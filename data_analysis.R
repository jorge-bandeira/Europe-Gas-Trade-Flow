library(tidyverse)
library(networkD3)

#import clean data
gas_data <- read_csv("gas_exports_data_cleaned.csv")

#function to get top exporters for a given year
getTrade <- function(f_year) {
    gas_data %>%
    select(exit, entry, gtf_mcm, year) %>% 
    filter(year == f_year, entry != "Liquefied Natural Gas", exit != "Liquefied Natural Gas") %>% 
    group_by(exit, entry) %>% 
    summarise(export = sum(gtf_mcm)) %>% 
    arrange(desc(export)) %>% 
    filter(export > 0)
}

top_exp_2021 <- getTrade(2021)
top_exp_2022 <- getTrade(2022)

#create nodes df for networkD3
nodes_2021 <- data.frame(name=c(as.character(top_exp_2021$exit), as.character(top_exp_2021$entry)) %>% unique())
nodes_2022 <- data.frame(name=c(as.character(top_exp_2022$exit), as.character(top_exp_2022$entry)) %>% unique())

#set ids for networkD3
top_exp_2021$exitId = match(top_exp_2021$exit, nodes_2021$name) - 1
top_exp_2021$entryId = match(top_exp_2021$entry, nodes_2021$name) - 1
top_exp_2022$exitId = match(top_exp_2022$exit, nodes_2022$name) - 1
top_exp_2022$entryId = match(top_exp_2022$entry, nodes_2022$name) - 1

#create chat with overview of natural gas trade
gas_trade_chart_2021 <- sankeyNetwork(Links = top_exp_2021, Nodes = nodes_2021, Source = "exitId", Target = "entryId", 
                                 Value = "export", NodeID = "name")

gas_trade_chart_2022 <- sankeyNetwork(Links = top_exp_2022, Nodes = nodes_2022, Source = "exitId", Target = "entryId", 
                                      Value = "export", NodeID = "name") 