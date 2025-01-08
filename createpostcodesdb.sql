INSTALL spatial;
LOAD spatial;

CREATE TABLE msoas AS SELECT MSOA21CD as msoa21cd, geometry FROM read_parquet('data/msoas.parquet');
CREATE TABLE lsoas AS SELECT LSOA21CD as lsoa21cd, geometry FROM read_parquet('data/lsoas.parquet');

CREATE TABLE postcodes AS SELECT pcd,doterm,oscty,ced,oslaua,osward,oseast1m,osnrth1m,osgrdind,ctry,rgn,pcon,oa11,lsoa11,msoa11,bua24,ru11ind,imd,oa21,lsoa21,msoa21,lat,long FROM read_parquet('data/ons-postcode-directory.parquet');

-- On the postcodes table create a geometry column from longitude and latitude using st_point
ALTER TABLE postcodes ADD COLUMN geometry geometry;
UPDATE postcodes SET geometry = st_point(long, lat);

-- Create a duckdb spatial index
CREATE INDEX postcodes_geom_idx ON postcodes USING RTREE (geometry);