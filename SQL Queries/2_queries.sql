--DELETE GEO OUTLIERS
select count(unipi_ais_feb_2018_raw.geom)
From unipi_ais_feb_2018_raw
WHERE NOT ST_Intersects(unipi_ais_feb_2018_raw.geom,ST_Buffer(ST_GeomFromText('POINT(25.5132 37.7779)', 4326),
3));
select count(unipi_ais_mar_2018_raw.geom)
From unipi_ais_mar_2018_raw
WHERE NOT ST_Intersects(unipi_ais_mar_2018_raw.geom,ST_Buffer(ST_GeomFromText('POINT(25.5132 37.7779)', 4326),
3));



select unipi_ais_mar_2018_raw.geom,unipi_ais_feb_2018_raw.geom
From unipi_ais_mar_2018_raw,unipi_ais_feb_2018_raw;
select unipi_ais_mar_2018_raw.geom
From unipi_ais_mar_2018_raw;
select unipi_ais_feb_2018_raw.geom
From unipi_ais_feb_2018_raw;



delete 
From unipi_ais_feb_2018_raw
WHERE NOT ST_Intersects(unipi_ais_feb_2018_raw.geom,ST_Buffer(ST_GeomFromText('POINT(25.5132 37.7779)', 4326),
3));

delete 
From unipi_ais_mar_2018_raw
WHERE NOT ST_Intersects(unipi_ais_mar_2018_raw.geom,ST_Buffer(ST_GeomFromText('POINT(25.5132 37.7779)', 4326),
3));

-- TRANSFER CLEANSED DATA AFTER PREPROCESSING WITH PYTHON TO POSTGRES

CREATE TABLE unipi_ais_feb_2018_clean(
mmsi integer,
timestmp bigint,
geom geometry(Point,0),
lon double precision,
lat double precision,
speed double precision,
ais_type varchar(50),
ais_status varchar(50),
ais_heading double precision,
ais_turn varchar(50),
ais_course double precision,
acceleration double precision);

CREATE TABLE unipi_ais_mar_2018_clean(
mmsi integer,
timestmp bigint,
geom geometry(Point,0),
lon double precision,
lat double precision,
speed double precision,
ais_type varchar(50),
ais_status varchar(50),
ais_heading double precision,
ais_turn varchar(50),
ais_course double precision,
acceleration double precision);

COPY unipi_ais_feb_2018_clean(mmsi,timestmp,geom,lon,lat,speed,ais_type,ais_status,ais_heading,ais_turn,ais_course,acceleration)
FROM 'D:\unipi_ais_feb_2018_clean.csv'
DELIMITER ';'
CSV HEADER;

COPY unipi_ais_mar_2018_clean(mmsi,timestmp,geom,lon,lat,speed,ais_type,ais_status,ais_heading,ais_turn,ais_course,acceleration)
FROM 'D:\unipi_ais_mar_2018_clean.csv'
DELIMITER ';'
CSV HEADER;

SELECT UpdateGeometrySRID('unipi_ais_feb_2018_clean','geom',4326);
SELECT UpdateGeometrySRID('unipi_ais_mar_2018_clean','geom',4326);
				 

--2.4 QUERY FOR R TREE INDEX
explain analyze 
select *  
from (select box2d(geom) as box2d   
	  from unipi_ais_feb_2018_clean   
	  where st_contains(st_transform(st_geomfromtext('polygon((23.423538 37.860290, 23.472977 37.856549,   23.475723 37.827810, 23.435898 37.833776, 23.423538 37.860290))', 4326), 2100),   st_transform(unipi_ais_feb_2018_clean.geom,2100))=true  and timestmp >= 1517436001000 and timestmp <= 1517695201000) as foo,  
unipi_ais_feb_2018_clean 
where foo.box2d && geom;