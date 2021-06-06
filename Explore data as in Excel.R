library(readxl)
#View the Data with tidyr::glimpse()
#The tidyverse offers a user-friendly way to view this data with the
#glimpse() function that is part of the tibble package. 
#To use this package, we will need to load it for use in our current session. 
#But rather than loading this package alone, 
#we can load many of the tidyverse packages at one time. 
#If you do not have the tidyverse collection of packages, 
#install it on your machine using the following command in your R or R Studio session:
  
install.packages("tidyverse")

#Once the package is installed, load it to memory:
  
library(tidyverse)

#Now that tidyverse is loaded into memory, take a "glimpse" of the Superstore dataset:
  
glimpse(Sample_EU_Superstore)

View() can also be used 

#The glimpse() function provides a user-friendly way to view the column names 
#and data types for all columns, or variables, in the data frame.
#With this function, we are also able to view the first few observations in 
#the data frame. This data frame has 20,185 observations, 
#or property sales records. And there are 21 variables, or columns.

#Data Types
#Looking at the data types for each column, we see that, 
#in general, the data is stored in a format that is ready to use! For example

mean(Sample_EU_Superstore $`Profit`)


