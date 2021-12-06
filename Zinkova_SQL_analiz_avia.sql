---запрос 1 

select city, count(airport_code)
from airports
group by city
having count(airport_code)>1

-----запрос 2

select f.departure_airport
from aircrafts a 
inner join flights f on a.aircraft_code=f.aircraft_code  
where a.range = (select max(range) 
from aircrafts )
group by (f.departure_airport)

----запрос 3

select flight_id, actual_departure - scheduled_departure as time
from flights 
where (actual_departure - scheduled_departure) is not null
order by (actual_departure - scheduled_departure) desc
limit 10

----запрос 4

select t.book_ref, bp.boarding_no
from tickets t
left join boarding_passes bp on bp.ticket_no=t.ticket_no 
where boarding_no is null


------запрос 5

select f.flight_id,f.departure_airport ,v-z as svodno, round((v-z)::decimal/v::decimal,5)*100 as proc, z,sum(z) over(partition by f.departure_airport order by f.actual_departure) 
from flights f 
inner join (select count(bp.seat_no) as z, bp.flight_id
from boarding_passes bp
group by bp.flight_id) as sv on f.flight_id =sv.flight_id
inner join (select aircraft_code, count(seat_no) as v
from seats 
group by aircraft_code ) as zan on f.aircraft_code=zan.aircraft_code


-----запрос 6

select a.aircraft_code,
round(count(flight_id::decimal)/(select count(flight_id)::decimal from flights),10)*100
from flights f 
right join aircrafts a on f.aircraft_code=a.aircraft_code 
group by 1

----запрос 7

with cte_bis as (select tf.flight_id, tf.fare_conditions,tf.amount ,a.city
from ticket_flights tf 
inner join flights f on tf.flight_id=f.flight_id 
inner join airports a on a.airport_code =f.arrival_airport
where fare_conditions='Business'),
cte_econ as(select tf.flight_id, tf.fare_conditions,tf.amount ,a.city
from ticket_flights tf 
inner join flights f on tf.flight_id=f.flight_id 
inner join airports a on a.airport_code =f.arrival_airport
where fare_conditions='Economy')
select cte_bis.city
from cte_bis
inner join cte_econ on cte_bis.flight_id=cte_econ.flight_id
where cte_bis.amount < cte_econ.amount

------запрос 8

create view city_all as  (select  a.city, a2.city as c2
from airports a, airports a2 
group by a.city, a2.city
having a.city <> a2.city
) 

create view city_1 as (select   a.city, a2.city as c2
from flights f
inner join airports a on a.airport_code =f.departure_airport
inner join airports a2 on a2.airport_code =f.arrival_airport 
)

select  *
from city_all
except 
select  *
from city_1

-----запрос 9

select distinct f.departure_airport ,f.arrival_airport ,
acos(sin(radians(a.latitude))*sin(radians(a2.latitude)) + cos(radians(a.latitude))*cos(radians(a2.latitude))*cos(radians(a.longitude) - radians(a2.longitude)))*6371 as L ,
case when range > (acos(sin(radians(a.latitude))*sin(radians(a2.latitude)) + cos(radians(a.latitude))*cos(radians(a2.latitude))*cos(radians(a.longitude) - radians(a2.longitude)))*6371) then 'yes' else 'no' end
from flights f
inner join airports a on a.airport_code=f.departure_airport 
inner join airports a2 on a2.airport_code =f.arrival_airport 
inner join aircrafts a3 on f.aircraft_code =a3.aircraft_code 




















 























