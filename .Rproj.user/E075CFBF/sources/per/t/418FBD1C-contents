#Set the working directory for my machine
setwd("/Users/lancedacy/Dropbox/Education/MSDS/6306/6306-case-study-2")

#Using this package to read a TSV file
install.packages("data.table")
library(data.table)

#Direct download from NOAA
url <- "https://www.ngdc.noaa.gov/nndc/struts/results?type_0=Exact&query_0=$ID&t=101650&s=13&d=189&dfn=signif.txt"
download.file(url, destfile = "./data/data.tsv", method="curl")

#Create a data frame from the data file
df <- as.data.frame(fread("./data/data.tsv"))

#Validate and inspect the file, I think using EQ_PRIMARY is the best idicator of the 
#magnitude. 
str(df)
head(df)
summary(df)
dim(df)
colnames(df)

plot(y=df$EQ_PRIMARY, x=df$YEAR, main="Earthquake Magnitudes Over Time", 
      xlab="Observations", ylab="Magnitude", col="Red")

