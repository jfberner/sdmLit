#' Congruence Map
#'
#' Map of bioclimatic congruence (congruence.grd) from \insertRef{InputMattersMatter}{sdmTools}.
#'
#' @format A RasterStack of global-scale bioclimatic congruence map to analyse environmental mismatches between recently updated bioclimatic databases [WorldClim v. 2](www.worldclim.org/version2),MERRAclim (\insertRef{c.vegaMERRAclimHighresolutionGlobal2017}{sdmTools} , \insertRef{c.vegaMERRAclimHighresolutionGlobal2017a}{sdmTools}), [CHELSA](www.chelsa-climate.org), and ocean databases [MARSPEC](www.marspec.org) and [Bio-ORACLE v. 2.0](www.bio-oracle.org):
#'  \describe{
#'  \item{\code{class}}{RasterLayer}
#'  \item{\code{dimensions}}{1080, 2160, 2332800  (nrow, ncol, ncell)}
#'  \item{\code{resolution}}{0.1666667, 0.1666667  (x, y)}
#'  \item{\code{extent}}{180, 180, -90, 90  (xmin, xmax, ymin, ymax)}
#'  \item{\code{crs}}{NA}
#'  \item{\code{source}}{inst/extdata/congruence.grd}
#'  \item{\code{names}}{congruence}
#'  \item{\code{values}}{0, 1  (min, max)}
#'}
#' @source \url{https://datadryad.org/stash/dataset/doi:10.5061/dryad.6kv7k29/}
#'
#' @references
#' \insertAllCited{}
"congruence"
