
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mlrmodel

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/htzheng1018/625hw3/branch/main/graph/badge.svg)](https://app.codecov.io/gh/htzheng1018/625hw3?branch=main)
[![R-CMD-check](https://github.com/htzheng1018/625hw3/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/htzheng1018/625hw3/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of mypackage is to fit a multiple linear regression using
matrix calculations. It contains a real dataset, which describes
depression and its factots, and a virtual dataset, which is created by
random variables. Using this model, we can estimate the coefficients of
variables, partial SSE, se(beta_hat), t value, p value and significance
of each variables.

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
#> [1] -0.07685271
#> 
#> $smry
#>                        beta       partial sse       se beta_hat
#> intercept  4.22130149395663 -780.253357064103 0.158307760645167
#> x1         3.04123060118513  472.211826798207 0.143249899260805
#> x2         1.96688031359417  169.776192582716 0.170283027888993
#> x3        -1.45103163848862  82.8255675924377 0.175035631612924
#>                     t value      p value significance
#> intercept  26.6651582762156 0.000000e+00          ***
#> x1         21.2302460028134 0.000000e+00          ***
#> x2         11.5506538612666 3.552714e-15             
#> x3        -8.28992145837743 1.109417e-10             
#> 
#> $corr_table
#>              x1          x2           x3
#> x1  1.000000000 -0.14850992 -0.007224338
#> x2 -0.148509918  1.00000000 -0.035888049
#> x3 -0.007224338 -0.03588805  1.000000000
#> 
#> $R_square
#>           [,1]
#> [1,] 0.9289465
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
#>       4.221        3.041        1.967       -1.451
```

use Rcpp to calculate mean

``` r
lrm(y, x, Rcpp = T)
#> [1] -0.19711935 -0.05215594  0.01871715
```

Compare with the original function.

``` r
colMeans(x)
#>          x1          x2          x3 
#> -0.19711935 -0.05215594  0.01871715
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
#> 1 myfunc        925µs    997µs      935.     463KB     10.6
#> 2 lmfunc        739µs    776µs     1275.     124KB     15.0
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
#> 1 rcppfunc    21.67µs   23.9µs    41053.    10.6KB     16.4
#> 2 orginfunc    4.88µs    5.5µs   175207.        0B     35.0
```
