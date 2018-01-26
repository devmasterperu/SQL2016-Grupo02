
--1 Obtener en formato JSON los tipos de documento SUNAT
select id,tipoSunat,descLarga,descCorta 
from   tbTipoDocumento
FOR JSON AUTO,INCLUDE_NULL_VALUES

--2 Obtener en formato JSON, con JSON AUTO y con raíz Vendedores 
select 
vend.id ,
vend.codVendedor,
pers.nombres,
pers.apellidoPaterno,
pers.apellidoMaterno,
tipo.descCorta,
tipo.descLarga
from tbVendedor vend 
inner join tbPersona pers on vend.idPersona=pers.id
inner join tbTipoDocumento tipo on pers.idTipoDoc=tipo.id
FOR JSON AUTO,root('vendedores');

--3 Obtener en formato JSON, con JSON Path y sin corchetes datos del vendedor
select vend.id as [vendedor.Id],
--vend.codVendedor as [vendedor.CodVendedor],
'SIN VALOR' as [vendedor.persona.valores.CodVendedor],
--pers.nombres as [vendedor.persona.Nombres],
--pers.apellidoPaterno as [vendedor.persona.ApellidoPat],
--pers.apellidoMaterno as [vendedor.persona.ApellidoMat]
pers.nombres as [vendedor.Nombres],
pers.apellidoPaterno as [vendedor.ApellidoPat],
pers.apellidoMaterno as [vendedor.ApellidoMat]
from tbVendedor vend inner join 
tbPersona pers on vend.idPersona=pers.id
FOR JSON PATH,WITHOUT_ARRAY_WRAPPER

--4 Obtener en formato JSON, con JSON Path y con raíz Vendedores 
select vend.id as [vendedor.Id],vend.codVendedor as [vendedor.CodVendedor],
pers.nombres as [vendedor.persona.Nombres],
pers.apellidoPaterno as [vendedor.persona.ApellidoPat],
pers.apellidoMaterno as [vendedor.persona.ApellidoMat]
from tbVendedor vend inner join 
tbPersona pers on vend.idPersona=pers.id
FOR JSON PATH,root('vendedores'),WITHOUT_ARRAY_WRAPPER

--5 Convertir JSON a formato tabular
DECLARE @json NVARCHAR(4000) = N'
{
    "StringValue": "Gian",
    "IntValue": 45,
    "TrueValue": true,
    "FalseValue": false,
    "NullValue": null,
    "ArrayValue": ["a","b"],
    "ObjectValue": {
        "edad": "27"
    }
}'

select * from OPENJSON(@json)

--6 Uso de OPENJSON
declare @myjson varchar(8000)=N'{
    "empresa":"Dev Master Perú SAC",
    "ruc":"1111111111",
    "numTrabajadores":5,
    "cursos":[
        {
            "curso":"Base de Datos con SQL Server 2016",
            "docente":{
                "nombres":"Gianfranco",
                "apellidos":"Manrique",
                "direccion":"Urb.Los Cipreses M-24",
                "ubigeo":{
                    "departamento":"Lima",
                    "provincia":"Huaura",
                    "distrito":"Santa María",
                    "nombre":"Lima\/Huaura\/Santa María"
                }
            }
        },
        {
            "curso":"Modelamiento de Datos",
            "docente":{
                "nombres":"Gianfranco",
                "apellidos":"Manrique",
                "direccion":"Urb.Los Cipreses M-24",
                "ubigeo":{
                    "departamento":"Lima",
                    "provincia":"Huaura",
                    "distrito":"Santa María",
                    "nombre":"Lima\/Huaura\/Santa María"
                }
            }
        }
    ]
}'

select * from OPENJSON(@myjson)

--7 Uso de OPENJSON+path
declare @myjson varchar(8000)=N'{
    "empresa":"Dev Master Perú SAC",
    "ruc":"1111111111",
    "numTrabajadores":5,
    "cursos":[
        {
            "curso":"Base de Datos con SQL Server 2016",
            "docente":{
                "nombres":"Gianfranco",
                "apellidos":"Manrique",
                "direccion":"Urb.Los Cipreses M-24",
                "ubigeo":{
                    "departamento":"Lima",
                    "provincia":"Huaura",
                    "distrito":"Santa María",
                    "nombre":"Lima\/Huaura\/Santa María"
                }
            }
        },
        {
            "curso":"Modelamiento de Datos",
            "docente":{
                "nombres":"Gianfranco",
                "apellidos":"Manrique",
                "direccion":"Urb.Los Cipreses M-24",
                "ubigeo":{
                    "departamento":"Lima",
                    "provincia":"Huaura",
                    "distrito":"Santa María",
                    "nombre":"Lima\/Huaura\/Santa María"
                }
            }
        }
    ]
}'

--select * from OPENJSON(@myjson,'lax $.cursos[1].docente.ubigeo2')
select * from OPENJSON(@myjson,'strict $.cursos[1].docente.ubigeo2')

--8 Uso de JSON_VALUE 1
declare @myjson varchar(8000)=N'{
    "empresa":"Dev Master Perú SAC",
    "ruc":"1111111111",
    "numTrabajadores":5,
    "cursos":[
        {
            "curso":"Base de Datos con SQL Server 2016",
            "docente":{
                "nombres":"Gianfranco",
                "apellidos":"Manrique",
                "direccion":"Urb.Los Cipreses M-24",
                "ubigeo":{
                    "departamento":"Lima",
                    "provincia":"Huaura",
                    "distrito":"Santa María",
                    "nombre":"Lima\/Huaura\/Santa María"
                }
            }
        },
        {
            "curso":"Modelamiento de Datos",
            "docente":{
                "nombres":"Gianfranco",
                "apellidos":"Manrique",
                "direccion":"Urb.Los Cipreses M-24",
                "ubigeo":{
                    "departamento":"Lima",
                    "provincia":"Huaura",
                    "distrito":"Santa María",
                    "nombre":"Lima\/Huaura\/Santa María"
                }
            }
        }
    ]
}'

--select JSON_VALUE(@myjson,'$.cursos[1].docente.ubigeo') as ubigeo
select JSON_VALUE(@myjson,'$.cursos[1].docente.ubigeo.departamento') as ubigeo

--9 Uso de JSON_VALUE 2
DECLARE @jsonInfo NVARCHAR(MAX)

SET @jsonInfo=N'{  
     "informacion":{    
     "nombres":"Gianfranco",
     "apellidos":"Manrique Valentín",
     "direccion":"Urb. Los Cipreses M-24",
       "ubigeo":{    
         "departamento":"Lima",  
         "provincia":"Huaura",  
         "distrito":"Huacho"  
       },  
     "cursos":["Base de Datos", "Modelamiento de Datos"]  
    }
 }'  

select  JSON_VALUE(@jsonInfo,'$.informacion.nombres') as nombres,
        JSON_VALUE(@jsonInfo,'$.informacion.apellidos') as apellidos,
        JSON_VALUE(@jsonInfo,'$.informacion.direccion') as direccion,
        JSON_VALUE(@jsonInfo,'$.informacion.ubigeo.departamento') as departamento,
		JSON_VALUE(@jsonInfo,'$.informacion.cursos') as cursos

--10 Uso de JSON_QUERY

DECLARE @jsonInfo NVARCHAR(MAX)

SET @jsonInfo=N'{  
     "informacion":{    
     "nombres":"Gianfranco",
     "apellidos":"Manrique Valentín",
     "direccion":"Urb. Los Cipreses M-24",
       "ubigeo":{    
         "departamento":"Lima",  
         "provincia":"Huaura",  
         "distrito":"Huacho"  
       },  
     "cursos":["Base de Datos", "Modelamiento de Datos"]  
    }
 }'  

 select JSON_QUERY(@jsonInfo,'$.informacion') as informacion,
        JSON_QUERY(@jsonInfo,'$.informacion.ubigeo') as ubigeo,
        JSON_QUERY(@jsonInfo,'$.informacion.cursos') as cursos,
		JSON_QUERY(@jsonInfo,'$.informacion.nombres') as nombres

--11 Consumir JSON, transformar a tabla y crear procedimiento almacenado
declare @myjson varchar(8000)=N'
 [
        {
            "empresa": 
            {
                "nombre":"Dev Master Perú SAC",
                "ruc": "1111111111",
                "numTrabajadores": 5
            },
            "sedeprincipal":{
                "departamento":"Lima",
                "provincia":"Huaura",
                "distrito":"Santa María"
            },
            "cursos": [
                {
                    "curso": "Base de Datos con SQL Server 2016",
                    "docente": {
                        "nombres": "Gianfranco",
                        "apellidos": "Manrique",
                        "direccion": "Urb.Los Cipreses M-24",
                        "ubigeo": {
                            "departamento": "Lima",
                            "provincia": "Huaura",
                            "distrito": "Santa María",
                            "nombre": "Lima\/Huaura\/Santa María"
                        }
                    }
                },
                {
                    "curso": "Modelamiento de Datos",
                    "docente": {
                        "nombres": "Gianfranco",
                        "apellidos": "Manrique",
                        "direccion": "Urb.Los Cipreses M-24",
                        "ubigeo": {
                            "departamento": "Lima",
                            "provincia": "Huaura",
                            "distrito": "Santa María",
                            "nombre": "Lima\/Huaura\/Santa María"
                        }
                    }
                }
            ]
        },
        {
            "empresa": {
                "nombre":"Cibertec",
                "ruc": "1111111112",
                "numTrabajadores": 1000
            },
            "sedeprincipal":{
                "departamento":"Lima",
                "provincia":"Lima",
                "distrito":"Miraflores"
            },
            "cursos": [
                {
                    "curso": "Base de Datos con SQL Server 2016",
                    "docente": {
                        "nombres": "Juan",
                        "apellidos": "Lopez",
                        "direccion": "NE",
                        "ubigeo": {
                            "departamento": "-",
                            "provincia": "-",
                            "distrito": "-",
                            "nombre": "-\/-\/-"
                        }
                    }
                },
                {
                    "curso": "Modelamiento de Datos",
                    "docente": {
                        "nombres": "Maria",
                        "apellidos": "Gonzales",
                        "direccion": "Urb. Los Jardines",
                        "ubigeo": {
                            "departamento": "Lima",
                            "provincia": "Lima",
                            "distrito": "San Martín de Porres",
                            "nombre": "Lima\/Lima\/SMP"
                        }
                    }
                }
            ]
        }
    ]
'
--Transferirlo a tabla luego de formatearlo con campos
select * 
into tb_empresas
from OPENJSON(@myjson) WITH
(
ruc    varchar(20) '$.empresa.ruc',
nombre varchar(30) '$.empresa.nombre',
sedePrinDpto varchar(30) '$.sedeprincipal.departamento',
sedePrinProv varchar(30) '$.sedeprincipal.provincia',
sedePrinDto  varchar(30) '$.sedeprincipal.distrito'
)
--Crear procedure en base a la tabla alimentada con JSON
create procedure sp_FiltrarEmpresa(@dpto varchar(30),@prov varchar(30),@dto varchar(30))
as
begin
select * from tb_empresas
where sedePrinDpto=@dpto and sedePrinProv=@prov and sedePrinDto=@dto
end
--Ejecutar procedure y obtener información cargada a través de JSON
sp_FiltrarEmpresa 'Lima','Lima','Miraflores'