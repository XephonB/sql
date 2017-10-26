/*
select * FROM (
SELECT 'N|'+Articulo+'|'+Subcuenta+'|1|'+Unidad+'|||8/31/2017 10.57.33' t1 FROM (
select distinct VentaD.Articulo,VentaD.Subcuenta,VentaD.Unidad FROM VentaD 
inner join Art on VentaD.Articulo=Art.Articulo where Art.Estatus='ALTA' AND Art.Proveedor<>'291' 
AND LEFT(Art.Rama,2)='02')T1)T2 where T1 IS NOT NULL  ORDER BY t1
*/
--////sacar los datos para carga a Toma Fisica//////////////////////////////////////////
 --59679
--select Articulo,Opcion+(CAST(Numero AS VARCHAR(20))) SubC from ArtOpcionD where (ThoDescontinuado  is null or  ThoDescontinuado<>1) AND Articulo='59679' 
select top 40000 'N|'+Tart.ArticuloC+'|'+Tart.Subcuenta+'|1|'+Art.Unidad+'|||8/31/2017 10.57.33' t1 from (
SELECT ArticuloC,(SubC+isnull(SubT,''))SubCuenta FROM (
select Articulo ArticuloC,Opcion+(CAST(Numero AS VARCHAR(20))) SubC from ArtOpcionD 
where (ThoDescontinuado  is null or  ThoDescontinuado<>1) --AND Articulo in ('10186','59679') 
and Opcion='C')Tcolor
left join
(
select Articulo ArticuloT,Opcion+(CAST(Numero AS VARCHAR(20))) SubT from ArtOpcionD 
where (ThoDescontinuado  is null or  ThoDescontinuado<>1) --AND Articulo in ('10186','59679') 
and Opcion='T')Ttalla
on ArticuloC=ArticuloT --order bY ArticuloC,SubCuenta
)Tart inner join Art on Tart.ArticuloC=Art.Articulo
inner join ArtSubCosto on Tart.ArticuloC=ArtSubCosto.Articulo and Tart.Subcuenta=ArtSubCosto.Subcuenta --borra luego lo de costo opcion
where art.Estatus='ALTA' AND LEFT(ART.Rama,2)='03' AND ( Art.Proveedor is null or Art.Proveedor<>'291') AND Art.Unidad<>'SERVICIO'  and Tart.ArticuloC<>'10048'
and ArtSubCosto.Sucursal='4'--fletes
ORDER BY ArticuloC,Tart.SubCuenta,Art.Unidad

--select Articulo , count(*)Flag from ArtOpcion
--group by Articulo
--having count(*)=1

--select * from ArtOpcionD where articulo='59679'


--select * from Art where DESCRIPCION1 LIKE '%FLETE%'


