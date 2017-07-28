USE SBX_Assis
GO
--DECLARE @Folio varchar(20)
--set @Folio='CHE151638'
--select ErpSendStatusID,ErpDocumentID,* from saledocument where Folio in('NTE130554')
--select * from ErpErrorLog where TableID in(select ID from saledocument where Folio in(@Folio))
--update SaleDocument set ErpSendStatusID=3,ErpDocumentID='AfectacionManual' where Folio in(@Folio)
--delete from ErpErrorLog where TableID in(select ID from saledocument where Folio in(@Folio))

SELECT saledocument.ErpSendStatusID,saledocument.ErpDocumentID,saledocument.Folio,saledocument.ID FROM saledocument 
WHERE ID in(SELECT tableID FROM ErpErrorLog WHERE ErrorDescription like 'El Movimiento ya fue afectado por otro usuario%')
SELECT ID FROM ErpErrorLog WHERE ErrorDescription like 'El Movimiento ya fue afectado por otro usuario%'
--////////////////////////////Actualizacion y borrado del registro ///////////////////////////////////////////////////
/*
UPDATE SaleDocument set ErpSendStatusID=3,ErpDocumentID='AfectacionManual'
WHERE ID in(SELECT tableID FROM ErpErrorLog WHERE ErrorDescription like 'El Movimiento ya fue afectado por otro usuario%')
DELETE from ErpErrorLog WHERE ErrorDescription like 'El Movimiento ya fue afectado por otro usuario%'
*/
--////////////////////////////////////////FIN////////////////////////////////////////////////