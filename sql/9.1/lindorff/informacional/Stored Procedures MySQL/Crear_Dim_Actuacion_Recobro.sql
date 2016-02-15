-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`lindorff`@`62.15.160.2` PROCEDURE `Crear_Dim_Actuacion_Recobro`(OUT o_error_status varchar(500))
MY_BLOCK_DIM_ACR: BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Septiembre 2013
-- Responsable última modificación: Gonzalo Martín, PFS Group
-- Fecha última modificación: 10/12/2013
-- Motivos del cambio: SP Lindorff v0
-- Cliente: Recovery BI Lindorff  
--
-- Descripción: Procedimiento almancenado que crea las tablas de la dimensión Actuación Recobro.
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


  CREATE TABLE IF NOT EXISTS DIM_ACTUACION_RECOBRO_MODELO( 
  `MODELO_ACTUACION_RECOBRO_ID` DECIMAL(16,0) NOT NULL ,
  `MODELO_ACTUACION_RECOBRO_ALT` VARCHAR(50) NULL ,
  `MODELO_ACTUACION_RECOBRO_DESC_ALT` VARCHAR(250) NULL ,
  PRIMARY KEY (`MODELO_ACTUACION_RECOBRO_ID`));
  

  CREATE TABLE IF NOT EXISTS DIM_ACTUACION_RECOBRO_PROVEEDOR (
  `PROVEEDOR_ACTUACION_RECOBRO_ID` DECIMAL(16,0) NOT NULL ,
  `PROVEEDOR_ACTUACION_RECOBRO_DESC` VARCHAR(50) NULL ,
  `PROVEEDOR_ACTUACION_RECOBRO_DESC_ALT` VARCHAR(250) NULL ,
  PRIMARY KEY (`PROVEEDOR_ACTUACION_RECOBRO_ID`));
  

  CREATE TABLE IF NOT EXISTS DIM_ACTUACION_RECOBRO_TIPO( 
  `TIPO_ACTUACION_RECOBRO_ID` DECIMAL(16,0) NOT NULL ,
  `TIPO_ACTUACION_RECOBRO_DESC` VARCHAR(50) NULL ,
  `TIPO_ACTUACION_RECOBRO_DESC_ALT` VARCHAR(250) NULL ,
  PRIMARY KEY (`TIPO_ACTUACION_RECOBRO_ID`));
  
  
  CREATE TABLE IF NOT EXISTS DIM_ACTUACION_RECOBRO_RESULTADO( 
  `RESULTADO_ACTUACION_RECOBRO_ID` DECIMAL(16,0) NOT NULL ,
  `RESULTADO_ACTUACION_RECOBRO_DESC` VARCHAR(50) NULL ,
  `RESULTADO_ACTUACION_RECOBRO_DESC_ALT` VARCHAR(250) NULL ,
  PRIMARY KEY (`RESULTADO_ACTUACION_RECOBRO_ID`));
  

END MY_BLOCK_DIM_ACR
