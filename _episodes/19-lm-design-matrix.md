
---
title: "The Design Matrix"
teaching: 0
exercises: 0
questions:
- "?"
- "?"
- "?"
objectives:
- ""
- ""
- ""
- ""
- ""
- ""
- ""
keypoints:
- "."
- "."
- "."
- "."
source: Rmd
---


## The Design Matrix

Here we will show how to use the two R functions, `formula`
and `model.matrix`, in order to produce *design matrices* (also known as *model matrices*) for a variety of linear models. For example, in the mouse diet examples we wrote the model as

$$ 
Y_i = \beta_0 + \beta_1 x_i + \varepsilon_i, i=1,\dots,N 
$$

with $Y_i$ the weights 
and $x_i$ equal to 1 only when mouse $i$ receives the high fat diet. We use the term _experimental unit_ to $N$ different entities from which we obtain a measurement. In this case, the mice are the experimental units. 

This is the type of variable we will focus on in this chapter. We call them _indicator variables_ since they simply indicate if the experimental unit had a certain characteristic or not. As we described earlier, we can use linear algebra to represent this model:

$$
\mathbf{Y} = \begin{pmatrix}
Y_1\\
Y_2\\
\vdots\\
Y_N
\end{pmatrix}
,
\mathbf{X} = \begin{pmatrix}
1&x_1\\
1&x_2\\
\vdots\\
1&x_N
\end{pmatrix}
,
\boldsymbol{\beta} = \begin{pmatrix}
\beta_0\\
\beta_1
\end{pmatrix} \mbox{ and }
\boldsymbol{\varepsilon} = \begin{pmatrix}
\varepsilon_1\\
\varepsilon_2\\
\vdots\\
\varepsilon_N
\end{pmatrix}
$$



as: 


$$
\,
\begin{pmatrix}
Y_1\\
Y_2\\
\vdots\\
Y_N
\end{pmatrix} = 
\begin{pmatrix}
1&x_1\\
1&x_2\\
\vdots\\
1&x_N
\end{pmatrix}
\begin{pmatrix}
\beta_0\\
\beta_1
\end{pmatrix} +
\begin{pmatrix}
\varepsilon_1\\
\varepsilon_2\\
\vdots\\
\varepsilon_N
\end{pmatrix}
$$

or simply: 

$$
\mathbf{Y}=\mathbf{X}\boldsymbol{\beta}+\boldsymbol{\varepsilon}
$$

The design matrix is the matrix $\mathbf{X}$.

Once we define a design matrix, we are ready to find the least squares estimates. We refer to this as _fitting the model_. For fitting linear models in R, we will directly provide a _formula_ to the `lm` function. In this script, we will use the `model.matrix` function, which is used internally by the `lm` function. This will help us to connect the R `formula` with the matrix $\mathbf{X}$. It will therefore help us interpret the results from `lm`.

#### Choice of design

The choice of design matrix is a critical step in linear modeling since it encodes which coefficients will be fit in the model, as well as the inter-relationship between the samples. 
A common misunderstanding is that the choice of design follows straightforward from a description of which samples were included in the experiment. This is not the case. The basic information about each sample (whether control or treatment group, experimental batch, etc.) does not imply a single 'correct' design matrix. The design matrix additionally encodes various assumptions about how the variables in $\mathbf{X}$ explain the observed values in $\mathbf{Y}$, on which the investigator must decide.

For the examples we cover here, we use linear models to make comparisons between different groups. Hence, the design matrices that we ultimately work with will have at least two columns: an _intercept_ column, which consists of a column of 1's, and a second column, which specifies which samples are in a second group. In this case, two coefficients are fit in the linear model: the intercept, which represents the population average of the first group, and a second coefficient, which represents the difference between the population averages of the second group and the first group. The latter is typically the coefficient we are interested in when we are performing statistical tests: we want to know if there is a difference between the two groups.

We encode this experimental design in R with two pieces. We start with a formula with the tilde symbol `~`. This means that we want to model the observations using the variables to the right of the tilde. Then we put the name of a variable, which tells us which samples are in which group.

Let's try an example. Suppose we have two groups, control and high fat diet, with two samples each. For illustrative purposes, we will code these with 1 and 2 respectively. We should first tell R that these values should not be interpreted numerically, but as different levels of a *factor*. We can then use the paradigm `~ group` to, say, model on the variable `group`.


~~~
group <- factor( c(1,1,2,2) )
model.matrix(~ group)
~~~
{: .language-r}



~~~
  (Intercept) group2
1           1      0
2           1      0
3           1      1
4           1      1
attr(,"assign")
[1] 0 1
attr(,"contrasts")
attr(,"contrasts")$group
[1] "contr.treatment"
~~~
{: .output}

(Don't worry about the `attr` lines printed beneath the matrix. We won't be using this information.)

What about the `formula` function? We don't have to include this. By starting an expression with `~`, it is equivalent to telling R that the expression is a formula:


~~~
model.matrix(formula(~ group))
~~~
{: .language-r}



~~~
  (Intercept) group2
1           1      0
2           1      0
3           1      1
4           1      1
attr(,"assign")
[1] 0 1
attr(,"contrasts")
attr(,"contrasts")$group
[1] "contr.treatment"
~~~
{: .output}

What happens if we don't tell R that `group` should be interpreted as a factor?


~~~
group <- c(1,1,2,2)
model.matrix(~ group)
~~~
{: .language-r}



~~~
  (Intercept) group
1           1     1
2           1     1
3           1     2
4           1     2
attr(,"assign")
[1] 0 1
~~~
{: .output}

This is **not** the design matrix we wanted, and the reason is that we provided a numeric variable as opposed to an _indicator_ to the `formula` and `model.matrix` functions, without saying that these numbers actually referred to different groups. We want the second column to have only 0 and 1, indicating group membership.

A note about factors: the names of the levels are irrelevant to `model.matrix` and `lm`. All that matters is the order. For example:


~~~
group <- factor(c("control","control","highfat","highfat"))
model.matrix(~ group)
~~~
{: .language-r}



~~~
  (Intercept) grouphighfat
1           1            0
2           1            0
3           1            1
4           1            1
attr(,"assign")
[1] 0 1
attr(,"contrasts")
attr(,"contrasts")$group
[1] "contr.treatment"
~~~
{: .output}

produces the same design matrix as our first code chunk.

#### More groups

Using the same formula, we can accommodate modeling more groups. Suppose we have a third diet:


~~~
group <- factor(c(1,1,2,2,3,3))
model.matrix(~ group)
~~~
{: .language-r}



~~~
  (Intercept) group2 group3
1           1      0      0
2           1      0      0
3           1      1      0
4           1      1      0
5           1      0      1
6           1      0      1
attr(,"assign")
[1] 0 1 1
attr(,"contrasts")
attr(,"contrasts")$group
[1] "contr.treatment"
~~~
{: .output}

Now we have a third column which specifies which samples belong to the third group.

An alternate formulation of design matrix is possible by specifying `+ 0` in the formula:


~~~
group <- factor(c(1,1,2,2,3,3))
model.matrix(~ group + 0)
~~~
{: .language-r}



~~~
  group1 group2 group3
1      1      0      0
2      1      0      0
3      0      1      0
4      0      1      0
5      0      0      1
6      0      0      1
attr(,"assign")
[1] 1 1 1
attr(,"contrasts")
attr(,"contrasts")$group
[1] "contr.treatment"
~~~
{: .output}

This group now fits a separate coefficient for each group. We will explore this design in more depth later on.

#### More variables

We have been using a simple case with just one variable (diet) as an example. In the life sciences, it is quite common to perform experiments with more than one variable. For example, we may be interested in the effect of diet and the difference in sexes. In this case, we have four possible groups:


~~~
diet <- factor(c(1,1,1,1,2,2,2,2))
sex <- factor(c("f","f","m","m","f","f","m","m"))
table(diet,sex)
~~~
{: .language-r}



~~~
    sex
diet f m
   1 2 2
   2 2 2
~~~
{: .output}

If we assume that the diet effect is the same for males and females (this is an assumption), then our linear model is:

$$
Y_{i}= \beta_0 + \beta_1 x_{i,1} + \beta_2 x_{i,2} + \varepsilon_i 
$$

To fit this model in R, we can simply add the additional variable with a `+` sign in order to build a design matrix which fits based on the information in additional variables:


~~~
diet <- factor(c(1,1,1,1,2,2,2,2))
sex <- factor(c("f","f","m","m","f","f","m","m"))
model.matrix(~ diet + sex)
~~~
{: .language-r}



~~~
  (Intercept) diet2 sexm
1           1     0    0
2           1     0    0
3           1     0    1
4           1     0    1
5           1     1    0
6           1     1    0
7           1     1    1
8           1     1    1
attr(,"assign")
[1] 0 1 2
attr(,"contrasts")
attr(,"contrasts")$diet
[1] "contr.treatment"

attr(,"contrasts")$sex
[1] "contr.treatment"
~~~
{: .output}

The design matrix includes an intercept, a term for `diet` and a term for `sex`. We would say that this linear model accounts for differences in both the group and condition variables. However, as mentioned above, the model assumes that the diet effect is the same for both males and females. We say these are an _additive_ effect. For each variable, we add an effect regardless of what the other is. Another model is possible here, which fits an additional term and which encodes the potential interaction of group and condition variables. We will cover interaction terms in depth in a later script.

The interaction model can be written in either of the following two formulas:


~~~
model.matrix(~ diet + sex + diet:sex)
~~~
{: .language-r}

or 


~~~
model.matrix(~ diet*sex)
~~~
{: .language-r}



~~~
  (Intercept) diet2 sexm diet2:sexm
1           1     0    0          0
2           1     0    0          0
3           1     0    1          0
4           1     0    1          0
5           1     1    0          0
6           1     1    0          0
7           1     1    1          1
8           1     1    1          1
attr(,"assign")
[1] 0 1 2 3
attr(,"contrasts")
attr(,"contrasts")$diet
[1] "contr.treatment"

attr(,"contrasts")$sex
[1] "contr.treatment"
~~~
{: .output}

#### Releveling

The level which is chosen for the *reference level* is the level which is contrasted against.  By default, this is simply the first level alphabetically. We can specify that we want group 2 to be the reference level by either using the `relevel` function:


~~~
group <- factor(c(1,1,2,2))
group <- relevel(group, "2")
model.matrix(~ group)
~~~
{: .language-r}



~~~
  (Intercept) group1
1           1      1
2           1      1
3           1      0
4           1      0
attr(,"assign")
[1] 0 1
attr(,"contrasts")
attr(,"contrasts")$group
[1] "contr.treatment"
~~~
{: .output}

or by providing the levels explicitly in the `factor` call:

~~~
group <- factor(group, levels=c("1","2"))
model.matrix(~ group)
~~~
{: .language-r}



~~~
  (Intercept) group2
1           1      0
2           1      0
3           1      1
4           1      1
attr(,"assign")
[1] 0 1
attr(,"contrasts")
attr(,"contrasts")$group
[1] "contr.treatment"
~~~
{: .output}

#### Where does model.matrix look for the data?

The `model.matrix` function will grab the variable from the R global environment, unless the data is explicitly provided as a data frame to the `data` argument:


~~~
group <- 1:4
model.matrix(~ group, data=data.frame(group=5:8))
~~~
{: .language-r}



~~~
  (Intercept) group
1           1     5
2           1     6
3           1     7
4           1     8
attr(,"assign")
[1] 0 1
~~~
{: .output}

Note how the R global environment variable `group` is ignored.

#### Continuous variables

In this chapter, we focus on models based on indicator values. In certain designs, however, we will be interested in using numeric variables in the design formula, as opposed to converting them to factors first. For example, in the falling object example, time was a continuous variable in the model and time squared was also included:



~~~
tt <- seq(0,3.4,len=4) 
model.matrix(~ tt + I(tt^2))
~~~
{: .language-r}



~~~
  (Intercept)       tt   I(tt^2)
1           1 0.000000  0.000000
2           1 1.133333  1.284444
3           1 2.266667  5.137778
4           1 3.400000 11.560000
attr(,"assign")
[1] 0 1 2
~~~
{: .output}

The `I` function above is necessary to specify a mathematical
transformation of a variable. For more details, see the manual page
for the `I` function by typing `?I`.

In the life sciences, we could be interested in testing various
dosages of a treatment, where we expect a specific relationship
between a measured quantity and the dosage, e.g. 0 mg, 10 mg, 20 mg. 

The assumptions imposed by including continuous data as variables are typically hard to defend and motivate than the indicator function variables. Whereas the indicator variables simply assume a different mean between two groups, continuous variables assume a very specific relationship between the outcome and predictor variables. 

In cases like the falling object, we have the theory of gravitation supporting the model. In the father-son height example, because the data is bivariate normal, it follows that there is a linear relationship if we condition. However, we find that continuous variables are included in linear models without justification to "adjust" for variables such as age. We highly discourage this practice unless the data support the model being used.

ExercisesSuppose we have an experiment with the following design: on three different days, we perform anexperiment with two treated and two control units. We then measure some outcomeYi, and wewant to test the effect of treatment as well the effects of different days (perhaps the temperature inthe lab affects the measuring device). Assume that the true condition effect is the same for each day(no interaction between condition and day). We then define factors in R fordayand forcondition.condition/dayABCtreatment222control2221.Given the factors we have defined above and without defining any new ones, which of thefollowing R formula will produce a design matrix (model matrix) that lets us analyze theeffect of condition, controlling for the different days?
•A)day + condition•B)conditionday•C)A + B + C + control + treated•D)B + C + treatedRemember that using theand the names for the two variables we want in the model will producea design matrix controlling for all levels of day and all levels of condition. We do not use the levelsin the design formula.
