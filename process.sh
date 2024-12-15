#!/bin/bash

# Unzip and then rename the postcode file
unzip data/ons-postcode-directory.zip "Data/ONSPD_*.csv"
mv data/ONSPD_*.csv data/ons-postcode-directory.csv

# Filter the MSOA boundary data to only include the msoa21cd field
ogr2ogr -f GeoJSON -select "msoa21cd" data/msoas-filtered.geojson data/msoas.geojson

# Filter the LSOA boundary data to only include the lsoa21cd field
ogr2ogr -f GeoJSON -select "lsoa21cd" data/lsoas-filtered.geojson data/lsoas.geojson

# Filter the ONS postcode directory to only include the fields we will be using
ogr2ogr -f CSV -select "pcd,doterm,oscty,ced,oslaua,osward,oseast1m,osnrth1m,osgrdind,ctry,rgn,pcon,oa11,lsoa11,msoa11,bua24,ru11ind,imd,oa21,lsoa21,msoa21" data/ons-postcode-directory-filtered.csv data/ons-postcode-directory.csv

# Convert the GeoJSON files to Geoparquet
gpq convert data/msoas-filtered.geojson data/msoas.parquet
gpq convert data/lsoas-filtered.geojson data/lsoas.parquet

duckdb -c "COPY(SELECT * FROM read_csv('data/ons-postcode-directory-filtered.csv', columns={'ru11ind': 'VARCHAR'})) TO 'data/ons-postcode-directory-filtered.parquet';"
