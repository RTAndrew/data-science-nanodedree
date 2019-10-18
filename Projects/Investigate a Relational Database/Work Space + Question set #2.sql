-- We want to find out how the two stores compare in their count of rental orders during every month for all the years we have data for. Write a query that returns the store ID for the store, the year and month and the number of rental orders each store has fulfilled for that month. Your table should include a column for each of the following: year, month, store ID and count of rental orders fulfilled during that month.

SELECT DATE_PART('month', rental.rental_date) AS month, DATE_PART('year', rental.rental_date) AS year, store.store_id, COUNT(rental.*) AS count_rentals
FROM store
	JOIN staff
		ON staff.staff_id = store.manager_staff_id
	JOIN rental
		ON rental.staff_id = staff.staff_id
GROUP BY 1,2,3
ORDER BY 1,2





-- We would like to know who were our top 10 paying customers, how many payments they made on a monthly basis during 2007, and what was the amount of the monthly payments. Can you write a query to capture the customer name, month and year of payment, and total payment amount for each month by these top 10 paying customers?

WITH table1 AS (
	SELECT DATE_TRUNC('month', payment.payment_date) AS payment_month, 
			CONCAT(customer.first_name,' ', customer.last_name) AS fullname, 
			COUNT(payment.*) AS pay_count_per_month,
			SUM(payment.amount) AS payment_amount
	FROM customer
		JOIN payment
			ON payment.customer_id = customer.customer_id
	GROUP BY 1,2
	ORDER BY 2,4
),

table2 AS (

	SELECT t1.fullname, SUM(t1.payment_amount) AS total_payments
	FROM (

		SELECT DATE_TRUNC('month', payment.payment_date) AS payment_month, 
				CONCAT(customer.first_name,' ', customer.last_name) AS fullname, 
				COUNT(payment.*) AS pay_count_per_month,
				SUM(payment.amount) AS payment_amount
		FROM customer
			JOIN payment
				ON payment.customer_id = customer.customer_id
		GROUP BY 1,2
		ORDER BY 2,4

	) t1
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 10
)



SELECT table1.*
FROM table2
	JOIN table1 
		ON table1.fullname = table2.fullname






-- Finally, for each of these top 10 paying customers, I would like to find out the difference across their monthly payments during 2007. Please go ahead and write a query to compare the payment amounts in each successive month. Repeat this for each of these 10 paying customers. Also, it will be tremendously helpful if you can identify the customer name who paid the most difference in terms of payments.
WITH table1 AS (
	SELECT DATE_PART('month', payment.payment_date) AS payment_month, 
			CONCAT(customer.first_name,' ', customer.last_name) AS fullname, 
			COUNT(payment.*) AS pay_count_per_month,
			SUM(payment.amount) AS payment_amount
	FROM customer
		JOIN payment
			ON payment.customer_id = customer.customer_id
	GROUP BY 1,2
	ORDER BY 2,4
),

table2 AS (

	SELECT t1.fullname, SUM(t1.payment_amount) AS total_payments
	FROM (

		SELECT DATE_PART('month', payment.payment_date) AS payment_month, 
				CONCAT(customer.first_name,' ', customer.last_name) AS fullname, 
				COUNT(payment.*) AS pay_count_per_month,
				SUM(payment.amount) AS payment_amount
		FROM customer
			JOIN payment
				ON payment.customer_id = customer.customer_id
		GROUP BY 1,2
		ORDER BY 2,4

	) t1
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 10
),

table3 AS (

	SELECT t1.*,
			LEAD(t1.payment_amount) OVER (PARTITION BY t1.fullname ORDER BY t1.payment_month) AS lead
	FROM (
		
		SELECT table1.*
		FROM table2
			JOIN table1 
				ON table1.fullname = table2.fullname

	) t1
)




SELECT t1.*,
		CASE 
			WHEN t1.difference_in_payments = (
				SELECT MAX(t1.difference_in_payments)
				FROM (
					SELECT table3.*, 
							(table3.lead - table3.payment_amount) AS difference_in_payments
					FROM table3
				) t1
			)
			THEN 'maximum difference amount'
		END AS maximun_difference_amount
FROM (
	SELECT table3.*, 
			(table3.lead - table3.payment_amount) AS difference_in_payments
	FROM table3

) t1
