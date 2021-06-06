#The key in vectorizing R code, is to reduce or eliminate 
#"by row operations" or method dispatching of R functions.

#That means that when approaching a problem that at first glance requires
#"by row operations", such as calculating the means of each row, one needs to ask themselves:
  
#What are the classes of the data sets I'm dealing with?
#Is there an existing compiled code that can achieve this
#without the need of repetitive evaluation of R functions?
#If not, can I do these operation by columns instead by row?
#Finally, is it worth spending a lot of time on developing 
#complicated vectorized code instead of just running a simple apply loop?
#In other words, is the data big/sophisticated enough that R can't handle
#it efficiently using a simple loop?
#Putting aside the memory pre-allocation issue and growing object in loops,
#we will focus in this example on how to possibly avoid apply loops, method dispatching or re-evaluating R functions within loops.

#A standard/easy way of calculating mean by row would be:
apply(mtcars, 1, mean)

  
rowMeans(mtcars)

#This involves no by row operations and therefore no repetitive 
#evaluation of R functions. However, we still converted a data.frame to a matrix.
#Though rowMeans has an error handling mechanism and it won't run
#on a data set that it can't handle, it's still has an efficiency cost.

rowMeans(iris)

#Error in rowMeans(iris) : 'x' must be numeric

#But still, can we do better? We could try instead of a matrix 
#conversion with error handling, a different method that will 
#allow us to use mtcars as a vector (because a data.frame is essentially a list and a list is a vector).

Reduce(`+`, mtcars)/ncol(mtcars)
 [1] 29.90727 29.98136 23.59818 38.73955 53.66455 35.04909 59.72000 24.63455 27.23364 31.86000 31.78727 46.43091 46.50000 46.35000 66.23273 66.05855
[17] 65.97227 19.44091 17.74227 18.81409 24.88864 47.24091 46.00773 58.75273 57.37955 18.92864 24.77909 24.88027 60.97182 34.50818 63.15545 26.26273

#Now for possible speed gain, we lost column names and error handling (including NA handling).

#Another example would be calculating mean by group, using base R we could try

aggregate(. ~ cyl, mtcars, mean)

#Still, we are basically evaluating an R function in a loop,
#but the loop is now hidden in an internal C function 
#(it matters little whether it is a C or an R loop).

#Could we avoid it? Well there is a compiled function in R called rowsum, 
#hence we could do:

rowsum(mtcars[-2], mtcars$cyl)/table(mtcars$cyl)

#Though we had to convert to a matrix first too.

#A this point we may question whether our current data structure 
#is the most appropriate one. 
#Is a data.frame is the best practice? Or should one just switch to a 
#matrix data structure in order to gain efficiency?

#By row operations will get more and more expensive (even in matrices) 
#as we start to evaluate expensive functions each time.
#Lets us consider a variance calculation by row example.

#Lets say we have a matrix m:

set.seed(100)
m <- matrix(sample(1e2), 10)
m
     
#One could simply do:

apply(m, 1, var)

#On the other hand, one could also completely vectorize this
#operation by following the formula of variance

RowVar <- function(x) {
  rowSums((x - rowMeans(x))^2)/(dim(x)[2] - 1)
}
RowVar(m)

