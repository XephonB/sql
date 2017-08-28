--DECLARE SP_DiferenciasInventarioFisico @Folio int
--AS BEGIN   -- titulo diferencias de invetario fisico , folio del fisico consolidad

USE Pruebas
GO
DECLARE @Folio int
SET @Folio=19


--///////////////////////A QUE PONER EL ESTATUS CONCLUIDO?????????''''///////////////////////////////////////////////////////////////////
--//////////////////////
--SELECT TResultado.FolioIFtf,TResultado.MovIDtf,TResultado.Referenciatf,TResultado.Articulotf,Art.Descripcion1,TResultado.SubCuentatf,TResultado.Unidadtf,TResultado.Cantidadtf FROM --Para sacar solo los articulos con diferencias
--(
SELECT
Ttf.FolioIFtf,
 ISNULL(FolioIf,'')FolioIf,ISNULL(MovTc,'')MovTc,ISNULL(ArticuloTC,'')ArticuloTC,ISNULL(SubCuentaTC,'')SubCuentaTC,ISNULL(UnidadTC,'')UnidadTC,ISNULL(CantidadTC,'')CantidadTC,ISNULL(MovFC,'')MovFC,ISNULL(ArticuloFC,'')ArticuloFC,ISNULL(SubCuentaFC,'')SubCuentaFC,ISNULL(UnidadFC,'')UnidadFC,ISNULL(CantidadFC,'')CantidadFC,
 Ttc.MovIDTC,Tfc.MovIDFC,
 (ISNULL(CantidadFC,0)-ISNULL(CantidadTC,0))Diferencia ,
 Ttf.Movtf, Ttf.MovIDtf, Ttf.Referenciatf,Ttf.Articulotf, Ttf.SubCuentatf, Ttf.Unidadtf ,Ttf.Cantidadtf
FROM --Datos del Teorico Congelado el del sistema
(SELECT Inv.FolioIF, Inv.Mov MovTC, Inv.MovID MovIDTC, InvD.Articulo ArticuloTC, InvD.SubCuenta SubCuentaTC, InvD.Cantidad CantidadTC, InvD.Unidad UnidadTC
FROM Inv  
inner JOIN InvD  ON Inv.ID = InvD.ID 
WHERE Inv.Mov IN('Teorico Congelado')
AND Inv.FOLIOIF=@Folio)Ttc
RIGHT JOIN 
(--Conteo ralizado por el personal pero consolidado
SELECT A.FolioIF FolioIFFC, A.Mov MovFC, A.MovID MovIDFC, B.Articulo ArticuloFC, B.SubCuenta SubCuentaFC, B.Cantidad CantidadFC, B.Unidad UnidadFC
FROM Inv AS A 
INNER JOIN InvD AS B ON A.ID = B.ID AND A.Mov='Fisico Consolidado'
WHERE A.FOLIOIF =@Folio
)Tfc 
ON Ttc.ArticuloTC=Tfc.ArticuloFC AND Ttc.SubCuentaTC=Tfc.SubCuentaFC AND Ttc.UnidadTC=Tfc.UnidadFC
INNER JOIN 
(--Conteo realizado por el personal individual
SELECT I.FolioIF FolioIFtf,I.Mov Movtf,I.MovID MovIDtf,ISNULL(I.Referencia,'')Referenciatf,ID.Articulo Articulotf,ISNULL(ID.SubCuenta,'')SubCuentatf,ID.Cantidad Cantidadtf,ID.Unidad Unidadtf 
FROM Inv AS I INNER JOIN InvD AS ID ON I.ID=ID.ID
WHERE I.mov='Toma Fisica' AND I.FolioIF=@Folio AND I.Estatus='CONCLUIDO'
)Ttf
ON Tfc.ArticuloFC=Ttf.Articulotf AND Tfc.SubCuentaFC=Ttf.SubCuentatf AND Tfc.UnidadFC=Ttf.Unidadtf
--)TResultado
--INNER JOIN Art ON TResultado.Articulotf=Art.Articulo
--WHERE TResultado.Diferencia<>0


--END

/*

EXEC SP_DiferenciaInventario @Folio=19

*/



--select * from Inv where Mov IN('Teorico Congelado')
