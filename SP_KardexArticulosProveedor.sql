CREATE PROCEDURE SP_KardexArticulosProveedor @Proveedor varchar(5), @Almacen varchar(10), @FechaD date, @FechaA date
AS BEGIN
----///////////////////////////TRY ME ////////////////////////////////////////////////////////////
--DECLARE @Proveedor varchar(5), @Almacen varchar(10), @FechaD date, @FechaA date
--SET @Proveedor='301'
--SET @Almacen='ALDISTEL'
--SET @FechaD='2017-05-09'
--SET @FechaA='2017-05-09'
----//////////////////////////////////////////////////////////////////////////////////////////////
SELECT T1.Grupo'TGrupo',T1.Proveedor'TProveedor',T1.Cuenta'TCuenta', T1.Descripcion1'TDescripcion1',T1.SubCuenta'TSubCuenta', SUM(T1.CargoU)TEntrada, SUM(T1.AbonoU)TSalida FROM (
SELECT AuxiliarU.Grupo, Art.Proveedor, AuxiliarU.Cuenta, Art.Descripcion1, AuxiliarU.Subcuenta, ISNULL(AuxiliarU.CargoU,0)CargoU, ISNULL(AuxiliarU.AbonoU,0)AbonoU 
FROM AuxiliarU 
INNER JOIN Art ON AuxiliarU.Cuenta=Art.Articulo AND Art.Estatus='ALTA' AND Art.Proveedor=@Proveedor
WHERE AuxiliarU.Empresa='ASSIS' AND AuxiliarU.Rama='INV' AND AuxiliarU.Grupo=@Almacen AND CAST(AuxiliarU.Fecha AS date) BETWEEN @FechaD AND @FechaA
)T1 GROUP BY T1.Grupo,T1.Proveedor,T1.Cuenta,T1.SubCuenta,T1.Descripcion1
ORDER BY T1.Cuenta,T1.SubCuenta

END

/*
EXEC SP_KardexArticulosProveedor @Proveedor='301', @Almacen='ALDISTEL', @FechaD='2017-05-09', @FechaA='2017-05-09'
*/