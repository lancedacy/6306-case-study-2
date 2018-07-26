#Set the working directory for my machine
setwd("/Users/lancedacy/Dropbox/Education/MSDS/6306/6306-case-study-2")

#Using this package to read a TSV file
library(ggplot2)
library(data.table)
library(usmap)
library(maps)

#Direct download from NOAA
url <- "https://www.ngdc.noaa.gov/nndc/struts/results?type_0=Exact&query_0=$ID&t=101650&s=13&d=189&dfn=signif.txt"
download.file(url, destfile = "./data/data.tsv", method="curl")

#Create a data frame from the data file
df <- as.data.frame(fread("./data/data.tsv"))
df_country <- na.omit(df[,c("I_D","YEAR","COUNTRY","TOTAL_DAMAGE_MILLIONS_DOLLARS")])
df_state <- na.omit(df[,c("I_D","YEAR","STATE","TOTAL_DAMAGE_MILLIONS_DOLLARS")])

df_country$TOTAL_DAMAGE_MILLIONS_DOLLARS <- as.numeric(df_country$TOTAL_DAMAGE_MILLIONS_DOLLARS)
df_country$YEAR <- as.numeric(df_country$YEAR)

df_state$TOTAL_DAMAGE_MILLIONS_DOLLARS <- as.numeric(df_state$TOTAL_DAMAGE_MILLIONS_DOLLARS)
df_state$YEAR <- as.numeric(df_state$YEAR)


View(df_country)
str(df_country)
summary(df_country)

View(df_state)
str(df_state)
summary(df_state)

#Validate and inspect the file, I think using EQ_PRIMARY is the best idicator of the 
#magnitude. 
str(df)
head(df)
summary(df)
dim(df)
colnames(df)

plot(y=df$EQ_PRIMARY, x=df$YEAR, main="Earthquake Magnitudes Over Time", 
      xlab="Year", ylab="Magnitude", col="Red")


plot(y=df$TOTAL_DAMAGE_MILLIONS_DOLLARS, x=df$YEAR, main="Earthquake Damage Over Time", 
     xlab="Year", ylab="Damage (in millions)", col="Green")

plot(y=df_country$TOTAL_DAMAGE_MILLIONS_DOLLARS, x=df_country$YEAR, main="Earthquake Damage by Region", 
     xlab="Year", ylab="Country", col="Blue")

# Get the data ready to plot
StateDB <- data.frame(state.name, state.abb, state.region)
colnames(StateDB)[colnames(StateDB)=='state.name'] <- 'StateName'
colnames(StateDB)[colnames(StateDB)=='state.abb'] <- 'State'
colnames(StateDB)[colnames(StateDB)=='state.region'] <- 'StateRegion'

#Add Washington DC
DistrictColumbia <- data.frame("District of Columbia","DC", "South")
names(DistrictColumbia) <- c("StateName","State", "StateRegion")
StateDB <- rbind(StateDB, DistrictColumbia)

#Hold total damages by state
DamagesCount <- data.frame(table(df_state$STATE))
DamagesCount2 <- data.frame(table(df_state$STATE))


#rename column names
colnames(DamagesCount)[colnames(DamagesCount)=='Var1'] <- 'State'
colnames(DamagesCount)[colnames(DamagesCount)=='Freq'] <- 'NumberOfDamagesByState'

#Merge the StateDB and sort by count of breweries by state
DamagesCount <- merge(DamagesCount, StateDB, by.x=("State"), by.y=("State"))
DamagesCount <- DamagesCount[order(DamagesCount$NumberOfDamagesByState, decreasing=TRUE),c(3,2)]
DamagesCount

#Merge DamagesCount to the statepop data set by state name
DamagesCountMap <- merge(statepop, DamagesCount, by.x=("full"), by.y=("StateName"))



#Plot states and color by damage total
usmap::plot_usmap(data = DamagesCountMap,
                  values = "NumberOfDamagesByState",
                  lines = "black") + scale_fill_continuous(
                    low = "green",
                    high = "red",
                    name = "Damages (in millions)",
                    label = scales::comma) + theme(legend.position = "right")+
  labs(title = "Total Damages by State")