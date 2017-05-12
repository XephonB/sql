/*
query que corrige el problema de lotes que se venden y no tienen existencia en el almacen de la sucursal, 
este query lo tienen que ejecutar en la base de la tienda que presente problemas de este tipo:
*/

/*
update sdd set sdd.ItemCombinationID =ioh.combinationid, sdd.ItemCombinationUUID=  ioh.combinationuuid, sdd.InventoryOnHandDetailID =  iohd2.id, sdd.InventoryOnHandDetailUUID = iohd2.UUID
from saledocumentdetail sdd
inner join sync s on s.uuid = sdd.uuid
left join itemcombination ic on ic.uuid = sdd.itemcombinationuuid
left join (
select ic.id combinationid, ic.UUID combinationuuid, ic.OptionDetail01ID, ic.ExternalID, ioh.id, ioh.ItemID from inventoryonhand ioh
inner join ItemCombination ic on ic.id = ioh.itemcombinationid
) ioh on ioh.ItemID = sdd.ItemID and ioh.OptionDetail01ID = ic.OptionDetail01ID
left join inventoryonhanddetail iohd on iohd.uuid = sdd.InventoryOnHandDetailuuID
left join InventoryOnHandDetail iohd2 on iohd2.Batch = sdd.Batch and iohd2.InventoryOnHandID = ioh.id 
where tablename = 'SALEDOCUMENTDETAIL' 
and iohd.uuid is null 
and coalesce(sdd.InventoryOnHanddetailUUID,'') <> ''
*/

select sdd.ItemCombinationID, ioh.combinationid, sdd.ItemCombinationUUID, ioh.combinationuuid, sdd.InventoryOnHandDetailID, iohd2.id, sdd.InventoryOnHandDetailUUID, iohd2.UUID
from saledocumentdetail sdd
inner join sync s on s.uuid = sdd.uuid
left join itemcombination ic on ic.uuid = sdd.itemcombinationuuid
left join (
select ic.id combinationid, ic.UUID combinationuuid, ic.OptionDetail01ID, ic.ExternalID, ioh.id, ioh.ItemID from inventoryonhand ioh
inner join ItemCombination ic on ic.id = ioh.itemcombinationid
) ioh on ioh.ItemID = sdd.ItemID and ioh.OptionDetail01ID = ic.OptionDetail01ID
left join inventoryonhanddetail iohd on iohd.uuid = sdd.InventoryOnHandDetailuuID
left join InventoryOnHandDetail iohd2 on iohd2.Batch = sdd.Batch and iohd2.InventoryOnHandID = ioh.id 
where tablename = 'SALEDOCUMENTDETAIL' 
and iohd.uuid is null 
and coalesce(sdd.InventoryOnHanddetailUUID,'') <> ''