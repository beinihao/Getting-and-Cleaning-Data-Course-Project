library(reshape2)

filename <- "getdata_dataset.zip"
 
# Downloading the data, Human Activity Recognition Using Smartphones Data Set, which was provided to us 
if (!file.exists(filename)){ 
   fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip " 
   download.file(fileURL, filename, method="curl") 
 }   
if (!file.exists("UCI HAR Dataset")) {  
   unzip(filename)  
 } 

train <- read.table("UCI HAR Dataset/train/X_train.txt")
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt") 
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt") 
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt") 
test <- cbind(testSubjects, testActivities, test) 

# Obtaining the Mean and Standard Deviation
columns123 <- grep("subject|activity|mean|std", colnames(humanActivity)) 
humanActivity <- humanActivity[, columns123] 

# Rename the columns
columns123 <- gsub ("BodyBody", "Body",columns123, fixed=TRUE)
columns123 <- gsub("^f", "FreqDomain", columns123)
columns123 <- gsub("^t", "TimeDomain", columns123)
columns123 <- gsub("mean[(][)]", "Mean", columns123)
columns123 <- gsub("std[(][)]", "StdDev", columns123)
columns123 <- gsub("Acc", "Acceleration", columns123, fixed = TRUE)
columns123 <- gsub("Gyro", "Gyroscope",columns123, fixed = TRUE)
columns123 <- gsub("Mag", "Magnitude", columns123, fixed = TRUE)
columns123 <- gsub("-", ".", columns123)

# Merging Training and Test data together and creating tidy dataset
TogetherData <- rbind(train, test)
colnames(TogetherData) <- c("subject", "activity")
TogetherData$activity <- factor(TogetherData$activity, levels = activityLabels[,1], labels = activityLabels[,2]) 
TogetherData$subject <- as.factor(TogetherData$subject) 
TogetherData.melted <- melt(TogetherData, id = c("subject", "activity")) 
TogetherData.mean <- dcast(TogetherData.melted, subject + activity ~ variable, mean) 
write.table(TogetherData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)

