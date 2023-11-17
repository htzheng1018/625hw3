
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mlrmodel

<!-- badges: start -->
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
#> [1] 0.001095871
#> 
#> $smry
#>                        beta       partial sse       se beta_hat
#> intercept    4.280605218811 -622.572618634865 0.150028969207522
#> x1         2.96514432375021  316.750385042125 0.170525770168378
#> x2         2.14367567529067  117.265166292354 0.171367735428449
#> x3        -1.69889984281764  136.793349663655 0.154088099245864
#>                     t value      p value significance
#> intercept  28.5318578233382 0.000000e+00          ***
#> x1         17.3882476579487 0.000000e+00          ***
#> x2         12.5092140007051 2.220446e-16             
#> x3        -11.0255097644294 1.665335e-14             
#> 
#> $corr_table
#>             x1         x2          x3
#> x1  1.00000000 -0.1122868 -0.06336296
#> x2 -0.11228679  1.0000000  0.23967993
#> x3 -0.06336296  0.2396799  1.00000000
#> 
#> $R_square
#>           [,1]
#> [1,] 0.9168551
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
#>       4.281        2.965        2.144       -1.699
```

use Rcpp to calculate mean

``` r
lrm(y, x, Rcpp = T)
#> [1] -0.007595435  0.006819126  0.004063922
```

Compare with the original function.

``` r
colMeans(x)
#>           x1           x2           x3 
#> -0.007595435  0.006819126  0.004063922
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
#> 1 myfunc        944µs   1.01ms      945.     463KB     10.7
#> 2 lmfunc        750µs 796.51µs     1244.     124KB     15.1
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
#> 1 rcppfunc    21.69µs  24.25µs    39318.    10.6KB     15.7
#> 2 orginfunc    4.68µs   5.28µs   175535.        0B     17.6
```
