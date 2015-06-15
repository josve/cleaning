* Summarization and cleanup of data form Samsung Galaxy smartphone sensors:

The data is located at the following URL:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

It is described here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The data was cleaned using the run_analysis.R script that generates a tidy.txt data set.

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

The resulting data set contains 180 rows and 68 columns:

The subject column contains an identifier uniqely identifying which subject performed the operations
measured by the sensors on the smartphone. The identifier is just a numeric identifier that 
provides no additional information.

The activity column contains a string describing the operation performed by the subject when
the sensor measurements where taken.

The remaining 66 columns contains averages of measurements grouped by subject and activity.

The "raw" data set describes how these measurements are processed pretty well in the 
features_info.txt file.

Basically if the columns starts with "t" then it's a time domain measurements but if it starts
with "f" it has been passed thought the fast fourier transform into the frequency domain.

"The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc* and tGravityAcc*) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk* and tBodyGyroJerk*). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'XYZ' at the end is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc*
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag"

The measurements either contain "StandardDeviation" or "Mean" indicating that the value is the
mean or standard deviation of the measurements. Regardless of this we have also taken the mean
of those measurements split by subject and activity.


