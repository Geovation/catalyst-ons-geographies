# ONS Geography Library

This is a repository for storing and querying Office for National Statistics geographies within the geoparquet file format and importing into a DuckDB database.

## Introduction

[DuckDB](https://duckdb.org/) is a fast in-process database system. It is designed for analytical workloads and can be used as a library in other applications. We are compiling a number of scripts to import ONS geographies into DuckDB, where they will then be available to embed in applications.

The end goal will be to quickly be able to generate a duckdb database file (or multiple files) that can be used to query ONS geographies.

## Setup

- [Duck DB](https://duckdb.org/) CLI - installed via brew
- [PlanetLab's GPQ](https://github.com/planetlabs/gpq) - installed via brew
- [GDAL](https://gdal.org/) - installed via brew

```bash
brew install duckdb
brew install planetlabs/gpq
brew install gdal
```

### Downloading and processing the data

Census boundaries and the ONS postcode directory are downloaded from the ONS Geoportal.

```bash
./download.sh
```

When the downloads are done the data is processed to create a number of geoparquet files.

```bash
./process.sh
```

These are pregenerated as part of this repository, and can be found in the `data` directory.

- `lsoas.parquet` - Lower Super Output Areas
- `msoas.parquet` - Middle Super Output Areas
- `ons_postcode_directory.parquet` - A selection of columns from the ONS Postcode Directory

### Importing the data into DuckDB

The geoparquet files can be imported into DuckDB using a shell script.

```bash
./createpostcodesdb.sh
```

This creates a file named `ons_postcodes.duckdb` which can be used to query the data.

## Release

When this repository is released the duckdb database file will be added to the release page as a build item, so there is no need to run the above commands if you simply want the database file.

See the [releases page](https://github.com/Geovation/catalyst-ons-geographies/releases) for the latest release.

## Usage

With duckdb installed the database can be launched:

```
duckdb ons_postcodes.duckdb
```

Whenever loading the database the following commands should be run to enable the geospatial functions:

```
LOAD spatial;
```

### Querying the database

The database can be queried using SQL.

Find the postcode for a given point:

```sql
SELECT postcode, date_of_termination, county_code,county_electoral_division_code, local_authority_district_code,ward_code, easting, northing, country_code, region_code, westminster_parliamentary_constituency_code, output_area_11_code, lower_super_output_area_11_code, middle_super_output_area_11_code, built_up_area_24_code, rural_urban_11_code, index_multiple_deprivation_rank, output_area_21_code, lower_super_output_area_21_code, middle_super_output_area_21_code, longitude, latitude
FROM(
  SELECT
    st_distance(ST_Point(-2.250, 51.346), geometry) as distance,
    *
  FROM postcodes
  WHERE ST_Within(geometry, ST_Buffer(ST_Point(-2.250, 51.346), 0.01))
  AND date_of_termination IS NULL
  ORDER BY distance ASC LIMIT 1);
```

Find the postcode for a given postcode:

```sql
SELECT postcode, date_of_termination, county_code,county_electoral_division_code, local_authority_district_code,ward_code, easting, northing, country_code, region_code, westminster_parliamentary_constituency_code, output_area_11_code, lower_super_output_area_11_code, middle_super_output_area_11_code, built_up_area_24_code, rural_urban_11_code, index_multiple_deprivation_rank, output_area_21_code, lower_super_output_area_21_code, middle_super_output_area_21_code, longitude, latitude
FROM postcodes where replace(postcode, ' ', '') = 'BA151DS';
```
