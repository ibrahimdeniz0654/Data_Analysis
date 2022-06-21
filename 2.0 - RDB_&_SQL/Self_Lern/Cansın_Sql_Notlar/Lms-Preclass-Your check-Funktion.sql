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

