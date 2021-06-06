# Data Preparation in R

#csv = comma separated value

View(iris)

head(iris)

#Getting the dimensions of your data frame
dim(iris)

colnames(iris)

is.na(iris)

df= data.frame(c(1,2,3,4),c(44,55,NA,NA))
df
is.na(df)

any(is.na(df))

any(is.na(iris))

sum(is.na(df))

sum(is.na(iris))
  














