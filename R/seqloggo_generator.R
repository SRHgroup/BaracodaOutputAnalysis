#' Sequence Logo Generator
#'
#' This function generates a sequence of logo.
#' @param data data to use
#' @param len length of mut_peptide
#' @param resp response: "yes" or "no
#' @param cons mutation consequence: "F", "M", "I", "D"
#' @param mouse cell_line of mouse
#' @export

seqloggo_generator <-  function(data,
                                len,
                                resp = c("yes","no"),
                                cons = c("F","M","I","D"),
                                mouse = c("CT26","4T1"))
{ p <- data %>%
  filter(str_length(mut_peptide)==len, response==resp, mutation_consequence==cons, cell_line == mouse) %>%
  select(mut_peptide) %>%
  ggseqlogo()
return(p)
}
