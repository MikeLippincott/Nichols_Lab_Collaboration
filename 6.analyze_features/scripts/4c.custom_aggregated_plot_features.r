# load libraries
suppressWarnings(suppressPackageStartupMessages(library(ggplot2)))
suppressWarnings(suppressPackageStartupMessages(library(tidyr)))
suppressWarnings(suppressPackageStartupMessages(library(tidyverse)))
suppressWarnings(suppressPackageStartupMessages(library(dplyr)))
suppressWarnings(suppressPackageStartupMessages(library(arrow)))
suppressWarnings(suppressPackageStartupMessages(library(patchwork)))
suppressWarnings(suppressPackageStartupMessages(library(ggsignif)))
# import ggplot theme
source("../../utils/figure_themes.r")

# set path to read the data
output_var_stats_path <- file.path("..","..","data","6.analysis_results","custom_aggregated_variance_results_feature_types_stats.csv")
output_var_path <- file.path("..","..","data","6.analysis_results","custom_aggregated_variance_results_feature_types.csv")
output_levene_path <- file.path("..","..","data","6.analysis_results","custom_aggregated_levene_test_results_feature_types.csv")
raw_features_path <- file.path("..","..","data", "5.converted_data","custom_aggregated_data.parquet")

# figures output path
fig_path <- file.path("..","figures","custom_aggregated")
# make the directory if it doesn't exist
if (!dir.exists(fig_path)){
  dir.create(fig_path, recursive = TRUE)
}

# read the data
variance_stats_df <- read.csv(output_var_stats_path)
variance_df <- read.csv(output_var_path)
levene_df <- read.csv(output_levene_path)
raw_features_df <- arrow::read_parquet(raw_features_path)
head(levene_df)
head(variance_df)
head(variance_stats_df)
head(raw_features_df)

# convert the data to long format
# genotype - feature - value
# drop the replicate and side columns
raw_features_df_long <- raw_features_df %>%
  select(-c("Metadata_replicate", "Metadata_side")) %>%
  pivot_longer(cols = -c("Metadata_genotype"), names_to = "feature", values_to = "value")
# get the feature types by splitting the feature string
raw_features_df_long$feature_type <- sapply(strsplit(raw_features_df_long$feature, "_"), function(x) x[1])
# rename the genotypes
raw_features_df_long$Metadata_genotype <- factor(raw_features_df_long$Metadata_genotype, levels = c("high", "unsel", "wt"), labels = c("High-Severity", "Mid-Severity", "Wild Type"))
head(raw_features_df_long)


# make a new column for ***
levene_df$significance <- ifelse(
    levene_df$levene_p_value < 0.001, "***",
    ifelse(levene_df$levene_p_value < 0.01, "**",
    ifelse(levene_df$levene_p_value < 0.05, "*",
    "ns")
    )
)
head(levene_df)

# split the levene_df into dfs for each feature group
levene_df_AreaShape <- levene_df %>% filter(feature_group == "AreaShape")
levene_df_Intensity <- levene_df %>% filter(feature_group == "Intensity")
levene_df_Granularity <- levene_df %>% filter(feature_group == "Granularity")
levene_df_Neighbors <- levene_df %>% filter(feature_group == "Neighbors")
levene_df_RadialDistribution <- levene_df %>% filter(feature_group == "RadialDistribution")

raw_features_df_long_AreaShape <- raw_features_df_long %>% filter(feature_type == "AreaShape")
raw_features_df_long_Intensity <- raw_features_df_long %>% filter(feature_type == "Intensity")
raw_features_df_long_Granularity <- raw_features_df_long %>% filter(feature_type == "Granularity")
raw_features_df_long_Neighbors <- raw_features_df_long %>% filter(feature_type == "Neighbors")
raw_features_df_long_RadialDistribution <- raw_features_df_long %>% filter(feature_type == "RadialDistribution")

variance_df_AreaShape <- variance_df %>% filter(feature_group == "AreaShape")
variance_df_Intensity <- variance_df %>% filter(feature_group == "Intensity")
variance_df_Granularity <- variance_df %>% filter(feature_group == "Granularity")
variance_df_Neighbors <- variance_df %>% filter(feature_group == "Neighbors")
variance_df_RadialDistribution <- variance_df %>% filter(feature_group == "RadialDistribution")


# split the variance_stats_df into dfs for each feature group
variance_stats_df_AreaShape <- variance_stats_df %>% filter(feature_group == "AreaShape")
variance_stats_df_Intensity <- variance_stats_df %>% filter(feature_group == "Intensity")
variance_stats_df_Granularity <- variance_stats_df %>% filter(feature_group == "Granularity")
variance_stats_df_Neighbors <- variance_stats_df %>% filter(feature_group == "Neighbors")
variance_stats_df_RadialDistribution <- variance_stats_df %>% filter(feature_group == "RadialDistribution")


head(variance_stats_df)
unique(variance_stats_df$Metadata_genotype)

width <- 7
height <- 5
options(repr.plot.width=width, repr.plot.height=height)
# make genotypes and sides into factors
variance_stats_df$Metadata_genotype <- factor(variance_stats_df$Metadata_genotype, levels = c("Wild Type", "Mid-Severity", "High-Severity"))
coef_gg <- (
        ggplot(variance_stats_df, aes(x = Metadata_genotype, y = feature_group))
        + geom_point(aes(fill = abs(variance_max)), pch = 22, size = 16)
        + theme_bw()
        + scale_fill_continuous(
            name="Top variance \nper genotype",
            low = "purple",
            high = "green",
        )
        + xlab("Genotype")
        + ylab("Feature")

        + figure_theme
        + theme(
            axis.text.x = element_text(angle = 45, hjust = 1, size = 14),
        )
        # make legend text smaller
        + theme(legend.text=element_text(size=14))
        # rotate x axis labels
        + theme(axis.text.x = element_text(angle = 45, hjust = 1))
        + theme(plot.title = element_text(hjust = 0.5))
        )
coef_gg
# save the plot
ggsave(file="custom_aggregated_top_variance_per_genotype.png", plot=coef_gg, path= file.path(fig_path), dpi=600, width=width, height=height, units="in", limitsize = FALSE)

WT_vs_high_significance <- levene_df_AreaShape %>% filter(group == "high_area_v_wt_area")
WT_vs_unsel_significance <- levene_df_AreaShape %>% filter(group == "unsel_area_v_wt_area")
unsel_vs_high_significance <- levene_df_AreaShape %>% filter(group == "high_area_v_unsel_area")
WT_vs_high_significance <- WT_vs_high_significance$significance
WT_vs_unsel_significance <- WT_vs_unsel_significance$significance
unsel_vs_high_significance <- unsel_vs_high_significance$significance
# make genotype a factor
raw_features_df_long_AreaShape$Metadata_genotype <- factor(raw_features_df_long_AreaShape$Metadata_genotype, levels = c("Wild Type", "Mid-Severity", "High-Severity"))
width <- 8
height <- 5
options(repr.plot.width=width, repr.plot.height=height)
max_plot_value <- max(raw_features_df_long_AreaShape$value)
min_plot_value <- min(raw_features_df_long_AreaShape$value)
areashape_boxplot <- (
    ggplot(raw_features_df_long_AreaShape, aes(x = Metadata_genotype, y = value, fill = Metadata_genotype))
        + geom_boxplot()
        + labs(x = "Genotype", y = "AreaShape feature \n normalized values", fill = "Genotype")
        # remove the x axis label
        + theme(
            axis.title.x=element_blank(),
            axis.ticks.x = element_blank(),
            axis.text.x = element_blank()
        )
        + theme_bw()
        + figure_theme
        # add significance bars
        + geom_signif(
            comparisons = list(c("High-Severity","Mid-Severity")),
            annotations = unsel_vs_high_significance,
            textsize = 7,
            y_position = c(max_plot_value+0.1, max_plot_value+0.5)
        )
        + geom_signif(
            comparisons = list(c("Wild Type","Mid-Severity")),
            annotations = WT_vs_unsel_significance,
            textsize = 7,
            y_position = c(max_plot_value+0.1, max_plot_value+0.25)
        )
        + geom_signif(
            comparisons = list(c("High-Severity","Wild Type")),
            annotations = WT_vs_high_significance,
            textsize = 7,
            vjust = 0.1,
            y_position = c(max_plot_value+1.3, max_plot_value+1.5)

        )
        # # remove the legend
        + theme(legend.position = "none")
        + ylim(min_plot_value,max_plot_value+3)
    )
areashape_boxplot
ggsave(file="custom_aggregated_normalized_feature_value_boxplot_across_genotype_AreaShape.png", plot=areashape_boxplot, path= file.path(fig_path), dpi=600, width=width, height=height, units="in", limitsize = FALSE)

WT_vs_high_significance <- levene_df_AreaShape %>% filter(group == "high_area_v_wt_area")
WT_vs_unsel_significance <- levene_df_AreaShape %>% filter(group == "unsel_area_v_wt_area")
unsel_vs_high_significance <- levene_df_AreaShape %>% filter(group == "high_area_v_unsel_area")
WT_vs_high_significance <- WT_vs_high_significance$significance
WT_vs_unsel_significance <- WT_vs_unsel_significance$significance
unsel_vs_high_significance <- unsel_vs_high_significance$significance
# make genotype a factor
variance_stats_df_AreaShape$Metadata_genotype <- factor(variance_stats_df_AreaShape$Metadata_genotype, levels = c("Wild Type", "Mid-Severity", "High-Severity"))
width <- 8
height <- 5
options(repr.plot.width=width, repr.plot.height=height)

# get the max value of the variance
max_var <- max(variance_stats_df_AreaShape$variance_mean)
# add 0.3 to the max value to get the y max
max_var_plot <- max_var + 0.4
areashape_plot <- (
        ggplot(variance_stats_df_AreaShape, aes(x = Metadata_genotype, y = variance_mean, fill = Metadata_genotype))
        + geom_bar(stat = "identity")
        + labs(x = "Genotype", y = "Mean AreaShape variance", fill = "Genotype")
        # remove the x axis label
        + theme(
            axis.title.x=element_blank(),
            axis.ticks.x = element_blank(),
            axis.text.x = element_blank()
        )
        + theme_bw()
        + figure_theme
        # add significance bars
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
            vjust = 0.1,
            y_position = c(max_var+0.2, max_var+0.25)

        )
        # # remove the legend
        + theme(legend.position = "none")
        + ylim(0,max_var_plot)
    )
areashape_plot
ggsave(file="custom_aggregated_variance_across_genotype_AreaShape.png", plot=areashape_plot, path= file.path(fig_path), dpi=600, width=width, height=height, units="in", limitsize = FALSE)

WT_vs_high_significance <- levene_df_Intensity %>% filter(group == "high_intensity_v_wt_intensity")
WT_vs_unsel_significance <- levene_df_Intensity %>% filter(group == "unsel_intensity_v_wt_intensity")
unsel_vs_high_significance <- levene_df_Intensity %>% filter(group == "high_intensity_v_unsel_intensity")
WT_vs_high_significance <- WT_vs_high_significance$significance
WT_vs_unsel_significance <- WT_vs_unsel_significance$significance
unsel_vs_high_significance <- unsel_vs_high_significance$significance
print(WT_vs_high_significance)
print(WT_vs_unsel_significance)
print(unsel_vs_high_significance)
# make genotype a factor
raw_features_df_long_Intensity$Metadata_genotype <- factor(raw_features_df_long_Intensity$Metadata_genotype, levels = c("Wild Type", "Mid-Severity", "High-Severity"))
width <- 8
height <- 5
options(repr.plot.width=width, repr.plot.height=height)
max_plot_value <- max(raw_features_df_long_Intensity$value)
min_plot_value <- min(raw_features_df_long_Intensity$value)
Intensity_boxplot <- (
    ggplot(raw_features_df_long_Intensity, aes(x = Metadata_genotype, y = value, fill = Metadata_genotype))
        + geom_boxplot()
        + labs(x = "Genotype", y = "Intensity feature \n normalized values", fill = "Genotype")
        # remove the x axis label
        + theme(
            axis.title.x=element_blank(),
            axis.ticks.x = element_blank(),
            axis.text.x = element_blank()
        )
        + theme_bw()
        + figure_theme
        # add significance bars
        + geom_signif(
            comparisons = list(c("High-Severity","Mid-Severity")),
            annotations = unsel_vs_high_significance,
            textsize = 7,
            y_position = c(max_plot_value+0.1, max_plot_value+0.5)
        )
        + geom_signif(
            comparisons = list(c("Wild Type","Mid-Severity")),
            annotations = WT_vs_unsel_significance,
            textsize = 7,
            y_position = c(max_plot_value+0.1, max_plot_value+0.25)
        )
        + geom_signif(
            comparisons = list(c("High-Severity","Wild Type")),
            annotations = WT_vs_high_significance,
            textsize = 7,
            vjust = 0.1,
            y_position = c(max_plot_value+1.3, max_plot_value+1.5)

        )
        # # remove the legend
        + theme(legend.position = "none")
        + ylim(min_plot_value,max_plot_value+3)
    )
Intensity_boxplot
ggsave(file="custom_aggregated_normalized_feature_value_boxplot_across_genotype_Intensity.png", plot=Intensity_boxplot, path= file.path(fig_path), dpi=600, width=width, height=height, units="in", limitsize = FALSE)

WT_vs_high_significance <- levene_df_Intensity %>% filter(group == "high_intensity_v_wt_intensity")
WT_vs_unsel_significance <- levene_df_Intensity %>% filter(group == "unsel_intensity_v_wt_intensity")
unsel_vs_high_significance <- levene_df_Intensity %>% filter(group == "high_intensity_v_unsel_intensity")
WT_vs_high_significance <- WT_vs_high_significance$significance
WT_vs_unsel_significance <- WT_vs_unsel_significance$significance
unsel_vs_high_significance <- unsel_vs_high_significance$significance
# make genotype a factor
variance_stats_df_Intensity$Metadata_genotype <- factor(variance_stats_df_Intensity$Metadata_genotype, levels = c("Wild Type", "Mid-Severity", "High-Severity"))
width <- 8
height <- 5
options(repr.plot.width=width, repr.plot.height=height)
# get the max value of the variance
max_var <- max(variance_stats_df_Intensity$variance_mean)
# add 0.3 to the max value to get the y max
max_var_plot <- max_var + 0.4
intensity_plot <- (
        ggplot(variance_stats_df_Intensity, aes(x = Metadata_genotype, y = variance_mean, fill = Metadata_genotype))
        + geom_bar(stat = "identity")
        + labs(x = "Genotype", y = "Mean Intensity variance", fill = "Genotype")
        # remove the x axis label
        + theme(
            axis.title.x=element_blank(),
            axis.ticks.x = element_blank(),
            axis.text.x = element_blank()
        )
        + theme_bw()
        + figure_theme
        # add significance bars
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
            vjust = 0.1,
            y_position = c(max_var+0.2, max_var+0.25)

        )
        # # remove the legend
        + theme(legend.position = "none")
        + ylim(0,max_var_plot)
    )
intensity_plot
ggsave(file="custom_aggregated_variance_across_genotype_Intensity.png", plot=intensity_plot, path= file.path(fig_path), dpi=600, width=width, height=height, units="in", limitsize = FALSE)

WT_vs_high_significance <- levene_df_Granularity %>% filter(group == "high_granularity_v_wt_granularity")
WT_vs_unsel_significance <- levene_df_Granularity %>% filter(group == "unsel_granularity_v_wt_granularity")
unsel_vs_high_significance <- levene_df_Granularity %>% filter(group == "high_granularity_v_unsel_granularity")
WT_vs_high_significance <- WT_vs_high_significance$significance
WT_vs_unsel_significance <- WT_vs_unsel_significance$significance
unsel_vs_high_significance <- unsel_vs_high_significance$significance
# make genotype a factor
raw_features_df_long_Granularity$Metadata_genotype <- factor(raw_features_df_long_Granularity$Metadata_genotype, levels = c("Wild Type", "Mid-Severity", "High-Severity"))
width <- 8
height <- 5
options(repr.plot.width=width, repr.plot.height=height)
max_plot_value <- max(raw_features_df_long_Granularity$value)
min_plot_value <- min(raw_features_df_long_Granularity$value)
Granularity_boxplot <- (
    ggplot(raw_features_df_long_Granularity, aes(x = Metadata_genotype, y = value, fill = Metadata_genotype))
        + geom_boxplot()
        + labs(x = "Genotype", y = "Granularity feature \n normalized values", fill = "Genotype")
        # remove the x axis label
        + theme(
            axis.title.x=element_blank(),
            axis.ticks.x = element_blank(),
            axis.text.x = element_blank()
        )
        + theme_bw()
        + figure_theme
        # add significance bars
        + geom_signif(
            comparisons = list(c("High-Severity","Mid-Severity")),
            annotations = unsel_vs_high_significance,
            textsize = 7,
            y_position = c(max_plot_value+0.1, max_plot_value+0.5)
        )
        + geom_signif(
            comparisons = list(c("Wild Type","Mid-Severity")),
            annotations = WT_vs_unsel_significance,
            textsize = 7,
            y_position = c(max_plot_value+0.1, max_plot_value+0.25)
        )
        + geom_signif(
            comparisons = list(c("High-Severity","Wild Type")),
            annotations = WT_vs_high_significance,
            textsize = 7,
            vjust = 0.1,
            y_position = c(max_plot_value+1.3, max_plot_value+1.5)

        )
        # # remove the legend
        + theme(legend.position = "none")
        + ylim(min_plot_value,max_plot_value+3)
    )
Granularity_boxplot
ggsave(file="custom_aggregated_normalized_feature_value_boxplot_across_genotype_Granularity.png", plot=Granularity_boxplot, path= file.path(fig_path), dpi=600, width=width, height=height, units="in", limitsize = FALSE)

WT_vs_high_significance <- levene_df_Granularity %>% filter(group == "high_granularity_v_wt_granularity")
WT_vs_unsel_significance <- levene_df_Granularity %>% filter(group == "unsel_granularity_v_wt_granularity")
unsel_vs_high_significance <- levene_df_Granularity %>% filter(group == "high_granularity_v_unsel_granularity")
WT_vs_high_significance <- WT_vs_high_significance$significance
WT_vs_unsel_significance <- WT_vs_unsel_significance$significance
unsel_vs_high_significance <- unsel_vs_high_significance$significance
# make genotype a factor
variance_stats_df_Granularity$Metadata_genotype <- factor(variance_stats_df_Granularity$Metadata_genotype, levels = c("Wild Type", "Mid-Severity", "High-Severity"))
width <- 8
height <- 5
options(repr.plot.width=width, repr.plot.height=height)
# get the max value of the variance
max_var <- max(variance_stats_df_Granularity$variance_mean)
# add 0.3 to the max value to get the y max
max_var_plot <- max_var + 0.4
granularity_plot <- (
        ggplot(variance_stats_df_Granularity, aes(x = Metadata_genotype, y = variance_mean, fill = Metadata_genotype))
        + geom_bar(stat = "identity")
        + labs(x = "Genotype", y = "Mean Granularity variance", fill = "Genotype")
        # remove the x axis label
        + theme(
            axis.title.x=element_blank(),
            axis.ticks.x = element_blank(),
            axis.text.x = element_blank()
        )
        + theme_bw()
        + figure_theme
        # add significance bars
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
            vjust = 0.1,
            y_position = c(max_var+0.2, max_var+0.25)

        )
        # # remove the legend
        + theme(legend.position = "none")
        + ylim(0,max_var_plot)
    )
granularity_plot
ggsave(file="custom_aggregated_custom_aggregated_variance_across_genotype_Granularity.png", plot=granularity_plot, path= file.path(fig_path), dpi=600, width=width, height=height, units="in", limitsize = FALSE)

WT_vs_high_significance <- levene_df_Neighbors %>% filter(group == "high_neighbors_v_wt_neighbors")
WT_vs_unsel_significance <- levene_df_Neighbors %>% filter(group == "unsel_neighbors_v_wt_neighbors")
unsel_vs_high_significance <- levene_df_Neighbors %>% filter(group == "high_neighbors_v_unsel_neighbors")
WT_vs_high_significance <- WT_vs_high_significance$significance
WT_vs_unsel_significance <- WT_vs_unsel_significance$significance
unsel_vs_high_significance <- unsel_vs_high_significance$significance
# make genotype a factor
raw_features_df_long_Neighbors$Metadata_genotype <- factor(raw_features_df_long_Neighbors$Metadata_genotype, levels = c("Wild Type", "Mid-Severity", "High-Severity"))
width <- 8
height <- 5
options(repr.plot.width=width, repr.plot.height=height)
max_plot_value <- max(raw_features_df_long_Neighbors$value)
min_plot_value <- min(raw_features_df_long_Neighbors$value)
Neighbors_boxplot <- (
    ggplot(raw_features_df_long_Neighbors, aes(x = Metadata_genotype, y = value, fill = Metadata_genotype))
        + geom_boxplot()
        + labs(x = "Genotype", y = "Neighbors feature \n normalized values", fill = "Genotype")
        # remove the x axis label
        + theme(
            axis.title.x=element_blank(),
            axis.ticks.x = element_blank(),
            axis.text.x = element_blank()
        )
        + theme_bw()
        + figure_theme
        # add significance bars
        + geom_signif(
            comparisons = list(c("High-Severity","Mid-Severity")),
            annotations = unsel_vs_high_significance,
            textsize = 7,
            y_position = c(max_plot_value+0.1, max_plot_value+0.5)
        )
        + geom_signif(
            comparisons = list(c("Wild Type","Mid-Severity")),
            annotations = WT_vs_unsel_significance,
            textsize = 7,
            y_position = c(max_plot_value+0.1, max_plot_value+0.25)
        )
        + geom_signif(
            comparisons = list(c("High-Severity","Wild Type")),
            annotations = WT_vs_high_significance,
            textsize = 7,
            vjust = 0.1,
            y_position = c(max_plot_value+1.3, max_plot_value+1.5)

        )
        # # remove the legend
        + theme(legend.position = "none")
        + ylim(min_plot_value,max_plot_value+3)
    )
Neighbors_boxplot
ggsave(file="custom_aggregated_normalized_feature_value_boxplot_across_genotype_Neighbors.png", plot=Neighbors_boxplot, path= file.path(fig_path), dpi=600, width=width, height=height, units="in", limitsize = FALSE)


WT_vs_high_significance <- levene_df_Neighbors %>% filter(group == "high_neighbors_v_wt_neighbors")
WT_vs_unsel_significance <- levene_df_Neighbors %>% filter(group == "unsel_neighbors_v_wt_neighbors")
unsel_vs_high_significance <- levene_df_Neighbors %>% filter(group == "high_neighbors_v_unsel_neighbors")
WT_vs_high_significance <- WT_vs_high_significance$significance
WT_vs_unsel_significance <- WT_vs_unsel_significance$significance
unsel_vs_high_significance <- unsel_vs_high_significance$significance
# make genotype a factor
variance_stats_df_Neighbors$Metadata_genotype <- factor(variance_stats_df_Neighbors$Metadata_genotype, levels = c("Wild Type", "Mid-Severity", "High-Severity"))
width <- 8
height <- 5
options(repr.plot.width=width, repr.plot.height=height)
# get the max value of the variance
max_var <- max(variance_stats_df_Neighbors$variance_mean)
# add 0.3 to the max value to get the y max
max_var_plot <- max_var + 0.4
neighbors_plot <- (
        ggplot(variance_stats_df_Neighbors, aes(x = Metadata_genotype, y = variance_mean, fill = Metadata_genotype))
        + geom_bar(stat = "identity")
        + labs(x = "Genotype", y = "Mean Neighbors variance", fill = "Genotype")
        # remove the x axis label
        + theme(
            axis.title.x=element_blank(),
            axis.ticks.x = element_blank(),
            axis.text.x = element_blank()
        )
        + theme_bw()
        + figure_theme
        # add significance bars
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
            vjust = 0.1,
            y_position = c(max_var+0.2, max_var+0.25)

        )
        # # remove the legend
        + theme(legend.position = "none")
        + ylim(0,max_var_plot)
    )
neighbors_plot
ggsave(file="custom_aggregated_variance_across_genotype_Neighbors.png", plot=neighbors_plot, path= file.path(fig_path), dpi=600, width=width, height=height, units="in", limitsize = FALSE)


WT_vs_high_significance <- levene_df_RadialDistribution %>% filter(group == "high_radial_v_wt_radial")
WT_vs_unsel_significance <- levene_df_RadialDistribution %>% filter(group == "unsel_radial_v_wt_radial")
unsel_vs_high_significance <- levene_df_RadialDistribution %>% filter(group == "high_radial_v_unsel_radial")
WT_vs_high_significance <- WT_vs_high_significance$significance
WT_vs_unsel_significance <- WT_vs_unsel_significance$significance
unsel_vs_high_significance <- unsel_vs_high_significance$significance
# make genotype a factor
raw_features_df_long_RadialDistribution$Metadata_genotype <- factor(raw_features_df_long_RadialDistribution$Metadata_genotype, levels = c("Wild Type", "Mid-Severity", "High-Severity"))
width <- 8
height <- 5
options(repr.plot.width=width, repr.plot.height=height)
max_plot_value <- max(raw_features_df_long_RadialDistribution$value)
min_plot_value <- min(raw_features_df_long_RadialDistribution$value)
RadialDistribution_boxplot <- (
    ggplot(raw_features_df_long_RadialDistribution, aes(x = Metadata_genotype, y = value, fill = Metadata_genotype))
        + geom_boxplot()
        + labs(x = "Genotype", y = "RadialDistribution feature \n normalized values", fill = "Genotype")
        # remove the x axis label
        + theme(
            axis.title.x=element_blank(),
            axis.ticks.x = element_blank(),
            axis.text.x = element_blank()
        )
        + theme_bw()
        + figure_theme
        # add significance bars
        + geom_signif(
            comparisons = list(c("High-Severity","Mid-Severity")),
            annotations = unsel_vs_high_significance,
            textsize = 7,
            y_position = c(max_plot_value+0.1, max_plot_value+0.5)
        )
        + geom_signif(
            comparisons = list(c("Wild Type","Mid-Severity")),
            annotations = WT_vs_unsel_significance,
            textsize = 7,
            y_position = c(max_plot_value+0.1, max_plot_value+0.25)
        )
        + geom_signif(
            comparisons = list(c("High-Severity","Wild Type")),
            annotations = WT_vs_high_significance,
            textsize = 7,
            vjust = 0.1,
            y_position = c(max_plot_value+1.3, max_plot_value+1.5)

        )
        # # remove the legend
        + theme(legend.position = "none")
        + ylim(min_plot_value,max_plot_value+3)
    )
RadialDistribution_boxplot
ggsave(file="custom_aggregated_normalized_feature_value_boxplot_across_genotype_RadialDistribution.png", plot=RadialDistribution_boxplot, path= file.path(fig_path), dpi=600, width=width, height=height, units="in", limitsize = FALSE)


WT_vs_high_significance <- levene_df_RadialDistribution %>% filter(group == "high_radial_v_wt_radial")
WT_vs_unsel_significance <- levene_df_RadialDistribution %>% filter(group == "unsel_radial_v_wt_radial")
unsel_vs_high_significance <- levene_df_RadialDistribution %>% filter(group == "high_radial_v_unsel_radial")
WT_vs_high_significance <- WT_vs_high_significance$significance
WT_vs_unsel_significance <- WT_vs_unsel_significance$significance
unsel_vs_high_significance <- unsel_vs_high_significance$significance
# make genotype a factor
variance_stats_df_RadialDistribution$Metadata_genotype <- factor(variance_stats_df_RadialDistribution$Metadata_genotype, levels = c("Wild Type", "Mid-Severity", "High-Severity"))
width <- 8
height <- 5
options(repr.plot.width=width, repr.plot.height=height)
# get the max value of the variance
max_var <- max(variance_stats_df_RadialDistribution$variance_mean)
# add 0.3 to the max value to get the y max
max_var_plot <- max_var + 0.4
RadialDistribution_plot <- (
        ggplot(variance_stats_df_RadialDistribution, aes(x = Metadata_genotype, y = variance_mean, fill = Metadata_genotype))
        + geom_bar(stat = "identity")
        + labs(x = "Genotype", y = "Mean RadialDistribution variance", fill = "Genotype")
        # remove the x axis label
        + theme(
            axis.title.x=element_blank(),
            axis.ticks.x = element_blank(),
            axis.text.x = element_blank()
        )
        + theme_bw()
        + figure_theme
        # add significance bars
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
            vjust = 0.1,
            y_position = c(max_var+0.2, max_var+0.25)

        )
        # # remove the legend
        + theme(legend.position = "none")
        + ylim(0,max_var_plot)
    )
RadialDistribution_plot
ggsave(file="custom_aggregated_variance_across_genotype_RadialDistribution.png", plot=RadialDistribution_plot, path= file.path(fig_path), dpi=600, width=width, height=height, units="in", limitsize = FALSE)
