sudo apt-get install postgresql postgresql-contrib postgis
sudo apt-get install osm2pgsql
sudo -u postgres createuser -s bnosac
sudo -u postgres createdb --encoding=UTF8 --owner=bnosac gis
#sudo -u postgres dropdb gis
psql --username=bnosac --dbname=gis -c "CREATE EXTENSION postgis;"
psql --username=bnosac --dbname=gis -c "CREATE EXTENSION postgis_topology;"
psql --username=bnosac --dbname=gis -c "CREATE EXTENSION hstore;"
./osmosis/bin/osmosis --read-pbf file=europe-latest.osm.pbf --bounding-box top=51.6 left=2.3 bottom=49.4  right=6.5 --write-pbf belgium.osm.pbf
#osm2pgsql --create --username bnosac --database gis --slim --exclude-invalid-polygon --keep-coastlines --latlong --hstore-all --input-reader pbf /home/bnosac/Desktop/OSM/belgium.osm.pbf
osm2pgsql --create --username bnosac --database gis --slim --exclude-invalid-polygon --keep-coastlines --hstore-all --input-reader pbf /home/bnosac/Desktop/OSM/belgium.osm.pbf
pgsql2shp -f BE_OSM_ADMIN -u bnosac gis "select osm_id, boundary, admin_level, name, way_area, way, id, way_off, rel_off, parts, members, rels.tags from (select * from planet_osm_polygon where boundary = 'administrative' and admin_level IN ('2', '4', '6', '7', '8', '9')) polygon left outer join (select * from planet_osm_rels) as rels on -polygon.osm_id = rels.id;"