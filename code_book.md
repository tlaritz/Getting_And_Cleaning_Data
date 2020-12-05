This file contains a description of the data which is produced by 
the run_analysis() function when executed in the main data directory.
The result from run_analysis() is a tidy data set with 5400 observations
and 4 variables.  Each of the variables are described below:

1. subject:  This is an integer between 1 and 30 (inclusive) representing the 
   30 subjects from whom data is collected.
   
2. activity:  This is an R factor which represent the various activities in which
   the subjects engaged during data collection.  In the raw data, the activity
   was encoded as an integer between 1 and 6 (inclusive).  In the tidy data,
   activity can take on the values of WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS,
   SITTING, STANDING, and LAYING.  The integer values were converted to 
   these labels using the R factor() function.
   
3. statistic:  This is the name of observations whose mean is calculated.  The
   values shown here are drawn from the 561 measurements contained in the 
   features.txt file. The values in this column can take on one of the following
   30 values:
   1. "tBodyAcc-mean()-X"    
   2. "tBodyAcc-mean()-Y"    
   3. "tBodyAcc-mean()-Z"
   4. "tBodyAcc-std()-X"     
   5. "tBodyAcc-std()-Y"     
   6. "tBodyAcc-std()-Z"
   7. "tGravityAcc-mean()-X" 
   8. "tGravityAcc-mean()-Y" 
   9. "tGravityAcc-mean()-Z"                    
   10. "tGravityAcc-std()-X"  
   11. "tGravityAcc-std()-Y"  
   12.  tGravityAcc-std()-Z"
   13. "tBodyGyro-mean()-X"   
   14. "tBodyGyro-mean()-Y"   
   15. "tBodyGyro-mean()-Z"                    
   16. "tBodyGyro-std()-X"    
   17. "tBodyGyro-std()-Y"    
   18. "tBodyGyro-std()-Z"
   19. "fBodyAcc-mean()-X"    
   20. "fBodyAcc-mean()-Y"    
   21. "fBodyAcc-mean()-Z",
   22. "fBodyAcc-std()-X",     
   23. "fBodyAcc-std()-Y",     
   24. "fBodyAcc-std()-Z",                     
   25. "fBodyGyro-mean()-X"   
   26. "fBodyGyro-mean()-Y"   
   27. "fBodyGyro-mean()-Z"
   28. "fBodyGyro-std()-X"    
   29. "fBodyGyro-std()-Y"    
   30. "fBodyGyro-std()-Z"

4. mean_of_statistic: For all observations corresponding to the subject in column 1 
   and the activity in column 2, this value is the equally-weighted mean of the          observations specified in column 3.
