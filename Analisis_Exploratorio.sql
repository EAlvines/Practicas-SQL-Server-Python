--CONSULTAS EXPLORATORIO--

select * from EmpleadosIBK

--�Cu�ntos empleados han salido vs cu�ntos siguen activos?
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

--�Cu�l es la sede con mayor cantidad de salidas?

SELECT Sede, COUNT(*) AS Salidas
FROM EmpleadosIBK
WHERE Fecha_Salida IS NOT NULL AND Fecha_Salida <> ''
GROUP BY Sede
ORDER BY Salidas DESC;

--�En qu� �rea hay m�s rotaci�n?
SELECT �rea, COUNT(*) AS Salidas
FROM EmpleadosIBK
WHERE Fecha_Salida IS NOT NULL AND Fecha_Salida <> ''
GROUP BY �rea
ORDER BY Salidas DESC;

--�Qu� tipo de contrato presenta m�s salidas?
SELECT Tipo_Contrato, COUNT(*) AS SALIDAS
FROM EmpleadosIBK
WHERE Fecha_Salida IS NOT NULL AND Fecha_Salida <> ''
GROUP BY Tipo_Contrato
ORDER BY SALIDAS DESC;

--�Cu�l fue el principal motivo de salida?
SELECT Motivo_Salida, COUNT(*) AS Total
FROM EmpleadosIBK
WHERE Motivo_Salida IS NOT NULL AND Motivo_Salida <> ''
GROUP BY Motivo_Salida
ORDER BY Total DESC;
