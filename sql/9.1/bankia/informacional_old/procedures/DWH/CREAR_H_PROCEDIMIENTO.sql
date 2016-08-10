create or replace PROCEDURE CREAR_H_PROCEDIMIENTO (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Gonzalo Martin, PFS Group
-- Fecha creacion: Mayo 2014
-- Responsable ultima modificacion: María Villanueva, PFS Group
-- Fecha última modificación: 01/02/2016
-- Motivos del cambio: Fase finalizada Y TMP_PRC_ITER_JERARQUIA
-- Cliente: Recovery BI Bankia
--
-- Descripcion: Procedimiento almancenado que crea las tablas del Hecho Procedimiento
-- ===============================================================================================

-- -------------------------------------------- INDICE -------------------------------------------
-- HECHO PROCEDIMIENTO
    -- H_PRC
    -- TMP_H_PRC
    -- H_PRC_SEMANA
    -- H_PRC_MES
    -- H_PRC_TRIMESTRE
    -- H_PRC_ANIO
    -- H_PRC_DET_COBRO
    -- H_PRC_DET_COBRO_MES
    -- H_PRC_DET_COBRO_TRIMESTRE
    -- H_PRC_DET_COBRO_ANIO
    -- H_PRC_DET_CONTRATO
    -- TMP_H_PRC_DET_CONTRATO
    -- H_PRC_DET_CONTRATO_MES
    -- H_PRC_DET_CONTRATO_TRIMESTRE
    -- H_PRC_DET_CONTRATO_ANIO
    -- TMP_PRC_CODIGO_PRIORIDAD
    -- TMP_PRC_JERARQUIA
    --TMP_PRC_ITER_JERARQUIA


    -- TMP_PRC_DETALLE
    -- TMP_PRC_TAREA
    -- TMP_PRC_AUTO_PRORROGAS
    -- TMP_PRC_CONTRATO
    -- TMP_PRC_CONCURSO_CONTRATO
    -- TMP_PRC_CARTERA
    -- TMP_PRC_FECHA_CONTABLE_LITIGIO
    -- TMP_PRC_TITULAR
    -- TMP_PRC_DEMANDADO
    -- TMP_PRC_COBROS
    -- TMP_PRC_ESTIMACION
    -- TMP_PRC_EXTRAS_RECOVERY_BI
    -- TMP_PRC_DECISION
    -- TMP_H_PRC_DET_COBRO
    -- H_PRC_DET_COBRO_SEMANA

    -- H_PRC_DET_ACUERDO
    -- H_PRC_DET_ACUERDO_SEMANA
    -- H_PRC_DET_ACUERDO_MES
    -- H_PRC_DET_ACUERDO_TRIMESTRE
    -- H_PRC_DET_ACUERDO_ANIO
    -- TMP_H_PRC_DET_ACUERDO
    

BEGIN
  declare
  nCount NUMBER;
  V_SQL VARCHAR2(16000);
  V_NOMBRE VARCHAR2(50) := 'CREAR_H_PROCEDIMIENTO';

  begin

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;

    ------------------------------ H_PRC --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRC'', 
                          ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              FASE_MAX_PRIORIDAD NUMBER(16,0),
                              FASE_ANTERIOR NUMBER(16,0),
                              FASE_ACTUAL NUMBER(16,0),
                              ULT_TAR_CREADA NUMBER(16,0),
                              ULT_TAR_FIN NUMBER(16,0),
                              ULTIMA_TAREA_ACTUALIZADA NUMBER(16,0),
                              ULT_TAR_PEND NUMBER(16,0),
                              FECHA_CREACION_ASUNTO DATE ,
                              FECHA_CONTABLE_LITIGIO DATE,
                              FECHA_CREACION_PROCEDIMIENTO DATE,
                              FECHA_CREACION_FASE_MAX_PRIO DATE,
                              FECHA_CREACION_FASE_ANTERIOR DATE,
                              FECHA_CREACION_FASE_ACTUAL DATE,
                              FECHA_ULT_TAR_CREADA DATE,
                              FECHA_ULT_TAR_FIN DATE,
                              FECHA_ULTIMA_TAREA_ACTUALIZADA DATE,
                              FECHA_ULT_TAR_PEND DATE,
                              FECHA_VENC_ORIG_ULT_TAR_FIN DATE,
                              FECHA_VENC_ACT_ULT_TAR_FIN DATE,
                              FECHA_VENC_ORIG_ULT_TAR_PEND DATE,
                              FECHA_VENC_ACT_ULT_TAR_PEND DATE,
                              FECHA_ACEPTACION DATE,
                              FECHA_RECOGIDA_DOC_Y_ACEPT DATE,
                              FECHA_REGISTRAR_TOMA_DECISION DATE,
                              FECHA_RECEPCION_DOC_COMPLETA DATE,
                              FECHA_INTERPOSICION_DEMANDA DATE,
                              FECHA_ULTIMA_POSICION_VENCIDA DATE,
                              FECHA_ULTIMA_ESTIMACION DATE,
                              FECHA_ESTIMADA_COBRO DATE,
                              FECHA_PARALIZACION DATE,
                              CONTEXTO_FASE VARCHAR2(250),
                              NIVEL INTEGER,

                              -- Dimensiones
                              ASUNTO_ID NUMBER(16,0),
                              TIPO_PROCEDIMIENTO_DET_ID NUMBER(16,0),
                              FASE_ACTUAL_DETALLE_ID NUMBER(16,0),
                              FASE_ANTERIOR_DETALLE_ID NUMBER(16,0),
                              ULT_TAR_CREADA_TIPO_DET_ID NUMBER(16,0),
                              ULT_TAR_CREADA_DESC_ID NUMBER(16,0),
                              ULT_TAR_FIN_TIPO_DET_ID NUMBER(16,0),
                              ULT_TAR_FIN_DESC_ID NUMBER(16,0),
                              ULT_TAR_ACT_TIPO_DET_ID NUMBER(16,0),
                              ULT_TAR_ACT_DESC_ID NUMBER(16,0),
                              ULT_TAR_PEND_TIPO_DET_ID NUMBER(16,0),
                              ULT_TAR_PEND_DESC_ID NUMBER(16,0),
                              CUMPLIMIENTO_ULT_TAR_FIN_ID NUMBER(16,0),
                              CUMPLIMIENTO_ULT_TAR_PEND_ID NUMBER(16,0),
                              ESTADO_PROCEDIMIENTO_ID NUMBER(16,0),
                              ESTADO_FASE_ACTUAL_ID NUMBER(16,0),
                              ESTADO_FASE_ANTERIOR_ID NUMBER(16,0),
                              T_SALDO_TOTAL_PRC_ID NUMBER(16,0),
                              T_SALDO_RECUPERACION_PRC_ID NUMBER(16,0),
                              T_SALDO_TOTAL_CONCURSO_ID NUMBER(16,0),
                              TD_ULT_ACTUALIZACION_PRC_ID NUMBER(16,0),
                              TD_CONTRATO_VENCIDO_ID NUMBER(16,0),
                              TD_CNT_VENC_CREACION_ASU_ID NUMBER(16,0),
                              TD_CREA_ASU_A_INTERP_DEM_ID NUMBER(16,0),
                              TD_CREACION_ASU_ACEPT_ID NUMBER(16,0),
                              TD_ACEPT_ASU_INTERP_DEM_ID NUMBER(16,0),
                              TD_CREA_ASU_REC_DOC_ACEP_ID NUMBER(16,0),
                              TD_REC_DOC_ACEPT_REG_TD_ID NUMBER(16,0),
                              TD_REC_DOC_ACEPT_REC_DC_ID NUMBER(16,0),
                              CNT_GARANTIA_REAL_ASOC_ID NUMBER(16,0),
                              ACT_ESTIMACIONES_ID NUMBER(16,0),
                              CARTERA_PROCEDIMIENTO_ID NUMBER(16,0),
                              TITULAR_PROCEDIMIENTO_ID NUMBER(16,0),
                              PRC_PARALIZADO_ID NUMBER(16,0),
                              MOTIVO_PARALIZACION_ID  NUMBER(16,0),
                              -- Metricas
                              NUM_PROCEDIMIENTOS INTEGER,
                              NUM_CONTRATOS INTEGER,
                              NUM_FASES INTEGER,
                              NUM_DIAS_ULT_ACTUALIZACION INTEGER,
                              NUM_MAX_DIAS_CONTRATO_VENCIDO INTEGER,
                              NUM_MAX_DIAS_CNT_VENC_CREA_ASU INTEGER,
                              PORCENTAJE_RECUPERACION INTEGER,
                              P_RECUPERACION INTEGER,
                              SALDO_RECUPERACION NUMBER(14,2),
                              ESTIMACION_RECUPERACION NUMBER(14,2),
                              SALDO_ORIGINAL_VENCIDO NUMBER(14,2),
                              SALDO_ORIGINAL_NO_VENCIDO NUMBER(14,2),
                              SALDO_ACTUAL_VENCIDO NUMBER(14,2),
                              SALDO_ACTUAL_NO_VENCIDO NUMBER(14,2),
                              SALDO_ACTUAL_TOTAL NUMBER(14,2),
                              SALDO_CONCURSOS_VENCIDO NUMBER(14,2),
                              SALDO_CONCURSOS_NO_VENCIDO NUMBER(14,2),
                              SALDO_CONCURSOS_TOTAL NUMBER(14,2),
                              INGRESOS_PENDIENTES_APLICAR NUMBER(14,2),
                              SUBTOTAL NUMBER(14,2),
                              DURACION_ULT_TAREA_FINALIZADA INTEGER,
                              NUM_DIAS_EXCED_ULT_TAR_FIN INTEGER,
                              NUM_DIAS_VENC_ULT_TAR_FIN INTEGER,
                              NUM_DIAS_PRORROG_ULT_TAR_FIN INTEGER,
                              NUM_PRORROG_ULT_TAR_FIN INTEGER,
                              DURACION_ULT_TAREA_PENDIENTE INTEGER,
                              NUM_DIAS_EXCEDIDO_ULT_TAR_PEND INTEGER,
                              NUM_DIAS_VENC_ULT_TAR_PEND INTEGER,
                              NUM_DIAS_PRORROG_ULT_TAR_PEND INTEGER,
                              NUM_PRORROG_ULT_TAR_PEND INTEGER,
                              P_CREA_ASU_A_INTERP_DEM INTEGER,
                              P_CREACION_ASU_ACEP INTEGER,
                              P_ACEPT_ASU_INTERP_DEM INTEGER,
                              P_CREA_ASU_REC_DOC_ACEP INTEGER,
                              P_REC_DOC_ACEP_REG_TD INTEGER,
                              P_REC_DOC_ACEP_RECEP_DC INTEGER,
                              NUM_DIAS_DESDE_ULT_ESTIMACION INTEGER,
							  FECHA_CANCELACION_ASUNTO date,
                              PRC_PARALIZADO_ID NUMBER(16,0) ,
                              FECHA_PARALIZACION DATE,
                              MOTIVO_PARALIZACION_ID  NUMBER(16,0) ,
                              FASE_ACTUAL_AGR_ID NUMBER(16,0), 
                              PRC_FINALIZADO_ID NUMBER(16,0) ,
                              FECHA_FINALIZACION DATE,
                              MOTIVO_FINALIZACION_ID  NUMBER(16,0)  
                             )SEGMENT CREATION IMMEDIATE 


                          TABLESPACE "RECOVERY_BANKIA_DWH" 
                          PARTITION BY RANGE ("DIA_ID")
                          INTERVAL(NUMTOYMINTERVAL(1, ''''MONTH''''))
                          (PARTITION "p1" VALUES LESS THAN (TO_DATE('''' 2014-11-01 00:00:00'''', ''''SYYYY-MM-DD HH24:MI:SS'''', ''''NLS_CALENDAR=GREGORIAN''''))'', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRC');

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_IX'', ''H_PRC (DIA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_FASE_ACTUAL_IX'', ''H_PRC (DIA_ID, FASE_ACTUAL)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRC');


    ------------------------------ TMP_H_PRC --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_H_PRC'', 
                          ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              FASE_MAX_PRIORIDAD NUMBER(16,0),
                              FASE_ANTERIOR NUMBER(16,0),
                              FASE_ACTUAL NUMBER(16,0),
                              ULT_TAR_CREADA NUMBER(16,0),
                              ULT_TAR_FIN NUMBER(16,0),
                              ULTIMA_TAREA_ACTUALIZADA NUMBER(16,0),
                              ULT_TAR_PEND NUMBER(16,0),
                              FECHA_CREACION_ASUNTO DATE ,
                              FECHA_CONTABLE_LITIGIO DATE,
                              FECHA_CREACION_PROCEDIMIENTO DATE,
                              FECHA_CREACION_FASE_MAX_PRIO DATE,
                              FECHA_CREACION_FASE_ANTERIOR DATE,
                              FECHA_CREACION_FASE_ACTUAL DATE,
                              FECHA_ULT_TAR_CREADA DATE,
                              FECHA_ULT_TAR_FIN DATE,
                              FECHA_ULTIMA_TAREA_ACTUALIZADA DATE,
                              FECHA_ULT_TAR_PEND DATE,
                              FECHA_VENC_ORIG_ULT_TAR_FIN DATE,
                              FECHA_VENC_ACT_ULT_TAR_FIN DATE,
                              FECHA_VENC_ORIG_ULT_TAR_PEND DATE,
                              FECHA_VENC_ACT_ULT_TAR_PEND DATE,
                              FECHA_ACEPTACION DATE,
                              FECHA_RECOGIDA_DOC_Y_ACEPT DATE,
                              FECHA_REGISTRAR_TOMA_DECISION DATE,
                              FECHA_RECEPCION_DOC_COMPLETA DATE,
                              FECHA_INTERPOSICION_DEMANDA DATE,
                              FECHA_ULTIMA_POSICION_VENCIDA DATE,
                              FECHA_ULTIMA_ESTIMACION DATE,
                              FECHA_ESTIMADA_COBRO DATE,
                              FECHA_PARALIZACION DATE,
                              CONTEXTO_FASE VARCHAR2(250),
                              NIVEL INTEGER,

                              -- Dimensiones
                              ASUNTO_ID NUMBER(16,0),
                              TIPO_PROCEDIMIENTO_DET_ID NUMBER(16,0),
                              FASE_ACTUAL_DETALLE_ID NUMBER(16,0),
                              FASE_ANTERIOR_DETALLE_ID NUMBER(16,0),
                              ULT_TAR_CREADA_TIPO_DET_ID NUMBER(16,0),
                              ULT_TAR_CREADA_DESC_ID NUMBER(16,0),
                              ULT_TAR_FIN_TIPO_DET_ID NUMBER(16,0),
                              ULT_TAR_FIN_DESC_ID NUMBER(16,0),
                              ULT_TAR_ACT_TIPO_DET_ID NUMBER(16,0),
                              ULT_TAR_ACT_DESC_ID NUMBER(16,0),
                              ULT_TAR_PEND_TIPO_DET_ID NUMBER(16,0),
                              ULT_TAR_PEND_DESC_ID NUMBER(16,0),
                              CUMPLIMIENTO_ULT_TAR_FIN_ID NUMBER(16,0),
                              CUMPLIMIENTO_ULT_TAR_PEND_ID NUMBER(16,0),
                              ESTADO_PROCEDIMIENTO_ID NUMBER(16,0),
                              ESTADO_FASE_ACTUAL_ID NUMBER(16,0),
                              ESTADO_FASE_ANTERIOR_ID NUMBER(16,0),
                              T_SALDO_TOTAL_PRC_ID NUMBER(16,0),
                              T_SALDO_RECUPERACION_PRC_ID NUMBER(16,0),
                              T_SALDO_TOTAL_CONCURSO_ID NUMBER(16,0),
                              TD_ULT_ACTUALIZACION_PRC_ID NUMBER(16,0),
                              TD_CONTRATO_VENCIDO_ID NUMBER(16,0),
                              TD_CNT_VENC_CREACION_ASU_ID NUMBER(16,0),
                              TD_CREA_ASU_A_INTERP_DEM_ID NUMBER(16,0),
                              TD_CREACION_ASU_ACEPT_ID NUMBER(16,0),
                              TD_ACEPT_ASU_INTERP_DEM_ID NUMBER(16,0),
                              TD_CREA_ASU_REC_DOC_ACEP_ID NUMBER(16,0),
                              TD_REC_DOC_ACEPT_REG_TD_ID NUMBER(16,0),
                              TD_REC_DOC_ACEPT_REC_DC_ID NUMBER(16,0),
                              CNT_GARANTIA_REAL_ASOC_ID NUMBER(16,0),
                              ACT_ESTIMACIONES_ID NUMBER(16,0),
                              CARTERA_PROCEDIMIENTO_ID NUMBER(16,0),
                              TITULAR_PROCEDIMIENTO_ID NUMBER(16,0),
                              PRC_PARALIZADO_ID NUMBER(16,0),
                              MOTIVO_PARALIZACION_ID  NUMBER(16,0),
                              -- Metricas
                              NUM_PROCEDIMIENTOS INTEGER,
                              NUM_CONTRATOS INTEGER,
                              NUM_FASES INTEGER,
                              NUM_DIAS_ULT_ACTUALIZACION INTEGER,
                              NUM_MAX_DIAS_CONTRATO_VENCIDO INTEGER,
                              NUM_MAX_DIAS_CNT_VENC_CREA_ASU INTEGER,
                              PORCENTAJE_RECUPERACION INTEGER,
                              P_RECUPERACION INTEGER,
                              SALDO_RECUPERACION NUMBER(14,2),
                              ESTIMACION_RECUPERACION NUMBER(14,2),
                              SALDO_ORIGINAL_VENCIDO NUMBER(14,2),
                              SALDO_ORIGINAL_NO_VENCIDO NUMBER(14,2),
                              SALDO_ACTUAL_VENCIDO NUMBER(14,2),
                              SALDO_ACTUAL_NO_VENCIDO NUMBER(14,2),
                              SALDO_ACTUAL_TOTAL NUMBER(14,2),
                              SALDO_CONCURSOS_VENCIDO NUMBER(14,2),
                              SALDO_CONCURSOS_NO_VENCIDO NUMBER(14,2),
                              SALDO_CONCURSOS_TOTAL NUMBER(14,2),
                              INGRESOS_PENDIENTES_APLICAR NUMBER(14,2),
                              SUBTOTAL NUMBER(14,2),
                              DURACION_ULT_TAREA_FINALIZADA INTEGER,
                              NUM_DIAS_EXCED_ULT_TAR_FIN INTEGER,
                              NUM_DIAS_VENC_ULT_TAR_FIN INTEGER,
                              NUM_DIAS_PRORROG_ULT_TAR_FIN INTEGER,
                              NUM_PRORROG_ULT_TAR_FIN INTEGER,
                              DURACION_ULT_TAREA_PENDIENTE INTEGER,
                              NUM_DIAS_EXCEDIDO_ULT_TAR_PEND INTEGER,
                              NUM_DIAS_VENC_ULT_TAR_PEND INTEGER,
                              NUM_DIAS_PRORROG_ULT_TAR_PEND INTEGER,
                              NUM_PRORROG_ULT_TAR_PEND INTEGER,
                              P_CREA_ASU_A_INTERP_DEM INTEGER,
                              P_CREACION_ASU_ACEP INTEGER,
                              P_ACEPT_ASU_INTERP_DEM INTEGER,
                              P_CREA_ASU_REC_DOC_ACEP INTEGER,
                              P_REC_DOC_ACEP_REG_TD INTEGER,
                              P_REC_DOC_ACEP_RECEP_DC INTEGER,
                              NUM_DIAS_DESDE_ULT_ESTIMACION INTEGER, 

                              FECHA_CANCELACION_ASUNTO date,
                              PRC_PARALIZADO_ID NUMBER(16,0) ,
                              FECHA_PARALIZACION DATE,
                              MOTIVO_PARALIZACION_ID  NUMBER(16,0),
                              FASE_ACTUAL_AGR_ID NUMBER(16,0)  , 
							  MOTIVO_FINALIZACION_ID  NUMBER(16,0) ,
                              PRC_FINALIZADO_ID NUMBER(16,0) ,
                              FECHA_FINALIZACION DATE
'', :error); END;';
    execute immediate V_SQL USING OUT error;











    


    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_H_PRC');

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_PRC_IX'', ''TMP_H_PRC (DIA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_PRC_FASE_ACTUAL_IX'', ''TMP_H_PRC (DIA_ID, FASE_ACTUAL)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_H_PRC');


    ------------------------------ H_PRC_SEMANA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRC_SEMANA'', 
                          ''SEMANA_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              FASE_MAX_PRIORIDAD NUMBER(16,0),
                              FASE_ANTERIOR NUMBER(16,0),
                              FASE_ACTUAL NUMBER(16,0),
                              ULT_TAR_CREADA NUMBER(16,0),
                              ULT_TAR_FIN NUMBER(16,0),
                              ULTIMA_TAREA_ACTUALIZADA NUMBER(16,0),
                              ULT_TAR_PEND NUMBER(16,0),
                              FECHA_CREACION_ASUNTO DATE,
                              FECHA_CONTABLE_LITIGIO DATE,
                              FECHA_CREACION_PROCEDIMIENTO DATE,
                              FECHA_CREACION_FASE_MAX_PRIO DATE,
                              FECHA_CREACION_FASE_ANTERIOR DATE,
                              FECHA_CREACION_FASE_ACTUAL DATE,
                              FECHA_ULT_TAR_CREADA DATE,
                              FECHA_ULT_TAR_FIN DATE,
                              FECHA_ULTIMA_TAREA_ACTUALIZADA DATE,
                              FECHA_ULT_TAR_PEND DATE,
                              FECHA_VENC_ORIG_ULT_TAR_FIN DATE,
                              FECHA_VENC_ACT_ULT_TAR_FIN DATE,
                              FECHA_VENC_ORIG_ULT_TAR_PEND DATE,
                              FECHA_VENC_ACT_ULT_TAR_PEND DATE,
                              FECHA_ACEPTACION DATE,
                              FECHA_RECOGIDA_DOC_Y_ACEPT DATE,
                              FECHA_REGISTRAR_TOMA_DECISION DATE,
                              FECHA_RECEPCION_DOC_COMPLETA DATE,
                              FECHA_INTERPOSICION_DEMANDA DATE,
                              FECHA_ULTIMA_POSICION_VENCIDA DATE,
                              FECHA_ULTIMA_ESTIMACION DATE,
                              FECHA_ESTIMADA_COBRO DATE,
                              FECHA_PARALIZACION DATE,
                              CONTEXTO_FASE VARCHAR2(250),
                              NIVEL INTEGER,

                              -- Dimensiones
                              ASUNTO_ID NUMBER(16,0),
                              TIPO_PROCEDIMIENTO_DET_ID NUMBER(16,0),
                              FASE_ACTUAL_DETALLE_ID NUMBER(16,0),
                              FASE_ANTERIOR_DETALLE_ID NUMBER(16,0),
                              ULT_TAR_CREADA_TIPO_DET_ID NUMBER(16,0),
                              ULT_TAR_CREADA_DESC_ID NUMBER(16,0),
                              ULT_TAR_FIN_TIPO_DET_ID NUMBER(16,0),
                              ULT_TAR_FIN_DESC_ID NUMBER(16,0),
                              ULT_TAR_ACT_TIPO_DET_ID NUMBER(16,0),
                              ULT_TAR_ACT_DESC_ID NUMBER(16,0),
                              ULT_TAR_PEND_TIPO_DET_ID NUMBER(16,0),
                              ULT_TAR_PEND_DESC_ID NUMBER(16,0),
                              CUMPLIMIENTO_ULT_TAR_FIN_ID NUMBER(16,0),
                              CUMPLIMIENTO_ULT_TAR_PEND_ID NUMBER(16,0),
                              ESTADO_PROCEDIMIENTO_ID NUMBER(16,0),
                              ESTADO_FASE_ACTUAL_ID NUMBER(16,0),
                              ESTADO_FASE_ANTERIOR_ID NUMBER(16,0),
                              T_SALDO_TOTAL_PRC_ID NUMBER(16,0),
                              T_SALDO_RECUPERACION_PRC_ID NUMBER(16,0),
                              T_SALDO_TOTAL_CONCURSO_ID NUMBER(16,0),
                              TD_ULT_ACTUALIZACION_PRC_ID NUMBER(16,0),
                              TD_CONTRATO_VENCIDO_ID NUMBER(16,0),
                              TD_CNT_VENC_CREACION_ASU_ID NUMBER(16,0),
                              TD_CREA_ASU_A_INTERP_DEM_ID NUMBER(16,0),
                              TD_CREACION_ASU_ACEPT_ID NUMBER(16,0),
                              TD_ACEPT_ASU_INTERP_DEM_ID NUMBER(16,0),
                              TD_CREA_ASU_REC_DOC_ACEP_ID NUMBER(16,0),
                              TD_REC_DOC_ACEPT_REG_TD_ID NUMBER(16,0),
                              TD_REC_DOC_ACEPT_REC_DC_ID NUMBER(16,0),
                              CNT_GARANTIA_REAL_ASOC_ID NUMBER(16,0),
                              ACT_ESTIMACIONES_ID NUMBER(16,0),
                              CARTERA_PROCEDIMIENTO_ID NUMBER(16,0),
                              TITULAR_PROCEDIMIENTO_ID NUMBER(16,0),
                              PRC_PARALIZADO_ID NUMBER(16,0),
                              MOTIVO_PARALIZACION_ID NUMBER(16,0),
                              -- Metricas
                              NUM_PROCEDIMIENTOS INTEGER,
                              NUM_CONTRATOS INTEGER,
                              NUM_FASES INTEGER,
                              NUM_DIAS_ULT_ACTUALIZACION INTEGER,
                              NUM_MAX_DIAS_CONTRATO_VENCIDO INTEGER,
                              NUM_MAX_DIAS_CNT_VENC_CREA_ASU INTEGER,
                              PORCENTAJE_RECUPERACION INTEGER,
                              P_RECUPERACION INTEGER,
                              SALDO_RECUPERACION NUMBER(14,2),
                              ESTIMACION_RECUPERACION NUMBER(14,2),
                              SALDO_ORIGINAL_VENCIDO NUMBER(14,2),
                              SALDO_ORIGINAL_NO_VENCIDO NUMBER(14,2),
                              SALDO_ACTUAL_VENCIDO NUMBER(14,2),
                              SALDO_ACTUAL_NO_VENCIDO NUMBER(14,2),
                              SALDO_ACTUAL_TOTAL NUMBER(14,2),
                              SALDO_CONCURSOS_VENCIDO NUMBER(14,2),
                              SALDO_CONCURSOS_NO_VENCIDO NUMBER(14,2),
                              SALDO_CONCURSOS_TOTAL NUMBER(14,2),
                              INGRESOS_PENDIENTES_APLICAR NUMBER(14,2),
                              SUBTOTAL NUMBER(14,2),
                              DURACION_ULT_TAREA_FINALIZADA INTEGER,
                              NUM_DIAS_EXCED_ULT_TAR_FIN INTEGER,
                              NUM_DIAS_VENC_ULT_TAR_FIN INTEGER,
                              NUM_DIAS_PRORROG_ULT_TAR_FIN INTEGER,
                              NUM_PRORROG_ULT_TAR_FIN INTEGER,
                              DURACION_ULT_TAREA_PENDIENTE INTEGER,
                              NUM_DIAS_EXCEDIDO_ULT_TAR_PEND INTEGER,
                              NUM_DIAS_VENC_ULT_TAR_PEND INTEGER,
                              NUM_DIAS_PRORROG_ULT_TAR_PEND INTEGER,
                              NUM_PRORROG_ULT_TAR_PEND INTEGER,
                              P_CREA_ASU_A_INTERP_DEM INTEGER,
                              P_CREACION_ASU_ACEP INTEGER,
                              P_ACEPT_ASU_INTERP_DEM INTEGER,
                              P_CREA_ASU_REC_DOC_ACEP INTEGER,
                              P_REC_DOC_ACEP_REG_TD INTEGER,
                              P_REC_DOC_ACEP_RECEP_DC INTEGER,
                              NUM_DIAS_DESDE_ULT_ESTIMACION INTEGER,

                              FECHA_CANCELACION_ASUNTO date,
                              PRC_PARALIZADO_ID NUMBER(16,0) ,
                              FECHA_PARALIZACION DATE,
                              MOTIVO_PARALIZACION_ID  NUMBER(16,0),
                              FASE_ACTUAL_AGR_ID NUMBER(16,0)  , 
                              PRC_FINALIZADO_ID NUMBER(16,0) ,
                              FECHA_FINALIZACION DATE,
                              MOTIVO_FINALIZACION_ID  NUMBER(16,0) '', :error); END;';
    execute immediate V_SQL USING OUT error;









    



    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRC_SEMANA');

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_SEMANA_IX'', ''H_PRC_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRC_SEMANA');

    
    ------------------------------ H_PRC_MES --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRC_MES'', 
                          ''MES_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              FASE_MAX_PRIORIDAD NUMBER(16,0),
                              FASE_ANTERIOR NUMBER(16,0),
                              FASE_ACTUAL NUMBER(16,0),
                              ULT_TAR_CREADA NUMBER(16,0),
                              ULT_TAR_FIN NUMBER(16,0),
                              ULTIMA_TAREA_ACTUALIZADA NUMBER(16,0),
                              ULT_TAR_PEND NUMBER(16,0),
                              FECHA_CREACION_ASUNTO DATE,
                              FECHA_CONTABLE_LITIGIO DATE,
                              FECHA_CREACION_PROCEDIMIENTO DATE,
                              FECHA_CREACION_FASE_MAX_PRIO DATE,
                              FECHA_CREACION_FASE_ANTERIOR DATE,
                              FECHA_CREACION_FASE_ACTUAL DATE,
                              FECHA_ULT_TAR_CREADA DATE,
                              FECHA_ULT_TAR_FIN DATE,
                              FECHA_ULTIMA_TAREA_ACTUALIZADA DATE,
                              FECHA_ULT_TAR_PEND DATE,
                              FECHA_VENC_ORIG_ULT_TAR_FIN DATE,
                              FECHA_VENC_ACT_ULT_TAR_FIN DATE,
                              FECHA_VENC_ORIG_ULT_TAR_PEND DATE,
                              FECHA_VENC_ACT_ULT_TAR_PEND DATE,
                              FECHA_ACEPTACION DATE,
                              FECHA_RECOGIDA_DOC_Y_ACEPT DATE,
                              FECHA_REGISTRAR_TOMA_DECISION DATE,
                              FECHA_RECEPCION_DOC_COMPLETA DATE,
                              FECHA_INTERPOSICION_DEMANDA DATE,
                              FECHA_ULTIMA_POSICION_VENCIDA DATE,
                              FECHA_ULTIMA_ESTIMACION DATE,
                              FECHA_ESTIMADA_COBRO DATE,
                              FECHA_PARALIZACION DATE,
                              CONTEXTO_FASE VARCHAR2(250),
                              NIVEL INTEGER,

                              -- Dimensiones
                              ASUNTO_ID NUMBER(16,0),
                              TIPO_PROCEDIMIENTO_DET_ID NUMBER(16,0),
                              FASE_ACTUAL_DETALLE_ID NUMBER(16,0),
                              FASE_ANTERIOR_DETALLE_ID NUMBER(16,0),
                              ULT_TAR_CREADA_TIPO_DET_ID NUMBER(16,0),
                              ULT_TAR_CREADA_DESC_ID NUMBER(16,0),
                              ULT_TAR_FIN_TIPO_DET_ID NUMBER(16,0),
                              ULT_TAR_FIN_DESC_ID NUMBER(16,0),
                              ULT_TAR_ACT_TIPO_DET_ID NUMBER(16,0),
                              ULT_TAR_ACT_DESC_ID NUMBER(16,0),
                              ULT_TAR_PEND_TIPO_DET_ID NUMBER(16,0),
                              ULT_TAR_PEND_DESC_ID NUMBER(16,0),
                              CUMPLIMIENTO_ULT_TAR_FIN_ID NUMBER(16,0),
                              CUMPLIMIENTO_ULT_TAR_PEND_ID NUMBER(16,0),
                              ESTADO_PROCEDIMIENTO_ID NUMBER(16,0),
                              ESTADO_FASE_ACTUAL_ID NUMBER(16,0),
                              ESTADO_FASE_ANTERIOR_ID NUMBER(16,0),
                              T_SALDO_TOTAL_PRC_ID NUMBER(16,0),
                              T_SALDO_RECUPERACION_PRC_ID NUMBER(16,0),
                              T_SALDO_TOTAL_CONCURSO_ID NUMBER(16,0),
                              TD_ULT_ACTUALIZACION_PRC_ID NUMBER(16,0),
                              TD_CONTRATO_VENCIDO_ID NUMBER(16,0),
                              TD_CNT_VENC_CREACION_ASU_ID NUMBER(16,0),
                              TD_CREA_ASU_A_INTERP_DEM_ID NUMBER(16,0),
                              TD_CREACION_ASU_ACEPT_ID NUMBER(16,0),
                              TD_ACEPT_ASU_INTERP_DEM_ID NUMBER(16,0),
                              TD_CREA_ASU_REC_DOC_ACEP_ID NUMBER(16,0),
                              TD_REC_DOC_ACEPT_REG_TD_ID NUMBER(16,0),
                              TD_REC_DOC_ACEPT_REC_DC_ID NUMBER(16,0),
                              CNT_GARANTIA_REAL_ASOC_ID NUMBER(16,0),
                              ACT_ESTIMACIONES_ID NUMBER(16,0),
                              CARTERA_PROCEDIMIENTO_ID NUMBER(16,0),
                              TITULAR_PROCEDIMIENTO_ID NUMBER(16,0),
                              PRC_PARALIZADO_ID NUMBER(16,0),
                              MOTIVO_PARALIZACION_ID NUMBER(16,0),
                              -- Metricas
                              NUM_PROCEDIMIENTOS INTEGER,
                              NUM_CONTRATOS INTEGER,
                              NUM_FASES INTEGER,
                              NUM_DIAS_ULT_ACTUALIZACION INTEGER,
                              NUM_MAX_DIAS_CONTRATO_VENCIDO INTEGER,
                              NUM_MAX_DIAS_CNT_VENC_CREA_ASU INTEGER,
                              PORCENTAJE_RECUPERACION INTEGER,
                              P_RECUPERACION INTEGER,
                              SALDO_RECUPERACION NUMBER(14,2),
                              ESTIMACION_RECUPERACION NUMBER(14,2),
                              SALDO_ORIGINAL_VENCIDO NUMBER(14,2),
                              SALDO_ORIGINAL_NO_VENCIDO NUMBER(14,2),
                              SALDO_ACTUAL_VENCIDO NUMBER(14,2),
                              SALDO_ACTUAL_NO_VENCIDO NUMBER(14,2),
                              SALDO_ACTUAL_TOTAL NUMBER(14,2),
                              SALDO_CONCURSOS_VENCIDO NUMBER(14,2),
                              SALDO_CONCURSOS_NO_VENCIDO NUMBER(14,2),
                              SALDO_CONCURSOS_TOTAL NUMBER(14,2),
                              INGRESOS_PENDIENTES_APLICAR NUMBER(14,2),
                              SUBTOTAL NUMBER(14,2),
                              DURACION_ULT_TAREA_FINALIZADA INTEGER,
                              NUM_DIAS_EXCED_ULT_TAR_FIN INTEGER,
                              NUM_DIAS_VENC_ULT_TAR_FIN INTEGER,
                              NUM_DIAS_PRORROG_ULT_TAR_FIN INTEGER,
                              NUM_PRORROG_ULT_TAR_FIN INTEGER,
                              DURACION_ULT_TAREA_PENDIENTE INTEGER,
                              NUM_DIAS_EXCEDIDO_ULT_TAR_PEND INTEGER,
                              NUM_DIAS_VENC_ULT_TAR_PEND INTEGER,
                              NUM_DIAS_PRORROG_ULT_TAR_PEND INTEGER,
                              NUM_PRORROG_ULT_TAR_PEND INTEGER,
                              P_CREA_ASU_A_INTERP_DEM INTEGER,
                              P_CREACION_ASU_ACEP INTEGER,
                              P_ACEPT_ASU_INTERP_DEM INTEGER,
                              P_CREA_ASU_REC_DOC_ACEP INTEGER,
                              P_REC_DOC_ACEP_REG_TD INTEGER,
                              P_REC_DOC_ACEP_RECEP_DC INTEGER,
                              NUM_DIAS_DESDE_ULT_ESTIMACION INTEGER,

                              FECHA_CANCELACION_ASUNTO date,
                              PRC_PARALIZADO_ID NUMBER(16,0) ,
                              FECHA_PARALIZACION DATE,
                              MOTIVO_PARALIZACION_ID  NUMBER(16,0),
                              FASE_ACTUAL_AGR_ID NUMBER(16,0) , 
                              PRC_FINALIZADO_ID NUMBER(16,0) ,
                              FECHA_FINALIZACION DATE,
                              MOTIVO_FINALIZACION_ID  NUMBER(16,0)  '', :error); END;';
    execute immediate V_SQL USING OUT error;













    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRC_MES');

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_MES_IX'', ''H_PRC_MES (MES_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRC_MES');


    ------------------------------ H_PRC_TRIMESTRE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRC_TRIMESTRE'', 
                          ''TRIMESTRE_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              FASE_MAX_PRIORIDAD NUMBER(16,0),
                              FASE_ANTERIOR NUMBER(16,0),
                              FASE_ACTUAL NUMBER(16,0),
                              ULT_TAR_CREADA NUMBER(16,0),
                              ULT_TAR_FIN NUMBER(16,0),
                              ULTIMA_TAREA_ACTUALIZADA NUMBER(16,0),
                              ULT_TAR_PEND NUMBER(16,0),
                              FECHA_CREACION_ASUNTO DATE,
                              FECHA_CONTABLE_LITIGIO DATE,
                              FECHA_CREACION_PROCEDIMIENTO DATE,
                              FECHA_CREACION_FASE_MAX_PRIO DATE,
                              FECHA_CREACION_FASE_ANTERIOR DATE,
                              FECHA_CREACION_FASE_ACTUAL DATE,
                              FECHA_ULT_TAR_CREADA DATE,
                              FECHA_ULT_TAR_FIN DATE,
                              FECHA_ULTIMA_TAREA_ACTUALIZADA DATE,
                              FECHA_ULT_TAR_PEND DATE,
                              FECHA_VENC_ORIG_ULT_TAR_FIN DATE,
                              FECHA_VENC_ACT_ULT_TAR_FIN DATE,
                              FECHA_VENC_ORIG_ULT_TAR_PEND DATE,
                              FECHA_VENC_ACT_ULT_TAR_PEND DATE,
                              FECHA_ACEPTACION DATE,
                              FECHA_RECOGIDA_DOC_Y_ACEPT DATE,
                              FECHA_REGISTRAR_TOMA_DECISION DATE,
                              FECHA_RECEPCION_DOC_COMPLETA DATE,
                              FECHA_INTERPOSICION_DEMANDA DATE,
                              FECHA_ULTIMA_POSICION_VENCIDA DATE,
                              FECHA_ULTIMA_ESTIMACION DATE,
                              FECHA_ESTIMADA_COBRO DATE,
                              FECHA_PARALIZACION DATE,
                              CONTEXTO_FASE VARCHAR2(250),
                              NIVEL INTEGER,

                              -- Dimensiones
                              ASUNTO_ID NUMBER(16,0),
                              TIPO_PROCEDIMIENTO_DET_ID NUMBER(16,0),
                              FASE_ACTUAL_DETALLE_ID NUMBER(16,0),
                              FASE_ANTERIOR_DETALLE_ID NUMBER(16,0),
                              ULT_TAR_CREADA_TIPO_DET_ID NUMBER(16,0),
                              ULT_TAR_CREADA_DESC_ID NUMBER(16,0),
                              ULT_TAR_FIN_TIPO_DET_ID NUMBER(16,0),
                              ULT_TAR_FIN_DESC_ID NUMBER(16,0),
                              ULT_TAR_ACT_TIPO_DET_ID NUMBER(16,0),
                              ULT_TAR_ACT_DESC_ID NUMBER(16,0),
                              ULT_TAR_PEND_TIPO_DET_ID NUMBER(16,0),
                              ULT_TAR_PEND_DESC_ID NUMBER(16,0),
                              CUMPLIMIENTO_ULT_TAR_FIN_ID NUMBER(16,0),
                              CUMPLIMIENTO_ULT_TAR_PEND_ID NUMBER(16,0),
                              ESTADO_PROCEDIMIENTO_ID NUMBER(16,0),
                              ESTADO_FASE_ACTUAL_ID NUMBER(16,0),
                              ESTADO_FASE_ANTERIOR_ID NUMBER(16,0),
                              T_SALDO_TOTAL_PRC_ID NUMBER(16,0),
                              T_SALDO_RECUPERACION_PRC_ID NUMBER(16,0),
                              T_SALDO_TOTAL_CONCURSO_ID NUMBER(16,0),
                              TD_ULT_ACTUALIZACION_PRC_ID NUMBER(16,0),
                              TD_CONTRATO_VENCIDO_ID NUMBER(16,0),
                              TD_CNT_VENC_CREACION_ASU_ID NUMBER(16,0),
                              TD_CREA_ASU_A_INTERP_DEM_ID NUMBER(16,0),
                              TD_CREACION_ASU_ACEPT_ID NUMBER(16,0),
                              TD_ACEPT_ASU_INTERP_DEM_ID NUMBER(16,0),
                              TD_CREA_ASU_REC_DOC_ACEP_ID NUMBER(16,0),
                              TD_REC_DOC_ACEPT_REG_TD_ID NUMBER(16,0),
                              TD_REC_DOC_ACEPT_REC_DC_ID NUMBER(16,0),
                              CNT_GARANTIA_REAL_ASOC_ID NUMBER(16,0),
                              ACT_ESTIMACIONES_ID NUMBER(16,0),
                              CARTERA_PROCEDIMIENTO_ID NUMBER(16,0),
                              TITULAR_PROCEDIMIENTO_ID NUMBER(16,0),
                              PRC_PARALIZADO_ID NUMBER(16,0),
                              MOTIVO_PARALIZACION_ID NUMBER(16,0),
                              -- Metricas
                              NUM_PROCEDIMIENTOS INTEGER,
                              NUM_CONTRATOS INTEGER,
                              NUM_FASES INTEGER,
                              NUM_DIAS_ULT_ACTUALIZACION INTEGER,
                              NUM_MAX_DIAS_CONTRATO_VENCIDO INTEGER,
                              NUM_MAX_DIAS_CNT_VENC_CREA_ASU INTEGER,
                              PORCENTAJE_RECUPERACION INTEGER,
                              P_RECUPERACION INTEGER,
                              SALDO_RECUPERACION NUMBER(14,2),
                              ESTIMACION_RECUPERACION NUMBER(14,2),
                              SALDO_ORIGINAL_VENCIDO NUMBER(14,2),
                              SALDO_ORIGINAL_NO_VENCIDO NUMBER(14,2),
                              SALDO_ACTUAL_VENCIDO NUMBER(14,2),
                              SALDO_ACTUAL_NO_VENCIDO NUMBER(14,2),
                              SALDO_ACTUAL_TOTAL NUMBER(14,2),
                              SALDO_CONCURSOS_VENCIDO NUMBER(14,2),
                              SALDO_CONCURSOS_NO_VENCIDO NUMBER(14,2),
                              SALDO_CONCURSOS_TOTAL NUMBER(14,2),
                              INGRESOS_PENDIENTES_APLICAR NUMBER(14,2),
                              SUBTOTAL NUMBER(14,2),
                              DURACION_ULT_TAREA_FINALIZADA INTEGER,
                              NUM_DIAS_EXCED_ULT_TAR_FIN INTEGER,
                              NUM_DIAS_VENC_ULT_TAR_FIN INTEGER,
                              NUM_DIAS_PRORROG_ULT_TAR_FIN INTEGER,
                              NUM_PRORROG_ULT_TAR_FIN INTEGER,
                              DURACION_ULT_TAREA_PENDIENTE INTEGER,
                              NUM_DIAS_EXCEDIDO_ULT_TAR_PEND INTEGER,
                              NUM_DIAS_VENC_ULT_TAR_PEND INTEGER,
                              NUM_DIAS_PRORROG_ULT_TAR_PEND INTEGER,
                              NUM_PRORROG_ULT_TAR_PEND INTEGER,
                              P_CREA_ASU_A_INTERP_DEM INTEGER,
                              P_CREACION_ASU_ACEP INTEGER,
                              P_ACEPT_ASU_INTERP_DEM INTEGER,
                              P_CREA_ASU_REC_DOC_ACEP INTEGER,
                              P_REC_DOC_ACEP_REG_TD INTEGER,
                              P_REC_DOC_ACEP_RECEP_DC INTEGER,
                              NUM_DIAS_DESDE_ULT_ESTIMACION INTEGER,

                              FECHA_CANCELACION_ASUNTO date,
                              PRC_PARALIZADO_ID NUMBER(16,0) ,
                              FECHA_PARALIZACION DATE,
                              MOTIVO_PARALIZACION_ID  NUMBER(16,0),
                              FASE_ACTUAL_AGR_ID NUMBER(16,0) , 
                              PRC_FINALIZADO_ID NUMBER(16,0) ,
                              FECHA_FINALIZACION DATE,
                              MOTIVO_FINALIZACION_ID  NUMBER(16,0) '', :error); END;';
    execute immediate V_SQL USING OUT error;



    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRC_TRIMESTRE');

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_TRIMESTRE_IX'', ''H_PRC_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRC_TRIMESTRE');


    ------------------------------ H_PRC_ANIO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRC_ANIO'', 
                          ''ANIO_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              FASE_MAX_PRIORIDAD NUMBER(16,0),
                              FASE_ANTERIOR NUMBER(16,0),
                              FASE_ACTUAL NUMBER(16,0),
                              ULT_TAR_CREADA NUMBER(16,0),
                              ULT_TAR_FIN NUMBER(16,0),
                              ULTIMA_TAREA_ACTUALIZADA NUMBER(16,0),
                              ULT_TAR_PEND NUMBER(16,0),
                              FECHA_CREACION_ASUNTO DATE,
                              FECHA_CONTABLE_LITIGIO DATE,
                              FECHA_CREACION_PROCEDIMIENTO DATE,
                              FECHA_CREACION_FASE_MAX_PRIO DATE,
                              FECHA_CREACION_FASE_ANTERIOR DATE,
                              FECHA_CREACION_FASE_ACTUAL DATE,
                              FECHA_ULT_TAR_CREADA DATE,
                              FECHA_ULT_TAR_FIN DATE,
                              FECHA_ULTIMA_TAREA_ACTUALIZADA DATE,
                              FECHA_ULT_TAR_PEND DATE,
                              FECHA_VENC_ORIG_ULT_TAR_FIN DATE,
                              FECHA_VENC_ACT_ULT_TAR_FIN DATE,
                              FECHA_VENC_ORIG_ULT_TAR_PEND DATE,
                              FECHA_VENC_ACT_ULT_TAR_PEND DATE,
                              FECHA_ACEPTACION DATE,
                              FECHA_RECOGIDA_DOC_Y_ACEPT DATE,
                              FECHA_REGISTRAR_TOMA_DECISION DATE,
                              FECHA_RECEPCION_DOC_COMPLETA DATE,
                              FECHA_INTERPOSICION_DEMANDA DATE,
                              FECHA_ULTIMA_POSICION_VENCIDA DATE,
                              FECHA_ULTIMA_ESTIMACION DATE,
                              FECHA_ESTIMADA_COBRO DATE,
                              FECHA_PARALIZACION DATE,
                              CONTEXTO_FASE VARCHAR2(250),
                              NIVEL INTEGER,

                              -- Dimensiones
                              ASUNTO_ID NUMBER(16,0),
                              TIPO_PROCEDIMIENTO_DET_ID NUMBER(16,0),
                              FASE_ACTUAL_DETALLE_ID NUMBER(16,0),
                              FASE_ANTERIOR_DETALLE_ID NUMBER(16,0),
                              ULT_TAR_CREADA_TIPO_DET_ID NUMBER(16,0),
                              ULT_TAR_CREADA_DESC_ID NUMBER(16,0),
                              ULT_TAR_FIN_TIPO_DET_ID NUMBER(16,0),
                              ULT_TAR_FIN_DESC_ID NUMBER(16,0),
                              ULT_TAR_ACT_TIPO_DET_ID NUMBER(16,0),
                              ULT_TAR_ACT_DESC_ID NUMBER(16,0),
                              ULT_TAR_PEND_TIPO_DET_ID NUMBER(16,0),
                              ULT_TAR_PEND_DESC_ID NUMBER(16,0),
                              CUMPLIMIENTO_ULT_TAR_FIN_ID NUMBER(16,0),
                              CUMPLIMIENTO_ULT_TAR_PEND_ID NUMBER(16,0),
                              ESTADO_PROCEDIMIENTO_ID NUMBER(16,0),
                              ESTADO_FASE_ACTUAL_ID NUMBER(16,0),
                              ESTADO_FASE_ANTERIOR_ID NUMBER(16,0),
                              T_SALDO_TOTAL_PRC_ID NUMBER(16,0),
                              T_SALDO_RECUPERACION_PRC_ID NUMBER(16,0),
                              T_SALDO_TOTAL_CONCURSO_ID NUMBER(16,0),
                              TD_ULT_ACTUALIZACION_PRC_ID NUMBER(16,0),
                              TD_CONTRATO_VENCIDO_ID NUMBER(16,0),
                              TD_CNT_VENC_CREACION_ASU_ID NUMBER(16,0),
                              TD_CREA_ASU_A_INTERP_DEM_ID NUMBER(16,0),
                              TD_CREACION_ASU_ACEPT_ID NUMBER(16,0),
                              TD_ACEPT_ASU_INTERP_DEM_ID NUMBER(16,0),
                              TD_CREA_ASU_REC_DOC_ACEP_ID NUMBER(16,0),
                              TD_REC_DOC_ACEPT_REG_TD_ID NUMBER(16,0),
                              TD_REC_DOC_ACEPT_REC_DC_ID NUMBER(16,0),
                              CNT_GARANTIA_REAL_ASOC_ID NUMBER(16,0),
                              ACT_ESTIMACIONES_ID NUMBER(16,0),
                              CARTERA_PROCEDIMIENTO_ID NUMBER(16,0),
                              TITULAR_PROCEDIMIENTO_ID NUMBER(16,0),
                              PRC_PARALIZADO_ID NUMBER(16,0),
                              MOTIVO_PARALIZACION_ID NUMBER(16,0),
                              -- Metricas
                              NUM_PROCEDIMIENTOS INTEGER,
                              NUM_CONTRATOS INTEGER,
                              NUM_FASES INTEGER,
                              NUM_DIAS_ULT_ACTUALIZACION INTEGER,
                              NUM_MAX_DIAS_CONTRATO_VENCIDO INTEGER,
                              NUM_MAX_DIAS_CNT_VENC_CREA_ASU INTEGER,
                              PORCENTAJE_RECUPERACION INTEGER,
                              P_RECUPERACION INTEGER,
                              SALDO_RECUPERACION NUMBER(14,2),
                              ESTIMACION_RECUPERACION NUMBER(14,2),
                              SALDO_ORIGINAL_VENCIDO NUMBER(14,2),
                              SALDO_ORIGINAL_NO_VENCIDO NUMBER(14,2),
                              SALDO_ACTUAL_VENCIDO NUMBER(14,2),
                              SALDO_ACTUAL_NO_VENCIDO NUMBER(14,2),
                              SALDO_ACTUAL_TOTAL NUMBER(14,2),
                              SALDO_CONCURSOS_VENCIDO NUMBER(14,2),
                              SALDO_CONCURSOS_NO_VENCIDO NUMBER(14,2),
                              SALDO_CONCURSOS_TOTAL NUMBER(14,2),
                              INGRESOS_PENDIENTES_APLICAR NUMBER(14,2),
                              SUBTOTAL NUMBER(14,2),
                              DURACION_ULT_TAREA_FINALIZADA INTEGER,
                              NUM_DIAS_EXCED_ULT_TAR_FIN INTEGER,
                              NUM_DIAS_VENC_ULT_TAR_FIN INTEGER,
                              NUM_DIAS_PRORROG_ULT_TAR_FIN INTEGER,
                              NUM_PRORROG_ULT_TAR_FIN INTEGER,
                              DURACION_ULT_TAREA_PENDIENTE INTEGER,
                              NUM_DIAS_EXCEDIDO_ULT_TAR_PEND INTEGER,
                              NUM_DIAS_VENC_ULT_TAR_PEND INTEGER,
                              NUM_DIAS_PRORROG_ULT_TAR_PEND INTEGER,
                              NUM_PRORROG_ULT_TAR_PEND INTEGER,
                              P_CREA_ASU_A_INTERP_DEM INTEGER,
                              P_CREACION_ASU_ACEP INTEGER,
                              P_ACEPT_ASU_INTERP_DEM INTEGER,
                              P_CREA_ASU_REC_DOC_ACEP INTEGER,
                              P_REC_DOC_ACEP_REG_TD INTEGER,
                              P_REC_DOC_ACEP_RECEP_DC INTEGER,
                              NUM_DIAS_DESDE_ULT_ESTIMACION INTEGER,

                              FECHA_CANCELACION_ASUNTO date,
                              PRC_PARALIZADO_ID NUMBER(16,0) ,
                              FECHA_PARALIZACION DATE,
                              MOTIVO_PARALIZACION_ID  NUMBER(16,0),
                              FASE_ACTUAL_AGR_ID NUMBER(16,0) , 
                              PRC_FINALIZADO_ID NUMBER(16,0) ,
                              FECHA_FINALIZACION DATE,
                              MOTIVO_FINALIZACION_ID  NUMBER(16,0) '', :error); END;';
    execute immediate V_SQL USING OUT error;













    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRC_ANIO');

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_ANIO_IX'', ''H_PRC_ANIO (ANIO_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRC_ANIO');


    ------------------------------ H_PRC_DET_COBRO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRC_DET_COBRO'', 
                          ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              ASUNTO_ID NUMBER(16,0) NOT NULL,
                              CONTRATO_ID NUMBER(16,0)  ,
                              FECHA_COBRO DATE ,
                              FECHA_ASUNTO DATE ,
                              -- Dimensiones
                              TIPO_COBRO_DETALLE_ID NUMBER(16,0) ,
                              -- Metricas
                              NUM_COBROS INTEGER ,
                              IMPORTE_COBRO NUMBER(15,2) ,
                              NUM_DIAS_CREACION_ASU_COBRO INTEGER

                             )SEGMENT CREATION IMMEDIATE 
                          TABLESPACE "RECOVERY_BANKIA_DWH" 
                          PARTITION BY RANGE ("DIA_ID")
                          INTERVAL(NUMTOYMINTERVAL(1, ''''MONTH''''))
                          (PARTITION "p1" VALUES LESS THAN (TO_DATE('''' 2014-11-01 00:00:00'''', ''''SYYYY-MM-DD HH24:MI:SS'''', ''''NLS_CALENDAR=GREGORIAN''''))'', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRC_DET_COBRO');

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_DET_COBRO_IX'', ''H_PRC_DET_COBRO (DIA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRC_DET_COBRO');

    
    
    ------------------------------ TMP_H_PRC_DET_COBRO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_H_PRC_DET_COBRO'', 
                          ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              ASUNTO_ID NUMBER(16,0) NOT NULL,
                              CONTRATO_ID NUMBER(16,0)  ,
                              FECHA_COBRO DATE ,
                              FECHA_ASUNTO DATE ,
                              -- Dimensiones
                              TIPO_COBRO_DETALLE_ID NUMBER(16,0) ,
                              -- Metricas
                              NUM_COBROS INTEGER ,
                              IMPORTE_COBRO NUMBER(15,2) ,
                              NUM_DIAS_CREACION_ASU_COBRO INTEGER'', :error); END;';


    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_H_PRC_DET_COBRO');

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_PRC_DET_COBRO_IX'', ''TMP_H_PRC_DET_COBRO (DIA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_H_PRC_DET_COBRO');


    ------------------------------ H_PRC_DET_COBRO_SEMANA--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRC_DET_COBRO_SEMANA'', 
                          ''SEMANA_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              ASUNTO_ID NUMBER(16,0) NOT NULL,
                              CONTRATO_ID NUMBER(16,0)  ,
                              FECHA_COBRO DATE ,
                              FECHA_ASUNTO DATE ,
                              -- Dimensiones
                              TIPO_COBRO_DETALLE_ID NUMBER(16,0) ,
                              -- Metricas
                              NUM_COBROS INTEGER ,
                              IMPORTE_COBRO NUMBER(15,2) ,
                              NUM_DIAS_CREACION_ASU_COBRO INTEGER'', :error); END;';


    execute immediate V_SQL USING OUT error;
    
    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRC_DET_COBRO_SEMANA');


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_DET_COBRO_SEMANA_IX'', ''H_PRC_DET_COBRO_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRC_DET_COBRO_SEMANA');



    ------------------------------ H_PRC_DET_COBRO_MES--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRC_DET_COBRO_MES'', 
                          ''MES_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              ASUNTO_ID NUMBER(16,0) NOT NULL,
                              CONTRATO_ID NUMBER(16,0)  ,
                              FECHA_COBRO DATE ,
                              FECHA_ASUNTO DATE ,
                              -- Dimensiones
                              TIPO_COBRO_DETALLE_ID NUMBER(16,0) ,
                              -- Metricas
                              NUM_COBROS INTEGER ,
                              IMPORTE_COBRO NUMBER(15,2) ,
                              NUM_DIAS_CREACION_ASU_COBRO INTEGER'', :error); END;';


    execute immediate V_SQL USING OUT error;
    
    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRC_DET_COBRO_MES');


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_DET_COBRO_MES_IX'', ''H_PRC_DET_COBRO_MES (MES_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRC_DET_COBRO_MES');



    ------------------------------ H_PRC_DET_COBRO_TRIMESTRE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRC_DET_COBRO_TRIMESTRE'', 
                          ''TRIMESTRE_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              ASUNTO_ID NUMBER(16,0) NOT NULL,
                              CONTRATO_ID NUMBER(16,0)  ,
                              FECHA_COBRO DATE ,
                              FECHA_ASUNTO DATE ,
                              -- Dimensiones
                              TIPO_COBRO_DETALLE_ID NUMBER(16,0) ,
                              -- Metricas
                              NUM_COBROS INTEGER ,
                              IMPORTE_COBRO NUMBER(15,2) ,
                              NUM_DIAS_CREACION_ASU_COBRO INTEGER'', :error); END;';


    execute immediate V_SQL USING OUT error;
    
    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRC_DET_COBRO_TRIMESTRE');


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_DET_COBRO_TRIMESTRE_IX'', ''H_PRC_DET_COBRO_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRC_DET_COBRO_TRIMESTRE');



    ------------------------------ H_PRC_DET_COBRO_ANIO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRC_DET_COBRO_ANIO'', 
                          ''ANIO_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              ASUNTO_ID NUMBER(16,0) NOT NULL,
                              CONTRATO_ID NUMBER(16,0)  ,
                              FECHA_COBRO DATE ,
                              FECHA_ASUNTO DATE ,
                              -- Dimensiones
                              TIPO_COBRO_DETALLE_ID NUMBER(16,0) ,
                              -- Metricas
                              NUM_COBROS INTEGER ,
                              IMPORTE_COBRO NUMBER(15,2) ,
                              NUM_DIAS_CREACION_ASU_COBRO INTEGER'', :error); END;';


    execute immediate V_SQL USING OUT error;
    
    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRC_DET_COBRO_ANIO');
      
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_DET_COBRO_ANIO_IX'', ''H_PRC_DET_COBRO_ANIO (ANIO_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRC_DET_COBRO_ANIO');


    ------------------------------ H_PRC_DET_CONTRATO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRC_DET_CONTRATO'', 
                          ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              ASUNTO_ID NUMBER(16,0) NOT NULL,
                              CONTRATO_ID NUMBER(16,0),
                              -- Metricas
                              NUM_CONTRATOS_PROCEDIMIENTO INTEGER
                             )SEGMENT CREATION IMMEDIATE 


                          TABLESPACE "RECOVERY_BANKIA_DWH" 
                          PARTITION BY RANGE ("DIA_ID")
                          INTERVAL(NUMTOYMINTERVAL(1, ''''MONTH''''))
                          (PARTITION "p1" VALUES LESS THAN (TO_DATE('''' 2014-11-01 00:00:00'''', ''''SYYYY-MM-DD HH24:MI:SS'''', ''''NLS_CALENDAR=GREGORIAN''''))'', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRC_DET_CONTRATO');

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_DET_CONTRATO_IX'', ''H_PRC_DET_CONTRATO (DIA_ID, PROCEDIMIENTO_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRC_DET_CONTRATO');


    ------------------------------ TMP_H_PRC_DET_CONTRATO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_H_PRC_DET_CONTRATO'', 
                          ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              ASUNTO_ID NUMBER(16,0) NOT NULL,
                              CONTRATO_ID NUMBER(16,0),
                              -- Metricas
                              NUM_CONTRATOS_PROCEDIMIENTO INTEGER'', :error); END;';


    execute immediate V_SQL USING OUT error;
        
    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_H_PRC_DET_CONTRATO');

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_PRC_DET_CONTRATO_IX'', ''TMP_H_PRC_DET_CONTRATO (DIA_ID, PROCEDIMIENTO_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      
    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_H_PRC_DET_CONTRATO');

    
    ------------------------------ H_PRC_DET_CONTRATO_SEMANA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRC_DET_CONTRATO_SEMANA'', 
                          ''SEMANA_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              ASUNTO_ID NUMBER(16,0) NOT NULL,
                              CONTRATO_ID NUMBER(16,0),
                              -- Metricas
                              NUM_CONTRATOS_PROCEDIMIENTO INTEGER'', :error); END;';


    execute immediate V_SQL USING OUT error;
    
    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRC_DET_CONTRATO_SEMANA');

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_DET_CONTRATO_SEMANA_IX'', ''H_PRC_DET_CONTRATO_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRC_DET_CONTRATO_SEMANA');

    
    ------------------------------ H_PRC_DET_CONTRATO_MES --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRC_DET_CONTRATO_MES'', 
                          ''MES_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              ASUNTO_ID NUMBER(16,0) NOT NULL,
                              CONTRATO_ID NUMBER(16,0),
                              -- Metricas
                              NUM_CONTRATOS_PROCEDIMIENTO INTEGER'', :error); END;';


    execute immediate V_SQL USING OUT error;
    
    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRC_DET_CONTRATO_MES');

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_DET_CONTRATO_MES_IX'', ''H_PRC_DET_CONTRATO_MES (MES_ID, PROCEDIMIENTO_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRC_DET_CONTRATO_MES');


    ------------------------------ H_PRC_DET_CONTRATO_TRIMESTRE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRC_DET_CONTRATO_TRIMESTRE'', 
                          ''TRIMESTRE_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              ASUNTO_ID NUMBER(16,0) NOT NULL,
                              CONTRATO_ID NUMBER(16,0),
                              -- Metricas
                              NUM_CONTRATOS_PROCEDIMIENTO INTEGER'', :error); END;';


    execute immediate V_SQL USING OUT error;
    
    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRC_DET_CONTRATO_TRIMESTRE');

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_DET_CONTRATO_TRI_IX'', ''H_PRC_DET_CONTRATO_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRC_DET_CONTRATO_TRIMESTRE');


    ------------------------------ H_PRC_DET_CONTRATO_ANIO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRC_DET_CONTRATO_ANIO'', 
                          ''ANIO_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              ASUNTO_ID NUMBER(16,0) NOT NULL,
                              CONTRATO_ID NUMBER(16,0),
                              -- Metricas
                              NUM_CONTRATOS_PROCEDIMIENTO INTEGER'', :error); END;';


    execute immediate V_SQL USING OUT error;
    
    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRC_DET_CONTRATO_ANIO');

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_DET_CONTRATO_ANIO_IX'', ''H_PRC_DET_CONTRATO_ANIO (ANIO_ID, PROCEDIMIENTO_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRC_DET_CONTRATO_ANIO');

    
      ------------------------------ H_PRC_DET_ACUERDO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRC_DET_ACUERDO'', 
                          ''DIA_ID DATE NOT NULL ENABLE, 
                              FECHA_CARGA_DATOS DATE NOT NULL ENABLE, 
                              ACUERDO_ID NUMBER(16,0) NOT NULL ENABLE, 
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL ENABLE, 
                              FECHA_PROPUESTA DATE, 
                              TIPO_PROCEDIMIENTO_ID NUMBER(16,0), 
                              TIPO_ACUERDO_PRC_ID NUMBER(16,0), 
                              GESTOR_PRC_ID NUMBER(16,0), 
                              DESPACHO_GESTOR_PRC_ID NUMBER(16,0), 
                              TIPO_GESTOR_PRC_ID NUMBER(16,0),
                              TIPO_DESP_GESTOR_PRC_ID NUMBER(16,0),
                              ESTADO_ACUERDO_PRC_ID NUMBER(16,0), 
                              SUPERVISOR_PRC_ID NUMBER(16,0),  
                              IMPORTE_ACORDADO NUMBER(16,2), 
                              SALDO_IMPAGADO NUMBER(16,2),
                              SALDO_TOTAL NUMBER(16,2)'', :error); END;';


    execute immediate V_SQL USING OUT error;
      
    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRC_DET_ACUERDO');

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_DET_ACUERDO_IX'', ''H_PRC_DET_ACUERDO (DIA_ID, FECHA_PROPUESTA, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRC_DET_ACUERDO');

    
    ------------------------------ TMP_H_PRC_DET_ACUERDO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_H_PRC_DET_ACUERDO'', 
                          ''DIA_ID DATE NOT NULL ENABLE, 
                              FECHA_CARGA_DATOS DATE NOT NULL ENABLE, 
                              ACUERDO_ID NUMBER(16,0) NOT NULL ENABLE, 
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL ENABLE, 
                              FECHA_PROPUESTA DATE, 
                              TIPO_PROCEDIMIENTO_ID NUMBER(16,0), 
                              TIPO_ACUERDO_PRC_ID NUMBER(16,0), 
                              GESTOR_PRC_ID NUMBER(16,0), 
                              DESPACHO_GESTOR_PRC_ID NUMBER(16,0), 
                              TIPO_GESTOR_PRC_ID NUMBER(16,0),
                              TIPO_DESP_GESTOR_PRC_ID NUMBER(16,0),
                              ESTADO_ACUERDO_PRC_ID NUMBER(16,0), 
                              SUPERVISOR_PRC_ID NUMBER(16,0),  
                              IMPORTE_ACORDADO NUMBER(16,2), 
                              SALDO_IMPAGADO NUMBER(16,2),
                              SALDO_TOTAL NUMBER(16,2)'', :error); END;';


    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_H_PRC_DET_ACUERDO');

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_PRC_DET_ACUERDO_IX'', ''TMP_H_PRC_DET_ACUERDO (DIA_ID, FECHA_PROPUESTA, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_H_PRC_DET_ACUERDO');


   ------------------------------ H_PRC_DET_ACUERDO_SEMANA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRC_DET_ACUERDO_SEMANA'', 
                          ''SEMANA_ID DATE NOT NULL ENABLE, 
                              FECHA_CARGA_DATOS DATE NOT NULL ENABLE, 
                              ACUERDO_ID NUMBER(16,0) NOT NULL ENABLE, 
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL ENABLE, 
                              FECHA_PROPUESTA DATE, 
                              TIPO_PROCEDIMIENTO_ID NUMBER(16,0), 
                              TIPO_ACUERDO_PRC_ID NUMBER(16,0), 
                              GESTOR_PRC_ID NUMBER(16,0), 
                              DESPACHO_GESTOR_PRC_ID NUMBER(16,0), 
                              TIPO_GESTOR_PRC_ID NUMBER(16,0),
                              TIPO_DESP_GESTOR_PRC_ID NUMBER(16,0),
                              ESTADO_ACUERDO_PRC_ID NUMBER(16,0), 
                              SUPERVISOR_PRC_ID NUMBER(16,0),  
                              IMPORTE_ACORDADO NUMBER(16,2), 
                              SALDO_IMPAGADO NUMBER(16,2),
                              SALDO_TOTAL NUMBER(16,2)'', :error); END;';


    execute immediate V_SQL USING OUT error;
   
   DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRC_DET_ACUERDO_SEMANA');

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_DET_ACUERDO_SEMANA_IX'', ''H_PRC_DET_ACUERDO_SEMANA (SEMANA_ID, FECHA_PROPUESTA, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRC_DET_ACUERDO_SEMANA');

    
    ------------------------------ H_PRC_DET_ACUERDO_MES --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRC_DET_ACUERDO_MES'', 
                          ''MES_ID DATE NOT NULL ENABLE, 
                              FECHA_CARGA_DATOS DATE NOT NULL ENABLE, 
                              ACUERDO_ID NUMBER(16,0) NOT NULL ENABLE, 
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL ENABLE, 
                              FECHA_PROPUESTA DATE, 
                              TIPO_PROCEDIMIENTO_ID NUMBER(16,0), 
                              TIPO_ACUERDO_PRC_ID NUMBER(16,0), 
                              GESTOR_PRC_ID NUMBER(16,0), 
                              DESPACHO_GESTOR_PRC_ID NUMBER(16,0), 
                              TIPO_GESTOR_PRC_ID NUMBER(16,0),
                              TIPO_DESP_GESTOR_PRC_ID NUMBER(16,0),
                              ESTADO_ACUERDO_PRC_ID NUMBER(16,0), 
                              SUPERVISOR_PRC_ID NUMBER(16,0),  
                              IMPORTE_ACORDADO NUMBER(16,2), 
                              SALDO_IMPAGADO NUMBER(16,2),
                              SALDO_TOTAL NUMBER(16,2)'', :error); END;';


    execute immediate V_SQL USING OUT error;
    
   DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRC_DET_ACUERDO_MES');

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_DET_ACUERDO_MES_IX'', ''H_PRC_DET_ACUERDO_MES (MES_ID, FECHA_PROPUESTA, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRC_DET_ACUERDO_MES');

    
    ------------------------------ H_PRC_DET_ACUERDO_TRIMESTRE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRC_DET_ACUERDO_TRIMESTRE'', 
                          ''TRIMESTRE_ID DATE NOT NULL ENABLE, 
                              FECHA_CARGA_DATOS DATE NOT NULL ENABLE, 
                              ACUERDO_ID NUMBER(16,0) NOT NULL ENABLE, 
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL ENABLE, 
                              FECHA_PROPUESTA DATE, 
                              TIPO_PROCEDIMIENTO_ID NUMBER(16,0), 
                              TIPO_ACUERDO_PRC_ID NUMBER(16,0), 
                              GESTOR_PRC_ID NUMBER(16,0), 
                              DESPACHO_GESTOR_PRC_ID NUMBER(16,0), 
                              TIPO_GESTOR_PRC_ID NUMBER(16,0),
                              TIPO_DESP_GESTOR_PRC_ID NUMBER(16,0),
                              ESTADO_ACUERDO_PRC_ID NUMBER(16,0), 
                              SUPERVISOR_PRC_ID NUMBER(16,0),  
                              IMPORTE_ACORDADO NUMBER(16,2), 
                              SALDO_IMPAGADO NUMBER(16,2),
                              SALDO_TOTAL NUMBER(16,2)'', :error); END;';


    execute immediate V_SQL USING OUT error;

   DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRC_DET_ACUERDO_TRIMESTRE');

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_DET_ACUERDO_TRIMESTRE_IX'', ''H_PRC_DET_ACUERDO_TRIMESTRE (TRIMESTRE_ID, FECHA_PROPUESTA, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRC_DET_ACUERDO_TRIMESTRE');

    
    ------------------------------ H_PRC_DET_ACUERDO_ANIO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRC_DET_ACUERDO_ANIO'', 
                          ''ANIO_ID DATE NOT NULL ENABLE, 
                              FECHA_CARGA_DATOS DATE NOT NULL ENABLE, 
                              ACUERDO_ID NUMBER(16,0) NOT NULL ENABLE, 
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL ENABLE, 
                              FECHA_PROPUESTA DATE, 
                              TIPO_PROCEDIMIENTO_ID NUMBER(16,0), 
                              TIPO_ACUERDO_PRC_ID NUMBER(16,0), 
                              GESTOR_PRC_ID NUMBER(16,0), 
                              DESPACHO_GESTOR_PRC_ID NUMBER(16,0), 
                              TIPO_GESTOR_PRC_ID NUMBER(16,0),
                              TIPO_DESP_GESTOR_PRC_ID NUMBER(16,0),
                              ESTADO_ACUERDO_PRC_ID NUMBER(16,0), 
                              SUPERVISOR_PRC_ID NUMBER(16,0),  
                              IMPORTE_ACORDADO NUMBER(16,2), 
                              SALDO_IMPAGADO NUMBER(16,2),
                              SALDO_TOTAL NUMBER(16,2)'', :error); END;';


    execute immediate V_SQL USING OUT error;
    
    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRC_DET_ACUERDO_ANIO');

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_DET_ACUERDO_ANIO_IX'', ''H_PRC_DET_ACUERDO_ANIO (ANIO_ID, FECHA_PROPUESTA, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRC_DET_ACUERDO_ANIO');


    ------------------------------ TMP_PRC_CODIGO_PRIORIDAD --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_PRC_CODIGO_PRIORIDAD'', 
                          ''DD_TIPO_CODIGO VARCHAR2(50),
                              PRIORIDAD INTEGER'', :error); END;';


    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_PRC_CODIGO_PRIORIDAD');



    ------------------------------ TMP_PRC_JERARQUIA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_PRC_JERARQUIA'', 
                          ''DIA_ID DATE NOT NULL,
                              ITER NUMBER(16,0) NOT NULL,
                              FASE_ACTUAL NUMBER(16,0) ,
                              ULTIMA_FASE NUMBER(16,0) ,
                              ULT_TAR_CREADA NUMBER(16,0) ,
                              ULT_TAR_FIN NUMBER(16,0) ,
                              ULTIMA_TAREA_ACTUALIZADA NUMBER(16,0) ,
                              ULT_TAR_PEND NUMBER(16,0) ,
                              FECHA_ULT_TAR_CREADA TIMESTAMP ,
                              FECHA_ULT_TAR_FIN TIMESTAMP ,
                              FECHA_ULTIMA_TAREA_ACTUALIZADA TIMESTAMP  ,
                              FECHA_ULT_TAR_PEND TIMESTAMP  ,
                              FECHA_ACEPTACION DATE ,
                              FECHA_INTERPOSICION_DEMANDA DATE ,
                              FECHA_RECOGIDA_DOC_Y_ACEPT DATE ,
                              FECHA_REGISTRAR_TOMA_DECISION DATE ,
                              FECHA_RECEPCION_DOC_COMPLETA DATE ,
                              FECHA_ULTIMA_POSICION_VENCIDA DATE ,
                              FECHA_ULTIMA_ESTIMACION DATE ,
                              FECHA_PARALIZACION DATE,
                              FASE_MAX_PRIORIDAD NUMBER(16,0) ,
                              NIVEL NUMBER(2,0) ,
                              CONTEXTO varchar(300) ,
                              CODIGO_FASE_ACTUAL varchar(20) ,
                              PRIORIDAD_FASE INTEGER ,
                              PRIORIDAD_PROCEDIMIENTO INTEGER ,
                              CANCELADO_FASE INTEGER ,
                              CANCELADO_PROCEDIMIENTO INTEGER ,
                              ASU_ID NUMBER(16,0) ,
                              NUM_FASES INTEGER ,
                              NUM_CONTRATOS INTEGER ,
                              SALDO_VENCIDO NUMBER(14,2)  ,
                              SALDO_NO_VENCIDO NUMBER(14,2)  ,
                              SALDO_CONCURSOS_VENCIDO NUMBER(14,2)  ,           -- Saldo vencido de los contratos asociados a los demandados del procedimiento que actuan como 1er y 2o Titular
                              SALDO_CONCURSOS_NO_VENCIDO NUMBER(14,2)  ,        -- Saldo no vencido de los contratos asociados a los demandados del procedimiento que actuan como 1er y 2o Titular
                              INGRESOS_PENDIENTES_APLICAR NUMBER(14,2) ,
                              SUBTOTAL NUMBER(14,2)  ,
                              GARANTIA_CONTRATO NUMBER(16,0) ,
                              NUM_DIAS_VENCIDO INTEGER ,
                              CARTERA NUMBER(16,0) ,
                              FECHA_CONTABLE_LITIGIO DATE ,
                              TITULAR_PROCEDIMIENTO NUMBER(16,0),


                              FASE_PARALIZADA NUMBER(16,0), 
                              MOTIVO_PARALIZACION_ID NUMBER(16,0),
							  PRC_PARALIZADO_ID NUMBER(16,0) ,
                              FECHA_PARALIZACION DATE,
							  FECHA_FINALIZACION DATE,
                              FASE_FINALIZADA NUMBER(16,0), 
                              MOTIVO_FINALIZACION_ID  NUMBER(16,0)'', :error); END;';
    execute immediate V_SQL USING OUT error;





    


    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_PRC_JERARQUIA');

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_JERARQUIA_ITER_IX'', ''TMP_PRC_JERARQUIA (DIA_ID, ITER)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_JERARQUIA_FASE_ACT_IX'', ''TMP_PRC_JERARQUIA (DIA_ID, FASE_ACTUAL)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_JERARQUIA_ULT_FASE_IX'', ''TMP_PRC_JERARQUIA (DIA_ID, ULTIMA_FASE)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_PRC_JERARQUIA');

    ------------------------------ TMP_PRC_DETALLE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_PRC_DETALLE'', 
                          ''ITER NUMBER(16,0)  ,
                                  FASE_ACTUAL NUMBER(16,0) ,
                                  ULT_TAR_CREADA NUMBER(16,0) ,
                                  ULT_TAR_FIN NUMBER(16,0) ,
                                  ULTIMA_TAREA_ACTUALIZADA NUMBER(16,0) ,
                                  ULT_TAR_PEND NUMBER(16,0) ,
                                  FECHA_ULT_TAR_CREADA TIMESTAMP ,
                                  FECHA_ULT_TAR_FIN TIMESTAMP ,
                                  FECHA_ULTIMA_TAREA_ACTUALIZADA TIMESTAMP  ,
                                  FECHA_ULT_TAR_PEND TIMESTAMP  ,
                                  FECHA_ACEPTACION DATE ,
                                  FECHA_INTERPOSICION_DEMANDA DATE ,
                                  FECHA_RECOGIDA_DOC_Y_ACEPT DATE ,
                                  FECHA_REGISTRAR_TOMA_DECISION DATE ,
                                  FECHA_RECEPCION_DOC_COMPLETA DATE ,
                                  FECHA_ULTIMA_POSICION_VENCIDA DATE ,
                                  FECHA_ULTIMA_ESTIMACION DATE ,
                                  MAX_PRIORIDAD NUMBER(16,0) ,
                                  FASE_MAX_PRIORIDAD NUMBER(16,0) ,
                                  CANCELADO_FASE INTEGER ,
                                  NUM_FASES INTEGER ,
                                  CANCELADO_PROCEDIMIENTO INTEGER ,
                                  NUM_CONTRATOS INTEGER ,
                                  SALDO_VENCIDO NUMBER(14,2)  ,
                                  SALDO_NO_VENCIDO NUMBER(14,2)  ,
                                  SALDO_CONCURSOS_VENCIDO NUMBER(14,2)  ,       -- Saldo vencido de los contratos asociados a los demandados del procedimiento que actuan como 1er y 2o Titular
                                  SALDO_CONCURSOS_NO_VENCIDO NUMBER(14,2)  ,    -- Saldo no vencido de los contratos asociados a los demandados del procedimiento que actuan como 1er y 2o Titular
                                  INGRESOS_PENDIENTES_APLICAR NUMBER(14,2) ,
                                  SUBTOTAL NUMBER(14,2)  ,
                                  GARANTIA_CONTRATO NUMBER(16,0) ,
                                  NUM_DIAS_VENCIDO INTEGER ,
                                  CARTERA NUMBER(16,0) ,
                                  FECHA_CONTABLE_LITIGIO DATE ,
                                  TITULAR_PROCEDIMIENTO NUMBER(16,0)'', :error); END;';

    execute immediate V_SQL USING OUT error;
    
    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_PRC_DETALLE');

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_DETALLE_IX'', ''TMP_PRC_DETALLE (ITER)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_PRC_DETALLE');



    ------------------------------ TMP_PRC_TAREA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_PRC_TAREA'', 
                          ''ITER NUMBER(16,0) ,
                                  FASE NUMBER(16,0) ,
                                  TAREA NUMBER(16,0) ,
                                  FECHA_INI TIMESTAMP ,
                                  FECHA_FIN TIMESTAMP ,
                                  FECHA_PRORROGA TIMESTAMP ,
                                  FECHA_AUTO_PRORROGA TIMESTAMP ,
                                  FECHA_ACTUALIZACION TIMESTAMP,
                                  DESCRIPCION_TAREA VARCHAR(250) ,
                                  TAP_ID NUMBER(16,0) ,
                                  TEX_ID NUMBER(16,0) ,
                                  DESCRIPCION_FORMULARIO VARCHAR(250) ,         -- TEV_NOMBRE (TEV_TAREA_EXTERNA_VALOR)
                                  FECHA_FORMULARIO DATE                         -- TEV_VALOR (TEV_TAREA_EXTERNA_VALOR)'', :error); END;';

    execute immediate V_SQL USING OUT error;
    
    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_PRC_TAREA');

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_TAREA_IX'', ''TMP_PRC_TAREA (ITER, TAREA)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_PRC_TAREA');


   ------------------------------ TMP_PRC_AUTO_PRORROGAS --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_PRC_AUTO_PRORROGAS'', 
                          ''TAREA NUMBER(16,0),
                                  FECHA_AUTO_PRORROGA TIMESTAMP'', :error); END;';


    execute immediate V_SQL USING OUT error;
   
    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_PRC_AUTO_PRORROGAS');

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_AUTO_PRORROGAS_IX'', ''TMP_PRC_AUTO_PRORROGAS (TAREA)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_PRC_AUTO_PRORROGAS');


   ------------------------------ TMP_PRC_CONTRATO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_PRC_CONTRATO'', 
                          ''ITER NUMBER(16,0) ,
                                  CONTRATO NUMBER(16,0) ,
                                  CEX_ID NUMBER(16,0) ,
                                  MAX_MOV_ID NUMBER(16,0) ,
                                  SALDO_VENCIDO NUMBER(14,2)  ,                 -- Saldo vencido de los contratos asociados al procedimiento
                                  SALDO_NO_VENCIDO NUMBER(14,2)  ,              -- Saldo no vencido de los contratos asociados al procedimiento
                                  INGRESOS_PENDIENTES_APLICAR NUMBER(14,2) ,
                                  FECHA_POS_VENCIDA DATE ,
                                  GARANTIA_CONTRATO NUMBER(16,0) ,              -- Garantia del contrato
                                  NUM_DIAS_VENCIDO INTEGER ,
                                  CARTERA NUMBER(16,0) ,                        -- Cartera a la que pertenece el contrato (UGAS, SAREB o Compartida)
                                  FECHA_CONTABLE_LITIGIO DATE                   -- Fecha contable del litigio asociado al contrato'', :error); END;';


    execute immediate V_SQL USING OUT error;
   
    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_PRC_CONTRATO');

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_CONTRATO_IX'', ''TMP_PRC_CONTRATO (ITER, CONTRATO)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_CONTRATO_CEX_IX'', ''TMP_PRC_CONTRATO (CEX_ID, CONTRATO)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_PRC_CONTRATO');


   ------------------------------ TMP_PRC_CONCURSO_CONTRATO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_PRC_CONCURSO_CONTRATO'', 
                          ''ITER NUMBER(16,0) ,
                                  CONTRATO NUMBER(16,0),
                                  SALDO_CONCURSOS_VENCIDO NUMBER(14,2),
                                  SALDO_CONCURSOS_NO_VENCIDO NUMBER(14,2),
                                  DEMANDADO NUMBER(16,0)'', :error); END;';


    execute immediate V_SQL USING OUT error;
   
    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_PRC_CONCURSO_CONTRATO');


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_CONCURSO_CONTRATO_IX'', ''TMP_PRC_CONCURSO_CONTRATO (ITER, CONTRATO)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_PRC_CONCURSO_CONTRATO');



   ------------------------------ TMP_PRC_CARTERA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_PRC_CARTERA'', 
                          ''CONTRATO NUMBER(16,0'', :error); END;';



    execute immediate V_SQL USING OUT error;
   
    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_PRC_CARTERA');

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_CARTERA_IX'', ''TMP_PRC_CARTERA (CONTRATO)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_PRC_CARTERA');


   ------------------------------ TMP_PRC_FECHA_CONTABLE_LITIGIO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_PRC_FECHA_CONTABLE_LITIGIO'', 
                          ''CONTRATO NUMBER(16,0),
                                  FECHA_CONTABLE_LITIGIO  DATE'', :error); END;';


    execute immediate V_SQL USING OUT error;
   
    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_PRC_FECHA_CONTABLE_LITIGIO ');

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_FECHA_CONT_LIT_IX'', ''TMP_PRC_FECHA_CONTABLE_LITIGIO (CONTRATO)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_PRC_FECHA_CONTABLE_LITIGIO ');


   ------------------------------ TMP_PRC_TITULAR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_PRC_TITULAR'', 
                          ''PROCEDIMIENTO NUMBER(16,0),
                                  CONTRATO NUMBER(16,0),
                                  TITULAR_PROCEDIMIENTO NUMBER(16,0)'', :error); END;';

    execute immediate V_SQL USING OUT error;
   
    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_PRC_TITULAR');

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_TITULAR_IX'', ''TMP_PRC_TITULAR (PROCEDIMIENTO)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_PRC_TITULAR');


   ------------------------------ TMP_PRC_DEMANDADO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_PRC_DEMANDADO'', 
                          ''PROCEDIMIENTO NUMBER(16,0),
                                  CONTRATO NUMBER(16,0),
                                  DEMANDADO NUMBER(16,0)'', :error); END;';


    execute immediate V_SQL USING OUT error;
   
    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_PRC_DEMANDADO');

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_DEMANDADO_IX'', ''TMP_PRC_DEMANDADO (PROCEDIMIENTO, CONTRATO)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_PRC_DEMANDADO');


   ------------------------------ TMP_PRC_COBROS --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_PRC_COBROS'', 
                          ''FECHA_COBRO DATE,
                                  CONTRATO NUMBER(16,0),
                                  IMPORTE NUMBER(15,2),
                                  REFERENCIA NUMBER(16,0)'', :error); END;';


    execute immediate V_SQL USING OUT error;
   
    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_PRC_COBROS');

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_COBROS_IX'', ''TMP_PRC_COBROS (CONTRATO)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_PRC_COBROS');


   ------------------------------ TMP_PRC_ESTIMACION --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_PRC_ESTIMACION'', 
                          '' ITER NUMBER(16,0),
                                  FASE NUMBER(16,0),
                                  FECHA_ESTIMACION TIMESTAMP,
                                  IRG_CLAVE VARCHAR2(20),
                                  IRG_VALOR VARCHAR2(255)'', :error); END;';


    execute immediate V_SQL USING OUT error;
   
    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_PRC_ESTIMACION');

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_ESTIMACION_IX'', ''TMP_PRC_ESTIMACION (ITER)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_PRC_ESTIMACION');


   ------------------------------ TMP_PRC_EXTRAS_RECOVERY_BI --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_PRC_EXTRAS_RECOVERY_BI'', 
                          ''FECHA_VALOR DATE,
                                  TIPO_ENTIDAD NUMBER(16,0) DEFAULT NULL,
                                  UNIDAD_GESTION NUMBER(16,0) DEFAULT NULL,
                                  DD_IFB_ID NUMBER(16,0) DEFAULT NULL,
                                  VALOR VARCHAR2(50) DEFAULT NULL'', :error); END;';


    execute immediate V_SQL USING OUT error;
   
    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_PRC_EXTRAS_RECOVERY_BI');

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_EXTRAS_RECOVERY_BI_IX'', ''TMP_PRC_EXTRAS_RECOVERY_BI (FECHA_VALOR, UNIDAD_GESTION)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_PRC_EXTRAS_RECOVERY_BI');

    
    ------------------------------ TMP_PRC_DECISION --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_PRC_DECISION'', 
                          ''FASE_ACTUAL NUMBER(16,0), 
                           FASE_PARALIZADA NUMBER(16,0), 
                           FASE_FINALIZADA NUMBER(16,0), 
                           FECHA_HASTA DATE,
                           MOTIVO_PARALIZACION_ID NUMBER(16,0),

                               MOTIVO_FINALIZACION_ID  NUMBER(16,0),
							   FECHA_FINALIZACION TIMESTAMP(6)
'', :error); END;';
    execute immediate V_SQL USING OUT error;



    


    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_PRC_DECISION');

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_DECISION_IX'', ''TMP_PRC_DECISION (FASE_ACTUAL)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_PRC_DECISION');


    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;

  end;

END CREAR_H_PROCEDIMIENTO;

