library(dplyr)
library(ggplot2)
library(tidyr)

#Viewing the data
head(mpg)
str(mpg)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))
#This chart presents the individual data points well in the scatterplot.

#Aggregating the data
#From the scatterplot it looks like there may be some differences 
#by class of car. 
#I want to see what the difference is between the classes as 
#a whole by looking at their mean and median mileage data.
#I also want to compare the city as well as the highway mileage data. 
#To do this I will use the dplyr package to aggregate the data by class.

mpg_aggbyclass <- mpg %>%  ## Create a new data frame called mpg_aggbyclass, using mpg data
  group_by(class) %>%  ## group this data by the "class" variable
  summarise_at(vars(hwy,cty), list(avg = ~mean(., na.rm=TRUE), med = ~median(., na.rm=TRUE)))
## summarise the variables hwy and cty at this class level.
#Calculate the mean and label it "avg"; 
#calculate the median and label it "med".  
#Remove any null values with the na.rm=TRUE

#Looking at this new data frame, 
#I now have an average and median value for the city and highway 
#mileage by class of vehicle.

mpg_aggbyclass

# Changing the shape of the data
# Now that I have these data, I want to see how the different average
#mileage conditions (city and highway) compare across and within each 
#class of car on a chart. The new data frame is in a wide format,
#and not well suited to the way I want to plot it. 
#I need to transform this data into a more narrow format
#using the gather function of tidyr.

summary_by_class <- mpg_aggbyclass %>% gather(Condition, Mileage, hwy_avg:cty_med)
summary_by_class

# Plot the new average and median data
# Now that I have prepared the data I can use ggplot to 
#create a gathered bar chart, and see the mean and median 
#mileage for each car type and each driving condition next to 
#each other, again using ggplot

ggplot(data = summary_by_class) + 
  geom_bar(mapping = aes(fill = Condition, x = class, y = Mileage), stat = "identity", position = "dodge")
 #_____________________________________x________________________________________________#


# NOT RUN {
## Compute the averages for the variables in 'state.x77', grouped
## according to the region (Northeast, South, North Central, West) that
## each state belongs to.
aggregate(state.x77, list(Region = state.region), mean)

## Compute the averages according to region and the occurrence of more
## than 130 days of frost.
aggregate(state.x77,
          list(Region = state.region,
               Cold = state.x77[,"Frost"] > 130),
          mean)
## (Note that no state in 'South' is THAT cold.)


## example with character variables and NAs
testDF <- data.frame(v1 = c(1,3,5,7,8,3,5,NA,4,5,7,9),
                     v2 = c(11,33,55,77,88,33,55,NA,44,55,77,99) )
by1 <- c("red", "blue", 1, 2, NA, "big", 1, 2, "red", 1, NA, 12)
by2 <- c("wet", "dry", 99, 95, NA, "damp", 95, 99, "red", 99, NA, NA)
aggregate(x = testDF, by = list(by1, by2), FUN = "mean")

# and if you want to treat NAs as a group
fby1 <- factor(by1, exclude = "")
fby2 <- factor(by2, exclude = "")
aggregate(x = testDF, by = list(fby1, fby2), FUN = "mean")


## Formulas, one ~ one, one ~ many, many ~ one, and many ~ many:
aggregate(weight ~ feed, data = chickwts, mean)
aggregate(breaks ~ wool + tension, data = warpbreaks, mean)
aggregate(cbind(Ozone, Temp) ~ Month, data = airquality, mean)
aggregate(cbind(ncases, ncontrols) ~ alcgp + tobgp, data = esoph, sum)

## Dot notation:
aggregate(. ~ Species, data = iris, mean)
aggregate(len ~ ., data = ToothGrowth, mean)

## Often followed by xtabs():
ag <- aggregate(len ~ ., data = ToothGrowth, mean)
xtabs(len ~ ., data = ag)


## Compute the average annual approval ratings for American presidents.
aggregate(presidents, nfrequency = 1, FUN = mean)
## Give the summer less weight.
aggregate(presidents, nfrequency = 1,
          FUN = weighted.mean, w = c(1, 1, 0.5, 1))
# }