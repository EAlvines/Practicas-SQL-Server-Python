SELECT * FROM customers_ventas

SELECT 
	sale_id,  
	product,
    quantity,
    price,
    sale_date,
	(quantity * price) as Venta_total
FROM sales_ventas
WHERE (quantity * price) > 
	(SELECT AVG(quantity*price) AS PROMEDIO
	FROM sales_ventas);


--CTE
WITH MONTO_TOTAL_COMPRADO AS (
	SELECT 
		S.customer_id,
		C.name as nombre_cliente,
		SUM(PRICE * QUANTITY) AS TOTAL_COMPRADO
	FROM SALES_VENTAS S
	INNER JOIN customers_ventas C ON S.customer_id = C.customer_id
	group by S.customer_id, C.name
		)
SELECT customer_id, nombre_cliente, TOTAL_COMPRADO
FROM MONTO_TOTAL_COMPRADO
WHERE TOTAL_COMPRADO > 5000;

--funcion de ventana: Para cada país enumera y ordena desde mayor para conocer 
--cuál fue la venta más alta (n°1), la segunda (n°2) y así.
SELECT
	C.country,
	S.sale_id,
	S.product,
	S.quantity,
	S.price,
	(S.price * S.quantity) AS MONTO_TOTAL,
	ROW_NUMBER() OVER(PARTITION BY C.COUNTRY ORDER BY (S.price * S.quantity) DESC
	) AS FILAS
FROM sales_ventas S
INNER JOIN customers_ventas C ON S.customer_id = C.customer_id;


