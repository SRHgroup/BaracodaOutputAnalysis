#' Box Plot Function
#'
#' This function takes in data, x, and y, and creates a box plot.
#' @param data data to plot
#' @param x x variable
#' @param y y variable
#' @param no_legend determine legend
#' @export

box_function <- function(data = data_single_peptides,
                         x,
                         y,
                         no_legend = TRUE) {
  p <-  data %>%
    ggplot(mapping = aes_string(x = x, y = y)) +
    geom_quasirandom(aes(color = response),size = 2) +
    geom_boxplot(aes(fill = response),
                 alpha = .5, outlier.shape = NA, colour = '#525252') +
    facet_grid(vars(cell_line), scales = "free") +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5))+
    scale_fill_manual(values = respond_cols) +
    scale_color_manual(values = respond_cols) +
    guides(fill = FALSE, color = guide_legend(override.aes = list(size = 4)))

  # Determine legend
  if (no_legend == TRUE) p <- p + theme(legend.position = 'none') else NULL

  return(p)
}

