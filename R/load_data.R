#' load data function
#'
#' This function takes in excel fil and load
#' @param data log_fold_change file
#' @export

# function to load data
load_data <- function(data = baracoda_output) {
  my_barrcoda_data <- data %>%
    excel_sheets() %>%
    set_names() %>%
    map_df(~ read_excel(path = data, sheet = .x), .id = "sheet")
  return(my_barrcoda_data)
}




