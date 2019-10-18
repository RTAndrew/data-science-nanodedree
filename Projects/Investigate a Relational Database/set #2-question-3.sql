/*

Finally, for each of these top 10 paying customers, I would like to find out the difference across their monthly payments during 2007. Please go ahead and write a query to compare the payment amounts in each successive month. Repeat this for each of these 10 paying customers. Also, it will be tremendously helpful if you can identify the customer name who paid the most difference in terms of payments.

*/

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