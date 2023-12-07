#' generate_FU_template_tab
#'
#' A function to generate template for PE percent table "generate_FU_template_tab"
#' @param data uploaded dataframe from my barracode data
#' @export

# function with clean data
generate_FU_template_tab <- function(data = my_barrcoda_data, outfile = "data/percent_PE.xlsx" ) {
  percent_pe_tab <- data %>%
    group_by(sample) %>%
    tally() %>%
    mutate(percent_pe = 5) %>%
    select(sample,percent_pe)
  write.xlsx(percent_pe_tab, file = outfile)
}
