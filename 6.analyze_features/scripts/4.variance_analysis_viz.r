# load libraries
suppressWarnings(suppressPackageStartupMessages(library(ggplot2)))
suppressWarnings(suppressPackageStartupMessages(library(dplyr)))
suppressWarnings(suppressPackageStartupMessages(library(arrow)))
suppressWarnings(suppressPackageStartupMessages(library(patchwork)))
suppressWarnings(suppressPackageStartupMessages(library(ggsignif)))
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

# load levene data in
levene_df_path <- file.path("..","..","data","6.analysis_results","levene_test_results.csv")
levene_df <- read.csv(levene_df_path)
# make a new column for ***
levene_df$significance <- ifelse(
    levene_df$levene_p_value < 0.001, "***",
    ifelse(levene_df$levene_p_value < 0.01, "**",
    ifelse(levene_df$levene_p_value < 0.05, "*",
    "ns")
    )
)
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

width <- 10
height <- 8

list_of_genotype_side_identity_anova_plots_split_by_genotype <- list()
list_of_genotype_side_identity_anova_plots_split_by_genotype_side <- list()

for (i in 1:length(features)){
    print(features[i])
    # get the top feature
    tmp <- data_df %>% select(c("Metadata_genotype", "Metadata_identity", "Metadata_side", features[i]))
    # aggregate the data to get the mean and standard deviation of the top feature
    tmp <- tmp %>% group_by(Metadata_genotype) %>% summarise(mean = mean(!!as.name(features[i])), sd = sd(!!as.name(features[i])))
    # get the AreaShape_ConvexArea feature
    tmp_df <- levene_df %>% filter(feature == features[i])
    # get the high_vs_unselected significance
    high_vs_unselected_significance <- tmp_df %>% filter(group == "high_vs_unsel")
    high_vs_unselected_significance <- high_vs_unselected_significance$significance
    WT_vs_unselected_significance <- tmp_df %>% filter(group == "unsel_vs_wt")
    WT_vs_unselected_significance <- WT_vs_unselected_significance$significance
    WT_vs_high_significance <- tmp_df %>% filter(group == "high_vs_wt")
    WT_vs_high_significance <- WT_vs_high_significance$significance
    all_significance <- tmp_df %>% filter(group == "all")
    all_significance <- all_significance$significance


    # calculate the variance where variance = sd^2
    tmp$variance <- tmp$sd^2
    title <- gsub("_", " ", features[i])
    # plot the variability of the top feature
    var_plot <- (
        ggplot(tmp, aes(x = Metadata_genotype, y = variance))
        + geom_bar(stat = "identity")
        + theme(axis.text.x = element_text(angle = 90, hjust = 1))
        + labs(title = title, x = "Genotype", y = "Variance", fill = "Genotype")
        + theme_bw()
        + figure_theme
        + ylim(0,1)
        # add significance bars
        + geom_signif(
            comparisons = list(c("High-Severity","Mid-Severity")),
            annotations = high_vs_unselected_significance,
            textsize = 7
        )
        + geom_signif(
            comparisons = list(c("Wild Type","Mid-Severity")),
            annotations = WT_vs_unselected_significance,
            textsize = 7
        )
        + geom_signif(
            comparisons = list(c("High-Severity","Wild Type")),
            annotations = WT_vs_high_significance,
            textsize = 7,
            vjust = 0.1,
            y_position = c(0.9, 0.99)
        )
        # remove the legend
        + theme(legend.position = "none")
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

width <- 10
height <- 8
options(repr.plot.width = width, repr.plot.height = height)
list_of_genotype_side_identity_anova_plots_split_by_genotype[[1]]
list_of_genotype_side_identity_anova_plots_split_by_genotype[[2]]
list_of_genotype_side_identity_anova_plots_split_by_genotype[[3]]
list_of_genotype_side_identity_anova_plots_split_by_genotype[[4]]
list_of_genotype_side_identity_anova_plots_split_by_genotype[[5]]
list_of_genotype_side_identity_anova_plots_split_by_genotype[[6]]
list_of_genotype_side_identity_anova_plots_split_by_genotype[[7]]
list_of_genotype_side_identity_anova_plots_split_by_genotype[[8]]
list_of_genotype_side_identity_anova_plots_split_by_genotype[[9]]
list_of_genotype_side_identity_anova_plots_split_by_genotype[[10]]

