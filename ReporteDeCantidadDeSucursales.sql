CREATE TABLE #ArCAnt
(
Articulo varchar(10),
Centro float,
Campeche float,
chetumal float,
playa float,
charly float,
kabah float
)
/*
insert into #ArCAnt (Articulo) values ('10220')
,('38805')
,('61841')
,('10284')
,('10283')
,('10155')
,('10156')
,('10152')
,('10154')
,('52549')
,('62871')
,('63597')
,('63590')
,('54280')
,('63599')
,('30076')
,('53211')
,('61382')
,('63445')
,('30079')
,('65755')
,('65759')
,('64712')
,('65485')
,('62163')
,('62159')
,('62162')
,('50012')
,('60217')
,('59903')
,('59719')
,('66138')
,('51461')
,('51446')
,('54200')
,('30452')
,('66140')
,('62235')
,('62236')
,('55499')
,('63859')
,('60145')
,('63848')
,('63852')
,('52402')
,('60471')
,('63845')
,('63546')
,('63785')
,('66136')
,('66137')
,('63543')
,('62237')
,('63544')
,('58393')
,('54335')
,('54330')
,('29513')
,('30513')
,('54531')
,('29546')
,('30348')
,('29667')
,('30419')
,('63545')
,('30504')
,('53225')
,('30162')
,('58395')
,('30347')
,('30282')
,('30283')
,('61473')
,('61472')
,('30276')
,('53896')
,('53897')
,('51735')
,('53893')
,('54090')
,('53892')
,('36343')
,('54665')
,('53894')
,('53895')
,('53891')
,('36342')
,('53890')
,('54339')
,('58805')
,('29774')
,('29849')
,('30053')
,('29675')
,('60663')
,('60666')
*/
insert into #ArCAnt (Articulo) values 
('10220')
,('38805')
,('61841')
,('10284')
,('10283')
,('10155')
,('10156')
,('10152')
,('10154')
,('52549')
,('62871')
,('63597')
,('63590')
,('54280')
,('63599')
,('30076')
,('53211')
,('61382')
,('63445')
,('30079')
,('65755')
,('65759')
,('64712')
,('65485')
,('62163')
,('62159')
,('62162')
,('50012')
,('60217')
,('59903')
,('59719')
,('66138')
,('51461')
,('51446')
,('54200')
,('30452')
,('66140')
,('62235')
,('62236')
,('55499')
,('63859')
,('60145')
,('63848')
,('63852')
,('52402')
,('60471')
,('63845')
,('63546')
,('63785')
,('66136')
,('66137')
,('63543')
,('62237')
,('63544')
,('58393')
,('54335')
,('54330')
,('29513')
,('30513')
,('54531')
,('29546')
,('30348')
,('29667')
,('30419')
,('63545')
,('30504')
,('53225')
,('30162')
,('58395')
,('30347')
,('30282')
,('30283')
,('61473')
,('61472')
,('30276')
,('53896')
,('53897')
,('51735')
,('53893')
,('54090')
,('53892')
,('36343')
,('54665')
,('53894')
,('53895')
,('53891')
,('36342')
,('53890')
,('54339')
,('58805')
,('29774')
,('29849')
,('30053')
,('29675')
,('60663')
,('60666')


select * from #ArCAnt

update #ArCAnt
set CENTRO=t1.Cantid
FROM(
select sum(SaldoU)Cantid,Cuenta,Grupo from SaldoU WITH(NOLOCK) where RAMA='INV' AND SaldoU<>0 and Grupo in ('CENTRO') and Cuenta in (select Articulo from #ArCAnt)
group by Cuenta,Grupo)t1
where Articulo=t1.Cuenta

update #ArCAnt
set Campeche=t1.Cantid
FROM(
select sum(SaldoU)Cantid,Cuenta,Grupo from SaldoU WITH(NOLOCK) where RAMA='INV' AND SaldoU<>0 and Grupo in ('CAMPECHE') and Cuenta in (select Articulo from #ArCAnt)
group by Cuenta,Grupo)t1
where Articulo=t1.Cuenta

update #ArCAnt
set chetumal=t1.Cantid
FROM(
select sum(SaldoU)Cantid,Cuenta,Grupo from SaldoU WITH(NOLOCK) where RAMA='INV' AND SaldoU<>0 and Grupo in ('CHETUMAL') and Cuenta in (select Articulo from #ArCAnt)
group by Cuenta,Grupo)t1
where Articulo=t1.Cuenta

update #ArCAnt
set playa=t1.Cantid
FROM(
select sum(SaldoU)Cantid,Cuenta,Grupo from SaldoU WITH(NOLOCK) where RAMA='INV' AND SaldoU<>0 and Grupo in ('PLAYACAR') and Cuenta in (select Articulo from #ArCAnt)
group by Cuenta,Grupo)t1
where Articulo=t1.Cuenta

update #ArCAnt
set charly=t1.Cantid
FROM(
select sum(SaldoU)Cantid,Cuenta,Grupo from SaldoU WITH(NOLOCK) where RAMA='INV' AND SaldoU<>0 and Grupo in ('CHARLY') and Cuenta in (select Articulo from #ArCAnt)
group by Cuenta,Grupo)t1
where Articulo=t1.Cuenta

update #ArCAnt
set kabah=t1.Cantid
FROM(
select sum(SaldoU)Cantid,Cuenta,Grupo from SaldoU WITH(NOLOCK) where RAMA='INV' AND SaldoU<>0 and Grupo in ('KABAH') and Cuenta in (select Articulo from #ArCAnt)
group by Cuenta,Grupo)t1
where Articulo=t1.Cuenta


select * from #ArCAnt
--drop table #ArCAnt

select Articulo,isnull(Centro,0)Cen,isnull(Campeche,0)Camp,isnull(Chetumal,0)Chet,isnull(playa,0)Pla,isnull(charly,0)Charl, isnull(kabah,0)Kab from #ArCAnt


--select DISTINCT GRUPO from SaldoU WHERE rama='INV'

SELECT * FROM sALDOu WHERE rAMA='INV' AND Cuenta='60217' AND SaldoU<>0