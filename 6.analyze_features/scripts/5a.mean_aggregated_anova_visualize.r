# load libraries
suppressWarnings(suppressPackageStartupMessages(library(ggplot2)))
suppressWarnings(suppressPackageStartupMessages(library(dplyr)))
suppressWarnings(suppressPackageStartupMessages(library(arrow)))
suppressWarnings(suppressPackageStartupMessages(library(patchwork)))
suppressWarnings(suppressPackageStartupMessages(library(ggsignif)))
# import ggplot theme
source("../../utils/figure_themes.r")

# path to the anova data
mean_aggregated_anova_genotype_df_path <- file.path("..","..","data","6.analysis_results","mean_aggregated_anova_results.parquet")
mean_aggregated_data_path <- file.path("..","..","data","5.converted_data","mean_aggregated_data.parquet")
fig_path <- file.path("..","figures","mean_aggregated")
# create the figure directory if it does not exist
if (!dir.exists(fig_path)){
  dir.create(fig_path, recursive = TRUE)
}

# read the data
mean_aggregated_data_df <- arrow::read_parquet(mean_aggregated_data_path)
head(mean_aggregated_data_df)

# read the anova data
mean_aggregated_anova_df <- arrow::read_parquet(mean_aggregated_anova_genotype_df_path)



mean_aggregated_anova_df$log10_anova_p_value <- -log10(mean_aggregated_anova_df$anova_p_value)
# order the results by log10 anova p-value
mean_aggregated_anova_df <- mean_aggregated_anova_df %>% arrange(log10_anova_p_value)
# split the feature into 3 groups at "_"
mean_aggregated_anova_df$feature_type <- sapply(strsplit(mean_aggregated_anova_df$feature, "_"), function(x) x[1])
mean_aggregated_anova_df$feature_name <- sapply(strsplit(mean_aggregated_anova_df$feature, "_"), function(x) x[2])
head(mean_aggregated_anova_df)


width <- 20
height <- 10
options(repr.plot.width = width, repr.plot.height = height)
anova_plot <- (
    # order the results by log10 anova p-value
    ggplot(mean_aggregated_anova_df, aes(y = reorder(feature, log10_anova_p_value), x = log10_anova_p_value, fill = feature_type))
    + geom_bar(stat = "identity")
    # drop y axis labels
    + theme(axis.text.x = element_text(angle = 90, hjust = 1))
    + labs(title = "ANOVA Analysis", y = "Feature", x = "-log10(ANOVA p-value)", fill = "Feature Type")

    + figure_theme


    + theme(axis.text.y = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank())
    + theme(axis.text.y = element_blank())
    + geom_hline(yintercept = length(unique(mean_aggregated_anova_df$feature))-10, linetype = "dashed", color = "black")

)
anova_plot
# save the plot
ggsave(file = "mean_aggregated_anova_plot.png", plot = anova_plot, path = file.path(fig_path), width = width, height = height, dpi = 600)

# load levene data in
mean_aggregated_levene_df_path <- file.path("..","..","data","6.analysis_results","mean_aggregated_levene_test_results.csv")
mean_aggregated_levene_df <- read.csv(mean_aggregated_levene_df_path)
# make a new column for ***
mean_aggregated_levene_df$significance <- ifelse(
    mean_aggregated_levene_df$levene_p_value < 0.001, "***",
    ifelse(mean_aggregated_levene_df$levene_p_value < 0.01, "**",
    ifelse(mean_aggregated_levene_df$levene_p_value < 0.05, "*",
    "ns")
    )
)
head(mean_aggregated_levene_df)

width <- 4
height <- 4
options(repr.plot.width = width, repr.plot.height = height)
# make a new column for the group1 and group2
mean_aggregated_anova_df$comparison <- paste(mean_aggregated_anova_df$group1, mean_aggregated_anova_df$group2, sep = " - ")

# order the results by anova p-value
mean_aggregated_anova_df <- mean_aggregated_anova_df %>% arrange(anova_p_value)
features <- unique(mean_aggregated_anova_df$feature)[1:20]
features
top_20_mean_aggregated_anova_df <- mean_aggregated_anova_df %>% filter(feature %in% features)
top_20_mean_aggregated_anova_df$log10_tukey_p_value <- -log10(top_20_mean_aggregated_anova_df$`p-adj`)
# make the genotype a factor
# replace the genotype values
mean_aggregated_data_df$Metadata_genotype <- gsub("wt", "Wild Type", mean_aggregated_data_df$Metadata_genotype)
mean_aggregated_data_df$Metadata_genotype <- gsub("unsel", "Mid-Severity", mean_aggregated_data_df$Metadata_genotype)
mean_aggregated_data_df$Metadata_genotype <- gsub("high", "High-Severity", mean_aggregated_data_df$Metadata_genotype)
mean_aggregated_data_df$Metadata_genotype <- factor(
    mean_aggregated_data_df$Metadata_genotype,
    levels = c("Wild Type", "Mid-Severity", "High-Severity")
)
head(mean_aggregated_data_df)

width <- 8
height <- 8

list_of_genotype_anova_plots_by_genotype <- list()

for (i in 1:length(features)){
    print(features[i])
    # get the top feature
    tmp <- mean_aggregated_data_df %>% select(c("Metadata_genotype", features[i]))
    # aggregate the data to get the mean and standard deviation of the top feature
    tmp <- tmp %>% group_by(Metadata_genotype) %>% summarise(mean = mean(!!as.name(features[i])), sd = sd(!!as.name(features[i])))

    # get the levene test result for the selected feature
    tmp_levene <- mean_aggregated_levene_df %>% filter(feature == features[i])
    WT_vs_high_significance <- tmp_levene %>% filter(group == "high_vs_unsel")
    WT_vs_unsel_significance <- tmp_levene %>% filter(group == "unsel_vs_wt")
    unsel_vs_high_significance <- tmp_levene %>% filter(group == "high_vs_wt")
    WT_vs_high_significance <- WT_vs_high_significance$significance
    WT_vs_unsel_significance <- WT_vs_unsel_significance$significance
    unsel_vs_high_significance <- unsel_vs_high_significance$significance

    # calculate the variance where variance = sd^2
    tmp$variance <- tmp$sd^2
    title <- gsub("_", " ", features[i])

    # get the max value of the variance
    max_var <- max(tmp$variance)
    # add 0.3 to the max value to get the y max
    max_var_plot <- max_var + 0.4


    # plot the variability of the top feature
    var_plot <- (
        ggplot(tmp, aes(x = Metadata_genotype, y = variance, fill = Metadata_genotype))
        + geom_bar(stat = "identity")
        + theme(axis.text.x = element_text(angle = 90, hjust = 1))
        + labs(title = title, x = "Genotype", y = "Variance", fill = "Genotype")
        + theme_bw()
        + figure_theme

        + geom_signif(
            comparisons = list(c("High-Severity","Mid-Severity")),
            annotations = unsel_vs_high_significance,
            textsize = 7,
            y_position = c(max_var+0.1, max_var+0.15)
            )
        + geom_signif(
            comparisons = list(c("Wild Type","Mid-Severity")),
            annotations = WT_vs_unsel_significance,
            textsize = 7,
            y_position = c(max_var+0.1, max_var+0.15)
            )
        + geom_signif(
            comparisons = list(c("High-Severity","Wild Type")),
            annotations = WT_vs_high_significance,
            textsize = 7,
            y_position = c(max_var+0.2, max_var+0.25)
        )
           # remove the legend
        + theme(legend.position = "none")
        + ylim(0,max_var_plot)
    )
    # save var plot
    ggsave(file = paste0("mean_aggregated_", features[i], "_variance_plot_genotype.png"), plot = var_plot, path = file.path(fig_path), width = width, height = height, dpi = 600)

    list_of_genotype_anova_plots_by_genotype[[i]] <- var_plot
}

width <- 10
height <- 4
options(repr.plot.width = width, repr.plot.height = height)
list_of_genotype_anova_plots_by_genotype[[1]]
list_of_genotype_anova_plots_by_genotype[[2]]
list_of_genotype_anova_plots_by_genotype[[3]]
list_of_genotype_anova_plots_by_genotype[[4]]
list_of_genotype_anova_plots_by_genotype[[5]]
list_of_genotype_anova_plots_by_genotype[[6]]
list_of_genotype_anova_plots_by_genotype[[7]]
list_of_genotype_anova_plots_by_genotype[[8]]
list_of_genotype_anova_plots_by_genotype[[9]]
list_of_genotype_anova_plots_by_genotype[[10]]
list_of_genotype_anova_plots_by_genotype[[11]]
list_of_genotype_anova_plots_by_genotype[[12]]
list_of_genotype_anova_plots_by_genotype[[13]]
list_of_genotype_anova_plots_by_genotype[[14]]
list_of_genotype_anova_plots_by_genotype[[15]]
list_of_genotype_anova_plots_by_genotype[[16]]
list_of_genotype_anova_plots_by_genotype[[17]]
list_of_genotype_anova_plots_by_genotype[[18]]
list_of_genotype_anova_plots_by_genotype[[19]]
list_of_genotype_anova_plots_by_genotype[[20]]

