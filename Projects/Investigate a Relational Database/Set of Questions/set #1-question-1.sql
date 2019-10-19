/*
List of each movie, the film category it is classified in, and the number of times it has been rented out.
*/

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
ORDER by 3, 1