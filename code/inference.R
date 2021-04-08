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

# create a histogram to visualize the distribution of fathers' heights
hist(x , xlab = "Height (in inches", main = "Fathers' heights")

# Probability Distribution

# create a histogram of the 10,000 null values created earlier
hist(null, freq = TRUE)
# now add a vertical line indicating where the observed difference between 
# high-fat and control mice lies
abline(v=obsdiff, col="red", lwd=2)
print(obsdiff) # what was the observed difference?

# Normal Distribution

# Use the normal approximation (pnorm) to compute the proportion of values below
# the observed difference between high-fat and control mice.
1 - pnorm(obsdiff, mean = mean(null), sd = sd(null))
# this represents everything to the right of the red vertical line on the 
# histogram above

# what is everything to the left of the red line (e.g. what proportion are below
# the observed difference)?
pnorm(obsdiff, mean = mean(null), sd = sd(null))

# Setting the random seed
set.seed(1) # set the random number generator seed to 1 so that results come up 
# the same each time

LETTERS # R has a built-in vector of letters
sample(LETTERS, 5) # take a sample of 5 letters after setting the seed
sample(LETTERS, 5) # should be different from previous
sample(LETTERS, 5) # different again

set.seed(1) # set the random number generator seed
sample(LETTERS, 5) 
set.seed(1) # set the seed again
sample(LETTERS, 5) # you should get exactly the same letters
set.seed(1) # set the seed again
sample(LETTERS, 5) # you should get exactly the same letters

# back to the "population" data
str(population)
head(population)
summary(population)

# use the population data for Exercise 1
# Exercise 1
# avg of weights?
mean(population$Bodyweight)
set.seed(1)
sample1 <- sample(population$Bodyweight, 5)
abs(mean(sample1) - mean(population$Bodyweight))
set.seed(5)
sample2 <- sample(population$Bodyweight, 5)
abs(mean(sample2) - mean(population$Bodyweight))

