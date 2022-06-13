CREATE DATABASE Assignments;
USE Assignments;
-- a) Creating Table and Value Insert:
CREATE TABLE Actions
	(
    VisitorID int,
    Adv_Type varchar(1),
    Action varchar(6)
	)
;
INSERT INTO Actions /*(VisitorID, Adv_Type, Action)*/
VALUES	(1,	'A',	'Left'),
		(2,	'A',	'Order'),
		(3,	'B',	'Left'),
		(4,	'A',	'Order'),
		(5,	'A',	'Review'),
		(6,	'A',	'Left'),
		(7,	'B',	'Left'),
		(8,	'B',	'Order'),
		(9,	'B',	'Review'),
		(10,'A',	'Review')
;
-- DROP TABLE IF EXISTS Actions
-- SELECT * FROM Actions
-- b) Count of total actions and Orders for each Adv type
CREATE VIEW adv_act_cnt AS
	SELECT Adv_Type, Action, COUNT(VisitorID) action_cnt
	FROM Actions
	GROUP BY Adv_Type, Action
;
-- Total Actions
SELECT SUM(action_cnt) total_act
FROM adv_act_cnt
;
-- Total Action Count by each Adv
SELECT Adv_Type, COUNT(Adv_Type) total_cnt
FROM Actions
GROUP BY Adv_Type
;
-- and Orders
SELECT Adv_Type, COUNT(Adv_Type) total_cnt
FROM Actions
WHERE Action = 'Order'
GROUP BY Adv_Type
;
-- Order Actions
CREATE VIEW adv_act_ord_oth AS
	SELECT Adv_Type, action_cnt,
		CASE Action
			WHEN 'Order' THEN 1
			ELSE 0
			END ord_oth
	FROM adv_act_cnt
;
-- Total Orders and Others Count
SELECT Adv_Type, ord_oth, SUM(action_cnt) ord_oth_cnt
FROM adv_act_ord_oth
GROUP BY Adv_Type, ord_oth
;
-- c) Calculation of Orders Conversion Rate for each Adv Type
-- Assign this to a VIEW
CREATE VIEW conv_rate AS
		SELECT Adv_Type, ord_oth, SUM(action_cnt) ord_oth_cnt
		FROM adv_act_ord_oth
		GROUP BY Adv_Type, ord_oth
;
--
SELECT Adv_Type, CASE
		WHEN Adv_Type = 'A' AND ord_oth = 'Order' THEN CAST(ROUND((ord_oth_cnt*1.0)/(SELECT SUM(action_cnt) total_act FROM adv_act_cnt WHERE Adv_Type = 'A'), 2) AS DECIMAL(2,2))
		WHEN Adv_Type = 'B' AND ord_oth = 'Order' THEN CAST(ROUND((ord_oth_cnt*1.0)/(SELECT SUM(action_cnt) total_act FROM adv_act_cnt WHERE Adv_Type = 'B'), 2) AS DECIMAL(2,2))
		END AS Conversion_Rate
INTO Result
FROM conv_rate
DELETE FROM Result WHERE Conversion_Rate IS NULL
-- Result
SELECT * FROM Result