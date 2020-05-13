#' barcoda response generater
#'
#' This function generates a sequence of logo.
#' @param data data to use
#' @param len length of mut_peptide
#' @param resp response: yes or no
#' @export

# GGseq logo function -----------------------------------------------
seqloggo_generator <-  function(data = my_clean_augment_data ,
                                len = 9,
                                resp = c("yes","no"))
{ p <- data  %>%
  group_by(response) %>%
  distinct(identifier, .keep_all = T) %>%
  filter(str_length(mut_peptide)==len,response==resp) %>%
  select(mut_peptide) %>%
  ggseqlogo()
return(p)
}

