################################################################################
## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
################################################################################
## check and install data.table and reshare2 package
if (!require("data.table")) {
    install.packages("data.table")
}


if (!require("reshape2")) {
    install.packages("reshape2")
}


require("data.table")
require("reshape2")

##Fix URL reading for knitr.
setInternet2(TRUE)

#### Downloading Data
# Set the url for the file to download
localfilepath = "./UCI HAR Dataset.zip"


# Check to see if the zip file is there. If it is exists then don't download it.
if (file.exists(localfilepath)){
    warning("Zip file exists in the working directory.")
} else {
    fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileurl,localfilepath)
}
## extract the zip file
if (file.exists("UCI HAR Dataset")){
    warning("folder alreday exists.")
} else {
    unzip("UCI HAR Dataset.zip",files = NULL,list = FALSE,overwrite = TRUE,exdir = ".",setTimes = FALSE)
}
##unzip("UCI HAR Dataset.zip",files = NULL,list = FALSE,overwrite = TRUE,exdir = ".",setTimes = FALSE)

# Print file time
file.info(localfilepath)$ctime

# Loading the activity labels
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")[,2]


# Loading the data column names
features <- read.table("UCI HAR Dataset/features.txt")[,2]


# Extract measurements on the mean and standard deviation for each variable.
extract_features <- grepl("mean|std", features)


# Loading and processssing X_test & y_test data.
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# names of the X_test
names(X_test) = features


# Extract measurements on the mean and standard deviation for each variable.
X_test = X_test[,extract_features]


# Loading activity labels
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"


# Binding data
test_data <- cbind(as.data.table(subject_test), y_test, X_test)


# Loading and process X_train & y_train data.
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")


subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")


names(X_train) = features

# Extract measurements on the mean and standard deviation for each variable.
X_train = X_train[,extract_features]


# Loading activity data
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"


# Binding data
train_data <- cbind(as.data.table(subject_train), y_train, X_train)


# Mergeing test and train data
data = rbind(test_data, train_data)


id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)

# Create codebook (commented out because only used in prep work)
write.table(colnames(tidy_data), file = "./codebook.txt")

# Applying mean function to dataset using dcast function
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)


write.table(tidy_data, file = "./tidy_data.txt")
