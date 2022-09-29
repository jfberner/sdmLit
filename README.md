
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sdmTools

#### Author: João Frederico Berner

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

There are four currently working “branches/tools” in the package.
Namely,

1.  **Boyce Index** [(Hirzel, Le Lay, Helfer, Randin, & Guisan,
    2006)](https://doi.org/10.1016/j.ecolmodel.2006.05.017) , with the
    function `sdm_to_boyceIndex()`;
2.  **Consistency/Congruence Maps** [(Morales-Barbero & Vega-Álvarez,
    2019)](https://doi.org/10.1111/2041-210X.13124) with the function
    `sdm_to_consistency()`. [Original source code
    here](https://besjournals.onlinelibrary.wiley.com/action/downloadSupplement?doi=10.1111%2F2041-210X.13124&file=mee313124-sup-0002-AppendixB_Rcode.R).
    I intend to allow new congruence maps to be created from a set of
    environmental predictors with a new function in the near future, but
    for now only the [original congruence
    map](https://doi.org/10.5061/dryad.6kv7k29) is available;
    (authorization pending)
3.  **Accumulation of Occurrences Curve** [(Jiménez & Soberón,
    2020)](https://doi.org/10.1111/2041-210X.13479) with the functions
    `sdm_to_occ.pnts()` and `sdm_to_output.mods()`, to be passed onto
    the [original functions](https://github.com/LauraJim/SDM-hyperTest)
    `accum.occ()`, and later `comp.accplot()`
    [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3981453.svg)](https://doi.org/10.5281/zenodo.3981453).
4.  **Frequency Ensemble** [(Sobral-Souza, Francini, & Lima-Ribeiro,
    2015)](https://doi.org/10.1016/j.ncon.2015.11.009) with functions
    `sdm_to_freqEnsemble()` and `frequency_ensemble_plot()`. The
    approach is the same as in the paper, but the code I got from a
    class I had with one of the authors (authorization pending).

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

## Examples

### Base Objects

###### Disclaimer

- The following are the basic objects that are going to be used in all
  the examples. They are not meant to be fully reproducible, as species
  data, variable and algorithm selection vary considerably and should be
  picked according to each dataset and objectives. Instead, I intend to
  briefly take the reader through the process of creating an ENM with
  the sdm package solely for clarifying what each object is (or is
  supposed to be).

- Details on the nature and origin of the datasets should not be
  important for the use of this package’s functions.

- Mind that some lines of the code are a MUST if one’s to implement my
  functions, and they are described as such.

The **‘species’** I’m using here is going to be called ‘charinus’. It is
not a species, but is a model from another project I have easy at hand.
I will not be sharing the dataset. I have two datasets: one called
`occ_train` (with model training data) and another called `occ_test`
(with model test data, which includes absence records). These objects
are SpatialPointsDataFrame(s).

``` r
# The following are shapefiles (.shp) being loaded:
occ_train <- rgdal::readOGR('data/processed/shapefiles/train.shp')
occ_test <- rgdal::readOGR('data/processed/shapefiles/test.shp')
```

``` r
# As SpatialPointsDataFrame
class(occ_train)
#> [1] "SpatialPointsDataFrame"
#> attr(,"package")
#> [1] "sp"
```

**Climate Data** (predictors) are four uncorrelated bioclimatic
variables from [BioClim v2.1](https://www.worldclim.org). In the code
they’ll be called `envpres`, refferring to ‘present’ climate (average
from 1970-2000, more on this on worldclim’s website linked above).

``` r
envpres <- dir(path = 'data/processed/envcropped/Present/', pattern = ".tif$", full.names = T)

envpres <- raster::stack(envpres)
```

``` r
class(envpres)
#> [1] "RasterStack"
#> attr(,"package")
#> [1] "raster"
```

I’ll be using four **algorithms** in my all of the examples: SVM,
MaxEnt, BioClim and Domain. References for those can be found in [e.g.
Sobral-Souza et al. (2015)](https://doi.org/10.1016/j.ncon.2015.11.009),
I will not go into details here.

``` r
# Saving algorithm list can make life easier, for at least a couple reasons: 
# it retains the order in which they are modeled inside the sdm::sdm() function to be used in sdmTools functions, 
# and it saves you from re-typing them everytime.

algorithms <- c('svm', 'maxent', 'bioclim', 'domain') # order will be important
```

The **Model** will (naturally) be constructed using the sdm package.
Details on sdm package usage can be found
[here](https://www.youtube.com/watch?v=83dMS3bcjJM) in video format and
[here](https://github.com/babaknaimi/sdm) is the github of the package.
I won’t go into further, unnecessary details.

First, we prepare the data:

``` r
d_occ <- sdm::sdmData(formula = charinus~., train=occ_train,
                 predictors = envpres, bg = 18, # same number as occurrences
                 method = 'eRandom') # Create sdmData object
# eRandom = random in Environmental Space
```

Then we run the models:

``` r
m_occ <- sdm::sdm(formula = charinus~.,data = d_occ,
              methods = algorithms,
                           replication = c('bootstrapping'), n=5)
```

This `m_occ` object is our sdmModel object, and it’ll be often used.

Finally, we **predict** using built models:

``` r
p_occ <- sdm::predict(m_occ, newdata = envpres, # new data is the environment in which we want to predict
                 filename = 'data/processed/model-build/predictions/predictions.present-rasterStd.tif',
                 prj = T, overwrite = T, nc = 7)

# This creates a file in the specified folder BUT the file doesn't retain the layer names, which will be super important for us to distinguish among methods. To do so:
```

This will save the predictions as a raster file. However, **layer names
WILL NOT BE RETAINED**. Not only is retaining layer names extremely
important to implement the functions of sdmTools package, it will make
it easier for the user/researcher to distinguish them later. **To retain
them**, simply:

``` r
# The next line grabs the 'fullname' inside the p_occ object
names(p_occ) <- p_occ@z$fullname # This is SUPER important. It ensure both SPECIES and ALGORITHM names are retained in layer names

p_occ_stack <- raster::stack(p_occ) #convert rasterBrick to rasterStack
p_occ_spatraster <- terra::rast(p_occ_stack) #convert rasterStack to SpatRaster
names(p_occ_spatraster) <- names(p_occ_stack) #grab the names again, because in converting the terra::rast() function grabs the names from the .tif file that p_occ refers to.

terra::writeRaster(x = p_occ_spatraster, 
                    filename = 'data/processed/model-build/predictions/predictions.present-terraStd.tif',
                    overwrite = TRUE) # Using terra package because it retains layer names
```

When you read your predictions raster file, make sure to so using the
terra package and then converting it to a RasterStack to retain sdm
package standards (not required, but I haven’t tested).

``` r
pocc <- terra::rast(x = 'data/processed/model-build/predictions/predictions.present-terraStd.tif')
pocc <- raster::stack()
```

**Note:** there are now **two different prediction objects**, and they
are **significantly different**. The object `p_occ` is the one
originally obtained from the sdm::predict() function, and `pocc` is the
one read from the terra package. Since is always best practice to have
separate scripts for different steps in modelling **I’ll be using `pocc`
for all functions from here on**.

And these are all the objects we need to implement the functions of the
sdmTools package: `occ_train`, `occ_test`, `envpres`, `m_occ` and
`pocc`. The following sections will be examples of how to use the
functions and a brief description, in my words, of when to use them.

### Boyce Index

The Continuous Boyce Index [Hirzel et al.
(2006)](https://doi.org/10.1016/j.ecolmodel.2006.05.017) is a
threshold-independent evaluator for models. It provides
predicted-to-expected ratio curves that offer further insights into the
model quality: robustness, habitat suitability resolution and deviation
from randomness. This information helps reclassifying predicted maps
into meaningful habitat suitability classes.

When absence data are unreliable or unavailable, the model evaluation
should be assessed for presences only. Two simple evaluators are the
absolute validation index (AVI) and contrast validation index (CVI), but
both rely on fixed thresholds. [Boyce, Vernier, Nielsen, & Schmiegelow
(2002)](https://doi.org/10.1016/S0304-3800(02)00200-4) proposed a way to
relieve somewhat the threshold constraint. Their method consists in
partitioning the habitat suitability range into *b* classes (or bins),
instead of only two. The main shortcoming of the Boyce index is its
sensitivity to the number of suitability classes *b* and to their
boundaries.

To overcome this problem, [Hirzel et al.
(2006)](https://doi.org/10.1016/j.ecolmodel.2006.05.017) derived a new
evaluator based on a “moving window” of width W (say W = 0.1) instead of
fixed classes.

The continuous Boyce index is thus both a complement to usual evaluation
of presence/absence models and a reliable measure of presence-only based
predictions.

Usage is as follows:

``` r
library(sdmTools)
boyce.output <- sdm_to_boyceIndex(preds = pocc, layer = mean(1:5), occurrence = occ_test)
# preds = pocc NOTE that it is NOT p_occ, refer to the text above for the difference.
# layer = mean(1:5) will take the mean of the first five layers, in this case the five SVM models
```

The sdm_to_boyceIndex relies on ecospat::ecospat.boyce() and simply
passes the arguments onto this function. Any additional arguments can be
passed onto it and reading its help is strongly suggested (run
`?ecospat::ecospat.boyce()` in R Console).

# References

<div id="refs" class="references csl-bib-body hanging-indent"
line-spacing="2">

<div id="ref-boyceEvaluatingResourceSelection2002" class="csl-entry">

Boyce, M. S., Vernier, P. R., Nielsen, S. E., & Schmiegelow, F. K. A.
(2002). Evaluating resource selection functions. *Ecological Modelling*,
*157*(2), 281–300. doi:
[10.1016/S0304-3800(02)00200-4](https://doi.org/10.1016/S0304-3800(02)00200-4)

</div>

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

<div id="ref-sobral-souzaSpeciesExtinctionRisk2015" class="csl-entry">

Sobral-Souza, T., Francini, R. B., & Lima-Ribeiro, M. S. (2015). Species
extinction risk might increase out of reserves: Allowances for
conservation of threatened butterfly Actinote quadra (Lepidoptera:
Nymphalidae) under global warming. *Natureza & Conservação*, *13*(2),
159–165. doi:
[10.1016/j.ncon.2015.11.009](https://doi.org/10.1016/j.ncon.2015.11.009)

</div>

</div>
