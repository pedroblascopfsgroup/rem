-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Crear_H_Procedimiento` $$

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

SET NAMES UTF8 $$

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Crear_H_Procedimiento`(OUT o_error_status varchar(500))
MY_BLOCK_H_PCR: BEGIN

-- ===============================================================================================
-- Autor: Enrique Jiménez Diaz, PFS Group
-- Fecha creación: Noviembre 2014
-- Responsable última modificación: María Villanueva, PFS Group
-- Fecha última modificación: 29/02/2016
-- Motivos del cambio: Se añade FASE_TAREA_AGR_ID
-- Cliente: Recovery BI Central de Demandas 
--
-- Descripción: Procedimiento almancenado que crea la tabla de hechos Procedimiento.
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


-- ----------------------------------------------------------------------------------------------
--                                      TABLAS DE HECHOS
-- ----------------------------------------------------------------------------------------------
DROP TABLE H_PRC;
  
CREATE TABLE IF NOT EXISTS H_PRC( 
  `DIA_ID` DATE NOT NULL,  
  `FECHA_CARGA_DATOS` DATE NOT NULL,         -- Fecha último día cargado
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL, -- ID de la primera fase del procedimiento (PRC_PRC_ID = NULL). Identifica al procedimiento (Secuencia de actuaciones)
  `FASE_MAX_PRIORIDAD` DECIMAL(16,0) NULL,   -- ID de la fase con mayor prioridad (Si hay varias de igual prioridad la última cronológicamente)
  `FASE_ANTERIOR` DECIMAL(16,0) NULL, -- ID de la penúltima fase del procedimiento (padre de la última fase)
  `FASE_ACTUAL` DECIMAL(16,0) NULL, -- ID de la última fase del procedimiento (fase con la última tarea o de mayor ID si el procedimiento no tiene tareas asociadas)
  `ULT_TAR_CREADA` DECIMAL(16,0) NULL, -- ID de la última tarea creada asociada al procedimiento (indica la fase actual)
  `ULT_TAR_FIN` DECIMAL(16,0) NULL, -- ID de la última tarea finalizada asociada al procedimiento 
  `ULTIMA_TAREA_ACTUALIZADA` DECIMAL(16,0) NULL, -- ID de la última tarea actualizada asociada al procedimiento
  `ULT_TAR_PEND` DECIMAL(16,0) NULL, -- ID de la última tarea pendiente asociada al procedimiento (última creada no finalizada)
  `FECHA_CREACION_ASUNTO` DATE NULL,
  `FECHA_CONTABLE_LITIGIO` DATE NULL, -- DD_IFC_ID =12
  `FECHA_CREACION_PROCEDIMIENTO` DATE NULL,
  `FECHA_CREACION_FASE_MAX_PRIO` DATE NULL,
  `FECHA_CREACION_FASE_ANTERIOR` DATE NULL, 
  `FECHA_CREACION_FASE_ACTUAL` DATE NULL, 
  `FECHA_ULT_TAR_CREADA` DATE NULL, 
  `FECHA_ULT_TAR_FIN` DATE NULL, 
  `FECHA_ULTIMA_TAREA_ACTUALIZADA` DATE NULL,    -- Fecha de actualización de la última tarea actualizada
  `FECHA_ULT_TAR_PEND` DATE NULL,      -- Fecha de creación de la última tarea pendiente
  `FECHA_VENC_ORIG_ULT_TAR_FIN` DATE NULL, 
  `FECHA_VENC_ACT_ULT_TAR_FIN` DATE NULL,
  `FECHA_VENC_ORIG_ULT_TAR_PEND` DATE NULL, 
  `FECHA_VENC_ACT_ULT_TAR_PEND` DATE NULL,
  `FECHA_ACEPTACION` DATE NULL,    -- Fecha de Trámite de aceptación y decisión (Fecha final de la tarea "Registrar toma de decisión" 
  `FECHA_RECOGIDA_DOC_Y_ACEPT` DATE NULL,   -- Fecha fin de la tarea Recogida de documentación y aceptación (Trámite de aceptación y decisión)
  `FECHA_REGISTRAR_TOMA_DECISION` DATE NULL,     -- Fecha fin de la tarea Registrar toma de decisión (Trámite de aceptación y decisión) 
  `FECHA_RECEPCION_DOC_COMPLETA` DATE NULL,      -- Fecha recepción documentación completa (Trámite de aceptación y decisión) 
  `FECHA_INTERPOSICION_DEMANDA` DATE NULL,
  `FECHA_ULTIMA_POSICION_VENCIDA` DATE NULL,     -- Fecha de la última posición vencida asociada de los contratos asociados al procedimiento
  `FECHA_ULTIMA_ESTIMACION` DATE NULL, 
  `FECHA_ESTIMADA_COBRO` DATE NULL, 
  `CONTEXTO_FASE` VARCHAR(250) NULL,    -- Secuencia de fases (IDs de las fases del procedimiento)
  `NIVEL` INT NULL,       -- Nivel de profundidad en la jerarquía de fases del procedimiento
  -- Dimensiones
  `ASUNTO_ID` DECIMAL(16,0) NULL,  -- Asunto al que pertenece el procedimiento
  `TIPO_PROCEDIMIENTO_DET_ID` DECIMAL(16,0) NULL,     -- Categorización del procedimiento (Secuencia de actuaciones) según las prioridades de éstas.
  `FASE_ACTUAL_DETALLE_ID` DECIMAL(16,0) NULL, 
  `FASE_ANTERIOR_DETALLE_ID` DECIMAL(16,0) NULL,
  `ULT_TAR_CREADA_TIPO_DET_ID` DECIMAL(16,0) NULL, 
  `ULT_TAR_CREADA_DESC_ID` DECIMAL(16,0) NULL, 
  `ULT_TAR_FIN_TIPO_DET_ID` DECIMAL(16,0) NULL,
  `ULT_TAR_FIN_DESC_ID` DECIMAL(16,0) NULL,
  `ULT_TAR_ACT_TIPO_DET_ID` DECIMAL(16,0) NULL, 
  `ULT_TAR_ACT_DESC_ID` DECIMAL(16,0) NULL,
  `ULT_TAR_PEND_TIPO_DET_ID` DECIMAL(16,0) NULL, 
  `ULT_TAR_PEND_DESC_ID` DECIMAL(16,0) NULL,
  `CUMPLIMIENTO_ULT_TAR_FIN_ID` DECIMAL(16,0) NULL,         -- -2 Ninguna Tarea Pendiente Asocidada, 0  En Plazo, 1 Fuera De Plazo
  `CUMPLIMIENTO_ULT_TAR_PEND_ID` DECIMAL(16,0) NULL,          -- -2 Ninguna Tarea Pendiente Asocidada, 0  En Plazo, 1 Fuera De Plazo
  `ESTADO_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL,  -- Activo o cancelado (todas sus fases canceladas)
  `ESTADO_FASE_ACTUAL_ID` DECIMAL(16,0) NULL, 
  `ESTADO_FASE_ANTERIOR_ID` DECIMAL(16,0) NULL,
  `T_SALDO_TOTAL_PRC_ID` DECIMAL(16,0) NULL ,     -- 0 si SALDO_ACTUAL_TOTAL < 1MM € / 1 si SALDO_ACTUAL_TOTAL >= 1 MM €
  `T_SALDO_TOTAL_CONCURSO_ID` DECIMAL(16,0) NULL ,     -- 0 si SALDO_CONCURSOS_TOTAL < 1MM € / 1 si SALDO_CONCURSOS_TOTAL >= 1 MM €
  `TD_ULT_ACTUALIZACION_PRC_ID` DECIMAL(16,0) NULL, -- 0 si <= 30 Días / 1 si 31 - 60 Días / 2 si 61 - 90 Días/ 3 si > 90 Días
  `TD_CONTRATO_VENCIDO_ID` DECIMAL(16,0) NULL ,    -- 0 si <= 30 Días / 1 si 31 - 60 Días / 2 si 61 - 90 Días/ 3 si > 90 Días
  `TD_CNT_VENC_CREACION_ASU_ID` DECIMAL(16,0) NULL,             
  `TD_CREA_ASU_A_INTERP_DEM_ID` DECIMAL(16,0) NULL,  
  `TD_CREACION_ASU_ACEPT_ID` DECIMAL(16,0) NULL,
  `TD_ACEPT_ASU_INTERP_DEM_ID` DECIMAL(16,0) NULL,
  `TD_CREA_ASU_REC_DOC_ACEP_ID` DECIMAL(16,0) NULL,  
  `TD_REC_DOC_ACEPT_REG_TD_ID` DECIMAL(16,0) NULL,
  `TD_REC_DOC_ACEPT_REC_DC_ID` DECIMAL(16,0) NULL,
  `CNT_GARANTIA_REAL_ASOC_ID` DECIMAL(16,0) NULL ,     -- 0 Contrato Garantía Real No Asociado / 1 Contrato Garantía Real Asociado
  `ACT_ESTIMACIONES_ID` DECIMAL(16,0) NULL ,
  `ULT_TAR_PEND_FILTR_DESC_ID` DECIMAL(16,0) NULL ,          -- 0 NCG BANCO, S.A / 1 SAREB / 2 Compartida  
  `NUM_DIAS_INTERPOS_FILT` INT NULL,   
  `FECHA_ULT_TAR_PEND_FILT` DATE NULL,
  `PLAZA_ID` DECIMAL(16,0) NULL,
  `JUZGADO_ID` DECIMAL(16,0) NULL,
  `PROCURADOR_ID` DECIMAL(16,0) NULL,
  `FASE_TAREA_DETALLE_ID` DECIMAL(16,0) NULL,
  `ORDEN_TAREA_FILT` INT NULL, 
  `FASE_TAREA_AGR_ID` DECIMAL(16,0) NULL,
  -- Métricas
  `NUM_PROCEDIMIENTOS` INT NULL,  
  `NUM_CONTRATOS` INT NULL,  
  `NUM_FASES` INT NULL,  
  `NUM_DIAS_ULT_ACTUALIZACION` INT NULL,    -- Número de dias desde la última actualización del procedimiento (Máxima fecha asociada a la última fase del procedimiento)
  `NUM_MAX_DIAS_CONTRATO_VENCIDO` INT NULL,       -- Número máximo de días vencidos de un contrato asociado al procedimiento respeto a la fecha de análisis
  `NUM_MAX_DIAS_CNT_VENC_CREA_ASU` INT NULL,     -- Número máximo de días vencidos de un contrato asociado al procedimiento respecto a la creación del asunto
  `PORCENTAJE_RECUPERACION` INT NULL ,   -- Porcentaje recuperado
  `P_RECUPERACION` INT NULL ,   -- Estimación TMPoral para recuperación
  `SALDO_RECUPERACION` DECIMAL(14,2) NULL ,       -- Saldo por recuperar
  `ESTIMACIÓN_RECUPERACION` DECIMAL(14,2) NULL ,  -- SALDO_RECUPERACION * PORCENTAJE_RECUPERACION
  `SALDO_ORIGINAL_VENCIDO` DECIMAL(14,2) NULL ,   -- Saldo vencido original al crear el procedimiento (De la tabla PRC_PROCEDIMIENTOS)
  `SALDO_ORIGINAL_NO_VENCIDO` DECIMAL(14,2) NULL ,         -- Saldo no vencido original al crear el procedimiento (De la tabla PRC_PROCEDIMIENTOS)
  `SALDO_ACTUAL_VENCIDO` DECIMAL(14,2) NULL ,     -- Saldo vencido de los contratos asociados al procedimiento
  `SALDO_ACTUAL_NO_VENCIDO` DECIMAL(14,2) NULL ,  -- Saldo no vencido de los contratos asociados al procedimiento
  `SALDO_ACTUAL_TOTAL` DECIMAL(14,2) NULL ,       -- Suma de los saldos vencido y no vencido de los contratos asociados al procedimiento
  `SALDO_CONCURSOS_VENCIDO` DECIMAL(14,2) NULL ,  -- Saldo vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
  `SALDO_CONCURSOS_NO_VENCIDO` DECIMAL(14,2) NULL ,        -- Saldo no vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
  `SALDO_CONCURSOS_TOTAL` DECIMAL(14,2) NULL ,    -- Suma de los saldos vencido y no vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
  `INGRESOS_PENDIENTES_APLICAR` DECIMAL(14,2) NULL ,       -- Ingresos pendientes de aplicar de los contratos asociados al procedimiento
  `SUBTOTAL` DECIMAL(14,2) NULL ,   -- Subtotal del procedimiento (NGB)
  `DURACION_ULT_TAREA_FINALIZADA` INT NULL,       -- Duración tarea en días (Fecha inicio hasta fecha fin)
  `NUM_DIAS_EXCED_ULT_TAR_FIN` INT NULL,       -- Número días desde fecha vencimiento (vigente) hasta fecha actual
  `NUM_DIAS_VENC_ULT_TAR_FIN` INT NULL,   -- Número días desde fecha actual hasta fecha vencimiento (valores negativos si no quedan días)
  `NUM_DIAS_PRORROG_ULT_TAR_FIN` INT NULL ,   -- Número días desde fecha vencimineto real (original) hasta fecha vencimiento vigente
  `NUM_PRORROG_ULT_TAR_FIN` INT NULL,  -- Número prórrogas pedidas para la tarea
  `DURACION_ULT_TAREA_PENDIENTE` INT NULL,        -- Duración tarea en días (Fecha inicio hasta fecha fin o fecha actual)
  `NUM_DIAS_EXCEDIDO_ULT_TAR_PEND` INT NULL,        -- Número días desde fecha vencimiento (vigente) hasta fecha actual
  `NUM_DIAS_VENC_ULT_TAR_PEND` INT NULL,    -- Número días desde fecha actual hasta fecha vencimiento (valores negativos si no quedan días)
  `NUM_DIAS_PRORROG_ULT_TAR_PEND` INT NULL ,    -- Número días desde fecha vencimineto real (original) hasta fecha vencimiento vigente
  `NUM_PRORROG_ULT_TAR_PEND` INT NULL,   -- Número prórrogas pedidas para la tarea
  `FECHA_PRORROG_ULT_TAR_PEND` DATE NULL,     -- Fecha de la ultima prórroga de la última tarea pendiente
  `NUM_AUTO_PRORROG_ULT_TAR_PEND` INT NULL,   -- Número autoprórrogas pedidas para la tarea
  `FECHA_AUTO_PRORROG_ULT_TAR_PEND` DATE NULL,-- Fecha de la ultima auto-prórroga de la última tarea pendiente
  `P_CREA_ASU_A_INTERP_DEM` INT NULL,  
  `P_CREACION_ASU_ACEP` INT NULL,   
  `P_ACEPT_ASU_INTERP_DEM` INT NULL,
  `P_CREA_ASU_REC_DOC_ACEP` INT NULL,
  `P_REC_DOC_ACEP_REG_TD` INT NULL,
  `P_REC_DOC_ACEP_RECEP_DC` INT NULL,
  `NUM_DIAS_DESDE_ULT_ESTIMACION` INT NULL,
  `NUM_PARALIZACIONES` INT NOT NULL DEFAULT 0, -- Numero de paralizaciones realizadas sobre todos los procedimientos del asunto
  `PARALIZADO` INT NOT NULL DEFAULT 0, -- 1=PARALIZADO 0=NO PARALIZADO
  `SIT_CUADRE_CARTERA_ID` DECIMAL(16,0) NULL, -- Indicamos la situación del Procedimeinto a nivel Cuadre de Cartera  	
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL 
 );
 
DROP TABLE H_PRC_MES;
CREATE TABLE IF NOT EXISTS H_PRC_MES( 
  `MES_ID` DECIMAL(16,0) NOT NULL,      -- Mes de análisis 
  `FECHA_CARGA_DATOS` DATE NOT NULL,    -- Fecha último día del mes cargado
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL,     -- ID de la primera fase del procedimiento (PRC_PRC_ID = NULL). Identifica al procedimiento (Secuencia de actuaciones)
  `FASE_MAX_PRIORIDAD` DECIMAL(16,0) NULL,       -- ID de la fase con mayor prioridad (Si hay varias de igual prioridad la última cronológicamente)
  `FASE_ANTERIOR` DECIMAL(16,0) NULL,   -- ID de la penúltima fase del procedimiento (padre de la última fase)
  `FASE_ACTUAL` DECIMAL(16,0) NULL,     -- ID de la última fase del procedimiento (fase con la última tarea o de mayor ID si el procedimiento no tiene tareas asociadas)
  `ULT_TAR_CREADA` DECIMAL(16,0) NULL,      -- ID de la última tarea creada asociada al procedimiento (indica la fase actual)
  `ULT_TAR_FIN` DECIMAL(16,0) NULL,  -- ID de la última tarea finalizada asociada al procedimiento 
  `ULTIMA_TAREA_ACTUALIZADA` DECIMAL(16,0) NULL,          -- ID de la última tarea actualizada asociada al procedimiento
  `ULT_TAR_PEND` DECIMAL(16,0) NULL,   -- ID de la última tarea pendiente asociada al procedimiento (última creada no finalizada)
  `FECHA_CREACION_ASUNTO` DATE NULL,
  `FECHA_CONTABLE_LITIGIO` DATE NULL,   -- DD_IFC_ID =12
  `FECHA_CREACION_PROCEDIMIENTO` DATE NULL,
  `FECHA_CREACION_FASE_MAX_PRIO` DATE NULL,
  `FECHA_CREACION_FASE_ANTERIOR` DATE NULL, 
  `FECHA_CREACION_FASE_ACTUAL` DATE NULL, 
  `FECHA_ULT_TAR_CREADA` DATE NULL, 
  `FECHA_ULT_TAR_FIN` DATE NULL, 
  `FECHA_ULTIMA_TAREA_ACTUALIZADA` DATE NULL,    -- Fecha de actualización de la última tarea actualizada
  `FECHA_ULT_TAR_PEND` DATE NULL,      -- Fecha de creación de la última tarea pendiente
  `FECHA_VENC_ORIG_ULT_TAR_FIN` DATE NULL, 
  `FECHA_VENC_ACT_ULT_TAR_FIN` DATE NULL,
  `FECHA_VENC_ORIG_ULT_TAR_PEND` DATE NULL, 
  `FECHA_VENC_ACT_ULT_TAR_PEND` DATE NULL,
  `FECHA_ACEPTACION` DATE NULL,    -- Fecha de Trámite de aceptación y decisión (Fecha final de la tarea "Registrar toma de decisión" 
  `FECHA_RECOGIDA_DOC_Y_ACEPT` DATE NULL,   -- Fecha fin de la tarea Recogida de documentación y aceptación (Trámite de aceptación y decisión)
  `FECHA_REGISTRAR_TOMA_DECISION` DATE NULL,     -- Fecha fin de la tarea Registrar toma de decisión (Trámite de aceptación y decisión) 
  `FECHA_RECEPCION_DOC_COMPLETA` DATE NULL,      -- Fecha recepción documentación completa (Trámite de aceptación y decisión) 
  `FECHA_INTERPOSICION_DEMANDA` DATE NULL,
  `FECHA_ULTIMA_POSICION_VENCIDA` DATE NULL,     -- Fecha de la última posición vencida asociada de los contratos asociados al procedimiento
  `FECHA_ULTIMA_ESTIMACION` DATE NULL, 
  `FECHA_ESTIMADA_COBRO` DATE NULL, 
  `CONTEXTO_FASE` VARCHAR(250) NULL,    -- Secuencia de fases (IDs de las fases del procedimiento)
  `NIVEL` INT NULL,       -- Nivel de profundidad en la jerarquía de fases del procedimiento
  -- Dimensiones
  `ASUNTO_ID` DECIMAL(16,0) NULL,  -- Asunto al que pertenece el procedimiento
  `TIPO_PROCEDIMIENTO_DET_ID` DECIMAL(16,0) NULL,     -- Categorización del procedimiento (Secuencia de actuaciones) según las prioridades de éstas.
  `FASE_ACTUAL_DETALLE_ID` DECIMAL(16,0) NULL, 
  `FASE_ANTERIOR_DETALLE_ID` DECIMAL(16,0) NULL,
  `ULT_TAR_CREADA_TIPO_DET_ID` DECIMAL(16,0) NULL, 
  `ULT_TAR_CREADA_DESC_ID` DECIMAL(16,0) NULL, 
  `ULT_TAR_FIN_TIPO_DET_ID` DECIMAL(16,0) NULL,
  `ULT_TAR_FIN_DESC_ID` DECIMAL(16,0) NULL,
  `ULT_TAR_ACT_TIPO_DET_ID` DECIMAL(16,0) NULL, 
  `ULT_TAR_ACT_DESC_ID` DECIMAL(16,0) NULL,
  `ULT_TAR_PEND_TIPO_DET_ID` DECIMAL(16,0) NULL, 
  `ULT_TAR_PEND_DESC_ID` DECIMAL(16,0) NULL,
  `CUMPLIMIENTO_ULT_TAR_FIN_ID` DECIMAL(16,0) NULL,         -- -2 Ninguna Tarea Pendiente Asocidada, 0  En Plazo, 1 Fuera De Plazo
  `CUMPLIMIENTO_ULT_TAR_PEND_ID` DECIMAL(16,0) NULL,          -- -2 Ninguna Tarea Pendiente Asocidada, 0  En Plazo, 1 Fuera De Plazo
  `ESTADO_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL,  -- Activo o cancelado (todas sus fases canceladas)
  `ESTADO_FASE_ACTUAL_ID` DECIMAL(16,0) NULL, 
  `ESTADO_FASE_ANTERIOR_ID` DECIMAL(16,0) NULL,
  `T_SALDO_TOTAL_PRC_ID` DECIMAL(16,0) NULL ,     -- 0 si SALDO_ACTUAL_TOTAL < 1MM € / 1 si SALDO_ACTUAL_TOTAL >= 1 MM €
  `T_SALDO_TOTAL_CONCURSO_ID` DECIMAL(16,0) NULL ,     -- 0 si SALDO_CONCURSOS_TOTAL < 1MM € / 1 si SALDO_CONCURSOS_TOTAL >= 1 MM €
  `TD_ULT_ACTUALIZACION_PRC_ID` DECIMAL(16,0) NULL, -- 0 si <= 30 Días / 1 si 31 - 60 Días / 2 si 61 - 90 Días/ 3 si > 90 Días
  `TD_CONTRATO_VENCIDO_ID` DECIMAL(16,0) NULL ,    -- 0 si <= 30 Días / 1 si 31 - 60 Días / 2 si 61 - 90 Días/ 3 si > 90 Días
  `TD_CNT_VENC_CREACION_ASU_ID` DECIMAL(16,0) NULL,             
  `TD_CREA_ASU_A_INTERP_DEM_ID` DECIMAL(16,0) NULL,  
  `TD_CREACION_ASU_ACEPT_ID` DECIMAL(16,0) NULL,
  `TD_ACEPT_ASU_INTERP_DEM_ID` DECIMAL(16,0) NULL,
  `TD_CREA_ASU_REC_DOC_ACEP_ID` DECIMAL(16,0) NULL,  
  `TD_REC_DOC_ACEPT_REG_TD_ID` DECIMAL(16,0) NULL,
  `TD_REC_DOC_ACEPT_REC_DC_ID` DECIMAL(16,0) NULL,
  `CNT_GARANTIA_REAL_ASOC_ID` DECIMAL(16,0) NULL ,     -- 0 Contrato Garantía Real No Asociado / 1 Contrato Garantía Real Asociado
  `ACT_ESTIMACIONES_ID` DECIMAL(16,0) NULL ,
  `CARTERA_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL ,          -- 0 NCG BANCO, S.A / 1 SAREB / 2 Compartida
  `TITULAR_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL,  -- Rerefencia a PER_ID
  `ULT_TAR_PEND_FILTR_DESC_ID` DECIMAL(16,0) NULL ,         
  `NUM_DIAS_INTERPOS_FILT` INT NULL,   
  `FECHA_ULT_TAR_PEND_FILT` DATE NULL,
  `PLAZA_ID` DECIMAL(16,0) NULL,
  `JUZGADO_ID` DECIMAL(16,0) NULL,
  `PROCURADOR_ID` DECIMAL(16,0) NULL,
  `FASE_TAREA_DETALLE_ID` DECIMAL(16,0) NULL,
  `ORDEN_TAREA_FILT` INT NULL, 
  `FASE_TAREA_AGR_ID` DECIMAL(16,0) NULL,
  -- Métricas
  `NUM_PROCEDIMIENTOS` INT NULL,  
  `NUM_CONTRATOS` INT NULL,  
  `NUM_FASES` INT NULL,  
  `NUM_DIAS_ULT_ACTUALIZACION` INT NULL,    -- Número de dias desde la última actualización del procedimiento (Máxima fecha asociada a la última fase del procedimiento)
  `NUM_MAX_DIAS_CONTRATO_VENCIDO` INT NULL,       -- Número máximo de días vencidos de un contrato asociado al procedimiento respeto a la fecha de análisis
  `NUM_MAX_DIAS_CNT_VENC_CREA_ASU` INT NULL,     -- Número máximo de días vencidos de un contrato asociado al procedimiento respecto a la creación del asunto
  `PORCENTAJE_RECUPERACION` INT NULL ,   -- Porcentaje recuperado
  `P_RECUPERACION` INT NULL ,   -- Estimación TMPoral para recuperación
  `SALDO_RECUPERACION` DECIMAL(14,2) NULL ,       -- Saldo por recuperar
  `ESTIMACIÓN_RECUPERACION` DECIMAL(14,2) NULL ,  -- SALDO_RECUPERACION * PORCENTAJE_RECUPERACION
  `SALDO_ORIGINAL_VENCIDO` DECIMAL(14,2) NULL ,   -- Saldo vencido original al crear el procedimiento (De la tabla PRC_PROCEDIMIENTOS)
  `SALDO_ORIGINAL_NO_VENCIDO` DECIMAL(14,2) NULL ,         -- Saldo no vencido original al crear el procedimiento (De la tabla PRC_PROCEDIMIENTOS)
  `SALDO_ACTUAL_VENCIDO` DECIMAL(14,2) NULL ,     -- Saldo vencido de los contratos asociados al procedimiento
  `SALDO_ACTUAL_NO_VENCIDO` DECIMAL(14,2) NULL ,  -- Saldo no vencido de los contratos asociados al procedimiento
  `SALDO_ACTUAL_TOTAL` DECIMAL(14,2) NULL ,       -- Suma de los saldos vencido y no vencido de los contratos asociados al procedimiento
  `SALDO_CONCURSOS_VENCIDO` DECIMAL(14,2) NULL ,  -- Saldo vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
  `SALDO_CONCURSOS_NO_VENCIDO` DECIMAL(14,2) NULL ,        -- Saldo no vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
  `SALDO_CONCURSOS_TOTAL` DECIMAL(14,2) NULL ,    -- Suma de los saldos vencido y no vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
  `INGRESOS_PENDIENTES_APLICAR` DECIMAL(14,2) NULL ,       -- Ingresos pendientes de aplicar de los contratos asociados al procedimiento
  `SUBTOTAL` DECIMAL(14,2) NULL ,   -- Subtotal del procedimiento (NGB)
  `DURACION_ULT_TAREA_FINALIZADA` INT NULL,       -- Duración tarea en días (Fecha inicio hasta fecha fin)
  `NUM_DIAS_EXCED_ULT_TAR_FIN` INT NULL,       -- Número días desde fecha vencimiento (vigente) hasta fecha actual
  `NUM_DIAS_VENC_ULT_TAR_FIN` INT NULL,   -- Número días desde fecha actual hasta fecha vencimiento (valores negativos si no quedan días)
  `NUM_DIAS_PRORROG_ULT_TAR_FIN` INT NULL ,   -- Número días desde fecha vencimineto real (original) hasta fecha vencimiento vigente
  `NUM_PRORROG_ULT_TAR_FIN` INT NULL,  -- Número prórrogas pedidas para la tarea
  `DURACION_ULT_TAREA_PENDIENTE` INT NULL,        -- Duración tarea en días (Fecha inicio hasta fecha fin o fecha actual)
  `NUM_DIAS_EXCEDIDO_ULT_TAR_PEND` INT NULL,        -- Número días desde fecha vencimiento (vigente) hasta fecha actual
  `NUM_DIAS_VENC_ULT_TAR_PEND` INT NULL,    -- Número días desde fecha actual hasta fecha vencimiento (valores negativos si no quedan días)
  `NUM_DIAS_PRORROG_ULT_TAR_PEND` INT NULL ,    -- Número días desde fecha vencimineto real (original) hasta fecha vencimiento vigente
  `NUM_PRORROG_ULT_TAR_PEND` INT NULL,   -- Número prórrogas pedidas para la tarea
  `FECHA_PRORROG_ULT_TAR_PEND` DATE NULL,     -- Fecha de la ultima prórroga de la última tarea pendiente
  `NUM_AUTO_PRORROG_ULT_TAR_PEND` INT NULL,   -- Número autoprórrogas pedidas para la tarea
  `FECHA_AUTO_PRORROG_ULT_TAR_PEND` DATE NULL,-- Fecha de la ultima auto-prórroga de la última tarea pendiente
  `P_CREA_ASU_A_INTERP_DEM` INT NULL,  
  `P_CREACION_ASU_ACEP` INT NULL,   
  `P_ACEPT_ASU_INTERP_DEM` INT NULL,
  `P_CREA_ASU_REC_DOC_ACEP` INT NULL,
  `P_REC_DOC_ACEP_REG_TD` INT NULL,
  `P_REC_DOC_ACEP_RECEP_DC` INT NULL,
  `NUM_DIAS_DESDE_ULT_ESTIMACION` INT NULL,
  `NUM_PARALIZACIONES` INT NOT NULL DEFAULT 0, -- Numero de paralizaciones realizadas sobre todos los procedimientos del asunto
  `PARALIZADO` INT NOT NULL DEFAULT 0, -- 1=PARALIZADO 0=NO PARALIZADO
  `SIT_CUADRE_CARTERA_ID` DECIMAL(16,0) NULL, -- Indicamos la situación del Procedimeinto a nivel Cuadre de Cartera	  
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL 
 );
 
DROP TABLE H_PRC_TRIMESTRE; 
CREATE TABLE IF NOT EXISTS H_PRC_TRIMESTRE( 
  `TRIMESTRE_ID` DECIMAL(16,0) NOT NULL,         -- Trimestre de análisis    
  `FECHA_CARGA_DATOS` DATE NOT NULL,    -- Fecha último día del trimestre cargado
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL,     -- ID de la primera fase del procedimiento (PRC_PRC_ID = NULL). Identifica al procedimiento (Secuencia de actuaciones)
  `FASE_MAX_PRIORIDAD` DECIMAL(16,0) NULL,       -- ID de la fase con mayor prioridad (Si hay varias de igual prioridad la última cronológicamente)
  `FASE_ANTERIOR` DECIMAL(16,0) NULL,   -- ID de la penúltima fase del procedimiento (padre de la última fase)
  `FASE_ACTUAL` DECIMAL(16,0) NULL,     -- ID de la última fase del procedimiento (fase con la última tarea o de mayor ID si el procedimiento no tiene tareas asociadas)
  `ULT_TAR_CREADA` DECIMAL(16,0) NULL,      -- ID de la última tarea creada asociada al procedimiento (indica la fase actual)
  `ULT_TAR_FIN` DECIMAL(16,0) NULL,  -- ID de la última tarea finalizada asociada al procedimiento 
  `ULTIMA_TAREA_ACTUALIZADA` DECIMAL(16,0) NULL,          -- ID de la última tarea actualizada asociada al procedimiento
  `ULT_TAR_PEND` DECIMAL(16,0) NULL,   -- ID de la última tarea pendiente asociada al procedimiento (última creada no finalizada)
  `FECHA_CREACION_ASUNTO` DATE NULL,
  `FECHA_CONTABLE_LITIGIO` DATE NULL,   -- DD_IFC_ID =12
  `FECHA_CREACION_PROCEDIMIENTO` DATE NULL,
  `FECHA_CREACION_FASE_MAX_PRIO` DATE NULL,
  `FECHA_CREACION_FASE_ANTERIOR` DATE NULL, 
  `FECHA_CREACION_FASE_ACTUAL` DATE NULL, 
  `FECHA_ULT_TAR_CREADA` DATE NULL, 
  `FECHA_ULT_TAR_FIN` DATE NULL, 
  `FECHA_ULTIMA_TAREA_ACTUALIZADA` DATE NULL,    -- Fecha de actualización de la última tarea actualizada
  `FECHA_ULT_TAR_PEND` DATE NULL,      -- Fecha de creación de la última tarea pendiente
  `FECHA_VENC_ORIG_ULT_TAR_FIN` DATE NULL, 
  `FECHA_VENC_ACT_ULT_TAR_FIN` DATE NULL,
  `FECHA_VENC_ORIG_ULT_TAR_PEND` DATE NULL, 
  `FECHA_VENC_ACT_ULT_TAR_PEND` DATE NULL,
  `FECHA_ACEPTACION` DATE NULL,    -- Fecha de Trámite de aceptación y decisión (Fecha final de la tarea "Registrar toma de decisión" 
  `FECHA_RECOGIDA_DOC_Y_ACEPT` DATE NULL,   -- Fecha fin de la tarea Recogida de documentación y aceptación (Trámite de aceptación y decisión)
  `FECHA_REGISTRAR_TOMA_DECISION` DATE NULL,     -- Fecha fin de la tarea Registrar toma de decisión (Trámite de aceptación y decisión) 
  `FECHA_RECEPCION_DOC_COMPLETA` DATE NULL,      -- Fecha recepción documentación completa (Trámite de aceptación y decisión) 
  `FECHA_INTERPOSICION_DEMANDA` DATE NULL,
  `FECHA_ULTIMA_POSICION_VENCIDA` DATE NULL,     -- Fecha de la última posición vencida asociada de los contratos asociados al procedimiento
  `FECHA_ULTIMA_ESTIMACION` DATE NULL, 
  `FECHA_ESTIMADA_COBRO` DATE NULL, 
  `CONTEXTO_FASE` VARCHAR(250) NULL,    -- Secuencia de fases (IDs de las fases del procedimiento)
  `NIVEL` INT NULL,       -- Nivel de profundidad en la jerarquía de fases del procedimiento
  -- Dimensiones
  `ASUNTO_ID` DECIMAL(16,0) NULL,  -- Asunto al que pertenece el procedimiento
  `TIPO_PROCEDIMIENTO_DET_ID` DECIMAL(16,0) NULL,     -- Categorización del procedimiento (Secuencia de actuaciones) según las prioridades de éstas.
  `FASE_ACTUAL_DETALLE_ID` DECIMAL(16,0) NULL, 
  `FASE_ANTERIOR_DETALLE_ID` DECIMAL(16,0) NULL,
  `ULT_TAR_CREADA_TIPO_DET_ID` DECIMAL(16,0) NULL, 
  `ULT_TAR_CREADA_DESC_ID` DECIMAL(16,0) NULL, 
  `ULT_TAR_FIN_TIPO_DET_ID` DECIMAL(16,0) NULL,
  `ULT_TAR_FIN_DESC_ID` DECIMAL(16,0) NULL,
  `ULT_TAR_ACT_TIPO_DET_ID` DECIMAL(16,0) NULL, 
  `ULT_TAR_ACT_DESC_ID` DECIMAL(16,0) NULL,
  `ULT_TAR_PEND_TIPO_DET_ID` DECIMAL(16,0) NULL, 
  `ULT_TAR_PEND_DESC_ID` DECIMAL(16,0) NULL,
  `CUMPLIMIENTO_ULT_TAR_FIN_ID` DECIMAL(16,0) NULL,         -- -2 Ninguna Tarea Pendiente Asocidada, 0  En Plazo, 1 Fuera De Plazo
  `CUMPLIMIENTO_ULT_TAR_PEND_ID` DECIMAL(16,0) NULL,          -- -2 Ninguna Tarea Pendiente Asocidada, 0  En Plazo, 1 Fuera De Plazo
  `ESTADO_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL,  -- Activo o cancelado (todas sus fases canceladas)
  `ESTADO_FASE_ACTUAL_ID` DECIMAL(16,0) NULL, 
  `ESTADO_FASE_ANTERIOR_ID` DECIMAL(16,0) NULL,
  `T_SALDO_TOTAL_PRC_ID` DECIMAL(16,0) NULL ,     -- 0 si SALDO_ACTUAL_TOTAL < 1MM € / 1 si SALDO_ACTUAL_TOTAL >= 1 MM €
  `T_SALDO_TOTAL_CONCURSO_ID` DECIMAL(16,0) NULL ,     -- 0 si SALDO_CONCURSOS_TOTAL < 1MM € / 1 si SALDO_CONCURSOS_TOTAL >= 1 MM €
  `TD_ULT_ACTUALIZACION_PRC_ID` DECIMAL(16,0) NULL, -- 0 si <= 30 Días / 1 si 31 - 60 Días / 2 si 61 - 90 Días/ 3 si > 90 Días
  `TD_CONTRATO_VENCIDO_ID` DECIMAL(16,0) NULL ,    -- 0 si <= 30 Días / 1 si 31 - 60 Días / 2 si 61 - 90 Días/ 3 si > 90 Días
  `TD_CNT_VENC_CREACION_ASU_ID` DECIMAL(16,0) NULL,             
  `TD_CREA_ASU_A_INTERP_DEM_ID` DECIMAL(16,0) NULL,  
  `TD_CREACION_ASU_ACEPT_ID` DECIMAL(16,0) NULL,
  `TD_ACEPT_ASU_INTERP_DEM_ID` DECIMAL(16,0) NULL,
  `TD_CREA_ASU_REC_DOC_ACEP_ID` DECIMAL(16,0) NULL,  
  `TD_REC_DOC_ACEPT_REG_TD_ID` DECIMAL(16,0) NULL,
  `TD_REC_DOC_ACEPT_REC_DC_ID` DECIMAL(16,0) NULL,
  `CNT_GARANTIA_REAL_ASOC_ID` DECIMAL(16,0) NULL ,     -- 0 Contrato Garantía Real No Asociado / 1 Contrato Garantía Real Asociado
  `ACT_ESTIMACIONES_ID` DECIMAL(16,0) NULL ,
  `CARTERA_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL ,          -- 0 NCG BANCO, S.A / 1 SAREB / 2 Compartida
  `TITULAR_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL,  -- Rerefencia a PER_ID
  `ULT_TAR_PEND_FILTR_DESC_ID` DECIMAL(16,0) NULL ,          
  `NUM_DIAS_INTERPOS_FILT` INT NULL,   
  `FECHA_ULT_TAR_PEND_FILT` DATE NULL,
  `PLAZA_ID` DECIMAL(16,0) NULL,
  `JUZGADO_ID` DECIMAL(16,0) NULL,
  `PROCURADOR_ID` DECIMAL(16,0) NULL,
  `FASE_TAREA_DETALLE_ID` DECIMAL(16,0) NULL,
  `ORDEN_TAREA_FILT` INT NULL, 
  `FASE_TAREA_AGR_ID` DECIMAL(16,0) NULL,
  -- Métricas
  `NUM_PROCEDIMIENTOS` INT NULL,  
  `NUM_CONTRATOS` INT NULL,  
  `NUM_FASES` INT NULL,  
  `NUM_DIAS_ULT_ACTUALIZACION` INT NULL,    -- Número de dias desde la última actualización del procedimiento (Máxima fecha asociada a la última fase del procedimiento)
  `NUM_MAX_DIAS_CONTRATO_VENCIDO` INT NULL,       -- Número máximo de días vencidos de un contrato asociado al procedimiento respeto a la fecha de análisis
  `NUM_MAX_DIAS_CNT_VENC_CREA_ASU` INT NULL,     -- Número máximo de días vencidos de un contrato asociado al procedimiento respecto a la creación del asunto
  `PORCENTAJE_RECUPERACION` INT NULL ,   -- Porcentaje recuperado
  `P_RECUPERACION` INT NULL ,   -- Estimación TMPoral para recuperación
  `SALDO_RECUPERACION` DECIMAL(14,2) NULL ,       -- Saldo por recuperar
  `ESTIMACIÓN_RECUPERACION` DECIMAL(14,2) NULL ,  -- SALDO_RECUPERACION * PORCENTAJE_RECUPERACION
  `SALDO_ORIGINAL_VENCIDO` DECIMAL(14,2) NULL ,   -- Saldo vencido original al crear el procedimiento (De la tabla PRC_PROCEDIMIENTOS)
  `SALDO_ORIGINAL_NO_VENCIDO` DECIMAL(14,2) NULL ,         -- Saldo no vencido original al crear el procedimiento (De la tabla PRC_PROCEDIMIENTOS)
  `SALDO_ACTUAL_VENCIDO` DECIMAL(14,2) NULL ,     -- Saldo vencido de los contratos asociados al procedimiento
  `SALDO_ACTUAL_NO_VENCIDO` DECIMAL(14,2) NULL ,  -- Saldo no vencido de los contratos asociados al procedimiento
  `SALDO_ACTUAL_TOTAL` DECIMAL(14,2) NULL ,       -- Suma de los saldos vencido y no vencido de los contratos asociados al procedimiento
  `SALDO_CONCURSOS_VENCIDO` DECIMAL(14,2) NULL ,  -- Saldo vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
  `SALDO_CONCURSOS_NO_VENCIDO` DECIMAL(14,2) NULL ,        -- Saldo no vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
  `SALDO_CONCURSOS_TOTAL` DECIMAL(14,2) NULL ,    -- Suma de los saldos vencido y no vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
  `INGRESOS_PENDIENTES_APLICAR` DECIMAL(14,2) NULL ,       -- Ingresos pendientes de aplicar de los contratos asociados al procedimiento
  `SUBTOTAL` DECIMAL(14,2) NULL ,   -- Subtotal del procedimiento (NGB)
  `DURACION_ULT_TAREA_FINALIZADA` INT NULL,       -- Duración tarea en días (Fecha inicio hasta fecha fin)
  `NUM_DIAS_EXCED_ULT_TAR_FIN` INT NULL,       -- Número días desde fecha vencimiento (vigente) hasta fecha actual
  `NUM_DIAS_VENC_ULT_TAR_FIN` INT NULL,   -- Número días desde fecha actual hasta fecha vencimiento (valores negativos si no quedan días)
  `NUM_DIAS_PRORROG_ULT_TAR_FIN` INT NULL ,   -- Número días desde fecha vencimineto real (original) hasta fecha vencimiento vigente
  `NUM_PRORROG_ULT_TAR_FIN` INT NULL,  -- Número prórrogas pedidas para la tarea
  `DURACION_ULT_TAREA_PENDIENTE` INT NULL,        -- Duración tarea en días (Fecha inicio hasta fecha fin o fecha actual)
  `NUM_DIAS_EXCEDIDO_ULT_TAR_PEND` INT NULL,        -- Número días desde fecha vencimiento (vigente) hasta fecha actual
  `NUM_DIAS_VENC_ULT_TAR_PEND` INT NULL,    -- Número días desde fecha actual hasta fecha vencimiento (valores negativos si no quedan días)
  `NUM_DIAS_PRORROG_ULT_TAR_PEND` INT NULL ,    -- Número días desde fecha vencimineto real (original) hasta fecha vencimiento vigente
  `NUM_PRORROG_ULT_TAR_PEND` INT NULL,   -- Número prórrogas pedidas para la tarea
  `FECHA_PRORROG_ULT_TAR_PEND` DATE NULL,     -- Fecha de la ultima prórroga de la última tarea pendiente
  `NUM_AUTO_PRORROG_ULT_TAR_PEND` INT NULL,   -- Número autoprórrogas pedidas para la tarea
  `FECHA_AUTO_PRORROG_ULT_TAR_PEND` DATE NULL,-- Fecha de la ultima auto-prórroga de la última tarea pendiente
  `P_CREA_ASU_A_INTERP_DEM` INT NULL,  
  `P_CREACION_ASU_ACEP` INT NULL,   
  `P_ACEPT_ASU_INTERP_DEM` INT NULL,
  `P_CREA_ASU_REC_DOC_ACEP` INT NULL,
  `P_REC_DOC_ACEP_REG_TD` INT NULL,
  `P_REC_DOC_ACEP_RECEP_DC` INT NULL,
  `NUM_DIAS_DESDE_ULT_ESTIMACION` INT NULL,
  `NUM_PARALIZACIONES` INT NOT NULL DEFAULT 0, -- Numero de paralizaciones realizadas sobre todos los procedimientos del asunto
  `PARALIZADO` INT NOT NULL DEFAULT 0, -- 1=PARALIZADO 0=NO PARALIZADO	  
  `SIT_CUADRE_CARTERA_ID` DECIMAL(16,0) NULL, -- Indicamos la situación del Procedimeinto a nivel Cuadre de Cartera
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL 
 );
 
DROP TABLE H_PRC_ANIO;
CREATE TABLE IF NOT EXISTS H_PRC_ANIO( 
  `ANIO_ID` DECIMAL(16,0) NOT NULL,     -- Año de análisis
  `FECHA_CARGA_DATOS` DATE NOT NULL,    -- Fecha último día del año cargado
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL,     -- ID de la primera fase del procedimiento (PRC_PRC_ID = NULL). Identifica al procedimiento (Secuencia de actuaciones)
  `FASE_MAX_PRIORIDAD` DECIMAL(16,0) NULL,       -- ID de la fase con mayor prioridad (Si hay varias de igual prioridad la última cronológicamente)
  `FASE_ANTERIOR` DECIMAL(16,0) NULL,   -- ID de la penúltima fase del procedimiento (padre de la última fase)
  `FASE_ACTUAL` DECIMAL(16,0) NULL,     -- ID de la última fase del procedimiento (fase con la última tarea o de mayor ID si el procedimiento no tiene tareas asociadas)
  `ULT_TAR_CREADA` DECIMAL(16,0) NULL,      -- ID de la última tarea creada asociada al procedimiento (indica la fase actual)
  `ULT_TAR_FIN` DECIMAL(16,0) NULL,  -- ID de la última tarea finalizada asociada al procedimiento 
  `ULTIMA_TAREA_ACTUALIZADA` DECIMAL(16,0) NULL,          -- ID de la última tarea actualizada asociada al procedimiento
  `ULT_TAR_PEND` DECIMAL(16,0) NULL,   -- ID de la última tarea pendiente asociada al procedimiento (última creada no finalizada)
  `FECHA_CREACION_ASUNTO` DATE NULL,
  `FECHA_CONTABLE_LITIGIO` DATE NULL,   -- DD_IFC_ID =12
  `FECHA_CREACION_PROCEDIMIENTO` DATE NULL,
  `FECHA_CREACION_FASE_MAX_PRIO` DATE NULL,
  `FECHA_CREACION_FASE_ANTERIOR` DATE NULL, 
  `FECHA_CREACION_FASE_ACTUAL` DATE NULL, 
  `FECHA_ULT_TAR_CREADA` DATE NULL, 
  `FECHA_ULT_TAR_FIN` DATE NULL, 
  `FECHA_ULTIMA_TAREA_ACTUALIZADA` DATE NULL,    -- Fecha de actualización de la última tarea actualizada
  `FECHA_ULT_TAR_PEND` DATE NULL,      -- Fecha de creación de la última tarea pendiente
  `FECHA_VENC_ORIG_ULT_TAR_FIN` DATE NULL, 
  `FECHA_VENC_ACT_ULT_TAR_FIN` DATE NULL,
  `FECHA_VENC_ORIG_ULT_TAR_PEND` DATE NULL, 
  `FECHA_VENC_ACT_ULT_TAR_PEND` DATE NULL,
  `FECHA_ACEPTACION` DATE NULL,    -- Fecha de Trámite de aceptación y decisión (Fecha final de la tarea "Registrar toma de decisión" 
  `FECHA_RECOGIDA_DOC_Y_ACEPT` DATE NULL,   -- Fecha fin de la tarea Recogida de documentación y aceptación (Trámite de aceptación y decisión)
  `FECHA_REGISTRAR_TOMA_DECISION` DATE NULL,     -- Fecha fin de la tarea Registrar toma de decisión (Trámite de aceptación y decisión) 
  `FECHA_RECEPCION_DOC_COMPLETA` DATE NULL,      -- Fecha recepción documentación completa (Trámite de aceptación y decisión) 
  `FECHA_INTERPOSICION_DEMANDA` DATE NULL,
  `FECHA_ULTIMA_POSICION_VENCIDA` DATE NULL,     -- Fecha de la última posición vencida asociada de los contratos asociados al procedimiento
  `FECHA_ULTIMA_ESTIMACION` DATE NULL, 
  `FECHA_ESTIMADA_COBRO` DATE NULL, 
  `CONTEXTO_FASE` VARCHAR(250) NULL,    -- Secuencia de fases (IDs de las fases del procedimiento)
  `NIVEL` INT NULL,       -- Nivel de profundidad en la jerarquía de fases del procedimiento
  -- Dimensiones
  `ASUNTO_ID` DECIMAL(16,0) NULL,  -- Asunto al que pertenece el procedimiento
  `TIPO_PROCEDIMIENTO_DET_ID` DECIMAL(16,0) NULL,     -- Categorización del procedimiento (Secuencia de actuaciones) según las prioridades de éstas.
  `FASE_ACTUAL_DETALLE_ID` DECIMAL(16,0) NULL, 
  `FASE_ANTERIOR_DETALLE_ID` DECIMAL(16,0) NULL,
  `ULT_TAR_CREADA_TIPO_DET_ID` DECIMAL(16,0) NULL, 
  `ULT_TAR_CREADA_DESC_ID` DECIMAL(16,0) NULL, 
  `ULT_TAR_FIN_TIPO_DET_ID` DECIMAL(16,0) NULL,
  `ULT_TAR_FIN_DESC_ID` DECIMAL(16,0) NULL,
  `ULT_TAR_ACT_TIPO_DET_ID` DECIMAL(16,0) NULL, 
  `ULT_TAR_ACT_DESC_ID` DECIMAL(16,0) NULL,
  `ULT_TAR_PEND_TIPO_DET_ID` DECIMAL(16,0) NULL, 
  `ULT_TAR_PEND_DESC_ID` DECIMAL(16,0) NULL,
  `CUMPLIMIENTO_ULT_TAR_FIN_ID` DECIMAL(16,0) NULL,         -- -2 Ninguna Tarea Pendiente Asocidada, 0  En Plazo, 1 Fuera De Plazo
  `CUMPLIMIENTO_ULT_TAR_PEND_ID` DECIMAL(16,0) NULL,          -- -2 Ninguna Tarea Pendiente Asocidada, 0  En Plazo, 1 Fuera De Plazo
  `ESTADO_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL,  -- Activo o cancelado (todas sus fases canceladas)
  `ESTADO_FASE_ACTUAL_ID` DECIMAL(16,0) NULL, 
  `ESTADO_FASE_ANTERIOR_ID` DECIMAL(16,0) NULL,
  `T_SALDO_TOTAL_PRC_ID` DECIMAL(16,0) NULL ,     -- 0 si SALDO_ACTUAL_TOTAL < 1MM € / 1 si SALDO_ACTUAL_TOTAL >= 1 MM €
  `T_SALDO_TOTAL_CONCURSO_ID` DECIMAL(16,0) NULL ,     -- 0 si SALDO_CONCURSOS_TOTAL < 1MM € / 1 si SALDO_CONCURSOS_TOTAL >= 1 MM €
  `TD_ULT_ACTUALIZACION_PRC_ID` DECIMAL(16,0) NULL, -- 0 si <= 30 Días / 1 si 31 - 60 Días / 2 si 61 - 90 Días/ 3 si > 90 Días
  `TD_CONTRATO_VENCIDO_ID` DECIMAL(16,0) NULL ,    -- 0 si <= 30 Días / 1 si 31 - 60 Días / 2 si 61 - 90 Días/ 3 si > 90 Días
  `TD_CNT_VENC_CREACION_ASU_ID` DECIMAL(16,0) NULL,             
  `TD_CREA_ASU_A_INTERP_DEM_ID` DECIMAL(16,0) NULL,  
  `TD_CREACION_ASU_ACEPT_ID` DECIMAL(16,0) NULL,
  `TD_ACEPT_ASU_INTERP_DEM_ID` DECIMAL(16,0) NULL,
  `TD_CREA_ASU_REC_DOC_ACEP_ID` DECIMAL(16,0) NULL,  
  `TD_REC_DOC_ACEPT_REG_TD_ID` DECIMAL(16,0) NULL,
  `TD_REC_DOC_ACEPT_REC_DC_ID` DECIMAL(16,0) NULL,
  `CNT_GARANTIA_REAL_ASOC_ID` DECIMAL(16,0) NULL ,     -- 0 Contrato Garantía Real No Asociado / 1 Contrato Garantía Real Asociado
  `ACT_ESTIMACIONES_ID` DECIMAL(16,0) NULL ,
  `CARTERA_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL ,          -- 0 NCG BANCO, S.A / 1 SAREB / 2 Compartida
  `TITULAR_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL,  -- Rerefencia a PER_ID
  `ULT_TAR_PEND_FILTR_DESC_ID` DECIMAL(16,0) NULL ,         
  `NUM_DIAS_INTERPOS_FILT` INT NULL,   
  `FECHA_ULT_TAR_PEND_FILT` DATE NULL,
  `PLAZA_ID` DECIMAL(16,0) NULL,
  `JUZGADO_ID` DECIMAL(16,0) NULL,
  `PROCURADOR_ID` DECIMAL(16,0) NULL,
  `FASE_TAREA_DETALLE_ID` DECIMAL(16,0) NULL,
  `ORDEN_TAREA_FILT` INT NULL, 
  `FASE_TAREA_AGR_ID` DECIMAL(16,0) NULL,
  -- Métricas
  `NUM_PROCEDIMIENTOS` INT NULL,  
  `NUM_CONTRATOS` INT NULL,  
  `NUM_FASES` INT NULL,  
  `NUM_DIAS_ULT_ACTUALIZACION` INT NULL,    -- Número de dias desde la última actualización del procedimiento (Máxima fecha asociada a la última fase del procedimiento)
  `NUM_MAX_DIAS_CONTRATO_VENCIDO` INT NULL,       -- Número máximo de días vencidos de un contrato asociado al procedimiento respeto a la fecha de análisis
  `NUM_MAX_DIAS_CNT_VENC_CREA_ASU` INT NULL,     -- Número máximo de días vencidos de un contrato asociado al procedimiento respecto a la creación del asunto
  `PORCENTAJE_RECUPERACION` INT NULL ,   -- Porcentaje recuperado
  `P_RECUPERACION` INT NULL ,   -- Estimación TMPoral para recuperación
  `SALDO_RECUPERACION` DECIMAL(14,2) NULL ,       -- Saldo por recuperar
  `ESTIMACIÓN_RECUPERACION` DECIMAL(14,2) NULL ,  -- SALDO_RECUPERACION * PORCENTAJE_RECUPERACION
  `SALDO_ORIGINAL_VENCIDO` DECIMAL(14,2) NULL ,   -- Saldo vencido original al crear el procedimiento (De la tabla PRC_PROCEDIMIENTOS)
  `SALDO_ORIGINAL_NO_VENCIDO` DECIMAL(14,2) NULL ,         -- Saldo no vencido original al crear el procedimiento (De la tabla PRC_PROCEDIMIENTOS)
  `SALDO_ACTUAL_VENCIDO` DECIMAL(14,2) NULL ,     -- Saldo vencido de los contratos asociados al procedimiento
  `SALDO_ACTUAL_NO_VENCIDO` DECIMAL(14,2) NULL ,  -- Saldo no vencido de los contratos asociados al procedimiento
  `SALDO_ACTUAL_TOTAL` DECIMAL(14,2) NULL ,       -- Suma de los saldos vencido y no vencido de los contratos asociados al procedimiento
  `SALDO_CONCURSOS_VENCIDO` DECIMAL(14,2) NULL ,  -- Saldo vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
  `SALDO_CONCURSOS_NO_VENCIDO` DECIMAL(14,2) NULL ,        -- Saldo no vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
  `SALDO_CONCURSOS_TOTAL` DECIMAL(14,2) NULL ,    -- Suma de los saldos vencido y no vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
  `INGRESOS_PENDIENTES_APLICAR` DECIMAL(14,2) NULL ,       -- Ingresos pendientes de aplicar de los contratos asociados al procedimiento
  `SUBTOTAL` DECIMAL(14,2) NULL ,   -- Subtotal del procedimiento (NGB)
  `DURACION_ULT_TAREA_FINALIZADA` INT NULL,       -- Duración tarea en días (Fecha inicio hasta fecha fin)
  `NUM_DIAS_EXCED_ULT_TAR_FIN` INT NULL,       -- Número días desde fecha vencimiento (vigente) hasta fecha actual
  `NUM_DIAS_VENC_ULT_TAR_FIN` INT NULL,   -- Número días desde fecha actual hasta fecha vencimiento (valores negativos si no quedan días)
  `NUM_DIAS_PRORROG_ULT_TAR_FIN` INT NULL ,   -- Número días desde fecha vencimineto real (original) hasta fecha vencimiento vigente
  `NUM_PRORROG_ULT_TAR_FIN` INT NULL,  -- Número prórrogas pedidas para la tarea
  `DURACION_ULT_TAREA_PENDIENTE` INT NULL,        -- Duración tarea en días (Fecha inicio hasta fecha fin o fecha actual)
  `NUM_DIAS_EXCEDIDO_ULT_TAR_PEND` INT NULL,        -- Número días desde fecha vencimiento (vigente) hasta fecha actual
  `NUM_DIAS_VENC_ULT_TAR_PEND` INT NULL,    -- Número días desde fecha actual hasta fecha vencimiento (valores negativos si no quedan días)
  `NUM_DIAS_PRORROG_ULT_TAR_PEND` INT NULL ,    -- Número días desde fecha vencimineto real (original) hasta fecha vencimiento vigente
  `NUM_PRORROG_ULT_TAR_PEND` INT NULL,   -- Número prórrogas pedidas para la tarea
  `FECHA_PRORROG_ULT_TAR_PEND` DATE NULL,     -- Fecha de la ultima prórroga de la última tarea pendiente
  `NUM_AUTO_PRORROG_ULT_TAR_PEND` INT NULL,   -- Número autoprórrogas pedidas para la tarea
  `FECHA_AUTO_PRORROG_ULT_TAR_PEND` DATE NULL,-- Fecha de la ultima auto-prórroga de la última tarea pendiente
  `P_CREA_ASU_A_INTERP_DEM` INT NULL,  
  `P_CREACION_ASU_ACEP` INT NULL,   
  `P_ACEPT_ASU_INTERP_DEM` INT NULL,
  `P_CREA_ASU_REC_DOC_ACEP` INT NULL,
  `P_REC_DOC_ACEP_REG_TD` INT NULL,
  `P_REC_DOC_ACEP_RECEP_DC` INT NULL,
  `NUM_DIAS_DESDE_ULT_ESTIMACION` INT NULL,
  `NUM_PARALIZACIONES` INT NOT NULL DEFAULT 0, -- Numero de paralizaciones realizadas sobre todos los procedimientos del asunto
  `PARALIZADO` INT NOT NULL DEFAULT 0, -- 1=PARALIZADO 0=NO PARALIZADO
  `SIT_CUADRE_CARTERA_ID` DECIMAL(16,0) NULL, -- Indicamos la situación del Procedimeinto a nivel Cuadre de Cartera	  
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL 
 );
 
DROP TABLE H_PRC_PLAZO_MEDIO;

 CREATE TABLE IF NOT EXISTS H_PRC_PLAZO_MEDIO(
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
  `MARCA_HITO_ID` decimal(16,0) DEFAULT NULL,
  `ORDEN_TAREA` int(11) DEFAULT NULL,
  `TIPO_PROCEDIMIENTO_DET_ID` decimal(16,0) DEFAULT NULL,
  `FASE_TAREA_AGR_ID` decimal(16,0) DEFAULT NULL);

-- ***** 
select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'H_PRC_PLAZO_MEDIO' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_PRC_PLAZO_MEDIO_IX';
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'H_PRC_PLAZO_MEDIO' and table_schema = 'bi_cdd_dwh';
if (HAY < 1 && HAY_TABLA = 1) then 
  CREATE INDEX H_PRC_PLAZO_MEDIO_IX ON H_PRC_PLAZO_MEDIO (DIA_ID, PROCEDIMIENTO_ID, ENTIDAD_CEDENTE_ID);
  set o_error_status:= concat('Se ha insertado el INDICE H_PRC_PLAZO_MEDIO_IX. Nº [', HAY, ']');
-- else 
--  set o_error_status:= concat('Ya existe el INDICE H_PRC_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
end if;

select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'H_PRC_PLAZO_MEDIO' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_PRC_PLAZO_MEDIO_IX2';
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'H_PRC_PLAZO_MEDIO' and table_schema = 'bi_cdd_dwh';
if (HAY < 1 && HAY_TABLA = 1) then 
  CREATE INDEX H_PRC_PLAZO_MEDIO_IX2 ON H_PRC_PLAZO_MEDIO (CATEGORIA_PLAZO_MEDIO);
  set o_error_status:= concat('Se ha insertado el INDICE H_PRC_PLAZO_MEDIO_IX2. Nº [', HAY, ']');
-- else 
--  set o_error_status:= concat('Ya existe el INDICE H_PRC_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
end if;

select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'H_PRC_PLAZO_MEDIO' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_PRC_PLAZO_MEDIO_IX3';
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'H_PRC_PLAZO_MEDIO' and table_schema = 'bi_cdd_dwh';
if (HAY < 1 && HAY_TABLA = 1) then 
  CREATE INDEX H_PRC_PLAZO_MEDIO_IX3 ON H_PRC_PLAZO_MEDIO (PROCEDIMIENTO_ID);
  set o_error_status:= concat('Se ha insertado el INDICE H_PRC_PLAZO_MEDIO_IX3. Nº [', HAY, ']');
-- else 
--  set o_error_status:= concat('Ya existe el INDICE H_PRC_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
end if;


select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'H_PRC' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_PRC_IX';
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'H_PRC' and table_schema = 'bi_cdd_dwh';
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX H_PRC_IX ON H_PRC (DIA_ID, PROCEDIMIENTO_ID, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_PRC_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE H_PRC_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
end if;

select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'H_PRC' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_PRC_FASE_ACTUAL_IX';
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'H_PRC' and table_schema = 'bi_cdd_dwh';
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX H_PRC_FASE_ACTUAL_IX ON H_PRC (DIA_ID, FASE_ACTUAL, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_PRC_FASE_ACTUAL_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE H_PRC_FASE_ACTUAL_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
end if;

select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'H_PRC_MES' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_PRC_MES_IX';
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'H_PRC_MES' and table_schema = 'bi_cdd_dwh';
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX H_PRC_MES_IX ON H_PRC_MES (MES_ID, PROCEDIMIENTO_ID, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_PRC_MES_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE H_PRC_MES_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
end if;


select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'H_PRC_TRIMESTRE' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_PRC_TRIMESTRE_IX';
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'H_PRC_TRIMESTRE' and table_schema = 'bi_cdd_dwh';
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX H_PRC_TRIMESTRE_IX ON H_PRC_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_PRC_TRIMESTRE_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE H_PRC_TRIMESTRE_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
end if;


select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'H_PRC_ANIO' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_PRC_ANIO_IX';
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'H_PRC_ANIO' and table_schema = 'bi_cdd_dwh';
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX H_PRC_ANIO_IX ON H_PRC_ANIO (ANIO_ID, PROCEDIMIENTO_ID, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_PRC_ANIO_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE H_PRC_ANIO_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
end if;


/** 2015-03-24 Quitamos dado que se va a hacer un SP propio 
--  ----------------------------  DETALLE COBRO ----------------------------
DROP TABLE H_PRC_DET_COBRO;
CREATE TABLE IF NOT EXISTS H_PRC_DET_COBRO( 
  `DIA_ID` DATE NOT NULL,  
  `FECHA_CARGA_DATOS` DATE NOT NULL,                                 
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL, 
  `ASUNTO_ID` DECIMAL(16,0) NOT NULL, 
  `CONTRATO_ID` DECIMAL(16,0) NULL ,
  `FECHA_COBRO` DATE NULL, 
  `FECHA_ASUNTO` DATE NULL, 
  -- Dimensiones
  `TIPO_COBRO_DETALLE_ID` DECIMAL(16,0) NULL,
  -- Métricas
  `NUM_COBROS` INT NULL,
  `IMPORTE_COBRO` DECIMAL(15,2) NULL,
  `NUM_DIAS_CREACION_ASU_COBRO` INT NULL,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL 
 );
 
DROP TABLE H_PRC_DET_COBRO_MES;
CREATE TABLE IF NOT EXISTS H_PRC_DET_COBRO_MES( 
  `MES_ID` DECIMAL(16,0) NOT NULL,  
  `FECHA_CARGA_DATOS` DATE NOT NULL, 
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL, 
  `ASUNTO_ID` DECIMAL(16,0) NOT NULL, 
  `CONTRATO_ID` DECIMAL(16,0) NULL ,
  `FECHA_COBRO` DATE NULL, 
  `FECHA_ASUNTO` DATE NULL, 
  -- Dimensiones
  `TIPO_COBRO_DETALLE_ID` DECIMAL(16,0) NULL,
  -- Métricas
  `NUM_COBROS` INT NULL,
  `IMPORTE_COBRO` DECIMAL(15,2) NULL,
  `NUM_DIAS_CREACION_ASU_COBRO` INT NULL,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL 
 );
 
DROP TABLE H_PRC_DET_COBRO_TRIMESTRE;
CREATE TABLE IF NOT EXISTS H_PRC_DET_COBRO_TRIMESTRE( 
  `TRIMESTRE_ID` DECIMAL(16,0) NOT NULL, 
  `FECHA_CARGA_DATOS` DATE NOT NULL, 
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL, 
  `ASUNTO_ID` DECIMAL(16,0) NOT NULL, 
  `CONTRATO_ID` DECIMAL(16,0) NULL ,
  `FECHA_COBRO` DATE NULL, 
  `FECHA_ASUNTO` DATE NULL, 
  -- Dimensiones
  `TIPO_COBRO_DETALLE_ID` DECIMAL(16,0) NULL,
  -- Métricas
  `NUM_COBROS` INT NULL,
  `IMPORTE_COBRO` DECIMAL(15,2) NULL,
  `NUM_DIAS_CREACION_ASU_COBRO` INT NULL,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL 
 );
 
DROP TABLE H_PRC_DET_COBRO_ANIO;
CREATE TABLE IF NOT EXISTS H_PRC_DET_COBRO_ANIO( 
  `ANIO_ID` DECIMAL(16,0) NOT NULL,  
  `FECHA_CARGA_DATOS` DATE NOT NULL, 
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL, 
  `ASUNTO_ID` DECIMAL(16,0) NOT NULL, 
  `CONTRATO_ID` DECIMAL(16,0) NULL ,
  `FECHA_COBRO` DATE NULL, 
  `FECHA_ASUNTO` DATE NULL, 
  -- Dimensiones
  `TIPO_COBRO_DETALLE_ID` DECIMAL(16,0) NULL,
  -- Métricas
  `NUM_COBROS` INT NULL,
  `IMPORTE_COBRO` DECIMAL(15,2) NULL,
  `NUM_DIAS_CREACION_ASU_COBRO` INT NULL,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL 
 );
 
-- ************************

select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'H_PRC_DET_COBRO' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_PRC_DET_COBRO_IX';
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'H_PRC_DET_COBRO' and table_schema = 'bi_cdd_dwh';
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX H_PRC_DET_COBRO_IX ON H_PRC_DET_COBRO (DIA_ID, PROCEDIMIENTO_ID, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_PRC_DET_COBRO_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE H_PRC_DET_COBRO_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
end if;


select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'H_PRC_DET_COBRO_MES' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_PRC_DET_COBRO_MES_IX';
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'H_PRC_DET_COBRO_MES' and table_schema = 'bi_cdd_dwh';
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX H_PRC_DET_COBRO_MES_IX ON H_PRC_DET_COBRO_MES (MES_ID, PROCEDIMIENTO_ID, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_PRC_DET_COBRO_MES_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE H_PRC_DET_COBRO_MES_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
end if;

select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'H_PRC_DET_COBRO_TRIMESTRE' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_PRC_DET_COBRO_TRIMESTRE_IX';
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'H_PRC_DET_COBRO_TRIMESTRE' and table_schema = 'bi_cdd_dwh';
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX H_PRC_DET_COBRO_TRIMESTRE_IX ON H_PRC_DET_COBRO_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_PRC_DET_COBRO_TRIMESTRE_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE H_PRC_DET_COBRO_TRIMESTRE_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
end if;

select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'H_PRC_DET_COBRO_ANIO' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_PRC_DET_COBRO_ANIO_IX';
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'H_PRC_DET_COBRO_ANIO' and table_schema = 'bi_cdd_dwh';
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX H_PRC_DET_COBRO_ANIO_IX ON H_PRC_DET_COBRO_ANIO (ANIO_ID, PROCEDIMIENTO_ID, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_PRC_DET_COBRO_ANIO_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE H_PRC_DET_COBRO_ANIO_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
end if;

*/


--  ----------------------------  DETALLE CONTRATO ----------------------------
DROP TABLE H_PRC_DET_CONTRATO;
CREATE TABLE IF NOT EXISTS H_PRC_DET_CONTRATO( 
  `DIA_ID` DATE NOT NULL,    
  `FECHA_CARGA_DATOS` DATE NOT NULL, 
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL, 
  `ASUNTO_ID` DECIMAL(16,0) NOT NULL, 
  `CONTRATO_ID` DECIMAL(16,0) NULL, 
  -- Métricas
  `NUM_CONTRATOS_PROCEDIMIENTO` INT NULL,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL 
 );
 
DROP TABLE H_PRC_DET_CONTRATO_MES;
CREATE TABLE IF NOT EXISTS H_PRC_DET_CONTRATO_MES( 
  `MES_ID` DECIMAL(16,0) NOT NULL,  
  `FECHA_CARGA_DATOS` DATE NOT NULL, 
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL, 
  `ASUNTO_ID` DECIMAL(16,0) NOT NULL, 
  `CONTRATO_ID` DECIMAL(16,0) NULL, 
  -- Métricas
  `NUM_CONTRATOS_PROCEDIMIENTO` INT NULL,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL 
 );
 
DROP TABLE H_PRC_DET_CONTRATO_TRIMESTRE;
CREATE TABLE IF NOT EXISTS H_PRC_DET_CONTRATO_TRIMESTRE( 
  `TRIMESTRE_ID` DECIMAL(16,0) NOT NULL,  
  `FECHA_CARGA_DATOS` DATE NOT NULL, 
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL, 
  `ASUNTO_ID` DECIMAL(16,0) NOT NULL, 
  `CONTRATO_ID` DECIMAL(16,0) NULL, 
  -- Métricas
  `NUM_CONTRATOS_PROCEDIMIENTO` INT NULL,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL 
 );
 
DROP TABLE H_PRC_DET_CONTRATO_ANIO;
CREATE TABLE IF NOT EXISTS H_PRC_DET_CONTRATO_ANIO( 
  `ANIO_ID` DECIMAL(16,0) NOT NULL,  
  `FECHA_CARGA_DATOS` DATE NOT NULL, 
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL, 
  `ASUNTO_ID` DECIMAL(16,0) NOT NULL, 
  `CONTRATO_ID` DECIMAL(16,0) NULL, 
  -- Métricas
  `NUM_CONTRATOS_PROCEDIMIENTO` INT NULL,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL 
 );
 

 
-- *********************
select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'H_PRC_DET_CONTRATO' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_PRC_DET_CONTRATO_IX';
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'H_PRC_DET_CONTRATO' and table_schema = 'bi_cdd_dwh';
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX H_PRC_DET_CONTRATO_IX ON H_PRC_DET_CONTRATO (DIA_ID, PROCEDIMIENTO_ID, CONTRATO_ID, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_PRC_DET_CONTRATO_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE H_PRC_DET_CONTRATO_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
end if;


select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'H_PRC_DET_CONTRATO_MES' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_PRC_DET_CONTRATO_MES_IX';
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'H_PRC_DET_CONTRATO_MES' and table_schema = 'bi_cdd_dwh';
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX H_PRC_DET_CONTRATO_MES_IX ON H_PRC_DET_CONTRATO_MES (MES_ID, PROCEDIMIENTO_ID, CONTRATO_ID, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_PRC_DET_CONTRATO_MES_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE H_PRC_DET_CONTRATO_MES_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
end if;


select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'H_PRC_DET_CONTRATO_TRIMESTRE' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_PRC_DET_CONTRATO_TRIMESTRE_IX';
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'H_PRC_DET_CONTRATO_TRIMESTRE' and table_schema = 'bi_cdd_dwh';
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX H_PRC_DET_CONTRATO_TRIMESTRE_IX ON H_PRC_DET_CONTRATO_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID, CONTRATO_ID, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_PRC_DET_CONTRATO_TRIMESTRE_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE H_PRC_DET_CONTRATO_TRIMESTRE_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
end if;


select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'H_PRC_DET_CONTRATO_ANIO' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_PRC_DET_CONTRATO_ANIO_IX';
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'H_PRC_DET_CONTRATO_ANIO' and table_schema = 'bi_cdd_dwh';
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX H_PRC_DET_CONTRATO_ANIO_IX ON H_PRC_DET_CONTRATO_ANIO (ANIO_ID, PROCEDIMIENTO_ID, CONTRATO_ID, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_PRC_DET_CONTRATO_ANIO_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE H_PRC_DET_CONTRATO_ANIO_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
end if;
  
 
-- =================================================================================================================================================
--                                                 TABLAS TMPORALES
-- =================================================================================================================================================
DROP TABLE TMP_PRC_CODIGO_PRIORIDAD; 
CREATE TABLE IF NOT EXISTS TMP_PRC_CODIGO_PRIORIDAD (
  `DD_TPO_CODIGO` VARCHAR(50) NULL ,
  `PRIORIDAD` INT NULL,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL 
);  

DROP TABLE TMP_PRC_JERARQUIA;
CREATE TABLE IF NOT EXISTS TMP_PRC_JERARQUIA (
  `DIA_ID` DATE NOT NULL,                               
  `ITER` DECIMAL(16,0) NOT NULL,   
  `FASE_ACTUAL` DECIMAL(16,0) NULL,
  `ULTIMA_FASE` DECIMAL(16,0) NULL,
  `ULT_TAR_CREADA` DECIMAL(16,0) NULL, 
  `ULT_TAR_FIN` DECIMAL(16,0) NULL, 
  `ULTIMA_TAREA_ACTUALIZADA` DECIMAL(16,0) NULL, 
  `ULT_TAR_PEND` DECIMAL(16,0) NULL,
  `FECHA_ULT_TAR_CREADA` DATETIME NULL,  
  `FECHA_ULT_TAR_FIN` DATETIME NULL,  
  `FECHA_ULTIMA_TAREA_ACTUALIZADA` DATETIME NULL , 
  `FECHA_ULT_TAR_PEND` DATETIME NULL , 
  `FECHA_ACEPTACION` DATE NULL,
  `FECHA_INTERPOSICION_DEMANDA` DATE NULL,
  `FECHA_RECOGIDA_DOC_Y_ACEPT` DATE NULL,                          
  `FECHA_REGISTRAR_TOMA_DECISION` DATE NULL,                           
  `FECHA_RECEPCION_DOC_COMPLETA` DATE NULL,                             
  `FECHA_ULTIMA_POSICION_VENCIDA` DATE NULL, 
  `FECHA_ULTIMA_ESTIMACION` DATE NULL, 
  `FASE_MAX_PRIORIDAD` DECIMAL(16,0) NULL, 
  `NIVEL` decimal(2,0) NULL,
  `CONTEXTO` varchar(300) NULL,
  `CODIGO_FASE_ACTUAL` varchar(20) NULL, 
  `PRIORIDAD_FASE` INT NULL,      
  `PRIORIDAD_PROCEDIMIENTO` INT NULL,
  `CANCELADO_FASE` INT NULL,
  `CANCELADO_PROCEDIMIENTO` INT NULL,
  `ASU_ID` decimal(16,0) NULL,
  `NUM_FASES` INT NULL,
  `NUM_CONTRATOS` INT NULL,
  `SALDO_VENCIDO` DECIMAL(14,2) NULL ,         
  `SALDO_NO_VENCIDO` DECIMAL(14,2) NULL ,
  `SALDO_CONCURSOS_VENCIDO` DECIMAL(14,2) NULL ,  -- Saldo vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
  `SALDO_CONCURSOS_NO_VENCIDO` DECIMAL(14,2) NULL ,        -- Saldo no vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
  `INGRESOS_PENDIENTES_APLICAR` DECIMAL(14,2) NULL,
  `SUBTOTAL` DECIMAL(14,2) NULL ,  
  `GARANTIA_CONTRATO` DECIMAL(16,0) NULL,
  `NUM_DIAS_VENCIDO` INT NULL,
  `CARTERA` DECIMAL(16,0) NULL,
  `FECHA_CONTABLE_LITIGIO` DATE NULL,
  `TITULAR_PROCEDIMIENTO` DECIMAL(16,0) NULL,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL, 
  `FECHA_ULTIMA_AUTO_PRORROGA` DATE NULL,
  `FECHA_ULTIMA_PRORROGA` DATE NULL,
  `NUM_AUTO_PRORROGA` INT NULL,
  `NUM_PRORROGA` INT NULL, 
  `NUM_PARALIZACIONES` INT NOT NULL DEFAULT 0, -- Numero de paralizaciones realizadas sobre todos los procedimientos del asunto
  `PARALIZADO` INT NOT NULL DEFAULT 0 -- 1=PARALIZADO 0=NO PARALIZADO	  
  ); 
  
DROP TABLE TMP_PRC_DETALLE;
CREATE TABLE IF NOT EXISTS TMP_PRC_DETALLE (
  `ITER` DECIMAL(16,0) NULL ,
  `FASE_ACTUAL` DECIMAL(16,0) NULL,
  `ULT_TAR_CREADA` DECIMAL(16,0) NULL,
  `ULT_TAR_FIN` DECIMAL(16,0) NULL, 
  `ULTIMA_TAREA_ACTUALIZADA` DECIMAL(16,0) NULL,
  `ULT_TAR_PEND` DECIMAL(16,0) NULL,
  `FECHA_ULT_TAR_CREADA` DATETIME NULL,  
  `FECHA_ULT_TAR_FIN` DATETIME NULL,  
  `FECHA_ULTIMA_TAREA_ACTUALIZADA` DATETIME NULL ,  
  `FECHA_ULT_TAR_PEND` DATETIME NULL , 
  `FECHA_ACEPTACION` DATE NULL,
  `FECHA_INTERPOSICION_DEMANDA` DATE NULL,
  `FECHA_RECOGIDA_DOC_Y_ACEPT` DATE NULL,                          
  `FECHA_REGISTRAR_TOMA_DECISION` DATE NULL,                           
  `FECHA_RECEPCION_DOC_COMPLETA` DATE NULL,    
  `FECHA_ULTIMA_POSICION_VENCIDA` DATE NULL,
  `FECHA_ULTIMA_ESTIMACION` DATE NULL, 
  `MAX_PRIORIDAD` DECIMAL(16,0) NULL,
  `FASE_MAX_PRIORIDAD` DECIMAL(16,0) NULL,
  `CANCELADO_FASE` INT NULL,
  `NUM_FASES` INT NULL,
  `CANCELADO_PROCEDIMIENTO` INT NULL,
  `NUM_CONTRATOS` INT NULL,
  `SALDO_VENCIDO` DECIMAL(14,2) NULL ,         
  `SALDO_NO_VENCIDO` DECIMAL(14,2) NULL ,
  `SALDO_CONCURSOS_VENCIDO` DECIMAL(14,2) NULL ,  -- Saldo vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
  `SALDO_CONCURSOS_NO_VENCIDO` DECIMAL(14,2) NULL ,        -- Saldo no vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
  `INGRESOS_PENDIENTES_APLICAR` DECIMAL(14,2) NULL,
  `SUBTOTAL` DECIMAL(14,2) NULL ,  
  `GARANTIA_CONTRATO` DECIMAL(16,0) NULL,
  `NUM_DIAS_VENCIDO` INT NULL,
  `CARTERA` DECIMAL(16,0) NULL,
  `FECHA_CONTABLE_LITIGIO` DATE NULL,
  `TITULAR_PROCEDIMIENTO` DECIMAL(16,0) NULL,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL, 
  `FECHA_ULTIMA_AUTO_PRORROGA` DATE NULL,
  `FECHA_ULTIMA_PRORROGA` DATE NULL,
  `NUM_AUTO_PRORROGA` INT NULL,
  `NUM_PRORROGA` INT NULL
  );  
    
  
DROP TABLE TMP_PRC_TAREA;
CREATE TABLE IF NOT EXISTS TMP_PRC_TAREA (
  `ITER` DECIMAL(16,0) NULL,
  `FASE` DECIMAL(16,0) NULL,
  `TAREA` DECIMAL(16,0) NULL,
  `FECHA_INI` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' ,
  `FECHA_FIN` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' ,
  `FECHA_PRORROGA` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' ,
  `FECHA_AUTO_PRORROGA` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' ,
  `FECHA_ACTUALIZACION` DATETIME,
  `DESCRIPCION_TAREA` VARCHAR(250) NULL, 
  `TAP_ID` DECIMAL(16,0) NULL,
  `TEX_ID` DECIMAL(16,0) NULL,
  `DESCRIPCION_FORMULARIO` VARCHAR(250) NULL,        -- TEV_NOMBRE (TEV_TAREA_EXTERNA_VALOR)
  `FECHA_FORMULARIO` DATE NULL ,       -- TEV_VALOR (TEV_TAREA_EXTERNA_VALOR) 
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL,
  `NUM_AUTO_PRORROGAS` INT NOT NULL DEFAULT 0,
  `NUM_PRORROGAS` INT NOT NULL DEFAULT 0 
);   


CREATE TABLE IF NOT EXISTS TMP_PRC_TAREA_STP1 (
  `ITER` DECIMAL(16,0) NULL,
  `FASE` DECIMAL(16,0) NULL,
  `TAREA` DECIMAL(16,0) NULL,
  `FECHA_INI` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' ,
  `FECHA_FIN` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' ,
  `FECHA_PRORROGA` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' ,
  `FECHA_AUTO_PRORROGA` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' ,
  `FECHA_ACTUALIZACION` DATETIME,
  `DESCRIPCION_TAREA` VARCHAR(250) NULL, 
  `TAP_ID` DECIMAL(16,0) NULL,
  `TEX_ID` DECIMAL(16,0) NULL,
  `DESCRIPCION_FORMULARIO` VARCHAR(250) NULL,        -- TEV_NOMBRE (TEV_TAREA_EXTERNA_VALOR)
  `FECHA_FORMULARIO` DATE NULL ,       -- TEV_VALOR (TEV_TAREA_EXTERNA_VALOR) 
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL,
  `NUM_AUTO_PRORROGAS` INT NOT NULL DEFAULT 0,
  `NUM_PRORROGAS` INT NOT NULL DEFAULT 0 
);


DROP TABLE TMP_PRC_AUTO_PRORROGAS;
CREATE TABLE IF NOT EXISTS TMP_PRC_AUTO_PRORROGAS (
  `TAREA` DECIMAL(16,0) NULL,       
  `FECHA_AUTO_PRORROGA` DATETIME NULL,     -- Para prórrogas y autoprórrogas   
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL      
  );  
  
DROP TABLE TMP_PRC_CONTRATO;
CREATE TABLE IF NOT EXISTS TMP_PRC_CONTRATO( 
  `ITER` DECIMAL(16,0) NULL, 
  `CONTRATO` DECIMAL(16,0) NULL,
  `CEX_ID` DECIMAL(16,0) NULL,
  `MAX_MOV_ID` DECIMAL(16,0) NULL,
  `SALDO_VENCIDO` DECIMAL(14,2) NULL ,    -- Saldo vencido de los contratos asociados al procedimiento
  `SALDO_NO_VENCIDO` DECIMAL(14,2) NULL ,      -- Saldo no vencido de los contratos asociados al procedimiento
  `INGRESOS_PENDIENTES_APLICAR` DECIMAL(14,2) NULL,
  `FECHA_POS_VENCIDA` DATE NULL,
  `GARANTIA_CONTRATO` DECIMAL(16,0) NULL,      -- Garantía del contrato
  `NUM_DIAS_VENCIDO` INT NULL,
  `CARTERA` DECIMAL(16,0) NULL,  -- Cartera a la que pertenece el contrato (UGAS, SAREB o Compartida)
  `FECHA_CONTABLE_LITIGIO` DATE NULL,      -- Fecha contable del litigio asociado al contrato
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL  
 );
 
   
 -- Calcular el saldo de los concursos
DROP TABLE TMP_PRC_CONCURSO_CONTRATO;
CREATE TABLE IF NOT EXISTS TMP_PRC_CONCURSO_CONTRATO( 
  `ITER` DECIMAL(16,0) NULL, 
  `CONTRATO` DECIMAL(16,0) NULL,
  `SALDO_CONCURSOS_VENCIDO` DECIMAL(14,2) NULL ,                 
  `SALDO_CONCURSOS_NO_VENCIDO` DECIMAL(14,2) NULL ,               
  `DEMANDADO` DECIMAL(16,0) NULL,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL  
 );
 
DROP TABLE TMP_PRC_CARTERA;
CREATE TABLE IF NOT EXISTS TMP_PRC_CARTERA ( 
  `CONTRATO` DECIMAL(16,0) NULL,
  `CARTERA` DECIMAL(16,0) NULL,   -- Cartera a la que pertenece el contrato (UGAS, SAREB o Compartida)
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL  
  );  
  
DROP TABLE TMP_PRC_FECHA_CONTABLE_LITIGIO;
CREATE TABLE IF NOT EXISTS TMP_PRC_FECHA_CONTABLE_LITIGIO ( 
  `CONTRATO` DECIMAL(16,0) NULL,
  `FECHA_CONTABLE_LITIGIO` DATE NULL,      -- Fecha contable del litigio asociado al contrato
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL  
  ); 
  
DROP TABLE TMP_PRC_TITULAR;
CREATE TABLE IF NOT EXISTS TMP_PRC_TITULAR ( 
  `PROCEDIMIENTO` DECIMAL(16,0) NULL,
  `CONTRATO` DECIMAL(16,0) NULL,
  `TITULAR_PROCEDIMIENTO` DECIMAL(16,0) NULL,   -- Primer titular del contrato de pase
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL  
  ); 
  
DROP TABLE TMP_PRC_DEMANDADO;
CREATE TABLE IF NOT EXISTS TMP_PRC_DEMANDADO ( 
  `PROCEDIMIENTO` DECIMAL(16,0) NULL,
  `CONTRATO` DECIMAL(16,0) NULL,
  `DEMANDADO` DECIMAL(16,0) NULL,          -- Demandado interviene como 1er o 2º Titular del contrato
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL  
  ); 
  
DROP TABLE TMP_PRC_COBROS;
CREATE TABLE IF NOT EXISTS TMP_PRC_COBROS( 
  `FECHA_COBRO` DATE NULL,  
  `CONTRATO` DECIMAL(16,0) NULL,
  `IMPORTE` DECIMAL(15,2) NULL,
  `REFERENCIA` DECIMAL(16,0) NULL,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL  
 );
  
DROP TABLE TMP_PRC_ESTIMACION;
CREATE TABLE IF NOT EXISTS TMP_PRC_ESTIMACION( 
  `ITER` DECIMAL(16,0) NULL,
  `FASE` DECIMAL(16,0) NULL,
  `FECHA_ESTIMACION` DATETIME NULL,  
  `IRG_CLAVE` varchar(20) NULL,
  `IRG_VALOR` varchar(255) NULL,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL  
 );
 
DROP TABLE TMP_PRC_EXTRAS_RECOVERY_BI; 
CREATE TABLE IF NOT EXISTS TMP_PRC_EXTRAS_RECOVERY_BI( 
  `FECHA_VALOR` DATE NULL,  
  `TIPO_ENTIDAD` DECIMAL(16,0) DEFAULT NULL,
  `UNIDAD_GESTION` DECIMAL(16,0) DEFAULT NULL,
  `DD_IFB_ID` DECIMAL(16,0) DEFAULT NULL,
  `VALOR` varchar(50) DEFAULT NULL,
  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL  
 );
 
--  *********************************************
select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'TMP_PRC_JERARQUIA' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'TMP_PRC_JERARQUIA_ITER_IX';
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'TMP_PRC_JERARQUIA' and table_schema = 'bi_cdd_dwh';
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX TMP_PRC_JERARQUIA_ITER_IX ON TMP_PRC_JERARQUIA (DIA_ID, ITER, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE TMP_PRC_JERARQUIA_ITER_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE TMP_PRC_JERARQUIA_ITER_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
end if;

select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'TMP_PRC_JERARQUIA' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'TMP_PRC_JERARQUIA_FASE_ACT_IX';
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'TMP_PRC_JERARQUIA' and table_schema = 'bi_cdd_dwh';
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX TMP_PRC_JERARQUIA_FASE_ACT_IX ON TMP_PRC_JERARQUIA (DIA_ID, FASE_ACTUAL, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE TMP_PRC_JERARQUIA_FASE_ACT_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE TMP_PRC_JERARQUIA_FASE_ACT_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
end if;

select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'TMP_PRC_JERARQUIA' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'TMP_PRC_JERARQUIA_ULT_FASE_IX';
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'TMP_PRC_JERARQUIA' and table_schema = 'bi_cdd_dwh';
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX TMP_PRC_JERARQUIA_ULT_FASE_IX ON TMP_PRC_JERARQUIA (DIA_ID, ULTIMA_FASE, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE TMP_PRC_JERARQUIA_ULT_FASE_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE TMP_PRC_JERARQUIA_ULT_FASE_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
end if;

select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'TMP_PRC_DETALLE' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'TMP_PRC_DETALLE_IX';
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'TMP_PRC_DETALLE' and table_schema = 'bi_cdd_dwh';
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX TMP_PRC_DETALLE_IX ON TMP_PRC_DETALLE (ITER, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE TMP_PRC_DETALLE_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE TMP_PRC_DETALLE_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
end if;

select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'TMP_PRC_TAREA' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'TMP_PRC_TAREA_IX';
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'TMP_PRC_TAREA' and table_schema = 'bi_cdd_dwh';
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX TMP_PRC_TAREA_IX ON TMP_PRC_TAREA (ITER, TAREA, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE TMP_PRC_TAREA_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE TMP_PRC_TAREA_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
end if;


select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'TMP_PRC_CONTRATO' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'TMP_PRC_CONTRATO_IX';
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'TMP_PRC_CONTRATO' and table_schema = 'bi_cdd_dwh';
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX TMP_PRC_CONTRATO_IX ON TMP_PRC_CONTRATO (ITER, CONTRATO, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE TMP_PRC_CONTRATO_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE TMP_PRC_CONTRATO_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
end if;

select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'TMP_PRC_CONTRATO' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'TMP_PRC_CONTRATO_CEX_IX';
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'TMP_PRC_CONTRATO' and table_schema = 'bi_cdd_dwh';
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX TMP_PRC_CONTRATO_CEX_IX ON TMP_PRC_CONTRATO (CEX_ID, CONTRATO, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE TMP_PRC_CONTRATO_CEX_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE TMP_PRC_CONTRATO_CEX_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
end if;

-- 

select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'TMP_PRC_CONCURSO_CONTRATO' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'TMP_PRC_CONCURSO_CONTRATO_IX';
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'TMP_PRC_CONCURSO_CONTRATO' and table_schema = 'bi_cdd_dwh';
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX TMP_PRC_CONCURSO_CONTRATO_IX ON TMP_PRC_CONCURSO_CONTRATO (ITER, CONTRATO, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE TMP_PRC_CONCURSO_CONTRATO_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE TMP_PRC_CONCURSO_CONTRATO_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
end if;

-- 

select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'TMP_PRC_AUTO_PRORROGAS' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'TMP_PRC_AUTO_PRORROGAS_IX';
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'TMP_PRC_AUTO_PRORROGAS' and table_schema = 'bi_cdd_dwh';
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX TMP_PRC_AUTO_PRORROGAS_IX ON TMP_PRC_AUTO_PRORROGAS (TAREA, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE TMP_PRC_AUTO_PRORROGAS_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE TMP_PRC_AUTO_PRORROGAS_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
end if;
-- 

select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'TMP_PRC_COBROS' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'TMP_PRC_COBROS_IX';
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'TMP_PRC_COBROS' and table_schema = 'bi_cdd_dwh';
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX TMP_PRC_COBROS_IX ON TMP_PRC_COBROS (CONTRATO, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE TMP_PRC_COBROS_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE TMP_PRC_COBROS_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
end if;
-- 

select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'TMP_PRC_ESTIMACION' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'TMP_PRC_ESTIMACION_IX';
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'TMP_PRC_ESTIMACION' and table_schema = 'bi_cdd_dwh';
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX TMP_PRC_ESTIMACION_IX ON TMP_PRC_ESTIMACION (ITER, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE TMP_PRC_ESTIMACION_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE TMP_PRC_ESTIMACION_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
end if;

-- 

select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'TMP_PRC_CARTERA' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'TMP_PRC_CARTERA_IX';
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'TMP_PRC_CARTERA' and table_schema = 'bi_cdd_dwh';
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX TMP_PRC_CARTERA_IX ON TMP_PRC_CARTERA (CONTRATO, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE TMP_PRC_CARTERA_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE TMP_PRC_CARTERA_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
end if;

-- 

select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'TMP_PRC_FECHA_CONTABLE_LITIGIO' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'TMP_PRC_FECHA_CONT_LIT_IX';
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'TMP_PRC_FECHA_CONTABLE_LITIGIO' and table_schema = 'bi_cdd_dwh';
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX TMP_PRC_FECHA_CONT_LIT_IX ON TMP_PRC_FECHA_CONTABLE_LITIGIO (CONTRATO, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE TMP_PRC_FECHA_CONT_LIT_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE TMP_PRC_FECHA_CONT_LIT_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
end if;

-- 

select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'TMP_PRC_TITULAR' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'TMP_PRC_TITULAR_IX';
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'TMP_PRC_TITULAR' and table_schema = 'bi_cdd_dwh';
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX TMP_PRC_TITULAR_IX ON TMP_PRC_TITULAR (PROCEDIMIENTO, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE TMP_PRC_TITULAR_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE TMP_PRC_TITULAR_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
end if;
-- 

select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'TMP_PRC_DEMANDADO' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'TMP_PRC_DEMANDADO_IX';
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'TMP_PRC_DEMANDADO' and table_schema = 'bi_cdd_dwh';
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX TMP_PRC_DEMANDADO_IX ON TMP_PRC_DEMANDADO (PROCEDIMIENTO, CONTRATO, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE TMP_PRC_DEMANDADO_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE TMP_PRC_DEMANDADO_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
end if;

select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'TMP_PRC_EXTRAS_RECOVERY_BI' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'TMP_PRC_EXTRAS_RECOVERY_BI_IX';
select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'TMP_PRC_EXTRAS_RECOVERY_BI' and table_schema = 'bi_cdd_dwh';
if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX TMP_PRC_EXTRAS_RECOVERY_BI_IX ON TMP_PRC_EXTRAS_RECOVERY_BI (FECHA_VALOR, UNIDAD_GESTION, ENTIDAD_CEDENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE TMP_PRC_EXTRAS_RECOVERY_BI_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE TMP_PRC_EXTRAS_RECOVERY_BI_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
end if;

 
END MY_BLOCK_H_PCR
