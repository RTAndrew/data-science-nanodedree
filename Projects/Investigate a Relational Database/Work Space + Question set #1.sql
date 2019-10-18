-- Question 1

-- We want to understand more about the movies that families are watching. The following categories are considered family movies: Animation, Children, Classics, Comedy, Family and Music.

-- Create a query that lists each movie, the film category it is classified in, and the number of times it has been rented out.

SELECT film.title, t2.inventory_id, t2.count
FROM film
	JOIN inventory
		ON inventory.film_id = film.film_id
	JOIN (
		SELECT DISTINCT(t1.inventory_id), COUNT(t1.rented_times) OVER (PARTITION BY t1.inventory_id)
		FROM (

			SELECT rental.rental_id, rental.inventory_id, COUNT(rental.inventory_id) AS rented_times
			FROM inventory
				JOIN rental 
					ON rental.inventory_id = inventory.inventory_id
			GROUP BY 1
			ORDER BY 1

		) t1
		ORDER BY 1		
	) t2 ON t2.inventory_id = inventory.inventory_id







SELECT DISTINCT(t1.inventory_id), COUNT(t1.rented_times) OVER (PARTITION BY t1.inventory_id)
FROM (

	SELECT rental.rental_id, rental.inventory_id, COUNT(rental.inventory_id) AS rented_times
	FROM inventory
		JOIN rental 
			ON rental.inventory_id = inventory.inventory_id
	GROUP BY 1
	ORDER BY 1

) t1
ORDER BY 1



-- Final result

SELECT DISTINCT t3.title, category.name AS category_name, SUM(t3.count) OVER (PARTITION BY t3.title) AS rental_count
FROM (

	SELECT film.title, t2.inventory_id, t2.count
	FROM film
		JOIN inventory
			ON inventory.film_id = film.film_id
		JOIN (
			SELECT DISTINCT(t1.inventory_id), COUNT(t1.rented_times) OVER (PARTITION BY t1.inventory_id)
			FROM (

				SELECT rental.rental_id, rental.inventory_id, COUNT(rental.inventory_id) AS rented_times
				FROM inventory
					JOIN rental 
						ON rental.inventory_id = inventory.inventory_id
				GROUP BY 1
				ORDER BY 1

			) t1
			ORDER BY 1		
		) t2 ON t2.inventory_id = inventory.inventory_id
) t3
JOIN film
	ON film.title = t3.title
JOIN film_category
	ON film_category.film_id = film.film_id
JOIN category
	ON category.category_id = film_category.category_id
WHERE category.name IN ('Animation', 'Children', 'Classics', '', 'Comedy', 'Family ', 'Music')
ORDER by 2, 1




















-- Now we need to know how the length of rental duration of these family-friendly movies compares to the duration that all movies are rented for. Can you provide a table with the movie titles and divide them into 4 levels (first_quarter, second_quarter, third_quarter, and final_quarter) based on the quartiles (25%, 50%, 75%) of the rental duration for movies across all categories? Make sure to also indicate the category that these family-friendly movies fall into.
SELECT film.title, category.name AS category_name, film.rental_duration, NTILE(4) OVER (ORDER BY film.rental_duration)
FROM film
	JOIN film_category
	ON film_category.film_id = film.film_id
JOIN category
	ON category.category_id = film_category.category_id
WHERE category.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
ORDER BY 2,4



















-- Finally, provide a table with the family-friendly film category, each of the quartiles, and the corresponding count of movies within each combination of film category for each corresponding rental duration category. 

SELECT DISTINCT t1.category_name, t1.standard_quartile, COUNT(*)
FROM (

	SELECT category.name AS category_name, film.rental_duration, NTILE(4) OVER (ORDER BY film.rental_duration) AS standard_quartile
	FROM film
		JOIN film_category
		ON film_category.film_id = film.film_id
	JOIN category
		ON category.category_id = film_category.category_id
	WHERE category.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
	ORDER BY 1,2

) t1
GROUP BY 1,2
ORDER BY 1, 2








