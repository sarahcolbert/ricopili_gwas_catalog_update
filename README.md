# Refreshing the GWAS catalog file used in the RICOPILI pipeline

## GWAS Catalog data used

```
downloaded by: SMCC
downloaded on: 20241114
download page: https://www.ebi.ac.uk/gwas/docs/file-downloads
command: wget https://www.ebi.ac.uk/gwas/api/search/downloads/full 
notes: 
downloaded the "All associations v1.0" file which is called "full" in this directory.
```

## Cleaning and formatting the file

See the script [01-clean_gwas_catalog_for_rico.R](https://github.com/sarahcolbert/ricopili_gwas_catalog_update/blob/main/01-clean_gwas_catalog_for_rico.R)

Filters applied
- P < 5e-8
- GWAS published after Jan 1, 2018
- To reduce number of hits and retain those most relevant, removed some biomarker phenotypes (i.e. those containing "level" in the name, e.g., "IgE levels" or "Serum albumin levels")
- N > 10,000

The resulting file is [gwascatalog.Nov_2024.rp.txt](https://github.com/sarahcolbert/ricopili_gwas_catalog_update/blob/main/gwascatalog.Nov_2024.rp.txt)

## Using the file

You need to make a few changes to the scripts in your rp_bin. First, edit the postimp_navi script: 

```
## line 1306 should link to the new gwas catalog file like:
my @gwascat_files = ("/projects/0/prjs0917/resources/gwas_catalog/gwascatalog.Nov_2024.rp.txt"); ## edited by SMCC 20241120

## line 4015 do the same, like:
$prekno_file = "/projects/0/prjs0917/resources/gwas_catalog/gwascatalog.Nov_2024.rp.txt"; ## edited by SMCC on 20241120

```

Also edit the area_plot_16_speed file:

```
## line 1306 should link to the new gwas catalog file like:
my @gwascat_files = ("/projects/0/prjs0917/resources/gwas_catalog/gwascatalog.Nov_2024.rp.txt"); ## edited by SMCC on 20241120

```

