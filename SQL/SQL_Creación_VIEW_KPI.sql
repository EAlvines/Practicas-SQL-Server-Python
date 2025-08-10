select * from sales_ventas

DROP VIEW IF EXISTS vw_resumen_mensual;
GO

CREATE VIEW vw_resumen_mensual AS
SELECT
	RIGHT(product_code, LEN(product_code) - CHARINDEX('_', product_code, CHARINDEX('_', product_code) + 1)) AS PRODUCTO_NOMBRE,
	YEAR(sale_date) AS AÑO,
	MONTH(SALE_DATE) AS MES,
	SUM(QUANTITY) AS TOTAL_CANTIDAD,
	SUM((PRICE * QUANTITY) - ISNULL(DISCOUNT, 0.00)) AS TOTAL_MONTO,
	COUNT(SALE_ID) AS CANTIDAD_VENTAS
FROM sales_ventas_raw
GROUP BY
	RIGHT(product_code, LEN(product_code) - CHARINDEX('_', product_code, CHARINDEX('_', product_code) + 1)),
	YEAR(sale_date),
	MONTH(SALE_DATE);

	--PARA CONSULTAR EL VIEW
SELECT * FROM vw_resumen_mensual;

--Vista combinada de Ventas + Clientes - MINIRETO
--vista llamada vw_ventas_clientes que combine ventas limpias con la información del cliente. 
--Servirá para analizar comportamiento por país, cliente y producto.

CREATE VIEW VW_VENTAS_CLIENTE AS
SELECT
	S.sale_id,
	C.customer_id,
	C.name AS NOMBRE_CLIENTE,
	C.country AS PAIS,
	S.product AS PRODUCTO,
	S.price,
	S.quantity AS CANTIDAD,
	(S.price * S.quantity) AS MONTO_TOTAL,
	S.sale_date,
	YEAR(S.SALE_DATE) AS AÑO,
	MONTH(S.SALE_DATE) AS MES
FROM customers_ventas C
INNER JOIN sales_ventas S ON C.customer_id = S.customer_id;

SELECT * FROM VW_VENTAS_CLIENTE;
