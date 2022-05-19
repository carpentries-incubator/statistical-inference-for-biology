# code for Populations, Samples and Estimates episode

library(tidyverse)

## read "population" and split it into control and treatment
pheno <- read.csv("../data/mice_pheno.csv") #Previously downloaded 

controlPopulation <- filter(pheno, Sex == "F" & Diet == "chow") %>%
  select(Bodyweight) %>% unlist
length(controlPopulation)

hfPopulation <- filter(pheno, Sex == "F" & Diet == "hf") %>%  
  select(Bodyweight) %>% unlist
length(hfPopulation)

# X is the control population
sum(controlPopulation) # sum of the xsubi's

length(controlPopulation) # this equals m

sum(controlPopulation)/length(controlPopulation) # this equals mu sub x

# Y is the high fat diet population
sum(hfPopulation) # sum of the ysubi's

sum(hfPopulation)/length(hfPopulation) # this equals mu sub y

# Exercise
# We will use the mouse phenotype data. Remove the observations that contain 
# missing values:
  
pheno <- na.omit(pheno)

# Use dplyr to create a vector x with the body weight of all males on the 
# control (chow) diet. What is this population’s average body weight?










