Baracoda Output Analysis
================

<!-- README.md is generated from the README.Rmd file. Edit that file for updates -->

The packges will take pre-processed copy of raw baracoda files and
calculate estimated frequency

## Installation and background

The packges will take pre-processed copy of raw baracoda files and
mupexi files and illustrate the characteristics of the immunugenic
neopeptides. The packgaes works only with murine data, The human data
input is in progress.

``` r
# install.packages("devtools")
library(devtools)
devtools::install_github("SRHgroup/BaracodaOutputAnalysis", force = T)
library(BaracodaOutputAnalysis)
```

BaracodaOutputAnalysis is built with
[tidyverse](https://github.com/tidyverse/tidyverse) and is required for
running. \## required packages

``` r
library(tidyverse)
library(readxl)
library(openxlsx)
library(ggplot2)
library(ggrepel)
library(ggbeeswarm)
library(knitr)
```

## Load data

### Baracoda files

``` r
# name of fold change file
baracoda_output <- "test_data/fold_change_example_file_new.xlsx"

# output directory
results_figures_path <- "results/figures/"
results_tables_path <- "results/tabels/"

# if you allready have PE table 
percent_FU <- "test_data/percent_PE_modi.xlsx"
# else follow the guidance and run the function "generate_FU_template_tab" after loading data 
```

### log fold change files

Load data

``` r

# load data
my_barrcoda_data <- BaracodaOutputAnalysis::load_data(data = baracoda_output)
```

## Add percent flourchrome information

generate template

``` r
# iF you want a template run function
BaracodaOutputAnalysis::generate_FU_template_tab(data = my_barrcoda_data, outfile = "test_data/percent_PE.xlsx")
```

Then change template with corresponding PE generate template

``` r
# load file
percent_FU <- "test_data/percent_PE_modi.xlsx"
FU_data <- read.xlsx(percent_FU)
```

``` r
# load file
head(FU_data)
#>   sample percent_pe
#> 1   1849        1.0
#> 2   2389        0.3
#> 3   7577        0.5
#> 4   7729        0.8
#> 5   9517        1.2
```

## responses and estimated frequency

Add column with response

``` r
my_barrcoda_data <- BaracodaOutputAnalysis::add_response_by_threshold(data = my_barrcoda_data,
         FC = 2, p_val = 0.001)
```

``` r
my_barrcoda_data %>% group_by(sample,response) %>% tally()
#> # A tibble: 10 × 3
#> # Groups:   sample [5]
#>    sample response     n
#>     <dbl> <chr>    <int>
#>  1   1849 no        1362
#>  2   1849 yes         87
#>  3   2389 no        1858
#>  4   2389 yes         50
#>  5   7577 no        1025
#>  6   7577 yes         45
#>  7   7729 no        1204
#>  8   7729 yes         86
#>  9   9517 no        2001
#> 10   9517 yes        135
```

Add estimated frequency and normalized estimated frequency

``` r
my_barrcoda_data <- BaracodaOutputAnalysis::estimated_frequency(data = my_barrcoda_data, fluochrome_dat = percent_FU)
```

``` r
my_barrcoda_data %>% 
  select(sample,Peptide,HLA,estimated_frequency, estimated_frequency_normalised_responses)
#> # A tibble: 7,853 × 5
#> # Groups:   sample [5]
#>    sample Peptide        HLA   estimated_frequency estimated_frequency_normali…¹
#>     <dbl> <chr>          <chr>               <dbl>                         <dbl>
#>  1   1849 CMV pp65 YSE   A0101            0.0513                        0.0170  
#>  2   1849 CMV pp50 VTE   A0101            0.0365                        0.0121  
#>  3   1849 Patient1849_18 A0101            0.00344                       0.00114 
#>  4   1849 Patient1849_15 A0101            0.00283                       0.000939
#>  5   1849 Patient1849_1  A0101            0.00420                       0.00139 
#>  6   1849 Patient1849_28 A0101            0.00131                       0.000436
#>  7   1849 Patient1849_19 A0101            0.00189                       0.000627
#>  8   1849 Patient1849_13 A0101            0.00113                       0.000375
#>  9   1849 Patient1849_14 A0101            0.00110                       0.000366
#> 10   1849 Patient1849_27 A0101            0.000931                      0.000309
#> # ℹ 7,843 more rows
#> # ℹ abbreviated name: ¹​estimated_frequency_normalised_responses
```

# Time for plotting

Overall responses

``` r
p <- BaracodaOutputAnalysis::barc_resp(data = my_barrcoda_data, est_freq = 'estimated_frequency')
```

``` r
p
```

<img src="README-bar_resp figure-1.png" width="80%" />

``` r
BaracodaOutputAnalysis::save_figure(plot = p, name = "response_figure" , width = 18 , height = 8)
```

Write output table

``` r
write.table(my_barrcoda_data, file = "results/tabels/barracoda_output_final.tsv", sep = "\t", quote = F, row.names = F)
```

# done
