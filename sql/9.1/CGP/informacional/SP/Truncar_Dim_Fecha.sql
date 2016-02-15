-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Truncar_Dim_Fecha` $$

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

SET NAMES UTF8 $$

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Truncar_Dim_Fecha`(OUT o_error_status varchar(500))
MY_BLOCK_DIM_TRUNC_FEC:BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Julio 2014
-- Responsable última modificación: 
-- Fecha última modificación: 
-- Motivos del cambio: 
-- Cliente: Recovery BI Central de Demandas  
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


TRUNCATE TABLE D_F_ANIO;
TRUNCATE TABLE D_F_DIA_SEMANA;
TRUNCATE TABLE D_F_DIA;
TRUNCATE TABLE D_F_SEMANA;
TRUNCATE TABLE D_F_SEMANA_ANIO;
TRUNCATE TABLE D_F_MES;
TRUNCATE TABLE D_F_MES_ANIO;
TRUNCATE TABLE D_F_TRIMESTRE;
TRUNCATE TABLE D_F_MTD;
TRUNCATE TABLE D_F_QTD;
TRUNCATE TABLE D_F_YTD;
TRUNCATE TABLE D_F_ULT_6_MESES;
TRUNCATE TABLE D_F_ULT_12_MESES;

END MY_BLOCK_DIM_TRUNC_FEC
