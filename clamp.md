---
layout: default
title: "CLAMP: Scoring Molecules with Natural Language"
---

<style>
main table { display: block; max-width: 100%; overflow-x: auto; border-collapse: collapse; font-size: 16px; }
main th, main td { padding: 8px 12px; border: 1px solid #e5e7eb; text-align: left; }
main th { background: #f6f8fa; }
</style>

[Download the notebook]({{ '/assets/clamp/clamp.ipynb' | relative_url }}) · [View it on GitHub](https://github.com/SpyrosAnagnosto/ml-blog/blob/main/assets/clamp/clamp.ipynb)

# CLAMP: Scoring Molecules with Natural Language

**CLAMP connects molecular structures with descriptions of biological tests.** Given a set of molecules and a description of a test, it produces a score for each molecule–description pair. Those scores can help prioritize candidates for further investigation.

For a computer science reader, this is a matching problem with two input types: a molecular structure and a text description. A biological test, also called a **bioassay**, measures something a molecule might do, such as reduce the activity of a protein or inhibit bacterial growth. The description tells the model what was tested; the model predicts a match without performing the laboratory experiment.

Short for **Contrastive Language-Assay Molecule Pre-Training**, CLAMP was trained on molecule–bioassay pairs. Its pretrained model supports three core operations: scoring pairs, extracting molecule embeddings, and extracting description embeddings. This notebook demonstrates all three, starting with the four possible scoring shapes. [Official repository](https://github.com/ml-jku/clamp), [paper](https://arxiv.org/abs/2303.03363)

## Loading the pretrained model

The examples use a Python 3.10 environment with CLAMP installed at commit `61575cb76f4079ccdee13ac8513906af23baf047` and CPU PyTorch. To reproduce them, install the dependencies using the [repository's setup instructions](https://github.com/ml-jku/clamp/blob/61575cb76f4079ccdee13ac8513906af23baf047/README.md). The authors' original environment specifies Python 3.8; Python 3.10 is the environment used for this walkthrough.

The code below assumes the pretrained `checkpoint.pt` and `hp.json` files are already in `data/models/clamp_clip`, and the CLIP text encoder is cached in `data/cache/clip`. Run the notebook from the directory containing `data`. These are local file paths, so readers using a different layout will need to adjust them. The checkpoint download URLs are defined in the [pretrained model implementation](https://github.com/ml-jku/clamp/blob/61575cb76f4079ccdee13ac8513906af23baf047/clamp/models/pretrained.py).

### Reproducing this notebook

The [downloadable notebook]({{ '/assets/clamp/clamp.ipynb' | relative_url }}) includes the saved outputs. The companion [setup script]({{ '/assets/clamp/setup/create-clamp-environment.sh' | relative_url }}), [build constraint]({{ '/assets/clamp/setup/clamp-build-constraints.txt' | relative_url }}), and [installed package snapshot]({{ '/assets/clamp/setup/clamp-installed.txt' | relative_url }}) document the environment used here. These files are also available in [the blog repository](https://github.com/SpyrosAnagnosto/ml-blog/tree/main/assets/clamp). Download the `assets/clamp` folder, install `uv` and Git, and run `bash setup/create-clamp-environment.sh` from that folder.

Create `data/models/clamp_clip` there and download the official [checkpoint.pt](https://cloud.ml.jku.at/s/7nxgpAQrTr69Rp2/download/checkpoint.pt) and [hp.json](https://cloud.ml.jku.at/s/dRX9TWPrF7WqnHd/download/hp.json) into it. The checkpoint is about 667 MB. Select `.venv-clamp/bin/python` as the notebook interpreter. The loading cell downloads the CLIP encoder automatically if it is missing from `data/cache/clip`; that download is about 354 MB.

### Importing the libraries

`clamp` provides the model, `torch` runs it, and OpenAI `clip` supplies its text encoder. `Path` locates the downloaded files.

{% raw %}
```python
from pathlib import Path
import torch
import clamp
import clip
```
{% endraw %}

### Restoring the learned weights

The **weights** are the numerical parameters learned during training. Loading the checkpoint restores those parameters so the model can make predictions.

The code also loads the text encoder from its local cache. `device="cpu"` runs the model on the computer's processor, and `model.eval()` selects evaluation behavior, including disabling dropout.

{% raw %}
```python
device = "cpu"

model = clamp.CLAMP(
    path_dir=str(Path("data/models/clamp_clip").resolve()),
    device=device,
)
model = model.to(device)

model.text_encoder, _ = clip.load(
    "ViT-B/32",
    device=device,
    download_root=str(Path("data/cache/clip").resolve()),
)
model.eval()

print("CLAMP is loaded and ready.")
```
{% endraw %}

**Output**

{% raw %}
```text
CLAMP is loaded and ready.
```
{% endraw %}

The pretrained model is now available as `model`. Loading restores the network; the following sections supply its inputs and inspect its outputs.

## Four ways to arrange the scoring inputs

A molecule is supplied as a **SMILES string**, a text representation of its chemical structure. An assay description is an ordinary sentence describing a biological test. CLAMP accepts a list of each and scores every combination.

Each example dataset is a Python dictionary containing:

- `molecule_names`: readable labels for the molecules.
- `molecules`: their SMILES strings, in the same order as the names.
- `assay_descriptions`: the test descriptions.

Only the structures and descriptions are passed to CLAMP. Names help identify the results. The examples draw from a shared catalogue of ten molecules and six test descriptions. Reusing the same inputs makes the different matrix shapes easy to follow. These are illustrative inputs with no measured activity labels, so they demonstrate the interface rather than evaluate prediction accuracy.

The first number in each case counts molecules; the second counts descriptions.

### A shared catalogue of molecules and test descriptions

The molecule catalogue includes familiar small compounds and medicines. The test catalogue contains six illustrative descriptions, each with a short label for the output tables. The enzyme targets named below are proteins: biological machines whose activity can be measured in a laboratory.

These choices are demonstration inputs, not a curated screening benchmark. The descriptions do not assert that any of the listed molecules produces the effect. The structures are used as written, without adding unspecified stereochemistry or enumerating alternative forms.

{% raw %}
```python
molecule_library = {
    "Aspirin": "CC(=O)OC1=CC=CC=C1C(=O)O",
    "Caffeine": "Cn1c(=O)c2c(ncn2C)n(C)c1=O",
    "Ethanol": "CCO",
    "Salicylic acid": "O=C(O)c1ccccc1O",
    "Ibuprofen": "CC(C)Cc1ccc(C(C)C(=O)O)cc1",
    "Paracetamol": "CC(=O)Nc1ccc(O)cc1",
    "Nicotinamide": "NC(=O)c1cccnc1",
    "Benzoic acid": "O=C(O)c1ccccc1",
    "Vanillin": "COc1cc(C=O)ccc1O",
    "Dopamine": "NCCc1ccc(O)c(O)c1"
}

assay_library = {
    "HIV replication": "Measure whether a molecule inhibits HIV replication in infected cells.",
    "COX-2 activity": "Measure whether a molecule inhibits the activity of the human cyclooxygenase-2 (COX-2) enzyme.",
    "E. coli growth": "Measure whether a molecule inhibits the growth of the bacterium Escherichia coli.",
    "DPP-4 activity": "Measure whether a molecule inhibits the activity of the human dipeptidyl peptidase-4 (DPP-4) enzyme.",
    "AChE activity": "Measure whether a molecule inhibits the activity of the human acetylcholinesterase enzyme.",
    "Liver cell viability": "Measure whether a molecule reduces the viability of cultured human liver cells."
}

print("Molecules:", ", ".join(molecule_library))
print("Test descriptions:", ", ".join(assay_library))
```
{% endraw %}

**Output**

{% raw %}
```text
Molecules: Aspirin, Caffeine, Ethanol, Salicylic acid, Ibuprofen, Paracetamol, Nicotinamide, Benzoic acid, Vanillin, Dopamine
Test descriptions: HIV replication, COX-2 activity, E. coli growth, DPP-4 activity, AChE activity, Liver cell viability
```
{% endraw %}

### One molecule and one description

The smallest input contains one candidate and one test description. The output has shape `(1, 1)`: a single pair score.

{% raw %}
```python
dataset_1_1 = {
    "molecule_names": ["Aspirin"],
    "molecules": [molecule_library["Aspirin"]],
    "assay_descriptions": [assay_library["HIV replication"]],
}
```
{% endraw %}

### One molecule and several descriptions

Here, aspirin is paired with all six descriptions in the catalogue, covering virus replication, protein activity, bacterial growth, and cell viability.

The output has shape `(1, 6)`, with one column for each description.

{% raw %}
```python
dataset_1_many = {
    "molecule_names": ["Aspirin"],
    "molecules": [molecule_library["Aspirin"]],
    "assay_descriptions": list(assay_library.values()),
}
```
{% endraw %}

### Several molecules and one description

All ten molecules are paired with the same HIV test description. The output has shape `(10, 1)`. This arrangement supports ranking candidates for a particular test.

{% raw %}
```python
dataset_many_1 = {
    "molecule_names": list(molecule_library),
    "molecules": list(molecule_library.values()),
    "assay_descriptions": [assay_library["HIV replication"]],
}
```
{% endraw %}

### Several molecules and several descriptions

Ten molecules and six descriptions produce all 60 combinations, with output shape `(10, 6)`. Each row corresponds to a molecule and each column to a description.

{% raw %}
```python
dataset_many_many = {
    "molecule_names": list(molecule_library),
    "molecules": list(molecule_library.values()),
    "assay_descriptions": list(assay_library.values()),
}
```
{% endraw %}

### Inspecting the input sizes

The expected output shape follows directly from the lengths of the two input lists. The following cell checks those dimensions before inference.

{% raw %}
```python
datasets = {
    "1–1": dataset_1_1,
    "1–many": dataset_1_many,
    "many–1": dataset_many_1,
    "many–many": dataset_many_many,
}

for case, dataset in datasets.items():
    n_molecules = len(dataset["molecules"])
    n_descriptions = len(dataset["assay_descriptions"])
    print(f"{case:10} {n_molecules} molecules × {n_descriptions} descriptions"
          f" → expected shape ({n_molecules}, {n_descriptions})")
```
{% endraw %}

**Output**

{% raw %}
```text
1–1        1 molecules × 1 descriptions → expected shape (1, 1)
1–many     1 molecules × 6 descriptions → expected shape (1, 6)
many–1     10 molecules × 1 descriptions → expected shape (10, 1)
many–many  10 molecules × 6 descriptions → expected shape (10, 6)
```
{% endraw %}

## Computing molecule–description scores

`model.forward_dense(molecules, assay_descriptions)` returns a matrix containing **one raw score for every molecule–description combination**. `torch.no_grad()` disables gradient tracking while making predictions; no weights are updated.

The tables use shorter labels for the descriptions, preserving their original order:

1. **HIV replication:** inhibiting HIV replication in infected cells.
2. **COX-2 activity:** inhibiting the human COX-2 enzyme.
3. **E. coli growth:** inhibiting bacterial growth.
4. **DPP-4 activity:** inhibiting the human DPP-4 enzyme.
5. **AChE activity:** inhibiting human acetylcholinesterase.
6. **Liver cell viability:** reducing the viability of cultured human liver cells.

The last description concerns a potentially harmful effect. A higher score means a stronger match to the described effect; it does not always mean a more desirable candidate.

Higher scores indicate a stronger match according to the model. The values are not calibrated probabilities or yes/no activity decisions. In particular, a negative score does not automatically mean a molecule is inactive. We keep the raw scores rather than applying softmax.

{% raw %}
```python
import pandas as pd

model.eval()
description_labels = list(assay_library)
```
{% endraw %}

### A single pair: one score

The `(1, 1)` result contains the score for aspirin and the HIV description. There is nothing to rank with only one pair, and the score alone does not establish whether aspirin is active in that test.

{% raw %}
```python
with torch.no_grad():
    scores_1_1 = model.forward_dense(
        dataset_1_1["molecules"],
        dataset_1_1["assay_descriptions"],
    )

assert tuple(scores_1_1.shape) == (len(dataset_1_1["molecules"]), len(dataset_1_1["assay_descriptions"]))
assert torch.isfinite(scores_1_1).all().item()

table_1_1 = pd.DataFrame(
    scores_1_1.cpu().numpy(),
    index=dataset_1_1["molecule_names"],
    columns=description_labels[:len(dataset_1_1["assay_descriptions"])],
)
table_1_1.index.name = "Molecule"
print("Output shape:", tuple(scores_1_1.shape))
print(table_1_1.to_string(float_format=lambda value: f"{value:.6f}"))
```
{% endraw %}

**Output**

{% raw %}
```text
Output shape: (1, 1)
          HIV replication
Molecule                 
Aspirin         -0.366618
```
{% endraw %}

### One molecule across six descriptions

The `(1, 6)` result keeps aspirin fixed and changes the description. Each column represents a separate molecule–description match; the values are not probabilities of passing the six tests.

{% raw %}
```python
with torch.no_grad():
    scores_1_many = model.forward_dense(
        dataset_1_many["molecules"],
        dataset_1_many["assay_descriptions"],
    )

assert tuple(scores_1_many.shape) == (len(dataset_1_many["molecules"]), len(dataset_1_many["assay_descriptions"]))
assert torch.isfinite(scores_1_many).all().item()

table_1_many = pd.DataFrame(
    scores_1_many.cpu().numpy(),
    index=dataset_1_many["molecule_names"],
    columns=description_labels[:len(dataset_1_many["assay_descriptions"])],
)
table_1_many.index.name = "Molecule"
print("Output shape:", tuple(scores_1_many.shape))
print(table_1_many.to_string(float_format=lambda value: f"{value:.6f}"))
```
{% endraw %}

**Output**

{% raw %}
```text
Output shape: (1, 6)
          HIV replication  COX-2 activity  E. coli growth  DPP-4 activity  AChE activity  Liver cell viability
Molecule                                                                                                      
Aspirin         -0.366619        0.088178       -0.059822        0.185820       0.094233              0.016379
```
{% endraw %}

### Ten molecules for one description

The `(10, 1)` result keeps the HIV description fixed and changes the molecule. Reading down the column shows how the model orders these candidates for that description.

{% raw %}
```python
with torch.no_grad():
    scores_many_1 = model.forward_dense(
        dataset_many_1["molecules"],
        dataset_many_1["assay_descriptions"],
    )

assert tuple(scores_many_1.shape) == (len(dataset_many_1["molecules"]), len(dataset_many_1["assay_descriptions"]))
assert torch.isfinite(scores_many_1).all().item()

table_many_1 = pd.DataFrame(
    scores_many_1.cpu().numpy(),
    index=dataset_many_1["molecule_names"],
    columns=description_labels[:len(dataset_many_1["assay_descriptions"])],
)
table_many_1.index.name = "Molecule"
print("Output shape:", tuple(scores_many_1.shape))
print(table_many_1.to_string(float_format=lambda value: f"{value:.6f}"))
```
{% endraw %}

**Output**

{% raw %}
```text
Output shape: (10, 1)
                HIV replication
Molecule                       
Aspirin               -0.366618
Caffeine              -0.403388
Ethanol               -0.338737
Salicylic acid        -0.424136
Ibuprofen             -0.362957
Paracetamol           -0.327127
Nicotinamide          -0.324844
Benzoic acid          -0.398288
Vanillin              -0.374405
Dopamine              -0.179926
```
{% endraw %}

### All 60 combinations

The `(10, 6)` result combines both dimensions. A cell at row `i`, column `j` is the score for molecule `i` and description `j`.

{% raw %}
```python
with torch.no_grad():
    scores_many_many = model.forward_dense(
        dataset_many_many["molecules"],
        dataset_many_many["assay_descriptions"],
    )

assert tuple(scores_many_many.shape) == (len(dataset_many_many["molecules"]), len(dataset_many_many["assay_descriptions"]))
assert torch.isfinite(scores_many_many).all().item()

table_many_many = pd.DataFrame(
    scores_many_many.cpu().numpy(),
    index=dataset_many_many["molecule_names"],
    columns=description_labels[:len(dataset_many_many["assay_descriptions"])],
)
table_many_many.index.name = "Molecule"
print("Output shape:", tuple(scores_many_many.shape))
print(table_many_many.to_string(float_format=lambda value: f"{value:.6f}"))
```
{% endraw %}

**Output**

{% raw %}
```text
Output shape: (10, 6)
                HIV replication  COX-2 activity  E. coli growth  DPP-4 activity  AChE activity  Liver cell viability
Molecule                                                                                                            
Aspirin               -0.366618        0.088178       -0.059822        0.185820       0.094233              0.016379
Caffeine              -0.403388        0.116526        0.026496        0.183566       0.111571              0.013421
Ethanol               -0.338738        0.027895       -0.029233        0.100803       0.030702             -0.026035
Salicylic acid        -0.424136        0.098062       -0.020005        0.160508       0.110034             -0.057783
Ibuprofen             -0.362957        0.161838        0.044695        0.237827       0.195697             -0.001829
Paracetamol           -0.327127        0.077334       -0.074225        0.148642       0.066108             -0.007175
Nicotinamide          -0.324845        0.125607        0.068875        0.208655       0.129340              0.126527
Benzoic acid          -0.398288        0.018762       -0.050969        0.094111       0.037358             -0.034154
Vanillin              -0.374406        0.091187       -0.042750        0.153406       0.103246             -0.035198
Dopamine              -0.179926        0.186974        0.001435        0.206594       0.166753              0.014057
```
{% endraw %}

### Reading the results

The aspirin–HIV pair appears in all four datasets. Its raw score remains the same apart from small numerical differences caused by batching. Adding other candidates does not normalize the pair scores.

Each column of the many–many table compares molecules against one description. Such a ranking can suggest an order for further investigation, but it does not establish experimental activity. Assessing predictive performance would require measured labels and a suitable evaluation dataset.

## Extracting embeddings

An **embedding** is a vector of numbers representing an input. CLAMP can return a molecule vector or a description vector independently, without requiring a pair.

This pretrained model produces **768 numbers per molecule** and **768 numbers per description**. The coordinates are learned features; individual dimensions do not have predefined meanings such as "toxicity" or "antiviral activity".

### Molecules to vectors

`model.encode_smiles(...)` takes SMILES strings alone. Ten molecules produce an embedding matrix with shape `(10, 768)`, with one row per molecule.

The table displays the first eight coordinates for readability. The full vectors remain in `molecule_embeddings`.

{% raw %}
```python
embedding_molecules = dataset_many_many["molecules"]

model.eval()
with torch.no_grad():
    molecule_embeddings = model.encode_smiles(embedding_molecules)

assert tuple(molecule_embeddings.shape) == (len(embedding_molecules), model.embedding_size)
assert torch.isfinite(molecule_embeddings).all().item()

molecule_preview = pd.DataFrame(
    molecule_embeddings[:, :8].cpu().numpy(),
    index=dataset_many_many["molecule_names"],
    columns=[f"dim_{i}" for i in range(8)],
)
molecule_preview.index.name = "Molecule"
print("Full molecule embedding shape:", tuple(molecule_embeddings.shape))
print("First 8 of 768 coordinates:")
print(molecule_preview.to_string(float_format=lambda value: f"{value:.4f}"))
```
{% endraw %}

**Output**

{% raw %}
```text
Full molecule embedding shape: (10, 768)
First 8 of 768 coordinates:
                dim_0   dim_1   dim_2   dim_3   dim_4   dim_5   dim_6   dim_7
Molecule                                                                     
Aspirin        3.1221 -0.0719  0.0823  0.1104 -0.0336 -0.0057  0.0001 -0.0119
Caffeine       2.9157  0.0084  0.0103  0.0116 -0.0093  0.0599  0.1428  0.1159
Ethanol        3.8183  0.0816  0.1665 -0.0483 -0.2073 -0.0029 -0.0485 -0.0576
Salicylic acid 2.6999 -0.0511  0.1661  0.0542 -0.0545 -0.0150  0.0149  0.0091
Ibuprofen      2.9926  0.0305 -0.0578  0.0158 -0.0519  0.0940  0.0989 -0.0047
Paracetamol    2.5871  0.0154  0.0126 -0.0389 -0.0598  0.0356 -0.0498 -0.0735
Nicotinamide   3.0963  0.0192  0.0575  0.0126 -0.0981  0.0810  0.0539  0.1183
Benzoic acid   3.2347  0.0147  0.1680  0.0100 -0.0973 -0.0263  0.0998  0.0162
Vanillin       2.6246  0.0952  0.0049 -0.0326 -0.2560  0.0014  0.0474 -0.1953
Dopamine       1.9448 -0.0543  0.0918 -0.0406 -0.0445  0.0008  0.0024 -0.1179
```
{% endraw %}

### Descriptions to vectors

`model.encode_text(...)` takes descriptions alone. The six descriptions produce another matrix with shape `(6, 768)`, with rows following the input order.

These are CLAMP's final description embeddings, after the CLIP text features pass through its learned projection. The full vectors remain in `text_embeddings`; the table shows the first eight coordinates.

{% raw %}
```python
embedding_descriptions = dataset_many_many["assay_descriptions"]

with torch.no_grad():
    text_embeddings = model.encode_text(embedding_descriptions)

assert tuple(text_embeddings.shape) == (len(embedding_descriptions), model.embedding_size)
assert torch.isfinite(text_embeddings).all().item()

text_preview = pd.DataFrame(
    text_embeddings[:, :8].cpu().numpy(),
    index=description_labels,
    columns=[f"dim_{i}" for i in range(8)],
)
text_preview.index.name = "Description"
print("Full description embedding shape:", tuple(text_embeddings.shape))
print("First 8 of 768 coordinates:")
print(text_preview.to_string(float_format=lambda value: f"{value:.4f}"))
```
{% endraw %}

**Output**

{% raw %}
```text
Full description embedding shape: (6, 768)
First 8 of 768 coordinates:
                       dim_0   dim_1  dim_2   dim_3   dim_4   dim_5  dim_6   dim_7
Description                                                                       
HIV replication      -1.5282 -0.0079 0.0552  0.0898 -0.0671 -0.1386 0.0045 -0.2598
COX-2 activity        0.3715 -0.0396 0.1379 -0.0521 -0.0214 -0.1702 0.1217 -0.2298
E. coli growth       -0.0772 -0.0137 0.0148 -0.0145  0.0323 -0.0818 0.0575 -0.2538
DPP-4 activity        1.0263 -0.0291 0.1287 -0.0639  0.0033 -0.1987 0.1190 -0.2976
AChE activity         0.3586  0.0192 0.0949 -0.0603  0.0126 -0.1373 0.0711 -0.2376
Liver cell viability -0.3490 -0.0182 0.0003  0.0384 -0.0407 -0.1107 0.0256 -0.2560
```
{% endraw %}

## Connecting embeddings and scores

The examples expose three operations with different outputs:

| Operation | Inputs | Output in this example |
| --- | --- | --- |
| `forward_dense` | 10 molecules + 6 descriptions | `(10, 6)` pair scores |
| `encode_smiles` | 10 molecules | `(10, 768)` molecule features |
| `encode_text` | 6 descriptions | `(6, 768)` description features |

Both encoders map their inputs into a shared vector space. In this pretrained configuration, `forward_dense` normalizes the vectors to unit length and computes their pairwise dot products. This connects the two kinds of embeddings to the scores shown earlier. The encoder methods return the vectors before that normalization. [Encoder implementation](https://github.com/ml-jku/clamp/blob/61575cb76f4079ccdee13ac8513906af23baf047/clamp/models/pretrained.py), [pair scoring](https://github.com/ml-jku/clamp/blob/61575cb76f4079ccdee13ac8513906af23baf047/clamp/models/models.py)

Molecule embeddings can also serve as features for a separate classifier trained on labeled data. That uses CLAMP as a fixed feature extractor. **Fine-tuning** is a different workflow: it updates CLAMP's own weights using additional training data.

For a collection such as COCONUT, these operations offer two starting points: score selected structures against a biological test description, or extract structure embeddings for another machine-learning task. The examples here use a small hand-written set; they have not screened or evaluated the COCONUT collection.

