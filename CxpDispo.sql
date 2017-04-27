--CREATE PROCEDURE SP_ComprasMercanciaConsignacion @FechaD date, @FechaA date
--AS BEGIN

--Try me
Declare @FechaD date, @FechaA date;
SET @FechaD='01-01-2016'
SET @FechaA='01-03-2018'
--Try me

	SELECT Cxp.Proveedor,Prov.Nombre,SUM(Cxp.Importe)Importe,LEFT(CAST(Cxp.FechaEmision AS date),7)FechaEmision FROM Cxp 
	INNER JOIN Prov ON Cxp.Proveedor=Prov.Proveedor
	WHERE Cxp.Mov='Disposicion Consig.' 
	AND LEFT(CAST(Cxp.FechaEmision AS date),7) BETWEEN LEFT(@FechaD,7) AND LEFT(@FechaA,7)
	--AND (DATEPART(MONTH,Cxp.FechaEmision) = DATEPART(MONTH,@Fecha) AND DATEPART(YEAR,Cxp.FechaEmision) = DATEPART(YEAR,@Fecha))
	GROUP BY Cxp.Proveedor,Prov.Nombre,LEFT(CAST(Cxp.FechaEmision AS date),7)
	ORDER BY FechaEmision,Cxp.Proveedor;
--END

/*
EXEC SP_ComprasMercanciaConsignacion @FechaD='01-01-2017, @FechaA='01-03-2017'
*/
