/*

 top 10 paying customers, how many payments they made on a monthly basis during 2007

*/

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


