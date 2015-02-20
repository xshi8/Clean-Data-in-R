
### Downolad files into work directory
*  1. check whether 'data' folder exists in your work directory or not. If no, create the folder
*  2. downolad files to the folder 'data' 
*  3. unzip files in the folder 'data'

### Relationship among raw data sets
*  five data sets are required to re-construct tidy train data set:
*    subject_train: 7352 rows and 1 column, which stores subject id
*    y_train: 7352 rows and 1 column, which stores activity id
*    X-train: 7352 rows and 561 columns, which stores values of 561 measures(features), and one column for one measure
*    features: 561 rows and 2 columns, which stores feature id and feature (measure) names, each row in features corresponds to a column in X_train
*    activity_labels: 6 rows and 2 columns, which stores activity id and activity description 
*    similar to tidy test data set.

### Rebuild first tidy data set
*  1. read subject_train.txt and  name the column of resultant subject.train data set as 'Subject.ID'
*  2. read y_train.txt and name the column of resultant y_train data set as 'Activity.ID'
*  3. read features.txt and name columns of resultant features data set as 'Feature.ID' and 'Feature.Name', respectively
*  4. read X_train.txt(X_test.txt) and name columns of resultant x_train data set with features$Feature.Name, respectively. 
*     illegal characters such as '(',')',',' etc, are converted into '.' in X_train(X_test) column names
*  5. subset features data set with mean() or std() in their Feature.Name
*  6. subset x_train data set by selecting only columns corresponding to Feature.ID of selected features in feature data set
*  7. combine subject.train, y_train and x_train data frames by cbind() into combine_train;
*  8. similarly get combine_test data set
*  9. combine combine_train and combine_test into full data set by rbind()
*  10. replace Activity.ID with activity description from activity.labels by merge() 
*  11. drop Activity.ID column.

### Build second tidy data set 
*  1. load reshape2 package
*  2. reshape full data set into four columns: Subject.ID, Activity.Names,Variable, Value using melt()
*  3. get means of each measures(distinct values of variable) by dcast()