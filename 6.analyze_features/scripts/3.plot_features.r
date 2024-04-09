# load libraries
suppressWarnings(suppressPackageStartupMessages(library(ggplot2)))
suppressWarnings(suppressPackageStartupMessages(library(tidyr)))
suppressWarnings(suppressPackageStartupMessages(library(tidyverse)))
suppressWarnings(suppressPackageStartupMessages(library(dplyr)))
suppressWarnings(suppressPackageStartupMessages(library(arrow)))
suppressWarnings(suppressPackageStartupMessages(library(patchwork)))
# import ggplot theme
source("../../utils/figure_themes.r")

data_path <- file.path("..","..","data","5.converted_data","normalized_manual_feature_selected_output.parquet")

data <- arrow::read_parquet(data_path)
head(data)

# drop all metadata except for the genotype data
features_df <- data %>% select(-c(contains("Metadata")))
features_df$Metadata_genotype <- data$Metadata_genotype
# get the variance of each feature per genotype
variance_df <- features_df %>%
  group_by(Metadata_genotype) %>%
  summarize_all(var) %>%
  pivot_longer(cols = -Metadata_genotype, names_to = "feature", values_to = "variance")
head(variance_df)

# order the df by variance
variance_df <- variance_df %>% arrange(desc(variance))
head(variance_df)


variance_df <- variance_df %>%
    dplyr::arrange(desc(abs(variance))) %>%
    tidyr::separate(
        feature,
        into = c(
            "feature_group",
            "measurement",
            "channel",
            "parameter1",
            "parameter2"
        ),
        sep = "_",
        remove = FALSE
    ) %>%
    dplyr::mutate(channel_cleaned = channel) %>%
    dplyr::arrange(desc(abs(variance)))

variance_df <- variance_df %>%
    dplyr::group_by(feature_group, Metadata_genotype) %>%
    dplyr::slice_max(order_by = variance, n = 1)


head(variance_df)

# replace the Metadata_genotype with the actual genotype name
variance_df$Metadata_genotype <- gsub("high", "High-Severity", variance_df$Metadata_genotype)
variance_df$Metadata_genotype <- gsub("unsel", "Mid-Severity", variance_df$Metadata_genotype)
variance_df$Metadata_genotype <- gsub("wt", "Wild Type", variance_df$Metadata_genotype)
# factorize the genotype
variance_df$Metadata_genotype <- factor(variance_df$Metadata_genotype, levels = c("Wild Type", "Mid-Severity", "High-Severity"))
head(variance_df,2)

width <- 6
height <- 4
options(repr.plot.width=width, repr.plot.height=height)

coef_gg <- (
        ggplot(variance_df, aes(x = Metadata_genotype, y = feature_group))
        + geom_point(aes(fill = abs(variance)), pch = 22, size = 17)
        # + facet_wrap("~compartment", ncol = 3)
        + theme_bw()
        + scale_fill_continuous(
            name="Top variance \nper genotype",
            low = "purple",
            high = "green",
        )
        + xlab("Genotype")
        + ylab("Feature type")

        + figure_theme
        + theme(
            axis.text.x = element_text(angle = 45, hjust = 1, size = 14),
        )
        # rotate x axis labels
        + theme(axis.text.x = element_text(angle = 45, hjust = 1))
        + theme(plot.title = element_text(hjust = 0.5))
        + ggplot2::coord_fixed()
        )
coef_gg
# save the plot
ggsave(file="top_variance_per_genotype.png", plot=coef_gg, path= file.path("..","figures"), dpi=600, width=width, height=height, units="in", limitsize = FALSE)

head(data)

# drop all metadata except for the genotype data
features_df <- data %>% select(-c(contains("Metadata")))
features_df$Metadata_genotype <- data$Metadata_genotype
features_df$Metadata_side <- data$Metadata_side
# get the variance of each feature per genotype and side
variance_df <- features_df %>%
  group_by(Metadata_genotype, Metadata_side) %>%
  summarize_all(var) %>%
  pivot_longer(cols = -c(Metadata_genotype, Metadata_side), names_to = "feature", values_to = "variance")
# replace the Metadata_genotype with the actual genotype name
variance_df$Metadata_genotype <- gsub("high", "High-Severity", variance_df$Metadata_genotype)
variance_df$Metadata_genotype <- gsub("unsel", "Mid-Severity", variance_df$Metadata_genotype)
variance_df$Metadata_genotype <- gsub("wt", "Wild Type", variance_df$Metadata_genotype)
# factorize the genotype
variance_df$Metadata_genotype <- factor(variance_df$Metadata_genotype, levels = c("Wild Type", "Mid-Severity", "High-Severity"))
head(variance_df,2)

# order the df by variance
variance_df <- variance_df %>% arrange(desc(variance))
head(variance_df)


variance_df <- variance_df %>%
    dplyr::arrange(desc(abs(variance))) %>%
    tidyr::separate(
        feature,
        into = c(
            "feature_group",
            "measurement",
            "channel",
            "parameter1",
            "parameter2"
        ),
        sep = "_",
        remove = FALSE
    ) %>%
    dplyr::mutate(channel_cleaned = channel) %>%
    dplyr::arrange(desc(abs(variance)))

variance_df <- variance_df %>%
    dplyr::group_by(feature_group, Metadata_genotype, Metadata_side) %>%
    dplyr::slice_max(order_by = variance, n = 1)


width <- 8
height <- 5
options(repr.plot.width=width, repr.plot.height=height)

coef_gg <- (
        ggplot(variance_df, aes(x = Metadata_genotype, y = feature_group))
        + geom_point(aes(fill = abs(variance)), pch = 22, size = 16)
        # + facet_wrap("~compartment", ncol = 3)
        + theme_bw()
        + scale_fill_continuous(
            name="Top variance \nper genotype and side",
            low = "purple",
            high = "green",
        )
        + xlab("Genotype")
        + ylab("Feature")

        + figure_theme
        + theme(
            axis.text.x = element_text(angle = 45, hjust = 1, size = 14),
        )
        # rotate x axis labels
        + theme(axis.text.x = element_text(angle = 45, hjust = 1))
        + theme(plot.title = element_text(hjust = 0.5))
        # + ggplot2::coord_fixed()
        + facet_wrap(~Metadata_side)
        )
coef_gg
# save the plot
ggsave(file="top_variance_per_genotype_and_side.png", plot=coef_gg, path= file.path("..","figures"), dpi=600, width=width, height=height, units="in", limitsize = FALSE)

width <- 8
height <- 4
options(repr.plot.width=width, repr.plot.height=height)

coef_gg <- (
        ggplot(variance_df, aes(x = Metadata_side, y = feature_group))
        + geom_point(aes(fill = abs(variance)), pch = 22, size = 16)
        # + facet_wrap("~compartment", ncol = 3)
        + theme_bw()
        + scale_fill_continuous(
            name="Top variance \nper side",
            low = "purple",
            high = "green",
        )
        + xlab("Side")
        + ylab("Feature")

        + figure_theme
        + theme(
            axis.text.x = element_text(angle = 45, hjust = 1, size = 14),
        )
        # rotate x axis labels
        + theme(axis.text.x = element_text(angle = 45, hjust = 1))
        + theme(plot.title = element_text(hjust = 0.5))
        + ggplot2::coord_fixed()
        )
coef_gg
# save the plot
ggsave(file="top_variance_per_side.png", plot=coef_gg, path= file.path("..","figures"), dpi=600, width=width, height=height, units="in", limitsize = FALSE)
