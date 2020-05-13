#' Bar Plot Function
#'
#' This function allows you to do a bar plot from specified peptide_position
#' @param data data to plot
#' @param num Length of mut_peptide
#' @export

bar_plot_func <- function(data = my_data_clean_aug,
                          pep_length = 9) {
  p <- data  %>%
    group_by(response) %>%
    distinct(identifier, .keep_all = T) %>%
    filter(str_length(mut_peptide)==pep_length,mutation_consequence=="M") %>%
    ggplot(aes(x=peptide_position)) +
    geom_bar(aes(fill = response), stat = "count")+
    scale_y_log10() +
    scale_x_discrete(limits = factor(1:pep_length)) +
    scale_fill_manual(values = c("#91bfdb","#ef8a62")) +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5))+
    facet_grid(vars(cell_line))+
    labs(x = "Peptide Position",
         y = "Count")

  return(p)
}
