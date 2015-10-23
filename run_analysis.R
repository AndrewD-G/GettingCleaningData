## if(!file.exists("./data"))      {dir.create("./data")}

# fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# download.file(fileUrl, "./data/Dataset.zip")
# unzip("./data/Dataset.zip",exdir = "./data/working")

## load the packages to use
require(dplyr)

setwd("C:/R/UCI_HAR_Dataset")

df_test <- read.table("./test/X_test.txt",header = F) ## read in the test data


df_train <- read.table("./train/X_train.txt",header = F) ## read in the train data

## check names of the dataframes are the same
identical(names(df_test), names(df_train))

## merge the test and train data frames
df_new <-merge(df_test, df_train, by = intersect(names(df_test), names(df_train)), all = T)

## read the names to apply to the data frame
df_X_nms <- read.table("./features.txt", header =  F )  
df_X_nms <- df_X_nms[,2]  ## subset to remove the integer and return only the row names
nms <- as.vector(as.matrix(df_X_nms))  ## convert data frame to vector to assist in updating the names

## rename dataframe to the names from the features table
names(df_new) <- nms

## remove dup named columns
df_new <- df_new[,!duplicated(colnames(df_new))]


## subset based on columns containing string std OR mean
df_new <- df_new[,grep("ean|std",colnames(df_new))]

## add the subject id and activities
df_test_sj_id <- read.table("./test/subject_test.txt",header = F) 

## add index for later joins
df_new <- data.frame(id = (1:nrow(df_new)), df_new)

## read in the test data
df_test_act_id <- read.table("./test/y_test.txt",header = F, row.names = NULL) 
names(df_test_act_id) <- c("Act_ID")
df_test_sj_id <- read.table("./test/subject_test.txt",header = F, row.names = NULL) 
names(df_test_sj_id) <- c("Subject_ID")
df_test_2 <- cbind.data.frame(df_test_act_id, df_test_sj_id )



df_train_sj_id <- read.table("./train/subject_train.txt",header = F) 
names(df_train_sj_id) <- c("Subject_ID")

df_train_act_id <- read.table("./train/y_train.txt",header = F) 
names(df_train_act_id) <- c("Act_ID")

df_train_2 <- cbind.data.frame(df_train_act_id, df_train_sj_id )


## merge the test and train data frames
df_new_2 <-merge(df_test_2, df_train_2,  all = T)
## add index for joining
df_new_2 <- data.frame(id = (1:nrow(df_new_2)), df_new_2)

## Join the two data frames on id
df_3 <- left_join(df_new, df_new_2 )

## Uses descriptive activity names to name the activities in the data set
act_lab <- read.table("activity_labels.txt")
df_3$Act_ID <- act_lab$V2[df_3$Act_ID]


## Appropriately labels the data set with descriptive variable names. 
names(df_3) <- gsub("tBody", "time_",names(df_3))
names(df_3) <- gsub("fBody", "Frequency_", names(df_3))
names(df_3) <- gsub("angle.", "", names(df_3))

# Candidate activity mean columns 2 thru 87
df_4 <- data.frame(Subject_Id = df_3$Subject_ID, Act_Id = df_3$Act_ID, Mean = rowMeans(df_3[,2:87]))
df5 <- group_by(df_4,Subject_Id, Act_Id) 
df5 <- summarise(df5, fnl_Mean = mean(Mean))

write.table(df5, file = "GetCleanData.txt", row.names = F, col.names = T)
