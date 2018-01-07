--1 Uso de CTE
WITH CTE_DeudaVencidaSol--NOMBRE CTE
AS
(
    --INNER QUERY
	select AVG(deudavencidasol) as deudavencidasol
	from
	(
		select case 
				when moneda='SOL' then deudaVencida
				when moneda='DOL' then (select conversionSOL from tbTipoCambio where fecha='20180105')*deudaVencida
				end as deudavencidasol
		from   tbCuenta cta 
		inner join tbCliente cte on cta.idCliente=cte.id
		inner join tbUbigeo ubi on cte.idUbigeo=ubi.id
		where UPPER(ubi.distrito)='HUACHO'
	) reshuacho
)
--OUTER QUERY
select cta.*,(select deudavencidasol from CTE_DeudaVencidaSol) as deudavencidasolprom
from   tbCuenta cta
where case 
			when moneda='SOL' then cta.deudaVencida
			when moneda='DOL' then (select conversionSOL from tbTipoCambio where fecha='20180105')*cta.deudaVencida
	   end<(select deudavencidasol from CTE_DeudaVencidaSol);

WITH CTE_DeudaVencidaSol--NOMBRE CTE
AS
(
    --INNER QUERY
	select AVG(deudavencidasol) as deudavencidasol
	from
	(
		select case 
				when moneda='SOL' then deudaVencida
				when moneda='DOL' then (select conversionSOL from tbTipoCambio where fecha='20180105')*deudaVencida
				end as deudavencidasol
		from   tbCuenta cta 
		inner join tbCliente cte on cta.idCliente=cte.id
		inner join tbUbigeo ubi on cte.idUbigeo=ubi.id
		where UPPER(ubi.distrito)='HUACHO'
	) reshuacho
)

select deudavencidasol from CTE_DeudaVencidaSol

--2 Uso de Vistas
create view dbo.vReporteDeudasVencidas
as
select CONCAT(nombres,' ',apellidoPat,' ', apellidoMat) as nombrecompleto,
       doc.descripcion,
	   cte.numDoc,
	   (
			select AVG(deudavencidasol)
			from
			(
				select case 
					   when moneda='SOL' then deudaVencida
					   when moneda='DOL' then (select conversionSOL from tbTipoCambio where fecha='20180105')*deudaVencida
					   end as deudavencidasol
				from   tbCuenta cta 
				inner join tbCliente cte on cta.idCliente=cte.id
				inner join tbUbigeo ubi on cte.idUbigeo=ubi.id
				where UPPER(ubi.distrito)='HUACHO'
			) reshuacho
	   ) deudavencidapromedio,
	   case 
			when moneda='SOL' then cta.deudaVencida
			when moneda='DOL' then (select conversionSOL from tbTipoCambio where fecha='20180105')*cta.deudaVencida
	   end as deudavencidasol,
	   cta.numcuenta
from   tbCliente cte
inner join tbTipoDocumento doc on cte.tipoDoc=doc.tipo
inner join tbCuenta cta on cta.idCliente=cte.id
where  case 
			when moneda='SOL' then cta.deudaVencida
			when moneda='DOL' then (select conversionSOL from tbTipoCambio where fecha='20180105')*cta.deudaVencida
	   end <   (
					select AVG(deudavencidasol)
					from
					(
						select case 
							   when moneda='SOL' then deudaVencida
							   when moneda='DOL' then (select conversionSOL from tbTipoCambio where fecha='20180105')*deudaVencida
							   end as deudavencidasol
						from   tbCuenta cta 
						inner join tbCliente cte on cta.idCliente=cte.id
						inner join tbUbigeo ubi on cte.idUbigeo=ubi.id
						where UPPER(ubi.distrito)='HUACHO'
					) reshuacho
				) 
--order by nombrecompleto

select top 10 nombrecompleto,descripcion,numDoc from dbo.vReporteDeudasVencidas

select top 20 nombrecompleto,descripcion,numDoc from dbo.vReporteDeudasVencidas

select top 30 nombrecompleto,descripcion,numDoc,* from dbo.vReporteDeudasVencidas

--3 Uso de Tabla en línea
--create function 
alter function dbo.fReporteDeudasVencidas(@numDoc varchar(8),@numcuenta varchar(20)) returns 
table
as
return
select CONCAT(nombres,' ',apellidoPat,' ', apellidoMat) as nombrecompleto,
       doc.descripcion,
	   cte.numDoc,
	   (
			select AVG(deudavencidasol)
			from
			(
				select case 
					   when moneda='SOL' then deudaVencida
					   when moneda='DOL' then (select conversionSOL from tbTipoCambio where fecha='20180105')*deudaVencida
					   end as deudavencidasol
				from   tbCuenta cta 
				inner join tbCliente cte on cta.idCliente=cte.id
				inner join tbUbigeo ubi on cte.idUbigeo=ubi.id
				where UPPER(ubi.distrito)='HUACHO'
			) reshuacho
	   ) deudavencidapromedio,
	   case 
			when moneda='SOL' then cta.deudaVencida
			when moneda='DOL' then (select conversionSOL from tbTipoCambio where fecha='20180105')*cta.deudaVencida
	   end as deudavencidasol,
	   cta.numcuenta
from   tbCliente cte
inner join tbTipoDocumento doc on cte.tipoDoc=doc.tipo
inner join tbCuenta cta on cta.idCliente=cte.id
where  case 
			when moneda='SOL' then cta.deudaVencida
			when moneda='DOL' then (select conversionSOL from tbTipoCambio where fecha='20180105')*cta.deudaVencida
	   end <   (
					select AVG(deudavencidasol)
					from
					(
						select case 
							   when moneda='SOL' then deudaVencida
							   when moneda='DOL' then (select conversionSOL from tbTipoCambio where fecha='20180105')*deudaVencida
							   end as deudavencidasol
						from   tbCuenta cta 
						inner join tbCliente cte on cta.idCliente=cte.id
						inner join tbUbigeo ubi on cte.idUbigeo=ubi.id
						where UPPER(ubi.distrito)='HUACHO'
					) reshuacho
				) 
and cte.numDoc=@numDoc and cta.numcuenta=@numcuenta

--Llamar a la función creada
select * from dbo.fReporteDeudasVencidas('46173384','10001000100010001')

--4 Uso de tablas temporales
	
	if OBJECT_ID('##tDeudasVencidas2') IS NOT NULL--La tabla temp. esta creada
	begin
		drop table ##tDeudasVencidas2
	end

	select AVG(deudavencidasol) as promedio
	into   ##tDeudasVencidas2
	from
	(
		select case 
				when moneda='SOL' then deudaVencida
				when moneda='DOL' then (select conversionSOL from tbTipoCambio where fecha='20180105')*deudaVencida
				end as deudavencidasol
		from   tbCuenta cta 
		inner join tbCliente cte on cta.idCliente=cte.id
		inner join tbUbigeo ubi on cte.idUbigeo=ubi.id
		where UPPER(ubi.distrito)='HUACHO'
	) reshuacho

	select CONCAT(nombres,' ',apellidoPat,' ', apellidoMat) as nombrecompleto,
		   doc.descripcion,
		   cte.numDoc,
	       (select promedio from ##tDeudasVencidas2),
		   case 
				when moneda='SOL' then cta.deudaVencida
				when moneda='DOL' then (select conversionSOL from tbTipoCambio where fecha='20180105')*cta.deudaVencida
		   end as deudavencidasol,
		   cta.numcuenta
	from   tbCliente cte
	inner join tbTipoDocumento doc on cte.tipoDoc=doc.tipo
	inner join tbCuenta cta on cta.idCliente=cte.id
	where  case 
				when moneda='SOL' then cta.deudaVencida
				when moneda='DOL' then (select conversionSOL from tbTipoCambio where fecha='20180105')*cta.deudaVencida
		   end < (select promedio from ##tDeudasVencidas2)
	order by nombrecompleto

