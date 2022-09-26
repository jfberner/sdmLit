#' sdm to output.mod
#'
#' @author João Frederico Berner
#'
#' @description This function takes the output from the sdm::predict() function, and environmental data used in predict() and makes a list of data.frames, one data.frame for each algorithm, in the output.mod format required by the accum.occ() function from \insertCite{LeavingAreaReceiving}{sdmTools}.
#'
#' @param env RasterStack used as newdata= in sdm::predict() function
#' @param long String. How the long variable is called in your output from sdm::predict(). Example: long = 'x'
#' @param lat  String. How the long variable is called in your output from sdm::predict(). Example: lat = 'y'
#' @param algorithms Vector of strings. Names of the methods passed as parameters in the sdm function, passed here identically. Order is important. If any of the algorithms failed you should not pass it onto this function. Example: algorithms = c('svm', 'maxent', 'rf', 'brt', 'domain')
#' @param predict_object RasterStack. Object obtained from sdm::predict() function. Can be the object as expelled from the function or the saved output loaded as RasterStack
#'
#' @return Returns a list of dataframes as long as the number of algorithms passed in 'algorithms ='. Each dataframe is in the output.mod format required by the accum.occ function and contains the information of one algorithm.
#' @export
#'
#' @import dplyr
#' @import raster
#' @importFrom Rdpack reprompt
#'
#' @examples \dontrun{ # DO NOT RUN
#' envpres <- dir(path = 'path/to/cropped/env/layers', pattern = ".tif$", full.names = T)
#' envpres <- raster::stack(envpres)
#'
#' occ_train <- rgdal::readOGR('data/processed/shapefiles/train.shp')
#'
#' d_occ <- sdmData(formula = charinus~., train=occ_train,
#'                  predictors = envpres, bg = 18,
#'                  method = 'eRandom') # Create sdmData object
#'
#' m_occ <- sdm(formula = charinus~.,data = d_occ,
#'              methods = c('svm', 'maxent', 'bioclim', 'domain'),
#'                           replication = c('bootstrapping'), n=5)
#' p_occ <- predict(m_occ, newdata = envpres, # new data is the environment in which we want to predict
#'                  filename = 'output/from/predict/function.tif',
#'                    mean = T, prj = T, overwrite = T, nc = 4)
#'
#' env.pres <- terra::rast(output/from/predict/function.tif)
#' env.pres %>% raster::stack()
#'
#' out.preds <- sdm_to_output.mods(env = env.pres, long = 'x',lat = 'y',
#'                                 algorithms = c('svm', 'maxent','bioclim','domain'),
#'                                 predict_object = pocc)
#'           }
#' @references
#' \insertRef{LeavingAreaReceiving}{sdmTools}
#'

sdm_to_output.mods <- function(env, algorithms, predict_object, long, lat){
  algorithms <- as.list(algorithms)
  env.data.frame <- as.data.frame(env, row.names=NULL, na.rm=F,xy=F,long=F)
  p.data.frame <- as.data.frame(predict_object, row.names=NULL, na.rm=F,xy=T,long=F)
  names(p.data.frame) <- c('long', 'lat' , algorithms)
  pred.data.frame <- vector('list',length(algorithms))
  output.mods <- vector('list',length(algorithms))
  for (i in 1:length(algorithms)){
    pred.data.frame[[i]] <- dplyr::select(p.data.frame, long, lat, algorithms[[i]])
  }
  for (j in 1:length(algorithms)){
    output.mods[[j]] <- cbind(pred.data.frame[[j]], env.data.frame)
  }
  return(output.mods)
}
