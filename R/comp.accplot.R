#' Accumulation of Occurrences Plot
#'
#' Compare the occurrence-accumulation curves \insertRef{LeavingAreaReceiving}{sdmTools} of different SDM/ENMs for a single species
#'
#' @author Laura Jiménez
#'
#' @param mods list with as much elements as models to be compared, each element must be the resulting matrix of values from the function 'accum.occ' applied to the same occurrence data (first two columns only)
#' @param nocc number of occurrence points
#' @param ncells number of cells in M
#' @param xrange Range of cells. Has value c(0,ncells) by default.
#' @param sp.name character chain with the name of the species under study
#' @param mods.names character vector with the names of the SDMs to be compared, must have the same length as 'mods'
#' @param alpha values between 0 and 1 representing the probability of the CI for the null model
#'
#' @return Plot comparing the accumulation of occurrences of each algorithm.
#' @export
#'
#' @import dismo
#' @import fields
#' @import maptools
#' @importFrom Rdpack reprompt
#'
#' @examples \dontrun{
#' # DO NOT RUN
#' ## Occurrence data ####
#' We'll only use the train data for the AOcCs
#' occ_train <- rgdal::readOGR('data/processed/shapefiles/train.shp')

#' ## Environmental Data #####
#' envpres <- dir(path = 'data/processed/envcropped/Present/', pattern = ".tif$", full.names = T)
#' envpres <- raster::stack(envpres)

#' ## Prediction Data #####
#' # Output from sdm::predict(), saved with terra and with full layer names retained before
#' # saving with names(p_occ) <- p_occ@z$fullname
#'
#' pred_pres <- terra::rast(x = 'data/processed/model-build/predictions/
#'                          predictions.present-all-algorithms.tif')
#' # remember to read with terra:: to retain layer names
#' pred_pres <- raster::stack(pred_pres) # and then turn them into RasterStacks
#'
#' ## AOcCs of models #####
#' # Prepare the data to pass it onto the function:
#' occ.pnts <- sdmTools::sdm_to_occ.pnts(env = envpres,
#'                            occ = occ_train,
#'                            algorithms = c('svm', 'maxent', 'bioclim', 'domain'),
#'                            # list of algorithms used in sdm::sdm()
#'                            predict_object = pred_pres)
#'
#' output.mod <- sdmTools::sdm_to_output.mod(env = envpres,
#'                                 algorithms = c('svm', 'maxent', 'bioclim', 'domain'),
#'                                 predict_object = pred_pres)
#' # The accum.occ function is annoying and creates three different plots in three different devices.
#' # To save them we'll use dev.print() in the reverse order in which they appear. I could automatize
#' # this part of the script but I don't have time for that, I'm sorry dear reader.
#'
#' dev.new() ; dev.control('enable') ; dev.off() # Just enabling device control
#'
#' # WARNING: Before running this next section of the script, make sure nothing
#' # is plotted and no devices are open with dev.list()
#' aocc_svm <- accum.occ(sp.name = 'Charinus',
#'                      output.mod = output.mod[[1]],
#'                      occ.pnts = occ.pnts[[1]],
#'                      null.mod = "hypergeom",
#'                      conlev = 0.05, bios = 0)
#'
#' # To save the plots, we have to do it in the reverse order as they were plotted:
#' dev.print(png, file = "figs/aocc/svm_aocc_aocc.png",
#'           width=8, height=8, units="in", res=300);dev.off()
#'
#' dev.print(png, file = "figs/aocc/svm_aocc_map.png",
#'           width=8, height=8, units="in", res=300);dev.off()
#'
#' dev.print(png, file = "figs/aocc/svm_aocc_env.png",
#'           width=8, height=8, units="in", res=300);dev.off()
#'
#' # Do this for each algorithm and when you have all of them, compare with
#'
#' aocc_list <- list(aocc_svm, aocc_maxent, aocc_bioclim, aocc_domain)
#'
#' model_comp <- comp.accplot(mods = aocc_list,
#'                           nocc = length(occ_train),
#'                           ncells = raster::ncell(envpres),
#'                           sp.name = 'Charinus',
#'                           mods.names = c('svm', 'maxent', 'bioclim', 'domain'), alpha = 0.05)
#' }
#' @references
#'     \insertAllCited{}
#'
comp.accplot <- function(mods,nocc,ncells,xrange=c(0,ncells),sp.name,mods.names,alpha){
  # number of models to compare
  nmods <- length(mods)
  if(length(mods.names==nmods)){
    # calculate the prevalence of the species in M
    preval <- nocc / ncells
    # Plot the curves of the models to be compared
    dev.new()
    plot(0:nocc,0:nocc,type="n",xlim=xrange,ylim=c(0,nocc),
         #main=substitute(expr = italic(tl),env = list(tl=sp.name)),
         xlab="Area (number of cells)",ylab="Number of Occurrences")
    # add the curves for each model and calculate the max value in x-axis
    colmod <- colorRampPalette(c("orange","royalblue"))(nmods)
    pt <- 15:(15+nmods)
    for (i in 1:nmods) {
      lines(mods[[i]][,2],mods[[i]][,1],type="o",pch=pt[i],lwd=2,col=colmod[i])
      #xmax <- c(xmax,modelB[[i]][(nrow(modelB[[i]])-1),2])
    }
    # add the line of random classification and confidence bands
    pnts <- floor(seq(0,xrange[2],length=nocc)) #ifelse(xrange[2]==ncells,ncells,max(xmax[2:nmods]))
    a1 <- (1-alpha)/2
    infs <- qhyper(a1,m=nocc,n=ncells-nocc,k=pnts)
    sups <- qhyper(1-a1,m=nocc,n=ncells-nocc,k=pnts)
    lines(0:ncells,0:ncells*preval,col="red",lwd=2)
    for (j in 1:nocc) {
      segments(pnts[j],infs[j],pnts[j],sups[j],col = "gray")
      points(pnts[j],infs[j],pch=20,col="grey25")
      points(pnts[j],sups[j],pch=20,col="grey25")
    }
    # add a legend to identify the different lines
    legend("bottomright",legend=c(mods.names,"Random counts","Hypergeometric-CI"),
           pch=c(pt,NA,NA),col=c(colmod,"red","gray"),lwd=3)
  } else{
    print("Warning! 'mods' and 'mods.names' should have the same length")
  }
}
