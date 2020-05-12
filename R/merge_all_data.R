#' merge data function
#'
#' This function takes in baracoda data, mupexi data, smaple information and buyyfyboat informatin
#' @param barracoda all merge baracoda files
#' @param mupexi all merge mupexi files
#' @param info all information about the sample in the data
#' @export

# function to merge
merge_all_data <- function(all_barracoda =  all_barracoda,
                           mupexi  = all_mupexi,
                           info = sample_info){

  barracoda %>% group_by(HLA) %>%
    count()

  barracoda <-  barracoda %>%
    # Rename it so that columns can be merged
    mutate(HLA = str_replace(HLA, "^H-2", "H2-")) %>%
    # Add identifier colum to merge w/ mupexi
    mutate(identifier = paste(HLA, Sequence, sep = "_"))

  mupexi <- all_mupexi %>%
    # identifier column to merge with barracoda - HLA_peptidename
    mutate(identifier = paste(HLA_allele, Mut_peptide, sep = "_"))

  mupexi_barracoda <- left_join(barracoda, mupexi, by = "identifier")

  my_data <- left_join(mupexi_barracoda, info)

}


