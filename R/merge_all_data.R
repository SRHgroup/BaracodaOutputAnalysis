
# function with clean data
merge_all_data <- function(baracoda =  all_barracoda ,
                          mupexi  = all_mupexi,
                          sampel_information = sample_info,
                          buffycoat_HLA_information  = buffycoat.HLA_info) {

  all_barracoda %>% group_by(HLA) %>%
    count()

  all_barracoda <-  all_barracoda %>%
    # Rename it so that columns can be merged
    mutate(HLA = str_replace(HLA, "^H-2", "H2-")) %>%
    # Add identifier colum to merge w/ mupexi
    mutate(identifier = paste(HLA, Sequence, sep = "_"))

  mupexi_barracoda <- left_join(all_barracoda, all_mupexi, by = "identifier")

  my_data <- left_join(mupexi_barracoda, sample_info) %>% #bring PE_population info of each sample into barracoda_mupexi file
    # add HLA_match column if HLA in any of the buffycoat_HLA info file
    mutate(HLA_match = case_when(HLA %in% buffycoat.HLA_info$HLA1 | HLA %in% buffycoat.HLA_info$HLA2 | HLA %in% buffycoat.HLA_info$HLA3~"yes",
                                 TRUE ~ "no"))

}


