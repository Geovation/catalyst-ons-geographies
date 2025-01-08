INSTALL spatial;
LOAD spatial;

CREATE TABLE msoas AS SELECT MSOA21CD as msoa21cd, geometry FROM read_parquet('data/msoas.parquet');
CREATE TABLE lsoas AS SELECT LSOA21CD as lsoa21cd, geometry FROM read_parquet('data/lsoas.parquet');

CREATE TABLE postcodes AS SELECT pcd,doterm,oscty,ced,oslaua,osward,oseast1m,osnrth1m,osgrdind,ctry,rgn,pcon,oa11,lsoa11,msoa11,bua24,ru11ind,imd,oa21,lsoa21,msoa21 FROM read_parquet('data/ons-postcode-directory.parquet');

