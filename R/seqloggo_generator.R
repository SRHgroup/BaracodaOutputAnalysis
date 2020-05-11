#' Sequence Logo Generator
#'
#' This function generates a sequence of logo.
#' @param data data to use
#' @param len length of mut_peptide
#' @param resp response: "yes" or "no
#' @param cons mutation consequence: "F", "M", "I", "D"
#' @param mouse cell_line of mouse
#' @export

# GGseq logo function -----------------------------------------------------
seqloggo_generator <-  function(data = my_data_clean_aug ,
                                len = 9,
                                resp = c("yes","no"))
{ p <- my_data_clean_aug %>%
  filter(str_length(mut_peptide)==len,
         response==resp) %>%
  select(mut_peptide) %>%
  ggseqlogo()
return(p)
}
