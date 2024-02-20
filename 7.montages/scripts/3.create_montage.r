library(ggplot2)
library(dplyr)
library(tidyr)
library(patchwork)
library(stringr)

image_paths <- file.path("..","..","data","7.montage_images","individual_images")


# get the list of images in the directory
list_of_images <- list.files(image_paths, full.names = TRUE)
list_of_images

path <- "../../data/7.montage_images/individual_images/MAX_high_10_L.png"

width <- 2
height <- 2
options(repr.plot.width = width, repr.plot.height = height)
# define function to return the image object
get_image <- function(path){
    # Load the PNG file
    img <- png::readPNG(path)
    # Convert the image to a raster object
    g <- grid::rasterGrob(img, interpolate=TRUE)

    # Create a ggplot
    p <- ggplot() +
    annotation_custom(g, xmin=-Inf, xmax=Inf, ymin=-Inf, ymax=Inf) +
    theme_void() + # Remove axes and labels
    theme(plot.background = element_rect(fill = "#131313")) # Change the background color
    # Print the plot
    return(p)
}


length(list_of_images)

# split the list of images into 2 lists if it is L or R
L_images <- list_of_images[str_detect(list_of_images, "L")]
R_images <- list_of_images[str_detect(list_of_images, "R")]
# split the list by genotype
L_images_WT <- L_images[str_detect(L_images, "wt")]
L_images_unsel <- L_images[str_detect(L_images, "unsel")]
L_images_high <- L_images[str_detect(L_images, "high")]
R_images_WT <- R_images[str_detect(R_images, "wt")]
R_images_unsel <- R_images[str_detect(R_images, "unsel")]
R_images_high <- R_images[str_detect(R_images, "high")]

L_WT_plots <- lapply(L_images_WT, get_image)
L_unsel_plots <- lapply(L_images_unsel, get_image)
L_high_plots <- lapply(L_images_high, get_image)
R_WT_plots <- lapply(R_images_WT, get_image)
R_unsel_plots <- lapply(R_images_unsel, get_image)
R_high_plots <- lapply(R_images_high, get_image)


# check list lengths
print(length(L_WT_plots))
print(length(R_WT_plots))
print(length(L_unsel_plots))
print(length(R_unsel_plots))
print(length(L_high_plots))
print(length(R_high_plots))
# check list imbalance
L_images_unsel
R_images_unsel
# drop the third item in R_unsel_plots to keep the lists balanced and paired
R_unsel_plots <- R_unsel_plots[-3]
R_images_unsel

# patch the plots together to make a montage
width <- 8
height <- 5
options(repr.plot.width = width, repr.plot.height = height)


montage_high <- (
    L_high_plots[[1]] + R_high_plots[[1]] + L_high_plots[[2]] + R_high_plots[[2]] + L_high_plots[[3]] + R_high_plots[[3]] + L_high_plots[[4]] + R_high_plots[[4]] + L_high_plots[[5]] + R_high_plots[[5]]
    + L_high_plots[[6]] + R_high_plots[[6]] + L_high_plots[[7]] + R_high_plots[[7]] + L_high_plots[[8]] + R_high_plots[[8]] + L_high_plots[[9]] + R_high_plots[[9]] + L_high_plots[[10]] + R_high_plots[[10]]
    + L_high_plots[[11]] + R_high_plots[[11]] + L_high_plots[[12]] + R_high_plots[[12]] + L_high_plots[[13]] + R_high_plots[[13]] + L_high_plots[[14]] + R_high_plots[[14]]
    + plot_layout(ncol = 7, widths = c(1, 1, 1, 1, 1, 1, 1))
)
# save each montage as a png
png(file.path("..","..","data","7.montage_images","montage_high.png"), width = width, height = height, units = "in", res = 600)
montage_high
dev.off()
montage_high



montage_unsel <- (
    L_unsel_plots[[1]] + R_unsel_plots[[1]] + L_unsel_plots[[2]] + R_unsel_plots[[2]] + L_unsel_plots[[3]] + R_unsel_plots[[3]] + L_unsel_plots[[4]] + R_unsel_plots[[4]] + L_unsel_plots[[5]] + R_unsel_plots[[5]]
    + L_unsel_plots[[6]] + R_unsel_plots[[6]] + L_unsel_plots[[7]] + R_unsel_plots[[7]] + L_unsel_plots[[8]] + R_unsel_plots[[8]] + L_unsel_plots[[9]] + R_unsel_plots[[9]] + L_unsel_plots[[10]] + R_unsel_plots[[10]]
    + L_unsel_plots[[11]] + R_unsel_plots[[11]] + L_unsel_plots[[12]] + R_unsel_plots[[12]] + L_unsel_plots[[13]] + R_unsel_plots[[13]]
    + plot_layout(ncol = 7)
)

png(file.path("..","..","data","7.montage_images","montage_unsel.png"), width = width, height = height, units = "in", res = 600)
montage_unsel
dev.off()
montage_unsel


montage_wt <- (
    L_WT_plots[[1]] + R_WT_plots[[1]] + L_WT_plots[[2]] + R_WT_plots[[2]] + L_WT_plots[[3]] + R_WT_plots[[3]] + L_WT_plots[[4]] + R_WT_plots[[4]] + L_WT_plots[[5]] + R_WT_plots[[5]]
    + L_WT_plots[[6]] + R_WT_plots[[6]] + L_WT_plots[[7]] + R_WT_plots[[7]] + L_WT_plots[[8]] + R_WT_plots[[8]] + L_WT_plots[[9]] + R_WT_plots[[9]] + L_WT_plots[[10]] + R_WT_plots[[10]]
    + L_WT_plots[[11]] + R_WT_plots[[11]] + L_WT_plots[[12]] + R_WT_plots[[12]] + L_WT_plots[[13]] + R_WT_plots[[13]] + L_WT_plots[[14]] + R_WT_plots[[14]]
    + plot_layout(ncol = 7)
)
png(file.path("..","..","data","7.montage_images","montage_wt.png"), width = width, height = height, units = "in", res = 600)
montage_wt
dev.off()

montage_wt
