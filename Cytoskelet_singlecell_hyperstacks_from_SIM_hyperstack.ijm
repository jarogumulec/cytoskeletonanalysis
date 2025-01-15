// =========================================================================
// Crop Cells & Measure Original Morphology
// =========================================================================

// Folder paths
inputFolder  = "z:\\999992-nanobiomed\\Elyra SuperResolution\\GACR PB\\Vinculin_TPM2_F-act\\StrF-WF-StdF\\";
outputFolder = inputFolder + "CroppedCells\\";

// Load the Max Projections image (Troponin_Max_projs.tif)
maxProjsFile = inputFolder + "Troponin_Max_projs.tif";
open(maxProjsFile);

// Load the ROI set (RoiSet.zip)
roiSetFile = inputFolder + "RoiSet.zip";
roiManager("Open", roiSetFile);

// Create output directory if it doesn't exist
if (!File.exists(outputFolder)) {
    File.makeDirectory(outputFolder);
}

setBatchMode(true);

// For each ROI (cell)
nROIs = roiManager("count");
for (roiIndex = 0; roiIndex < nROIs; roiIndex++) {
    
    // Select the ROI in the Max Projections image
    roiManager("Select", roiIndex);

    // ---------------------------------------------------------------------
    // 1. MEASURE MORPHOLOGY ON MAX PROJS (ORIGINAL ROI)
    // ---------------------------------------------------------------------
    // Clear results from any previous measurement
    run("Clear Results");

    // Configure the measurement settings (Area + Shape Descriptors)
    // "shape" includes parameters like Circularity, Aspect Ratio, Roundness, etc.
    run("Set Measurements...", "area shape redirect=None decimal=3");

    // Measure the current ROI (on the MaxProjs image)
    run("Measure");

    // Save the measurement results. We'll build a filename based on the slice label:
    sliceLabel = getInfo("slice.label");  // e.g. "MaxProj_001"
    baseName   = replace(sliceLabel, "MaxProj_", "");  // e.g. "001"
    measureFileName = outputFolder + baseName + "_cell_" + roiIndex + "_measurements.csv";
    saveAs("Results", measureFileName);

    // ---------------------------------------------------------------------
    // 2. ENLARGE ROI FOR CROPPING
    // ---------------------------------------------------------------------
    run("Enlarge...", "enlarge=5");
    
    // ---------------------------------------------------------------------
    // 3. OPEN & CROP THE CORRESPONDING CZI HYPERSTACK
    // ---------------------------------------------------------------------
    // Derive the .czi filename
    cziFileName = baseName + ".czi"; // e.g. "001.czi"
    cziFilePath = inputFolder + cziFileName;

    // Check if the file exists
    if (!File.exists(cziFilePath)) {
        print("Error: File does not exist - " + cziFilePath);
        continue; // Skip to the next ROI
    }

    // Open the .czi file via Bio-Formats
    run("Bio-Formats Importer", "open=[" + cziFilePath + "] autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
    ORIGINAL = getImageID();

    // Restore the *enlarged* selection
    run("Restore Selection");

    // Clear everything outside the ROI (all channels, all slices)
    setBackgroundColor(0, 0, 0);
    run("Clear Outside", "stack");

    // Crop
    run("Crop");

    // Construct filename for the cropped hyperstack
    croppedFileName = outputFolder + baseName + "_cropped_cell_" + roiIndex + ".tif";

    // Save cropped hyperstack
    saveAs("Tiff", croppedFileName);

    // Close current image
    close();
}

setBatchMode(false);

print("Cropping and original morphology measurements are complete.");
