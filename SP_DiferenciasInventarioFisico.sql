--alter PROCEDURE SP_DiferenciasInventarioFisico @Folio int
--AS BEGIN   -- titulo diferencias de invetario fisico , folio del fisico consolidad

----/////////////////////////////TRY ME /////////////////////////////////////////////////
--USE Pruebas
--GO
--DECLARE @Folio int
--SET @Folio=40
----//////////////////////////////////////////////////////////////////////////////////

--traer todos las tomas fisicas o ajustes　　　　　　　
--- Y AGRUPAR POR ARTIUCLO, SUBCUENTA, UNIDAD

/*
SELECT TDif.FolioIFC,TDif.ArticuloC,TDif.Descripcion1,TDif.SubCuentaC,TDif.UnidadC,TDif.CantidadTFAFC,TDif.MovTFAFC,TDif.MovIDTFAFC,TDif.ReferenciaTFAFC FROM --SELECT para sacar los que tienen diferencia
(
SELECT Inv.FolioIF FolioIFC,--, Inv.Mov, Inv.MovID, 
InvD.Articulo ArticuloC,Art.Descripcion1 , InvD.SubCuenta SubCuentaC, InvD.Unidad UnidadC
,InvD.Cantidad-(ISNULL(
(SELECT B.Cantidad FROM Inv AS A INNER JOIN InvD AS B ON A.ID = B.ID AND A.Mov IN ('Teorico Congelado')--Cantidad Original en el sistema
WHERE A.FOLIOIF =@Folio AND A.Estatus='PENDIENTE' AND B.Articulo=InvD.Articulo AND B.SubCuenta=InvD.SubCuenta AND B.Unidad=InvD.Unidad)
,0))Diferencia
/*
,InvD.Cantidad,
ISNULL(
(SELECT B.Cantidad FROM Inv AS A INNER JOIN InvD AS B ON A.ID = B.ID AND A.Mov IN ('Teorico Congelado')--Cantidad Original en el sistema
WHERE A.FOLIOIF =@Folio AND A.Estatus='PENDIENTE' AND B.Articulo=InvD.Articulo AND B.SubCuenta=InvD.SubCuenta AND B.Unidad=InvD.Unidad)
,0)teorico
*/
,ISNULL(--cantidad del fisico consolidado
(SELECT B.Cantidad FROM Inv AS A INNER JOIN InvD AS B ON A.ID = B.ID -- AND A.Mov IN ('Toma Fisica','Ajuste Fisico Cons.')
WHERE A.ID=--Selecionar el movimiento mas reciente que modifico el Fisico Consolidado
 (select max(I0.ID) from inv I0 inner join InvD ID0 ON I0.id=ID0.id 
 WHERE ID0.Articulo=InvD.Articulo AND ISNULL(ID0.SubCuenta,'')=InvD.SubCuenta AND ID0.Unidad=InvD.Unidad AND I0.Mov in ('Toma Fisica','Ajuste Fisico Cons.') AND I0.Estatus='CONCLUIDO' AND I0.FolioIF=@Folio) 
 )
,0)CantidadTFAFC,
ISNULL(--Mov del ultimo movimiento
(SELECT A.Mov FROM Inv AS A INNER JOIN InvD AS B ON A.ID = B.ID 
WHERE A.ID=--Selecionar el movimiento mas reciente que modifico el Fisico Consolidado
 (select max(I0.ID) from inv I0 inner join InvD ID0 ON I0.id=ID0.id 
 WHERE ID0.Articulo=InvD.Articulo AND ISNULL(ID0.SubCuenta,'')=InvD.SubCuenta AND ID0.Unidad=InvD.Unidad AND I0.Mov in ('Toma Fisica','Ajuste Fisico Cons.') AND I0.Estatus='CONCLUIDO' AND I0.FolioIF=@Folio) 
 )
,'')MovTFAFC,
ISNULL(--MovId del ultimo movimiento
(SELECT A.MovID FROM Inv AS A INNER JOIN InvD AS B ON A.ID = B.ID 
WHERE A.ID=--Selecionar el movimiento mas reciente que modifico el Fisico Consolidado
 (select max(I0.ID) from inv I0 inner join InvD ID0 ON I0.id=ID0.id 
 WHERE ID0.Articulo=InvD.Articulo AND ISNULL(ID0.SubCuenta,'')=InvD.SubCuenta AND ID0.Unidad=InvD.Unidad AND I0.Mov in ('Toma Fisica','Ajuste Fisico Cons.') AND I0.Estatus='CONCLUIDO' AND I0.FolioIF=@Folio) 
 )
,'')MovIDTFAFC,
ISNULL(--Referencia del ultimo movimiento
(SELECT A.Referencia FROM Inv AS A INNER JOIN InvD AS B ON A.ID = B.ID 
WHERE A.ID=--Selecionar el movimiento mas reciente que modifico el Fisico Consolidado
 (select max(I0.ID) from inv I0 inner join InvD ID0 ON I0.id=ID0.id 
 WHERE ID0.Articulo=InvD.Articulo AND ISNULL(ID0.SubCuenta,'')=InvD.SubCuenta AND ID0.Unidad=InvD.Unidad AND I0.Mov in ('Toma Fisica','Ajuste Fisico Cons.') AND I0.Estatus='CONCLUIDO' AND I0.FolioIF=@Folio) 
 )
,'')ReferenciaTFAFC

FROM Inv 
INNER JOIN InvD  ON Inv.ID = InvD.ID AND Inv.Mov='Fisico Consolidado'
INNER JOIN Art ON InvD.Articulo=Art.Articulo
WHERE Inv.FOLIOIF=@Folio AND Inv.Estatus='PENDIENTE'
)TDif where TDif.Diferencia<>0

*/

--///////////////////////////////////
/*
SELECT FolioFC,ArticuloV,Descripcion1,SubCuentaV,UnidadV,MovTFA,MovIDTFA,ReferenciaTFA,SUM(CantidadTFA)CantidadTFA FROM(--SOLO PARA AGRUPAR IGUALES
SELECT TArts.FolioFC, TArts.ArticuloV, Art.Descripcion1,TArts.SubCuentaV, TArts.UnidadV, 
ISNULL(TTFAFC.Mov,'SIN MOV')MovTFA ,ISNULL(TTFAFC.MovID,'SIN MOVID')MovIDTFA , ISNULL(TTFAFC.Referencia,'SIN REFE')ReferenciaTFA , ISNULL(TTFAFC.Cantidad,0)CantidadTFA FROM ( --SOLO PARA TENER LOS CAMPOS SIN EL CASE
SELECT FolioFC,	'ArticuloV'=case when ArticuloFC ='' THEN ArticuloTC  ELSE ArticuloFC END, 'SubCuentaV'=CASE WHEN SubCuentaCF='' THEN SubCuentaTC ELSE SubCuentaCF END,
'UnidadV'=CASE WHEN UnidadFC ='' THEN UnidadTC ELSE UnidadFC END,Difer FROM(--Mostrar todos los Art validando si no existe en los dos
SELECT * ,(CantidadFC-CantidadTC)Difer FROM (--Sacar las diferencias que hay entre el Fc y TC
SELECT isnull(FolioFC,@Folio)FolioFC, ISNULL(ArticuloFC,'')ArticuloFC, ISNULL(SubCuentaCF,'')SubCuentaCF, ISNULL(UnidadFC,'')UnidadFC, ISNULL(CantidadFC,0)CantidadFC
,ISNULL(FolioIFTC,'')FolioIFTC,	ISNULL(ArticuloTC,'')ArticuloTC, ISNULL(SubCuentaTC,'')SubCuentaTC,	ISNULL(UnidadTC,'')UnidadTC, ISNULL(CantidadTC,'')CantidadTC
 FROM 
(SELECT Inv.FolioIF FolioFC,InvD.Articulo ArticuloFC,ISNULL(InvD.SubCuenta,'')SubCuentaCF,InvD.Unidad UnidadFC,InvD.Cantidad CantidadFC
FROM Inv 
INNER JOIN InvD  ON Inv.ID = InvD.ID
WHERE Inv.FolioIF=@Folio AND Inv.Mov='Fisico Consolidado' AND Inv.Estatus='PENDIENTE'
)TFisCon
FULL JOIN --SELECCIONA LOS ARTICULOS DE TC PARA UNIR FC 
(SELECT A.FolioIF FolioIFTC, B.Articulo ArticuloTC,ISNULL(B.SubCuenta,'')SubCuentaTC, B.Unidad UnidadTC, B.Cantidad CantidadTC FROM Inv AS A 
INNER JOIN InvD AS B ON A.ID = B.ID 
WHERE A.FOLIOIF=@Folio AND A.Mov='Teorico Congelado' AND A.Estatus='PENDIENTE' )TTeoCon
ON TFisCon.ArticuloFC=TTeoCon.ArticuloTC AND TFisCon.SubCuentaCF=TTeoCon.SubCuentaTC AND TFisCon.UnidadFC=TTeoCon.UnidadTC
)TResta 
)TValidaArt)TArts
LEFT JOIN 
(
SELECT AA.Mov,AA.MovID,AA.Referencia,BB.Articulo,ISNULL(BB.SubCuenta,'')Subcuenta,BB.Unidad,BB.Cantidad FROM Inv AS AA 
INNER JOIN InvD AS BB ON AA.ID=BB.ID 
WHERE AA.FolioIF=@Folio AND AA.Mov IN ('Toma Fisica','Ajuste Fisico Cons.') AND AA.Estatus='CONCLUIDO')TTFAFC
ON TArts.ArticuloV=TTFAFC.Articulo AND TArts.SubCuentaV=TTFAFC.Subcuenta AND TArts.UnidadV=TTFAFC.Unidad
INNER JOIN ART ON TArts.ArticuloV=Art.Articulo
WHERE TArts.Difer<>0
)Tagrupado GROUP BY FolioFC,ArticuloV,Descripcion1,SubCuentaV,UnidadV,MovTFA,MovIDTFA,ReferenciaTFA
ORDER BY ArticuloV,SubCuentaV,UnidadV ,MovTFA DESC, MovIDTFA

END

*/
/*

EXEC SP_DiferenciasInventarioFisico @Folio=39

*/

--##############################################################################################################################################
USE Pruebas
GO
DECLARE @FolioTeorico int, @FolioFisico int
SET @FolioTeorico=69
SET @FolioFisico=71

---------------------------------------------------------

SELECT FolioFC,ArticuloV,Descripcion1,SubCuentaV,ISNULL(Unidad,'N/A') UnidadV,MovTFA,MovIDTFA,ReferenciaTFA,SUM(CantidadTFA)CantidadTFA,Difer  FROM(--SOLO PARA AGRUPAR IGUALES
SELECT TArts.FolioFC, TArts.ArticuloV ,Art.Descripcion1
,TArts.SubCuentaV, TTFAFC.Unidad, 
ISNULL(TTFAFC.Mov,'SIN MOV')MovTFA ,ISNULL(TTFAFC.MovID,'SIN MOVID')MovIDTFA , ISNULL(TTFAFC.Referencia,'SIN REFE')ReferenciaTFA , ISNULL(TTFAFC.Cantidad,0)CantidadTFA ,TArts.Difer FROM ( --SOLO PARA TENER LOS CAMPOS SIN EL CASE
SELECT FolioFC,	'ArticuloV'=case when ArticuloFC ='' THEN ArticuloTC  ELSE ArticuloFC END, 'SubCuentaV'=CASE WHEN SubCuentaCF='' THEN SubCuentaTC ELSE SubCuentaCF END,
'UnidadV'=CASE WHEN UnidadFC ='' THEN UnidadTC ELSE UnidadFC END,Difer FROM(--Mostrar todos los Art validando si no existe en los dos
SELECT * ,(CantidadFC-CantidadTC)Difer FROM (--Sacar las diferencias que hay entre el Fc y TC
SELECT isnull(FolioFC,@FolioTeorico)FolioFC, ISNULL(ArticuloFC,'')ArticuloFC, ISNULL(SubCuentaCF,'')SubCuentaCF, ISNULL(UnidadFC,'')UnidadFC, ISNULL(CantidadFC,0)CantidadFC
,ISNULL(FolioIFTC,'')FolioIFTC,	ISNULL(ArticuloTC,'')ArticuloTC, ISNULL(SubCuentaTC,'')SubCuentaTC,	ISNULL(UnidadTC,'')UnidadTC, ISNULL(CantidadTC,'')CantidadTC
 FROM 
(
SELECT Inv.FolioIF FolioFC,InvD.Articulo ArticuloFC,ISNULL(InvD.SubCuenta,'')SubCuentaCF,InvD.Unidad UnidadFC,InvD.Cantidad CantidadFC
FROM Inv 
INNER JOIN InvD  ON Inv.ID = InvD.ID
WHERE Inv.FolioIF=@FolioFisico AND Inv.Mov='Fisico Consolidado' AND Inv.Estatus<>'CANCELADO' --and invd.articulo='13983'
)TFisCon
FULL JOIN --SELECCIONA LOS ARTICULOS DE TC PARA UNIR FC 
(
SELECT A.FolioIF FolioIFTC, B.Articulo ArticuloTC,ISNULL(B.SubCuenta,'')SubCuentaTC, B.Unidad UnidadTC, B.Cantidad CantidadTC FROM Inv AS A 
INNER JOIN InvD AS B ON A.ID = B.ID 
WHERE A.FOLIOIF=@FolioTeorico AND A.Mov='Teorico Congelado' AND A.Estatus<>'CANCELADO'  --and b.articulo='13983'
)TTeoCon
ON TFisCon.ArticuloFC=TTeoCon.ArticuloTC AND TFisCon.SubCuentaCF=TTeoCon.SubCuentaTC AND TFisCon.UnidadFC=TTeoCon.UnidadTC
)TResta 
)TValidaArt)TArts
LEFT JOIN 
(
SELECT AA.Mov,AA.MovID,AA.Referencia,BB.Articulo,ISNULL(BB.SubCuenta,'')Subcuenta,BB.Unidad,BB.Cantidad FROM Inv AS AA 
INNER JOIN InvD AS BB ON AA.ID=BB.ID 
WHERE AA.FolioIF=@FolioFisico AND AA.Mov IN ('Toma Fisica','Ajuste Fisico Cons.') AND AA.Estatus='CONCLUIDO' --and BB.articulo='13983'
)TTFAFC
ON TArts.ArticuloV=TTFAFC.Articulo AND TArts.SubCuentaV=TTFAFC.Subcuenta --AND TArts.UnidadV=TTFAFC.Unidad
INNER JOIN ART ON TArts.ArticuloV=Art.Articulo
WHERE TArts.Difer<>0
)Tagrupado GROUP BY FolioFC,ArticuloV,Descripcion1,SubCuentaV,MovTFA,MovIDTFA,Unidad,ReferenciaTFA,Difer
ORDER BY ArticuloV,SubCuentaV,MovTFA DESC, MovIDTFA,Unidad

--###############################################################################################################################################

