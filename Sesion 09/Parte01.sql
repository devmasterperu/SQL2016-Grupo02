--Funciones
--1 Funcion Escalar

create function dbo.fnFormula(@valor1 int,@valor2 int,@valor3 int) returns int
as
begin
	--Aplicar formula
	declare @resultado int
	set @resultado=@valor1+@valor2*@valor3
	return @resultado
end

select dbo.fnFormula(1,2,3)

--2 Funcion escalar sobre valores de tabla
create table tbValores
(
columna1 int,
columna2 int,
columna3 int
)

insert into tbValores
values (2,3,4),(3,4,5),(4,5,6)

select columna1,columna2,columna3,dbo.fnFormula(columna1,columna2,columna3) as Resultado
from tbValores

--3 Funcion escalar con valores de tabla 

create function dbo.fnFormula2(@valor1 int,@valor2 int,@valor3 int) returns int
as
begin
	--Aplicar formula
	declare @minCol1 int=(select min(columna1) from tbValores)

	declare @resultado int
	set @resultado=(@valor1+@valor2*@valor3)*@minCol1
	return @resultado
end

--Aplicacion de funcion
select columna1,columna2,columna3,dbo.fnFormula2(columna1,columna2,columna3) as Resultado
from tbValores



