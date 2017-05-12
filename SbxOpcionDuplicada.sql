/*
MUESTRA LAS NOTAS QUE TIENEN OPCIONES DUPLICADAS, PARA CORREGIRLAS SELECCIONAMOS DESDE EL UPDATE HASTA EL FINAL... Y AFECTAMOS
SE TIENE QUE EJECUTAR EN SBX_ASSIS
*/

select 
sd.id, ioh2.StoreID,sdd.id,sd.folio, sdd.Line, ic.ExternalID, sdd.ItemCode, sdd.Quantity, ioh.StoreID,
 ioh2.QuantityOnHand, ic.ExternalID, ic.id,sdd.ItemCombinationID ,ioh.combinationid,ioh.QuantityOnHand, ioh.ExternalID, sdd.ItemCode, sdd.SaleDocumentID
 ,sdd.ItemCombinationID ,ioh.combinationid, sdd.ItemCombinationUUID,  ioh.combinationuuid,sdd.InventoryOnHandDetailID
--update sdd set sdd.ItemCombinationID =ioh.combinationid, sdd.ItemCombinationUUID=  ioh.combinationuuid
from SaleDocumentdetail sdd
left join saledocument sd on sd.id = sdd.saledocumentid
left join ItemCombination ic on ic.id = sdd.ItemCombinationID
left join (
select ic.id combinationid, ic.UUID combinationuuid, ic.OptionDetail01ID, ic.OptionDetail02ID, ic.ExternalID, ioh.id, ioh.ItemID, ioh.QuantityOnHand, ioh.StoreID from inventoryonhand ioh
inner join ItemCombination ic on ic.id = ioh.itemcombinationid
) ioh on ioh.ItemID = sdd.ItemID and ioh.OptionDetail01ID = ic.OptionDetail01ID and ioh.StoreID = sd.StoreID
left join InventoryOnHand ioh2 on ioh2.ItemID = sdd.ItemID and ioh2.ItemCombinationID = sdd.ItemCombinationID and ioh2.storeid = sd.storeid
left join Assis..SBXLogTransaction sl on sl.UUID = sd.UUID
left join assis..venta v on v.id = sl.LocalID
left join ErpErrorLog el on el.TableID = sd.id 
where sd.ErpSendStatusID = 4
and ioh2.QuantityOnHand < 0
AND IOH.QuantityOnHand >=0
--and ic.ExternalID <> ''
--and sd.DocumentStatusID = 2
--and v.Estatus ='SINAFECTAR'
--and sd.uuid ='348FBBBA-DC74-448A-BEEC-72293B384A77'
--and sd.id in (select tableid from ErpErrorLog where (ErrorDescription like 'El Movimiento ya fue afectado por otro usuario Not%' )and TableName ='Saledocument')
and v.Estatus in('SINAFECTAR')