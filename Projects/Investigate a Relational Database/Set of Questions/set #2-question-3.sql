/*
A list of family-friendly film category, each of the quartiles, and the corresponding count of movies within each combination of film category.
*/

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