-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Truncar_H_Expediente` $$

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

SET NAMES UTF8 $$

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Truncar_H_Expediente`(OUT o_error_status varchar(500))
MY_BLOCK_TRUNC_H_EXP: BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Julio 2014
-- Responsable última modificación: 
-- Fecha última modificación: 
-- Motivos del cambio: 
-- Cliente: Recovery BI Central de Demandas 
--
-- Descripción: Procedimiento almancenado que trunca las tablas de hechos H_EXP.
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

TRUNCATE TABLE H_EXP;
TRUNCATE TABLE H_EXP_SEMANA; 
TRUNCATE TABLE H_EXP_MES; 
TRUNCATE TABLE H_EXP_TRIMESTRE; 
TRUNCATE TABLE H_EXP_ANIO; 

TRUNCATE TABLE H_EXP_DET_KO; 
TRUNCATE TABLE H_EXP_DET_KO_SEMANA; 
TRUNCATE TABLE H_EXP_DET_KO_MES; 
TRUNCATE TABLE H_EXP_DET_KO_TRIMESTRE; 
TRUNCATE TABLE H_EXP_DET_KO_ANIO; 

TRUNCATE TABLE H_EXP_DET_FACTURA; 
TRUNCATE TABLE H_EXP_DET_FACTURA_SEMANA; 
TRUNCATE TABLE H_EXP_DET_FACTURA_MES; 
TRUNCATE TABLE H_EXP_DET_FACTURA_TRIMESTRE; 
TRUNCATE TABLE H_EXP_DET_FACTURA_ANIO;
 
END MY_BLOCK_TRUNC_H_EXP
