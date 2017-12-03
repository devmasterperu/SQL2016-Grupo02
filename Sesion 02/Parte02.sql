
--Taller de Ordenamiento y Filtrado
--1.Toda vez que se requiera listar los pa�ses, la base de datos debe enviar el id,
--nombre de cada pa�s ordenado por nombre de manera ascendente
--1.1 Generar sentencias en Excel para inserci�n.
--1.2 Ejecutar inserci�n sobre tabla tbPais
--1.3 Elaborar consulta con lo solicitado.
select   idpais,
         nombrepais
from     tbPais 
order by nombrepais asc

--2.Elaborar un reporte que liste las pel�culas registradas entre el 26/11/2017 y el 01/12/2017
--Adem�s,si es una pel�cula peruana debe mostrar el mensaje �Pel�cula Nacional�. 
--Caso contrario, �Pel�cula del extranjero�
--2.1 Inserci�n de pel�cula extranjera.
insert into tbPelicula
select 2,'JASON X','...','http://devmaster.pe/devflix/jasonx',1990,90,getdate(),null
--2.2 An�lisis de formato de fecha: 2017-11-26 13:07:03.303->20171126 (Formato 112)
--2.3 Elaborar consulta con lo solicitado. 
select nombre,
       convert(varchar(8),fecregistro,112) as fecregistro,
       case when idpais=1 then 'Pel�cula Nacional' else 'Pel�cula del extranjero' end as Mensaje
from   tbPelicula
where  convert(varchar(8),fecregistro,112)>='20171126' and convert(varchar(8),fecregistro,112)<='20171201'

--3.Elaborar un reporte que liste las pel�culas cuyo nombre contenga la palabra �MA�. 
--Adem�s, considere el siguiente cuadro para mostrar en base a la duraci�n en minutos un mensaje
select nombre,
       duracionmin,
case   when duracionmin>=0 and duracionmin<=59 then 'Pel�cula no cumple los est�ndares de la plataforma'
       when duracionmin>=60 and duracionmin<=90 then 'Pel�cula '+nombre+' es de duraci�n baja'
       when duracionmin>=91 and duracionmin<=120 then 'Pel�cula '+nombre+' es de duraci�n media'
       else 'Pel�cula '+nombre+' es de duraci�n alta' end as mensaje_pelicula
from   tbPelicula
where  nombre like '%MA%'--Obtener las pel�culas con MA dentro del nombre

--4.Elaborar un reporte que liste en una sola consulta
--4.1 Pel�culas con a�o de estreno 2015 y duraci�n en minutos mayor a 100
--4.2 Pel�culas con a�o de estreno 2016 hacia adelante.
--Usando Operadores L�gicos
--Tabla de verdad: PvQ.Si al menos una de las expresiones es verdadera. la fila ser� devueltas en SQL. 
select nombre,estreno,duracionmin from tbPelicula
where (estreno=2015 and duracionmin>100) --P
			OR 
      (estreno>=2016)					 --Q	
--Con UNION ALL.
--Se "pegan" los resultados del primer y segundo SELECT.
select nombre,estreno,duracionmin from tbPelicula
where estreno=2015 and duracionmin>100
union all
select nombre,estreno,duracionmin from tbPelicula
where estreno>=2016

--5.Elaborar un reporte que liste las pel�culas no estrenadas en el a�o 2015
--Forma 1
select nombre,estreno,duracionmin from tbPelicula
where NOT (estreno=2015)
--Forma 2
select nombre,estreno,duracionmin from tbPelicula
where estreno!=2015
--Forma 3
select nombre,estreno,duracionmin from tbPelicula
where estreno<>2015
--Forma 4
select nombre,estreno,duracionmin from tbPelicula
where estreno NOT IN (2015)

--6.En base al requerimiento 1, elabore un reporte que liste los 10 primeros
--pa�ses ordenados por nombre de manera descendente. Este reporte recibe un
--par�metro que indica si incluir� filas con valores que coinciden con la
--posici�n 10

--Variable que controla que reporte se mostrar�
declare @siempates bit
set     @siempates=1

--L�gica de reporte 
if @siempates=0
begin
	--Se muestran s�lo 10 registros y UGANDA se muestra una sola vez
	select top 10 nombrepais,idpais from tbPais
	order by nombrepais desc
end
else
begin
	--Se muestran 11 registros y UGANDA se muestra m�s de una vez
	select top 10 with ties nombrepais,idpais from tbPais
	order by nombrepais desc
end

--Otros ejemplos
--Uso de IN
--Buscar peliculas con id 1 o id 4
select * from tbCategoriaPelicula
where idpelicula in (4,1)--
--Buscar peliculas con id 1 o id 4 (Forma 02)
select * from tbCategoriaPelicula
where 
 idpelicula=1 --p true--false
 or
 idpelicula=4 --q true--false
 --Uso de BETWEEN
 select nombre,
       convert(varchar(8),fecregistro,112) as fecregistro,
       case when idpais=1 then 'Pel�cula Nacional' else 'Pel�cula del extranjero' end as Mensaje
from   tbPelicula
where  convert(varchar(8),fecregistro,112) BETWEEN '20171126' and '20171203'
--Usando IN en vez de BETWEEN
 select nombre,
       convert(varchar(8),fecregistro,112) as fecregistro,
       case when idpais=1 then 'Pel�cula Nacional' else 'Pel�cula del extranjero' end as Mensaje
from   tbPelicula
where  convert(varchar(8),fecregistro,112) in ('20171126','20171127','20171128','20171129','20171130',
'20171201','20171202','20171203')



