-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Crear_H_Prc_Cobros` $$

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

SET NAMES UTF8 $$

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Crear_H_Prc_Cobros`(OUT o_error_status varchar(500))
MY_BLOCK_CREAR_H_PRC_COBROS: BEGIN

-- ===============================================================================================
-- Autor: Joaquín Arnal, PFS Group
-- Fecha creación: Marzo 2015
-- Responsable última modificación: 
-- Fecha última modificación: 
-- Motivos del cambio: 
-- Cliente: Recovery BI Central de Demandas 
--
-- Descripción: Procedimiento almancenado que crea las tablas de hecho de H_PRC_DET_COBRO.
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

	select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PRC_DET_COBRO' and table_schema = 'bi_cdd_dwh';
	if (HAY_TABLA > 0) then 
	    DROP TABLE H_PRC_DET_COBRO;
		-- set o_error_status:= concat('Se ha borrado la tabla H_PRC_DET_COBRO. Nº [', HAY_TABLA, ']');
	end if;
 
	CREATE TABLE H_PRC_DET_COBRO(  
	  	`DIA_ID` DATE NULL,
		`FECHA_CARGA_DATOS` DATE NOT NULL,
		`ID_COBRO` DECIMAL(16,0) NOT NULL,
		`PROCEDIMIENTO_ID` DECIMAL(16,0) NULL,
		`ASUNTO_ID` DECIMAL(16,0) NOT NULL,
		`CONTRATO_ID` DECIMAL(16,0) NULL,
		`FECHA_COBRO` DATE NULL,
		`FECHA_ASUNTO` DATE NULL,
		`TIPO_PAGO_ID` DECIMAL(16,0) NULL,
		`SUBTIPO_PAGO_ID` DECIMAL(16,0) NULL,
		`ESTADO_PAGO_ID` DECIMAL(16,0) NULL,
		`NUM_COBROS` DECIMAL(16,0) NULL,
		`IMPORTE_COBRO` DECIMAL(16,0) NOT NULL,
		`NUM_DIAS_CREACION_ASU_COBRO` DECIMAL(16,0) NULL,
		`ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL
	);
	
	select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PRC_DET_COBRO_MES' and table_schema = 'bi_cdd_dwh';
	if (HAY_TABLA > 0) then 
	    DROP TABLE H_PRC_DET_COBRO_MES;
		-- set o_error_status:= concat('Se ha borrado la tabla H_PRC_DET_COBRO. Nº [', HAY_TABLA, ']');
	end if;
	
	CREATE TABLE H_PRC_DET_COBRO_MES(  
	  	`DIA_ID` DATE NULL,
	  	`MES_ID` INT NOT NULL,
		`FECHA_CARGA_DATOS` DATE NOT NULL,
		`ID_COBRO` DECIMAL(16,0) NOT NULL,
		`PROCEDIMIENTO_ID` DECIMAL(16,0) NULL,
		`ASUNTO_ID` DECIMAL(16,0) NOT NULL,
		`CONTRATO_ID` DECIMAL(16,0) NULL,
		`FECHA_COBRO` DATE NULL,
		`FECHA_ASUNTO` DATE NULL,
		`TIPO_PAGO_ID` DECIMAL(16,0) NULL,
		`SUBTIPO_PAGO_ID` DECIMAL(16,0) NULL,
		`ESTADO_PAGO_ID` DECIMAL(16,0) NULL,
		`NUM_COBROS` DECIMAL(16,0) NULL,
		`IMPORTE_COBRO` DECIMAL(16,0) NOT NULL,
		`NUM_DIAS_CREACION_ASU_COBRO` DECIMAL(16,0) NULL,
		`ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL
	);
	
	select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PRC_DET_COBRO_TRIMESTRE' and table_schema = 'bi_cdd_dwh';
	if (HAY_TABLA > 0) then 
	    DROP TABLE H_PRC_DET_COBRO_TRIMESTRE;
		-- set o_error_status:= concat('Se ha borrado la tabla H_PRC_DET_COBRO. Nº [', HAY_TABLA, ']');
	end if;
	
	CREATE TABLE H_PRC_DET_COBRO_TRIMESTRE(  
	  	`TRIMESTRE_ID` INT NOT NULL,
		`FECHA_CARGA_DATOS` DATE NOT NULL,
		`ID_COBRO` DECIMAL(16,0) NOT NULL,
		`PROCEDIMIENTO_ID` DECIMAL(16,0) NULL,
		`ASUNTO_ID` DECIMAL(16,0) NOT NULL,
		`CONTRATO_ID` DECIMAL(16,0) NULL,
		`FECHA_COBRO` DATE NULL,
		`FECHA_ASUNTO` DATE NULL,
		`TIPO_PAGO_ID` DECIMAL(16,0) NULL,
		`SUBTIPO_PAGO_ID` DECIMAL(16,0) NULL,
		`ESTADO_PAGO_ID` DECIMAL(16,0) NULL,
		`NUM_COBROS` DECIMAL(16,0) NULL,
		`IMPORTE_COBRO` DECIMAL(16,0) NOT NULL,
		`NUM_DIAS_CREACION_ASU_COBRO` DECIMAL(16,0) NULL,
		`ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL
	);
	
	select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PRC_DET_COBRO_ANIO' and table_schema = 'bi_cdd_dwh';
	if (HAY_TABLA > 0) then 
	    DROP TABLE H_PRC_DET_COBRO_ANIO;
		-- set o_error_status:= concat('Se ha borrado la tabla H_PRC_DET_COBRO. Nº [', HAY_TABLA, ']');
	end if;
	
	CREATE TABLE H_PRC_DET_COBRO_ANIO(  
	  	`ANIO_ID` INT NOT NULL,
		`FECHA_CARGA_DATOS` DATE NOT NULL,
		`ID_COBRO` DECIMAL(16,0) NOT NULL,
		`PROCEDIMIENTO_ID` DECIMAL(16,0) NULL,
		`ASUNTO_ID` DECIMAL(16,0) NOT NULL,
		`CONTRATO_ID` DECIMAL(16,0) NULL,
		`FECHA_COBRO` DATE NULL,
		`FECHA_ASUNTO` DATE NULL,
		`TIPO_PAGO_ID` DECIMAL(16,0) NULL,
		`SUBTIPO_PAGO_ID` DECIMAL(16,0) NULL,
		`ESTADO_PAGO_ID` DECIMAL(16,0) NULL,
		`NUM_COBROS` DECIMAL(16,0) NULL,
		`IMPORTE_COBRO` DECIMAL(16,0) NOT NULL,
		`NUM_DIAS_CREACION_ASU_COBRO` DECIMAL(16,0) NULL,
		`ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL
	);
	
	
	-- ** CREACION DE INDICES **
	select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'H_PRC_DET_COBRO' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_PRC_DET_COBRO_IX';
	select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'H_PRC_DET_COBRO' and table_schema = 'bi_cdd_dwh';
		if (HAY < 1 && HAY_TABLA = 1) then 
			CREATE INDEX H_PRC_DET_COBRO_IX ON H_PRC_DET_COBRO (DIA_ID, PROCEDIMIENTO_ID, ENTIDAD_CEDENTE_ID);
		end if;
		if (HAY_TABLA = 1) then
			DROP INDEX H_PRC_DET_COBRO_IX ON H_PRC_DET_COBRO;
			CREATE INDEX H_PRC_DET_COBRO_IX ON H_PRC_DET_COBRO (DIA_ID, PROCEDIMIENTO_ID, ENTIDAD_CEDENTE_ID);
		end if;

	select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'H_PRC_DET_COBRO_MES' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_PRC_DET_COBRO_MES_IX';
	select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'H_PRC_DET_COBRO_MES' and table_schema = 'bi_cdd_dwh';
		if (HAY < 1 && HAY_TABLA = 1) then 
			CREATE INDEX H_PRC_DET_COBRO_MES_IX ON H_PRC_DET_COBRO_MES (MES_ID, PROCEDIMIENTO_ID, ENTIDAD_CEDENTE_ID);
		end if;
		if (HAY_TABLA = 1) then
			DROP INDEX H_PRC_DET_COBRO_MES_IX ON H_PRC_DET_COBRO_MES;
			CREATE INDEX H_PRC_DET_COBRO_MES_IX ON H_PRC_DET_COBRO_MES (MES_ID, PROCEDIMIENTO_ID, ENTIDAD_CEDENTE_ID);
		end if;
	
	select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'H_PRC_DET_COBRO_TRIMESTRE' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_PRC_DET_COBRO_TRIMESTRE_IX';
	select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'H_PRC_DET_COBRO_TRIMESTRE' and table_schema = 'bi_cdd_dwh';
		if (HAY < 1 && HAY_TABLA = 1) then 
			CREATE INDEX H_PRC_DET_COBRO_TRIMESTRE_IX ON H_PRC_DET_COBRO_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID, ENTIDAD_CEDENTE_ID);
		end if;
		if (HAY_TABLA = 1) then
			DROP INDEX H_PRC_DET_COBRO_TRIMESTRE_IX ON H_PRC_DET_COBRO_TRIMESTRE;
			CREATE INDEX H_PRC_DET_COBRO_TRIMESTRE_IX ON H_PRC_DET_COBRO_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID, ENTIDAD_CEDENTE_ID);
		end if;
	
	select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'H_PRC_DET_COBRO_ANIO' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_PRC_DET_COBRO_ANIO_IX';
	select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'H_PRC_DET_COBRO_ANIO' and table_schema = 'bi_cdd_dwh';
		if (HAY < 1 && HAY_TABLA = 1) then 
			CREATE INDEX H_PRC_DET_COBRO_ANIO_IX ON H_PRC_DET_COBRO_ANIO (ANIO_ID, PROCEDIMIENTO_ID, ENTIDAD_CEDENTE_ID);
		end if;
		if (HAY_TABLA = 1) then
			DROP INDEX H_PRC_DET_COBRO_ANIO_IX ON H_PRC_DET_COBRO_ANIO;
			CREATE INDEX H_PRC_DET_COBRO_ANIO_IX ON H_PRC_DET_COBRO_ANIO (ANIO_ID, PROCEDIMIENTO_ID, ENTIDAD_CEDENTE_ID);
		end if;
 
END MY_BLOCK_CREAR_H_PRC_COBROS
