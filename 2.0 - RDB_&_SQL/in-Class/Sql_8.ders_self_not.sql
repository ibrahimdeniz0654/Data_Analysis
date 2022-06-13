---- session  - 8

Use SampleRetail
-- Session - 8
-- A�a��daki �r�n� sat�n alan m��terilerin eyalet listesi
select	distinct C.state
from	product.product P,
		sale.order_item I,
		sale.orders O,
		sale.customer C
where	P.product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White' and
		P.product_id = I.product_id and
		I.order_id = O.order_id and
		O.customer_id = C.customer_id
;

7:40
select	distinct [state]
from	sale.customer C2
where	not exists (
			select	distinct C.state
			from	product.product P,
					sale.order_item I,
					sale.orders O,
					sale.customer C
			where	P.product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White' and
					P.product_id = I.product_id and
					I.order_id = O.order_id and
					O.customer_id = C.customer_id and
					C2.state = C.state
		)
;

------

select	distinct [state]
from	sale.customer C2
EXCEPT
select	distinct C.state
			from	product.product P,
					sale.order_item I,
					sale.orders O,
					sale.customer C
			where	P.product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White' and
					P.product_id = I.product_id and
					I.order_id = O.order_id and
					O.customer_id = C.customer_id
;


--Burkes Outlet ma�aza sto�unda bulunmay�p,
-- Davi techno ma�azas�nda bulunan �r�nlerin stok bilgilerini d�nd�ren bir sorgu yaz�n. (edited) 

SELECT PC.product_id, PC.store_id, PC.quantity
FROM product.stock PC, sale.store SS
WHERE PC.store_id = SS.store_id AND SS.store_name = 'Davi techno Retail' AND
EXISTS( SELECT DISTINCT A.product_id, A.store_id, A.quantity
	FROM product.stock A, sale.store B
	WHERE A.store_id = B.store_id AND B.store_name = 'Burkes Outlet' AND PC.product_id = A.product_id AND A.quantity=0)

	----
SELECT PC.product_id, PC.store_id, PC.quantity
FROM product.stock PC, sale.store SS
WHERE PC.store_id = SS.store_id AND SS.store_name = 'Davi techno Retail' AND
	NOT EXISTS ( SELECT DISTINCT A.product_id, A.store_id, A.quantity
			FROM product.stock A, sale.store B
			WHERE A.store_id = B.store_id AND B.store_name = 'Burkes Outlet' AND
				PC.product_id = A.product_id AND A.quantity>0
	)
;

---Burkes Outlet storedan al�n�p The BFLO Store ma�azas�ndan hi� al�nmayan �r�n var m�?
-- Varsa bu �r�nler nelerdir?
-- �r�nlerin sat�� bilgileri istenmiyor, sadece �r�n listesi isteniyor.
SELECT P.product_name
FROM product.product P
WHERE NOT EXISTS (
SELECt I.product_id
FROM sale.order_item I, sale.orders O, sale.store S
WHERE I.order_id = O.order_id AND S.store_id = O.store_id 
AND S.store_name = 'The BFLO Store' 
and P.product_id = I.product_id)


---CTE
--- Jerald Berray isimli m��terinin son sipari�inden �nce sipari� vermi� 
--ve Austin �ehrinde ikamet eden m��terileri listeleyin.


with tbl AS (
	select	max(b.order_date) JeraldLastOrderDate
	from	sale.customer a, sale.orders b
	where	a.first_name = 'Jerald' and a.last_name = 'Berray'
			and a.customer_id = b.customer_id
)
select	*
from	sale.customer a,
		Sale.orders b,
		tbl c
where	a.city = 'Austin' and a.customer_id = b.customer_id and
		b.order_date < c.JeraldLastOrderDate
;


---S�ra Sizde:
-- Herbir markan�n sat�ld��� en son tarihi bir CTE sorgusunda,
-- Yine herbir markaya ait ka� farkl� �r�n bulundu�unu da ayr� bir CTE sorgusunda tan�mlay�n�z.
-- Bu sorgular� kullanarak  Logitech ve Sony markalar�na ait son sat�� tarihini ve toplam �r�n say�s�n� (product tablosundaki) ayn� sql sorgusunda d�nd�r�n�z.

with tbl as(
	select	soi.product_id, max(so.order_date) LastOrderDate
	from	sale.orders so, sale.order_item soi
	where	so.order_id=soi.order_id
	group by soi.product_id
), 
tbl2 as(
	select	pp.product_id, pb.brand_name, count(*) count_brand
	from	product.brand pb, product.product pp
	where	pb.brand_id=pp.brand_id
	group by pp.product_id, pb.brand_name

)
select	* 
from	tbl a, tbl2 b
where	a.product_id=b.product_id
;

----ismail beyden... 

WITH tbl1 ( brand_id, name_,marka,son_tarih) AS(
SELECT B.brand_id, B.brand_name, COUNT(*) AS marka_say�, MAX(D.order_date)
FROM product.product A, product.brand B, sale.order_item C, sale.orders D
WHERE A.brand_id = B.brand_id AND A.product_id = C.product_id AND C.order_id = D.order_id
GROUP BY B.brand_id, B.brand_name )
SELECT DISTINCT B.*
FROM product.brand A, tbl1 B
WHERE B.name_ = 'Logitech ' OR B.name_ = 'Sony '
----

son kod.
with tbl as(
	select	br.brand_id, br.brand_name, max(so.order_date) LastOrderDate
	from	sale.orders so, sale.order_item soi, product.product pr, product.brand br
	where	so.order_id=soi.order_id and
			soi.product_id = pr.product_id and
			pr.brand_id = br.brand_id
	group by br.brand_id, br.brand_name
),
tbl2 as(
	select	pb.brand_id, pb.brand_name, count(*) count_product
	from	product.brand pb, product.product pp
	where	pb.brand_id=pp.brand_id
	group by pb.brand_id, pb.brand_name
)
select	*
from	tbl a, tbl2 b
where	a.brand_id=b.brand_id and
		a.brand_name in ('Logitech', 'Sony')
;

--- 2020 ocak ay�n�n herbir tarihi bir sat�r olacak �ekilde 31 sat�rl� bir tablo olu�turunuz.

D1109- �smail
  1 minute ago
with cte AS (
	select cast('2020-01-01' as date) AS gun
	union all
	select DATEADD(DAY,1,gun)
	from cte
	where gun < EOMONTH('2020-01-01')
)
select * from cte;


F1329 - allen
  < 1 minute ago
with cte as(
	select	CAST('2020-01-01' AS DATETIME) [date]
	UNION ALL
	select DATEADD(dd, 1, t.[date]) 
    from cte t
    where DATEADD(dd, 1, t.[date]) <= '2020-01-31'
) select * from cte;

----- 2020 ocak ay�n�n herbir tarihi bir sat�r olacak �ekilde 31 sat�rl� bir tablo olu�turunuz.
with ocak as (
	select	cast('2020-01-01' as date) tarih
	union all
	select	cast(DATEADD(DAY, 1, tarih) as date) tarih
	from ocak
	where tarih < '2020-01-31'
)
select * from ocak;
with cte AS (
	select cast('2020-01-01' as date) AS gun
	union all
	select DATEADD(DAY,1,gun)
	from cte
	where gun < EOMONTH('2020-01-01')
)
select gun tarih, day(gun) gun, month(gun) ay, year(gun) yil,
	EOMONTH(gun) ayinsongunu
from cte;


--Write a query that returns all staff with their manager_ids. (use recursive CTE)
with cte as (
	select	staff_id, first_name, manager_id
	from	sale.staff
	where	staff_id = 1
	union all
	select	a.staff_id, a.first_name, a.manager_id
	from	sale.staff a, cte b
	where	a.manager_id = b.staff_id
)
select *
from	cte
;


---- alternatif y�ntem cte siz...
select staff_id, first_name, manager_id
from sale.staff
order by manager_id

-------2018 y�l�nda t�m ma�azalar�n ortalama cirosunun alt�nda ciroya sahip ma�azalar� listeleyin.
--List the stores their earnings are under the average income in 2018.

WITH T1 AS (
SELECT	c.store_name, SUM(list_price*quantity*(1-discount)) Store_earn
FROM	sale.orders A, SALE.order_item B, sale.store C
WHERE	A.order_id = b.order_id
AND		A.store_id = C.store_id
AND		YEAR(A.order_date) = 2018
GROUP BY C.store_name
),
T2 AS (
SELECT	AVG(Store_earn) Avg_earn
FROM	T1
)
SELECT *
FROM T1, T2
WHERE T2.Avg_earn > T1.Store_earn
;