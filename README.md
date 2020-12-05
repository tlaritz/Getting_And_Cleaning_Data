There are 2 scripts submitted as part of this peer-reviwed assignment, 
"Getting and Cleaning Data Course Project":

1. run_analysis.R:  This file contains the functions which solves the problem posed 
   by the assignment.  This file contains a function run_analsys() which 
   reads the data files and produces a tidy data set.  It finally
   generates a file tidy_data_set.txt which allows for reviewers to verify
   that the data set produced is in fact tidy and contains
   accurate results.
   
2. read_tidy_data_set.R:  This is an aid for reviewers to help in inspecting
   the tidy set produced by run_analysis().  read_tidy_data_set() reads the
   submitted file tidy_data_set.txt.  Reviewers can use the View() function
   to look and the resulting data.
   
Each script will be described below.

run_analysis()
--------------
This is the function which solves the problem posed in the project description.

1. Its input is a hard coded vector of statistic names.  The vector is contained
   in the variable DESIRED_STATS.
2. Its main output is a tibble named tidy_data and is returned by the the function
   run_analysis().  Its secondary output is the file tidy_data_set.txt
   which contains the same table as tidy_data.  This file can be read by 
   reviewers using a varity of techniques.

run_analysis() breaks the problem downs into 2 steps, where each step is 
implemented in its own function:

1. read_files():  This function is responsible for reading all of the pertinent
   data files and generating a list of vectors with the pertinent data.
   This function reads the following files:
   
    1. features.txt:  This file contains a list of statistics contained in the
       X_*.txt files.  Each lines corresponds to a statistic and also includes 
       the column number in the X_*.txt files where that statistic can be found.
       This file is read using the read.table() function.  This file contains
       561 lines representing 561 statistics.
       
    2. activity_labels.txt:  This file contains on each of its 6 lines an
       activity ID and the activity label.  This file is 6 lines long 
       representing the 6 activitys which subjects undertook during the data
       collection.  This file is read using the read.delim() function.
    
    3. test/subject_test.txt and train/subject_train.txt:  These files contain the
       integer ID, representing the 30 subjects, corresponding each observation.             These IDs are integers between.  This file is read by the read.fwf() 
       function.
    
    4. test/y_test.txt and train/y_train.txt:  These files contain the 
       activity corresponding to each observation.  It is read using the 
       read.fwf() function.
    
    5. test/X_test.txt and train/X_train.txt:  These files contain
       the 561 statistics available for each observation.  Thus it has 561
       columns representing 561 variables.  These are the largest data files
       and are read using the read.fwf() functions.
       
  Reading the test/X_test.txt and train/X_train.txt using the read.fwf() function
  require a vector which describes the file columns to skip and to read into order
  to obtain the statistic requested in DESIRED_STATS. read_files() uses a helper
  function, calc_column_vector(), which converts the column number of the
  desired statistics (ie, a number from 1 to 561) into a vector describing
  the file columns to skip (which are represented by negative integers)
  and the file columns to read (which are presented by positive integer).
  
  The output of read_files() is a list of vectors named test_list.  test_list
  represents an untidy data set.

2. tidy_the_data():  run_analysis() calls read_files() and converts the
   list of vectors returned by read_files() into a tibble.  This tibble
   represents an untidy data set which is passed to tidy_the_data().
   tidy_the_data() uses functions from the tidyr library, including 
   gather(), group_by() and summarize(), to generate a tidy data set.
   
For more information about the detailed processing of read_files(),
calc_column_vector(), and tidy_the_data(), see the code comments in the file
run_analysis.R.   
  
       
read_tidy_data_set()
------------------
This function is an aid to reviewers who wish to inspect the tidy data
set using R.  It reads tidy_data_set.txt using the read.table() function.
This function is contained in read_tidy_data_set.R.

