
ALTER PROCEDURE SP_ListaPrecioMayoreoArea  @Ram varchar(2)
AS BEGIN
----/*
--DECLARE @Ram varchar(2)
--SET @Ram='01'
----*/

CREATE TABLE #ListaP(
TArt varchar(20),TTT varchar(3),TDes varchar(100),TRam varchar(20),TCF varchar(50),
TUni varchar(50),TFact float,TSubC varchar(50),TMM money,
TPMay money,TPMayE money--,TProv varchar(10),TPovN varchar(100)
);						
INSERT INTO #ListaP
SELECT DISTINCT L.Articulo,'Cate'=CASE WHEN RIGHT(A.Categoria,2) IS NULL THEN '' ELSE RIGHT(A.Categoria,2) END
				,A.Descripcion1,A.Rama,'CF'=CASE WHEN A.ClaveFabricante IS NULL THEN '' ELSE A.ClaveFabricante END
				,L.Unidad,CASE WHEN AU.Factor IS NULL THEN 0 ELSE AU.Factor END,''
				,'MM'=CASE WHEN A.MargenMinimo IS NULL THEN 0 ELSE A.MargenMinimo END
				,'MA'=CASE WHEN Ma.Precio IS NULL THEN 0 ELSE ROUND((Ma.Precio*1.16),2) END 
				,'MAE'=CASE WHEN MaE.Precio IS NULL THEN 0 ELSE ROUND((MaE.Precio*1.16),2) END
				--,'Pro'= CASE WHEN A.Proveedor IS NULL THEN '' ELSE A.Proveedor END,'ProN'=CASE WHEN P.Nombre IS NULL THEN '' ELSE P.Nombre END
				FROM ListaPreciosDUnidad AS L
				INNER JOIN Art AS A ON L.Articulo=A.Articulo
				--LEFT JOIN Prov AS P ON A.Proveedor=P.Proveedor
				LEFT JOIN ArtUnidad AS AU ON L.Articulo=AU.Articulo AND L.Unidad=AU.Unidad				
				LEFT JOIN ListaPreciosDUnidad AS PC ON L.Articulo=PC.Articulo AND L.Unidad=PC.Unidad AND PC.Lista='Precios de Compra'
				LEFT JOIN ListaPreciosDUnidad AS Ma ON L.Articulo=Ma.Articulo AND L.Unidad=Ma.Unidad AND Ma.Lista='Mayoreo'
				LEFT JOIN ListaPreciosDUnidad AS MaE ON L.Articulo=MaE.Articulo AND L.Unidad=MaE.Unidad AND MaE.Lista='Mayoreo Especial'				
				WHERE LEFT(A.Rama,2)=@Ram AND A.Estatus ='ALTA' AND L.Unidad=A.UnidadCompra
			UNION ALL
				SELECT DISTINCT S.Articulo,'Cate'=CASE WHEN RIGHT(A.Categoria,2) IS NULL THEN '' ELSE RIGHT(A.Categoria,2) END
				,'',A.Rama,''
				,S.Unidad,CASE WHEN AU.Factor IS NULL THEN 0 ELSE AU.Factor END,S.SubCuenta
				,'MM'=CASE WHEN A.MargenMinimo IS NULL THEN 0 ELSE A.MargenMinimo END 
				,'MA'=CASE WHEN Ma.Precio IS NULL THEN 0 ELSE ROUND((Ma.Precio*1.16),2) END 
				,'MAE'=CASE WHEN MaE.Precio IS NULL THEN 0 ELSE ROUND((MaE.Precio*1.16),2) END
				--,'Pro'= CASE WHEN A.Proveedor IS NULL THEN '' ELSE A.Proveedor END,'ProN'=CASE WHEN P.Nombre IS NULL THEN '' ELSE P.Nombre END
				FROM ListaPreciosSubUnidad AS S
				INNER JOIN Art AS A ON S.Articulo=A.Articulo
				LEFT JOIN Prov AS P ON A.Proveedor=P.Proveedor
				LEFT JOIN ArtUnidad AS AU ON S.Articulo=AU.Articulo AND S.Unidad=AU.Unidad				
				LEFT JOIN ListaPreciosSubUnidad AS PC ON S.Articulo=PC.Articulo AND S.Unidad=PC.Unidad AND S.SubCuenta=PC.SubCuenta AND PC.Lista='Precios de Compra'
				LEFT JOIN ListaPreciosSubUnidad AS Ma ON S.Articulo=Ma.Articulo AND S.Unidad=Ma.Unidad AND S.SubCuenta=Ma.SubCuenta AND Ma.Lista='Mayoreo'
				LEFT JOIN ListaPreciosSubUnidad AS MaE ON S.Articulo=MaE.Articulo AND S.Unidad=MaE.Unidad AND S.SubCuenta=MaE.SubCuenta AND MaE.Lista='Mayoreo Especial'				
				WHERE LEFT(A.Rama,2)=@Ram AND A.Estatus ='ALTA' AND S.Unidad=A.UnidadCompra;

SELECT * FROM #ListaP Order by TArt-- TProv,TRam,TTT,TArt,TDes DESC;
DROP TABLE #ListaP;

END

/*

EXEC SP_ListaPrecioMayoreoArea @Ram='01'

*/
