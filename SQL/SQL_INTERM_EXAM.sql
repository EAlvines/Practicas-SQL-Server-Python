--PRUEBA FINAL - SQL INTERM
--1.1 Muestra todas las ventas mayores a 1000 de clientes del país "Perú", solo columnas:
--sale_id, customer_id, monto_total, country.
select
	s.sale_id,
	s.customer_id,
	c.country,
	(s.price * s.quantity) as monto_total
from sales_ventas s
inner join customers_ventas c on s.customer_id = c.customer_id
where (s.price * s.quantity) > 1000 and country = 'Peru';

--1.2 ¿Cuántas ventas totales hay por producto? Usa GROUP BY + COUNT.
select product	as producto, count(sale_id) as Ventas_totales
from sales_ventas
group by product;

--1.3 Lista los 3 productos con mayor monto total generado (usa SUM() y ORDER BY descendente).
select TOP 3
	product as productos, 
	SUM(price * quantity) as monto_total
from sales_ventas
group by product
order by monto_total DESC;

--Sección 2: Herramientas para estructurar consultas
--2.1 Usando una subconsulta, muestra las ventas cuyo monto total sea mayor al promedio general de todas las ventas.
SELECT sale_id, product, quantity, (price * quantity) AS MONTO_TOTAL 
FROM sales_ventas
WHERE (price * quantity) > (
							SELECT AVG(PRICE * QUANTITY) AS PROMEDIO_VENTAS
							FROM sales_ventas);

--2.2 Usa un CTE para calcular el total gastado por cliente, y filtra los que superan los 8000 soles.
WITH total_gastado_cliente as(
	select
		customer_id,
		SUM(price * quantity) as total_gastado
	from sales_ventas
	GROUP BY customer_id )

select * from total_gastado_cliente
where total_gastado > 8000;
	
--2.3 Usa ROW_NUMBER() para obtener la última venta de cada cliente (por sale_date).
with ultima_venta as (
	select
		c.customer_id,
		s.sale_date,
		(s.price * s.quantity) as venta,
		row_number() over(partition by c.customer_id order by s.sale_date desc) as rn
	from sales_ventas s
	inner join customers_ventas c on s.customer_id = c.customer_id
	group by 
		c.customer_id,
		s.sale_date, (s.price * s.quantity))
select * from ultima_venta
where rn = 1;

--Sección 3: Transformación y limpieza de datos (ETL)
--3.1 Crea una nueva columna segmento con CASE WHEN:
--Si el monto_total > 5000 → 'Alto'/Entre 1000 y 5000 → 'Medio' / Menos de 1000 → 'Bajo'

select * from sales_ventas_raw

alter table sales_ventas_raw
add segmento varchar(50);

update sales_ventas_raw
set segmento = 
			case
				when (price * quantity) > 5000 then 'alto'
				when (price * quantity) between 1000 and 5000 then 'medio'
				when (price * quantity) < 1000 then 'bajo'
			end;

--3.2 Extrae el nombre del producto desde product_code, usando SUBSTRING y CHARINDEX.
select product_code, 
		SUBSTRING(product_code, 10, len(product_code) - charindex('_', product_code) + 1) as nombre_producto
from sales_ventas_raw;

--3.3 Muestra cuántos valores NULL hay en la columna discount.
select sale_id, discount, COUNT(*) as total
from sales_ventas_raw
group by sale_id, discount
having discount is null;

--3.4 Usa ISNULL() o COALESCE() para reemplazar los valores NULL en discount por 0.00
select *, 
	isnull(discount, 0.00)
from sales_ventas_raw;

--Sección 4: Preparación de datos para análisis
--4.1 Crea una tabla nueva con ventas del año 2024 usando SELECT INTO.
with ventas_2024 as ( 
	select 
		sale_id,
		customer_id,
		product,
		price,
		quantity,
		sale_date,
		YEAR(sale_date) as año,
		MONTH(sale_date) as mes
		from sales_ventas
	Group by 
		sale_id, customer_id, product, price, quantity, sale_date,
		YEAR(sale_date),
		MONTH(sale_date))
select * INTO VENTAS_AÑO_2024
from ventas_2024
where año = 2024;
	
--4.2 Crea una vista con el resumen mensual por producto (producto, mes, año, total_ventas, total_monto)

drop view if EXISTS vw_resumen_mensual_2;

create view vw_resumen_mensual_2 as
select
	LTRIM(RTRIM(product)) as producto,
	sum(price * quantity) as total_monto,
	COUNT(sale_id) as total_ventas
from VENTAS_AÑO_2024
Group by 
	product;

select * from vw_resumen_mensual_2;

