-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Truncar_Dim_Asunto` $$

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

SET NAMES UTF8 $$

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Truncar_Dim_Asunto`(OUT o_error_status varchar(500))
MY_BLOCK_TRUNC_DIM_ASU:BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Septiembre 2014
-- Responsable última modificación: 
-- Fecha última modificación: 
-- Motivos del cambio: 
-- Cliente: CDD 
--
-- Descripción: Procedimiento almancenado que trunca las tablas de la dimensión Asunto.
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


TRUNCATE TABLE D_ENTIDAD_CEDENTE;
TRUNCATE TABLE D_ASU_DESPACHO;
TRUNCATE TABLE D_ASU_DESPACHO_GESTOR;
TRUNCATE TABLE D_ASU_ENTIDAD_GESTOR;
TRUNCATE TABLE D_ASU_ESTADO;
TRUNCATE TABLE D_ASU_GESTOR;
TRUNCATE TABLE D_ASU_NVL_DESPACHO;
TRUNCATE TABLE D_ASU_NVL_DESPACHO_GESTOR;
TRUNCATE TABLE D_ASU_OFI_DESPACHO; 
TRUNCATE TABLE D_ASU_OFI_DESPACHO_GESTOR;
TRUNCATE TABLE D_ASU_PROV_DESPACHO;
TRUNCATE TABLE D_ASU_PROV_DESPACHO_GESTOR;
TRUNCATE TABLE D_ASU_TIPO_DESPACHO;
TRUNCATE TABLE D_ASU_TIPO_DESPACHO_GESTOR;
TRUNCATE TABLE D_ASU_ROL_GESTOR;
TRUNCATE TABLE D_ASU_ZONA_DESPACHO; 
TRUNCATE TABLE D_ASU_ZONA_DESPACHO_GESTOR;
TRUNCATE TABLE D_ASU; 
  
END MY_BLOCK_TRUNC_DIM_ASU
