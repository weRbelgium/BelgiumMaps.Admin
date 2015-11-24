library(RPostgreSQL)
library(sp)
library(rgdal)
library(rgeos)
library(maptools)
library(stringi)

gisQuery <- function(query, gis=FALSE, ...){
  drv <- dbDriver("PostgreSQL")
  con <- dbConnect(drv, dbname="gis",
                   host="/var/run/postgresql")
  if(gis){
    x <- readOGR("PG:dbname=gis", query, ...)  
  }else{
    x <- dbGetQuery(con, query)  
  }
  dbDisconnect(con)
  x
}
x <- readShapeSpatial("/home/bnosac/BE_OSM_ADMIN")
x@data <- x@data[, c("OSM_ID", "BOUNDARY", "ADMIN_LEVE", "NAME", "ID")]
x@data$BOUNDARY <- as.character(x@data$BOUNDARY)
x@data$ADMIN_LEVE <- as.character(x@data$ADMIN_LEVE)
x@data$NAME <- as.character(x@data$NAME)
Encoding(x@data$NAME) <- "UTF-8"

tags <- gisQuery("SELECT * from planet_osm_rels")
colnames(tags) <- toupper(colnames(tags))
Encoding(tags$TAGS) <- "UTF-8"
Encoding(tags$PARTS) <- "UTF-8"
Encoding(tags$MEMBERS) <- "UTF-8"
x <- merge(x, tags, by.x = "ID", by.y = "ID", all.x=TRUE, all.y=FALSE)

myextractor <- function(x, tag){
  regex <- ",name,.+|^\\{name,.+"
  regex <- sprintf(",%s,.+|^\\{%s,.+", tag, tag)
  x <- stri_extract(str=x, regex = regex, mode = "all")
  x <- gsub("^,|^\\{|}$", "", x)
  if(is.na(x)){
    return(x)
  }
  x <- strsplit(x, ",")[[1]][2]
  x <- gsub('^"', "", x)
  x <- gsub('"$', "", x)
  x
}
tags <- c("type", "admin_level", "boundary",
          "name", "name:nl", "name:fr", 
          "official_name", "official_name:nl", "official_name:fr", "wikipedia:fr",     
          "addr:postcode", "ref:INS", "old_ref:INS", 
          "wikipedia", "wikidata", "website", "is_in")
for(tag in tags){
  x[[sprintf("TAG.%s", make.names(tag, allow_=FALSE))]] <- sapply(x$TAGS, FUN=myextractor, tag = tag)
}
names(x)[which(names(x) == "ADMIN_LEVE")] <- "ADMIN_LEVEL"
x$PENDING <- NULL
x$OSM_ID <- NULL
BE_OSM_ADMIN <- x
names(BE_OSM_ADMIN)[which(names(BE_OSM_ADMIN) == "ID")] <- "OSM_ID"
names(BE_OSM_ADMIN) <- make.names(tolower(names(BE_OSM_ADMIN)), allow_=FALSE)
BE_OSM_ADMIN$admin.level <- as.integer(BE_OSM_ADMIN$admin.level)
#proj4string(BE_OSM_ADMIN) <- CRS("+proj=longlat +datum=WGS84")
save(BE_OSM_ADMIN, file = "BE_OSM_ADMIN_mercator.RData", compress = "xz")

