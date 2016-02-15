-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`lindorff`@`62.15.160.2` PROCEDURE `Crear_H_Tarea_Finalizada`(OUT o_error_status varchar(500))
MY_BLOCK_H_TAR: BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Septiembre 2013
-- Responsable última modificación: Gonzalo Martín, PFS Group
-- Fecha última modificación: 10/12/2013
-- Motivos del cambio: SP Lindorff v0
-- Cliente: Recovery BI Lindorff  
--
-- Descripción: Procedimiento almancenado que crea la tabla de hechos Tarea Finalizada.
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


-- =========================================================================================================================
--                                                 TABLAS DE HECHOS
-- =========================================================================================================================
  
 CREATE TABLE IF NOT EXISTS H_TAREA_FINALIZADA( 
  `DIA_FINALIZACION_TAREA_ID` DATE NOT NULL, 
  `FECHA_CARGA_DATOS` DATE NOT NULL,                                    -- Fecha último día cargado
  `TAREA_ID` DECIMAL(16,0) NOT NULL, 
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NULL,                                -- ID de la primera fase del procedimiento (PRC_PRC_ID = NULL). Identifica al procedimiento (Secuencia de actuaciones)
  `FASE_ACTUAL_PROCEDIMIENTO` DECIMAL(16,0) NULL,  
  `ASUNTO_ID` DECIMAL(16,0) NULL,                                       -- Asunto al que pertenece el procedimiento
  `FECHA_CREACION_TAREA` DATE NULL,
  `FECHA_VENCIMIENTO_ORIGINAL_TAREA` DATE NULL,
  `FECHA_VENCIMIENTO_TAREA` DATE NULL, 
  -- Dimensiones
  `RESPONSABLE_TAREA_ID` DECIMAL(16,0) NULL,   
  `TIPO_PROCEDIMIENTO_DETALLE_ID` DECIMAL(16,0) NULL,  
  `CARTERA_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL ,
  `PROPIETARIO_CONTRATO_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL , 
  `GESTOR_EN_RECOVERY_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL ,    
  -- Métricas
  `NUM_TAREAS_FINALIZADAS` INT NULL,  
  `DURACION_TAREA_FINALIZADA` INT NULL,  
  `NUM_DIAS_VENCIDO` INT NULL
 );
 

-- =========================================================================================================================
--                                                 TABLAS TEMPORALES
-- =========================================================================================================================
 CREATE TABLE IF NOT EXISTS TEMP_TAREA_JERARQUIA (
  `DIA_ID` DATE NOT NULL,                               
  `ITER` DECIMAL(16,0) NOT NULL,   
  `FASE_ACTUAL` DECIMAL(16,0) NULL
  ); 


END MY_BLOCK_H_TAR
