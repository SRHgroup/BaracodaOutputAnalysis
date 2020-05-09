barcc
================

<!-- README.md is generated from README.Rmd. Please edit that file -->

The packges will take pre-processed copy of raw baracoda files and
mupexi files and illustrate the characteristics of the immunugenic
neopeptides.

## Installation and background

The packges will take pre-processed copy of raw baracoda files and
mupexi files and illustrate the characteristics of the immunugenic
neopeptides. The packgaes can take mouse data as input. The human data
input is in process …

``` r
# install.packages("devtools")
library(devtools)
devtools::install_github("rforbiodatascience/barcc")
```

barcc is built with [tidyverse](https://github.com/tidyverse/tidyverse)
and is required for running \# required packages

``` r
library(tidyverse)
#> ── Attaching packages ────────────────────────────────────────────────────────────────────────────── tidyverse 1.3.0 ──
#> ✓ ggplot2 3.3.0     ✓ purrr   0.3.4
#> ✓ tibble  3.0.1     ✓ dplyr   0.8.5
#> ✓ tidyr   1.0.2     ✓ stringr 1.4.0
#> ✓ readr   1.3.1     ✓ forcats 0.5.0
#> Warning: package 'tibble' was built under R version 3.6.2
#> Warning: package 'purrr' was built under R version 3.6.2
#> ── Conflicts ───────────────────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()
library(readxl)
```

## Load data

# BARRACODA FILES

``` r

path_ct26 <- "test_data/barracoda_output_CT26.xlsx"
all_ct26_barracoda_raw <- path_ct26 %>% 
  # function to import all sheets
  excel_sheets() %>% 
  # give names to each sheet
  set_names() %>% 
  # apply read_excel to each sheet, and add the number to the colum sheet
  map_df(~ read_excel(path = path_ct26, sheet = .x), .id = "sheet") 

path_4t1 <- "test_data//barracoda_output_4T1.xlsx"

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

# MUPEXI FILES

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

# PE\_population\_info and buffycoat\_HLA\_info file

``` r
sample_info <- read_xlsx(path = "test_data/sample_info.xlsx")
buffycoat.HLA_info <- read_xlsx(path = "test_data/buffycoatHLA_info.xlsx")
```

# Wrangle data

``` r
all_barracoda <- full_join(all_ct26_barracoda_raw, all_4t1_barracoda_raw)
#> Joining, by = c("sheet", "barcode", "sample", "count.1", "input.1", "input.2", "input.3", "log_fold_change", "p", "-log10(p)", "masked_p (p = 1 if logFC < 0)", "-log10(masked_p)", "count.normalised (edgeR)", "input.normalised (edgeR)", "Peptide.name", "HLA", "Sequence")
```

# Wrong HLA annotation: H-2XX instead of H2-XX as mupexi.

``` r
all_barracoda %>% group_by(HLA) %>%
  count()
#> # A tibble: 6 x 2
#> # Groups:   HLA [6]
#>   HLA       n
#>   <chr> <int>
#> 1 H-2Db  1830
#> 2 H-2Dd  1830
#> 3 H-2Kb  1842
#> 4 H-2Kd  1830
#> 5 H-2Ld  1200
#> 6 H2-Ld   636

all_barracoda <-  all_barracoda %>% 
  # Rename it so that columns can be merged
  mutate(HLA = str_replace(HLA, "^H-2", "H2-")) %>% 
  # Add identifier colum to merge w/ mupexi
  mutate(identifier = paste(HLA, Sequence, sep = "_"))

all_mupexi <- full_join(mupexi_4t1, mupexi_ct26) %>% 
  # identifier column to merge with barracoda - HLA_peptidename
  mutate(identifier = paste(HLA_allele, Mut_peptide, sep = "_"))
#> Joining, by = c("HLA_allele", "Norm_peptide", "Norm_MHCrank_EL", "Norm_MHCscore_EL", "Norm_MHCaffinity", "Norm_MHCrank_BA", "Norm_MHCscore_BA", "Mut_peptide", "Mut_MHCrank_EL", "Mut_MHCscore_EL", "Mut_MHCaffinity", "Mut_MHCrank_BA", "Mut_MHCscore_BA", "Gene_ID", "Transcript_ID", "Amino_Acid_Change", "Allele_Frequency", "Mismatches", "peptide_position", "Chr", "Genomic_Position", "Protein_position", "Mutation_Consequence", "Gene_Symbol", "Cancer_Driver_Gene", "Proteome_Peptide_Match", "Expression_Level", "Mutant_affinity_score", "Normal_affinity_score", "Expression_score", "priority_Score", "Self_Similarity")
```

# Merged dataset

``` r
mupexi_barracoda <- left_join(all_barracoda, all_mupexi, by = "identifier")

my_data <- left_join(mupexi_barracoda, sample_info) %>% #bring PE_population info of each sample into barracoda_mupexi file 
  # add HLA_match column if HLA in any of the buffycoat_HLA info file
  mutate(HLA_match = case_when(HLA %in% buffycoat.HLA_info$HLA1 | HLA %in% buffycoat.HLA_info$HLA2 | HLA %in% buffycoat.HLA_info$HLA3~"yes",
                               TRUE ~ "no"))
#> Joining, by = "sample"
```
