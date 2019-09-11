---
title: Setup
---
FIXME


library(tidyverse)

dat <- read_csv(file = "https://raw.githubusercontent.com/genomicsclass/dagdata/master/inst/extdata/femaleMiceWeights.csv")

population <- read_csv(file = "https://raw.githubusercontent.com/genomicsclass/dagdata/master/inst/extdata/femaleControlsPopulation.csv")   
population <- unlist(population) # turn it into a numeric

{% include links.md %}
