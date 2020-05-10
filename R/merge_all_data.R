#' merge data function
#'
#' This function takes in baracoda data, mupexi data, smaple information and buyyfyboat informatin
#' @param baracoda all merge baracoda files
#' @param mupexi all merge mupexi files
#' @param sampel_information all information about the samplea in the data
#' @param buffycoat_HLA_information information about HLA in buffycoat
#' @export

# function to merge
merge_all_data <- function(all_barracoda =  all_barracoda,
                           all_mupexi  = all_mupexi,
                          sample_info = sample_info,
                          buffycoat.HLA_info  = buffycoat.HLA_info)
  {

  all_barracoda %>% group_by(HLA) %>%
    count()

  all_barracoda <-  all_barracoda %>%
    # Rename it so that columns can be merged
    mutate(HLA = str_replace(HLA, "^H-2", "H2-")) %>%
    # Add identifier colum to merge w/ mupexi
    mutate(identifier = paste(HLA, Sequence, sep = "_"))

  # deselect som of the columns
  all_mupexi <- all_mupexi %>%   # remove extra columns from previous handling
    select(-identifier, -Mut_peptide.y, -Allele) %>%
    # convert Mut_MHCrank_EL and Expression level to numeric so we can join both files
    mutate(Mut_MHCrank_EL = as.numeric(Mut_MHCrank_EL),
           Expression_Level = as.numeric(Expression_Level)) %>%
    # identifier column to merge with barracoda - HLA_peptidename
    mutate(identifier = paste(HLA_allele, Mut_peptide, sep = "_"))

  mupexi_barracoda <- left_join(all_barracoda, all_mupexi, by = "identifier")

  my_data <- left_join(mupexi_barracoda, sample_info) %>% #bring PE_population info of each sample into barracoda_mupexi file
    # add HLA_match column if HLA in any of the buffycoat_HLA info file
    mutate(HLA_match = case_when(HLA %in% buffycoat.HLA_info$HLA1 | HLA %in% buffycoat.HLA_info$HLA2 | HLA %in% buffycoat.HLA_info$HLA3~"yes",
                                 TRUE ~ "no"))
}


