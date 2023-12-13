#' barcoda response generater
#'
#' This function generates a sequence of logo.
#' @param data data to use
#' @param est_freq the estimated frequency to use
#' @export

# Baracoda respond function -----------------------------------------------
barc_resp <- function(data = my_barrcoda_data,
                      est_freq = estimated_frequency){
  p <- data %>%
    ggplot(., aes(x = Peptide, y = as.numeric(log_fold_change) )) +
    geom_point(aes_string(color = 'response', size = est_freq )) +
    geom_point(data=subset(data, !is.na(estimated_frequency)), aes_string(color = 'response', size = est_freq )) +
    geom_point(data=subset(data, is.na(estimated_frequency)),aes_string(color = 'response'), size=0.01) +
    geom_text_repel(data=subset(data, response=="yes"),
                    aes(label=Sequence)) +
    facet_grid(.~HLA)+
    theme_bw() +
    labs(y = "log fold change", x = "", size = "estimated frequency") +
    scale_y_log10() +
    theme_bw() +
    theme(legend.position = "bottom")
  return(p)
}


