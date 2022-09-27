
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sdmTools

## Author: João Frederico Berner

<!-- badges: start -->

[![R-CMD-check](https://github.com/jfberner/jfbpack/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/jfberner/jfbpack/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of sdmTools is to allow easy implementation of methods not
implemented in the sdm package, using the standard outputs of the sdm::
functions. The methods are all described in the literature, and are
usually not compiled in any single package, which leads to very long
coding and implementing sessions. The author felt ENM analyses and
mapping currently sparsed in the literature could be centralized in a
single package.

There are three currently working “branches” in the package. Namely, 1)
Boyce Index Hirzel, Le Lay, Helfer, Randin, & Guisan (2006), 2)
consistency/congruence maps Morales-Barbero & Vega-Álvarez (2019) and 3)
Accumulation of Occurrences Curve Jiménez & Soberón (2020).

Below, I do my best to explain when/why use each of these and give
examples of usage with the standard outputs from the sdm package, mainly
from sdm() and predict().

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
#> Warning: libthrift-0.16.0.so: não é possível abrir arquivo compartilhado:
#> Arquivo ou diretório inexistente (GDAL error 1)

#> Warning: libthrift-0.16.0.so: não é possível abrir arquivo compartilhado:
#> Arquivo ou diretório inexistente (GDAL error 1)
#> Warning: libpodofo.so.0.9.8: não é possível abrir arquivo compartilhado: Arquivo
#> ou diretório inexistente (GDAL error 1)

#> Warning: libpodofo.so.0.9.8: não é possível abrir arquivo compartilhado: Arquivo
#> ou diretório inexistente (GDAL error 1)
#> Warning: libthrift-0.16.0.so: não é possível abrir arquivo compartilhado:
#> Arquivo ou diretório inexistente (GDAL error 1)

#> Warning: libthrift-0.16.0.so: não é possível abrir arquivo compartilhado:
#> Arquivo ou diretório inexistente (GDAL error 1)
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

<div id="refs" class="references csl-bib-body hanging-indent"
line-spacing="2">

<div id="ref-hirzelEvaluatingAbilityHabitat2006" class="csl-entry">

Hirzel, A. H., Le Lay, G., Helfer, V., Randin, C., & Guisan, A. (2006).
Evaluating the ability of habitat suitability models to predict species
presences. *Ecological Modelling*, *199*(2), 142–152. doi:
[10.1016/j.ecolmodel.2006.05.017](https://doi.org/10.1016/j.ecolmodel.2006.05.017)

</div>

<div id="ref-jimenezLeavingAreaReceiving2020a" class="csl-entry">

Jiménez, L., & Soberón, J. (2020). Leaving the area under the receiving
operating characteristic curve behind: An evaluation method for species
distribution modelling applications based on presence-only data.
*Methods in Ecology and Evolution*, *11*(12), 1571–1586. doi:
[10.1111/2041-210X.13479](https://doi.org/10.1111/2041-210X.13479)

</div>

<div id="ref-morales-barberoInputMattersMatter2019a" class="csl-entry">

Morales-Barbero, J., & Vega-Álvarez, J. (2019). Input matters matter:
Bioclimatic consistency to map more reliable species distribution
models. *Methods in Ecology and Evolution*, *10*(2), 212–224. doi:
[10.1111/2041-210X.13124](https://doi.org/10.1111/2041-210X.13124)

</div>

</div>
