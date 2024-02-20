

suppressPackageStartupMessages(library(ggplot2))

figure_theme <- (
    theme_bw()
    + theme(
        axis.text = element_text(size = 20),
        axis.title = element_text(size = 20),
        legend.text = element_text(size = 20),
        legend.title = element_text(size = 18),
        strip.text = element_text(size = 18),
        plot.title = element_text(size = 20, hjust = 0.5)
    )


)

