select * from trips;

select * from trips_details;

select * from loc;

select * from duration;

select * from payment;


--total trips

select count(distinct tripid) from trips_details;
--Output-2161

--total drivers

select * from trips;

select count(distinct driverid) from trips;
--Output - 30

-- total earnings

select sum(fare) from trips;
--Output- 751343

-- total Completed trips

select * from trips_details;
select sum(end_ride) from trips_details;
--Output- 983

--total searches

select sum(searches)
from trips_details;
--Output- 2161
--total searches which got estimate

select sum(searches_got_estimate) from trips_details;
--Output - 1758

--total searches for quotes

select sum(searches_for_quotes) from trips_details;
--Output-1758

--total searches which got quotes
select sum(searches_got_quotes) from trips_details;
--Output- 1277

select * from trips;


select * from trips_details;


--total driver cancelled
select count(*)-sum(driver_not_cancelled) from trips_details;
--Output- 1021

--total otp entered
select sum(otp_entered) from trips_details;
--Output- 983

--total end ride
select sum(end_ride) from trips_details;
----Output-983

--average distance per trip

select AVG(distance) from trips;
--Output - 14


--average fare per trip

select sum(fare)/count(*) from trips;
--Output -764

--sum of distance travelled by all in one day

select sum(distance) from trips;
--Output -14148



-- which is the most used payment method 
select top 1 method,COUNT(tripid) from trips t left join payment p on t.faremethod=p.id 
group by method order by COUNT(tripid) desc;
--Output - creditcard 262


-- the highest payment was made through which instrument
select a.method from payment a inner join
(select top 1 * from trips order by fare desc) b
on a.id=b.faremethod;
--Output - creditcard

-- highest total amount payment was made through which instrument
select a.method from payment a inner join
(select top 1 faremethod,sum(fare) fare from trips group by faremethod order by sum(fare) desc)b
on a.id=b.faremethod
----Output - creditcard


-- which two locations had the most trips

select loc_from,loc_to,count(distinct tripid) from trips 
group by loc_from,loc_to order by count(distinct tripid) desc;
--Output - 35 and 5 
			16 and 21


--top 5 earning drivers
select * from 
(select *,dense_rank() over(order by fare desc) rnk from
(select driverid,sum(fare)  fare from trips
group by driverid)b)c
where rnk <=5;

-- which duration had more trips
select * from
(select *,dense_rank() over(order by cnt desc) rnk from
(select duration,COUNT(distinct tripid) cnt from trips
group by duration)a)b
where rnk=1;

-- which driver , customer pair had more orders
select * from 
(select *,rank() over (order by cnt desc) rnk from
(select driverid,custid,COUNT(distinct tripid) cnt from trips
group by driverid,custid)b)c
where rnk =1

-- search to estimate rate

select sum(searches_got_estimate)*100.0/sum(searches) S_to_e from trips_details
--Output -81.35%

-- estimate to search for quote rates
select sum(searches_for_quotes)*100.0/sum(searches_got_estimate) S_to_e from trips_details
--Output -82.76

-- quote acceptance rate

select sum(searches_got_quotes)*100.0/sum(searches_for_quotes) S_to_e from trips_details
--Output -87.76


--which area got highest trips in which duration
select * from
(select *,rank() over (order by cnt desc) rnk from
(select duration,loc_from,COUNT(distinct tripid) cnt from trips
group by duration,loc_from)b)c
where rnk=1

---which area got the highest fares,cancellations,trips
select * from
(select *,rank() over(order by fare desc) rnk from
(select loc_from,sum(fare) fare from trips
group by loc_from)b)c
where rnk=1

--which area got highest Driver cancellations
select * from
(select *,rank() over(order by cnt desc) rnk from
(select loc_from,count(*)- sum(driver_not_cancelled) cnt
from trips_details
group by loc_from)b)c
where rnk=1

--which area got highest customer cancellations
select * from
(select *,rank() over(order by cnt desc) rnk from
(select loc_from,count(*)- sum(customer_not_cancelled) cnt
from trips_details
group by loc_from)b)c
where rnk=1

--which duraton got highest trips and fares
--fare
select * from
(select *,rank() over(order by fare desc) rnk from
(select duration,sum(fare) fare from trips
group by duration)b)c
where rnk=1

--trips
select * from
(select *,rank() over(order by trips desc) rnk from
(select duration,Count(tripid) trips from trips
group by duration)b)c
where rnk=1
