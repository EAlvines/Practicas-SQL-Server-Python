--TRANSFORMACION DE LA TABLA - CREAR NUEVA COLUMNA SEGUN CASE
--Clasificacion de monto vendido - Consulta
	SELECT
		sale_id, product, price, quantity, 
		(price * quantity)  AS Monto_total,
		CASE
			WHEN (price * quantity) > 8000 THEN 'ALTO'
			WHEN (price * quantity) BETWEEN 4001 AND 8000 THEN 'MEDIO'
			ELSE 'BAJO'
		END AS Segmento
	FROM sales_ventas;

--AGREGAR LA COLUMNA 'SEGMENTO' A LA TABLA PERMANENTE
ALTER TABLE Sales_ventas
ADD Segmento VARCHAR(50);

--AGREGAR LA LOGICA A LA COLUMNA NUEVA
UPDATE sales_ventas
SET Segmento = 
	CASE
		WHEN (price * quantity) > 8000 THEN 'ALTO'
		WHEN (price * quantity) BETWEEN 4001 AND 8000 THEN 'MEDIO'
		ELSE 'BAJO'
	END;

--CREAR UNA NUEVA TABLA_ LISTA DE PRODUCTOS
SELECT product, COUNT(*) as Cantidad_productos
from sales_ventas
GROUP BY product;

CREATE TABLE Productos_Lista (
	Producto_name VARCHAR(50),
	Producto_code VARCHAR(50));

INSERT INTO Productos_Lista (Producto_name, Producto_code)
VALUES
  ('Laptop', 'SKU_1001_LAPTOP'),
  ('Monitor', 'SKU_1002_MONITOR'),
  ('Mouse', 'SKU_1003_MOUSE'),
  ('Keyboard', 'SKU_1004_KEYBOARD'),
  ('Tablet', 'SKU_1005_TABLET'),
  ('Phone', 'SKU_1006_PHONE');



