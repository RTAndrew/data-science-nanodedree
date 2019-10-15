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




