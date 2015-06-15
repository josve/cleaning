# Cleanup of data from Samsung Galaxy smartphone sensors

This repository contains two R-scripts that downloads and processes the raw data.

* download.R

The data is located at the following URL:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The download.R scripts takes care of downloading that data set into a new data directory,
it also unzips the zip-file. It doesn't do any modification of the source data.

In addition to the unzipping of the data it also creates a new text file "downloadedDate.txt"
with the timestamp when the data was downloaded for future reference.

* run_analysis.R
