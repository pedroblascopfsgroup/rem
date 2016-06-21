create or replace PROCEDURE CREAR_INDICES_DATASTAGE  (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Gonzalo Mart�n, PFS Group
-- Fecha creaci�n: Septiembre 2013
-- Responsable ultima modificacion: Maria Villanueva, PFS Group
-- Fecha �ltima modificaci�n: 01/12/2015
-- Motivos del cambio: usuario propietario
-- Cliente: Recovery BI Haya
--
-- Descripci�n: Procedimiento almancenado que crea �ndices en las tablas del datastage
-- ==============================================================================================
BEGIN
DECLARE
  V_NUM_ROW NUMBER(10);
  V_DATASTAGE VARCHAR2(100);
  O_ERROR_STATUS VARCHAR2(5000);
  V_NOMBRE VARCHAR2(50) := 'CREAR_INDICES_DATASTAGE';
  V_SQL varchar2(16000);
 
  HAY INT;
  HAY_TABLA INT;
-- --------------------------------------------------------------------------------
-- DEFINICI�N DE LOS HANDLER DE ERROR
-- --------------------------------------------------------------------------------
  OBJECTEXISTS EXCEPTION;
  INSERT_NULL EXCEPTION;
  PARAMETERS_NUMBER EXCEPTION;
  PRAGMA EXCEPTION_INIT(OBJECTEXISTS, -955);
  PRAGMA EXCEPTION_INIT(INSERT_NULL, -1400);
  PRAGMA EXCEPTION_INIT(PARAMETERS_NUMBER, -909);

BEGIN
-- -------------------------------------------- �NDICE -------------------------------------------
-- CPE_CONTRATOS_PERSONAS
-- CEX_CONTRATOS_EXPEDIENTE
-- CRE_PRC_CEX
-- PRC_PER
-- MOV_MOVIMIENTOS
-- H_MOV_MOVIMIENTOS
-- PRC_PROCEDIMIENTOS_JERARQUIA
-- PER_PERSONAS
-- CNT_CONTRATOS
-- PRC_CEX
-- PRC_PROCEDIMIENTOS
-- DD_TPO_TIPO_PROCEDIMIENTO
-- ASU_ASUNTOS
-- TAR_TAREAS_NOTIFICACIONES
-- TEX_TAREA_EXTERNA
-- TEV_TAREA_EXTERNA_VALOR
-- MEJ_REG_REGISTRO
-- MEJ_IRG_INFO_REGISTRO
-- USD_USUARIOS_DESPACHOS
-- GAA_GESTOR_ADICIONAL_ASUNTO
-- GAH_GESTOR_ADICIONAL_HISTORICO
-- USU_USUARIOS
-- EXT_IAC_INFO_ADD_CONTRATO
-- MOVIMIENTO_GALICIA
-- DPR_DECISIONES_PROCEDIMIENTOS
-- RCR_RECURSOS_PROCEDIMIENTOS
-- PVR_OPE_PROV_REC_OPERACION
-- CNT_DPS_CONTRATOS
-- PVR_LOAD_STATIC_DATA_CONTRATOS
-- PVR_LOAD_STATIC_DATA_CLIENTES
-- ACE_ACCIONES_EXTRAJUDICIALES
-- PRE_PREVISIONES
-- CARTERIZACION_ESPECIALIZADA
-- CAR_CARTERA
-- LOT_LOTE
-- DD_ENP_ENTIDADES_PROPIETARIAS
-- DD_ENC_ENTIDADES_CEDENTES
-- OFI_OFICINAS
-- CPA_COBROS_PAGOS
-- ITA_INPUTS_TAREAS
-- BPM_DIP_DATOS_INPUT
-- ACU_ACUERDOS_PROCEDIMIENTOS
-- LIN_LOTES_NUEVOS
-- BPM_IPT_INPUT
-- BPM_GVA_GRUPOS_VALORES
-- EXT_IAB_INFO_ADD_BI_H
-- EXT_IAB_INFO_ADD_BI
-- CRC_CICLO_RECOBRO_CNT
-- EXP_EXPEDIENTES
-- CRE_CICLO_RECOBRO_EXP
-- H_REC_FICHERO_CONTRATOS
-- ACU_ACUERDO_PROCEDIMIENTOS
-- ACC_ACUERDO_CONTRATO

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
select valor into V_DATASTAGE from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DATASTAGE'; 
-- ----------------------------------------------------------------------------------------------
--                                    CPE_CONTRATOS_PERSONAS
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES  WHERE TABLE_NAME = 'CPE_CONTRATOS_PERSONAS' AND INDEX_NAME = 'CPE_CONTRATO_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''CPE_CONTRATO_IX'', '''||V_DATASTAGE||'.CPE_CONTRATOS_PERSONAS (CNT_ID, PER_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE CPE_CONTRATO_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE CPE_CONTRATO_IX. N� ['||HAY||']';
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CPE_CONTRATOS_PERSONAS' AND INDEX_NAME = 'CPE_CONTRATO_PER_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''CPE_CONTRATO_PER_IX'', '''||V_DATASTAGE||'.CPE_CONTRATOS_PERSONAS (PER_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE CPE_CONTRATO_PER_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE CPE_CONTRATO_PER_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                    CEX_CONTRATOS_EXPEDIENTE
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CEX_CONTRATOS_EXPEDIENTE' AND INDEX_NAME = 'CEX_CONT_EXP_CNT_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''CEX_CONT_EXP_CNT_IX'', '''||V_DATASTAGE||'.CEX_CONTRATOS_EXPEDIENTE (CNT_ID, CEX_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE CEX_CONT_EXP_CNT_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE CEX_CONT_EXP_CNT_IX. N� ['||HAY||']';
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CEX_CONTRATOS_EXPEDIENTE' AND INDEX_NAME = 'CEX_CONT_EXP_EXP_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''CEX_CONT_EXP_EXP_IX'', '''||V_DATASTAGE||'.CEX_CONTRATOS_EXPEDIENTE (EXP_ID, CEX_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE CEX_CONT_EXP_EXP_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE CEX_CONT_EXP_EXP_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                    CRE_PRC_CEX
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CRE_PRC_CEX' AND INDEX_NAME = 'CRE_PRC_CEX_CEX_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''CRE_PRC_CEX_CEX_IX'', '''||V_DATASTAGE||'.CRE_PRC_CEX (CRE_PRC_CEX_CEXID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE CRE_PRC_CEX_CEX_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE CRE_PRC_CEX_CEX_IX. N� ['||HAY||']';
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CRE_PRC_CEX' AND INDEX_NAME = 'CRE_PRC_CEX_PRC_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''CRE_PRC_CEX_PRC_IX'', '''||V_DATASTAGE||'.CRE_PRC_CEX (CRE_PRC_CEX_PRCID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE CRE_PRC_CEX_PRC_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE CRE_PRC_CEX_PRC_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                    PRC_PER
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'PRC_PER' AND INDEX_NAME = 'PRC_PER_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''PRC_PER_IX'', '''||V_DATASTAGE||'.PRC_PER (PRC_ID, PER_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE PRC_PER_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE PRC_PER_IX. N� ['||HAY||']';
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'PRC_PER' AND INDEX_NAME = 'PRC_PER_PER_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''PRC_PER_PER_IX'', '''||V_DATASTAGE||'.PRC_PER (PER_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE PRC_PER_PER_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE PRC_PER_PER_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      MOV_MOVIMIENTOS
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'MOV_MOVIMIENTOS' AND INDEX_NAME = 'MOV_MOVIMIENTOS_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''MOV_MOVIMIENTOS_IX'', '''||V_DATASTAGE||'.MOV_MOVIMIENTOS (MOV_FECHA_EXTRACCION, CNT_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE MOV_MOVIMIENTOS_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE MOV_MOVIMIENTOS_IX. N� ['||HAY||']';
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'MOV_MOVIMIENTOS' AND INDEX_NAME = 'MOV_MOVIMIENTOS_MOV_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''MOV_MOVIMIENTOS_MOV_IX'', '''||V_DATASTAGE||'.MOV_MOVIMIENTOS (CNT_ID, MOV_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE MOV_MOVIMIENTOS_MOV_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE MOV_MOVIMIENTOS_MOV_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      H_MOV_MOVIMIENTOS
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'H_MOV_MOVIMIENTOS' AND INDEX_NAME = 'H_MOV_MOVIMIENTOS_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_MOV_MOVIMIENTOS_IX'', '''||V_DATASTAGE||'.H_MOV_MOVIMIENTOS (MOV_FECHA_EXTRACCION, CNT_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE H_MOV_MOVIMIENTOS_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE H_MOV_MOVIMIENTOS_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      PRC_PROCEDIMIENTOS_JERARQUIA
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'PRC_PROCEDIMIENTOS_JERARQUIA' AND INDEX_NAME = 'PRC_PROC_JERARQUIA_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''PRC_PROC_JERARQUIA_IX'', '''||V_DATASTAGE||'.PRC_PROCEDIMIENTOS_JERARQUIA (FECHA_PROCEDIMIENTO, PRC_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE PRC_PROC_JERARQUIA_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE PRC_PROC_JERARQUIA_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      PER_PERSONAS
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'PER_PERSONAS' AND INDEX_NAME = 'PER_PERSONAS_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''PER_PERSONAS_IX'', '''||V_DATASTAGE||'.PER_PERSONAS (PER_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE PER_PERSONAS_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE PER_PERSONAS_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      CNT_CONTRATOS
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CNT_CONTRATOS' AND INDEX_NAME = 'CNT_CONTRATOS_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''CNT_CONTRATOS_IX'', '''||V_DATASTAGE||'.CNT_CONTRATOS (CNT_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE CNT_CONTRATOS_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE CNT_CONTRATOS_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      PRC_CEX
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'PRC_CEX' AND INDEX_NAME = 'PRC_CEX_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''PRC_CEX_IX'', '''||V_DATASTAGE||'.PRC_CEX (CEX_ID, PRC_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE PRC_CEX_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE PRC_CEX_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      PRC_PROCEDIMIENTOS
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'PRC_PROCEDIMIENTOS' AND INDEX_NAME = 'PRC_PROCEDIMIENTOS_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''PRC_PROCEDIMIENTOS_IX'', '''||V_DATASTAGE||'.PRC_PROCEDIMIENTOS (PRC_ID, ASU_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE PRC_PROCEDIMIENTOS_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE PRC_PROCEDIMIENTOS_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      DD_TPO_TIPO_PROCEDIMIENTO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'DD_TPO_TIPO_PROCEDIMIENTO' AND INDEX_NAME = 'DD_TPO_TIPO_PROCEDIMIENTO_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''DD_TPO_TIPO_PROCEDIMIENTO_IX'', '''||V_DATASTAGE||'.DD_TPO_TIPO_PROCEDIMIENTO (DD_TPO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE DD_TPO_TIPO_PROCEDIMIENTO_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE DD_TPO_TIPO_PROCEDIMIENTO_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      ASU_ASUNTOS
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'ASU_ASUNTOS' AND INDEX_NAME = 'ASU_ASUNTOS_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''ASU_ASUNTOS_IX'', '''||V_DATASTAGE||'.ASU_ASUNTOS (ASU_ID, EXP_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE ASU_ASUNTOS_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE ASU_ASUNTOS_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      TAR_TAREAS_NOTIFICACIONES
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'TAR_TAREAS_NOTIFICACIONES' AND INDEX_NAME = 'TAR_TAREAS_NOTIFICACIONES_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TAR_TAREAS_NOTIFICACIONES_IX'', '''||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES (TAR_ID, PRC_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE TAR_TAREAS_NOTIFICACIONES_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE TAR_TAREAS_NOTIFICACIONES_IX. N� ['||HAY||']';
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'TAR_TAREAS_NOTIFICACIONES' AND INDEX_NAME = 'TAR_TAREAS_NOTIF_TIPO_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TAR_TAREAS_NOTIF_TIPO_IX'', '''||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES (TAR_ID, DD_STA_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE TAR_TAREAS_NOTIF_TIPO_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE TAR_TAREAS_NOTIF_TIPO_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      TEX_TAREA_EXTERNA
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'TEX_TAREA_EXTERNA' AND INDEX_NAME = 'TEX_TAREA_EXTERNAS_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TEX_TAREA_EXTERNAS_IX'', '''||V_DATASTAGE||'.TEX_TAREA_EXTERNA (TAR_ID, TEX_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE TEX_TAREA_EXTERNAS_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE TEX_TAREA_EXTERNAS_IX. N� ['||HAY||']';
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'TEX_TAREA_EXTERNA' AND INDEX_NAME = 'TEX_TAREA_EXTERNAS_TEX_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TEX_TAREA_EXTERNAS_TEX_IX'', '''||V_DATASTAGE||'.TEX_TAREA_EXTERNA (TEX_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE TEX_TAREA_EXTERNAS_TEX_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE TEX_TAREA_EXTERNAS_TEX_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      TEV_TAREA_EXTERNA_VALOR
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'TEV_TAREA_EXTERNA_VALOR' AND INDEX_NAME = 'TEV_TAREA_EXTERNA_VALOR_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TEV_TAREA_EXTERNA_VALOR_IX'', '''||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR (TEX_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE TEV_TAREA_EXTERNA_VALOR_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE TEV_TAREA_EXTERNA_VALOR_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      MEJ_REG_REGISTRO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'MEJ_REG_REGISTRO' AND INDEX_NAME = 'MEJ_REG_REGISTRO_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''MEJ_REG_REGISTRO_IX'', '''||V_DATASTAGE||'.MEJ_REG_REGISTRO (REG_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE MEJ_REG_REGISTRO_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE MEJ_REG_REGISTRO_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      MEJ_IRG_INFO_REGISTRO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'MEJ_IRG_INFO_REGISTRO' AND INDEX_NAME = 'MEJ_IRG_INFO_REGISTRO_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''MEJ_IRG_INFO_REGISTRO_IX'', '''||V_DATASTAGE||'.MEJ_IRG_INFO_REGISTRO (REG_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE MEJ_IRG_INFO_REGISTRO_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE MEJ_IRG_INFO_REGISTRO_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      USD_USUARIOS_DESPACHOS
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'USD_USUARIOS_DESPACHOS' AND INDEX_NAME = 'USD_USUARIOS_DESPACHOS_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''USD_USUARIOS_DESPACHOS_IX'', '''||V_DATASTAGE||'.USD_USUARIOS_DESPACHOS (USD_ID, USU_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE USD_USUARIOS_DESPACHOS_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE USD_USUARIOS_DESPACHOS_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      GAA_GESTOR_ADICIONAL_ASUNTO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'GAA_GESTOR_ADICIONAL_ASUNTO' AND INDEX_NAME = 'GAA_GESTOR_ADICIONAL_ASUNTO_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''GAA_GESTOR_ADICIONAL_ASUNTO_IX'', '''||V_DATASTAGE||'.GAA_GESTOR_ADICIONAL_ASUNTO (USD_ID, DD_TGE_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE GAA_GESTOR_ADICIONAL_ASUNTO_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE GAA_GESTOR_ADICIONAL_ASUNTO_IX. N� ['||HAY||']';
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'GAA_GESTOR_ADICIONAL_ASUNTO' AND INDEX_NAME = 'GAA_GEST_ADIC_ASUNTO_ASU_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''GAA_GEST_ADIC_ASUNTO_ASU_IX'', '''||V_DATASTAGE||'.GAA_GESTOR_ADICIONAL_ASUNTO (ASU_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE GAA_GEST_ADIC_ASUNTO_ASU_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE GAA_GEST_ADIC_ASUNTO_ASU_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      GAH_GESTOR_ADICIONAL_HISTORICO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'GAH_GESTOR_ADICIONAL_HISTORICO' AND INDEX_NAME = 'GAH_GESTOR_ADICIONAL_HIST_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''GAH_GESTOR_ADICIONAL_HIST_IX'', '''||V_DATASTAGE||'.GAH_GESTOR_ADICIONAL_HISTORICO (GAH_GESTOR_ID, GAH_TIPO_GESTOR_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE GAH_GESTOR_ADICIONAL_HIST_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE GAH_GESTOR_ADICIONAL_HIST_IX. N� ['||HAY||']';
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'GAH_GESTOR_ADICIONAL_HISTORICO' AND INDEX_NAME = 'GAH_GEST_ADICI_HIST_ASU_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''GAH_GEST_ADICI_HIST_ASU_IX'', '''||V_DATASTAGE||'.GAH_GESTOR_ADICIONAL_HISTORICO (GAH_ASU_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE GAH_GEST_ADICI_HIST_ASU_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE GAH_GEST_ADICI_HIST_ASU_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      USU_USUARIOS
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'USU_USUARIOS' AND INDEX_NAME = 'USU_USUARIOS_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''USU_USUARIOS_IX'', '''||V_DATASTAGE||'.USU_USUARIOS (USU_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE USU_USUARIOS_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE USU_USUARIOS_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      EXT_IAC_INFO_ADD_CONTRATO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'EXT_IAC_INFO_ADD_CONTRATO' AND INDEX_NAME = 'EXT_IAC_INFO_ADD_CONTRATO_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''EXT_IAC_INFO_ADD_CONTRATO_IX'', '''||V_DATASTAGE||'.EXT_IAC_INFO_ADD_CONTRATO (IAC_VALUE)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE EXT_IAC_INFO_ADD_CONTRATO_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE EXT_IAC_INFO_ADD_CONTRATO_IX. N� ['||HAY||']';
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'EXT_IAC_INFO_ADD_CONTRATO' AND INDEX_NAME = 'EXT_IAC_INFO_ADD_CONT_CNT_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''EXT_IAC_INFO_ADD_CONT_CNT_IX'', '''||V_DATASTAGE||'.EXT_IAC_INFO_ADD_CONTRATO (CNT_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE EXT_IAC_INFO_ADD_CONT_CNT_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE EXT_IAC_INFO_ADD_CONT_CNT_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      MOVIMIENTO_GALICIA
-- ----------------------------------------------------------------------------------------------
/*
  EXECUTE IMMEIDATE 'SELECT COUNT(TABLE_NAME) FROM USER_TABLES WHERE TABLE_NAME = ''MOVIMIENTO_GALICIA'' AND TABLESPACE_NAME='''||V_DATASTAGE||'''' INTO HAY_TABLA;
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'MOVIMIENTO_GALICIA' AND INDEX_NAME = 'MOVIMIENTO_GALICIA_IX';
  IF (HAY < 1 AND HAY_TABLA > 0) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''MOVIMIENTO_GALICIA_IX'', '''||V_DATASTAGE||'.MOVIMIENTO_GALICIA (NUM_CONTRATO)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE MOVIMIENTO_GALICIA_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE MOVIMIENTO_GALICIA_IX. N� ['||HAY||']';
  END IF;
*/

-- ----------------------------------------------------------------------------------------------
--                                      DPR_DECISIONES_PROCEDIMIENTOS
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'DPR_DECISIONES_PROCEDIMIENTOS' AND INDEX_NAME = 'DPR_DECISIONES_PROC_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''DPR_DECISIONES_PROC_IX'', '''||V_DATASTAGE||'.DPR_DECISIONES_PROCEDIMIENTOS (PRC_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE DPR_DECISIONES_PROC_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE DPR_DECISIONES_PROC_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      RCR_RECURSOS_PROCEDIMIENTOS
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'RCR_RECURSOS_PROCEDIMIENTOS' AND INDEX_NAME = 'RCR_RECURSOS_PROCEDIMIENTOS_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''RCR_RECURSOS_PROCEDIMIENTOS_IX'', '''||V_DATASTAGE||'.RCR_RECURSOS_PROCEDIMIENTOS (PRC_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE RCR_RECURSOS_PROCEDIMIENTOS_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE RCR_RECURSOS_PROCEDIMIENTOS_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      PVR_OPE_PROV_REC_OPERACION
-- ----------------------------------------------------------------------------------------------
/*
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'PVR_OPE_PROV_REC_OPERACION' AND INDEX_NAME = 'PVR_OPE_PROV_REC_OPER_IX';
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''PVR_OPE_PROV_REC_OPER_IX'', '''||V_DATASTAGE||'.PVR_OPE_PROV_REC_OPERACION (PVR_OPE_CNT_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE PVR_OPE_PROV_REC_OPER_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE PVR_OPE_PROV_REC_OPER_IX. N� ['||HAY||']';
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'PVR_OPE_PROV_REC_OPERACION' AND INDEX_NAME = 'PVR_OPE_PROV_REC_OPER_ALTA_IX';
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''PVR_OPE_PROV_REC_OPER_ALTA_IX'', '''||V_DATASTAGE||'.PVR_OPE_PROV_REC_OPERACION (PVR_OPE_FECHA_ALTA, PVR_OPE_CNT_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE PVR_OPE_PROV_REC_OPER_ALTA_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE PVR_OPE_PROV_REC_OPER_ALTA_IX. N� ['||HAY||']';
  END IF;
*/
-- ----------------------------------------------------------------------------------------------
--                                      CNT_DPS_CONTRATOS
-- ----------------------------------------------------------------------------------------------
  EXECUTE IMMEDIATE 'SELECT COUNT(TABLE_NAME) FROM USER_TABLES WHERE TABLE_NAME = ''CNT_DPS_CONTRATOS'' AND TABLESPACE_NAME='''||V_DATASTAGE||'''' INTO HAY_TABLA;
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CNT_DPS_CONTRATOS' AND INDEX_NAME = 'CNT_DPS_CONTRATOS_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY_TABLA > 1 AND HAY < 1) THEN
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''CNT_DPS_CONTRATOS_IX'', '''||V_DATASTAGE||'.CNT_DPS_CONTRATOS (FECHA_REGULARIZACION, CONTRATO)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
    O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE CNT_DPS_CONTRATOS_IX. N� ['||HAY||']';
  ELSE
    O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE CNT_DPS_CONTRATOS_IX o NO HAY TABLA. N� ['||HAY||']';
  END IF;

  EXECUTE IMMEDIATE 'SELECT COUNT(TABLE_NAME) FROM USER_TABLES WHERE TABLE_NAME = ''CNT_DPS_CONTRATOS'' AND TABLESPACE_NAME = '''||V_DATASTAGE||'''' INTO HAY_TABLA;
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CNT_DPS_CONTRATOS' AND INDEX_NAME = 'CNT_DPS_CONTRATOS_OPE_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY_TABLA > 1 AND HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''CNT_DPS_CONTRATOS_OPE_IX'', '''||V_DATASTAGE||'.CNT_DPS_CONTRATOS (PVR_OPE_ID_OPERACION)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE CNT_DPS_CONTRATOS_OPE_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE CNT_DPS_CONTRATOS_OPE_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      PVR_LOAD_STATIC_DATA_CONTRATOS
-- ----------------------------------------------------------------------------------------------
/*
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'PVR_LOAD_STATIC_DATA_CONTRATOS' AND INDEX_NAME = 'PVR_LOAD_STATIC_DATA_CONT_IX';
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''PVR_LOAD_STATIC_DATA_CONT_IX'', '''||V_DATASTAGE||'.PVR_LOAD_STATIC_DATA_CONTRATOS (PER_ID, CNT_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE PVR_LOAD_STATIC_DATA_CONT_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE PVR_LOAD_STATIC_DATA_CONT_IX. N� ['||HAY||']';
  END IF;
*/
-- ----------------------------------------------------------------------------------------------
--                                      PVR_LOAD_STATIC_DATA_CLIENTES
-- ----------------------------------------------------------------------------------------------
/*
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'PVR_LOAD_STATIC_DATA_CLIENTES' AND INDEX_NAME = 'PVR_LOAD_STATIC_DATA_CLI_IX';
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''PVR_LOAD_STATIC_DATA_CLI_IX'', '''||V_DATASTAGE||'.PVR_LOAD_STATIC_DATA_CLIENTES (PER_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE PVR_LOAD_STATIC_DATA_CLI_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE PVR_LOAD_STATIC_DATA_CLI_IX. N� ['||HAY||']';
  END IF;
*/

-- ----------------------------------------------------------------------------------------------
--                                      ACE_ACCIONES_EXTRAJUDICIALES
-- ----------------------------------------------------------------------------------------------
/*
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'ACE_ACCIONES_EXTRAJUDICIALES' AND INDEX_NAME = 'ACE_ACCIONES_EXTRAJUD_IX';
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''ACE_ACCIONES_EXTRAJUD_IX'', '''||V_DATASTAGE||'.ACE_ACCIONES_EXTRAJUDICIALES (PVR_OPE_ID_OPERACION)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE ACE_ACCIONES_EXTRAJUD_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE ACE_ACCIONES_EXTRAJUD_IX. N� ['||HAY||']';
  END IF;
*/
-- ----------------------------------------------------------------------------------------------
--                                      PRE_PREVISIONES
-- ----------------------------------------------------------------------------------------------
  EXECUTE IMMEDIATE 'SELECT COUNT(TABLE_NAME) FROM USER_TABLES WHERE TABLE_NAME = ''PRE_PREVISIONES'' AND TABLESPACE_NAME = '''||V_DATASTAGE||'''' INTO HAY_TABLA;
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'PRE_PREVISIONES' AND INDEX_NAME = 'PRE_PREVISIONES_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1 AND HAY_TABLA > 0) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''PRE_PREVISIONES_IX'', '''||V_DATASTAGE||'.PRE_PREVISIONES (CNT_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE PRE_PREVISIONES_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE PRE_PREVISIONES_IX. N� ['||HAY||']';
  END IF;

  EXECUTE IMMEDIATE 'SELECT COUNT(TABLE_NAME) FROM USER_TABLES WHERE TABLE_NAME = ''PRE_PREVISIONES'' AND TABLESPACE_NAME = '''||V_DATASTAGE||'''' INTO HAY_TABLA ;
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'PRE_PREVISIONES' AND INDEX_NAME = 'PRE_PREVISIONES_FECHA_PREVISION_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1 AND HAY_TABLA > 0) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''PRE_PREVISIONES_FECHA_PREVISION_IX'', '''||V_DATASTAGE||'.PRE_PREVISIONES (PRE_FECHA_PREVISION)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE PRE_PREVISIONES_FECHA_PREVISION_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE PRE_PREVISIONES_FECHA_PREVISION_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      CARTERIZACION_ESPECIALIZADA
-- ----------------------------------------------------------------------------------------------
  EXECUTE IMMEDIATE 'SELECT COUNT(TABLE_NAME) FROM USER_TABLES WHERE TABLE_NAME = ''CARTERIZACION_ESPECIALIZADA'' AND TABLESPACE_NAME = '''||V_DATASTAGE||'''' INTO HAY_TABLA ;
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CARTERIZACION_ESPECIALIZADA' AND INDEX_NAME = 'CARTERIZACION_ESPECIALIZADA_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1 AND HAY_TABLA > 0) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''CARTERIZACION_ESPECIALIZADA_IX'', '''||V_DATASTAGE||'.CARTERIZACION_ESPECIALIZADA (CNT_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE CARTERIZACION_ESPECIALIZADA_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE CARTERIZACION_ESPECIALIZADA_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      CAR_CARTERA
-- ----------------------------------------------------------------------------------------------
/*
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CAR_CARTERA' AND INDEX_NAME = 'CAR_CARTERA_IX';
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''CAR_CARTERA_IX'', '''||V_DATASTAGE||'.CAR_CARTERA (CAR_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE CAR_CARTERA_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE CAR_CARTERA_IX. N� ['||HAY||']';
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CAR_CARTERA' AND INDEX_NAME = 'CAR_CARTERA_DESCRIPCION_IX';
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''CAR_CARTERA_DESCRIPCION_IX'', '''||V_DATASTAGE||'.CAR_CARTERA (CAR_DESCRIPCION)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE CAR_CARTERA_DESCRIPCION_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE CAR_CARTERA_DESCRIPCION_IX. N� ['||HAY||']';
  END IF;
*/
-- ----------------------------------------------------------------------------------------------
--                                      LOT_LOTE
-- ----------------------------------------------------------------------------------------------
/*
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'LOT_LOTE' AND INDEX_NAME = 'LOT_LOTE_IX';
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''LOT_LOTE_IX'', '''||V_DATASTAGE||'.LOT_LOTE (LOT_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE LOT_LOTE_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE LOT_LOTE_IX. N� ['||HAY||']';
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'LOT_LOTE' AND INDEX_NAME = 'LOT_LOTE_CARTERA_IX';
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''LOT_LOTE_CARTERA_IX'', '''||V_DATASTAGE||'.LOT_LOTE (CAR_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE LOT_LOTE_CARTERA_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE LOT_LOTE_CARTERA_IX. N� ['||HAY||']';
  END IF;
*/
-- ----------------------------------------------------------------------------------------------
--                                      DD_ENP_ENTIDADES_PROPIETARIAS
-- ----------------------------------------------------------------------------------------------
/*
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'DD_ENP_ENTIDADES_PROPIETARIAS' AND INDEX_NAME = 'DD_ENP_ENTIDADES_PROP_IX';
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''DD_ENP_ENTIDADES_PROP_IX'', '''||V_DATASTAGE||'.DD_ENP_ENTIDADES_PROPIETARIAS (DD_ENP_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE DD_ENP_ENTIDADES_PROP_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE DD_ENP_ENTIDADES_PROP_IX. N� ['||HAY||']';
  END IF;
*/
-- ----------------------------------------------------------------------------------------------
--                                      DD_ENC_ENTIDADES_CEDENTES
-- ----------------------------------------------------------------------------------------------
/*
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'DD_ENC_ENTIDADES_CEDENTES' AND INDEX_NAME = 'DD_ENC_ENTIDADES_CEDENTES_IX';
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''DD_ENC_ENTIDADES_CEDENTES_IX'', '''||V_DATASTAGE||'.DD_ENC_ENTIDADES_CEDENTES (DD_ENC_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE DD_ENC_ENTIDADES_CEDENTES_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE DD_ENC_ENTIDADES_CEDENTES_IX. N� ['||HAY||']';
  END IF;
*/
-- ----------------------------------------------------------------------------------------------
--                                      OFI_OFICINAS
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'OFI_OFICINAS' AND INDEX_NAME = 'OFI_OFICINAS_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''OFI_OFICINAS_IX'', '''||V_DATASTAGE||'.OFI_OFICINAS (OFI_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE OFI_OFICINAS_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE OFI_OFICINAS_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      CPA_COBROS_PAGOS
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CPA_COBROS_PAGOS' AND INDEX_NAME = 'CPA_COBROS_PAGOS_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''CPA_COBROS_PAGOS_IX'', '''||V_DATASTAGE||'.CPA_COBROS_PAGOS (CPA_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE CPA_COBROS_PAGOS_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE CPA_COBROS_PAGOS_IX. N� ['||HAY||']';
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CPA_COBROS_PAGOS' AND INDEX_NAME = 'CPA_COBROS_PAGOS_FECHA_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''CPA_COBROS_PAGOS_FECHA_IX'', '''||V_DATASTAGE||'.CPA_COBROS_PAGOS (CPA_FECHA)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE CPA_COBROS_PAGOS_FECHA_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE CPA_COBROS_PAGOS_FECHA_IX. N� ['||HAY||']';
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CPA_COBROS_PAGOS' AND INDEX_NAME = 'CPA_COBROS_PAGOS_CNT_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''CPA_COBROS_PAGOS_CNT_IX'', '''||V_DATASTAGE||'.CPA_COBROS_PAGOS (CNT_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE CPA_COBROS_PAGOS_CNT_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE CPA_COBROS_PAGOS_CNT_IX. N� ['||HAY||']';
  END IF;
  
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CPA_COBROS_PAGOS' AND INDEX_NAME = 'CPA_COBROS_PAGOS_CODIGO_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''CPA_COBROS_PAGOS_CODIGO_IX'', '''||V_DATASTAGE||'.CPA_COBROS_PAGOS (CPA_CODIGO_COBRO)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE CPA_COBROS_PAGOS_CODIGO_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE CPA_COBROS_PAGOS_CODIGO_IX. N� ['||HAY||']';
  END IF;
  

-- ----------------------------------------------------------------------------------------------
--                                      ITA_INPUTS_TAREAS
-- ----------------------------------------------------------------------------------------------
/*
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'ITA_INPUTS_TAREAS' AND INDEX_NAME = 'ITA_INPUTS_TAREAS_BPM_IPT_IX';
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''ITA_INPUTS_TAREAS_BPM_IPT_IX'', '''||V_DATASTAGE||'.ITA_INPUTS_TAREAS (BPM_IPT_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE ITA_INPUTS_TAREAS_BPM_IPT_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE ITA_INPUTS_TAREAS_BPM_IPT_IX. N� ['||HAY||']';
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'ITA_INPUTS_TAREAS' AND INDEX_NAME = 'ITA_INPUTS_TAREAS_TEX_IX';
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''ITA_INPUTS_TAREAS_TEX_IX'', '''||V_DATASTAGE||'.ITA_INPUTS_TAREAS (TEX_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE ITA_INPUTS_TAREAS_TEX_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE ITA_INPUTS_TAREAS_TEX_IX. N� ['||HAY||']';
  END IF;
*/
-- ----------------------------------------------------------------------------------------------
--                                      BPM_DIP_DATOS_INPUT
-- ----------------------------------------------------------------------------------------------
/*
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'BPM_DIP_DATOS_INPUT' AND INDEX_NAME = 'BPM_DIP_DATOS_INPUT_BPM_IPT_IX';
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''BPM_DIP_DATOS_INPUT_BPM_IPT_IX'', '''||V_DATASTAGE||'.BPM_DIP_DATOS_INPUT (BPM_IPT_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE BPM_DIP_DATOS_INPUT_BPM_IPT_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE BPM_DIP_DATOS_INPUT_BPM_IPT_IX. N� ['||HAY||']';
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'BPM_DIP_DATOS_INPUT' AND INDEX_NAME = 'BPM_DIP_DATOS_INPUT_DIP_NOMBRE_IX';
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''BPM_DIP_DATOS_INPUT_DIP_NOMBRE_IX'', '''||V_DATASTAGE||'.BPM_DIP_DATOS_INPUT (BPM_DIP_NOMBRE)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE BPM_DIP_DATOS_INPUT_DIP_NOMBRE_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE BPM_DIP_DATOS_INPUT_DIP_NOMBRE_IX. N� ['||HAY||']';
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'BPM_DIP_DATOS_INPUT' AND INDEX_NAME = 'BPM_DIP_DATOS_INPUT_DIP_VALOR_IX';
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''BPM_DIP_DATOS_INPUT_DIP_VALOR_IX'', '''||V_DATASTAGE||'.BPM_DIP_DATOS_INPUT (BPM_DIP_VALOR)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE BPM_DIP_DATOS_INPUT_DIP_VALOR_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE BPM_DIP_DATOS_INPUT_DIP_VALOR_IX. N� ['||HAY||']';
  END IF;
*/
-- ----------------------------------------------------------------------------------------------
--                                      ACU_ACUERDOS_PROCEDIMIENTOS
-- ----------------------------------------------------------------------------------------------
  EXECUTE IMMEDIATE 'SELECT COUNT(TABLE_NAME) FROM USER_TABLES WHERE TABLE_NAME = ''ACU_ACUERDOS_PROCEDIMIENTOS'' AND TABLESPACE_NAME = '''||V_DATASTAGE||'''' INTO HAY_TABLA;
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'ACU_ACUERDOS_PROCEDIMIENTOS' AND INDEX_NAME = 'ACU_ACUERDOS_PROCEDIMIENTOS_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1 AND HAY_TABLA > 0) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''ACU_ACUERDOS_PROCEDIMIENTOS_IX'', '''||V_DATASTAGE||'.ACU_ACUERDOS_PROCEDIMIENTOS (ACU_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE ACU_ACUERDOS_PROCEDIMIENTOS_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE ACU_ACUERDOS_PROCEDIMIENTOS_IX. N� ['||HAY||']';
  END IF;

  EXECUTE IMMEDIATE 'SELECT COUNT(TABLE_NAME) FROM USER_TABLES WHERE TABLE_NAME = ''ACU_ACUERDOS_PROCEDIMIENTOS'' AND TABLESPACE_NAME = '''||V_DATASTAGE||'''' INTO HAY_TABLA;
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'ACU_ACUERDOS_PROCEDIMIENTOS' AND INDEX_NAME = 'ACU_ACUERDOS_PROCEDIMIENTOS_ASUNTO_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1 AND HAY_TABLA > 0) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''ACU_ACUERDOS_PROCEDIMIENTOS_ASUNTO_IX'', '''||V_DATASTAGE||'.ACU_ACUERDOS_PROCEDIMIENTOS (ASU_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE ACU_ACUERDOS_PROCEDIMIENTOS_ASUNTO_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE ACU_ACUERDOS_PROCEDIMIENTOS_ASUNTO_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      LIN_LOTES_NUEVOS
-- ----------------------------------------------------------------------------------------------
/*
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'LIN_LOTES_NUEVOS' AND INDEX_NAME = 'LIN_LOTES_NUEVOS_NUM_CASO_IX';
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''LIN_LOTES_NUEVOS_NUM_CASO_IX'', '''||V_DATASTAGE||'.LIN_LOTES_NUEVOS (N_CASO)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE LIN_LOTES_NUEVOS_NUM_CASO_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE LIN_LOTES_NUEVOS_NUM_CASO_IX. N� ['||HAY||']';
  END IF;
*/
-- ----------------------------------------------------------------------------------------------
--                                      BPM_IPT_INPUT
-- ----------------------------------------------------------------------------------------------
/*
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'BPM_IPT_INPUT' AND INDEX_NAME = 'BPM_IPT_INPUT_IX';
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''BPM_IPT_INPUT_IX'', '''||V_DATASTAGE||'.BPM_IPT_INPUT (PRC_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE BPM_IPT_INPUT_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE BPM_IPT_INPUT_IX. N� ['||HAY||']';
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'BPM_IPT_INPUT' AND INDEX_NAME = 'BPM_IPT_INPUT_ID_IX';
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''BPM_IPT_INPUT_ID_IX'', '''||V_DATASTAGE||'.BPM_IPT_INPUT (BPM_IPT_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE BPM_IPT_INPUT_ID_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE BPM_IPT_INPUT_ID_IX. N� ['||HAY||']';
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'BPM_IPT_INPUT' AND INDEX_NAME = 'BPM_IPT_INPUT_USUARIOCREAR_IX';
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''BPM_IPT_INPUT_USUARIOCREAR_IX'', '''||V_DATASTAGE||'.BPM_IPT_INPUT (FECHACREAR, USUARIOCREAR)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE BPM_IPT_INPUT_USUARIOCREAR_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE BPM_IPT_INPUT_USUARIOCREAR_IX. N� ['||HAY||']';
  END IF;
*/
-- ----------------------------------------------------------------------------------------------
--                                      BPM_GVA_GRUPOS_VALORES
-- ----------------------------------------------------------------------------------------------
/*
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'BPM_GVA_GRUPOS_VALORES' AND INDEX_NAME = 'BPM_GVA_GRUPOS_VALORES_IX';
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''BPM_GVA_GRUPOS_VALORES_IX'', '''||V_DATASTAGE||'.BPM_GVA_GRUPOS_VALORES (PRC_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE BPM_GVA_GRUPOS_VALORES_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE BPM_GVA_GRUPOS_VALORES_IX. N� ['||HAY||']';
  END IF;
*/
-- ----------------------------------------------------------------------------------------------
--                                      EXT_IAB_INFO_ADD_BI_H
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'EXT_IAB_INFO_ADD_BI_H' AND INDEX_NAME = 'EXT_IAB_INFO_ADD_BI_H_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''EXT_IAB_INFO_ADD_BI_H_IX'', '''||V_DATASTAGE||'.EXT_IAB_INFO_ADD_BI_H (IAB_FECHA_VALOR, IAB_ID_UNIDAD_GESTION)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE EXT_IAB_INFO_ADD_BI_H_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE EXT_IAB_INFO_ADD_BI_H_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      EXT_IAB_INFO_ADD_BI
-- ----------------------------------------------------------------------------------------------
/*
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'EXT_IAB_INFO_ADD_BI' AND INDEX_NAME = 'EXT_IAB_INFO_ADD_BI_IX';
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''EXT_IAB_INFO_ADD_BI_IX'', '''||V_DATASTAGE||'.EXT_IAB_INFO_ADD_BI (IAB_FECHA_VALOR, IAB_ID_UNIDAD_GESTION)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE EXT_IAB_INFO_ADD_BI_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE EXT_IAB_INFO_ADD_BI_IX. N� ['||HAY||']';
  END IF;

  O_ERROR_STATUS:= O_ERROR_STATUS_E;
*/


-- ----------------------------------------------------------------------------------------------
--                                      CRC_CICLO_RECOBRO_CNT
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CRC_CICLO_RECOBRO_CNT' AND INDEX_NAME = 'CRC_CICLO_RECOBRO_CNT_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''CRC_CICLO_RECOBRO_CNT_IX'', '''||V_DATASTAGE||'.CRC_CICLO_RECOBRO_CNT (CNT_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE CRC_CICLO_RECOBRO_CNT_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE CRC_CICLO_RECOBRO_CNT_IX. N� ['||HAY||']';
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CRC_CICLO_RECOBRO_CNT' AND INDEX_NAME = 'CRC_CICLO_RECOBRO_CNT_CRE_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''CRC_CICLO_RECOBRO_CNT_CRE_IX'', '''||V_DATASTAGE||'.CRC_CICLO_RECOBRO_CNT (CRE_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE CRC_CICLO_RECOBRO_CNT_CRE_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE CRC_CICLO_RECOBRO_CNT_CRE_IX. N� ['||HAY||']';
  END IF;
  
-- ----------------------------------------------------------------------------------------------
--                                      EXP_EXPEDIENTES
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'EXP_EXPEDIENTES' AND INDEX_NAME = 'EXP_EXPEDIENTES_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''EXP_EXPEDIENTES_IX'', '''||V_DATASTAGE||'.EXP_EXPEDIENTES (EXP_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE EXP_EXPEDIENTES_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE EXP_EXPEDIENTES_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      CRE_CICLO_RECOBRO_EXP
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CRE_CICLO_RECOBRO_EXP' AND INDEX_NAME = 'CRE_CICLO_RECOBRO_EXP_EXP_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''CRE_CICLO_RECOBRO_EXP_EXP_IX'', '''||V_DATASTAGE||'.CRE_CICLO_RECOBRO_EXP (EXP_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE CRE_CICLO_RECOBRO_EXP_EXP_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE CRE_CICLO_RECOBRO_EXP_EXP_IX. N� ['||HAY||']';
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CRE_CICLO_RECOBRO_EXP' AND INDEX_NAME = 'CRE_CICLO_RECOBRO_EXP_CRE_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''CRE_CICLO_RECOBRO_EXP_CRE_IX'', '''||V_DATASTAGE||'.CRE_CICLO_RECOBRO_EXP (CRE_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE CRE_CICLO_RECOBRO_EXP_CRE_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE CRE_CICLO_RECOBRO_EXP_CRE_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      H_REC_FICHERO_CONTRATOS
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'H_REC_FICHERO_CONTRATOS' AND INDEX_NAME = 'H_REC_FICHERO_CONTRATOS_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_REC_FICHERO_CONTRATOS_IX'', '''||V_DATASTAGE||'.H_REC_FICHERO_CONTRATOS (TRUNC(FECHA_HIST))'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE H_REC_FICHERO_CONTRATOS_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE H_REC_FICHERO_CONTRATOS_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      ACU_ACUERDO_PROCEDIMIENTOS
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'ACU_ACUERDO_PROCEDIMIENTOS' AND INDEX_NAME = 'ACU_ACUERDO_PROCEDIMIENTOS_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''ACU_ACUERDO_PROCEDIMIENTOS_IX'', '''||V_DATASTAGE||'.ACU_ACUERDO_PROCEDIMIENTOS (ACU_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE ACU_ACUERDO_PROCEDIMIENTOS_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE ACU_ACUERDO_PROCEDIMIENTOS_IX. N� ['||HAY||']';
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      ACC_ACUERDO_CONTRATO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'ACC_ACUERDO_CONTRATO' AND INDEX_NAME = 'ACC_ACUERDO_CONTRATO_IX' AND TABLESPACE_NAME = UPPER(V_DATASTAGE);
  IF (HAY < 1) THEN
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''ACC_ACUERDO_CONTRATO_IX'', '''||V_DATASTAGE||'.ACC_ACUERDO_CONTRATO (ACU_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE ACC_ACUERDO_CONTRATO_IX. N� ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE ACC_ACUERDO_CONTRATO_IX. N� ['||HAY||']';
  END IF;


/*
EXCEPTION
  WHEN OBJECTEXISTS THEN
    O_ERROR_STATUS := 'La tabla ya existe';
    --ROLLBACK;
  WHEN INSERT_NULL THEN
    O_ERROR_STATUS := 'Has intentado insertar un valor nulo';
    --ROLLBACK;
  WHEN PARAMETERS_NUMBER THEN
    O_ERROR_STATUS := 'N�mero de par�metros incorrecto';
    --ROLLBACK;
  WHEN OTHERS THEN
    O_ERROR_STATUS := 'Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM;
    --ROLLBACK;
    */

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;
    
END;
END CREAR_INDICES_DATASTAGE;
