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
4. [Acknowledgments](#acknowledgments)  

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

## Acknowledgments

These macros were **inspired by** the ImageJ macros provided in the [MitoGraphTools repository](https://github.com/vianamp/MitoGraphTools), particularly the ideas behind:

- `GenFramesMaxProjs.ijm` for generating a max-projection stack to easily select cells.  
- `CropCells.ijm` for efficiently cropping individual ROIs to single-cell z-stacks.

We adapted and extended these principles for cytoskeletal SIM data.

---

## License

*(Consider including an open-source license, such as MIT, GPL, or BSD. For example:)*

