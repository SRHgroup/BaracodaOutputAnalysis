#' barcoda response generater
#'
#' This function generates a sequence of logo.
#' @param data data to use
#' @param Cell_Line select mouse cell line
#' @export

# Baracoda respond function -----------------------------------------------
barc_resp <- function(d, c){
  d <- d %>% filter(cell_line == c) %>%
    ggplot(., aes(peptide_name, log_fold_change)) +
    geom_point(aes(color = sample, shape = organ, alpha = response, size = estimated_frequency_norm)) +
    geom_text_repel(d %>%
                      filter(cell_line == c, response == "yes"), mapping = aes(label = neoepitope_sequence, size = 14)) +
    facet_grid(vars(treatment)) +
    labs(size = "Normalized estimated frequency",
         shape = "Organ",
         color = "Sample",
         alpha = "Response",
         y = "logFC") +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5, size = 16),
          axis.title = element_text(size = 16),
          axis.title.x = element_blank(),
          legend.title = element_text(size = 16),
          legend.text = element_text(size = 14)) +
    guides(color = guide_legend(override.aes = list(size = 4)),
           alpha = guide_legend(override.aes = list(size = 4)),
           shape = guide_legend(override.aes = list(size = 4)))
}

