library(dplyr)

# we read this data in earlier
fWeights <- read.csv(file = "../data/femaleMiceWeights.csv") 
control <- filter(fWeights, Diet=="chow") %>% 
  select(Bodyweight) %>% 
  unlist
treatment <- filter(fWeights, Diet=="hf") %>% 
  select(Bodyweight) %>% 
  unlist
obsdiff <- mean(treatment) - mean(control)
obsdiff

# 12 chow and 12 high fat
N <- 12

# sample control and treatment values 
# scramble their orders
# newcontrols will have a mix of controls and treatments, 
# as will newtreatments
# by scrambling controls and treatments, we assume that diet means nothing
# because labels have been scrambled
# there is effectively no difference between treatments and controls
# but you will still get differences between groups

scramble <- function() {
  all <- sample(c(control, treatment))
  newcontrols <- all[1:N]
  newtreatments <- all[(N+1):(2*N)]
  return(mean(newtreatments) - mean(newcontrols))
}

avgdiff <- replicate(1000, scramble())
hist(avgdiff)
abline(v = obsdiff, col = "red", lwd=2)

# this effectively calculates a p-value
(sum(abs(avgdiff) > abs(obsdiff)) + 1) / (length(avgdiff) + 1)
# as sample size goes down, p-values get larger and power diminishes
# larger the sample size, better the p-values and better the estimate
# of the means

# Exercises
url<-"https://raw.githubusercontent.com/genomicsclass/dagdata/master/inst/extdata/babies.txt"
filename <- basename(url)
download(url, destfile=filename)
babies<-read.table("babies.txt", header=TRUE)
bwt.nonsmoke <- filter(babies, smoke==0) %>% select(bwt) %>% unlist
bwt.smoke <- filter(babies, smoke==1) %>% select(bwt) %>% unlist

N <- 10
set.seed(1)
nonsmokers <- sample(bwt.nonsmoke, N)
smokers <- sample(bwt.smoke, N)
obs <- mean(smokers) - mean(nonsmokers)
obs

dat <- c(smokers, nonsmokers)
shuffle <- sample(dat)
smokersstar <- shuffle[1:N]
nonsmokersstar <- shuffle[(N+1):(2*N)]
mean(smokersstar) - mean(nonsmokersstar)

set.seed(1)

nulldist <- function() {
  shuffle <- sample(dat)
  smokersstar <- shuffle[1:N]
  nonsmokersstar <- shuffle[(N+1):(2*N)]
  return(mean(smokersstar) - mean(nonsmokersstar))
}

stats <- replicate(1000, nulldist())
stats
summary(stats)
(sum(abs(stats) > abs(obs)) + 1) / (length(stats) + 1)
