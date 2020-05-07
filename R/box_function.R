#' Box Plot Function
#'
#' This function takes in data, x, and y, and creates a box plot.
#' @param data data to plot
#' @param x x variable
#' @param y y variable
#' @export

box_function <- function(data, x, y) {
  data %>%
    ggplot(mapping = aes_string(x = x, y = y)) +
    geom_boxplot(aes(fill = response)) }
