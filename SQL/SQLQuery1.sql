SELECT * FROM customers_ventas
SELECT * FROM sales_ventas

ALTER TABLE sales_ventas
ADD CONSTRAINT FK_SALE_CUSTOMER
FOREIGN KEY (customer_id)
REFERENCES customers_ventas(customer_id);

--Filtrar a cliente de un pais especifico Germany
SELECT name AS CLIENTE, country AS PAIS
FROM customers_ventas
WHERE country = 'Germany';

--Buscar cliente cuyo nombre contine Maria
SELECT * from customers_ventas
WHERE name LIKE 'Maria%';

--Ventas de más de 3 unidades y precio mayor a 500
SELECT * FROM sales_ventas
WHERE quantity > 3 AND price > 500;

--Ventas realizadas entre 2023-01-01 y 2023-12-31
SELECT * FROM sales_ventas
WHERE sale_date BETWEEN '2023-01-01' AND '2023-12-31'
ORDER BY sale_date ASC;

-- Lista de ventas con nombre del cliente (INNER JOIN)
SELECT s.sale_id, s.customer_id, C.name, S.quantity, S.product, S.price
FROM sales_ventas s
INNER JOIN customers_ventas c ON s.customer_id = c.customer_id;

-- Clientes que NO han realizado compras (LEFT JOIN + filtro)
SELECT *
FROM customers_ventas C
LEFT JOIN sales_ventas S ON C.customer_id = S.customer_id
WHERE quantity IS NULL;

-- Todas las ventas y los clientes relacionados (RIGHT JOIN)
SELECT *
FROM sales_ventas S
RIGHT JOIN customers_ventas C ON S.customer_id = C.customer_id;

--Cantidad total de ventas por producto
SELECT product AS producto, COUNT(*) AS total_venta
FROM sales_ventas
GROUP BY product;

--Ventas totales (monto) por país
SELECT C.country, SUM(S.price * S.quantity) AS VENTAS_TOTALES
FROM sales_ventas S
INNER JOIN customers_ventas C ON S.customer_id = C.customer_id
GROUP BY C.country;

-- Promedio de cantidad vendida por producto, solo si supera 2 unidades
SELECT product, AVG(quantity) AS PROMEDIO_VENTAS_Q
FROM sales_ventas
GROUP BY product
HAVING AVG(quantity) > 2;

--Top 5 países con mayor cantidad de ventas realizadas
SELECT TOP 5 C.country, COUNT(S.sale_id) AS CANTIDAD_VENTAS
FROM sales_ventas S
INNER JOIN customers_ventas C ON S.customer_id = C.customer_id
GROUP BY C.country
ORDER BY CANTIDAD_VENTAS DESC;

-- Ejercicio Final: “Top 3 productos más vendidos por monto total”
--Muestra los 3 productos que generaron más ingresos totales (precio * cantidad) en ventas.
--Incluye estas columnas en el resultado:producto, cantidad_total_vendida, monto_total_generado
--Ordena los resultados de mayor a menor por el monto total.
SELECT TOP 3
	product, 
	SUM(quantity) AS CANTIDAD_TOTAL_VENDIDA,
	SUM(price * quantity) AS MONTO_TOTAL_GENERADO
FROM sales_ventas
GROUP BY product
ORDER BY MONTO_TOTAL_GENERADO DESC;


select * from sales_ventas