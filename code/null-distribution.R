library(tidyverse)
set.seed(1)

pheno <- read.csv("../data/mice_pheno.csv")
meanWeight <- mean(pheno$Bodyweight, na.rm = TRUE)
sdWeight <- sd(pheno$Bodyweight, na.rm = TRUE)
simWeights <-  rnorm(100, meanWeight, sdWeight)
ninetyFifth <- quantile(simWeights, probs = .95)[[1]]

png("../fig/null-hypothesis.png", res = 125)
ggplot(data.frame(x = simWeights), aes(x = x)) +
  stat_function(fun = dnorm, args = list(meanWeight, sdWeight),
                color = "#7570b3", lwd=1) +
  scale_x_continuous(limits = c(0,60)) +
  labs(title = "Null hypothesis", x = "body weight (g)") +
  theme(axis.title.y=element_blank(),
        axis.text.y=element_blank(), axis.ticks.y=element_blank(),
        panel.background = element_rect(fill = "white"),
        axis.line.x = element_line()) +
  geom_segment(aes(x = meanWeight, xend = meanWeight, y=0, yend=.065),
               color = "#1b9e77") +
  geom_segment(aes(x = ninetyFifth, xend = ninetyFifth, y=0, yend=.022),
               color = "#d95f02") +
  geom_segment(aes(x = ninetyFifth, xend = max(simWeights) + 5, y=0, yend=0),
               color = "#d95f02") +
  annotate(geom = "text", x = 17, y=.05, label=expression(H[0]), size = 7) +
  annotate(geom = "text", x = 28, y=.068, label=expression(mu[0]), size = 6,
           color = "#1b9e77") +
  annotate(geom = "text", x = 40.5, y=.004, label=expression(alpha), size = 6,
           color = "#d95f02") +
  annotate(geom = "text", x = 14, y=-.002, label=expression(alpha), size = 4,
           color = "#d95f02") +
  annotate(geom = "text", x = 30, y=-.002, label="= probability of falsely rejecting",
           size = 3) +
  annotate(geom = "text", x = 46.5, y=-.002, label=expression(H[0]),
           size = 3) +
  annotate(geom = "text", x = 53, y=-.002, label="when true",
           size = 3) +
  annotate(geom = "text", x = 37, y=-.006, label="also known as Type I error or false positive",
           size = 3) +
  annotate(geom = "text", x = ninetyFifth + 5.5, y=.026, label="body weight",
           size = 3) +
  annotate(geom = "text", x = ninetyFifth + 5, y=.0225, label="= x grams",
           size = 3, color = "#d95f02")
dev.off()
