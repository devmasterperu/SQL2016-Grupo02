--Semana 02
--Creación de tabla tbCategoria
create table dbo.tbCategoria
(
idcategoria int identity(1,1) primary key,--SQL Server genera este valor automaticamente
nombrecategoria varchar(50) not null--Este valor si debe ser insertado
)
--Carga de tabla tbCategoria
insert into dbo.tbCategoria
select 'ACCION' union all--Juntar los resultados de +1 select
select 'CIENCIA FICCION Y FANTASIA' union all
select 'CLASICAS' union all
select 'COMEDIAS' union all
select 'TERROR' union all
select 'ROMANCE' union all
select 'DRAMA' union all
select 'POLICIAL' union all
select 'THRILLER' union all
select 'OTROS' --union all
--Creación de tabla CategoriaPelicula
create table tbCategoriaPelicula
(
idcategoria int references tbCategoria(idcategoria),
idpelicula int references tbPelicula(idpelicula),
primary key(idcategoria,idpelicula)--idcategoria+idpelicula son irrepetibles
)
--Agregar una columna del tipo fecha y hora con valor por defecto fecha y hora de la base datos
alter table tbCategoriaPelicula add fecregistro datetime default getdate()
alter table tbCategoriaPelicula add comentario varchar(100) default ''
--Carga de la tabla tbCategoriaPelicula
insert into tbCategoriaPelicula(idcategoria,idpelicula)
select 4,1 union all
select 4,2 union all
select 4,4 