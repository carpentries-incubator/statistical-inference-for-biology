# Script for Inference section
# 2021-04-08
# Lesson website: https://smcclatchy.github.io/statistical-inference-for-biology/
# See Setup instructions for project directory organization and data download
# This section of the lesson: 
# https://smcclatchy.github.io/statistical-inference-for-biology/02-inference-rv-dists/index.html

library(tidyverse)
library(UsingR)

fWeights <- read.csv("../data/femaleMiceWeights.csv")
head(fWeights) # to view the first 6 rows
View(fWeights) # to view the entire data set

# Are high-fat diet fed mice heavier than controls?
control <- filter(fWeights, Diet=="chow") %>% 
  select(Bodyweight) %>% 
  unlist
treatment <- filter(fWeights, Diet=="hf") %>% 
  select(Bodyweight) %>% 
  unlist
print(mean(treatment))
print(mean(control))

# What is the difference in mean body weight between high-fat and control?
obsdiff <- mean(treatment) - mean(control)
print(obsdiff)

# Random Variables

# Pretend that you have access to all female control mice and call it the
# population. Then repeatedly take samples of 12 mice from this population.
population <- read.csv(file = "../data/femaleControlsPopulation.csv")
control <- sample(population$Bodyweight, 12)
mean(control)
# Repeat the previous commands two more times and watch how the mean changes.
control <- sample(population$Bodyweight, 12)
mean(control)
control <- sample(population$Bodyweight, 12)
mean(control)

# The Null Hypothesis

# Continue sampling from the "population", but this time pretend that one
# of the samples of 12 is a treatment group.
control <- sample(population$Bodyweight, 12)
treatment <- sample(population$Bodyweight, 12)
print(mean(treatment) - mean(control))

# Now repeat the above 10,000 times with a for loop (the replicate function is 
# better at this, and we'll get to that later)
n <- 10000 # number of iterations through the loop
null <- vector("numeric", n) # empty vector of length n to hold the results 
for (i in 1:n) {
  control <- sample(population$Bodyweight, 12)
  treatment <- sample(population$Bodyweight, 12)
  null[i] <- mean(treatment) - mean(control)
}

# What percent of the 10,000 are greater than the observed difference?
mean(null >= obsdiff)

# Distributions
data(father.son, package = "UsingR") # load data on fathers' and sons' heights
View(father.son)
x <- father.son$fheight # fathers' heights

# take a random sample of 10 fathers' heights and round them to 1 decimal place
round(sample(x, 10), 1)

