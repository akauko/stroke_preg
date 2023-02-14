# stroke_preg
Code for the project: Risk of Midlife Stroke after Adverse Pregnancy Outcomes

We studied if adverse pregnancy outcomes are associated with younger age at first stroke, with a larger effect in those with recurrent adverse events.

* Data: FinnGen https://www.finngen.fi/en
* Description of variables: https://risteys.finngen.fi/
* Description of registries: https://finngen.gitbook.io/finngen-analyst-handbook/finngen-data-specifics/finnish-health-registers-and-medical-coding
* Data access: https://site.fingenious.fi/en/

```
ht_prs_preg
├── README.md                   # Overview
├── stroke_preg3.rmd            # R markdown for the analysis
├── scripts
  ├── functions.R               # Minor R functions for the analysis
  ├── select columns.pl         # Perl script to select columns from a tsv file by column names
  ├── fg_pheno_cols.txt         # List of variables that are extracted from the FinnGen phenotype file
  ├── icd_codes_preg.csv        # ICD codes for adverse pregnancy events, used for the medical birth registry

```
