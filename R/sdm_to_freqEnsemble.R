#' Frequency Ensemble from sdm::sdm() and sdm::predict()
#'
#'  This function reproduces the methods from Sobral-Souza and Prasniewski, in which ensembling by the frequency among model predictions is made. For more information please consult the literature in \insertCite{sobral-souzaSpeciesExtinctionRisk2015}{sdmTools} or \insertCite{dasilveiraFutureClimateChange2021}{sdmTools}.
#'
#' @param model Model object as output from sdm() function or written/read with sdm::read.sdm().
#' @param preds Prediction Object Output, with two observations: first, for it to have species names and
#'  algorithm names in the layer names, you have to run  ```names(p_occ) <- p_occ@z$fullname ``` and second,
#'  you have to save (and later read it) it with the terra package to retain layer names
#'  ```p_occ_stack <- raster::stack(p_occ) ; ```
#'  ```p_occ_spatraster <- terra::rast(p_occ) ; ```
#'  ```names(p_occ_spatraster) <- names(p_occ_stack) ; ```
#'  ```terra::writeRaster(x = p_occ_spatraster, ```
#'  ```                   filename = 'data/processed/final-model-build/predictions/predictions.present-terraStd.tif', overwrite = TRUE)```
#' @param species Character. Names of the species as they appear in layer names.
#'
#' @param threshold Interger. Which parameter to use as threshold for binarizing the predictions. The possible value can be between 1 to 10 for "sp=se", "max(se+sp)", "min(cost)", "minROCdist", "max(kappa)", "max(ppv+npv)", "ppv=npv", "max(NMI)", "max(ccr)", "prevalence" criteria, respectively. For more information, see [sdm::getEvaluation()].
#'
#' @return A RasterStack with one layer, ensembled all models present in 'model' and 'preds' by frequency of presences as of threshold max(sp+se). See  \insertCite{sobral-souzaSpeciesExtinctionRisk2015}{sdmTools} or \insertCite{dasilveiraFutureClimateChange2021}{sdmTools} for details.
#' @export
#'
#' @import tidyverse
#' @import raster
#' @import sdm
#' @import ggplot2
#' @import stringr
#' @importFrom Rdpack reprompt
#'
#' @seealso [sdm::getEvaluation()]
#'
#' @examples \dontrun{
#' ## DO NOT RUN
#' library(raster);library(sdm);library(dplyr);library(ggplot2)
#' model <- sdm::read.sdm("data/processed/model-build/model-object/model.sdm")
#' pocc <- terra::rast('data/processed/model-build/predictions/predictions.present-terraStd.tif')
#' preds <- raster::stack(pocc)
#' teste <- sdm_to_freqEnsemble(model, preds, c('charinus'), 1) }
#' @references
#' \insertRef{sobral-souzaSpeciesExtinctionRisk2015}{sdmTools}
#'
#' \insertRef{dasilveiraFutureClimateChange2021}{sdmTools}
#'

sdm_to_freqEnsemble <- function(model, preds, species, threshold){
  evaluation <- sdm::getEvaluation(x = model, p = preds, wtest = 'test.dep', species = species, index = T, stat = c('AUC', 'COR', 'TSS', 'threshold'), opt = threshold) # opt = 2 = max(se + sp)

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

