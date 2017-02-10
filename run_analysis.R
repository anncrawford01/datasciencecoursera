# cleaning data coursera run_analysis.R
# Ann Crawford
#Date 2/7/2017

##http://vita.had.co.nz/papers/tidy-data.pdf

### tidy data set
# Each variable forms a column
# Echar observation forms a row
# Each table sores data about one kind of observation

# reading code book files
# https://www.r-bloggers.com/reading-codebook-files-in-r/
# http://www.medicine.mcgill.ca/epidemiology/joseph/pbelisle/CodebookCookbook.html
#######################
# there are 33 measurements: 8 with xyz values = 24 + 9 magnitude measures for a total of 33 measuremnts
#
#


# get zipfile from the web put it in data folder

#zipurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#if(!file.exists("./data")) {dir.create("./data")}
###zipfile <- "./data/uciSmartPhoneActivity.zip"

#download.file(zipurl,destfile=zipfile,mode = "wb")

#  - This tells me  that there are 32 files.
##filelist <-unzip(zipfile,list=TRUE)
##dim(filelist)

## read zipped file -
#unzip(zipfile, exdir = "./data")

#### Step 1 get the data #####


## 1a data that is in both test and train
features   = read.table("./data/UCI HAR Dataset/features.txt")
activities = read.table("./data/UCI HAR Dataset/activity_labels.txt")

fixActivities <- function(x) { sub("_"," ",tolower(x)  ) }



### http://stackoverflow.com/questions/21712384/updating-column-in-one-dataframe-with-value-from-another-dataframe-based-on-matc

activitytest$V2 <- activities[match(activitytest$V1, activities$V1), 2]


## 1b. Get the test data 30% of the observations
subjecttest = read.table("./data/UCI HAR Dataset/test/subject_test.txt")
activitytest  = read.table("./data/UCI HAR Dataset/test/y_test.txt")

datatest    = read.table("./data/UCI HAR Dataset/test/x_test.txt", col.names = features$V2)

## 1c. Get the train data 70% of the observations
subjecttrain = read.table("./data/UCI HAR Dataset/train/subject_train.txt" )
activitytrain  = read.table("./data/UCI HAR Dataset/train/y_train.txt")

datatrain    = read.table("./data/UCI HAR Dataset/train/x_train.txt", col.names = features$V2)



###  Step 2. Shape the data   
### 10299 rows:  all observarions 7352 + 2947 
### 68 columns: 66 measures for mean() and std() + subject + activity

##2.a get the columns of interest to the assignment
meanstdtrain <- datatrain[, grepl("(mean\\(\\))|(std\\(\\))" ,features$V2) ]
meanstdtest <- datatest[, grepl("(mean\\(\\))|(std\\(\\))" ,features$V2) ]


fulltest <- cbind(subjecttest$V1,labeltest$V1,meanstdtest)

fulltrain <- cbind(subjecttrain$V1,labeltrain$V1,meanstdtrain)


fulldf <- rbind(fulltrain, fulltest)







