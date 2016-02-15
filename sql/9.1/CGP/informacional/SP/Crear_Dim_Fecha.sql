-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Crear_Dim_Fecha` $$

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

SET NAMES UTF8 $$

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Crear_Dim_Fecha`(OUT o_error_status varchar(500))
MY_BLOCK_DIM_FEC: BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Julio 2014
-- Responsable última modificación: 
-- Fecha última modificación: 
-- Motivos del cambio: 
-- Cliente: Recovery BI Central de Demandas 
--
-- Descripción: Procedimiento almancenado que crea las tablas de la dimensión Fecha.
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


CREATE TABLE IF NOT EXISTS D_F_ANIO (
  `ANIO_ID` INT NOT NULL ,
  `ANIO_FECHA` DATE NULL ,
  `ANIO_DURACION` INT NULL ,
  `ANIO_ANT_ID` INT NULL ,
  PRIMARY KEY (`ANIO_ID`));
  

CREATE  TABLE IF NOT EXISTS D_F_DIA_SEMANA( 
  `DIA_SEMANA_ID` INT NOT NULL ,
  `DIA_SEMANA_DESC` VARCHAR(45) NULL ,
  `DIA_SEMANA_DESC_EN` VARCHAR(45) NULL ,
  `DIA_SEMANA_DESC_DE` VARCHAR(45) NULL ,
  `DIA_SEMANA_DESC_FR` VARCHAR(45) NULL ,
  `DIA_SEMANA_DESC_IT` VARCHAR(45) NULL ,
  PRIMARY KEY (`DIA_SEMANA_ID`));
  
  
  CREATE  TABLE IF NOT EXISTS D_F_MES( 
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
  `MES_CIERRE_ANIO_ID` INT NULL ,
  `MES_DESC_EN` VARCHAR(45) NULL ,
  `MES_DESC_DE` VARCHAR(45) NULL ,
  `MES_DESC_FR` VARCHAR(45) NULL ,
  `MES_DESC_IT` VARCHAR(45) NULL ,
  PRIMARY KEY (`MES_ID`));
  
  
  CREATE  TABLE IF NOT EXISTS D_F_MES_ANIO( 
  `MES_ANIO_ID` INT NOT NULL ,
  `MES_ANIO_DESC` VARCHAR(45) NULL ,
  `MES_ANIO_DESC_EN` VARCHAR(45) NULL ,
  `MES_ANIO_DESC_DE` VARCHAR(45) NULL ,
  `MES_ANIO_DESC_FR` VARCHAR(45) NULL ,
  `MES_ANIO_DESC_IT` VARCHAR(45) NULL ,
  PRIMARY KEY (`MES_ANIO_ID`));
  

  CREATE  TABLE IF NOT EXISTS D_F_TRIMESTRE( 
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
  
  
  CREATE  TABLE IF NOT EXISTS D_F_DIA( 
  `DIA_ID` DATE NOT NULL ,
  `DIA_SEMANA_ID` INT NULL ,
  `SEMANA_ID` INT NULL,
  `MES_ID` INT NULL ,
  `TRIMESTRE_ID` INT NULL ,
  `ANIO_ID` INT NULL ,
  `DIA_ANT_ID` DATE NULL ,
  `DIA_ULT_MES_ID` DATE NULL ,
  `DIA_ULT_TRIMESTRE_ID` DATE NULL ,
  `DIA_ULT_ANIO_ID` DATE NULL ,  
  PRIMARY KEY (`DIA_ID`));


  CREATE TABLE IF NOT EXISTS D_F_SEMANA(
  `SEMANA_ID` INT NOT NULL,
  `SEMANA_FECHA` DATE NULL,
  `SEMANA_DESC` VARCHAR(45) NULL,
  `SEMANA_DESC_ALT` VARCHAR(45) NULL,
  `SEMANA_ANIO_ID` INT NULL ,
  `SEMANA_DURACION` INT NULL,  
  `MES_ID` INT NULL ,
  `ANIO_ID` INT NULL,
  `SEM_ANT_ID` INT NULL,  
  `SEMANA_DESC_EN` VARCHAR(45) NULL,
  `SEMANA_DESC_DE` VARCHAR(45) NULL,
  `SEMANA_DESC_FR` VARCHAR(45) NULL,
  `SEMANA_DESC_IT` VARCHAR(45) NULL,
  PRIMARY KEY (`SEMANA_ID`));
  
  
CREATE  TABLE IF NOT EXISTS D_F_SEMANA_ANIO( 
  `SEMANA_ANIO_ID` INT NOT NULL ,
  `SEMANA_ANIO_DESC` VARCHAR(45) NULL ,
  `SEMANA_ANIO_DESC_EN` VARCHAR(45) NULL ,
  `SEMANA_ANIO_DESC_DE` VARCHAR(45) NULL ,
  `SEMANA_ANIO_DESC_FR` VARCHAR(45) NULL ,
  `SEMANA_ANIO_DESC_IT` VARCHAR(45) NULL ,
  PRIMARY KEY (`SEMANA_ANIO_ID`)); 
  
  
  CREATE  TABLE IF NOT EXISTS D_F_MTD( 
  `DIA_ID` DATE NOT NULL ,
  `MTD_DIA` DATE NULL);
  
  
  CREATE  TABLE IF NOT EXISTS D_F_QTD( 
  `DIA_ID` DATE NOT NULL ,
  `QTD_DIA` DATE NULL);
  
  
  CREATE  TABLE IF NOT EXISTS D_F_YTD( 
  `DIA_ID` DATE NOT NULL ,
  `YTD_DIA` DATE NULL);
    
  
  CREATE  TABLE IF NOT EXISTS D_F_ULT_6_MESES( 
  `MES_ID` INT NOT NULL ,
  `ULT_6_MESES_ID` INT NULL);
	 /* CREATE INDEX D_F_ULT_6_MESES_IX ON D_F_ULT_6_MESES (MES_ID);*/
	select count(INDEX_NAME) into HAY from information_schema.statistics  
			where table_name = 'D_F_ULT_6_MESES' 
				and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'D_F_ULT_6_MESES_IX';
	select count(TABLE_NAME) into HAY_TABLA from information_schema.tables 
			where table_name = 'D_F_ULT_6_MESES' and table_schema = 'bi_cdd_dwh';
	if (HAY < 1 && HAY_TABLA = 1) then 
		CREATE INDEX D_F_ULT_6_MESES_IX ON D_F_ULT_6_MESES (MES_ID);
		set o_error_status:= concat('Se ha insertado el INDICE D_F_ULT_6_MESES_IX. Nº [', HAY, ']');
--	else 
--		set o_error_status:= concat('Ya existe el INDICE D_F_ULT_6_MESES_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
	end if;

  
  
  CREATE  TABLE IF NOT EXISTS D_F_ULT_12_MESES( 
  `MES_ID` INT NOT NULL ,
  `ULT_12_MESES_ID` INT NULL);
	/*  CREATE INDEX D_F_ULT_12_MESES_IX ON D_F_ULT_12_MESES (MES_ID); */
	select count(INDEX_NAME) into HAY from information_schema.statistics 
				where table_name = 'D_F_ULT_12_MESES' 
					and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'D_F_ULT_12_MESES_IX';
	select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  
				where table_name = 'D_F_ULT_12_MESES' 
					and table_schema = 'bi_cdd_dwh';
	if (HAY < 1 && HAY_TABLA = 1) then 
		CREATE INDEX D_F_ULT_12_MESES_IX ON D_F_ULT_12_MESES (MES_ID);
		set o_error_status:= concat('Se ha insertado el INDICE D_F_ULT_12_MESES_IX. Nº [', HAY, ']');
--	else 
--		set o_error_status:= concat('Ya existe el INDICE D_F_ULT_12_MESES_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
	end if;


 CREATE TABLE IF NOT EXISTS TMP_FECHA( 
  `DIA_H` DATE NULL,  -- Fecha H_TEMP
  `DIA_ANT` DATE NULL,  -- Sig fecha
  `SEMANA_H` INT NULL,
  `SEMANA_ANT` INT NULL,
  `MES_H` INT NULL,
  `MES_ANT` INT NULL,
  `TRIMESTRE_H` INT NULL,
  `TRIMESTRE_ANT` INT NULL,
  `ANIO_H` INT NULL,
  `ANIO_ANT` INT NULL
 );

	--  CREATE INDEX TMP_FECHA_DIA_IX ON TMP_FECHA (DIA_H, DIA_ANT);
	select count(INDEX_NAME) into HAY from information_schema.statistics 
				where table_name = 'TMP_FECHA' 
					and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'TMP_FECHA_DIA_IX';
	select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  
				where table_name = 'TMP_FECHA' 
					and table_schema = 'bi_cdd_dwh';
	if (HAY < 1 && HAY_TABLA = 1) then 
		 CREATE INDEX TMP_FECHA_DIA_IX ON TMP_FECHA (DIA_H, DIA_ANT);
		set o_error_status:= concat('Se ha insertado el INDICE TMP_FECHA_DIA_IX. Nº [', HAY, ']');
--	else 
--		set o_error_status:= concat('Ya existe el INDICE TMP_FECHA_DIA_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
	end if;

	-- CREATE INDEX TMP_FECHA_SEMANA_IX ON TMP_FECHA (SEMANA_H, SEMANA_ANT);
	select count(INDEX_NAME) into HAY from information_schema.statistics 
				where table_name = 'TMP_FECHA' 
					and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'TMP_FECHA_SEMANA_IX';
	select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  
				where table_name = 'TMP_FECHA' 
					and table_schema = 'bi_cdd_dwh';
	if (HAY < 1 && HAY_TABLA = 1) then 
		CREATE INDEX TMP_FECHA_SEMANA_IX ON TMP_FECHA (SEMANA_H, SEMANA_ANT);
		set o_error_status:= concat('Se ha insertado el INDICE TMP_FECHA_SEMANA_IX. Nº [', HAY, ']');
--	else 
--		set o_error_status:= concat('Ya existe el INDICE TMP_FECHA_SEMANA_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
	end if;

	-- CREATE INDEX TMP_FECHA_MES_IX ON TMP_FECHA (MES_H, MES_ANT);
	select count(INDEX_NAME) into HAY from information_schema.statistics 
				where table_name = 'TMP_FECHA' 
					and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'TMP_FECHA_MES_IX';
	select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  
				where table_name = 'TMP_FECHA' 
					and table_schema = 'bi_cdd_dwh';
	if (HAY < 1 && HAY_TABLA = 1) then 
		 CREATE INDEX TMP_FECHA_MES_IX ON TMP_FECHA (MES_H, MES_ANT);
		set o_error_status:= concat('Se ha insertado el INDICE TMP_FECHA_MES_IX. Nº [', HAY, ']');
--	else 
--		set o_error_status:= concat('Ya existe el INDICE TMP_FECHA_MES_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
	end if;

	-- CREATE INDEX TMP_FECHA_TRIMESTRE_IX ON TMP_FECHA (TRIMESTRE_H, TRIMESTRE_ANT);
	select count(INDEX_NAME) into HAY from information_schema.statistics 
				where table_name = 'TMP_FECHA' 
					and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'TMP_FECHA_TRIMESTRE_IX';
	select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  
				where table_name = 'TMP_FECHA' 
					and table_schema = 'bi_cdd_dwh';
	if (HAY < 1 && HAY_TABLA = 1) then 
		CREATE INDEX TMP_FECHA_TRIMESTRE_IX ON TMP_FECHA (TRIMESTRE_H, TRIMESTRE_ANT);
		set o_error_status:= concat('Se ha insertado el INDICE TMP_FECHA_TRIMESTRE_IX. Nº [', HAY, ']');
--	else 
--		set o_error_status:= concat('Ya existe el INDICE TMP_FECHA_TRIMESTRE_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
	end if;

	--  CREATE INDEX TMP_FECHA_ANIO_IX ON TMP_FECHA (ANIO_H, ANIO_ANT);
	select count(INDEX_NAME) into HAY from information_schema.statistics 
				where table_name = 'TMP_FECHA' 
					and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'TMP_FECHA_ANIO_IX';
	select count(INDEX_NAME) into HAY_TABLA from information_schema.tables  
				where table_name = 'TMP_FECHA' 
					and table_schema = 'bi_cdd_dwh';
	if (HAY < 1 && HAY_TABLA = 1) then 
		CREATE INDEX TMP_FECHA_ANIO_IX ON TMP_FECHA (ANIO_H, ANIO_ANT);
		set o_error_status:= concat('Se ha insertado el INDICE TMP_FECHA_ANIO_IX. Nº [', HAY, ']');
--	else 
--		set o_error_status:= concat('Ya existe el INDICE TMP_FECHA_ANIO_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
	end if;

 
 CREATE TABLE IF NOT EXISTS TMP_FECHA_AUX( 
  `DIA_AUX` DATE NULL,
  `SEMANA_AUX` INT NULL,
  `MES_AUX` INT NULL,
  `TRIMESTRE_AUX` INT NULL,
  `ANIO_AUX` INT NULL
 );




END MY_BLOCK_DIM_FEC$$
DELIMITER ;
