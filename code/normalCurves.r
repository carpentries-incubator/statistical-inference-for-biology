# script for plot of normal curves with differing means and sds
library(tidyverse)

png("../fig/normal-curves.png")
ggplot(data.frame(x = c(-10, 10)), aes(x = x)) +
  stat_function(fun = dnorm, args = list(-5, 2), color = "#7570b3", lwd=1) +
  stat_function(fun = dnorm, args = list(5, 0.5), color = "#d95f02", lwd=1) +
  stat_function(fun = dnorm, color = "#1b9e77", lwd=1) + 
  theme(axis.title.x=element_blank(), axis.title.y=element_blank()) + 
  annotate('text', x = -8, y = 0.2, label= "mean = -5\nsd = 2", color = "#7570b3") + 
  annotate('text', x = -2.5, y = 0.35, label= "mean = 0\nsd = 1", color = "#1b9e77")  + 
  annotate('text', x = 2.5, y = 0.6, label= "mean = 5\nsd = 0.5", color = "#d95f02")
dev.off()
