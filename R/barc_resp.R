#' barcoda response generater
#'
#' This function generates a sequence of logo.
#' @param data data to use
#' @param mouse_cell_line select mouse cell line
#' @export

# Baracoda respond function -----------------------------------------------
barc_resp <- function(data = my_clean_augment_data,
                       mouse_cell_line = "CT26"){

  p <- data %>% filter(cell_line == mouse_cell_line) %>%
    ggplot(., aes(peptide_name, log_fold_change)) +
    geom_point(aes(color = sample, shape = organ,
                   alpha = response, size = estimated_frequency_norm)) +
    geom_text_repel(data %>%
                      filter(cell_line == mouse_cell_line, response == "yes"),
                    mapping = aes(label = peptide_name)) +
    facet_grid(vars(treatment)) +
    labs(size = "Normalized est. freq.",
         shape = "Organ",
         color = "Sample",
         alpha = "Response",
         y = "logFC") +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5, size = 16),
          axis.title = element_text(size = 16),
          axis.title.x = element_blank(),
          legend.title = element_text(size = 16),
          legend.text = element_text(size = 14),
          legend.position = 'bottom') +
    guides(color = guide_legend(override.aes = list(size = 4), nrow = 8 ,title.position="top"),
           alpha = guide_legend(override.aes = list(size = 4), nrow = 2 ,title.position="top"),
           shape = guide_legend(override.aes = list(size = 4), nrow = 2 ,title.position="top"),
    size = guide_legend(nrow = 6, title.position="top"))
  return(p)
}

