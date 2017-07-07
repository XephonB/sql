USE [Assis]
GO
/****** Object:  StoredProcedure [dbo].[SP_CMenudeoCAgrupado]    Script Date: 07/07/2017 10:07:13 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SP_CMenudeoCAgrupado] @Finicio DATE, @Ffinal DATE, @Sucursal VARCHAR(10)
AS BEGIN

----COMENTAR
--DECLARE @Finicio DATE, @Ffinal DATE, @Sucursal VARCHAR(10)
--SET @Finicio='2017-01-01'
--SET @Ffinal='2017-01-31'
--SET @Sucursal='1'
----COMENTAR

DECLARE @ComisionMen TABLE(
Agente varchar(10),Nombre varchar(100),Plaza varchar(20),VendidoActual money, VendidoAnterior money, Rama varchar(3),Area varchar(30)
,VendidoTotalActual money, VendidoTotalAnterior money, PorcentajeArea float,PorcentajeValor float,Estatus varchar(15)
)
INSERT INTO @ComisionMen 
SELECT AoActual.Agente, 'Nombre'=CASE WHEN LEFT(P.Plaza,18)='ENCARGADDECORACION' THEN AoActual.Nombre+' (ENCARGADO DECORACION)'
WHEN LEFT(P.Plaza,20)='ENCARGADOELECTRONICA' THEN AoActual.Nombre+' (ENCARGADO GENERAL)' WHEN LEFT(P.Plaza,17)='ENCARGADOMERCERIA' THEN AoActual.Nombre+' (ENCARGADO MERECERIA)'
WHEN LEFT(P.Plaza,13)='ENCARGADOROPA' THEN AoActual.Nombre+' (ENCARGADO ROPA)' WHEN LEFT(P.Plaza,14)='ENCARGADOTELAS' THEN AoActual.Nombre+' (ENCARGADO TELAS)' ELSE  AoActual.Nombre END,
'Plaza'=CASE WHEN LEFT(P.Plaza,18)='VENDPISODECORACION' THEN '00' WHEN LEFT(P.Plaza,18)='VENDPISOELECTRONIC' THEN '04'
WHEN LEFT(P.Plaza,18)='VENDEDPISOMERCERIA' THEN  '01' WHEN LEFT(P.Plaza,16)='VENDEDORPISOROPA' THEN '03'
WHEN LEFT(P.Plaza,17)='VENDEDORPISOTELAS' THEN '02' WHEN LEFT(P.Plaza,18)='ENCARGADDECORACION' THEN '00 E'
WHEN LEFT(P.Plaza,20)='ENCARGADOELECTRONICA' THEN '04 E' WHEN LEFT(P.Plaza,17)='ENCARGADOMERCERIA' THEN '01 E'
WHEN LEFT(P.Plaza,13)='ENCARGADOROPA' THEN '03 E' WHEN LEFT(P.Plaza,14)='ENCARGADOTELAS' THEN '02 E'
WHEN P.Plaza IS NULL THEN '' ELSE P.Plaza END  --ISNULL(P.Plaza,'')Plaza
,AoActual.VendidoActual,0,AoActual.Rama,AoActual.Area
--ISNULL(AoPasado.VendidoAnterior,0)VendidoAnterior,AoActual.Rama,AoActual.Area 
,0,ISNULL(Tsuma.C2,0),0,0,ISNULL(P.Estatus,'') FROM --Tabla Final
(
SELECT Tabla1.Agente,Tabla1.Nombre,SUM(Tabla1.Cantidad*Tabla1.PrecioT*Tabla1.Descuento)VendidoActual,Tabla1.Rama,ISNULL(Art.Descripcion1,'DECORACION')Area --Sumar y agrupar los resultados
FROM(SELECT VD.Agente,Ag.Nombre,V.Importe,V.Impuestos,VD.Cantidad,VD.Articulo,ISNULL(VD.SubCuenta,'')SubC,
	--VD.Precio'PrecioT', --Select basico con inner
		'PrecioT'=CASE 		
		WHEN V.Mov IN('Devolucion Venta','Cancelacion Factura','Bonificacion Venta') 
		THEN (VD.Precio * -1) ELSE VD.Precio END,
	--'Descuento'=CASE WHEN VD.DescuentoLinea IS NULL THEN 1 WHEN VD.DescuentoLinea=0 THEN 1 ELSE (100-VD.DescuentoLinea)/100 END, --Sacar el Descuento Lineal por producto		
	   'Descuento'= CASE 		
		WHEN VD.DescuentoLinea <> 0 AND V.Mov IN('Devolucion Venta','Cancelacion Factura','Bonificacion Venta')
		THEN (-1*((100-VD.DescuentoLinea)/100))
		WHEN VD.DescuentoLinea <> 0 THEN ((100 -VD.DescuentoLinea)/100)
		WHEN VD.DescuentoLinea IS NULL THEN 1
		ELSE 1 END,
	'Rama'=CASE WHEN V.Concepto='Ventas Decoracion' THEN '00' WHEN LEFT(A.Rama,4) in ('0202','0229','0249','0265','0267','0269') THEN '00' ELSE left(A.Rama,2) END --Si es Decoracion poner una nueva rama
	FROM Venta AS V
	INNER JOIN VentaD AS VD ON V.ID=VD.ID
	INNER JOIN ART AS A ON VD.Articulo=A.Articulo
	INNER JOIN Sucursal AS S ON V.Sucursal=S.Sucursal
	LEFT JOIN Agente AS Ag ON VD.Agente=Ag.Agente
	WHERE VD.ID IN(SELECT V.ID FROM Venta AS V
			  INNER JOIN Sucursal AS S ON V.Sucursal=S.Sucursal
			  WHERE V.Mov='Nota' AND V.Estatus='CONCLUIDO' AND V.Empresa='ASSIS' AND V.Sucursal=@Sucursal AND
		      CAST(V.FechaEmision AS DATE) BETWEEN @Finicio AND @Ffinal 
				OR (V.Mov='Factura' AND V.Concepto in ('Ventas Piso Menudeo','Venta Menudeo') AND V.Estatus='CONCLUIDO' AND V.Empresa='ASSIS' AND V.Sucursal=@Sucursal AND
		      CAST(V.FechaEmision AS DATE) BETWEEN @Finicio AND @Ffinal )
				OR (V.Mov='Factura' AND  V.Concepto='Ventas Decoracion' AND V.Estatus='CONCLUIDO' AND V.Empresa='ASSIS' AND V.Sucursal=@Sucursal AND
		      CAST(V.FechaEmision AS DATE) BETWEEN @Finicio AND @Ffinal )
		       OR (V.Mov='Factura POS' AND V.Estatus='CONCLUIDO' AND V.Empresa='ASSIS' AND V.Sucursal=@Sucursal AND
		      CAST(V.FechaEmision AS DATE) BETWEEN @Finicio AND @Ffinal )
		      OR (V.Mov in ('Devolucion Venta','Cancelacion Factura','Bonificacion Venta') AND V.Estatus='CONCLUIDO' AND V.Empresa='ASSIS' AND V.Sucursal=@Sucursal AND
		      CAST(V.FechaEmision AS DATE) BETWEEN @Finicio AND @Ffinal )
		      )  /*and vd.ID in (1134260,1028437)*/ )Tabla1  
LEFT JOIN Art ON Tabla1.Rama=Art.Articulo
WHERE Tabla1.Rama IN ('01','02','03','04','00')					
Group by Tabla1.Agente,Tabla1.Nombre,Tabla1.Rama,Art.Descripcion1
)AoActual
LEFT JOIN PersonalPropValor AS PPV ON AoActual.Agente=PPV.Valor AND PPV.Rama='PER' AND PPV.Propiedad='Acreedor Cheques'
LEFT JOIN Personal AS P ON PPV.Cuenta=P.Personal
LEFT JOIN --/////////////////////////consulta para el año pasado/////////////////////////////////////////////////////////////////////////////////////////////					      
(
SELECT AoPasado.Rama, SUM(AoPasado.VendidoAnterior)'C2' FROM (
SELECT Tabla1.Agente,SUM(Tabla1.Cantidad*Tabla1.PrecioT*Tabla1.Descuento)VendidoAnterior,Tabla1.Rama --Sumar y agrupar los resultados
FROM(
		SELECT VD.Agente,Ag.Nombre,V.Importe,V.Impuestos,VD.Cantidad,VD.Articulo,ISNULL(VD.SubCuenta,'')SubC,
		--VD.Precio'PrecioT', --Select basico con inner
			'PrecioT'=CASE 		
			WHEN V.Mov IN('Devolucion Venta','Cancelacion Factura','Bonificacion Venta') 
			THEN (VD.Precio * -1) ELSE VD.Precio END,
			--'Descuento'=CASE WHEN VD.DescuentoLinea IS NULL THEN 1 WHEN VD.DescuentoLinea=0 THEN 1 ELSE (100-VD.DescuentoLinea)/100 END, --Sacar el Descuento Lineal por producto
		   'Descuento'= CASE 		
			WHEN VD.DescuentoLinea <> 0 AND V.Mov IN('Devolucion Venta','Cancelacion Factura','Bonificacion Venta')
			THEN (-1*((100-VD.DescuentoLinea)/100))
			WHEN VD.DescuentoLinea <> 0 THEN ((100 -VD.DescuentoLinea)/100)
			WHEN VD.DescuentoLinea IS NULL THEN 1
			ELSE 1 END,
			'Rama'=CASE WHEN V.Concepto='Ventas Decoracion' THEN '00' WHEN LEFT(A.Rama,4) in ('0202','0229','0249','0265','0267','0269') THEN '00' ELSE left(A.Rama,2) END --Si es Decoracion poner una nueva rama
			FROM Venta AS V
			INNER JOIN VentaD AS VD ON V.ID=VD.ID
			INNER JOIN ART AS A ON VD.Articulo=A.Articulo
			INNER JOIN Sucursal AS S ON V.Sucursal=S.Sucursal
			LEFT JOIN Agente AS Ag ON VD.Agente=Ag.Agente
			WHERE VD.ID IN(SELECT V.ID FROM Venta AS V
					  INNER JOIN Sucursal AS S ON V.Sucursal=S.Sucursal
					  WHERE V.Mov='Nota' AND V.Estatus='CONCLUIDO' AND V.Empresa='ASSIS' AND V.Sucursal=@Sucursal AND
					  CAST(V.FechaEmision AS DATE) BETWEEN (DATEADD(YEAR,-1,(CAST(@Finicio AS DATE)))) AND (DATEADD(YEAR,-1,(CAST(@Ffinal AS DATE)))) 
						OR (V.Mov='Factura' AND V.Concepto in ('Ventas Piso Menudeo','Venta Menudeo') AND V.Estatus='CONCLUIDO' AND V.Empresa='ASSIS' AND V.Sucursal=@Sucursal AND
					  CAST(V.FechaEmision AS DATE) BETWEEN (DATEADD(YEAR,-1,(CAST(@Finicio AS DATE)))) AND (DATEADD(YEAR,-1,(CAST(@Ffinal AS DATE)))) AND V.Empresa='ASSIS' )
						OR (V.Mov='Factura' AND  V.Concepto='Ventas Decoracion' AND V.Estatus='CONCLUIDO' AND V.Empresa='ASSIS' AND V.Sucursal=@Sucursal AND
					  CAST(V.FechaEmision AS DATE) BETWEEN (DATEADD(YEAR,-1,(CAST(@Finicio AS DATE)))) AND (DATEADD(YEAR,-1,(CAST(@Ffinal AS DATE)))) AND V.Empresa='ASSIS')
					   OR (V.Mov='Factura POS' AND V.Estatus='CONCLUIDO' AND V.Empresa='ASSIS' AND V.Sucursal=@Sucursal AND
					  CAST(V.FechaEmision AS DATE) BETWEEN (DATEADD(YEAR,-1,(CAST(@Finicio AS DATE)))) AND (DATEADD(YEAR,-1,(CAST(@Ffinal AS DATE)))) AND V.Empresa='ASSIS')
					  OR (V.Mov in ('Devolucion Venta','Cancelacion Factura','Bonificacion Venta') AND V.Estatus='CONCLUIDO' AND V.Empresa='ASSIS' AND V.Sucursal=@Sucursal AND
					  CAST(V.FechaEmision AS DATE) BETWEEN @Finicio AND @Ffinal )
		)  /*and vd.ID in (1134260,1028437)*/ 
		
)Tabla1  
LEFT JOIN Art ON Tabla1.Rama=Art.Articulo
WHERE Tabla1.Rama IN ('01','02','03','04','00')					
Group by Tabla1.Agente,Tabla1.Nombre,Tabla1.Rama,Art.Descripcion1
)AoPasado 
GROUP BY AoPasado.Rama
)Tsuma
--//////////////fin consulta para el año pasado/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
ON AoActual.Rama = Tsuma.Rama--Ligar Nombre y Rama de las dos selects

--select 'UNO',* from @ComisionMen
--/////////////terminar aca abajo los porcentajes
UPDATE a 
SET VendidoTotalActual=Sumas.VendidoActual, --VendidoTotalAnterior=Sumas.VendidoAnterior , 
PorcentajeArea=Sumas.PorcentajeAr
FROM @ComisionMen as a 
,(SELECT SUM(VendidoActual)VendidoActual--SUM(VendidoAnterior)VendidoAnterior
,ISNULL(((SUM(VendidoActual)*100)/NULLIF(VendidoTotalAnterior,0)-100),0)PorcentajeAr, Rama 
FROM @ComisionMen  GROUP BY Rama,VendidoTotalAnterior)Sumas
WHERE A.Rama=Sumas.Rama
--select 'DOS',* from @ComisionMen

UPDATE Com SET Com.PorcentajeValor=SelTemp.ValorTemp
FROM @ComisionMen Com, (SELECT 'ValorTemp'=CASE --WHEN PorcentajeArea<0 THEN 0 
WHEN PorcentajeArea <10 THEN 0.005 WHEN PorcentajeArea BETWEEN 10 AND 14.9999 THEN 0.01
WHEN PorcentajeArea BETWEEN 15 AND 19.9999 THEN 0.012 WHEN PorcentajeArea>20 THEN 0.014
ELSE 0 END,Agente,Rama FROM @ComisionMen)SelTemp
WHERE Com.Agente=SelTemp.Agente AND Com.Rama=SelTemp.Rama

--select * from @ComisionMen -- where Estatus=''

MERGE @ComisionMen AS TARGET
USING (
--SELECT * FROM(
SELECT *--,DatosArea.Rama,DatosArea.Area,DatosArea.VendidoTotalActual,DatosArea.VendidoTotalAnterior,DatosArea.PorcentajeArea,DatosArea.PorcentajeValor 
FROM 
(SELECT Age.Agente,'Nombre'=CASE WHEN LEFT(Pl.Plaza,18)='ENCARGADDECORACION' THEN Age.Nombre+' (ENCARGADO DECORACION)'
WHEN LEFT(Pl.Plaza,20)='ENCARGADOELECTRONICA' THEN Age.Nombre+' (ENCARGADO GENERAL)' 
WHEN LEFT(Pl.Plaza,17)='ENCARGADOMERCERIA' THEN Age.Nombre+' (ENCARGADO MERECERIA)'WHEN LEFT(Pl.Plaza,13)='ENCARGADOROPA' THEN Age.Nombre+' (ENCARGADO ROPA)' 
WHEN LEFT(Pl.Plaza,14)='ENCARGADOTELAS' THEN Age.Nombre+' (ENCARGADO TELAS)' ELSE  'Error Nombre' END
,'PlazaC'=CASE  WHEN LEFT(Pl.Plaza,18)='ENCARGADDECORACION' THEN '00' WHEN LEFT(Pl.Plaza,20)='ENCARGADOELECTRONICA' THEN '04'
WHEN LEFT(Pl.Plaza,17)='ENCARGADOMERCERIA' THEN '01' WHEN LEFT(Pl.Plaza,13)='ENCARGADOROPA' THEN '03' 
WHEN LEFT(Pl.Plaza,14)='ENCARGADOTELAS' THEN '02' ELSE 'Error plaza' END
,0'Vac',0'Van' 
FROM Agente Age
INNER JOIN PersonalPropValor AS Per ON Age.Agente=Per.Valor AND Per.Rama='PER' AND Per.Propiedad='Acreedor Cheques'
INNER JOIN Personal AS Pl ON Per.Cuenta=Pl.Personal 
WHERE Age.SucursalEmpresa=@Sucursal and Pl.Estatus IN ('ALTA','Aspirante')
--and Age.Agente in ('E121','E122','E120','e146')
AND (LEFT(Plaza,18)='ENCARGADDECORACION' OR LEFT(Plaza,20)='ENCARGADOELECTRONICA' OR LEFT(Plaza,17)='ENCARGADOMERCERIA' OR LEFT(Plaza,13)='ENCARGADOROPA' OR LEFT(Plaza,14)='ENCARGADOTELAS'))Encargados
INNER JOIN (select distinct Rama,Area,VendidoTotalActual,VendidoTotalAnterior,PorcentajeArea,PorcentajeValor from @ComisionMen)DatosArea
ON Encargados.PlazaC=DatosArea.Rama 
--)EncargadosFin
) AS SOURCE
ON (TARGET.Agente=SOURCE.Agente AND TARGET.Rama=SOURCE.PlazaC)
WHEN NOT MATCHED THEN
INSERT VALUES (SOURCE.Agente,SOURCE.Nombre,(SOURCE.PlazaC+' E'),SOURCE.Vac,SOURCE.Van,SOURCE.Rama,SOURCE.Area,SOURCE.VendidoTotalActual,SOURCE.VendidoTotalAnterior,SOURCE.PorcentajeArea,SOURCE.PorcentajeValor,'ALTA')
;

 --select * from @ComisionMen 

SELECT  Agrupado.Agente,Agrupado.Nombre, SUM(ComisionC)Comision FROM(
SELECT * FROM(
SELECT Agente,Nombre,Area,VendidoActual,VendidoTotalAnterior,VendidoTotalActual,'PlazaE'=CASE WHEN LEFT(Plaza,2)=Rama AND LEFT(Plaza,2)='00' THEN 'DECORACION'
WHEN LEFT(Plaza,2)=Rama THEN SUBSTRING(Area,5,LEN(Area)) WHEN LEN(Plaza)=4 THEN LEFT(Plaza,2 )
WHEN LEN(Plaza)>4 THEN 'OTROS' ELSE Plaza END
,'ComisionC'=CASE WHEN RIGHT(Plaza,1)='E' AND LEFT(Plaza,2)=Rama AND PorcentajeValor>=0.01 THEN (PorcentajeValor*VendidoTotalActual)*0.30 
WHEN RIGHT(Plaza,1)='E' THEN 0 
WHEN LEFT(Plaza,2)=Rama THEN PorcentajeValor*VendidoActual 
ELSE VendidoActual*0.01 END, PorcentajeValor
FROM @ComisionMen WHERE Estatus<>'' AND ((LEFT(Plaza,5) <> 'CAJER') AND (LEFT(Plaza,8) <> 'ENCARGAD') AND (LEFT(Nombre,11) <>'AUTOSERVICI')) )Final
---WHERE ComisionC<>0
 --ORDER BY Area,Nombre 
 )Agrupado GROUP BY Agente,Nombre

/*
SELECT *,'Comision'=CASE WHEN RIGHT(Plaza,1)='E' AND LEFT(Plaza,2)=Rama AND PorcentajeValor>=0.01 THEN PorcentajeValor*VendidoTotalActual 
WHEN RIGHT(Plaza,1)='E' THEN 0 
WHEN LEFT(Plaza,2)=Rama THEN PorcentajeValor*VendidoActual 
ELSE VendidoActual*0.01 END
FROM @ComisionMen WHERE (LEFT(Plaza,5) <> 'CAJER') AND (LEFT(Plaza,8) <> 'ENCARGAD') AND (LEFT(Nombre,11) <>'AUTOSERVICI')  ORDER BY Rama,Nombre
*/
END

--
/*
EXEC SP_CMenudeoCAgrupado @Finicio ='2016-12-01', @Ffinal ='2016-12-31', @Sucursal ='3'

DROP PROCEDURE SP_CMenudeoCAgrupado 

*/