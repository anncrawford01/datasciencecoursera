# Cleaning data coursera run_analysis.R
# Ann Crawford
# Date 2/7/2017

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
## data that is in both test and train
features   = read.table("./data/UCI HAR Dataset/features.txt")
activities = read.table("./data/UCI HAR Dataset/activity_labels.txt")


## Test data 30% of observations 2947 rows
subjecttest = read.table("./data/UCI HAR Dataset/test/subject_test.txt")
activitytest  = read.table("./data/UCI HAR Dataset/test/y_test.txt")
datatest    = read.table("./data/UCI HAR Dataset/test/x_test.txt", col.names = features$V2)

##  train data 70% of the observations 7352 rows
subjecttrain = read.table("./data/UCI HAR Dataset/train/subject_train.txt" )
activitytrain  = read.table("./data/UCI HAR Dataset/train/y_train.txt")
datatrain    = read.table("./data/UCI HAR Dataset/train/x_train.txt", col.names = features$V2)

# replace activities numbers with Names
activitytest$V2 <- activities[match(activitytest$V1, activities$V1), 2]
activitytrain$V2 <- activities[match(activitytrain$V1, activities$V1), 2]


###  Step 2. subset the data   
### 10299 rows:  all observarions 7352 + 2947 
### 68 columns: 66 measures for mean() and std() + subject + activity

## get the columns of interest to the assignment
meanstdtrain <- datatrain[, grepl("(mean\\(\\))|(std\\(\\))" ,features$V2) ]
meanstdtest <- datatest[, grepl("(mean\\(\\))|(std\\(\\))" ,features$V2) ]


fulltest  <- cbind(subjecttest$V1, activitytest$V2,meanstdtest)
fulltrain <- cbind(subjecttrain$V1,activitytrain$V2,meanstdtrain)

names(fulltest)[1] <- "subject"
names(fulltest)[2] <-"activity" 
names(fulltrain)[1] <- "subject"
names(fulltrain)[2] <-"activity" 

###fixActivities <- function(x) { sub("_"," ",tolower(x)  ) }

fulldf <- rbind(fulltrain, fulltest)


### Step 3. Create the average over each variable for activity and subject.

### use plyr
library(plyr)
library(reshape2)
 melted <- melt(fulldf, id.vars = c("subject" , "activity"))

### final shape is
 ## 11880 rows : 6 activities x 30 subject x 66 measurements
 ## 4     columns: the subject, activity, measurement, mean
finaldf <-ddply(melted, c("subject", "activity", "variable"), summarise,  mean= mean(value) ) 

