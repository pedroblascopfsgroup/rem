-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Crear_H_Procedimiento_Especifico` $$

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

SET NAMES UTF8 $$

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Crear_H_Procedimiento_Especifico`(OUT o_error_status varchar(500))
MY_BLOCK_H_PCR_ESP: BEGIN

-- ===============================================================================================
-- Autor: Joaquin Arnal Diaz, PFS Group
-- Fecha creación: Marzo 2015
-- Responsable última modificación:María Villanueva, PFS Group
-- Fecha última modificación:12/11/2015
-- Motivos del cambio:se modifica H_PRC_PLAZO_MEDIO
-- Cliente: Recovery BI Central de Demandas 
--
-- Descripción: Procedimiento almancenado que crea la tabla de hechos Procedimiento Especifico.
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
CREATE TABLE TMP_PRC_JERARQUIA_PM(     
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
CREATE TABLE TMP_PRC_TAREA_PM_ALL(  
  `FECHA` DATE NOT NULL,
  `ITER` DECIMAL(16,0) NOT NULL, 
  `FASE` DECIMAL(16,0) NOT NULL,
  `TAREA` DECIMAL(16,0) NOT NULL,
  `FECHA_INI` DATE NULL,
  `FECHA_FIN` DATE NULL,
  `DESCRIPCION_TAREA` VARCHAR(50) NULL,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL,
  `FECHA_INTERPOSICION_DEMANDA`DECIMAL(16,0) NULL, -- Calculo 1
  `NUM_DIAS_INTERPOS` DECIMAL(16,0) NULL, -- Calculo 2
  `CATEGORIA_PLAZO_MEDIO`  DECIMAL(16,0)  NULL -- Calculo 3
 );
 
CREATE INDEX TMP_PRC_TAREA_PM_ALL_IX ON bi_cdd_dwh.TMP_PRC_TAREA_PM_ALL(ITER,CATEGORIA_PLAZO_MEDIO,ENTIDAD_CEDENTE_ID,TAREA);
 
--  TMP_PRC_TAREA_PM_INT: Tabla temporal con todas las tareas con interposicion de la demanda
DROP TABLE TMP_PRC_TAREA_PM_INT;
CREATE TABLE TMP_PRC_TAREA_PM_INT(
  `FECHA` DATE NOT NULL,
  `ITER` DECIMAL(16,0) NOT NULL, 
  `FASE` DECIMAL(16,0) NOT NULL,
  `TAREA` DECIMAL(16,0) NOT NULL,
  `FECHA_INI` DATE NULL,
  `FECHA_FIN` DATE NULL,
  `DESCRIPCION_TAREA` VARCHAR(50) NULL,
  `TAP_ID` DECIMAL(16,0) NULL,
  `TEX_ID` DECIMAL(16,0) NULL,
  `DESCRIPCION_FORMULARIO` VARCHAR(250) NULL, 
  `FECHA_FORMULARIO` DATE NULL,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL
);

-- TMP_PLAZO_MEDIO_BYPASS: Temporal para el precaulculo de los plazos medios
DROP TABLE TMP_PLAZO_MEDIO_BYPASS;
CREATE TABLE TMP_PLAZO_MEDIO_BYPASS(     
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL,
  `CATEGORIA_PLAZO_MEDIO` DECIMAL(16,0) NOT NULL,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL, 
  `TAREA_CALC` DECIMAL(16,0) NOT NULL
);

CREATE INDEX TMP_PLAZO_MEDIO_BYPASS_IX ON bi_cdd_dwh.TMP_PLAZO_MEDIO_BYPASS(PROCEDIMIENTO_ID,CATEGORIA_PLAZO_MEDIO,ENTIDAD_CEDENTE_ID);

-- TMP_PLAZO_MEDIO: Temporal con los plazos medios
DROP TABLE TMP_PLAZO_MEDIO;
CREATE TABLE TMP_PLAZO_MEDIO(     
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
  `NUM_DIAS_INTERPOS2`DECIMAL(16,0) NULL
); 
DROP TABLE H_PRC_PLAZO_MEDIO;
CREATE TABLE H_PRC_PLAZO_MEDIO(
  `DIA_ID` date NOT NULL,
  `FECHA_CARGA_DATOS` date NOT NULL,
  `PROCEDIMIENTO_ID` decimal(16,0) NOT NULL,
  `CATEGORIA_PLAZO_MEDIO` decimal(16,0) DEFAULT NULL,
  `NUM_DIAS_INTERPOS` int(11) NOT NULL DEFAULT '0',
  `ENTIDAD_CEDENTE_ID` decimal(16,0) NOT NULL,
  `colum_dommy` int(11) DEFAULT '1',
  `FECHA_INTERPOS_DEMANDA` date DEFAULT NULL,
  `FECHA_FIN_TAREA` date DEFAULT NULL,
  `TAR_CAT_PM` decimal(16,0) DEFAULT NULL,
  `ASUNTO_ID` decimal(16,0) DEFAULT NULL,
  `ESTADO_FASE_ACTUAL_ID` decimal(16,0) DEFAULT NULL,
  `FASE_ACTUAL_DETALLE_ID` decimal(16,0) DEFAULT NULL,
  `NUM_DIAS_INTERPOS_2` int(11) NOT NULL DEFAULT '0',
  `FECHA_VALOR_TAREA` date DEFAULT NULL,
  `ULT_TAR_FIN_DESC_ID` decimal(16,0) DEFAULT NULL,
  `PLAZA_ID` decimal(16,0) DEFAULT NULL,
  `JUZGADO_ID` decimal(16,0) DEFAULT NULL,
  `PROCURADOR_ID` decimal(16,0) DEFAULT NULL,
  `PRC_CON_OPOSICION_ID` decimal(16,0) DEFAULT NULL,
  `FASE_TAREA_DETALLE_ID` decimal(16,0) DEFAULT NULL,
  KEY `H_PRC_PLAZO_MEDIO_IX` (`DIA_ID`,`PROCEDIMIENTO_ID`,`ENTIDAD_CEDENTE_ID`),
  KEY `H_PRC_PLAZO_MEDIO_IX2` (`CATEGORIA_PLAZO_MEDIO`),
  KEY `H_PRC_PLAZO_MEDIO_IX3` (`PROCEDIMIENTO_ID`)
);

 
 
END MY_BLOCK_H_PCR_ESP
