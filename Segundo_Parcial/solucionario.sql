--SEGUNDO PARCIAL.SOLUCIONARIO

--1. Listar el ciiu y la descripción de aquellas actividades económicas
--que cumplan al menos una de las siguientes condiciones (3 puntos)
--1.1 La descripción contenga la palabra “CULTIVO” o “PESCA”.
--1.2 El ciiu inicie con “03”.

SELECT A.ciiu,B.descripcion
FROM [produccion].[tbEmprendimientoActividad] A INNER JOIN [produccion].[tbActividadEconomica] B ON A.ciiu = B.ciiu
WHERE B.descripcion LIKE '%CULTIVO%' OR B.descripcion LIKE '%PESCA%' OR A.ciiu LIKE '03%'

--2. Listar el ciiu y la descripción de las actividades económicas en base
--a TODOS los siguientes requerimientos (4 puntos)
--2.1 El ciiu finalice con “11”.
--2.2 Ordenados por descripción de Z-A.
--2.3 En base al resultado de 2.1 y 2.2 no se debe mostrar los
--primeros 10 registros, pero si los siguientes 15.
--El resultado de su consulta debe arrojar el siguiente cuadro:

SELECT ciiu,descripcion
FROM  [produccion].[tbActividadEconomica]
WHERE ciiu LIKE '%11'
ORDER BY descripcion DESC
OFFSET 10 ROWS
FETCH NEXT 15 ROWS ONLY

--3. Listar el conjunto de emprendimientos y actividades económicas en
--base a los campos requeridos (5 puntos).
--NOTA: Debe excluir aquellas asociaciones de emprendimiento y
--actividad económica con fecha de registro desconocida.

		SELECT A.RUC,A.razonsocial,A.nombrecomercial,D.descripcion,CONCAT(C.departamento,'-',C.provincia,'-',C.distrito) AS UBIGEO 
		FROM [produccion].[tbEmprendimiento] A 
		INNER JOIN [produccion].[tbEmprendimientoActividad] B ON A.id=B.idemprendimiento
		INNER JOIN [produccion].[tbUbigeo] C ON A.idubigeo=C.id
		INNER JOIN [produccion].[tbActividadEconomica] D ON B.ciiu=D.ciiu
		WHERE B.fecregistro IS NOT NULL
		order by  A.RUC,A.razonsocial,D.descripcion
--4. Listar el NUEVO_ID, RUC, NOMBRE_COMERCIAL y
--FECHA_INICIO de operaciones para cada emprendimiento (6
--puntos).
--La fórmula de generación del NUEVO ID es la indicada a
--continuación.
SELECT 'NUEVO_ID'=CONCAT(SUBSTRING(RUC,1,3),'(',DAY(fecinicio),')','(', MONTH([fecinicio]),')','(',YEAR([fecinicio]),')'),
        RUC,[nombrecomercial],fecinicio, razonsocial
FROM [produccion].[tbEmprendimiento] 
WHERE NOT (LEN(ruc)<>11 OR fecinicio IS NULL OR razonsocial='')
ORDER BY NUEVO_ID


--5. Actualizar el estado y comentario de los emprendimientos en base a
--las siguientes reglas (2 puntos):

update emp
set    emp.estado=0,comentario='Este emprendimiento tiene un RUC con longitud menor a 11.'
from  [produccion].[tbEmprendimiento] emp
where len(emp.ruc)<11

update emp
set    emp.estado=0,comentario='Este emprendimiento tiene razón social en blanco.'
from  [produccion].[tbEmprendimiento] emp
where razonsocial=''