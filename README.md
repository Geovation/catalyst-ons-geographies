# ONS Geography database

This is a repository for storing and querying Office for National Statistics geographies within the geoparquet file format and importing into a DuckDB database.

## Introduction

[DuckDB](https://duckdb.org/) is a fast in-process database system. It is designed for analytical workloads and can be used as a library in other applications. We are compiling a number of scripts to import ONS geographies into DuckDB, where they will then be available to embed in applications.

The outcome will be to produce and quickly update a duckdb database that can be used to query ONS geographies.

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

When a new release is generated in GitHub for this repository, the duckdb database file will be added to the release page as a build item, so there is no need to run the above commands if you simply want the database file.

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

Find the postcode data for a given postcode:

```sql
SELECT * FROM vw_postcodes where replace(postcode, ' ', '') = 'BA151DS';
```

The results of the above query would be:

| Column Name | Value |
| --- | --- |
| postcode | BA15 1DS |


It is also possible to reverse geocode and find the postcode and associated ONS data for a given point. It's important to note that as the ONS postcode lookup is best fit, the results may not be 100% accurate for the given point. The following query uses the date_of_termination field to filter out postcodes that are no longer in use.

```sql
SELECT
  st_distance(ST_Point(-2.250, 51.346), geometry) as distance,
  *
FROM vw_postcodes
WHERE ST_Within(geometry, ST_Buffer(ST_Point(-2.250, 51.346), 0.01))
AND date_of_termination IS NULL
ORDER BY distance ASC LIMIT 1;
```
