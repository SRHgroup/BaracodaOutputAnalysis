#' Bar Plot Function
#'
#' This function allows you to do a bar plot from specified peptide_position
#' @param num Length of mut_peptide
#' @export

bar_plot_func <- function(num) {
  my_data_clean_aug %>%
    filter(str_length(mut_peptide)==num,mutation_consequence=="M") %>%
    ggplot(aes(x=peptide_position)) +
    geom_bar(aes(fill = response), stat = "count")+
    scale_y_log10() +
    scale_x_discrete(limits = c(1:num)) +
    scale_fill_manual(values = respond_cols) +
    theme_bw()

}
