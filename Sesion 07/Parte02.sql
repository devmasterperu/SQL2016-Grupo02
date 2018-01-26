--Parte 02
--1 Uso de FOR XML RAW
select pdto.id,pdto.nombre,pdto.cantidad,unidad.descripcion as unidad
from   tbProducto pdto 
join   tbUnidad unidad on pdto.idUnidad=unidad.id
FOR XML RAW('producto'),--definir nombre de elemento
ELEMENTS--mostrar resultado centrado en elementos
--2 Uso de FOR XML AUTO
select ventadet.idCompra as idVenta,
       pdto.id as idProducto,
       pdto.nombre,
	   pdto.cantidad,
	   unidad.descripcion as unidad
from   tbVentaDetalle ventadet
join     tbProducto pdto 
on       ventadet.idProducto=pdto.id
join     tbUnidad unidad
on       pdto.idUnidad=unidad.id
FOR XML AUTO,ROOT('ventasDetalles')--Especificamos elemento raiz.

select unidad.descripcion as unidad,
       ventadet.idCompra as idVenta,
       pdto.id as idProducto,
       pdto.nombre,
	   pdto.cantidad
from   tbVentaDetalle ventadet
join     tbProducto pdto 
on       ventadet.idProducto=pdto.id
join     tbUnidad unidad
on       pdto.idUnidad=unidad.id
order by unidad.descripcion--Especificamos ORDER BY para agrupamiento
FOR XML AUTO,ROOT('ventasDetalles')--Especificamos elemento raiz.
--3 Uso de FOR XML PATH
select ventadet.idCompra as "@idVenta",--Lo visualizo como atributo
       ventadet.fecRegistro as "fecRegistro",
       unidad.descripcion as unidad,
       pdto.id as "producto/@id",
       pdto.nombre as "producto/nombre",
       pdto.cantidad as "producto/cantidad"
from   tbVentaDetalle ventadet
join     tbProducto pdto 
on       ventadet.idProducto=pdto.id
join     tbUnidad unidad
on       pdto.idUnidad=unidad.id
FOR XML PATH('venta'),ROOT('ventas')

--4 USO DE OPENXML centrado a atributo
--Documento XML.  
DECLARE @idoc int, @xml varchar(4000);  
SET @xml= '<?xml version="1.0" encoding="UTF-8"?>
<productos>
    <producto nombre="Arroz" cantidad="100" precioUnidad="2">
        <unidad id="1" descripcion="kilogramo"></unidad>
    </producto>
    <producto nombre="Aceite" cantidad="50" precioUnidad="1.8">
        <unidad id="4" descripcion="litro"></unidad>
    </producto>
    <producto nombre="Pasta dental" cantidad="12" precioUnidad="2.5">
        <unidad id="3" descripcion="unidad"></unidad>
    </producto>
    <producto nombre="Desodorante" cantidad="30" precioUnidad="8">
        <unidad id="3" descripcion="unidad"></unidad>
    </producto>
</productos>';  

--Crear una representación interna del Documento XML.  
EXEC sp_xml_preparedocument @idoc OUTPUT, @xml; 

print @idoc
--EXEC sys.sp_xml_removedocument @idoc; 
--Lea desde Documento XML.  
/*
Esto es un comentario
*/
SELECT    *  
FROM       OPENXML (@idoc, '/productos/producto/unidad',1)--Obtención en base a atributos 
           WITH (nombre  varchar(300) '../@nombre',--Atributo nombre del padre de Unidad
                 cantidad decimal(10,2) '../@cantidad',--Atributo cantidad del padre de Unidad
                 idUnidad int '@id',--Atributo id de unidad.
                 precioUnidad decimal(10,2) '../@precioUnidad')--Atributo precioUnidad
				 --del padre de Unidad.

--5 USO DE OPENXML centrado a elementos
--Documento XML.  
DECLARE @idoc2 int, @doc varchar(1000);  
SET @doc= '<?xml version="1.0" encoding="UTF-8"?>
<productos>
<producto>
    <nombre>Arroz</nombre>
    <cantidad>100</cantidad>
    <unidad>
        <id>1</id>
        <descripcion>kilogramo</descripcion>
    </unidad>
    <precioUnidad>2</precioUnidad>
</producto>
<producto>
    <nombre>Aceite</nombre>
    <cantidad>50</cantidad>
   <unidad>
        <id>4</id>
        <descripcion>litro</descripcion>
    </unidad>
    <precioUnidad>1.8</precioUnidad>
</producto>
<producto>
    <nombre>Pasta dental</nombre>
    <cantidad>12</cantidad>
    <unidad>
        <id>3</id>
        <descripcion>unidad</descripcion>
    </unidad>
    <precioUnidad>2.5</precioUnidad>
</producto>
<producto>
    <nombre>Desodorante</nombre>
    <cantidad>30</cantidad>
    <unidad>
        <id>3</id>
        <descripcion>unidad</descripcion>
    </unidad>
    <precioUnidad>8</precioUnidad>
</producto>
</productos>';  

--Crear una representación interna del Documento XML.  
EXEC sp_xml_preparedocument @idoc2 OUTPUT, @doc; 
--EXEC sys.sp_xml_removedocument @idoc; 
--Lea desde Documento XML.  
SELECT    *  
FROM       OPENXML (@idoc2, '/productos/producto/unidad',2) --Leer XML centrado en elementos
           WITH (nombre  varchar(300) '../nombre',--Del padre de unidad obtener el elemento hijo "nombre"
                 cantidad decimal(10,2) '../cantidad',--Del padre de unidad obtener el elemento hijo "cantidad"
                 idUnidad int 'id',--Obtener el valor id de unidad
                 precioUnidad decimal(10,2) '../precioUnidad');--Del padre de unidad obtener el elemento hijo "precioUnidad"