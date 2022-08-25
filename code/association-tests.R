tab <- matrix(data=c(3,1,1,3), nrow=2, ncol=2)
rownames(tab) <- c("Poured Before", "Poured After")
colnames(tab) <- c("Guessed before", "Guessed after")
tab

fisher.test(tab, alternative = "greater")

disease <- factor(c(rep(0, 180), rep(1, 20), rep(0,40), rep(1,10)),
                    labels = c("control", "cases"))
genotype <- factor(c(rep("AA/Aa", 200), rep("aa", 50)),
                   levels = c("AA/Aa", "aa"))
dat <- data.frame(disease, genotype)
dat <- dat[sample(nrow(dat)),] # shuffle them up
head(dat)

table(genotype)

tab <- table(genotype, disease)
tab
tab[2, 2] / tab[2, 1]
tab[1, 2] / tab[1, 1]
(tab[2, 2] / tab[2, 1]) / (tab[1, 2] / tab[1, 1])

p <- mean(disease == "cases")
p

expected <- rbind(c(1-p, p) * sum(genotype=="AA/Aa"),
                  c(1-p, p) * sum(genotype=="aa"))
dimnames(expected) <- dimnames(tab)
expected

chisq.test(tab)$p.value

tab <- tab * 10
tab
chisq.test(tab)$p.value

# modeling categorical analysis
# binomial - logistic regression model
fit <- glm(disease ~ genotype, family = "binomial", data = dat)
summary(fit)
coeftab <- summary(fit)$coef
coeftab
exp(0.8109302) # odds ratio from glm estimate

ci <- coeftab[2, 1] + c(-2, 2) * coeftab[2, 2]
ci # 95% of data is between
coeftab[2, 1] # estimate
coeftab[2, 2] # 2 standard errors
exp(ci) # odds ratio is between this number, and includes 1 which means null 
# might be true; close to but not quite significant 
