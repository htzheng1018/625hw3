
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

Call our function

``` r
lrm(y, x)
#> $mean_x
#> [1] -0.03980453
#> 
#> $smry
#>                        beta       partial sse       se beta_hat
#> intercept  4.21549110137113 -753.019671033192 0.161369209213496
#> x1         2.81579243039914  400.835124857333 0.155920062090442
#> x2         1.99145439102231  219.118538569371 0.170996770563359
#> x3        -1.36447773591242  76.1107527549014 0.174032928800899
#>                     t value      p value significance
#> intercept  26.1232680132547 0.000000e+00          ***
#> x1         18.0592054200557 0.000000e+00          ***
#> x2         11.6461520557455 2.664535e-15             
#> x3        -7.84034231518014 5.089902e-10             
#> 
#> $corr_table
#>            x1          x2          x3
#> x1 1.00000000  0.01436727  0.03125442
#> x2 0.01436727  1.00000000 -0.18219815
#> x3 0.03125442 -0.18219815  1.00000000
#> 
#> $R_square
#>           [,1]
#> [1,] 0.9243642
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
#>       4.215        2.816        1.991       -1.364
```

use Rcpp to calculate mean

``` r
lrm(y, x, Rcpp = T)
#> [1]  0.1109601 -0.1073051 -0.1230686
```

Compare with the original function.

``` r
colMeans(x)
#>         x1         x2         x3 
#>  0.1109601 -0.1073051 -0.1230686
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
#> 1 myfunc        926µs      1ms      953.     463KB     10.6
#> 2 lmfunc        741µs    775µs     1279.     124KB     15.0
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
#> 1 rcppfunc    21.91µs  24.13µs    40818.    10.6KB     16.3
#> 2 orginfunc    4.72µs   5.35µs   160926.        0B     32.2
```
