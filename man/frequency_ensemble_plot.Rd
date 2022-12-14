% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/frequency_ensemble_plot.R
\name{frequency_ensemble_plot}
\alias{frequency_ensemble_plot}
\title{Plot Frequency Ensemble}
\usage{
frequency_ensemble_plot(freq_object)
}
\arguments{
\item{freq_object}{RasterStack, output from sdm_to_freqEnsemble() function, plotted with ggplot2.}
}
\value{
A ggplot2 object.
}
\description{
This function aims to reproduce the exact plotting theme and configurations as in \insertCite{sobral-souzaSpeciesExtinctionRisk2015}{sdmLit}. The function takes the output from sdm_frequency_ensemble() and plots it in those configurations. ggplot2 is used. Othewise the output is simply a rasterStack and can be plotted in any other preferred way.
}
\examples{
\dontrun{
## DO NOT RUN
library(raster);library(sdm);library(dplyr);library(ggplot2)
model <- sdm::read.sdm("data/processed/model-build/model-object/model.sdm")
pocc <- terra::rast('data/processed/model-build/predictions/predictions.present-all-algorithms.tif')
preds <- raster::stack(pocc)
source('R/sdm_to_freqEnsemble')
teste <- sdm_to_freqEnsemble(model, preds, c('charinus'))
frequency_ensemble_plot(teste) }
}
\references{
\insertRef{sobral-souzaSpeciesExtinctionRisk2015}{sdmLit}
}
