alter procedure Consulta @Departamento varchar(50)
as
begin
--declare 
--set @Dato=1292
select Nombre,Puesto,Personal from personal where Departamento=@Departamento

END 

/*

Exec Consulta @Departamento='INFORMATICA'

*/