/*
A table with the movie titles and the category they fall based on the quartiles of the rental duration for movies across all categories
*/


SELECT film.title, category.name AS category_name, film.rental_duration, NTILE(4) OVER (ORDER BY film.rental_duration)
FROM film
	JOIN film_category
	ON film_category.film_id = film.film_id
JOIN category
	ON category.category_id = film_category.category_id
WHERE category.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
ORDER BY 2,4