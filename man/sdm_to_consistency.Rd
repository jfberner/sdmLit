% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sdm_to_consistency.R
\name{sdm_to_consistency}
\alias{sdm_to_consistency}
\title{Build Consistency Maps from sdm::prediction() output}
\usage{
sdm_to_consistency(preds, layer)
}
\arguments{
\item{preds}{RasterStack, output from sdm::predict() function.}

\item{layer}{Character or Interger. Layer ID to be used in plotting.}
}
\value{
RasterStack with Consistency Map imposed on the original congruence map from \insertCite{morales-barberoInputMattersMatter2019a}{sdmLit}.
}
\description{
This function builds consistency maps from a set of environmental layers and suitability maps, following  \insertCite{morales-barberoInputMattersMatter2019a}{sdmLit} (Fig.4). The aim of this script is to automatize and make the process more easily reproducible. Moreover, it is intended to be easily implemented with objects from the sdm package.
}
\examples{
\dontrun{
# DO NOT RUN
preds <- terra::rast(x = 'data/processed/final-model-build/
                     predictions/predictions.present-terraStd.tif')
preds <- raster::stack()
consMap <- sdm_to_consistency(preds, 1)
}
}
\references{
\insertRef{morales-barberoInputMattersMatter2019a}{sdmLit}
}
