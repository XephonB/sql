--ALTER PROCEDURE [dbo].[SP_ComiMay] @Finicio DATE, @Ffinal DATE
--AS BEGIN

--/*
DECLARE @Finicio DATE, @Ffinal DATE, @Sucursal CHAR
SET @Finicio='2017-07-01'
SET @Ffinal='2017-07-31'
--*/

CREATE TABLE #ObD
(Tid int,
Tage varchar(10),
TAno varchar(100),
Tusr varchar(10),
TNsr varchar(100),
TUag varchar(10),
Temi date,
Tsuc int,
Tnom varchar(100),
Timp money,
Tits money,
Tcan float,
Tart varchar(20),
TDesL money,
Tsub varchar(50),
Tpre float,
Tare varchar(20),
TCon varchar(50)
);
--SELECT DefAgente FROM Usuario WHERE Usuario=''

INSERT INTO #ObD --- Ventas Mayoreo por contado o Credito
	SELECT V.ID,V.Agente,Ag.Nombre,V.Usuario,U.Nombre,'Valida'=CASE WHEN U.DefAgente IS NULL THEN '' ELSE U.DefAgente END,
	CAST(V.FechaEmision AS DATE),V.Sucursal,S.Nombre,V.Importe,V.Impuestos,VD.Cantidad,VD.Articulo,
	'Desc'=CASE WHEN VD.DescuentoLinea IS NULL THEN 1 WHEN VD.DescuentoLinea=0 THEN 1 ELSE (100-VD.DescuentoLinea)/100 END ,
	'Subc'=CASE WHEN VD.SubCuenta IS NULL THEN '' ELSE VD.SubCuenta END,VD.Precio,left(A.Rama,2),left(V.Condicion,7)
	FROM Venta AS V
	INNER JOIN VentaD AS VD ON V.ID=VD.ID
	INNER JOIN ART AS A ON VD.Articulo=A.Articulo
	INNER JOIN Sucursal AS S ON V.Sucursal=S.Sucursal
	INNER JOIN Agente AS Ag ON V.Agente=Ag.Agente --BORRAR
	             and V.Agente in ('E147','E99') --asta aqui BORRAR
	LEFT JOIN Usuario AS U ON V.Usuario=U.Usuario
	WHERE 
	 VD.ID IN(SELECT V.ID
					FROM Venta AS V
					INNER JOIN Sucursal AS S ON V.Sucursal=S.Sucursal
					WHERE 
					V.Mov in ('Factura','Factura Prom. Plazo','Factura expo','Factura PromPzo Expo','Factura Mayoreo Inst','Factura Ventas Inst') AND V.Estatus='CONCLUIDO' AND V.Empresa='ASSIS' AND 
					V.Concepto NOT IN ('Venta Menudeo','Ventas Piso Menudeo','Ventas Decoracion')
					AND CAST(V.FechaEmision AS DATE) BETWEEN @Finicio AND @Ffinal
					)
				
UNION ALL
SELECT Vf.ID,V.Agente,A1.Nombre,V.Usuario,U1.Nombre,'N',CAST(Vf.FechaEmision AS DATE),Vf.Sucursal,S.Nombre,Vf.Importe,Vf.Impuestos,Vd.Cantidad,Vd.Articulo,
'Des'=CASE WHEN Vd.DescuentoLinea IS NULL THEN 1 WHEN Vd.DescuentoLinea=0 THEN 1 ELSE (100-Vd.DescuentoLinea)/100 END ,
'Subc'=CASE WHEN Vd.SubCuenta IS NULL THEN '' ELSE Vd.SubCuenta END,Vd.Precio,LEFT(A0.Rama,2),LEFT(Vf.Condicion,7)
FROM Venta AS V
INNER JOIN MovFlujo AS M1 ON M1.Empresa='ASSIS' AND M1.OModulo='VTAS' AND M1.Cancelado=0 AND M1.DMov='Orden Surtido' AND M1.OID=V.ID AND M1.OMovID=v.MovID
INNER JOIN MovFlujo AS M2 ON M2.Empresa='ASSIS' AND M2.OModulo='VTAS' AND M2.Cancelado=0 AND M2.DMov='Surtido' AND M2.OID=M1.DID AND M2.OMovID=M1.DMovID
INNER JOIN MovFlujo AS M3 ON M3.Empresa='ASSIS' AND M3.OModulo='VTAS' AND M3.Cancelado=0 AND M3.DMov='Chequeo y Empaque' AND M3.OID=M2.DID AND M3.OMovID=M2.DMovID
INNER JOIN MovFlujo AS M4 ON M4.Empresa='ASSIS' AND M4.OModulo='VTAS' AND M4.Cancelado=0 AND M4.DMov='Factura' AND M4.OID=M3.DID AND M4.OMovID=M3.DMovID
INNER JOIN Venta AS Vf ON Vf.ID=M4.DID AND Vf.MovID=M4.DMovID AND Vf.Empresa='ASSIS' AND Vf.Estatus='CONCLUIDO' AND CAST(Vf.FechaEmision AS DATE) BETWEEN @Finicio AND @Ffinal
INNER JOIN Agente AS A1 ON V.Agente=A1.Agente --BORRAR
	       and V.Agente in ('E147','E99') --asta aqui BORRAR
LEFT JOIN Usuario AS U1 ON V.Usuario=U1.Usuario
INNER JOIN Sucursal AS S ON Vf.Sucursal=S.Sucursal
INNER JOIN VentaD AS Vd ON Vf.ID=Vd.ID
INNER JOIN Art AS A0 ON Vd.Articulo=A0.Articulo
	WHERE V.Mov='PEDIDO' AND V.Estatus='CONCLUIDO'  AND V.Empresa='ASSIS' AND (
(V.Usuario='MAYTELE01' AND V.Agente<>'E28') OR (V.Usuario='MAYTELE02' AND V.Agente<>'E29') OR (V.Usuario='MAYTELE03' AND V.Agente<>'E30') )
					
INSERT INTO #ObD --Devoluciones que restan en negativo

	SELECT V.ID,V.Agente,Ag.Nombre,V.Usuario,U.Nombre,'Valida'=CASE WHEN U.DefAgente IS NULL THEN '' ELSE U.DefAgente END,
	CAST(V.FechaEmision AS DATE),V.Sucursal,S.Nombre,V.Importe,V.Impuestos,VD.Cantidad,VD.Articulo,
	'Desc'=CASE WHEN VD.DescuentoLinea IS NULL THEN 1 WHEN VD.DescuentoLinea=0 THEN 1 ELSE (100-VD.DescuentoLinea)/100 END ,
	'Subc'=CASE WHEN VD.SubCuenta IS NULL THEN '' ELSE VD.SubCuenta END,VD.Precio*-1,left(A.Rama,2),left(V.Condicion,7)
	FROM Venta AS V
	INNER JOIN VentaD AS VD ON V.ID=VD.ID
	INNER JOIN ART AS A ON VD.Articulo=A.Articulo
	INNER JOIN Sucursal AS S ON V.Sucursal=S.Sucursal
	INNER JOIN Agente AS Ag ON V.Agente=Ag.Agente --BORRAR
	               and V.Agente in ('E147','E99') --asta aqui BORRAR
	LEFT JOIN Usuario AS U ON V.Usuario=U.Usuario
	WHERE 
	 VD.ID IN(SELECT V.ID
					FROM Venta AS V
					INNER JOIN Sucursal AS S ON V.Sucursal=S.Sucursal
					WHERE 
					V.Mov in ('Devolucion Venta','Cancelacion Factura','Bonificacion Venta') AND V.Estatus='CONCLUIDO' AND V.Empresa='ASSIS'
					--AND (Autorizacion IN ('ZMUKUL','DUCAN','MPOOT') OR Autorizacion IS NULL) 
					AND CAST(V.FechaEmision AS DATE) BETWEEN @Finicio AND @Ffinal
					);				
					
--////////CHECAME
--SELECT * FROM #ObD --ORDER BY TAno
--SELECT * FROM #ObD WHERE Tpre=0 or Timp=0 or Tits=0 or Tart=''
--SELECT * FROM #ObD WHERE Tpre<0
--///////

CREATE TABLE #SumaC
(
TTage varchar(10),
TTNag varchar(100),
TTConI float,
TTCreI float,
TTare varchar(20),
TTArn varchar(100),
TTco float,
TTtip varchar(10)	
);

INSERT INTO #SumaC 
SELECT Tage,TAno,'Con'=CASE WHEN TCon='Contado' THEN (Tcan*Tpre*TDesL) ELSE 0 END,
'Cred'=CASE WHEN TCon='Credito' THEN (Tcan*Tpre*TDesL) ELSE 0 END
,Tare,A.Descripcion1,TTco=CASE
WHEN Tare='01' THEN 0.0
WHEN Tare='02' THEN 0.0
WHEN Tare='03' THEN 0.0
WHEN Tare='04' THEN 0.0
ELSE 0.0 END,'Agente' 
FROM #ObD AS T
LEFT JOIN Art AS A ON T.Tare=A.Articulo
WHERE TUag <> ('N')
--GROUP BY Tage,TAno,Tare,Tpre,Tcan,Tart,Tsub,A.Descripcion1;

INSERT INTO #SumaC
SELECT Tusr,TNsr,'Con'=CASE WHEN TCon='Contado' THEN (Tcan*Tpre*TDesL) ELSE 0 END,
'Cred'=CASE WHEN TCon='Credito' THEN (Tcan*Tpre*TDesL) ELSE 0 END
,Tare,A2.Descripcion1,0.0,'Usuario' 
FROM #ObD AS T2
LEFT JOIN Art AS A2 ON T2.Tare=A2.Articulo 
WHERE Tage<>TUag 
--GROUP BY Tusr,TNsr,Tare,Tpre,Tcan,Tart,Tsub,A2.Descripcion1;

--///////CHECAME
--SELECT * FROM #SumaC-- order by TTNag;
--/////////////
--JOSE MANUEL ESTEBAN CHUC MOLINA  Aldrin Quijano Medina 04 EL PRODUCTO TIENE PRECIO DE 0

CREATE TABLE #TEND
(
TTtage varchar(10),
TTtNag varchar(100),
TotalCon float,
TotalCre float,
TTtCon float,
TTtCre float,
TTtare varchar(20),
TTArn varchar(100),
TTpor float,
TTIP varchar(10),
TTCom float
); 

INSERT INTO #TEND
SELECT TTage,TTNag,0,0,SUM(TTConI),SUM(TTCreI),TTare,TTArn,TTco,TTtip,0
FROM #SumaC GROUP BY TTage,TTNag,TTare,TTArn,TTco,TTtip ORDER BY TTtip,TTNag,TTare;

--borrar+
--select * from #TEND
--borrar
--SELECT * FROM #TEND WHERE TTtare IN ('01','02','03','04','00')
--AND (TTIP = 'AGENTE' OR (TTIP = 'Usuario' AND TTtage IN ('MAYTELE01','MAYTELE02','MAYTELE03')))
-- ORDER BY  TTIP,TTtNag,TTtare; 

-->>>>Temp
declare @TotalT table(
COnt float,
Cret float,
Agen varchar(10));
INSERT INTO @TotalT
select sum(TTtCon),sum(TTtCre),TTtage from #TEND where TTtare IN ('01','02','03','04','00')
AND (TTIP = 'AGENTE' OR (TTIP = 'Usuario' AND TTtage IN ('MAYTELE01','MAYTELE02','MAYTELE03')))
 group by TTtage;
 
MERGE #TEND AS TARGET
USING @TotalT AS SOURCE
ON (TARGET.TTtage = SOURCE.Agen)
WHEN MATCHED AND TARGET.TTtage = SOURCE.Agen THEN
UPDATE SET TARGET.TotalCon=SOURCE.Cont, TARGET.TotalCre=SOURCE.Cret;
 
SELECT * FROM #TEND WHERE TTtare IN ('01','02','03','04','00')
AND (TTIP = 'AGENTE' OR (TTIP = 'Usuario' AND TTtage IN ('MAYTELE01','MAYTELE02','MAYTELE03')))
--borrar
and TTtage in ('E147','E99')
--borrar
ORDER BY  TTIP,TTtNag,TTtare; 
 
DROP TABLE #ObD
DROP TABLE #SumaC
DROP TABLE #TEND

--END
/*

EXEC SP_ComiMay @Finicio='2016-07-01', @Ffinal='2016-07-25'


DROP PROCEDURE SP_ComiMay

*/
