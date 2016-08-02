-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`lindorff`@`62.15.160.2` PROCEDURE `Crear_Dim_Credito_Insinuado`(OUT o_error_status varchar(500))
MY_BLOCK_DIM_CRE: BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Mart�n, PFS Group
-- Fecha creaci�n: Septiembre 2013
-- Responsable �ltima modificaci�n: Gonzalo Mart�n, PFS Group
-- Fecha �ltima modificaci�n: 10/12/2013
-- Motivos del cambio: SP Lindorff v0
-- Cliente: Recovery BI Lindorff  
--
-- Descripci�n: Procedimiento almancenado que crea las tablas de la dimensi�n Cr�dito Insinuado.
-- ===============================================================================================

-- --------------------------------------------------------------------------------
-- DEFINICI�N DE LOS HANDLER DE ERROR
-- --------------------------------------------------------------------------------
DECLARE EXIT handler for 1062 set o_error_status := 'Error 1062: La tabla ya existe';
DECLARE EXIT handler for 1048 set o_error_status := 'Error 1048: Has intentado insertar un valor nulo'; 
DECLARE EXIT handler for 1318 set o_error_status := 'Error 1318: N�mero de par�metros incorrecto'; 

-- --------------------------------------------------------------------------------
-- DEFINICI�N DEL HANDLER GEN�RICO DE ERROR
-- --------------------------------------------------------------------------------
DECLARE EXIT handler for sqlexception set o_error_status:= 'Se ha producido un error en el proceso';

  
  CREATE TABLE IF NOT EXISTS DIM_CREDITO_INSINUADO_CALIFICACION_CREDITO_EXTERNO(
  `CALIFICACION_CREDITO_EXTERNO_ID` DECIMAL(16,0) NOT NULL ,
  `CALIFICACION_CREDITO_EXTERNO_DESC` VARCHAR(50) NULL ,
  `CALIFICACION_CREDITO_EXTERNO_DESC_ALT` VARCHAR(250) NULL ,
  PRIMARY KEY (`CALIFICACION_CREDITO_EXTERNO_ID`)); 
  
  
  CREATE TABLE IF NOT EXISTS DIM_CREDITO_INSINUADO_CALIFICACION_CREDITO_SUPERVISOR(
  `CALIFICACION_CREDITO_SUPERVISOR_ID` DECIMAL(16,0) NOT NULL ,
  `CALIFICACION_CREDITO_SUPERVISOR_DESC` VARCHAR(50) NULL ,
  `CALIFICACION_CREDITO_SUPERVISOR_DESC_ALT` VARCHAR(250) NULL ,
  PRIMARY KEY (`CALIFICACION_CREDITO_SUPERVISOR_ID`));
  
  
  CREATE TABLE IF NOT EXISTS DIM_CREDITO_INSINUADO_CALIFICACION_CREDITO_FINAL(
  `CALIFICACION_CREDITO_FINAL_ID` DECIMAL(16,0) NOT NULL ,
  `CALIFICACION_CREDITO_FINAL_DESC` VARCHAR(50) NULL ,
  `CALIFICACION_CREDITO_FINAL_DESC_ALT` VARCHAR(250) NULL ,
  PRIMARY KEY (`CALIFICACION_CREDITO_FINAL_ID`)); 
  
  
  CREATE TABLE IF NOT EXISTS DIM_CREDITO_INSINUADO_ESTADO_INSINUACION_CREDITO(
  `ESTADO_INSINUACION_CREDITO_ID` DECIMAL(16,0) NOT NULL ,
  `ESTADO_INSINUACION_CREDITO_DESC` VARCHAR(50) NULL ,
  `ESTADO_INSINUACION_CREDITO_DESC_ALT` VARCHAR(250) NULL ,
  PRIMARY KEY (`ESTADO_INSINUACION_CREDITO_ID`)); 
  
  
  CREATE TABLE IF NOT EXISTS DIM_CREDITO_INSINUADO(
  `CREDITO_INSINUADO_ID` DECIMAL(16,0) NOT NULL ,
  `ESTADO_INSINUACION_CREDITO_ID` DECIMAL(16,0) NULL ,
  `CALIFICACION_CREDITO_EXTERNO_ID` DECIMAL(16,0) NULL ,
  `CALIFICACION_CREDITO_SUPERVISOR_ID` DECIMAL(16,0) NULL ,
  `CALIFICACION_CREDITO_FINAL_ID` DECIMAL(16,0) NULL ,
  PRIMARY KEY (`CREDITO_INSINUADO_ID`)); 
  
  
END MY_BLOCK_DIM_CRE
