--create PROCEDURE SP_Temporal @TProv varchar(10), @TFinicio date, @TFfinal date
--AS BEGIN 

DECLARE @TProv varchar(10), @TFinicio date, @TFfinal date
SET @TProv='291'
SET @TFinicio='2017-01-02'
SET @TFfinal='2017-06-01'
/*
SELECT ComprA.ID,Compra.Mov,Compra.MovID,Compra.FechaEmision,Compra.Estatus,Compra.Proveedor,CompraD.Articulo,Art.Descripcion1,CompraD.SubCuenta,CompraD.Cantidad
,MovFlujo.DMov,CD1.Articulo,CD1.SubCuenta,CD1.Cantidad
FROM Compra 
INNER JOIN CompraD ON Compra.ID=CompraD.ID
INNER JOIN Art ON CompraD.Articulo=Art.Articulo
INNER JOIN MovFlujo ON Compra.ID=MovFlujo.OID AND Compra.MovID=MovFlujo.OMovID AND MovFlujo.OModulo='COMS'
left JOIN CompraD AS CD1 ON MovFlujo.DID=CD1.ID AND CompraD.Articulo=CD1.Articulo AND CompraD.SubCuenta=CD1.SubCuenta AND Compra.MovID=CD1.AplicaID AND Compra.Mov=CD1.Aplica
WHERE Compra.Mov in ('Orden Compra','OC Consig. Merceria','OC Consig. Ropa','OC Decoracion','OC Electronica','OC Generales','OC Import. Merceria','OC Import. Telas','OC Merc Dir. al Cte.','OC Merceria','OC Ropa','OC Tela Dir. al Cte.','OC Telas')
AND Compra.Estatus NOT IN ('CANCELADO','SINAFECTAR') AND Compra.Proveedor=@TProv AND CAST(Compra.FechaEmision AS DATE) BETWEEN @TFinicio AND @TFfinal
ORDER BY Compra.ID
*/
/*
SELECT TDos.ID,TDos.Mov,TDos.Estatus,TDos.Articulo,TDos.Descripcion1,TDos.SubCuenta,TDos.Cantidad,SUM(TDos.CantidadEntregada)CantidadEntregada,SUM(TDos.CantidadPerdida)CantidadPerdida FROM(
SELECT TCompra.ID,TCompra.Mov,TCompra.MovID,TCompra.FEmision,TCompra.Estatus,TCompra.Proveedor,TCompra.Articulo,TCompra.Descripcion1,TCompra.SubCuenta,TCompra.Cantidad,MovFlujo.DMov,MovFlujo.DMovID,MovFlujo.DID 
,(SELECT IsNULL(SUM(CompraD.Cantidad),0) FROM CompraD WHERE CompraD.ID=MovFlujo.DID AND CompraD.Articulo=TCompra.Articulo AND CompraD.SubCuenta=TCompra.SubCuenta AND CompraD.AplicaID=TCompra.MovID AND CompraD.Aplica=TCompra.Mov AND MovFlujo.DMov in ('Ent Comp Decora x FF','Ent Comp Decoracion','Ent. Comp. Dir. Cte.','Entrada Compra','Entrada con Gastos'))'CantidadEntregada'
,(SELECT ISNULL(SUM(CompraD.Cantidad),0) FROM CompraD WHERE CompraD.ID=MovFlujo.DID AND CompraD.Articulo=TCompra.Articulo AND CompraD.SubCuenta=TCompra.SubCuenta AND CompraD.AplicaID=TCompra.MovID AND CompraD.Aplica=TCompra.Mov AND MovFlujo.Dmov in ('Compra Perdida','Compra Rechazada'))'CantidadPerdida'
FROM
(SELECT ComprA.ID,Compra.Mov,Compra.MovID,CAST(Compra.FechaEmision AS DATE)FEmision,Compra.Estatus,Compra.Proveedor,CompraD.Articulo,Art.Descripcion1,CompraD.SubCuenta,SUM(CompraD.Cantidad)Cantidad
--,MovFlujo.DMov,CD1.Articulo,CD1.SubCuenta,CD1.Cantidad
FROM Compra 
INNER JOIN CompraD ON Compra.ID=CompraD.ID
INNER JOIN Art ON CompraD.Articulo=Art.Articulo
--INNER JOIN MovFlujo ON Compra.ID=MovFlujo.OID AND Compra.MovID=MovFlujo.OMovID AND MovFlujo.OModulo='COMS'
--left JOIN CompraD AS CD1 ON MovFlujo.DID=CD1.ID AND CompraD.Articulo=CD1.Articulo AND CompraD.SubCuenta=CD1.SubCuenta AND Compra.MovID=CD1.AplicaID AND Compra.Mov=CD1.Aplica
WHERE Compra.Mov in ('Orden Compra','OC Consig. Ropa','OC Decoracion','OC Electronica','OC Generales','OC Import. Merceria','OC Import. Telas','OC Merc Dir. al Cte.','OC Merceria','OC Ropa','OC Tela Dir. al Cte.','OC Telas')
AND Compra.Estatus NOT IN ('CANCELADO','SINAFECTAR') /*AND Compra.Proveedor=@TProv*/ AND CAST(Compra.FechaEmision AS DATE) BETWEEN @TFinicio AND @TFfinal 
and compra.id=10815
GROUP BY Compra.ID,Compra.Mov,Compra.MovID,Compra.FechaEmision,Compra.Estatus,Compra.Proveedor,CompraD.Articulo,Art.Descripcion1,CompraD.SubCuenta
--ORDER BY Compra.ID
)TCompra 
iNNER JOIN MovFlujo ON TCompra.ID=MovFlujo.OID AND TCompra.MovID=MovFlujo.OMovID AND MovFlujo.OModulo='COMS' AND MovFlujo.Cancelado=0 
)TDos GROUP BY TDos.ID,TDos.Mov,TDos.Estatus,TDos.Articulo,TDos.Descripcion1,TDos.SubCuenta,TDos.Cantidad ORDER BY TDos.ID,TDos.Articulo,TDos.SubCuenta
*/

--select distinct Borrame.TID,Borrame.TMOV,Borrame.TMovID from (

SELECT	TOc.ID'TID',TOc.MovID'TMovID',TOc.Mov'TMOV',TOc.Estatus'TEstatus',TOc.Articulo'Articulo',TOc.Descripcion1'TDescripcion1',TOc.SubCuenta'TSubCuenta',TOc.Cantidad'TCantidad',SUM(TOc.CantidadEntregada)CantidadEntregada,SUM(TOc.CantidadPerdida)CantidadPerdida FROM(
SELECT TCompra.ID,TCompra.Mov,TCompra.MovID,TCompra.FEmision,TCompra.Estatus,TCompra.Proveedor,TCompra.Articulo,TCompra.Descripcion1,TCompra.SubCuenta,TCompra.Cantidad,MovFlujo.DMov,MovFlujo.DMovID,MovFlujo.DID 
,(SELECT IsNULL(SUM(CompraD.Cantidad),0) FROM CompraD WHERE CompraD.ID=MovFlujo.DID AND CompraD.Articulo=TCompra.Articulo AND CompraD.SubCuenta=TCompra.SubCuenta AND CompraD.AplicaID=TCompra.MovID AND CompraD.Aplica=TCompra.Mov AND MovFlujo.DMov in ('Ent Comp Decora x FF','Ent Comp Decoracion','Ent. Comp. Dir. Cte.','Ent. Suministros FF','Entrada Compra','Entrada con Gastos','Entrada con Remision','Entrada Suministro'))'CantidadEntregada'
,(SELECT ISNULL(SUM(CompraD.Cantidad),0) FROM CompraD WHERE CompraD.ID=MovFlujo.DID AND CompraD.Articulo=TCompra.Articulo AND CompraD.SubCuenta=TCompra.SubCuenta AND CompraD.AplicaID=TCompra.MovID AND CompraD.Aplica=TCompra.Mov AND MovFlujo.Dmov in ('Compra Perdida','Compra Rechazada'))'CantidadPerdida'
FROM
(
SELECT ComprA.ID,Compra.Mov,Compra.MovID,CAST(Compra.FechaEmision AS DATE)FEmision,Compra.Estatus,Compra.Proveedor,CompraD.Articulo,Art.Descripcion1,CompraD.SubCuenta,(ISNULL(SUM(CompraD.Cantidad),0)-ISNULL(SUM(CompraD.CantidadCancelada),0))Cantidad
FROM Compra 
INNER JOIN CompraD ON Compra.ID=CompraD.ID
INNER JOIN Art ON CompraD.Articulo=Art.Articulo
WHERE Compra.Mov in ('OC con Remision','OC Decoracion','OC Electronica','OC Gen. Dir. al Cte.','OC Generales','OC Merc Dir. al Cte.','OC Merceria','OC Ropa','OC Ropa Dir. al Cte.','OC Suministros','OC Tela Dir. al Cte.','OC Telas','Orden Compra','Orden Compra Emida,')
AND Compra.Estatus NOT IN ('CANCELADO','SINAFECTAR') AND Compra.Proveedor=@TProv AND CAST(Compra.FechaEmision AS DATE) BETWEEN @TFinicio AND @TFfinal 
--and compra.id in (10815,10823)
GROUP BY Compra.ID,Compra.Mov,Compra.MovID,Compra.FechaEmision,Compra.Estatus,Compra.Proveedor,CompraD.Articulo,Art.Descripcion1,CompraD.SubCuenta
--ORDER BY Compra.ID
)TCompra 
iNNER JOIN MovFlujo ON TCompra.ID=MovFlujo.OID AND TCompra.MovID=MovFlujo.OMovID AND MovFlujo.OModulo='COMS' AND MovFlujo.Cancelado=0 
)TOc GROUP BY TOc.ID,TOc.MovID,TOc.Mov,TOc.Estatus,TOc.Articulo,TOc.Descripcion1,TOc.SubCuenta,TOc.Cantidad --ORDER BY TOc.ID,TOc.Articulo,TOc.SubCuenta

UNION ALL
--////////////////////////codigo parar importacion solo faltaria el de orden con gastos ///////////////////////////////////////////////////////////////////////////////////
SELECT TImpo.ID,TImpo.MovID,TImpo.Mov,TImpo.Estatus,TImpo.Articulo,TImpo.Descripcion1,TImpo.SubCuenta,TImpo.Cantidad,SUM(TImpo.CantidadEntregada)CantidadEntregada,SUM(TImpo.CantidadPerdida)CantidadPerdida FROM(
SELECT TCompra.ID,TCompra.Mov,TCompra.MovID,TCompra.FEmision,TCompra.Estatus,TCompra.Proveedor,TCompra.Articulo,TCompra.Descripcion1,TCompra.SubCuenta,TCompra.Cantidad,MovFlujo.DMov'MovR',MovFlujo.DMovID'MovIDR',MovFlujo.DID'IDR',M2.DMov'MovE',M2.DMovID'MovIDE',M2.DID'IDE'
,(SELECT IsNULL(SUM(CompraD.Cantidad),0) FROM CompraD WHERE CompraD.ID=M2.DID AND CompraD.Articulo=TCompra.Articulo AND CompraD.SubCuenta=TCompra.SubCuenta AND CompraD.AplicaID=M2.OMovID AND CompraD.Aplica='Recep. Importacion' AND M2.DMov in ('Entrada Importacion'))'CantidadEntregada'
,(SELECT ISNULL(SUM(CompraD.Cantidad),0) FROM CompraD WHERE CompraD.ID=MovFlujo.DID AND CompraD.Articulo=TCompra.Articulo AND CompraD.SubCuenta=TCompra.SubCuenta AND CompraD.AplicaID=TCompra.MovID AND CompraD.Aplica=TCompra.Mov AND MovFlujo.Dmov in ('Compra Perdida'))'CantidadPerdida'
FROM
(SELECT ComprA.ID,Compra.Mov,Compra.MovID,CAST(Compra.FechaEmision AS DATE)FEmision,Compra.Estatus,Compra.Proveedor,CompraD.Articulo,Art.Descripcion1,CompraD.SubCuenta,(ISNULL(SUM(CompraD.Cantidad),0)-ISNULL(SUM(CompraD.CantidadCancelada),0))Cantidad
FROM Compra 
INNER JOIN CompraD ON Compra.ID=CompraD.ID
INNER JOIN Art ON CompraD.Articulo=Art.Articulo
WHERE Compra.Mov in ('OC Import. Electroni','OC Import. Generales','OC Import. Merceria','OC Import. Ropa','OC Import. Telas','OG Ropa Import.')
AND Compra.Estatus NOT IN ('CANCELADO','SINAFECTAR') AND Compra.Proveedor=@TProv AND CAST(Compra.FechaEmision AS DATE) BETWEEN @TFinicio AND @TFfinal 
--and compra.id in (10815,10823)
GROUP BY Compra.ID,Compra.Mov,Compra.MovID,Compra.FechaEmision,Compra.Estatus,Compra.Proveedor,CompraD.Articulo,Art.Descripcion1,CompraD.SubCuenta
--ORDER BY Compra.ID
)TCompra 
iNNER JOIN MovFlujo ON TCompra.ID=MovFlujo.OID AND TCompra.MovID=MovFlujo.OMovID AND MovFlujo.OModulo='COMS' AND MovFlujo.Cancelado=0 
LEFT JOIN MovFlujo AS M2 ON MovFlujo.DID=M2.OID AND MovFlujo.DMovID=M2.OMovID AND M2.OModulo='COMS' AND M2.OMov='Recep. Importacion' AND M2.Cancelado=0
)TImpo GROUP BY TImpo.ID,TImpo.MovID,TImpo.Mov,TImpo.Estatus,TImpo.Articulo,TImpo.Descripcion1,TImpo.SubCuenta,TImpo.Cantidad --ORDER BY TImpo.ID,TImpo.Articulo,TImpo.SubCuenta

----)Borrame
--order by Borrame.TID
ORDER BY TOc.ID,TOC.MovID,TOc.Articulo,TOc.SubCuenta

--END


/*
----///////////comparando luego borrar
select distinct ID,MovID,Mov ,CAST(Compra.FechaEmision AS DATE) from compra 
WHERE Mov in ('OC con Remision','OC Decoracion','OC Electronica','OC Gen. Dir. al Cte.','OC Generales','OC Merc Dir. al Cte.','OC Merceria','OC Ropa','OC Ropa Dir. al Cte.','OC Suministros','OC Tela Dir. al Cte.','OC Telas','Orden Compra','Orden Compra Emida,','OC Import. Electroni','OC Import. Generales','OC Import. Merceria','OC Import. Ropa','OC Import. Telas','OG Ropa Import.')
and Estatus NOT IN ('CANCELADO','SINAFECTAR')
and Proveedor='291' AND CAST(Compra.FechaEmision AS DATE) BETWEEN @TFinicio AND @TFfinal 
order by ID
*/

/*
exec SP_Temporal @TProv='291' ,@TFinicio='2017-01-02' ,@TFfinal='2017-04-30'
*/

--select * from compra where mov='Orden con Gastos' falto para validar codigo
--/////////ahora sacar inner a movflujo luego hacer un subselect

/* --el 10823 es porque tiene dos entradas
select id,mov,movid,FechaEmision,estatus from compra where id=10823
select articulo,SubCuenta,cantidad,aplica,AplicaID from compraD where id=10823 
order by Articulo,SubCuenta
select top 3 * from movflujo where omodulo='coms' and oid=10823

select id,mov,movid,FechaEmision,estatus from compra where id=10993
select articulo,SubCuenta,cantidad,aplica,AplicaID from compraD where id=10993 
order by Articulo,SubCuenta

select id,mov,movid,FechaEmision,estatus from compra where id=11135
select articulo,SubCuenta,cantidad,aplica,AplicaID from compraD where id=11135 
order by Articulo,SubCuenta
*/
--select top 3 * from art where articulo='33510'
--select distinct Dmov from CfgMovFlujo where Omov in ('Orden Compra','OC Consig. Merceria','OC Consig. Ropa','OC Decoracion','OC Electronica','OC Generales','OC Import. Merceria','OC Import. Telas','OC Merc Dir. al Cte.','OC Merceria','OC Ropa','OC Tela Dir. al Cte.','OC Telas')


--select distinct Dmov from CfgMovFlujo where Omov in ('OC con Remision','OC Decoracion','OC Electronica','OC Gen. Dir. al Cte.','OC Generales','OC Import. Electroni','OC Import. Generales','OC Import. Merceria','OC Import. Ropa','OC Import. Telas','OC Merc Dir. al Cte.','OC Merceria','OC Ropa','OC Ropa Dir. al Cte.','OC Suministros','OC Tela Dir. al Cte.','OC Telas','OG Ropa Import.','Orden Compra','Orden Compra Emida,','Orden con Gastos')
--select distinct Dmov from CfgMovFlujo where Omov in ('OC con Remision','OC Decoracion','OC Electronica','OC Gen. Dir. al Cte.','OC Generales','OC Merc Dir. al Cte.','OC Merceria','OC Ropa','OC Ropa Dir. al Cte.','OC Suministros','OC Tela Dir. al Cte.','OC Telas','Orden Compra','Orden Compra Emida,')
--select distinct Dmov from CfgMovFlujo where Omov in ('OC Import. Electroni','OC Import. Generales','OC Import. Merceria','OC Import. Ropa','OC Import. Telas','OG Ropa Import.') --buscar segundo mov que es entrada impo
--select distinct Dmov from CfgMovFlujo where Omov in ('Orden con Gastos')--validar mas flujopara entrada

--select distinct Dmov from CfgMovFlujo where Omov in ('Compra Perdida')
--select distinct Dmov from CfgMovFlujo where Omov in ('EG Ropa')
--select distinct Dmov from CfgMovFlujo where Omov in ('Entrada Importacion')
--,'Compra Rechazada'
--,'Ent. Comp. Dir. Cte.'
--,'Ent. Suministros FF'
--,'Entrada Compra'
--,'Entrada con Gastos'
--,'Entrada Suministro')