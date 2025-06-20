--SUBQUERY PRO: Ventas mayores al monto promedio por producto vendido

SELECT sale_id, product, (quantity * price) AS TOTAL_VENTA
FROM sales_ventas AS S1
WHERE (quantity*price) > 
	(SELECT AVG(quantity * price)
	FROM sales_ventas AS S2
	WHERE S2. product = S1.product);
--CTE
WITH TOTA_PRODUCTO AS (
	SELECT product, SUM(quantity * price) AS Total_Producto
	FROM sales_ventas
	GROUP BY product)
SELECT PRODUCT, Total_Producto
FROM TOTA_PRODUCTO
WHERE Total_Producto > 10000;


-- CTE ROW_NUMBER
WITH VENTAS_RECIENTES AS (
	SELECT customer_id, sale_id, sale_date, 
		(PRICE*QUANTITY) AS MONTO_TOTAL,
		ROW_NUMBER() OVER
			(PARTITION BY CUSTOMER_ID 
			ORDER BY SALE_DATE DESC) AS RN
FROM sales_ventas )

SELECT customer_id, sale_id, sale_date, MONTO_TOTAL
FROM VENTAS_RECIENTES
WHERE RN = 1;

--EXAMEN
--1: muestra las ventas superiores al promedio de ventas por producto (en montos)
select sale_id, product, (price * quantity) as total 
from sales_ventas as S1
where (price * quantity) > (
	select AVG(price * quantity) 
	from sales_ventas as S2
	where s2.product = s1.product);

--2. CTE: total gastado por cliente y luego filtrar lo gastado mayor a 6000
with Gasto_por_Cliente as (
	select customer_id, sum(price * quantity) as total_gastado
	from sales_ventas
	group by customer_id)
select customer_id, total_gastado
from Gasto_por_Cliente
where total_gastado > 6000;

--3. ROW NUMBER: pra cada producto filtrar por las 2 ventas más recientes.
with ventas_recientes as (
	select 
	sale_id, 
	product, 
	customer_id, 
	sale_date, 
	(price * quantity) as monto_total,
	ROW_NUMBER() over(partition by product order by sale_date desc) as fila
from sales_ventas)

select sale_id, product, customer_id, sale_date, monto_total, fila
from ventas_recientes
where fila <= 2;