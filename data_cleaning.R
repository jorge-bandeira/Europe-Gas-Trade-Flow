library(tidyverse)
library(readxl)
library(data.table)
library(lubridate)

# read raw xls file
raw_df <- read_excel("Export_GTF_IEA_202205_edited.xls")

#unpivot months
unp_df <- melt(setDT(raw_df), id.vars = c("Borderpoint", "Exit", "Entry"), variable.name = "Month")

#clean col names
colnames(unp_df)[5] <- "gtf_Mcm"

#create year and month columns
unp_df <- unp_df %>%
  transform(Month = as.numeric(as.character(Month))) %>% 
  mutate(date = as_date(Month, origin = date("1900/01/01"))) %>% 
  mutate(month = month(date)) %>% 
  mutate(year = year(date)) %>% 
  select(-c(Month, date))

#change NA values to 0, make gtf column numeric
unp_df$gtf_Mcm[unp_df$gtf_Mcm == "N/A"] <- 0
unp_df <- unp_df %>% 
  mutate(gtf_Mcm = as.numeric(gtf_Mcm))

#change colnames to lowercase
names(unp_df) <- tolower(names(unp_df))

#export to csv
write_csv(unp_df, "gas_exports_data_cleaned.csv")