#General Functions in R
#cbind(), rbind(),range(),sort(),order() 

#diff() function
#If you work on time series, you need to stationary the series by taking their lag values. 
#A stationary process allows constant mean, variance and autocorrelation over time. 
#This mainly improves the prediction of a time series.
#It can be easily done with the function diff(). 
#We can build a random time-series data with a trend and then use the function diff() to 
#stationary the series. 
#The diff() function accepts one argument, a vector, and return suitable 
#lagged and iterated difference.

#Note: We often need to create random data, but for learning and comparison we want 
#the numbers to be identical across machines. 
#To ensure we all generate the same data, we use the set.seed() function with 
#arbitrary values of 123. 
#The set.seed() function is generated through the process of pseudorandom number generator 
#that make every modern computers to have the same sequence of numbers. 
#If we don't use set.seed() function, we will all have different sequence of numbers.

set.seed(123)
## Create the data
x = rnorm(1000)
x
ts <- cumsum(x)
ts
## Stationary the serie
diff_ts <- diff(ts)
diff_ts
par(mfrow=c(1,2))
par
## Plot the series
?plot(ts, type='l')
plot(diff(ts), type='l')

#length() function
#In many cases, we want to know the length of a vector for computation or to be used 
#in a for loop. 
#The length() function counts the number of rows in vector x. 
#The following codes import the cars dataset and return the number of rows.

#Note: length() returns the number of elements in a vector. 
#If the function is passed into a matrix or a data frame, 
#the number of columns is returned.

dt <- cars
## number columns
length(dt)

## number rows
length(dt[,1])

#Math functions
#R has an array of mathematical functions.

#Operator	Description
#abs(x)	Takes the absolute value of x
#log(x,base=y)	Takes the logarithm of x with base y; if base is not specified, returns the natural logarithm
#exp(x)	Returns the exponential of x
#sqrt(x)	Returns the square root of x
#factorial(x)	Returns the factorial of x (x!)

# sequence of number from 44 to 55 both including incremented by 1
x_vector <- seq(45,55, by = 1)
x_vector 
#logarithm
log(x_vector)

#exponential
exp(x_vector)

#squared root
sqrt(x_vector)

#factorial
factorial(x_vector)

#Statistical functions
#R standard installation contains wide range of statistical functions. 
#we will briefly look at the most important function..

#Basic statistic functions

#Operator

mean(x)
#Mean of x

median(x)
#Median of x

var(x)
#Variance of x

sd(x)
#Standard deviation of x

?scale(x)
#Standard scores (z-scores) of x

?quantile(x)
#The quartiles of x

summary(x)
#Summary of x: mean, min, max etc..

View(dt)
speed <- dt$speed
speed


# Mean speed of cars dataset
mean(speed)

# Median speed of cars dataset
median(speed)

# Variance speed of cars dataset
var(speed)

# Standard deviation speed of cars dataset
sd(speed)

# Standardize vector speed of cars dataset		
head(scale(speed), 10)

# Quantile speed of cars dataset
quantile(speed)

# Summary speed of cars dataset
summary(speed)

