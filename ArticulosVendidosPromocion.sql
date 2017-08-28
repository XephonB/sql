DECLARE @FechaI date, @FechaF date
SET @FechaI='2017-07-14'
SET @FechaF='2017-08-16'
--SET @FechaF='2017-08-16'

SELECT Articulo, SUM(Cantid)Cantid, Unidad FROM (
SELECT CAST(Venta.FechaEmision AS DATE)FechaE,Venta.Sucursal,VentaD.Articulo,
'Cantid'=CASE WHEN Venta.Mov in ('Cancelacion Factura','Devolucion Venta','Devolucion Global') THEN -1*VentaD.Cantidad ELSE VentaD.Cantidad END,VentaD.Unidad
FROM Venta 
INNER JOIN VentaD ON Venta.Id=VentaD.Id
WHERE CAST(Venta.FechaEmision AS DATE) BETWEEN @FechaI AND @FechaF  AND Venta.Estatus='CONCLUIDO' AND 
Venta.Mov in ('Cancelacion Factura','Devolucion Venta','Devolucion Global','Factura','Factura Global','Factura Mayoreo Inst','Factura POS','Factura PromPzo Expo','Factura Tesoreria','Factura Ventas Inst','Factura Prom. Plazo','Factura expo')
AND VentaD.Articulo in (
--////
'63357'
,'63361'
,'35621'
,'61621'
,'52548'
,'52547'
,'52549'
,'63059'
,'63057'
,'35663'
,'63057'
,'62677'
,'62223'
,'63697'
,'62380'
,'44812'
,'62372'
,'63043'
,'63693'
,'63107'
,'62429'
,'63694'
,'56946'
,'63162'
,'54685'
,'62377'
,'60602'
,'63046'
,'63455'
,'53313'
,'52111'
,'61968'
,'61956'
,'61951'
,'61337'
,'62252'
,'52725'
,'59383'
,'57860'
,'63363'
,'63065'
,'63061'
,'63176'
,'63246'
,'63244'
,'36181'
,'61789'
,'54251'
,'62408'
,'40775'
,'61783'
,'61856'
,'62235'
,'62236'
,'30203'
,'29883'
,'30379'
,'63589'
,'60595'
,'63588'
,'63587'
,'63766'
,'59719'
,'63539'
,'51561'
,'54200'
,'30452'
,'51446'
,'64136'
,'64138'
,'64137'
,'63546'
,'59724'
,'63540'
,'30367'
,'29596'
,'63544'
,'63543'
,'58393'
,'62237'
,'29798'
,'62873'
,'29796'
,'29666'
,'30419'
,'63545'
,'29667'
,'30504'
,'30162'
,'53225'
,'58395'
,'54531'
,'29546'
,'30086'
,'56352'
,'30543'
,'53214'
,'30096'
,'30092'
,'63599'
,'54280'
,'63590'
,'63597'
,'62871'
,'30276'
,'61474'
,'30282'
,'61472'
,'61473'
,'30283'
,'61745'
,'61744'
,'30518'
,'53220'
,'55421'
,'63784'
,'53203'
,'30057'
,'30438'
,'30439'
,'61741'
,'54346'
,'29717'
,'29714'
,'29716'
,'29715'
,'30514'
,'29496'
,'55882'
,'54528'
,'53889'
,'53896'
,'53897'
,'51735'
,'53893'
,'54090'
,'53892'
,'36343'
,'54665'
,'53894'
,'53895'
,'53891'
,'36342'
,'53890'
,'63847'
,'63851'
,'63850'
,'63852'
,'63846'
,'63853'
,'60475'
,'53988'
,'53990'
,'63849'
,'63848'
,'63843'
,'63841'
,'63844'
,'60143'
,'63854'
,'63858'
,'63855'
,'63857'
,'63856'
,'63859'
,'63861'
,'60462'
,'60463'
,'61522'
,'60465'
,'64851'
,'64851'
,'64853'
,'60217'
,'59903','50012'
--//
)
)T1 Group by Articulo,Unidad Order by Articulo,Unidad
 

 --select * from venta inner join VentaD ON Venta.Id=VentaD.Id
 --where Mov in ('Cancelacion Factura','Devolucion Venta') and CAST(Venta.FechaEmision AS DATE) BETWEEN @FechaI AND @FechaF  AND Venta.Estatus='CONCLUIDO' and articulo='10185'


