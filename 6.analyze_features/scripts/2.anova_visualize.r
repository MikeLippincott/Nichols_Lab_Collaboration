library(ggplot2)
library(dplyr)
library(arrow)


# path to the anova data
anova_df_path <- file.path("..","..","data","6.analysis_results","anova_results.parquet")
data_path <- file.path("..","..","data","5.converted_data","normalized_feature_selected_output.parquet")

# read the data
data_df <- arrow::read_parquet(data_path)
head(data_df)

# read the anova data
anova_df <- arrow::read_parquet(anova_df_path)
head(anova_df)

# make a new column for the group1 and group2
anova_df$comparison <- paste(anova_df$group1, anova_df$group2, sep = " - ")

# order the results by anova p-value
anova_df <- anova_df %>% arrange(anova_p_value)
head(anova_df)
features <- unique(anova_df$feature)[1:10]
features

top_10_anova_df <- anova_df %>% filter(feature %in% features)
top_10_anova_df$log10_anova_p_value <- -log10(top_10_anova_df$`p-adj`)

head(top_10_anova_df)
unique(top_10_anova_df$feature)

# plot the variability of the top 10 features
features
# tmp <- data_df %>% select(c("Metadata_unique", features[1]))
# head(tmp)
data_df$Metadata_unique <- paste0(data_df$Metadata_genotype, "_", data_df$Metadata_identity, "_", data_df$Metadata_side)
head(data_df,2)

for (i in 1:length(features)){
    print(features[i])
    # get the top feature
    tmp <- data_df %>% select(c("Metadata_unique", "Metadata_genotype", "Metadata_identity", "Metadata_side", features[i]))
    # aggregate the data to get the mean and standard deviation of the top feature
    tmp <- tmp %>% group_by(Metadata_genotype) %>% summarise(mean = mean(!!as.name(features[i])), sd = sd(!!as.name(features[i])))
    # calculate the variance where variance = sd^2
    tmp$variance <- tmp$sd^2
    # plot the variability of the top feature
    var_plot <- (
        ggplot(tmp, aes(x = Metadata_genotype, y = variance, fill = Metadata_genotype))
        + geom_bar(stat = "identity")
        + theme(axis.text.x = element_text(angle = 90, hjust = 1))
        + labs(title = features[i])
        + theme_bw()
    )
    print(var_plot)
    # get the top feature
    tmp <- data_df %>% select(c("Metadata_unique", "Metadata_genotype", "Metadata_identity", "Metadata_side", features[i]))
    # aggregate the data to get the mean and standard deviation of the top feature
    tmp <- tmp %>% group_by(Metadata_genotype, Metadata_side) %>% summarise(mean = mean(!!as.name(features[i])), sd = sd(!!as.name(features[i])))
    # calculate the variance where variance = sd^2
    tmp$variance <- tmp$sd^2
    # plot the variability of the top feature
    var_plot <- (
        ggplot(tmp, aes(x = Metadata_genotype, y = variance, fill = Metadata_side))
        + geom_bar(stat = "identity", position = "dodge")
        + theme(axis.text.x = element_text(angle = 90, hjust = 1))
        + labs(title = features[i])
        + theme_bw()
    )
    print(var_plot)
    # get the top feature
    tmp <- data_df %>% select(c("Metadata_unique", "Metadata_genotype", "Metadata_identity", "Metadata_side", features[i]))
    # aggregate the data to get the mean and standard deviation of the top feature
    tmp <- tmp %>% group_by(Metadata_genotype, Metadata_side, Metadata_identity) %>% summarise(mean = mean(!!as.name(features[i])), sd = sd(!!as.name(features[i])))
    # calculate the variance where variance = sd^2
    tmp$variance <- tmp$sd^2
    # plot the variability of the top feature
    var_plot <- (
        ggplot(tmp, aes(x = Metadata_genotype, y = variance, fill = Metadata_side))
        + geom_bar(stat = "identity", position = "dodge")
        + theme(axis.text.x = element_text(angle = 90, hjust = 1))
        + labs(title = features[i])
        + theme_bw()
        + facet_grid(.~Metadata_identity)
    )
    print(var_plot)
}


features





# # get the top feature
# tmp <- data_df %>% select(c("Metadata_unique", "Metadata_genotype", "Metadata_identity", "Metadata_side", features[1]))
# # aggregate the data to get the mean and standard deviation of the top feature
# tmp <- tmp %>% group_by(Metadata_genotype) %>% summarise(mean = mean(!!as.name(features[1])), sd = sd(!!as.name(features[1])))
# # calculate the variance where variance = sd^2
# tmp$variance <- tmp$sd^2
# # plot the variability of the top feature
# var_plot <- (
#     ggplot(tmp, aes(x = Metadata_genotype, y = variance, fill = Metadata_genotype))
#     + geom_bar(stat = "identity")
#     + theme(axis.text.x = element_text(angle = 90, hjust = 1))
#     + labs(title = features[1])
#     + theme_bw()
# )
# var_plot
# # get the top feature
# tmp <- data_df %>% select(c("Metadata_unique", "Metadata_genotype", "Metadata_identity", "Metadata_side", features[1]))
# # aggregate the data to get the mean and standard deviation of the top feature
# tmp <- tmp %>% group_by(Metadata_genotype, Metadata_side) %>% summarise(mean = mean(!!as.name(features[1])), sd = sd(!!as.name(features[1])))
# # calculate the variance where variance = sd^2
# tmp$variance <- tmp$sd^2
# # plot the variability of the top feature
# var_plot <- (
#     ggplot(tmp, aes(x = Metadata_genotype, y = variance, fill = Metadata_side))
#     + geom_bar(stat = "identity", position = "dodge")
#     + theme(axis.text.x = element_text(angle = 90, hjust = 1))
#     + labs(title = features[1])
#     + theme_bw()
# )
# var_plot
# # get the top feature
# tmp <- data_df %>% select(c("Metadata_unique", "Metadata_genotype", "Metadata_identity", "Metadata_side", features[1]))
# # aggregate the data to get the mean and standard deviation of the top feature
# tmp <- tmp %>% group_by(Metadata_genotype, Metadata_side, Metadata_identity) %>% summarise(mean = mean(!!as.name(features[1])), sd = sd(!!as.name(features[1])))
# # calculate the variance where variance = sd^2
# tmp$variance <- tmp$sd^2
# # plot the variability of the top feature
# var_plot <- (
#     ggplot(tmp, aes(x = Metadata_genotype, y = variance, fill = Metadata_side))
#     + geom_bar(stat = "identity", position = "dodge")
#     + theme(axis.text.x = element_text(angle = 90, hjust = 1))
#     + labs(title = features[1])
#     + theme_bw()
#     + facet_grid(.~Metadata_identity)
# )
# var_plot



width <- 20
height <- 10
options(repr.plot.width = width, repr.plot.height = height)
for (i in features) {
    tmp <- top_10_anova_df %>% filter(feature == i)
    plot <- (
        ggplot(tmp, aes(x = comparison, y = log10_anova_p_value))
        + geom_bar(stat = "identity")
        + geom_hline(yintercept = -log10(0.05), linetype = "dashed", color = "red")
        + labs(title = i)
    )
    print(plot)
}
tmp


