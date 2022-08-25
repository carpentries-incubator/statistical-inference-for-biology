library(tidyverse)
library(UsingR)

fWeights <- read.csv("../data/femaleMiceWeights.csv")
head(fWeights)
View(fWeights)

control <- filter(fWeights, Diet=="chow") %>% 
  dplyr::select(Bodyweight) %>% 
  unlist

treatment <- filter(fWeights, Diet=="hf") %>% 
  dplyr::select(Bodyweight) %>%
  unlist
  
print(mean(treatment))
print(mean(control))
obsdiff <- mean(treatment) - mean(control)

population <- read.csv("../data/femaleControlsPopulation.csv")
control <- sample(population$Bodyweight, 12)
mean(control)
control <- sample(population$Bodyweight, 12)
mean(control)
control <- sample(population$Bodyweight, 12)
mean(control)

control <- sample(population$Bodyweight, 12)
treatment <- sample(population$Bodyweight, 12)
print(mean(treatment) - mean(control))

n <- 10000
null <- vector("numeric", n)
for (i in 1:n) {
  control <- sample(population$Bodyweight, 12)
  treatment <- sample(population$Bodyweight, 12)
  null[i] <- mean(treatment) - mean(control)
}
head(null)

mean(null >= obsdiff)

data(father.son, package = "UsingR")
x <- father.son$fheight
head(x)
round(sample(x, 10), 1)

hist(null, freq=TRUE)
abline(v=obsdiff, col="red", lwd=2)
1 - pnorm(obsdiff, mean(null), sd(null))
pnorm(obsdiff, mean(null), sd(null))

set.seed(1)
LETTERS
sample(LETTERS, 5)
sample(LETTERS, 5)
sample(LETTERS, 5)
set.seed(1)
sample(LETTERS, 5)
set.seed(1)
sample(LETTERS, 5)
set.seed(1)
sample(LETTERS, 5)

str(population)
head(population)
summary(population)

# Exercise 1
# avg of weights?
mean(population$Bodyweight)
set.seed(1)
sample1 <- sample(population$Bodyweight, 5)
abs(mean(sample1) - mean(population$Bodyweight))
set.seed(5)
sample2 <- sample(population$Bodyweight, 5)
abs(mean(sample2) - mean(population$Bodyweight))

# Exercise 1
# avg of weights?
