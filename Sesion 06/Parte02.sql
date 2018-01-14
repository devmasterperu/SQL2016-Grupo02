--Parte 02
--1 Uso de UNION|UNION ALL
select * from
(
select numDoc,nombres,apellidoPat,apellidoMat from tbCliente
where nombres NOT LIKE '%^%'
union
select numDoc,nombres,apellidoMat,apellidoPat from tbMaestroCliente
union
select '99999999','desconocido','desconocido','desconocido'
) tbPersona
order by numDoc,nombres,apellidoPat,apellidoMat

--2 Uso de INTERSECT
select numDoc,nombres,apellidoPat,apellidoMat from tbCliente
where nombres NOT LIKE '%^%'
INTERSECT
select numDoc,nombres,apellidoPat,apellidoMat from tbMaestroCliente

select numDoc from tbCliente
where nombres NOT LIKE '%^%'
INTERSECT
select numDoc from tbMaestroCliente

--union
--select '99999999','desconocido','desconocido','desconocido'

--3 Uso de EXCEPT
select numDoc,nombres,apellidoPat,apellidoMat from tbCliente
where nombres NOT LIKE '%^%'
EXCEPT
select numDoc,nombres,apellidoPat,apellidoMat from tbMaestroCliente

select numDoc,nombres,apellidoPat,apellidoMat from tbMaestroCliente
EXCEPT
select numDoc,nombres,apellidoPat,apellidoMat from tbCliente
where nombres NOT LIKE '%^%'

select numDoc,nombres,apellidoPat,apellidoMat from tbCliente
where nombres NOT LIKE '%^%' and nombres NOT LIKE '%Ana%'
EXCEPT
select numDoc,nombres,apellidoPat,apellidoMat from tbMaestroCliente
