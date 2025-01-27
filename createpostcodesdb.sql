INSTALL spatial;
LOAD spatial;

CREATE TABLE postcodes (
    postcode VARCHAR,
    date_of_termination VARCHAR,
    county_code VARCHAR,
    county_electoral_division_code VARCHAR,
    local_authority_district_code VARCHAR,
    ward_code VARCHAR,
    easting INTEGER,
    northing INTEGER,
    country_code VARCHAR,
    region_code VARCHAR,
    westminster_parliamentary_constituency_code VARCHAR,
    output_area_11_code VARCHAR,
    lower_super_output_area_11_code VARCHAR,
    middle_super_output_area_11_code VARCHAR,
    built_up_area_24_code VARCHAR,
    rural_urban_11_code VARCHAR,
    index_multiple_deprivation_rank INTEGER,
    output_area_21_code VARCHAR,
    lower_super_output_area_21_code VARCHAR,
    middle_super_output_area_21_code VARCHAR,
    longitude DOUBLE,
    latitude DOUBLE
);

-- Load the data from the parquet file into the postcodes table
INSERT INTO postcodes
SELECT pcd as postcode,
       doterm as date_of_termination,
       oscty as county_code,
       ced as county_electoral_division_code,
       oslaua as local_authority_district_code,
       osward as ward_code,
       oseast1m as easting,
       osnrth1m as northing,
       ctry as country_code,
       rgn as region_code,
       pcon as westminster_parliamentary_constituency_code,
       oa11 as output_area_11_code,
       lsoa11 as lower_super_output_area_11_code,
       msoa11 as middle_super_output_area_11_code,
       bua24 as built_up_area_24_code,
       ru11ind as rural_urban_11_code,
       imd as index_multiple_deprivation_rank,
       oa21 as output_area_21_code,
       lsoa21 as lower_super_output_area_21_code,
       msoa21 as middle_super_output_area_21_code,
       long as longitude,
       lat as latitude
FROM read_parquet('data/ons-postcode-directory.parquet');

CREATE TABLE counties (
    code VARCHAR,
    name VARCHAR
);

-- Load the data from the parquet file into the counties table
INSERT INTO counties
SELECT code, name
FROM read_parquet('data/ons-counties.parquet');

-- On the postcodes table create a geometry column from longitude and latitude using st_point
ALTER TABLE postcodes ADD COLUMN geometry geometry;
UPDATE postcodes SET geometry = st_point(longitude, latitude);

-- Create a duckdb spatial index
CREATE INDEX postcodes_geom_idx ON postcodes USING RTREE (geometry);


