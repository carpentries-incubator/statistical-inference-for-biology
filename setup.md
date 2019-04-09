---
title: Setup
---
FIXME


library(downloader)
# load the high fat diet population data
dir <- "https://raw.githubusercontent.com/genomicsclass/dagdata/master/inst/extdata/"
filename <- "mice_pheno.csv"
url <- paste0(dir, filename)
if (!file.exists(filename)) download(url,destfile=filename)

{% include links.md %}
