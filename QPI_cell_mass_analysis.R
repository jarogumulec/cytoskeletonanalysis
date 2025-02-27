# 25-02-04 - holograf mass bunek PB LM5 TPM2.3 UP
# analysis of mass/density/area of cells using QPI, 210 FOVs (30x7)

setwd("D:/temp/25-01-17 - FA tropomyosin PB/25-02-04 - holograf mass bunek PB LM5 TPM2.3 UP")

# Load necessary libraries
library(dplyr)
library(readr)
library(ggplot2)
library(ggpubr)


# data load --------------

# Get the list of all CSV files in the working directory
file_list <- list.files(pattern = "\\.csv$", full.names = TRUE)

# Function to read a semicolon-separated CSV and add a column with the filename as treatment
read_and_label <- function(file) {
  df <- read_delim(file, delim = ";")  # Read the CSV file with semicolon separator
  df$treatment <- gsub(".csv$", "", basename(file))  # Extract filename without .csv
  return(df)
}

# Read and merge all CSV files
merged_data <- bind_rows(lapply(file_list, read_and_label))

# View first rows of merged data
head(merged_data)

# Optionally, save merged data to a new CSV file (semicolon-separated)
write_delim(merged_data, "merged_data.csv", delim = ";")


# histograms - chck of data -------


colnames(merged_data)


# Define the columns to check
columns_to_check <- c("Mass [ pg ]", "Area [ µm² ]", "Density [ pg/µm² ]",
                      "Perimeter [ µm ]", "Circularity [ % ]")

# Loop through each column and create a histogram
for (col in columns_to_check) {
  p <- ggplot(merged_data_filtered, aes(x = .data[[col]])) +
    geom_histogram(color = "black", fill = "lightblue", bins = 30) +
    theme_bw() +
    labs(title = paste("Histogram of", col),
         x = col,
         y = "Frequency") +
    theme(axis.text.x = element_text(size = 8),
          axis.text.y = element_text(size = 8),
          axis.title = element_text(size = 10))
  
  # Print the histogram
  print(p)
}




# Function to calculate descriptive statistics, including non-outlier range
calculate_statistics <- function(data, column) {
  values <- data[[column]]
  
  # Remove NAs
  values <- values[!is.na(values)]
  
  # Compute basic stats
  min_val <- min(values)
  max_val <- max(values)
  mean_val <- mean(values)
  median_val <- median(values)
  sd_val <- sd(values)
  
  # Compute IQR and non-outlier range
  Q1 <- quantile(values, 0.25)
  Q3 <- quantile(values, 0.75)
  IQR_val <- Q3 - Q1
  non_outlier_min <- Q1 - 1.5 * IQR_val
  non_outlier_max <- Q3 + 1.5 * IQR_val
  
  return(data.frame(
    Variable = column,
    Min = min_val,
    Max = max_val,
    Mean = mean_val,
    Median = median_val,
    SD = sd_val,
    Non_Outlier_Min = non_outlier_min,
    Non_Outlier_Max = non_outlier_max
  ))
}

# Apply function to all selected columns and combine results
descriptive_stats <- bind_rows(lapply(columns_to_check, calculate_statistics, data = merged_data))

# Display the table
print(descriptive_stats)




#filtering dataset for outliers -------
# 35390 cells total, filtering out several extreme vals

# Filter the dataset based on given criteria
merged_data_filtered <- merged_data %>%
  filter(`Mass [ pg ]` < 1300,  # Keep only values below 1500 pg
         `Perimeter [ µm ]` < 595,
         `Area [ µm² ]` >= 60, `Area [ µm² ]` <= 4500,
         `Density [ pg/µm² ]` >= 0.05, `Density [ pg/µm² ]` <= 1.5)  # Keep only values between 60 and 5000 µm²

# Display summary of the filtered dataset
print(dim(merged_data_filtered))  # Check the number of remaining rows

# Save the filtered dataset to a new CSV file
write.csv(merged_data_filtered, "filtered_cells_FAs.csv", row.names = FALSE)

# 97 cells filtered out.


# plotting ----------------


columns_to_check <- c("Mass [ pg ]", "Area [ µm² ]", "Density [ pg/µm² ]",
                      "Perimeter [ µm ]", "Circularity [ % ]")




# violin

merged_data_filtered$treatment <- as.factor(merged_data_filtered$treatment)

#mass
ggplot(merged_data_filtered, aes(x = treatment, y = `Mass [ pg ]`, fill = treatment)) +
  geom_violin(alpha = 0.5) +
  geom_boxplot(width = 0.2, outlier.shape = NA) +
  labs(x = "", y = "Cell dry mass (pg)") +
  theme_bw() +
  theme(axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
        axis.text.y = element_text(color = "black", size = 6.3),
        axis.title = element_text(size = 8),
        legend.position = "none") +
  stat_compare_means(method = "t.test",
                     ref.group = "LM5 WT",
                     label = "p.signif",
                     p.adjust.method = "BH",
                     size = 2,
                     vjust = -1) +
  scale_y_continuous(limits = c(0, NA))



ggsave("../mass.svg", plot = last_plot(),
       width = 3, height = 5, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)




#area
ggplot(merged_data_filtered, aes(x = treatment, y = `Area [ µm² ]`, fill = treatment)) +
  geom_violin(alpha = 0.5) +
  geom_boxplot(width = 0.2, outlier.shape = NA) +
  labs(x = "", y = "Area (µm²)") +
  theme_bw() +
  theme(axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
        axis.text.y = element_text(color = "black", size = 6.3),
        axis.title = element_text(size = 8),
        legend.position = "none") +
  stat_compare_means(method = "t.test",
                     ref.group = "LM5 WT",
                     label = "p.signif",
                     p.adjust.method = "BH",
                     size = 2,
                     vjust = -1) +
  scale_y_continuous(limits = c(0, NA))



ggsave("../area.svg", plot = last_plot(),
       width = 3, height = 5, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)


ggplot(merged_data_filtered, aes(x = treatment, y = `Density [ pg/µm² ]`, fill = treatment)) +
  geom_violin(alpha = 0.5) +
  geom_boxplot(width = 0.2, outlier.shape = NA) +
  labs(x = "", y = "Density (pg/µm²)") +
  theme_bw() +
  theme(axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
        axis.text.y = element_text(color = "black", size = 6.3),
        axis.title = element_text(size = 8),
        legend.position = "none") +
  stat_compare_means(method = "t.test",
                     ref.group = "LM5 WT",
                     label = "p.signif",
                     p.adjust.method = "BH",
                     size = 2,
                     vjust = -1) +
  scale_y_continuous(limits = c(0, NA))



ggsave("../density.svg", plot = last_plot(),
       width = 3, height = 5, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)


ggplot(merged_data_filtered, aes(x = treatment, y = `Perimeter [ µm ]`, fill = treatment)) +
  geom_violin(alpha = 0.5) +
  geom_boxplot(width = 0.2, outlier.shape = NA) +
  labs(x = "", y = "Perimeter (µm)") +
  theme_bw() +
  theme(axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
        axis.text.y = element_text(color = "black", size = 6.3),
        axis.title = element_text(size = 8),
        legend.position = "none") +
  stat_compare_means(method = "t.test",
                     ref.group = "LM5 WT",
                     label = "p.signif",
                     p.adjust.method = "BH",
                     size = 2,
                     vjust = -1) +
  scale_y_continuous(limits = c(0, NA))



ggsave("../perim.svg", plot = last_plot(),
       width = 3, height = 5, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)


ggplot(merged_data_filtered, aes(x = treatment, y = `Circularity [ % ]`, fill = treatment)) +
  geom_violin(alpha = 0.5) +
  geom_boxplot(width = 0.2, outlier.shape = NA) +
  labs(x = "", y = "Circularity") +
  theme_bw() +
  theme(axis.text.x = element_text(color = "black", size = 6.3, angle = 90, vjust = 0.5, hjust = 1),
        axis.text.y = element_text(color = "black", size = 6.3),
        axis.title = element_text(size = 8),
        legend.position = "none") +
  stat_compare_means(method = "t.test",
                     ref.group = "LM5 WT",
                     label = "p.signif",
                     p.adjust.method = "BH",
                     size = 2,
                     vjust = -1) +
  scale_y_continuous(limits = c(0, NA))



ggsave("../circ.svg", plot = last_plot(),
       width = 3, height = 5, units = "cm", dpi = 300, scale = 1, limitsize = TRUE)



# descr stats of filtered data ---------------


# Function to calculate descriptive statistics per group, including non-outlier range and N
calculate_statistics <- function(data, column) {
  data %>%
    group_by(treatment) %>%
    summarise(
      N = sum(!is.na(.data[[column]])),  # Count non-NA values
      Min = min(.data[[column]], na.rm = TRUE),
      Max = max(.data[[column]], na.rm = TRUE),
      Mean = mean(.data[[column]], na.rm = TRUE),
      Median = median(.data[[column]], na.rm = TRUE),
      SD = sd(.data[[column]], na.rm = TRUE),
      Q1 = quantile(.data[[column]], 0.25, na.rm = TRUE),
      Q3 = quantile(.data[[column]], 0.75, na.rm = TRUE),
      IQR = Q3 - Q1,
      Non_Outlier_Min = Q1 - 1.5 * IQR,
      Non_Outlier_Max = Q3 + 1.5 * IQR
    ) %>%
    mutate(Variable = column) %>%  # Add column name for reference
    select(Variable, treatment, everything())  # Reorder columns
}

# Apply function to all selected columns and combine results
descriptive_stats <- bind_rows(lapply(columns_to_check, calculate_statistics, data = merged_data_filtered))

# Display the table
print(descriptive_stats)

# Function to calculate descriptive statistics per group, including non-outlier range and N
calculate_statistics <- function(data, column) {
  data %>%
    group_by(treatment) %>%
    summarise(
      N = sum(!is.na(.data[[column]])),  # Count non-NA values
      Min = min(.data[[column]], na.rm = TRUE),
      Max = max(.data[[column]], na.rm = TRUE),
      Mean = mean(.data[[column]], na.rm = TRUE),
      Median = median(.data[[column]], na.rm = TRUE),
      SD = sd(.data[[column]], na.rm = TRUE),
      Q1 = quantile(.data[[column]], 0.25, na.rm = TRUE),
      Q3 = quantile(.data[[column]], 0.75, na.rm = TRUE),
      IQR = Q3 - Q1,
      Non_Outlier_Min = Q1 - 1.5 * IQR,
      Non_Outlier_Max = Q3 + 1.5 * IQR
    ) %>%
    mutate(Variable = column) %>%  # Add column name for reference
    select(Variable, treatment, everything())  # Reorder columns
}

# Apply function to all selected columns and combine results
descriptive_stats <- bind_rows(lapply(columns_to_check, calculate_statistics, data = merged_data))

# Display the table
print(descriptive_stats)

# Save the descriptive statistics table to a CSV file
write.csv(descriptive_stats, "descriptive_statistics.csv", row.names = FALSE)


