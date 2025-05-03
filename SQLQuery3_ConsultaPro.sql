--CONSULTA TIPO DASHBOARD--
--Un reporte consolidado: muestra por area: 
--(nombre area, total empleado, prom sueldo, sueldo max, fecha ingreo mas reciente y cant de emp dsp 2023) 

SELECT A.NombreDep,
	COUNT(*) AS TOTALEMPLEADOS, 
	AVG(D.SUELDO) AS PROMEDIOSUELDO,
	MAX(D.SUELDO) AS SUELDOMAX,
	MAX(E.FechaIngreso) AS FECHAMAX	
FROM DETALLE D
INNER JOIN Empleados E ON D.ID = E.ID
INNER JOIN Departamento A ON A.DepartamentoID = D.AREA
GROUP BY A.NombreDep
ORDER BY PROMEDIOSUELDO
