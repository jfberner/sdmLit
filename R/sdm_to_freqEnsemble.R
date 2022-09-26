# --------------------------------------------------#
# Ensemble by Frequency
#
#
#
# First version: 14 September 2022
# Author: João Frederico Berner
# --------------------------------------------------#

#' Frequency Ensemble from sdm::sdm() and sdm::predict()
#'
#'  This function reproduces the methods from Sobral-Souza and Prasniewski, in which ensembling by the frequency among model predictions is made. For more information please consult the literature in \insertRef{sobral-souzaSpeciesExtinctionRisk2015}{sdmTools} or \insertRef{dasilveiraFutureClimateChange2021}{sdmTools}.
#'
#' @param model Model object as output from sdm() function or written/read with sdm::read.sdm().
#' @param preds Prediction Object Output, with two observations: first, for it to have species names and algorithm names in the layer names, you have to run  ```names(p_occ) <- p_occ@z$fullname ``` and second, you have to save (and later read it) it with the terra package to retain layer names ```p_occ_stack <- raster::stack(p_occ) ; p_occ_spatraster <- terra::rast(p_occ) ; names(p_occ_spatraster) <- names(p_occ_stack) ; terra::writeRaster(x = p_occ_spatraster, filename = 'data/processed/final-model-build/predictions/predictions.present-terraStd.tif', overwrite = TRUE)```
#' @param species Character. Names of the species as they appear in layer names.
#'
#' @return A RasterStack with one layer, ensembled all models present in 'model' and 'preds' by frequency of presences as of threshold max(sp+se). See  Sobral-Souza, Francini & Lima-Ribeiro (2015), or Da Silveira et al. (2021) for details.
#' @export
#'
#' @import tidyverse
#' @import raster
#' @import sdm
#' @import ggplot2
#' @import stringr
#' @importFrom Rdpack reprompt
#'
#' @examples \dontrun{
#' ## DO NOT RUN
#' library(raster);library(sdm);library(dplyr);library(ggplot2)
#' model <- sdm::read.sdm("data/processed/model-build/model-object/model.sdm")
#' pocc <- terra::rast('data/processed/model-build/predictions/predictions.present-all-algorithms.tif')
#' preds <- raster::stack(pocc)
#' teste <- sdm_to_freqEnsemble(model, preds, c('charinus')) }
#' @references
#'     \insertAllCited{}
#'
sdm_to_freqEnsemble <- function(model, preds, species){
  evaluation <- sdm::getEvaluation(x = model, p = preds, wtest = 'test.dep', species = species, index = T, stat = c('AUC', 'COR', 'TSS', 'threshold'), opt = 2) # opt = 2 = max(se + sp)

  eval <- cbind(evaluation, model@run.info['species'], model@run.info['method'])

  names(eval)[names(eval) == 'method'] <- 'algorithm' ; names(eval)[names(eval) == 'threshold'] <- 'thrs' ; names(eval)[names(eval) == 'modelID'] <- 'replica'

  tif <- preds
  enm <- preds[[1]]
  csv <- eval

  ## frequency ensemble
  # species
sp <- csv %>%
    dplyr::select(species) %>%
    dplyr::distinct() %>%
    dplyr::pull()

  # algorithms
  al <- csv %>%
    dplyr::select(algorithm) %>%
    dplyr::distinct() %>%
    dplyr::pull() %>%
    stringr::str_replace("_", "")

  # ensembles
  ens <- enm
  ens[] <- 0

  # for
  for(i in sp){

    # select model by species
    tif.sp <- grep(i, names(tif), value = TRUE)
    eva.sp <- csv %>% dplyr::filter(species == i)

    # information
    print(paste0("The ensemble for ", i, " started, relax, take a coffee, it may take awhile..."))


    for(j in al){

      # select model by algorithms
      tif.al <- grep(j, tif.sp, value = TRUE)
      eva.al <- eva.sp %>% dplyr::filter(algorithm == j) %>% dplyr::select(species, replica, algorithm, thrs, AUC, TSS) %>% as_tibble()

      # information
      print(paste0("The ensemble for '", i, "', algorithm '", j, "' are going!"))

      # import raster
      enm.al <- stack(tif[[tif.al]])


      for(k in seq(length(tif.al))){

        # sum
        ens <- sum(ens, enm.al[[1]] >= eva.al[1, 4] %>% dplyr::pull())

      }

    }

    # export
    x <- raster()
    names(ens) <- paste0("ensemble_freq_", i,".tif")
    y <- raster::addLayer(x, ens / (length(tif.sp)))

    # information
    print(paste0("Nice! The ensemble of ", i, " it's done!"))

    ens[] <- 0

  }

  print("Yeah! It's over!!!")

  return(y)

}



# TO DO:

# FIX NAMES OF terraStd AND rasterStd IN ALL SCRIPTS
# RE-RUN ALL SCRIPTS WITH ANALYSES AND EVALS BECAUSE YOU ADDED ALGORITHMS
# PICK OTHER ALGORITHMS AND ETC