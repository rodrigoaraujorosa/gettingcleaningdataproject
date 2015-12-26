## Downloading and extracting data
if(!file.exists("./data")){dir.create("./data")} # verifiing file exists
fileUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" # url data set
fileZip = "./data/getdata-projectfiles-UCI HAR Dataset.zip" # destination file zip path
print("Downloading project files...")
download.file(fileUrl, destfile =  fileZip) # download file
print("Extracting project files... Waiting a few minutes.") 
unzip(fileZip, exdir = "./data") # extracting files
print("Extract is finish!")

## Follow the tips: https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/
## Read: README.md and CodeBook.md in the GitHub Repo

## Declaring variables
xtrainfile <- "./data/UCI HAR Dataset/train/X_train.txt" # file X_train.txt path (Training Set)
ytrainfile <- "./data/UCI HAR Dataset/train/y_train.txt" # file y_train.txt path (Training labels)
subjecttrainfile <- "./data/UCI HAR Dataset/train/subject_train.txt" # file subject_train.txt path (subject who performed the activity)
xtestfile <- "./data/UCI HAR Dataset/test/X_test.txt" # file X_test.txt path (Test Set)
ytestfile <- "./data/UCI HAR Dataset/test/y_test.txt" # file y_test.txt path (Test labels)
subjecttestfile <- "./data/UCI HAR Dataset/test/subject_test.txt" # file subject_test.txt path (subject who performed the activity)
featuresfile <- "./data/UCI HAR Dataset/features.txt" # file features.txt path (List of all features) - use in step two
activityfile <- "./data/UCI HAR Dataset/activity_labels.txt" # file activity_labels.txt path (Links the class labels with their activity name) - use in step three

## Loading necessary packages
library(dplyr)
library(reshape2)

### First step: Merges the training and the test sets to create one data set.

## Open data frames and save in variables (Tip: for testing the dimension use dim())
xtraindf <- read.table(xtrainfile) # read text file with read.table() and save in xtraindf variable (Dimension = 7352 Obs x 561 Var)
ytraindf <- read.table(ytrainfile) # read text file with read.table() and save in ytraindf variable (Dimension = 7352 Obs x 1 var)
names(ytraindf) <- "V562" # change de variable name for bind
subjecttraindf <- read.table(subjecttrainfile) # read text file with read.table() and save in subjecttraindf variable (Dimension = 7352 Obs x 1 Var)
names(subjecttraindf) <- "V563" # change de variable name for bind
xtestdf <- read.table(xtestfile) # read text file with read.table() and save in xtestdf variable (Dimension = 2947 Obs x 561 Var)
ytestdf <- read.table(ytestfile) # read text file with read.table() and save in ytestdf variable (Dimension = 2947 Obs x 1 var)
names(ytestdf) <- "V562" # change de variable name for bind
subjecttestdf <- read.table(subjecttestfile) # read text file with read.table() and save in subjecttestdf variable (Dimension = 2947 Obs x 1 Var)
names(subjecttestdf) <- "V563" # change de variable name for bind

## Bind column x, y and subject files
traindf <- cbind(xtraindf, ytraindf, subjecttraindf) # use cbind combines three data frames xtraindf, ytraindf and subjecttraindf and save in traindf variable (Dimension = 7352 Obs x 563 Var)
testdf <- cbind(xtestdf, ytestdf, subjecttestdf) # use cbind combines three data frames xtestdf, ytestdf and subjecttestdf and save in testdf variable (Dimension = 2947 Obs x 563 Var)

## Merging the training (traindf) and the test (testdf) sets to create one data set (traindf x testdf)
trainxtestdf <- rbind(traindf, testdf) # use rbind combines traindf and testdf data frames and save in trainxtestdf variable (10299 Obs x 563 Var)

### End First step

### Second step: Extract only the measurements on the mean and standard deviation for each measurement.

featuresdf <- read.table(featuresfile) # read text file with read.table() and save in featuresdf variable (Dimension = 561 Obs x 2 Var)
# There are no specific marking criteria on the number of columns
# Please read: What columns are measurements on the mean and standard deviation in https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/
# More details: README.md
colmeasurements <- grep("mean\\(\\)$|std\\(\\)$", featuresdf$V2) # get columns names in features is the entries then include mean() and std() at the end (18 variables)
# Using select from Dplyr package for extract columns measurements, column activity (562) and column subject (563)
# Use names(measurementsdf) to verify the names variables
# Result: [1] "V201" "V202" "V214" "V215" "V227" "V228" "V240" "V241" "V253" "V254" "V503" "V504" "V516" "V517" "V529" "V530" "V542" "V543" "V562" "V563"
measurementsdf <- select(trainxtestdf, colmeasurements, c(562,563)) # only the measurements on the mean (mean()) and standard deviation (std()) for each measurement and save in measurementsdf (Dimension = 10299 x 20)

### End Second step

### Third step: Uses descriptive activity names to name the activities in the data set

activitydf <- read.table(activityfile)  # read text file with read.table() and save in activitydf variable (Dimension = 6 Obs x 2 Var)
activitydf$V2 <- gsub("_"," ", activitydf$V2) # use gsub() substitute "_" for " " in the activity name (e.g WALKING_UPSTAIRS = WALKING UPSTAIRS)
measurementsdf <- merge(measurementsdf, activitydf, by.x = "V562", by.y = "V1", all = TRUE, sort = FALSE) # merge data set for descriptive activity names to name the activities in the data set
measurementsdf$V562 <- measurementsdf$V2 # subtitute activity code with activity name and set like first column in the data set
measurementsdf <- select(measurementsdf, -V2) # exclude original activity column and save work in measurementsdf variable (Dimension = 10299 x 20)

### End Third step

### Fourth step: Appropriately labels the data set with descriptive variable names

measurementsdf <- measurementsdf[c(1, 20, 2:19)] # reordering the columns in data frame (alocate activity and subject, first and second columns respectively)
# Set descriptive variable names.
# Description details: please read CodeBook.md
names(measurementsdf) <- c("Activity", "Subject", "Mean Time Body Acc Mag","Standard Deviation Time Body Acc Mag","Mean Time Gravity Acc Mag","Standard Deviation Time Gravity Acc Mag","Mean Time Body Acc Jerk Mag","Standard Deviation Time Body Acc Jerk Mag","Mean Time Body Gyro Mag","Standard Deviation Time Body Gyro Mag","Mean Time Body Gyro Jerk Mag","Standard Deviation Time Body Gyro Jerk Mag","Mean Freq Body Acc Mag",  "Standard Deviation Freq Body Acc Mag","Mean Freq Body Body Acc Jerk Mag","Standard Deviation Freq Body Body Acc Jerk Mag","Mean Freq Body Body Gyro Mag","Standard Deviation Freq Body Body Gyro Mag","Mean Freq Body Body Gyro Jerk Mag","Standard Deviation Freq Body Body Gyro Jerk Mag")

### End Fourth step

### Fifth step: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

# Calculate the average magnitude of the three-dimensional signals which were calculated by using the Euclidean norm subject and activity
tidydf <- dcast(measurementsdf, Subject ~ Activity, mean, value.var = "Mean Time Body Acc Mag")
write.table(tidydf, "./data/UCI HAR Dataset/tidydf_projectcourse.txt", row.names = FALSE) # created data set text file with write.table()

### End Fifth step