####
# Training Data

x_train=read.table("/Users/anirudhgambhir/Documents/COLLEGE/SEM5/R Prog./Datasets/Coursera Datasets/UCI HAR Dataset/train/X_train.txt")
y_train=read.table("/Users/anirudhgambhir/Documents/COLLEGE/SEM5/R Prog./Datasets/Coursera Datasets/UCI HAR Dataset/train/y_train.txt")
subject_train=read.table("/Users/anirudhgambhir/Documents/COLLEGE/SEM5/R Prog./Datasets/Coursera Datasets/UCI HAR Dataset/train/subject_train.txt")

####
# Testing Data

x_test=read.table("/Users/anirudhgambhir/Documents/COLLEGE/SEM5/R Prog./Datasets/Coursera Datasets/UCI HAR Dataset/test/X_test.txt")
y_test=read.table("/Users/anirudhgambhir/Documents/COLLEGE/SEM5/R Prog./Datasets/Coursera Datasets/UCI HAR Dataset/test/y_test.txt")
subject_test=read.table("/Users/anirudhgambhir/Documents/COLLEGE/SEM5/R Prog./Datasets/Coursera Datasets/UCI HAR Dataset/test/subject_test.txt")

####
# Additional Files

features=read.table("/Users/anirudhgambhir/Documents/COLLEGE/SEM5/R Prog./Datasets/Coursera Datasets/UCI HAR Dataset/features.txt")
activity=read.table("/Users/anirudhgambhir/Documents/COLLEGE/SEM5/R Prog./Datasets/Coursera Datasets/UCI HAR Dataset/activity_labels.txt")

####
# Giving Useful Names

colnames(x_train)=features[,2]
colnames(x_test)=features[,2]
colnames(y_train)="activityCode"
colnames(y_test)="activityCode"
colnames(subject_train)="volunteerCode"
colnames(subject_test)="volunteerCode"

####
# Merging of Datasets

train_Data=cbind(y_train,subject_train,x_train)
test_Data=cbind(y_test,subject_test,x_test)
complete_dataset=rbind(train_Data,test_Data)

####
# Extracting Useful Rows

extracted_Indices = (grepl("activityCode" , colnames(complete_dataset)) | 
                       grepl("volunteerCode" , colnames(complete_dataset)) | 
                       grepl("mean.." , colnames(complete_dataset)) |
                       grepl("std.." , colnames(complete_dataset)))
extracted_Dataset=complete_dataset[,extracted_Indices==T]

updated_Dataset = merge(activity,extracted_Dataset, by.y='activityCode',by.x = 'V1', all.x=TRUE)
colnames(updated_Dataset)[1:2]=c("activityCode","activityName")

####
# Descriptive Names

names(updated_Dataset)=gsub("^t", "time", names(updated_Dataset))
names(updated_Dataset)=gsub("^f", "frequency", names(updated_Dataset))
names(updated_Dataset)=gsub("Acc", "Accelerometer", names(updated_Dataset))
names(updated_Dataset)=gsub("Gyro", "Gyroscope", names(updated_Dataset))
names(updated_Dataset)=gsub("Mag", "Magnitude", names(updated_Dataset))
names(updated_Dataset)=gsub("BodyBody", "Body", names(updated_Dataset))

####
# Tidy set and samving file

grouped_dataset=group_by(updated_Dataset,activityCode,volunteerCode)
grouped_dataset=grouped_dataset %>% summarise_each(funs(mean))

write.table(grouped_dataset, "tidy_Dataset.txt", row.names = FALSE, quote = FALSE)



