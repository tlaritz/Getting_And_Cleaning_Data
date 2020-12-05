## Performs analysis required by peer-reviewed assignment for the Coursera
## course "Getting and Cleaning Data."

## This script assumes the following file and directory structure:
##
## activity_labels.txt    contains row with activity index and activity label
## features.txt           contains 561 lines with the names of the varibles in X_*.txt
## test                   directory containing info for test data with 2947 measurements
## |-subject_test.txt     2947 x 1 vector of patient IDs (1 thru 30)
## |-X_test.txt           2947 x 561 vector of derived measurements (mean, std, others)
## |-y_test.txt           2947 x 1 a activity ID ( 1 thru 6)
## train                  directory containing info for training data with 7352 measurements
## |-subject_test.txt     7352 x 1 vector of patient IDs (1 thru 30)
## |-X_test.txt           7352 x 561 vector of derived measurements (mean, std, others)                           2947 x 1 vector of patient IDs (1 thru 30)
## |-y_test.txt           7352 x 1 a activity ID ( 1 thru 6)


## The code below performs the following actions outlined in the instructions
## for the peer-reviewed project:
##
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set 
##    with the average of each variable for each activity and each subject.
## 6. Writes the resulting tidy data set to a .txt file using write.table().


##
## The following "global" constants are used in multiple functions.
SUBJECT_LABEL = "subject"
ACTIVITY_LABEL = "activity"

run_analysis <- function()
{
  ##
  ## DESIRED_STATS contains the names of the desired
  ## mean and std statistics contained in the X_test.txt and X_train.txt files.
  ## The user need only add the name of the desired statistic,
  ## exactly as shown in the features.txt file, in DESIRED_STATS below.  
  ## Notes: 
  ## 1. The order of the statistics in the vector below must appear
  ##    in the same order as shown in features.txt.
  ##    Thus, "tBodyAcc-mean()-X" must appear before "tBodyAcc-mean()-Y"
  ##    in DESIRED_STATS because "tBodyAcc-mean()-X" is contained on
  ##    line 1 of features.txt and "tBodyAcc-mean()-Y" appears on line 2
  ##    of features.txt
  ## 2. The names in the vector below must exactly match
  ##    the name in the features.txt file.  Names are case sensitive.
  ##
  DESIRED_STATS = c("tBodyAcc-mean()-X",    "tBodyAcc-mean()-Y",    "tBodyAcc-mean()-Z",
                    "tBodyAcc-std()-X",     "tBodyAcc-std()-Y",     "tBodyAcc-std()-Z",
                    "tGravityAcc-mean()-X", "tGravityAcc-mean()-Y", "tGravityAcc-mean()-Z",                    
                    "tGravityAcc-std()-X",  "tGravityAcc-std()-Y",  "tGravityAcc-std()-Z",
                    "tBodyGyro-mean()-X",   "tBodyGyro-mean()-Y",   "tBodyGyro-mean()-Z",                    
                    "tBodyGyro-std()-X",    "tBodyGyro-std()-Y",    "tBodyGyro-std()-Z",
                    "fBodyAcc-mean()-X",    "fBodyAcc-mean()-Y",    "fBodyAcc-mean()-Z",
                    "fBodyAcc-std()-X",     "fBodyAcc-std()-Y",     "fBodyAcc-std()-Z",                     
                    "fBodyGyro-mean()-X",   "fBodyGyro-mean()-Y",   "fBodyGyro-mean()-Z",
                    "fBodyGyro-std()-X",    "fBodyGyro-std()-Y",    "fBodyGyro-std()-Z"                    )
  ##
  ## Read the requested statistics, identified in DESIRED_STATS,
  ## into the tibble data_from_files.
  ##
  data_from_files <- tbl_df(read_files(DESIRED_STATS))
  
  ##
  ## Produce the tidy data table that is requested in
  ## the project description.
  ##
  tidy_data <- tidy_the_data(data_from_files)
  ##
  ## Meet the final project requirement by creating a .txt file
  ## containing the tidy data set.
  ## Note: There are 2 ways to inspect the resulting file tidy_data_set.txt
  ## 1. From R, use the supplied function in file read_tidy_data_set.R.
  ##    From the R command prompt, source the file by entering
  ##    source("<path to read_tidy_data_set.R>") and then execut the command
  ##    "tidy_data <- read_tidy_data_set()".  You can view the data by
  ##    issuing the command "View(tidy_data)"
  ## 2. From Excel, select open file, select "*.* as the file type, and 
  ##    open the tidy_data_set.txt. In the "Text Import wizzard step 1 of 3", select
  ##    "delimited" and "My data has headers" and click next.
  ##    In the "Text Import Wizzard step 2 of 3", click on Space as the delimiter, 
  ##    click Next and then Finish. You should see the contents of the tidy data
  ##    where each Excel row corresponds to an observation and each Excel column
  ##    corresponds to a variable.  The first row are the table headers.
  ##    There should be 5400 observations after the table header row
  ##    and 4 variables per observation.
  ##
  file_name <- "tidy_data_set.txt"
  print(paste("Processing file:", file_name))
  write.table(tidy_data, file = file_name, row.name=FALSE)
  tidy_data
}
  
tidy_the_data <- function(data)
{
  ##
  ## Below is the another hard part: tidying the data
  ## to meet the project's requirements.  This function is invoked
  ## after that data is read in from the data files.
  ##
  ## The steps below will take wide data and, using tidyr's gather() function,
  ## make the data narrow and long.
  ##
  ## That is, the raw data has the following columns;
  ## subject   activity   stat1  stat2 stat3 ... statN
  ##
  ## The tidy data will have the following:
  ## subject   activity  statistic   mean_of_statistic
  ##   1          1      stat1       mean of stat1 with subject = 1 and activity == 1
  ##   2          1      stat2       mean of stat2 with subject = 1 and activity == 2
  ##   and so on
  
  ##
  ## Order rows in data first by the column with label SUBJECT_LABEL
  ## and then by column with label ACTIVITY_LABEL.
  ## This step is not absolutely necessary.  It allowed me to 
  ## double check my result by creating a .csv file and using
  ## Excel to view the data prior to tidying.
  ##
  index = order(data[[SUBJECT_LABEL]], data[[ACTIVITY_LABEL]])
  data = data[index, ]
  ##write.csv(data, file="save.csv")
  
  ##
  ## Do the hard part of tidying the data.
  ##
  result <- data %>%
    gather("statistic", "value", 3:(dim(data)[2])) %>%
    group_by(subject, activity, statistic) %>% 
    summarise(mean_of_statistic = mean(value))
  
  result
}

##
## read_files() does the hard work of reading the data from the appropriate
## files and returns a list of vectors with the requested data.
## desired_stats is a vector of measurement names which are desired.
## The elements of desired_stats are the names contained in the
## file features.txt.
##
##
read_files <- function(desired_stats)
{
  ##
  ## A call to calc_column_vector hides all of the intricate details
  ## of calculating FWF_COL_VECTOR, the vector passed to read.fwf(),
  ## which I selected for reading X_text.txt and X_train.txt.
  ## FWF_COL_VECTOR contains a negative values to skip past file columns
  ## and positive values to read values from file columns.
  ## calc_column_vector() automates the process which would otherwise
  ## be manual and error prone.
  ##
  fwf_col_vector = calc_column_vector(desired_stats)
  
  ##
  ## Constant containing name of 2 datasets to process.
  ##
  DIR_NAMES = c("test","train")
  
  ##
  ## All files processed here have the same extension:
  ##
  FILE_EXTENSION = ".txt"
  
  #
  # Process the file contained in the main directory first.
  # Read integer activity levels and
  # corresponding activity strings from activity_labels.txt.
  #
  file_name <- paste("activity_labels", FILE_EXTENSION, sep="")
  print(paste("Processing file:",file_name ))  
  temp <- read.delim(file_name, sep=" ", header = FALSE)
  activity_levels <- temp[[1]]
  activity_labels <- temp[[2]]
  

  ##
  ## test_list is a list of variables which are column vectors.
  ## The column vectors are made up of observations.
  ##
  test_list = list()
  

  ##
  ## Process the files in the test and train subdirectories.
  ##
  for (dir in DIR_NAMES)
  {
    ## Process the subject_*.txt files.
    ## Subject is an integer between 1 and 30.
    ##
    file_name = paste(dir, "/", "subject_", dir, FILE_EXTENSION, sep = "")
    print(paste("Processing file:", file_name))
    temp <- read.fwf(file_name, c(2))[[1]]
    test_list[[SUBJECT_LABEL]] <- c(test_list[[SUBJECT_LABEL]], temp)
    
    #
    # Read the activity integer for each observation from y_*.txt file.
    # This file has the integer activity levels which will be converted
    # to a factor (ie, an enumator type for R) using the factor() function
    # below.
    #
    file_name <- paste(dir, "/", "y_", dir, FILE_EXTENSION, sep = "")
    print(paste("Processing file:", file_name))    
    temp <- read.fwf(file_name, c(2))[[1]]
    test_list[[ACTIVITY_LABEL]] <- c(test_list[[ACTIVITY_LABEL]], temp)

    ##
    ## Read in the file with the stats, reading just those columns
    ## reflected in fwf_col_vector.
    ##
    ##
    file_name <- paste(dir,"/","X_",dir, FILE_EXTENSION, sep = "")
    print(paste("Processing file:", file_name))
    temp_table <- read.fwf(file_name, fwf_col_vector)
  
    ##
    ## And then add the stats pulled from X_*.txt as additional variables
    ## in test_list.
    ##
    for(i in 1:length(desired_stats))
    {
      temp <- temp_table[[i]]
      label <- desired_stats[i]
      test_list[[label]] = c(test_list[[label]], temp)
    }
  }
  
  ##
  ## Create the factor values for the activity variable.
  ## activity_levels and activity_labels were created above.
  ##
  test_list[[ACTIVITY_LABEL]] <- factor(test_list[[ACTIVITY_LABEL]],  activity_levels, activity_labels)
  
  test_list
}

##
## Calculates the vector passed to read.fwf, 
## which specifies the file columns to read and skip,
## in order to read the variables contained in the
## vector DESIRED_STATS.
##
calc_column_vector <- function(DESIRED_STATS)
{
  ##
  ## Some constants that describe the column spacing in file X_*.txt.
  ##
  NUM_COLS_PER_STAT = 15  ## number of characters making up each numeric value
  NUM_COLS_PER_SEP = 1    ## width of the separation between columns
  NUM_COLS_TOTAL_PER_STAT = NUM_COLS_PER_STAT + NUM_COLS_PER_SEP
  
  FILE_NAME = "features.txt"
  
  print(paste("Processing file:", FILE_NAME))
  stats_in_file <- read.table(FILE_NAME, sep=" ")[[2]]
  stat_index <- NULL
  for(desired_stat in DESIRED_STATS)
  {
    row_number = grep(desired_stat, stats_in_file, fixed = TRUE)
    if (identical(row_number,integer(0)))
    {
      stop(paste("Could not find stat", desired_stat, "in file", FILE_NAME))
    }
    stat_in_file = stats_in_file[row_number]
    if (!identical(stat_in_file, desired_stat))
    {
      stop(paste("stat", desired_stat, "must match", stat_in_file, "exactly, including case"))
    }
    stat_index = c(stat_index, row_number)
  }
  
  ##
  ## Ensure that the column numbers in stat_index
  ## are in increasing order.
  ## This check is needed because read.fwf() must read
  ## FILE columns from left to right in the X_*.txt files.
  ##
  if (!identical(stat_index, sort(stat_index)))
  {
    stop("Requested stats in DESIRED_STATS do not appear in order shown in features.txt")
  }
  
  #
  # stat_index contains the numbers of the desired NUMERIC columns
  # in the the files X_*.txt.
  # Note that the values in stat_index will be between 1 and 561.
  # Convert the NUMERIC column numbers
  # into to FILE column numbers which read.fwf() can use.
  # fwf_col_vector will contain the resulting vector for use by read.fwf().
  # fwf_col_vector will contain negative numbers to skip FILE columns
  # and positive numbers in order to read FILE columns.
  #
  
  fwf_col_vector <- NULL

  for (i in 1:length(stat_index))
  {
    current_col = stat_index[i]

    ##
    ## Assign a default value to cols_to_skip.
    ## Use this value if
    ## 1. (i == 1) and (current_col == 1), or
    ## 2. (i >  1) and (delta_col == 1)
    ##
    cols_to_skip <- NUM_COLS_PER_SEP
    
    if (i == 1)
    {
      if (current_col > 1)
      {
        ##
        ## First element of stat_index is requesting a column other than
        ## the first NUMERIC column.
        ##
        cols_to_skip = (current_col - 1) * NUM_COLS_TOTAL_PER_STAT + NUM_COLS_PER_SEP
      }
    }
    else
    {
      ##
      ## We are processing the 2nd or greater element of stat_index.
      ##
      prev_col = stat_index[i - 1];
      delta_col <- current_col - prev_col
      if (delta_col > 1)
      {
        ##
        ## Consecutive elements of stat_index are not adjacent NUMERIC columns 
        ## in the X_*.txt file.
        ##
        cols_to_skip <- (delta_col - 1) * NUM_COLS_TOTAL_PER_STAT + NUM_COLS_PER_SEP; 
      }
    }
    fwf_col_vector = c(fwf_col_vector, -cols_to_skip, NUM_COLS_PER_STAT)    
  }
  fwf_col_vector
}