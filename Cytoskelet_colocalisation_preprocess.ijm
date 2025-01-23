// simple script to preprocess files before colocalisation analysis


// prerequisities ----
// instal colocalisation plugin for image "JACoP", 
// availible here: https://github.com/fabricecordelieres/IJ-Plugin_JACoP/releases



// how to ----
// open first image (manually) in your folder, then run macro. 
// macro only splits the image to two channels, which are needed for 
// the colocalisation analysis, then coloc plugin JACoP can run.
// in JACoP select Pearson, overlapp coef, M1 and M2, k1, k2 (with treshold)
// then move treshold so only cell is red 
// copy the results to some table where numbers can be acessed easily.


// 1) Capture the title of the original hyperstack
originalTitle = getTitle();

// 2) Split the channels into individual images
run("Split Channels");

// 3) Automatically determine the window titles of the split channels
//    Channel 1, Channel 2, and Channel 3 will be named like "HyStackName (C1)", etc.
ch1Title = "C1-" + originalTitle;
ch2Title = "C2-" + originalTitle;
ch3Title = "C3-" + originalTitle;

// 4) Close Channel 2
if (isOpen(ch2Title)) {
    selectWindow(ch2Title);
    close();
}

// 5) Close the original hyperstack
if (isOpen(originalTitle)) {
    selectWindow(originalTitle);
    close();
}

// Optional: Rename C1 and C3 to something more descriptive
if (isOpen(ch1Title)) {
    selectWindow(ch1Title);
    rename(originalTitle + "_tropomyosin");
}
if (isOpen(ch3Title)) {
    selectWindow(ch3Title);
    rename(originalTitle + "_actin");
}


//run the coloc plugin
run("JACoP ");