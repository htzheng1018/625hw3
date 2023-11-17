
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
missing_positions = sample(1: 200, 30) 
y = 4 + 3 * x1 + 2 * x2 - 1.5 * x3 + rnorm(n)
```

call our function

``` r
lrm(y, x)
#> $mean_x
#> [1] -0.1714946
#> 
#> $smry
#>                       beta       partial sse       se beta_hat          t value
#> intercept 3.93124147978536 -788.687978357865 0.142656568163142 27.5573815521035
#> x1        3.18340502150309  460.894412591189 0.190495910516939 16.7111462543445
#> x2        1.88353710451697  195.046077230162  0.13704930389979 13.7434999735147
#> x3        -1.5250215000774  95.8810734646578 0.139426736144106 -10.937798174528
#>                p value significance
#> intercept 0.000000e+00          ***
#> x1        0.000000e+00          ***
#> x2        0.000000e+00          ***
#> x3        2.176037e-14             
#> 
#> $corr_table
#>            x1         x2         x3
#> x1  1.0000000  0.2344004 -0.2608428
#> x2  0.2344004  1.0000000 -0.2047026
#> x3 -0.2608428 -0.2047026  1.0000000
#> 
#> $R_square
#>          [,1]
#> [1,] 0.953256
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
#>       3.931        3.183        1.884       -1.525
```

use Rcpp to calculate mean

``` r
lrm(y, x, Rcpp = T)
#> [1] -0.30070085 -0.05100168 -0.16278112
```

Compare with the original function.

``` r
colMeans(x)
#>          x1          x2          x3 
#> -0.30070085 -0.05100168 -0.16278112
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
#> 1 myfunc        938µs      1ms      950.     463KB     10.7
#> 2 lmfunc        738µs    782µs     1261.     124KB     15.0
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
#> 1 rcppfunc    21.71µs   24.1µs    39756.    10.6KB     15.9
#> 2 orginfunc    4.67µs    5.2µs   184318.        0B     36.9
```
