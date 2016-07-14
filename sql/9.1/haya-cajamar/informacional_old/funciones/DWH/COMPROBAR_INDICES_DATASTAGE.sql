create or replace FUNCTION COMPROBAR_INDICES_DATASTAGE 
RETURN NUMBER
-- ===============================================================================================
-- Autor: Diego Pérez, PFS Group
-- Fecha creación: Marzo  2015
-- Responsable ultima modificacion: 
-- Fecha última modificación:
-- Motivos del cambio:
-- Cliente: Haya
--
-- Descripción: Función que comprueba los índices. Devuelve 0 si todo OK, o por lo contrario el nº del último índice que no existe
-- ==============================================================================================
IS
  V_NUM_ROW NUMBER(10);
  V_DATASTAGE VARCHAR(25) := 'recovery_haya02_datastage';
  O_ERROR_STATUS VARCHAR2(5000);
  V_NOMBRE VARCHAR2(50) := 'COMPROBAR_INDICES_DATASTAGE';

  HAY INT;
  HAY_TABLA INT;
  NUM_INDICE INT := 0;  
-- --------------------------------------------------------------------------------
-- DEFINICIÓN DE LOS HANDLER DE ERROR
-- --------------------------------------------------------------------------------
  OBJECTEXISTS EXCEPTION;
  INSERT_NULL EXCEPTION;
  PARAMETERS_NUMBER EXCEPTION;
  PRAGMA EXCEPTION_INIT(OBJECTEXISTS, -955);
  PRAGMA EXCEPTION_INIT(INSERT_NULL, -1400);
  PRAGMA EXCEPTION_INIT(PARAMETERS_NUMBER, -909);

BEGIN
-- -------------------------------------------- ÍNDICE -------------------------------------------
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


-- ----------------------------------------------------------------------------------------------
--                                    CPE_CONTRATOS_PERSONAS
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES  WHERE TABLE_NAME = 'CPE_CONTRATOS_PERSONAS' AND INDEX_NAME = 'CPE_CONTRATO_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 1;
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CPE_CONTRATOS_PERSONAS' AND INDEX_NAME = 'CPE_CONTRATO_PER_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 2;
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                    CEX_CONTRATOS_EXPEDIENTE
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CEX_CONTRATOS_EXPEDIENTE' AND INDEX_NAME = 'CEX_CONT_EXP_CNT_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 3;
  END IF;


  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CEX_CONTRATOS_EXPEDIENTE' AND INDEX_NAME = 'CEX_CONT_EXP_EXP_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 4;
  END IF;


-- ----------------------------------------------------------------------------------------------
--                                    CRE_PRC_CEX
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CRE_PRC_CEX' AND INDEX_NAME = 'CRE_PRC_CEX_CEX_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 5;
  END IF;


  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CRE_PRC_CEX' AND INDEX_NAME = 'CRE_PRC_CEX_PRC_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 6;
  END IF;


-- ----------------------------------------------------------------------------------------------
--                                    PRC_PER
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'PRC_PER' AND INDEX_NAME = 'PRC_PER_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 7;
  END IF;


  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'PRC_PER' AND INDEX_NAME = 'PRC_PER_PER_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 8;
  END IF;


-- ----------------------------------------------------------------------------------------------
--                                      MOV_MOVIMIENTOS
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'MOV_MOVIMIENTOS' AND INDEX_NAME = 'MOV_MOVIMIENTOS_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 9;
  END IF;


  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'MOV_MOVIMIENTOS' AND INDEX_NAME = 'MOV_MOVIMIENTOS_MOV_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 10;
  END IF;


-- ----------------------------------------------------------------------------------------------
--                                      H_MOV_MOVIMIENTOS
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'H_MOV_MOVIMIENTOS' AND INDEX_NAME = 'H_MOV_MOVIMIENTOS_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 11;
  END IF;


-- ----------------------------------------------------------------------------------------------
--                                      PRC_PROCEDIMIENTOS_JERARQUIA
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'PRC_PROCEDIMIENTOS_JERARQUIA' AND INDEX_NAME = 'PRC_PROC_JERARQUIA_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 12;
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      PER_PERSONAS
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'PER_PERSONAS' AND INDEX_NAME = 'PER_PERSONAS_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 13;
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      CNT_CONTRATOS
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CNT_CONTRATOS' AND INDEX_NAME = 'CNT_CONTRATOS_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 14;
  END IF;


-- ----------------------------------------------------------------------------------------------
--                                      PRC_CEX
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'PRC_CEX' AND INDEX_NAME = 'PRC_CEX_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 15;
  END IF;


-- ----------------------------------------------------------------------------------------------
--                                      PRC_PROCEDIMIENTOS
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'PRC_PROCEDIMIENTOS' AND INDEX_NAME = 'PRC_PROCEDIMIENTOS_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 16;
  END IF;


-- ----------------------------------------------------------------------------------------------
--                                      DD_TPO_TIPO_PROCEDIMIENTO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'DD_TPO_TIPO_PROCEDIMIENTO' AND INDEX_NAME = 'DD_TPO_TIPO_PROCEDIMIENTO_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 17;
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      ASU_ASUNTOS
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'ASU_ASUNTOS' AND INDEX_NAME = 'ASU_ASUNTOS_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 18;
  END IF;


-- ----------------------------------------------------------------------------------------------
--                                      TAR_TAREAS_NOTIFICACIONES
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'TAR_TAREAS_NOTIFICACIONES' AND INDEX_NAME = 'TAR_TAREAS_NOTIFICACIONES_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 19;
  END IF;


  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'TAR_TAREAS_NOTIFICACIONES' AND INDEX_NAME = 'TAR_TAREAS_NOTIF_TIPO_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 20;
  END IF;


-- ----------------------------------------------------------------------------------------------
--                                      TEX_TAREA_EXTERNA
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'TEX_TAREA_EXTERNA' AND INDEX_NAME = 'TEX_TAREA_EXTERNAS_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 21;
  END IF;


  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'TEX_TAREA_EXTERNA' AND INDEX_NAME = 'TEX_TAREA_EXTERNAS_TEX_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 22;
  END IF;


-- ----------------------------------------------------------------------------------------------
--                                      TEV_TAREA_EXTERNA_VALOR
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'TEV_TAREA_EXTERNA_VALOR' AND INDEX_NAME = 'TEV_TAREA_EXTERNA_VALOR_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 23;
  END IF;


-- ----------------------------------------------------------------------------------------------
--                                      MEJ_REG_REGISTRO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'MEJ_REG_REGISTRO' AND INDEX_NAME = 'MEJ_REG_REGISTRO_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 24;
  END IF;


-- ----------------------------------------------------------------------------------------------
--                                      MEJ_IRG_INFO_REGISTRO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'MEJ_IRG_INFO_REGISTRO' AND INDEX_NAME = 'MEJ_IRG_INFO_REGISTRO_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 25;
  END IF;


-- ----------------------------------------------------------------------------------------------
--                                      USD_USUARIOS_DESPACHOS
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'USD_USUARIOS_DESPACHOS' AND INDEX_NAME = 'USD_USUARIOS_DESPACHOS_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 26;
  END IF;


-- ----------------------------------------------------------------------------------------------
--                                      GAA_GESTOR_ADICIONAL_ASUNTO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'GAA_GESTOR_ADICIONAL_ASUNTO' AND INDEX_NAME = 'GAA_GESTOR_ADICIONAL_ASUNTO_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 27;
  END IF;


  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'GAA_GESTOR_ADICIONAL_ASUNTO' AND INDEX_NAME = 'GAA_GEST_ADIC_ASUNTO_ASU_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 28;
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      GAH_GESTOR_ADICIONAL_HISTORICO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'GAH_GESTOR_ADICIONAL_HISTORICO' AND INDEX_NAME = 'GAH_GESTOR_ADICIONAL_HIST_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 29;
  END IF;


  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'GAH_GESTOR_ADICIONAL_HISTORICO' AND INDEX_NAME = 'GAH_GEST_ADICI_HIST_ASU_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 30;
  END IF;


-- ----------------------------------------------------------------------------------------------
--                                      USU_USUARIOS
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'USU_USUARIOS' AND INDEX_NAME = 'USU_USUARIOS_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 31;
  END IF;


-- ----------------------------------------------------------------------------------------------
--                                      EXT_IAC_INFO_ADD_CONTRATO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'EXT_IAC_INFO_ADD_CONTRATO' AND INDEX_NAME = 'EXT_IAC_INFO_ADD_CONTRATO_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 32;
  END IF;


  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'EXT_IAC_INFO_ADD_CONTRATO' AND INDEX_NAME = 'EXT_IAC_INFO_ADD_CONT_CNT_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 33;
  END IF;


-- ----------------------------------------------------------------------------------------------
--                                      MOVIMIENTO_GALICIA
-- ----------------------------------------------------------------------------------------------
/*
  EXECUTE IMMEIDATE 'SELECT COUNT(TABLE_NAME) FROM USER_TABLES WHERE TABLE_NAME = ''MOVIMIENTO_GALICIA'' AND TABLESPACE_NAME='''||V_DATASTAGE||'''' INTO HAY_TABLA;
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'MOVIMIENTO_GALICIA' AND INDEX_NAME = 'MOVIMIENTO_GALICIA_IX';
  IF (HAY < 1 AND HAY_TABLA > 0) THEN
      EXECUTE IMMEDIATE 'CREATE INDEX MOVIMIENTO_GALICIA_IX ON '||V_DATASTAGE||'.MOVIMIENTO_GALICIA (NUM_CONTRATO)';
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE MOVIMIENTO_GALICIA_IX. Nº ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE MOVIMIENTO_GALICIA_IX. Nº ['||HAY||']';
  END IF;
*/

-- ----------------------------------------------------------------------------------------------
--                                      DPR_DECISIONES_PROCEDIMIENTOS
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'DPR_DECISIONES_PROCEDIMIENTOS' AND INDEX_NAME = 'DPR_DECISIONES_PROC_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 34;
  END IF;


-- ----------------------------------------------------------------------------------------------
--                                      RCR_RECURSOS_PROCEDIMIENTOS
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'RCR_RECURSOS_PROCEDIMIENTOS' AND INDEX_NAME = 'RCR_RECURSOS_PROCEDIMIENTOS_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 35;
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      PVR_OPE_PROV_REC_OPERACION
-- ----------------------------------------------------------------------------------------------
/*
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'PVR_OPE_PROV_REC_OPERACION' AND INDEX_NAME = 'PVR_OPE_PROV_REC_OPER_IX';
  IF (HAY < 1) THEN
      EXECUTE IMMEDIATE 'CREATE INDEX PVR_OPE_PROV_REC_OPER_IX ON '||V_DATASTAGE||'.PVR_OPE_PROV_REC_OPERACION (PVR_OPE_CNT_ID)';
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE PVR_OPE_PROV_REC_OPER_IX. Nº ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE PVR_OPE_PROV_REC_OPER_IX. Nº ['||HAY||']';
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'PVR_OPE_PROV_REC_OPERACION' AND INDEX_NAME = 'PVR_OPE_PROV_REC_OPER_ALTA_IX';
  IF (HAY < 1) THEN
      EXECUTE IMMEDIATE 'CREATE INDEX PVR_OPE_PROV_REC_OPER_ALTA_IX ON '||V_DATASTAGE||'.PVR_OPE_PROV_REC_OPERACION (PVR_OPE_FECHA_ALTA, PVR_OPE_CNT_ID)';
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE PVR_OPE_PROV_REC_OPER_ALTA_IX. Nº ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE PVR_OPE_PROV_REC_OPER_ALTA_IX. Nº ['||HAY||']';
  END IF;
*/
-- ----------------------------------------------------------------------------------------------
--                                      CNT_DPS_CONTRATOS
-- ----------------------------------------------------------------------------------------------
  EXECUTE IMMEDIATE 'SELECT COUNT(TABLE_NAME) FROM USER_TABLES WHERE TABLE_NAME = ''CNT_DPS_CONTRATOS'' AND TABLESPACE_NAME='''||V_DATASTAGE||'''' INTO HAY_TABLA;
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CNT_DPS_CONTRATOS' AND INDEX_NAME = 'CNT_DPS_CONTRATOS_IX';
  IF (HAY = 0) AND (HAY_TABLA = 1) THEN
    NUM_INDICE := 36;
  END IF;


  EXECUTE IMMEDIATE 'SELECT COUNT(TABLE_NAME) FROM USER_TABLES WHERE TABLE_NAME = ''CNT_DPS_CONTRATOS'' AND TABLESPACE_NAME = '''||V_DATASTAGE||'''' INTO HAY_TABLA;
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CNT_DPS_CONTRATOS' AND INDEX_NAME = 'CNT_DPS_CONTRATOS_OPE_IX';
  IF (HAY = 0) AND (HAY_TABLA = 1) THEN
    NUM_INDICE := 37;
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      PVR_LOAD_STATIC_DATA_CONTRATOS
-- ----------------------------------------------------------------------------------------------
/*
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'PVR_LOAD_STATIC_DATA_CONTRATOS' AND INDEX_NAME = 'PVR_LOAD_STATIC_DATA_CONT_IX';
  IF (HAY < 1) THEN
      EXECUTE IMMEDIATE 'CREATE INDEX PVR_LOAD_STATIC_DATA_CONT_IX ON '||V_DATASTAGE||'.PVR_LOAD_STATIC_DATA_CONTRATOS (PER_ID, CNT_ID)';
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE PVR_LOAD_STATIC_DATA_CONT_IX. Nº ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE PVR_LOAD_STATIC_DATA_CONT_IX. Nº ['||HAY||']';
  END IF;
*/
-- ----------------------------------------------------------------------------------------------
--                                      PVR_LOAD_STATIC_DATA_CLIENTES
-- ----------------------------------------------------------------------------------------------
/*
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'PVR_LOAD_STATIC_DATA_CLIENTES' AND INDEX_NAME = 'PVR_LOAD_STATIC_DATA_CLI_IX';
  IF (HAY < 1) THEN
      EXECUTE IMMEDIATE 'CREATE INDEX PVR_LOAD_STATIC_DATA_CLI_IX ON '||V_DATASTAGE||'.PVR_LOAD_STATIC_DATA_CLIENTES (PER_ID)';
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE PVR_LOAD_STATIC_DATA_CLI_IX. Nº ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE PVR_LOAD_STATIC_DATA_CLI_IX. Nº ['||HAY||']';
  END IF;
*/

-- ----------------------------------------------------------------------------------------------
--                                      ACE_ACCIONES_EXTRAJUDICIALES
-- ----------------------------------------------------------------------------------------------
/*
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'ACE_ACCIONES_EXTRAJUDICIALES' AND INDEX_NAME = 'ACE_ACCIONES_EXTRAJUD_IX';
  IF (HAY < 1) THEN
      EXECUTE IMMEDIATE 'CREATE INDEX ACE_ACCIONES_EXTRAJUD_IX ON '||V_DATASTAGE||'.ACE_ACCIONES_EXTRAJUDICIALES (PVR_OPE_ID_OPERACION)';
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE ACE_ACCIONES_EXTRAJUD_IX. Nº ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE ACE_ACCIONES_EXTRAJUD_IX. Nº ['||HAY||']';
  END IF;
*/
-- ----------------------------------------------------------------------------------------------
--                                      PRE_PREVISIONES
-- ----------------------------------------------------------------------------------------------
  EXECUTE IMMEDIATE 'SELECT COUNT(TABLE_NAME) FROM USER_TABLES WHERE TABLE_NAME = ''PRE_PREVISIONES'' AND TABLESPACE_NAME = '''||V_DATASTAGE||'''' INTO HAY_TABLA;
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'PRE_PREVISIONES' AND INDEX_NAME = 'PRE_PREVISIONES_IX';
  IF (HAY = 0) AND (HAY_TABLA = 1) THEN
    NUM_INDICE := 38;
  END IF;


  EXECUTE IMMEDIATE 'SELECT COUNT(TABLE_NAME) FROM USER_TABLES WHERE TABLE_NAME = ''PRE_PREVISIONES'' AND TABLESPACE_NAME = '''||V_DATASTAGE||'''' INTO HAY_TABLA ;
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'PRE_PREVISIONES' AND INDEX_NAME = 'PRE_PREVISIONES_FECHA_PREVISION_IX';
  IF (HAY = 0) AND (HAY_TABLA = 1) THEN
    NUM_INDICE := 39;
  END IF;


-- ----------------------------------------------------------------------------------------------
--                                      CARTERIZACION_ESPECIALIZADA
-- ----------------------------------------------------------------------------------------------
  EXECUTE IMMEDIATE 'SELECT COUNT(TABLE_NAME) FROM USER_TABLES WHERE TABLE_NAME = ''CARTERIZACION_ESPECIALIZADA'' AND TABLESPACE_NAME = '''||V_DATASTAGE||'''' INTO HAY_TABLA ;
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CARTERIZACION_ESPECIALIZADA' AND INDEX_NAME = 'CARTERIZACION_ESPECIALIZADA_IX';
  IF (HAY = 0) AND (HAY_TABLA = 1) THEN
    NUM_INDICE := 40;
  END IF;


-- ----------------------------------------------------------------------------------------------
--                                      CAR_CARTERA
-- ----------------------------------------------------------------------------------------------
/*
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CAR_CARTERA' AND INDEX_NAME = 'CAR_CARTERA_IX';
  IF (HAY < 1) THEN
      EXECUTE IMMEDIATE 'CREATE INDEX CAR_CARTERA_IX ON '||V_DATASTAGE||'.CAR_CARTERA (CAR_ID)';
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE CAR_CARTERA_IX. Nº ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE CAR_CARTERA_IX. Nº ['||HAY||']';
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CAR_CARTERA' AND INDEX_NAME = 'CAR_CARTERA_DESCRIPCION_IX';
  IF (HAY < 1) THEN
      EXECUTE IMMEDIATE 'CREATE INDEX CAR_CARTERA_DESCRIPCION_IX ON '||V_DATASTAGE||'.CAR_CARTERA (CAR_DESCRIPCION)';
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE CAR_CARTERA_DESCRIPCION_IX. Nº ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE CAR_CARTERA_DESCRIPCION_IX. Nº ['||HAY||']';
  END IF;
*/
-- ----------------------------------------------------------------------------------------------
--                                      LOT_LOTE
-- ----------------------------------------------------------------------------------------------
/*
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'LOT_LOTE' AND INDEX_NAME = 'LOT_LOTE_IX';
  IF (HAY < 1) THEN
      EXECUTE IMMEDIATE 'CREATE INDEX LOT_LOTE_IX ON '||V_DATASTAGE||'.LOT_LOTE (LOT_ID)';
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE LOT_LOTE_IX. Nº ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE LOT_LOTE_IX. Nº ['||HAY||']';
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'LOT_LOTE' AND INDEX_NAME = 'LOT_LOTE_CARTERA_IX';
  IF (HAY < 1) THEN
      EXECUTE IMMEDIATE 'CREATE INDEX LOT_LOTE_CARTERA_IX ON '||V_DATASTAGE||'.LOT_LOTE (CAR_ID)';
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE LOT_LOTE_CARTERA_IX. Nº ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE LOT_LOTE_CARTERA_IX. Nº ['||HAY||']';
  END IF;
*/
-- ----------------------------------------------------------------------------------------------
--                                      DD_ENP_ENTIDADES_PROPIETARIAS
-- ----------------------------------------------------------------------------------------------
/*
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'DD_ENP_ENTIDADES_PROPIETARIAS' AND INDEX_NAME = 'DD_ENP_ENTIDADES_PROP_IX';
  IF (HAY < 1) THEN
      EXECUTE IMMEDIATE 'CREATE INDEX DD_ENP_ENTIDADES_PROP_IX ON '||V_DATASTAGE||'.DD_ENP_ENTIDADES_PROPIETARIAS (DD_ENP_ID)';
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE DD_ENP_ENTIDADES_PROP_IX. Nº ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE DD_ENP_ENTIDADES_PROP_IX. Nº ['||HAY||']';
  END IF;
*/
-- ----------------------------------------------------------------------------------------------
--                                      DD_ENC_ENTIDADES_CEDENTES
-- ----------------------------------------------------------------------------------------------
/*
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'DD_ENC_ENTIDADES_CEDENTES' AND INDEX_NAME = 'DD_ENC_ENTIDADES_CEDENTES_IX';
  IF (HAY < 1) THEN
      EXECUTE IMMEDIATE 'CREATE INDEX DD_ENC_ENTIDADES_CEDENTES_IX ON '||V_DATASTAGE||'.DD_ENC_ENTIDADES_CEDENTES (DD_ENC_ID)';
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE DD_ENC_ENTIDADES_CEDENTES_IX. Nº ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE DD_ENC_ENTIDADES_CEDENTES_IX. Nº ['||HAY||']';
  END IF;
*/
-- ----------------------------------------------------------------------------------------------
--                                      OFI_OFICINAS
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'OFI_OFICINAS' AND INDEX_NAME = 'OFI_OFICINAS_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 41;
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      CPA_COBROS_PAGOS
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CPA_COBROS_PAGOS' AND INDEX_NAME = 'CPA_COBROS_PAGOS_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 42;
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CPA_COBROS_PAGOS' AND INDEX_NAME = 'CPA_COBROS_PAGOS_FECHA_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 43;
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CPA_COBROS_PAGOS' AND INDEX_NAME = 'CPA_COBROS_PAGOS_CNT_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 44;
  END IF;
  
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CPA_COBROS_PAGOS' AND INDEX_NAME = 'CPA_COBROS_PAGOS_CODIGO_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 45;
  END IF;
  

-- ----------------------------------------------------------------------------------------------
--                                      ITA_INPUTS_TAREAS
-- ----------------------------------------------------------------------------------------------
/*
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'ITA_INPUTS_TAREAS' AND INDEX_NAME = 'ITA_INPUTS_TAREAS_BPM_IPT_IX';
  IF (HAY < 1) THEN
      EXECUTE IMMEDIATE 'CREATE INDEX ITA_INPUTS_TAREAS_BPM_IPT_IX ON '||V_DATASTAGE||'.ITA_INPUTS_TAREAS (BPM_IPT_ID)';
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE ITA_INPUTS_TAREAS_BPM_IPT_IX. Nº ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE ITA_INPUTS_TAREAS_BPM_IPT_IX. Nº ['||HAY||']';
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'ITA_INPUTS_TAREAS' AND INDEX_NAME = 'ITA_INPUTS_TAREAS_TEX_IX';
  IF (HAY < 1) THEN
      EXECUTE IMMEDIATE 'CREATE INDEX ITA_INPUTS_TAREAS_TEX_IX ON '||V_DATASTAGE||'.ITA_INPUTS_TAREAS (TEX_ID)';
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE ITA_INPUTS_TAREAS_TEX_IX. Nº ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE ITA_INPUTS_TAREAS_TEX_IX. Nº ['||HAY||']';
  END IF;
*/
-- ----------------------------------------------------------------------------------------------
--                                      BPM_DIP_DATOS_INPUT
-- ----------------------------------------------------------------------------------------------
/*
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'BPM_DIP_DATOS_INPUT' AND INDEX_NAME = 'BPM_DIP_DATOS_INPUT_BPM_IPT_IX';
  IF (HAY < 1) THEN
      EXECUTE IMMEDIATE 'CREATE INDEX BPM_DIP_DATOS_INPUT_BPM_IPT_IX ON '||V_DATASTAGE||'.BPM_DIP_DATOS_INPUT (BPM_IPT_ID)';
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE BPM_DIP_DATOS_INPUT_BPM_IPT_IX. Nº ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE BPM_DIP_DATOS_INPUT_BPM_IPT_IX. Nº ['||HAY||']';
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'BPM_DIP_DATOS_INPUT' AND INDEX_NAME = 'BPM_DIP_DATOS_INPUT_DIP_NOMBRE_IX';
  IF (HAY < 1) THEN
      EXECUTE IMMEDIATE 'CREATE INDEX BPM_DIP_DATOS_INPUT_DIP_NOMBRE_IX ON '||V_DATASTAGE||'.BPM_DIP_DATOS_INPUT (BPM_DIP_NOMBRE)';
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE BPM_DIP_DATOS_INPUT_DIP_NOMBRE_IX. Nº ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE BPM_DIP_DATOS_INPUT_DIP_NOMBRE_IX. Nº ['||HAY||']';
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'BPM_DIP_DATOS_INPUT' AND INDEX_NAME = 'BPM_DIP_DATOS_INPUT_DIP_VALOR_IX';
  IF (HAY < 1) THEN
      EXECUTE IMMEDIATE 'CREATE INDEX BPM_DIP_DATOS_INPUT_DIP_VALOR_IX ON '||V_DATASTAGE||'.BPM_DIP_DATOS_INPUT (BPM_DIP_VALOR)';
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE BPM_DIP_DATOS_INPUT_DIP_VALOR_IX. Nº ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE BPM_DIP_DATOS_INPUT_DIP_VALOR_IX. Nº ['||HAY||']';
  END IF;
*/
-- ----------------------------------------------------------------------------------------------
--                                      ACU_ACUERDOS_PROCEDIMIENTOS
-- ----------------------------------------------------------------------------------------------
  EXECUTE IMMEDIATE 'SELECT COUNT(TABLE_NAME) FROM USER_TABLES WHERE TABLE_NAME = ''ACU_ACUERDOS_PROCEDIMIENTOS'' AND TABLESPACE_NAME = '''||V_DATASTAGE||'''' INTO HAY_TABLA;
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'ACU_ACUERDOS_PROCEDIMIENTOS' AND INDEX_NAME = 'ACU_ACUERDOS_PROCEDIMIENTOS_IX';
  IF (HAY = 0) AND (HAY_TABLA = 1) THEN
    NUM_INDICE := 46;
  END IF;

  EXECUTE IMMEDIATE 'SELECT COUNT(TABLE_NAME) FROM USER_TABLES WHERE TABLE_NAME = ''ACU_ACUERDOS_PROCEDIMIENTOS'' AND TABLESPACE_NAME = '''||V_DATASTAGE||'''' INTO HAY_TABLA;
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'ACU_ACUERDOS_PROCEDIMIENTOS' AND INDEX_NAME = 'ACU_ACUERDOS_PROCEDIMIENTOS_ASUNTO_IX';
  IF (HAY = 0) AND (HAY_TABLA = 1) THEN
    NUM_INDICE := 47;
  END IF;
-- ----------------------------------------------------------------------------------------------
--                                      LIN_LOTES_NUEVOS
-- ----------------------------------------------------------------------------------------------
/*
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'LIN_LOTES_NUEVOS' AND INDEX_NAME = 'LIN_LOTES_NUEVOS_NUM_CASO_IX';
  IF (HAY < 1) THEN
      EXECUTE IMMEDIATE 'CREATE INDEX LIN_LOTES_NUEVOS_NUM_CASO_IX ON '||V_DATASTAGE||'.LIN_LOTES_NUEVOS (N_CASO)';
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE LIN_LOTES_NUEVOS_NUM_CASO_IX. Nº ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE LIN_LOTES_NUEVOS_NUM_CASO_IX. Nº ['||HAY||']';
  END IF;
*/
-- ----------------------------------------------------------------------------------------------
--                                      BPM_IPT_INPUT
-- ----------------------------------------------------------------------------------------------
/*
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'BPM_IPT_INPUT' AND INDEX_NAME = 'BPM_IPT_INPUT_IX';
  IF (HAY < 1) THEN
      EXECUTE IMMEDIATE 'CREATE INDEX BPM_IPT_INPUT_IX ON '||V_DATASTAGE||'.BPM_IPT_INPUT (PRC_ID)';
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE BPM_IPT_INPUT_IX. Nº ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE BPM_IPT_INPUT_IX. Nº ['||HAY||']';
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'BPM_IPT_INPUT' AND INDEX_NAME = 'BPM_IPT_INPUT_ID_IX';
  IF (HAY < 1) THEN
      EXECUTE IMMEDIATE 'CREATE INDEX BPM_IPT_INPUT_ID_IX ON '||V_DATASTAGE||'.BPM_IPT_INPUT (BPM_IPT_ID)';
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE BPM_IPT_INPUT_ID_IX. Nº ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE BPM_IPT_INPUT_ID_IX. Nº ['||HAY||']';
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'BPM_IPT_INPUT' AND INDEX_NAME = 'BPM_IPT_INPUT_USUARIOCREAR_IX';
  IF (HAY < 1) THEN
      EXECUTE IMMEDIATE 'CREATE INDEX BPM_IPT_INPUT_USUARIOCREAR_IX ON '||V_DATASTAGE||'.BPM_IPT_INPUT (FECHACREAR, USUARIOCREAR)';
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE BPM_IPT_INPUT_USUARIOCREAR_IX. Nº ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE BPM_IPT_INPUT_USUARIOCREAR_IX. Nº ['||HAY||']';
  END IF;
*/
-- ----------------------------------------------------------------------------------------------
--                                      BPM_GVA_GRUPOS_VALORES
-- ----------------------------------------------------------------------------------------------
/*
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'BPM_GVA_GRUPOS_VALORES' AND INDEX_NAME = 'BPM_GVA_GRUPOS_VALORES_IX';
  IF (HAY < 1) THEN
      EXECUTE IMMEDIATE 'CREATE INDEX BPM_GVA_GRUPOS_VALORES_IX ON '||V_DATASTAGE||'.BPM_GVA_GRUPOS_VALORES (PRC_ID)';
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE BPM_GVA_GRUPOS_VALORES_IX. Nº ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE BPM_GVA_GRUPOS_VALORES_IX. Nº ['||HAY||']';
  END IF;
*/
-- ----------------------------------------------------------------------------------------------
--                                      EXT_IAB_INFO_ADD_BI_H
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'EXT_IAB_INFO_ADD_BI_H' AND INDEX_NAME = 'EXT_IAB_INFO_ADD_BI_H_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 48;
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      EXT_IAB_INFO_ADD_BI
-- ----------------------------------------------------------------------------------------------
/*
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'EXT_IAB_INFO_ADD_BI' AND INDEX_NAME = 'EXT_IAB_INFO_ADD_BI_IX';
  IF (HAY < 1) THEN
      EXECUTE IMMEDIATE 'CREATE INDEX EXT_IAB_INFO_ADD_BI_IX ON '||V_DATASTAGE||'.EXT_IAB_INFO_ADD_BI (IAB_FECHA_VALOR, IAB_ID_UNIDAD_GESTION)';
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Se ha insertado el INDICE EXT_IAB_INFO_ADD_BI_IX. Nº ['||HAY||']';
  ELSE
      O_ERROR_STATUS:= O_ERROR_STATUS||CHR(13)||CHR(10)||'Ya existe el INDICE EXT_IAB_INFO_ADD_BI_IX. Nº ['||HAY||']';
  END IF;

  O_ERROR_STATUS:= O_ERROR_STATUS_E;
*/


-- ----------------------------------------------------------------------------------------------
--                                      CRC_CICLO_RECOBRO_CNT
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CRC_CICLO_RECOBRO_CNT' AND INDEX_NAME = 'CRC_CICLO_RECOBRO_CNT_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 49;
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CRC_CICLO_RECOBRO_CNT' AND INDEX_NAME = 'CRC_CICLO_RECOBRO_CNT_CRE_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 50;
  END IF;
  
-- ----------------------------------------------------------------------------------------------
--                                      EXP_EXPEDIENTES
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'EXP_EXPEDIENTES' AND INDEX_NAME = 'EXP_EXPEDIENTES_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 51;
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      CRE_CICLO_RECOBRO_EXP
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CRE_CICLO_RECOBRO_EXP' AND INDEX_NAME = 'CRE_CICLO_RECOBRO_EXP_EXP_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 52;
  END IF;

  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'CRE_CICLO_RECOBRO_EXP' AND INDEX_NAME = 'CRE_CICLO_RECOBRO_EXP_CRE_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 53;
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      H_REC_FICHERO_CONTRATOS
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'H_REC_FICHERO_CONTRATOS' AND INDEX_NAME = 'H_REC_FICHERO_CONTRATOS_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 54;
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      ACU_ACUERDO_PROCEDIMIENTOS
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'ACU_ACUERDO_PROCEDIMIENTOS' AND INDEX_NAME = 'ACU_ACUERDO_PROCEDIMIENTOS_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 55;
  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      ACC_ACUERDO_CONTRATO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES WHERE TABLE_NAME = 'ACC_ACUERDO_CONTRATO' AND INDEX_NAME = 'ACC_ACUERDO_CONTRATO_IX';
  IF (HAY = 0) THEN
    NUM_INDICE := 56;
  END IF;




    
    RETURN(NUM_INDICE);
END;