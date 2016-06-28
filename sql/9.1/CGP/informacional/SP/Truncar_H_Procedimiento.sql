-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Truncar_H_Procedimiento` $$

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

SET NAMES UTF8 $$

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Truncar_H_Procedimiento`(OUT o_error_status varchar(500))
MY_BLOCK_TRUNC_H_PRC: BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Julio 2014
-- Responsable última modificación: 
-- Fecha última modificación: 
-- Motivos del cambio: 
-- Cliente: Recovery BI Central de Demandas 
--
-- Descripción: Procedimiento almancenado que trunca las tablas de hechos H_PROCEDIMIENTO.
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


TRUNCATE TABLE H_PRC;
TRUNCATE TABLE H_PRC_MES;
TRUNCATE TABLE H_PRC_TRIMESTRE;
TRUNCATE TABLE H_PRC_ANIO;

TRUNCATE TABLE H_PRC_DET_CONTRATO;
TRUNCATE TABLE H_PRC_DET_CONTRATO_MES;
TRUNCATE TABLE H_PRC_DET_CONTRATO_TRIMESTRE;
TRUNCATE TABLE H_PRC_DET_CONTRATO_ANIO;

TRUNCATE TABLE TMP_PRC_CODIGO_PRIORIDAD;
TRUNCATE TABLE TMP_PRC_JERARQUIA;  
TRUNCATE TABLE TMP_PRC_DETALLE;
TRUNCATE TABLE TMP_PRC_TAREA;
TRUNCATE TABLE TMP_PRC_CONTRATO;
TRUNCATE TABLE TMP_PRC_AUTO_PRORROGAS;
TRUNCATE TABLE TMP_PRC_COBROS;
TRUNCATE TABLE TMP_PRC_ESTIMACION;
TRUNCATE TABLE TMP_PRC_CARTERA;
TRUNCATE TABLE TMP_PRC_FECHA_CONTABLE_LITIGIO;
TRUNCATE TABLE TMP_PRC_TITULAR;
TRUNCATE TABLE TMP_PRC_EXTRAS_RECOVERY_BI;
TRUNCATE TABLE TMP_PRC_DEMANDADO;

END MY_BLOCK_TRUNC_H_PRC
