// ==========================================================================\ 
// Adjusted Crop Cells Macro with Selection Fix
// ==========================================================================\

// Folder paths
inputFolder = "z:\\999992-nanobiomed\\Elyra SuperResolution\\GACR PB\\Vinculin_TPM2_F-act\\StrF-WF-StdF\\"; // Input folder containing your data
outputFolder = inputFolder + "CroppedCells\\"; // Output folder to save cropped cells

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
for (roi = 0; roi < roiManager("count"); roi++) {
    
    // Select the ROI in the Max Projections image
    roiManager("Select", roi);

    // Expand ROI slightly for a safety margin
    run("Enlarge...", "enlarge=5");
    
    // Get the slice label (corresponding filename for hyperstack .czi files)
    _FileName = getInfo("slice.label");
    _FileName = replace(_FileName, "MaxProj_", ""); // Remove the "MaxProj_" prefix
    _FileName = _FileName + ".czi"; // Add the .czi extension
    
    // Construct the full path to the .czi file
    cziFilePath = inputFolder + _FileName;

    // Check if the .czi file exists
    if (!File.exists(cziFilePath)) {
        print("Error: File does not exist - " + cziFilePath);
        continue; // Skip this ROI if the file does not exist
    }

    // Open the corresponding .czi file using Bio-Formats Importer
    run("Bio-Formats Importer", "open=[" + cziFilePath + "] autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
    ORIGINAL = getImageID();

    // Restore the selection (ROI) in the .czi file
    run("Restore Selection");

	// Clear everything outside the ROI (in the CZI)
    setBackgroundColor(0, 0, 0);
	run("Clear Outside", "stack");

    // Get the ROI bounding box (x, y, width, height)
    getSelectionBounds(x, y, w, h); // Store the coordinates and size of the ROI

    // Create a rectangle using the bounds
    makeRectangle(x, y, w, h);
    
       
    
    // Crop the image using the ROI bounding box
    run("Crop");

    // Construct the filename for the cropped image
    croppedFileName = outputFolder + _FileName.replace(".czi", "") + "_cropped_cell_" + roi + ".tif";

    // Save the cropped image
    saveAs("Tiff", croppedFileName);

    // Close the current original image
    close();
}

setBatchMode(false);

print("Cell cropping is complete.");
