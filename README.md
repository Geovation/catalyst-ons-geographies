# ONS Geography Library

Storing and querying ONS geographies within an easy to use file formats.

## Setup

- [Duck DB](https://duckdb.org/) CLI - installed via brew

```bash
brew install duckdb
```

- [PlanetLab's GPQ](https://github.com/planetlabs/gpq) - installed via brew

```bash
brew install planetlabs/gpq
```

- [GDAL](https://gdal.org/) - installed via brew

```bash
brew install gdal
```

## Data scripts

Census boundaries and ONS postcode directory are downloaded from the ONS Geoportal.

```bash
./download.sh
```

When the downloads are down the data is processe to create a number of geoparquet files.

```bash
./process.sh
```

## Using the database

With duckdb installed the database can be launched:

```
duckdb
```
