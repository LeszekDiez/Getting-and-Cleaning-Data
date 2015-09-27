#GETTING AND CLEANING DATA COURSE PROJECT


#Setting the working directory
setwd("~/Cursos/Data Science/Getting and Cleaning Data/Project")

library(reshape2)

#Reading all DataSets for the ETL Process

      #x_train.txt are the Traning Sets and x_test are the Test Sets
      trainingSet <- read.table("./data/train/X_train.txt")
      testSet <- read.table("./data/test/X_test.txt")
      
      #y_train.txt are the training labels and y_train are the Test Labels
      trainingLabels <- read.table("./data/train/y_train.txt")
      testLabels <- read.table("./data/test/y_test.txt") 
      
      #This are the data set for the subjects who performed the activities
      trainingSubject <- read.table("./data/train/subject_train.txt")
      testSubject <- read.table("./data/test/subject_test.txt")
      
      ## Read the dataframe's column names
      features <- read.table("./data/features.txt")

      ## Read the activity labels
      activityLabels <- read.table("./data/activity_labels.txt", col.names=c("activity_id","activity"))

# Step1. Merges the training and the test sets to create one data set.

      joinSet <- rbind(trainingSet, testSet)
      joinLabels <- rbind(trainingLabels, testLabels)
      joinSubject <- rbind(trainingSubject, testSubject)
          
# Step2. Extracts only the measurements on the mean and standard deviation for each measurement. 
      mean_std_idx <- grep("mean\\(\\)|std\\(\\)", features[, 2])
      joinSet_Mean_Std <- joinSet[, mean_std_idx]
      names(joinSet_Mean_Std) <- features[mean_std_idx, 2]
     
# Step3. Uses descriptive activity names to name the activities in the data set
      joinLabels[, 1] <- activityLabels[joinLabels[, 1], 2]
      
      
# Step4. Appropriately labels the data set with descriptive activity names. 
      names(joinLabels) <- "activity"
      names(joinSubject) <- "subject"
      allData <- cbind(joinSubject, joinLabels, joinSet_Mean_Std)
      
      
# Step5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
      valueCols <- allData[, 3:dim(allData)[2]]
      tidy_dataset <- aggregate(valueCols, list(allData$subject, allData$activity), mean)
      
      write.csv(tidy_dataset, "./data/tidy_dataset.csv")
      