-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Crear_H_Tareas` $$

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

SET NAMES UTF8 $$

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Crear_H_Tareas`(OUT o_error_status varchar(500))
MY_BLOCK_H_PCR_ESP: BEGIN

-- ===============================================================================================
-- Autor: Enrique Jiménez Diaz, PFS Group
-- Fecha creación: Abril 2015
-- Responsable última modificación:
-- Fecha última modificación:
-- Motivos del cambio:
-- Cliente: Recovery BI Central de Demandas 
--
-- Descripción: Procedimiento almancenado que crea la tabla de hechos Tareas
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


--  TMP_PRC_JERARQUIA_PM: Tabla temporal con todos los procedimientos
DROP TABLE TMP_PRC_JERARQUIA_PM;
CREATE TABLE IF NOT EXISTS TMP_PRC_JERARQUIA_PM(     
  `DIA_ID` DATE NOT NULL, 
  `ITER` DECIMAL(16,0) NOT NULL,
  `FASE_ACTUAL` DECIMAL(16,0) NULL,
  `NIVEL` DECIMAL(2,0) NULL,
  `CONTEXTO` VARCHAR(300) NULL,
  `CODIGO_FASE_ACTUAL` VARCHAR(20) NULL,
  `PRIORIDAD_FASE` DECIMAL(11,0) NOT NULL,
  `CANCELADO_FASE`DECIMAL(11,0) NULL, 
  `ASU_ID` DECIMAL(16,0) NULL, 
  `ENTIDAD_CEDENTE_ID`  DECIMAL(16,0) NULL
 );


--  TMP_PRC_TAREA_PM_ALL: Tabla temporal con todas las tareas
DROP TABLE TMP_PRC_TAREA_PM_ALL;
CREATE TABLE IF NOT EXISTS TMP_PRC_TAREA_PM_ALL(  
  `FECHA` DATE NOT NULL,
  `ITER` DECIMAL(16,0) NOT NULL, 
  `FASE` DECIMAL(16,0) NOT NULL,
  `TAREA` DECIMAL(16,0) NOT NULL,
  `FECHA_INI` DATE NULL,
  `FECHA_FIN` DATE NULL,
  `FECHA_VENCIMIENTO` DATE NULL,
  `FECHA_VENCIMIENTO_REAL` DATE NULL,  
  `DESCRIPCION_TAREA` VARCHAR(50) NULL,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL,
  `FECHA_INTERPOSICION_DEMANDA`DECIMAL(16,0) NULL, -- Calculo 1
  `NUM_DIAS_INTERPOS` DECIMAL(16,0) NULL, -- Calculo 2
  `CATEGORIA_PLAZO_MEDIO`  DECIMAL(16,0)  NULL, -- Calculo 3
  `FECHA_VALOR_TAREA` DATE NULL,
  `FECHA_CONFOR_ASUNTO` DATE NULL
 );
 
CREATE INDEX TMP_PRC_TAREA_PM_ALL_IX ON bi_cdd_dwh.TMP_PRC_TAREA_PM_ALL(ITER,CATEGORIA_PLAZO_MEDIO,ENTIDAD_CEDENTE_ID,TAREA);
 
--  TMP_PRC_TAREA_PM_INT: Tabla temporal con todas las tareas con interposicion de la demanda
DROP TABLE TMP_PRC_TAREA_PM_INT;
CREATE TABLE IF NOT EXISTS TMP_PRC_TAREA_PM_INT(
  `FECHA` DATE NOT NULL,
  `ITER` DECIMAL(16,0) NOT NULL, 
  `FASE` DECIMAL(16,0) NOT NULL,
  `TAREA` DECIMAL(16,0) NOT NULL,
  `FECHA_INI` DATE NULL,
  `FECHA_FIN` DATE NULL,
  `FECHA_VENCIMIENTO` DATE NULL,
  `FECHA_VENCIMIENTO_REAL` DATE NULL,  
  `DESCRIPCION_TAREA` VARCHAR(50) NULL,
  `TAP_ID` DECIMAL(16,0) NULL,
  `TEX_ID` DECIMAL(16,0) NULL,
  `DESCRIPCION_FORMULARIO` VARCHAR(250) NULL, 
  `FECHA_FORMULARIO` DATE NULL,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL
);

-- TMP_PLAZO_MEDIO_BYPASS: Temporal para el precaulculo de los plazos medios
DROP TABLE TMP_PLAZO_MEDIO_BYPASS;
CREATE TABLE IF NOT EXISTS TMP_PLAZO_MEDIO_BYPASS(     
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL,
  `CATEGORIA_PLAZO_MEDIO` DECIMAL(16,0) NOT NULL,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL, 
  `TAREA_CALC` DECIMAL(16,0) NOT NULL,
  `FECHA` DATE NULL
);

CREATE INDEX TMP_PLAZO_MEDIO_BYPASS_IX ON bi_cdd_dwh.TMP_PLAZO_MEDIO_BYPASS(PROCEDIMIENTO_ID,CATEGORIA_PLAZO_MEDIO,ENTIDAD_CEDENTE_ID);

-- TMP_PLAZO_MEDIO: Temporal con los plazos medios
DROP TABLE TMP_PLAZO_MEDIO;
CREATE TABLE IF NOT EXISTS TMP_PLAZO_MEDIO(     
  `FECHA_CARGA_DATOS` DATE NULL,
  `DIA_ID` DATE NOT NULL,
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL, 
  `CATEGORIA_PLAZO_MEDIO` DECIMAL(16,0) NOT NULL, 
  `NUM_DIAS_INTERPOS` DECIMAL(11,0) NULL, 
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL,
  `COLUM_DOMMY` DECIMAL(16,0) NULL,
  `FECHA_INTERPOS_DEMANDA` DATE NULL,
  `FECHA_FIN_TAREA` DATE NULL,
  `TAR_CAM_PM` DECIMAL(16,0) NULL,
  `ASUNTO_ID` DECIMAL(16,0) NULL,
  `ESTADO_FASE_ACTUAL_ID` DECIMAL(16,0) NULL,
  `FASE_ACTUAL_DETALLE_ID` DECIMAL(16,0) NULL,
  `NUM_DIAS_INTERPOS2`DECIMAL(16,0) NULL,
  `FECHA_VALOR_TAREA` DATE NULL
); 

--	

DROP TABLE H_TAR;

CREATE TABLE IF NOT EXISTS H_TAR(
  `DIA_ID` DATE NOT NULL,  
  `FECHA_CARGA_DATOS` DATE NOT NULL,         -- Fecha último día cargado
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL, -- ID de la primera fase del procedimiento (PRC_PRC_ID = NULL). Identifica al procedimiento (Secuencia de actuaciones)
  `FASE_MAX_PRIORIDAD` DECIMAL(16,0) NULL,       -- ID de la fase con mayor prioridad (Si hay varias de igual prioridad la última cronológicamente)
  `ASUNTO_ID` DECIMAL(16,0) NULL,  -- Asunto al que pertenece el procedimiento
  `ITER` DECIMAL(16,0) NOT NULL, 
  `FASE` DECIMAL(16,0) NOT NULL,
  `TAREA` DECIMAL(16,0) NOT NULL,
  `FECHA_INI` DATE NULL,
  `FECHA_FIN` DATE NULL,
  `FECHA_VENCIMIENTO` DATE NULL,
  `FECHA_VENCIMIENTO_REAL` DATE NULL,  
  `DESCRIPCION_TAREA` VARCHAR(50) NULL,
  `TAP_ID` DECIMAL(16,0) NULL,
  `TEX_ID` DECIMAL(16,0) NULL,
  `DESCRIPCION_FORMULARIO` VARCHAR(250) NULL, 
  `FECHA_FORMULARIO` DATE NULL,
  `CUMPLIMIENTO`  DECIMAL(16,0) NULL,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL
);

-- XXXXXXXXXXXXXXXXXXXXXXXX

DROP TABLE H_TAR_MES;

CREATE TABLE IF NOT EXISTS H_TAR_MES(
  `MES_ID` DECIMAL(16,0) NOT NULL,      -- Mes de análisis 
  `FECHA_CARGA_DATOS` DATE NOT NULL,         -- Fecha último día cargado
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL, -- ID de la primera fase del procedimiento (PRC_PRC_ID = NULL). Identifica al procedimiento (Secuencia de actuaciones)
  `FASE_MAX_PRIORIDAD` DECIMAL(16,0) NULL,       -- ID de la fase con mayor prioridad (Si hay varias de igual prioridad la última cronológicamente)
  `ASUNTO_ID` DECIMAL(16,0) NULL,  -- Asunto al que pertenece el procedimiento
  `ITER` DECIMAL(16,0) NOT NULL, 
  `FASE` DECIMAL(16,0) NOT NULL,
  `TAREA` DECIMAL(16,0) NOT NULL,
  `FECHA_INI` DATE NULL,
  `FECHA_FIN` DATE NULL,
  `FECHA_VENCIMIENTO` DATE NULL,
  `FECHA_VENCIMIENTO_REAL` DATE NULL,  
  `DESCRIPCION_TAREA` VARCHAR(50) NULL,
  `TAP_ID` DECIMAL(16,0) NULL,
  `TEX_ID` DECIMAL(16,0) NULL,
  `DESCRIPCION_FORMULARIO` VARCHAR(250) NULL, 
  `FECHA_FORMULARIO` DATE NULL,
  `CUMPLIMIENTO`  DECIMAL(16,0) NULL,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL
);

-- XXXXXXXXXXXXXXXXXXXXXXXX

DROP TABLE H_TAR_TRIMESTRE;

CREATE TABLE IF NOT EXISTS H_TAR_TRIMESTRE(
  `TRIMESTRE_ID` DECIMAL(16,0) NOT NULL,      -- Mes de análisis 
  `FECHA_CARGA_DATOS` DATE NOT NULL,         -- Fecha último día cargado
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL, -- ID de la primera fase del procedimiento (PRC_PRC_ID = NULL). Identifica al procedimiento (Secuencia de actuaciones)
  `FASE_MAX_PRIORIDAD` DECIMAL(16,0) NULL,       -- ID de la fase con mayor prioridad (Si hay varias de igual prioridad la última cronológicamente)
  `ASUNTO_ID` DECIMAL(16,0) NULL,  -- Asunto al que pertenece el procedimiento
  `ITER` DECIMAL(16,0) NOT NULL, 
  `FASE` DECIMAL(16,0) NOT NULL,
  `TAREA` DECIMAL(16,0) NOT NULL,
  `FECHA_INI` DATE NULL,
  `FECHA_FIN` DATE NULL,
  `FECHA_VENCIMIENTO` DATE NULL,
  `FECHA_VENCIMIENTO_REAL` DATE NULL,  
  `DESCRIPCION_TAREA` VARCHAR(50) NULL,
  `TAP_ID` DECIMAL(16,0) NULL,
  `TEX_ID` DECIMAL(16,0) NULL,
  `DESCRIPCION_FORMULARIO` VARCHAR(250) NULL, 
  `FECHA_FORMULARIO` DATE NULL,
  `CUMPLIMIENTO`  DECIMAL(16,0) NULL,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL
);


-- XXXXXXXXXXXXXXXXXXXXXXXX

DROP TABLE H_TAR_ANIO;

CREATE TABLE IF NOT EXISTS H_TAR_ANIO(
  `ANIO_ID` DECIMAL(16,0) NOT NULL,      -- Mes de análisis 
  `FECHA_CARGA_DATOS` DATE NOT NULL,         -- Fecha último día cargado
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL, -- ID de la primera fase del procedimiento (PRC_PRC_ID = NULL). Identifica al procedimiento (Secuencia de actuaciones)
  `FASE_MAX_PRIORIDAD` DECIMAL(16,0) NULL,       -- ID de la fase con mayor prioridad (Si hay varias de igual prioridad la última cronológicamente)
  `ASUNTO_ID` DECIMAL(16,0) NULL,  -- Asunto al que pertenece el procedimiento
  `ITER` DECIMAL(16,0) NOT NULL, 
  `FASE` DECIMAL(16,0) NOT NULL,
  `TAREA` DECIMAL(16,0) NOT NULL,
  `FECHA_INI` DATE NULL,
  `FECHA_FIN` DATE NULL,
  `FECHA_VENCIMIENTO` DATE NULL,
  `FECHA_VENCIMIENTO_REAL` DATE NULL,  
  `DESCRIPCION_TAREA` VARCHAR(50) NULL,
  `TAP_ID` DECIMAL(16,0) NULL,
  `TEX_ID` DECIMAL(16,0) NULL,
  `DESCRIPCION_FORMULARIO` VARCHAR(250) NULL, 
  `FECHA_FORMULARIO` DATE NULL,
  `CUMPLIMIENTO`  DECIMAL(16,0) NULL,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL
);

-- GENERACIÓN DE INDICES. 
-- ***** 
-- H_TAR_IX
select count(INDEX_NAME) into HAY from information_schema.statistics  
	where table_name = 'H_TAR' 
		and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_TAR_IX';
		
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  
	where table_name = 'H_TAR' and table_schema = 'bi_cdd_dwh';
	
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX H_TAR_IX ON H_TAR (DIA_ID, TAREA, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_TAR_IX. Nº [', HAY, ']');
end if;
-- H_TAR_FASE_MAX_PRIOR_IX
select count(INDEX_NAME) into HAY from information_schema.statistics  
	where table_name = 'H_TAR' 
		and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_TAR_FASE_MAX_PRIOR_IX';
		
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  
	where table_name = 'H_TAR' and table_schema = 'bi_cdd_dwh';
	
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX H_PRC_FASE_ACTUAL_IX ON H_TAR (DIA_ID, FASE_MAX_PRIORIDAD, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_TAR_FASE_MAX_PRIOR_IX. Nº [', HAY, ']');
end if;

-- MES
-- H_TAR_MES_IX
select count(INDEX_NAME) into HAY from information_schema.statistics  
	where table_name = 'H_TAR_MES' 
		and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_TAR_MES_IX';
		
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  
	where table_name = 'H_TAR_MES' and table_schema = 'bi_cdd_dwh';
	
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX H_TAR_MES_IX ON H_TAR_MES (MES_ID, TAREA, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_TAR_MES_IX. Nº [', HAY, ']');
end if;
-- H_TAR_MES_FASE_MAX_PRIOR_IX
select count(INDEX_NAME) into HAY from information_schema.statistics  
	where table_name = 'H_TAR_MES' 
		and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_TAR_MES_FASE_MAX_PRIOR_IX';
		
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  
	where table_name = 'H_TAR_MES' and table_schema = 'bi_cdd_dwh';
	
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX H_TAR_MES_FASE_MAX_PRIOR_IX ON  H_TAR_MES (MES_ID, FASE_MAX_PRIORIDAD, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_TAR_MES_FASE_MAX_PRIOR_IX. Nº [', HAY, ']');
end if;

-- TRIMESTRE
select count(INDEX_NAME) into HAY from information_schema.statistics  
	where table_name = 'H_TAR_TRIMESTRE' 
		and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_TAR_TRIMESTRE_IX';
		
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  
	where table_name = 'H_TAR_TRIMESTRE' and table_schema = 'bi_cdd_dwh';
	
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX H_TAR_TRIMESTRE_IX ON H_TAR_TRIMESTRE (TRIMESTRE_ID, TAREA, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_TAR_TRIMESTRE_IX. Nº [', HAY, ']');
end if;
-- H_TAR_TRIM_FASE_MAX_PRIOR_IX
select count(INDEX_NAME) into HAY from information_schema.statistics  
	where table_name = 'H_TAR_TRIMESTRE' 
		and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_TAR_TRIM_FASE_MAX_PRIOR_IX';
		
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  
	where table_name = 'H_TAR_TRIMESTRE' and table_schema = 'bi_cdd_dwh';
	
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX H_TAR_TRIM_FASE_MAX_PRIOR_IX ON H_TAR_TRIMESTRE (TRIMESTRE_ID, FASE_MAX_PRIORIDAD, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_TAR_TRIM_FASE_MAX_PRIOR_IX. Nº [', HAY, ']');
end if;

-- ANIO
select count(INDEX_NAME) into HAY from information_schema.statistics  
	where table_name = 'H_TAR_ANIO' 
		and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_TAR_ANIO_IX';
		
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  
	where table_name = 'H_TAR_ANIO' and table_schema = 'bi_cdd_dwh';
	
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX H_TAR_ANIO_IX ON H_TAR_ANIO (ANIO_ID, TAREA, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_TAR_ANIO_IX. Nº [', HAY, ']');
end if;
-- H_TAR_ANIO_FASE_MAX_PRIOR_IX
select count(INDEX_NAME) into HAY from information_schema.statistics  
	where table_name = 'H_TAR_ANIO' 
		and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_TAR_ANIO_FASE_MAX_PRIOR_IX';
		
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  
	where table_name = 'H_TAR_ANIO' and table_schema = 'bi_cdd_dwh';
	
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX H_TAR_ANIO_FASE_MAX_PRIOR_IX ON H_TAR_ANIO (ANIO_ID, FASE_MAX_PRIORIDAD, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_TAR_ANIO_FASE_MAX_PRIOR_IX. Nº [', HAY, ']');
end if;
 
END MY_BLOCK_H_PCR_ESP
