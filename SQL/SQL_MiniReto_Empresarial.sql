--Retail Market SAC
--Identificar los productos más vendidos en cada país
--quiénes son los mejores clientes por país
--con ranking y montos incluidos

WITH VENTAS_PRODUCTO_PAIS AS (
	SELECT 
		C.country,
		s.product,
		SUM(s.price * s.quantity) AS Monto_total
	FROM sales_ventas S
	INNER JOIN customers_ventas C on s.customer_id = c.customer_id
	GROUP BY c.country, s.product
),
RANKING AS (
	SELECT 
	country,
	product,
	Monto_total,
	RANK() OVER(PARTITION BY country ORDER BY Monto_total DESC) AS Rank_producto
	FROM VENTAS_PRODUCTO_PAIS )

SELECT * FROM RANKING
WHERE Rank_producto <= 3; 


--para cada país, muestra el Top 3 de clientes según el monto total gastado
--con Ranking

WITH MONTO_TOTAL_CLIENTE AS (
	SELECT 
		C.country,
		S.customer_id,
		c.name,
		SUM(s.price * s.quantity) as Total_Gastado
	FROM sales_ventas S
	INNER JOIN customers_ventas C ON S.customer_id = C.customer_id
	GROUP BY C.country, S.customer_id, C.name
),
RANKING_TOP AS (
	SELECT
		country,
		customer_id,
		name,
		Total_Gastado,
		RANK() OVER(PARTITION BY country ORDER BY Total_Gastado DESC) AS TOP_3
FROM MONTO_TOTAL_CLIENTE)

SELECT * FROM RANKING_TOP
WHERE TOP_3 <= 3
ORDER BY country, TOP_3;