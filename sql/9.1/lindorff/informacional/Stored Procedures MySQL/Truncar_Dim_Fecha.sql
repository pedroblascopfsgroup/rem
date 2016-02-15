-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`lindorff`@`62.15.160.2` PROCEDURE `Truncar_Dim_Fecha`(OUT o_error_status varchar(500))
MY_BLOCK_DIM_TRUNC_FEC:BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Septiembre 2013
-- Responsable última modificación: Gonzalo Martín, PFS Group
-- Fecha última modificación: 10/12/2013
-- Motivos del cambio: SP Lindorff v0
-- Cliente: Recovery BI Lindorff  
--
-- Descripción: Procedimiento almancenado que trunca las tablas de la dimensión Fecha.
-- ===============================================================================================

-- --------------------------------------------------------------------------------
-- DEFINICIÓN DE LOS HANDLER DE ERROR
-- --------------------------------------------------------------------------------
DECLARE EXIT handler for 1062 set o_error_status := 'Error 1062: La tabla ya existe';
DECLARE EXIT handler for 1048 set o_error_status := 'Error 1048: Has intentado insertar un valor nulo'; 
DECLARE EXIT handler for 1318 set o_error_status := 'Error 1318: Número de parámetros incorrecto'; 

-- --------------------------------------------------------------------------------
-- DEFINICIÓN DEL HANDLER GENÉRICO DE ERROR
-- --------------------------------------------------------------------------------
DECLARE EXIT handler for sqlexception set o_error_status:= 'Se ha producido un error en el proceso';

TRUNCATE TABLE DIM_FECHA_ANIO;
TRUNCATE TABLE DIM_FECHA_DIA_SEMANA;
TRUNCATE TABLE DIM_FECHA_DIA;
TRUNCATE TABLE DIM_FECHA_MES;
TRUNCATE TABLE DIM_FECHA_MES_ANIO;
TRUNCATE TABLE DIM_FECHA_TRIMESTRE;
TRUNCATE TABLE DIM_FECHA_MTD;
TRUNCATE TABLE DIM_FECHA_QTD;
TRUNCATE TABLE DIM_FECHA_YTD;
TRUNCATE TABLE DIM_FECHA_ULT_6_MESES;
TRUNCATE TABLE DIM_FECHA_ULT_12_MESES;

END MY_BLOCK_DIM_TRUNC_FEC
