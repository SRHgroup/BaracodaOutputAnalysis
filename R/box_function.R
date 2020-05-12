#' Box Plot Function
#'
#' This function takes in data, x, and y, and creates a box plot.
#' @param data data to plot
#' @param x x variable
#' @param y y variable
#' @export

box_function <- function(data = my_clean_augment_data,
                         x ='response',
                         y= 'mut_mhcrank_el') {
  p <-  data %>%
    ggplot(mapping = aes_string(x = x, y = y)) +
    geom_quasirandom(aes(color = response),size = 2) +
    geom_boxplot(aes(fill = response),
                 alpha = .5, outlier.shape = NA, colour = '#525252') +
    facet_grid(vars(cell_line), scales = "free") +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5))+
    scale_fill_manual(values = c("#91bfdb","#ef8a62")) +
    scale_color_manual(values = c("#91bfdb","#ef8a62")) +
    guides(fill = FALSE, color = guide_legend(override.aes = list(size = 4)))
  return(p)
}

