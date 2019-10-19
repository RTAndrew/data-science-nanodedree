/*

We want to find out how the two stores compare in their count of rental orders during every month for all the years we have data for. Write a query that returns the store ID for the store, the year and month and the number of rental orders each store has fulfilled for that month. Your table should include a column for each of the following: year, month, store ID and count of rental orders fulfilled during that month.

*/


SELECT DATE_PART('month', rental.rental_date) AS month, DATE_PART('year', rental.rental_date) AS year, store.store_id, COUNT(rental.*) AS count_rentals
FROM store
	JOIN staff
		ON staff.staff_id = store.manager_staff_id
	JOIN rental
		ON rental.staff_id = staff.staff_id
GROUP BY 1,2,3
ORDER BY 1,2
