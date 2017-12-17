--SESION 04--Parte 02
--1 Insert into. Una sola fila
--select * from [tbPelicula]
INSERT INTO [dbo].[tbPelicula]
           ([idpais]
           ,[nombre]
           ,[resumen]
           ,[rutaalojamiento]
           ,[estreno]
           ,[duracionmin]
           ,[fecregistro]
           ,[fecactualiza])
     VALUES
           (1
           ,'Juego Macabro 1'
           ,'Juego Macabro 1 trata de ..'
           ,'http://devmaster.pe/devflix/juegomacabro'
           ,2000
           ,90
           ,getdate()
           ,null)
--2 Insertar varias filas de datos
INSERT INTO [dbo].[tbPelicula]
           ([idpais]
           ,[nombre]
           ,[resumen]
           ,[rutaalojamiento]
           ,[estreno]
           ,[duracionmin]
           ,[fecregistro]
           ,[fecactualiza])
     VALUES
           (1
           ,'Juego Macabro 2'
           ,'Juego Macabro 2 trata de ..'
           ,'http://devmaster.pe/devflix/juegomacabro2'
           ,2001
           ,90
           ,getdate()
           ,null),

		    (1
           ,'Juego Macabro 3'
           ,'Juego Macabro 3 trata de ..'
           ,'http://devmaster.pe/devflix/juegomacabro3'
           ,2001
           ,90
           ,getdate()
           ,null),

		   (1
           ,'Juego Macabro 4'
           ,'Juego Macabro 4 trata de ..'
           ,'http://devmaster.pe/devflix/juegomacabro4'
           ,2001
           ,90
           ,getdate()
           ,null)
--3 Insertar no en el mismo orden que las columnas de la tabla
INSERT INTO [dbo].[tbPelicula]
           (
		   [duracionmin]
		   ,[idpais]
           ,[nombre]
           ,[resumen]
           ,[rutaalojamiento]
           ,[estreno]
           ,[fecregistro]
           ,[fecactualiza])
     VALUES
           (90
		   ,1
           ,'Juego Macabro 5'
           ,'Juego Macabro 5 trata de ..'
           ,'http://devmaster.pe/devflix/juegomacabro2'
           ,2001
           ,getdate()
           ,null)
--select * from [dbo].[tbPelicula]
--4 Insertar en una tabla con columnas que tienen valor predeterminado
alter table tbPelicula add estado bit default 0--Si no se especifica
--en la inserción el estado, se insertará el 0.
INSERT INTO [dbo].[tbPelicula]
           (
		   [duracionmin]
		   ,[idpais]
           ,[nombre]
           ,[resumen]
           ,[rutaalojamiento]
           ,[estreno]
           ,[fecregistro]
           ,[fecactualiza])
     VALUES
           (90
		   ,1
           ,'Juego Macabro 6'
           ,'Juego Macabro 6 trata de ..'
           ,'http://devmaster.pe/devflix/juegomacabro6'
           ,2005
           ,getdate()
           ,null)

		   INSERT INTO [dbo].[tbPelicula]
           (
		   [duracionmin]
		   ,[idpais]
           ,[nombre]
           ,[resumen]
           ,[rutaalojamiento]
           ,[estreno]
           ,[fecregistro]
           ,[fecactualiza]
		   ,estado)
     VALUES
           (90
		   ,1
           ,'Juego Macabro 7'
           ,'Juego Macabro 7 trata de ..'
           ,'http://devmaster.pe/devflix/juegomacabro6'
           ,2005
           ,getdate()
           ,null
		   ,1)
--5 Insertar en una tabla con columna IDENTITY.
delete from [tbPelicula]
where idpelicula=16
select * from [tbPelicula]
--1	Juego Macabro 6	Juego Macabro 6 trata de ..	http://devmaster.pe/devflix/juegomacabro6	2005	90	2017-12-17 12:17:15.407	NULL	0
SET IDENTITY_INSERT dbo.tbPelicula ON;  --Permitir inserción en columna IDENTITY
INSERT INTO [dbo].[tbPelicula]
           (
		   idpelicula
		   ,[duracionmin]
		   ,[idpais]
           ,[nombre]
           ,[resumen]
           ,[rutaalojamiento]
           ,[estreno]
           ,[fecregistro]
           ,[fecactualiza])
     VALUES
           (
		   16
		   ,90
		   ,1
           ,'Juego Macabro 6'
           ,'Juego Macabro 6 trata de ..'
           ,'http://devmaster.pe/devflix/juegomacabro6'
           ,2005
           ,getdate()
           ,null)
SET IDENTITY_INSERT dbo.tbPelicula OFF;

--6 Usar SELECT para insertar datos de otras tablas.
create schema gm
drop table gm.tbPeliculaCarga
create table gm.tbPeliculaCarga
(
nombrepais varchar(100),
nombrepelicula varchar(30),
resumen varchar(250),
rutaalojamiento varchar(500),
estreno int,
duracionmin int
)

insert into gm.tbPeliculaCarga
select 'ESTADOS UNIDOS DE AMERICA','AVENGERS','AVENGERS trata de ...',
'http://devmaster.pe/devflix/avengers',2010,120

 INSERT INTO [dbo].[tbPelicula]
           (
		   [duracionmin]
		   ,[idpais]
           ,[nombre]
           ,[resumen]
           ,[rutaalojamiento]
           ,[estreno]
           ,[fecactualiza]
		   ,estado)
select duracionmin,pais.idpais,nombrepelicula,resumen,rutaalojamiento,estreno,null,1
from gm.tbPeliculaCarga pel
left join tbPais pais on pais.nombrepais=pel.nombrepais

--7 Carga de calificaciones masiva
--drop table gm.calificaciones

--1 Crear tabla borrador
create table gm.calificacion
(
alias varchar(15),
nombrepelicula varchar(30),
valoracion int
)

--2 Carga de tabla borrador
insert into gm.calificacion
SELECT 'gmanriquev','AVENGERS',1 union all 
SELECT 'gmanriquev','AVENGERS 2',4 union all 
SELECT 'mmoralesq','AVENGERS',5 union all 
SELECT 'mmoralesq','AVENGERS 3',2 

--3 Carga de tabla limpio

INSERT INTO [dbo].[tbCalificacion]
           ([idusuario]
           ,[idpelicula]
           ,[valoracion]
           ,[comentario]
           ,[fecactualiza])
select usu.idusuario, pel.idpelicula,valoracion,null,null
from gm.calificacion cal
inner join tbUsuario usu on cal.alias=usu.alias
inner join tbPelicula pel on cal.nombrepelicula=pel.nombre

--4 Validacion

select top 1 * from [dbo].[tbCalificacion]
order by fecregistro desc

select * from tbUsuario
where idusuario=1

select * from tbPelicula
where idpelicula=19

--8 Usar EXECUTE para insertar datos de otras tablas.
alter procedure usp_MostrarPeliculasBorrador
as
select duracionmin,pais.idpais,nombrepelicula,resumen,rutaalojamiento,estreno,null,1
from gm.tbPeliculaCarga pel
left join tbPais pais on pais.nombrepais=pel.nombrepais
order by estreno desc
--select 1
--delete from gm.tbPeliculaCarga
--where 1=0

 INSERT INTO [dbo].[tbPelicula]
           (
		   [duracionmin]
		   ,[idpais]
           ,[nombre]
           ,[resumen]
           ,[rutaalojamiento]
           ,[estreno]
           ,[fecactualiza]
		   ,estado)
execute usp_MostrarPeliculasBorrador--Retornar un conjunto de resultados

--9 Usar TOP para limitar los datos insertados de la tabla origen.

insert into gm.tbPeliculaCarga
select 'ESTADOS UNIDOS DE AMERICA','AVENGERS 2','AVENGERS 2 trata de ...',
'http://devmaster.pe/devflix/avengers',2012,120

insert into gm.tbPeliculaCarga
select 'ESTADOS UNIDOS DE AMERICA','AVENGERS 3','AVENGERS 2 trata de ...',
'http://devmaster.pe/devflix/avengers3',2013,120

 INSERT TOP(1) INTO [dbo].[tbPelicula]
           (
		   [duracionmin]
		   ,[idpais]
           ,[nombre]
           ,[resumen]
           ,[rutaalojamiento]
           ,[estreno]
           ,[fecactualiza]
		   ,estado)
execute usp_MostrarPeliculasBorrador--Retornar un conjunto de resultados

select * from [dbo].[tbPelicula]

--10 INSERT INTO+Variable Tabla

--10.1 Declarar una variable del tipo tabla
declare @calificacion table
(
alias varchar(15),
nombrepelicula varchar(30),
valoracion int
)

--10.2 Carga la variable Tabla 
insert into @calificacion
SELECT 'gmanriquev','AVENGERS',1 union all 
SELECT 'gmanriquev','AVENGERS 2',4 union all 
SELECT 'mmoralesq','AVENGERS',5 union all 
SELECT 'mmoralesq','AVENGERS 3',2 

--10.3 Validacion
select * from @calificacion

--11 Utilizar DELETE sin la clausula WHERE

declare @calificacion table
(
alias varchar(15),
nombrepelicula varchar(30),
valoracion int
)

insert into @calificacion
SELECT 'gmanriquev','AVENGERS',1 union all 
SELECT 'gmanriquev','AVENGERS 2',4 union all 
SELECT 'mmoralesq','AVENGERS',5 union all 
SELECT 'mmoralesq','AVENGERS 3',2 

select * from @calificacion

delete from @calificacion

select * from @calificacion

--12
begin tran
delete from [gm].[tbPeliculaCarga]
select *from [gm].[tbPeliculaCarga]
rollback
--commit
select *from [gm].[tbPeliculaCarga2]

--13 DELETE +WHERE
begin tran
delete from [gm].[tbPeliculaCarga2]
where duracionmin=120--Especificar
rollback

--select * from tbPais
--where nombrePais LIKE '%ESTADOS%'
--14 Usar Joins y Subconsultas para eliminar filas de otra tabla
--Eliminar las películas con id de pais 119

--14.1 Universo a eliminar data

select * from [gm].[tbPeliculaCarga2] pel
inner join tbPais pais on pel.nombrepais=pais.nombrepais
where pais.idpais=119

--14.2 Aplicar DELETE sobre Universos

delete pel
from  [gm].[tbPeliculaCarga2] pel
inner join tbPais pais on pel.nombrepais=pais.nombrepais
where pais.idpais=119

--15 DELETE+TOP

select top(1) * from [gm].[tbPeliculaCarga] pel
inner join tbPais pais on pel.nombrepais=pais.nombrepais
where pais.idpais=119


--DELETE TOP con alias
begin tran
delete top(1) pel
from  [gm].[tbPeliculaCarga] pel
inner join tbPais pais on pel.nombrepais=pais.nombrepais
where pais.idpais=119
rollback

--DELETE TOP sin alias
begin tran
delete top(1) gm.tbPeliculaCarga 
from  gm.tbPeliculaCarga 
join tbPais on [gm].[tbPeliculaCarga] .nombrepais=tbPais.nombrepais
where tbPais.idpais=119
rollback

begin tran
delete from [gm].[tbPeliculaCarga]
rollback

begin tran
delete pel 
from [gm].[tbPeliculaCarga] pel
rollback

--16 UPDATE de una sola columna
--Todas las tarifas van a subir 2 dolares
select * from  tbPlan

begin tran
update  tbPlan
set     tarifadol=tarifadol+2
from    tbPlan
commit

select * from  tbPlan
--17 UPDATE con WHERE+CASE WHEN
update  tbPlan
set    nombre=CASE WHEN tarifadol<12 then CONCAT(nombre,'***') else CONCAT(nombre,'___') end
from    tbPlan
--where  idplan=1

--UPDATE MULTIPLE 

alter table tbPlan alter column nombre varchar(50)
select * from tbPlan
update  tbPlan
set     nombre=CASE WHEN tarifadol<35 then CONCAT(nombre,'$') else CONCAT(nombre,'-') end,
        tarifadol=(1.1*tarifadol+5)*1.2,
		fecactualiza=getdate()
from    tbPlan
select * from tbPlan
