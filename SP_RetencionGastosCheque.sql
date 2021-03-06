USE [Assis]
GO
/****** Object:  StoredProcedure [dbo].[SP_RetencionGastosCheque]    Script Date: 13/09/2017 11:46:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_RetencionGastosCheque] @fechadesde varchar (10),@fechaHasta varchar (10)
as begin
------------------------------RETENCION GASTOS DESDE CHEQUE----------
--Declare @fechadesde varchar (10)
--        set @fechadesde='01/06/2016'
--Declare @fechaHasta varchar (10)
--        set @fechaHAsta='30/06/2016'
---///////////////////////////////////////////////////////////////////////////////

--DECLARE @Tabla Table(
--Mov varchar(20),
--MovID varchar(20),
--Estatus varchar(50),
--Importe money,
--Mov1 varchar(20),
--MovID1 varchar(20),
--Importe1 money,
--Concepto varchar(50),
--Importe2 money,
--Impuestos money,
--Retencion money,
--Retencion2 money,
--Retencion3 money
--)
--INSERT INTO @Tabla


select CAST(a.FechaEmision AS date)'FechaE', a.Mov,a.MovID,a.estatus,a.Importe, a.BeneficiarioNombre 'BN',ISNULL(Prov.RFC,'')'tRFC',a.CtaDinero 'CD'
,e.Mov 'Mov1',e.MovID 'MovID1',e.Importe 'Importe1',f.Concepto,f.importe 'Importe2',f.impuestos,isnull(f.Retencion,0)'Retencion',isnull(f.Retencion2,0)'Retencion2',isnull(f.retencion3,0)'Retencion3'
from Dinero a 
left join Dinero b on a.origen=b.mov and a.OrigenID=b.movid 
left join Cxp c on b.Origen=c.Mov and b.OrigenID=c.movid 
left join Cxp d on c.Origen=d.Mov and c.OrigenID=d.movid 
left join Gasto e on d.Origen=e.Mov and d.OrigenID=e.movid 
left join GastoD f on e.ID=f.id
LEFT JOIN Prov ON a.Contacto=Prov.Proveedor
where a.Mov='cheque' and CAST(a.FechaEmision AS DATE)>=@fechadesde and CAST(a.FechaEmision AS DATE)<=@fechaHAsta  and a.Estatus<>'cancelado' and e.Mov='gasto' and (f.Retencion>0 or f.Retencion2>0 or f.Retencion3>0 or f.impuestos>0)
order by a.MovID 



--SELECT * FROM @Tabla
END

/*
EXEC SP_RetencionGastosCheque @fechadesde='01/06/2016',@fechaHasta='30/06/2016'

*/