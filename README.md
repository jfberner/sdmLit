
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sdmTools

<!-- badges: start -->
<!-- badges: end -->

The goal of sdmTools is to … I’ll fill all of this tomorrow :)

## Installation

You can install the development version of sdmTools from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("jfberner/sdmTools")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(sdmTools)
#> Warning: libpodofo.so.0.9.8: não é possível abrir arquivo compartilhado: Arquivo
#> ou diretório inexistente (GDAL error 1)

#> Warning: libpodofo.so.0.9.8: não é possível abrir arquivo compartilhado: Arquivo
#> ou diretório inexistente (GDAL error 1)
#> Warning: libarrow.so.800: não é possível abrir arquivo compartilhado: Arquivo ou
#> diretório inexistente (GDAL error 1)

#> Warning: libarrow.so.800: não é possível abrir arquivo compartilhado: Arquivo ou
#> diretório inexistente (GDAL error 1)

#> Warning: libarrow.so.800: não é possível abrir arquivo compartilhado: Arquivo ou
#> diretório inexistente (GDAL error 1)

#> Warning: libarrow.so.800: não é possível abrir arquivo compartilhado: Arquivo ou
#> diretório inexistente (GDAL error 1)
#> Warning: libpodofo.so.0.9.8: não é possível abrir arquivo compartilhado: Arquivo
#> ou diretório inexistente (GDAL error 1)

#> Warning: libpodofo.so.0.9.8: não é possível abrir arquivo compartilhado: Arquivo
#> ou diretório inexistente (GDAL error 1)
#> Warning: libarrow.so.800: não é possível abrir arquivo compartilhado: Arquivo ou
#> diretório inexistente (GDAL error 1)

#> Warning: libarrow.so.800: não é possível abrir arquivo compartilhado: Arquivo ou
#> diretório inexistente (GDAL error 1)

#> Warning: libarrow.so.800: não é possível abrir arquivo compartilhado: Arquivo ou
#> diretório inexistente (GDAL error 1)

#> Warning: libarrow.so.800: não é possível abrir arquivo compartilhado: Arquivo ou
#> diretório inexistente (GDAL error 1)
#> Warning: replacing previous import 'dismo::points' by 'graphics::points' when
#> loading 'sdmTools'
#> Warning: replacing previous import 'dplyr::union' by 'raster::union' when
#> loading 'sdmTools'
#> Warning: replacing previous import 'dplyr::select' by 'raster::select' when
#> loading 'sdmTools'
#> Warning: replacing previous import 'dplyr::intersect' by 'raster::intersect'
#> when loading 'sdmTools'
#> Warning: replacing previous import 'sdm::density' by 'stats::density' when
#> loading 'sdmTools'
#> Warning: replacing previous import 'raster::weighted.mean' by
#> 'stats::weighted.mean' when loading 'sdmTools'
#> Warning: replacing previous import 'raster::predict' by 'stats::predict' when
#> loading 'sdmTools'
#> Warning: replacing previous import 'raster::aggregate' by 'stats::aggregate'
#> when loading 'sdmTools'
#> Warning: replacing previous import 'dplyr::filter' by 'stats::filter' when
#> loading 'sdmTools'
#> Warning: replacing previous import 'dplyr::lag' by 'stats::lag' when loading
#> 'sdmTools'
#> Warning: replacing previous import 'raster::quantile' by 'stats::quantile' when
#> loading 'sdmTools'
#> Warning: replacing previous import 'raster::update' by 'stats::update' when
#> loading 'sdmTools'
#> Warning: replacing previous import 'raster::tail' by 'utils::tail' when loading
#> 'sdmTools'
#> Warning: replacing previous import 'raster::stack' by 'utils::stack' when
#> loading 'sdmTools'
#> Warning: replacing previous import 'raster::unstack' by 'utils::unstack' when
#> loading 'sdmTools'
#> Warning: replacing previous import 'raster::head' by 'utils::head' when loading
#> 'sdmTools'
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

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/v1/examples>.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
