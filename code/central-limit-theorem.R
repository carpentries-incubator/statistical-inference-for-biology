# Script for Central Limit Theorem section
# 2021-04-15
# Lesson website: https://smcclatchy.github.io/statistical-inference-for-biology/

library(tidyverse)

# only 5% of the values in the standard normal distribution
# are larger than 2 in absolute value
pnorm(-2) + (1 - pnorm(2))

# Exercise 1
# 1. one standard deviation away from average
pnorm(-1) # proportion -1 sd or more away from avg
pnorm(1) # proportion +1 sd or less (to -infinity) from avg
pnorm(1) - pnorm(-1) # proportion within 1 sd from avg
# 2. within two standard deviations away from average
pnorm(2) - pnorm(-2)

# Exercise 1
# Set the seed to 1, then use replicate to perform the simulation, and report 
# what proportion of times z was larger than 2 in absolute value (CLT says it 
# should be about 0.05).

n <- 10000
p <- 1/6
x <- sample(1:6, n, replace = TRUE)
mean(x==6)
set.seed(1)
results <- replicate(10000, mean(x==6)-p)/sqrt(p*(1-p)/n)

