# Data Transformation and cleaning for NYC Restaurant dataset

library(dplyr)
library(forwards)
library(ggplot2)
library(forcats)
library(readr)
library(tidyverse)
library("scales")
df_rest<- readr::read_csv("DOHMH_New_York_City_Restaurant_Inspection_Results.csv")

# initial inspection of data
dim(df_rest) # initial dimension of dataset
colSums(is.na(subset(df_rest, select = c("SCORE","GRADE")))) # counts of missing values
colSums(is.na(subset(df_rest, select = c("SCORE","GRADE")))) / dim(df_rest)[1]*100 # prop of missing values

#Data Cleaning part: 
df_rest_2 <- df_rest
colnames(df_rest_2)[18] = "INSPECTION_TYPE"
df_rest_2 <- filter(df_rest_2, INSPECTION_TYPE == "Cycle Inspection / Initial Inspection" | 
                      INSPECTION_TYPE == "Pre-permit (Operational) / Initial Inspection")

colSums(is.na(subset(df_rest_2, select = c("SCORE","GRADE")))) # counts of missing values
colSums(is.na(subset(df_rest_2, select = c("SCORE","GRADE"))))/ dim(df_rest_2)[1]*100 # prop of missing values

columns_intersted = c("CAMIS","ZIPCODE", "BORO", "INSPECTION DATE", "INSPECTION_TYPE", "SCORE")
df_rest_2<- subset(df_rest_2, select = columns_intersted) # Restaurant Data Frame
df_rest_2$`INSPECTION DATE` <- as.Date(df_rest_2$`INSPECTION DATE`,format = "%m/%d/%Y") # convert to Date class
colnames(df_rest_2)[4] <- "INSPECTION_DATE" # make column name without space

df_rest_2<-subset(df_rest_2, !is.na(SCORE)) # Remove NA values from SCORE column
#dim(df_rest)

colSums(is.na(df_rest_2)) # to check whether there still exists NA values
df_rest_2<-subset(df_rest_2, !is.na(ZIPCODE)) # Remove NA values from ZIPCODE column

colSums(is.na(df_rest_2)) # to check whether there still exists NA values

#Add neighborhood based on zipcode
zip <- read.csv("Neighbor_by_zipcode.csv")
df_rest_2$neighborhood <- zip$Neighborhood[match(unlist(df_rest_2$ZIPCODE), zip$ZipCode)]

# Remove NA values from column neighborhood because some building 
# has a particular zipcode that is not mapped to zipcode
df_rest_2<- filter(df_rest_2, !is.na(neighborhood)) 

# save the cleaned Restaurant data frame
write.table(df_rest_2, file = "rest_inspection_cleaned.csv",
            sep = "\t", row.names = F)
