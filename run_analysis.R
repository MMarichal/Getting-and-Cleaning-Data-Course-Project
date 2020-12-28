########## PEER - GETTING AND CLEANING DATA COURSE PROJECT ##########


##### Carga de paquetes #####

library(plyr)
library(dplyr)


##### Directorio de trabajo #####

setwd("C:/Users/mmarichal/Desktop/Coursera/3 - Getting and cleaning data/Peer")


##### Bases #####

filename <- "Coursera_DS3_Final.zip"

#Generación de DFs en RAM
ft <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
act <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = ft$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = ft$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")


##### Parte 1: Merges the training and the test sets to create one data set #####

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
df1 <- cbind(subject, Y, X)


##### Parte 2: Extracts only the measurements on the mean and standard deviation for each measurement #####

df2 <- df1 %>% select(subject, code, contains("mean"), contains("std"))


##### Parte 3: Uses descriptive activity names to name the activities in the data set #####

df2$code <- act[df2$code, 2]


##### Parte 4: Appropriately labels the data set with descriptive variable names #####

names(df2)[2] = "activity"
names(df2)<-gsub("Acc", "Accelerometer", names(df2))
names(df2)<-gsub("Gyro", "Gyroscope", names(df2))
names(df2)<-gsub("BodyBody", "Body", names(df2))
names(df2)<-gsub("Mag", "Magnitude", names(df2))
names(df2)<-gsub("^t", "Time", names(df2))
names(df2)<-gsub("^f", "Frequency", names(df2))
names(df2)<-gsub("tBody", "TimeBody", names(df2))
names(df2)<-gsub("-mean()", "Mean", names(df2), ignore.case = TRUE)
names(df2)<-gsub("-std()", "STD", names(df2), ignore.case = TRUE)
names(df2)<-gsub("-freq()", "Frequency", names(df2), ignore.case = TRUE)
names(df2)<-gsub("angle", "Angle", names(df2))
names(df2)<-gsub("gravity", "Gravity", names(df2))


##### Parte 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject #####

df3 <- df2 %>%
   group_by(subject, activity) %>%
   summarise_all(funs(mean))
write.table(df3, "Final_Data.txt", row.name=FALSE)

#Chequeo
str(df3)


########## FIN DE LA SINTAXIS ##########