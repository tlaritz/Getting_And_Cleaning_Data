read_tidy_data_set <- function()
{
  ##
  ## A function that reads tidy_data from the file "tidy_data_set.txt.
  ##
  
  FILE_NAME = "tidy_data_set.txt"
  
  tidy_data <- read.table(FILE_NAME, header = TRUE)
  
  tidy_data
  
}