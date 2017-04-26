CREATE PROCEDURE SP_VentasHaffir2 @Finicio DATE, @Ffinal DATE

AS BEGIN
----borrar
--DECLARE @Finicio DATE, @Ffinal DATE
--SET @Finicio='2016-01-12'
--SET @Ffinal='2017-08-12'
----borrar

SELECT Importe,Saldo,FechaEmision,MovID,Mov,EnviarA,Nombre,
'Estatus'=CASE WHEN EstatusCxc='' THEN Estatus ELSE EstatusCxc END,
'MovPago'=CASE WHEN Condicion='Contado' THEN Condicion ELSE MovPago END,MovIDPago
 FROM(
	SELECT (Venta.Importe+Venta.Impuestos)Importe,CAST(Venta.FechaEmision AS DATE)FechaEmision,Venta.MovID,Venta.Mov,ISNULL(Venta.EnviarA,'')EnviarA,ISNULL(CteEnviarA.Nombre,'')Nombre,Venta.Estatus,Venta.Condicion
	,ISNULL((SELECT C.Saldo FROM Cxc C WHERE C.MovID=Venta.MovID),'')Saldo
	--,MF1.DID,MF1.DMovID--BORRAR
	,ISNULL((SELECT Estatus FROM Cxc WHERE ID=MF1.DID),'')EstatusCxc
	,ISNULL(MF2.DMovID,'')MovIDPago,ISNULL(MF2.DMov,'')MovPago --Resultado de lo pagado
		FROM Venta  LEFT JOIN CteEnviarA ON Venta.EnviarA=CteEnviarA.ID AND Venta.Cliente=CteEnviarA.Cliente
		LEFT JOIN MovFlujo MF1 ON Venta.ID=MF1.OID AND Venta.Mov=MF1.OMov AND Venta.MovID=MF1.OMovID AND Venta.Mov=MF1.DMov AND MF1.Cancelado=0
		LEFT JOIN MovFlujo MF2 ON MF1.DID=MF2.OID AND MF1.DMov=MF2.OMov AND MF1.DMovID=MF2.OMovID AND MF2.Cancelado=0
		WHERE Venta.Cliente='PG001' AND Venta.Mov IN ('Factura','FacturaPromPzo Expo','Factura Mayoreo Inst','Factura Expo','Factura Prom. Plazo')
		AND CAST(Venta.FechaEmision AS date) BETWEEN @Finicio AND @Ffinal 
)TFa
ORDER BY FechaEmision,MovID --MAY26422 --1556574,MAY32316

END

/*
exec SP_VentasHaffir2 @Finicio='2016-08-12',@Ffinal='2016-08-12'
*/