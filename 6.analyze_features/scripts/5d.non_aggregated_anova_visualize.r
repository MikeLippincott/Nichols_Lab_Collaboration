# load libraries
suppressWarnings(suppressPackageStartupMessages(library(ggplot2)))
suppressWarnings(suppressPackageStartupMessages(library(dplyr)))
suppressWarnings(suppressPackageStartupMessages(library(arrow)))
suppressWarnings(suppressPackageStartupMessages(library(patchwork)))
# import ggplot theme
source("../../utils/figure_themes.r")

# path to the anova data
non_aggregated_anova_genotype_df_path <- file.path("..","..","data","6.analysis_results","non_aggregated_anova_results.parquet")
non_aggregated_data_path <- file.path("..","..","data","5.converted_data","non_aggregated_data.parquet")
fig_path <- file.path("..","figures","non_aggregated")
# create the figure directory if it does not exist
if (!dir.exists(fig_path)){
  dir.create(fig_path, recursive = TRUE)
}

# read the data
non_aggregated_data_df <- arrow::read_parquet(non_aggregated_data_path)
head(non_aggregated_data_df)

# read the anova data
non_aggregated_anova_df <- arrow::read_parquet(non_aggregated_anova_genotype_df_path)



non_aggregated_anova_df$log10_anova_p_value <- -log10(non_aggregated_anova_df$anova_p_value)
# order the results by log10 anova p-value
non_aggregated_anova_df <- non_aggregated_anova_df %>% arrange(log10_anova_p_value)
# split the feature into 3 groups at "_"
non_aggregated_anova_df$feature_type <- sapply(strsplit(non_aggregated_anova_df$feature, "_"), function(x) x[1])
non_aggregated_anova_df$feature_name <- sapply(strsplit(non_aggregated_anova_df$feature, "_"), function(x) x[2])
head(non_aggregated_anova_df)


width <- 20
height <- 10
options(repr.plot.width = width, repr.plot.height = height)
anova_plot <- (
    # order the results by log10 anova p-value
    ggplot(non_aggregated_anova_df, aes(y = reorder(feature, log10_anova_p_value), x = log10_anova_p_value, fill = feature_type))
    + geom_bar(stat = "identity")
    # drop y axis labels
    + theme(axis.text.x = element_text(angle = 90, hjust = 1))
    + labs(title = "ANOVA Analysis", y = "Feature", x = "-log10(ANOVA p-value)", fill = "Feature Type")

    + figure_theme


    + theme(axis.text.y = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank())
    + theme(axis.text.y = element_blank())
    + geom_hline(yintercept = length(unique(non_aggregated_anova_df$feature))-10, linetype = "dashed", color = "black")

)
anova_plot
# save the plot
ggsave(file = "non_aggregatednova_plot.png", plot = anova_plot, path = file.path(fig_path), width = width, height = height, dpi = 600)

# load levene data in
non_aggregated_levene_df_path <- file.path("..","..","data","6.analysis_results","non_aggregated_levene_test_results.csv")
non_aggregated_levene_df <- read.csv(non_aggregated_levene_df_path)
head(non_aggregated_levene_df)

width <- 4
height <- 4
options(repr.plot.width = width, repr.plot.height = height)
# make a new column for the group1 and group2
non_aggregated_anova_df$comparison <- paste(non_aggregated_anova_df$group1, non_aggregated_anova_df$group2, sep = " - ")

# order the results by anova p-value
non_aggregated_anova_df <- non_aggregated_anova_df %>% arrange(anova_p_value)
features <- unique(non_aggregated_anova_df$feature)[1:20]
features
top_20_non_aggregated_anova_df <- non_aggregated_anova_df %>% filter(feature %in% features)
top_20_non_aggregated_anova_df$log10_tukey_p_value <- -log10(top_20_non_aggregated_anova_df$`p-adj`)
# make the genotype a factor
# replace the genotype values
non_aggregated_data_df$Metadata_genotype <- gsub("wt", "Wild Type", non_aggregated_data_df$Metadata_genotype)
non_aggregated_data_df$Metadata_genotype <- gsub("unsel", "Mid-Severity", non_aggregated_data_df$Metadata_genotype)
non_aggregated_data_df$Metadata_genotype <- gsub("high", "High-Severity", non_aggregated_data_df$Metadata_genotype)
non_aggregated_data_df$Metadata_genotype <- factor(
    non_aggregated_data_df$Metadata_genotype,
    levels = c("Wild Type", "Mid-Severity", "High-Severity")
)
head(non_aggregated_data_df)

width <- 8
height <- 8

list_of_genotype_anova_plots_by_genotype <- list()

for (i in 1:length(features)){
    print(features[i])
    # get the top feature
    tmp <- non_aggregated_data_df %>% select(c("Metadata_genotype", features[i]))
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
    ggsave(file = paste0("non_aggregated_", features[i], "_variance_plot_genotype.png"), plot = var_plot, path = file.path(fig_path), width = width, height = height, dpi = 600)

    list_of_genotype_anova_plots_by_genotype[[i]] <- var_plot
}
