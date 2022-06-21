-- ASSIGNMENT - 4

USE SampleRetail;

/*
Generate a report including product IDs and discount effects on 
whether the increase in the discount rate positively impacts 
the number of orders for the products.

In this assignment, you are expected to generate a solution using SQL 
with a logical approach. 
*/
--- Grup içinde uzun bir tartýþma sonucu Order id üzerinden hesaplamalar yapýldý ve mantýk bunu üzerine kuruldu. 
SELECT		product_id, discount, COUNT(order_id) cnt
FROM		sale.order_item
GROUP BY	product_id, discount
ORDER BY	product_id, discount
;

CREATE VIEW next_slope
AS
SELECT	product_id, discount, COUNT(order_id) cnt,
LEAD(COUNT(order_id)) OVER (PARTITION BY product_id ORDER BY	discount) next_cnt,
CASE
	WHEN	(LEAD(COUNT(order_id)) OVER (PARTITION BY product_id ORDER BY	discount) - COUNT(order_id)) > 0	THEN	'Positive'
	WHEN	(LEAD(COUNT(order_id)) OVER (PARTITION BY product_id ORDER BY	discount) - COUNT(order_id)) < 0	THEN	'Negative'
	WHEN	(LEAD(COUNT(order_id)) OVER (PARTITION BY product_id ORDER BY	discount) - COUNT(order_id)) = 0	THEN	'Neutral'
	ELSE	NULL
	END slope
FROM	sale.order_item
GROUP BY product_id, discount
;

SELECT	*
FROM	next_slope
;

CREATE VIEW avg_slope
AS
SELECT		product_id, AVG(cnt) avg_cnt, AVG(next_cnt) avg_next_cnt
FROM		next_slope
GROUP BY	product_id
;

SELECT		product_id,
			CASE
				WHEN	avg_next_cnt > avg_cnt	THEN	'Positive'
				WHEN	avg_next_cnt < avg_cnt	THEN	'Negative'
				WHEN	avg_next_cnt = avg_cnt	THEN	'Neutral'
				ELSE	NULL
			END	Discount_Effect
FROM		avg_slope
;


