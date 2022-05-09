set.seed(1)
library(tidyverse)

pheno <- read.csv("../data/mice_pheno.csv")
hfPopulation <- filter(pheno, Diet == "hf") %>%
  select(Bodyweight) %>% unlist

mu_hf <- 42
meanWeight <- mean(pheno$Bodyweight, na.rm = TRUE)
sdWeight <- sd(pheno$Bodyweight, na.rm = TRUE)
simWeights <-  rnorm(100, meanWeight, sdWeight)
simhfWeights <-  rnorm(100, mu_hf, sdWeight)
ninetyFifth <- quantile(simWeights, probs = .95)[[1]]

png("../fig/alternative-hypothesis.png", res = 125)
ggplot(data.frame(x = simhfWeights), aes(x = x)) +
  stat_function(fun = dnorm, args = list(mu_hf, sdWeight),
                color = "#66a61e", lwd=1) +
  scale_x_continuous(limits = c(0,60)) +
  labs(title = "Alternative hypothesis", x = "body weight (g)") +
  theme(axis.title.y=element_blank(),
        axis.text.y=element_blank(), axis.ticks.y=element_blank(),
        panel.background = element_rect(fill = "white"),
        axis.line.x = element_line()) +
  geom_segment(aes(x = mu_hf, xend = mu_hf, y=0, yend=.01),
               color = "#e7298a") +
  geom_segment(aes(x = mu_hf, xend = mu_hf, y=.025, yend=.065),
               color = "#e7298a") +
  geom_segment(aes(x = ninetyFifth, xend = ninetyFifth, y=0, yend=.055),
               color = "#e6ab02") +
  geom_segment(aes(x = ninetyFifth, xend = min(simWeights), y=0, yend=0),
                                                 color = "#e6ab02") +
  annotate(geom = "text", x = 17, y=.05, label=expression(H[A]), size = 7) +
  annotate(geom = "text", x = 41, y=.067, label=expression(mu[A]), size = 6,
           color = "#e7298a") +
  annotate(geom = "text", x = 35, y=.015, label=expression(beta), size = 6,
           color = "#e6ab02") +
  annotate(geom = "text", x = 45, y=.02, label= "power", size = 4) +
  annotate(geom = "text", x = 43.5, y=.015, label= "1 - ", size = 5) +
  annotate(geom = "text", x = 47, y=.015, label= expression(beta), size = 6,
           color = "#e6ab02") +
  annotate(geom = "text", x = 18.5, y=-.002, label=expression(beta), size = 4,
           color = "#e6ab02") +
  annotate(geom = "text", x = 27.3, y=-.002, label="= failure to reject",
           size = 3) +
  annotate(geom = "text", x = 37, y=-.002, label=expression(H[0]),
           size = 3) +
  annotate(geom = "text", x = 46, y=-.002, label="when we should",
           size = 3) +
  annotate(geom = "text", x = 38, y=-.006, label="also known as Type II error or false negative",
           size = 3) +
  annotate(geom = "text", x = 32.5, y=.057, label="body weight",
           size = 3) +
  annotate(geom = "text", x = 32.5, y=.054, label="= x grams",
           size = 3, color = "#e6ab02")
dev.off()
