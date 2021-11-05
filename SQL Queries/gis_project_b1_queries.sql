CREATE TABLE ais_static(
mmsi integer,
imo integer,
vessel_name varchar(100),
vessel_flag varchar(100),
vessel_type varchar(100),
PRIMARY KEY(mmsi));



CREATE TABLE unipi_ais_feb_2018_raw(
mmsi integer,
timestmp bigint,
geom geometry(Point,4326),
lon double precision,
lat double precision,
speed double precision,
ais_type varchar(50),
ais_status varchar(50),
ais_heading integer,
ais_turn varchar(50),
ais_course double precision);

CREATE TABLE unipi_ais_mar_2018_raw(
mmsi integer,
timestmp bigint,
geom geometry(Point,4326),
lon double precision,
lat double precision,
speed double precision,
ais_type varchar(50),
ais_status varchar(50),
ais_heading integer,
ais_turn varchar(50),
ais_course double precision);
				 
			 
				 


COPY unipi_ais_mar_2018_raw(timestmp,ais_type,mmsi,ais_status,lon,lat,ais_heading,ais_turn,speed,ais_course)
FROM 'D:\unipi_kinematic_AIS_feb_mar2018\unipi_kinematic_AIS_mar2018.csv'
DELIMITER ';'
CSV HEADER;


COPY unipi_ais_feb_2018_raw(timestmp,ais_type,mmsi,ais_status,lon,lat,ais_heading,ais_turn,speed,ais_course)
FROM 'D:\unipi_kinematic_AIS_feb_mar2018\unipi_kinematic_AIS_feb2018.csv'
DELIMITER ';'
CSV HEADER;

COPY ais_static(mmsi,imo,vessel_name,vessel_flag,vessel_type)
FROM 'D:\unipi_kinematic_AIS_feb_mar2018\static_ais_vessel_id.csv'
DELIMITER ';'
CSV HEADER;

UPDATE unipi_ais_feb_2018_raw SET geom = ST_SetSRID(ST_MakePoint(lon, lat), 4326);

UPDATE unipi_ais_mar_2018_raw SET geom = ST_SetSRID(ST_MakePoint(lon, lat), 4326);


