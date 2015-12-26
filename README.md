# Getting & Cleaning Data Course Project

This guide explains how the R script of the project was implemented and the steps that were performed to get the final result. It is divided as follows:

* Downloading and extracting data files (additional)
* Created the R Script run_analisys for the project:
  * Step 1 - Merging the training and the test sets to create one data set
  * Step 2 - Extracting only the measurements on the mean and standard deviation for each measurement
  * Step 3 - Using descriptive activity names to name the activities in the data set
  * Step 4 - Appropriately labels the data set with descriptive variable names
  * Step 5 - Creating a independent tidy data set with the average of each variable for each activity and each subject
  
## Downloading and extracting data files (additional)
This block is included for easy downloading and extracting the data files.
First the data file was downloaded from the website indicated on the course page (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) and saved in a directory called "data" with the name "getdata-PROJECTFiles UCI-HAR Dataset.zip ". Then it was used to unzip () function to extract the data files. The directories were structured as follows:

    ./data

     |
 
     |+ UCI HAR Dataset
 
        |
        
        |+ test
        
    	   |
	   
    	   |+ Inertial Signals
	   
    	|
	
    	|+ train
	
    	   |
	   
    	   |+ Inertial Signals
	   

## Creating the R run_analysis script for the project
This section describes the steps used to implement the script run_analisys.R. For the implementation of the project, it was used as reference the instructions of the site THOUGHTFULBLOKE AKA DAVID HOOD, this link: https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/.

Before you begin, they have been declared all variables with the ways of the data files used in the analysis. The files used in the analysis were:
X_train.txt (Training Set)
y_train.txt (Training labels)
subject_train.txt (subject who performed the activity)
X_test.txt (Test Set)
y_test.txt (Test labels)
subject_test.txt (subject who performed the activity)
features.txt (List of all features) - use in step two
activity_labels.txt (Links the class labels with their activity name)

It was also used to analyze the packets "dplyr" and "reshape2".

The following 5 steps performed to construct the script analysis.

### Step 1 - Merging the training and the test sets to create one data set
First, date frames were created using the read.table function and saving on specific variables. Looking at Their dimensions with a command like dim (). To merge the data, the functions were used "cbind ()" and "rbind ()".

To merge the data, we joined three files to train and test. To train joined files "X_train.txt", "y_train.txt" and "subject_train.txt". To test joined files "X_test.txt", "y_test.txt" and "subject_test.txt". This merges have been saved in two new variables "traindf" and "testdf".

To facilitate the next steps, columns named "V1" and "V2" in the archives "y" and "subject" have been renamed to "V562" and "V563", respectively. This was necessary, because the "X" files 561 have variable.

After the bind columns, was held bind the lines using the "rbind ()" to unite the data frames "traindf" and "testdf" and save to a new variable called "trainxtestdf".

### Step 2 - Extracting only the measurements on the mean and standard deviation for each measurement
First it created a data frame with the file data "features.txt" and saved in the variable "featuresdf".

To extract only the columns with mean and standard deviation, the grep () function was used to get the occurrences "mean ()" and "std ()" at the end of the name of each variable. For this it used the regular expression "mean \\ (\\) $ | std \\ (\\) $" and saved in the variable "colmeasurements". There are no specific marking criteria on the number of columns. 18 columns were returned (V201 "" V202 "" V214 "" V215 "" V227 "" V228 "" V240 "" V241 "" V253 "" V254 "" V503 "" V504 "" V516 "" V517 "" V529 "" V530 "" V542 "" V543 ').

To assemble the data frame "measurementsdf" was done used the "select ()" the data frame "trainxtestdf" by selecting the column vector "colmeasurements" more columns "V562" and "V563". Looking at Their dimensions with a command like dim (), the dimension is 10299 observations and 20 variables.

### Step 3 - Using descriptive activity names to name the activities in the data set
First, it created a data frame "activity df" with file data "activity_labels.txt". Following the "gsub ()" function is used to rename the labels with "_" with "".

Original:
1 WALKING
2 WALKING_UPSTAIRS
3 WALKING_DOWNSTAIRS
4 SITTING
5 STANDING
6 LAYING

Result:
1 WALKING
2 WALKING UPSTAIRS
3 WALKING DOWNSTAIRS
4 SITTING
5 STANDING
6 LAYING

Then, using the function "merge ()" was made the ratio between the activities of columns "V562" of the data frame "measurementsdf" and column "V1" of the data frame "activitydf".

Finally, it replaced the "V562" column by "V2" and excluded the original column of activities. Again, looking at Their dimensions with a command like dim (), the dimension is 10299 observations and 20 variables.

### Step 4 - Appropriately labels the data set with descriptive variable names
First the data frame has been ordered, the columns 1 and 20 were placed at the beginning of the data frame. Finally, they renamed the 20 columns with the following names:

 [1] "Activity"                                        "Subject"                                        
 [3] "Mean Time Body Acc Mag"                          "Standard Deviation Time Body Acc Mag"           
 [5] "Mean Time Gravity Acc Mag"                       "Standard Deviation Time Gravity Acc Mag"        
 [7] "Mean Time Body Acc Jerk Mag"                     "Standard Deviation Time Body Acc Jerk Mag"      
 [9] "Mean Time Body Gyro Mag"                         "Standard Deviation Time Body Gyro Mag"          
[11] "Mean Time Body Gyro Jerk Mag"                    "Standard Deviation Time Body Gyro Jerk Mag"     
[13] "Mean Freq Body Acc Mag"                          "Standard Deviation Freq Body Acc Mag"           
[15] "Mean Freq Body Body Acc Jerk Mag"                "Standard Deviation Freq Body Body Acc Jerk Mag" 
[17] "Mean Freq Body Body Gyro Mag"                    "Standard Deviation Freq Body Body Gyro Mag"     
[19] "Mean Freq Body Body Gyro Jerk Mag"               "Standard Deviation Freq Body Body Gyro Jerk Mag"

Details of variables in CodeBook.md

### Step 5 - Creating a independent tidy data set with the average of each variable for each activity and each subject
To create the tidy we used the tool "dcast ()" where we analyzed the average magnitude of the accelerometer with respect to the body between the activity and the subject who carried out the experiment.

Finally, write.table () function is used to create the arranged data file. write.table (tidydf, "./data/UCI HAR Dataset / tidydf_projectcourse.txt" row.names = FALSE)

To read the tidy, use: read.table ("./ date / UCI HAR Dataset / tidydf_projectcourse.txt", header = TRUE)
