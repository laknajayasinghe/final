download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
              "finalData.zip", method = "curl")
unzip("finalData.zip")
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
## Merging the files
x_merged <- rbind(x_train, x_test)
y_merged <- rbind(y_train, y_test)
subject_merged <- rbind(subject_train, subject_test)
merged_data <- cbind(subject_merged, y_merged, x_merged)
library(dplyr)
## Extracting mean and standard deviation
data <- select(merged_data, subject, code, contains("mean"), contains("std"))
## Change to descriptive activity names 
data$code <- activity_labels[data$code, 2]
## Change to descriptive variable names 
names(data)[2] <- "activity"
names(data)<-gsub("^t", "time", names(data))
names(data)<-gsub("BodyBody", "body", names(data))
names(data)<-gsub("^f", "frequency", names(data))
names(data)<-gsub("Acc", "accelerometer", names(data))
names(data)<-gsub("Gyro", "gyroscope", names(data))
names(data)<-gsub("Mag", "magnitude", names(data))
##Create independent tidy data set
final <- group_by(data, subject, activity)
final <- summarize_all(final, funs(mean))
write.table(final, "final_data.txt", row.name=FALSE)
