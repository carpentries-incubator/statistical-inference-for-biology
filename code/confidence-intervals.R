# prepare session
# path to scripts folder is relative to project folder
# setwd("./scripts")
library(tidyverse)
library(rafalib)
set.seed(1)

# read in the dataset for the "real" population
pheno <- read.csv("../data/mice_pheno.csv")
# extract bodyweight for female on chow diet
chowPopulation <- pheno %>% 
  filter(Sex=="F" & Diet=="chow") %>% 
  select(Bodyweight) %>% 
  unlist

mu_chow <- mean(chowPopulation)
mu_chow

# generate a sample out of the "population"
N <- 30
chow <- sample(chowPopulation, N)
print(mean(chow))

# calculation of SE following CLT
se <- sd(chow)/sqrt(N)
print(se)

# 95% of the distribution falls within 2 sd below and above the mean
pnorm(2) - pnorm(-2)

# calculation of CI following CLT
c(mean(chow) - 2 * se, mean(chow) + 2 * se )

# more accurately with qnorm function
Q <- qnorm(1 - 0.05/2)
interval <- c(mean(chow) - Q * se, mean(chow) + Q * se )
interval
interval[1] < mu_chow & interval[2] > mu_chow

ci.lo <- mean(chow) - Q * se
ci.hi <- mean(chow) + Q * se
ci.lo < mu_chow
ci.hi > mu_chow

# with large sample size, about 95% of iterations (resampling) will cover the 
# true mean
Q <- qnorm(1 - 0.05/2)
B <- 250
N <- 30

plot(mean(chowPopulation) + c(-7,7), c(1,1), type="n",
     xlab="weight", ylab="interval", ylim=c(1,B))
abline(v=mean(chowPopulation))
for (i in 1:B) {
  chow <- sample(chowPopulation,N)
  se <- sd(chow)/sqrt(N)
  interval <- c(mean(chow) - Q * se, mean(chow) + Q * se)
  covered <- 
    mean(chowPopulation) <= interval[2] & mean(chowPopulation) >= interval[1]
  color <- ifelse(covered,1,2)
  lines(interval, c(i,i),col=color)
}

### With smaller sample size, fewer iterations cover the true mean
Q <- qnorm(1 - 0.05/2)
B <- 250
N <- 5

plot(mean(chowPopulation) + c(-7,7), c(1,1), type="n",
     xlab="weight", ylab="interval", ylim=c(1,B))
abline(v=mean(chowPopulation))
for (i in 1:B) {
  chow <- sample(chowPopulation,N)
  se <- sd(chow)/sqrt(N)
  interval <- c(mean(chow) - Q * se, mean(chow) + Q * se)
  covered <- 
    mean(chowPopulation) <= interval[2] & mean(chowPopulation) >= interval[1]
  color <- ifelse(covered,1,2)
  lines(interval, c(i,i),col=color)
}

### using T instead of Normal distribution accounts for small sample size
Q <- qt(1 - 0.05/2, df=4)
B <- 250
N <- 5

plot(mean(chowPopulation) + c(-7,7), c(1,1), type="n",
     xlab="weight", ylab="interval", ylim=c(1,B))
abline(v=mean(chowPopulation))
for (i in 1:B) {
  chow <- sample(chowPopulation,N)
  se <- sd(chow)/sqrt(N)
  interval <- c(mean(chow) - Q * se, mean(chow) + Q * se)
  covered <- 
    mean(chowPopulation) <= interval[2] & mean(chowPopulation) >= interval[1]
  color <- ifelse(covered,1,2)
  lines(interval, c(i,i),col=color)
}

### Connection Between Confidence Intervals and p-values
# we specify the control and treatment vectors
control <- pheno %>% 
  filter(Sex=="F" & Diet=="chow") %>% 
  select(Bodyweight) %>% 
  unlist

treatment <- pheno %>% 
  filter(Sex=="F" & Diet=="hf") %>% 
  select(Bodyweight) %>% 
  unlist

# We use the t.test function to calculate CI and p-value
t.test(treatment, control, conf.level=0.95)
t.test(treatment, control, conf.level=0.99)