#!/bin/bash

# Unzip and then rename the postcode file
unzip data/ons-postcode-directory.zip "Data/ONSPD_*.csv"
mv data/ONSPD_*.csv data/ons-postcode-directory.csv

# Unzip the country codes lookup file
unzip data/ons-postcode-directory.zip "Documents/Country names and codes*.csv"
mv Documents/Country\ names\ and\ codes*.csv data/country-codes.csv

# Unzip the BUA24 names and codes EW as at 04_24.csv
unzip data/ons-postcode-directory.zip "Documents/BUA24 names and codes*.csv"
mv Documents/BUA24\ names\ and\ codes*.csv data/bua24-codes.csv

# Unzip the County Electoral Division names and codes EN as at 05_23.csv
unzip data/ons-postcode-directory.zip "Documents/County Electoral Division names and codes*.csv"
mv Documents/County\ Electoral\ Division\ names\ and\ codes*.csv data/ced-codes.csv

# Unzip the LA_UA names and codes UK as at 04_23.csv
unzip data/ons-postcode-directory.zip "Documents/LA_UA names and codes*.csv"
mv Documents/LA_UA\ names\ and\ codes*.csv data/la-ua-codes.csv

# Unzip the Region names and codes EN as at 12_20 (RGN).csv
unzip data/ons-postcode-directory.zip "Documents/Region names and codes*.csv"
mv Documents/Region\ names\ and\ codes*.csv data/region-codes.csv

# Unzip data/ons-postcode-directory/Documents/Rural Urban (2011) Indicator names and codes GB as at 12_16.csv
unzip data/ons-postcode-directory.zip "Documents/Rural Urban (2011) Indicator names and codes*.csv"
mv Documents/Rural\ Urban\ \(2011\)\ Indicator\ names\ and\ codes*.csv data/ru11-codes.csv

# Unzip the Ward names and codes UK as at 05_21.csv
unzip data/ons-postcode-directory.zip "Documents/Ward names and codes*.csv"
mv Documents/Ward\ names\ and\ codes*.csv data/ward-codes.csv

# Unzip the Westminster Parliamentary Constituency names and codes UK as at 05_23.csv
unzip data/ons-postcode-directory.zip "Documents/Westminster Parliamentary Constituency names and codes*.csv"
mv Documents/Westminster\ Parliamentary\ Constituency\ names\ and\ codes*.csv data/pcon-codes.csv

# Filter the MSOA boundary data to only include the msoa21cd field
ogr2ogr -f GeoJSON -select "msoa21cd" data/msoas-filtered.geojson data/msoas.geojson

# Filter the LSOA boundary data to only include the lsoa21cd field
ogr2ogr -f GeoJSON -select "lsoa21cd" data/lsoas-filtered.geojson data/lsoas.geojson

# Filter the ONS postcode directory to only include the fields we will be using
ogr2ogr -f CSV -select "pcd,doterm,oscty,ced,oslaua,osward,oseast1m,osnrth1m,osgrdind,ctry,rgn,pcon,oa11,lsoa11,msoa11,bua24,ru11ind,imd,oa21,lsoa21,msoa21,lat,long" data/ons-postcode-directory-filtered.csv data/ons-postcode-directory.csv

# Convert the GeoJSON files to Geoparquet
gpq convert data/msoas-filtered.geojson data/msoas.parquet
gpq convert data/lsoas-filtered.geojson data/lsoas.parquet

duckdb -c "COPY(SELECT * FROM read_csv('data/ons-postcode-directory-filtered.csv', types={'ru11ind': 'VARCHAR'})) TO 'data/ons-postcode-directory.parquet';"
