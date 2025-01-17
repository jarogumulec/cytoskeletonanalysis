
# Analysis of FAs and cytoskeleton
# wwhats done before: analysed FAs and cells from SIM hyperstacks using macros 
# Cytoskelet_Maxprojs_from_ch1_SIM_hyperstack.ijm
# Cytoskelet_singlecell_hyperstacks_from_SIM_hyperstack.ijm
# Cytoskelet_focaladhesion_manual_analyser.ijm

# then the FA and ell csvs are put to individual folders from which analysis is done


# library preequisities ----
library(dplyr)
library(ggpubr)
library(pheatmap)

# cells data load and summary to one table ----
setwd("D:/temp/25-01-17 - FA tropomyosin PB/cells")


# Get a list of all CSV files in the working directory
file_list <- list.files(pattern = "\\.csv$", full.names = TRUE)

# Initialize an empty list to store data
data_list <- list()

for (file in file_list) {
  # Read the file
  data <- tryCatch(read.csv(file, stringsAsFactors = FALSE), error = function(e) NULL)
  
  # Skip the file if it is empty or fails to load
  if (is.null(data) || nrow(data) == 0) {
    message(paste("Skipping empty or invalid file:", basename(file)))
    next
  }
  
  # Add filename column
  data$filename <- basename(file)
  
  # Store the data in the list
  data_list[[file]] <- data
}

# Combine all data frames into one
cells <- bind_rows(data_list)


cells <- cells %>%
  rename(cellid = filename) %>%
  mutate(cellid = gsub("_measurements\\.csv$", "", cellid))


# View the combined data
print(head(cells))

# Optionally save the combined data to a new CSV file
write.csv(cells, "../cells.csv", row.names = FALSE)


# FAs data load and summary to one table----


setwd("D:/temp/25-01-17 - FA tropomyosin PB/FAs")


file_list <- list.files(pattern = "\\.csv$", full.names = TRUE)

# Initialize an empty data frame to store results
FAs <- data.frame()

# Loop through each file and calculate required metrics
for (file in file_list) {
  # Read the CSV file
  data <- read.csv(file)
  
  # Calculate the summary statistics
  area_mean <- mean(data$Area, na.rm = TRUE)
  mean_mean <- mean(data$Mean, na.rm = TRUE)
  width_mean <- mean(data$Width, na.rm = TRUE)
  height_mean <- mean(data$Height, na.rm = TRUE)
  circ_mean <- mean(data$Circ., na.rm = TRUE)
  ar_mean <- mean(data$AR, na.rm = TRUE)
  round_mean <- mean(data$Round, na.rm = TRUE)
  solidity_mean <- mean(data$Solidity, na.rm = TRUE)
  area_sum <- sum(data$Area, na.rm = TRUE)
    n_count <- nrow(data)
  
  # Create a data frame for the current file's summary
  file_summary <- data.frame(
    FA_Area_Mean = area_mean,
    FA_Mean_Mean = mean_mean,
    FA_Width_Mean = width_mean,
    FA_Height_Mean = height_mean,
    FA_Circ_Mean = circ_mean,
    FA_AR_Mean = ar_mean,
    FA_Round_Mean = round_mean,
    FA_Solidity_Mean = solidity_mean,
    FA_Area_Sum = area_sum,
    FA_N = n_count,
    cellid = gsub("_FAs.csv$", "", basename(file)) # Remove "_FAs.csv" from filename
  )
  
  # Append the file summary to the summary table
  FAs <- rbind(FAs, file_summary)
}

# Save the summary table as a CSV file
write.csv(FAs, "../FAs.csv", row.names = FALSE)

# Print the summary table
print(FAs)

# colocalisation ------------

# here once the coloc actin+tropo will be done will go


# put together cells and FAs ---------

# Assuming the two tables are already loaded as summary_FAs and cells

# Merge the tables by the common column 'cellid'
cells_FAs_merged <- merge(cells, FAs, by = "cellid", all = TRUE)


# Create a new column by dividing FA_Area_Sum by Area (FA fraction area)
cells_FAs_merged <- cells_FAs_merged %>%
  mutate(FA_cell_area_proportion = FA_Area_Sum / Area)

# number of FAs per 1 um2 of cell area
cells_FAs_merged <- cells_FAs_merged %>%
  mutate(FA_N_per_area = FA_N / Area)




# removes the column X which persisted in cells table 
cells_FAs_merged <- cells_FAs_merged %>% select(-X) 

# extract the treatment from the filename
cells_FAs_merged$treatment <- sub(".*?_.*?_(.*?)_.*", "\\1", cells_FAs_merged$cellid)




# Print the first few rows of the merged table
print(head(cells_FAs_merged))




# Save the merged table as a CSV file
write.csv(cells_FAs_merged, "../cells_FAs_merged.csv", row.names = FALSE)

#close everyrything except the merged table 
rm(list = setdiff(ls(), "cells_FAs_merged"))



#Analysis -------------


# Visualize charts for cells 

ggplot(cells_FAs_merged, aes(x = treatment, y = Area)) +
  geom_boxplot(outlier.shape = NA) +
  geom_point(position = position_jitter(seed = 1, width = 0.3),
             size = 0.05, aes(color = factor(treatment))) +
  labs(x = "",
       y = "Area (um2)",
       fill = "group") +
  theme_bw() +
  theme(axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
        axis.text.y = element_text(color = "black", size = 6.3),
        axis.title = element_text(size = 8),
        legend.position = "none") +
  stat_compare_means(method = "t.test",
                     ref.group = "WT", # Use WT as the reference group
                     label = "p.signif", # Shows significance levels
                     p.adjust.method = "BH", # Apply BH correction
                     size = 2,
                     vjust = -1) +
  scale_y_continuous(limits = c(0, 3000)) # Adjust y-axis limits if needed


# Save the plot
ggsave("../Treatment_vs_Area.svg", plot = last_plot(),
       width = 3, height = 4, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)


ggplot(cells_FAs_merged, aes(x = treatment, y = Circ.)) +
  geom_boxplot(outlier.shape = NA) +
  geom_point(position = position_jitter(seed = 1, width = 0.3),
             size = 0.05, aes(color = factor(treatment))) +
  labs(x = "",
       y = "Cell Circularity",
       fill = "group") +
  theme_bw() +
  theme(axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
        axis.text.y = element_text(color = "black", size = 6.3),
        axis.title = element_text(size = 8),
        legend.position = "none") +
  stat_compare_means(method = "t.test",
                     ref.group = "WT", # Use WT as the reference group
                     label = "p.signif", # Shows significance levels
                     p.adjust.method = "BH", # Apply BH correction
                     size = 2,
                     vjust = -1) +
  scale_y_continuous(limits = c(0, NA)) # Adjust y-axis limits if needed


# Save the plot
ggsave("../Treatment_vs_cellcirc.svg", plot = last_plot(),
       width = 3, height = 4, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)


ggplot(cells_FAs_merged, aes(x = treatment, y = AR)) +
  geom_boxplot(outlier.shape = NA) +
  geom_point(position = position_jitter(seed = 1, width = 0.3),
             size = 0.05, aes(color = factor(treatment))) +
  labs(x = "",
       y = "Cell aspect ratio",
       fill = "group") +
  theme_bw() +
  theme(axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
        axis.text.y = element_text(color = "black", size = 6.3),
        axis.title = element_text(size = 8),
        legend.position = "none") +
  stat_compare_means(method = "t.test",
                     ref.group = "WT", # Use WT as the reference group
                     label = "p.signif", # Shows significance levels
                     p.adjust.method = "BH", # Apply BH correction
                     size = 2,
                     vjust = -1) +
  scale_y_continuous(limits = c(0, NA)) # Adjust y-axis limits if needed


# Save the plot
ggsave("../Treatment_vs_cellar.svg", plot = last_plot(),
       width = 3, height = 4, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)



ggplot(cells_FAs_merged, aes(x = treatment, y = Solidity)) +
  geom_boxplot(outlier.shape = NA) +
  geom_point(position = position_jitter(seed = 1, width = 0.3),
             size = 0.05, aes(color = factor(treatment))) +
  labs(x = "",
       y = "Cell Solidity",
       fill = "group") +
  theme_bw() +
  theme(axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
        axis.text.y = element_text(color = "black", size = 6.3),
        axis.title = element_text(size = 8),
        legend.position = "none") +
  stat_compare_means(method = "t.test",
                     ref.group = "WT", # Use WT as the reference group
                     label = "p.signif", # Shows significance levels
                     p.adjust.method = "BH", # Apply BH correction
                     size = 2,
                     vjust = -1) +
  scale_y_continuous(limits = c(0, NA)) # Adjust y-axis limits if needed


# Save the plot
ggsave("../Treatment_vs_cellsolid.svg", plot = last_plot(),
       width = 3, height = 4, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)


ggplot(cells_FAs_merged, aes(x = treatment, y = AR)) +
  geom_boxplot(outlier.shape = NA) +
  geom_point(position = position_jitter(seed = 1, width = 0.3),
             size = 0.05, aes(color = factor(treatment))) +
  labs(x = "",
       y = "Cell aspect ratio",
       fill = "group") +
  theme_bw() +
  theme(axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
        axis.text.y = element_text(color = "black", size = 6.3),
        axis.title = element_text(size = 8),
        legend.position = "none") +
  stat_compare_means(method = "t.test",
                     ref.group = "WT", # Use WT as the reference group
                     label = "p.signif", # Shows significance levels
                     p.adjust.method = "BH", # Apply BH correction
                     size = 2,
                     vjust = -1) +
  scale_y_continuous(limits = c(0, NA)) # Adjust y-axis limits if needed


# Save the plot
ggsave("../Treatment_vs_cellar.svg", plot = last_plot(),
       width = 3, height = 4, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)



# FA charts-


ggplot(cells_FAs_merged, aes(x = treatment, y = FA_N)) +
  geom_boxplot(outlier.shape = NA) +
  geom_point(position = position_jitter(seed = 1, width = 0.3),
             size = 0.05, aes(color = factor(treatment))) +
  labs(x = "",
       y = "N FAs per cell",
       fill = "group") +
  theme_bw() +
  theme(axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
        axis.text.y = element_text(color = "black", size = 6.3),
        axis.title = element_text(size = 8),
        legend.position = "none") +
  stat_compare_means(method = "t.test",
                     ref.group = "WT", # Use WT as the reference group
                     label = "p.signif", # Shows significance levels
                     p.adjust.method = "BH", # Apply BH correction
                     size = 2,
                     vjust = -1) +
  scale_y_continuous(limits = c(0, NA)) # Adjust y-axis limits if needed


# Save the plot
ggsave("../Treatment_vs_FA_N.svg", plot = last_plot(),
       width = 3, height = 4, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)


ggplot(cells_FAs_merged, aes(x = treatment, y = FA_N_per_area)) +
  geom_boxplot(outlier.shape = NA) +
  geom_point(position = position_jitter(seed = 1, width = 0.3),
             size = 0.05, aes(color = factor(treatment))) +
  labs(x = "",
       y = "N FAs per cell area (/um2)",
       fill = "group") +
  theme_bw() +
  theme(axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
        axis.text.y = element_text(color = "black", size = 6.3),
        axis.title = element_text(size = 8),
        legend.position = "none") +
  stat_compare_means(method = "t.test",
                     ref.group = "WT", # Use WT as the reference group
                     label = "p.signif", # Shows significance levels
                     p.adjust.method = "BH", # Apply BH correction
                     size = 2,
                     vjust = -1) +
  scale_y_continuous(limits = c(0, NA)) # Adjust y-axis limits if needed


# Save the plot
ggsave("../Treatment_vs_FA_N_area.svg", plot = last_plot(),
       width = 3, height = 4, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)


ggplot(cells_FAs_merged, aes(x = treatment, y = FA_cell_area_proportion)) +
  geom_boxplot(outlier.shape = NA) +
  geom_point(position = position_jitter(seed = 1, width = 0.3),
             size = 0.05, aes(color = factor(treatment))) +
  labs(x = "",
       y = "Area proportion of cell by FA",
       fill = "group") +
  theme_bw() +
  theme(axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
        axis.text.y = element_text(color = "black", size = 6.3),
        axis.title = element_text(size = 8),
        legend.position = "none") +
  stat_compare_means(method = "t.test",
                     ref.group = "WT", # Use WT as the reference group
                     label = "p.signif", # Shows significance levels
                     p.adjust.method = "BH", # Apply BH correction
                     size = 2,
                     vjust = -1) +
  scale_y_continuous(limits = c(0, NA), labels = scales::percent_format(accuracy = 1)) # Adjust y-axis limits if needed


# Save the plot
ggsave("../Treatment_vs_FA_arearatio.svg", plot = last_plot(),
       width = 3, height = 4, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)




ggplot(cells_FAs_merged, aes(x = treatment, y = FA_Area_Mean)) +
  geom_boxplot(outlier.shape = NA) +
  geom_point(position = position_jitter(seed = 1, width = 0.3),
             size = 0.05, aes(color = factor(treatment))) +
  labs(x = "",
       y = "Single FA Area (um2)",
       fill = "group") +
  theme_bw() +
  theme(axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
        axis.text.y = element_text(color = "black", size = 6.3),
        axis.title = element_text(size = 8),
        legend.position = "none") +
  stat_compare_means(method = "t.test",
                     ref.group = "WT", # Use WT as the reference group
                     label = "p.signif", # Shows significance levels
                     p.adjust.method = "BH", # Apply BH correction
                     size = 2,
                     vjust = -1) +
  scale_y_continuous(limits = c(0, NA)) # Adjust y-axis limits if needed


# Save the plot
ggsave("../Treatment_vs_FA_area.svg", plot = last_plot(),
       width = 3, height = 4, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)


ggplot(cells_FAs_merged, aes(x = treatment, y = FA_AR_Mean)) +
  geom_boxplot(outlier.shape = NA) +
  geom_point(position = position_jitter(seed = 1, width = 0.3),
             size = 0.05, aes(color = factor(treatment))) +
  labs(x = "",
       y = "Single FA aspect ratio",
       fill = "group") +
  theme_bw() +
  theme(axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
        axis.text.y = element_text(color = "black", size = 6.3),
        axis.title = element_text(size = 8),
        legend.position = "none") +
  stat_compare_means(method = "t.test",
                     ref.group = "WT", # Use WT as the reference group
                     label = "p.signif", # Shows significance levels
                     p.adjust.method = "BH", # Apply BH correction
                     size = 2,
                     vjust = -1) +
  scale_y_continuous(limits = c(0, NA)) # Adjust y-axis limits if needed


# Save the plot
ggsave("../Treatment_vs_FA_AR.svg", plot = last_plot(),
       width = 3, height = 4, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)




# correlations---------



# Select the numeric columns 2:18 from the data
numeric_data <- cells_FAs_merged[, 2:18]

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


