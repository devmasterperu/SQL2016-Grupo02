select * from tbTipoCliente
--Subconsulta dentro de SELECT
--1 

--Consulta externa
select numcuenta,
	   (select max(diasMoraNuevo) from tbCuenta) as maxdiasmora,--Consulta interna
	   diasMoraNuevo,
	   (select max(diasMoraNuevo) from tbCuenta)-diasMoraNuevo as diferencial
from   tbCuenta
where  diasMoraNuevo is not null
order by diferencial
--order by (select max(diasMoraNuevo) from tbCuenta)-diasMoraNuevo

--2

select numcuenta,
	   (select max(diasMoraNuevo) from tbCuenta) as maxdiasmora,--Consulta interna
	   diasMoraNuevo,
	   (select max(diasMoraNuevo) from tbCuenta)-diasMoraNuevo as diferencial,
	   --Adicionar clasificacion en base a cuadro.
	   case 
	   when diasMoraNuevo>=1 and diasMoraNuevo<=90 then 'Riesgo bajo'
	   when diasMoraNuevo>=91 and diasMoraNuevo<=120 then 'Riesgo medio'
	   when diasMoraNuevo>=121  then 'Riesgo alto'
	   end as clasificacion
from   tbCuenta
where  diasMoraNuevo is not null
order by diferencial

--3
--Consulta interna
select conversionSOL from tbTipoCambio where fecha='20180105'--T.C del 05/01
select conversionSOL from tbTipoCambio where fecha='20180104'--T.C del 04/01
select conversionSOL from tbTipoCambio where fecha=convert(varchar(8),getdate()-1,112)--T.C del día anterior

select numcuenta,
       moneda,
	   deudaTotal,
	   case when moneda='SOL' then deudaTotal
	        when moneda='DOL' then (select conversionSOL from tbTipoCambio where fecha='20180105')*deudaTotal
	   end as deudatotalsol,
	    case when moneda='DOL' then deudaTotal
	         when moneda='SOL' then (select conversionDOL from tbTipoCambio where fecha='20180104')*deudaTotal
	   end as deudatotaldol
       --deuda total dolarizada con TC 20180104
from   tbCuenta

--4
--Consulta interna
select sum(deudaVencida) from tbCuenta where moneda='SOL'
--Consulta externa
select numcuenta,
	   moneda,
	   deudaVencida,
	   --case when moneda='SOL' then deudaVencida
	   --     when moneda='DOL' then (select conversionSOL from tbTipoCambio where fecha='20180105')*deudaVencida
	   --end as deudavencidasol,
	   concat(
		   cast(
				cast(deudaVencida/(select sum(deudaVencida) from tbCuenta where moneda='SOL')*100 as numeric(10,2))
				as varchar(10)
			),
			'%'
		)
	   as ratiodeudavencidasol
from   tbCuenta
where  moneda='SOL'

--5 
--Forma 1
   --Consulta externa con FROM
   select count(1) as totTiposDoc,
          (select count(1) from tbProducto) as totProductos,--Consulta interna 1
		  (select count(1) from tbTipoCliente) as totTipoClientes,--Consulta interna 2
		  (select count(1) from tbUbigeo) as totUbigeo--Consulta interna 3
   from   tbTipoDocumento
--Forma 2
   --Consulta externa sin FROM
		  SELECT
		  (select count(1) from tbTipoDocumento) as totTiposDoc,--Consulta interna 0
		  (select count(1) from tbProducto) as totProductos,--Consulta interna 1
		  (select count(1) from tbTipoCliente) as totTipoClientes,--Consulta interna 2
		  (select count(1) from tbUbigeo) as totUbigeo--Consulta interna 3

--Subconsulta dentro de FROM
--6
  --Consulta interna
  select cte.idUbigeo,AVG(diasMoraNuevo)  as promDiasMora
  from   tbCuenta cta
  inner join tbCliente cte on cta.idCliente=cte.id
  group by cte.idUbigeo
  --Consulta externa
  select cli.id, 
         doc.descripcion,
		 cli.numDoc,
		 CONCAT(nombres,' ',apellidoPat,' ',apellidoMat) as nombrecompleto,
		 CONCAT(departamento,'-',provincia,'-',distrito) as ubigeo,
		 resubigeo.promDiasMora
  from   tbCliente cli
  inner join tbTipoDocumento doc on cli.tipoDoc=doc.tipo
  inner join tbUbigeo ubi on cli.idUbigeo=ubi.id
  inner join (	 --Consulta externa
				  select cte.idUbigeo,AVG(diasMoraNuevo)  as promDiasMora
				  from   tbCuenta cta
				  inner join tbCliente cte on cta.idCliente=cte.id
				  group by cte.idUbigeo
			 ) resubigeo on cli.idUbigeo=resubigeo.idUbigeo
  where  cli.nombres not like '%^%'
  order by cli.idUbigeo

  --7
  --Forma 1
  --Consulta interna
  --Total de clientes por ubigeo
	select idUbigeo,count(1) as total 
	from   tbCliente
	group by idUbigeo
  --Máximo días mora por ubigeo
    select idUbigeo,max(cta.diasMoraNuevo) as MaxDiasMora 
	from   tbCliente cli 
	inner join tbCuenta cta on cli.id=cta.idCliente
	group by idUbigeo
  --Consulta externa
    select id, 
	       departamento,
		   provincia,
		   distrito,
		   resxtotal.total,
		   resmax.MaxDiasMora
	from   tbUbigeo ubi
	inner join (--Consulta interna 1
				select idUbigeo,count(1) as total 
				from   tbCliente
				group by idUbigeo
			   ) resxtotal on resxtotal.idUbigeo=ubi.id
	inner join (--Consulta interna 2
				select idUbigeo,max(cta.diasMoraNuevo) as MaxDiasMora 
				from   tbCliente cli 
				inner join tbCuenta cta on cli.id=cta.idCliente
				group by idUbigeo
			   ) resmax on resmax.idUbigeo=ubi.id

      select id, 
	       departamento,
		   provincia,
		   distrito,
		   isnull(resxtotal.total,0) as total,
		   isnull(resmax.MaxDiasMora,999999999) as maxDiasMora
	from   tbUbigeo ubi
	left join (--Consulta interna 1
				select idUbigeo,count(1) as total 
				from   tbCliente
				group by idUbigeo
			   ) resxtotal on resxtotal.idUbigeo=ubi.id
	left join (--Consulta interna 2
				select idUbigeo,max(cta.diasMoraNuevo) as MaxDiasMora 
				from   tbCliente cli 
				inner join tbCuenta cta on cli.id=cta.idCliente
				group by idUbigeo
			   ) resmax on resmax.idUbigeo=ubi.id
--8 