
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mlrmodel

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/htzheng1018/625hw3/branch/main/graph/badge.svg)](https://app.codecov.io/gh/htzheng1018/625hw3?branch=main)
[![R-CMD-check](https://github.com/htzheng1018/625hw3/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/htzheng1018/625hw3/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of mypackage is to fit a multiple linear regression using
matrix calculations. It contains a virtual dataset with y and x, which
are created by random variables. Using this model, we can estimate the
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
#> [1] 0.04487539
#> 
#> $smry
#>                        beta       partial sse       se beta_hat
#> intercept  3.95197393629873 -740.543377602071 0.107905242788902
#> x1         2.91207148337092  449.752629915167 0.100718620960364
#> x2         2.01569866736167  179.199716454656 0.113475228094789
#> x3        -1.40355410239345  85.1623161327073 0.115282804898289
#>                     t value      p value significance
#> intercept  36.6244849106181 0.000000e+00          ***
#> x1         28.9129403838532 0.000000e+00          ***
#> x2         17.7633365555158 0.000000e+00          ***
#> x3        -12.1748781497098 4.440892e-16             
#> 
#> $corr_table
#>            x1         x2         x3
#> x1 1.00000000 0.09047979 0.37572537
#> x2 0.09047979 1.00000000 0.04181908
#> x3 0.37572537 0.04181908 1.00000000
#> 
#> $R_square
#>           [,1]
#> [1,] 0.9643117
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
#>       3.952        2.912        2.016       -1.404
```

use Rcpp to calculate mean

``` r
lrm(y, x, Rcpp = T)
#> [1] -0.002068075  0.035904456  0.100789805
```

Compare with the original function.

``` r
colMeans(x)
#>           x1           x2           x3 
#> -0.002068075  0.035904456  0.100789805
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
#> 1 myfunc        927µs    993µs      946.     463KB     10.7
#> 2 lmfunc        740µs    776µs     1279.     124KB     15.0
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
#> 1 rcppfunc    21.84µs   24.1µs    38968.    10.6KB     15.6
#> 2 orginfunc    4.59µs   5.15µs   184733.        0B     37.0
```
