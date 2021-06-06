#Download the data set
#Before we get rolling with the EDA, we want to download our data set. 
#For this example, we are going to use the dataset produced by my recent science, 
#technology, art and math (STEAM) project.

#Load the readr library to bring in the dataset
library(readr)

#Download the data set
df= read_csv('https://raw.githubusercontent.com/lgellis/STEM/master/DATA-ART-1/Data/FinalData.csv', col_names = TRUE)

#Head
#To begin, we are going to run the head function, 
#which allows us to see the first 6 rows by default. 
#We are going to override the default and ask to preview the first 10 rows.

head(df, 10)

#dim and Glimpse
#Next, we will run the dim function which displays the dimensions of the table. 
#The output takes the form of row, column.

#And then we run the glimpse function from the dplyr package. 
#This will display a vertical preview of the dataset. 
#It allows us to easily preview data type and sample data.

dim(df)

#Displays the type and a preview of all columns as a row so that it's very easy to take in.

library(dplyr)
glimpse(df)

#Summary
#We then run the summary function to show each column, 
#it's data type and a few other attributes which are especially useful 
#for numeric attributes. We can see that for all the numeric attributes, 
#it also displays min, 1st quartile, median, mean, 3rd quartile and max values.

summary(df)

#Skim
#Next we run the skim function from the skimr package. 
#The skim function is a good addition to the summary function. 
#It displays most of the numerical attributes from summary, 
#but it also displays missing values, more quantile information and an 
#inline histogram for each variable!
  
library(skimr)
skim(df)

#create_report in DataExplorer
#And finally the pièce de résistance, 
#the main attraction and the reason I wrote this blog; 
#the create_report function in the DataExplorer package. 
#This awesome one line function will pull a full data profile of your data frame. 
#It will produce an html file with the basic statistics, structure, 
#missing data, distribution visualizations, correlation matrix and
#principal component analysis for your data frame!
#This function is a game changer!
  
library(DataExplorer)
DataExplorer::create_report(df)

#R Studio project sharing : https://wp.stolaf.edu/it/project-sharing/#:~:text=Select%20File%20and%20then%20select,the%20users%20you've%20selected.


