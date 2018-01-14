--Uso de OVER
--1 Uso de ROW_NUMBER
select idCliente, 
       diasMoraNuevo,
	   ROW_NUMBER() OVER(ORDER BY diasMoraNuevo desc) as posicion
from   tbCuenta
where  diasMoraNuevo is not NULL
order by diasMoraNuevo desc

select idCliente, 
       diasMoraNuevo,
	   ROW_NUMBER() OVER(ORDER BY diasMoraNuevo asc) as posicion
from   tbCuenta
where  diasMoraNuevo is not NULL
order by diasMoraNuevo asc

select idCliente, 
       numcuenta,       
       diasMoraNuevo,
	   ROW_NUMBER() OVER(PARTITION BY idCliente ORDER BY diasMoraNuevo asc) as posicion
from   tbCuenta
where  diasMoraNuevo is not NULL
order by idCliente,diasMoraNuevo asc

--2 Uso de RANK-DENSE_RANK-NTILE
--Por tipo de cliente establecer un ranking del total de cuentas de cada cliente

--Consulta interna
select idCliente,count(1)as totctas from tbCuenta
group by idCliente

--Consulta externa 
select tipoCliente,
       numDoc, 
       ctegrupo.totctas as TotalCtas,
	   ROW_NUMBER() OVER(PARTITION BY tipoCliente ORDER BY ctegrupo.totctas DESC) as #,
	   RANK() OVER(PARTITION BY tipoCliente ORDER BY ctegrupo.totctas DESC) as #RANK,
	   DENSE_RANK() OVER(PARTITION BY tipoCliente ORDER BY ctegrupo.totctas DESC) as #DENSE_RANK,
	   NTILE(4) OVER(PARTITION BY tipoCliente ORDER BY ctegrupo.totctas DESC) as NTILE
from tbCliente cte 
inner join (
		select idCliente,count(1)as totctas from tbCuenta
		group by idCliente
) ctegrupo on cte.id=ctegrupo.idCliente
order by tipoCliente,TotalCtas desc

--3 Uso de OVER+Funciones de Agrupamiento
--FUNCION_AGRUPA(EXPRESION) OVER(PARTITION BY CAMPO_PARTICION) 

select idCliente,
       moneda,
	   deudaTotal,
	   case when moneda='SOL' then deudaTotal else 3.12*deudaTotal end as deudaTotalSOL,
	   SUM(case when moneda='SOL' then deudaTotal else 3.12*deudaTotal end) OVER (PARTITION BY idCliente)as SUM,
	   AVG(case when moneda='SOL' then deudaTotal else 3.12*deudaTotal end) OVER (PARTITION BY idCliente)as AVG,
	   COUNT(case when moneda='SOL' then deudaTotal else 3.12*deudaTotal end) OVER (PARTITION BY idCliente)as COUNT,
	   MIN(case when moneda='SOL' then deudaTotal else 3.12*deudaTotal end) OVER (PARTITION BY idCliente)as MIN,
	   MAX(case when moneda='SOL' then deudaTotal else 3.12*deudaTotal end) OVER (PARTITION BY idCliente)as MAX
from   tbCuenta
order by idCliente

--4 Uso de OVER+Funciones OFFSET
--F.OFFSET (campo) OVER(PARTITION BY campo_particion ORDER BY campoX) as LAG
select idCliente,
       moneda,
	   deudaTotal,
	   case when moneda='SOL' then deudaTotal else 3.12*deudaTotal end as deudaTotalSOL,
	   LAG(deudaTotal) OVER(PARTITION BY idCliente ORDER BY case when moneda='SOL' then deudaTotal else 3.12*deudaTotal end) as LAG_COL,
	   LEAD(deudaTotal) OVER(PARTITION BY idCliente ORDER BY case when moneda='SOL' then deudaTotal else 3.12*deudaTotal end) as LEAD_COL,
	   FIRST_VALUE(deudaTotal) OVER(PARTITION BY idCliente ORDER BY case when moneda='SOL' then deudaTotal else 3.12*deudaTotal end) as FIRST_VALUE_COL,
	   LAST_VALUE(deudaTotal) OVER(PARTITION BY idCliente ORDER BY case when moneda='SOL' then deudaTotal else 3.12*deudaTotal end) as LAST_VALUE_COL,
	   LAG(case when moneda='SOL' then deudaTotal else 3.12*deudaTotal end) OVER(PARTITION BY idCliente ORDER BY case when moneda='SOL' then deudaTotal else 3.12*deudaTotal end) as LAG_EXP,
	   LEAD(case when moneda='SOL' then deudaTotal else 3.12*deudaTotal end) OVER(PARTITION BY idCliente ORDER BY case when moneda='SOL' then deudaTotal else 3.12*deudaTotal end) as LEAD_EXP,
	   FIRST_VALUE(case when moneda='SOL' then deudaTotal else 3.12*deudaTotal end) OVER(PARTITION BY idCliente ORDER BY case when moneda='SOL' then deudaTotal else 3.12*deudaTotal end) as FIRST_VALUE_EXP,
	   LAST_VALUE(case when moneda='SOL' then deudaTotal else 3.12*deudaTotal end) OVER(PARTITION BY idCliente ORDER BY case when moneda='SOL' then deudaTotal else 3.12*deudaTotal end) as LAST_VALUE_EXP
from   tbCuenta
order by idCliente

