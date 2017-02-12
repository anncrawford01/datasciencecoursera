# Cleaning data coursera run_analysis.R 
# Week 4 Assignment
# Ann Crawford
# Date 2/7/2017

## required packages

##install.packages('plyr')
##library(plyr)

##install.packages('reshape2')
##library(reshape2)
#############################################################################
# This script downloads, several files, reads the files and produces a single
# tidy data set that summarizes a subset of the varaibles.
# Code book:
# Read me:

# Assignment Text:
#   You should create one R script called run_analysis.R that does the following.
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement.
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names.
#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
##############################################################################

### tidy data set
# Each variable forms a column
# Echar observation forms a row
# Each table sores data about one kind of observation

##########
# get zipfile from the web put it in data folder
#############
zipurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if(!file.exists("./data")) {dir.create("./data")}
  zipfile <- "./data/uciSmartPhoneActivity.zip"
  download.file(zipurl,destfile=zipfile,mode = "wb")

## read zipped file 
unzip(zipfile, exdir = "./data")

#### Get the data #####
## data that is in both test and train - Add the feature names when reading the data 
features   = read.table("./data/UCI HAR Dataset/features.txt",colClasses = c("integer", "character"))
activities = read.table("./data/UCI HAR Dataset/activity_labels.txt",colClasses = c("integer", "character"))

## Test data 30% of observations 2947 rows
subjecttest   = read.table("./data/UCI HAR Dataset/test/subject_test.txt")
activitytest  = read.table("./data/UCI HAR Dataset/test/y_test.txt")
datatest      = read.table("./data/UCI HAR Dataset/test/x_test.txt")

##  train data 70% of the observations 7352 rows
subjecttrain   = read.table("./data/UCI HAR Dataset/train/subject_train.txt" )
activitytrain  = read.table("./data/UCI HAR Dataset/train/y_train.txt")
datatrain      = read.table("./data/UCI HAR Dataset/train/x_train.txt")

#3. Uses descriptive activity names to name the activities in the data set
#     simplify the Activity names
         
#     replace activities numbers with Names
activitytest$V2  <- activities[match(activitytest$V1, activities$V1), 2]
activitytrain$V2 <- activities[match(activitytrain$V1, activities$V1), 2]

# replace the column names with the feature names
colnames(datatrain) = features$V2
colnames(datatest) = features$V2

### subset the data   
### 10299 rows:  all observarions 7352 + 2947 
### there are 33 measurements: 8 with xyz values = 24 + 9 magnitude measures for a total of 33 measuremnts
### 68 columns: 66 measures for mean() and std() + subject + activity

#2. Extracts only the measurements on the mean and standard deviation for each measurement.
meanstdtrain <- datatrain[, grepl("(mean\\(\\))|(std\\(\\))" ,features$V2) ]
meanstdtest <-  datatest[, grepl("(mean\\(\\))|(std\\(\\))" ,features$V2) ]

activities[1,2] <- "Walk"
activities[2,2] <- "Walk Up"
activities[3,2] <- "Walk Down"
activities[4,2] <- "Sit"
activities[5,2] <- "Stand"
activities[6,2] <- "Lay"

# replace activities numbers with Names
activitytest$V2  <- activities[match(activitytest$V1, activities$V1), 2]
activitytrain$V2 <- activities[match(activitytrain$V1, activities$V1), 2]

fulltest  <- cbind(subjecttest$V1, activitytest$V2,meanstdtest)
fulltrain <- cbind(subjecttrain$V1,activitytrain$V2,meanstdtrain)

#4. Appropriately labels the data set with descriptive variable names.
names(fulltest)[1]  <- "subject"
names(fulltest)[2]  <- "activity" 
names(fulltrain)[1] <- "subject"
names(fulltrain)[2] <- "activity"



#1. Merges the training and the test sets to create one data set.
fulldf <- rbind(fulltrain, fulltest)

### Step 3. Create the average over each variable for activity and subject.


melted <- melt(fulldf, id.vars = c("subject" , "activity"))

### final shape is
 ## 11880      rows   : (6 activities x 30 subject x 66 measurements)
 ##     4      columns: ( subject, activity, measurement, mean)
finaldf <-ddply(melted, c("subject", "activity", "variable"), summarise,  mean= mean(value) ) 

write.table(finaldf, file = "assignment4.txt")
