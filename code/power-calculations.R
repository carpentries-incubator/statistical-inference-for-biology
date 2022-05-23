library(tidyverse)

## read "population" and split it into control and treatment
pheno <- read.csv("../data/mice_pheno.csv") #Previously downloaded 

controlPopulation <- filter(pheno, Sex == "F" & Diet == "chow") %>%  
  select(Bodyweight) %>% unlist

hfPopulation <- filter(pheno, Sex == "F" & Diet == "hf") %>%  
  select(Bodyweight) %>% unlist

mu_hf <- mean(hfPopulation)
mu_control <- mean(controlPopulation)
print(mu_hf - mu_control)
print((mu_hf - mu_control)/mu_control * 100) #percent increase

## See what happens when we try to reject the null with only 5 data points
set.seed(1234)
N <- 5
hf <- sample(hfPopulation, N)
control <- sample(controlPopulation, N)
t.test(hf, control)$p.value

## Calculate power for a given sample size and alpha
N <- 12
alpha <- 0.05
B <- 2000

reject <- function(N, alpha=0.05){
  treatment <- sample(hfPopulation, N) 
  control <- sample(controlPopulation, N)
  pval <- t.test(treatment, control)$p.value
  pval < alpha
}

reject(12)

rejections <- replicate(B, reject(N))
length(which(rejections==TRUE))/B # this is our power with N=12 for this effect size

## Calculate power for 10 different N values; alpha =0.05
Ns <- seq(5, 50, 5)

power <- sapply(Ns,function(N){
  rejections <- replicate(B, reject(N))
  length(which(rejections==TRUE))/B
})

plot(Ns, power, type="b")

## Calculate power for different alpha values; N=30
N <- 30
alphas <- c(0.1, 0.05, 0.01, 0.001, 0.0001)
power <- sapply(alphas, function(alpha){
  rejections <- replicate(B, reject(N, alpha=alpha))
  length(which(rejections==TRUE))/B
})
plot(alphas, power, xlab="alpha", type="b", log="x")

# write a function that returns a p-value for a given sample size N:
calculatePvalue <- function(N) {
  hf <- sample(hfPopulation,N) 
  control <- sample(controlPopulation,N)
  t.test(hf,control)$p.value
}

# We have a limit here of 200 for the high-fat diet population, but we can see 
# the effect well before we get to 200. For each sample size, we will calculate 
# a few p-values. We can do this by repeating each value of N a few times.
Ns <- seq(10,200,by=10)
Ns_rep <- rep(Ns, each=10)

# use sapply to run our simulations:
pvalues <- sapply(Ns_rep, calculatePvalue)

# plot the 10 p-values generated for each sample size:
plot(Ns_rep, pvalues, log="y", xlab="sample size",
       ylab="p-values")
abline(h=c(.01, .05), col="red", lwd=2)

# a better statistic to report is the effect size with a confidence interval or 
# some statistic which gives the reader a sense of the change in a meaningful 
# scale. We can report the effect size as a percent by dividing the difference 
# and the confidence interval by the control population mean:
N <- 12
hf <- sample(hfPopulation, N)
control <- sample(controlPopulation, N)
diff <- mean(hf) - mean(control)
diff / mean(control) * 100
