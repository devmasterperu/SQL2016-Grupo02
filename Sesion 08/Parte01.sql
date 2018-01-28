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

