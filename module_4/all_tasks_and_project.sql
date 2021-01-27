/*
задание 4.1
База данных содержит список аэропортов практически всех крупных городов России.
В большинстве городов есть только один аэропорт. Исключение составляет:
*/
select ap.city
from dst_project.airports ap
group by 1
having count(ap.airport_name) > 1;

/*
задание 4.2.1
Таблица рейсов содержит всю информацию о прошлых, текущих и запланированных рейсах.
Сколько всего статусов для рейсов определено в таблице?
*/
select count(distinct f.status)
from dst_project.flights f;

/*
задание 4.2.2
Какое количество самолетов находятся в воздухе на момент среза в базе
(статус рейса «самолёт уже вылетел и находится в воздухе»)
*/
select
  count(*)
from
  dst_project.flights f
where
  f.actual_departure is not null and
  f.actual_arrival is null;

/*
Задание 4.2.3
Места определяют схему салона каждой модели. Сколько мест имеет самолет модели  (Boeing 777-300)?
*/
select count(*)
from dst_project.seats s
where s.aircraft_code = '773';

/*
задание 4.2.4
 Сколько состоявшихся (фактических) рейсов было совершено между 1 апреля 2017 года и 1 сентября 2017 года?
 */
select
  count(*)
from
  dst_project.flights f
where
  (f.actual_arrival >= '2017-04-01' and f.actual_arrival <= '2017-09-01')
  and f.status = 'Arrived';

/*
Задание 4.3.1
Сколько всего рейсов было отменено по данным базы?
*/
select count(*)
from dst_project.flights f
where f.status = 'Cancelled';

/*
Задание 4.3.2
Сколько самолетов моделей типа Boeing, Sukhoi Superjet, Airbus находится в базе авиаперевозок?
*/
select
  sum((ac.model like 'Boeing%')::int) Boeings
  ,sum((ac.model like 'Sukhoi%')::int) Sukhoi
  ,sum((ac.model like 'Airbus%')::int) Airbus
from dst_project.aircrafts ac;

/*
Задание 4.3.3
В какой части (частях) света находится больше аэропортов?
*/
select
  split_part(ap.timezone, '/', 1) as time_zone
  ,count(split_part(ap.timezone, '/', 1))
from dst_project.airports ap
group by 1;

/*
задание 4.3.4
У какого рейса была самая большая задержка прибытия за все время сбора данных?
Введите id рейса (flight_id)
*/
select
  f.flight_id
  ,f.actual_departure - f.scheduled_departure delay
from dst_project.flights f
where f.actual_departure is not null
order by delay desc
limit 1;

/*
задание 4.4.1
Когда был запланирован самый первый вылет, сохраненный в базе данных?
*/
select f.scheduled_departure
from dst_project.flights f
order by 1
limit 1;

/*
задание 4.4.2
Сколько минут составляет запланированное время полета в самом длительном рейсе?
*/
select
  date_part('hour', f.scheduled_arrival - f.scheduled_departure) * 60 +
   date_part('minute', f.scheduled_arrival - f.scheduled_departure)  duration_mn
from dst_project.flights f
order by 1 desc
limit 1;

/*
Задание 4.4.3 Между какими аэропортами пролегает самый длительный по времени запланированный рейс?
*/
select
  distinct (f.departure_airport
  ,f.arrival_airport)
from dst_project.flights f
where f.scheduled_arrival - f.scheduled_departure = (select  f.scheduled_arrival - f.scheduled_departure
                                                    from dst_project.flights f
                                                    order by 1 desc
                                                    limit 1);


/*
Задание 4.4.4
Сколько составляет средняя дальность полета среди всех самолетов в минутах?
Секунды округляются в меньшую сторону (отбрасываются до минут).
*/
select
  date_part('hour', avg(f.actual_arrival - f.actual_departure)) * 60 +
   date_part('minute', avg(f.actual_arrival - f.actual_departure))  duration_mn
from dst_project.flights f
where f.status = 'Arrived';

/*
Задание 4.5.1
Мест какого класса у SU9 больше всего?
*/
select
  s.fare_conditions
  ,count(s.fare_conditions)
from dst_project.seats s
where s.aircraft_code = 'SU9'
group by 1
order by 1 desc;

/*
Задание 4.5.2
Какую самую минимальную стоимость составило бронирование за всю историю?
*/
select b.total_amount
from dst_project.bookings b
order by 1;

/*
Задание 4.5.3
Какой номер места был у пассажира с id = 4313 788533?
*/
select
  bp.seat_no
from
  dst_project.tickets t
    join dst_project.boarding_passes bp on t.ticket_no = bp.ticket_no
where t.passenger_id = '4313 788533';

/*
Задание 5.1.1
Анапа — курортный город на юге России. Сколько рейсов прибыло в Анапу за 2017 год?
*/
select
  count(*)
from dst_project.flights f
  left join dst_project.airports ap on ap.airport_code = f.arrival_airport
where
  ap.city = 'Anapa' and (f.actual_arrival between '2017-01-01' and '2017-12-31')
  and f.status = 'Arrived';

/*
Задание 5.1.2 Сколько рейсов из Анапы вылетело зимой 2017 года?
*/
select
  count(*)
from dst_project.flights f
  left join dst_project.airports ap on ap.airport_code = f.departure_airport
where
  ap.city = 'Anapa' and ((f.actual_arrival between '2017-01-01 00:00:00' and '2017-2-28 23:59:59')
  or (f.actual_arrival between '2017-12-1 00:00:00' and '2017-12-31 23:59:59'));


/*
Задание 5.1.3
Посчитайте количество отмененных рейсов из Анапы за все время.
*/

select
  count(*)
from dst_project.flights f
  left join dst_project.airports ap on ap.airport_code = f.departure_airport
where
  ap.city = 'Anapa' and status = 'Cancelled';


/*
Задание 5.1.4 Сколько рейсов из Анапы не летают в Москву?
*/
with codes as
(select
  f.arrival_airport
  ,count(f.arrival_airport) cnt
from dst_project.flights f
  join dst_project.airports ap on ap.airport_code = f.departure_airport
where f.departure_airport = 'AAQ'
group by 1)

select
  sum(codes.cnt)
from dst_project.airports ap
  join codes on ap.airport_code = codes.arrival_airport
where ap.city != 'Moscow';

/*
Задание 5.1.5 Какая модель самолета летящего на рейсах из Анапы имеет больше всего мест?
*/
with all_codes as
(select
  distinct f.aircraft_code cd
from dst_project.flights f
  join dst_project.airports ap on ap.airport_code = f.departure_airport
where f.departure_airport = 'AAQ')

select
  a.model
  ,count(s.seat_no)
from
  dst_project.seats s
    join all_codes ac on ac.cd = s.aircraft_code
    join dst_project.aircrafts a on a.aircraft_code = s.aircraft_code
group by a.model;


------------------------------------------------------------------------------------------------
-- project
with distance as
-- это избыточный CTE, его здесь не должно быть, далее объясняется почему
(
select
  'AAQ' dep_airport
  ,'EGO' arr_airport
  ,630 distance
  union
select
  'AAQ' dep_airport
  ,'SVO' arr_airport
  ,1220.25 distance
  union
select
  'AAQ' dep_airport
  ,'NOZ' arr_airport
  ,123 distance
)

select
  distinct f.flight_id
  ,ac.model
  ,count(*) over (partition by f.flight_id, s.seat_no) * 1.0 / spac.total_cnt PLF
  ,sum(tf.amount) over (partition by f.flight_id, s.seat_no) flight_sum
  ,sum(tf.amount) over (partition by f.flight_id, s.seat_no) /
    count(*) over (partition by f.flight_id, s.seat_no) avg_amount
  ,f.arrival_airport
  ,ap.city
  ,distance_between.distance
  ,date_part('hour', (f.actual_arrival - f.actual_departure)) * 60 +
    date_part('minute', (f.actual_arrival - f.actual_departure))  duration_mn
  ,ac.range
/*
я не использую эти данные в своей презентации, но использую их в питоне
  ,distance_between.arr_lat
  ,distance_between.arr_long
  ,distance_between.dep_lat
  ,distance_between.dep_long
 */
from
  dst_project.flights f
left join dst_project.ticket_flights tf on f.flight_id = tf.flight_id
left join dst_project.tickets t on tf.ticket_no = t.ticket_no
left join dst_project.bookings b on b.book_ref = t.book_ref
left join dst_project.aircrafts ac on f.aircraft_code = ac.aircraft_code
left join dst_project.seats s on f.aircraft_code = s.aircraft_code
join dst_project.airports ap on ap.airport_code = f.arrival_airport
left join
  (
  select
  ac.aircraft_code
  ,count(*) total_cnt
  from dst_project.aircrafts ac
    join dst_project.seats s on ac.aircraft_code = s.aircraft_code
group by ac.aircraft_code
  ) spac
on f.aircraft_code = spac.aircraft_code
left join
  (
  select
  f.flight_id
  ,f.departure_airport
  ,ap1.latitude arr_lat
  ,ap1.longitude arr_long
  ,f.arrival_airport
  ,ap2.latitude dep_lat
  ,ap2.longitude dep_long
  ,d.distance
/*
  2 * 6371 * (sqrt(pow(sin(radians(0.5 * (ap2.latitude-ap1.latitude)))), 2)
   + cos(radians(ap1.latitude)) * cos(radians(ap2.latitude)) * pow(radians(sin(0.5 * (ap2.longitude - ap1.longitude))), 2))
  я не знаю что не правильно в этом селекте, устранить ошибки не получилось
  есть решение данного запроса через функцию, но мы не проходили функции
  https://stackoverflow.com/questions/13026675/calculating-distance-between-two-points-latitude-longitude/13026961#13026961
*/
from dst_project.flights f
  join dst_project.airports ap1 on f.departure_airport = ap1.airport_code
  join dst_project.airports ap2 on f.arrival_airport = ap2.airport_code
  join distance d on
    f.departure_airport = d.dep_airport and f.arrival_airport = d.arr_airport
) distance_between
    on f.flight_id = distance_between.flight_id

where f.departure_airport = 'AAQ'
  and (date_trunc('month', f.scheduled_departure) in ('2017-01-01','2017-02-01', '2017-12-01'))
  and f.status not in ('Cancelled')
  and tf.amount is not null
order by PLF, 1;