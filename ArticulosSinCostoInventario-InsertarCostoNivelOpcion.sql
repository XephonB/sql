DECLARE @FolioIF int, @Sucursal int , @Insert VARCHAR(4)
SET @FolioIF=52
SET @Sucursal=10
SET @Insert='NO'

--////////////////////////////////////////////////////////NIVEL SUBCUENTA/////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
SELECT @Sucursal Suc,'ASSIS' Empre,TAgru.Arti,TAgru.SubC
,isnull((SELECT CASE WHEN A.UltimoCosto=0 THEN A.CostoPromedio ELSE A.UltimoCosto  END FROM ArtCosto AS A with(nolock)  WHERE TAgru.Arti=A.Articulo AND A.Sucursal=@Sucursal),
(SELECT top 1 B.UltimoCosto FROM ArtCosto AS B with(nolock) where TAgru.Arti=B.Articulo and B.UltimoCosto<>0) )UltCost
,isnull((SELECT CASE WHEN C.CostoPromedio=0 THEN C.UltimoCosto ELSE C.CostoPromedio END FROM ArtCosto  AS C with(nolock) WHERE TAgru.Arti=C.Articulo AND C.Sucursal=@Sucursal),
(SELECT top 1 E.CostoPromedio FROM ArtCosto AS E with(nolock) where TAgru.Arti=E.Articulo and E.CostoPromedio<>0))CostProm
FROM (
SELECT TF.Articulo Arti ,TF.SubCuenta SubC ,CSub.UltimoCosto UltiCos FROM (
SELECT DISTINCT /*Inv.ID , Inv.FechaEmision,Inv.Referencia,Inv.Almacen, */InvD.Articulo,InvD.SubCuenta FROM Inv with(nolock)
INNER JOIN InvD with(nolock) ON Inv.ID=InvD.ID WHERE Inv.FolioIF=@FolioIF AND Inv.Estatus='SINAFECTAR' AND Inv.Mov='Toma Fisica'
)TF --CAMBIAR A SINAFECTAR
LEFT JOIN 
(
SELECT D.Articulo, D.SubCuenta, D.UltimoCosto FROM ArtSubcosto AS D with(nolock) WHERE D.Sucursal=@Sucursal)CSub--CAMBIAR
ON TF.Articulo=CSub.Articulo and TF.Subcuenta=CSub.Subcuenta
WHERE CSub.UltimoCosto IS NULL )TAgru
INNER JOIN Art ON TAgru.Arti=Art.Articulo AND Art.Estatus='ALTA' AND TipoOpcion='SI'
ORDER BY TAgru.Arti,TAgru.SubC


--//////////////////////////////////////////Insertar Costo//////////////////////////////////////////////

IF @Insert='SI' --CAMBIAR
	BEGIN
	INSERT INTO ArtSubCosto (Sucursal,Empresa,Articulo,SubCuenta,UltimoCosto,CostoPromedio)  
	SELECT @Sucursal Suc,'ASSIS' Empre,TAgru.Arti,TAgru.SubC
	,isnull((SELECT CASE WHEN A.UltimoCosto=0 THEN A.CostoPromedio ELSE A.UltimoCosto  END FROM ArtCosto AS A with(nolock)  WHERE TAgru.Arti=A.Articulo AND A.Sucursal=@Sucursal),
	(SELECT top 1 B.UltimoCosto FROM ArtCosto AS B with(nolock) where TAgru.Arti=B.Articulo and B.UltimoCosto<>0) )UltCost
	,isnull((SELECT CASE WHEN C.CostoPromedio=0 THEN C.UltimoCosto ELSE C.CostoPromedio END FROM ArtCosto  AS C with(nolock) WHERE TAgru.Arti=C.Articulo AND C.Sucursal=@Sucursal),
	(SELECT top 1 E.CostoPromedio FROM ArtCosto AS E with(nolock) where TAgru.Arti=E.Articulo and E.CostoPromedio<>0))CostProm
	FROM (
	SELECT TF.Articulo Arti ,TF.SubCuenta SubC ,CSub.UltimoCosto UltiCos FROM (
	SELECT DISTINCT /*Inv.ID , Inv.FechaEmision,Inv.Referencia,Inv.Almacen, */InvD.Articulo,InvD.SubCuenta FROM Inv with(nolock)
	INNER JOIN InvD with(nolock) ON Inv.ID=InvD.ID WHERE Inv.FolioIF=@FolioIF AND Inv.Estatus='SINAFECTAR' AND Inv.Mov='Toma Fisica'
	)TF --CAMBIAR A SINAFECTAR
	LEFT JOIN 
	(
	SELECT D.Articulo, D.SubCuenta, D.UltimoCosto FROM ArtSubcosto AS D with(nolock) WHERE D.Sucursal=@Sucursal)CSub--CAMBIAR
	ON TF.Articulo=CSub.Articulo and TF.Subcuenta=CSub.Subcuenta
	WHERE CSub.UltimoCosto IS NULL )TAgru
	INNER JOIN Art ON TAgru.Arti=Art.Articulo AND Art.Estatus='ALTA' AND TipoOpcion='SI'
ORDER BY TAgru.Arti,TAgru.SubC
	END

ELSE select 'SIN INSERTAR COSTOS NIVEL OPCION' Operacion

--//////////////////////////////////////////////////////////////FIN///////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////NIVEL SUBCUENTA/////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

--///////////////////////////////////////////////NIVEL ARTICULO////////////////////////////////////////////////////////////////////////////////////////

SELECT @Sucursal Sucur,'ASSIS' Empre,TF.Articulo
,(SELECT top 1 F.UltimoCosto FROM ArtCosto AS F with(nolock) where F.Articulo=TF.Articulo and F.UltimoCosto<>0)UltimoCosto 
,(SELECT top 1 G.CostoPromedio FROM ArtCosto AS G with(nolock) where G.Articulo=TF.Articulo and G.CostoPromedio<>0)CostoPromedio -- CAMBIAR 
FROM (
	SELECT DISTINCT /*Inv.ID, Inv.FechaEmision,Inv.Referencia,Inv.Almacen,*/InvD.Articulo FROM Inv with(nolock)
	INNER JOIN InvD with(nolock) ON Inv.ID=InvD.ID 
	INNER JOIN Art with(nolock) ON Invd.Articulo=Art.Articulo AND Art.Estatus='ALTA' AND Art.TipoOpcion='NO'
	WHERE Inv.FolioIF=@FolioIF AND Inv.Estatus='SINAFECTAR' AND Inv.Mov='Toma Fisica'
	)TF
	LEFT JOIN (SELECT H.Articulo,H.UltimoCosto FROM ArtCosto AS H with(nolock) WHERE H.Sucursal=@Sucursal)ACS --CAMBIAR
    ON TF.Articulo=ACS.Articulo
	WHERE ACS.UltimoCosto IS NULL
--	GROUP BY TF.Articulo,ACS.UltimoCosto
	ORDER BY TF.Articulo


--//////////////////////////////////////////Insertar Costo////////////////////////////////////////////////////////////////////////////////////////////

IF @Insert='SI'
BEGIN
INSERT INTO ArtCosto(Sucursal,Empresa,Articulo,UltimoCosto,CostoPromedio) 
	SELECT @Sucursal Sucur,'ASSIS' Empre,TF.Articulo
	,(SELECT top 1 F.UltimoCosto FROM ArtCosto AS F with(nolock) where F.Articulo=TF.Articulo and F.UltimoCosto<>0)UltimoCosto 
	,(SELECT top 1 G.CostoPromedio FROM ArtCosto AS G with(nolock) where G.Articulo=TF.Articulo and G.CostoPromedio<>0)CostoPromedio -- CAMBIAR 
	FROM (
	SELECT DISTINCT /*Inv.ID, Inv.FechaEmision,Inv.Referencia,Inv.Almacen,*/InvD.Articulo FROM Inv with(nolock)
	INNER JOIN InvD with(nolock) ON Inv.ID=InvD.ID 
	INNER JOIN Art with(nolock) ON Invd.Articulo=Art.Articulo AND Art.Estatus='ALTA' AND Art.TipoOpcion='NO'
	WHERE Inv.FolioIF=@FolioIF AND Inv.Estatus='SINAFECTAR' AND Inv.Mov='Toma Fisica'
	)TF
	LEFT JOIN (SELECT H.Articulo,H.UltimoCosto FROM ArtCosto AS H with(nolock) WHERE H.Sucursal=@Sucursal)ACS --CAMBIAR
    ON TF.Articulo=ACS.Articulo
	WHERE ACS.UltimoCosto IS NULL
--	GROUP BY TF.Articulo,ACS.UltimoCosto
	ORDER BY TF.Articulo
END
ELSE select 'SIN INSERTAR COSTOS NIVEL ARTICULO' Operacion

--//////////////////////////////////////////FIN/////////////////////////////////////////////////////
--/////////////////////////////////////////////////////////////////////////////////////////////////////
