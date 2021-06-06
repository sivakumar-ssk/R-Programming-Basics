#Vectors from a Sequence of Numbers
#You can create vectors as a sequence of numbers.

series <- 1:10
series

seq(10)

seq(from = 1, to = 10, by = 0.1)

#Missing Data
#R supports missing data in vectors. 
#They are represented as NA (Not Available) and can be used for all the vector types 

x <- c(0.5, NA, 0.7)
x <- c(TRUE, FALSE, NA)
x <- c("a", NA, "c", "d", "e")
x <- c(1+5i, 2-3i, NA)

#The function is.na() indicates the elements of the vectors that represent missing data, 
#and the function anyNA() returns TRUE if the vector contains any missing values:
  
x <- c("a", NA, "c", "d", NA)
y <- c("a", "b", "c", "d", "e")
is.na(x)
is.na(y)
anyNA(x)
anyNA(y)

#Other Special Values
#Inf is infinity. You can have either positive or negative infinity.

1/0

#NaN means Not a Number. It's an undefined value.

0/0

#What Happens When You Mix Types Inside a Vector?
#R will create a resulting vector with a mode that can most easily accommodate all 
#the elements it contains. 
#This conversion between modes of storage is called "coercion". 
#When R converts the mode of storage based on its content, 
#it is referred to as "implicit coercion". 
#For instance, can you guess what the following do (without running them first)?
  
xx <- c(1.7, "a")
xx <- c(TRUE, 2)
xx <- c("a", TRUE)

#You can also control how vectors are coerced explicitly using 
#the as.<class_name>() functions:
  
as.numeric("1")

as.character(1:2)

#Objects Attributes
#Objects can have attributes. Attributes are part of the object. These include:
  
#names
#dimnames
#dim
#class
#attributes (contain metadata)
#You can also glean other attribute-like information such as 
#length (works on vectors and lists) or number of characters (for character strings).

length(1:10)

nchar("Bread")

#Matrix
#In R matrices are an extension of the numeric or character vectors. 
#They are not a separate type of object but simply an atomic vector with dimensions; 
#the number of rows and columns. 
#As with atomic vectors, the elements of a matrix must be of the same data type.

m <- matrix(nrow = 2, ncol = 2)
m

dim(m)

#You can check that matrices are vectors with a class attribute of matrix by 
#using class() and typeof().

m <- matrix(c(1:3))
class(m)
m

typeof(m)

#While class() shows that m is a matrix, typeof() shows that fundamentally 
#the matrix is an integer vector.

#Data types of matrix elements
#Consider the following matrix:
  
FOURS <- matrix(
    c(4, 4, 4, 4),
    nrow = 2,
    ncol = 2)

FOURS 

#Given that typeof(FOURS[1]) returns "double", 
#what would you expect typeof(FOURS) to return? How do you know this is the case even without running this code?
  
#Hint Can matrices be composed of elements of different data types?
  
#Solution
#We know that typeof(FOURS) will also return "double" since 
#matrices are made of elements of the same data type. 
#Note that you could do something like as.character(FOURS) 
#if you needed the elements of FOURS as characters.

#Matrices in R are filled column-wise.

m <- matrix(1:6, nrow = 2, ncol = 3)
m

#Other ways to construct a matrix

m

#This takes a vector and transforms it into a matrix with 2 rows and 5 columns.

#Another way is to bind columns or rows using 
#rbind() and cbind() ("row bind" and "column bind", respectively).

x <- 1:3
y <- 10:12
cbind(x, y)

rbind(x, y)

#You can also use the byrow argument to specify how the matrix is filled. 
#From R's own documentation:
  
mdat <- matrix(c(1, 2, 3, 11, 12, 13),
                 nrow = 2,
                 ncol = 3,
                 byrow = TRUE)
mdat

#Elements of a matrix can be referenced by specifying the index along each
#dimension (e.g. "row" and "column") in single square brackets.

mdat[2, 3]

#List
#In R lists act as containers. 
#Unlike atomic vectors, the contents of a list are not restricted to a single mode 
#and can encompass any mixture of data types. 
#Lists are sometimes called generic vectors, 
#because the elements of a list can by of any type of R object, 
#even lists containing further lists. 
#This property makes them fundamentally different from atomic vectors.

#A list is a special type of vector. Each element can be a different type.

#Create lists using list() or coerce other objects using as.list(). 
#An empty list of the required length can be created using vector()

x <- list(1, "a", TRUE, 1+4i)
x

x <- vector("list", length = 5) # empty list
length(x)

#The content of elements of a list can be retrieved by using double square brackets.
x[[1]]

#Vectors can be coerced to lists as follows:
  
x <- 1:10
x <- as.list(x)
length(x)

#What is the class of x[1]?
#What is the class of x[[1]]?
  
#Elements of a list can be named (i.e. lists can have the names attribute)

xlist <- list(a = "Karthik Ram", b = 1:10, data = head(mtcars))
xlist

View(mtcars)

head(mtcars)

tail(mtcars)

names(xlist)

#Examining Named Lists
#What is the length of this object?
#What is its structure?
  
#Lists can be extremely useful inside functions. 
#Because the functions in R are able to return only a single object, 
#you can "staple" together lots of different kinds of results into a 
#single object that a function can return.

#A list does not print to the console like a vector. 
  #Instead, each element of the list starts on a new line.

#Elements are indexed by double brackets. 
  #Single brackets will still return a(nother) list. 
#If the elements of a list are named, they can be referenced by the $ notation 
#(i.e. xlist$data).

#Data Frame
#A data frame is a very important data type in R. 
#It's pretty much the de facto data structure for most tabular data and what we use 
#for statistics.

#A data frame is a special type of list where every element of the 
#list has same length (i.e. data frame is a "rectangular" list).

#Data frames can have additional attributes such as rownames(), 
#which can be useful for annotating data, 
#like subject_id or sample_id. But most of the time they are not used.

#Some additional information on data frames:
  
#Usually created by read.csv() and read.table(), i.e. when importing the data into R.
#Assuming all columns in a data frame are of same type, 
#data frame can be converted to a matrix with data.matrix() (preferred) or as.matrix(). 
#Otherwise type coercion will be enforced and the results may not always be what you expect.
#Can also create a new data frame with data.frame() function.
#Find the number of rows and columns with nrow(dat) and ncol(dat), respectively.
#Rownames are often automatically generated and look like 1, 2, ., n. Consistency in numbering of rownames may not be honored when rows are reshuffled or subset.
#Creating Data Frames by Hand
#To create data frames by hand:
  
dat <- data.frame(id = letters[1:10], x = 1:10, y = 11:20)
dat

#Useful Data Frame Functions
#head() - shows first 6 rows
#tail() - shows last 6 rows
#dim() - returns the dimensions of data frame (i.e. number of rows and number of columns)
#nrow() - number of rows
#ncol() - number of columns
#str() - structure of data frame - name, type and preview of data in each column
#names() or colnames() - both show the names attribute for a data frame
#sapply(dataframe, class) - shows the class of each column in the data frame
#See that it is actually a special list:
  
  
is.list(dat)

class(dat)

dat[1, 3]

#As data frames are also lists, it is possible to refer to columns (which are elements of such list) using the list notation, i.e. either double square brackets or a $.

dat[["y"]]

dat$y

#The following table summarizes the one-dimensional and two-dimensional 
#data structures in R in relation to diversity of data types they can contain.

#Dimensions	Homogenous	Heterogeneous
#1-D	atomic vector	list
#2-D	matrix	data frame
#Lists can contain elements that are themselves muti-dimensional 
#(e.g. a lists can contain data frames or another type of objects). Lists can also contain elements of any length, therefore list do not necessarily have to be "rectangular". However in order for the list to qualify as a data frame, the length of each element has to be the same.

#Column Types in Data Frames
#Knowing that data frames are lists, can columns be of different type?
  
#What type of structure do you expect to see when you explore the structure 
#of the PlantGrowth data frame? Hint: Use str().







