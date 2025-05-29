--CONSULTAS EXPLORATORIO--

select * from EmpleadosIBK

--¿Cuántos empleados han salido vs cuántos siguen activos?
SELECT
	CASE
		WHEN Fecha_Salida IS NULL OR Fecha_Salida = '' THEN 'ACTIVO'
		ELSE 'INACTIVO'
	END AS Estado,
	COUNT(*) AS Total
FROM EmpleadosIBK
GROUP BY
	CASE
		WHEN Fecha_Salida IS NULL OR Fecha_Salida = '' THEN 'ACTIVO'
		ELSE 'INACTIVO'
	END;

--¿Cuál es la sede con mayor cantidad de salidas?

SELECT Sede, COUNT(*) AS Salidas
FROM EmpleadosIBK
WHERE Fecha_Salida IS NOT NULL AND Fecha_Salida <> ''
GROUP BY Sede
ORDER BY Salidas DESC;

--¿En qué área hay más rotación?
SELECT Área, COUNT(*) AS Salidas
FROM EmpleadosIBK
WHERE Fecha_Salida IS NOT NULL AND Fecha_Salida <> ''
GROUP BY Área
ORDER BY Salidas DESC;

--¿Qué tipo de contrato presenta más salidas?
SELECT Tipo_Contrato, COUNT(*) AS SALIDAS
FROM EmpleadosIBK
WHERE Fecha_Salida IS NOT NULL AND Fecha_Salida <> ''
GROUP BY Tipo_Contrato
ORDER BY SALIDAS DESC;

--¿Cuál fue el principal motivo de salida?
SELECT Motivo_Salida, COUNT(*) AS Total
FROM EmpleadosIBK
WHERE Motivo_Salida IS NOT NULL AND Motivo_Salida <> ''
GROUP BY Motivo_Salida
ORDER BY Total DESC;
