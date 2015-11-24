
#' @name BE_OSM_ADMIN
#' @title BE_OSM_ADMIN: Administrative boundaries of Belgium based on OpenStreetMap
#' @description BE_OSM_ADMIN: SpatialPolygonsDataFrame with administrative boundaries of Belgium. Extracted on 2015/11/19. 
#' It contains polygons of all administrative boundaries (levels 2, 4, 6, 7, 8, 9). 
#' Polygons are stored in degrees latitude/longitude (EPSG:4326 WGS 84).
#' The data slot in the SpatialPolygonsDataFrame contains the following fields:
#' 
#' The OpenStreetMap data of Europe (europe-latest.osm.pbf as of 2015-11-18T22:23:02Z) was clipped 
#' with the bounding box 51.6, 49.4, 2.3, 6.5 using osmosis and the resulting file was imported with osm2pgsql in PostGIS
#' and converted to a shapefile with pgsql2shp to obtain shape files of polygons of administrative boundaries of administrative levels 2, 4, 6, 7, 8, 9.
#' 
#' SQL: select osm_id, boundary, admin_level, name, way_area, way, id, way_off, rel_off, parts, members, rels.tags from 
#' (select * from planet_osm_polygon where boundary = 'administrative' and admin_level IN ('2', '4', '6', '7', '8', '9')) polygon left outer join 
#' (select * from planet_osm_rels) as rels 
#' on -polygon.osm_id = rels.id;
#' 
#' The data was further joined based on the INS code with aggregated TF_SOC_POP_STRUCT_2015 data from the 
#' BelgiumStatistics package and spatially grouped at different administrative levels which were 
#' retained from the TF_SOC_POP_STRUCT_2015 data namely: municipality / district / province / region / country 
#' as well as clipped to the Belgium boundary.
#' All the administrative boundaries are made available in the BE_OSM_ADMIN dataset which can be found inside the package.
#' 
#' Mark that Brussels is not considered a a province and that in this dataset at the province level the region level information is taken
#' from the TF_SOC_POP_STRUCT_2015 dataset.
#' 
#' \itemize{
#' \item osm.id: the OpenStreetMap id of the polygon 
#' \item boundary: the boundary OpenStreetMap tag of the polygon: always administrative
#' \item admin.level: the admin_level OpenStreetMap tag of the polygon: either 2, 4, 6, 7, 8, 9 (national, regions, provinces, districts, municipalities, nissections)
#' \item name: the OpenStreetMap name of the polygon
#' \item way.off: part of the planet_osm_rels table
#' \item rel.off: part of the planet_osm_rels table
#' \item parts: ways field, part of the planet_osm_rels table
#' \item members: members field, part of the planet_osm_rels table
#' \item tags: tags field, part of the planet_osm_rels table
#' \item tag.type: type tag, extracted using \code{tag_extractor} from the tags field of the planet_osm_rels table
#' \item tag.admin.level: admin_level tag, extracted using \code{tag_extractor} from the tags field of the planet_osm_rels table
#' \item tag.boundary: boundary tag, extracted using \code{tag_extractor} from the tags field of the planet_osm_rels table
#' \item tag.name: name tag, extracted using \code{tag_extractor} from the tags field of the planet_osm_rels table
#' \item tag.name.nl: name:nl tag, extracted using \code{tag_extractor} from the tags field of the planet_osm_rels table
#' \item tag.name.fr: name:fr tag, extracted using \code{tag_extractor} from the tags field of the planet_osm_rels table
#' \item tag.official.name: official_name tag, extracted using \code{tag_extractor} from the tags field of the planet_osm_rels table
#' \item tag.official.name.nl: official_name:nl tag, extracted using \code{tag_extractor} from the tags field of the planet_osm_rels table
#' \item tag.official.name.fr: official_name:fr tag, extracted using \code{tag_extractor} from the tags field of the planet_osm_rels table
#' \item tag.wikipedia.fr: wikipedia:fr tag, extracted using \code{tag_extractor} from the tags field of the planet_osm_rels table
#' \item tag.addr.postcode: addr:postcode tag, extracted using \code{tag_extractor} from the tags field of the planet_osm_rels table
#' \item tag.ref.ins: ref:INS tag, extracted using \code{tag_extractor} from the tags field of the planet_osm_rels table
#' \item tag.old.ref.ins: old_ref:INS tag, extracted using \code{tag_extractor} from the tags field of the planet_osm_rels table
#' \item tag.wikipedia: wikipedia tag, extracted using \code{tag_extractor} from the tags field of the planet_osm_rels table
#' \item tag.wikidata: wikidata tag, extracted using \code{tag_extractor} from the tags field of the planet_osm_rels table
#' \item tag.website: website tag, extracted using \code{tag_extractor} from the tags field of the planet_osm_rels table
#' \item tag.is.in: is_in tag, extracted using \code{tag_extractor} from the tags field of the planet_osm_rels table
#' }
#' 
#' @docType data
#' @references \url{http://wiki.openstreetmap.org/wiki/Tag:boundary=administrative}, 
#' \url{http://download.geofabrik.de/europe.html}, 
#' \url{https://en.wikipedia.org/wiki/World_Geodetic_System}
#' @examples
#' \dontrun{
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






#' @name BE_OSM_ADMIN_MUNTY
#' @title BE_OSM_ADMIN_MUNTY: Municipality boundaries of Belgium extracted from OpenStreetMap
#' @description BE_OSM_ADMIN_MUNTY: Municipality boundaries of Belgium extracted from OpenStreetMap 
#' and enriched with labels based on TF_SOC_POP_STRUCT_2015 from the BelgiumStatistics package.
#' Extracted as described in \code{\link{BE_OSM_ADMIN}}
#' 
#' \itemize{
#' \item CD_MUNTY_REFNIS, TX_MUNTY_DESCR_NL, TX_MUNTY_DESCR_FR: NIS code of the municipality as well as NL/FR labels (based on TF_SOC_POP_STRUCT_2015)
#' \item CD_DSTR_REFNIS, TX_ADM_DSTR_DESCR_NL, TX_ADM_DSTR_DESCR_FR: NIS code of the district (arrondissement) as well as NL/FR labels (based on TF_SOC_POP_STRUCT_2015)
#' \item CD_PROV_REFNIS, TX_PROV_DESCR_NL, TX_PROV_DESCR_FR: NIS code of the province as well as NL/FR labels (based on TF_SOC_POP_STRUCT_2015)
#' \item CD_RGN_REFNIS, TX_RGN_DESCR_NL, TX_RGN_DESCR_FR: NIS code of the region as well as NL/FR labels (based on TF_SOC_POP_STRUCT_2015)
#' }
#' @docType data
#' @examples
#' \dontrun{
#' data(BE_OSM_ADMIN_MUNTY)
#' str(as.data.frame(BE_OSM_ADMIN_MUNTY))
#' 
#' library(sp)
#' plot(BE_OSM_ADMIN_MUNTY)
#' }
NULL


#' @name BE_OSM_ADMIN_DISTRICT
#' @title BE_OSM_ADMIN_DISTRICT: District boundaries of Belgium extracted from OpenStreetMap
#' @description BE_OSM_ADMIN_DISTRICT: District boundaries of Belgium extracted from OpenStreetMap.
#' and enriched with labels based on TF_SOC_POP_STRUCT_2015 from the BelgiumStatistics package.
#' Extracted as described in \code{\link{BE_OSM_ADMIN}}
#' 
#' \itemize{
#' \item CD_DSTR_REFNIS, TX_ADM_DSTR_DESCR_NL, TX_ADM_DSTR_DESCR_FR: NIS code of the district (arrondissement) as well as NL/FR labels (based on TF_SOC_POP_STRUCT_2015)
#' \item CD_PROV_REFNIS, TX_PROV_DESCR_NL, TX_PROV_DESCR_FR: NIS code of the province as well as NL/FR labels (based on TF_SOC_POP_STRUCT_2015)
#' \item CD_RGN_REFNIS, TX_RGN_DESCR_NL, TX_RGN_DESCR_FR: NIS code of the region as well as NL/FR labels (based on TF_SOC_POP_STRUCT_2015)
#' }
#' @docType data
#' @examples
#' \dontrun{
#' data(BE_OSM_ADMIN_DISTRICT)
#' str(as.data.frame(BE_OSM_ADMIN_DISTRICT))
#' 
#' library(sp)
#' plot(BE_OSM_ADMIN_DISTRICT)
#' }
NULL

#' @name BE_OSM_ADMIN_PROVINCE
#' @title BE_OSM_ADMIN_PROVINCE: Province boundaries of Belgium extracted from OpenStreetMap
#' @description BE_OSM_ADMIN_PROVINCE: Province boundaries of Belgium extracted from OpenStreetMap.
#' and enriched with labels based on TF_SOC_POP_STRUCT_2015 from the BelgiumStatistics package.
#' Extracted as described in \code{\link{BE_OSM_ADMIN}}
#' 
#' \itemize{
#' \item CD_PROV_REFNIS, TX_PROV_DESCR_NL, TX_PROV_DESCR_FR: NIS code of the province as well as NL/FR labels (based on TF_SOC_POP_STRUCT_2015)
#' \item CD_RGN_REFNIS, TX_RGN_DESCR_NL, TX_RGN_DESCR_FR: NIS code of the region as well as NL/FR labels (based on TF_SOC_POP_STRUCT_2015)
#' }
#' @docType data
#' @examples
#' \dontrun{
#' data(BE_OSM_ADMIN_PROVINCE)
#' str(as.data.frame(BE_OSM_ADMIN_PROVINCE))
#' 
#' library(sp)
#' plot(BE_OSM_ADMIN_PROVINCE)
#' }
NULL


#' @name BE_OSM_ADMIN_REGION
#' @title BE_OSM_ADMIN_REGION: Region boundaries of Belgium extracted from OpenStreetMap
#' @description BE_OSM_ADMIN_REGION: Region boundaries of Belgium extracted from OpenStreetMap.
#' and enriched with labels based on TF_SOC_POP_STRUCT_2015 from the BelgiumStatistics package.
#' Extracted as described in \code{\link{BE_OSM_ADMIN}}
#' 
#' \itemize{
#' \item CD_RGN_REFNIS, TX_RGN_DESCR_NL, TX_RGN_DESCR_FR: NIS code of the region as well as NL/FR labels (based on TF_SOC_POP_STRUCT_2015)
#' }
#' @docType data
#' @examples
#' \dontrun{
#' data(BE_OSM_ADMIN_REGION)
#' str(as.data.frame(BE_OSM_ADMIN_REGION))
#' 
#' library(sp)
#' plot(BE_OSM_ADMIN_REGION)
#' }
NULL


#' @name BE_OSM_ADMIN_COUNTRY
#' @title BE_OSM_ADMIN_COUNTRY: Country boundaries of Belgium extracted from OpenStreetMap
#' @description BE_OSM_ADMIN_COUNTRY: Country boundaries of Belgium extracted from OpenStreetMap.
#' and enriched with labels based on TF_SOC_POP_STRUCT_2015 from the BelgiumStatistics package.
#' Extracted as described in \code{\link{BE_OSM_ADMIN}}
#' 
#' \itemize{
#' \item COUNTRY: Belgium
#' }
#' @docType data
#' @examples
#' \dontrun{
#' data(BE_OSM_ADMIN_COUNTRY)
#' str(as.data.frame(BE_OSM_ADMIN_COUNTRY))
#' 
#' library(sp)
#' plot(BE_OSM_ADMIN_COUNTRY)
#' }
NULL


