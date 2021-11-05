

select trajectories_feb.mmsi,trajectories_mar.trajectory
from trajectories_feb,trajectories_mar
where st_equals(st_startpoint(trajectories_feb.trajectory),st_startpoint(trajectories_mar.trajectory))
and st_equals(st_endpoint(trajectories_feb.trajectory),st_endpoint(trajectories_mar.trajectory)); 241081000 --mmsi has the same start and end point in trajectory in feb and mar

select st_startpoint(trajectories_mar.trajectory),st_endpoint(trajectories_mar.trajectory)//--trajectories in march the same start and end point
from trajectories_mar
group by st_startpoint(trajectories_mar.trajectory),st_endpoint(trajectories_mar.trajectory)
HAVING count(*) > 1;

select *--trajectories starting in piraeus port
from trajectories_feb 
where st_contains( st_geomfromtext('POLYGON ((23.5778 37.9543,23.6897 37.9281,23.6340 37.7894, 23.5153 37.8874,23.5778 37.9543))',4326),st_startpoint(trajectories_feb.trajectory));


select *--trajectories starting and ending at piraeus port before february 15.
from trajectories_feb
where st_contains( st_geomfromtext('POLYGON ((23.5778 37.9543,23.6897 37.9281,23.6340 37.7894, 23.5153 37.8874,23.5778 37.9543))',4326),st_startpoint(trajectories_feb.trajectory))
and st_contains( st_geomfromtext('POLYGON ((23.5778 37.9543,23.6897 37.9281,23.6340 37.7894, 23.5153 37.8874,23.5778 37.9543))',4326),st_endpoint(trajectories_feb.trajectory))
and timestamp <1518652800000;

select *--mmsis with the same trajectory with this 
from trajectories_feb,(
select st_startpoint(trajectory) as sp,st_endpoint(trajectory) as ep
from trajectories_feb
where trajectories_feb.mmsi=210096000) as foo
where st_startpoint(trajectory)=foo.sp and st_endpoint(trajectory)=foo.ep;

select trajectories_feb.mmsi,trajectories_feb.trajectory --mmsi  with the same trajectory endpoint in february and march
from trajectories_feb,trajectories_mar 
where st_equals(st_endpoint(trajectories_feb.trajectory),st_endpoint(trajectories_mar.trajectory));

select * --trajectories_in_feb_not_starting_from_piraeus_port
from trajectories_feb 
where not st_contains( st_geomfromtext('POLYGON ((23.5778 37.9543,23.6897 37.9281,23.6340 37.7894, 23.5153 37.8874,23.5778 37.9543))',4326),st_startpoint(trajectories_feb.trajectory));