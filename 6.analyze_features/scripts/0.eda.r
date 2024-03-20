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
    + guides(color = guide_legend(title = "Genotype"), shape = guide_legend(title = "Identity"))
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
pca_plot
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


# split the data by genotype
unique(df$Metadata_genotype)
# remove metadata columns
tmp_df <- df %>% select(-contains("Metadata"))
tmp_df$Metadata_genotype <- df$Metadata_genotype
tmp_df$Metadata_identity <- df$Metadata_identity

agg_df <- tmp_df %>% group_by(Metadata_identity, Metadata_genotype) %>% summarize_all(c("mean", "sd"))
# remove grouping
agg_df <- agg_df %>% ungroup()
agg_df


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

