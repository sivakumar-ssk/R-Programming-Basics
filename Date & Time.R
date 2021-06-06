#Create and format dates
#To create a Date object from a simple character string in R, 
#you can use the as.Date() function. The character string has to obey 
#a format that can be defined using a set of symbols 
#(the examples correspond to 13 January, 1982):
  
%Y: 4-digit year (1982)
%y: 2-digit year (82)
%m: 2-digit month (01)
%d: 2-digit day of the month (13)
%A: weekday (Wednesday)
%a: abbreviated weekday (Wed)
%B: month (January)
%b: abbreviated month (Jan)
The following R commands will all create the same Date object for the 13th day in January of 1982:
  
as.Date("1982-01-13")
as.Date("Jan-13-82", format = "%b-%d-%y")
as.Date("13 January, 1982", format = "%d %B, %Y")

#Notice that the first line here did not need a format argument, 
#because by default R matches your character string to the formats "%Y-%m-%d" or "%Y/%m/%d".

#In addition to creating dates, you can also convert dates to character strings 
#that use a different date notation. 
#For this, you use the format() function. 
  
today <- Sys.Date()
format(Sys.Date(), format = "%d %B, %Y")
format(Sys.Date(), format = "Today is a %A!")

#In the editor on the right, three character strings representing dates have been created. 
#Convert them to dates using as.Date(), and assign them to date1, date2, and date3 respectively.
#The code for date1 is already included.
#Extract useful information from the dates as character strings using format(). 
#From the first date, select the weekday. 
#From the second date, select the day of the month. 
#From the third date, you should select the abbreviated month and the 4-digit year, separated by a space.

# Definition of character strings representing dates
str1 <- "May 23, '96"
str2 <- "2012-03-15"
str3 <- "30/January/2006"

# Convert the strings to dates: date1, date2, date3
date1 <- as.Date(str1, format = "%b %d, '%y")

# Convert dates to formatted strings
format(date1, "%A")

#Create and format times
#Similar to working with dates, you can use as.POSIXct() to convert from a 
#character string to a POSIXct object, 
#and format() to convert from a POSIXct object to a character string. 
#Again, you have a wide variety of symbols:
  
%H: hours as a decimal number (00-23)
%I: hours as a decimal number (01-12)
%M: minutes as a decimal number
%S: seconds as a decimal number
%T: shorthand notation for the typical format %H:%M:%S
%p: AM/PM indicator

#For a full list of conversion symbols, consult the strptime documentation in the console:
  
?strptime
#Again,as.POSIXct() uses a default format to match character strings. 
#In this case, it's %Y-%m-%d %H:%M:%S. In this exercise, abstraction is made of different time zones.

#Convert two strings that represent timestamps, str1 and str2, to POSIXct objects called time1 and time2.
#Using format(), create a string from time1 containing only the minutes.
#From time2, extract the hours and minutes as "hours:minutes AM/PM".

# Definition of character strings representing times
str1 <- "May 23, '96 hours:23 minutes:01 seconds:45"
str2 <- "2012-3-12 14:23:08"

# Convert the strings to POSIXct objects: time1, time2
time1 <- as.POSIXct(str1, format = "%B %d, '%y hours:%H minutes:%M seconds:%S")


# Convert times to formatted strings

#Calculations with Dates
#Both Date and POSIXct R objects are represented by simple numerical values under the hood. This makes calculation with time and date objects very straightforward: R performs the calculations using the underlying numerical values, and then converts the result back to human-readable time information again.

#You can increment and decrement Date objects, or do actual calculations with them (try it out in the console!):
  
today <- Sys.Date()
today + 1
today - 1

#as.Date("2015-03-12") - as.Date("2015-02-27")
#To control your eating habits, you decided to write down the dates of the last five days that you ate pizza. 
#In the workspace, these dates are defined as five Date objects, day1 to day5. 

#Calculate the number of days that passed between the last and the first day you ate pizza. 
#Use the function diff() on pizza to calculate the differences between consecutive pizza days. 
#Store the result in a new variable day_diff.
#Calculate the average period between two consecutive pizza days.

# day1, day2, day3, day4 and day5 are already available in the workspace

# Difference between last and first pizza day


# Create vector pizza
pizza <- c(day1, day2, day3, day4, day5)

# Create differences between consecutive pizza days: day_diff


# Average period between two consecutive pizza days

#Calculations with Times
#Calculations using POSIXct objects are completely analogous to those using Date objects. 
#Try to experiment with this code to increase or decrease POSIXct objects:
  
now <- Sys.time()
now + 3600          # add an hour
now - 3600 * 24     # subtract a day
Adding or subtracting time objects is also straightforward:
  
birth <- as.POSIXct("1879-03-14 14:37:23")
death <- as.POSIXct("1955-04-18 03:47:12")
einstein <- death - birth
einstein
#You're developing a website that requires users to log in and out. 
#You want to know what is the total and average amount of time a particular user spends on your website. 
#This user has logged in 5 times and logged out 5 times as well. 
#These times are gathered in the vectors login and logout, which are already defined in the workspace.


#Calculate the difference between the two vectors logout and login, i.e. 
#the time the user was online in each independent session. 
#Store the result in a variable time_online.
#Inspect the variable time_online by printing it.
#Calculate the total time that the user was online. Print the result.
#Calculate the average time the user was online. Print the result.

#Hint
#For the first instruction, simply type logout - login.
#For the third and fourth instruction, you can use sum() and mean() out of the box.

#Time is of the essence
#The dates when a season begins and ends can vary depending on who you ask. People in Australia will tell you that spring starts on September 1st. The Irish people in the Northern hemisphere will swear that spring starts on February 1st, with the celebration of St. Brigid's Day. Then there's also the difference between astronomical and meteorological seasons: while astronomers are used to equinoxes and solstices, meteorologists divide the year into 4 fixed seasons that are each three months long. (source: www.timeanddate.com)

#A vector astro, which contains character strings representing the dates on which the 4 astronomical seasons start, has been defined on your workspace. Similarly, a vector meteo has already been created for you, with the meteorological beginnings of a season.

#Use as.Date() to convert the astro vector to a vector containing Date objects. 
#You will need the %d, %b and %Y symbols to specify the format. 
#Store the resulting vector as astro_dates.

#Use as.Date() to convert the meteo vector to a vector with Date objects. 
#This time, you will need the %B, %d and %y symbols for the format argument. 
#Store the resulting vector as meteo_dates.

#With a combination of max(), abs() and -, calculate the maximum absolute difference 
#between the astronomical and the meteorological beginnings of a season, i.e. 
#astro_dates and meteo_dates. Simply print this maximum difference to the console output.

#Hint
#To convert astro to a vector of Date objects, you'll need the following format: "%d-%b-%Y".
#To convert meteo to a vector of Date objects, you'll want to use "%B %d, %y" in the format argument.
#For the final instruction, use max(abs(x - y)), where you set x and y appropriately

