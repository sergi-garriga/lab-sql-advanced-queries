use sakila;


-- 1.List each pair of actors that have worked together.
select * from film_actor;

select fa1.actor_id as actor_1, fa2.actor_id as actor_2, film_id as 'film_id in which they worked together' from film_actor fa1
join film_actor fa2 using(film_id)
where fa1.actor_id <> fa2.actor_id -- avoid duplicates
order by actor_1;



-- 2.For each film, list actor that has acted in more films.
select * from film_actor;

	-- subquery: number of films an actor has acted in.
select actor_id, count(film_id) as count from film_actor
group by actor_id
order by count desc;

	-- subquery: join
select fa.film_id, fa.actor_id, sub1.count from film_actor fa
join (
	select actor_id, count(film_id) as count from film_actor
	group by actor_id
    )sub1 
using(actor_id)
order by film_id;

	-- subquery: ranking the counts for each film
select *, rank() over(partition by film_id order by count desc) as ranking
from (
	select fa.film_id, fa.actor_id, sub1.count from film_actor fa
	join (
		select actor_id, count(film_id) as count from film_actor
		group by actor_id
		)sub1 
	using(actor_id)
	)sub2;

	-- query: select rankings = 1s
select film_id, actor_id, count
from (
	select *, rank() over(partition by film_id order by count desc) as ranking
	from (
		select fa.film_id, fa.actor_id, sub1.count from film_actor fa
		join (
			select actor_id, count(film_id) as count from film_actor
			group by actor_id
			)sub1 
		using(actor_id)
		)sub2
	)sub3
where ranking = 1;





