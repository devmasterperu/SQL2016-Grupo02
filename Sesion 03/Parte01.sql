--Semana 03
--1. Uso de OFFSET
--Manera no dinámica
--Marcando
SELECT *
FROM   tbPelicula
ORDER BY fecregistro desc
OFFSET 0 ROWS--Se saltea 0 registros
FETCH NEXT 3 ROWS ONLY

SELECT *
FROM   tbPelicula
ORDER BY fecregistro desc
OFFSET 3 ROWS--Se saltea 0 registros
FETCH NEXT 3 ROWS ONLY

SELECT *
FROM   tbPelicula
ORDER BY fecregistro desc
OFFSET 6 ROWS--Se saltea 0 registros
FETCH NEXT 3 ROWS ONLY

--Manera dinámica

DECLARE  @tamPagina AS BIGINT = 3, 
         --@numPagina AS BIGINT = 1;
		 --@numPagina AS BIGINT = 2;
		 @numPagina AS BIGINT = 3;

SELECT     *
FROM       tbPelicula
ORDER BY   fecregistro DESC
OFFSET    (@numPagina - 1) * @tamPagina ROWS 
FETCH NEXT @tamPagina ROWS ONLY


--2 Uso de NULL
--2.1 Quienes son los usuarios con fecha de confirmación desconocida
SELECT     *
FROM       tbUsuario
where      fechconfirma is null

SELECT     alias,correo,
           case when fechconfirma is null then 'Fecha no confirmada por usuario'
		   else 'El usuario confirmó el '+CONVERT(varchar(8),fechconfirma,112)
		   end as mensaje
FROM       tbUsuario
where      fechconfirma is null   --Valores desconocidos
--where      fechconfirma is not null --Valores conocidos

--3 Uso de LIKE
--3.1 Países que inician con una vocal
select * from tbPais
where nombrepais LIKE '[aeiou]%'
order by nombrepais
--3.2.1 Países que inician con una consonante
select * from tbPais
where nombrepais LIKE '[^aeiou]%'
order by nombrepais
--3.2.2 Países que no contengan algún caracter especial
select * from tbPais
where nombrepais LIKE '[^aeiou]%' and nombrepais NOT LIKE '%-%'
order by nombrepais
--3.3.1 Inicia y termina con una "a"
select * from tbPais
where nombrepais LIKE 'a%a' 
order by nombrepais
--3.3.2 Inicia con una "e" y termina con una "a"
select * from tbPais
where nombrepais LIKE 'e%a' 
order by nombrepais
--3.4 Contenga secuencia ama
select * from tbPais
where nombrepais LIKE '%ama%' 
order by nombrepais
--3.5 Segunda letra es una “u” y penúltima la “i”
select * from tbPais
where nombrepais LIKE '_u%i_' 
order by nombrepais
--3.6.1 Segunda letra es una “u” y antepenúltima diferente a “i”
select * from tbPais
where nombrepais LIKE '_u%[^i]__' 
order by nombrepais
--3.6.2 Segunda letra es una “u” y antepenúltima diferente a “i” o diferente a "o"
select * from tbPais
where nombrepais LIKE '_u%[^io]__' 
order by nombrepais
--3.7 Contenga una “a” seguida del carácter sombrero, seguida de la letra “b”
select * from tbPais
where nombrepais LIKE '%a^b%' 
order by nombrepais
--3.8 Contenga una vocal seguida de la letra “n”, seguida de una consonante
select * from tbPais
where nombrepais LIKE '%[aeiou]n[^aeiou]%' 
order by nombrepais