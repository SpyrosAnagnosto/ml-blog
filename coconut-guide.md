---
layout: default
title: "COCONUT: A Guide to the Collection of Open Natural Products"
description: "An introduction to COCONUT, its natural-product records, chemical families, biological sources, practical uses, and limitations."
date: 2026-11-09
---

<style>
main { max-width: 900px; }
main h1 { font-size: clamp(30px, 5vw, 40px); }
main table { display: block; width: 100%; overflow-x: auto; border-collapse: collapse; margin: 28px 0; font: 15px/1.6 Arial, sans-serif; }
main th, main td { padding: 12px 14px; border: 1px solid #dce7e8; text-align: left; vertical-align: top; }
main th { background: #edf5f5; color: #17343b; }
main tr:nth-child(even) td { background: #f8fbfb; }
main td code { overflow-wrap: anywhere; }
main img { display: block; margin: 28px auto 12px; }
main p > em:only-child { display: block; font-size: 0.85em; line-height: 1.6; color: #536770; }
</style>

# COCONUT: A Guide to the Collection of Open Natural Products

**COCONUT is a searchable database of natural-product molecules.** Natural products are chemicals produced by living organisms, including plants, fungi, and bacteria. Caffeine is a familiar example.

Short for **COlleCtion of Open NatUral producTs**, COCONUT brings information from multiple open collections into one resource. It connects molecular structures with names, chemical properties, organisms, and publications. The database can be explored through its website or downloaded for analysis. Its scope includes natural products whose structures have been determined, as well as predicted natural products. [About COCONUT](https://coconut.naturalproducts.net/about)

This aggregation addresses a practical problem: natural-product information is scattered across resources that use different formats and supply different details. Bringing those records together makes them easier to find and compare. COCONUT also supports community submission and curation, so contributors can add information and address problems in existing entries. [Official introduction](https://steinbeck-lab.github.io/coconut/introduction.html)

![A COCONUT compound record connects chemical information, organisms, source collections, and literature]({{ '/assets/images/coconut/coconut_record_map.png' | relative_url }})

*One record connects several kinds of information. The diagram uses selected examples from [caffeine's entry](https://coconut.naturalproducts.net/compounds/CNP0228556.0).*

## Reading a compound entry: caffeine

Caffeine's entry, **CNP0228556.0**, shows how the resource works. It lists the formula **C8H10N4O2** and molecular weight **194.19 g/mol**, alongside a chemical structure and its associated information. [Caffeine in COCONUT](https://coconut.naturalproducts.net/compounds/CNP0228556.0)

The formula tells us that a molecule contains eight carbon atoms, ten hydrogens, four nitrogens, and two oxygens. The drawing adds the connections between those atoms. A formula describes composition; a structure describes how the atoms are arranged.

![Caffeine molecular structure]({{ '/assets/images/coconut/caffeine.png' | relative_url }})

*Caffeine, drawn from the structure representation supplied by COCONUT. Nitrogen and oxygen atoms are labelled; carbon atoms occupy unlabelled corners and line ends, and most hydrogens are omitted.*

The entry also provides **annotations**: information attached to the structure. Its organism annotations include the coffee plants *Coffea arabica* and *Coffea canephora*, and the tea plant *Camellia sinensis*. Its source collections include KNApSaCK, PubChem NPs, and ChEBI NPs. Here, an organism is a biological association, while a collection is a data resource contributing information. Linked publications provide routes back to the literature. [Caffeine entry, accessed 9 November 2026](https://coconut.naturalproducts.net/compounds/CNP0228556.0)

A compound entry therefore connects three things: the molecule's identity, its structure, and the information reported about it. The same organization carries over into a downloadable dataset.

## Inside the CSV: 738,793 rows and 44 columns

A **CSV**, or comma-separated values file, represents information as a table. The **November 2026 full CSV export contains 738,793 compound records and 44 columns**, excluding the header row. All dataset counts in this article refer to that release, a snapshot of COCONUT rather than the continuously changing website or the complete underlying database. [November 2026 export](https://coconut.s3.uni-jena.de/prod/downloads/2026-11/coconut_csv-11-2026.zip)

### What does one row represent?

Each row is a **compound record**: a chemical structure together with its identifiers, properties, and annotations. Reading across a row brings together information about the same entry, from its molecular formula to associated organisms and source collections.

One record can list several organisms, collections, or publications. Related structures, including forms that differ in the spatial arrangement of their atoms, can also have separate records. The row count is therefore a count of compound records, rather than experiments, organism associations, or unrelated molecular families.

### What do the columns describe?

The columns describe different aspects of each record:

| Kind of information | Example columns | What they tell us |
| --- | --- | --- |
| Identity | `identifier`, `name`, `iupac_name` | The entry's identifier and names |
| Structure | `canonical_smiles`, `standard_inchi`, `standard_inchi_key` | Text representations and identifiers of the chemical structure |
| Composition and properties | `molecular_formula`, `molecular_weight` | Which atoms the molecule contains and its molecular weight |
| Structural features | `heavy_atom_count`, `rotatable_bond_count` | Counts of features within the structure |
| Chemical classification | `chemical_class`, `np_classifier_class` | Categories assigned to the compound |
| Biological context | `organisms` | Organisms associated with the compound in the database |
| Sources and references | `collections`, `dois` | Contributing collections and linked publications |

SMILES and InChI are ways of encoding a structure as text; an InChIKey is a compact identifier derived from an InChI. A DOI identifies a publication or another citable resource. These fields help connect records to structures and sources even when names differ.

Not every cell contains a value. An entry may have a structure and molecular formula while its name or organism field is blank. With this layout in mind, the table can be used to explore both chemical diversity and biological context.

## What kinds of molecules does COCONUT contain?

Natural products encompass several broad chemical families. Caffeine belongs to a different group from a fatty acid or a sugar, even though all can be represented in the same database.

One set of labels in COCONUT comes from **NPClassifier**, a computational classification system informed by biosynthesis: how organisms build molecules. Its broadest level, called a pathway, distinguishes seven families. The table below introduces those families and shows their representation in the November 2026 export. [NPClassifier paper](https://doi.org/10.1021/acs.jnatprod.1c00399)

| Broad family | Introductory description | Records | Share of all records |
| --- | --- | ---: | ---: |
| Terpenoids | Includes many scent compounds and steroids | 209,865 | 28.4% |
| Alkaloids | Diverse nitrogen-containing compounds; caffeine is an example | 173,145 | 23.4% |
| Shikimates and phenylpropanoids | Includes flavonoids and other aromatic compounds | 116,239 | 15.7% |
| Fatty acids | Carbon-chain acids and related lipids | 83,412 | 11.3% |
| Polyketides | Compounds assembled by extending small carbon building blocks | 61,388 | 8.3% |
| Amino acids and peptides | Amino acids and compounds built from linked amino acids | 33,829 | 4.6% |
| Carbohydrates | Sugars and related compounds | 8,647 | 1.2% |
| No pathway label | The classification field is blank | 52,268 | 7.1% |

*Counts use the supplied NPClassifier pathway field. Percentages include all 738,793 records, including those with no label. The descriptions are introductory guides rather than strict chemical definitions. [Source export](https://coconut.s3.uni-jena.de/prod/downloads/2026-11/coconut_csv-11-2026.zip)*

![Chemical-family distribution in COCONUT]({{ '/assets/images/coconut/coconut_chemical_families.png' | relative_url }})

*Terpenoids are the largest assigned family, followed by alkaloids and shikimates/phenylpropanoids. Grey denotes a blank field, not an eighth chemical family.*

More specific labels distinguish groups within a family. Caffeine's record places it among **alkaloids**, specifically **purine alkaloids**. Quercetin's record places it among **shikimates and phenylpropanoids**, within the **flavonoids** superclass and **flavonols** class. This lets a researcher move from a broad overview to a narrower set of compounds. [Caffeine entry](https://coconut.naturalproducts.net/compounds/CNP0228556.0), [quercetin entry](https://coconut.naturalproducts.net/compounds/CNP0103504.0)

These counts describe database coverage under the supplied classification. They do not measure how abundant the families are in nature.

## Where do the molecules come from?

Chemical classifications describe the kinds of structures present. Organism annotations add biological context, connecting compound records to plants, fungi, bacteria, and other organisms.

| Compound record | One organism annotation | Type of organism |
| --- | --- | --- |
| Caffeine | *Coffea arabica* | Coffee plant |
| Lovastatin | *Aspergillus terreus* | Fungus |
| Antibiotic SO 75R1 | *Nocardia brasiliensis* | Bacterium |

*Selected annotations from longer organism lists in the November 2026 CSV. Entries: [caffeine](https://coconut.naturalproducts.net/compounds/CNP0228556.0), [lovastatin](https://coconut.naturalproducts.net/compounds/CNP0201094.1), and [SO-75R1](https://coconut.naturalproducts.net/compounds/CNP0146911.1).*

These are biological-source annotations. The separate collection field identifies where the data came from: a database or a published dataset. Keeping those meanings of “source” distinct helps a reader follow an entry from a molecule to its reported biological context and then to the resources behind it. [COCONUT collections guide](https://steinbeck-lab.github.io/coconut/collections.html)

### Starting with an organism: the tea plant

The connection can be followed in either direction. A reader can start with caffeine and inspect its associated organisms, or start with the tea plant, *Camellia sinensis*, and find associated compound records.

In the November 2026 export, **807 records contain the exact organism label `Camellia sinensis`**, including caffeine and quercetin. Their structures, classifications, and references provide a starting point for exploring chemistry associated with tea. This selection excludes records annotated only with alternative spellings, synonyms, or more specific variety names. [Source export](https://coconut.s3.uni-jena.de/prod/downloads/2026-11/coconut_csv-11-2026.zip)

The result reflects available annotations. Across the full export, **273,549 records (37.0%)** have a nonblank organism field. A blank field supplies no organism information for that record; it does not establish that the compound lacks a biological source. Organism queries therefore recover documented associations, not a complete inventory of an organism's chemistry.

![Availability of structure and annotation fields in COCONUT]({{ '/assets/images/coconut/coconut_annotation_coverage.png' | relative_url }})

*The November 2026 full CSV supplies SMILES and collection fields for every record, while names, organisms, and DOI references have lower coverage. Teal shows nonblank fields and pale portions show blanks. A populated field does not establish that its content has been independently verified. [Source export](https://coconut.s3.uni-jena.de/prod/downloads/2026-11/coconut_csv-11-2026.zip)*

## What can someone do with COCONUT?

The examples illustrate two uses already: looking up a known molecule and exploring compounds associated with an organism. Other starting points include a structural fragment, a proposed molecular formula, or a need for a defined research dataset.

| Research question | How COCONUT can help |
| --- | --- |
| What information is available about this molecule? | Look up its name, identifier, or structure and inspect its annotations and references. |
| Which compounds are associated with an organism? | Select records carrying the relevant organism annotation. |
| Which molecules contain a particular fragment? | Use substructure search to find structures containing that fragment. |
| Which molecules resemble a known compound? | Use similarity search to find structurally related candidates. |
| Which records fit a particular analysis? | Select a chemical class or filter molecular properties in a downloaded dataset. |
| Which structures fit a proposed molecular formula? | Find matching records to build a candidate list. |

The website supports individual lookups and structure-based searches. Downloads support larger comparisons in a researcher's own software. [Browsing guide](https://steinbeck-lab.github.io/coconut/browse.html), [structure-search documentation](https://steinbeck-lab.github.io/coconut/search.html)

A **substructure search** requires a particular fragment to occur within a molecule. A **similarity search** compares broader structural resemblance under selected settings. Both can reveal compounds worth investigating.

### Starting with a formula: finding candidates

Suppose a researcher is investigating a sample whose proposed molecular formula is **C8H10N4O2**. Searching that exact formula in the November 2026 CSV returns **13 compound records**, including caffeine and isocaffeine. [Source export](https://coconut.s3.uni-jena.de/prod/downloads/2026-11/coconut_csv-11-2026.zip)

Caffeine and isocaffeine contain the same numbers of each element, but their atoms are connected differently. The search narrows the possibilities without providing a unique identification. The researcher can inspect the candidate structures and literature, then use additional experimental evidence to distinguish them. [Caffeine](https://coconut.naturalproducts.net/compounds/CNP0228556.0), [isocaffeine](https://coconut.naturalproducts.net/compounds/CNP0106880.0)

This illustrates how the resource can support interpretation of chemical measurements. COCONUT lists mass-spectrometry research, fragment analysis, and computational drug-discovery work among its applications. Exported structures can also support comparisons within a chemical family or the preparation of a set for computational screening. [Application examples](https://steinbeck-lab.github.io/coconut/use-cases.html)

## How to get started

A first visit can begin with the same molecule used in this guide:

1. Open the [COCONUT search page](https://coconut.naturalproducts.net/search) and search for **caffeine**. The identifier **CNP0228556.0** locates the entry discussed here.
2. Inspect its name, formula, and structure to establish which entry you are reading.
3. Explore its organisms, collections, and references. These show the biological associations and routes back to the source information.
4. For a question involving many records, choose an export from the [download page](https://coconut.naturalproducts.net/download). The full CSV includes organism, collection, and reference fields alongside the chemistry.

### Preview the downloaded table in Python

With pandas installed and the November 2026 full CSV ZIP in the current working folder, a short preview can be loaded directly from the archive:

```python
import pandas as pd

sample = pd.read_csv(
    "coconut_csv-11-2026.zip", nrows=5, dtype=str, keep_default_na=False
)
print(sample[["identifier", "name", "molecular_formula"]])
```

This reads the first five records, preserving text values and empty cells. It provides a manageable introduction to the columns, rather than a representative sample of the database. The filename ties the example to this article's release; use the matching filename for another download.

## What are COCONUT's limitations?

The value of a result depends on the question and the evidence attached to the selected records. Four considerations help establish its scope.

### Coverage and source evidence vary

COCONUT reflects the collections it incorporates and their available annotations. Its contents are not a census of natural-product chemistry. Missing information, naming differences, and the coverage of contributing collections all affect what a query retrieves.

Agreement between collections is also not necessarily independent confirmation. Collections may reuse information, allowing an incorrect structure or annotation to appear in several places. The COCONUT 2.0 paper discusses these circular imports and the propagation of problematic records. [COCONUT 2.0 paper](https://doi.org/10.1093/nar/gkae1063)

An organism association needs interpretation in its original context. Detecting a compound in a sample, isolating it from an organism, and demonstrating that the organism biosynthesizes it are different claims.

### Computational annotations are not experimental findings

NPClassifier labels organize structures computationally; they do not establish an experimentally confirmed biosynthetic route. Similarly, calculated properties and structural similarity scores do not by themselves demonstrate biological activity. Studies of activity require suitable experimental measurements for the question being asked.

### Structural specificity matters

**Stereochemistry** describes the spatial arrangement of atoms. Structures with identical formulas can differ in this arrangement, and some descriptions leave parts of it unspecified. The COCONUT 2.0 paper documents incomplete stereochemical information in source records and groups stereochemical variants using related identifiers. Researchers combining records need to decide which distinctions to preserve. [COCONUT 2.0 paper](https://doi.org/10.1093/nar/gkae1063)

### An export has a defined scope

The full CSV places organism, collection, and reference lists beside a compound, but does not necessarily show which publication supports each individual organism association. That detail may require consultation of the original collection or publication.

A downloaded file also belongs to a particular release. Subsequent curation can change entries and counts, while the website may differ from a saved export. Retaining the release, identifiers, and selection criteria makes results traceable. [Export documentation](https://steinbeck-lab.github.io/coconut/data.html)

## Access, licensing, and citation

### Obtaining the data

Use the [website](https://coconut.naturalproducts.net/) for individual lookups and the [download page](https://coconut.naturalproducts.net/download) for release files. CSV supports tabular analysis, SDF provides chemical structure files, and the PostgreSQL dump supports work with the relational database. Keep the release label and original filename with an analysis so its source can be identified later.

### Checking the applicable licence

As checked on **9 November 2026**, the download page describes its data as **CC0**, while the documentation's licence page describes **data in the repository as CC BY 4.0** and the software as **MIT-licensed**. These statements should not be collapsed into a single licence claim for every part of the resource. Record the terms stated for the specific download or material being used, and seek clarification from the maintainers if their applicability is unclear. [Download-page statement](https://coconut.naturalproducts.net/download), [code and data licence documentation](https://steinbeck-lab.github.io/coconut/license.html)

### Citing the resource and the release

The [official citation guidance](https://steinbeck-lab.github.io/coconut/introduction.html) identifies the platform paper:

- [*COCONUT 2.0: a comprehensive overhaul and curation of the collection of open natural products database*](https://doi.org/10.1093/nar/gkae1063), published in *Nucleic Acids Research*.

A paper citation identifies the resource, while a dataset citation identifies the version analysed. If using an archived release with a dataset DOI, cite that release's record and version. For the direct download used in this article, the source description is:

> COCONUT, November 2026 full CSV export, `coconut_csv-11-2026.zip`, accessed 9 November 2026. [Release file](https://coconut.s3.uni-jena.de/prod/downloads/2026-11/coconut_csv-11-2026.zip).

The release file above should not be assigned the DOI of a different archived version. For claims about individual compounds or organism associations, cite the relevant original publications as well as the database.

For a first investigation, a familiar compound provides a useful entry point. Its structure, associated organisms, and references show how COCONUT connects chemical records to a wider body of information. From there, a focused question can guide the selection of records and the evidence needed to interpret them.
