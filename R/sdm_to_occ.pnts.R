#' sdm to occ.pnts object
#'
#' @author João Frederico Berner
#'
#' @description This function takes the output from the sdm::predict() function, along with the used occurrence data used in model build, and environmental data used in predict() and makes a list of data.frames, one data.frame for each algorithm, in the occ.pnts format required by the accum.occ() function from \insertCite{jimenezLeavingAreaReceiving2020a}{sdmLit}.
#'
#' @param env RasterStack used as newdata= in sdm::predict() function
#' @param occ SpatialPointsDataFrame used in sdm::sdmData() function
#' @param algorithms Vector of strings. Names of the methods passed as parameters in the sdm function, passed here identically. Order is important. If any of the algorithms failed you should not pass it onto this function. Example: algorithms = c('svm', 'maxent', 'rf', 'brt', 'domain')
#' @param predict_object RasterStack. Object obtained from sdm::predict() function. Can be the object as expelled from the function or the saved output loaded as RasterStack
#'
#' @return Returns a list of dataframes as long as the number of algorithms passed in 'algorithms ='. Each dataframe is in the occ.pnts format required by the accum.occ function and contains the information of one algorithm.
#' @export
#'
#' @import raster
#' @importFrom Rdpack reprompt
#'
#' @examples \dontrun{
#' # DO NOT RUN
#' envpres <- dir(path = 'path/to/cropped/env/layers', pattern = ".tif$", full.names = T)
#' envpres <- raster::stack(envpres)
#'
#' occ_train <- rgdal::readOGR('data/processed/shapefiles/train.shp')
#'
#' d_occ <- sdmData(formula = charinus~., train=occ_train, predictors = envpres,
#'                  bg = 18, method = 'eRandom') # Create sdmData object
#'
#' m_occ <- sdm(formula = charinus~.,data = d_occ,
#'              methods = c('svm', 'maxent', 'bioclim', 'domain'),
#'                           replication = c('bootstrapping'), n=5)
#' p_occ <- predict(m_occ, newdata = envpres, # new data is the environment in which we want to predict
#'                  filename = 'output/from/predict/function.tif',
#'                    mean = T, prj = T, overwrite = T, nc = 4)
#'
#'
#' occ.pnts <- sdm_to_occ.pnts(env = env.pres, occ = occ_train,
#'                             algorithms = c('svm', 'maxent', 'bioclim', 'domain'),
#'                             predict_object = p_pres)
#' }
#'
#' @references
#' \insertRef{jimenezLeavingAreaReceiving2020a}{sdmLit}
#'
sdm_to_occ.pnts <- function(env, occ, algorithms, predict_object){
  algorithms <- as.list(algorithms)
  pred.df <- raster::extract(predict_object, occ, as_data_frame = T)
  env.extract <- raster::extract(env, occ, as.data.frame = T)
  occ.coords <- occ@coords
  occ.p_preds <- vector('list',length(algorithms))
  occ.pnts <- vector('list',length(algorithms))
  for (i in 1:length(algorithms)){
    occ.p_preds[[i]] <- pred.df[,i]
  }
  for (j in 1:length(algorithms)){
   occ.pnts[[j]] <- cbind(occ.coords,
                    occ.p_preds[[j]],
                    env.extract)
   }
      return(occ.pnts)

}
