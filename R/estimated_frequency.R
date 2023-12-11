#' estimated_frequency
#'
#' A function to calculate "estimated_frequency" and "estimated_frequency_normalised_responses"
#' @param my_baracoda_data barrcoda loaded data
#' @param fluochrome_dat the importet percent flouchrome
#' @export

estimated_frequency <- function(data = my_barrcoda_data, fluochrome_dat = percent_FU) {
  sum_count_responses =  data %>% filter(response == "yes") %>% select(count.1) %>% sum(., na.rm = T)
  barrcoda_data <- left_join(data, FU_data)

  barrcoda_data <- barrcoda_data %>%
    group_by(sample) %>%
    mutate(count.1 = as.numeric(count.1)) %>%
    mutate(sum_count = sum(count.1, na.rm = T)) %>%
    mutate(percent_count_fraction_response = (count.1/sum_count_responses)*100) %>%
    mutate(estimated_frequency = case_when(response=="yes" ~ (percent_pe*percent_count_fraction_response/100),
                                           response=="no" ~ "NA"))
  return(barrcoda_data)
}
