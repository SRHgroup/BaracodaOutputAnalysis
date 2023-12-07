#' add_response_by_threshold
#'
#' A function to add response column "add_response_by_threshold"
#' @param my_baracoda_data baracoda_data
#' @export

# function to merge
add_response_by_threshold <- function(data =my_barrcoda_data,
                                      FC = 2, p_val = 0.001) {
  data <- data %>%
    mutate(response = case_when(log_fold_change >= FC & p <= p ~ "yes",
                                TRUE ~ "no"))
  return(data)
}
