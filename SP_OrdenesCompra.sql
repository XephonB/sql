--create PROCEDURE SP_Temporal @TProv varchar(10), @TFinicio date, @TFfinal date
--AS BEGIN 

DECLARE @TProv varchar(10), @TFinicio date, @TFfinal date
SET @TProv='291'
SET @TFinicio='2017-01-03'
SET @TFfinal='2017-01-03'

--SELECT * FROM (
SELECT	Tdos.ID,Tdos.MovID,Tdos.Estatus,Tdos.FEmision,Tdos.FRequerida,Tdos.FEEntrada,Tdos.DMov,Tdos.DMovID,Tdos.Articulo,Tdos.Descripcion1,Tdos.SubCuenta,Tdos.Cantidad'Ordenado',SUM(Tdos.CantidadEntregada)TRecibido,SUM(Tdos.CantidadPerdida)TPerdida 
FROM(
	SELECT Tuno.ID,Tuno.MovID,Tuno.FEmision,Tuno.FRequerida,Tuno.Estatus,Tuno.Articulo,Tuno.Descripcion1,Tuno.SubCuenta,Tuno.Cantidad,MovFlujo.DMov,MovFlujo.DMovID,MovFlujo.DID
	,(SELECT CAST(C1.FechaEmision as date) FROM Compra C1 WHERE C1.ID=MovFlujo.DID)FEEntrada
	,(SELECT IsNULL(SUM(C2.Cantidad),0) FROM CompraD C2 WHERE C2.ID=MovFlujo.DID AND C2.Articulo=Tuno.Articulo AND C2.SubCuenta=Tuno.SubCuenta AND C2.AplicaID=Tuno.MovID AND MovFlujo.DMov in ('Ent Comp Decora x FF','Ent Comp Decoracion','Ent. Comp. Dir. Cte.','Ent. Suministros FF','Entrada Compra','Entrada con Gastos','Entrada con Remision','Entrada Suministro'))'CantidadEntregada'
	,(SELECT ISNULL(SUM(C3.Cantidad),0) FROM CompraD C3 WHERE C3.ID=MovFlujo.DID AND C3.Articulo=Tuno.Articulo AND C3.SubCuenta=Tuno.SubCuenta AND C3.AplicaID=Tuno.MovID AND MovFlujo.Dmov in ('Compra Perdida','Compra Rechazada'))'CantidadPerdida'
	FROM
	(
		SELECT Compra.ID,Compra.MovID,CAST(Compra.FechaEmision AS DATE)FEmision,CAST(Compra.FechaRequerida AS date)FRequerida
		,Compra.Estatus,CompraD.Articulo,Art.Descripcion1,CompraD.SubCuenta,(ISNULL(SUM(CompraD.Cantidad),0)-ISNULL(SUM(CompraD.CantidadCancelada),0))Cantidad
		FROM Compra 
		INNER JOIN CompraD ON Compra.ID=CompraD.ID
		INNER JOIN Art ON CompraD.Articulo=Art.Articulo
		WHERE Compra.Mov in ('OC con Remision','OC Decoracion','OC Electronica','OC Gen. Dir. al Cte.','OC Generales','OC Merc Dir. al Cte.','OC Merceria','OC Ropa','OC Ropa Dir. al Cte.','OC Suministros','OC Tela Dir. al Cte.','OC Telas','Orden Compra','Orden Compra Emida,')
		AND Compra.Estatus NOT IN ('CANCELADO','SINAFECTAR') AND Compra.Proveedor=@TProv AND CAST(Compra.FechaEmision AS DATE) BETWEEN @TFinicio AND @TFfinal 
		GROUP BY Compra.ID,Compra.Mov,Compra.MovID,Compra.FechaEmision,Compra.FechaRequerida,Compra.Estatus,Compra.Proveedor,CompraD.Articulo,Art.Descripcion1,CompraD.SubCuenta
		HAVING (ISNULL(SUM(CompraD.Cantidad),0)-ISNULL(SUM(CompraD.CantidadCancelada),0))<>0
		--ORDER BY CompraD.Articulo,CompraD.SubCuenta
		)Tuno
iNNER JOIN MovFlujo ON Tuno.ID=MovFlujo.OID AND Tuno.MovID=MovFlujo.OMovID AND MovFlujo.OModulo='COMS' AND MovFlujo.Cancelado=0
)Tdos GROUP BY Tdos.ID,Tdos.MovID,Tdos.FEmision,Tdos.FRequerida,Tdos.FEEntrada,Tdos.DMov,Tdos.DMovID,Tdos.Estatus,Tdos.Articulo,Tdos.Descripcion1,Tdos.SubCuenta,Tdos.Cantidad 
--HAVING SUM(Tdos.CantidadEntregada)<>0 OR SUM(Tdos.CantidadPerdida)<>0
ORDER BY Tdos.ID,Tdos.Articulo,Tdos.SubCuenta



--UNION ALL
----////////////////////////codigo parar importacion solo faltaria el de orden con gastos ///////////////////////////////////////////////////////////////////////////////////
--SELECT TImpo.ID,TImpo.MovID,TImpo.Mov,TImpo.Estatus,TImpo.Articulo,TImpo.Descripcion1,TImpo.SubCuenta,TImpo.Cantidad,SUM(TImpo.CantidadEntregada)CantidadEntregada,SUM(TImpo.CantidadPerdida)CantidadPerdida 
--FROM(
--	SELECT TCompra.ID,TCompra.Mov,TCompra.MovID,TCompra.FEmision,TCompra.Estatus,TCompra.Proveedor,TCompra.Articulo,TCompra.Descripcion1,TCompra.SubCuenta,TCompra.Cantidad,MovFlujo.DMov'MovR',MovFlujo.DMovID'MovIDR',MovFlujo.DID'IDR',M2.DMov'MovE',M2.DMovID'MovIDE',M2.DID'IDE'
--	,(SELECT IsNULL(SUM(CompraD.Cantidad),0) FROM CompraD WHERE CompraD.ID=M2.DID AND CompraD.Articulo=TCompra.Articulo AND CompraD.SubCuenta=TCompra.SubCuenta AND CompraD.AplicaID=M2.OMovID AND CompraD.Aplica='Recep. Importacion' AND M2.DMov in ('Entrada Importacion'))'CantidadEntregada'
--	,(SELECT ISNULL(SUM(CompraD.Cantidad),0) FROM CompraD WHERE CompraD.ID=MovFlujo.DID AND CompraD.Articulo=TCompra.Articulo AND CompraD.SubCuenta=TCompra.SubCuenta AND CompraD.AplicaID=TCompra.MovID AND CompraD.Aplica=TCompra.Mov AND MovFlujo.Dmov in ('Compra Perdida'))'CantidadPerdida'
--	FROM
--	(SELECT ComprA.ID,Compra.Mov,Compra.MovID,CAST(Compra.FechaEmision AS DATE)FEmision,Compra.Estatus,Compra.Proveedor,CompraD.Articulo,Art.Descripcion1,CompraD.SubCuenta,(ISNULL(SUM(CompraD.Cantidad),0)-ISNULL(SUM(CompraD.CantidadCancelada),0))Cantidad
--		FROM Compra 
--		INNER JOIN CompraD ON Compra.ID=CompraD.ID
--		INNER JOIN Art ON CompraD.Articulo=Art.Articulo
--		WHERE Compra.Mov in ('OC Import. Electroni','OC Import. Generales','OC Import. Merceria','OC Import. Ropa','OC Import. Telas','OG Ropa Import.')
--		AND Compra.Estatus NOT IN ('CANCELADO','SINAFECTAR') AND Compra.Proveedor=@TProv AND CAST(Compra.FechaEmision AS DATE) BETWEEN @TFinicio AND @TFfinal 
--		--and compra.id in (10815,10823)
--		GROUP BY Compra.ID,Compra.Mov,Compra.MovID,Compra.FechaEmision,Compra.Estatus,Compra.Proveedor,CompraD.Articulo,Art.Descripcion1,CompraD.SubCuenta
--		--ORDER BY Compra.ID
--		)TCompra 
--iNNER JOIN MovFlujo ON TCompra.ID=MovFlujo.OID AND TCompra.MovID=MovFlujo.OMovID AND MovFlujo.OModulo='COMS' AND MovFlujo.Cancelado=0 
--LEFT JOIN MovFlujo AS M2 ON MovFlujo.DID=M2.OID AND MovFlujo.DMovID=M2.OMovID AND M2.OModulo='COMS' AND M2.OMov='Recep. Importacion' AND M2.Cancelado=0
--)TImpo GROUP BY TImpo.ID,TImpo.MovID,TImpo.Mov,TImpo.Estatus,TImpo.Articulo,TImpo.Descripcion1,TImpo.SubCuenta,TImpo.Cantidad --ORDER BY TImpo.ID,TImpo.Articulo,TImpo.SubCuenta
--ORDER BY TOc.ID,TOC.MovID,TOc.Articulo,TOc.SubCuenta

--END
