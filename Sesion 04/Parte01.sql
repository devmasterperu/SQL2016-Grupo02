--SEMANA04
--1 Uso de CONCAT
select top 1 'Usuario:'+alias+'-correo:'+correo --Concatenacion con +
from tbUsuario
select top 1 concat('Usuario:',alias,'-correo:',correo)--Funcion CONCAT
from tbUsuario
select top 1 'Usuario:'+null+'-correo:'+correo 
from tbUsuario
select top 1 concat('Usuario:',null,'-correo:',correo)
from tbUsuario

--alter table tbUsuario add telefono varchar(15)

--update tbUsuario
--set telefono='995995177'
--where idusuario=1
select 'Usuario:'+alias+'-telefono:'+telefono 
from tbUsuario
where idusuario!=1
select concat('Usuario:',alias,'-telefono:',telefono)
from tbUsuario
where idusuario!=1

--Uso de SUBSTRING
--SUBSTRING(expression, start, length)

select nombre,
       resumen,
	   SUBSTRING(resumen,1, 6)--Obtener porción de cadena
from   tbPelicula

--LEFT(expression, integer_value)

select nombre,
       resumen,
	   SUBSTRING(resumen,1, 3) as subcadena,--Obtener porción de cadena
	   LEFT(SUBSTRING(resumen,1,3),2) as subcadena2--Obtener porción de cadena desde el inicio
									 --de la porción de cadena anterior
from   tbPelicula

--RIGHT(expression, integer_value)

select nombre,
       resumen,
	   SUBSTRING(resumen,1, 3) as subcadena,--Obtener porción de cadena
	   LEFT(SUBSTRING(resumen,1,3),2) as subcadena1,--Obtener porción izquierda de cadena
	   RIGHT(SUBSTRING(resumen,1,3),2) as subcadena2--Obtener porción derecha de cadena
from   tbPelicula

--LEN(string_expression)|DATALENGTH(expression)


select nombre,
       resumen,
	   LEN(nombre) as longitudsubcadena,
	   DATALENGTH(nombre)  as longitudsubcadena2
from   tbPelicula

--insert into tbPelicula
--select 1,'La Paisana Jacinta  ','...','http://devmaster.pe/devflix/paisanajacinta',
--2017,90,getdate(),null

--CHARINDEX(expressionToFind, expressionToSearch)

declare @expressionToSearch varchar(20)='OS'
select nombre,
       CHARINDEX(@expressionToSearch, nombre) as posicionEncontrada
from   tbPelicula
where  CHARINDEX(@expressionToSearch, nombre)>0 and
       LEN(nombre)<10

--REPLACE(string_expression, string_pattern, string_replacement)
declare @expressionToSearch2 varchar(20)='A'
select nombre,
       CHARINDEX(@expressionToSearch2, nombre) as posicionEncontrada,
	   REPLACE(nombre,' ','*') as nombreremplazado,
	   REPLACE(nombre,'A',' ') as nombreremplazado
from   tbPelicula
where  CHARINDEX(@expressionToSearch2, nombre)>0 and
       LEN(nombre)<10

--UPPER(character_expression)
--LOWER(character_expression)
select nombre,
       resumen,
	   UPPER(resumen) as resumenMay,--Convierte todo a mayuscula
	   LOWER(resumen) as resumenMin --Convierte todo a minuscula
from   tbPelicula

--2 Uso de funciones de Fecha y Hora

--Funciones que retornan la fecha y hora actual
SELECT GETDATE(),--Fecha y hora actual en datetime
	   GETUTCDATE(),--Fecha y hora actual UTC en datetime
	   CURRENT_TIMESTAMP,--Fecha y hora actual en datetime
	   SYSDATETIME(),--Fecha y hora actual en datetime2
	   SYSUTCDATETIME(),--Fecha y hora actual UTC en datetime2
	   SYSDATETIMEOFFSET() as SYSDATETIMEOFFSET

--Funciones que obtienen parte de fecha y hora:
--DATENAME( datepart, date)
select nombre,
       fecregistro,
	   DATENAME(YYYY,fecregistro) as nombreaño,
	   DATENAME(MM,fecregistro) as nombremes,
	   DATENAME(DD,fecregistro) as nombredia,
	   DATENAME(DW,fecregistro) as nombrediasemana
 from tbPelicula
--DATEPART ( datepart , date )
--Sunday (Domingo) es el valor 1.
select nombre,
       fecregistro,
	   DATEPART(YYYY,fecregistro) as valoraño,
	   DATEPART(MM,fecregistro) as valormes,
	   DATEPART(DD,fecregistro) as valordia,
	   DATEPART(DW,fecregistro) as valordiasemana
 from tbPelicula
 --DAY ( date )|MONTH ( date )|YEAR ( date )
 select nombre,
       fecregistro,
	   DAY (fecregistro) AS DIA,
	   MONTH (fecregistro) AS MES,
	   YEAR (fecregistro) AS AÑO
 from tbPelicula

 --Funciones que obtienen la fecha y hora a partir de sus partes
 --DATEFROMPARTS ( year, month, day )
 select DATEFROMPARTS (2016,1,25)
--DATETIME2FROMPARTS ( year, month, day, hour, minute, seconds, fractions, precision )
 select DATETIME2FROMPARTS (2016,1,25,11,30,10,53,2)
 --TIMEFROMPARTS ( hour, minute, seconds, fractions, precision )
  select TIMEFROMPARTS(11,30,10,53,2)
 --SMALLDATETIMEFROMPARTS ( year, month, day, hour, minute )
  select SMALLDATETIMEFROMPARTS(2017,10,5,5,20)
  --Funciones que modifican valores de fecha y hora
  --DATEADD(datepart, interval, date)
  select  fecregistro, 
          DATEADD(MM, 1, fecregistro) as nuevofecregistro1,
		  DATEADD(MM, -1, fecregistro) as nuevofecregistro2,
		  DATEADD(YY,2, fecregistro) as nuevofecregistro3,
		  DATEADD(hh,-5, fecregistro) as nuevofecregistro3
  from tbPelicula
  --EOMONTH(start_date, interval)
  select  fecregistro, 
           EOMONTH(fecregistro) as finmesactual,
		   EOMONTH(fecregistro,-1) as finmesant,
		   EOMONTH(fecregistro,1) as finmessgte,
		   EOMONTH(fecregistro,-12) as finmesañoant
  from tbPelicula
  --SWITCHOFFSET(datetimeoffset, time_zone)
 CREATE TABLE dbo.prueba   
(  
ColDatetimeoffset datetimeoffset  
);  
GO  
INSERT INTO dbo.prueba   
VALUES ('2017-10-11 7:45:50.71345 -5:00');  
GO  

SELECT ColDatetimeoffset,SWITCHOFFSET (ColDatetimeoffset, '-08:00')   
FROM dbo.prueba;  

  --TODATETIMEOFFSET(expression, time_zone)
  DECLARE @todaysDateTime datetime2;  
   SET @todaysDateTime = GETDATE();  
   SELECT @todaysDateTime,TODATETIMEOFFSET (@todaysDateTime, '-07:00'); 

   SELECT fecregistro,TODATETIMEOFFSET (fecregistro, '-10:00') as fecregistroconoffset
   from tbPelicula