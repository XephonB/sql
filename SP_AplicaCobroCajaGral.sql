CREATE PROCEDURE SP_AplicaCobroCajaGral @Fecha varchar(10)
AS BEGIN
----/////////////TRY ME
--declare @Fecha varchar(10)
--set @Fecha = '2017-01-02'
----///////////

SELECT CxC.Mov,CxC.MovID,Cast(CxC.FechaEmision AS date)'FEmision',CxC.FormaCobro,CxcD.Aplica,CxcD.AplicaID,CxcD.Importe 
FROM CxC INNER JOIN CxCD ON Cxc.ID=CxcD.ID
WHERE CxC.Estatus='CONCLUIDO' AND CAST(CxC.FechaEmision AS date)=@Fecha AND CxC.Mov='Cobro en Caja Gral' 
ORDER BY CxC.MovID

END
--EXEC SP_AplicaCobroCajaGral @Fecha='2017-01-02'