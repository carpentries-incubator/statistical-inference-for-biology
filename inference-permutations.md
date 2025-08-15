---
title: Permutations
teaching: 0
exercises: 0
source: Rmd
---

::::::::::::::::::::::::::::::::::::::: objectives

- - - 
::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- ?

::::::::::::::::::::::::::::::::::::::::::::::::::





## Permutation Tests

Suppose we have a situation in which none of the standard mathematical
statistical approximations apply. We have computed a summary statistic, such as
the difference in mean, but do not have a useful approximation, such as that
provided by the CLT. In practice, we do not have access to all values in the
population so we can't perform a simulation as done above. Permutation tests can
be useful in these scenarios.

We are back to the scenario where we only have 10 measurements for each group.


``` r
fWeights <- read.csv(file = "../data/femaleMiceWeights.csv") # we read this data in earlier
```

``` warning
Warning in file(file, "rt"): cannot open file '../data/femaleMiceWeights.csv':
No such file or directory
```

``` error
Error in file(file, "rt"): cannot open the connection
```

``` r
control <- filter(fWeights, Diet=="chow") %>% select(Bodyweight) %>% unlist
```

``` error
Error: object 'fWeights' not found
```

``` r
treatment <- filter(fWeights, Diet=="hf") %>% select(Bodyweight) %>% unlist
```

``` error
Error: object 'fWeights' not found
```

``` r
obsdiff <- mean(treatment) - mean(control)
```

``` error
Error: object 'treatment' not found
```

In previous sections, we showed parametric approaches that helped determine if
the observed difference was significant. Permutation tests take advantage of the
fact that if we randomly shuffle the cases and control labels, then the null is
true. So we shuffle the cases and control labels and assume that the ensuing
distribution approximates the null distribution. Here is how we generate a null
distribution by shuffling the data 1,000 times:


``` r
N <- 12
avgdiff <- replicate(1000, {
    all <- sample(c(control, treatment))
    newcontrols <- all[1:N]
    newtreatments <- all[(N+1):(2*N)]
  return(mean(newtreatments) - mean(newcontrols))
})
```

``` error
Error in FUN(X[[i]], ...): object 'control' not found
```

``` r
hist(avgdiff)
```

``` error
Error: object 'avgdiff' not found
```

``` r
abline(v=obsdiff, col="red", lwd=2)
```

``` error
Error: object 'obsdiff' not found
```

How many of the null means are bigger than the observed value? That proportion
would be the p-value for the null. We add a 1 to the numerator and denominator
to account for misestimation of the p-value (for more details see
[Phipson and Smyth, Permutation P-values should never be zero](https://www.ncbi.nlm.nih.gov/pubmed/21044043)).


``` r
#the proportion of permutations with larger difference
(sum(abs(avgdiff) > abs(obsdiff)) + 1) / (length(avgdiff) + 1)
```

``` error
Error: object 'avgdiff' not found
```

Now let's repeat this experiment for a smaller dataset. We create a smaller
dataset by sampling:


``` r
N <- 5
control <- sample(control,N)
```

``` error
Error: object 'control' not found
```

``` r
treatment <- sample(treatment,N)
```

``` error
Error: object 'treatment' not found
```

``` r
obsdiff <- mean(treatment)- mean(control)
```

``` error
Error: object 'treatment' not found
```

and repeat the exercise:


``` r
avgdiff <- replicate(1000, {
    all <- sample(c(control,treatment))
    newcontrols <- all[1:N]
    newtreatments <- all[(N+1):(2*N)]
  return(mean(newtreatments) - mean(newcontrols))
})
```

``` error
Error in FUN(X[[i]], ...): object 'control' not found
```

``` r
hist(avgdiff)
```

``` error
Error: object 'avgdiff' not found
```

``` r
abline(v=obsdiff, col="red", lwd=2)
```

``` error
Error: object 'obsdiff' not found
```

Now the observed difference is not significant using this approach. Keep in mind
that there is no theoretical guarantee that the null distribution estimated from permutations approximates the actual null distribution. For example, if there is
a real difference between the populations, some of the permutations will be
unbalanced and will contain some samples that explain this difference. This
implies that the null distribution created with permutations will have larger
tails than the actual null distribution. This is why permutations result in
conservative p-values. For this reason, when we have few samples, we can't do
permutations.

Note also that permutation tests still have assumptions: samples are assumed to
be independent and "exchangeable". If there is hidden structure in your data,
then permutation tests can result in estimated null distributions that
underestimate the size of tails because the permutations may destroy the
existing structure in the original data.

> Exercises
> We will use the following dataset to demonstrate the use of permutations:  
> `url<-"https://raw.githubusercontent.com/genomicsclass/dagdata/master/inst/extdata/babies.txt"`  
> `filename <- basename(url)`  
> `download(url, destfile=filename)`  
> `babies<-read.table("babies.txt", header=TRUE)`  
> `bwt.nonsmoke <- filter(babies, smoke==0) %>% select(bwt) %>% unlist`  
> `bwt.smoke <- filter(babies, smoke==1) %>% select(bwt) %>% unlist`
> 
> 1. We will generate the following random variable based on a sample size of 10
>   and observe the following difference:  
>   `N <- 10`  
>   `set.seed(1)`  
>   `nonsmokers<-sample(bwt.nonsmoke, N)`  
>   `smokers<-sample(bwt.smoke, N)`  
>   `obs <- mean(smokers) - mean(nonsmokers)`  
>   The question is whether this observed difference is statistically significant.
>   We do not want to rely on the assumptions needed for the normal or
>   t-distribution approximations to hold, so instead we will use permutations. We
>   will reshuffle the data and recompute the mean. We can create one permuted
>   sample with the following code:  
>   `dat <- c(smokers, nonsmokers)`  
>   `shuffle <- sample(dat)`  
>   `smokersstar <- shuffle[1:N]`  
>   `nonsmokersstar <- shuffle[(N+1):(2*N)]`  
>   `mean(smokersstar) - mean(nonsmokersstar)`  
>   The last value is one observation from the null distribution we will
>   construct. Set the seed at 1, and then repeat the permutation 1,000 times to
>   create a null distribution. What is the permutation derived p-value for our
>   observation?
> 2. Repeat the above exercise, but instead of the differences in mean, consider
>   the differences in median.
>   `obs <- median(smokers) - median(nonsmokers)`
>   What is the permutation based p-value?

:::::::::::::::::::::::::::::::::::::::: keypoints

- .
- .
- .
- .

::::::::::::::::::::::::::::::::::::::::::::::::::


