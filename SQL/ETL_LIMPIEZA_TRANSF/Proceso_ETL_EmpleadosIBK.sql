SELECT TOP 100 * FROM Empleados_Orig

--Revisar valores nulo. 
SELECT 
	COUNT(*) AS TOTAL,
	SUM(CASE WHEN Nombre IS NULL OR LTRIM(RTRIM(Nombre)) = '' THEN 1 ELSE 0 END) AS Nombres_Nulos,
	SUM(CASE WHEN Área IS NULL OR LTRIM(RTRIM(Área)) ='' THEN 1 ELSE 0 END) AS Área_Nulos,
	SUM(CASE WHEN ID_Empleado IS NULL OR LTRIM(RTRIM(ID_Empleado)) ='' THEN 1 ELSE 0 END) AS ID_Nulos,
	SUM(CASE WHEN Salario IS NULL OR LTRIM(RTRIM(Salario)) ='' THEN 1 ELSE 0 END) AS Salario_Nulos,
	SUM(CASE WHEN Edad IS NULL OR LTRIM(RTRIM(Edad)) ='' THEN 1 ELSE 0 END) AS Edad_Nulos,
	SUM(CASE WHEN Género IS NULL OR LTRIM(RTRIM(Género)) ='' THEN 1 ELSE 0 END) AS Genero_Nulos,
	SUM(CASE WHEN Fecha_Ingreso IS NULL OR LTRIM(RTRIM(Fecha_Ingreso)) ='' THEN 1 ELSE 0 END) AS FechaIngreso_Nulos
FROM Empleados_Orig
-- Solo se tiene datos nulos en Nombres, Edad, genero

--Eliminar Duplicado de ID
WITH Duplicados AS (
	SELECT *,
		ROW_NUMBER() OVER(PARTITION BY ID_Empleado ORDER BY Fecha_Ingreso DESC) AS rn
	FROM Empleados_Orig
)
SELECT * 
INTO Empleados_sin_duplicados
FROM Duplicados
WHERE rn = 1; 


--Limpieza de texo - nombres con espacios o minusculs
SELECT
	UPPER(LTRIM(RTRIM(Nombre))) AS Nombre_Apellido,
	*
INTO Empleados_Texto_Limpio
FROM Empleados_sin_duplicados;

--REVISAR FECHAS VALIDAS (NOFUTURAS NI ERRORES)
SELECT *
INTO Empledados_Fechas_validas
FROM Empleados_Texto_Limpio
WHERE Fecha_Ingreso <= GETDATE();

--CREAR LA TABLA FINAL
SELECT 
	ID_Empleado, Nombre_Apellido, Área, Salario, Género AS Genero, Fecha_Ingreso, Correo
INTO Empleados_Final
FROM Empledados_Fechas_validas;

SELECT * FROM Empleados_Final

--Limpiar valores vacios en Genero a Otros
UPDATE Empleados_Final 
SET Genero = 'O'
WHERE Genero IS NULL OR LTRIM(RTRIM(Genero)) = '';

--Limpiar eliminar los que no tienen nombre
DELETE FROM Empleados_Final 
WHERE Nombre_Apellido IS NULL OR LTRIM(RTRIM(Nombre_Apellido)) = '';

--Cambiar ID EMPLEADO: "E" + Primera letra del nombre + número correlativo con 3 dígitos
--Crear un tabla temporal
WITH ENUMERADOS AS (
	SELECT 
		ID_Empleado, 
		LEFT(LTRIM(Nombre_Apellido), 1) AS INICIAL,
		ROW_NUMBER() OVER(ORDER BY Nombre_Apellido) AS NUMORDER
	FROM Empleados_Final)

UPDATE E
SET ID_Empleado = 
	'E' + EE.INICIAL + RIGHT('000' + CAST(EE.NUMORDER AS varchar), 3)
FROM Empleados_Final E 
JOIN ENUMERADOS EE ON E.ID_Empleado = EE.ID_Empleado;

SELECT * FROM Empleados_Final
ORDER BY ID_Empleado ASC;
