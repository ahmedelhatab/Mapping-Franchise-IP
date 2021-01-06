setwd("./input")
Sys.setlocale("LC_ALL","Arabic")
rm(list=ls())
library(tidyverse)
library(xlsx)
library(lubridate)
files <- list.files(path=".")
#Create Empty data frame 
data_frame=data.frame(Company=as.character(),OU_Name=as.character(),OU_code=as.character(),IP=as.character())

#loop through the files 
for (input_file in files)
{
  
  data <- read.csv(file=input_file)
  data <- cbind(input_file,data)
  number_of_columns <- ncol(data)
  names(data) <- c("input_file","Parent","OU_Code","OU_Name",1:(number_of_columns-4))
  data <- data %>% replace(.=="", NA)
  for (c in 5:number_of_columns)
  {
    temp_df1 <- data %>% select(input_file,Parent,OU_Name,OU_Code,c)
    names(temp_df1) <- c("input_file","Company","OU_Name","OU_code","IP")
    data_frame=rbind(data_frame,temp_df1)
  }
}
data_frame <- data_frame %>% filter(is.na(IP)==FALSE)
current_date <- now()
current_date <- paste0(year(current_date),"-",month(current_date),"-",day(current_date),"-",hour(current_date),"-",minute(current_date))
file_name <- paste0("../","FRAUD_Makers_IP",current_date,".xlsx")
write.xlsx(file=file_name,sheetName = "IPs",x=data_frame)
  