--CONSULTA TIPO DASHBOARD--
--Un reporte consolidado: muestra por area: 
--(nombre area, total empleado, prom sueldo, sueldo max, fecha ingreo mas reciente y cant de emp dsp 2023) 

SELECT A.NombreDep,
	COUNT(*) AS TOTALEMPLEADOS, 
	ROUND(AVG(D.SUELDO), 2) AS PROMEDIOSUELDO,
	MAX(D.SUELDO) AS SUELDOMAX,
	MAX(E.FechaIngreso) AS FECHAMAX,
	SUM(CASE WHEN E.FechaIngreso > '2023-12-31' THEN 1 ELSE 0 END) AS Empleados_despues_2023
FROM DETALLE D
INNER JOIN Empleados E ON D.ID = E.ID
INNER JOIN Departamento A ON A.DepartamentoID = D.AREA
GROUP BY A.NombreDep
ORDER BY PROMEDIOSUELDO;
