--preparar una tabla de ventas limpia y lista para análisis en Power BI.
--| sale_id | customer_id | producto_nombre | codigo_producto | precio | cantidad | descuento | monto_total | mes | año |

SELECT * FROM SALES_VENTAS_RAW

--Extraer codigo de producto
SELECT product_code, 
	SUBSTRING(product_code, 5, 4) AS Codigo_Producto
FROM Sales_ventas_raw;

--extraer nombre de producto
SELECT product_code, 
	RIGHT(Product_code,LEN(product_code) - CHARINDEX('_', product_code, CHARINDEX('_', product_code) + 1)) AS Nombre_Producto
FROM Sales_ventas_raw;

--Reemplazar valores NULL en discount por 0.00
SELECT
	sale_id,
	ISNULL(discount, 0.00) AS Descuento_final
FROM sales_ventas_raw;

SELECT
	price, quantity, COALESCE(discount, 0.00) As Descuento, 
	((price * quantity) - COALESCE(discount, 0.00)) as Monto_total
FROM sales_ventas_raw;

--Revisar duplicados
SELECT sale_id, COUNT(*) AS DUPLICADO
FROM SALES_VENTAS_RAW
GROUP BY SALE_ID
HAVING COUNT(*) > 1; 
--No hay duplicados de ID de ventas. 

--Agregar columna de Mes y año 
SELECT
	sale_date,
	MONTH(sale_date) as Mes,
	YEAR(SALE_DATE) AS Año
FROM sales_ventas_raw; 

--JUNTAR TODO EN CTE
WITH ventas_limpias as ( 
	SELECT
	sale_id as Venta_id,
	product_code AS Codigo_Completo,
	SUBSTRING(product_code, 5, 4) AS Codigo_Producto,
	RIGHT(Product_code,LEN(product_code) - CHARINDEX('_', product_code, CHARINDEX('_', product_code) + 1)) AS Nombre_Producto,
	price as Precio, 
	quantity as Cantidad, 
	COALESCE(discount, 0.00) As Descuento, 
	((price * quantity) - COALESCE(discount, 0.00)) as Monto_total,
	sale_date as Fecha_venta,
	MONTH(sale_date) as Mes,
	YEAR(SALE_DATE) AS Año
	FROM sales_ventas_raw )

SELECT * 
INTO Ventas_Final
FROM ventas_limpias;

select * from Ventas_Final