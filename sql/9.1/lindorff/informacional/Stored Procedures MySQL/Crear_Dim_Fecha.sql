-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`lindorff`@`62.15.160.2` PROCEDURE `Crear_Dim_Fecha`(OUT o_error_status varchar(500))
MY_BLOCK_DIM_FEC: BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Septiembre 2013
-- Responsable última modificación: Gonzalo Martín, PFS Group
-- Fecha última modificación: 10/12/2013
-- Motivos del cambio: SP Lindorff v0
-- Cliente: Recovery BI Lindorff  
--
-- Descripción: Procedimiento almancenado que crea las tablas de la dimensión Fecha.
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


CREATE TABLE IF NOT EXISTS DIM_FECHA_ANIO (
  `ANIO_ID` INT NOT NULL ,
  `ANIO_FECHA` DATE NULL ,
  `ANIO_DURACION` INT NULL ,
  `ANIO_ANT_ID` INT NULL ,
  PRIMARY KEY (`ANIO_ID`));
  

CREATE  TABLE IF NOT EXISTS DIM_FECHA_DIA_SEMANA( 
  `DIA_SEMANA_ID` INT NOT NULL ,
  `DIA_SEMANA_DESC` VARCHAR(45) NULL ,
  `DIA_SEMANA_DESC_EN` VARCHAR(45) NULL ,
  `DIA_SEMANA_DESC_DE` VARCHAR(45) NULL ,
  `DIA_SEMANA_DESC_FR` VARCHAR(45) NULL ,
  `DIA_SEMANA_DESC_IT` VARCHAR(45) NULL ,
  PRIMARY KEY (`DIA_SEMANA_ID`));
  
  
  CREATE  TABLE IF NOT EXISTS DIM_FECHA_MES( 
  `MES_ID` INT NOT NULL ,
  `MES_FECHA` DATE NULL ,
  `MES_DESC` VARCHAR(45) NULL ,
  `MES_ANIO_ID` INT NULL ,
  `TRIMESTRE_ID` INT NULL ,
  `ANIO_ID` INT NULL ,
  `MES_DURACION` INT NULL ,
  `MES_ANT_ID` INT NULL ,
  `MES_ULT_TRIMESTRE_ID` INT NULL ,
  `MES_ULT_ANIO_ID` INT NULL ,
  `MES_DESC_EN` VARCHAR(45) NULL ,
  `MES_DESC_DE` VARCHAR(45) NULL ,
  `MES_DESC_FR` VARCHAR(45) NULL ,
  `MES_DESC_IT` VARCHAR(45) NULL ,
  PRIMARY KEY (`MES_ID`));
  
  
  CREATE  TABLE IF NOT EXISTS DIM_FECHA_MES_ANIO( 
  `MES_ANIO_ID` INT NOT NULL ,
  `MES_ANIO_DESC` VARCHAR(45) NULL ,
  `MES_ANIO_DESC_EN` VARCHAR(45) NULL ,
  `MES_ANIO_DESC_DE` VARCHAR(45) NULL ,
  `MES_ANIO_DESC_FR` VARCHAR(45) NULL ,
  `MES_ANIO_DESC_IT` VARCHAR(45) NULL ,
  PRIMARY KEY (`MES_ANIO_ID`));
  

  CREATE  TABLE IF NOT EXISTS DIM_FECHA_TRIMESTRE( 
  `TRIMESTRE_ID` INT NOT NULL ,
  `TRIMESTRE_FECHA` DATE NULL ,
  `TRIMESTRE_DESC` VARCHAR(45) NULL ,
  `ANIO_ID` INT NULL ,
  `TRIMESTRE_DURACION` INT NULL ,
  `TRIMESTRE_ANT_ID` INT NULL ,
  `TRIMESTRE_ULT_ANIO_ID` INT NULL ,
  `TRIMESTRE_DESC_EN` VARCHAR(45) NULL ,
  `TRIMESTRE_DESC_DE` VARCHAR(45) NULL ,
  `TRIMESTRE_DESC_FR` VARCHAR(45) NULL ,
  `TRIMESTRE_DESC_IT` VARCHAR(45) NULL ,
  PRIMARY KEY (`TRIMESTRE_ID`));
  
  
  CREATE  TABLE IF NOT EXISTS DIM_FECHA_DIA( 
  `DIA_ID` DATE NOT NULL ,
  `DIA_SEMANA_ID` INT NULL ,
  `MES_ID` INT NULL ,
  `TRIMESTRE_ID` INT NULL ,
  `ANIO_ID` INT NULL ,
  `DIA_ANT_ID` DATE NULL ,
  `DIA_ULT_MES_ID` DATE NULL ,
  `DIA_ULT_TRIMESTRE_ID` DATE NULL ,
  `DIA_ULT_ANIO_ID` DATE NULL ,  
  PRIMARY KEY (`DIA_ID`));

  
  CREATE  TABLE IF NOT EXISTS DIM_FECHA_MTD( 
  `DIA_ID` DATE NOT NULL ,
  `MTD_DIA` DATE NULL);
  
  
  CREATE  TABLE IF NOT EXISTS DIM_FECHA_QTD( 
  `DIA_ID` DATE NOT NULL ,
  `QTD_DIA` DATE NULL);
  
  
  CREATE  TABLE IF NOT EXISTS DIM_FECHA_YTD( 
  `DIA_ID` DATE NOT NULL ,
  `YTD_DIA` DATE NULL);
  
  
  CREATE  TABLE IF NOT EXISTS DIM_FECHA_ULT_6_MESES( 
  `MES_ID` INT NOT NULL ,
  `ULT_6_MESES_ID` INT NULL);
  
  
  CREATE  TABLE IF NOT EXISTS DIM_FECHA_ULT_12_MESES( 
  `MES_ID` INT NOT NULL ,
  `ULT_12_MESES_ID` INT NULL);
  
END MY_BLOCK_DIM_FEC
