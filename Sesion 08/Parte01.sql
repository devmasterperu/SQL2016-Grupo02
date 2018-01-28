--1
--Declara nombre de procedimiento
CREATE PROCEDURE dbo.insTipoDocumento
--Declara de parametros de entrada
(
@tipoSunat varchar(2),--parametro y tipo de dato
@descLarga varchar(30),
@descCorta varchar(20)
)
--Declara de logica
as
begin

	insert into dbo.tbTipoDocumento(tipoSunat,descLarga,descCorta)
	values (@tipoSunat,@descLarga,@descCorta)

	print 'El tipo de documento fue insertado'

end
--Ejecucion. Nombre de SP+Parametros de entrada
EXECUTE dbo.insTipoDocumento '12','PASAPORTE ELECTRONICO','PAS_ELECTRO'
EXEC dbo.insTipoDocumento '13','PASAPORTE ELECTRONICO 2','PAS_ELECTRO_2'
EXEC dbo.insTipoDocumento @tipoSunat='14',@descLarga='PASAPORTE ELECTRONICO 3',@descCorta='PAS_ELECTRO_3'
	--values ('12','PASAPORTE ELECTRONICO','PAS_ELECTRO')

--2
--3 
CREATE PROCEDURE dbo.InsProducto
(
@nombre varchar(300),
@cantidad decimal(10,2),
@descripUnidad varchar(10),
@precioUnidad decimal(10,2)
)
as
begin
	declare @idUnidad int
	set     @idUnidad=(select id from tbUnidad where descripcion=@descripUnidad)--Obtener el idUnidad x descripcion

	if @idUnidad is not null--Existe el valor en tbUnidad
	begin
			insert into dbo.tbProducto(nombre,cantidad,idUnidad,precioUnidad)
			values (@nombre,@cantidad,@idUnidad,@precioUnidad)

			print 'Producto ingresado a las '+CAST(GETDATE() as varchar(20))
	end
	else
	begin
			print 'Unidad de medida no existente'
	end
	
end
--Unidad de medida no existente
execute dbo.InsProducto 'Leche Pura Vida',100,'LT.',3.5
--Producto ingresado a las Jan 28 2018 10:00AM
execute dbo.InsProducto 'Leche Pura Vida',100,'litro',3.5
--3.5 Realizar la inserción de una persona en base a sus parámetros numDoc,nombres,apellidoPat,
--apellidoMat y la descripcion corta del tipo de documento. En caso de no existir el tipo de documento
--Imprimir un mensaje de tipo no existente++++

--4 
create procedure dbo.Upd_Persona
(
@idTipodDoc int,
@numDoc varchar(15),
@nombres varchar(100),
@apellidoPaterno varchar(100),
@apellidoMaterno varchar(100)
)
as  
begin

	declare @idPersona int
	set @idPersona=(select id from tbPersona where idTipoDoc=@idTipodDoc and numDoc=@numDoc)
	
	if @idPersona is not null --Persona existe en tbPersona 
	begin
		
		update pers
		set    nombres=@nombres,
			   apellidoPaterno=@apellidoPaterno,
			   apellidoMaterno=@apellidoMaterno
		from   tbPersona pers
		where  idTipoDoc=@idTipodDoc and numDoc=@numDoc

		print 'Persona actualizada a las'+cast(getdate() as varchar(10))

	end

end

select * from tbPersona
execute dbo.Upd_Persona 1,'46173384','GIANFRANCO','MANRIQUE','VALENTIN'

--4.5 Actualizar la cantidad,precioUnidad de un producto en base
--al nombre del producto. De no existir el producto, debe realizar el guardado del registro
--en la tabla log (nombre-producto,fecregistro)

create table tbLog
(
nombreproducto varchar(300),
fecregistro datetime default getdate()
)

--5 

create procedure dbo.DelPersona
(
@idTipoDoc int,
@numDoc varchar(15)
)
as
begin
	declare @idpersona int
	set @idpersona=(select id from tbPersona where idTipoDoc=@idTipoDoc and numDoc=@numDoc)

	if @idpersona is not null--Persona existe
	begin
		--Eliminacion en comprador
		delete tbComprador where idPersona=@idpersona

		print 'Registro eliminado'
	end
end
execute dbo.DelPersona 1,'46173384'

--5.5 Crear un SP que elimine todos las ventas con monto total menor a 40 soles
--6 
--USE ComprasS8_2
create procedure dbo.selReporteProductoMayorVenta
as
begin
	--Obtener el nombre del producto mas vendido
		declare @idProducto int 
		declare @nombreProducto varchar(300)
		declare @mtovendido decimal(10,2)
		declare @fecprimeraventa datetime
		declare @fecultimaventa datetime
		--Obtencion de idproducto y mtovendido
		select top 1 @idProducto=idProducto,@mtovendido=sum(totalDetalle) from tbVentaDetalle group by idProducto 

		set @nombreProducto=(select nombre from tbProducto where id=@idProducto)

		select @fecprimeraventa=min(fecRegistro), 
		       @fecultimaventa=max(fecRegistro)
		from tbVentaDetalle group by idProducto having idProducto=@idProducto

		print @idProducto
		print @nombreProducto
		print @mtovendido

	select 'DEV MASTER PERU SAC' as nombreEmpresa,
	        'Reporte al '+convert(varchar(10),getdate(),103)+' '+convert(varchar(10),getdate(),14) as CabeceraReporte,
			@nombreProducto as 'Producto + vendido',
			@mtovendido as 'Monto Total Venta',
			convert(varchar(10),@fecprimeraventa,103)  as 'Fecha de primera venta',
			convert(varchar(10),@fecultimaventa,103)  as 'Fecha de ultima venta'
end

--7 Operaciones con producto de mayor monto de venta
alter procedure dbo.selReporteDetalleProductoMayorVente
as
	declare @idProducto2 int 
	declare @mtovendido2 decimal(10,2)
	declare @nombreProducto2 varchar(300)
	select top 1 @idProducto2=idProducto,@mtovendido2=sum(totalDetalle) from tbVentaDetalle group by idProducto 

	set @nombreProducto2=(select nombre from tbProducto where id=@idProducto2)

	select  'DEV MASTER PERU SAC' as nombre_empresa,
			'11111111111' as ruc_empresa

	select 'Reporte al '+convert(varchar(10),getdate(),103)+' '+convert(varchar(10),getdate(),14) as CabeceraReporte,
			'VEN'+cast(vta.id as varchar(500)) as Venta,
	        @nombreProducto2 as Producto,
			vtadet.cantidad as unidades_vendidas,
			vtadet.precioUnidad as precio_unitario,
			vta.fecRegistro as fecha_venta
	from    tbVenta vta 
	inner join tbVentaDetalle vtadet on vta.id=vtadet.idCompra
	where       vtadet.idProducto=@idProducto2

execute selReporteDetalleProductoMayorVente

--7.5 Elaborar un procedimiento almacenado que retorne la fecha y hora de la consulta,
--la cantidad de compradores y la cantidad de vendedores.

---Fecha Consulta---Total_compradores--Total_vendedores
---28/01/2018 13:25 | 4				| 5
--7.5.1 Forma sin variables
create procedure dbo.selReporteCantidades
as
begin

	select convert(varchar(10),getdate(),103)+' '+convert(varchar(10),getdate(),14) as fecha_consulta,
	       (select count(1) from tbComprador) as total_compradores,
		   (select count(1) from tbVendedor) as total_vendedores
end

execute dbo.selReporteCantidades
--7.5.2 Forma con variables
alter procedure dbo.selReporteCantidades2
as
begin
    declare @fecha_consulta varchar(20)
	declare @total_compradores int
	declare @total_vendedores int

	set @fecha_consulta=(select convert(varchar(10),getdate(),103)+' '+convert(varchar(10),getdate(),14))
	set @total_compradores=(select count(1) from tbComprador)
	set @total_vendedores=(select count(1) from tbVendedor)

	select @fecha_consulta,@total_compradores as total_compradores,@total_vendedores as total_vendedores
end
execute dbo.selReporteCantidades2


--8 Reporte de ventas entre fechas
alter procedure dbo.reporteVentasPorFecha
(
@fecinicio varchar(8),
@fecfin    varchar(8)
)
as
begin
		select 'VEN'+CAST(vta.id as VARCHAR(100)) as venta,
		        total as monto_total, 
				CONCAT(per.nombres,' ',per.apellidoPaterno,' ',per.apellidoMaterno) as nom_vendedor,
				vta.fecRegistro
		from tbVenta vta 
		inner join tbVendedor vend on vta.idVendedor=vend.id
		inner join tbPersona per on vend.idPersona=per.id
		where convert(varchar(8),vta.fecregistro,112)>=@fecinicio and convert(varchar(8),vta.fecregistro,112)<=@fecfin
end

--8.5 Reporte de Productos (nombre,cantidad,nombre de unidad de medida) registrados entre dos fechas
 
execute reporteVentasPorFecha '20180101','20180128'
