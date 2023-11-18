
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mlrmodel

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/htzheng1018/625hw3/branch/main/graph/badge.svg)](https://app.codecov.io/gh/htzheng1018/625hw3?branch=main)
[![R-CMD-check](https://github.com/htzheng1018/625hw3/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/htzheng1018/625hw3/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of mlrmodel is to fit a multiple linear regression using matrix
calculations. It contains a virtual dataset with y and x, which are
created by random variables. Using this model, we can estimate the
coefficients of variables, partial SSE, se(beta_hat), t value, p value,
significance of each variables, R square. Meanwhile, this function also
contains a Rcpp function, which can calculate the mean of each x
variables.

Compare with the traditional lm() function, the lrm() function can
remains the same effect. Meanwhile, the Rcpp file can also have the same
effect with the original R function.

## Installation

You can install the development version of mypackage and vignettes from
github with devtools:

``` r
# install.packages("devtools")
devtools::install_github("htzheng1018/625hw3", build_vignettes = T)
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(mlrmodel)
## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

This is a basic example which shows you how to solve a common problem:

``` r
n = 50
x1 = rnorm(n)
x2 = rnorm(n)
x3 = rnorm(n)
x = cbind(x1, x2, x3)
y = 4 + 3 * x1 + 2 * x2 - 1.5 * x3 + rnorm(n)
```

call our function

``` r
lrm(y, x)
#> $mean_x
#> [1] -0.1573282
#> 
#> $smry
#>                        beta      partial sse       se beta_hat
#> intercept  4.13631739717443  -688.4384476697 0.136926322353665
#> x1         3.22760089958289 395.024213875671 0.161098015709941
#> x2         1.96424689106138 156.552529956613 0.143834178250059
#> x3        -1.63612336674549 97.9812535596508  0.15196069758785
#>                     t value     p value significance
#> intercept  30.2083436265146 0.00000e+00          ***
#> x1         20.0350133759202 0.00000e+00          ***
#> x2         13.6563292185428 0.00000e+00          ***
#> x3        -10.7667534613655 3.68594e-14             
#> 
#> $corr_table
#>              x1          x2           x3
#> x1  1.000000000 0.005720326 -0.124269181
#> x2  0.005720326 1.000000000  0.003613378
#> x3 -0.124269181 0.003613378  1.000000000
#> 
#> $R_square
#>           [,1]
#> [1,] 0.9435237
```

Compare with the original function lm().

``` r
lm(y ~ x1 + x2 + x3)
#> 
#> Call:
#> lm(formula = y ~ x1 + x2 + x3)
#> 
#> Coefficients:
#> (Intercept)           x1           x2           x3  
#>       4.136        3.228        1.964       -1.636
```

use Rcpp to calculate mean

``` r
lrm(y, x, Rcpp = T)
#> [1] -0.1097702 -0.1953049 -0.1669094
```

Compare with the original function.

``` r
colMeans(x)
#>         x1         x2         x3 
#> -0.1097702 -0.1953049 -0.1669094
```

We use benchmarks to test the efficiency of our new function.

``` r
library(bench)
effct_func <- bench::mark(myfunc = {
  beta_my <- as.vector(round(as.numeric(lrm(y, x)$smry[, "beta"]), 3))
}, lmfunc = {
   beta_lm <- as.vector(round(summary(lm(y ~ x1 + x2 + x3))$coefficients[, "Estimate"], 3))
})
summary(effct_func)
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 myfunc        930µs    997µs      956.     463KB     10.7
#> 2 lmfunc        745µs    785µs     1250.     124KB     15.1
```

We use benchmarks to test the efficiency of our Rcpp.

``` r
effct_func_new <- bench::mark(rcppfunc = {
  mean_my <- as.vector(round(as.numeric(lrm(y, x, Rcpp = T)), 3))
}, orginfunc = {
   mean_og <- as.vector(round(colMeans(x), 3))
})
summary(effct_func_new)
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 rcppfunc    21.69µs  24.09µs    40605.    10.6KB     16.2
#> 2 orginfunc    4.67µs   5.28µs   178251.        0B     35.7
```
