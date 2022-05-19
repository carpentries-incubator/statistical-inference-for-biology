set.seed(1)

pheno <- read.csv("../data/mice_pheno.csv")
meanWeight <- mean(pheno$Bodyweight, na.rm = TRUE)
sdWeight <- sd(pheno$Bodyweight, na.rm = TRUE)
simWeights <-  rnorm(100, meanWeight, sdWeight)
ninetyFifth <- quantile(simWeights, probs = .95)[[1]]

pdf("../fig/null-hypothesis.pdf")
ggplot(data.frame(x = simWeights), aes(x = x)) +
  stat_function(fun = dnorm, args = list(meanWeight, sdWeight),
                color = "#7570b3", lwd=1) +
  labs(title = "Null hypothesis", x = "body weight (g)") +
  theme(axis.title.y=element_blank(),
        axis.text.y=element_blank(), axis.ticks.y=element_blank(),
        panel.background = element_rect(fill = "white"),
        axis.line.x = element_line()) +
  geom_segment(aes(x = meanWeight, xend = meanWeight, y=0.003, yend=.065),
               color = "#1b9e77") +
  geom_segment(aes(x = ninetyFifth, xend = ninetyFifth, y=0.0007, yend=.02),
               color = "#d95f02") +
  geom_segment(aes(x = ninetyFifth, xend = max(simWeights), y=0.0007, yend=0.0007),
               color = "#d95f02") +
  annotate(geom = "text", x = 17, y=.05, label=expression(H[0]), size = 7) +
  annotate(geom = "text", x = 28, y=.065, label=expression(mu[0]), size = 6,
           color = "#1b9e77") +
  annotate(geom = "text", x = 40.5, y=.005, label=expression(alpha), size = 6,
           color = "#d95f02") +
  annotate(geom = "text", x = 30.5, y=.011, label=expression(alpha), size = 5,
           color = "#d95f02") +
  annotate(geom = "text", x = 33.7, y=.011, label="= probability of",
           size = 4) +
  annotate(geom = "text", x = 33.7, y=.009, label="falsely rejecting",
           size = 4) +
  annotate(geom = "text", x = 37.25, y=.00875, label=expression(H[0]),
           size = 4) +
  annotate(geom = "text", x = 34, y=.007, label="when true",
           size = 4) +
  annotate(geom = "text", x = 34, y=.0045, label="also known as",
           size = 4) +
  annotate(geom = "text", x = 34, y=.0025, label="Type I error",
           size = 4) +
  annotate(geom = "text", x = 34, y=.0005, label="or false positive",
           size = 4) +
  annotate(geom = "text", x = 41.5, y=.02, label="body weight",
           size = 4) +
  annotate(geom = "text", x = 41, y=.018, label="= x grams",
           size = 4, color = "#d95f02")
dev.off()
