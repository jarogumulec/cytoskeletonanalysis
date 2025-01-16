// Folder paths


// 1) Prompt user for the input folder
inputFolder = getDirectory("Choose the folder with your CroppedCells .tif files");
// If the user cancels or no folder is selected, getDirectory() returns an empty string
if (inputFolder == "") {
    exit("No folder selected. Macro aborted.");
}



outputFolder = inputFolder + "MaxProjections\\";

// Ensure output folder exists, if not create it
if (!File.exists(outputFolder)) {
    File.makeDirectory(outputFolder);
}

// Get list of files in the input folder
list = getFileList(inputFolder);
setBatchMode(true);

// Loop through the files in the folder
for (i = 0; i < list.length; i++) {
    // Only process image files (e.g., .tif, .czi)
    if (endsWith(list[i], ".tif") || endsWith(list[i], ".czi")) {
        // Construct the full path to the current file
        currentFile = inputFolder + list[i];

        // Open the file using Bio-Formats Importer with parameters to suppress the dialog
        run("Bio-Formats Importer", "open=[" + currentFile + "] autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");

        // Ensure the image is loaded correctly
        wait(1000); // Wait for 1 second to ensure the image is loaded
        
        // Perform Z projection (Max Intensity) for all slices in the 3 channels
        run("Z Project...", "projection=[Max Intensity]");

        // Remove channels 2 and 3, keeping only channel 1 (actin)
        run("Make Substack...", "channels=1");

        // Check if the image is valid and not empty
        if (getTitle() != "") {
            // Attempt to save the resulting image as a stack (only channel 1, max projection)
            saveAs("Tiff", outputFolder + "MaxProj_" + list[i]);
            print("Saved: " + list[i]);
        } else {
            print("Error: Image is invalid or empty, skipping: " + list[i]);
        }

        // Close the current image
        close();
    }
}

setBatchMode(false);
