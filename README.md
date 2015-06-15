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

The run_analysis.R script assumes that you have previously downloaded and unziped the previously
mentioned data set into either the current directory or a data directory below the current dir.

It requires the dplyr package to be installed, which can be done using:
install.packages("dplyr")

It first validates that all expected files exist and then reads the datasets into R first into 
separate data.frames.

First we load the activityLabels dataset into the activityLabelsDF data.frame. We assign the 
columns the names "id" and "activity". We will later use this table to get nicer names for 
activities, as the main data set only contains the id and not the nicer activity labels.

Next we load the features data set which gives names for the measurements performed in the
main data sets, the rows in this data set will be used as column names later on in another
table. The table has two columns but one is essentially only a row number so we will only use
the name column later on.

The raw data sets basically have all data duplicated as training and test data, the same operations
are performed first on the training data set and then on the test dataset so we will only describe
the operations here once.

We read the entire X_train.txt data set which contain postprocessed measurements from the sensor
as described in the features_info.txt file (included with the downloaded raw data). We know that
the variables here (561) matches the names in the features.txt so we assign column names from the
values in that table.

Since we are only interested in mean or standard deviation variables we filter out all columns
where the column name doesn't contain mean() or std().

The Y_train.txt data set contains labels that describe the training action performed when the
measurements where taken. Since these match row-by-row with the X_train.txt data set we can just
assign the column a name "label" and append the column to the X_train dataset later on.

Similiarily we read the subject_train.txt dataset which specifies the identifier of which subject
was using the phone when the sensor readings was taken. These also match row-by-row so we can
just assign the column a name "subject" and append the column to the X_train dataset later on.

We create a new data.frame with the X_train data (filtered out the non-mean/std columns), where
the label and subject columns has been appended, this data.frame is called train.

Using the merge command we merge into the activity label from the activityLabelsDF data.frame.

Then we perform the same operations with the test data set and perform the same operations
resulting in test data.frame.

Finally we can now perform a union (rbind) between the training and test data set, we also add
a column (origin) that can be used to identify which rows the data has come from. It won't
be used in this analysis but could be useful in other cases.

We perform some cleanup on the column names by removing "()", giving nicer names for Mean and 
Standard Deviation and removing dashes. Since the names are actually quite good we keep them
mostly as is with a mix of upper and lower casing. The are actually quite hard to read when
they are only in lower case and applications like RStudio provides quite nice auto-complete
functionality that automatically assigns the correct case.

Finally we compute the mean of all measurements grouped by subject and activity, ignoring the
origin column and we write the result to a file called tidy.txt in the current directory.

