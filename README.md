barcc
================

<!-- README.md is generated from the README.Rmd file. Edit that file for updates -->

## THIS PACKGAES IS IN BETA VERION\!

The packges will take pre-processed copy of raw baracoda files and
mupexi files and illustrate the characteristics of the immunugenic
neopeptides.

## Installation and background

The packges will take pre-processed copy of raw baracoda files and
mupexi files and illustrate the characteristics of the immunugenic
neopeptides. The packgaes works only with murine data, The human data
input is in progress …

``` r
# install.packages("devtools")
library(devtools)
devtools::install_github("rforbiodatascience/barcc")
```

barcc is built with [tidyverse](https://github.com/tidyverse/tidyverse)
and is required for running \#\# required packages

``` r
library(tidyverse)
#> ── Attaching packages ────────────────────────────────────────────────────────────────────── tidyverse 1.3.0 ──
#> ✓ ggplot2 3.3.0.9000     ✓ purrr   0.3.4     
#> ✓ tibble  3.0.1          ✓ dplyr   0.8.5     
#> ✓ tidyr   1.0.2          ✓ stringr 1.4.0     
#> ✓ readr   1.3.1          ✓ forcats 0.5.0
#> Warning: package 'tibble' was built under R version 3.6.2
#> Warning: package 'purrr' was built under R version 3.6.2
#> ── Conflicts ───────────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()
library(readxl)
library(openxlsx)
library(shiny)
library(ggplot2)
library(barcc)
```

# Load data

## Baracoda files

``` r
path_ct26 <- "test_data/barracoda_output_CT26.xlsx"
path_4t1 <- "test_data//barracoda_output_4T1.xlsx"
all_ct26_barracoda_raw <- path_ct26 %>% 
    # function to import all sheets
    excel_sheets() %>% 
    # give names to each sheet
    set_names() %>% 
    # apply read_excel to each sheet, and add the number to the colum sheet
    map_df(~ read_excel(path = path_ct26, sheet = .x), .id = "sheet") 
  
all_4t1_barracoda_raw <- path_4t1 %>% 
    excel_sheets() %>% 
    set_names() %>% 
    map_df(~ read_excel(path = path_4t1, sheet = .x), .id = "sheet")
#> New names:
#> * `` -> ...17
#> New names:
#> * `` -> ...17
#> New names:
#> * `` -> ...17
#> New names:
#> * `` -> ...17
#> New names:
#> * `` -> ...17
```

## Mupexi files

``` r
mupexi_ct26 <- read_xlsx(path = "test_data/ct26_library_mupexi.xlsx") %>% 
  # remove extra columns from previous handling
  select(-identifier, -Mut_peptide.y, -Allele) %>% 
  # convert Mut_MHCrank_EL and Expression level to numeric so we can join both files
  mutate(Mut_MHCrank_EL = as.numeric(Mut_MHCrank_EL),
         Expression_Level = as.numeric(Expression_Level))

mupexi_4t1 <- read_xlsx(path = "test_data/4T1_library_mupexi.xlsx") %>% 
  select(-identifier, -"...1")
#> New names:
#> * `` -> ...1
```

## PE population info and buffycoat HLA info file

``` r
sample_info <- read_xlsx(path = "test_data/sample_info.xlsx")
buffycoat.HLA_info <- read_xlsx(path = "test_data/buffycoatHLA_info.xlsx")
```

## Merge all baracoda files

``` r
all_barracoda <- full_join(all_ct26_barracoda_raw, all_4t1_barracoda_raw)
#> Joining, by = c("sheet", "barcode", "sample", "count.1", "input.1", "input.2", "input.3", "log_fold_change", "p", "-log10(p)", "masked_p (p = 1 if logFC < 0)", "-log10(masked_p)", "count.normalised (edgeR)", "input.normalised (edgeR)", "Peptide.name", "HLA", "Sequence")
```

## Merge mupexi files

``` r
all_mupexi <- full_join(mupexi_4t1, mupexi_ct26) %>% 
    # identifier column to merge with barracoda - HLA_peptidename
    mutate(identifier = paste(HLA_allele, Mut_peptide, sep = "_"))
#> Joining, by = c("HLA_allele", "Norm_peptide", "Norm_MHCrank_EL", "Norm_MHCscore_EL", "Norm_MHCaffinity", "Norm_MHCrank_BA", "Norm_MHCscore_BA", "Mut_peptide", "Mut_MHCrank_EL", "Mut_MHCscore_EL", "Mut_MHCaffinity", "Mut_MHCrank_BA", "Mut_MHCscore_BA", "Gene_ID", "Transcript_ID", "Amino_Acid_Change", "Allele_Frequency", "Mismatches", "peptide_position", "Chr", "Genomic_Position", "Protein_position", "Mutation_Consequence", "Gene_Symbol", "Cancer_Driver_Gene", "Proteome_Peptide_Match", "Expression_Level", "Mutant_affinity_score", "Normal_affinity_score", "Expression_score", "priority_Score", "Self_Similarity")
```

# Merge data function

Use merge function to merge baracoda and mupexi files the output is
my\_data

``` r
my_data <- merge_all_data(all_barracoda =  all_barracoda,
                           all_mupexi  = all_mupexi,
                          sample_info = sample_info,
                          buffycoat.HLA_info  = buffycoat.HLA_info)
#> Joining, by = "sample"
```

# Clean data function

with clean data function the varribale is cleaned and reay to import in
augment\_data fundtion

``` r
my_clean_data <- clean_data(my_data)
```

# Augment data

This function will make new column esimated frequency from the baracaoda
screening

``` r
my_clean_augment_data <- augment_data(my_clean_data)
#> Joining, by = "sample"
```

# Explore data in shiny app

Tha data can easy be open in a shiny app to explore the responses and
the if tehre is and pattern in the immunugenic neoepitopes

``` r
Exploring_data_shiny(Plotting_data = my_clean_augment_data )
#> Adding missing grouping variables: `sample`
#> PhantomJS not found. You can install it with webshot::install_phantomjs(). If it is installed, please make sure the phantomjs executable can be found via the PATH variable.
```

<!--html_preserve-->

<div class="muted well" style="width: 100% ; height: 400px ; text-align: center; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box;">

Shiny applications not supported in static R Markdown documents

</div>

<!--/html_preserve-->
