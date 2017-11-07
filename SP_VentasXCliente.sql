
--CREATE PROCEDURE SP_VentasXCliente @FechaI date, @FechaF date, @Cliente as varchar(10)
--AS BEGIN
-------////////////TRY ME /////////////////////////
DECLARE @FechaI date, @FechaF date
SET @FechaI='2016-12-01'
SET @FechaF='2017-03-31'
-------////////////TRY ME ////////////////////////
---VALIDAR LONGITUD DE CAMPOS Y FLOAT POR MONEY?
declare @Fecha varchar(100), @ImpSinIva money, @CostoTotal money, @Cliente varchar(10), @CNombre varchar(100),@Categoria varchar(50),@Ruta varchar(50),@Agente varchar(10),@ANombre varchar(100)

CREATE TABLE #Temporal( Cliente varchar(10),CNombre varchar(100),Categoria varchar(50),Ruta varchar(50),Agente varchar(10),Anombre varchar(100) )
CREATE TABLE #Columns( ColumnasFecha varchar(10) )

DECLARE Ccodigin CURSOR FAST_FORWARD READ_ONLY FOR

SELECT (cast(Ao as varchar(5))+cast(Mes as varchar(4)))Fecha,SUM(ImpSinIva)'ImpSinIva',SUM(CostoTotal)'CostoTotal',Cliente,CNombre,Categoria,Ruta,Agente,ANombre  FROM (
SELECT YEAR(Venta.FechaEmision)'Ao',MONTH(Venta.FechaEmision)'Mes',((Venta.Importe)*MovTipo.Factor)'ImpSinIva',Venta.CostoTotal 
,Cte.Cliente,Cte.Nombre'CNombre',Cte.Categoria,Cte.Ruta,Cte.Agente, Agente.Nombre'ANombre'
FROM Venta with(nolock)
INNER JOIN MovTipo with(nolock) ON Venta.Mov=MovTipo.Mov AND MovTipo.Modulo='VTAS' 
INNER JOIN Cte with(nolock) ON Venta.Cliente=Cte.Cliente --AND Cte.ListaPreciosEsp in ('Mayoreo Especial','Mayoreo','Expo Mayoreo') 
INNER JOIN Agente with(nolock) ON Cte.Agente=Agente.Agente
WHERE  Venta.Estatus='CONCLUIDO' AND Venta.Mov in ('Factura','Factura Prom. Plazo','Factura expo','Factura PromPzo Expo','Factura Mayoreo Inst','Factura Ventas Inst','Cancelacion Factura','Devolucion Venta','Bonificacion Venta')
AND cast(Venta.FechaEmision AS date) between @FechaI and @FechaF AND Cte.ListaPreciosEsp in ('Mayoreo Especial','Mayoreo','Expo Mayoreo') 
)t1  
--WHERE Agente='E347' --borrarr
GROUP BY Ao,Mes,Cliente,CNombre,Categoria,Ruta,Agente,ANombre
order by Ao,mes,CNombre


OPEN Ccodigin
	FETCH NEXT FROM Ccodigin INTO @Fecha, @ImpSinIva, @CostoTotal, @Cliente, @CNombre,@Categoria,@Ruta,@Agente,@ANombre

		WHILE @@FETCH_STATUS = 0
			BEGIN --//Comparar la fecha si existe como columna en la tabla  --INICIO DE WHILE
				IF @Fecha=(select ColumnasFecha From #Columns WHERE ColumnasFecha=@Fecha)
					BEGIN --Si el Cliente existe en la tabla actualizamos --INICION DEL IF PRINCIPAL
					 IF @Cliente=(SELECT Cliente FROM #Temporal WHERE Cliente=@Cliente)
						 EXEC ('UPDATE #Temporal SET ImpSinIva'+@Fecha+' = '+@ImpSinIva+' , CostoTotal'+@Fecha+' = '+@CostoTotal+' WHERE Cliente='+''''+@Cliente+'''')
					ElSE--Si no Existe , insertamos los datos
						EXEC ('INSERT INTO #Temporal (Cliente,CNombre,Categoria,Ruta,Agente,Anombre,ImpSinIva'+@Fecha+',CostoTotal'+@Fecha+') values ('+''''+@Cliente+''''+','+''''+@CNombre+''''+','+''''+@Categoria+''''+','+''''+@Ruta+''''+','+''''+@Agente+''''+','+''''+@ANombre+''''+','+@ImpSinIva+','+@CostoTotal+')')
					END--FIN DEL IF PRINCIPAL
				ELSE --Si no hay fecha como columna, lo creamos y completamos el registro de columnas
					BEGIN--INICIO DEL ELSE
					EXEC ('ALTER TABLE #Temporal ADD ImpSinIva'+@Fecha+' money, CostoTotal'+@Fecha+' money;') 
					INSERT INTO #Columns (ColumnasFecha) values (@Fecha)
				    --Buscamos el cliente nuevamente para actualizarlo
					IF @Cliente=(SELECT Cliente FROM #Temporal WHERE Cliente=@Cliente)
						 EXEC ('UPDATE #Temporal SET ImpSinIva'+@Fecha+' = '+@ImpSinIva+' , CostoTotal'+@Fecha+' = '+@CostoTotal+' WHERE Cliente='+''''+@Cliente+'''')
					ElSE -- si no encontramos el cliente lo insertamos
						EXEC ('INSERT INTO #Temporal (Cliente,CNombre,Categoria,Ruta,Agente,Anombre,ImpSinIva'+@Fecha+',CostoTotal'+@Fecha+') values ('+''''+@Cliente+''''+','+''''+@CNombre+''''+','+''''+@Categoria+''''+','+''''+@Ruta+''''+','+''''+@Agente+''''+','+''''+@ANombre+''''+','+@ImpSinIva+','+@CostoTotal+')')
					END--FIN DEL ELSE

			FETCH NEXT FROM Ccodigin INTO @Fecha, @ImpSinIva, @CostoTotal, @Cliente, @CNombre,@Categoria,@Ruta,@Agente,@ANombre --Seguimos con el siguiente renglon
			
		 END--FIN DE WHILE
	CLOSE Ccodigin;
	DEALLOCATE Ccodigin;	

SELECT * FROM #Temporal ORDER BY CNombre
--SELECT * FROM #Columns
--BORRAR PARA LIBERAR EN MEMORIA
DROP TABLE #Temporal
DROP TABLE #Columns

--END

/*
--EXEC procedure SP_VentasXCliente @FechaI='2016-01-10',@FechaF='2017-11-10',@Cliente='1996'
*/
