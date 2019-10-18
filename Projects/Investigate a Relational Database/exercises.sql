	-- -- Let's start with creating a table that provides the following details: 
	-- actor's first and last name combined as full_name, film title, film description and length of the movie
	-- -- How many rows are there in the table?

SELECT CONCAT(actor.first_name, ' ', actor.last_name) AS full_name,
		film.title, film.description, film.length
FROM actor
	JOIN film_actor 
		ON film_actor.actor_id = actor.actor_id
	JOIN film
		ON film.film_id = film_actor.film_id




-- Write a query that creates a list of actors and movies 
-- where the movie length was more than 60 minutes. 
-- How many rows are there in this query result?

SELECT actor.*, film.*
FROM actor
	JOIN film_actor 
		ON film_actor.actor_id = actor.actor_id
	JOIN film
		ON film.film_id = film_actor.film_id AND film.length > 60




-- Write a query that captures the actor id, full name of the actor, 
-- and counts the number of movies each actor has made. 
-- (HINT: Think about whether you should group by actor id or the full name of the actor.) Identify the actor who has made the maximum number movies.

SELECT actor.actor_id, CONCAT(actor.first_name, ' ', actor.last_name) AS full_name, COUNT(film_actor.*)
FROM actor
	JOIN film_actor 
		ON film_actor.actor_id = actor.actor_id
	JOIN film
		ON film.film_id = film_actor.film_id
GROUP BY 1
ORDER BY 3 DESC



-- Write a query that displays a table with 4 columns: actor's full name, 
-- film title, length of movie, and a column name "filmlen_groups" 
-- that classifies movies based on their length. 
-- Filmlen_groups should include 4 categories: 
-- 1 hour or less, Between 1-2 hours, Between 2-3 hours, More than 3 hours.


SELECT CONCAT(actor.first_name, ' ', actor.last_name) AS full_name,
		film.title, film.description, film.length,
	CASE
		WHEN length <= 60 THEN '1 hour or less'
		WHEN length > 60 AND length <= 120  THEN 'Between 1-2 hours'
		WHEN length > 120 AND length <= 180  THEN 'Between 2-3 hours'
		WHEN length > 180 THEN 'More than 3 hours'
	END AS filmlen_groups
FROM actor
JOIN film_actor 
		ON film_actor.actor_id = actor.actor_id
	JOIN film
		ON film.film_id = film_actor.film_id
ORDER BY title




-- Now, we bring in the advanced SQL query concepts! Revise the query you wrote above to create a count of movies in each of the 4 filmlen_groups: 1 hour or less, Between 1-2 hours, Between 2-3 hours, More than 3 hours.
-- Match the count of movies in each filmlen_group.

SELECT DISTINCT COUNT(t1.title) OVER (PARTITION BY t1.filmlen_groups), t1.filmlen_groups
FROM (
	SELECT film.title, length,
	CASE
		WHEN length <= 60 THEN '1 hour or less'
		WHEN length > 60 AND length <= 120  THEN 'Between 1-2 hours'
		WHEN length > 120 AND length <= 180  THEN 'Between 2-3 hours'
		WHEN length > 180 THEN 'More than 3 hours'
	END AS filmlen_groups
FROM film
) t1
