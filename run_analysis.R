library(data.table)
library(reshape2)

#Load the dimension´s labels
y_labels <- read.table("./UCI_HAR_Dataset/activity_labels.txt")
x_labels <- read.table("./UCI_HAR_Dataset/features.txt")

#Load the test measures data and keep just the required columns
x_test <- read.table("./UCI_HAR_Dataset/test/X_test.txt")
names(x_test) = x_labels[,2]
x_required <- grepl("mean|std", x_labels[,2])
x_test = x_test[,x_required]

#Load the test activity data and change the Activity ID by Activity name on the data table
y_test <- read.table("./UCI_HAR_Dataset/test/Y_test.txt")
y_test <- merge(y_test,y_labels,by.x = "V1",by.y = "V1",all = TRUE)
y_test <- as.data.table(y_test[,2])
names(y_test) = "Activity"

#Load the test subject data
s_test <- read.table("./UCI_HAR_Dataset/test/subject_test.txt", col.names = 'Subject')

#Append all the test data into one table
dt_test <- cbind(s_test, y_test, x_test)

#Repeat the same process above to the train data
x_train <- read.table("./UCI_HAR_Dataset/train/X_train.txt")
names(x_train) = x_labels[,2]
x_train = x_train[,x_required]

y_train <- read.table("./UCI_HAR_Dataset/train/Y_train.txt")
y_train <- merge(y_train,y_labels,by.x = "V1",by.y = "V1",all = TRUE)
y_train <- as.data.table(y_train[,2])
names(y_train) = "Activity"

s_train <- read.table("./UCI_HAR_Dataset/train/subject_train.txt", col.names = 'Subject')

dt_train <- cbind(s_train, y_train, x_train)

#Merge the test and train data into one final data set
dt_final <- rbind(dt_test, dt_train)

#Create another data set with a tidy data and the average of each measure
col_labels <- c("Subject","Activity")
measures <- setdiff(colnames(dt_final),col_labels)
tidy_data <- melt(dt_final, id = col_labels, measure.vars = measures)
tidy_data <- dcast(melt_data, Subject + Activity ~ variable, mean)
write.table(tidy_data, file = "./tidy_data.txt", row.name=FALSE)
