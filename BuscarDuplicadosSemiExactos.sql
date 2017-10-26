
create table #Prueba 
(Tipo char,Articulo varchar(20),Subcuenta varchar(50),Cantidad float,Unidad varchar(50),SerieLote varchar(50),CantS float,Tiempo varchar(100)
)

create table #FinalD
(id int,Tipo char,Articulo varchar(20),Subcuenta varchar(50),Cantidad float,Unidad varchar(50),SerieLote varchar(50),CantS float,Tiempo varchar(100)
)

BULK INSERT #Prueba
FROM 'C:\Comparar\TelasNormalpaño.txt' WITH
( FIELDTERMINATOR = '|', --separa campos
  ROWTERMINATOR = '\n',
  CODEPAGE='ACP' ) --separa filas
;
GO
INSERT #FinalD 
SELECT row_number() over(order by tipo)'id', Tipo,Articulo,isnull(SubCuenta,''),Cantidad,Unidad,isnull(SerieLote,''),isnull(CantS,0),Tiempo FROM (select * from #Prueba)TTEMP
--////////////////////////////////////////////Articulos duplicados //////////////////////////////////////////////////////
SELECT Tipo,Articulo,Subcuenta,Cantidad,Unidad FROM(
sELECT COUNT(*)Repetido,Tipo,Articulo,SubCuenta,Cantidad,Unidad,SerieLote,CantS FROM(
SELECT row_number() over(order by tipo)'id', Tipo,Articulo,SubCuenta,Cantidad,Unidad,SerieLote,CantS,Tiempo FROM (select * from #FinalD)TTEMP
)A1 GROUP BY Tipo,Articulo,SubCuenta,Cantidad,Unidad,SerieLote,CantS
)B2 WHERE Repetido>1


select * from #FinalD

--/////////////////////////////BUSCAR EN QUE PARTE DEL TXT SE ENCUENTRA ////////////////////////////////////////
/*
select * from #FinalD WHERE 
(Articulo='31053' and Subcuenta='C20358' and cantidad=50 and unidad='METRO') or
(Articulo='31060' and Subcuenta='C22583' and cantidad=25 and unidad='METRO') or
(Articulo='31061' and Subcuenta='C17681' and cantidad=25 and unidad='METRO') or
(Articulo='32045' and Subcuenta='C11346' and cantidad=15.29 and unidad='METRO')


select * from #FinalD WHERE 
(Articulo='32045' and Subcuenta='C11968' and cantidad=51.12 and unidad='METRO') or
(Articulo='32051' and Subcuenta='C16397' and cantidad=13 and unidad='PIEZA') or
(Articulo='32052' and Subcuenta='C16397' and cantidad=1 and unidad='PIEZA') or
(Articulo='32052' and Subcuenta='C16397' and cantidad=8 and unidad='PIEZA')
*/

--select count(*)veces, Tipo,Articulo,Subcuenta,sum(Cantidad)CAnt,Unidad,SerieLote,sum(CantS)Canti from #FinalD  group by Tipo,Articulo,Subcuenta,Unidad,SerieLote having count(*)>1
--select count(*)veces, Tipo,Articulo,Subcuenta,sum(Cantidad)CAnt,Unidad,SerieLote,sum(CantS)Canti from #FinalD  group by Tipo,Articulo,Subcuenta,Unidad,SerieLote having count(*)=1
--select * from #FinalD
---///////////////////////////////////////////////////////////////FIN ////////////////////////////////////////

--BORRAR TODO
/*
drop table #Prueba
drop table #FinalD
*/

