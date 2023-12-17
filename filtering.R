allpackages <- function() {
  if(!require(pacman)){install.packages("pacman")}
  pacman::p_load(foreach, ggplot2, plyr, psych, likert,ggsignif,hrbrthemes, outliers, coin, rstatix)
  library(dplyr)
  library(foreach)
  library(ggplot2)
  library(likert)
  library(psych)
  library(stringr)
  library(ggsignif)
  library(scales)
  library(hrbrthemes)
  library(viridis)
  library(tidyr)
  library(outliers)
  library(coin)
  library(rstatix)
  
  
  
  
  update.packages(ask = TRUE, repos = 'http://cran.rstudio.org')
  return()
}

allpackages() #install all packages for work
install.packages("summarytools")
library(summarytools)

install.packages("stringr")
library("stringr")


setwd("/Users/dinatal/Documents/Study/TU/Visual Data Science/Datasets")    
df_gen = read.csv('movies_general.csv')
df_bechdel = read.csv('Bechdel_detailed.csv')
df_oscar = read.csv('oscar.csv')
head(df_bechdel)
head(df_gen)
head(df_oscar)

#dfSummary(df_bechdel)
df_bechdel$title <- str_replace(df_bechdel$title, "&#39;","'")
df_bechdel$title <- str_replace(df_bechdel$title, "&amp;","and")
df_bechdel$title <- ifelse(grepl(", The$", df_bechdel$title), 
                         sub(", The$", "", paste("The", df_bechdel$title)), 
                         df_bechdel$title)
df_bechdel <- df_bechdel[!grepl("&", df_bechdel$title), ]
df_bechdel <- df_bechdel %>% filter(year > 1979 & year < 2022) 
df_bechdel <- df_bechdel %>% filter(dubious == 0) 
df_bechdel = df_bechdel %>% dplyr::rename(bechdel = rating)

df_bechdel <- df_bechdel %>% select(title, year, bechdel, imdbid)

dfSummary(df_oscar)
df_oscar <- df_oscar %>% filter(year > 1979 & year < 2022) 
df_oscar <- df_oscar %>% dplyr::rename(title = film, oscar_cat = category, oscar_name = name, oscar_status = status, oscar_gender = gender)
df_oscar <- df_oscar %>% filter(oscar_cat == "BEST PICTURE")
df_oscar <- df_oscar %>% select(year, title, oscar_status)
df_oscar <- unique(df_oscar)

dfSummary(df_gen)
df_gen <- df_gen %>% select(name, genre, year, score,votes, director, star, country,budget, gross, runtime)
df_gen <- df_gen %>% dplyr::rename(title = name, imdb_score = score, imdb_votes = votes)

#joined_first <- left_join(df_bechdel, df_oscar, by = join_by(title == title & year == year))
joined_first <- merge(df_bechdel, df_oscar,  by = c("title", "year"), all = TRUE)
joined <- merge(df_gen, joined_first,  by = c("title", "year"), all.x = TRUE)
dfSummary(joined)

write.csv(joined, "joined_dataset.csv")



