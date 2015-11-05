#' Maps with administrative boundaries (national, regions, provinces, districts, municipalities, nissections) of Belgium extracted from OpenStreetMap
#' 
#' Maps with administrative boundaries (national, regions, provinces, districts, municipalities, nissections) of Belgium extracted from OpenStreetMap
#'
#' @name BelgiumMaps.Admin-package 
#' @aliases BelgiumMaps.Admin BelgiumMaps.Admin-package
#' @docType package 
#' @importFrom stringi stri_extract
#' @examples
#' \dontrun{
#' ## Administrative areas
#' data(BE_OSM_ADMIN)
#' str(as.data.frame(BE_OSM_ADMIN))
#' 
#' library(sp)
#' plot(BE_OSM_ADMIN)
#' plot(subset(BE_OSM_ADMIN, admin.level %in% "2"))
#' plot(subset(BE_OSM_ADMIN, admin.level %in% "4"))
#' plot(subset(BE_OSM_ADMIN, admin.level %in% "6"))
#' plot(subset(BE_OSM_ADMIN, admin.level %in% "7"))
#' plot(subset(BE_OSM_ADMIN, admin.level %in% "8"))
#' plot(subset(BE_OSM_ADMIN, admin.level %in% "9"))
#' }
NULL
