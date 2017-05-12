select ErpSendStatusID,ErpDocumentID,* from saledocument where Folio in('CHE139697','CHE139803','CHE139779')
--update SaleDocument set ErpSendStatusID=3,ErpDocumentID='AfectacionManual' where Folio in('NTE112802','CHA352639')
select * from ErpErrorLog where TableID in(1315764,1315945)
--delete from ErpErrorLog where TableID in(1315764,1315945)