#' Plot Frequency Ensemble
#'
#' This function aims to reproduce the exact plotting theme and configurations as in \insertRef{sobral-souzaSpeciesExtinctionRisk2015}{sdmTools}. The function takes the output from sdm_frequency_ensemble() and plots it in those configurations. ggplot2 is used. Othewise the output is simply a rasterStack and can be plotted in any other preferred way.
#'
#' @param freq_object RasterStack, output from sdm_to_freqEnsemble() function, plotted with ggplot2.
#'
#' @return A ggplot2 object.
#' @export
#'
#' @import colorRamps
#' @import graphics
#' @import tibble
#' @import grDevices
#' @import stats
#' @import raster
#' @importFrom Rdpack reprompt
#'
#' @examples \dontrun{
#' ## DO NOT RUN
#' library(raster);library(sdm);library(dplyr);library(ggplot2)
#' model <- sdm::read.sdm("data/processed/model-build/model-object/model.sdm")
#' pocc <- terra::rast('data/processed/model-build/predictions/predictions.present-all-algorithms.tif')
#' preds <- raster::stack(pocc)
#' source('R/sdm_to_freqEnsemble')
#' teste <- sdm_to_freqEnsemble(model, preds, c('charinus'))
#' frequency_ensemble_plot(teste) }
#' @references
#'     \insertAllCited{}
#'

frequency_ensemble_plot <- function(freq_object){
  for (i in length(names(freq_object))) {
    z <- ggplot(data = raster::rasterToPoints(freq_object[[i]]) %>% tibble::as_tibble(), aes(x, y)) +
      geom_raster(aes_string(fill = colnames(raster::rasterToPoints(freq_object[[i]]) %>% tibble::as_tibble())[3])) +
      scale_fill_gradientn(colours = colorRamps::matlab.like2(100)) +
      theme_minimal() +
      theme(legend.title = element_blank())}
  return(z)
}
