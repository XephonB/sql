create PROCEDURE SP_OrdenesCompra @TProv varchar(10), @TFinicio date, @TFfinal date
AS BEGIN 

--DECLARE @TProv varchar(10), @TFinicio date, @TFfinal date
--SET @TProv='291'
--SET @TFinicio='2017-01-03'
--SET @TFfinal='2017-03-20'

SELECT	Tdos.ID,Tdos.Mov,Tdos.MovID,Tdos.Estatus,Tdos.FEmision,Tdos.FRequerida,Tdos.FEEntrada,Tdos.DMov,Tdos.DMovID,Tdos.Articulo,Tdos.Descripcion1,Tdos.SubCuenta,Tdos.Cantidad'Ordenado',SUM(Tdos.CantidadEntregada)TRecibido,SUM(Tdos.CantidadPerdida)TPerdida 
FROM(
	SELECT Tuno.ID,Tuno.Mov,Tuno.MovID,Tuno.FEmision,Tuno.FRequerida,Tuno.Estatus,Tuno.Articulo,Tuno.Descripcion1,Tuno.SubCuenta,Tuno.Cantidad,MovFlujo.DMov,MovFlujo.DMovID,MovFlujo.DID
	,(SELECT CAST(C1.FechaEmision as date) FROM Compra C1 WHERE C1.ID=MovFlujo.DID)FEEntrada
	,(SELECT IsNULL(SUM(C2.Cantidad),0) FROM CompraD C2 WHERE C2.ID=MovFlujo.DID AND C2.Articulo=Tuno.Articulo AND C2.SubCuenta=Tuno.SubCuenta AND C2.AplicaID=Tuno.MovID AND MovFlujo.DMov in ('Ent Comp Decora x FF','Ent Comp Decoracion','Ent. Comp. Dir. Cte.','Ent. Suministros FF','Entrada Compra','Entrada con Gastos','Entrada con Remision','Entrada Suministro'))'CantidadEntregada'
	,(SELECT ISNULL(SUM(C3.Cantidad),0) FROM CompraD C3 WHERE C3.ID=MovFlujo.DID AND C3.Articulo=Tuno.Articulo AND C3.SubCuenta=Tuno.SubCuenta AND C3.AplicaID=Tuno.MovID AND MovFlujo.Dmov in ('Compra Perdida','Compra Rechazada'))'CantidadPerdida'
	FROM
	(
		SELECT Compra.ID,Compra.Mov,Compra.MovID,CAST(Compra.FechaEmision AS DATE)FEmision,CAST(Compra.FechaRequerida AS date)FRequerida
		,Compra.Estatus,CompraD.Articulo,Art.Descripcion1,CompraD.SubCuenta,(ISNULL(SUM(CompraD.Cantidad),0)-ISNULL(SUM(CompraD.CantidadCancelada),0))Cantidad
		FROM Compra 
		INNER JOIN CompraD ON Compra.ID=CompraD.ID
		INNER JOIN Art ON CompraD.Articulo=Art.Articulo
		WHERE Compra.Mov in ('OC con Remision','OC Decoracion','OC Electronica','OC Gen. Dir. al Cte.','OC Generales','OC Merc Dir. al Cte.','OC Merceria','OC Ropa','OC Ropa Dir. al Cte.','OC Suministros','OC Tela Dir. al Cte.','OC Telas','Orden Compra','Orden Compra Emida,')
		AND Compra.Estatus NOT IN ('CANCELADO','SINAFECTAR') AND Compra.Proveedor=@TProv AND CAST(Compra.FechaEmision AS DATE) BETWEEN @TFinicio AND @TFfinal 
		GROUP BY Compra.ID,Compra.Mov,Compra.MovID,Compra.FechaEmision,Compra.FechaRequerida,Compra.Estatus,Compra.Proveedor,CompraD.Articulo,Art.Descripcion1,CompraD.SubCuenta
		HAVING (ISNULL(SUM(CompraD.Cantidad),0)-ISNULL(SUM(CompraD.CantidadCancelada),0))<>0
		)Tuno
iNNER JOIN MovFlujo ON Tuno.ID=MovFlujo.OID AND Tuno.MovID=MovFlujo.OMovID AND MovFlujo.OModulo='COMS' AND MovFlujo.Cancelado=0
)Tdos GROUP BY Tdos.ID,Tdos.Mov,Tdos.MovID,Tdos.FEmision,Tdos.FRequerida,Tdos.FEEntrada,Tdos.DMov,Tdos.DMovID,Tdos.Estatus,Tdos.Articulo,Tdos.Descripcion1,Tdos.SubCuenta,Tdos.Cantidad 
HAVING SUM(Tdos.CantidadEntregada)<>0 OR SUM(Tdos.CantidadPerdida)<>0

UNION ALL
--////////////////////////codigo parar importacion solo faltaria el de orden con gastos ///////////////////////////////////////////////////////////////////////////////////
SELECT TdosB.ID,TdosB.Mov,TdosB.MovID,TdosB.Estatus,TdosB.FEmision,TdosB.FRequerida,TdosB.FEEntrada,TdosB.DMov,TdosB.DMovID,TdosB.Articulo,TdosB.Descripcion1,TdosB.SubCuenta,TdosB.Cantidad,SUM(TdosB.CantidadEntregada)CantidadEntregada,SUM(TdosB.CantidadPerdida)CantidadPerdida 
FROM(
	SELECT TunoB.ID,TunoB.Mov,TunoB.MovID,TunoB.FEmision,TunoB.FRequerida,TunoB.Estatus,TunoB.Articulo,TunoB.Descripcion1,TunoB.SubCuenta,TunoB.Cantidad,M2.DMov,M2.DMovID,M2.DID
	,(SELECT CAST(c2c.FechaEmision as date) FROM Compra c2c WHERE c2c.ID=M2.DID)FEEntrada
	,(SELECT IsNULL(SUM(c2a.Cantidad),0) FROM CompraD c2a WHERE c2a.ID=M2.DID AND c2a.Articulo=TunoB.Articulo AND c2a.SubCuenta=TunoB.SubCuenta AND c2a.AplicaID=M2.OMovID AND c2a.Aplica='Recep. Importacion' AND M2.DMov in ('Entrada Importacion'))'CantidadEntregada'
	,(SELECT ISNULL(SUM(c2b.Cantidad),0) FROM CompraD c2b WHERE c2b.ID=MovFlujo.DID AND c2b.Articulo=TunoB.Articulo AND c2b.SubCuenta=TunoB.SubCuenta AND c2b.AplicaID=TunoB.MovID AND c2b.Aplica=TunoB.Mov AND MovFlujo.Dmov in ('Compra Perdida'))'CantidadPerdida'
	FROM
	(SELECT ComprA.ID,Compra.Mov,Compra.MovID,CAST(Compra.FechaEmision AS DATE)FEmision,CAST(Compra.FechaRequerida AS DATE)FRequerida,Compra.Estatus,Compra.Proveedor,CompraD.Articulo,Art.Descripcion1,CompraD.SubCuenta,(ISNULL(SUM(CompraD.Cantidad),0)-ISNULL(SUM(CompraD.CantidadCancelada),0))Cantidad
		FROM Compra 
		INNER JOIN CompraD ON Compra.ID=CompraD.ID
		INNER JOIN Art ON CompraD.Articulo=Art.Articulo
		WHERE Compra.Mov in ('OC Import. Electroni','OC Import. Generales','OC Import. Merceria','OC Import. Ropa','OC Import. Telas','OG Ropa Import.')
		AND Compra.Estatus NOT IN ('CANCELADO','SINAFECTAR') AND Compra.Proveedor=@TProv AND CAST(Compra.FechaEmision AS DATE) BETWEEN @TFinicio AND @TFfinal 
		GROUP BY Compra.ID,Compra.Mov,Compra.MovID,Compra.FechaEmision,Compra.FechaRequerida,Compra.Estatus,Compra.Proveedor,CompraD.Articulo,Art.Descripcion1,CompraD.SubCuenta
		HAVING (ISNULL(SUM(CompraD.Cantidad),0)-ISNULL(SUM(CompraD.CantidadCancelada),0))<>0
		)TunoB 
iNNER JOIN MovFlujo ON TunoB.ID=MovFlujo.OID AND TunoB.MovID=MovFlujo.OMovID AND MovFlujo.OModulo='COMS' AND MovFlujo.Cancelado=0 
LEFT JOIN MovFlujo AS M2 ON MovFlujo.DID=M2.OID AND MovFlujo.DMovID=M2.OMovID AND M2.OModulo='COMS' AND M2.OMov='Recep. Importacion' AND M2.Cancelado=0
)TdosB GROUP BY TdosB.ID,TdosB.MovID,TdosB.Mov,TdosB.Estatus,TdosB.FEmision,TdosB.FRequerida,TdosB.FEEntrada,TdosB.DMov,TdosB.DMovID,TdosB.Articulo,TdosB.Descripcion1,TdosB.SubCuenta,TdosB.Cantidad 
HAVING SUM(TdosB.CantidadEntregada)<>0 OR SUM(TdosB.CantidadPerdida)<>0
ORDER BY ID,Articulo,SubCuenta--,DMovID

END
/*
exec SP_OrdenesCompra @TProv='291', @TFinicio='2017-01-03', @TFfinal='2017-01-03'
*/