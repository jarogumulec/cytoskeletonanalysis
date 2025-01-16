//-----------------------------------------------------
// Manual Focal Adhesion Measurements Macro
//-----------------------------------------------------

// 1) Prompt user for the input folder
inputFolder = getDirectory("Choose the folder with your CroppedCells .tif files");
// If the user cancels or no folder is selected, getDirectory() returns an empty string
if (inputFolder == "") {
    exit("No folder selected. Macro aborted.");
}

// 2) Get list of files in that folder
list = getFileList(inputFolder);

// Keep setBatchMode(false) so we can see images and draw ROIs interactively
setBatchMode(false);

// 3) Loop through the files
for (i = 0; i < list.length; i++) {
    
    // Process only .tif files
    if (!endsWith(list[i], ".tif")) {
        continue;
    }
    
    // -- Base name for output files (remove ".tif")
    baseName = replace(list[i], ".tif", "");

    // ---------------------------------------------------------------
    // A) OPEN THE IMAGE
    // ---------------------------------------------------------------
    fullPath = inputFolder + list[i];
    open(fullPath);
    originalTitle = getTitle(); // e.g. "40x_LM5_A6_..."

    // ---------------------------------------------------------------
    // B) MAKE MAX PROJECTION
    // ---------------------------------------------------------------
    run("Z Project...", "projection=[Max Intensity]");
    // The new projection might be titled "MAX_originalTitle"
    maxProjTitle = getTitle();

    // ---------------------------------------------------------------
    // C) KEEP ONLY FA & ACTIN CHANNELS (REMOVE CHANNEL 1)
    // ---------------------------------------------------------------
    // Switch to composite mode in case it's not already
    run("Make Composite", "display=Composite");

    // Make substack of channels 2-3 (adjust if FA channel differs)
    run("Make Substack...", "channels=2-3");
    substackTitle = getTitle(); // e.g. "MAX_...-1"

    // Rename the substack to a simpler name
    rename("TEMP_SUBSTACK");

    // ---------------------------------------------------------------
    // D) ENHANCE CONTRAST ON SLICE #1 (FA CHANNEL)
    // ---------------------------------------------------------------
    selectWindow("TEMP_SUBSTACK");
    // Move to slice 1
    setSlice(1);
    resetMinAndMax();
    run("Enhance Contrast", "saturated=0.35");

    // ---------------------------------------------------------------
    // E) CLEAR ROI MANAGER
    // ---------------------------------------------------------------
    roiManager("reset");

    // ---------------------------------------------------------------
    // F) WAIT FOR USER TO DRAW FAs & ADD THEM TO ROI MANAGER
    // ---------------------------------------------------------------
    waitForUser("Manual FA Annotation",
        "1) Draw ROIs around each FA (slice #1 = FAs).\n" +
        "2) Press 't' (Add) in ROI Manager for each ROI.\n" +
        "3) Click 'OK' when finished."
    );

    // ---------------------------------------------------------------
    // G) MEASURE FAs
    // ---------------------------------------------------------------
    run("Clear Results");  
    run("Set Measurements...", "area mean bounding shape redirect=None decimal=3");
    roiManager("Measure");

    // ---------------------------------------------------------------
    // H) SAVE MEASUREMENTS & ROIs
    // ---------------------------------------------------------------
    resultsPath = inputFolder + baseName + "_FAs.csv";
    roisetPath  = inputFolder + baseName + "_FAs_RoiSet.zip";

    saveAs("Results", resultsPath);
    roiManager("Save", roisetPath);

    // ---------------------------------------------------------------
    // I) CLOSE ALL IMAGES
    // ---------------------------------------------------------------
    // Close TEMP_SUBSTACK
    if (isOpen("TEMP_SUBSTACK")) {
       selectWindow("TEMP_SUBSTACK");
       close();
    }
    // Close the max projection
    if (isOpen(maxProjTitle)) {
       selectWindow(maxProjTitle);
       close();
    }
    // Close the original
    if (isOpen(originalTitle)) {
       selectWindow(originalTitle);
       close();
    }

    // Clear results again to avoid any leftover lines
    run("Clear Results");
}

print("Finished measuring FAs in all .tif images!");
