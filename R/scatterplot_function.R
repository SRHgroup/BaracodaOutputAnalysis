#' Scatter Plot Function
#'
#' This function takes in data, x, and y, and creates a scatter plot.
#' @param data data to plot
#' @param x x variable
#' @param y y variable
#' @export

scatterplot_function <- function(data,
                                 x,
                                 y)
{  data %>%
    ggplot(mapping = aes_string(x = x, y = y)) +
    geom_point(aes(color=response, alpha = response, size  = estimated_frequency))+
    scale_y_log10(breaks = c(0.01, 0.10, 1.00, 2.00, 10))+
    scale_x_log10(breaks = c(0.01, 0.10, 1.00, 2.00, 10))+
    theme_bw() +
    scale_alpha_manual(breaks = c("no","yes"),labels = c("no","yes"),values = c(0.3,0.9))+
    scale_color_manual(values = respond_cols) +
    guides(color = guide_legend(override.aes = list(size = 5))) +
    labs(size = "Estimated frequency",
         color = "Respond",
         alpha = "Respond")
}
