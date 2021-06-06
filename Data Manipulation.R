# %in% Operator: 
# Checks if an element belongs to a list and returns a boolean value TRUE
#if the value is present else FALSE.

#Input : 

val <- 0.1
list1 <- c(TRUE, 0.1,"apple")
print (val %in% list1)
# Checks for the value 0.1 in the specified list. It exists, therefore, prints TRUE.


#OR

v1 <- 8
v2 <- 12
t <- 1:10
print(v1 %in% t) 
print(v2 %in% t)


#%*% operator:
#This operator is used to multiply a matrix with its transpose.

M = matrix( c(2,6,5,1,10,4), nrow = 2,ncol = 3,byrow = TRUE)
t = M %*% t(M)
print(t)


#Sorting Data
#To sort a data frame in R, use the order( ) function. 
#By default, sorting is ASCENDING.
#Prepend the sorting variable by a minus sign to indicate DESCENDING order. 
#Here are some examples.

# sorting examples using the mtcars dataset

View(mtcars)

attach(mtcars)

# sort by mpg
newdata <- mtcars[order(mpg),]
newdata

# sort by mpg and cyl
newdata <- mtcars[order(mpg, cyl),]
newdata

#sort by mpg (ascending) and cyl (descending)
newdata <- mtcars[order(mpg, -cyl),]
newdata

?detach(mtcars)

#Merging Data
authors <- data.frame(
  surname = c("Tukey", "Venables", "Tierney", "Ripley", "McNeil"),
  nationality = c("US", "Australia", "US", "UK", "Australia"),
  retired = c("yes", rep("no", 4)))

authors

books <- data.frame(
  name = c("Tukey", "Venables", "Tierney", "Ripley", "Ripley", "McNeil"),
  title = c("Exploratory Data Analysis",
            "Modern Applied Statistics ...",
            "LISP-STAT",
            "Spatial Statistics", "Stochastic Simulation",
            "Interactive Data Analysis"),
  other.author = c(NA, "Ripley", NA, NA, NA, NA))

books

merge(authors, books, by.x="surname", by.y="name")
merge(books, authors, by.x="name", by.y="surname")

#rbind
#cbind
