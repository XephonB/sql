USE [Assis]
GO
/****** Object:  StoredProcedure [dbo].[SP_LPreciosUnidadCompra]    Script Date: 26/05/2017 11:05:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_LPreciosUnidadCompra] @Proov varchar(10), @Ram varchar(20)
AS BEGIN
----/*
--DECLARE @Proov varchar(10), @Ram varchar(20)
--SET @Proov='291'
--SET @Ram=''
----*/

CREATE TABLE #ListaP(
TArt varchar(20),TTT varchar(3),TDes varchar(100),TRam varchar(20),TCF varchar(50),
TUni varchar(50),TFact float,TSubC varchar(50),TMM money,TPMenu money,
TPMay money,TPMayE money,TProv varchar(10),TPovN varchar(100)
);
IF @Proov NOT IN ('','NULL','TODAS') AND @Ram IN (NULL,'','NULL','TODAS') 
INSERT INTO #ListaP
SELECT DISTINCT L.Articulo,'Cate'=CASE WHEN RIGHT(A.Categoria,2) IS NULL THEN '' ELSE RIGHT(A.Categoria,2) END
				,A.Descripcion1,A.Rama,'CF'=CASE WHEN A.ClaveFabricante IS NULL THEN '' ELSE A.ClaveFabricante END
				,L.Unidad,CASE WHEN AU.Factor IS NULL THEN 0 ELSE AU.Factor END,''
				--,ISNULL(A.DescuentoCompra,0)
				--,ISNULL(PC.Precio,0)
				--,'PC'=CASE WHEN A.DescuentoCompra IS NULL THEN ISNULL(PC.Precio,0) ELSE ISNULL(PC.Precio*(1-(A.DescuentoCompra/100)),0)END
				,'MM'=CASE WHEN A.MargenMinimo IS NULL THEN 0 ELSE A.MargenMinimo END 
				,'ME'=CASE WHEN Me.Precio IS NULL THEN 0 ELSE ROUND((Me.Precio*1.16),2) END,'MA'=CASE WHEN Ma.Precio IS NULL THEN 0 ELSE ROUND((Ma.Precio*1.16),2) END 
				,'MAE'=CASE WHEN MaE.Precio IS NULL THEN 0 ELSE ROUND((MaE.Precio*1.16),2) END
				,'Pro'= CASE WHEN A.Proveedor IS NULL THEN '' ELSE A.Proveedor END,'ProN'=CASE WHEN P.Nombre IS NULL THEN '' ELSE P.Nombre END
				FROM ListaPreciosDUnidad AS L
				INNER JOIN Art AS A ON L.Articulo=A.Articulo
				LEFT JOIN Prov AS P ON A.Proveedor=P.Proveedor
				LEFT JOIN ArtUnidad AS AU ON L.Articulo=AU.Articulo AND L.Unidad=AU.Unidad				
				LEFT JOIN ListaPreciosDUnidad AS PC ON L.Articulo=PC.Articulo AND L.Unidad=PC.Unidad AND PC.Lista='Precios de Compra'
				LEFT JOIN ListaPreciosDUnidad AS Me ON L.Articulo=Me.Articulo AND L.Unidad=Me.Unidad AND Me.Lista='Menudeo'
				LEFT JOIN ListaPreciosDUnidad AS Ma ON L.Articulo=Ma.Articulo AND L.Unidad=Ma.Unidad AND Ma.Lista='Mayoreo'
				LEFT JOIN ListaPreciosDUnidad AS MaE ON L.Articulo=MaE.Articulo AND L.Unidad=MaE.Unidad AND MaE.Lista='Mayoreo Especial'				
				WHERE A.Proveedor=@Proov AND A.Estatus ='ALTA' AND L.Unidad=A.UnidadCompra
			UNION ALL
				SELECT DISTINCT S.Articulo,'Cate'=CASE WHEN RIGHT(A.Categoria,2) IS NULL THEN '' ELSE RIGHT(A.Categoria,2) END
				,'',A.Rama,''
				,S.Unidad,CASE WHEN AU.Factor IS NULL THEN 0 ELSE AU.Factor END,S.SubCuenta
				--,ISNULL(A.DescuentoCompra,0)
				--,ISNULL(PC.Precio,0)
				--,'PC'=CASE WHEN A.DescuentoCompra IS NULL THEN ISNULL(PC.Precio,0) ELSE ISNULL(PC.Precio*(1-(A.DescuentoCompra/100)),0)END
				,'MM'=CASE WHEN A.MargenMinimo IS NULL THEN 0 ELSE A.MargenMinimo END 
				,'ME'=CASE WHEN Me.Precio IS NULL THEN 0 ELSE ROUND((Me.Precio*1.16),2) END,'MA'=CASE WHEN Ma.Precio IS NULL THEN 0 ELSE ROUND((Ma.Precio*1.16),2) END 
				,'MAE'=CASE WHEN MaE.Precio IS NULL THEN 0 ELSE ROUND((MaE.Precio*1.16),2) END
				,'Pro'= CASE WHEN A.Proveedor IS NULL THEN '' ELSE A.Proveedor END,'ProN'=CASE WHEN P.Nombre IS NULL THEN '' ELSE P.Nombre END
				FROM ListaPreciosSubUnidad AS S
				INNER JOIN Art AS A ON S.Articulo=A.Articulo
				LEFT JOIN Prov AS P ON A.Proveedor=P.Proveedor
				LEFT JOIN ArtUnidad AS AU ON S.Articulo=AU.Articulo AND S.Unidad=AU.Unidad				
				LEFT JOIN ListaPreciosSubUnidad AS PC ON S.Articulo=PC.Articulo AND S.Unidad=PC.Unidad AND S.SubCuenta=PC.SubCuenta AND PC.Lista='Precios de Compra'
				LEFT JOIN ListaPreciosSubUnidad AS Me ON S.Articulo=Me.Articulo AND S.Unidad=Me.Unidad AND S.SubCuenta=Me.SubCuenta AND Me.Lista='Menudeo'
				LEFT JOIN ListaPreciosSubUnidad AS Ma ON S.Articulo=Ma.Articulo AND S.Unidad=Ma.Unidad AND S.SubCuenta=Ma.SubCuenta AND Ma.Lista='Mayoreo'
				LEFT JOIN ListaPreciosSubUnidad AS MaE ON S.Articulo=MaE.Articulo AND S.Unidad=MaE.Unidad AND S.SubCuenta=MaE.SubCuenta AND MaE.Lista='Mayoreo Especial'				
				WHERE A.Proveedor=@Proov AND A.Estatus ='ALTA' AND S.Unidad=A.UnidadCompra;
								
ELSE IF @Proov IN (NULL,'','NULL','TODAS') AND @Ram NOT IN ('','NULL','TODAS')	
INSERT INTO #ListaP
SELECT DISTINCT L.Articulo,'Cate'=CASE WHEN RIGHT(A.Categoria,2) IS NULL THEN '' ELSE RIGHT(A.Categoria,2) END
				,A.Descripcion1,A.Rama,'CF'=CASE WHEN A.ClaveFabricante IS NULL THEN '' ELSE A.ClaveFabricante END
				,L.Unidad,CASE WHEN AU.Factor IS NULL THEN 0 ELSE AU.Factor END,''
				--,ISNULL(A.DescuentoCompra,0)
				--,ISNULL(PC.Precio,0)
				--,'PC'=CASE WHEN A.DescuentoCompra IS NULL THEN ISNULL(PC.Precio,0) ELSE ISNULL(PC.Precio*(1-(A.DescuentoCompra/100)),0)END
				,'MM'=CASE WHEN A.MargenMinimo IS NULL THEN 0 ELSE A.MargenMinimo END 
				,'ME'=CASE WHEN Me.Precio IS NULL THEN 0 ELSE ROUND((Me.Precio*1.16),2) END,'MA'=CASE WHEN Ma.Precio IS NULL THEN 0 ELSE ROUND((Ma.Precio*1.16),2) END 
				,'MAE'=CASE WHEN MaE.Precio IS NULL THEN 0 ELSE ROUND((MaE.Precio*1.16),2) END
				,'Pro'= CASE WHEN A.Proveedor IS NULL THEN '' ELSE A.Proveedor END,'ProN'=CASE WHEN P.Nombre IS NULL THEN '' ELSE P.Nombre END
				FROM ListaPreciosDUnidad AS L
				INNER JOIN Art AS A ON L.Articulo=A.Articulo
				LEFT JOIN Prov AS P ON A.Proveedor=P.Proveedor
				LEFT JOIN ArtUnidad AS AU ON L.Articulo=AU.Articulo AND L.Unidad=AU.Unidad				
				LEFT JOIN ListaPreciosDUnidad AS PC ON L.Articulo=PC.Articulo AND L.Unidad=PC.Unidad AND PC.Lista='Precios de Compra'
				LEFT JOIN ListaPreciosDUnidad AS Me ON L.Articulo=Me.Articulo AND L.Unidad=Me.Unidad AND Me.Lista='Menudeo'
				LEFT JOIN ListaPreciosDUnidad AS Ma ON L.Articulo=Ma.Articulo AND L.Unidad=Ma.Unidad AND Ma.Lista='Mayoreo'
				LEFT JOIN ListaPreciosDUnidad AS MaE ON L.Articulo=MaE.Articulo AND L.Unidad=MaE.Unidad AND MaE.Lista='Mayoreo Especial'				
				WHERE A.Rama=@Ram AND A.Estatus ='ALTA' AND L.Unidad=A.UnidadCompra
			UNION ALL
				SELECT DISTINCT S.Articulo,'Cate'=CASE WHEN RIGHT(A.Categoria,2) IS NULL THEN '' ELSE RIGHT(A.Categoria,2) END
				,'',A.Rama,''
				,S.Unidad,CASE WHEN AU.Factor IS NULL THEN 0 ELSE AU.Factor END,S.SubCuenta
				--,ISNULL(A.DescuentoCompra,0)
				--,ISNULL(PC.Precio,0)
				--,'PC'=CASE WHEN A.DescuentoCompra IS NULL THEN ISNULL(PC.Precio,0) ELSE ISNULL(PC.Precio*(1-(A.DescuentoCompra/100)),0)END
				,'MM'=CASE WHEN A.MargenMinimo IS NULL THEN 0 ELSE A.MargenMinimo END 
				,'ME'=CASE WHEN Me.Precio IS NULL THEN 0 ELSE ROUND((Me.Precio*1.16),2) END,'MA'=CASE WHEN Ma.Precio IS NULL THEN 0 ELSE ROUND((Ma.Precio*1.16),2) END 
				,'MAE'=CASE WHEN MaE.Precio IS NULL THEN 0 ELSE ROUND((MaE.Precio*1.16),2) END
				,'Pro'= CASE WHEN A.Proveedor IS NULL THEN '' ELSE A.Proveedor END,'ProN'=CASE WHEN P.Nombre IS NULL THEN '' ELSE P.Nombre END
				FROM ListaPreciosSubUnidad AS S
				INNER JOIN Art AS A ON S.Articulo=A.Articulo
				LEFT JOIN Prov AS P ON A.Proveedor=P.Proveedor
				LEFT JOIN ArtUnidad AS AU ON S.Articulo=AU.Articulo AND S.Unidad=AU.Unidad				
				LEFT JOIN ListaPreciosSubUnidad AS PC ON S.Articulo=PC.Articulo AND S.Unidad=PC.Unidad AND S.SubCuenta=PC.SubCuenta AND PC.Lista='Precios de Compra'
				LEFT JOIN ListaPreciosSubUnidad AS Me ON S.Articulo=Me.Articulo AND S.Unidad=Me.Unidad AND S.SubCuenta=Me.SubCuenta AND Me.Lista='Menudeo'
				LEFT JOIN ListaPreciosSubUnidad AS Ma ON S.Articulo=Ma.Articulo AND S.Unidad=Ma.Unidad AND S.SubCuenta=Ma.SubCuenta AND Ma.Lista='Mayoreo'
				LEFT JOIN ListaPreciosSubUnidad AS MaE ON S.Articulo=MaE.Articulo AND S.Unidad=MaE.Unidad AND S.SubCuenta=MaE.SubCuenta AND MaE.Lista='Mayoreo Especial'				
				WHERE A.Rama=@Ram AND A.Estatus ='ALTA' AND S.Unidad=A.UnidadCompra;
ELSE
INSERT INTO #ListaP
SELECT DISTINCT L.Articulo,'Cate'=CASE WHEN RIGHT(A.Categoria,2) IS NULL THEN '' ELSE RIGHT(A.Categoria,2) END
				,A.Descripcion1,A.Rama,'CF'=CASE WHEN A.ClaveFabricante IS NULL THEN '' ELSE A.ClaveFabricante END
				,L.Unidad,CASE WHEN AU.Factor IS NULL THEN 0 ELSE AU.Factor END,''
				--,ISNULL(A.DescuentoCompra,0)
				--,ISNULL(PC.Precio,0)
				--,'PC'=CASE WHEN A.DescuentoCompra IS NULL THEN ISNULL(PC.Precio,0) ELSE ISNULL(PC.Precio*(1-(A.DescuentoCompra/100)),0)END
				,'MM'=CASE WHEN A.MargenMinimo IS NULL THEN 0 ELSE A.MargenMinimo END 
				,'ME'=CASE WHEN Me.Precio IS NULL THEN 0 ELSE ROUND((Me.Precio*1.16),2) END,'MA'=CASE WHEN Ma.Precio IS NULL THEN 0 ELSE ROUND((Ma.Precio*1.16),2) END 
				,'MAE'=CASE WHEN MaE.Precio IS NULL THEN 0 ELSE ROUND((MaE.Precio*1.16),2) END
				,'Pro'= CASE WHEN A.Proveedor IS NULL THEN '' ELSE A.Proveedor END,'ProN'=CASE WHEN P.Nombre IS NULL THEN '' ELSE P.Nombre END
				FROM ListaPreciosDUnidad AS L
				INNER JOIN Art AS A ON L.Articulo=A.Articulo
				LEFT JOIN Prov AS P ON A.Proveedor=P.Proveedor
				LEFT JOIN ArtUnidad AS AU ON L.Articulo=AU.Articulo AND L.Unidad=AU.Unidad				
				LEFT JOIN ListaPreciosDUnidad AS PC ON L.Articulo=PC.Articulo AND L.Unidad=PC.Unidad AND PC.Lista='Precios de Compra'
				LEFT JOIN ListaPreciosDUnidad AS Me ON L.Articulo=Me.Articulo AND L.Unidad=Me.Unidad AND Me.Lista='Menudeo'
				LEFT JOIN ListaPreciosDUnidad AS Ma ON L.Articulo=Ma.Articulo AND L.Unidad=Ma.Unidad AND Ma.Lista='Mayoreo'
				LEFT JOIN ListaPreciosDUnidad AS MaE ON L.Articulo=MaE.Articulo AND L.Unidad=MaE.Unidad AND MaE.Lista='Mayoreo Especial'				
				WHERE A.Proveedor=@Proov AND A.Rama=@Ram AND A.Estatus ='ALTA' AND L.Unidad=A.UnidadCompra
			UNION ALL
				SELECT DISTINCT S.Articulo,'Cate'=CASE WHEN RIGHT(A.Categoria,2) IS NULL THEN '' ELSE RIGHT(A.Categoria,2) END
				,'',A.Rama,''
				,S.Unidad,CASE WHEN AU.Factor IS NULL THEN 0 ELSE AU.Factor END,S.SubCuenta
				--,ISNULL(A.DescuentoCompra,0)
				--,ISNULL(PC.Precio,0)
				--,'PC'=CASE WHEN A.DescuentoCompra IS NULL THEN ISNULL(PC.Precio,0) ELSE ISNULL(PC.Precio*(1-(A.DescuentoCompra/100)),0)END
				,'MM'=CASE WHEN A.MargenMinimo IS NULL THEN 0 ELSE A.MargenMinimo END 
				,'ME'=CASE WHEN Me.Precio IS NULL THEN 0 ELSE ROUND((Me.Precio*1.16),2) END,'MA'=CASE WHEN Ma.Precio IS NULL THEN 0 ELSE ROUND((Ma.Precio*1.16),2) END 
				,'MAE'=CASE WHEN MaE.Precio IS NULL THEN 0 ELSE ROUND((MaE.Precio*1.16),2) END
				,'Pro'= CASE WHEN A.Proveedor IS NULL THEN '' ELSE A.Proveedor END,'ProN'=CASE WHEN P.Nombre IS NULL THEN '' ELSE P.Nombre END
				FROM ListaPreciosSubUnidad AS S
				INNER JOIN Art AS A ON S.Articulo=A.Articulo
				LEFT JOIN Prov AS P ON A.Proveedor=P.Proveedor
				LEFT JOIN ArtUnidad AS AU ON S.Articulo=AU.Articulo AND S.Unidad=AU.Unidad				
				LEFT JOIN ListaPreciosSubUnidad AS PC ON S.Articulo=PC.Articulo AND S.Unidad=PC.Unidad AND S.SubCuenta=PC.SubCuenta AND PC.Lista='Precios de Compra'
				LEFT JOIN ListaPreciosSubUnidad AS Me ON S.Articulo=Me.Articulo AND S.Unidad=Me.Unidad AND S.SubCuenta=Me.SubCuenta AND Me.Lista='Menudeo'
				LEFT JOIN ListaPreciosSubUnidad AS Ma ON S.Articulo=Ma.Articulo AND S.Unidad=Ma.Unidad AND S.SubCuenta=Ma.SubCuenta AND Ma.Lista='Mayoreo'
				LEFT JOIN ListaPreciosSubUnidad AS MaE ON S.Articulo=MaE.Articulo AND S.Unidad=MaE.Unidad AND S.SubCuenta=MaE.SubCuenta AND MaE.Lista='Mayoreo Especial'				
				WHERE A.Proveedor=@Proov AND A.Rama=@Ram AND A.Estatus ='ALTA' AND S.Unidad=A.UnidadCompra;

SELECT * FROM #ListaP Order by TProv,TRam,TTT,TArt,TDes DESC;
DROP TABLE #ListaP;

END

/*

EXEC SP_LPreciosUnidadCompra @Proov='',@Ram='0319'
DROP PROCEDURE SP_LPreciosUnidadCompra

*/