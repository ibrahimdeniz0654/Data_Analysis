---- RDB&SQL Exercise-2 Student

----1. By using view get the average sales by staffs and years using the AVG() aggregate function.
USE SampleRetail;
----1. By using view get the average sales by staffs and years using the AVG() aggregate function.
CREATE VIEW avg_sales
AS
SELECT S.staff_id, YEAR(O.order_date) AS years, AVG((OI.list_price * OI.quantity)*(1-OI.discount)) AS avg_sale
FROM	sale.orders AS O
INNER JOIN sale.staff AS S
ON O.staff_id = S.staff_id
INNER JOIN sale.order_item AS OI
ON O.order_id = OI.order_id
GROUP BY S.staff_id, YEAR(O.order_date);

SELECT *
FROM avg_sales ;
----2. Select the annual amount of product produced according to brands (use window functions).
SELECT B.brand_name, P.model_year, P.product_id,
COUNT(P.product_id) 
OVER(
Partition By B.brand_name, P.model_year) AS annual_amount
FROM product.brand B
INNER JOIN product.product p
ON B.brand_id = P.brand_id
order by B.brand_name, P.model_year

----3. Select the least 3 products in stock according to stores.

SELECT		*
FROM		(
		SELECT		S.store_name, P.product_name, SUM(ST.quantity) quantity,
					ROW_NUMBER()
					OVER(PARTITION BY S.store_name ORDER BY SUM(ST.quantity) ASC) AS least3
		FROM		sale.store S
		INNER JOIN	product.stock ST
		ON			S.store_id = ST.store_id
		INNER JOIN	product.product P
		ON			ST.product_id = P.product_id
		GROUP BY	S.store_name, P.product_name
		HAVING		SUM(ST.quantity) > 0
		) A
WHERE		A.least3 < 4

----4. Return the average number of sales orders in 2020 sales
SELECT AVG(number_of_sales) avg_num_sales
FROM      (
		SELECT S.order_id, Count(OI.order_id) As number_of_sales
		FROM	sale.order_item OI
		INNER JOIN sale.orders S
		ON	OI.ORDER_ÝD = S.order_id
		AND	YEAR(S.order_date) = 2020
		GROUP BY s.order_id
		) AS sale_order
----5. Assign a rank to each product by list price in each brand and get products with rank less than or equal to three.

SELECT *
FROM (SELECT *,
	  RANK() 
	  OVER (PARTITION BY brand_id ORDER BY list_price) AS rank1
	  FROM	product.product
	  ) AS A 
WHERE rank1 <= 3;

----

SELECT *
FROM (SELECT *,
	  DENSE_RANK() 
	  OVER (PARTITION BY brand_id ORDER BY list_price) AS rank1
	  FROM	product.product
	  ) AS A 
WHERE rank1 <= 3
