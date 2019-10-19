/*

	The performance (payment amount and number of rentals) of Sakila DVD Rental database

*/



SELECT DATE_PART('month', rental.rental_date) AS month, DATE_PART('year', rental.rental_date) AS year, store.store_id, COUNT(rental.*) AS count_rentals, SUM(payment.amount)
FROM store
	JOIN staff
		ON staff.staff_id = store.manager_staff_id
	JOIN rental
		ON rental.staff_id = staff.staff_id
	JOIN payment
		ON payment.rental_id = rental.rental_id
GROUP BY 1,2,3
ORDER BY 2,1