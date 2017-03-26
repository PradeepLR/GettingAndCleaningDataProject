#load libraries necessary for running script.
library(reshape2)
library(plyr)
library(dplyr)

#This block sets Parent Path, sub directory, fileurl for download, and filename.
ParentPath <- "/Users/Pradeep/R projects/Getting_and_Cleaning_Data/Week_4/CourseProject/"
subDir ="UCI HAR Dataset"
DataFileURL <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filename <- "UCI_HAR_Dataset.zip"

#This block checks if file has been previously downloaded, if not, downloads the file and unzips it.
ifelse(!dir.exists(file.path(ParentPath, subDir)), download.file(DataFileURL, paste(ParentPath, filename, sep="")), NA)
unzip(filename)

#This block reads necessary files in to appropriately labelled objects.
subject_test <- read.table(paste(ParentPath, subDir, "/test/subject_test.txt", sep=""), header=FALSE)
X_test <- read.table(paste(ParentPath, subDir, "/test/X_test.txt", sep=""), header=FALSE)
Y_test <- read.table(paste(ParentPath, subDir, "/test/y_test.txt", sep=""), header=FALSE)

subject_train <- read.table(paste(ParentPath, subDir, "/train/subject_train.txt", sep=""), header=FALSE)
X_train <- read.table(paste(ParentPath, subDir, "/train/X_train.txt", sep=""), header=FALSE)
Y_train <- read.table(paste(ParentPath, subDir, "/train/y_train.txt", sep=""), header=FALSE)

activity_labels <- read.table(paste(ParentPath, subDir, "/activity_labels.txt", sep=""), header=FALSE)
Features <- read.table(paste(ParentPath, subDir, "/features.txt", sep=""), header=FALSE, as.is = TRUE)

#This block merges all objects in to one data frame called All_Data.
All_test <- cbind(subject_test, Y_test, X_test)
All_train <- cbind(subject_train, Y_train, X_train)
All_Data <- rbind(All_test, All_train)

#This block converts columns 1 and 2 to factors.
All_Data[[1]] <- factor(All_Data[[1]])
All_Data[[2]] <- factor(All_Data[[2]])

#Orders Data based on column 1 (subject number).
OrderedAll_Data <- All_Data[order(All_Data[,1]), ]

#Creates appropriate labels for columns and categorical names for column 1 and 2.
subject_list <- as.character(levels(All_Data[,1]))
activity_labels <- activity_labels$V2
levels(OrderedAll_Data[[2]]) <- activity_labels
levels(OrderedAll_Data[[1]]) <- subject_list
Features <- c("Subject", "Activity", Features[[2]])
colnames(OrderedAll_Data) <- Features

#This block reformats the data and takes the mean of similar categories of column 2, and recasts the data in to a data frame.
MeltedData <- melt(OrderedAll_Data, id.vars= c("Subject", "Activity"))
MeltedMeanData <- ddply(MeltedData, c("Subject", "Activity", "variable"), mean=mean(value))
FinalDataFrame <- dcast(MeltedMeanData, Subject + Activity ~ variable)
#Writes File to Parent Path.
write.csv(All_test4, paste(ParentPath,"TidyData.csv", sep=""), quote=TRUE)
