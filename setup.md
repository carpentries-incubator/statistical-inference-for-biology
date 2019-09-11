---
layout: page
title: Setup
permalink: /setup/
---
## Installation

R is a programming language that is especially powerful for data exploration, visualization, and statistical analysis. To interact with R, we use RStudio. 

1. Install the latest version of R from [CRAN](https://cran.r-project.org/).

2. Install the latest version of RStudio [here](https://www.rstudio.com/products/rstudio/download/). Choose the free RStudio Desktop version for Windows, Mac, or Linux. 

3. Start RStudio. The [tidyverse](https://www.tidyverse.org/) contains several packages that work together for everyday use in data science. You can install them from the Console or from the RStudio Packages tab.

~~~
install.packages("tidyverse")
~~~
{: .r}

Make sure that the installation was successful by loading the `tidyverse` library. Do this in the Console as below, or check the box next to the `tidyverse` library in the RStudio Packages tab.

~~~
library(tidyverse)
~~~
{: .r}

Also install and load the libraries for `downloader`, `UsingR` and `rafalib` by following the same procedure that you followed for the `tidyverse`.

## Data files and project organization

1. Make a new folder in your Desktop called `dals`. Move into this new folder.

2. Create  a `data` folder to hold the data, a `scripts` folder to house your scripts, and a `results` folder to hold results. 

Alternatively, you can use the R console to run the following commands for steps 1 and 2.

~~~
setwd("~/Desktop")
dir.create("./dals")
setwd("~/Desktop/dals")
dir.create("./data")
dir.create("./scripts")
dir.create("./results")
~~~
{: .r}


3. Please download the following files **before the workshop**, and place them in your `data` folder. You can download the files from the URLs below and move the files the same way that you would for downloading and moving any other kind of data.


Alternatively, you can copy and paste the following into the R console to download the data.
~~~
setwd("~/Desktop/mapping")
download.file("https://ndownloader.figshare.com/files/9746485", "./data/cc_variants.sqlite")
download.file("https://ndownloader.figshare.com/files/9746458", "./data/mouse_genes.sqlite")
download.file("https://ndownloader.figshare.com/files/9746452", "./data/mouse_genes_mgi.sqlite")
download.file("ftp://ftp.jax.org/dgatti/qtl2_workshop/qtl2_demo.Rdata", "./data/qtl2_demo.Rdata")
~~~
{: .r}


You will need these for the final lesson episodes on SNP association mapping and QTL analysis in Diversity Outbred mice.

### Load data for the chapter on [Inference]("https://smcclatchy.github.io/dals-chaps4-10/02-inference/index.html") by copying and pasting the following code into the RStudio Console.

download(url = "https://raw.githubusercontent.com/genomicsclass/dagdata/master/inst/extdata/femaleMiceWeights.csv", destfile = "data/femaleMiceWeights.csv")

download(url = "https://raw.githubusercontent.com/genomicsclass/dagdata/master/inst/extdata/femaleControlsPopulation.csv", destfile = "data/femaleControlsPopulation.csv")
 
{% include links.md %}
