# load libraries
suppressWarnings(suppressPackageStartupMessages(library(ggplot2)))
suppressWarnings(suppressPackageStartupMessages(library(dplyr)))
suppressWarnings(suppressPackageStartupMessages(library(arrow)))
suppressWarnings(suppressPackageStartupMessages(library(patchwork)))
suppressWarnings(suppressPackageStartupMessages(library(ggsignif)))
# import ggplot theme
source("../../utils/figure_themes.r")

# path to the anova data
anova_genotype_df_path <- file.path("..","..","data","6.analysis_results","sum_aggregated_anova_results.parquet")
sum_aggregated_data_path <- file.path("..","..","data","5.converted_data","sum_aggregated_data.parquet")
fig_path <- file.path("..","figures","sum_aggregated")
# make the directory if it doesn't exist
if (!dir.exists(fig_path)) dir.create(fig_path)

# read the data
sum_aggregated_data <- arrow::read_parquet(sum_aggregated_data_path)
head(sum_aggregated_data)

# read the anova data
anova_genotype_df <- arrow::read_parquet(anova_genotype_df_path)

# load levene data in
levene_df_path <- file.path("..","..","data","6.analysis_results","sum_aggregated_levene_test_results.csv")
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

head(anova_genotype_df)

width <- 4
height <- 4
options(repr.plot.width = width, repr.plot.height = height)
# make a new column for the group1 and group2
anova_genotype_df$comparison <- paste(anova_genotype_df$group1, anova_genotype_df$group2, sep = " - ")

# order the results by anova p-value
anova_genotype_df <- anova_genotype_df %>% arrange(anova_p_value)
features <- unique(anova_genotype_df$feature)[1:20]
features
top_10_anova_genotype_df <- anova_genotype_df %>% filter(feature %in% features)
top_10_anova_genotype_df$log10_tukey_p_value <- -log10(top_10_anova_genotype_df$`p-adj`)
# make the genotype a factor
# replace the genotype values
sum_aggregated_data$Metadata_genotype <- gsub("wt", "Wild Type", sum_aggregated_data$Metadata_genotype)
sum_aggregated_data$Metadata_genotype <- gsub("unsel", "Mid-Severity", sum_aggregated_data$Metadata_genotype)
sum_aggregated_data$Metadata_genotype <- gsub("high", "High-Severity", sum_aggregated_data$Metadata_genotype)
sum_aggregated_data$Metadata_genotype <- factor(
    sum_aggregated_data$Metadata_genotype,
    levels = c("Wild Type", "Mid-Severity", "High-Severity")
)
head(sum_aggregated_data)
# add features to the features list
features <- c(
    features,
    'AreaShape_HuMoment_0',
    'AreaShape_HuMoment_1',
    'AreaShape_HuMoment_2',
    'AreaShape_HuMoment_3',
    'AreaShape_HuMoment_4',
    'AreaShape_HuMoment_5',
    'AreaShape_HuMoment_6'
)

width <- 10
height <- 8

list_of_sum_aggregated_feature_plots <- list()

for (i in 1:length(features)){
    print(features[i])
    # get the top feature
    tmp <- sum_aggregated_data %>% select(c("Metadata_genotype", features[i]))
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
        ggplot(tmp, aes(x = Metadata_genotype, y = variance, fill = Metadata_genotype))
        + geom_bar(stat = "identity")
        + theme(axis.text.x = element_text(angle = 90, hjust = 1))
        + labs(title = title, x = "Genotype", y = "Variance", fill = "Genotype")
        + theme_bw()
        + figure_theme
        # + ylim(0,1)
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
            # y_position = c(0.9, 0.99)
        )
        # remove the legend
        + theme(legend.position = "none")
    )
    # save var plot
    ggsave(file = paste0("sum_aggregated_",features[i], "_variance_plot.png"), plot = var_plot, path = file.path(fig_path), width = width, height = height, dpi = 600)

    list_of_sum_aggregated_feature_plots[[i]] <- var_plot
}

width <- 10
height <- 8
options(repr.plot.width = width, repr.plot.height = height)
list_of_sum_aggregated_feature_plots[[1]]
list_of_sum_aggregated_feature_plots[[2]]
list_of_sum_aggregated_feature_plots[[3]]
list_of_sum_aggregated_feature_plots[[4]]
list_of_sum_aggregated_feature_plots[[5]]
list_of_sum_aggregated_feature_plots[[6]]
list_of_sum_aggregated_feature_plots[[7]]
list_of_sum_aggregated_feature_plots[[8]]
list_of_sum_aggregated_feature_plots[[9]]
list_of_sum_aggregated_feature_plots[[10]]
list_of_sum_aggregated_feature_plots[[11]]
list_of_sum_aggregated_feature_plots[[12]]
list_of_sum_aggregated_feature_plots[[13]]
list_of_sum_aggregated_feature_plots[[14]]
list_of_sum_aggregated_feature_plots[[15]]
list_of_sum_aggregated_feature_plots[[16]]
list_of_sum_aggregated_feature_plots[[17]]
list_of_sum_aggregated_feature_plots[[18]]
list_of_sum_aggregated_feature_plots[[19]]
list_of_sum_aggregated_feature_plots[[20]]

