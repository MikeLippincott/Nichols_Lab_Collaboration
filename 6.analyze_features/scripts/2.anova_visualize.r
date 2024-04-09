# load libraries
suppressWarnings(suppressPackageStartupMessages(library(ggplot2)))
suppressWarnings(suppressPackageStartupMessages(library(dplyr)))
suppressWarnings(suppressPackageStartupMessages(library(arrow)))
suppressWarnings(suppressPackageStartupMessages(library(patchwork)))
# import ggplot theme
source("../../utils/figure_themes.r")

# path to the anova data
anova_genotype_df_path <- file.path("..","..","data","6.analysis_results","anova_results_genotype.parquet")
anova_genotype_side_df_path <- file.path("..","..","data","6.analysis_results","anova_results_genotype_side.parquet")
anova_genotype_side_identity_df_path <- file.path("..","..","data","6.analysis_results","anova_results_genotype_side_identity.parquet")
data_path <- file.path("..","..","data","5.converted_data","normalized_feature_selected_output.parquet")

# read the data
data_df <- arrow::read_parquet(data_path)
head(data_df)

# read the anova data
anova_genotype_df <- arrow::read_parquet(anova_genotype_df_path)
anova_genotype_side_df <- arrow::read_parquet(anova_genotype_side_df_path)
anova_genotype_side_identity_df <- arrow::read_parquet(anova_genotype_side_identity_df_path)


anova_genotype_side_identity_df$log10_anova_p_value <- -log10(anova_genotype_side_identity_df$anova_p_value)
# order the results by log10 anova p-value
anova_genotype_side_identity_df <- anova_genotype_side_identity_df %>% arrange(log10_anova_p_value)
# split the feature into 3 groups at "_"
anova_genotype_side_identity_df$feature_type <- sapply(strsplit(anova_genotype_side_identity_df$feature, "_"), function(x) x[1])
anova_genotype_side_identity_df$feature_name <- sapply(strsplit(anova_genotype_side_identity_df$feature, "_"), function(x) x[2])
head(anova_genotype_side_identity_df)


width <- 20
height <- 10
options(repr.plot.width = width, repr.plot.height = height)
anova_plot <- (
    # order the results by log10 anova p-value
    ggplot(anova_genotype_side_identity_df, aes(y = reorder(feature, log10_anova_p_value), x = log10_anova_p_value, fill = feature_type))
    + geom_bar(stat = "identity")
    # drop y axis labels
    + theme(axis.text.x = element_text(angle = 90, hjust = 1))
    + labs(title = "ANOVA Analysis", y = "Feature", x = "-log10(ANOVA p-value)", fill = "Feature Type")

    + figure_theme


    + theme(axis.text.y = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank())
    + theme(axis.text.y = element_blank())
    + geom_hline(yintercept = length(unique(anova_genotype_side_identity_df$feature))-10, linetype = "dashed", color = "black")
    # custom x ticks
    + scale_x_continuous(breaks = c(0, 1000, 2000), labels = c("0", "1000", "2000"))

)
anova_plot
# save the plot
ggsave(file = "anova_plot.png", plot = anova_plot, path = file.path("..", "figures"), width = width, height = height, dpi = 600)

# load levene data in
levene_df_path <- file.path("..","..","data","6.analysis_results","levene_test_results.csv")
levene_df <- read.csv(levene_df_path)
head(levene_df)

width <- 4
height <- 4
options(repr.plot.width = width, repr.plot.height = height)
# make a new column for the group1 and group2
anova_genotype_side_identity_df$comparison <- paste(anova_genotype_side_identity_df$group1, anova_genotype_side_identity_df$group2, sep = " - ")

# order the results by anova p-value
anova_genotype_side_identity_df <- anova_genotype_side_identity_df %>% arrange(anova_p_value)
features <- unique(anova_genotype_side_identity_df$feature)[1:10]
features
top_10_anova_genotype_side_identity_df <- anova_genotype_side_identity_df %>% filter(feature %in% features)
top_10_anova_genotype_side_identity_df$log10_tukey_p_value <- -log10(top_10_anova_genotype_side_identity_df$`p-adj`)
# make the genotype a factor
# replace the genotype values
data_df$Metadata_genotype <- gsub("wt", "Wild Type", data_df$Metadata_genotype)
data_df$Metadata_genotype <- gsub("unsel", "Mid-Severity", data_df$Metadata_genotype)
data_df$Metadata_genotype <- gsub("high", "High-Severity", data_df$Metadata_genotype)
data_df$Metadata_genotype <- factor(
    data_df$Metadata_genotype,
    levels = c("Wild Type", "Mid-Severity", "High-Severity")
)
head(data_df)

width <- 8
height <- 8

list_of_genotype_side_identity_anova_plots_split_by_genotype <- list()
list_of_genotype_side_identity_anova_plots_split_by_genotype_side <- list()

for (i in 1:length(features)){
    print(features[i])
    # get the top feature
    tmp <- data_df %>% select(c("Metadata_genotype", "Metadata_identity", "Metadata_side", features[i]))
    # aggregate the data to get the mean and standard deviation of the top feature
    tmp <- tmp %>% group_by(Metadata_genotype) %>% summarise(mean = mean(!!as.name(features[i])), sd = sd(!!as.name(features[i])))
    # calculate the variance where variance = sd^2
    tmp$variance <- tmp$sd^2
    title <- gsub("_", " ", features[i])
    # plot the variability of the top feature
    var_plot <- (
        ggplot(tmp, aes(x = Metadata_genotype, y = variance, fill = Metadata_genotype))
        + geom_bar(stat = "identity")
        + theme(axis.text.x = element_text(angle = 90, hjust = 1))
        + labs(title = title, x = "Genotype", y = "Variance", fill = "Genotype")
        + theme_bw()
        + figure_theme
    )
    # save var plot
    ggsave(file = paste0(features[i], "_variance_plot_genotype.png"), plot = var_plot, path = file.path("..", "figures"), width = width, height = height, dpi = 600)

    list_of_genotype_side_identity_anova_plots_split_by_genotype[[i]] <- var_plot
    # get the top feature
    tmp <- data_df %>% select(c("Metadata_genotype", "Metadata_identity", "Metadata_side", features[i]))
    # aggregate the data to get the mean and standard deviation of the top feature
    tmp <- tmp %>% group_by(Metadata_genotype, Metadata_side) %>% summarise(mean = mean(!!as.name(features[i])), sd = sd(!!as.name(features[i])))
    # calculate the variance where variance = sd^2
    tmp$variance <- tmp$sd^2
    # plot the variability of the top feature
    var_plot <- (
        ggplot(tmp, aes(x = Metadata_genotype, y = variance, fill = Metadata_side))
        + geom_bar(stat = "identity", position = "dodge")
        + theme(axis.text.x = element_text(angle = 90, hjust = 1))
        + labs(title = title, x = "Genotype", y = "Variance", fill = "Side")

        + theme_bw()
        + figure_theme
    )
    # save var plot
    ggsave(file = paste0(features[i], "_variance_plot_genotype_side.png"), plot = var_plot, path = file.path("..", "figures"), width = width, height = height, dpi = 600)

    list_of_genotype_side_identity_anova_plots_split_by_genotype_side[[i]] <- var_plot
}

# filter the anova results to only include the top 10 features
top_10_anova_genotype_df <- anova_genotype_df %>% filter(feature %in% features)
top_10_anova_genotype_df$`p-adj` <- abs(top_10_anova_genotype_df$`p-adj`)

# list_of_genotype_side_identity_anova_plots_split_by_genotype[[1]]
# # add significance to the plot
# library(ggsignif)


# load in the unormalized data
df_path <- file.path("..","..","data","5.converted_data","output.parquet")
df <- arrow::read_parquet(df_path)
# split the Metadata_Image_FileName into the genotype, and side
df$Metadata_genotype <- sapply(strsplit(df$Metadata_Image_FileName_OP, "_"), function(x) x[2])
df$Metadata_side <- sapply(strsplit(df$Metadata_Image_FileName_OP, "_"), function(x) x[4])
df$Metadata_side <- gsub(".tiff", "", df$Metadata_side)
df <- df %>% select(c("Metadata_genotype", "Metadata_identity", "Metadata_side", "Neighbors_FirstClosestDistance_Adjacent"))
# manually correct the high genotype to be 0 for the Neighbors_FirstClosestDistance_Adjacent feature
df$Neighbors_FirstClosestDistance_Adjacent[df$Metadata_genotype == "high"] <- 0

# units are in pixels so convert to microns
resolution = 1.6585 # pixels per micron
df$Neighbors_FirstClosestDistance_Adjacent <- df$Neighbors_FirstClosestDistance_Adjacent / resolution
df$Metadata_genotype <- gsub("wt", "Wild Type", df$Metadata_genotype)
df$Metadata_genotype <- gsub("unsel", "Mid-Severity", df$Metadata_genotype)
df$Metadata_genotype <- gsub("high", "High-Severity", df$Metadata_genotype)
df$Metadata_genotype <- factor(
    df$Metadata_genotype,
    levels = c("Wild Type", "Mid-Severity", "High-Severity")
)

head(df)

# plot
width <- 10
height <- 8
options(repr.plot.width = width, repr.plot.height = height)
# reorder the genotype factor
distance_plot <- (
    ggplot(df, aes(
        # reorder the genotype factor
        y = reorder(Metadata_genotype, Neighbors_FirstClosestDistance_Adjacent),
        x = Neighbors_FirstClosestDistance_Adjacent, fill = Metadata_genotype))
    + geom_boxplot()
    + theme(axis.text.x = element_text(angle = 90, hjust = 1))
    + labs(title = "Distance between OP and Br", x = "Distance (um)", y = "Genotype", fill = "Genotype")
    + theme_bw()
    + figure_theme
    # drop legend
    + theme(legend.position = "none")
)
distance_plot
# save the plot
ggsave(file = "distance_plot_genotype.png", plot = distance_plot, path = file.path("..", "figures"), width = width, height = height, dpi = 600)

# reorder the genotype factor
df$Metadata_genotype <- factor(df$Metadata_genotype, levels = c("Wild Type", "Mid-Severity", "High-Severity"))
# plot the variance of the Neighbors_FirstClosestDistance_Adjacent feature
tmp <- df %>% group_by(Metadata_genotype) %>% summarise(mean = mean(Neighbors_FirstClosestDistance_Adjacent), sd = sd(Neighbors_FirstClosestDistance_Adjacent))
tmp$variance <- tmp$sd^2
var_plot <- (
    ggplot(tmp, aes(x = Metadata_genotype, y = variance, fill = Metadata_genotype))
    + geom_bar(stat = "identity")
    + theme(axis.text.x = element_text(angle = 90, hjust = 1))
    + labs(title = "Variance of distance between OP and Br", x = "Genotype", y = "Variance (um)", fill = "Genotype")
    + theme_bw()
    + figure_theme
    + theme(legend.position = "none")
)
var_plot
# save the plot
ggsave(file = "distance_variance_plot_genotype.png", plot = var_plot, path = file.path("..", "figures"), width = width, height = height, dpi = 600)

width <- 17
height <- 15
options(repr.plot.width = width, repr.plot.height = height)
# remove the legend from each plot
var_plot <- var_plot + theme(legend.position = "none")
distance_plot <- distance_plot + theme(legend.position = "none")
list_of_genotype_side_identity_anova_plots_split_by_genotype[[1]] <- list_of_genotype_side_identity_anova_plots_split_by_genotype[[1]] + theme(legend.position = "none")
list_of_genotype_side_identity_anova_plots_split_by_genotype[[2]] <- list_of_genotype_side_identity_anova_plots_split_by_genotype[[2]] + theme(legend.position = "none")
list_of_genotype_side_identity_anova_plots_split_by_genotype[[3]] <- list_of_genotype_side_identity_anova_plots_split_by_genotype[[3]] + theme(legend.position = "none")
list_of_genotype_side_identity_anova_plots_split_by_genotype[[5]] <- list_of_genotype_side_identity_anova_plots_split_by_genotype[[5]] + theme(legend.position = "none")
list_of_genotype_side_identity_anova_plots_split_by_genotype[[8]] <- list_of_genotype_side_identity_anova_plots_split_by_genotype[[8]] + theme(legend.position = "none")

layout <- c(
    area(t=1, b=1, l=1, r=1),
    area(t=1, b=1, l=2, r=2),
    area(t=1, b=1, l=3, r=3),
    area(t=2, b=2, l=1, r=1),
    area(t=2, b=2, l=2, r=2),
    area(t=2, b=2, l=3, r=3),
    area(t=3, b=3, l=1, r=1),
    area(t=3, b=3, l=2, r=3)
)


final_plot <- (
    wrap_elements(full = anova_plot)
    + list_of_genotype_side_identity_anova_plots_split_by_genotype[[1]]
    + list_of_genotype_side_identity_anova_plots_split_by_genotype[[2]]
    + list_of_genotype_side_identity_anova_plots_split_by_genotype[[3]]
    + list_of_genotype_side_identity_anova_plots_split_by_genotype[[5]]
    + list_of_genotype_side_identity_anova_plots_split_by_genotype[[8]]
    + var_plot
    + distance_plot
    + plot_layout(design = layout)
    + plot_annotation(tag_levels = "A") & theme(plot.tag = element_text(size = 20))

)

# make the figures path if it doesn't exist
if (!dir.exists("../figures/")){
    dir.create("../figures/", showWarnings = FALSE)
}
png("../figures/final_plot.png", width = width, height = height, units = "in", res = 600)
final_plot
dev.off()
final_plot
