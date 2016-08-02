-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Crear_Dim_Prc_Recursos` $$

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

SET NAMES UTF8 $$

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Crear_Dim_Prc_Recursos`(OUT o_error_status varchar(500))
MY_BLOCK_DIM_CREAR_REC: BEGIN

-- ===============================================================================================
-- Autor: Joaquín Arnal PFS Group
-- Fecha creación: Marzo 2015
-- Responsable última modificación:
-- Fecha última modificación:
-- Motivos del cambio:
-- Cliente: CDD
--
-- Descripción: Procedimiento almancenado que crea las tablas de la dimensión Prc_Recursos.
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

-- -------------------------------------------- ÍNDICE -------------------------------------------
-- DIMENSIÓN PRC_RECURSOS 
  	-- D_PRC_RECURSOS_ACTOR
	-- D_PRC_RECURSOS_TIPO
	-- D_PRC_RECURSOS_CAUSA
	-- D_PRC_RECURSOS_ES_FAV
	-- D_PRC_RECURSOS_RESUL_RESOL
	-- D_PRC_RECURSOS_CONF_VISTA
	-- D_PRC_RECURSOS_CONF_IMPUG
	-- D_PRC_RECURSOS_SUSPENSIVO

-- ===============================================================================================

	/* D_PRC_RECURSOS_ACTOR */

	select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_RECURSOS_ACTOR' and table_schema = 'bi_cdd_dwh';
	if (HAY_TABLA > 0) then 
	    DROP TABLE D_PRC_RECURSOS_ACTOR;
	end if;

	CREATE TABLE D_PRC_RECURSOS_ACTOR (
	  `ACTOR_ID` DECIMAL(16,0) NOT NULL,
	  `ACTOR_CODIGO` VARCHAR(50) NULL,
	  `ACTOR_DESC` VARCHAR(50) NULL,
	  `ACTOR_DESC_LARGA` VARCHAR(250) NULL,
	  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL,
	  PRIMARY KEY (`ACTOR_ID`,`ENTIDAD_CEDENTE_ID`));
	  
	  
	/* D_PRC_RECURSOS_TIPO */ 
   
	select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_RECURSOS_TIPO' and table_schema = 'bi_cdd_dwh';
	if (HAY_TABLA > 0) then 
	    DROP TABLE D_PRC_RECURSOS_TIPO;
	end if;

	CREATE TABLE D_PRC_RECURSOS_TIPO (
	  `TIPO_RECURSO_ID` DECIMAL(16,0) NOT NULL,
	  `TIPO_RECURSO_CODIGO` VARCHAR(50) NULL,
	  `TIPO_RECURSO_DESC` VARCHAR(50) NULL,
	  `TIPO_RECURSO_DESC_LARGA` VARCHAR(250) NULL,
	  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL,
	  PRIMARY KEY (`TIPO_RECURSO_ID`,`ENTIDAD_CEDENTE_ID`));
	  
	  
	/* D_PRC_RECURSOS_CAUSA */ 
	  
	select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_RECURSOS_CAUSA' and table_schema = 'bi_cdd_dwh';
	if (HAY_TABLA > 0) then 
	    DROP TABLE D_PRC_RECURSOS_CAUSA;
	end if;

	CREATE TABLE D_PRC_RECURSOS_CAUSA (
	  `CAUSA_RECURSO_ID` DECIMAL(16,0) NOT NULL,
	  `CAUSA_RECURSO_CODIGO` VARCHAR(50) NULL,
	  `CAUSA_RECURSO_DESC` VARCHAR(50) NULL,
	  `CAUSA_RECURSO_DESC_LARGA` VARCHAR(250) NULL,
	  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL,
	  PRIMARY KEY (`CAUSA_RECURSO_ID`,`ENTIDAD_CEDENTE_ID`));
	  
	  
	/* D_PRC_RECURSOS_ES_FAV */ 
	  
	select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_RECURSOS_ES_FAV' and table_schema = 'bi_cdd_dwh';
	if (HAY_TABLA > 0) then 
	    DROP TABLE D_PRC_RECURSOS_ES_FAV;
	end if;

	CREATE TABLE D_PRC_RECURSOS_ES_FAV (
	  `ES_FAVORABLE_ID` DECIMAL(16,0) NOT NULL,
	  `ES_FAVORABLE_CODIGO` VARCHAR(50) NULL,
	  `ES_FAVORABLE_DESC` VARCHAR(50) NULL,
	  `ES_FAVORABLE_DESC_LARGA` VARCHAR(250) NULL,
	  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL,
	  PRIMARY KEY (`ES_FAVORABLE_ID`,`ENTIDAD_CEDENTE_ID`));  

	  
	/* D_PRC_RECURSOS_RESUL_RESOL */  
	  
	select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_RECURSOS_RESUL_RESOL' and table_schema = 'bi_cdd_dwh';
	if (HAY_TABLA > 0) then 
	    DROP TABLE D_PRC_RECURSOS_RESUL_RESOL;
	end if;

	CREATE TABLE D_PRC_RECURSOS_RESUL_RESOL (
	  `RESULTADO_RESOL_ID` DECIMAL(16,0) NOT NULL,
	  `RESULTADO_RESOL_CODIGO` VARCHAR(50) NULL,
	  `RESULTADO_RESOL_DESC` VARCHAR(50) NULL,
	  `RESULTADO_RESOL_DESC_LARGA` VARCHAR(250) NULL,
	  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL,
	  PRIMARY KEY (`RESULTADO_RESOL_ID`,`ENTIDAD_CEDENTE_ID`)); 
	
	  
	/* D_PRC_RECURSOS_CONF_VISTA */  
	  
	select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_RECURSOS_CONF_VISTA' and table_schema = 'bi_cdd_dwh';
	if (HAY_TABLA > 0) then 
	    DROP TABLE D_PRC_RECURSOS_CONF_VISTA;
	end if;

	CREATE TABLE D_PRC_RECURSOS_CONF_VISTA (
	  `CONFIRM_VISTA_ID` DECIMAL(16,0) NOT NULL,
	  `CONFIRM_VISTA_DESC` VARCHAR(50) NULL,
	  `CONFIRM_VISTA_DESC_LARGA` VARCHAR(250) NULL,
	  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL,
	  PRIMARY KEY (`CONFIRM_VISTA_ID`,`ENTIDAD_CEDENTE_ID`));

	  
	/* D_PRC_RECURSOS_CONF_IMPUG */  
	  
	select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_RECURSOS_CONF_IMPUG' and table_schema = 'bi_cdd_dwh';
	if (HAY_TABLA > 0) then 
	    DROP TABLE D_PRC_RECURSOS_CONF_IMPUG;
	end if;

	CREATE TABLE D_PRC_RECURSOS_CONF_IMPUG (
	  `CONFIRM_IMPUGNACION_ID` DECIMAL(16,0) NOT NULL,
	  `CONFIRM_IMPUGNACION_DESC` VARCHAR(50) NULL,
	  `CONFIRM_IMPUGNACION_DESC_LARGA` VARCHAR(250) NULL,
	  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL,
	  PRIMARY KEY (`CONFIRM_IMPUGNACION_ID`,`ENTIDAD_CEDENTE_ID`));
 	

	/* D_PRC_RECURSOS_SUSPENSIVO */  
	  
 	select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_RECURSOS_SUSPENSIVO' and table_schema = 'bi_cdd_dwh';
	if (HAY_TABLA > 0) then 
	    DROP TABLE D_PRC_RECURSOS_SUSPENSIVO;
	end if;

	CREATE TABLE D_PRC_RECURSOS_SUSPENSIVO (
	  `SUSPENSIVO_ID` DECIMAL(16,0) NOT NULL,
	  `SUSPENSIVO_DESC` VARCHAR(50) NULL,
	  `SUSPENSIVO_DESC_LARGA` VARCHAR(250) NULL,
	  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL,
	  PRIMARY KEY (`SUSPENSIVO_ID`,`ENTIDAD_CEDENTE_ID`));
	  
	  
END MY_BLOCK_DIM_CREAR_REC$$
DELIMITER ;
