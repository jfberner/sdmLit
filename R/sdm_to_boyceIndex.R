#' Boyce Index from sdm::predict() Output
#'
#' This function simply converts the output from the sdm package to the Boyce Index \insertCite{hirzelEvaluatingAbilityHabitat2006}{sdmLit} using the function from the ecospat package.
#'
#' @param preds RasterStack. Output from sdm::predict().
#' @param layer String, Function or Interger. If string, name of the layer to be used exactly as found on the preds layer. If an Interger, the number of the layer to be used. Can be a function e.g. mean(2:5), which will average the layers and then perform the analyses.
#' @param occurrence Either a SpatialPointsDataFrame or a data.frame. If a data.frame, x and y (lat and long) coordinates of the occurrence records as two separate collumns. Usually used with the test data, instead of the train data.
#' @param ... additional arguments to be passed onto ecospat.boyce()
#'
#' @return A list, and by default PEplot is plotted to the device. List contains three items: F.ratio, cor and HS. For more information please refer to \insertCite{hirzelEvaluatingAbilityHabitat2006}{sdmLit} or to the ecospat.boyce() help (linked below).
#' @export
#'
#' @seealso [ecospat::ecospat.boyce()] which this function wraps.
#'
#' @examples
#' occ_test <- rgdal::readOGR('data/processed/shapefiles/test.shp')
#' occ <- as.data.frame(occ_test)
#' pred_pres <- terra::rast(x = 'data/processed/model-build/predictions/predictions.present-terraStd.tif') # remember to read with terra:: to retain layer names
#' pred_pres <- raster::stack(pred_pres) # and then turn them into RasterStacks
#'
#' teste <- sdm_to_boyceIndex(pred_pres, mean(2:5), occ[,2:3])
#'
#' @references
#' \insertRef{hirzelEvaluatingAbilityHabitat2006}{sdmLit}
#'
sdm_to_boyceIndex <- function(preds, layer, occurrence, ...){
  fit <- preds[[layer]]
  if (class(occurrence) == "SpatialPointsDataFrame") {
    obs <- as.data.frame(occurrence)[,2:3]
  }
  else obs <- occurrence
  x <- ecospat::ecospat.boyce(fit = fit, obs = obs, PEplot = T, ...)
  return(x)
}
