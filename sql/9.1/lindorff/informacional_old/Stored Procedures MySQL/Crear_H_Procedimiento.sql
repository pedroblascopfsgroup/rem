-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`lindorff`@`ba01` PROCEDURE `Crear_H_Procedimiento`(OUT o_error_status varchar(500))
MY_BLOCK_H_PCR: BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Septiembre 2013
-- Responsable última modificación: María Villanueva, PFS Group
-- Fecha última modificación: 18/09/2015
-- Motivos del cambio: tablas necesarias para ultima resolución
-- Cliente: Recovery BI Lindorff  
--
-- Descripción: Procedimiento almancenado que crea la tabla de hechos Procedimiento.
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
  
 CREATE TABLE IF NOT EXISTS H_PROCEDIMIENTO( 
  `DIA_ID` DATE NOT NULL,  
  `FECHA_CARGA_DATOS` DATE NOT NULL,                                    -- Fecha último día cargado
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL,                            -- ID de la primera fase del procedimiento (PRC_PRC_ID = NULL). Identifica al procedimiento (Secuencia de actuaciones)
  `FASE_MAX_PRIORIDAD` DECIMAL(16,0) NULL,                              -- ID de la fase con mayor prioridad (Si hay varias de igual prioridad la última cronológicamente)
  `FASE_ANTERIOR` DECIMAL(16,0) NULL,                                   -- ID de la penúltima fase del procedimiento (padre de la última fase)
  `FASE_ACTUAL` DECIMAL(16,0) NULL,                                     -- ID de la última fase del procedimiento (fase con la última tarea o de mayor ID si el procedimiento no tiene tareas asociadas)
  `ULTIMA_TAREA_CREADA` DECIMAL(16,0) NULL,                             -- ID de la última tarea creada asociada al procedimiento (indica la fase actual)
  `ULTIMA_TAREA_FINALIZADA` DECIMAL(16,0) NULL,                         -- ID de la última tarea finalizada asociada al procedimiento 
  `ULTIMA_TAREA_ACTUALIZADA` DECIMAL(16,0) NULL,                        -- ID de la última tarea actualizada asociada al procedimiento
  `ULTIMA_TAREA_PENDIENTE` DECIMAL(16,0) NULL,                          -- ID de la última tarea pendiente asociada al procedimiento (última creada no finalizada)
  `ULTIMA_TAREA_PENDIENTE_FA` DECIMAL(16,0) NULL,                       -- ID de la última tarea pendiente de la fase actual (última creada no finalizada)
  `FECHA_CREACION_ASUNTO` DATE NULL,
  `FECHA_CONTABLE_LITIGIO` DATE NULL,                                   -- DD_IFC_ID =12
  `FECHA_CREACION_PROCEDIMIENTO` DATE NULL,
  `FECHA_CREACION_FASE_MAX_PRIORIDAD` DATE NULL,
  `FECHA_CREACION_FASE_ANTERIOR` DATE NULL, 
  `FECHA_CREACION_FASE_ACTUAL` DATE NULL, 
  `FECHA_ULTIMA_TAREA_CREADA` DATE NULL, 
  `FECHA_ULTIMA_TAREA_FINALIZADA` DATE NULL, 
  `FECHA_ULTIMA_TAREA_ACTUALIZADA` DATE NULL,                           -- Fecha de actualización de la última tarea actualizada
  `FECHA_ULTIMA_TAREA_PENDIENTE` DATE NULL,                             -- Fecha de creación de la última tarea pendiente
  `FECHA_ULTIMA_TAREA_PENDIENTE_FA` DATE NULL, 
  `FECHA_VENCIMIENTO_ORIGINAL_ULT_TAREA_FINALIZADA` DATE NULL, 
  `FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA` DATE NULL,
  `FECHA_VENCIMIENTO_ORIGINAL_ULT_TAREA_PENDIENTE` DATE NULL, 
  `FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE` DATE NULL,
  `FECHA_ACEPTACION` DATE NULL,                                         -- Fecha de Trámite de aceptación y decisión (Fecha final de la tarea "Registrar toma de decisión" 
  `FECHA_RECOGIDA_DOC_Y_ACEPTACION` DATE NULL,                          -- Fecha fin de la tarea Recogida de documentación y aceptación (Trámite de aceptación y decisión)
  `FECHA_REGISTRAR_TOMA_DECISION` DATE NULL,                            -- Fecha fin de la tarea Registrar toma de decisión (Trámite de aceptación y decisión) 
  `FECHA_RECEPCION_DOC_COMPLETA` DATE NULL,                             -- Fecha recepción documentación completa (Trámite de aceptación y decisión) 
  `FECHA_INTERPOSICION_DEMANDA` DATE NULL,
  `FECHA_ULTIMA_POSICION_VENCIDA` DATE NULL,                            -- Fecha de la última posición vencida asociada de los contratos asociados al procedimiento
  `FECHA_ULTIMA_ESTIMACION` DATE NULL, 
  `FECHA_ESTIMADA_COBRO` DATE NULL, 
  `FECHA_ULTIMO_COBRO` DATE NULL, 
  `FECHA_ULTIMA_RESOLUCION` DATE NULL, 
  `FECHA_ULTIMO_IMPULSO` DATE NULL,
  `FECHA_ULTIMA_INADMISION` DATE NULL, 
  `FECHA_ULTIMO_ARCHIVO` DATE NULL,
  `FECHA_ULTIMO_REQUERIMIENTO_PREVIO` DATE NULL,
  `CONTEXTO_FASE` VARCHAR(250) NULL,                                    -- Secuencia de fases (IDs de las fases del procedimiento)
  `NIVEL` INT NULL,                                                     -- Nivel de profundidad en la jerarquía de fases del procedimiento
  -- Dimensiones
  `ASUNTO_ID` DECIMAL(16,0) NULL,                                       -- Asunto al que pertenece el procedimiento
  `TIPO_PROCEDIMIENTO_DETALLE_ID` DECIMAL(16,0) NULL,                   -- Categorización del procedimiento (Secuencia de actuaciones) según las prioridades de éstas.
  `FASE_ACTUAL_DETALLE_ID` DECIMAL(16,0) NULL, 
  `FASE_ANTERIOR_DETALLE_ID` DECIMAL(16,0) NULL,
  `ULTIMA_TAREA_CREADA_TIPO_DETALLE_ID` DECIMAL(16,0) NULL, 
  `ULTIMA_TAREA_CREADA_DESCRIPCION_ID` DECIMAL(16,0) NULL, 
  `ULTIMA_TAREA_FINALIZADA_TIPO_DETALLE_ID` DECIMAL(16,0) NULL,
  `ULTIMA_TAREA_FINALIZADA_DESCRIPCION_ID` DECIMAL(16,0) NULL,
  `ULTIMA_TAREA_ACTUALIZADA_TIPO_DETALLE_ID` DECIMAL(16,0) NULL, 
  `ULTIMA_TAREA_ACTUALIZADA_DESCRIPCION_ID` DECIMAL(16,0) NULL,
  `ULTIMA_TAREA_PENDIENTE_TIPO_DETALLE_ID` DECIMAL(16,0) NULL, 
  `ULTIMA_TAREA_PENDIENTE_DESCRIPCION_ID` DECIMAL(16,0) NULL,
  `ULTIMA_TAREA_PENDIENTE_FA_TIPO_DETALLE_ID` DECIMAL(16,0) NULL, 
  `ULTIMA_TAREA_PENDIENTE_FA_DESCRIPCION_ID` DECIMAL(16,0) NULL,
  `CUMPLIMIENTO_ULTIMA_TAREA_FINALIZADA_ID` DECIMAL(16,0) NULL,         -- -2 Ninguna Tarea Pendiente Asocidada, 0  En Plazo, 1 Fuera De Plazo
  `CUMPLIMIENTO_ULTIMA_TAREA_PENDIENTE_ID` DECIMAL(16,0) NULL,          -- -2 Ninguna Tarea Pendiente Asocidada, 0  En Plazo, 1 Fuera De Plazo
  `ESTADO_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL,                         -- Activo o cancelado (todas sus fases canceladas)
  `ESTADO_ASUNTO_ID` DECIMAL(16,0) NULL,
  `ESTADO_ASUNTO_AGRUPADO_ID` DECIMAL(16,0) NULL,
  `ESTADO_FASE_ACTUAL_ID` DECIMAL(16,0) NULL, 
  `ESTADO_FASE_ANTERIOR_ID` DECIMAL(16,0) NULL,
  `TRAMO_SALDO_TOTAL_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL ,              -- 0 si SALDO_ACTUAL_TOTAL < 1MM € / 1 si SALDO_ACTUAL_TOTAL >= 1 MM €
  `TRAMO_SALDO_TOTAL_CONCURSO_ID` DECIMAL(16,0) NULL ,                   -- 0 si SALDO_CONCURSOS_TOTAL < 1MM € / 1 si SALDO_CONCURSOS_TOTAL >= 1 MM €
  `TRAMO_DIAS_ULTIMA_ACTUALIZACION_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL, -- 0 si <= 30 Días / 1 si 31 - 60 Días / 2 si 61 - 90 Días/ 3 si > 90 Días
  `TRAMO_DIAS_CONTRATO_VENCIDO_ID` DECIMAL(16,0) NULL ,                  -- 0 si <= 30 Días / 1 si 31 - 60 Días / 2 si 61 - 90 Días/ 3 si > 90 Días
  `TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_ID` DECIMAL(16,0) NULL,             
  `TRAMO_DIAS_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID` DECIMAL(16,0) NULL,  
  `TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION_ID` DECIMAL(16,0) NULL,
  `TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID` DECIMAL(16,0) NULL,
  `TRAMO_DIAS_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPT_ID` DECIMAL(16,0) NULL,  
  `TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGISTRAR_TOMA_DECISION_ID` DECIMAL(16,0) NULL,
  `TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEPCION_DOC_COMPLETA_ID` DECIMAL(16,0) NULL,
  `CONTRATO_GARANTIA_REAL_ASOCIADO_ID` DECIMAL(16,0) NULL ,              -- 0 Contrato Garantía Real No Asociado / 1 Contrato Garantía Real Asociado
  `ACTUALIZACION_ESTIMACIONES_ID` DECIMAL(16,0) NULL ,
  `CARTERA_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL ,                        -- Cartera a la que pertence el contrato / Comprartida si hay varios tipos
  `CEDENTE_CONTRATO_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL ,
  `PROPIETARIO_CONTRATO_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL , 
  `SEGMENTO_CONTRATO_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL ,
  `SOCIO_CONTRATO_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL ,
  `TITULAR_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL,                         -- Rerefencia a PER_ID
  `REFERENCIA_ASUNTO` VARCHAR(50) NULL,   
  `PROCEDIMIENTO_CON_COBRO_ID` DECIMAL(16,0) NULL ,				                -- Cargamos a 0 o 1 dependiendo si se han producido cobros en el procedimiento
  `PROCURADOR_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL ,
  `PROCEDIMIENTO_CON_PROCURADOR_ID` DECIMAL(16,0) NULL ,                 -- Cargamos a 0 o 1 dependiendo si tiene procurador asignado
  `PROCEDIMIENTO_CON_RESOLUCION_ID` DECIMAL(16,0) NULL ,                 -- Cargamos a 0 o 1 dependiendo si tiene resolución 
  `PROCEDIMIENTO_CON_IMPULSO_ID` DECIMAL(16,0) NULL ,                    -- Cargamos a 0 o 1 dependiendo si tiene impulso
  `TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_ID` DECIMAL(16,0) NULL,
  `TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_ID` DECIMAL(16,0) NULL,
  `RESULTADO_ULTIMO_IMPULSO_ID` DECIMAL(16,0) NULL,
  `JUZGADO_ID` DECIMAL(16,0) NULL ,
  `NUMERO_AUTO` VARCHAR(50) NULL ,                                       -- Número de auto. No lleva índice. Forma de atributo de procedimiento que cambia en el tiempo
  `TIPO_ULTIMA_RESOLUCION_ID` DECIMAL(16,0) NULL ,
  `MOTIVO_INADMISION_ULTIMA_RESOLUCION_ID` DECIMAL(16,0) NULL ,
  `MOTIVO_ARCHIVO_ULTIMA_RESOLUCION_ID` DECIMAL(16,0) NULL ,
  `REQUERIMIENTO_PREVIO_ULTIMA_RESOLUCION_ID` DECIMAL(16,0) NULL ,
  -- Métricas
  `NUM_PROCEDIMIENTOS` INT NULL,  
  `NUM_CONTRATOS` INT NULL,  
  `NUM_FASES` INT NULL,  
  `NUM_DIAS_DESDE_ULT_ACTUALIZACION` INT NULL,                           -- Número de dias desde la última actualización del procedimiento (Máxima fecha asociada a la última fase del procedimiento)
  `NUM_MAX_DIAS_CONTRATO_VENCIDO` INT NULL,                              -- Número máximo de días vencidos de un contrato asociado al procedimiento respeto a la fecha de análisis
  `NUM_MAX_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO` INT NULL,     -- Número máximo de días vencidos de un contrato asociado al procedimiento respecto a la creación del asunto
  `PORCENTAJE_RECUPERACION` INT NULL ,                                   -- Porcentaje recuperado
  `PLAZO_RECUPERACION` INT NULL ,                                        -- Estimación temporal para recuperación
  `SALDO_RECUPERACION` DECIMAL(14,2) NULL ,                              -- Saldo por recuperar
  `ESTIMACIÓN_RECUPERACION` DECIMAL(14,2) NULL ,                         -- SALDO_RECUPERACION * PORCENTAJE_RECUPERACION
  `SALDO_ORIGINAL_VENCIDO` DECIMAL(14,2) NULL ,                          -- Saldo vencido original al crear el procedimiento (De la tabla PRC_PROCEDIMIENTOS)
  `SALDO_ORIGINAL_NO_VENCIDO` DECIMAL(14,2) NULL ,                       -- Saldo no vencido original al crear el procedimiento (De la tabla PRC_PROCEDIMIENTOS)
  `SALDO_ACTUAL_VENCIDO` DECIMAL(14,2) NULL ,                            -- Saldo vencido de los contratos asociados al procedimiento
  `SALDO_ACTUAL_NO_VENCIDO` DECIMAL(14,2) NULL ,                         -- Saldo no vencido de los contratos asociados al procedimiento
  `SALDO_ACTUAL_TOTAL` DECIMAL(14,2) NULL ,                              -- Suma de los saldos vencido y no vencido de los contratos asociados al procedimiento
  `SALDO_CONCURSOS_VENCIDO` DECIMAL(14,2) NULL ,                         -- Saldo vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
  `SALDO_CONCURSOS_NO_VENCIDO` DECIMAL(14,2) NULL ,                      -- Saldo no vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
  `SALDO_CONCURSOS_TOTAL` DECIMAL(14,2) NULL ,                           -- Suma de los saldos vencido y no vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
  `INGRESOS_PENDIENTES_APLICAR` DECIMAL(14,2) NULL ,                     -- Ingresos pendientes de aplicar de los contratos asociados al procedimiento
  `SUBTOTAL` DECIMAL(14,2) NULL ,                                        -- Subtotal del procedimiento (NGB)
  `RESTANTE_TOTAL` DECIMAL(14,2) NULL ,                                  -- Restante total de los contratos asociados al procedimiento
  `DURACION_ULT_TAREA_FINALIZADA` INT NULL,                              -- Duración tarea en días (Fecha inicio hasta fecha fin)
  `NUM_DIAS_EXCEDIDO_ULT_TAREA_FINALIZADA` INT NULL,                     -- Número días desde fecha vencimiento (vigente) hasta fecha actual
  `NUM_DIAS_HASTA_VENCIMIENTO_ULT_TAREA_FINALIZADA` INT NULL,            -- Número días desde fecha actual hasta fecha vencimiento (valores negativos si no quedan días)
  `NUM_DIAS_PRORROGADOS_ULT_TAREA_FINALIZADA` INT NULL ,                 -- Número días desde fecha vencimineto real (original) hasta fecha vencimiento vigente
  `NUM_PRORROGAS_ULT_TAREA_FINALIZADA` INT NULL,                         -- Número prórrogas pedidas para la tarea
  `DURACION_ULT_TAREA_PENDIENTE` INT NULL,                               -- Duración tarea en días (Fecha inicio hasta fecha fin o fecha actual)
  `NUM_DIAS_EXCEDIDO_ULT_TAREA_PENDIENTE` INT NULL,                      -- Número días desde fecha vencimiento (vigente) hasta fecha actual
  `NUM_DIAS_HASTA_VENCIMIENTO_ULT_TAREA_PENDIENTE` INT NULL,             -- Número días desde fecha actual hasta fecha vencimiento (valores negativos si no quedan días)
  `NUM_DIAS_PRORROGADOS_ULT_TAREA_PENDIENTE` INT NULL ,                  -- Número días desde fecha vencimineto real (original) hasta fecha vencimiento vigente
  `NUM_PRORROGAS_ULT_TAREA_PENDIENTE` INT NULL,                          -- Número prórrogas pedidas para la tarea
  `PLAZO_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA` INT NULL,  
  `PLAZO_CREACION_ASUNTO_A_ACEPTACION` INT NULL,   
  `PLAZO_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA` INT NULL,
  `PLAZO_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPTACION` INT NULL,
  `PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_REGISTRAR_TOMA_DECISION` INT NULL,
  `PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_RECEPCION_DOC_COMPLETA` INT NULL,
  `NUM_DIAS_DESDE_ULTIMA_ESTIMACION` INT NULL,
  `NUM_DIAS_DESDE_ULTIMA_RESOLUCION` INT NULL,
  `NUM_DIAS_DESDE_ULTIMO_IMPULSO` INT NULL
 );
 
 
  CREATE TABLE IF NOT EXISTS H_PROCEDIMIENTO_MES( 
  `MES_ID` DECIMAL(16,0) NOT NULL,                                      -- Mes de análisis 
  `FECHA_CARGA_DATOS` DATE NOT NULL,                                    -- Fecha último día cargado
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL,                            -- ID de la primera fase del procedimiento (PRC_PRC_ID = NULL). Identifica al procedimiento (Secuencia de actuaciones)
  `FASE_MAX_PRIORIDAD` DECIMAL(16,0) NULL,                              -- ID de la fase con mayor prioridad (Si hay varias de igual prioridad la última cronológicamente)
  `FASE_ANTERIOR` DECIMAL(16,0) NULL,                                   -- ID de la penúltima fase del procedimiento (padre de la última fase)
  `FASE_ACTUAL` DECIMAL(16,0) NULL,                                     -- ID de la última fase del procedimiento (fase con la última tarea o de mayor ID si el procedimiento no tiene tareas asociadas)
  `ULTIMA_TAREA_CREADA` DECIMAL(16,0) NULL,                             -- ID de la última tarea creada asociada al procedimiento (indica la fase actual)
  `ULTIMA_TAREA_FINALIZADA` DECIMAL(16,0) NULL,                         -- ID de la última tarea finalizada asociada al procedimiento 
  `ULTIMA_TAREA_ACTUALIZADA` DECIMAL(16,0) NULL,                        -- ID de la última tarea actualizada asociada al procedimiento
  `ULTIMA_TAREA_PENDIENTE` DECIMAL(16,0) NULL,                          -- ID de la última tarea pendiente asociada al procedimiento (última creada no finalizada)
  `ULTIMA_TAREA_PENDIENTE_FA` DECIMAL(16,0) NULL,                       -- ID de la última tarea pendiente de la fase actual (última creada no finalizada)
  `FECHA_CREACION_ASUNTO` DATE NULL,
  `FECHA_CONTABLE_LITIGIO` DATE NULL,                                   -- DD_IFC_ID =12
  `FECHA_CREACION_PROCEDIMIENTO` DATE NULL,
  `FECHA_CREACION_FASE_MAX_PRIORIDAD` DATE NULL,
  `FECHA_CREACION_FASE_ANTERIOR` DATE NULL, 
  `FECHA_CREACION_FASE_ACTUAL` DATE NULL, 
  `FECHA_ULTIMA_TAREA_CREADA` DATE NULL, 
  `FECHA_ULTIMA_TAREA_FINALIZADA` DATE NULL, 
  `FECHA_ULTIMA_TAREA_ACTUALIZADA` DATE NULL,                           -- Fecha de actualización de la última tarea actualizada
  `FECHA_ULTIMA_TAREA_PENDIENTE` DATE NULL,                             -- Fecha de creación de la última tarea pendiente
  `FECHA_ULTIMA_TAREA_PENDIENTE_FA` DATE NULL, 
  `FECHA_VENCIMIENTO_ORIGINAL_ULT_TAREA_FINALIZADA` DATE NULL, 
  `FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA` DATE NULL,
  `FECHA_VENCIMIENTO_ORIGINAL_ULT_TAREA_PENDIENTE` DATE NULL, 
  `FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE` DATE NULL,
  `FECHA_ACEPTACION` DATE NULL,                                         -- Fecha de Trámite de aceptación y decisión (Fecha final de la tarea "Registrar toma de decisión" 
  `FECHA_RECOGIDA_DOC_Y_ACEPTACION` DATE NULL,                          -- Fecha fin de la tarea Recogida de documentación y aceptación (Trámite de aceptación y decisión)
  `FECHA_REGISTRAR_TOMA_DECISION` DATE NULL,                            -- Fecha fin de la tarea Registrar toma de decisión (Trámite de aceptación y decisión) 
  `FECHA_RECEPCION_DOC_COMPLETA` DATE NULL,                             -- Fecha recepción documentación completa (Trámite de aceptación y decisión) 
  `FECHA_INTERPOSICION_DEMANDA` DATE NULL,
  `FECHA_ULTIMA_POSICION_VENCIDA` DATE NULL,                            -- Fecha de la última posición vencida asociada de los contratos asociados al procedimiento
  `FECHA_ULTIMA_ESTIMACION` DATE NULL, 
  `FECHA_ESTIMADA_COBRO` DATE NULL, 
  `FECHA_ULTIMO_COBRO` DATE NULL, 
  `FECHA_ULTIMA_RESOLUCION` DATE NULL, 
  `FECHA_ULTIMO_IMPULSO` DATE NULL,
  `FECHA_ULTIMA_INADMISION` DATE NULL, 
  `FECHA_ULTIMO_ARCHIVO` DATE NULL,
  `FECHA_ULTIMO_REQUERIMIENTO_PREVIO` DATE NULL,
  `CONTEXTO_FASE` VARCHAR(250) NULL,                                    -- Secuencia de fases (IDs de las fases del procedimiento)
  `NIVEL` INT NULL,                                                     -- Nivel de profundidad en la jerarquía de fases del procedimiento
  -- Dimensiones
  `ASUNTO_ID` DECIMAL(16,0) NULL,                                       -- Asunto al que pertenece el procedimiento
  `TIPO_PROCEDIMIENTO_DETALLE_ID` DECIMAL(16,0) NULL,                   -- Categorización del procedimiento (Secuencia de actuaciones) según las prioridades de éstas.
  `FASE_ACTUAL_DETALLE_ID` DECIMAL(16,0) NULL, 
  `FASE_ANTERIOR_DETALLE_ID` DECIMAL(16,0) NULL,
  `ULTIMA_TAREA_CREADA_TIPO_DETALLE_ID` DECIMAL(16,0) NULL, 
  `ULTIMA_TAREA_CREADA_DESCRIPCION_ID` DECIMAL(16,0) NULL, 
  `ULTIMA_TAREA_FINALIZADA_TIPO_DETALLE_ID` DECIMAL(16,0) NULL,
  `ULTIMA_TAREA_FINALIZADA_DESCRIPCION_ID` DECIMAL(16,0) NULL,
  `ULTIMA_TAREA_ACTUALIZADA_TIPO_DETALLE_ID` DECIMAL(16,0) NULL, 
  `ULTIMA_TAREA_ACTUALIZADA_DESCRIPCION_ID` DECIMAL(16,0) NULL,
  `ULTIMA_TAREA_PENDIENTE_TIPO_DETALLE_ID` DECIMAL(16,0) NULL, 
  `ULTIMA_TAREA_PENDIENTE_DESCRIPCION_ID` DECIMAL(16,0) NULL,
  `ULTIMA_TAREA_PENDIENTE_FA_TIPO_DETALLE_ID` DECIMAL(16,0) NULL, 
  `ULTIMA_TAREA_PENDIENTE_FA_DESCRIPCION_ID` DECIMAL(16,0) NULL,
  `CUMPLIMIENTO_ULTIMA_TAREA_FINALIZADA_ID` DECIMAL(16,0) NULL,         -- -2 Ninguna Tarea Pendiente Asocidada, 0  En Plazo, 1 Fuera De Plazo
  `CUMPLIMIENTO_ULTIMA_TAREA_PENDIENTE_ID` DECIMAL(16,0) NULL,          -- -2 Ninguna Tarea Pendiente Asocidada, 0  En Plazo, 1 Fuera De Plazo
  `ESTADO_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL,                         -- Activo o cancelado (todas sus fases canceladas)
  `ESTADO_ASUNTO_ID` DECIMAL(16,0) NULL,
  `ESTADO_ASUNTO_AGRUPADO_ID` DECIMAL(16,0) NULL,
  `ESTADO_FASE_ACTUAL_ID` DECIMAL(16,0) NULL, 
  `ESTADO_FASE_ANTERIOR_ID` DECIMAL(16,0) NULL,
  `TRAMO_SALDO_TOTAL_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL ,              -- 0 si SALDO_ACTUAL_TOTAL < 1MM € / 1 si SALDO_ACTUAL_TOTAL >= 1 MM €
  `TRAMO_SALDO_TOTAL_CONCURSO_ID` DECIMAL(16,0) NULL ,                   -- 0 si SALDO_CONCURSOS_TOTAL < 1MM € / 1 si SALDO_CONCURSOS_TOTAL >= 1 MM €
  `TRAMO_DIAS_ULTIMA_ACTUALIZACION_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL, -- 0 si <= 30 Días / 1 si 31 - 60 Días / 2 si 61 - 90 Días/ 3 si > 90 Días
  `TRAMO_DIAS_CONTRATO_VENCIDO_ID` DECIMAL(16,0) NULL ,                  -- 0 si <= 30 Días / 1 si 31 - 60 Días / 2 si 61 - 90 Días/ 3 si > 90 Días
  `TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_ID` DECIMAL(16,0) NULL,             
  `TRAMO_DIAS_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID` DECIMAL(16,0) NULL,  
  `TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION_ID` DECIMAL(16,0) NULL,
  `TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID` DECIMAL(16,0) NULL,
  `TRAMO_DIAS_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPT_ID` DECIMAL(16,0) NULL,  
  `TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGISTRAR_TOMA_DECISION_ID` DECIMAL(16,0) NULL,
  `TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEPCION_DOC_COMPLETA_ID` DECIMAL(16,0) NULL,
  `CONTRATO_GARANTIA_REAL_ASOCIADO_ID` DECIMAL(16,0) NULL ,              -- 0 Contrato Garantía Real No Asociado / 1 Contrato Garantía Real Asociado
  `ACTUALIZACION_ESTIMACIONES_ID` DECIMAL(16,0) NULL ,
  `CARTERA_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL ,                        -- Cartera a la que pertence el contrato / Comprartida si hay varios tipos
  `CEDENTE_CONTRATO_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL ,
  `PROPIETARIO_CONTRATO_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL , 
  `SEGMENTO_CONTRATO_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL ,
  `SOCIO_CONTRATO_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL ,
  `TITULAR_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL,                         -- Rerefencia a PER_ID
  `REFERENCIA_ASUNTO` VARCHAR(50) NULL, 
  `PROCEDIMIENTO_CON_COBRO_ID` DECIMAL(16,0) NULL ,				                -- Cargamos a 0 o 1 dependiendo si se han producido cobros en el procedimiento
  `PROCURADOR_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL ,
  `PROCEDIMIENTO_CON_PROCURADOR_ID` DECIMAL(16,0) NULL ,                 -- Cargamos a 0 o 1 dependiendo si tiene procurador asignado
  `PROCEDIMIENTO_CON_RESOLUCION_ID` DECIMAL(16,0) NULL ,                 -- Cargamos a 0 o 1 dependiendo si tiene resolución 
  `PROCEDIMIENTO_CON_IMPULSO_ID` DECIMAL(16,0) NULL ,                    -- Cargamos a 0 o 1 dependiendo si tiene impulso
  `TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_ID` DECIMAL(16,0) NULL,
  `TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_ID` DECIMAL(16,0) NULL,
  `RESULTADO_ULTIMO_IMPULSO_ID` DECIMAL(16,0) NULL,
  `JUZGADO_ID` DECIMAL(16,0) NULL ,
  `NUMERO_AUTO` VARCHAR(50) NULL ,                                       -- Número de auto. No lleva índice. Forma de atributo de procedimiento que cambia en el tiempo
  `TIPO_ULTIMA_RESOLUCION_ID` DECIMAL(16,0) NULL ,
  `MOTIVO_INADMISION_ULTIMA_RESOLUCION_ID` DECIMAL(16,0) NULL ,
  `MOTIVO_ARCHIVO_ULTIMA_RESOLUCION_ID` DECIMAL(16,0) NULL ,
  `REQUERIMIENTO_PREVIO_ULTIMA_RESOLUCION_ID` DECIMAL(16,0) NULL ,
  -- Métricas
  `NUM_PROCEDIMIENTOS` INT NULL,  
  `NUM_CONTRATOS` INT NULL,  
  `NUM_FASES` INT NULL,  
  `NUM_DIAS_DESDE_ULT_ACTUALIZACION` INT NULL,                           -- Número de dias desde la última actualización del procedimiento (Máxima fecha asociada a la última fase del procedimiento)
  `NUM_MAX_DIAS_CONTRATO_VENCIDO` INT NULL,                              -- Número máximo de días vencidos de un contrato asociado al procedimiento respeto a la fecha de análisis
  `NUM_MAX_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO` INT NULL,     -- Número máximo de días vencidos de un contrato asociado al procedimiento respecto a la creación del asunto
  `PORCENTAJE_RECUPERACION` INT NULL ,                                   -- Porcentaje recuperado
  `PLAZO_RECUPERACION` INT NULL ,                                        -- Estimación temporal para recuperación
  `SALDO_RECUPERACION` DECIMAL(14,2) NULL ,                              -- Saldo por recuperar
  `ESTIMACIÓN_RECUPERACION` DECIMAL(14,2) NULL ,                         -- SALDO_RECUPERACION * PORCENTAJE_RECUPERACION
  `SALDO_ORIGINAL_VENCIDO` DECIMAL(14,2) NULL ,                          -- Saldo vencido original al crear el procedimiento (De la tabla PRC_PROCEDIMIENTOS)
  `SALDO_ORIGINAL_NO_VENCIDO` DECIMAL(14,2) NULL ,                       -- Saldo no vencido original al crear el procedimiento (De la tabla PRC_PROCEDIMIENTOS)
  `SALDO_ACTUAL_VENCIDO` DECIMAL(14,2) NULL ,                            -- Saldo vencido de los contratos asociados al procedimiento
  `SALDO_ACTUAL_NO_VENCIDO` DECIMAL(14,2) NULL ,                         -- Saldo no vencido de los contratos asociados al procedimiento
  `SALDO_ACTUAL_TOTAL` DECIMAL(14,2) NULL ,                              -- Suma de los saldos vencido y no vencido de los contratos asociados al procedimiento
  `SALDO_CONCURSOS_VENCIDO` DECIMAL(14,2) NULL ,                         -- Saldo vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
  `SALDO_CONCURSOS_NO_VENCIDO` DECIMAL(14,2) NULL ,                      -- Saldo no vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
  `SALDO_CONCURSOS_TOTAL` DECIMAL(14,2) NULL ,                           -- Suma de los saldos vencido y no vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
  `INGRESOS_PENDIENTES_APLICAR` DECIMAL(14,2) NULL ,                     -- Ingresos pendientes de aplicar de los contratos asociados al procedimiento
  `SUBTOTAL` DECIMAL(14,2) NULL ,                                        -- Subtotal del procedimiento (NGB)
  `RESTANTE_TOTAL` DECIMAL(14,2) NULL ,                                  -- Restante total de los contratos asociados al procedimiento
  `DURACION_ULT_TAREA_FINALIZADA` INT NULL,                              -- Duración tarea en días (Fecha inicio hasta fecha fin)
  `NUM_DIAS_EXCEDIDO_ULT_TAREA_FINALIZADA` INT NULL,                     -- Número días desde fecha vencimiento (vigente) hasta fecha actual
  `NUM_DIAS_HASTA_VENCIMIENTO_ULT_TAREA_FINALIZADA` INT NULL,            -- Número días desde fecha actual hasta fecha vencimiento (valores negativos si no quedan días)
  `NUM_DIAS_PRORROGADOS_ULT_TAREA_FINALIZADA` INT NULL ,                 -- Número días desde fecha vencimineto real (original) hasta fecha vencimiento vigente
  `NUM_PRORROGAS_ULT_TAREA_FINALIZADA` INT NULL,                         -- Número prórrogas pedidas para la tarea
  `DURACION_ULT_TAREA_PENDIENTE` INT NULL,                               -- Duración tarea en días (Fecha inicio hasta fecha fin o fecha actual)
  `NUM_DIAS_EXCEDIDO_ULT_TAREA_PENDIENTE` INT NULL,                      -- Número días desde fecha vencimiento (vigente) hasta fecha actual
  `NUM_DIAS_HASTA_VENCIMIENTO_ULT_TAREA_PENDIENTE` INT NULL,             -- Número días desde fecha actual hasta fecha vencimiento (valores negativos si no quedan días)
  `NUM_DIAS_PRORROGADOS_ULT_TAREA_PENDIENTE` INT NULL ,                  -- Número días desde fecha vencimineto real (original) hasta fecha vencimiento vigente
  `NUM_PRORROGAS_ULT_TAREA_PENDIENTE` INT NULL,                          -- Número prórrogas pedidas para la tarea
  `PLAZO_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA` INT NULL,  
  `PLAZO_CREACION_ASUNTO_A_ACEPTACION` INT NULL,   
  `PLAZO_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA` INT NULL,
  `PLAZO_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPTACION` INT NULL,
  `PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_REGISTRAR_TOMA_DECISION` INT NULL,
  `PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_RECEPCION_DOC_COMPLETA` INT NULL,
  `NUM_DIAS_DESDE_ULTIMA_ESTIMACION` INT NULL,
  `NUM_DIAS_DESDE_ULTIMA_RESOLUCION` INT NULL,
  `NUM_DIAS_DESDE_ULTIMO_IMPULSO` INT NULL
 );
 
 
  CREATE TABLE IF NOT EXISTS H_PROCEDIMIENTO_TRIMESTRE( 
  `TRIMESTRE_ID` DECIMAL(16,0) NOT NULL,                                -- Trimestre de análisis    
  `FECHA_CARGA_DATOS` DATE NOT NULL,                                    -- Fecha último día cargado
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL,                            -- ID de la primera fase del procedimiento (PRC_PRC_ID = NULL). Identifica al procedimiento (Secuencia de actuaciones)
  `FASE_MAX_PRIORIDAD` DECIMAL(16,0) NULL,                              -- ID de la fase con mayor prioridad (Si hay varias de igual prioridad la última cronológicamente)
  `FASE_ANTERIOR` DECIMAL(16,0) NULL,                                   -- ID de la penúltima fase del procedimiento (padre de la última fase)
  `FASE_ACTUAL` DECIMAL(16,0) NULL,                                     -- ID de la última fase del procedimiento (fase con la última tarea o de mayor ID si el procedimiento no tiene tareas asociadas)
  `ULTIMA_TAREA_CREADA` DECIMAL(16,0) NULL,                             -- ID de la última tarea creada asociada al procedimiento (indica la fase actual)
  `ULTIMA_TAREA_FINALIZADA` DECIMAL(16,0) NULL,                         -- ID de la última tarea finalizada asociada al procedimiento 
  `ULTIMA_TAREA_ACTUALIZADA` DECIMAL(16,0) NULL,                        -- ID de la última tarea actualizada asociada al procedimiento
  `ULTIMA_TAREA_PENDIENTE` DECIMAL(16,0) NULL,                          -- ID de la última tarea pendiente asociada al procedimiento (última creada no finalizada)
  `ULTIMA_TAREA_PENDIENTE_FA` DECIMAL(16,0) NULL,                       -- ID de la última tarea pendiente de la fase actual (última creada no finalizada)
  `FECHA_CREACION_ASUNTO` DATE NULL,
  `FECHA_CONTABLE_LITIGIO` DATE NULL,                                   -- DD_IFC_ID =12
  `FECHA_CREACION_PROCEDIMIENTO` DATE NULL,
  `FECHA_CREACION_FASE_MAX_PRIORIDAD` DATE NULL,
  `FECHA_CREACION_FASE_ANTERIOR` DATE NULL, 
  `FECHA_CREACION_FASE_ACTUAL` DATE NULL, 
  `FECHA_ULTIMA_TAREA_CREADA` DATE NULL, 
  `FECHA_ULTIMA_TAREA_FINALIZADA` DATE NULL, 
  `FECHA_ULTIMA_TAREA_ACTUALIZADA` DATE NULL,                           -- Fecha de actualización de la última tarea actualizada
  `FECHA_ULTIMA_TAREA_PENDIENTE` DATE NULL,                             -- Fecha de creación de la última tarea pendiente
  `FECHA_ULTIMA_TAREA_PENDIENTE_FA` DATE NULL, 
  `FECHA_VENCIMIENTO_ORIGINAL_ULT_TAREA_FINALIZADA` DATE NULL, 
  `FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA` DATE NULL,
  `FECHA_VENCIMIENTO_ORIGINAL_ULT_TAREA_PENDIENTE` DATE NULL, 
  `FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE` DATE NULL,
  `FECHA_ACEPTACION` DATE NULL,                                         -- Fecha de Trámite de aceptación y decisión (Fecha final de la tarea "Registrar toma de decisión" 
  `FECHA_RECOGIDA_DOC_Y_ACEPTACION` DATE NULL,                          -- Fecha fin de la tarea Recogida de documentación y aceptación (Trámite de aceptación y decisión)
  `FECHA_REGISTRAR_TOMA_DECISION` DATE NULL,                            -- Fecha fin de la tarea Registrar toma de decisión (Trámite de aceptación y decisión) 
  `FECHA_RECEPCION_DOC_COMPLETA` DATE NULL,                             -- Fecha recepción documentación completa (Trámite de aceptación y decisión) 
  `FECHA_INTERPOSICION_DEMANDA` DATE NULL,
  `FECHA_ULTIMA_POSICION_VENCIDA` DATE NULL,                            -- Fecha de la última posición vencida asociada de los contratos asociados al procedimiento
  `FECHA_ULTIMA_ESTIMACION` DATE NULL, 
  `FECHA_ESTIMADA_COBRO` DATE NULL, 
  `FECHA_ULTIMO_COBRO` DATE NULL, 
  `FECHA_ULTIMA_RESOLUCION` DATE NULL, 
  `FECHA_ULTIMO_IMPULSO` DATE NULL,
  `FECHA_ULTIMA_INADMISION` DATE NULL, 
  `FECHA_ULTIMO_ARCHIVO` DATE NULL,
  `FECHA_ULTIMO_REQUERIMIENTO_PREVIO` DATE NULL,
  `CONTEXTO_FASE` VARCHAR(250) NULL,                                    -- Secuencia de fases (IDs de las fases del procedimiento)
  `NIVEL` INT NULL,                                                     -- Nivel de profundidad en la jerarquía de fases del procedimiento
  -- Dimensiones
  `ASUNTO_ID` DECIMAL(16,0) NULL,                                       -- Asunto al que pertenece el procedimiento
  `TIPO_PROCEDIMIENTO_DETALLE_ID` DECIMAL(16,0) NULL,                   -- Categorización del procedimiento (Secuencia de actuaciones) según las prioridades de éstas.
  `FASE_ACTUAL_DETALLE_ID` DECIMAL(16,0) NULL, 
  `FASE_ANTERIOR_DETALLE_ID` DECIMAL(16,0) NULL,
  `ULTIMA_TAREA_CREADA_TIPO_DETALLE_ID` DECIMAL(16,0) NULL, 
  `ULTIMA_TAREA_CREADA_DESCRIPCION_ID` DECIMAL(16,0) NULL, 
  `ULTIMA_TAREA_FINALIZADA_TIPO_DETALLE_ID` DECIMAL(16,0) NULL,
  `ULTIMA_TAREA_FINALIZADA_DESCRIPCION_ID` DECIMAL(16,0) NULL,
  `ULTIMA_TAREA_ACTUALIZADA_TIPO_DETALLE_ID` DECIMAL(16,0) NULL, 
  `ULTIMA_TAREA_ACTUALIZADA_DESCRIPCION_ID` DECIMAL(16,0) NULL,
  `ULTIMA_TAREA_PENDIENTE_TIPO_DETALLE_ID` DECIMAL(16,0) NULL, 
  `ULTIMA_TAREA_PENDIENTE_DESCRIPCION_ID` DECIMAL(16,0) NULL,
  `ULTIMA_TAREA_PENDIENTE_FA_TIPO_DETALLE_ID` DECIMAL(16,0) NULL, 
  `ULTIMA_TAREA_PENDIENTE_FA_DESCRIPCION_ID` DECIMAL(16,0) NULL,
  `CUMPLIMIENTO_ULTIMA_TAREA_FINALIZADA_ID` DECIMAL(16,0) NULL,         -- -2 Ninguna Tarea Pendiente Asocidada, 0  En Plazo, 1 Fuera De Plazo
  `CUMPLIMIENTO_ULTIMA_TAREA_PENDIENTE_ID` DECIMAL(16,0) NULL,          -- -2 Ninguna Tarea Pendiente Asocidada, 0  En Plazo, 1 Fuera De Plazo
  `ESTADO_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL,                         -- Activo o cancelado (todas sus fases canceladas)
  `ESTADO_ASUNTO_ID` DECIMAL(16,0) NULL,
  `ESTADO_ASUNTO_AGRUPADO_ID` DECIMAL(16,0) NULL,
  `ESTADO_FASE_ACTUAL_ID` DECIMAL(16,0) NULL, 
  `ESTADO_FASE_ANTERIOR_ID` DECIMAL(16,0) NULL,
  `TRAMO_SALDO_TOTAL_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL ,              -- 0 si SALDO_ACTUAL_TOTAL < 1MM € / 1 si SALDO_ACTUAL_TOTAL >= 1 MM €
  `TRAMO_SALDO_TOTAL_CONCURSO_ID` DECIMAL(16,0) NULL ,                   -- 0 si SALDO_CONCURSOS_TOTAL < 1MM € / 1 si SALDO_CONCURSOS_TOTAL >= 1 MM €
  `TRAMO_DIAS_ULTIMA_ACTUALIZACION_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL, -- 0 si <= 30 Días / 1 si 31 - 60 Días / 2 si 61 - 90 Días/ 3 si > 90 Días
  `TRAMO_DIAS_CONTRATO_VENCIDO_ID` DECIMAL(16,0) NULL ,                  -- 0 si <= 30 Días / 1 si 31 - 60 Días / 2 si 61 - 90 Días/ 3 si > 90 Días
  `TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_ID` DECIMAL(16,0) NULL,             
  `TRAMO_DIAS_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID` DECIMAL(16,0) NULL,  
  `TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION_ID` DECIMAL(16,0) NULL,
  `TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID` DECIMAL(16,0) NULL,
  `TRAMO_DIAS_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPT_ID` DECIMAL(16,0) NULL,  
  `TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGISTRAR_TOMA_DECISION_ID` DECIMAL(16,0) NULL,
  `TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEPCION_DOC_COMPLETA_ID` DECIMAL(16,0) NULL,
  `CONTRATO_GARANTIA_REAL_ASOCIADO_ID` DECIMAL(16,0) NULL ,              -- 0 Contrato Garantía Real No Asociado / 1 Contrato Garantía Real Asociado
  `ACTUALIZACION_ESTIMACIONES_ID` DECIMAL(16,0) NULL ,
  `CARTERA_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL ,                        -- Cartera a la que pertence el contrato / Comprartida si hay varios tipos
  `CEDENTE_CONTRATO_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL ,
  `PROPIETARIO_CONTRATO_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL , 
  `SEGMENTO_CONTRATO_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL ,
  `SOCIO_CONTRATO_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL ,
  `TITULAR_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL,                         -- Rerefencia a PER_ID
  `REFERENCIA_ASUNTO` VARCHAR(50) NULL, 
  `PROCEDIMIENTO_CON_COBRO_ID` DECIMAL(16,0) NULL ,				                -- Cargamos a 0 o 1 dependiendo si se han producido cobros en el procedimiento
  `PROCURADOR_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL ,
  `PROCEDIMIENTO_CON_PROCURADOR_ID` DECIMAL(16,0) NULL ,                 -- Cargamos a 0 o 1 dependiendo si tiene procurador asignado
  `PROCEDIMIENTO_CON_RESOLUCION_ID` DECIMAL(16,0) NULL ,                 -- Cargamos a 0 o 1 dependiendo si tiene resolución 
  `PROCEDIMIENTO_CON_IMPULSO_ID` DECIMAL(16,0) NULL ,                    -- Cargamos a 0 o 1 dependiendo si tiene impulso
  `TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_ID` DECIMAL(16,0) NULL,
  `TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_ID` DECIMAL(16,0) NULL,
  `RESULTADO_ULTIMO_IMPULSO_ID` DECIMAL(16,0) NULL,
  `JUZGADO_ID` DECIMAL(16,0) NULL ,
  `NUMERO_AUTO` VARCHAR(50) NULL ,                                       -- Número de auto. No lleva índice. Forma de atributo de procedimiento que cambia en el tiempo
  `TIPO_ULTIMA_RESOLUCION_ID` DECIMAL(16,0) NULL ,
  `MOTIVO_INADMISION_ULTIMA_RESOLUCION_ID` DECIMAL(16,0) NULL ,
  `MOTIVO_ARCHIVO_ULTIMA_RESOLUCION_ID` DECIMAL(16,0) NULL ,
  `REQUERIMIENTO_PREVIO_ULTIMA_RESOLUCION_ID` DECIMAL(16,0) NULL ,
  -- Métricas
  `NUM_PROCEDIMIENTOS` INT NULL,  
  `NUM_CONTRATOS` INT NULL,  
  `NUM_FASES` INT NULL,  
  `NUM_DIAS_DESDE_ULT_ACTUALIZACION` INT NULL,                           -- Número de dias desde la última actualización del procedimiento (Máxima fecha asociada a la última fase del procedimiento)
  `NUM_MAX_DIAS_CONTRATO_VENCIDO` INT NULL,                              -- Número máximo de días vencidos de un contrato asociado al procedimiento respeto a la fecha de análisis
  `NUM_MAX_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO` INT NULL,     -- Número máximo de días vencidos de un contrato asociado al procedimiento respecto a la creación del asunto
  `PORCENTAJE_RECUPERACION` INT NULL ,                                   -- Porcentaje recuperado
  `PLAZO_RECUPERACION` INT NULL ,                                        -- Estimación temporal para recuperación
  `SALDO_RECUPERACION` DECIMAL(14,2) NULL ,                              -- Saldo por recuperar
  `ESTIMACIÓN_RECUPERACION` DECIMAL(14,2) NULL ,                         -- SALDO_RECUPERACION * PORCENTAJE_RECUPERACION
  `SALDO_ORIGINAL_VENCIDO` DECIMAL(14,2) NULL ,                          -- Saldo vencido original al crear el procedimiento (De la tabla PRC_PROCEDIMIENTOS)
  `SALDO_ORIGINAL_NO_VENCIDO` DECIMAL(14,2) NULL ,                       -- Saldo no vencido original al crear el procedimiento (De la tabla PRC_PROCEDIMIENTOS)
  `SALDO_ACTUAL_VENCIDO` DECIMAL(14,2) NULL ,                            -- Saldo vencido de los contratos asociados al procedimiento
  `SALDO_ACTUAL_NO_VENCIDO` DECIMAL(14,2) NULL ,                         -- Saldo no vencido de los contratos asociados al procedimiento
  `SALDO_ACTUAL_TOTAL` DECIMAL(14,2) NULL ,                              -- Suma de los saldos vencido y no vencido de los contratos asociados al procedimiento
  `SALDO_CONCURSOS_VENCIDO` DECIMAL(14,2) NULL ,                         -- Saldo vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
  `SALDO_CONCURSOS_NO_VENCIDO` DECIMAL(14,2) NULL ,                      -- Saldo no vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
  `SALDO_CONCURSOS_TOTAL` DECIMAL(14,2) NULL ,                           -- Suma de los saldos vencido y no vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
  `INGRESOS_PENDIENTES_APLICAR` DECIMAL(14,2) NULL ,                     -- Ingresos pendientes de aplicar de los contratos asociados al procedimiento
  `SUBTOTAL` DECIMAL(14,2) NULL ,                                        -- Subtotal del procedimiento (NGB)
  `RESTANTE_TOTAL` DECIMAL(14,2) NULL ,                                  -- Restante total de los contratos asociados al procedimiento
  `DURACION_ULT_TAREA_FINALIZADA` INT NULL,                              -- Duración tarea en días (Fecha inicio hasta fecha fin)
  `NUM_DIAS_EXCEDIDO_ULT_TAREA_FINALIZADA` INT NULL,                     -- Número días desde fecha vencimiento (vigente) hasta fecha actual
  `NUM_DIAS_HASTA_VENCIMIENTO_ULT_TAREA_FINALIZADA` INT NULL,            -- Número días desde fecha actual hasta fecha vencimiento (valores negativos si no quedan días)
  `NUM_DIAS_PRORROGADOS_ULT_TAREA_FINALIZADA` INT NULL ,                 -- Número días desde fecha vencimineto real (original) hasta fecha vencimiento vigente
  `NUM_PRORROGAS_ULT_TAREA_FINALIZADA` INT NULL,                         -- Número prórrogas pedidas para la tarea
  `DURACION_ULT_TAREA_PENDIENTE` INT NULL,                               -- Duración tarea en días (Fecha inicio hasta fecha fin o fecha actual)
  `NUM_DIAS_EXCEDIDO_ULT_TAREA_PENDIENTE` INT NULL,                      -- Número días desde fecha vencimiento (vigente) hasta fecha actual
  `NUM_DIAS_HASTA_VENCIMIENTO_ULT_TAREA_PENDIENTE` INT NULL,             -- Número días desde fecha actual hasta fecha vencimiento (valores negativos si no quedan días)
  `NUM_DIAS_PRORROGADOS_ULT_TAREA_PENDIENTE` INT NULL ,                  -- Número días desde fecha vencimineto real (original) hasta fecha vencimiento vigente
  `NUM_PRORROGAS_ULT_TAREA_PENDIENTE` INT NULL,                          -- Número prórrogas pedidas para la tarea
  `PLAZO_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA` INT NULL,  
  `PLAZO_CREACION_ASUNTO_A_ACEPTACION` INT NULL,   
  `PLAZO_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA` INT NULL,
  `PLAZO_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPTACION` INT NULL,
  `PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_REGISTRAR_TOMA_DECISION` INT NULL,
  `PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_RECEPCION_DOC_COMPLETA` INT NULL,
  `NUM_DIAS_DESDE_ULTIMA_ESTIMACION` INT NULL,
  `NUM_DIAS_DESDE_ULTIMA_RESOLUCION` INT NULL,
  `NUM_DIAS_DESDE_ULTIMO_IMPULSO` INT NULL
 );
 

  CREATE TABLE IF NOT EXISTS H_PROCEDIMIENTO_ANIO( 
  `ANIO_ID` DECIMAL(16,0) NOT NULL,                                     -- Año de análisis
  `FECHA_CARGA_DATOS` DATE NOT NULL,                                    -- Fecha último día cargado
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL,                            -- ID de la primera fase del procedimiento (PRC_PRC_ID = NULL). Identifica al procedimiento (Secuencia de actuaciones)
  `FASE_MAX_PRIORIDAD` DECIMAL(16,0) NULL,                              -- ID de la fase con mayor prioridad (Si hay varias de igual prioridad la última cronológicamente)
  `FASE_ANTERIOR` DECIMAL(16,0) NULL,                                   -- ID de la penúltima fase del procedimiento (padre de la última fase)
  `FASE_ACTUAL` DECIMAL(16,0) NULL,                                     -- ID de la última fase del procedimiento (fase con la última tarea o de mayor ID si el procedimiento no tiene tareas asociadas)
  `ULTIMA_TAREA_CREADA` DECIMAL(16,0) NULL,                             -- ID de la última tarea creada asociada al procedimiento (indica la fase actual)
  `ULTIMA_TAREA_FINALIZADA` DECIMAL(16,0) NULL,                         -- ID de la última tarea finalizada asociada al procedimiento 
  `ULTIMA_TAREA_ACTUALIZADA` DECIMAL(16,0) NULL,                        -- ID de la última tarea actualizada asociada al procedimiento
  `ULTIMA_TAREA_PENDIENTE` DECIMAL(16,0) NULL,                          -- ID de la última tarea pendiente asociada al procedimiento (última creada no finalizada)
  `ULTIMA_TAREA_PENDIENTE_FA` DECIMAL(16,0) NULL,                       -- ID de la última tarea pendiente de la fase actual (última creada no finalizada)
  `FECHA_CREACION_ASUNTO` DATE NULL,
  `FECHA_CONTABLE_LITIGIO` DATE NULL,                                   -- DD_IFC_ID =12
  `FECHA_CREACION_PROCEDIMIENTO` DATE NULL,
  `FECHA_CREACION_FASE_MAX_PRIORIDAD` DATE NULL,
  `FECHA_CREACION_FASE_ANTERIOR` DATE NULL, 
  `FECHA_CREACION_FASE_ACTUAL` DATE NULL, 
  `FECHA_ULTIMA_TAREA_CREADA` DATE NULL, 
  `FECHA_ULTIMA_TAREA_FINALIZADA` DATE NULL, 
  `FECHA_ULTIMA_TAREA_ACTUALIZADA` DATE NULL,                           -- Fecha de actualización de la última tarea actualizada
  `FECHA_ULTIMA_TAREA_PENDIENTE` DATE NULL,                             -- Fecha de creación de la última tarea pendiente
  `FECHA_ULTIMA_TAREA_PENDIENTE_FA` DATE NULL, 
  `FECHA_VENCIMIENTO_ORIGINAL_ULT_TAREA_FINALIZADA` DATE NULL, 
  `FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA` DATE NULL,
  `FECHA_VENCIMIENTO_ORIGINAL_ULT_TAREA_PENDIENTE` DATE NULL, 
  `FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE` DATE NULL,
  `FECHA_ACEPTACION` DATE NULL,                                         -- Fecha de Trámite de aceptación y decisión (Fecha final de la tarea "Registrar toma de decisión" 
  `FECHA_RECOGIDA_DOC_Y_ACEPTACION` DATE NULL,                          -- Fecha fin de la tarea Recogida de documentación y aceptación (Trámite de aceptación y decisión)
  `FECHA_REGISTRAR_TOMA_DECISION` DATE NULL,                            -- Fecha fin de la tarea Registrar toma de decisión (Trámite de aceptación y decisión) 
  `FECHA_RECEPCION_DOC_COMPLETA` DATE NULL,                             -- Fecha recepción documentación completa (Trámite de aceptación y decisión) 
  `FECHA_INTERPOSICION_DEMANDA` DATE NULL,
  `FECHA_ULTIMA_POSICION_VENCIDA` DATE NULL,                            -- Fecha de la última posición vencida asociada de los contratos asociados al procedimiento
  `FECHA_ULTIMA_ESTIMACION` DATE NULL, 
  `FECHA_ESTIMADA_COBRO` DATE NULL, 
  `FECHA_ULTIMO_COBRO` DATE NULL, 
  `FECHA_ULTIMA_RESOLUCION` DATE NULL, 
  `FECHA_ULTIMO_IMPULSO` DATE NULL,
  `FECHA_ULTIMA_INADMISION` DATE NULL, 
  `FECHA_ULTIMO_ARCHIVO` DATE NULL,
  `FECHA_ULTIMO_REQUERIMIENTO_PREVIO` DATE NULL,
  `CONTEXTO_FASE` VARCHAR(250) NULL,                                    -- Secuencia de fases (IDs de las fases del procedimiento)
  `NIVEL` INT NULL,                                                     -- Nivel de profundidad en la jerarquía de fases del procedimiento
  -- Dimensiones
  `ASUNTO_ID` DECIMAL(16,0) NULL,                                       -- Asunto al que pertenece el procedimiento
  `TIPO_PROCEDIMIENTO_DETALLE_ID` DECIMAL(16,0) NULL,                   -- Categorización del procedimiento (Secuencia de actuaciones) según las prioridades de éstas.
  `FASE_ACTUAL_DETALLE_ID` DECIMAL(16,0) NULL, 
  `FASE_ANTERIOR_DETALLE_ID` DECIMAL(16,0) NULL,
  `ULTIMA_TAREA_CREADA_TIPO_DETALLE_ID` DECIMAL(16,0) NULL, 
  `ULTIMA_TAREA_CREADA_DESCRIPCION_ID` DECIMAL(16,0) NULL, 
  `ULTIMA_TAREA_FINALIZADA_TIPO_DETALLE_ID` DECIMAL(16,0) NULL,
  `ULTIMA_TAREA_FINALIZADA_DESCRIPCION_ID` DECIMAL(16,0) NULL,
  `ULTIMA_TAREA_ACTUALIZADA_TIPO_DETALLE_ID` DECIMAL(16,0) NULL, 
  `ULTIMA_TAREA_ACTUALIZADA_DESCRIPCION_ID` DECIMAL(16,0) NULL,
  `ULTIMA_TAREA_PENDIENTE_TIPO_DETALLE_ID` DECIMAL(16,0) NULL, 
  `ULTIMA_TAREA_PENDIENTE_DESCRIPCION_ID` DECIMAL(16,0) NULL,
  `ULTIMA_TAREA_PENDIENTE_FA_TIPO_DETALLE_ID` DECIMAL(16,0) NULL, 
  `ULTIMA_TAREA_PENDIENTE_FA_DESCRIPCION_ID` DECIMAL(16,0) NULL,
  `CUMPLIMIENTO_ULTIMA_TAREA_FINALIZADA_ID` DECIMAL(16,0) NULL,         -- -2 Ninguna Tarea Pendiente Asocidada, 0  En Plazo, 1 Fuera De Plazo
  `CUMPLIMIENTO_ULTIMA_TAREA_PENDIENTE_ID` DECIMAL(16,0) NULL,          -- -2 Ninguna Tarea Pendiente Asocidada, 0  En Plazo, 1 Fuera De Plazo
  `ESTADO_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL,                         -- Activo o cancelado (todas sus fases canceladas)
  `ESTADO_ASUNTO_ID` DECIMAL(16,0) NULL,
  `ESTADO_ASUNTO_AGRUPADO_ID` DECIMAL(16,0) NULL,
  `ESTADO_FASE_ACTUAL_ID` DECIMAL(16,0) NULL, 
  `ESTADO_FASE_ANTERIOR_ID` DECIMAL(16,0) NULL,
  `TRAMO_SALDO_TOTAL_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL ,              -- 0 si SALDO_ACTUAL_TOTAL < 1MM € / 1 si SALDO_ACTUAL_TOTAL >= 1 MM €
  `TRAMO_SALDO_TOTAL_CONCURSO_ID` DECIMAL(16,0) NULL ,                   -- 0 si SALDO_CONCURSOS_TOTAL < 1MM € / 1 si SALDO_CONCURSOS_TOTAL >= 1 MM €
  `TRAMO_DIAS_ULTIMA_ACTUALIZACION_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL, -- 0 si <= 30 Días / 1 si 31 - 60 Días / 2 si 61 - 90 Días/ 3 si > 90 Días
  `TRAMO_DIAS_CONTRATO_VENCIDO_ID` DECIMAL(16,0) NULL ,                  -- 0 si <= 30 Días / 1 si 31 - 60 Días / 2 si 61 - 90 Días/ 3 si > 90 Días
  `TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_ID` DECIMAL(16,0) NULL,             
  `TRAMO_DIAS_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID` DECIMAL(16,0) NULL,  
  `TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION_ID` DECIMAL(16,0) NULL,
  `TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID` DECIMAL(16,0) NULL,
  `TRAMO_DIAS_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPT_ID` DECIMAL(16,0) NULL,  
  `TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGISTRAR_TOMA_DECISION_ID` DECIMAL(16,0) NULL,
  `TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEPCION_DOC_COMPLETA_ID` DECIMAL(16,0) NULL,
  `CONTRATO_GARANTIA_REAL_ASOCIADO_ID` DECIMAL(16,0) NULL ,              -- 0 Contrato Garantía Real No Asociado / 1 Contrato Garantía Real Asociado
  `ACTUALIZACION_ESTIMACIONES_ID` DECIMAL(16,0) NULL ,
  `CARTERA_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL ,                        -- Cartera a la que pertence el contrato / Comprartida si hay varios tipos
  `CEDENTE_CONTRATO_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL ,
  `PROPIETARIO_CONTRATO_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL , 
  `SEGMENTO_CONTRATO_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL ,
  `SOCIO_CONTRATO_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL ,
  `TITULAR_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL,                         -- Rerefencia a PER_ID
  `REFERENCIA_ASUNTO` VARCHAR(50) NULL, 
  `PROCEDIMIENTO_CON_COBRO_ID` DECIMAL(16,0) NULL ,				                -- Cargamos a 0 o 1 dependiendo si se han producido cobros en el procedimiento
  `PROCURADOR_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL ,
  `PROCEDIMIENTO_CON_PROCURADOR_ID` DECIMAL(16,0) NULL ,                 -- Cargamos a 0 o 1 dependiendo si tiene procurador asignado
  `PROCEDIMIENTO_CON_RESOLUCION_ID` DECIMAL(16,0) NULL ,                 -- Cargamos a 0 o 1 dependiendo si tiene resolución 
  `PROCEDIMIENTO_CON_IMPULSO_ID` DECIMAL(16,0) NULL ,                    -- Cargamos a 0 o 1 dependiendo si tiene impulso
  `TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_ID` DECIMAL(16,0) NULL,
  `TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_ID` DECIMAL(16,0) NULL,
  `RESULTADO_ULTIMO_IMPULSO_ID` DECIMAL(16,0) NULL,
  `JUZGADO_ID` DECIMAL(16,0) NULL ,
  `NUMERO_AUTO` VARCHAR(50) NULL ,                                       -- Número de auto. No lleva índice. Forma de atributo de procedimiento que cambia en el tiempo
  `TIPO_ULTIMA_RESOLUCION_ID` DECIMAL(16,0) NULL ,
  `MOTIVO_INADMISION_ULTIMA_RESOLUCION_ID` DECIMAL(16,0) NULL ,
  `MOTIVO_ARCHIVO_ULTIMA_RESOLUCION_ID` DECIMAL(16,0) NULL ,
  `REQUERIMIENTO_PREVIO_ULTIMA_RESOLUCION_ID` DECIMAL(16,0) NULL ,
  -- Métricas
  `NUM_PROCEDIMIENTOS` INT NULL,  
  `NUM_CONTRATOS` INT NULL,  
  `NUM_FASES` INT NULL,  
  `NUM_DIAS_DESDE_ULT_ACTUALIZACION` INT NULL,                           -- Número de dias desde la última actualización del procedimiento (Máxima fecha asociada a la última fase del procedimiento)
  `NUM_MAX_DIAS_CONTRATO_VENCIDO` INT NULL,                              -- Número máximo de días vencidos de un contrato asociado al procedimiento respeto a la fecha de análisis
  `NUM_MAX_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO` INT NULL,     -- Número máximo de días vencidos de un contrato asociado al procedimiento respecto a la creación del asunto
  `PORCENTAJE_RECUPERACION` INT NULL ,                                   -- Porcentaje recuperado
  `PLAZO_RECUPERACION` INT NULL ,                                        -- Estimación temporal para recuperación
  `SALDO_RECUPERACION` DECIMAL(14,2) NULL ,                              -- Saldo por recuperar
  `ESTIMACIÓN_RECUPERACION` DECIMAL(14,2) NULL ,                         -- SALDO_RECUPERACION * PORCENTAJE_RECUPERACION
  `SALDO_ORIGINAL_VENCIDO` DECIMAL(14,2) NULL ,                          -- Saldo vencido original al crear el procedimiento (De la tabla PRC_PROCEDIMIENTOS)
  `SALDO_ORIGINAL_NO_VENCIDO` DECIMAL(14,2) NULL ,                       -- Saldo no vencido original al crear el procedimiento (De la tabla PRC_PROCEDIMIENTOS)
  `SALDO_ACTUAL_VENCIDO` DECIMAL(14,2) NULL ,                            -- Saldo vencido de los contratos asociados al procedimiento
  `SALDO_ACTUAL_NO_VENCIDO` DECIMAL(14,2) NULL ,                         -- Saldo no vencido de los contratos asociados al procedimiento
  `SALDO_ACTUAL_TOTAL` DECIMAL(14,2) NULL ,                              -- Suma de los saldos vencido y no vencido de los contratos asociados al procedimiento
  `SALDO_CONCURSOS_VENCIDO` DECIMAL(14,2) NULL ,                         -- Saldo vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
  `SALDO_CONCURSOS_NO_VENCIDO` DECIMAL(14,2) NULL ,                      -- Saldo no vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
  `SALDO_CONCURSOS_TOTAL` DECIMAL(14,2) NULL ,                           -- Suma de los saldos vencido y no vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
  `INGRESOS_PENDIENTES_APLICAR` DECIMAL(14,2) NULL ,                     -- Ingresos pendientes de aplicar de los contratos asociados al procedimiento
  `SUBTOTAL` DECIMAL(14,2) NULL ,                                        -- Subtotal del procedimiento (NGB)
  `RESTANTE_TOTAL` DECIMAL(14,2) NULL ,                                  -- Restante total de los contratos asociados al procedimiento
  `DURACION_ULT_TAREA_FINALIZADA` INT NULL,                              -- Duración tarea en días (Fecha inicio hasta fecha fin)
  `NUM_DIAS_EXCEDIDO_ULT_TAREA_FINALIZADA` INT NULL,                     -- Número días desde fecha vencimiento (vigente) hasta fecha actual
  `NUM_DIAS_HASTA_VENCIMIENTO_ULT_TAREA_FINALIZADA` INT NULL,            -- Número días desde fecha actual hasta fecha vencimiento (valores negativos si no quedan días)
  `NUM_DIAS_PRORROGADOS_ULT_TAREA_FINALIZADA` INT NULL ,                 -- Número días desde fecha vencimineto real (original) hasta fecha vencimiento vigente
  `NUM_PRORROGAS_ULT_TAREA_FINALIZADA` INT NULL,                         -- Número prórrogas pedidas para la tarea
  `DURACION_ULT_TAREA_PENDIENTE` INT NULL,                               -- Duración tarea en días (Fecha inicio hasta fecha fin o fecha actual)
  `NUM_DIAS_EXCEDIDO_ULT_TAREA_PENDIENTE` INT NULL,                      -- Número días desde fecha vencimiento (vigente) hasta fecha actual
  `NUM_DIAS_HASTA_VENCIMIENTO_ULT_TAREA_PENDIENTE` INT NULL,             -- Número días desde fecha actual hasta fecha vencimiento (valores negativos si no quedan días)
  `NUM_DIAS_PRORROGADOS_ULT_TAREA_PENDIENTE` INT NULL ,                  -- Número días desde fecha vencimineto real (original) hasta fecha vencimiento vigente
  `NUM_PRORROGAS_ULT_TAREA_PENDIENTE` INT NULL,                          -- Número prórrogas pedidas para la tarea
  `PLAZO_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA` INT NULL,  
  `PLAZO_CREACION_ASUNTO_A_ACEPTACION` INT NULL,   
  `PLAZO_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA` INT NULL,
  `PLAZO_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPTACION` INT NULL,
  `PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_REGISTRAR_TOMA_DECISION` INT NULL,
  `PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_RECEPCION_DOC_COMPLETA` INT NULL,
  `NUM_DIAS_DESDE_ULTIMA_ESTIMACION` INT NULL,
  `NUM_DIAS_DESDE_ULTIMA_RESOLUCION` INT NULL,
  `NUM_DIAS_DESDE_ULTIMO_IMPULSO` INT NULL
 );
 

-- ----------------------------------------------------------------------------------------------
--                                      DETALLE COBRO
-- ----------------------------------------------------------------------------------------------
 CREATE TABLE IF NOT EXISTS H_PROCEDIMIENTO_DETALLE_COBRO( 
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
  `NUM_DIAS_CREACION_ASUNTO_A_COBRO` INT NULL  
 );
 

 CREATE TABLE IF NOT EXISTS H_PROCEDIMIENTO_DETALLE_COBRO_MES( 
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
  `NUM_DIAS_CREACION_ASUNTO_A_COBRO` INT NULL  
 );
 

 CREATE TABLE IF NOT EXISTS H_PROCEDIMIENTO_DETALLE_COBRO_TRIMESTRE( 
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
  `NUM_DIAS_CREACION_ASUNTO_A_COBRO` INT NULL  
 );
 
 
 CREATE TABLE IF NOT EXISTS H_PROCEDIMIENTO_DETALLE_COBRO_ANIO( 
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
  `NUM_DIAS_CREACION_ASUNTO_A_COBRO` INT NULL  
 );
 
 
-- ----------------------------------------------------------------------------------------------
--                                      DETALLE CONTRATO
-- ----------------------------------------------------------------------------------------------
 CREATE TABLE IF NOT EXISTS H_PROCEDIMIENTO_DETALLE_CONTRATO( 
  `DIA_ID` DATE NOT NULL,    
  `FECHA_CARGA_DATOS` DATE NOT NULL, 
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL, 
  `ASUNTO_ID` DECIMAL(16,0) NOT NULL, 
  `CONTRATO_ID` DECIMAL(16,0) NULL, 
  -- Métricas
  `NUM_CONTRATOS_PROCEDIMIENTO` INT NULL
 );
 

 CREATE TABLE IF NOT EXISTS H_PROCEDIMIENTO_DETALLE_CONTRATO_MES( 
  `MES_ID` DECIMAL(16,0) NOT NULL,  
  `FECHA_CARGA_DATOS` DATE NOT NULL, 
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL, 
  `ASUNTO_ID` DECIMAL(16,0) NOT NULL, 
  `CONTRATO_ID` DECIMAL(16,0) NULL, 
  -- Métricas
  `NUM_CONTRATOS_PROCEDIMIENTO` INT NULL 
 );
 

 CREATE TABLE IF NOT EXISTS H_PROCEDIMIENTO_DETALLE_CONTRATO_TRIMESTRE( 
  `TRIMESTRE_ID` DECIMAL(16,0) NOT NULL,  
  `FECHA_CARGA_DATOS` DATE NOT NULL, 
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL, 
  `ASUNTO_ID` DECIMAL(16,0) NOT NULL, 
  `CONTRATO_ID` DECIMAL(16,0) NULL, 
  -- Métricas
  `NUM_CONTRATOS_PROCEDIMIENTO` INT NULL 
 );
 
 
 CREATE TABLE IF NOT EXISTS H_PROCEDIMIENTO_DETALLE_CONTRATO_ANIO( 
  `ANIO_ID` DECIMAL(16,0) NOT NULL,  
  `FECHA_CARGA_DATOS` DATE NOT NULL, 
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL, 
  `ASUNTO_ID` DECIMAL(16,0) NOT NULL, 
  `CONTRATO_ID` DECIMAL(16,0) NULL, 
  -- Métricas
  `NUM_CONTRATOS_PROCEDIMIENTO` INT NULL 
 );


-- ----------------------------------------------------------------------------------------------
--                                      DETALLE RESOLUCIONES
-- ----------------------------------------------------------------------------------------------
 CREATE TABLE IF NOT EXISTS H_PROCEDIMIENTO_DETALLE_RESOLUCION( 
  `DIA_ID` DATE NOT NULL,  
  `FECHA_CARGA_DATOS` DATE NOT NULL,                                 
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL, 
  `ASUNTO_ID` DECIMAL(16,0) NOT NULL, 
  `GESTOR_RESOLUCION_ID` DECIMAL(16,0) NOT NULL, 
  `FECHA_RESOLUCION` DATE NULL, 
  -- Dimensiones
  `TIPO_RESOLUCION_ID` DECIMAL(16,0) NULL,
  `MOTIVO_INADMISION_RESOLUCION_ID` DECIMAL(16,0) NULL ,
  `MOTIVO_ARCHIVO_RESOLUCION_ID` DECIMAL(16,0) NULL ,
  `REQUERIMIENTO_PREVIO_RESOLUCION_ID` DECIMAL(16,0) NULL ,
	`RESOLUCION_ID` DECIMAL(16,0) NULL,
  -- Métricas
  `NUM_RESOLUCIONES` INT NULL
 );


 CREATE TABLE IF NOT EXISTS H_PROCEDIMIENTO_DETALLE_RESOLUCION_MES( 
  `MES_ID` DECIMAL(16,0) NOT NULL,   
  `FECHA_CARGA_DATOS` DATE NOT NULL,                                 
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL, 
  `ASUNTO_ID` DECIMAL(16,0) NOT NULL, 
  `GESTOR_RESOLUCION_ID` DECIMAL(16,0) NOT NULL, 
  `FECHA_RESOLUCION` DATE NULL, 
  -- Dimensiones
  `TIPO_RESOLUCION_ID` DECIMAL(16,0) NULL,
  `MOTIVO_INADMISION_RESOLUCION_ID` DECIMAL(16,0) NULL ,
  `MOTIVO_ARCHIVO_RESOLUCION_ID` DECIMAL(16,0) NULL ,
  `REQUERIMIENTO_PREVIO_RESOLUCION_ID` DECIMAL(16,0) NULL ,
  -- Métricas
  `NUM_RESOLUCIONES` INT NULL
 );


 CREATE TABLE IF NOT EXISTS H_PROCEDIMIENTO_DETALLE_RESOLUCION_TRIMESTRE( 
  `TRIMESTRE_ID` DECIMAL(16,0) NOT NULL,  
  `FECHA_CARGA_DATOS` DATE NOT NULL,                                 
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL, 
  `ASUNTO_ID` DECIMAL(16,0) NOT NULL, 
  `GESTOR_RESOLUCION_ID` DECIMAL(16,0) NOT NULL, 
  `FECHA_RESOLUCION` DATE NULL, 
  -- Dimensiones
  `TIPO_RESOLUCION_ID` DECIMAL(16,0) NULL,
  `MOTIVO_INADMISION_RESOLUCION_ID` DECIMAL(16,0) NULL ,
  `MOTIVO_ARCHIVO_RESOLUCION_ID` DECIMAL(16,0) NULL ,
  `REQUERIMIENTO_PREVIO_RESOLUCION_ID` DECIMAL(16,0) NULL ,
  -- Métricas
  `NUM_RESOLUCIONES` INT NULL
 );


 CREATE TABLE IF NOT EXISTS H_PROCEDIMIENTO_DETALLE_RESOLUCION_ANIO( 
  `ANIO_ID` DECIMAL(16,0) NOT NULL,   
  `FECHA_CARGA_DATOS` DATE NOT NULL,                                 
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NOT NULL, 
  `ASUNTO_ID` DECIMAL(16,0) NOT NULL, 
  `GESTOR_RESOLUCION_ID` DECIMAL(16,0) NOT NULL, 
  `FECHA_RESOLUCION` DATE NULL, 
  -- Dimensiones
  `TIPO_RESOLUCION_ID` DECIMAL(16,0) NULL,
  `MOTIVO_INADMISION_RESOLUCION_ID` DECIMAL(16,0) NULL ,
  `MOTIVO_ARCHIVO_RESOLUCION_ID` DECIMAL(16,0) NULL ,
  `REQUERIMIENTO_PREVIO_RESOLUCION_ID` DECIMAL(16,0) NULL ,
  -- Métricas
  `NUM_RESOLUCIONES` INT NULL
 );
 
-- =========================================================================================================================
--                                                 TABLAS TEMPORALES
-- =========================================================================================================================
 
 CREATE TABLE IF NOT EXISTS TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (
  `DD_TPO_CODIGO` VARCHAR(50) NULL ,
  `PRIORIDAD` INT NULL
  );  

  
 CREATE TABLE IF NOT EXISTS TEMP_PROCEDIMIENTO_JERARQUIA (
  `DIA_ID` DATE NOT NULL,                               
  `ITER` DECIMAL(16,0) NOT NULL,   
  `FASE_ACTUAL` DECIMAL(16,0) NULL,
  `ULTIMA_FASE` DECIMAL(16,0) NULL,
  `ULTIMA_TAREA_CREADA` DECIMAL(16,0) NULL, 
  `ULTIMA_TAREA_FINALIZADA` DECIMAL(16,0) NULL, 
  `ULTIMA_TAREA_ACTUALIZADA` DECIMAL(16,0) NULL, 
  `ULTIMA_TAREA_PENDIENTE` DECIMAL(16,0) NULL,
  `ULTIMA_TAREA_PENDIENTE_FA` DECIMAL(16,0) NULL,
  `FECHA_ULTIMA_TAREA_CREADA` DATETIME NULL,  
  `FECHA_ULTIMA_TAREA_FINALIZADA` DATETIME NULL,  
  `FECHA_ULTIMA_TAREA_ACTUALIZADA` DATETIME NULL , 
  `FECHA_ULTIMA_TAREA_PENDIENTE` DATETIME NULL , 
  `FECHA_ULTIMA_TAREA_PENDIENTE_FA` DATETIME NULL , 
  `FECHA_ACEPTACION` DATE NULL,
  `FECHA_INTERPOSICION_DEMANDA` DATE NULL,
  `FECHA_RECOGIDA_DOC_Y_ACEPTACION` DATE NULL,                          
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
  `SALDO_CONCURSOS_VENCIDO` DECIMAL(14,2) NULL ,                         -- Saldo vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
  `SALDO_CONCURSOS_NO_VENCIDO` DECIMAL(14,2) NULL ,                      -- Saldo no vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
  `INGRESOS_PENDIENTES_APLICAR` DECIMAL(14,2) NULL,
  `SUBTOTAL` DECIMAL(14,2) NULL ,  
  `RESTANTE_TOTAL` DECIMAL(14,2) NULL , 
  `GARANTIA_CONTRATO` DECIMAL(16,0) NULL,
  `NUM_DIAS_VENCIDO` INT NULL,
  `CARTERA` DECIMAL(16,0) NULL,                         
  `CEDENTE` DECIMAL(16,0) NULL,
  `PROPIETARIO` DECIMAL(16,0) NULL,
  `FECHA_CONTABLE_LITIGIO` DATE NULL,
  `TITULAR_PROCEDIMIENTO` DECIMAL(16,0) NULL,
  `REFERENCIA_ASUNTO` VARCHAR(50) NULL,
  `SEGMENTO` VARCHAR(100) NULL,
  `SOCIO` VARCHAR(100) NULL
  ); 
  
  
 CREATE TABLE IF NOT EXISTS TEMP_PROCEDIMIENTO_DETALLE (
  `ITER` DECIMAL(16,0) NULL ,
  `FASE_ACTUAL` DECIMAL(16,0) NULL,
  `ULTIMA_TAREA_CREADA` DECIMAL(16,0) NULL,
  `ULTIMA_TAREA_FINALIZADA` DECIMAL(16,0) NULL, 
  `ULTIMA_TAREA_ACTUALIZADA` DECIMAL(16,0) NULL,
  `ULTIMA_TAREA_PENDIENTE` DECIMAL(16,0) NULL,
  `ULTIMA_TAREA_PENDIENTE_FA` DECIMAL(16,0) NULL,
  `FECHA_ULTIMA_TAREA_CREADA` DATETIME NULL,  
  `FECHA_ULTIMA_TAREA_FINALIZADA` DATETIME NULL,  
  `FECHA_ULTIMA_TAREA_ACTUALIZADA` DATETIME NULL ,  
  `FECHA_ULTIMA_TAREA_PENDIENTE` DATETIME NULL , 
  `FECHA_ULTIMA_TAREA_PENDIENTE_FA` DATETIME NULL , 
  `FECHA_ACEPTACION` DATE NULL,
  `FECHA_INTERPOSICION_DEMANDA` DATE NULL,
  `FECHA_RECOGIDA_DOC_Y_ACEPTACION` DATE NULL,                          
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
  `SALDO_CONCURSOS_VENCIDO` DECIMAL(14,2) NULL ,                         -- Saldo vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
  `SALDO_CONCURSOS_NO_VENCIDO` DECIMAL(14,2) NULL ,                      -- Saldo no vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
  `INGRESOS_PENDIENTES_APLICAR` DECIMAL(14,2) NULL,
  `SUBTOTAL` DECIMAL(14,2) NULL ,  
  `RESTANTE_TOTAL` DECIMAL(14,2) NULL , 
  `GARANTIA_CONTRATO` DECIMAL(16,0) NULL,
  `NUM_DIAS_VENCIDO` INT NULL,
  `CARTERA` DECIMAL(16,0) NULL,                         
  `CEDENTE` DECIMAL(16,0) NULL,
  `PROPIETARIO` DECIMAL(16,0) NULL,
  `FECHA_CONTABLE_LITIGIO` DATE NULL,
  `TITULAR_PROCEDIMIENTO` DECIMAL(16,0) NULL,
  `REFERENCIA_ASUNTO` VARCHAR(50) NULL,
  `SEGMENTO` DECIMAL(16,0) NULL,
  `SOCIO` DECIMAL(16,0) NULL
  );  
  

 CREATE TABLE IF NOT EXISTS TEMP_PROCEDIMIENTO_TAREA (
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
  `FECHA_FORMULARIO` DATE NULL                      -- TEV_VALOR (TEV_TAREA_EXTERNA_VALOR) 
  );   


 CREATE TABLE IF NOT EXISTS TEMP_PROCEDIMIENTO_AUTO_PRORROGAS (
  `TAREA` DECIMAL(16,0) NULL,       
  `FECHA_AUTO_PRORROGA` DATETIME NULL                   -- Para prórrogas y autoprórrogas        
  );  
  

 CREATE TABLE IF NOT EXISTS TEMP_PROCEDIMIENTO_CONTRATO( 
  `ITER` DECIMAL(16,0) NULL, 
  `CONTRATO` DECIMAL(16,0) NULL,
  `CEX_ID` DECIMAL(16,0) NULL,
  `MAX_MOV_ID` DECIMAL(16,0) NULL,
  `SALDO_VENCIDO` DECIMAL(14,2) NULL ,                  -- Saldo vencido de los contratos asociados al procedimiento
  `SALDO_NO_VENCIDO` DECIMAL(14,2) NULL ,               -- Saldo no vencido de los contratos asociados al procedimiento
  `INGRESOS_PENDIENTES_APLICAR` DECIMAL(14,2) NULL,
  `RESTANTE_TOTAL` DECIMAL(14,2) NULL , 
  `FECHA_POS_VENCIDA` DATE NULL,
  `GARANTIA_CONTRATO` DECIMAL(16,0) NULL,               -- Garantía del contrato
  `NUM_DIAS_VENCIDO` INT NULL,
  `CARTERA` DECIMAL(16,0) NULL,                         
  `CEDENTE` DECIMAL(16,0) NULL,
  `PROPIETARIO` DECIMAL(16,0) NULL,
  `FECHA_CONTABLE_LITIGIO` DATE NULL ,                  -- Fecha contable del litigio asociado al contrato
  `REFERENCIA_ASUNTO` VARCHAR(50) NULL,
  `SEGMENTO` DECIMAL(16,0) NULL,
  `SOCIO` DECIMAL(16,0) NULL
 );
 
   
 -- Calcular el saldo de los concursos
  CREATE TABLE IF NOT EXISTS TEMP_PROCEDIMIENTO_CONCURSO_CONTRATO( 
  `ITER` DECIMAL(16,0) NULL, 
  `CONTRATO` DECIMAL(16,0) NULL,
  `SALDO_CONCURSOS_VENCIDO` DECIMAL(14,2) NULL ,                 
  `SALDO_CONCURSOS_NO_VENCIDO` DECIMAL(14,2) NULL ,               
  `DEMANDADO` DECIMAL(16,0) NULL
 );
 
 
  CREATE TABLE IF NOT EXISTS TEMP_PROCEDIMIENTO_CARTERA ( 
  `CONTRATO` DECIMAL(16,0) NULL,
  `CARTERA` DECIMAL(16,0) NULL                         
  );  
 
   CREATE TABLE IF NOT EXISTS TEMP_PROCEDIMIENTO_CEDENTE ( 
  `CONTRATO` DECIMAL(16,0) NULL,
  `CEDENTE` DECIMAL(16,0) NULL                         
  );  
  
  CREATE TABLE IF NOT EXISTS TEMP_PROCEDIMIENTO_PROPIETARIO ( 
  `CONTRATO` DECIMAL(16,0) NULL,
  `PROPIETARIO` DECIMAL(16,0) NULL                         
  );  

  CREATE TABLE IF NOT EXISTS TEMP_PROCEDIMIENTO_FECHA_CONTABLE_LITIGIO ( 
  `CONTRATO` DECIMAL(16,0) NULL,
  `FECHA_CONTABLE_LITIGIO` DATE NULL                    -- Fecha contable del litigio asociado al contrato
  ); 
  
  
  CREATE TABLE IF NOT EXISTS TEMP_PROCEDIMIENTO_TITULAR ( 
  `PROCEDIMIENTO` DECIMAL(16,0) NULL,
  `CONTRATO` DECIMAL(16,0) NULL,
  `TITULAR_PROCEDIMIENTO` DECIMAL(16,0) NULL            -- Primer titular del contrato de pase
  ); 
  
    
  CREATE TABLE IF NOT EXISTS TEMP_PROCEDIMIENTO_REFERENCIA ( 
  `CONTRATO` DECIMAL(16,0) NULL,
  `REFERENCIA_ASUNTO` VARCHAR(50) NULL                      
  );  

  CREATE TABLE IF NOT EXISTS TEMP_PROCEDIMIENTO_SEGMENTO ( 
  `CONTRATO` DECIMAL(16,0) NULL,
  `SEGMENTO` VARCHAR(50) NULL                      
  );  
  
  CREATE TABLE IF NOT EXISTS TEMP_PROCEDIMIENTO_SOCIO ( 
  `CONTRATO` DECIMAL(16,0) NULL,
  `SOCIO` VARCHAR(50) NULL                      
  );  
  
   CREATE TABLE IF NOT EXISTS TEMP_PROCEDIMIENTO_DEMANDADO ( 
  `PROCEDIMIENTO` DECIMAL(16,0) NULL,
  `CONTRATO` DECIMAL(16,0) NULL,
  `DEMANDADO` DECIMAL(16,0) NULL                        -- Demandado interviene como 1er o 2º Titular del contrato
  ); 
  

 CREATE TABLE IF NOT EXISTS TEMP_PROCEDIMIENTO_COBROS( 
  `FECHA_COBRO` DATE NULL,  
  `CONTRATO` DECIMAL(16,0) NULL,
  `IMPORTE` DECIMAL(15,2) NULL,
  `TIPO_COBRO_DETALLE_ID` DECIMAL(16,0) NULL
 );
  

 CREATE TABLE IF NOT EXISTS TEMP_PROCEDIMIENTO_ESTIMACION( 
  `ITER` DECIMAL(16,0) NULL,
  `FASE` DECIMAL(16,0) NULL,
  `FECHA_ESTIMACION` DATETIME NULL,  
  `IRG_CLAVE` varchar(20) NULL,
  `IRG_VALOR` varchar(255) NULL
 );
 
  CREATE TABLE IF NOT EXISTS TEMP_PROCEDIMIENTO_EXTRAS_RECOVERY_BI( 
  `FECHA_VALOR` DATE NULL,  
  `TIPO_ENTIDAD` DECIMAL(16,0) DEFAULT NULL,
  `UNIDAD_GESTION` DECIMAL(16,0) DEFAULT NULL,
  `DD_IFB_ID` DECIMAL(16,0) DEFAULT NULL,
  `VALOR` varchar(50) DEFAULT NULL
 );
 
 
 CREATE TABLE IF NOT EXISTS TEMP_PROCEDIMIENTO_USUARIOS( 
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NULL, 
  `GESTOR` DECIMAL(16,0) NULL,
  `SUPERVISOR` DECIMAL(16,0) NULL,
  `PROCURADOR` DECIMAL(16,0) NULL,
  `FECHA_DESDE` DATE NULL,
  `FECHA_VALIDA` DATE NULL
 );  
 
 CREATE TABLE IF NOT EXISTS TEMP_PROCEDIMIENTO_USUARIOS_AUX( 
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NULL, 
  `MAX_FECHA` DATE NULL
 );  
 
 
 CREATE TABLE IF NOT EXISTS TEMP_PROCEDIMIENTO_RESOLUCIONES( 
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NULL, 
  `BPM_IPT_ID` DECIMAL(16,0) NULL, 
  `FECHA_RESOLUCION` DATE NULL,  
  `FECHA_CREAR_INPUT` DATETIME NULL, 
  `USUARIO_CREAR` VARCHAR(20) NULL,
  `GESTOR_RESOLUCION` DECIMAL(16,0) NULL,
  `TIPO_RESOLUCION_ID` DECIMAL(16,0) NULL,
  `MAX_FECHA_RESOLUCION` DATETIME NULL,
  `MOTIVO_INADMISION_RESOLUCION_ID` VARCHAR(100) NULL,
  `MOTIVO_ARCHIVO_RESOLUCION_ID` VARCHAR(100) NULL,
  `REQUERIMIENTO_PREVIO_RESOLUCION_ID` VARCHAR(100) NULL,
  `MAX_FECHA_INADMISION` DATE NULL, 
  `MAX_FECHA_ARCHIVO` DATE NULL,
  `MAX_FECHA_REQUERIMIENTO_PREVIO` DATE NULL
 ); 
 
 
 CREATE TABLE IF NOT EXISTS TEMP_PROCEDIMIENTO_RESOLUCIONES_AUX( 
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NULL, 
  `MAX_FECHA` DATETIME NULL
 ); 

 CREATE TABLE IF NOT EXISTS TEMP_PROCEDIMIENTO_RESOLUCIONES_AUX2( 
  `PROCEDIMIENTO_ID` DECIMAL(16,0) NULL, 
  `MAX_FECHA_RESOLUCION` DATE NULL,
  `MAX_RESOLUCION_ID` DECIMAL(16,0) NULL,
  `TIPO_RESOLUCION_ID` DECIMAL(16,0) NULL
 ); 

 
END MY_BLOCK_H_PCR