-- Lesson 2: SQL JOINS
-- Video 19


SELECT region.name AS region_name, sales_reps.name AS sales_name, accounts.name AS acc_name
FROM accounts
JOIN sales_reps 
	ON sales_reps.id = accounts.sales_rep_id
JOIN region
	ON region.id = sales_reps.region_id
WHERE region.name = 'Midwest'
ORDER BY accounts.name 



SELECT region.name AS region_name, sales_reps.name AS sales_name, accounts.name AS acc_name
FROM accounts
JOIN sales_reps 
	ON sales_reps.id = accounts.sales_rep_id
JOIN region
	ON region.id = sales_reps.region_id
WHERE region.name = 'Midwest' AND sales_reps.name LIKE 'S%'
ORDER BY accounts.name 



SELECT region.name AS region_name, accounts.name AS acc_name
FROM accounts
JOIN sales_reps 
	ON sales_reps.id = accounts.sales_rep_id
JOIN region
	ON region.id = sales_reps.region_id
WHERE region.name = 'Midwest' AND sales_reps.name LIKE '% K%'
ORDER BY accounts.name 




SELECT region.name AS region_name, accounts.name AS acc_name, orders.total_amt_usd/(orders.total+0.01) AS unit_price
FROM accounts
JOIN sales_reps 
	ON sales_reps.id = accounts.sales_rep_id
JOIN region
	ON region.id = sales_reps.region_id
JOIN orders
	ON orders.account_id = accounts.id
WHERE orders.standard_qty >= 100




SELECT region.name AS region_name, accounts.name AS acc_name, orders.total_amt_usd/(orders.total+0.01) AS unit_price
FROM accounts
JOIN sales_reps 
	ON sales_reps.id = accounts.sales_rep_id
JOIN region
	ON region.id = sales_reps.region_id
JOIN orders
	ON orders.account_id = accounts.id
WHERE orders.standard_qty >= 100 AND  poster_qty >= 50




SELECT region.name AS region_name, accounts.name AS acc_name, orders.total_amt_usd/(orders.total+0.01) AS unit_price
FROM accounts
JOIN sales_reps 
	ON sales_reps.id = accounts.sales_rep_id
JOIN region
	ON region.id = sales_reps.region_id
JOIN orders
	ON orders.account_id = accounts.id
WHERE orders.standard_qty >= 100 AND  poster_qty >= 50
ORDER BY unit_price






SELECT accounts.name, DISTINCT(web_events.channel) 
FROM accounts
JOIN web_events
	ON web_events.account_id = accounts.id
WHERE web_events.id = '1001'




SELECT orders.occurred_at, accounts.name, orders.total, orders.total_amt_usd
FROM orders
JOIN accounts	
	ON accounts.id = orders.account_id
WHERE occurred_at BETWEEN '2015-01-01' AND '2016-01-01'







-- Lesson 3: SQL AGGREGATION
-- Video 14

SELECT accounts.name 
FROM accounts
JOIN orders 
	ON orders.account_id = accounts.id
WHERE occurred_at = (
SELECT MIN(orders.occurred_at) AS date
FROM accounts
JOIN orders 
	ON orders.account_id = accounts.id)





SELECT accounts.name, SUM(total_amt_usd)
FROM accounts
JOIN orders 
	ON orders.account_id = accounts.id
GROUP BY accounts.name





SELECT web_events.occurred_at, web_events.channel, accounts.name
FROM accounts
JOIN web_events 
	ON web_events.account_id = accounts.id
ORDER BY web_events
LIMIT 1


SELECT web_events.channel, COUNT(web_events.channel)
FROM web_events
GROUP BY channel





SELECT accounts.name, web_events.occurred_at 
FROM accounts
JOIN web_events 
	ON web_events.account_id = accounts.id
ORDER BY web_events.occurred_at 
LIMIT 1



SELECT accounts.name, MIN(orders.total_amt_usd)
FROM accounts
JOIN orders 
	ON orders.account_id = accounts.id
GROUP BY accounts.name




SELECT sales_reps.name, count(*)
FROM sales_reps
JOIN accounts 
	ON accounts.sales_rep_id = sales_reps.id
GROUP BY sales_reps.name
HAVING COUNT(*) > 5



SELECT accounts.name, count(orders.*) AS num_orders
FROM accounts
JOIN orders 
	ON orders.account_id = accounts.id
GROUP BY accounts.name
HAVING count(orders.*) > 20
ORDER BY num_orders



SELECT accounts.name, COUNT(orders.id) AS num_orders
FROM accounts
JOIN orders 
	ON orders.account_id = accounts.id
GROUP BY accounts.name
ORDER BY num_orders DESC
LIMIT 1



SELECT accounts.name, MAX(orders.total_amt_usd) AS num_orders
FROM accounts
JOIN orders 
	ON orders.account_id = accounts.id
GROUP BY accounts.name
HAVING MAX(orders.total_amt_usd) >= 30000
ORDER BY num_orders DESC



SELECT accounts.name, MIN(orders.total_amt_usd) AS num_orders
FROM accounts
JOIN orders 
	ON orders.account_id = accounts.id
GROUP BY accounts.name
HAVING MIN(orders.total_amt_usd) < 1000
ORDER BY num_orders DESC



SELECT accounts.name, MAX(orders.total_amt_usd) AS num_orders
FROM accounts
JOIN orders 
	ON orders.account_id = accounts.id
GROUP BY accounts.name
ORDER BY num_orders DESC
LIMIT 1




SELECT accounts.name, MIN(orders.total_amt_usd) AS num_orders
FROM accounts
JOIN orders 
	ON orders.account_id = accounts.id
GROUP BY accounts.name
ORDER BY num_orders DESC
LIMIT 1



SELECT accounts.name, COUNT(*) num_channel
FROM accounts
JOIN web_events
	ON web_events.account_id = accounts.id
WHERE web_events.channel = 'facebook'
GROUP BY accounts.name
HAVING COUNT(*) > 6
ORDER BY num_channel DESC
LIMIT 1

-- Video 14

SELECT DATE_PART('year', occurred_at) as date, SUM(total_amt_usd) as total
FROM orders
GROUP BY date
ORDER BY total DESC

SELECT DATE_PART('mon', occurred_at), SUM(total_amt_usd)
FROM orders
GROUP BY 1
ORDER BY 2 DESC

SELECT DATE_TRUNC('month', occurred_at), MAX(gloss_amt_usd)
FROM accounts
JOIN orders 
	ON orders.account_id = accounts.id
WHERE name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1







-- Lesson 3: SQL SUBQUERIES AND TEMP. TABLES
-- Video 3

SELECT AVG(event_per_day_channel.count), event_per_day_channel.channel
FROM  (	SELECT DATE_TRUNC('day', occurred_at), channel, COUNT(*)
	FROM web_events
	GROUP BY 1, 2
	ORDER BY 2
	) AS event_per_day_channel
GROUP BY 2

-- Video 4
SELECT AVG(tb.standard_qty) avg_standard, AVG(poster_qty) avg_poster, AVG (gloss_qty) avg_gloss
FROM (SELECT DATE_TRUNC('month', occurred_at) AS date, *
	FROM orders) AS tb
WHERE tb.date = (SELECT DATE_TRUNC('month', MIN(occurred_at)) AS date
	FROM orders
	order by 1
	limit 1)

SELECT SUM(total_amt_usd) as total_amt_usd
FROM (SELECT DATE_TRUNC('month', occurred_at) AS date, *
	FROM orders) AS tb
WHERE tb.date = (SELECT DATE_TRUNC('month', MIN(occurred_at)) AS date
	FROM orders
	order by 1
	limit 1)


-- Video 10


SELECT t2.name, t2.total_amt_usd, t2.region_name
FROM (
	SELECT sales_reps.name, SUM(total_amt_usd) AS total_amt_usd, region.name as region_name
			FROM accounts
					JOIN sales_reps 
						ON sales_reps.id = accounts.sales_rep_id
					JOIN orders
						ON orders.account_id = accounts.id
					JOIN region
						ON region.id = sales_reps.region_id
			GROUP BY 1,3
) t2

JOIN (

	SELECT t1.region_name, MAX(t1.total_amt_usd)
	FROM (
		SELECT sales_reps.name, SUM(total_amt_usd) AS total_amt_usd, region.name as region_name
		FROM accounts
				JOIN sales_reps 
					ON sales_reps.id = accounts.sales_rep_id
				JOIN orders
					ON orders.account_id = accounts.id
				JOIN region
					ON region.id = sales_reps.region_id
		GROUP BY 1,3
		ORDER BY 2,3
	) as t1
	GROUP BY 1

) t3 ON t3.max = t2.total_amt_usd





SELECT region.name, SUM(total_amt_usd) AS total_amt_usd, COUNT(orders.*)
FROM accounts
		JOIN sales_reps 
			ON sales_reps.id = accounts.sales_rep_id
		JOIN orders
			ON orders.account_id = accounts.id
		JOIN region
			ON region.id = sales_reps.region_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1



SELECT accounts.name, SUM(total) as total_purchase
FROM accounts
	JOIN orders
		ON orders.account_id = accounts.id
GROUP BY 1
HAVING SUM(total) > (
	SELECT total_purchase
	FROM (
		SELECT accounts.name, SUM(orders.total) as total_purchase, SUM(orders.standard_qty) as total_paper
		FROM accounts
			JOIN orders
				ON orders.account_id = accounts.id
		GROUP BY 1
		ORDER BY 3 DESC
		LIMIT 1
	) t1
)



SELECT accounts.name, web_events.channel, COUNT(web_events.*)
FROM accounts
	JOIN web_events
		ON web_events.account_id = accounts.id
WHERE name = (
	SELECT t1.name 
	FROM (
		SELECT accounts.name, SUM(total_amt_usd)
		FROM accounts
			JOIN orders
				ON orders.account_id = accounts.id
		GROUP BY 1
		ORDER BY 2 DESC
		LIMIT 1
	) t1

)
GROUP BY 1, 2
ORDER BY 1





SELECT AVG(t2.avg)
FROM (
	SELECT t1.name, AVG(t1.total_spent)
	FROM accounts
		JOIN orders
			ON orders.account_id = accounts.id
		JOIN (
				SELECT accounts.name, SUM(total_amt_usd) AS total_spent
				FROM accounts
					JOIN orders
						ON orders.account_id = accounts.id
				GROUP BY 1
				ORDER BY 2 DESC
				LIMIT 10
			) t1 ON t1.name = accounts.name
	GROUP BY 1
	ORDER BY 1
) t2











-- Lesson 4: Data Cleaning
-- Video 3

SELECT RIGHT(accounts.website, 3) AS website, COUNT(*)
FROM accounts
GROUP BY 1
ORDER BY 1 DESC



SELECT t1.name, (COUNT(t1.name) / (SELECT SUM(t2.amount) AS total
		FROM (
			SELECT t1.name, COUNT(t1.name) AS amount
			FROM (
				SELECT LEFT(name, 1) AS name
				FROM accounts
				ORDER BY 1
			) t1
			GROUP BY 1
		) t2)) AS amount
	FROM (
		SELECT LEFT(name, 1) AS name
		FROM accounts
		ORDER BY 1
	) t1
	GROUP BY 1

--Para certificar

SELECT SUM(amount) 
FROM (
	SELECT t1.name, (COUNT(t1.name) / (SELECT SUM(t2.amount) AS total
		FROM (
			SELECT t1.name, COUNT(t1.name) AS amount
			FROM (
				SELECT LEFT(name, 1) AS name
				FROM accounts
				ORDER BY 1
			) t1
			GROUP BY 1
		) t2)) AS amount
	FROM (
		SELECT LEFT(name, 1) AS name
		FROM accounts
		ORDER BY 1
	) t1
	GROUP BY 1
) t4



-- Video 6


SELECT primary_poc, LEFT(primary_poc, (POSITION(' ' IN primary_poc))-1) as first_name, RIGHT(primary_poc, LENGTH(primary_poc)-(POSITION(' ' IN primary_poc))) as last_name
FROM accounts

SELECT LOWER( CONCAT(t1.first_name, t1.last_name, '@', LOWER(t1.company_name), '.com') )
FROM (
	SELECT name AS company_name, primary_poc, LEFT(primary_poc, (POSITION(' ' IN primary_poc))-1) as first_name, RIGHT(primary_poc, LENGTH(primary_poc)-(POSITION(' ' IN primary_poc))) as last_name
	FROM accounts
) t1


SELECT accounts.name as acc_name, accounts.primary_poc, sales_reps.name as sales_name
FROM sales_reps
LEFT JOIN accounts 
	ON accounts.sales_rep_id = sales_reps.id AND accounts.primary_poc < sales_reps.name
