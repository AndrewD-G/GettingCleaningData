# GettingCleaningData
How the code works

dplyr is loaded for later use.

The test and train data are read into R Studio then merged
The names are read in and converted to a vector for application to the merged data.

The duplicated columns are removed and then subsetted using grep to retain only means and std deviations.

The subject id and activities are loaded into the data and an index is applied to join the data together.

The data sets, activities and subject id are joined together based on the join index and the labels are altered to be more readable.

The activity data mean is assigned based on the available data using plyr functions, then the data is written to a text file using the write.table function.

