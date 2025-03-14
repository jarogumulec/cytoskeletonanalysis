

# coloc analysis TPM2-actin

# library preequisities ----
library(dplyr)
library(ggpubr)
library(pheatmap)
library(readxl)

# cells data load and summary to one table ----
setwd("D:/temp/25-01-17 - FA tropomyosin PB")



TPM2_actin_coloc <- read_excel("25-02-17 kolokalizace/TPM2_actin_coloc_processed.xlsx")
# load pre-processed FA table to merge w colocs
cells_FAs_merged <- read.csv("cells_FAs_merged.csv")
#to merge later


# corelation of col coef pracovni -------


# Select the numeric columns 2:18 from the data
numeric_data <- TPM2_actin_coloc[,c(5:8,10:14,16:17)]



# Calculate the correlation matrix (using pairwise complete observations)
correlation_matrix <- cor(numeric_data, use = "pairwise.complete.obs")

# Define a color palette for the heatmap
color_palette <- colorRampPalette(c("blue", "white", "red"))(50)

# Plot the heatmap with clustering
pheatmap(
  correlation_matrix,
  clustering_distance_rows = "euclidean",  # Row clustering distance
  clustering_distance_cols = "euclidean",  # Column clustering distance
  clustering_method = "complete",          # Clustering method
  color = color_palette,
  breaks = seq(-1, 1, length.out = 51),    # Scale the color bar around 0
  main = "Clustered Correlation Matrix",   # Title of the heatmap
  fontsize_row = 6,                        # Row font size
  fontsize_col = 6                         # Column font size
)




# coloc of selected coefs vs treatments -----------
colnames(TPM2_actin_coloc)

ggplot(TPM2_actin_coloc, aes(x = treatment, y = `M1.tresh.(fraction of A overlapping B)`)) +
  geom_boxplot(outlier.shape = NA) +
  geom_point(position = position_jitterdodge(seed = 1, dodge.width = 0.8, jitter.width = 0.3), 
             size = 0.05, aes(color = factor(treatment))) +
  labs(x = "",
       y = "M1 (tresholded)",
       fill = "group") +
  theme_bw() +
  theme(axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
        axis.text.y = element_text(color = "black", size = 6.3),
        axis.title = element_text(size = 8),
        legend.position = "none") +
  stat_compare_means(method = "t.test",
                     ref.group = "control",  # Use 'control' as the reference group
                     label = "p.signif",       # Show significance levels
                     size = 2,
                     vjust = -1) +
  scale_y_continuous(limits = c(0, 1))


# Save the plot
ggsave("M1.svg", plot = last_plot(),
       width = 3, height = 4, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)


ggplot(TPM2_actin_coloc, aes(x = treatment, y = `M2.tresh (fraction of B overlapping A)`)) +
  geom_boxplot(outlier.shape = NA) +
  geom_point(position = position_jitterdodge(seed = 1, dodge.width = 0.8, jitter.width = 0.3), 
             size = 0.05, aes(color = factor(treatment))) +
  labs(x = "",
       y = "M2 (tresholded)",
       fill = "group") +
  theme_bw() +
  theme(axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
        axis.text.y = element_text(color = "black", size = 6.3),
        axis.title = element_text(size = 8),
        legend.position = "none") +
  stat_compare_means(method = "t.test",
                     ref.group = "control",  # Use 'control' as the reference group
                     label = "p.signif",       # Show significance levels
                     size = 2,
                     vjust = -1) +
  scale_y_continuous(limits = c(0, 1))


# Save the plot
ggsave("M2.svg", plot = last_plot(),
       width = 3, height = 4, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)




#mpmtresh M1M2

ggplot(TPM2_actin_coloc, aes(x = treatment, y = `M1.(fraction of A overlapping B)`)) +
  geom_boxplot(outlier.shape = NA) +
  geom_point(position = position_jitterdodge(seed = 1, dodge.width = 0.8, jitter.width = 0.3), 
             size = 0.05, aes(color = factor(treatment))) +
  labs(x = "",
       y = "M1",
       fill = "group") +
  theme_bw() +
  theme(axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
        axis.text.y = element_text(color = "black", size = 6.3),
        axis.title = element_text(size = 8),
        legend.position = "none") +
  stat_compare_means(method = "t.test",
                     ref.group = "control",  # Use 'control' as the reference group
                     label = "p.signif",       # Show significance levels
                     size = 2,
                     vjust = -1) +
  scale_y_continuous(limits = c(0, 1))


# Save the plot
ggsave("M1_NON.svg", plot = last_plot(),
       width = 3, height = 4, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)


ggplot(TPM2_actin_coloc, aes(x = treatment, y = `M2 (fraction of B overlapping A)`)) +
  geom_boxplot(outlier.shape = NA) +
  geom_point(position = position_jitterdodge(seed = 1, dodge.width = 0.8, jitter.width = 0.3), 
             size = 0.05, aes(color = factor(treatment))) +
  labs(x = "",
       y = "M2",
       fill = "group") +
  theme_bw() +
  theme(axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
        axis.text.y = element_text(color = "black", size = 6.3),
        axis.title = element_text(size = 8),
        legend.position = "none") +
  stat_compare_means(method = "t.test",
                     ref.group = "control",  # Use 'control' as the reference group
                     label = "p.signif",       # Show significance levels
                     size = 2,
                     vjust = -1) +
  scale_y_continuous(limits = c(0, 1))


# Save the plot
ggsave("M2_NT.svg", plot = last_plot(),
       width = 3, height = 4, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)



ggplot(TPM2_actin_coloc, aes(x = treatment, y = Overlap.coef)) +
  geom_boxplot(outlier.shape = NA) +
  geom_point(position = position_jitterdodge(seed = 1, dodge.width = 0.8, jitter.width = 0.3), 
             size = 0.05, aes(color = factor(treatment))) +
  labs(x = "",
       y = "Overlap coef",
       fill = "group") +
  theme_bw() +
  theme(axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
        axis.text.y = element_text(color = "black", size = 6.3),
        axis.title = element_text(size = 8),
        legend.position = "none") +
  stat_compare_means(method = "t.test",
                     ref.group = "control",  # Use 'control' as the reference group
                     label = "p.signif",       # Show significance levels
                     size = 2,
                     vjust = -1) +
  scale_y_continuous(limits = c(0, 1))


# Save the plot
ggsave("overlap.svg", plot = last_plot(),
       width = 3, height = 4, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)



ggplot(TPM2_actin_coloc, aes(x = treatment, y = Overlap.coef.tresh)) +
  geom_boxplot(outlier.shape = NA) +
  geom_point(position = position_jitterdodge(seed = 1, dodge.width = 0.8, jitter.width = 0.3), 
             size = 0.05, aes(color = factor(treatment))) +
  labs(x = "",
       y = "Overlap coef (tresholded)",
       fill = "group") +
  theme_bw() +
  theme(axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
        axis.text.y = element_text(color = "black", size = 6.3),
        axis.title = element_text(size = 8),
        legend.position = "none") +
  stat_compare_means(method = "t.test",
                     ref.group = "control",  # Use 'control' as the reference group
                     label = "p.signif",       # Show significance levels
                     size = 2,
                     vjust = -1) +
  scale_y_continuous(limits = c(0, 1))


# Save the plot
ggsave("overlap_tresh.svg", plot = last_plot(),
       width = 3, height = 4, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)





ggplot(TPM2_actin_coloc, aes(x = treatment, y = k1.tresh)) +
  geom_boxplot(outlier.shape = NA) +
  geom_point(position = position_jitterdodge(seed = 1, dodge.width = 0.8, jitter.width = 0.3), 
             size = 0.05, aes(color = factor(treatment))) +
  labs(x = "",
       y = "k1 (tresholded)",
       fill = "group") +
  theme_bw() +
  theme(axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
        axis.text.y = element_text(color = "black", size = 6.3),
        axis.title = element_text(size = 8),
        legend.position = "none") +
  stat_compare_means(method = "t.test",
                     ref.group = "control",  # Use 'control' as the reference group
                     label = "p.signif",       # Show significance levels
                     size = 2,
                     vjust = -1) +
  scale_y_continuous(limits = c(0, NA))


# Save the plot
ggsave("k1_tresh.svg", plot = last_plot(),
       width = 3, height = 4, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)


ggplot(TPM2_actin_coloc, aes(x = treatment, y = k2.tresh)) +
  geom_boxplot(outlier.shape = NA) +
  geom_point(position = position_jitterdodge(seed = 1, dodge.width = 0.8, jitter.width = 0.3), 
             size = 0.05, aes(color = factor(treatment))) +
  labs(x = "",
       y = "k2 (tresholded)",
       fill = "group") +
  theme_bw() +
  theme(axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
        axis.text.y = element_text(color = "black", size = 6.3),
        axis.title = element_text(size = 8),
        legend.position = "none") +
  stat_compare_means(method = "t.test",
                     ref.group = "control",  # Use 'control' as the reference group
                     label = "p.signif",       # Show significance levels
                     size = 2,
                     vjust = -1) +
  scale_y_continuous(limits = c(0, NA))


# Save the plot
ggsave("k2_tresh.svg", plot = last_plot(),
       width = 3, height = 4, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)




ggplot(TPM2_actin_coloc, aes(x = treatment, y = k1)) +
  geom_boxplot(outlier.shape = NA) +
  geom_point(position = position_jitterdodge(seed = 1, dodge.width = 0.8, jitter.width = 0.3), 
             size = 0.05, aes(color = factor(treatment))) +
  labs(x = "",
       y = "k1",
       fill = "group") +
  theme_bw() +
  theme(axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
        axis.text.y = element_text(color = "black", size = 6.3),
        axis.title = element_text(size = 8),
        legend.position = "none") +
  stat_compare_means(method = "t.test",
                     ref.group = "control",  # Use 'control' as the reference group
                     label = "p.signif",       # Show significance levels
                     size = 2,
                     vjust = -1) +
  scale_y_continuous(limits = c(0, NA))


# Save the plot
ggsave("k1.svg", plot = last_plot(),
       width = 3, height = 4, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)


ggplot(TPM2_actin_coloc, aes(x = treatment, y = k2)) +
  geom_boxplot(outlier.shape = NA) +
  geom_point(position = position_jitterdodge(seed = 1, dodge.width = 0.8, jitter.width = 0.3), 
             size = 0.05, aes(color = factor(treatment))) +
  labs(x = "",
       y = "k2",
       fill = "group") +
  theme_bw() +
  theme(axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
        axis.text.y = element_text(color = "black", size = 6.3),
        axis.title = element_text(size = 8),
        legend.position = "none") +
  stat_compare_means(method = "t.test",
                     ref.group = "control",  # Use 'control' as the reference group
                     label = "p.signif",       # Show significance levels
                     size = 2,
                     vjust = -1) +
  scale_y_continuous(limits = c(0, NA))


# Save the plot
ggsave("k2.svg", plot = last_plot(),
       width = 3, height = 4, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)





# merge with FA Data---------

merged_table <- merge(TPM2_actin_coloc, cells_FAs_merged, by = "cellid", all = TRUE)



colnames(merged_table)


c(16,17,18,20, 32,23,28,33)




# Select the numeric columns 2:18 from the data
numeric_data <- merged_table[,c(16,17,18,20, 32,23,28,33)]



# Calculate the correlation matrix (using pairwise complete observations)
correlation_matrix <- cor(numeric_data, use = "pairwise.complete.obs")

# Define a color palette for the heatmap
color_palette <- colorRampPalette(c("blue", "white", "red"))(50)

# Plot the heatmap with clustering
pheatmap(
  correlation_matrix,
  clustering_distance_rows = "euclidean",  # Row clustering distance
  clustering_distance_cols = "euclidean",  # Column clustering distance
  clustering_method = "complete",          # Clustering method
  color = color_palette,
  breaks = seq(-1, 1, length.out = 51),    # Scale the color bar around 0
  main = "Clustered Correlation Matrix",   # Title of the heatmap
  fontsize_row = 6,                        # Row font size
  fontsize_col = 6                         # Column font size
)



# plot vybranyhc------



ggplot(merged_table, aes(x = `M1.tresh.(fraction of A overlapping B)`, y = AR, color = treatment.x)) +
  geom_point(position = position_jitter(seed = 1, width = 0.3), size = 0.05) +
  labs(x = "M1", y = "Cell aspect ratio", color = "Treatment") +
  theme_bw() +
  theme(
    axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
    axis.text.y = element_text(color = "black", size = 6.3),
    axis.title = element_text(size = 8))


ggsave("M1_AR.svg", plot = last_plot(),
       width = 6, height = 3.5, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)

ggplot(merged_table, aes(x = `M2.tresh (fraction of B overlapping A)`, y = AR, color = treatment.x)) +
  geom_point(position = position_jitter(seed = 1, width = 0.3), size = 0.05) +
  labs(x = "M2", y = "Cell aspect ratio", color = "Treatment") +
  theme_bw() +
  theme(
    axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
    axis.text.y = element_text(color = "black", size = 6.3),
    axis.title = element_text(size = 8))


ggsave("M2_AR.svg", plot = last_plot(),
       width = 6, height = 3.5, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)





ggplot(merged_table, aes(x = `M1.tresh.(fraction of A overlapping B)`, y = FA_cell_area_proportion, color = treatment.x)) +
  geom_point(position = position_jitter(seed = 1, width = 0.3), size = 0.05) +
  labs(x = "M1", y = "FA cell area prop.", color = "Treatment") +
  theme_bw() +
  theme(
    axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
    axis.text.y = element_text(color = "black", size = 6.3),
    axis.title = element_text(size = 8))


ggsave("M1_faareaprop.svg", plot = last_plot(),
       width = 6, height = 3.5, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)

ggplot(merged_table, aes(x = `M2.tresh (fraction of B overlapping A)`, y = FA_cell_area_proportion, color = treatment.x)) +
  geom_point(position = position_jitter(seed = 1, width = 0.3), size = 0.05) +
  labs(x = "M2", y = "FA cell area prop.", color = "Treatment") +
  theme_bw() +
  theme(
    axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
    axis.text.y = element_text(color = "black", size = 6.3),
    axis.title = element_text(size = 8))


ggsave("M2_faareaprop.svg", plot = last_plot(),
       width = 6, height = 3.5, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)





ggplot(merged_table, aes(x = `M1.tresh.(fraction of A overlapping B)`, y = FA_N, color = treatment.x)) +
  geom_point(position = position_jitter(seed = 1, width = 0.3), size = 0.05) +
  labs(x = "M1", y = "N of FAs per cell", color = "Treatment") +
  theme_bw() +
  theme(
    axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
    axis.text.y = element_text(color = "black", size = 6.3),
    axis.title = element_text(size = 8))


ggsave("M1_FAN.svg", plot = last_plot(),
       width = 6, height = 3.5, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)

ggplot(merged_table, aes(x = `M2.tresh (fraction of B overlapping A)`, y = FA_N, color = treatment.x)) +
  geom_point(position = position_jitter(seed = 1, width = 0.3), size = 0.05) +
  labs(x = "M2", y = "N of FAs per cell", color = "Treatment") +
  theme_bw() +
  theme(
    axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
    axis.text.y = element_text(color = "black", size = 6.3),
    axis.title = element_text(size = 8))


ggsave("M2_FAN.svg", plot = last_plot(),
       width = 6, height = 3.5, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)




ggplot(merged_table, aes(x = `M1.tresh.(fraction of A overlapping B)`, y = Area, color = treatment.x)) +
  geom_point(position = position_jitter(seed = 1, width = 0.3), size = 0.05) +
  labs(x = "M1", y = "Cell area(um2)", color = "Treatment") +
  theme_bw() +
  theme(
    axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
    axis.text.y = element_text(color = "black", size = 6.3),
    axis.title = element_text(size = 8))


ggsave("M1_area.svg", plot = last_plot(),
       width = 6, height = 3.5, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)

ggplot(merged_table, aes(x = `M2.tresh (fraction of B overlapping A)`, y = Area, color = treatment.x)) +
  geom_point(position = position_jitter(seed = 1, width = 0.3), size = 0.05) +
  labs(x = "M2", y = "Cell area(um2)", color = "Treatment") +
  theme_bw() +
  theme(
    axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
    axis.text.y = element_text(color = "black", size = 6.3),
    axis.title = element_text(size = 8))


ggsave("M2_area.svg", plot = last_plot(),
       width = 6, height = 3.5, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)






ggplot(merged_table, aes(x = `M1.tresh.(fraction of A overlapping B)`, y = FA_Area_Mean, color = treatment.x)) +
  geom_point(position = position_jitter(seed = 1, width = 0.3), size = 0.05) +
  labs(x = "M1", y = "avg.FA area(um2)", color = "Treatment") +
  theme_bw() +
  theme(
    axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
    axis.text.y = element_text(color = "black", size = 6.3),
    axis.title = element_text(size = 8))


ggsave("M1_FAarea.svg", plot = last_plot(),
       width = 6, height = 3.5, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)

ggplot(merged_table, aes(x = `M2.tresh (fraction of B overlapping A)`, y = FA_Area_Mean, color = treatment.x)) +
  geom_point(position = position_jitter(seed = 1, width = 0.3), size = 0.05) +
  labs(x = "M2", y = "avg.FA area(um2)", color = "Treatment") +
  theme_bw() +
  theme(
    axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
    axis.text.y = element_text(color = "black", size = 6.3),
    axis.title = element_text(size = 8))


ggsave("M2_FAarea.svg", plot = last_plot(),
       width = 6, height = 3.5, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)
