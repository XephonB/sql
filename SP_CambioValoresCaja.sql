CREATE PROCEDURE SP_CambioValoresCaja @Finicio date, @FFinal date
AS BEGIN 
----/////////////////try me /////////////////////
--DECLARE @Finicio date , @FFinal date
--SET @Finicio='2017-06-30'
--SET @FFinal='2017-06-30'
----////////////////////////////////////////////
SELECT CAST(Dinero.FechaEmision AS date)FechaEmision,Dinero.Sucursal'TSucursal',Dinero.CtaDinero'TCtaDinero',Dinero.Usuario'TUsuario',Dinero.Mov'TMov',Dinero.MovID'TMovID',Dinero.Moneda'TMoneda',Dinero.TipoCambio'TipoCambio',Dinero.Importe'TImporte'
,'Total'=CASE WHEN Dinero.Mov='Ingre Cambio Moneda' THEN Dinero.TipoCambio*Dinero.Importe WHEN Dinero.Mov='Egre Cambio Moneda' THEN -1*Dinero.TipoCambio*Dinero.Importe ELSE 0 END
FROM Dinero WHERE Dinero.Mov IN ('Ingre Cambio Moneda','Egre Cambio Moneda') AND Dinero.Estatus='CONCLUIDO' AND CAST(Dinero.FechaEmision AS date) BETWEEN @Finicio AND @FFinal
END

/*
exec SP_CambioValoresCaja @Finicio='2017-06-30', @FFinal='2017-06-30'
*/