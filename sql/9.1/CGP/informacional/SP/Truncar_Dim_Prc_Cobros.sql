-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Truncar_Dim_Prc_Cobros` $$

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

SET NAMES UTF8 $$

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Truncar_Dim_Prc_Cobros`(OUT o_error_status varchar(500))
MY_BLOCK_TRUNC_DIM_PRC:BEGIN

-- ===============================================================================================
-- Autor: Enrique Jiménez, PFS Group
-- Fecha creación: Septiembre 2014
-- Responsable última modificación:
-- Fecha última modificación: 
-- Motivos del cambio: 
-- Cliente: CDD
--
-- Descripción: Procedimiento almancenado que trunca las tablas de la dimensión Prc_Cobros.
-- ===============================================================================================

DECLARE HAY_TABLA INT;

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

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_COBRO_ESTADO_PAGO' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_COBRO_ESTADO_PAGO;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_COBRO_TIPO_PAGO' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_COBRO_TIPO_PAGO;
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_COBRO_SUBTIPO_PAGO' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_COBRO_SUBTIPO_PAGO;
end if;	 

END MY_BLOCK_TRUNC_DIM_PRC
