INSTALL spatial;
LOAD spatial;

CREATE TABLE msoas AS SELECT MSOA21CD as msoa21cd, geometry FROM read_parquet('data/msoas.parquet');