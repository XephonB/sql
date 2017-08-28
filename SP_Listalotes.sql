ALTER PROCEDURE SP_Listalotes @Almac varchar(10),@Artic varchar(20)
AS
BEGIN

----IF (LEN(@Artic)<3 ) SET @Artic=''
----ELSE  SET @Artic=@Artic
----//////////////////////////////////////TRY ME//////////////////////////////////////////////////////////////////////
--DECLARE @Almac varchar(10),@Artic varchar(20);--,@Articulo varchar(10);
--SET @Almac='CENTRO';
--SET @Artic=''; --33819
----/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
DECLARE @Parametros varchar(60);

IF (@Artic<>'' AND @Artic IS NOT NULL) SET @Parametros='Almac='+''''+@Almac+''''+' AND Artic='+''''+@Artic+''''
ELSE SET @Parametros='Almac='+''''+@Almac+'''' ;


/*
DECLARE @Filtro varchar(9);
IF (LEN(@Valor)>2 ) SET @Filtro='Articulo'
ELSE IF (ISNUMERIC(@Valor)=1 AND @Valor NOT IN  (',','.','+','-','$','\'))SET @Filtro='Sucursal'
ELSE BEGIN SET @Filtro='Sucursal' SET @Valor='99' END
*/

EXEC('
SELECT * FROM 
(SELECT SLE.Sucursal Sucur, SLE.Articulo Artic,A.Descripcion1 Descr, SLE.SubCuenta SubCu, SLE.SerieLote SLote, SLE.Almacen Almac,ISNULL(SLE.Existencia,0)Exist,A.Estatus Estat
FROM SerieLote SLE
INNER JOIN Art A ON SLE.Articulo=A.Articulo
WHERE  A.Tipo=''Lote'' AND A.Proveedor=''291'')Q1
WHERE (Exist<0 OR( SLote<>''99999'' and Exist>0)) AND '+@Parametros+' ORDER BY Almac,Artic,SubCu,SLote
') 

END

/*
EXEC SP_Listalotes @Almac='CENTRO', @Artic=' '

*/

