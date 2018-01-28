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
select * from tbVenta