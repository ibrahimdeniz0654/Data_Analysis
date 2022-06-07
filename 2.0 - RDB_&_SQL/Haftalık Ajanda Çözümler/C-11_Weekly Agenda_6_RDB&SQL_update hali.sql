---- C-11 WEEKLY AGENDA-6 RD&SQL STUDENT
Use SampleRetail;
SELECT * FROM [sale].[customer]
---- 1. List all the cities in the Texas and the numbers of customers in each city.----
SELECT city, COUNT(customer_id) Total
FROM [sale].[customer]
WHERE customer.state = 'TX'
GROUP BY city

-- unique cities
SELECT COUNT( DISTINCT city) as cities
FROM sale.customer;

---- 2. List all the cities in the California which has more than 5 customer, by showing the cities which have more customers first.---
SELECT city, COUNT(customer_id) AS Total
FROM sale.customer
WHERE customer.state = 'CA'
GROUP BY city
HAVING COUNT(customer_id) > 5
ORDER BY Total DESC;

---- 3. List the top 10 most expensive products----
SELECT TOP 10 *
FROM product.product
ORDER BY list_price DESC

---- 4. List store_id, product name and list price and the quantity of the products which are located in the store id 2 and the quantity is greater than 25----
SELECT B.store_id, A.product_name, A.list_price, B.quantity
FROM product.product as A
INNER JOIN product.stock AS B
ON A.product_id = B.product_id
WHERE B.store_id = 2 AND B.quantity > 25

---- 5. Find the sales order of the customers who lives in Boulder order by order date----
SELECT order_id, C.customer_id, last_name
FROM sale.orders as O
LEFT JOIN sale.customer as C 
ON O.customer_id = C.customer_id
WHERE C.city = 'Boulder' 
ORDER BY O.order_date ASC;

---- 6. Get the sales by staffs and years using the AVG() aggregate function.
SELECT	so.staff_id, ss.first_name, ss.last_name, 
		YEAR(so.order_date), 
		AVG(soi.quantity*soi.list_price*(1-soi.discount)) as sales
FROM	sale.staff as ss
JOIN	sale.orders as so
		ON ss.staff_id=so.staff_id
JOIN	sale.order_item as soi
		ON so.order_id=soi.order_id
GROUP BY so.staff_id, ss.first_name, ss.last_name, YEAR(so.order_date)
ORDER BY so.staff_id, YEAR(so.order_date), sales


---- 7. What is the sales quantity of product according to the brands and sort them highest-lowest----
SELECT Br.brand_name, Pr.product_name, 
	SUM(it.quantity) AS miktar  
FROM product.brand Br
 join product.product Pr
	on Br.brand_id = Pr.brand_id
 join sale.order_item it
on Pr.product_id = it.product_id
GROUP BY Br.brand_name, Pr.product_name
ORDER BY miktar DESC;


---- 8. What are the categories that each brand has?----
SELECT Br.brand_name, Pr.product_name, Ca.category_name
FROM product.product Pr
	JOIN product.brand Br
		ON Pr.brand_id=Br.brand_id
	JOIN product.category Ca
		ON Pr.category_id=Ca.category_id
ORDER BY  Br.brand_name, Ca.category_name

---- 9. Select the avg prices according to brands and categories----       ************Need to multiply with quantity*************
SELECT Br.brand_name,Ca.category_name, 
CAST(AVG(Pr.list_price)  as NUMERIC(10,2)) avg_prices
FROM product.product Pr
	JOIN product.brand Br
		ON Pr.brand_id=Br.brand_id
	JOIN product.category Ca
		ON Pr.category_id=Ca.category_id
GROUP BY  Br.brand_name, Ca.category_name
ORDER BY Br.brand_name

---- 10. Select the annual amount of product produced according to brands----
SELECT	pb.brand_name,
		pp.model_year,
		SUM(soi.quantity*soi.list_price*(1-soi.discount)) as annual_amount
FROM	product.brand as pb
JOIN	product.product as pp
		ON pb.brand_id=pp.brand_id
JOIN	sale.order_item as soi
		ON pp.product_id=soi.product_id
GROUP BY pb.brand_name, pp.model_year
ORDER BY pb.brand_name, annual_amount DESC

---- 11. Select the store which has the most sales quantity in 2018.----
SELECT	TOP 1 ss.store_name,
		SUM(soi.quantity) as sales_quantity
FROM	sale.store as ss
JOIN	sale.orders as so
		ON ss.store_id=so.store_id
JOIN	sale.order_item as soi
		ON so.order_id=soi.order_id
WHERE YEAR(so.order_date) = 2018
GROUP BY ss.store_name
ORDER BY sales_quantity DESC

---- 12 Select the store which has the most sales amount in 2018.----
SELECT	TOP 1 ss.store_name,
		CAST(SUM(soi.quantity*soi.list_price*(1-soi.discount)) as NUMERIC(10,2)) as sales_amount
FROM	sale.store as ss
JOIN	sale.orders as so
		ON ss.store_id=so.store_id
JOIN	sale.order_item as soi
		ON so.order_id=soi.order_id
WHERE YEAR(so.order_date) = 2018
GROUP BY ss.store_name
ORDER BY sales_amount DESC

---- 13. Select the personnel which has the most sales amount in 2019.----

SELECT	TOP 10 ss.first_name, ss.last_name, 
		CAST(SUM(soi.quantity*soi.list_price*(1-soi.discount)) as NUMERIC(10,2)) as sales_amount
FROM	sale.staff as ss
JOIN	sale.orders as so
		ON ss.store_id=so.store_id
JOIN	sale.order_item as soi
		ON so.order_id=soi.order_id
WHERE YEAR(so.order_date) = 2019
GROUP BY ss.first_name, ss.last_name
ORDER BY sales_amount DESC