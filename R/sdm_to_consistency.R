#' Build Consistency Maps from sdm::prediction() output
#'
#' This function builds consistency maps from a set of environmental layers and suitability maps, following Morales-Barbero & Vega-Álvarez (Fig.4). The aim of this script is to automatize and make the process more easily reproducible. Moreover, it is intended to be easily implemented with objects from the sdm package.
#'
#' @param preds RasterStack, output from sdm::predict() function.
#' @param layer Character or Interger. Layer ID to be used in plotting.
#'
#' @return RasterStack with Consistency Map imposed on the original congruence map from \insertRef{InputMattersMatter}{sdmTools}.
#' @export
#'
#' @import climateStability
#' @import classInt
#' @import utils
#' @import raster
#' @import maps
#' @importFrom Rdpack reprompt
#'
#' @examples \dontrun{
#' # DO NOT RUN
#' preds <- terra::rast(x = 'data/processed/final-model-build/
#'                      predictions/predictions.present-terraStd.tif')
#' preds <- raster::stack()
#' consMap <- sdm_to_consistency(preds, 1)
#' }
#' @references
#'     \insertAllCited{}
#'
sdm_to_consistency <- function(preds, layer){
  suitability <- preds[[layer]]
  suitability <- climateStability::rescale0to1(suitability)
  congruence <- data("congruence")
  congruencer<-resample(x=congruence, y=suitability, method="bilinear")
  # Bioclimatic consistency

  # Create a colour matrix for the bivariate map. Specify the number of quantiles, colours and   # labels of the colour matrix.
  # Original code for colmat function from http://rfunctions.blogspot.fi/2015/03/bivariate-maps-bivariatemap-function.html

colmat<-function(nquantiles=10, upperleft="#be64ac", upperright="#3b4994", bottomleft="#e8e8e8", bottomright="#5ac8c8", xlab="x label", ylab="y label"){
    my.data<-seq(0,1,.01)
    my.class<-classIntervals(my.data,n=nquantiles,style="quantile")
    my.pal.1<-findColours(my.class,c(upperleft,bottomleft))
    my.pal.2<-findColours(my.class,c(upperright, bottomright))
    col.matrix<-matrix(nrow = 101, ncol = 101, NA)
    for(i in 1:101){
      my.col<-c(paste(my.pal.1[i]),paste(my.pal.2[i]))
      col.matrix[102-i,]<-findColours(my.class,my.col)}
    plot(c(1,1),pch=19,col=my.pal.1, cex=0.5,xlim=c(0,1),ylim=c(0,1),frame.plot=F, xlab=xlab, ylab=ylab,cex.lab=1.3)
    for(i in 1:101){
      col.temp<-col.matrix[i-1,]
      points(my.data,rep((i-1)/100,101),pch=15,col=col.temp, cex=1)}
    seqs<-seq(0,100,(100/nquantiles))
    seqs[1]<-1
    col.matrix<-col.matrix[c(seqs), c(seqs)]}

  # Get colour matrix with 5 quantiles and legend. Specify the number of quantiles, colours and   # labels of the colour legend.
  col.matrix<-colmat(nquantiles=5,
                     upperleft="#be64ac",
                     upperright="#3b4994",
                     bottomleft="#e8e8e8",
                     bottomright="#5ac8c8",
                     xlab="Habitat suitability",
                     ylab="Bioclimatic congruence")

  # Run this function to generate consistency maps.

  bivariate.map<-function(rasterx, rastery, colormatrix=col.matrix, nquantiles=10){
    quanmean<-getValues(rasterx)
    temp<-data.frame(quanmean, quantile=rep(NA, length(quanmean)))
    brks<-with(temp, quantile(temp,na.rm=TRUE, probs = c(seq(0,1,1/nquantiles))))
    r1<-within(temp, quantile <- cut(quanmean, breaks = brks, labels = 2:length(brks),include.lowest = TRUE))
    quantr<-data.frame(r1[,2])
    quanvar<-getValues(rastery)
    temp<-data.frame(quanvar, quantile=rep(NA, length(quanvar)))
    brks<-with(temp, quantile(temp,na.rm=TRUE, probs = c(seq(0,1,1/nquantiles))))
    r2<-within(temp, quantile <- cut(quanvar, breaks = unique(brks), labels = 2:length(unique(brks)),include.lowest = TRUE))
    quantr2<-data.frame(r2[,2])
    as.numeric.factor<-function(x) {as.numeric(levels(x))[x]}
    col.matrix2<-col.matrix
    cn<-unique(col.matrix)
    for(i in 1:length(col.matrix2)){
      ifelse(is.na(col.matrix2[i]),col.matrix2[i]<-1,col.matrix2[i]<-which(col.matrix2[i]==cn)[1])}
    cols<-numeric(length(quantr[,1]))
    for(i in 1:length(quantr[,1])){
      a<-as.numeric.factor(quantr[i,1])
      b<-as.numeric.factor(quantr2[i,1])
      cols[i]<-as.numeric(col.matrix2[b,a])}
    r<-rasterx
    r[1:length(r)]<-cols
    return(r)}

  bivmap<-bivariate.map(suitability,congruencer,colormatrix=col.matrix, nquantiles=5)

  plot(bivmap,frame.plot=F,axes=F,box=F,add=F,legend=F,col=as.vector(col.matrix))

  map(interior=T,add=T)

  return(bivmap)
}
