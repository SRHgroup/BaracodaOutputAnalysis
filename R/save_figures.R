#' save_figures
#'
#' A function to save "save_figure"
#'
#' @return A figure in results folder
#' @name save_figures
#' @examples
#' save_figure(plot = p, name = "figure" , width = 12 , height = 8)
#' @export
save_figure <- function(plot = p, name = "figure" , width = 12 , height = 8) {
  ggsave(p, file = paste0(results_figures_path,name,".pdf"),  width = width, height = height)

}

