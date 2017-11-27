--26/11/2017
--Primeros pasos en SQL Server
--1.1 CREAR BASE DE DATOS
CREATE DATABASE DEVFLIXDB
--1.2 USAR BASE DE DATOS
USE DEVFLIXDB
--1.3 CREACION DE ESQUEMA
CREATE SCHEMA GMV
CREATE SCHEMA GCMV
--1.4 CREACION DE TABLAS
create table GMV.tbPais
(
idpais int identity(1,1) primary key,
nombrepais varchar(30) not null
)

create table GCMV.tbPais
(
idpais int identity(1,1) primary key,--Valor de inicio,valor de incremento
nombrepais varchar(30) not null
)

--1.5 ELIMINAR ESQUEMA
drop table GCMV.tbPais
go
drop schema GCMV
--1.6 CREAR TABLA SIN ESPECIFICAR ESQUEMA
create table tbPais
(
idpais int identity(1,1) primary key,--Valor de inicio,valor de incremento
nombrepais varchar(30) not null
)

create table tbPelicula
(
idpelicula int identity(1,1) primary key,
idpais int references tbPais(idpais) not null,
nombre varchar(30) not null,
resumen varchar(150) not null,
rutaalojamiento varchar(500) not null,
estreno int null,
duracionmin int not null,
fecregistro datetime default getdate(),--Fecha y hora del sistema,
fecactualiza datetime null
)
select getdate()--Para obtener fecha y hora de servidor de BD.

--1.7 REGISTRO DE INFORMACION
insert into tbPais values('PERU')
--OBTENER LOS PAISES REGISTRADOS
select * from tbPais
insert into tbPelicula
(
idpais,
nombre,
resumen,
rutaalojamiento,
estreno,
duracionmin
)
values (1,
'ONCE MACHOS','Una de las películas peruanas que más convocatoria han logrado en lo que va del 2017',
'http://devmaster.pe/devflix/oncemachos',2017,100)

insert into tbPelicula
(
idpais,
nombre,
resumen,
rutaalojamiento,
estreno,
duracionmin
)
values (1,
'ASU MARE','ASU MARE trata de ...',
'http://devmaster.pe/devflix/asumare',2013,90)
go
insert into tbPelicula
(
idpais,
nombre,
resumen,
rutaalojamiento,
estreno,
duracionmin
)
values (1,
'ROSA CHUMBE','ROSA CHUMBE trata de ...',
'http://devmaster.pe/devflix/rosachumbe',2015,120)
go
insert into tbPelicula
(
idpais,
nombre,
resumen,
rutaalojamiento,
estreno,
duracionmin
)
values (1,
'ASU MARE 2','ASU MARE 2 trata de ...',
'http://devmaster.pe/devflix/asumare2',2015,90)
go
--1.8 MODIFICAR LONGITUD DE COLUMNA RESUMEN
alter table tbPelicula alter column resumen varchar(250) not null
--VALIDAR INSERCION
select * from tbPelicula
--1.9 ELIMINAR ALGUN REGISTRO
--DELETE FROM tbPelicula
--WHERE idpelicula=1

--1.10 Conociendo al SELECT
SELECT nombre,resumen,estreno,fecregistro
FROM   tbPelicula
WHERE  estreno<>2017
--GROUP BY
--HAVING
ORDER BY fecregistro desc,nombre desc--de las más nuevas a las más viejas en registro.
--ORDER BY fecregistro asc--de las más viejas a las más nuevas en registro.

--1.11 Con GROUP BY y HAVING
SELECT estreno as añoestreno,--(5)
COUNT(idpelicula) as total--Count permite contar registros
FROM   tbPelicula
WHERE  idpais=1
GROUP BY estreno--(3)
--GROUP BY añoestreno--(3)
HAVING estreno=2015
ORDER BY añoestreno desc--(6)

--1.12 USO DE CALCULOS
--declare @valor1 int
--set @valor1=10
--declare @valor2 int
--set @valor1=3
select 10 as valor1,3 as valor2,
10+3 as suma,10-3 as resta,10*3 as multiplica,10/3 as divide,10%3 as modulo

--1.13 USO DE DISTINCT
insert into tbPelicula
(
idpais,
nombre,
resumen,
rutaalojamiento,
estreno,
duracionmin
)
values (1,
'ROSA CHUMBE','ROSA CHUMBE trata de ...',
'http://devmaster.pe/devflix/rosachumbe',2015,125)
go
insert into tbPelicula
(
idpais,
nombre,
resumen,
rutaalojamiento,
estreno,
duracionmin
)
values (1,
'ASU MARE 2','ASU MARE 2 trata de ...',
'http://devmaster.pe/devflix/asumare2',2015,95)
go
--USO DE DISTINCT
select * from tbPelicula--6 registros
select distinct idpais,nombre,resumen,estreno from tbPelicula --4 registros
select distinct idpais,nombre,resumen,estreno,duracionmin from tbPelicula --6 registros
--1.14 ALIAS PARA COLUMNAS 
SELECT nombre as mipelicula from tbPelicula
SELECT nombre mipelicula from tbPelicula
SELECT nombre 'mipelicula' from tbPelicula
--1.15 ALIAS PARA TABLAS 
SELECT nombre from tbPelicula mipelicula
SELECT nombre from tbPelicula as mipelicula
SELECT pel.nombre from tbPelicula as pel
--1.16 USO DE CASE
select nombre,
       resumen,
	   duracionmin,
	   --Primer CASE
		CASE WHEN duracionmin<95 THEN 'Película corta' 
			 WHEN duracionmin>=95 and duracionmin<=120 THEN 'Película no tan larga' 
		ELSE 'Película larga'
		END as mensaje_duracion,
		--Fin Primer CASE
		estreno,
		--Segundo CASE
		CASE WHEN estreno<2015 THEN 'Película vieja'
	    ELSE 'Película nueva'
		END as mensaje_año_estreno,
		--Fin Segundo CASE
		fecregistro
from tbPelicula
order by fecregistro desc