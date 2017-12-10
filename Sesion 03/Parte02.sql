--Consultas en M�ltiples Tablas
--3.9 Uso de CROSS JOIN
select cat.nombrecategoria,pla.nombre 
from tbCategoria cat
CROSS JOIN tbPlan pla
order by cat.nombrecategoria
--3.10.1 Uso de INNER JOIN
--Liste por cada pel�cula el nombre, resumen, a�o de estreno, duraci�n en
--minutos y nombre del pa�s

select pel.nombre,
       pel.resumen,
	   pel.estreno,
	   pel.duracionmin, 
       pais.nombrepais as nombrepais
from tbPelicula pel
inner join tbPais pais 
on pel.idpais=pais.idpais

--3.10.2 Mostrar ruc,razonsocial,departamento,provincia,distrito
--de cada uno de los emprendimientos
--Consultar desde otra BD en la misma instancia
select emp.ruc,
       emp.razonsocial,
	   ubi.departamento,
	   ubi.provincia,
	   ubi.distrito
from EmprendeDB.produccion.tbEmprendimiento emp
inner join EmprendeDB.produccion.tbUbigeo ubi
on emp.idubigeo=ubi.id
--Cuales son los emprendimientos del departamento de Amazonas
select emp.ruc,
       emp.razonsocial,
	   ubi.departamento,
	   ubi.provincia,
	   ubi.distrito
from EmprendeDB.produccion.tbEmprendimiento emp
inner join EmprendeDB.produccion.tbUbigeo ubi
on emp.idubigeo=ubi.id
where ubi.departamento='AMAZONAS' and ubi.distrito='ASUNCION'

--Cuales son los emprendimientos del departamento de Amazonas
--y con poblaci�n<10,000
--y mostrar mensaje [0-5000>: Poblaci�n menor a 5000
--contrario, poblaci�n entre 5000 y 10000
select emp.ruc,
       emp.razonsocial,
	   ubi.departamento,
	   ubi.provincia,
	   ubi.distrito,
	   ubi.poblacion,
	   case when ubi.poblacion>=0 and ubi.poblacion<5000 then 'Poblaci�n menor a 5000'
	   else 'poblaci�n entre 5000 y 10000' end as mensajepoblacion
from EmprendeDB.produccion.tbEmprendimiento emp
inner join EmprendeDB.produccion.tbUbigeo ubi
on emp.idubigeo=ubi.id
where ubi.departamento='AMAZONAS' and ubi.poblacion<10000
order by ubi.poblacion desc