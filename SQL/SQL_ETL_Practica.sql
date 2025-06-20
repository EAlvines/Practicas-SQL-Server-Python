--Extrae codigo numerico
SELECT 
	Producto_code,
	SUBSTRING(producto_code, 
		CHARINDEX('_', Producto_code) + 1,
		CHARINDEX('_', Producto_code, CHARINDEX('_', Producto_code) + 1) - CHARINDEX('_', Producto_code) - 1)
		AS codigo_extraido
FROM Productos_Lista;

--Filtra solo las personas que la longitud de nombre es mayor a 12
SELECT 
	customer_id, name, country,
	LEN(name) as longitud_nombre
FROM customers_ventas
WHERE LEN(name) > 12;

--Muestra las ventas que ocurrieron en los últimos 30 días contando desde hoy
SELECT * FROM sales_ventas
WHERE sale_date >= DATEADD(DAY, -30, GETDATE());

--Agrupa las ventas por año y mes
--muestra el monto total vendido en cada mes.
SELECT 
	YEAR(sale_date) AS Año,
	MONTH(sale_date) AS Mes,
	SUM(price * quantity) AS Monto_total_mes
FROM sales_ventas
GROUP BY YEAR(sale_date), MONTH(sale_date)
ORDER BY Año, Mes;

--Calcula cuántos días han pasado desde que cada cliente hizo su primera compra hasta hoy (GETDATE()).

SELECT
	S.customer_id,
	C.name,
	DATEDIFF(MONTH, MIN(S.sale_date), GETDATE()) AS Antiguedad_Comercial_Meses
FROM sales_ventas S
INNER JOIN customers_ventas C ON S.customer_id = C.customer_id
GROUP BY S.customer_id, C.name;

SELECT COUNT(*) AS Nulos
FROM customers_ventas
WHERE country IS NULL;