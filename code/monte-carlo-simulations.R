# Monte Carlo simulation is often used with a new method to analyze data to 
# evaluate the method against other existing methods so that they can publish
# in omics there are not many synthetic wet lab data sets
# much easier to simulate the data instead
library(dplyr)
pheno <- read.csv("../data/mice_pheno.csv")

controlPopulation <- filter(pheno, Sex == "F" & Diet == "chow") %>%
  select(Bodyweight) %>% 
  unlist

head(controlPopulation)

# make a function to generate a t-test value for different sample sizes
ttestgenerator <- function(n) {
  # note that here we have a false "high fat" group where we actually
  # sample from the chow or control population. 
  # This is because we are modeling the null.
  cases <- sample(controlPopulation, n)
  controls <- sample(controlPopulation, n)
  # code below is effectively the Welch t-test, which allows for differing 
  # variances between groups; Gosset's version assumes equal variances
  # Welch is the default for the t.test() function
  tstat <- (mean(cases) - mean(controls)) / 
    sqrt( var(cases)/n + var(controls)/n ) 
  return(tstat)
  }

# generate 1000 test experiments at sample size of 10 (e.g.10 cases, 10 controls)
ttests <- replicate(1000, ttestgenerator(10))

# what is the spread of the t-test values?
summary(ttests)

# is the distribution normal?
hist(ttests)
qqnorm(ttests)
abline(0, 1)
# underlying data appear to be fairly normal

# try using a sample size of 3 now
ttests <- replicate(1000, ttestgenerator(3))
# skip the histogram because it's hard to see the difference between
# the normal and the t-distribution
qqnorm(ttests)
abline(0, 1)
# tails indicate non-normal distribution, meaning that this 
# distribution has fatter tails (greater spread) than a normal distribution
# if model a fat-tailed distribution as a narrower one, you can end up
# with many false positives or negatives

# generate values from a t-distribution by filling in a sequence of 
# probabilities
# ask what are the q-values for the degrees of freedom?
# sample size 3, estimating 2 means to calculate degrees of freedom
ps <- (seq(0, 999) + 0.5)/1000
summary(ps)
head(ps)
tail(ps)
# qqnorm plots some distribution against normal distribution
# qqplot plots two different distributions
# qt returns t-statistics corresponding to a specific probability and 
# degrees of freedom; qt = quantiles (percentiles)
qqplot(qt(ps, df = 2 * 3 - 2), ttests, xlim=c(-6, 6), ylim=c(-6,6))
abline(0, 1)
# sample size of 3 with the right t-distribution is not too far off

# generate 5000 random normal values with a mean of 24 
# and standard deviation 3.5 
controls <- rnorm(5000, mean = 24, sd = 3.5)
summary(controls)

# re-define the function with a mean of 24 and standard deviation 3.5 
ttestgenerator <- function(n, mean=24, sd=3.5) {
  cases <- rnorm(n, mean, sd)
  controls <- rnorm(n, mean, sd)
  tstat <- (mean(cases) - mean(controls)) / 
    sqrt( var(cases)/n + var(controls)/n ) 
  return(tstat)
}

ttests <- replicate(1000, ttestgenerator(3))
summary(ttests)
length(ttests)
ps <- (seq(0, 999) + 0.5) / 1000
summary(ps)
head(ps)
qqplot(qt(ps, df = 2 * 3 - 2), ttests, xlim=c(-6,6), ylim=c(-6,6))
abline(0,1)
