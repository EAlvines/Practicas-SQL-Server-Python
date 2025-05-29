SELECT * FROM EmpleadosIBK

--Tasa de Rotación General = empleados salidos / empleados totales
SELECT
	CAST(COUNT(CASE
				WHEN Fecha_Salida IS NOT NULL AND Fecha_Salida <> '' THEN 1 
				END) AS FLOAT)
		/COUNT(*) AS TasaRotacionGeneral
FROM EmpleadosIBK

-- Tasa de Rotación por Sede
SELECT Sede, 
	CAST(COUNT(CASE
				WHEN Fecha_Salida IS NOT NULL AND Fecha_Salida <> '' THEN 1 
				END) AS FLOAT)
		/COUNT(*) AS TasaRotacion
FROM EmpleadosIBK
GROUP BY Sede
ORDER BY TasaRotacion DESC;

--Promedio de Tiempo de Permanencia (en meses) por área
SELECT Área, AVG(DATEDIFF(MONTH, Fecha_Ingreso, Fecha_Salida)) AS PromedioPermanencia
FROM EmpleadosIBK
WHERE Fecha_Salida IS NOT NULL AND Fecha_Salida <> ''
GROUP BY Área;

--Antigüedad promedio de los empleados activos
SELECT
	AVG(DATEDIFF(MONTH, Fecha_Ingreso, GETDATE())) AS PromedioAnguedad_Activos
FROM EmpleadosIBK
WHERE Fecha_Salida IS NULL OR Fecha_Salida = '';
