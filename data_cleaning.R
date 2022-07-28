library(tidyverse)
library(readxl)
library(data.table)
library(lubridate)
library(zoo)

# read raw xls file
raw_df <- read_excel("Export_GTF_IEA_202205_edited.xls")

#unpivot months
unp_df <- melt(setDT(raw_df), id.vars = c("Borderpoint", "Exit", "Entry"), variable.name = "Month")

#clean col names
colnames(unp_df)[5] <- "gtf_Mcm"

#convert month column to mm-yyyy
unp_df <- unp_df %>%
  transform(Month = as.numeric(as.character(Month))) %>% 
  mutate(Month = as_date(Month, origin = date("1900/01/01"))) %>% 
  mutate(Month = as.yearmon(Month))

#change NA values to 0 and make gtf column numeric
