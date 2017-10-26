
--no valido las opciones qu esten dadas de baja.


--SELECT * FROM Art where left(rama,2)='01'
--select * from Alm
--select * from ArtOpcion WHERE Articulo='34045'
--select * from ArtOpcionD WHERE Articulo='34045'


--select Articulo,Opcion,Numero,ThoDescontinuado,Opcion+CASt(Numero AS VARCHAR(50)) from ArtOpcionD where ThoDescontinuado=1  and Articulo='10220' order by Articulo
--select Codigo,Cuenta,SubCuenta from CB where Cuenta='10220' order by Cuenta,SubCuenta

--////////////////////////////SOLO SIRVE PARA COLORES//////////////////7
SELECT * FROM (
select ArtOpcionD.Articulo,Opcion+CASt(Numero AS VARCHAR(50))Subcuent ,len(Opcion+CASt(Numero AS VARCHAR(50)))Tamaño
,CB.Codigo,CB.Cuenta,CB.SubCuenta,CB.Unidad
from ArtOpcionD 
INNER JOIN CB on ArtOpcionD.Articulo=CB.Cuenta
where ArtOpcionD.ThoDescontinuado=1  --and ArtOpcionD.Articulo in ('31744','10220')
)T1 --WHERE Subcuent= LEFT (SubCuenta,Tamaño) 
WHERE Subcuenta like '%' + SubCuent+ '%'

--///////////para talla//////////


--////////7parar borrar
/*
delete FROM CB WHERE Codigo in (
SELECT distinct Codigo FROM (
select ArtOpcionD.Articulo,Opcion+CASt(Numero AS VARCHAR(50))Subcuent ,len(Opcion+CASt(Numero AS VARCHAR(50)))Tamaño
,CB.Codigo,CB.Cuenta,CB.SubCuenta,CB.Unidad
from ArtOpcionD 
INNER JOIN CB on ArtOpcionD.Articulo=CB.Cuenta
where ArtOpcionD.ThoDescontinuado=1  --
)T1   WHERE Subcuenta like '%' + SubCuent+ '%' )
--order by Articulo,Subcuent,SubCuenta, Codigo
*/
--//////////////////////777777
/* respaldo////////////////////
SELECT * INTO Tablas_Sistemas.DBO.CB01092017 FROM CB
*/
 --SELECT Articulo,Opcion,Numero,ThoDescontinuado,Opcion+CASt(Numero AS VARCHAR(50))Subcuent  from ArtOpcionD where ThoDescontinuado=1 AND  Articulo='31744' order by Articulo
 --select Codigo,Cuenta,SubCuenta,Unidad from CB where Cuenta='31744' order by Cuenta,SubCuenta,Codigo

 /*
--delete from Cb where Cuenta='10220' and Codigo='00765746'
*/
