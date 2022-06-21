use SampleRetail
SELECT product_name
FROM [product].[product]
WHERE product_name LIKE 'Samsung%'
ORDER BY product_name

select *
from
(SELECT street
FROM
(SELECT street, RIGHT(street,2) as son2 FROM sale.customer) son2
WHERE son2 in ('#1','#2','#3','#4') )Tablo_3 
order by street
--------
SELECT street , street + '$' as columns2
FROM
(SELECT street, RIGHT(street,2) as son2 FROM sale.customer) son2
WHERE son2 in ('#1','#2','#3','#4') 
order By street

---#3 ve #2 ile bitenler soruda 5 in altýnda olanlar. 

---Write a query that returns the order date of the product named 
-- 'Sony - 5.1-Ch. 3D / Smart Blu-ray Home Theater System - Black'. nedense çift týrnak kabul edilmiyor... 
--- (Use SampleRetail Database and paste your result in the box below.)
 
 SELECT *
 FROM 
 WHERE 
