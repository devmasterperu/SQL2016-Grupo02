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

--3.11 Liste por cada calificaci�n la valoraci�n, fecha de valoraci�n, comentario,
--nombre de pel�cula de aquellas calificaciones>=3.
select cal.valoracion,
       cal.fecregistro,
	   ISNULL(cal.comentario,'No ingres� comentario') as comentario,
	   pel.nombre
from tbCalificacion cal 
inner join tbPelicula pel
on cal.idpelicula=pel.idpelicula
where cal.valoracion>=3
order by cal.valoracion desc

--3.12 Liste por cada usuario el alias, correo, estado y nombre de su pa�s.
--NOTA: Los usuarios deben mostrarse as� el pa�s no se encuentra cargado
--siendo usuario la tabla principal de la consulta

select usu.alias,usu.correo,usu.estado,pais.nombrepais
from   tbUsuario usu
left join tbPais pais
on usu.idpais=pais.idpais

--3.13 Liste por cada pa�s el id, nombre del pa�s, as� como el alias y correo de los
--usuarios asociados.
--NOTA: Los pa�ses deben mostrarse as� no existan usuarios asociados
--siendo usuario la tabla principal de la consulta

select usu.alias,usu.correo,pais.idpais,pais.nombrepais
from   tbUsuario usu
right join tbPais pais
on usu.idpais=pais.idpais

--3.14 Uso de Full Outer Join
select usu.alias,usu.correo,pais.idpais,pais.nombrepais
from   tbUsuario usu
full join tbPais pais
on usu.idpais=pais.idpais

--3.15 Uso de Self Join
create schema interno
--drop table interno.tbEmpleado
create table interno.tbEmpleado
(
id int identity(1,1) primary key,
nombres varchar(100),
apellidoPat varchar(100),
apellidoMat varchar(100),
matricula varchar(8),
matriculajefe int,
)

insert into interno.tbEmpleado
select 'Carlos','Menendez','Lopez','S00001',NULL
select * from interno.tbEmpleado

insert into interno.tbEmpleado
select 'Miguel','Morales','Vallejo','S00002',1

insert into interno.tbEmpleado
select 'Juana','Lucas','Diaz','S00003',1

--
insert into interno.tbEmpleado
select 'Evelyn','Cabrera','Arias','S00004',2

insert into interno.tbEmpleado
select 'Ronald','Pecho','Moran','S00005',2

--
insert into interno.tbEmpleado
select 'Carlos','Quispe','Camarena','S00006',3

insert into interno.tbEmpleado
select 'Alejandra','Lopez','Ugarte','S00007',3

--Obtener la matr�cula, nombre completo de los empleados y nombre completo de los jefes

select emp.matricula,
	   emp.nombres+' ' +emp.apellidoPat+' '+emp.apellidoMat as nombrecompleto,
	   isnull(emp2.nombres+' '+emp2.apellidoPat+' '+emp2.apellidoMat,'No tiene jefe') as nombrecompletojefe
from interno.tbEmpleado emp
left join interno.tbEmpleado emp2
on emp.matriculajefe=emp2.id

--3.16 Uso de Multi Joins

select cal.valoracion,cal.fecregistro,isnull(cal.comentario,'No hay comentario por el momento') as comentario,
pel.nombre,pel.estreno,pais.nombrepais as paispelicula,usu.alias,usu.correo,pla.nombre,pla.tarifadol
 from tbCalificacion cal
 left join tbPelicula pel on cal.idpelicula=pel.idpelicula
 left join tbPais pais on pais.idpais=pel.idpais
 left join tbUsuario usu on usu.idusuario=cal.idusuario
 left join tbPlan pla on pla.idplan=usu.idplan 
 order by cal.valoracion desc,pel.nombre asc

 --3.17 Multi Join+Agrupamiento+Sum

 select cal.valoracion,pais.nombrepais as paispelicula,count(1) as total
 from tbCalificacion cal
 left join tbPelicula pel on cal.idpelicula=pel.idpelicula
 left join tbPais pais on pais.idpais=pel.idpais
 left join tbUsuario usu on usu.idusuario=cal.idusuario
 left join tbPlan pla on pla.idplan=usu.idplan 
 group by cal.valoracion,pais.nombrepais
 order by cal.valoracion desc,pais.nombrepais asc

 --3.18 Multi Join+Agrupamiento+Max+Min
 --La valoraci�n m�nima y la valoraci�n m�xima por cada pa�s.
  select pais.nombrepais as paispelicula,min(valoracion) as minvalora,max(valoracion) as maxvalora
 from tbCalificacion cal
 left join tbPelicula pel on cal.idpelicula=pel.idpelicula
 left join tbPais pais on pais.idpais=pel.idpais
 left join tbUsuario usu on usu.idusuario=cal.idusuario
 left join tbPlan pla on pla.idplan=usu.idplan 
 group by pais.nombrepais
 having min(valoracion)=1--"Where" a nivel de Group By
 order by pais.nombrepais desc

 --3.19 No visualizar ubigeos sin emprendimientos.Contabilizar por cada ubigeo los emprendimientos registrados

 select ubi.departamento,ubi.provincia,ubi.distrito,count(1) as total
 from EmprendeDB.produccion.tbUbigeo ubi
 inner join EmprendeDB.produccion.tbEmprendimiento emp
 on ubi.id=emp.idubigeo
 group by ubi.departamento,ubi.provincia,ubi.distrito
 order by ubi.departamento,ubi.provincia,ubi.distrito

 --3.20 Mostrar la m�nima,m�xima poblaci�n y el �rea en km2 de cada departamento.
 select ubi.departamento,min(ubi.poblacion) as minpoblacion,max(ubi.poblacion) as maxpoblacion,sum(ubi.areakm2) as area
 from EmprendeDB.produccion.tbUbigeo ubi
 group by ubi.departamento
 order by ubi.departamento