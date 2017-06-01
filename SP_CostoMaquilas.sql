
SELECT
CF.Articulo,CF.Descripcion,CF.Material,CF.DescMaterial,CF.Cantidad,CF.Unidad, 
------------------------INICIO CODIGO
ISNULL((SELECT (ListaPreciosDUnidad.Precio/AU.Factor)*ArtUnidad.Factor*(1-(ISNULL(Art.DescuentoCompra,0))/100)*CF.Cantidad
FROM ArtUnidad
LEFT JOIN Art ON CF.Material=Art.Articulo
LEFT JOIN ListaPreciosDUnidad ON CF.Material=ListaPreciosDUnidad.Articulo AND ListaPreciosDUnidad.Lista='Precios de Compra' AND ListaPreciosDUnidad.Precio<>0 --para tener el costo que es unico 
LEFT JOIN ArtUnidad AU ON AU.Articulo=CF.Material AND ListaPreciosDUnidad.Unidad=AU.Unidad --factor de la unidad de compra 
WHERE CF.Material=ArtUnidad.Articulo AND CF.Unidad=ArtUnidad.Unidad),0)'Costo'
------------------------//FIN CODIGO
FROM
(SELECT A.Articulo, (SELECT Descripcion1 FROM Art WHERE Articulo = A.Articulo)'Descripcion', A.Material, (SELECT Descripcion1 FROM Art WHERE Articulo = A.Material)'DescMaterial',  MAX(A.Cantidad)'Cantidad', A.Unidad
FROM ArtMaterial AS A WHERE A.Articulo IN
('10050','10173','10174','10175','10176','10177','10178','45267','45268','45269','45399','45400','45401','45402','45403',
'45404','45427','45428','45477','45478','49871','52731','52732','52733','10046','10062','10084','10170','10184','10185',
'45181','45270','45288','45407','45408','45410','45411','45430','45432','52730') 
GROUP BY A.Articulo, A.Material, A.Unidad)CF
UNION ALL
SELECT DISTINCT C.Articulo, (SELECT Descripcion1 FROM Art WHERE Articulo = C.Articulo)'Descripcion', C.Centro, ISNULL((SELECT Descripcion FROM Centro WHERE Centro = C.Centro),'')'DescCentro', '1' 'Cantidad', 'M' 'Unidad', C.Costo 
FROM CentroTarifa AS C WHERE C.Articulo IN
('10050','10173','10174','10175','10176','10177','10178','45267','45268','45269','45399','45400','45401','45402','45403',
'45404','45427','45428','45477','45478','49871','52731','52732','52733','10046','10062','10084','10170','10184','10185',
'45181','45270','45288','45407','45408','45410','45411','45430','45432','52730') 
ORDER BY  CF.Articulo, CF.Material


/*
SELECT CF.Articulo,CF.Descripcion,CF.Material,CF.DescMaterial,CF.Cantidad,CF.Unidad, 
------------------------
ISNULL((SELECT (ListaPreciosDUnidad.Precio/AU.Factor)*ArtUnidad.Factor*(1-(ISNULL(Art.DescuentoCompra,0))/100)*CF.Cantidad
FROM ArtUnidad
LEFT JOIN Art ON CF.Material=Art.Articulo
LEFT JOIN ListaPreciosDUnidad ON CF.Material=ListaPreciosDUnidad.Articulo AND ListaPreciosDUnidad.Lista='Precios de Compra' AND ListaPreciosDUnidad.Precio<>0 --para tener el costo que es unico 
LEFT JOIN ArtUnidad AU ON AU.Articulo=CF.Material AND ListaPreciosDUnidad.Unidad=AU.Unidad --factor de la unidad de compra 
WHERE CF.Material=ArtUnidad.Articulo AND CF.Unidad=ArtUnidad.Unidad),0)'Costo'
------------------------
 FROM 
(SELECT A.Articulo, (SELECT Descripcion1 FROM Art WHERE Articulo = A.Articulo)'Descripcion', A.Material, (SELECT Descripcion1 FROM Art WHERE Articulo = A.Material)'DescMaterial',  MAX(A.Cantidad)'Cantidad', A.Unidad 
FROM ArtMaterial AS A WHERE A.Articulo IN
('10050','10173','10174','10175','10176','10177','10178','45267','45268','45269','45399','45400','45401','45402','45403',
'45404','45427','45428','45477','45478','49871','52731','52732','52733','10046','10062','10084','10170','10184','10185',
'45181','45270','45288','45407','45408','45410','45411','45430','45432','52730') 
GROUP BY A.Articulo, A.Material, A.Unidad)CF
ORDER BY CF.Articulo,CF.Material,CF.Unidad
*/


/*TRY ME
declare @articulo varchar(20) 
set @articulo='34438'
--27336

sELECT Articulo,Precio,Unidad,Lista FROM ListaPreciosDUnidad where Articulo=@articulo AND Lista='Precios de Compra'
select Articulo,DescuentoCompra,Unidad from Art WHERE Articulo=@articulo
SELECT Articulo,Factor ,unidad FROM ArtUnidad where Articulo=@articulo


--select aRTICULO,count(*) FROM ListaPreciosDUnidad where lista='Precios de Compra' and precio<>0
--group by Articulo
--having count(*)>1
--order by Articulo


*/