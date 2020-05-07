#' Sequence Logo Generator
#'
#' This function takes in a dataset and len.
#' @export

seqloggo_generator <-  function(data = x ,
                                len = y,
                                resp = c("yes","no"),
                                cons = c("F","M","I","D"),
                                mouse = c("CT26","4T1"))
{ p <- x %>%
  filter(str_length(mut_peptide)==y, response==resp, mutation_consequence==cons, cell_line == mouse) %>%
  select(mut_peptide) %>%
  ggseqlogo()
return(p)
}
