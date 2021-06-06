# Converting data between wide and long format
# tidyr
# From wide to long
# From long to wide
# reshape2
# From wide to long
# From long to wide
# Problem
# You want to do convert data from a wide format to a long format.
# 
# Many functions in R expect data to be in a long format rather than a wide format. Programs like SPSS, however, often use wide-formatted data.
# 
# Solution
# There are two sets of methods that are explained below:
#   
#   gather() and spread() from the tidyr package. This is a newer interface to the reshape2 package.
# melt() and dcast() from the reshape2 package.
# There are a number of other methods which aren't covered here, since they are not as easy to use:
#   
#   The reshape() function, which is confusingly not part of the reshape2 package; it is part of the base install of R.
# stack() and unstack()
# Sample data
# These data frames hold the same data, but in wide and long formats. They will each be converted to the other format below.

olddata_wide <- read.table(header=TRUE, text='
 subject sex control cond1 cond2
       1   M     7.9  12.3  10.7
       2   F     6.3  10.6  11.1
       3   F     9.5  13.1  13.8
       4   M    11.5  13.4  12.9
')
# Make sure the subject column is a factor
olddata_wide$subject <- factor(olddata_wide$subject)
olddata_wide$subject 
olddata_long <- read.table(header=TRUE, text='
 subject sex condition measurement
       1   M   control         7.9
       1   M     cond1        12.3
       1   M     cond2        10.7
       2   F   control         6.3
       2   F     cond1        10.6
       2   F     cond2        11.1
       3   F   control         9.5
       3   F     cond1        13.1
       3   F     cond2        13.8
       4   M   control        11.5
       4   M     cond1        13.4
       4   M     cond2        12.9
')
# Make sure the subject column is a factor
olddata_long$subject <- factor(olddata_long$subject)
#tidyr
#From wide to long
#Use gather:
  
  olddata_wide


library(tidyr)

# The arguments to gather():
# - data: Data object
# - key: Name of new key column (made from names of data columns)
# - value: Name of new value column
# - ...: Names of source columns that contain values
# - factor_key: Treat the new key column as a factor (instead of character vector)
data_long <- gather(olddata_wide, condition, measurement, control:cond2, factor_key=TRUE)
data_long

#In this example, the source columns that are gathered are specified with control:cond2. 
#This means to use all the columns, positionally, between control and cond2. 
#Another way of doing it is to name the columns individually, as in:
  
  gather(olddata_wide, condition, measurement, control, cond1, cond2)

  #If you need to use gather() programmatically, you may need to use variables containing column names. 
  #To do this, you should use the gather_() function instead, 
  #which takes strings instead of bare (unquoted) column names.

keycol <- "condition"
valuecol <- "measurement"
gathercols <- c("control", "cond1", "cond2")

gather_(olddata_wide, keycol, valuecol, gathercols)

#Optional: Rename the factor levels of the variable column, and sort.

# Rename factor names from "cond1" and "cond2" to "first" and "second"
levels(data_long$condition)[levels(data_long$condition)=="cond1"] <- "first"
levels(data_long$condition)[levels(data_long$condition)=="cond2"] <- "second"

# Sort by subject first, then by condition
data_long <- data_long[order(data_long$subject, data_long$condition), ]
data_long

#From long to wide
#Use spread:
  
  olddata_long

library(tidyr)

# The arguments to spread():
# - data: Data object
# - key: Name of column containing the new column names
# - value: Name of column containing values
data_wide <- spread(olddata_long, condition, measurement)
data_wide
#>   subject sex cond1 cond2 control
#> 1       1   M  12.3  10.7     7.9
#> 2       2   F  10.6  11.1     6.3
#> 3       3   F  13.1  13.8     9.5
#> 4       4   M  13.4  12.9    11.5

#Optional: A few things to make the data look nicer.

# Rename cond1 to first, and cond2 to second
names(data_wide)[names(data_wide)=="cond1"] <- "first"
names(data_wide)[names(data_wide)=="cond2"] <- "second"

# Reorder the columns
data_wide <- data_wide[, c(1,2,5,3,4)]
data_wide

#The order of factor levels determines the order of the columns.
#The level order can be changed before reshaping, or the columns can be re-ordered afterward.

#reshape2
# From wide to long
# Use melt:
  
  olddata_wide

library(reshape2)

# Specify id.vars: the variables to keep but not split apart on
melt(olddata_wide, id.vars=c("subject", "sex"))

?melt()

#There are options for melt that can make the output a little easier to work with:
  
  data_long <- melt(olddata_wide,
                    # ID variables - all the variables to keep but not split apart on
                    id.vars=c("subject", "sex"),
                    # The source columns
                    measure.vars=c("control", "cond1", "cond2" ),
                    # Name of the destination column that will identify the original
                    # column that the measurement came from
                    variable.name="condition",
                    value.name="measurement"
  )
data_long

# If you leave out the measure.vars, melt will automatically use all the other variables as the id.vars. The reverse is true if you leave out id.vars.
# 
# If you don't specify variable.name, it will name that column "variable", and if you leave out value.name, it will name that column "measurement".
# 
# Optional: Rename the factor levels of the variable column.

# Rename factor names from "cond1" and "cond2" to "first" and "second"
levels(data_long$condition)[levels(data_long$condition)=="cond1"] <- "first"
levels(data_long$condition)[levels(data_long$condition)=="cond2"] <- "second"

# Sort by subject first, then by condition
data_long <- data_long[ order(data_long$subject, data_long$condition), ]
data_long

# From long to wide
# The following code uses dcast to reshape the data. This function is meant for data frames; if you are working with arrays or matrices, use acast instead.

olddata_long

# From the source:
# "subject" and "sex" are columns we want to keep the same
# "condition" is the column that contains the names of the new column to put things in
# "measurement" holds the measurements
library(reshape2)

data_wide <- dcast(olddata_long, subject + sex ~ condition, value.var="measurement")
data_wide

#Optional: A few things to make the data look nicer.

# Rename cond1 to first, and cond2 to second
names(data_wide)[names(data_wide)=="cond1"] <- "first"
names(data_wide)[names(data_wide)=="cond2"] <- "second"

# Reorder the columns
data_wide <- data_wide[, c(1,2,5,3,4)]
data_wide

# The order of factor levels determines the order of the columns.
# 
# The level order can be changed before reshaping, or the columns can be re-ordered afterward.
# 


# __________________________x________________________________#

Using stack() for data frames with a simple structure
Wide format -> long format
set.seed(123)
Nj     <- 4
cond1  <- sample(1:10, Nj, replace=TRUE)
cond2  <- sample(1:10, Nj, replace=TRUE)
cond3  <- sample(1:10, Nj, replace=TRUE)
dfTemp <- data.frame(cond1, cond2, cond3)
(res   <- stack(dfTemp, select=c("cond1", "cond3")))
values   ind
1      3 cond1
2      3 cond1
3     10 cond1
4      2 cond1
5      9 cond3
6     10 cond3
7      5 cond3
8      3 cond3
str(res)
'data.frame':   8 obs. of  2 variables:
  $ values: int  3 3 10 2 9 10 5 3
$ ind   : Factor w/ 2 levels "cond1","cond3": 1 1 1 1 2 2 2 2
Long format -> wide format
unstack(res)
cond1 cond3
1     3     9
2     3    10
3    10     5
4     2     3
res$IVnew <- factor(sample(rep(c("A", "B"), Nj), 2*Nj, replace=FALSE))
res$DVnew <- sample(100:200, 2*Nj)
head(res)
values   ind IVnew DVnew
1      3 cond1     A   125
2      3 cond1     A   106
3     10 cond1     B   141
4      2 cond1     A   108
5      9 cond3     A   182
6     10 cond3     B   135
unstack(res, DVnew ~ IVnew)
A   B
1 125 141
2 106 135
3 108 177
4 182 180
Using reshape() for more complex data frames
One within variable
Simulate data
Nj      <- 2
P       <- 2
Q       <- 3
id      <- 1:(P*Nj)
DV_t1   <- round(rnorm(P*Nj, -1, 1), 2)
DV_t2   <- round(rnorm(P*Nj,  0, 1), 2)
DV_t3   <- round(rnorm(P*Nj,  1, 1), 2)
IVbtw   <- factor(rep(c("A", "B"), Nj))
(dfWide <- data.frame(id, IVbtw, DV_t1, DV_t2, DV_t3))
id IVbtw DV_t1 DV_t2 DV_t3
1  1     A -0.30 -1.03  1.84
2  2     B -1.47 -0.73  1.15
3  3     A -2.07 -0.63 -0.14
4  4     B -1.22 -1.69  2.25
idL    <- rep(id, Q)
DVl    <- c(DV_t1, DV_t2, DV_t3)
IVwth  <- factor(rep(1:3, each=P*Nj))
IVbtwL <- rep(IVbtw, times=Q)
dfLong <- data.frame(id=idL, IVbtw=IVbtwL, IVwth=IVwth, DV=DVl)
dfLong[order(dfLong$id), ]
id IVbtw IVwth    DV
1   1     A     1 -0.30
5   1     A     2 -1.03
9   1     A     3  1.84
2   2     B     1 -1.47
6   2     B     2 -0.73
10  2     B     3  1.15
3   3     A     1 -2.07
7   3     A     2 -0.63
11  3     A     3 -0.14
4   4     B     1 -1.22
8   4     B     2 -1.69
12  4     B     3  2.25
Wide format -> long format
resLong <- reshape(dfWide, varying=c("DV_t1", "DV_t2", "DV_t3"),
                   direction="long", idvar=c("id", "IVbtw"),
                   v.names="DV", timevar="IVwth")
resLong[order(resLong$id), ]
id IVbtw IVwth    DV
1.A.1  1     A     1 -0.30
1.A.2  1     A     2 -1.03
1.A.3  1     A     3  1.84
2.B.1  2     B     1 -1.47
2.B.2  2     B     2 -0.73
2.B.3  2     B     3  1.15
3.A.1  3     A     1 -2.07
3.A.2  3     A     2 -0.63
3.A.3  3     A     3 -0.14
4.B.1  4     B     1 -1.22
4.B.2  4     B     2 -1.69
4.B.3  4     B     3  2.25
resLong$IVwth <- factor(resLong$IVwth)
all.equal(dfLong, resLong, check.attributes=FALSE)
[1] TRUE
Long format -> wide format
reshape(dfLong, v.names="DV", timevar="IVwth", idvar=c("id", "IVbtw"),
        direction="wide")
id IVbtw  DV.1  DV.2  DV.3
1  1     A -0.30 -1.03  1.84
2  2     B -1.47 -0.73  1.15
3  3     A -2.07 -0.63 -0.14
4  4     B -1.22 -1.69  2.25
Two within variables
Simulate data
Nj   <- 4
id   <- 1:Nj
t_11 <- round(rnorm(Nj,  8, 2), 2)
t_21 <- round(rnorm(Nj, 13, 2), 2)
t_31 <- round(rnorm(Nj, 13, 2), 2)
t_12 <- round(rnorm(Nj, 10, 2), 2)
t_22 <- round(rnorm(Nj, 15, 2), 2)
t_32 <- round(rnorm(Nj, 15, 2), 2)
dfW  <- data.frame(id, t_11, t_21, t_31, t_12, t_22, t_32)
Wide format -> long format
(dfL1 <- reshape(dfW, varying=list(c("t_11", "t_21", "t_31"),
                                   c("t_12", "t_22", "t_32")),
                 direction="long", timevar="IV1", idvar="id",
                 v.names=c("IV2-1", "IV2-2")))
id IV1 IV2-1 IV2-2
1.1  1   1  8.85  7.47
2.1  2   1  7.41 14.34
3.1  3   1  9.79 12.42
4.1  4   1  9.76  7.75
1.2  1   2 14.64 14.19
2.2  2   2 14.38 14.07
3.2  3   2 14.11 16.56
4.2  4   2 12.88 14.83
1.3  1   3 12.39 15.51
2.3  2   3 12.24 14.94
3.3  3   3 11.61 14.91
4.3  4   3 12.58 17.74
dfL2 <- reshape(dfL1, varying=c("IV2-1", "IV2-2"),
                direction="long", timevar="IV2",
                idvar=c("id", "IV1"), v.names="DV")
head(dfL2)
id IV1 IV2    DV
1.1.1  1   1   1  8.85
2.1.1  2   1   1  7.41
3.1.1  3   1   1  9.79
4.1.1  4   1   1  9.76
1.2.1  1   2   1 14.64
2.2.1  2   2   1 14.38
Long format -> wide format
dfW1 <- reshape(dfL2, v.names="DV", timevar="IV1",
                idvar=c("id", "IV2"), direction="wide")
dfW2 <- reshape(dfW1, v.names=c("DV.1", "DV.2", "DV.3"),
                timevar="IV2", idvar="id", direction="wide")

all.equal(dfW, dfW2, check.attributes=FALSE)
[1] TRUE

Useful packages
Package tidyr provides functions pivot_longer() and pivot_wider() for an alternative approach 
to reshaping data frames that can be integrated into a dplyr based workflow.


Reshaping Your Data with tidyr
Although many fundamental data processing functions exist in R, they have been a bit convoluted to date and have lacked consistent coding and the ability to easily flow together. This leads to difficult-to-read nested functions and/or choppy code. R Studio is driving a lot of new packages to collate data management tasks and better integrate them with other analysis activities. As a result, a lot of data processing tasks are becoming packaged in more cohesive and consistent ways, which leads to:
  
  More efficient code
Easier to remember syntax
Easier to read syntax
tidyr is a one such package which was built for the sole purpose of simplifying the process of creating tidy data. This tutorial provides you with the basic understanding of the four fundamental functions of data tidying that tidyr provides:
  
  gather() makes "wide" data longer
spread() makes "long" data wider
separate() splits a single column into multiple columns
unite() combines multiple columns into a single column
Additional Resources


Packages Utilized
install.packages("tidyr")
library(tidyr)



%>% Operator
Although not required, the tidyr and dplyr packages make use of the pipe operator %>% developed by Stefan Milton Bache in the R package magrittr. Although all the functions in tidyr and dplyr can be used without the pipe operator, one of the great conveniences these packages provide is the ability to string multiple functions together by incorporating %>%.

This operator will forward a value, or the result of an expression, into the next function call/expression. For instance a function to filter data can be written as:
  
  filter(data, variable == numeric_value)
or
data %>% filter(variable == numeric_value)


Both functions complete the same task and the benefit of using %>% is not evident; however, when you desire to perform multiple functions its advantage becomes obvious. For more info check out the %>% tutorial.




gather( ) function:
  Objective: Reshaping wide format to long format

Description: There are times when our data is considered unstacked and a common attribute of concern is spread out across columns. To reformat the data such that these common attributes are gathered together as a single variable, the gather() function will take multiple columns and collapse them into key-value pairs, duplicating all other columns as needed.

gather() function

Function:       gather(data, key, value, ..., na.rm = FALSE, convert = FALSE)
Same as:        data %>% gather(key, value, ..., na.rm = FALSE, convert = FALSE)

Arguments:
  data:           data frame
key:            column name representing new variable
value:          column name representing variable values
...:            names of columns to gather (or not gather)
na.rm:          option to remove observations with missing values (represented by NAs)
convert:        if TRUE will automatically convert values to logical, integer, numeric, complex or factor as appropriate
??? This function is a complement to spread()

Example

We'll start with the following data set:
  
  ## Source: local data frame [12 x 6]
  ## 
  ##    Group Year Qtr.1 Qtr.2 Qtr.3 Qtr.4
  ## 1      1 2006    15    16    19    17
  ## 2      1 2007    12    13    27    23
  ## 3      1 2008    22    22    24    20
  ## 4      1 2009    10    14    20    16
  ## 5      2 2006    12    13    25    18
  ## 6      2 2007    16    14    21    19
  ## 7      2 2008    13    11    29    15
## 8      2 2009    23    20    26    20
## 9      3 2006    11    12    22    16
## 10     3 2007    13    11    27    21
## 11     3 2008    17    12    23    19
## 12     3 2009    14     9    31    24
This data is considered wide since the time variable (represented as quarters) is structured such that each quarter represents a variable. To re-structure the time component as an individual variable, we can gather each quarter within one column variable and also gather the values associated with each quarter in a second column variable.

long_DF <- DF %>% gather(Quarter, Revenue, Qtr.1:Qtr.4)
head(long_DF, 24)  # note, for brevity, I only show the data for the first two years 

## Source: local data frame [24 x 4]
## 
##    Group Year Quarter Revenue
## 1      1 2006   Qtr.1      15
## 2      1 2007   Qtr.1      12
## 3      1 2008   Qtr.1      22
## 4      1 2009   Qtr.1      10
## 5      2 2006   Qtr.1      12
## 6      2 2007   Qtr.1      16
## 7      2 2008   Qtr.1      13
## 8      2 2009   Qtr.1      23
## 9      3 2006   Qtr.1      11
## 10     3 2007   Qtr.1      13
## ..   ...  ...     ...     ...
These all produce the same results:
  
  DF %>% gather(Quarter, Revenue, Qtr.1:Qtr.4)
DF %>% gather(Quarter, Revenue, -Group, -Year)
DF %>% gather(Quarter, Revenue, 3:6)
DF %>% gather(Quarter, Revenue, Qtr.1, Qtr.2, Qtr.3, Qtr.4)
Also note that if you do not supply arguments for na.rm or convert values then the defaults are used.



separate( ) function:
  Objective: Splitting a single variable into two

Description: Many times a single column variable will capture multiple variables, or even parts of a variable you just don't care about. Some examples include:
  
  ##   Grp_Ind    Yr_Mo       City_State        First_Last Extra_variable
  ## 1     1.a 2006_Jan      Dayton (OH) George Washington   XX01person_1
  ## 2     1.b 2006_Feb Grand Forks (ND)        John Adams   XX02person_2
  ## 3     1.c 2006_Mar       Fargo (ND)  Thomas Jefferson   XX03person_3
  ## 4     2.a 2007_Jan   Rochester (MN)     James Madison   XX04person_4
  ## 5     2.b 2007_Feb     Dubuque (IA)      James Monroe   XX05person_5
  ## 6     2.c 2007_Mar Ft. Collins (CO)        John Adams   XX06person_6
  ## 7     3.a 2008_Jan   Lake City (MN)    Andrew Jackson   XX07person_7
  ## 8     3.b 2008_Feb    Rushford (MN)  Martin Van Buren   XX08person_8
  ## 9     3.c 2008_Mar          Unknown  William Harrison   XX09person_9
In each of these cases, our objective may be to separate characters within the variable string. This can be accomplished using the separate() function which turns a single character column into multiple columns.

Function:       separate(data, col, into, sep = " ", remove = TRUE, convert = FALSE)
Same as:        data %>% separate(col, into, sep = " ", remove = TRUE, convert = FALSE)

Arguments:
  data:           data frame
col:            column name representing current variable
into:           names of variables representing new variables
sep:            how to separate current variable (char, num, or symbol)
remove:         if TRUE, remove input column from output data frame
convert:        if TRUE will automatically convert values to logical, integer, numeric, complex or 
factor as appropriate
??? This function is a complement to unite()

Example

We can go back to our long_DF dataframe we created above in which way may desire to clean up or separate the Quarter variable.

## Source: local data frame [6 x 4]
## 
##   Group Year Quarter Revenue
## 1     1 2006   Qtr.1      15
## 2     1 2007   Qtr.1      12
## 3     1 2008   Qtr.1      22
## 4     1 2009   Qtr.1      10
## 5     2 2006   Qtr.1      12
## 6     2 2007   Qtr.1      16
By applying the separate() function we get the following:
  
  separate_DF <- long_DF %>% separate(Quarter, c("Time_Interval", "Interval_ID"))
head(separate_DF, 10)

## Source: local data frame [10 x 5]
## 
##    Group Year Time_Interval Interval_ID Revenue
## 1      1 2006           Qtr           1      15
## 2      1 2007           Qtr           1      12
## 3      1 2008           Qtr           1      22
## 4      1 2009           Qtr           1      10
## 5      2 2006           Qtr           1      12
## 6      2 2007           Qtr           1      16
## 7      2 2008           Qtr           1      13
## 8      2 2009           Qtr           1      23
## 9      3 2006           Qtr           1      11
## 10     3 2007           Qtr           1      13
These produce the same results:
  
  long_DF %>% separate(Quarter, c("Time_Interval", "Interval_ID"))
long_DF %>% separate(Quarter, c("Time_Interval", "Interval_ID"), sep = "\\.")


unite( ) function:
  Objective: Merging two variables into one

Description: There may be a time in which we would like to combine the values of two variables. The unite() function is a convenience function to paste together multiple variable values into one. In essence, it combines two variables of a single observation into one variable.

Function:       unite(data, col, ..., sep = " ", remove = TRUE)
Same as:        data %>% unite(col, ..., sep = " ", remove = TRUE)

Arguments:
  data:           data frame
col:            column name of new "merged" column
...:            names of columns to merge
sep:            separator to use between merged values
remove:         if TRUE, remove input column from output data frame
??? This function is a complement to separate()

Example

Using the separate_DF dataframe we created above, we can re-unite the Time_Interval and Interval_ID variables we created and re-create the original Quarter variable we had in the long_DF dataframe.

unite_DF <- separate_DF %>% unite(Quarter, Time_Interval, Interval_ID, sep = ".")
head(unite_DF, 10)

## Source: local data frame [10 x 4]
## 
##    Group Year Quarter Revenue
## 1      1 2006   Qtr.1      15
## 2      1 2007   Qtr.1      12
## 3      1 2008   Qtr.1      22
## 4      1 2009   Qtr.1      10
## 5      2 2006   Qtr.1      12
## 6      2 2007   Qtr.1      16
## 7      2 2008   Qtr.1      13
## 8      2 2009   Qtr.1      23
## 9      3 2006   Qtr.1      11
## 10     3 2007   Qtr.1      13
These produce the same results:
  
  separate_DF %>% unite(Quarter, Time_Interval, Interval_ID, sep = "_")
separate_DF %>% unite(Quarter, Time_Interval, Interval_ID)

# If no spearator is identified, "_" will automatically be used


spread( ) function:
  Objective: Reshaping long format to wide format

Description: There are times when we are required to turn long formatted data into wide formatted data. The spread() function spreads a key-value pair across multiple columns.

Function:       spread(data, key, value, fill = NA, convert = FALSE)
Same as:        data %>% spread(key, value, fill = NA, convert = FALSE)

Arguments:
  data:           data frame
key:            column values to convert to multiple columns
value:          single column values to convert to multiple columns' values 
        fill:           If there isn't a value for every combination of the other variables and the key 
column, this value will be substituted
convert:        if TRUE will automatically convert values to logical, integer, numeric, complex or 
factor as appropriate
??? This function is a complement to gather()

Example

wide_DF <- unite_DF %>% spread(Quarter, Revenue)
head(wide_DF, 24)

## Source: local data frame [12 x 6]
## 
##    Group Year Qtr.1 Qtr.2 Qtr.3 Qtr.4
## 1      1 2006    15    16    19    17
## 2      1 2007    12    13    27    23
## 3      1 2008    22    22    24    20
## 4      1 2009    10    14    20    16
## 5      2 2006    12    13    25    18
## 6      2 2007    16    14    21    19
## 7      2 2008    13    11    29    15
## 8      2 2009    23    20    26    20
## 9      3 2006    11    12    22    16
## 10     3 2007    13    11    27    21
## 11     3 2008    17    12    23    19
## 12     3 2009    14     9    31    24