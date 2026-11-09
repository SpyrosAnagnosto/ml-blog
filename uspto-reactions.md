---
layout: default
title: "From Chemical Patents to Reaction Data: Pistachio and the Open USPTO Dataset"
description: "A practical introduction to patent reaction data, with open USPTO downloads, Python examples, outputs, coverage charts, uses, and limitations."
date: 2026-11-09
---

<style>
main { max-width: 960px; }
main h1 { font-size: clamp(30px, 5vw, 40px); }
main table { display: block; max-width: 100%; overflow-x: auto; border-collapse: collapse; font: 15px/1.6 Arial, sans-serif; margin: 28px 0; }
main th, main td { padding: 10px 12px; border: 1px solid #dce7e8; text-align: left; vertical-align: top; }
main th { background: #edf5f5; }
main td code { overflow-wrap: anywhere; }
main img { display: block; margin: 28px auto 12px; }
main p > em:only-child { display: block; font-size: .85em; color: #536770; }
</style>

# From Chemical Patents to Reaction Data: Pistachio and the Open USPTO Dataset

A molecule's structure describes how its atoms are connected. A chemical reaction describes a transformation: starting substances, called **reactants**, become **products**. A reaction database organizes information about those transformations so that researchers can search and compare them.

A molecular database such as COCONUT helps us explore individual compounds. A reaction dataset connects starting substances to reported products. In this article, we introduce Pistachio through NextMove Software’s 2021 announcement, then use Daniel Lowe’s separate open USPTO release to examine real reaction records in Python.

## What does a reaction record describe?

Consider a simplified example:

**Acetic acid + ethanol → ethyl acetate + water**

Acetic acid and ethanol are the reactants. Ethyl acetate, an ester, is the desired product in this example; water is also formed. The arrow describes the chemical transformation. This is an introductory illustration, not a record taken from Pistachio.

A useful account of an experiment needs more than an arrow. It can describe the substances used, their quantities, the temperature, the reaction time, and how much product was obtained. These details help a reader interpret what was reported and compare it with another procedure. A database record may capture only part of that information, depending on the source and extraction process.

## From a patent document to a reaction record

Chemical patents can include experimental examples explaining how compounds were prepared. These descriptions connect starting materials to products through a procedure, providing material from which reaction records can be extracted.

To see what extraction involves, consider an invented description:

> Compound A was dissolved in ethanol. Reagent B was added, and the mixture was stirred at 60 °C for two hours. After purification, compound C was isolated in 75% yield.

This short passage contains several kinds of information:

| Information | Example in the passage | Meaning |
| --- | --- | --- |
| Starting materials | Compound A and reagent B | Substances used in the procedure; their structures would be needed to establish their roles in the transformation |
| Solvent | Ethanol | The liquid used to dissolve compound A |
| Temperature and time | 60 °C; two hours | Reported reaction conditions |
| Product | Compound C | The substance obtained after purification |
| Yield | 75% | The reported amount obtained as a percentage of the theoretical amount, relative to a specified basis |

The compound labels alone do not identify molecular structures. A reader would need to find their definitions elsewhere in the document. Likewise, ethanol's role here is a solvent: the presence of a chemical name does not automatically make that substance a reactant.

### Reading the chemistry in context

NextMove's article describes several tasks involved in interpreting patent text: recovering headings, linking references to compounds, allowing a reaction description to span paragraphs, and generating structures from chemical names and other representations. References such as “title compound” depend on finding the relevant heading. Labels such as “Compound 1” and “Intermediate 1” also need to remain distinguishable. [Extraction and reference-handling improvements](https://nextmovesoftware.com/blog/2021/03/24/13118970-reactions-and-counting/)

Some documents add another difficulty: their text comes from **optical character recognition (OCR)**, which converts page images into machine-readable text. The article reports problems with damaged chemical names and misplaced paragraph breaks in WIPO documents. Such errors can interfere with identifying both the molecules and the boundaries of a reaction description. [OCR examples in the 2021 announcement](https://nextmovesoftware.com/blog/2021/03/24/13118970-reactions-and-counting/)

The path can therefore be understood as:

**Patent document → readable text and chemical information → resolved structures and references → reaction record**

This is a conceptual outline, rather than a specification of Pistachio's internal software. Its purpose is to show why extraction requires understanding relationships within a document. The resulting record is an interpretation of reported information, and its quality depends on both the source and the extraction.

## Is Pistachio a dataset or a tool?

**Pistachio is both a chemical reaction dataset and an interface for searching and analysing reaction data.** NextMove Software describes these two parts together on its official product page. [Official Pistachio overview](https://www.nextmovesoftware.com/pistachio.html)

The distinction is useful when approaching the resource for the first time:

| Part | What it provides |
| --- | --- |
| Reaction dataset | Structured records describing reactions extracted from source documents |
| Search interface | Ways to find records using chemical structures, reaction types, yields, and document information |
| The 2021 blog announcement | An explanation of a particular release and improvements to its data extraction |

The article we are examining, *13,118,970 Reactions and Counting*, was published on March 24, 2021. Its counts describe the release announced then. It is an account of the resource at that time, rather than a dataset download or a statement of its present size. [2021 announcement](https://nextmovesoftware.com/blog/2021/03/24/13118970-reactions-and-counting/)

### What does the headline count mean?

NextMove’s 2021 announcement reported **13,118,970 document-linked reaction records** and **4,212,894 unique reactions by RInChI**, a standardized reaction identifier. A description can appear in an application, its granted patent, and filings in several jurisdictions. Multiple records can therefore describe the same transformation. These are historical Pistachio figures; they are separate from the counts we measure in the open files below. [2021 counts](https://nextmovesoftware.com/blog/2021/03/24/13118970-reactions-and-counting/), [RInChI paper](https://doi.org/10.1186/s13321-018-0277-8)

### Can we download the data?

The open USPTO reaction releases and the expanded Pistachio collection must be distinguished. Daniel Lowe's 2017 Figshare release contains reactions extracted from US patents published between 1976 and September 2016. It is downloadable under **CC0**, in CML and reaction SMILES formats. Its documentation describes additional source and yield fields and warns of duplicate records and atom-mapping errors. [Open USPTO dataset and documentation](https://doi.org/10.6084/m9.figshare.5104873)

The 2021 Pistachio article describes updates supplied to customers and broader patent coverage. The open Figshare release therefore does not provide the full collection discussed in that announcement. For Pistachio access and applicable terms, readers should contact NextMove using the contact details on its product page. [Pistachio announcement](https://nextmovesoftware.com/blog/2021/03/24/13118970-reactions-and-counting/), [NextMove contact information](https://www.nextmovesoftware.com/pistachio.html)

For a hands-on exploration with publicly downloadable files, the Figshare release gives us a concrete starting point. Any analysis of it must identify that release and use its own counts, rather than attribute the 2021 Pistachio totals to it.

## What does the open dataset look like?

For our exploration, the dataset consists of **two large tables stored in separate `.rsmi` files**: one for reactions extracted from granted patents and one for patent applications. Each file has a header and six columns. Tabs separate the values, much as commas separate values in a CSV file.

**One row is one extracted reaction record.** Its first cell contains the reaction as a text string. The remaining cells identify its patent source, year, and available yields. One patent can contribute many rows, and repeated reactions can occur across rows and files.

Here is a simplified view of two actual application records; the long reaction strings are replaced by descriptions for readability:

| ReactionSmiles | PatentNumber | ParagraphNum | Year | TextMinedYield | CalculatedYield |
| --- | --- | --- | --- | --- | --- |
| Reaction structure as text | US20010000035A1 | 0007 | 2001 | blank | blank |
| Another reaction structure as text | US20010000038A1 | 0256 | 2001 | 86% | 86.9% |

The two CML archives in the download provide an alternative XML representation. They are not two additional sets of independent reactions. We use the tabular `.rsmi` files for the examples that follow.

### How can a reaction fit inside one cell?

A **SMILES string** describes a molecular structure using text. For example, ethanol is `CCO`: two connected carbon atoms followed by an oxygen, with hydrogens implied. Reaction SMILES joins molecular descriptions into three fields:

```text
reactants>agents>products
```

Reactants are the starting substances; products are the substances formed. The middle field holds agents, which can include catalysts or solvents. A simplified conversion of ethanol to ethanal can be written as:

```text
CCO>>CC=O
```

The left side describes ethanol. The right side describes ethanal, where `=` indicates a carbon–oxygen double bond. The empty middle field means no agents are supplied in this representation. This teaching example omits other reaction participants and experimental conditions. [SMILES and reaction notation](https://daylight.com/dayhtml/doc/theory/theory.smiles.html)

The downloaded strings also contain **atom-map labels**, such as `:6`. Matching labels connect corresponding atoms on the two sides, helping us inspect changes in bonds. These labels identify atoms within a represented reaction; they do not identify patents or record numbers. [Atom-mapping introduction](https://www.daylight.com/meetings/summerschool00/course/basics/smirks.html)

With the file layout and reaction notation established, we can download the release and inspect those fields directly.

## Downloading the open USPTO release

For the practical examples, we downloaded Daniel Lowe's **2017 open USPTO release**, under CC0, on **9 November 2026**. The complete release contains five files totalling **1,494,665,893 bytes (about 1.49 GB)**. This is the open release described above; the 13-million-record Pistachio count does not apply to these files. [Versioned dataset record](https://doi.org/10.6084/m9.figshare.5104873.v1)

| File | Contents |
| --- | --- |
| `1976_Sep2016_USPTOgrants_smiles.7z` | Reaction SMILES from granted patents |
| `2001_Sep2016_USPTOapplications_smiles.7z` | Reaction SMILES from patent applications |
| `1976_Sep2016_USPTOgrants_cml.7z` | Granted-patent data in Chemical Markup Language (CML), an XML format |
| `2001_Sep2016_USPTOapplications_cml.7z` | Patent-application data in CML |
| `cml_xsd.zip` | Schema describing the CML format |

The SMILES and CML archives provide alternative representations of the data. Their contents should not be added together as separate reaction collections. Applications and grants can also contain overlapping reaction descriptions. We will begin the Python exploration with the reaction SMILES files.

### Download and verify the files with Python

The following script uses Python's standard library. Run it from the project folder. It reads the version-1 Figshare metadata, saves the original filenames under `data/raw/uspto_lowe_2017`, and checks each downloaded file against its expected size and MD5 checksum. Files are copied in chunks rather than held entirely in memory.

```python
import hashlib
import json
import shutil
from pathlib import Path
from urllib.request import urlopen

output = Path("data/raw/uspto_lowe_2017")
output.mkdir(parents=True, exist_ok=True)
metadata_url = "https://api.figshare.com/v2/articles/5104873/versions/1"

with urlopen(metadata_url, timeout=60) as response:
    metadata = json.load(response)

(output / "figshare_metadata.json").write_text(
    json.dumps(metadata, indent=2) + "\n", encoding="utf-8"
)

verification = []
for file in metadata["files"]:
    destination = output / file["name"]
    partial = destination.with_name(destination.name + ".part")

    print("Downloading", file["name"], flush=True)
    with urlopen(file["download_url"], timeout=120) as response:
        with partial.open("wb") as stream:
            shutil.copyfileobj(response, stream, length=1024 * 1024)

    digest = hashlib.md5()
    with partial.open("rb") as stream:
        for chunk in iter(lambda: stream.read(8 * 1024 * 1024), b""):
            digest.update(chunk)

    actual_md5 = digest.hexdigest()
    if (
        partial.stat().st_size != file["size"]
        or actual_md5 != file["computed_md5"]
    ):
        raise ValueError(f"Download verification failed: {file['name']}")

    partial.replace(destination)
    verification.append({
        "file": file["name"],
        "bytes": destination.stat().st_size,
        "md5": actual_md5,
        "verified": True,
    })
    print("Verified", destination.name)

(output / "verification.json").write_text(
    json.dumps(verification, indent=2) + "\n", encoding="utf-8"
)
```

For our download, all five files matched Figshare's published sizes and checksums. At this stage the files are compressed archives; the next step extracts the two tables. The saved metadata identifies the source files, while `verification.json` records the local checks. A matching checksum confirms the downloaded bytes match the distributed file; it does not validate the chemistry in its records.

## Loading the reaction files into Python

The two SMILES archives extract into `.rsmi` files. Although the extension refers to reaction SMILES, each file is a **tab-separated table with a header**, containing a reaction string and five metadata fields. We extracted both archives successfully; together, the extracted files occupy about **1.70 GB**.

With the 7-Zip command-line program installed, run these commands from the project folder:

```bash
7z x -y -odata/raw/uspto_lowe_2017/extracted data/raw/uspto_lowe_2017/1976_Sep2016_USPTOgrants_smiles.7z
7z x -y -odata/raw/uspto_lowe_2017/extracted data/raw/uspto_lowe_2017/2001_Sep2016_USPTOapplications_smiles.7z
```

### Start with five records

With pandas installed (`python -m pip install pandas`), the following code reads just five patent-application records. A preview lets us understand the fields before attempting a larger analysis.

```python
from pathlib import Path
import pandas as pd

folder = Path("data/raw/uspto_lowe_2017/extracted")
path = folder / "2001_Sep2016_USPTOapplications_smiles.rsmi"

sample = pd.read_csv(
    path,
    sep="\t",
    nrows=5,
    dtype=str,
    keep_default_na=False,
)

print("Sample shape:", sample.shape)
# Display metadata first; inspect the long reaction string separately below.
print(sample.drop(columns="ReactionSmiles").to_string(index=False))
```

Output from the downloaded applications file:

```text
Sample shape: (5, 6)
   PatentNumber ParagraphNum Year TextMinedYield CalculatedYield
US20010000035A1         0007 2001
US20010000038A1         0256 2001            86%           86.9%
US20010000038A1         0259 2001            95%
US20010000038A1         0285 2001
US20010000038A1         0287 2001           100%          100.9%
```

The loaded sample has shape **`(5, 6)`**: five records and six columns. The printed table shows five columns because we temporarily omit the long `ReactionSmiles` column from the display; it remains in `sample`. This is the sample size, not the size of the complete dataset. Reading values as strings preserves paragraph labels such as `0007`; `keep_default_na=False` preserves empty fields as empty strings.

| Column | Information supplied |
| --- | --- |
| `ReactionSmiles` | The represented reaction, including atom-map labels |
| `PatentNumber` | Source patent identifier |
| `ParagraphNum` | Source paragraph number, where available |
| `Year` | Patent publication year |
| `TextMinedYield` | Yield extracted from the text, where available |
| `CalculatedYield` | A separately supplied calculated yield, where available |

These are the actual headers in the downloaded files. The release documentation identifies the source and yield fields. A blank yield is missing information, not a measured yield of zero. [Dataset documentation](https://doi.org/10.6084/m9.figshare.5104873.v1)

Reading across the preview reveals several useful features:

- Four rows share patent number `US20010000038A1`, with different paragraph references. A row is a reaction record, so one patent can contribute multiple rows.
- Every displayed record is from 2001. These are the first five rows, rather than a random sample; they do not establish the distribution of years in the full file.
- Some yield fields are blank. Paragraph `0259` has a text-mined yield of `95%` but no calculated yield; paragraph `0285` has neither. The two columns therefore have different coverage.
- Paragraph `0256` contains `86%` and `86.9%`, while paragraph `0287` contains `100%` and `100.9%`. The supplied values need interpretation before analysis: a calculated value above 100% is present in the data. This preview alone cannot establish its cause, and we should inspect the source and calculation method rather than silently treating it as a validated measurement or replacing it.

### Inspect one reaction

We can separate the reaction string into its three fields without interpreting every atom symbol:

```python
record = sample.iloc[0]
reactants, agents, products = record["ReactionSmiles"].split(">")

print("Patent:", record["PatentNumber"])
print("Paragraph:", record["ParagraphNum"])
print("Year:", record["Year"])
print("Reactants:", reactants)
print("Agents:", agents)
print("Products:", products)
```

Output:

```text
Patent: US20010000035A1
Paragraph: 0007
Year: 2001
Reactants: [C:1]([C:5]1[CH:10]=[CH:9][C:8]([OH:11])=[CH:7][CH:6]=1)([CH3:4])([CH3:3])[CH3:2]
Agents: [Ni]
Products: [C:1]([CH:5]1[CH2:6][CH2:7][CH:8]([OH:11])[CH2:9][CH2:10]1)([CH3:4])([CH3:2])[CH3:3]
```

For this file, the first record points to patent **US20010000035A1**, paragraph **0007**, published in **2001**. Its middle field is `[Ni]`, the chemical symbol for nickel in SMILES notation. This shows how one row links a represented transformation to its patent source. We can now use the atom-map labels introduced earlier to compare the structures.

The numbered labels let us compare corresponding atoms. For example, atom `:6` appears as `[CH:6]` on the reactant side and `[CH2:6]` on the product side: its represented hydrogen count increases from one to two. The reactant contains alternating single and double bonds in its six-membered carbon ring, whereas the product ring has only single bonds. This is consistent with hydrogenation of the ring. Nickel appears in the agents field, consistent with a catalytic role, although the record alone does not establish its detailed experimental function. No separate hydrogen-gas component appears in this string, illustrating why a represented reaction should not automatically be read as a complete balanced equation.

Splitting the string exposes the fields as stored. It does not verify chemical roles, mapping correctness, or whether the record includes every participant in the experiment.

### Process the full file in batches

When we are ready to analyse every row, pandas can read batches instead of building one large table in memory:

```python
record_count = 0
for batch in pd.read_csv(
    path,
    sep="\t",
    dtype=str,
    keep_default_na=False,
    chunksize=50_000,
):
    record_count += len(batch)
    # Add the desired analysis for this batch here.

print("Records in the applications file:", record_count)
```

Output after processing the complete applications file:

```text
Records in the applications file: 1939253
```

We read **1,939,253 reaction records** from the applications file, excluding its header. This is a measured count for this downloaded file, not the five-row preview and not the size of Pistachio. Counting rows establishes how much data is present; it does not establish how many distinct chemical transformations or independently performed experiments those rows represent.

The count excludes the grants file. Process batches as they arrive: collecting them all into a list would remove the memory benefit.

## What does the full open dataset contain?

The preview showed individual rows. To understand their context, we now scan **both complete reaction SMILES files**, counting records by publication year and checking whether each yield field contains a value. These calculations use the downloaded 2017 release without deduplicating or filtering its rows.

### Count records and available yield fields

The code below builds on the `folder` path defined earlier. A yield is counted as present when its field contains something other than whitespace. This checks availability, not whether the value is a valid percentage.

```python
summaries = {}
for label, filename in {
    "Grants": "1976_Sep2016_USPTOgrants_smiles.rsmi",
    "Applications": "2001_Sep2016_USPTOapplications_smiles.rsmi",
}.items():
    total = 0
    years = pd.Series(dtype="int64")
    present = {"TextMinedYield": 0, "CalculatedYield": 0}

    for batch in pd.read_csv(
        folder / filename, sep="\t", dtype=str,
        keep_default_na=False, chunksize=50_000,
    ):
        total += len(batch)
        years = years.add(batch["Year"].value_counts(), fill_value=0)
        for field in present:
            present[field] += int(batch[field].str.strip().ne("").sum())

    years = years.astype(int).sort_index()
    summaries[label] = {"records": total, "years": years, "present": present}
    print(label)
    print(f"  Records: {total:,}")
    print(f"  Publication years: {years.index.min()}–{years.index.max()}")
    for field, count in present.items():
        print(f"  {field}: {count:,} ({count / total:.1%})")
```

Output:

```text
Grants
  Records: 1,808,937
  Publication years: 1976–2016
  TextMinedYield: 696,621 (38.5%)
  CalculatedYield: 739,764 (40.9%)
Applications
  Records: 1,939,253
  Publication years: 2001–2016
  TextMinedYield: 859,604 (44.3%)
  CalculatedYield: 857,111 (44.2%)
```

| File | Reaction records | Publication years |
| --- | ---: | --- |
| Grants | 1,808,937 | 1976–2016 |
| Applications | 1,939,253 | 2001–2016 |
| Both files combined | 3,748,190 | Different coverage as shown above |

The combined total is a sum of rows. An application and its subsequent grant can repeat a reaction, and repetitions can occur within a file. **3,748,190 therefore does not count unique reactions.** The earlier starting year of the grants file also means the two files cover different periods.

### How are the records distributed over time?

![Reaction record counts by patent publication year]({{ '/assets/images/uspto/publication_years.png' | relative_url }})

*Counts measured from the two downloaded reaction SMILES tables. The release ends in September 2016, so its final year is incomplete. Lines connect annual counts; they do not represent continuous measurements.*

Both files contain substantially more records per year toward the later part of their coverage. The applications series begins in 2001 because that is the starting year of the supplied applications archive. Its absence before then is a coverage boundary, not evidence that no reactions were reported in patent applications.

The fall in 2016 should be read alongside the September cutoff: it compares a partial year with preceding full years. More generally, these are counts of extracted database records, not a direct measure of how many distinct reactions chemists discovered or performed in each year. The chart alone cannot separate changes in patent publication, document contents, and extraction coverage.

### How much yield information is available?

![Availability of the two yield fields in grants and applications]({{ '/assets/images/uspto/yield_coverage.png' | relative_url }})

*Each percentage uses all records in its own file as the denominator. The two yield fields are counted separately and may be populated on the same rows.*

Each yield column is nonblank in fewer than half the records. For example, the grants file provides a text-mined yield for **696,621 of 1,808,937 records (38.5%)**. A project requiring that field would retain only those rows before any additional validity checks.

The bars must not be added together: a record can have both yield fields. These calculations do not measure the share with at least one yield. Nor does a nonblank field establish correctness—the five-row preview already exposed a calculated value above 100%. Missing yields remain missing information and must not be converted to zero.

The dataset is therefore useful for exploring millions of represented transformations, but analyses requiring yield values work with a smaller, selected portion of its records. We would need further checks to understand whether that selection differs systematically from the rows without yields.

## What can someone use reaction data for?

A reaction dataset connects starting structures to reported products and their sources. Those connections support both finding existing examples and developing models that propose new ones. The open files provide data for these tasks; loading them into pandas does not itself provide a chemical search engine or a trained model.

### Find reported preparations

A researcher interested in a molecule can look for records containing it as a product, inspect the associated starting materials, and follow the patent and paragraph references back to the procedure. Related transformations can provide examples to investigate when planning a synthesis.

Searching by chemical structure requires a chemistry-aware comparison. Matching literal SMILES text alone can miss equivalent structures written differently. The open tables can be processed with appropriate chemistry software; Pistachio separately provides an interface supporting structure, reaction, yield, and document queries. [Pistachio search capabilities](https://www.nextmovesoftware.com/pistachio.html)

### Learn to predict products or suggest starting materials

Reaction records supply paired examples for machine learning. Two useful tasks read those pairs in opposite directions:

| Task | Information supplied to a model | What the model proposes |
| --- | --- | --- |
| Product prediction | Starting materials and available agents | A possible product structure |
| Single-step retrosynthesis | A target product structure | Possible starting materials for one preparation step |

For a computer science reader, these can be viewed as transformations between structured text sequences. Molecular Transformer research demonstrates learning such tasks using SMILES representations. Training requires a prepared dataset and evaluation procedure beyond the file loading shown here. [Reaction prediction and retrosynthesis research](https://doi.org/10.1039/C9CC05122H)

Retrosynthesis works backwards from a desired molecule. A single-step suggestion is only one part of a potential route: making the proposed starting materials may require further steps. A proposed route also requires assessment of conditions and experimental feasibility.

### Build a defined research dataset

Our overview is already a small example of dataset preparation: it establishes file sizes in records, year coverage, and yield availability. A researcher can use these fields to define a subset, retain source references, and document what was excluded. For a yield study, the next task would include validating percentage values and investigating missing information. For product prediction, it would include checking structures and separating training examples from evaluation examples.

The appropriate preparation depends on the question. The dataset does not supply experimental activity labels for the molecule–assay matching task explored in CLAMP; its central relationship is between starting structures and reaction products.

## What are the limitations?

The records preserve extracted reports, with the coverage and uncertainty that entails. Several limitations affect how their results should be interpreted.

### Repeated records can distort counts and evaluation

The release documentation warns that duplicate reactions are frequent, particularly when combining patent applications with grants. Our total of **3,748,190 rows** therefore cannot be interpreted as that many unique reactions. [Release documentation](https://doi.org/10.6084/m9.figshare.5104873.v1)

For machine learning, related or repeated examples appearing in both training and test data can make evaluation less demanding than intended. A preparation workflow should define what counts as a duplicate and consider keeping related patent records together when dividing the data. Even after removing exact duplicates, similarity between molecular structures can affect evaluation: a study of USPTO-based prediction identified scaffold bias and showed that a different split reduced model performance. [Study of reaction-model bias](https://www.nature.com/articles/s41467-021-21895-w)

### Extraction and atom mapping can be wrong

A successfully parsed string is not proof of a correct chemical interpretation. The dataset author explicitly warns that some atom maps are incorrect. That matters when using mappings to identify bond changes or derive transformation rules. The release also applies extraction filters, so its contents are already a selected portion of the mined material. [Author's mapping warnings and filtering criteria](https://doi.org/10.6084/m9.figshare.5104873.v1)

Our extraction discussion explains possible sources of ambiguity, such as compound references and damaged text. The improvements described for Pistachio in 2021 should not be assumed to have been applied to the separate open release published in 2017.

### Experimental information is incomplete

The six columns we loaded contain no dedicated temperature, reaction-time, or experimental-procedure field. Some agents may be represented in the reaction string, but a row is not a complete laboratory protocol. Reading its patent source may be necessary to recover the experimental context.

The yield overview makes missing information measurable: each yield column is populated in fewer than half of the records. Available values also need validation, as illustrated by `100.9%` in our preview. Filtering to nonblank yields selects a subset whose representativeness we have not established. Research on USPTO reagent prediction likewise discusses incomplete and noisy reaction information as a limitation for modelling. [Reaction-data quality study](https://pubs.rsc.org/en/content/articlehtml/2023/sc/d2sc06798f)

### Coverage is defined by patents and the release period

These files cover US patent documents through September 2016, with different starting years for grants and applications. They are not an inventory of all chemistry, all publications, or all laboratory attempts. In particular, we have not established coverage of unsuccessful experiments; an absent reaction is not evidence that it fails.

For prediction tasks, uneven coverage can leave some chemistry poorly represented. The USPTO bias study found that scarce examples of a reaction class were associated with poor predictions for that class. Overall performance should therefore be interpreted alongside performance on the kinds of reactions relevant to the intended use. [Coverage and model behaviour](https://www.nature.com/articles/s41467-021-21895-w)

These limitations guide the next decisions: retain source references, document selections, check structures and values, and choose an evaluation that matches the research question. A predicted product or proposed preparation remains a hypothesis requiring chemical assessment and experimental evidence.

## From records to a research question

The open release gives us tables of extracted reaction records, with chemical structures encoded in a text column and source information beside them. Our first inspection connected a reaction to a patent paragraph, exposed missing and differing yield values, and counted **1,939,253 application records**. These checks establish the file’s layout and some questions for further analysis. They do not measure extraction accuracy or count distinct chemistry.

The full-file overview adds their publication-year coverage and yield availability. Together, these checks help define a focused next task: finding reported preparations, preparing product-prediction examples, or investigating the subset with yield information. Retaining the release, source references, and selection rules makes that work traceable.
