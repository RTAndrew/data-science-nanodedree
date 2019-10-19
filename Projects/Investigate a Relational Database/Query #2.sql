/*

 The number of movie rentals by genre and their average rental.

*/

SELECT DISTINCT category.name AS category_name, SUM(t3.count) OVER (PARTITION BY category.name) AS rental_count, 
	AVG(t3.count) OVER (PARTITION BY category.name)
FROM (

	SELECT t2.country, film.title, t2.inventory_id, t2.count
	FROM film
		JOIN inventory
			ON inventory.film_id = film.film_id
		JOIN (
			SELECT DISTINCT t1.country, (t1.inventory_id), COUNT(t1.rented_times) OVER (PARTITION BY t1.inventory_id)
			FROM (

				SELECT country.country, rental.rental_id, rental.inventory_id, COUNT(rental.inventory_id) AS rented_times
				FROM inventory
					JOIN rental 
						ON rental.inventory_id = inventory.inventory_id
					JOIN customer
						ON customer.customer_id = rental.customer_id
					JOIN address
						ON address.address_id = customer.address_id
					JOIN city
						ON city.city_id = address.city_id
					JOIN country
						ON country.country_id = city.country_id
				GROUP BY 1,2
				ORDER BY 1,2

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
ORDER by 1

