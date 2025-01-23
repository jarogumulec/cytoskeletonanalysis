# ImageJ Macros for Cytoskeleton Single-Cell Analysis

These ImageJ macros help you format and isolate single-cell regions from a set of 3-channel SIM (Structured Illumination Microscopy) hyperstack files. They were **inspired by** the [MitoGraphTools](https://github.com/vianamp/MitoGraphTools) macros, which similarly split large z-stack images into smaller single-cell z-stacks for individual analyses.

## Table of Contents

1. [Overview](#overview)  
2. [Macro 1: Cytoskelet_Maxprojs_from_ch1_SIM_hyperstack.ijm](#macro-1-cytoskelet_maxprojs_from_ch1_sim_hyperstackijm)  
   - [Purpose](#purpose)  
   - [Usage](#usage)  
3. [Macro 2: Cytoskelet_singlecell_hyperstacks_from_SIM_hyperstack.ijm](#macro-2-cytoskelet_singlecell_hyperstacks_from_sim_hyperstackijm)  
   - [Purpose](#purpose-1)  
   - [Usage](#usage-1)  
   - [Important Notes](#important-notes)  
4. [Macro 3: Cytoskelet_focaladhesion_manual_analyser.ijm](#macro-3-cytoskelet_focaladhesion_manual_analyserijm)  
   - [Purpose](#purpose-2)  
   - [Usage](#usage-2)  
5. R script for analsis
6. Colocalisation analysis
7. [Acknowledgments](#acknowledgments)

---

## Overview

1. **Cytoskelet_Maxprojs_from_ch1_SIM_hyperstack.ijm**  
   - **Generates a max-intensity projection** of 3-channel SIM hyperstacks, but then **retains only channel 1** (for example, an actin channel).  
   - Each resulting max-projection is saved as `MaxProj_<originalFilename>.tif` in a specified output folder.

2. **Cytoskelet_singlecell_hyperstacks_from_SIM_hyperstack.ijm**  
   - Uses the **max-projection** images and **ROI sets** (RoiSet.zip) you draw on them to:
     1. **Measure morphological features** on the *original* ROI (no padding).  
     2. **Enlarge the ROI** slightly (for a safety margin).  
     3. **Open the corresponding 3-channel SIM hyperstack**.  
     4. **Crop each hyperstack** so that only the cell of interest remains.  
   - Automatically saves both:
     - A measurements file (`.csv`) containing shape descriptors (area, circularity, etc.).  
     - A cropped hyperstack (`.tif`) for each ROI.

3. **Cytoskelet_focaladhesion_manual_analyser.ijm**  
   - Assumes you have a 2- or 3-channel image (e.g., the **cropped cells** from the second macro) where **channel 1** is focal adhesions.  
   - Lets you **manually annotate** each focal adhesion in the ROI Manager, measuring their area, intensity, and shape descriptors.  
   - Saves a results CSV (`_FAs.csv`) and a corresponding set of ROIs (`_FAs_RoiSet.zip`).

These macros streamline preparing single-cell images for various downstream analyses (e.g., cytoskeletal studies, morphological quantifications, etc.).

---

## Macro 1: Cytoskelet_Maxprojs_from_ch1_SIM_hyperstack.ijm

### Purpose

Creates single-channel **max-intensity projections** from 3-channel SIM hyperstacks. Specifically:
- Uses **Bio-Formats** to import each `.czi` or `.tif` from the input folder.  
- Projects *all slices* (z-dimension) into a single slice (max-intensity).  
- **Retains only channel 1** (the user-specified channel of interest, e.g., actin).  
- Saves each resulting max-projection as `MaxProj_<originalFilename>.tif` into a `MaxProjections/` subfolder.

### Usage

1. **Open ImageJ/Fiji** and select **`Plugins > Macros > Run...`**.  
2. **Choose** `Cytoskelet_Maxprojs_from_ch1_SIM_hyperstack.ijm`.  
3. When prompted, **select** an input directory that contains `.czi` or `.tif` hyperstack files.  
4. The macro automatically:  
   - Creates a subfolder named `MaxProjections/` in the same directory (if it doesn’t exist).  
   - Processes each valid image file.  
   - Saves `MaxProj_<filename>.tif` in that subfolder.  

**Tip:** Ensure that file names are not excessively long (under ~60 characters) and do not contain spaces. If needed, replace spaces with underscores `_`.

---

## Macro 2: Cytoskelet_singlecell_hyperstacks_from_SIM_hyperstack.ijm

### Purpose

Splits a large 3-channel SIM hyperstack into **single-cell** hyperstack `.tif` files. Additionally, it:
- **Measures morphological features** (area, shape, circularity, etc.) from the **original** ROI drawn on the **max-projection**.  
- **Enlarges** the ROI by a small margin (e.g., 5 px) to avoid cropping out peripheral structures.  
- **Clears and crops** each hyperstack so that only the ROI of interest remains (for all channels and z-slices).  
- Saves both the **cropped hyperstack** and the **morphology measurements** (as a `.csv`).

### Usage

1. **Obtain or generate** a `Troponin_Max_projs.tif` (or similarly named file) using the first macro (or by any other means).  
2. **Open `Troponin_Max_projs.tif`** in ImageJ.  
3. **Draw ROIs** around each cell you wish to crop.  
4. **Save the ROIs** via **`ROI Manager > More > Save...`** as `RoiSet.zip` in the *same* folder.  
5. **Run** `Cytoskelet_singlecell_hyperstacks_from_SIM_hyperstack.ijm` from ImageJ.  
6. **Verify** (and if needed, modify) the `inputFolder` and `outputFolder` paths in the macro to match your local structure.  
7. The macro will:  
   - Open the `Troponin_Max_projs.tif`.  
   - Load the `RoiSet.zip`.  
   - Measure each ROI’s area/shape and save a CSV.  
   - Enlarge the ROI by 5 pixels.  
   - Open the corresponding `.czi` hyperstack using Bio-Formats.  
   - Clear everything outside the ROI (all channels, all z-slices) and crop.  
   - Save the final cropped hyperstack as `.tif`.  

### Important Notes

- **Batch Mode**: The macro runs in `setBatchMode(true);`, which keeps ImageJ from showing each opened file. This speeds up processing but means you won’t see intermediate results.  
- **Measurements**: Each ROI’s morphological data is saved to a unique `.csv`. If you want all measurements in a single file, you can modify the macro by removing `run("Clear Results")` in each iteration and saving once after processing all cells.  
- **Enlargement**: Adjust the `enlarge=5` parameter if you need a bigger or smaller padding around your cells.

---

## Macro 3: Cytoskelet_focaladhesion_manual_analyser.ijm

### Purpose

Provides a **manual** way to identify and measure focal adhesions (FAs) within each single-cell image (e.g., the result of Macro 2). You can:

- Load a **cropped** cell image that has at least one channel dedicated to focal adhesions.  
- Optionally remove unneeded channels (e.g., keep FA channel + actin channel).  
- **Manually draw** ROI(s) around each focal adhesion in the ROI Manager.  
- Measure area, intensity, shape descriptors, etc., for each FA.  
- Save the resulting measurements to a CSV and the ROIs to a `.zip`.

### Usage

1. **Prepare** a folder containing your **cropped** single-cell `.tif` files from Macro 2.  
2. **Open ImageJ/Fiji** and select **`Plugins > Macros > Run...`**.  
3. **Choose** `Cytoskelet_focaladhesion_manual_analyser.ijm`.  
4. The macro will:
   - Automatically open each `.tif` in the specified folder.  
   - **Max-project** it (if necessary).  
   - **Remove unwanted channels** (e.g., keep channel 1 for FAs, channel 2 for actin).  
   - **Enhance contrast** (on the FA channel).  
   - **Wait** for you to **manually draw** ROIs around each FA.  
   - Measure each ROI, saving a CSV named after the original file (e.g. `filename_FAs.csv`) plus a ROI set `.zip` (e.g. `filename_FAs_RoiSet.zip`).  
   - Close the images and proceed to the next file.

5. **Open** the CSV files in Excel or other data-analysis tools to see the area, mean intensity, bounding rectangle, shape descriptors, etc. of each annotated focal adhesion.

---

## Results plotting

cell_and_FA_analysis.R putts all cell metric together with focal adhesion metrics and creates boxplots and simple correlation matrix

---


## Colocalisation analysis

needed for analysis
- Colocation plugin https://imagej.net/plugins/jacop : download the JACoP_.jar file
- Cytoskelet_colocalisation_preprocess.ijm - macro that prepares the images

Procedure:
1. open the macro in Fiji
2. open the first image and click Run on the macro
3. in the JACoP colocaliser window set the first three: Pearson, k1,k2 and M1, M2 (just do it once, they will stay there)
4. in Treshold set so that only cells are red
5. click the analysis and then save the text output somehow systematically

---


## Acknowledgments

These macros were **inspired by** the ImageJ macros provided in the [MitoGraphTools repository](https://github.com/vianamp/MitoGraphTools), particularly the ideas behind:

- `GenFramesMaxProjs.ijm` for generating a max-projection stack to easily select cells.  
- `CropCells.ijm` for efficiently cropping individual ROIs to single-cell z-stacks.

We adapted and extended these principles for cytoskeletal SIM data.
