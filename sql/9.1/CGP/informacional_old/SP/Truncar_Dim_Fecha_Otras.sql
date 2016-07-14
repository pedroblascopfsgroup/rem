-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Truncar_Dim_Fecha_Otras` $$

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

SET NAMES UTF8 $$

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Truncar_Dim_Fecha_Otras`(OUT o_error_status varchar(500))
MY_BLOCK_DIM_TRUNC_FEC_OTRAS:BEGIN

-- ===============================================================================================
-- Autor: María Villanueva, PFS Group
-- Fecha creación: Noviembre 2015
-- Responsable última modificación: 
-- Fecha última modificación: 
-- Motivos del cambio: 
-- Cliente: Recovery BI Central de Demandas  
--
-- Descripción: Procedimiento almancenado que trunca las tablas de las dimensiones Fecha_carga_datos y fecha_interposicion_demanda
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


    TRUNCATE TABLE DIM_FECHA_INTERPOS_DEMANDA_ANIO;
    TRUNCATE TABLE DIM_FECHA_INTERPOS_DEMANDA_TRIMESTRE;
    TRUNCATE TABLE DIM_FECHA_INTERPOS_DEMANDA_MES;
    TRUNCATE TABLE DIM_FECHA_INTERPOS_DEMANDA_DIA;
    TRUNCATE TABLE DIM_FECHA_INTERPOS_DEMANDA_DIA_SEMANA;
    TRUNCATE TABLE DIM_FECHA_INTERPOS_DEMANDA_MES_ANIO;
    TRUNCATE TABLE D_F_CARGA_DATOS_ANIO;
    TRUNCATE TABLE D_F_CARGA_DATOS_TRIMESTRE;
    TRUNCATE TABLE D_F_CARGA_DATOS_MES;
    TRUNCATE TABLE D_F_CARGA_DATOS_DIA;
    TRUNCATE TABLE D_F_CARGA_DATOS_DIA_SEMANA;
    TRUNCATE TABLE D_F_CARGA_DATOS_MES_ANIO;

END MY_BLOCK_DIM_TRUNC_FEC_OTRAS
