library("dplyr")

# First validate that all paths and files exist
dataDir <- "data"

if (!file.exists(dataDir))
{
   dataDir <- "."
}

dataSetDir <- paste(dataDir, "UCI HAR Dataset", sep="/")

if (!file.exists(dataSetDir))
{
    stop("dataset directory does not exist.")
}

trainDir <- paste(dataSetDir, "train", sep="/")

if (!file.exists(trainDir))
{
    stop("training directory does not exist.")
}

testDir <- paste(dataSetDir, "test", sep="/")

if (!file.exists(testDir))
{
    stop("test directory does not exist.")
}

trainDir <- paste(dataSetDir, "train", sep="/")

if (!file.exists(trainDir))
{
    stop("training directory does not exist.")
}

# Load the data set and assign column names.

### activity_labels
activityLabelsPath <- paste(dataSetDir, "activity_labels.txt", sep="/")
if (!file.exists(activityLabelsPath))
{
    stop("activity labels file does not exist.")
}

activityLabelsDF <- 
    read.delim(
         activityLabelsPath, 
         header=FALSE, 
         sep = " ", 
         colClasses=c("numeric", "character"),
         stringsAsFactors = FALSE)

activityLabelsDF <- tbl_df(activityLabelsDF)

names(activityLabelsDF) <- c("id", "activity")

### features
featuresPath <- paste(dataSetDir, "features.txt", sep="/")
if (!file.exists(featuresPath))
{
    stop("features file does not exist.")
}

featuresDF <- 
    read.delim(
        featuresPath, 
        header=FALSE, 
        sep = " ", 
        colClasses=c("numeric", "character"),
        stringsAsFactors = FALSE)

featuresDF <- tbl_df(featuresDF)

names(featuresDF) <- c("id", "name")

### Now we handle the training data set.
xTrainPath <- paste(trainDir, "X_train.txt", sep="/")
if (!file.exists(xTrainPath))
{
    stop(paste(xTrainPath,"file does not exist."))
}

XtrainDF <- 
    read.table(
        xTrainPath, 
        header=FALSE, 
        sep = "", 
        colClasses="numeric",
        stringsAsFactors = FALSE)

XtrainDF <- tbl_df(XtrainDF)

# assign names from the features table.
names(XtrainDF) <- featuresDF$name

# filter out all columns that don't contain mean() or std()
mean_names <- grepl("mean()", names(XtrainDF), fixed=TRUE)
std_names <- grepl("std()", names(XtrainDF), fixed=TRUE)
filtered_names <- mean_names | std_names
XtrainDF <- XtrainDF[,filtered_names]

### y_train
yTrainPath <- paste(trainDir, "y_train.txt", sep="/")
if (!file.exists(yTrainPath))
{
    stop(paste(yTrainPath,"file does not exist."))
}

YtrainDF <- 
    read.table(
        yTrainPath, 
        header=FALSE, 
        sep = "", 
        colClasses="numeric",
        stringsAsFactors = FALSE)

YtrainDF <- tbl_df(YtrainDF)
names(YtrainDF) <- c("label")

# subject_train.txt
subjectTrainPath <- paste(trainDir, "subject_train.txt", sep="/")
if (!file.exists(subjectTrainPath))
{
    stop(paste(subjectTrainPath,"file does not exist."))
}

subjectTrainDF <- 
    read.table(
        subjectTrainPath, 
        header=FALSE, 
        sep = "", 
        colClasses="numeric",
        stringsAsFactors = FALSE)

subjectTrainDF <- tbl_df(subjectTrainDF)
names(subjectTrainDF) <- c("subject")

# Append all cols to a train dataset.
train <- XtrainDF
train$label <- YtrainDF$label
train$subject <- subjectTrainDF$subject

# join in the activity label
train <- merge(train, activityLabelsDF, by.x="label", by.y="id")
train <- tbl_df(train)

### Now we do the same for the test data set.
### X_test
xTestPath <- paste(testDir, "X_test.txt", sep="/")
if (!file.exists(xTestPath))
{
    stop(paste(xTestPath,"file does not exist."))
}

XtestDF <- 
    read.table(
        xTestPath, 
        header=FALSE, 
        sep = "", 
        colClasses="numeric",
        stringsAsFactors = FALSE)

XtestDF <- tbl_df(XtestDF)
names(XtestDF) <- featuresDF$name

# Filter out mean/std columns
mean_names <- grepl("mean()", names(XtestDF), fixed=TRUE)
std_names <- grepl("std()", names(XtestDF), fixed=TRUE)
filtered_names <- mean_names | std_names
XtestDF <- XtestDF[,filtered_names]


### y_test
yTestPath <- paste(testDir, "y_test.txt", sep="/")
if (!file.exists(yTestPath))
{
    stop(paste(yTestPath,"file does not exist."))
}

YtestDF <- 
    read.table(
        yTestPath, 
        header=FALSE, 
        sep = "", 
        colClasses="numeric",
        stringsAsFactors = FALSE)

YtestDF <- tbl_df(YtestDF)
names(YtestDF) <- c("label")

# subject_test.txt
subjectTestPath <- paste(testDir, "subject_test.txt", sep="/")
if (!file.exists(subjectTestPath))
{
    stop(paste(subjectTestPath,"file does not exist."))
}

subjectTestDF <- 
    read.table(
        subjectTestPath, 
        header=FALSE, 
        sep = "", 
        colClasses="numeric",
        stringsAsFactors = FALSE)

subjectTestDF <- tbl_df(subjectTestDF)
names(subjectTestDF) <- c("subject")

# Append all cols to a test dataset.
test <- XtestDF
test$label <- YtestDF$label
test$subject <- subjectTestDF$subject

# join in the activity label
test <- merge(test, activityLabelsDF, by.x="label", by.y="id")
test <- tbl_df(test)


# Now we combine the rows in the test and training data set.
test$origin <- "test"
train$origin <- "training"
combined <- rbind(test, train)
combined <- tbl_df(combined)

# we don't need the label column anymore.
combined$label <- NULL

# Perform some cleanup on the column names.
names(combined) <- gsub("()", "", names(combined), fixed=TRUE)
names(combined) <- gsub("-mean", "Mean", names(combined), fixed=TRUE)
names(combined) <- gsub("-std", "StandardDeviation", names(combined), fixed=TRUE)
names(combined) <- gsub("-", "", names(combined), perl=TRUE)

# Now we compute the mean of all measurements grouped by subject and activity, ignoring
# origin column
grouped_combined <- 
    combined %>% 
    select (-origin) %>% 
    group_by(subject, activity)

result <- grouped_combined %>% summarise_each(funs(mean))

# write the result to a tidy.txt file.
write.table(result, file="tidy.txt", row.name=FALSE)
