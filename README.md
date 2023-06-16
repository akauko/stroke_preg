# stroke_preg
Code for the project: 
[Miller, E.C., et al., Risk of Midlife Stroke After Adverse Pregnancy Outcomes: The FinnGen Study, Stroke (2023), Online ahead of print.](https://doi.org/10.1161/strokeaha.123.043052)

We studied if adverse pregnancy outcomes are associated with younger age at first stroke, with a larger effect in those with recurrent adverse events.

* Data: FinnGen https://www.finngen.fi/en
* Description of variables: https://risteys.finngen.fi/
* Description of registries: https://finngen.gitbook.io/finngen-analyst-handbook/finngen-data-specifics/finnish-health-registers-and-medical-coding
* Data access: https://site.fingenious.fi/en/

```
ht_prs_preg
├── README.md                   # Overview
├── stroke_preg3b.rmd            # R markdown for the analysis
├── scripts
  ├── functions.R               # Minor R functions for the analysis
  ├── select columns.pl         # Perl script to select columns from a tsv file by column names
  ├── fg_pheno_cols.txt         # List of variables that are extracted from the FinnGen phenotype file
  ├── icd_codes_preg.csv        # ICD codes for adverse pregnancy events, used for the medical birth registry

```
