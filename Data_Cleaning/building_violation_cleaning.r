df_housing <- read_csv('Housing_Maintenance_Code_Violations.csv')
zip <- read_csv("Neighbor_by_zipcode.csv")

df_housing$ApprovedDate <- as.character(df_housing$ApprovedDate)
df_housing$BuildingID <- as.character(df_housing$BuildingID)


#Drop rows with NA value in Postcode
df_housing <- df_housing[!is.na(df_housing$Postcode),]
#Delete rows with wrong postcode (ex:4or 6digit postcode)
df_housing <- df_housing[!(df_housing$Postcode < 10000 |df_housing$Postcode >99999),]

#Give numerical score to violation by seriousness (removed I since it is informative warning)
df_housing$Grade = 0
df_housing[df_housing$Class == 'A',]$Grade <- 1 
df_housing[df_housing$Class == 'B',]$Grade <- 2
df_housing[df_housing$Class == 'C',]$Grade <- 3

#Add neighborhood column by the Zipcode
df_housing$neighborhood <- zip$Neighborhood[match(unlist(df_housing$Postcode), zip$ZipCode)]
#Convert the Zipcode to neighborhood
#Drop NA values in neighborhood (we are only looking for the neighbor hood provided by the NY state health department: https://www.health.ny.gov/statistics/cancer/registry/appendix/neighborhoods.htm)
df_housing <- df_housing[!is.na(df_housing$neighborhood),]
df_housing2 <- df_housing
df_housing <- df_housing %>% filter(str_detect(ViolationStatus, "Open"))
df_housing <- df_housing %>% select(-starts_with("NOV"), -starts_with("Original"), -starts_with("New"))

write.table(df_housing, file = "Housing_violation_cleaned.csv",
            sep = "\t", row.names = F)