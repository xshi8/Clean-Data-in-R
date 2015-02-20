## download data sets
if (!file.exists('./data')){dir.create('./data')}
fileUrl <-'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(fileUrl, destfile='./data/getdata-projectfiles-UCI HAR dataset.zip')
unzip('./data/getdata-projectfiles-UCI HAR dataset.zip',exdir='./data')

## subject_train has 7352 rows and subject_test has 2947 rows and 
## Both data sets have one column with values of subject ID
subject_train <- read.table('./data/UCI HAR dataset/train/subject_train.txt',header=F,
                            col.names='Subject.ID', colClasses='numeric')
subject_test <- read.table('./data/UCI HAR dataset/test/subject_test.txt',header=F,
                           col.names='Subject.ID', colClasses='numeric')

## y_train conains 7352 rows and y-test contains 2947 rows, 
## Both data sets have one column with values of activity ID
y_train <- read.table('./data/UCI HAR dataset/train/y_train.txt',header=F,
                      col.names='Activity.ID', colClasses='numeric')
y_test <- read.table('./data/UCI HAR dataset/test/y_test.txt',header=F,
                      col.names='Activity.ID', colClasses='numeric')

## x_train has 7352 rows and x_test has 2947 rows;
## The row number in the features table correponds to the column number in x_train (or x_test),
## so x_train (or x_test) columns are named by feature names;
## select only columns with std() or mean() in their feature names 
features <- read.table('./data/UCI HAR dataset/features.txt',header=F,
                       col.names=c('Feature.ID','Feature.Name'),
                       colClasses=c('numeric','character'))
x_train <- read.table('./data/UCI HAR dataset/train/X_train.txt',header=F,
                      col.names=features$Feature.Name) 
x_test  <- read.table('./data/UCI HAR dataset/test/X_test.txt',header=F,
                      col.names=features$Feature.Name)

select.features <- features[regexpr('mean()',features$Feature.Name,fixed=T)>1|
                            regexpr('std()',features$Feature.Name,fixed=T)>1,]
select.x_train <- x_train[,select.features[,1]] 
select.x_test  <- x_test[,select.features[,1]]

## combine subject,activity,features data sets by cbind()
combine_train <- cbind(subject_train,y_train,select.x_train)
combine_test <-  cbind(subject_test,y_test,select.x_test)

## combine train and test data sets by rbind()
full_dataset <- rbind(combine_train,combine_test)

## replace activity id with descriptive names from activity_labels
activity.labels <- read.table('./data/UCI HAR dataset/activity_labels.txt',header=F,
                              col.names=c('Activity.ID','Activity.Name'),
                              colClasses=c('numeric','character'))
full.dataset.merge <- merge(activity.labels,full_dataset,by='Activity.ID',all=F)

## drop Activity.ID column and sort data set by Subject.ID and activity.name
nvar <- ncol(full.dataset.merge)
final.full.dataset <- full.dataset.merge[order(full.dataset.merge$Subject.ID,full.dataset.merge$Activity.Name),
                                         c(3,2,4:nvar)]

## create additional data set with the average of each variable 
## for each activity and each subject
library(reshape2)
fNames <- names(final.full.dataset) #get column names
FullData.melt <- melt(final.full.dataset,id=1:2,measure.vars=fNames[-1:-2])
avg.measures <- dcast(FullData.melt,Subject.ID + Activity.Name ~ variable,mean)

##
write.table(avg.measures,'./data/avg-measures-per-subject-activity.txt',row.names=F)

 
