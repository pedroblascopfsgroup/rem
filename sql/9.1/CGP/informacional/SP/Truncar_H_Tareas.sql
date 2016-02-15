-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Truncar_H_Tareas` $$

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

SET NAMES UTF8 $$

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Truncar_H_Tareas`(OUT o_error_status varchar(500))
MY_BLOCK_TRUNC_H_TAR: BEGIN

-- ===============================================================================================
-- Autor: Joaquin Arnal Diaz, PFS Group
-- Fecha creación: Marzo 2015
-- Responsable última modificación: 
-- Fecha última modificación: 
-- Motivos del cambio: 
-- Cliente: Recovery BI Central de Demandas 
--
-- Descripción: Procedimiento almancenado que trunca las tablas de hechos de Procedimiento Especifico.
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

TRUNCATE TABLE TMP_PRC_JERARQUIA_PM;
TRUNCATE TABLE TMP_PRC_TAREA_PM_ALL;
TRUNCATE TABLE TMP_PRC_TAREA_PM_INT; 
TRUNCATE TABLE TMP_PLAZO_MEDIO_BYPASS; 
TRUNCATE TABLE TMP_PLAZO_MEDIO; 

TRUNCATE TABLE H_TAR;
TRUNCATE TABLE H_TAR_MES;
TRUNCATE TABLE H_TAR_TRIMESTRE;
TRUNCATE TABLE H_TAR_ANIO;
 
END MY_BLOCK_TRUNC_H_TAR
