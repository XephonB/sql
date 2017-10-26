--ALTER PROCEDURE SP_DiferenciasInventarioFisico @Folio int
--AS BEGIN   -- titulo diferencias de invetario fisico , folio del fisico consolidad

----/////////////////////////////TRY ME /////////////////////////////////////////////////
USE Pruebas
GO
DECLARE @Folio int
SET @Folio=39
----//////////////////////////////////////////////////////////////////////////////////
/*
SELECT TResultado.FolioIFtf,TResultado.MovIDtf,TResultado.Referenciatf,TResultado.Articulotf,Art.Descripcion1,TResultado.SubCuentatf,TResultado.Unidadtf,TResultado.Cantidadtf FROM --Para sacar solo los articulos con diferencias
(
*/
SELECT * FROM(
SELECT
 --ISNULL(FolioIf,'')FolioIf,ISNULL(MovTc,'')MovTc,ISNULL(ArticuloTC,'')ArticuloTC,ISNULL(SubCuentaTC,'')SubCuentaTC,ISNULL(UnidadTC,'')UnidadTC,ISNULL(CantidadTC,'')CantidadTC,ISNULL(MovFC,'')MovFC,ISNULL(ArticuloFC,'')ArticuloFC,ISNULL(SubCuentaFC,'')SubCuentaFC,ISNULL(UnidadFC,'')UnidadFC,ISNULL(CantidadFC,'')CantidadFC,
 --Ttc.MovIDTC,Tfc.MovIDFC,
-- (ISNULL(CantidadFC,0)-ISNULL(CantidadTC,0))Diferencia ,
 FolioIFFC,ArticuloFC,SubCuentaFC,UnidadFC,
 Ttf.Movtf, Ttf.MovIDtf, Ttf.Referenciatf,Ttf.Cantidadtf
FROM --Datos del Teorico Congelado el del sistema
(SELECT ISNULL(Inv.FolioIF,'')FolioIF, Inv.Mov MovTC, Inv.MovID MovIDTC, InvD.Articulo ArticuloTC, ISNULL(InvD.SubCuenta,'') SubCuentaTC, InvD.Cantidad CantidadTC, InvD.Unidad UnidadTC
FROM Inv  
inner JOIN InvD  ON Inv.ID = InvD.ID 
WHERE Inv.Mov IN('Teorico Congelado')
AND Inv.FOLIOIF=@Folio AND iNV.Estatus='PENDIENTE'
)Ttc
RIGHT JOIN 
(--Conteo ralizado por el personal pero consolidado
SELECT A.FolioIF FolioIFFC, A.Mov MovFC, A.MovID MovIDFC, B.Articulo ArticuloFC, ISNULL(B.SubCuenta,'')SubCuentaFC, B.Cantidad CantidadFC, B.Unidad UnidadFC
FROM Inv AS A 
INNER JOIN InvD AS B ON A.ID = B.ID AND A.Mov='Fisico Consolidado'
WHERE A.FOLIOIF =@Folio AND A.Estatus='PENDIENTE'
)Tfc 
ON Ttc.ArticuloTC=Tfc.ArticuloFC AND Ttc.SubCuentaTC=Tfc.SubCuentaFC AND Ttc.UnidadTC=Tfc.UnidadFC
LEFT JOIN 
(--Conteo realizado por el personal individual

SELECT I.FolioIF FolioIFtf,I.Mov Movtf,I.MovID MovIDtf,ISNULL(I.Referencia,'')Referenciatf,ID.Articulo Articulotf,ISNULL(ID.SubCuenta,'')SubCuentatf,ID.Cantidad Cantidadtf,ID.Unidad Unidadtf 
FROM Inv AS I INNER JOIN InvD AS ID ON I.ID=ID.ID
WHERE I.mov='Ajuste Fisico Cons.' AND I.FolioIF=@Folio AND I.Estatus='CONCLUIDO' AND Inv.ID=(select max(INV.ID),INV.Mov from inv inner join InvD ON inv.id=Invd.id where )

)Ttf
ON Tfc.ArticuloFC=Ttf.Articulotf AND Tfc.SubCuentaFC=Ttf.SubCuentatf AND Tfc.UnidadFC=Ttf.Unidadtf
)TAjuste


SELECT I.FolioIF FolioIFtf,I.Mov Movtf,I.MovID MovIDtf,ISNULL(I.Referencia,'')Referenciatf,ID.Articulo Articulotf,ISNULL(ID.SubCuenta,'')SubCuentatf,ID.Cantidad Cantidadtf,ID.Unidad Unidadtf 
FROM Inv AS I INNER JOIN InvD AS ID ON I.ID=ID.ID
WHERE I.mov='Toma Fisica' AND I.FolioIF=@Folio AND I.Estatus='CONCLUIDO'
/*
)TResultado
INNER JOIN Art ON TResultado.Articulotf=Art.Articulo
WHERE TResultado.Diferencia<>0 Order By Articulotf,SubCuentatf,Unidadtf
*/

--END

/*

EXEC SP_DiferenciasInventarioFisico @Folio=39

*/

SELECT A.FolioIF FolioIFFC, A.Mov MovFC, A.MovID MovIDFC, B.Articulo ArticuloFC, ISNULL(B.SubCuenta,'')SubCuentaFC, B.Cantidad CantidadFC, B.Unidad UnidadFC
FROM Inv AS A 
INNER JOIN InvD AS B ON A.ID = B.ID AND A.Mov='Fisico Consolidado'
WHERE A.FOLIOIF =@Folio AND A.Estatus='PENDIENTE'