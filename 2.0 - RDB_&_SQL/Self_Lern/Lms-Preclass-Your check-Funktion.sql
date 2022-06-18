---Functions 2 -
SELECT SC.street
FROM sale.customer SC
WHERE	ISNUMERIC(SUBSTRING(SC.street, CHARINDEX('#', SC.street)+1, 4)) = 1 AND SUBSTRING(SC.street, CHARINDEX('#', SC.street)+1, 4)< 5
ORDER BY	SC.street
;

---join-1
SELECT		PP.product_name, OI.order_id
FROM		product.product PP
LEFT JOIN	sale.order_item OI ON PP.product_id = OI.product_id
LEFT JOIN	product.brand PB ON PB.brand_id = PP.brand_id
WHERE		PB.brand_name = ('Seagate')
ORDER BY	OI.order_id
;
----https://lms.clarusway.com/mod/quiz/review.php?attempt=308118&cmid=18007
--- product_name


---join 2
SELECT		SO.order_date
FROM		sale.orders SO
LEFT JOIN	 sale.order_item OI ON OI.order_id = SO.order_id
LEFT JOIN	 product.product PP ON OI.product_id = PP.product_id
WHERE		PP.product_name = ('Sony - 5.1-Ch. 3D / Smart Blu-ray Home Theater System - Black')
ORDER BY	SO.order_date
;


----In progress
---https://lms.clarusway.com/mod/quiz/attempt.php?attempt=309481&cmid=18018&page=1

SELECT		SO.order_date
FROM		sale.orders SO
LEFT JOIN	 sale.order_item OI ON OI.order_id = SO.order_id
LEFT JOIN	 product.product PP ON OI.product_id = PP.product_id
WHERE		PP.product_name = ('Sony - 5.1-Ch. 3D / Smart Blu-ray Home Theater System - Black')
ORDER BY	SO.order_date
;

Adv. Grouping Op. 1-
SELECT OI.order_id
FROM sale.order_item OI
GROUP BY OI.order_id
HAVING AVG((OI.list_price-OI.discount)*OI.quantity) > 2000;

Adv. Grouping Op. 2-
SELECT [sunday], [Monday], [Tuesday], [Wednesday], [Thursday], [Friday], [saturday]
FROM
	(
	SELECT SO.order_id, DATENAME(WEEKDAY, SO.order_date) day_name
	FROM   sale.orders SO
	WHERE SO.order_date BETWEEN '2020-01-19' AND '2020-01-25'
	) AS dayOrderCnt
PIVOT 
	(
	 COUNT(order_id)
	 FOR day_name
	 IN ([Sunday], [Monday], [Tuesday], [Wednesday], [Thursday], [Friday], [saturday])
	) AS pivot_table
;


---pivot TABLE ile yapılıyor. 
Adv. Grouping Op. 2-
SELECT [sunday], [Monday], [Tuesday], [Wednesday], [Thursday], [Friday], [saturday]
FROM
	(
	SELECT SO.order_id, DATENAME(WEEKDAY, SO.order_date) day_name
	FROM   sale.orders SO
	WHERE SO.order_date BETWEEN '2020-01-19' AND '2020-01-25'
	) AS dayOrderCnt
PIVOT 
	(
	 COUNT(order_id)
	 FOR day_name
	 IN ([Sunday], [Monday], [Tuesday], [Wednesday], [Thursday], [Friday], [saturday])
	) AS pivot_table
;


----Dashboard
My courses
RDB & SQL - C11
Set Operators
Check Yourself

Set Opr. 1-
SELECT	SS.store_name
FROM	sale.store SS
GROUP BY SS.store_name
EXCEPT
SELECT	SS.store_name
FROM	sale.store SS, product.stock PS, product.product PP
WHERE	SS.store_id = PS.store_id 
AND		PS.product_id = PP.product_id
AND		PP.product_name = 'Samsung Galaxy Tab S3 Keyboard Cover'
GROUP BY SS.store_name


GROUP BY SS.store_name
EXCEPT
SELECT	SS.store_name
FROM	sale.store SS, product.stock PS, product.product PP
WHERE	SS.store_id = PS.store_id 
AND		PS.product_id = PP.product_id
AND		PP.product_name = 'Samsung Galaxy Tab S3 Keyboard Cover'
GROUP BY SS.store_name
;

The BFLO Store

Burkes Outlet Davi techno Retail


soru : 
Classify staff according to the count of orders they receive as follows:

a) 'High-Performance Employee' if the number of orders is greater than 400
b) 'Normal-Performance Employee' if the number of orders is between 100 and 400
c) 'Low-Performance Employee' if the number of orders is between 1 and 100
d) 'No Order' if the number of orders is 0
Then, list the staff's first name, last name, employee class, and count of orders.  (Count of orders and first names in ascending order)

Personeli aldıkları sipariş sayısına göre aşağıdaki 
gibi sınıflandırınız: 
a) Sipariş sayısı 
400'den fazla ise 'Yüksek Performanslı Çalışan' 
b) Sipariş sayısı 100 ile 400 arasında ise 'Normal Performanslı Çalışan' 
c) Sipariş sayısı 1 ile 100 arasında ise 'Düşük Performanslı Çalışan' 
d) Sipariş sayısı 0 ise 'Sipariş Yok' Ardından personelin adını, soyadını, 
çalışan sınıfı ve sipariş sayısını listeleyin. (Siparişlerin ve isimlerin artan 
sırada sayısı)
Case Exp. 2-
SELECT		SS.first_name, 
			SS.last_name, 
			CASE
				WHEN COUNT(SA.order_id) > 400 THEN 'High-Performance Employee'
				WHEN COUNT(SA.order_id) BETWEEN 100 AND 400 THEN 'Normal-Performance Employee'
				WHEN COUNT(SA.order_id) BETWEEN 1 AND 100 THEN 'Low-Performance Employee'
				WHEN COUNT(SA.order_id) = 0 THEN 'No Order'
			END AS employee_class,
			COUNT(SA.order_id) Count_of_Orders
FROM		sale.staff SS
LEFT JOIN	sale.orders SA
ON			SA.staff_id = SS.staff_id
GROUP BY	SS.first_name, SS.last_name
ORDER BY	4, 1



List counts of orders on the weekend and weekdays. Submit your answer in a single row with two columns. For example: 164 161. First value is for weekend.

(Use SampleRetail Database and paste your result in the box below.)

---Hafta sonu ve hafta içi sipariş sayılarını listeleyin. 
SELECT
--CASE WHEN DATENAME(WEEKDAY, SO.order_date) IN ('Samstag','Sonntag') THEN 'Weekend' ELSE 'Weekday' END AS WED,
	SUM(CASE WHEN DATENAME(WEEKDAY, SO.order_date) IN ('Saturday','Sunday')   THEN 1 ELSE 0 END) AS [weekend],
	SUM(CASE WHEN DATENAME(WEEKDAY, SO.order_date) IN ('Monday','Tuesday','Wednesday','Thursday','Friday')   THEN 1 ELSE 0 END) AS [weekday]
	
FROM sale.orders SO

----
List the store names in ascending order that did not have an order between "2018-07-22" and "2018-07-28".

(Use SampleRetail Database and paste your result in the box below.)


Subquery and CTE 1-
SELECT		DISTINCT SS.store_name
FROM		sale.store SS, sale.orders SO
WHERE		SS.store_name 
IN			(
			SELECT	SS.store_name
			FROM	sale.orders SO, sale.store SS
			WHERE	SO.store_id = SS.store_id
			EXCEPT
			SELECT	SS.store_name
			FROM	sale.orders SO, sale.store SS
			WHERE	SO.order_date BETWEEN '2018-07-22' AND '2018-07-28'
AND			SO.store_id = SS.store_id
			)
AND			SO.store_id = SS.store_id
ORDER BY	SS.store_name
;

List customers with each order over 500$ and reside in the city of Charleston. List customers' first name and last name ( both of the last name and first name in ascending order). 

(Use SampleRetail Database and paste your result in the box below.)

Her siparişte 500$'ın üzerinde olan ve Charleston şehrinde ikamet eden müşterileri listeleyin. Müşterilerin adını ve soyadını listeleyin (hem soyadı hem de adı artan sırada). (SampleRetail Database'i kullanın ve sonucunuzu aşağıdaki kutuya yapıştırın.)
select distinct sc.first_name, sc.last_name,sc.city,so.order_id
from sale.customer sc, sale.orders so, sale.order_item soi
where sc.customer_id = so.customer_id and 
	  so.order_id =  soi.order_id and 
	  sc.city = 'Charleston'  and 
exists 
	(SELECT oi.order_id, SUM(quantity*list_price*(1-discount))
		FROM sale.order_item oi 
		where oi.order_id = so.order_id
		GROUP BY oi.order_id
		having SUM(quantity*list_price*(1-discount)) > 500)
order by 2,1

Write a query using the window function that returns the cumulative total turnovers of the Burkes Outlet by order date between "2019-04-01" and "2019-04-30".

Columns that should be listed are: 'order_date' in ascending order and 'Cumulative_Total_Price'.
Burkes Outlet'in "2019-04-01" ve "2019-04-30" arasındaki sipariş tarihine göre kümülatif toplam cirolarını döndüren pencere işlevini kullanarak bir sorgu yazın. Listelenmesi gereken sütunlar: artan sırada 'order_date' ve 'Cumulative_Total_Price'.

