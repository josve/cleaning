# This script downloads the source data for the cleaning assignment,
# into the data directory
if (!file.exists("data"))
{
    dir.create("data")
}

# Keep track of when the data was downloaded, by writing the current
# timestamp in a file.
dateDownloaded <- date()
dateFile <- file("data/downloadedDate.txt")
writeLines(as.character(dateDownloaded), dateFile)
close(dateFile)

# Download the dataset
zippedDataSetPath <- "data/UCI_HAR_Dataset.zip"
download.file(
    url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
    destfile = zippedDataSetPath,
    quiet = FALSE,
    method = "curl")

# Unzip the dataset
unzip(zipfile = zippedDataSetPath,
      overwrite = TRUE,
      exdir = "data")
