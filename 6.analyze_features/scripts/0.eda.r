suppressWarnings(suppressPackageStartupMessages(library(ggplot2)))
suppressWarnings(suppressPackageStartupMessages(library(dplyr)))
suppressWarnings(suppressPackageStartupMessages(library(tidyr)))
suppressWarnings(suppressPackageStartupMessages(library(arrow)))
suppressWarnings(suppressPackageStartupMessages(library(umap)))
# Load necessary packages
suppressWarnings(suppressPackageStartupMessages(library(factoextra)))


# set path to the data
file_path <- file.path("..","..","data", "5.converted_data","normalized_feature_selected_output.parquet")

# read the data
df <- arrow::read_parquet(file_path)
df$Metadata_genotype <- gsub("wt", "Wild Type", df$Metadata_genotype)
df$Metadata_genotype <- gsub("unsel", "Mid-Severity", df$Metadata_genotype)
df$Metadata_genotype <- gsub("high", "High-Severity", df$Metadata_genotype)
df$Metadata_genotype <- factor(
    df$Metadata_genotype,
    levels = c("Wild Type", "Mid-Severity", "High-Severity")
)
df$Metadata_identity <- gsub("both", "Merged", df$Metadata_identity)
df$Metadata_identity <- gsub("br", "Br", df$Metadata_identity)
df$Metadata_identity <- gsub("op", "Op", df$Metadata_identity)
df$Metadata_identity <- factor(
    df$Metadata_identity,
    levels = c("Br","Op", "Merged")
)
head(df)

# split the data into metadata and features
metadata_df <- df %>% select(contains("Metadata"))
features_df <- df %>% select(-contains("Metadata"))
print(dim(metadata_df))
print(dim(features_df))

# umap
width <- 7
height <- 5
options(repr.plot.width = width, repr.plot.height = height)
umap_df <- umap::umap((features_df), n_neighbors = 7, min_dist = 0.7, n_components = 2, metric = "cosine")
umap_df <- as.data.frame(umap_df$layout)
colnames(umap_df) <- c("UMAP0", "UMAP1")
umap_df <- cbind(metadata_df, umap_df)

# plot umap
umap_plot <- (
    ggplot(umap_df, aes(x = UMAP0, y = UMAP1, color = Metadata_genotype))
    + geom_point(size = 2)

    + theme_bw()
    + guides(color = guide_legend(title = "Genotype"))
)
umap_plot
# save the plot
ggsave("umap_plot_genotype.png", path = file.path("..","figures"), width = width, height = height, units = "in", dpi = 600)



# umap
width <- 7
height <- 5
options(repr.plot.width = width, repr.plot.height = height)
umap_df <- umap::umap((features_df), n_neighbors = 7, min_dist = 0.7, n_components = 2, metric = "cosine")
umap_df <- as.data.frame(umap_df$layout)
colnames(umap_df) <- c("UMAP0", "UMAP1")
umap_df <- cbind(metadata_df, umap_df)

# plot umap
umap_plot <- (
    ggplot(umap_df, aes(x = UMAP0, y = UMAP1, color = Metadata_genotype, shape = Metadata_identity))
    + geom_point(size = 2)

    + theme_bw()
    + guides(color = guide_legend(title = "Genotype"), shape = guide_legend(title = "Bone"))
)
umap_plot
# save the plot
ggsave("umap_plot_genotype_and_bone.png", path = file.path("..","figures"), width = width, height = height, units = "in", dpi = 600)



# umap
width <- 7
height <- 5
options(repr.plot.width = width, repr.plot.height = height)
umap_df <- umap::umap((features_df), n_neighbors = 7, min_dist = 0.7, n_components = 2, metric = "cosine")
umap_df <- as.data.frame(umap_df$layout)
colnames(umap_df) <- c("UMAP0", "UMAP1")
umap_df <- cbind(metadata_df, umap_df)

# plot umap
umap_plot <- (
    ggplot(umap_df, aes(x = UMAP0, y = UMAP1, color = Metadata_genotype, shape = Metadata_side))
    + geom_point(size = 2)
    + theme_bw()
    + guides(color = guide_legend(title = "Genotype"), shape = guide_legend(title = "Side"))
)
umap_plot
# save the plot
ggsave("umap_plot_genotype_and_side.png", path = file.path("..","figures"), width = width, height = height, units = "in", dpi = 600)




# Apply PCA
res.pca <- prcomp(features_df, scale = TRUE)

# Create scree plot
scree_plot <- fviz_eig(res.pca, addlabels = TRUE, ylim = c(0, 50))
scree_plot <- (
    scree_plot
    + theme_bw()
    # title centered
    + theme(plot.title = element_text(hjust = 0.5))
)
scree_plot
# save the plot
ggsave("scree_plot.png", path = file.path("..","figures"), width = width, height = height, units = "in", dpi = 600)

# pca analysis
pca_df <- as.data.frame(res.pca$x)
pca_df <- cbind(metadata_df, pca_df)

# plot pca
pca_plot <- (
    ggplot(pca_df, aes(x = PC1, y = PC2, color = Metadata_genotype))
    + geom_point()
    + theme_bw()
    + guides(color = guide_legend(title = "Genotype"))
)
pca_plot
# save the plot
ggsave("pca_plot_genotype.png", path = file.path("..","figures"), width = width, height = height, units = "in", dpi = 600)


# pca analysis
pca_df <- as.data.frame(res.pca$x)
pca_df <- cbind(metadata_df, pca_df)

# plot pca
pca_plot <- (
    ggplot(pca_df, aes(x = PC1, y = PC2, color = Metadata_genotype, shape = Metadata_identity))
    + geom_point()
    + theme_bw()
    + guides(color = guide_legend(title = "Genotype"), shape = guide_legend(title = "Identity"))
)
# save the plot
ggsave("pca_plot_genotype_and_bone.png", path = file.path("..","figures"), width = width, height = height, units = "in", dpi = 600)


# pca analysis
pca_df <- as.data.frame(res.pca$x)
pca_df <- cbind(metadata_df, pca_df)

# plot pca
pca_plot <- (
    ggplot(pca_df, aes(x = PC1, y = PC2, color = Metadata_genotype, shape = Metadata_side))
    + geom_point()
    + theme_bw()
    + guides(color = guide_legend(title = "Genotype"), shape = guide_legend(title = "Side"))
)
pca_plot
# save the plot
ggsave("pca_plot_genotype_and_side.png", path = file.path("..","figures"), width = width, height = height, units = "in", dpi = 600)



# remove all metadata columns
df_selected <- df %>% select(-contains("Metadata"))
df_selected$Metadata_genotype <- df$Metadata_genotype
df_selected$Metadata_replicate <- df$Metadata_replicate
# aggregate by Metadata_genotype, FileName, Metadata_ImageNumber, side, Metdata_replicate
df_agg <- df_selected %>%
    group_by(Metadata_genotype, Metadata_replicate) %>%
    summarise_all(mean)
# ungroup the data
df_agg <- ungroup(df_agg)
# # generate the pca for the aggregated data
res.pca <- prcomp(df_agg %>% select(-contains("Metadata")), scale = TRUE)
# # create the pca plot
pca_df <- as.data.frame(res.pca$x)
pca_df <- cbind(df_agg %>% select(contains("Metadata")), pca_df)
pca_plot <- (
    ggplot(pca_df, aes(x = PC1, y = PC2, color = Metadata_genotype))
    + geom_point()
    + theme_bw()
    + guides(color = guide_legend(title = "Genotype"))
)
pca_plot
# save the plot
ggsave("pca_plot_genotype_aggregated.png", path = file.path("..","figures"), width = width, height = height, units = "in", dpi = 600)


# set path to the data
file_path <- file.path("..","..","data", "5.converted_data","normalized_manual_feature_selected_output.parquet")

# read the data
df <- arrow::read_parquet(file_path)
head(df)

# split the data into metadata and features
metadata_df <- df %>% select(contains("Metadata"))
features_df <- df %>% select(-contains("Metadata"))
print(dim(metadata_df))
print(dim(features_df))

# umap
width <- 7
height <- 5
options(repr.plot.width = width, repr.plot.height = height)
umap_df <- umap::umap((features_df), n_neighbors = 7, min_dist = 0.7, n_components = 2, metric = "cosine")
umap_df <- as.data.frame(umap_df$layout)
colnames(umap_df) <- c("UMAP0", "UMAP1")
umap_df <- cbind(metadata_df, umap_df)

# plot umap
umap_plot <- (
    ggplot(umap_df, aes(x = UMAP0, y = UMAP1, color = Metadata_genotype))
    + geom_point(size = 2)

    + theme_bw()
    + guides(color = guide_legend(title = "Genotype"))
)
umap_plot
# save the plot
ggsave("umap_plot_genotype_manual_selection.png", path = file.path("..","figures"), width = width, height = height, units = "in", dpi = 600)



# umap
width <- 7
height <- 5
options(repr.plot.width = width, repr.plot.height = height)
umap_df <- umap::umap((features_df), n_neighbors = 7, min_dist = 0.7, n_components = 2, metric = "cosine")
umap_df <- as.data.frame(umap_df$layout)
colnames(umap_df) <- c("UMAP0", "UMAP1")
umap_df <- cbind(metadata_df, umap_df)

# plot umap
umap_plot <- (
    ggplot(umap_df, aes(x = UMAP0, y = UMAP1, color = Metadata_genotype, shape = Metadata_identity))
    + geom_point(size = 2)

    + theme_bw()
    + guides(color = guide_legend(title = "Genotype"), shape = guide_legend(title = "Identity"))
)
umap_plot
# save the plot
ggsave("umap_plot_genotype_and_bone_manual_selection.png", path = file.path("..","figures"), width = width, height = height, units = "in", dpi = 600)



# umap
width <- 7
height <- 5
options(repr.plot.width = width, repr.plot.height = height)
umap_df <- umap::umap((features_df), n_neighbors = 7, min_dist = 0.7, n_components = 2, metric = "cosine")
umap_df <- as.data.frame(umap_df$layout)
colnames(umap_df) <- c("UMAP0", "UMAP1")
umap_df <- cbind(metadata_df, umap_df)

# plot umap
umap_plot <- (
    ggplot(umap_df, aes(x = UMAP0, y = UMAP1, color = Metadata_genotype, shape = Metadata_side))
    + geom_point(size = 2)
    + theme_bw()
    + guides(color = guide_legend(title = "Genotype"), shape = guide_legend(title = "Side"))
)
umap_plot
# save the plot
ggsave("umap_plot_genotype_and_side_manual_selection.png", path = file.path("..","figures"), width = width, height = height, units = "in", dpi = 600)




# Apply PCA
res.pca <- prcomp(features_df, scale = TRUE)

# Create scree plot
scree_plot <- fviz_eig(res.pca, addlabels = TRUE, ylim = c(0, 50))
scree_plot <- (
    scree_plot
    + theme_bw()
    # title centered
    + theme(plot.title = element_text(hjust = 0.5))
)
scree_plot
# save the plot
ggsave("scree_plot_manual_selection.png", path = file.path("..","figures"), width = width, height = height, units = "in", dpi = 600)

# pca analysis
pca_df <- as.data.frame(res.pca$x)
pca_df <- cbind(metadata_df, pca_df)

# plot pca
pca_plot <- (
    ggplot(pca_df, aes(x = PC1, y = PC2, color = Metadata_genotype))
    + geom_point()
    + theme_bw()
    + guides(color = guide_legend(title = "Genotype"))
)
pca_plot
# save the plot
ggsave("pca_plot_genotype_manual_selection.png", path = file.path("..","figures"), width = width, height = height, units = "in", dpi = 600)


# pca analysis
pca_df <- as.data.frame(res.pca$x)
pca_df <- cbind(metadata_df, pca_df)

# plot pca
pca_plot <- (
    ggplot(pca_df, aes(x = PC1, y = PC2, color = Metadata_genotype, shape = Metadata_identity))
    + geom_point()
    + theme_bw()
    + guides(color = guide_legend(title = "Genotype"), shape = guide_legend(title = "Identity"))
)
pca_plot
# save the plot
ggsave("pca_plot_genotype_and_bone_manual_selection.png", path = file.path("..","figures"), width = width, height = height, units = "in", dpi = 600)


# pca analysis
pca_df <- as.data.frame(res.pca$x)
pca_df <- cbind(metadata_df, pca_df)

# plot pca
pca_plot <- (
    ggplot(pca_df, aes(x = PC1, y = PC2, color = Metadata_genotype, shape = Metadata_side))
    + geom_point()
    + theme_bw()
    + guides(color = guide_legend(title = "Genotype"), shape = guide_legend(title = "Side"))
)
pca_plot
# save the plot
ggsave("pca_plot_genotype_and_side_manual_selection.png", path = file.path("..","figures"), width = width, height = height, units = "in", dpi = 600)


# pca analysis
pca_df <- as.data.frame(res.pca$x)
pca_df <- cbind(metadata_df, pca_df)

# plot pca
pca_plot <- (
    ggplot(pca_df, aes(x = PC1, y = PC2, color = Metadata_side))
    + geom_point()
    + theme_bw()
    + guides(color = guide_legend(title = "Genotype"), shape = guide_legend(title = "Side"))
)
pca_plot
# save the plot
ggsave("pca_plot_side_manual_selection.png", path = file.path("..","figures"), width = width, height = height, units = "in", dpi = 600)


pca_df
