-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Crear_Dim_Procedimiento` $$

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

SET NAMES UTF8 $$

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Crear_Dim_Procedimiento`(OUT o_error_status varchar(500))
MY_BLOCK_DIM_PRC: BEGIN

-- ===============================================================================================
-- Autor: Enrique Jiménez, PFS Group
-- Fecha creación: Septiembre 2014
-- Responsable última modificación:María Villanueva, PFS Group 
-- Fecha última modificación:
-- Motivos del cambio:D_PRC_FASE_TAREA y D_PRC_FASE_TAREA_DETALLE
-- Cliente: CDD
--
-- Descripción: Procedimiento almancenado que crea las tablas de la dimensión Procedimiento.
-- ===============================================================================================

DECLARE HAY INT;
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


/*CREATE TABLE IF NOT EXISTS D_PRC_JUZGADO (
  `JUZGADO_ID` DECIMAL(16,0) NOT NULL ,
  `JUZGADO_DESC` VARCHAR(50) NULL ,
  `JUZGADO_DESC_2` VARCHAR(250) NULL ,
  `PLAZA_ID` DECIMAL(16,0) NULL ,
  PRIMARY KEY (`JUZGADO_ID`));*/
   

 /* CREATE TABLE IF NOT EXISTS D_PRC_PLAZA( 
  `PLAZA_ID` DECIMAL(16,0) NOT NULL ,
  `PLAZA_DESC` VARCHAR(50) NULL ,
  `PLAZA_DESC_2` VARCHAR(250) NULL ,
  PRIMARY KEY (`PLAZA_ID`));*/
  
  
/*  CREATE TABLE IF NOT EXISTS D_PRC_TIPO_RECLAMACION( 
  `TIPO_RECLAMACION_ID` DECIMAL(16,0) NOT NULL ,
  `TIPO_RECLAMACION_DESC` VARCHAR(50) NULL ,
  `TIPO_RECLAMACION_DESC_2` VARCHAR(250) NULL ,
  PRIMARY KEY (`TIPO_RECLAMACION_ID`));*/

  DROP TABLE D_PRC_TIPO_PROCEDIMIENTO_AGR;
  CREATE TABLE IF NOT EXISTS D_PRC_TIPO_PROCEDIMIENTO_AGR( 
  `TIPO_PROCEDIMIENTO_AGR_ID` DECIMAL(16,0) NOT NULL ,
  `TIPO_PROCEDIMIENTO_AGR_DESC` VARCHAR(50) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,
  PRIMARY KEY (`TIPO_PROCEDIMIENTO_AGR_ID`, `ENTIDAD_CEDENTE_ID`));
  
  DROP TABLE D_PRC_TIPO_PROCEDIMIENTO;  
  CREATE TABLE IF NOT EXISTS D_PRC_TIPO_PROCEDIMIENTO( 
  `TIPO_PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL ,
  `TIPO_PROCEDIMIENTO_DESC` VARCHAR(50) NULL ,
  `TIPO_PROCEDIMIENTO_DESC_2` VARCHAR(250) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,
  PRIMARY KEY (`TIPO_PROCEDIMIENTO_ID`, `ENTIDAD_CEDENTE_ID`));
  
  DROP TABLE D_PRC_TIPO_PROCEDIMIENTO_DET;    
  CREATE TABLE IF NOT EXISTS D_PRC_TIPO_PROCEDIMIENTO_DET( 
  `TIPO_PROCEDIMIENTO_DET_ID` DECIMAL(16,0) NOT NULL ,
  `TIPO_PROCEDIMIENTO_DET_DESC` VARCHAR(50) NULL ,
  `TIPO_PROCEDIMIENTO_DET_DESC_2` VARCHAR(250) NULL ,
  `TIPO_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL ,
  `TIPO_PROCEDIMIENTO_AGR_ID` DECIMAL(16,0) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,
  PRIMARY KEY (`TIPO_PROCEDIMIENTO_DET_ID`, `ENTIDAD_CEDENTE_ID`));

  DROP TABLE D_PRC_FASE_ACTUAL; 
  CREATE TABLE IF NOT EXISTS D_PRC_FASE_ACTUAL( 
  `FASE_ACTUAL_ID` DECIMAL(16,0) NOT NULL ,
  `FASE_ACTUAL_DESC` VARCHAR(50) NULL ,
  `FASE_ACTUAL_DESC_2` VARCHAR(250) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,
  PRIMARY KEY (`FASE_ACTUAL_ID`, `ENTIDAD_CEDENTE_ID`));
  
  DROP TABLE D_PRC_FASE_ACTUAL_DETALLE;   
  CREATE TABLE IF NOT EXISTS D_PRC_FASE_ACTUAL_DETALLE( 
  `FASE_ACTUAL_DETALLE_ID` DECIMAL(16,0) NOT NULL ,
  `FASE_ACTUAL_DETALLE_DESC` VARCHAR(50) NULL ,
  `FASE_ACTUAL_DETALLE_DESC_2` VARCHAR(250) NULL ,
  `FASE_ACTUAL_ID` DECIMAL(16,0) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,
  PRIMARY KEY (`FASE_ACTUAL_DETALLE_ID`, `ENTIDAD_CEDENTE_ID`));

  DROP TABLE D_PRC_FASE_ANTERIOR;
  CREATE TABLE IF NOT EXISTS D_PRC_FASE_ANTERIOR( 
  `FASE_ANTERIOR_ID` DECIMAL(16,0) NOT NULL ,
  `FASE_ANTERIOR_DESC` VARCHAR(50) NULL ,
  `FASE_ANTERIOR_DESC_2` VARCHAR(250) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,
  PRIMARY KEY (`FASE_ANTERIOR_ID`, `ENTIDAD_CEDENTE_ID`));
  
  DROP TABLE D_PRC_FASE_ANTERIOR_DETALLE;  
  CREATE TABLE IF NOT EXISTS D_PRC_FASE_ANTERIOR_DETALLE( 
  `FASE_ANTERIOR_DETALLE_ID` DECIMAL(16,0) NOT NULL ,
  `FASE_ANTERIOR_DETALLE_DESC` VARCHAR(50) NULL ,
  `FASE_ANTERIOR_DETALLE_DESC_2` VARCHAR(250) NULL ,
  `FASE_ANTERIOR_ID` DECIMAL(16,0) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,
  PRIMARY KEY (`FASE_ANTERIOR_DETALLE_ID`, `ENTIDAD_CEDENTE_ID`));
  
  DROP TABLE D_PRC_ESTADO_PROCEDIMIENTO;  
  CREATE TABLE IF NOT EXISTS D_PRC_ESTADO_PROCEDIMIENTO( 
  `ESTADO_PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL ,
  `ESTADO_PROCEDIMIENTO_DESC` VARCHAR(50) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,
  PRIMARY KEY (`ESTADO_PROCEDIMIENTO_ID`, `ENTIDAD_CEDENTE_ID`));
  
  DROP TABLE D_PRC_ESTADO_FASE_ACTUAL;    
  CREATE TABLE IF NOT EXISTS D_PRC_ESTADO_FASE_ACTUAL( 
  `ESTADO_FASE_ACTUAL_ID` DECIMAL(16,0) NOT NULL ,
  `ESTADO_FASE_ACTUAL_DESC` VARCHAR(50) NULL ,
  `ESTADO_FASE_ACTUAL_DESC_2` VARCHAR(250) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,
  PRIMARY KEY (`ESTADO_FASE_ACTUAL_ID`, `ENTIDAD_CEDENTE_ID`));

  DROP TABLE D_PRC_ESTADO_FASE_ANTERIOR;  
  CREATE TABLE IF NOT EXISTS D_PRC_ESTADO_FASE_ANTERIOR( 
  `ESTADO_FASE_ANTERIOR_ID` DECIMAL(16,0) NOT NULL ,
  `ESTADO_FASE_ANTERIOR_DESC` VARCHAR(50) NULL ,
  `ESTADO_FASE_ANTERIOR_DESC_2` VARCHAR(250) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,
  PRIMARY KEY (`ESTADO_FASE_ANTERIOR_ID`, `ENTIDAD_CEDENTE_ID`));
 
  
  DROP TABLE D_PRC_ULT_TAR_CREADA_TIPO;   
  CREATE TABLE IF NOT EXISTS D_PRC_ULT_TAR_CREADA_TIPO( 
	`ULT_TAR_CREADA_TIPO_ID` DECIMAL(16,0) NOT NULL ,
	`ULT_TAR_CREADA_TIPO_DESC` VARCHAR(50) NULL ,
	`ULT_TAR_CREADA_TIPO_DESC_2` VARCHAR(250) NULL ,
	`ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL, 
	PRIMARY KEY (`ULT_TAR_CREADA_TIPO_ID`, `ENTIDAD_CEDENTE_ID`)
  );

  
  DROP TABLE D_PRC_ULT_TAR_CREADA_TIPO_DET;
  CREATE TABLE IF NOT EXISTS D_PRC_ULT_TAR_CREADA_TIPO_DET( 
	`ULT_TAR_CREADA_TIPO_DET_ID` DECIMAL(16,0) NOT NULL ,
	`ULT_TAR_CREADA_TIPO_DET_DESC` VARCHAR(50) NULL ,
	`ULT_TAR_CREADA_TIPO_DET_DESC_2` VARCHAR(250) NULL ,
	`ULT_TAR_CREADA_TIPO_ID` DECIMAL(16,0) NULL ,
	`ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL, 
  	PRIMARY KEY (`ULT_TAR_CREADA_TIPO_DET_ID`, `ENTIDAD_CEDENTE_ID`)
  );

 
  DROP TABLE D_PRC_ULT_TAR_CREADA_DESC;   
  CREATE TABLE IF NOT EXISTS D_PRC_ULT_TAR_CREADA_DESC(
  `ULT_TAR_CREADA_DESC_ID` DECIMAL(16,0) NOT NULL ,
  `ULT_TAR_CREADA_DESC_DESC` VARCHAR(100) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL, 
  PRIMARY KEY (`ULT_TAR_CREADA_DESC_ID`, `ENTIDAD_CEDENTE_ID`));  
  

  DROP TABLE D_PRC_ULT_TAR_FIN_TIPO;  
  CREATE TABLE IF NOT EXISTS D_PRC_ULT_TAR_FIN_TIPO( 
  `ULT_TAR_FIN_TIPO_ID` DECIMAL(16,0) NOT NULL ,
  `ULT_TAR_FIN_TIPO_DESC` VARCHAR(50) NULL ,
  `ULT_TAR_FIN_TIPO_DESC_2` VARCHAR(250) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL,  
  PRIMARY KEY (`ULT_TAR_FIN_TIPO_ID`, `ENTIDAD_CEDENTE_ID`));
   
 
  DROP TABLE D_PRC_ULT_TAR_FIN_TIPO_DET;  
  CREATE TABLE IF NOT EXISTS D_PRC_ULT_TAR_FIN_TIPO_DET( 
  `ULT_TAR_FIN_TIPO_DET_ID` DECIMAL(16,0) NOT NULL ,
  `ULT_TAR_FIN_TIPO_DET_DESC` VARCHAR(50) NULL ,
  `ULT_TAR_FIN_TIPO_DET_DESC_2` VARCHAR(250) NULL ,
  `ULT_TAR_FIN_TIPO_ID` DECIMAL(16,0) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,    
  PRIMARY KEY (`ULT_TAR_FIN_TIPO_DET_ID`, `ENTIDAD_CEDENTE_ID`));  
  
  DROP TABLE D_PRC_ULT_TAR_FIN_DESC;  
  CREATE TABLE IF NOT EXISTS D_PRC_ULT_TAR_FIN_DESC(
  `ULT_TAR_FIN_DESC_ID` DECIMAL(16,0) NOT NULL ,
  `ULT_TAR_FIN_DESC_DESC` VARCHAR(100) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,    
  PRIMARY KEY (`ULT_TAR_FIN_DESC_ID`, `ENTIDAD_CEDENTE_ID`)); 
  
  DROP TABLE D_PRC_ULT_TAR_ACT_TIPO;  
  CREATE TABLE IF NOT EXISTS D_PRC_ULT_TAR_ACT_TIPO( 
  `ULT_TAR_ACT_TIPO_ID` DECIMAL(16,0) NOT NULL ,
  `ULT_TAR_ACT_TIPO_DESC` VARCHAR(50) NULL ,
  `ULT_TAR_ACT_TIPO_DESC_2` VARCHAR(250) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,    
  PRIMARY KEY (`ULT_TAR_ACT_TIPO_ID`, `ENTIDAD_CEDENTE_ID`));

 
  DROP TABLE D_PRC_ULT_TAR_ACT_TIPO_DET;     
  CREATE TABLE IF NOT EXISTS D_PRC_ULT_TAR_ACT_TIPO_DET( 
  `ULT_TAR_ACT_TIPO_DET_ID` DECIMAL(16,0) NOT NULL ,
  `ULT_TAR_ACT_TIPO_DET_DESC` VARCHAR(50) NULL ,
  `ULT_TAR_ACT_TIPO_DET_DESC_2` VARCHAR(250) NULL ,
  `ULT_TAR_ACT_TIPO_ID` DECIMAL(16,0) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,   
  PRIMARY KEY (`ULT_TAR_ACT_TIPO_DET_ID`, `ENTIDAD_CEDENTE_ID`));  
  
  DROP TABLE D_PRC_ULT_TAR_ACT_DESC;     
  CREATE TABLE IF NOT EXISTS D_PRC_ULT_TAR_ACT_DESC(
  `ULT_TAR_ACT_DESC_ID` DECIMAL(16,0) NOT NULL ,
  `ULT_TAR_ACT_DESC_DESC` VARCHAR(100) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,   
  PRIMARY KEY (`ULT_TAR_ACT_DESC_ID`, `ENTIDAD_CEDENTE_ID`));  
  
  DROP TABLE D_PRC_ULT_TAR_PEND_TIPO;     
  CREATE TABLE IF NOT EXISTS D_PRC_ULT_TAR_PEND_TIPO( 
  `ULT_TAR_PEND_TIPO_ID` DECIMAL(16,0) NOT NULL ,
  `ULT_TAR_PEND_TIPO_DESC` VARCHAR(50) NULL ,
  `ULT_TAR_PEND_TIPO_DESC_2` VARCHAR(250) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,   
  PRIMARY KEY (`ULT_TAR_PEND_TIPO_ID`, `ENTIDAD_CEDENTE_ID`));


  DROP TABLE D_PRC_ULT_TAR_PEND_TIPO_DET;   
  CREATE TABLE IF NOT EXISTS D_PRC_ULT_TAR_PEND_TIPO_DET( 
  `ULT_TAR_PEND_TIPO_DET_ID` DECIMAL(16,0) NOT NULL ,
  `ULT_TAR_PEND_TIPO_DET_DESC` VARCHAR(50) NULL ,
  `ULT_TAR_PEND_TIPO_DET_DESC_2` VARCHAR(250) NULL ,
  `ULT_TAR_PEND_TIPO_ID` DECIMAL(16,0) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,   
  PRIMARY KEY (`ULT_TAR_PEND_TIPO_DET_ID`, `ENTIDAD_CEDENTE_ID`));

  DROP TABLE D_PRC_ULT_TAR_PEND_DESC;    
  CREATE TABLE IF NOT EXISTS D_PRC_ULT_TAR_PEND_DESC(
  `ULT_TAR_PEND_DESC_ID` DECIMAL(16,0) NOT NULL ,
  `ULT_TAR_PEND_DESC_DESC` VARCHAR(100) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,  
  PRIMARY KEY (`ULT_TAR_PEND_DESC_ID`, `ENTIDAD_CEDENTE_ID`));  
  
  DROP TABLE D_PRC_DESPACHO_GESTOR;  
  CREATE TABLE IF NOT EXISTS D_PRC_DESPACHO_GESTOR (
  `DESPACHO_GESTOR_PRC_ID` DECIMAL(16,0) NOT NULL ,
  `DESPACHO_GESTOR_PRC_DESC` VARCHAR(250) NULL ,
  `TIPO_DESP_GESTOR_PRC_ID` DECIMAL(16,0) NULL ,
  `ZONA_DESP_GESTOR_PRC_ID` DECIMAL(16,0) NULL ,  
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,
  PRIMARY KEY (`DESPACHO_GESTOR_PRC_ID`, `ENTIDAD_CEDENTE_ID`));
  
  DROP TABLE D_PRC_TIPO_DESP_GESTOR;  
  CREATE TABLE IF NOT EXISTS D_PRC_TIPO_DESP_GESTOR(
  `TIPO_DESP_GESTOR_PRC_ID` DECIMAL(16,0) NOT NULL ,
  `TIPO_DESP_GESTOR_PRC_DESC` VARCHAR(50) NULL ,
  `TIPO_DESP_GESTOR_PRC_DESC_2` VARCHAR(250) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,
  PRIMARY KEY (`TIPO_DESP_GESTOR_PRC_ID`, `ENTIDAD_CEDENTE_ID`));
  
  DROP TABLE D_PRC_GESTOR; 
  CREATE TABLE IF NOT EXISTS D_PRC_GESTOR (
  `GESTOR_PRC_ID` DECIMAL(16,0) NOT NULL ,
  `GESTOR_PRC_NOMBRE_COMPLETO` VARCHAR(250) NULL ,
  `GESTOR_PRC_NOMBRE` VARCHAR(250) NULL ,
  `GESTOR_PRC_APELLIDO1` VARCHAR(250) NULL ,
  `GESTOR_PRC_APELLIDO2` VARCHAR(250) NULL ,
  `ENTIDAD_GESTOR_PRC_ID` DECIMAL(16,0) NULL , 
  `DESPACHO_GESTOR_PRC_ID` DECIMAL(16,0) NULL ,
  `GESTOR_EN_RECOVERY_PRC_ID` DECIMAL(16,0) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,
  PRIMARY KEY (`GESTOR_PRC_ID`, `ENTIDAD_CEDENTE_ID`));

  DROP TABLE D_PRC_GESTOR_EN_RECOVERY;
  CREATE TABLE IF NOT EXISTS D_PRC_GESTOR_EN_RECOVERY(
  `GESTOR_EN_RECOVERY_PRC_ID` DECIMAL(16,0) NOT NULL ,
  `GESTOR_EN_RECOVERY_PRC_DESC` VARCHAR(255) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,
  PRIMARY KEY (`GESTOR_EN_RECOVERY_PRC_ID`, `ENTIDAD_CEDENTE_ID`));
  
  DROP TABLE D_PRC_ENTIDAD_GESTOR;  
  CREATE TABLE IF NOT EXISTS D_PRC_ENTIDAD_GESTOR(
  `ENTIDAD_GESTOR_PRC_ID` DECIMAL(16,0) NOT NULL ,
  `ENTIDAD_GESTOR_PRC_DESC` VARCHAR(255) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,
  PRIMARY KEY (`ENTIDAD_GESTOR_PRC_ID`, `ENTIDAD_CEDENTE_ID`));
  
  
/* CREATE TABLE IF NOT EXISTS D_PRC_NIVEL_DESP_GESTOR( 
  `NIVEL_DESP_GESTOR_PRC_ID` DECIMAL(16,0) NOT NULL ,
  `NIVEL_DESP_GESTOR_PRC_DESC` VARCHAR(50) NULL ,
  `NIVEL_DESP_GESTOR_PRC_DESC_2` VARCHAR(250) NULL ,
  PRIMARY KEY (`NIVEL_DESP_GESTOR_PRC_ID`));
  
  
 CREATE TABLE IF NOT EXISTS D_PRC_OFI_DESP_GESTOR( 
  `OFI_DESP_GESTOR_PRC_ID` DECIMAL(16,0) NOT NULL ,
  `OFI_DESP_GESTOR_PRC_DESC` VARCHAR(50) NULL ,
  `OFI_DESP_GESTOR_PRC_DESC_2` VARCHAR(250) NULL ,
  `PROV_DESP_GESTOR_PRC_ID` DECIMAL(16,0) NULL ,
  PRIMARY KEY (`OFI_DESP_GESTOR_PRC_ID`));
  

 CREATE TABLE IF NOT EXISTS D_PRC_PROV_DESP_GESTOR( 
  `PROV_DESP_GESTOR_PRC_ID` DECIMAL(16,0) NOT NULL ,
  `PROV_DESP_GESTOR_PRC_DESC` VARCHAR(50) NULL ,
  `PROV_DESP_GESTOR_PRC_DESC_2` VARCHAR(250) NULL ,
  PRIMARY KEY (`PROV_DESP_GESTOR_PRC_ID`));
  

 CREATE TABLE IF NOT EXISTS D_PRC_ZONA_DESP_GESTOR( 
  `ZONA_DESP_GESTOR_PRC_ID` DECIMAL(16,0) NOT NULL ,
  `ZONA_DESP_GESTOR_PRC_DESC` VARCHAR(50) NULL ,
  `ZONA_DESP_GESTOR_PRC_DESC_2` VARCHAR(250) NULL ,
  `NIVEL_DESP_GESTOR_PRC_ID` DECIMAL(16,0) NULL ,
  `OFI_DESP_GESTOR_PRC_ID` DECIMAL(16,0) NULL ,
  PRIMARY KEY (`ZONA_DESP_GESTOR_PRC_ID`));*/
  
  DROP TABLE D_PRC_DESPACHO_SUPERVISOR;  
  CREATE TABLE IF NOT EXISTS D_PRC_DESPACHO_SUPERVISOR (
  `DESP_SUPER_PRC_ID` DECIMAL(16,0) NOT NULL ,
  `DESP_SUPER_PRC_DESC` VARCHAR(250) NULL ,
  `TIPO_DESP_SUPER_PRC_ID` DECIMAL(16,0) NULL ,
  `ZONA_DESP_SUPER_PRC_ID` DECIMAL(16,0) NULL ,  
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,
  PRIMARY KEY (`DESP_SUPER_PRC_ID`, `ENTIDAD_CEDENTE_ID`));
  
  DROP TABLE D_PRC_TIPO_DESPACHO_SUPERVISOR;    
  CREATE TABLE IF NOT EXISTS D_PRC_TIPO_DESPACHO_SUPERVISOR(
  `TIPO_DESP_SUPER_PRC_ID` DECIMAL(16,0) NOT NULL ,
  `TIPO_DESP_SUPER_PRC_DESC` VARCHAR(50) NULL ,
  `TIPO_DESP_SUPER_PRC_DESC_2` VARCHAR(250) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,
  PRIMARY KEY (`TIPO_DESP_SUPER_PRC_ID`, `ENTIDAD_CEDENTE_ID`));
  
  DROP TABLE D_PRC_SUPERVISOR; 
  CREATE TABLE IF NOT EXISTS D_PRC_SUPERVISOR (
  `SUPERVISOR_PRC_ID` DECIMAL(16,0) NOT NULL ,
  `SUPERVISOR_PRC_NOMBRE_COMPLETO` VARCHAR(250) NULL ,
  `SUPERVISOR_PRC_NOMBRE` VARCHAR(250) NULL ,
  `SUPERVISOR_PRC_APELLIDO1` VARCHAR(250) NULL ,
  `SUPERVISOR_PRC_APELLIDO2` VARCHAR(250) NULL ,
  `ENTIDAD_SUPER_PRC_ID` DECIMAL(16,0) NULL , 
  `DESP_SUPER_PRC_ID` DECIMAL(16,0) NULL ,  
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,
  PRIMARY KEY (`SUPERVISOR_PRC_ID`, `ENTIDAD_CEDENTE_ID`));
  
  DROP TABLE D_PRC_ENTIDAD_SUPERVISOR;
  CREATE TABLE IF NOT EXISTS D_PRC_ENTIDAD_SUPERVISOR(
  `ENTIDAD_SUPER_PRC_ID` DECIMAL(16,0) NOT NULL ,
  `ENTIDAD_SUPER_PRC_DESC` VARCHAR(255) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,
  PRIMARY KEY (`ENTIDAD_SUPER_PRC_ID`, `ENTIDAD_CEDENTE_ID`));
  
  
/* CREATE TABLE IF NOT EXISTS D_PRC_NIVEL_DESP_SUPERVISOR( 
  `NIVEL_DESP_SUPER_PRC_ID` DECIMAL(16,0) NOT NULL ,
  `NIVEL_DESP_SUPER_PRC_DESC` VARCHAR(50) NULL ,
  `NIVEL_DESP_SUPER_PRC_DESC_2` VARCHAR(250) NULL ,
  PRIMARY KEY (`NIVEL_DESP_SUPER_PRC_ID`));
  
  
 CREATE TABLE IF NOT EXISTS D_PRC_OFI_DESP_SUPERVISOR( 
  `OFICINA_DESP_SUPER_PRC_ID` DECIMAL(16,0) NOT NULL ,
  `OFICINA_DESP_SUPER_PRC_DESC` VARCHAR(50) NULL ,
  `OFICINA_DESP_SUPER_PRC_DESC_2` VARCHAR(250) NULL ,
  `PROV_DESP_SUPER_PRC_ID` DECIMAL(16,0) NULL ,
  PRIMARY KEY (`OFICINA_DESP_SUPER_PRC_ID`));
  

 CREATE TABLE IF NOT EXISTS D_PRC_PROV_DESP_SUPERVISOR( 
  `PROV_DESP_SUPER_PRC_ID` DECIMAL(16,0) NOT NULL ,
  `PROV_DESP_SUPER_PRC_DESC` VARCHAR(50) NULL ,
  `PROV_DESP_SUPER_PRC_DESC_2` VARCHAR(250) NULL ,
  PRIMARY KEY (`PROV_DESP_SUPER_PRC_ID`));
  

 CREATE TABLE IF NOT EXISTS D_PRC_ZONA_DESP_SUPERVISOR( 
  `ZONA_DESP_SUPER_PRC_ID` DECIMAL(16,0) NOT NULL ,
  `ZONA_DESP_SUPER_PRC_DESC` VARCHAR(50) NULL ,
  `ZONA_DESP_SUPER_PRC_DESC_2` VARCHAR(250) NULL ,
  `NIVEL_DESP_SUPER_PRC_ID` DECIMAL(16,0) NULL ,
  `OFICINA_DESP_SUPER_PRC_ID` DECIMAL(16,0) NULL ,
  PRIMARY KEY (`ZONA_DESP_SUPER_PRC_ID`));*/
  
  
 /* CREATE TABLE IF NOT EXISTS D_PRC_ULT_TAR_PEND_CUMPL(
  `CUMPLIMIENTO_ULT_TAR_PEND_ID` DECIMAL(16,0) NOT NULL ,
  `CUMPLIMIENTO_ULT_TAR_PEND_DESC` VARCHAR(50) NULL ,
  PRIMARY KEY (`CUMPLIMIENTO_ULT_TAR_PEND_ID`));
  
  
  CREATE TABLE IF NOT EXISTS D_PRC_ULT_TAR_FIN_CUMPL(
  `CUMPLIMIENTO_ULT_TAR_FIN_ID` DECIMAL(16,0) NOT NULL ,
  `CUMPLIMIENTO_ULT_TAR_FIN_DESC` VARCHAR(50) NULL ,
  PRIMARY KEY (`CUMPLIMIENTO_ULT_TAR_FIN_ID`));*/
  

 /* CREATE TABLE IF NOT EXISTS D_PRC_CNT_GARANTIA_REAL_ASOC(
  `CNT_GARANTIA_REAL_ASOC_ID` DECIMAL(16,0) NOT NULL ,
  `CNT_GARANTIA_REAL_ASOC_DESC` VARCHAR(50) NULL ,
  PRIMARY KEY (`CNT_GARANTIA_REAL_ASOC_ID`));
  
  
  CREATE TABLE IF NOT EXISTS D_PRC_COBRO_TIPO_DET(
  `TIPO_COBRO_DETALLE_ID` DECIMAL(16,0) NOT NULL ,
  `TIPO_COBRO_DETALLE_DESC` VARCHAR(50) NULL ,
  `TIPO_COBRO_ID` DECIMAL(16,0) NULL ,
  PRIMARY KEY (`TIPO_COBRO_DETALLE_ID`)); 
  
  
  CREATE TABLE IF NOT EXISTS D_PRC_COBRO_TIPO(
  `TIPO_COBRO_ID` DECIMAL(16,0) NOT NULL ,
  `TIPO_COBRO_DESC` VARCHAR(50) NULL ,
  PRIMARY KEY (`TIPO_COBRO_ID`)); 
  

  CREATE TABLE IF NOT EXISTS D_PRC_ACT_ESTIMACIONES(
  `ACT_ESTIMACIONES_ID` DECIMAL(16,0) NOT NULL ,
  `ACT_ESTIMACIONES_DESC` VARCHAR(50) NULL ,
  PRIMARY KEY (`ACT_ESTIMACIONES_ID`)); 
  
  
  CREATE TABLE IF NOT EXISTS D_PRC_CARTERA( 
  `CARTERA_PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL ,
  `CARTERA_PROCEDIMIENTO_DESC` VARCHAR(50) NULL ,
  PRIMARY KEY (`CARTERA_PROCEDIMIENTO_ID`));
  
  
  CREATE TABLE IF NOT EXISTS D_PRC_TITULAR( 
  `TITULAR_PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL,        -- Rerefencia a PER_ID
  `TITULAR_PROCEDIMIENTO_DESC` DECIMAL(16,0) NOT NULL,      -- Rerefencia a PER_COD_CLIENTE_ENTIDAD
  `DOCUMENTO_ID` VARCHAR(20) NULL ,
  `NOMBRE` VARCHAR(100) NULL ,
  `APELLIDO_1` VARCHAR(100) NULL ,
  `APELLIDO_2` VARCHAR(100) NULL , 
  PRIMARY KEY (`TITULAR_PROCEDIMIENTO_ID`));*/
  
  DROP TABLE D_PRC;  
  CREATE TABLE IF NOT EXISTS D_PRC( 
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL ,
  `NUMERO_AUTO` VARCHAR(50) NULL ,
  `ANIO_CODIGO_AUTO` VARCHAR(50) NULL ,
  `GESTOR_PRC_ID` DECIMAL(16,0) NULL ,
  `SUPERVISOR_PRC_ID` DECIMAL(16,0) NULL ,
  `ASUNTO_ID` DECIMAL(16,0) NULL ,
  `JUZGADO_ID` DECIMAL(16,0) NULL ,
  `TIPO_RECLAMACION_ID` DECIMAL(16,0)  NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,
  PRIMARY KEY (`PROCEDIMIENTO_ID`, `ENTIDAD_CEDENTE_ID`));
  
-- ----------------------------------- TRAMOS COMUNES ------------------------------------  
  DROP TABLE D_PRC_T_SALDO_TOTAL; 
  CREATE TABLE IF NOT EXISTS D_PRC_T_SALDO_TOTAL(
  `T_SALDO_TOTAL_PRC_ID` DECIMAL(16,0) NOT NULL ,
  `T_SALDO_TOTAL_PRC_DESC` VARCHAR(255) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,
  PRIMARY KEY (`T_SALDO_TOTAL_PRC_ID`, `ENTIDAD_CEDENTE_ID`));
  
  DROP TABLE D_PRC_T_SALDO_TOTAL_CONCURSO;  
  CREATE TABLE IF NOT EXISTS D_PRC_T_SALDO_TOTAL_CONCURSO(
  `T_SALDO_TOTAL_CONCURSO_ID` DECIMAL(16,0) NOT NULL ,
  `T_SALDO_TOTAL_CONCURSO_DESC` VARCHAR(255) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,
  PRIMARY KEY (`T_SALDO_TOTAL_CONCURSO_ID`, `ENTIDAD_CEDENTE_ID`));
    
  DROP TABLE D_PRC_TD_ULTIMA_ACTUALIZACION;  
  CREATE TABLE IF NOT EXISTS D_PRC_TD_ULTIMA_ACTUALIZACION(
  `TD_ULT_ACTUALIZACION_PRC_ID` DECIMAL(16,0) NOT NULL ,
  `TD_ULT_ACTUALIZACION_PRC_DESC` VARCHAR(255) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,
  PRIMARY KEY (`TD_ULT_ACTUALIZACION_PRC_ID`, `ENTIDAD_CEDENTE_ID`));
  
  DROP TABLE D_PRC_TD_CONTRATO_VENCIDO;  
  CREATE TABLE IF NOT EXISTS D_PRC_TD_CONTRATO_VENCIDO(
  `TD_CONTRATO_VENCIDO_ID` DECIMAL(16,0) NOT NULL ,
  `TD_CONTRATO_VENCIDO_DESC` VARCHAR(255) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,
  PRIMARY KEY (`TD_CONTRATO_VENCIDO_ID`, `ENTIDAD_CEDENTE_ID`)); 
 
  DROP TABLE D_PRC_TD_CNT_VENC_CREACION_ASU; 
  CREATE TABLE IF NOT EXISTS D_PRC_TD_CNT_VENC_CREACION_ASU(
  `TD_CNT_VENC_CREACION_ASU_ID` DECIMAL(16,0) NOT NULL ,
  `TD_CNT_VENC_CREACION_ASU_DESC` VARCHAR(255) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,
  PRIMARY KEY (`TD_CNT_VENC_CREACION_ASU_ID`, `ENTIDAD_CEDENTE_ID`)); 


DROP TABLE D_PRC_JUZGADO_CONEXP;
CREATE TABLE IF NOT EXISTS D_PRC_JUZGADO_CONEXP(
  `JUZGADO_ID` DECIMAL(16,0) NOT NULL ,
  `JUZGADO_DESC` VARCHAR(100) NULL ,
  `PLAZA_ID` DECIMAL(16,0) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,
  PRIMARY KEY (`JUZGADO_ID`, `ENTIDAD_CEDENTE_ID`));


DROP TABLE D_PRC_PLAZA_CONEXP;
CREATE TABLE IF NOT EXISTS D_PRC_PLAZA_CONEXP(
  `PLAZA_ID` DECIMAL(16,0) NOT NULL ,
  `PLAZA_DESC` VARCHAR(100) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,
  PRIMARY KEY (`PLAZA_ID`, `ENTIDAD_CEDENTE_ID`));


DROP TABLE D_PRC_PROCURADOR_CONEXP;
CREATE TABLE IF NOT EXISTS D_PRC_PROCURADOR_CONEXP(
  `PROCURADOR_ID` DECIMAL(16,0) NOT NULL ,
  `PROCURADOR_NOMBRE` VARCHAR(100) NULL ,
  -- `PROCURADOR_APELLIDO1` VARCHAR(100) NULL ,
  -- `PROCURADOR_APELLIDO2` VARCHAR(100) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,
  PRIMARY KEY (`PROCURADOR_ID`, `ENTIDAD_CEDENTE_ID`));

DROP TABLE D_PRC_CON_OPOSICION;
CREATE TABLE `D_PRC_CON_OPOSICION` (
  `PRC_CON_OPOSICION_ID` decimal(16,0) NOT NULL,
  `PRC_CON_OPOSICION_DESC` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`PRC_CON_OPOSICION_ID`));

DROP TABLE D_PRC_TAREA_HITO;
CREATE TABLE `D_PRC_TAREA_HITO` (
  `PRC_TAREA_HITO_ID` decimal(16,0) NOT NULL,
  `PRC_TAREA_HITO_DESC` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`PRC_TAREA_HITO_ID`));

  DROP TABLE D_PRC_FASE_TAREA; 
  CREATE TABLE IF NOT EXISTS D_PRC_FASE_TAREA( 
  `FASE_TAREA_ID` DECIMAL(16,0) NOT NULL ,
  `FASE_TAREA_DESC` VARCHAR(50) NULL ,
  `FASE_TAREA_DESC_2` VARCHAR(250) NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,
  PRIMARY KEY (`FASE_TAREA_ID`, `ENTIDAD_CEDENTE_ID`));

  DROP TABLE D_PRC_FASE_TAREA_DETALLE; 
  CREATE TABLE IF NOT EXISTS D_PRC_FASE_TAREA_DETALLE( 
  `FASE_TAREA_DETALLE_ID` DECIMAL(16,0) NOT NULL ,
  `FASE_TAREA_DETALLE_DESC` VARCHAR(50) NULL ,
  `FASE_TAREA_DETALLE_DESC_2` VARCHAR(250) NULL ,
  `FASE_TAREA_ID` DECIMAL(16,0) NOT NULL ,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL ,
  PRIMARY KEY (`FASE_TAREA_DETALLE_ID`, `ENTIDAD_CEDENTE_ID`));
  
 
/*  CREATE TABLE IF NOT EXISTS D_PRC_TD_CREA_ASU_A_INTERP_DEM(
  `TD_CREA_ASU_A_INTERP_DEM_ID` DECIMAL(16,0) NOT NULL ,
  `TD_CREA_ASU_A_INTERP_DEM_DESC` VARCHAR(255) NULL ,
  PRIMARY KEY (`TD_CREA_ASU_A_INTERP_DEM_ID`));
  
  
  CREATE TABLE IF NOT EXISTS D_PRC_TD_CREACION_ASU_ACEPT(
  `TD_CREACION_ASU_ACEPT_ID` DECIMAL(16,0) NOT NULL ,
  `TD_CREACION_ASU_ACEPT_DESC` VARCHAR(255) NULL ,
  PRIMARY KEY (`TD_CREACION_ASU_ACEPT_ID`));  


  CREATE TABLE IF NOT EXISTS D_PRC_TD_ACEPT_ASU_INTERP_DEM(
  `TD_ACEPT_ASU_INTERP_DEM_ID` DECIMAL(16,0) NOT NULL ,
  `TD_ACEPT_ASU_INTERP_DEM_DESC` VARCHAR(255) NULL ,
  PRIMARY KEY (`TD_ACEPT_ASU_INTERP_DEM_ID`));
  
  
  CREATE TABLE IF NOT EXISTS D_PRC_TD_CREA_ASU_REC_DOC_ACEP(
  `TD_CREA_ASU_REC_DOC_ACEP_ID` DECIMAL(16,0) NOT NULL ,
  `TD_CREA_ASU_REC_DOC_ACEP_DESC` VARCHAR(255) NULL ,
  PRIMARY KEY (`TD_CREA_ASU_REC_DOC_ACEP_ID`));
  
  
  CREATE TABLE IF NOT EXISTS D_PRC_TD_REC_DOC_ACEPT_REG_TD(
  `TD_REC_DOC_ACEPT_REG_TD_ID` DECIMAL(16,0) NOT NULL ,
  `TD_REC_DOC_ACEPT_REG_TD_DESC` VARCHAR(255) NULL ,
  PRIMARY KEY (`TD_REC_DOC_ACEPT_REG_TD_ID`));
  
  
  CREATE TABLE IF NOT EXISTS D_PRC_TD_REC_DOC_ACEPT_REC_DC(
  `TD_REC_DOC_ACEPT_REC_DC_ID` DECIMAL(16,0) NOT NULL ,
  `TD_REC_DOC_ACEPT_REC_DC_DESC` VARCHAR(255) NULL ,
  PRIMARY KEY (`TD_REC_DOC_ACEPT_REC_DC_ID`));*/
  
  
-- ----------------------------------- CONCURSOS ------------------------------------  
 /* CREATE TABLE IF NOT EXISTS D_PRC_TD_AUTO_FC_DIA_ANALISIS(
  `TD_AUTO_FC_DIA_ANALISIS_ID` DECIMAL(16,0) NOT NULL ,
  `TD_AUTO_FC_DIA_ANALISIS_DESC` VARCHAR(255) NULL ,
  PRIMARY KEY (`TD_AUTO_FC_DIA_ANALISIS_ID`));
  

  CREATE TABLE IF NOT EXISTS D_PRC_TD_AUTO_FC_LIQUIDACION(
  `TD_AUTO_FC_LIQUIDACION_ID` DECIMAL(16,0) NOT NULL ,
  `TD_AUTO_FC_LIQUIDACION_DESC` VARCHAR(255) NULL ,
  PRIMARY KEY (`TD_AUTO_FC_LIQUIDACION_ID`)); */


 /* CREATE TABLE IF NOT EXISTS D_PRC_ESTADO_CONVENIO(
  `ESTADO_CONVENIO_ID` DECIMAL(16,0) NOT NULL ,
  `ESTADO_CONVENIO_DESC` VARCHAR(255) NULL ,
  PRIMARY KEY (`ESTADO_CONVENIO_ID`)); 
  
  
  CREATE TABLE IF NOT EXISTS D_PRC_SEGUIMIENTO_CONVENIO(
  `SEGUIMIENTO_CONVENIO_ID` DECIMAL(16,0) NOT NULL ,
  `SEGUIMIENTO_CONVENIO_DESC` VARCHAR(255) NULL ,
  PRIMARY KEY (`SEGUIMIENTO_CONVENIO_ID`)); 
  
 
  CREATE TABLE IF NOT EXISTS D_PRC_T_PORCENTAJE_QUITA_CONV(
  `T_PORCENTAJE_QUITA_ID` DECIMAL(16,0) NOT NULL ,
  `T_PORCENTAJE_QUITA_DESC` VARCHAR(255) NULL ,
  PRIMARY KEY (`T_PORCENTAJE_QUITA_ID`)); 


  CREATE TABLE IF NOT EXISTS D_PRC_GARANTIA_CONCURSO(
  `GARANTIA_CONCURSO_ID` DECIMAL(16,0) NOT NULL ,
  `GARANTIA_CONCURSO_DESC` VARCHAR(255) NULL ,
  PRIMARY KEY (`GARANTIA_CONCURSO_ID`)); */
  
-- -------------------------------------- DECLARATIVO ------------------------------------  
 /* CREATE TABLE IF NOT EXISTS D_PRC_TD_ID_DECL_RESOL_FIRME(
  `TD_ID_DECL_RESOL_FIRME_ID` DECIMAL(16,0) NOT NULL ,
  `TD_ID_DECL_RESOL_FIRME_DESC` VARCHAR(255) NULL ,
  PRIMARY KEY (`TD_ID_DECL_RESOL_FIRME_ID`));
  

-- ------------------------------------- EJECUCIÓN ORDINARIA ------------------------------
  CREATE TABLE IF NOT EXISTS D_PRC_TD_ID_ORD_INI_APREMIO(
  `TD_ID_ORD_INI_APREMIO_ID` DECIMAL(16,0) NOT NULL ,
  `TD_ID_ORD_INI_APREMIO_DESC` VARCHAR(255) NULL ,
  PRIMARY KEY (`TD_ID_ORD_INI_APREMIO_ID`));
  
  
-- ------------------------------------- HIPOTECARIO --------------------------------------  
  CREATE TABLE IF NOT EXISTS D_PRC_TD_ID_HIP_SUBASTA(
  `TD_ID_HIP_SUBASTA_ID` DECIMAL(16,0) NOT NULL ,
  `TD_ID_HIP_SUBASTA_DESC` VARCHAR(255) NULL ,
  PRIMARY KEY (`TD_ID_HIP_SUBASTA_ID`));
  
  
  CREATE TABLE IF NOT EXISTS D_PRC_TD_SUB_SOL_SUB_CEL(
  `TD_SUB_SOL_SUB_CEL_ID` DECIMAL(16,0) NOT NULL ,
  `TD_SUB_SOL_SUB_CEL_DESC` VARCHAR(255) NULL ,
  PRIMARY KEY (`TD_SUB_SOL_SUB_CEL_ID`));
  
  
  CREATE TABLE IF NOT EXISTS D_PRC_TD_SUB_CEL_CESION_REMATE(
  `TD_SUB_CEL_CESION_REMATE_ID` DECIMAL(16,0) NOT NULL ,
  `TD_SUB_CEL_CESION_REMATE_DESC` VARCHAR(255) NULL ,
  PRIMARY KEY (`TD_SUB_CEL_CESION_REMATE_ID`));
  
  
  CREATE TABLE IF NOT EXISTS D_PRC_FASE_SUBASTA_HIPOTECARIO(
  `FASE_SUBASTA_HIPOTECARIO_ID` DECIMAL(16,0) NOT NULL ,
  `FASE_SUBASTA_HIPOTECARIO_DESC` VARCHAR(255) NULL ,
  PRIMARY KEY (`FASE_SUBASTA_HIPOTECARIO_ID`));
  
    
  CREATE TABLE IF NOT EXISTS D_PRC_ULT_TAR_FASE_HIP(
  `ULT_TAR_FASE_HIP_ID` DECIMAL(16,0) NOT NULL ,
  `ULT_TAR_FASE_HIP_DESC` VARCHAR(100) NULL ,
  PRIMARY KEY (`ULT_TAR_FASE_HIP_ID`));  */
  
-- -------------------------------------- MONITORIO -----------------------------------------  
 /* CREATE TABLE IF NOT EXISTS D_PRC_TD_ID_MON_DECRETO_FIN(
  `TD_ID_MON_DECRETO_FIN_ID` DECIMAL(16,0) NOT NULL ,
  `TD_ID_MON_DECRETO_FIN_DESC` VARCHAR(255) NULL ,
  PRIMARY KEY (`TD_ID_MON_DECRETO_FIN_ID`));
    

-- ------------------------------------- EJECUCION_NOTARIAL --------------------------------------  
  CREATE TABLE IF NOT EXISTS D_PRC_F_SUBASTA_EJEC_NOTARIAL(
  `F_SUBASTA_EJEC_NOTARIAL_ID` DECIMAL(16,0) NOT NULL ,
  `F_SUBASTA_EJEC_NOTARIAL_DESC` VARCHAR(255) NULL ,
  PRIMARY KEY (`F_SUBASTA_EJEC_NOTARIAL_ID`));*/


-- -------------------------------- TABLAS TMPORALES --------------------------------
  DROP TABLE TMP_PRC_GESTOR;
  CREATE TABLE IF NOT EXISTS TMP_PRC_GESTOR( 
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NULL, 
  `GESTOR_PRC_ID` DECIMAL(16,0) NULL,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL 
 ); 
 
  DROP TABLE TMP_PRC_SUPERVISOR;
  CREATE TABLE IF NOT EXISTS TMP_PRC_SUPERVISOR( 
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NULL, 
  `SUPERVISOR_PRC_ID` DECIMAL(16,0) NULL,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL 
 ); 
  
	/* TMP_PRC_GESTOR_IX ON TMP_PRC_GESTOR (PROCEDIMIENTO_ID, ENTIDAD_CEDENTE_ID);*/
	select count(INDEX_NAME) into HAY from information_schema.statistics 
				where table_name = 'TMP_PRC_GESTOR' 
					and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'TMP_PRC_GESTOR_IX';
	select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  
				where table_name = 'TMP_PRC_GESTOR' 
					and table_schema = 'bi_cdd_dwh';
	if (HAY < 1 && HAY_TABLA = 1) then 
		CREATE INDEX TMP_PRC_GESTOR_IX ON TMP_PRC_GESTOR (PROCEDIMIENTO_ID, ENTIDAD_CEDENTE_ID);
		set o_error_status:= concat('Se ha insertado el INDICE TMP_PRC_GESTOR_IX. Nº [', HAY, ']');
--	else 
--		set o_error_status:= concat('Ya existe el INDICE TMP_PRC_GESTOR_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
	end if;
 
	/* TMP_PRC_SUPER_IX ON TMP_PRC_SUPERVISOR (PROCEDIMIENTO_ID, ENTIDAD_CEDENTE_ID); */
	select count(INDEX_NAME) into HAY from information_schema.statistics 
				where table_name = 'TMP_PRC_SUPERVISOR' 
					and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'TMP_PRC_SUPER_IX';
	select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  
				where table_name = 'TMP_PRC_SUPERVISOR' 
					and table_schema = 'bi_cdd_dwh';
	if (HAY < 1 && HAY_TABLA = 1) then 
		CREATE INDEX TMP_PRC_SUPER_IX ON TMP_PRC_SUPERVISOR (PROCEDIMIENTO_ID, ENTIDAD_CEDENTE_ID);
		set o_error_status:= concat('Se ha insertado el INDICE TMP_PRC_SUPER_IX. Nº [', HAY, ']');
--	else 
--		set o_error_status:= concat('Ya existe el INDICE TMP_PRC_SUPER_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
	end if;
  
END MY_BLOCK_DIM_PRC$$
DELIMITER ;
