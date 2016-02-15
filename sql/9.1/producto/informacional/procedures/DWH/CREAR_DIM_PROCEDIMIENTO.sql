create or replace PROCEDURE CREAR_DIM_PROCEDIMIENTO (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creacion: Mayo 2014
-- Responsable ultima modificacion: María Villanueva, PFS Group
-- Fecha ultima modificacion: 20/01/2016
-- Motivos del cambio: D_PRC_FINALIZADO Y D_PRC_MOTIVO_FINALIZACION
-- Cliente: Recovery BI PRODUCTO
--
-- Descripcion: Procedimiento almancenado que crea las tablas de la dimension Procedimiento
-- ===============================================================================================

-- -------------------------------------------- INDICE -------------------------------------------
-- DIMENSION PROCEDIMIENTO
    -- D_PRC_JUZGADO
    -- D_PRC_PLAZA
    -- D_PRC_TIPO_RECLAMACION
    -- D_PRC_TIPO_PROCEDIMIENTO_AGR
    -- D_PRC_TIPO_PROCEDIMIENTO
    -- D_PRC_TIPO_PROCEDIMIENTO_DET
    -- D_PRC_FASE_ACTUAL
    -- D_PRC_FASE_ACTUAL_DETALLE
    -- D_PRC_FASE_ANTERIOR
    -- D_PRC_FASE_ANTERIOR_DETALLE
    -- D_PRC_ESTADO_PROCEDIMIENTO
    -- D_PRC_ESTADO_FASE_ACTUAL
    -- D_PRC_ESTADO_FASE_ANTERIOR
    -- D_PRC_ULT_TAR_CREADA_TIPO
    -- D_PRC_ULT_TAR_CREADA_TIPO_DET
    -- D_PRC_ULT_TAR_CREADA_DESC
    -- D_PRC_ULT_TAR_FIN_TIPO
    -- D_PRC_ULT_TAR_FIN_TIPO_DET
    -- D_PRC_ULT_TAR_FIN_DESC
    -- D_PRC_ULT_TAR_ACT_TIPO
    -- D_PRC_ULT_TAR_ACT_TIPO_DET
    -- D_PRC_ULT_TAR_ACT_DESC
    -- D_PRC_ULT_TAR_PEND_TIPO
    -- D_PRC_ULT_TAR_PEND_TIPO_DET
    -- D_PRC_ULT_TAR_PEND_DESC
    -- D_PRC_DESPACHO_GESTOR
    -- D_PRC_TIPO_DESP_GESTOR
    -- D_PRC_GESTOR
    -- D_PRC_GESTOR_PRECONTENCIOSO
    -- D_PRC_GESTOR_EN_RECOVERY
    -- D_PRC_ENTIDAD_GESTOR
    -- D_PRC_NIVEL_DESP_GESTOR
    -- D_PRC_OFI_DESP_GESTOR
    -- D_PRC_PROV_DESP_GESTOR
    -- D_PRC_ZONA_DESP_GESTOR
    -- D_PRC_DESPACHO_SUPERVISOR
    -- D_PRC_TIPO_DESPACHO_SUPERVISOR
    -- D_PRC_SUPERVISOR
    -- D_PRC_ENTIDAD_SUPERVISOR
    -- D_PRC_NIVEL_DESP_SUPERVISOR
    -- D_PRC_OFI_DESP_SUPERVISOR
    -- D_PRC_PROV_DESP_SUPERVISOR
    -- D_PRC_ZONA_DESP_SUPERVISOR
    -- D_PRC_ULT_TAR_PEND_CUMPL
    -- D_PRC_ULT_TAR_FIN_CUMPL
    -- D_PRC_CNT_GARANTIA_REAL_ASOC
    -- D_PRC_COBRO_TIPO_DET
    -- D_PRC_COBRO_TIPO
    -- D_PRC_ACT_ESTIMACIONES
    -- D_PRC_CARTERA
    -- D_PRC_TITULAR
    -- D_PRC_ZONA_NIVEL_0
    -- D_PRC_ZONA_NIVEL_1
    -- D_PRC_ZONA_NIVEL_2
    -- D_PRC_ZONA_NIVEL_3
    -- D_PRC_ZONA_NIVEL_4
    -- D_PRC_ZONA_NIVEL_5
    -- D_PRC_ZONA_NIVEL_6
    -- D_PRC_ZONA_NIVEL_7
    -- D_PRC_ZONA_NIVEL_8
    -- D_PRC_ZONA_NIVEL_9
    -- D_PRC
    -- D_PRC_T_SALDO_TOTAL
    -- D_PRC_T_SALDO_RECUPERACION
    -- D_PRC_T_SALDO_TOTAL_CONCURSO
    -- D_PRC_TD_ULTIMA_ACTUALIZACION
    -- D_PRC_TD_CONTRATO_VENCIDO
    -- D_PRC_TD_CNT_VENC_CREACION_ASU
    -- D_PRC_TD_CREA_ASU_A_INTERP_DEM
    -- D_PRC_TD_CREACION_ASU_ACEPT
    -- D_PRC_TD_ACEPT_ASU_INTERP_DEM
    -- D_PRC_TD_CREA_ASU_REC_DOC_ACEP
    -- D_PRC_TD_REC_DOC_ACEPT_REG_TD
    -- D_PRC_TD_REC_DOC_ACEPT_REC_DC
    -- D_PRC_TD_AUTO_FC_DIA_ANALISIS
    -- D_PRC_TD_AUTO_FC_LIQUIDACION
    -- D_PRC_ESTADO_CONVENIO
    -- D_PRC_SEGUIMIENTO_CONVENIO
    -- D_PRC_T_PORCENTAJE_QUITA_CONV
    -- D_PRC_GARANTIA_CONCURSO
    -- D_PRC_TD_ID_DECL_RESOL_FIRME
    -- D_PRC_TD_ID_ORD_INI_APREMIO
    -- D_PRC_TD_ID_HIP_SUBASTA
    -- D_PRC_TD_SUB_SOL_SUB_CEL
    -- D_PRC_TD_SUB_CEL_CESION_REMATE
    -- D_PRC_FASE_SUBASTA_HIPOTECARIO
    -- D_PRC_ULT_TAR_FASE_HIP
    -- D_PRC_TD_ID_MON_DECRETO_FIN
    -- D_PRC_F_SUBASTA_EJEC_NOTARIAL
    -- TMP_PRC_GESTOR
    -- TMP_PRC_SUPERVISOR
    -- D_PRC_PARALIZADO
    -- D_PRC_MOTIVO_PARALIZACION
    -- D_PRC_FINALIZADO 
    -- D_PRC_MOTIVO_FINALIZACION
    -- D_PRC_TIPO_ACUERDO
    -- D_PRC_ESTADO_ACUERDO
    -- D_PRC_TIPO_GESTOR
    -- D_PRC_TD_CEL_ADJUDICACION
    -- D_PRC_TD_RECEP_DECRE_ADJUDICA
    -- D_PRC_FASE_ACTUAL_AGR
    -- D_PRC_FASE_SUBASTA_CONCURSAL
  
    -- Módulo Precontecioso:
    -- D_PRC_PROPIETARIO
    -- D_PRC_TIPO_PRE
    -- D_PRC_ESTADO_PREPARACION
    -- D_PRC_TIPO_PREPARACION    
    -- D_PRC_ESTADO_BUROFAX
    -- D_PRC_RESULTADO_BUROFAX
    -- D_PRC_TIPO_BUROFAX_ENVIO
    -- D_PRC_RESULT_BUROFAX_ENVIO
    -- D_PRC_TIPO_DOCUMENTO
    -- D_PRC_ESTADO_DOCUMENTO
    -- D_PRC_RESULTADO_SOLICITUD
    -- D_PRC_TIPO_ACTOR_SOLICITUD
    -- D_PRC_USUARIO_SOLICITUD
    -- D_PRC_LIQUIDACION_ESTADO
    -- D_PRC_MOTIVO_CANCELACION
    -- D_PRC_MOTIVO_SUBSANACION
    -- D_PRC_TRAMO_SUBSANACION
    -- D_PRC_TRAMO_AVANCE_DOCUMENTO
    -- D_PRC_TRAMO_AVANCE_LIQUIDACION
    -- D_PRC_TRAMO_AVANCE_BUROFAX
    -- D_PRC_ESTADO_DOCUMENTO_PER_ANT
    -- D_PRC_ESTADO_LIQ_PER_ANT
    -- D_PRC_ENT_CEDENTE
    -- D_PRC_PROP_SAREB

BEGIN

declare
  nCount NUMBER;
  V_SQL varchar2(16000); 
  V_NOMBRE VARCHAR2(50) := 'CREAR_DIM_PROCEDIMIENTO';

  begin

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;

    ------------------------------ D_PRC_JUZGADO --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_JUZGADO'', 
                          ''JUZGADO_ID NUMBER(16,0) NOT NULL,
                            JUZGADO_DESC VARCHAR2(250 CHAR),
                            JUZGADO_DESC_2 VARCHAR2(250 CHAR),
                            PLAZA_ID NUMBER(16,0) NULL,
                            PRIMARY KEY (JUZGADO_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_JUZGADO');
    

    ----------------------------- D_PRC_PLAZA --------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_PLAZA'', 
                          ''PLAZA_ID NUMBER(16,0) NOT NULL,
                            PLAZA_DESC VARCHAR2(50 CHAR),
                            PLAZA_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (PLAZA_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_PLAZA');
    

    ----------------------------- D_PRC_TIPO_RECLAMACION --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TIPO_RECLAMACION'', 
                          ''TIPO_RECLAMACION_ID NUMBER(16,0) NOT NULL,
                            TIPO_RECLAMACION_DESC VARCHAR2(50 CHAR),
                            TIPO_RECLAMACION_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_RECLAMACION_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TIPO_RECLAMACION');
    

    ----------------------------- D_PRC_TIPO_PROCEDIMIENTO_AGR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TIPO_PROCEDIMIENTO_AGR'', 
                          ''TIPO_PROCEDIMIENTO_AGR_ID NUMBER(16,0) NOT NULL,
                            TIPO_PROCEDIMIENTO_AGR_DESC VARCHAR2(50 CHAR),
                            TIPO_PROCEDIMIENTO_AGR_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_PROCEDIMIENTO_AGR_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TIPO_PROCEDIMIENTO_AGR');
    

    ----------------------------- D_PRC_TIPO_PROCEDIMIENTO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TIPO_PROCEDIMIENTO'', 
                          ''TIPO_PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                            TIPO_PROCEDIMIENTO_DESC VARCHAR2(50 CHAR),
                            TIPO_PROCEDIMIENTO_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_PROCEDIMIENTO_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TIPO_PROCEDIMIENTO');
    

    ----------------------------- D_PRC_TIPO_PROCEDIMIENTO_DET --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TIPO_PROCEDIMIENTO_DET'', 
                          ''TIPO_PROCEDIMIENTO_DET_ID NUMBER(16,0) NOT NULL,
                            TIPO_PROCEDIMIENTO_DET_DESC VARCHAR2(100 CHAR),
                            TIPO_PROCEDIMIENTO_DET_DESC_2 VARCHAR2(250 CHAR),
                            TIPO_PROCEDIMIENTO_ID NUMBER(16,0),
                            TIPO_PROCEDIMIENTO_AGR_ID NUMBER(16,0),
                            PRIMARY KEY (TIPO_PROCEDIMIENTO_DET_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TIPO_PROCEDIMIENTO_DET');
    

    ----------------------------- D_PRC_FASE_ACTUAL_AGR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_FASE_ACTUAL_AGR'', 
                          ''FASE_ACTUAL_AGR_ID NUMBER(16,0) NOT NULL,
                            FASE_ACTUAL_AGR_DESC VARCHAR2(50 CHAR),
                            FASE_ACTUAL_AGR_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (FASE_ACTUAL_AGR_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_FASE_ACTUAL_AGR');
    

    ----------------------------- D_PRC_FASE_ACTUAL --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_FASE_ACTUAL'', 
                          ''FASE_ACTUAL_ID NUMBER(16,0) NOT NULL,
                            FASE_ACTUAL_DESC VARCHAR2(50 CHAR),
                            FASE_ACTUAL_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (FASE_ACTUAL_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_FASE_ACTUAL');
    

    ----------------------------- D_PRC_FASE_ACTUAL_DETALLE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_FASE_ACTUAL_DETALLE'', 
                          ''FASE_ACTUAL_DETALLE_ID NUMBER(16,0) NOT NULL,
                            FASE_ACTUAL_DETALLE_DESC VARCHAR2(100 CHAR),
                            FASE_ACTUAL_DETALLE_DESC_2 VARCHAR2(250 CHAR),
                            FASE_ACTUAL_ID NUMBER(16,0),
                            FASE_ACTUAL_AGR_ID NUMBER(16,0),
                            PRIMARY KEY (FASE_ACTUAL_DETALLE_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_FASE_ACTUAL_DETALLE');
    

    ----------------------------- D_PRC_FASE_ANTERIOR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_FASE_ANTERIOR'', 
                          ''FASE_ANTERIOR_ID NUMBER(16,0) NOT NULL,
                            FASE_ANTERIOR_DESC VARCHAR2(50 CHAR),
                            FASE_ANTERIOR_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (FASE_ANTERIOR_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_FASE_ANTERIOR');
    

    ----------------------------- D_PRC_FASE_ANTERIOR_DETALLE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_FASE_ANTERIOR_DETALLE'', 
                          ''FASE_ANTERIOR_DETALLE_ID NUMBER(16,0) NOT NULL,
                            FASE_ANTERIOR_DETALLE_DESC VARCHAR2(100 CHAR),
                            FASE_ANTERIOR_DETALLE_DESC_2 VARCHAR2(250 CHAR),
                            FASE_ANTERIOR_ID NUMBER(16,0),
                            PRIMARY KEY (FASE_ANTERIOR_DETALLE_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_FASE_ANTERIOR_DETALLE');
    

    ----------------------------- D_PRC_ESTADO_PROCEDIMIENTO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ESTADO_PROCEDIMIENTO'', 
                          ''ESTADO_PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                            ESTADO_PROCEDIMIENTO_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (ESTADO_PROCEDIMIENTO_ID)'', 
                            :error); END;';
     execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ESTADO_PROCEDIMIENTO');
    

    ----------------------------- D_PRC_ESTADO_FASE_ACTUAL --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ESTADO_FASE_ACTUAL'', 
                          ''ESTADO_FASE_ACTUAL_ID NUMBER(16,0) NOT NULL,
                            ESTADO_FASE_ACTUAL_DESC VARCHAR2(50 CHAR),
                            ESTADO_FASE_ACTUAL_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (ESTADO_FASE_ACTUAL_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ESTADO_FASE_ACTUAL');
    

    ----------------------------- D_PRC_ESTADO_FASE_ANTERIOR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ESTADO_FASE_ANTERIOR'', 
                          ''ESTADO_FASE_ANTERIOR_ID NUMBER(16,0) NOT NULL,
                            ESTADO_FASE_ANTERIOR_DESC VARCHAR2(50 CHAR),
                            ESTADO_FASE_ANTERIOR_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (ESTADO_FASE_ANTERIOR_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ESTADO_FASE_ANTERIOR');
    

    ----------------------------- D_PRC_ULT_TAR_CREADA_TIPO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ULT_TAR_CREADA_TIPO'', 
                          ''ULT_TAR_CREADA_TIPO_ID NUMBER(16,0) NOT NULL,
                            ULT_TAR_CREADA_TIPO_DESC VARCHAR2(50 CHAR),
                            ULT_TAR_CREADA_TIPO_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (ULT_TAR_CREADA_TIPO_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ULT_TAR_CREADA_TIPO');
    

    ----------------------------- D_PRC_ULT_TAR_CREADA_TIPO_DET --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ULT_TAR_CREADA_TIPO_DET'', 
                          ''ULT_TAR_CREADA_TIPO_DET_ID NUMBER(16,0) NOT NULL,
                            ULT_TAR_CREADA_TIPO_DET_DESC VARCHAR2(250 CHAR),
                            ULT_TAR_CREADA_TIPO_DET_DESC_2 VARCHAR2(250 CHAR),
                            ULT_TAR_CREADA_TIPO_ID NUMBER(16,0),
                            PRIMARY KEY (ULT_TAR_CREADA_TIPO_DET_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ULT_TAR_CREADA_TIPO_DET');
    

    ----------------------------- D_PRC_ULT_TAR_CREADA_DESC --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ULT_TAR_CREADA_DESC'', 
                          ''ULT_TAR_CREADA_DESC_ID NUMBER(16,0) NOT NULL,
                            ULT_TAR_CREADA_DESC_DESC VARCHAR2(100 CHAR),
                            PRIMARY KEY (ULT_TAR_CREADA_DESC_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ULT_TAR_CREADA_DESC');
    

    ----------------------------- D_PRC_ULT_TAR_FIN_TIPO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ULT_TAR_FIN_TIPO'', 
                          ''ULT_TAR_FIN_TIPO_ID NUMBER(16,0) NOT NULL,
                            ULT_TAR_FIN_TIPO_DESC VARCHAR2(50 CHAR),
                            ULT_TAR_FIN_TIPO_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (ULT_TAR_FIN_TIPO_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ULT_TAR_FIN_TIPO');
    

    ----------------------------- D_PRC_ULT_TAR_FIN_TIPO_DET --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ULT_TAR_FIN_TIPO_DET'', 
                          ''ULT_TAR_FIN_TIPO_DET_ID NUMBER(16,0) NOT NULL,
                            ULT_TAR_FIN_TIPO_DET_DESC VARCHAR2(250 CHAR),
                            ULT_TAR_FIN_TIPO_DET_DESC_2 VARCHAR2(250 CHAR),
                            ULT_TAR_FIN_TIPO_ID NUMBER(16,0),
                            PRIMARY KEY (ULT_TAR_FIN_TIPO_DET_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ULT_TAR_FIN_TIPO_DET');
    

    ----------------------------- D_PRC_ULT_TAR_FIN_DESC --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ULT_TAR_FIN_DESC'', 
                          ''ULT_TAR_FIN_DESC_ID NUMBER(16,0) NOT NULL,
                            ULT_TAR_FIN_DESC_DESC VARCHAR2(100 CHAR),
                            PRIMARY KEY (ULT_TAR_FIN_DESC_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ULT_TAR_FIN_DESC');
    

    ----------------------------- D_PRC_ULT_TAR_ACT_TIPO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ULT_TAR_ACT_TIPO'', 
                          ''ULT_TAR_ACT_TIPO_ID NUMBER(16,0) NOT NULL,
                            ULT_TAR_ACT_TIPO_DESC VARCHAR2(50 CHAR),
                            ULT_TAR_ACT_TIPO_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (ULT_TAR_ACT_TIPO_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ULT_TAR_ACT_TIPO');
    

    ----------------------------- D_PRC_ULT_TAR_ACT_TIPO_DET --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ULT_TAR_ACT_TIPO_DET'', 
                          ''ULT_TAR_ACT_TIPO_DET_ID NUMBER(16,0) NOT NULL,
                            ULT_TAR_ACT_TIPO_DET_DESC VARCHAR2(250 CHAR),
                            ULT_TAR_ACT_TIPO_DET_DESC_2 VARCHAR2(250 CHAR),
                            ULT_TAR_ACT_TIPO_ID NUMBER(16,0),
                            PRIMARY KEY (ULT_TAR_ACT_TIPO_DET_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ULT_TAR_ACT_TIPO_DET');
    

    ----------------------------- D_PRC_ULT_TAR_ACT_DESC --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ULT_TAR_ACT_DESC'', 
                          ''ULT_TAR_ACT_DESC_ID NUMBER(16,0) NOT NULL,
                            ULT_TAR_ACT_DESC_DESC VARCHAR2(100 CHAR),
                            PRIMARY KEY (ULT_TAR_ACT_DESC_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ULT_TAR_ACT_DESC');
    

    ----------------------------- D_PRC_ULT_TAR_PEND_TIPO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ULT_TAR_PEND_TIPO'', 
                          ''ULT_TAR_PEND_TIPO_ID NUMBER(16,0) NOT NULL,
                            ULT_TAR_PEND_TIPO_DESC VARCHAR2(50 CHAR),
                            ULT_TAR_PEND_TIPO_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (ULT_TAR_PEND_TIPO_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ULT_TAR_PEND_TIPO');
    

    ----------------------------- D_PRC_ULT_TAR_PEND_TIPO_DET --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ULT_TAR_PEND_TIPO_DET'', 
                          ''ULT_TAR_PEND_TIPO_DET_ID NUMBER(16,0) NOT NULL,
                            ULT_TAR_PEND_TIPO_DET_DESC VARCHAR2(250 CHAR),
                            ULT_TAR_PEND_TIPO_DET_DESC_2 VARCHAR2(250 CHAR),
                            ULT_TAR_PEND_TIPO_ID NUMBER(16,0),
                            PRIMARY KEY (ULT_TAR_PEND_TIPO_DET_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ULT_TAR_PEND_TIPO_DET');
    

    ----------------------------- D_PRC_ULT_TAR_PEND_DESC --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ULT_TAR_PEND_DESC'', 
                          ''ULT_TAR_PEND_DESC_ID NUMBER(16,0) NOT NULL,
                            ULT_TAR_PEND_DESC_DESC VARCHAR2(100 CHAR),
                            PRIMARY KEY (ULT_TAR_PEND_DESC_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ULT_TAR_PEND_DESC');
    

    ----------------------------- D_PRC_DESPACHO_GESTOR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_DESPACHO_GESTOR'', 
                          ''DESPACHO_GESTOR_PRC_ID NUMBER(16,0) NOT NULL,
                            DESPACHO_GESTOR_PRC_DESC VARCHAR2(250 CHAR),
                            TIPO_DESP_GESTOR_PRC_ID NUMBER(16,0),
                            ZONA_DESP_GESTOR_PRC_ID NUMBER(16,0),
                            PRIMARY KEY (DESPACHO_GESTOR_PRC_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_DESPACHO_GESTOR');
    

    ----------------------------- D_PRC_TIPO_DESP_GESTOR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TIPO_DESP_GESTOR'', 
                          ''TIPO_DESP_GESTOR_PRC_ID NUMBER(16,0) NOT NULL,
                            TIPO_DESP_GESTOR_PRC_DESC VARCHAR2(50 CHAR),
                            TIPO_DESP_GESTOR_PRC_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_DESP_GESTOR_PRC_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TIPO_DESP_GESTOR');
    

    ----------------------------- D_PRC_GESTOR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_GESTOR'', 
                          ''GESTOR_PRC_ID NUMBER(16,0) NOT NULL,
                            GESTOR_PRC_NOMBRE_COMPLETO VARCHAR2(250),
                            GESTOR_PRC_NOMBRE VARCHAR2(250),
                            GESTOR_PRC_APELLIDO1 VARCHAR2(250),
                            GESTOR_PRC_APELLIDO2 VARCHAR2(250),
                            ENTIDAD_GESTOR_PRC_ID NUMBER(16,0),
                            DESPACHO_GESTOR_PRC_ID NUMBER(16,0),
                            GESTOR_EN_RECOVERY_PRC_ID NUMBER(16,0),
                            PRIMARY KEY (GESTOR_PRC_ID,DESPACHO_GESTOR_PRC_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_GESTOR');
    

    ----------------------------- D_PRC_GESTOR_PRECONTENCIOSO  --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_GESTOR_PRECONTENCIOSO'', 
                          ''GESTOR_PRE_ID NUMBER(16,0) NOT NULL,
                            GESTOR_PRE_NOMBRE_COMPLETO VARCHAR2(250),
                            GESTOR_PRE_NOMBRE VARCHAR2(250),
                            GESTOR_PRE_APELLIDO1 VARCHAR2(250),
                            GESTOR_PRE_APELLIDO2 VARCHAR2(250),
                            PRIMARY KEY (GESTOR_PRE_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_GESTOR_PRECONTENCIOSO');
    

    ----------------------------- D_PRC_GESTOR_EN_RECOVERY --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_GESTOR_EN_RECOVERY'', 
                          ''GESTOR_EN_RECOVERY_PRC_ID NUMBER(16,0) NOT NULL,
                            GESTOR_EN_RECOVERY_PRC_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (GESTOR_EN_RECOVERY_PRC_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_GESTOR_EN_RECOVERY');
    

    ----------------------------- D_PRC_ENTIDAD_GESTOR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ENTIDAD_GESTOR'', 
                          ''ENTIDAD_GESTOR_PRC_ID NUMBER(16,0) NOT NULL,
                            ENTIDAD_GESTOR_PRC_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (ENTIDAD_GESTOR_PRC_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ENTIDAD_GESTOR');
    

    ----------------------------- D_PRC_NIVEL_DESP_GESTOR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_NIVEL_DESP_GESTOR'', 
                          ''NIVEL_DESP_GESTOR_PRC_ID NUMBER(16,0) NOT NULL,
                            NIVEL_DESP_GESTOR_PRC_DESC VARCHAR2(50 CHAR),
                            NIVEL_DESP_GESTOR_PRC_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (NIVEL_DESP_GESTOR_PRC_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_NIVEL_DESP_GESTOR');
    

    ----------------------------- D_PRC_OFI_DESP_GESTOR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_OFI_DESP_GESTOR'', 
                          ''OFI_DESP_GESTOR_PRC_ID NUMBER(16,0) NOT NULL,
                            OFI_DESP_GESTOR_PRC_DESC VARCHAR2(50 CHAR),
                            OFI_DESP_GESTOR_PRC_DESC_2 VARCHAR2(250 CHAR),
                            PROV_DESP_GESTOR_PRC_ID NUMBER(16,0),
                            PRIMARY KEY (OFI_DESP_GESTOR_PRC_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_OFI_DESP_GESTOR');
    

    ----------------------------- D_PRC_PROV_DESP_GESTOR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_PROV_DESP_GESTOR'', 
                          ''PROV_DESP_GESTOR_PRC_ID NUMBER(16,0) NOT NULL,
                            PROV_DESP_GESTOR_PRC_DESC VARCHAR2(50 CHAR),
                            PROV_DESP_GESTOR_PRC_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (PROV_DESP_GESTOR_PRC_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_PROV_DESP_GESTOR');
    

    ----------------------------- D_PRC_ZONA_DESP_GESTOR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ZONA_DESP_GESTOR'', 
                          ''ZONA_DESP_GESTOR_PRC_ID NUMBER(16,0) NOT NULL,
                            ZONA_DESP_GESTOR_PRC_DESC VARCHAR2(50 CHAR),
                            ZONA_DESP_GESTOR_PRC_DESC_2 VARCHAR2(250 CHAR),
                            NIVEL_DESP_GESTOR_PRC_ID NUMBER(16,0),
                            OFI_DESP_GESTOR_PRC_ID NUMBER(16,0),
                            PRIMARY KEY (ZONA_DESP_GESTOR_PRC_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ZONA_DESP_GESTOR');
    

    ----------------------------- D_PRC_DESPACHO_SUPERVISOR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_DESPACHO_SUPERVISOR'', 
                          ''DESP_SUPER_PRC_ID NUMBER(16,0) NOT NULL,
                            DESP_SUPER_PRC_DESC VARCHAR2(250 CHAR),
                            TIPO_DESP_SUPER_PRC_ID NUMBER(16,0),
                            ZONA_DESP_SUPER_PRC_ID NUMBER(16,0),
                            PRIMARY KEY (DESP_SUPER_PRC_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_DESPACHO_SUPERVISOR');
    

    ----------------------------- D_PRC_TIPO_DESPACHO_SUPERVISOR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TIPO_DESPACHO_SUPERVISOR'', 
                          ''TIPO_DESP_SUPER_PRC_ID NUMBER(16,0) NOT NULL,
                            TIPO_DESP_SUPER_PRC_DESC VARCHAR2(50 CHAR),
                            TIPO_DESP_SUPER_PRC_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_DESP_SUPER_PRC_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TIPO_DESPACHO_SUPERVISOR');
    

    ----------------------------- D_PRC_SUPERVISOR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_SUPERVISOR'', 
                          ''SUPERVISOR_PRC_ID NUMBER(16,0) NOT NULL,
                            SUPERVISOR_PRC_NOMBRE_COMPLETO VARCHAR2(250 CHAR),
                            SUPERVISOR_PRC_NOMBRE VARCHAR2(250 CHAR),
                            SUPERVISOR_PRC_APELLIDO1 VARCHAR2(250 CHAR),
                            SUPERVISOR_PRC_APELLIDO2 VARCHAR2(250 CHAR),
                            ENTIDAD_SUPER_PRC_ID NUMBER(16,0),
                            DESP_SUPER_PRC_ID NUMBER(16,0),
                            PRIMARY KEY (SUPERVISOR_PRC_ID,DESP_SUPER_PRC_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_SUPERVISOR');
    

    ----------------------------- D_PRC_ENTIDAD_SUPERVISOR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ENTIDAD_SUPERVISOR'', 
                          ''ENTIDAD_SUPER_PRC_ID NUMBER(16,0) NOT NULL,
                            ENTIDAD_SUPER_PRC_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (ENTIDAD_SUPER_PRC_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ENTIDAD_SUPERVISOR');
    

    ----------------------------- D_PRC_NIVEL_DESP_SUPERVISOR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_NIVEL_DESP_SUPERVISOR'', 
                          ''NIVEL_DESP_SUPER_PRC_ID NUMBER(16,0) NOT NULL,
                            NIVEL_DESP_SUPER_PRC_DESC VARCHAR2(50 CHAR),
                            NIVEL_DESP_SUPER_PRC_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (NIVEL_DESP_SUPER_PRC_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_NIVEL_DESP_SUPERVISOR');
    

    ----------------------------- D_PRC_OFI_DESP_SUPERVISOR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_OFI_DESP_SUPERVISOR'', 
                          ''OFICINA_DESP_SUPER_PRC_ID NUMBER(16,0) NOT NULL,
                            OFICINA_DESP_SUPER_PRC_DESC VARCHAR2(50 CHAR),
                            OFICINA_DESP_SUPER_PRC_DESC_2 VARCHAR2(250 CHAR),
                            PROV_DESP_SUPER_PRC_ID NUMBER(16,0),
                            PRIMARY KEY (OFICINA_DESP_SUPER_PRC_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_OFI_DESP_SUPERVISOR');
    

    ----------------------------- D_PRC_PROV_DESP_SUPERVISOR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_PROV_DESP_SUPERVISOR'', 
                          ''PROV_DESP_SUPER_PRC_ID NUMBER(16,0) NOT NULL ,
                            PROV_DESP_SUPER_PRC_DESC VARCHAR2(50),
                            PROV_DESP_SUPER_PRC_DESC_2 VARCHAR2(250),
                            PRIMARY KEY (PROV_DESP_SUPER_PRC_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_PROV_DESP_SUPERVISOR');
    

    ----------------------------- D_PRC_ZONA_DESP_SUPERVISOR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ZONA_DESP_SUPERVISOR'', 
                          ''ZONA_DESP_SUPER_PRC_ID NUMBER(16,0) NOT NULL,
                            ZONA_DESP_SUPER_PRC_DESC VARCHAR2(50 CHAR),
                            ZONA_DESP_SUPER_PRC_DESC_2 VARCHAR2(250 CHAR),
                            NIVEL_DESP_SUPER_PRC_ID NUMBER(16,0),
                            OFICINA_DESP_SUPER_PRC_ID NUMBER(16,0),
                            PRIMARY KEY (ZONA_DESP_SUPER_PRC_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ZONA_DESP_SUPERVISOR');
    

    ----------------------------- D_PRC_ULT_TAR_PEND_CUMPL --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ULT_TAR_PEND_CUMPL'', 
                          ''CUMPLIMIENTO_ULT_TAR_PEND_ID NUMBER(16,0) NOT NULL,
                            CUMPLIMIENTO_ULT_TAR_PEND_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (CUMPLIMIENTO_ULT_TAR_PEND_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ULT_TAR_PEND_CUMPL');
    

    ----------------------------- D_PRC_ULT_TAR_FIN_CUMPL --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ULT_TAR_FIN_CUMPL'', 
                          ''CUMPLIMIENTO_ULT_TAR_FIN_ID NUMBER(16,0) NOT NULL,
                            CUMPLIMIENTO_ULT_TAR_FIN_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (CUMPLIMIENTO_ULT_TAR_FIN_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ULT_TAR_FIN_CUMPL');
    

    ----------------------------- D_PRC_CNT_GARANTIA_REAL_ASOC --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_CNT_GARANTIA_REAL_ASOC'', 
                          ''CNT_GARANTIA_REAL_ASOC_ID NUMBER(16,0) NOT NULL,
                            CNT_GARANTIA_REAL_ASOC_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (CNT_GARANTIA_REAL_ASOC_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_CNT_GARANTIA_REAL_ASOC');
    

    ----------------------------- D_PRC_COBRO_TIPO_DET --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_COBRO_TIPO_DET'', 
                          ''TIPO_COBRO_DETALLE_ID NUMBER(16,0) NOT NULL,
                            TIPO_COBRO_DETALLE_DESC VARCHAR2(50 CHAR),
                            TIPO_COBRO_ID NUMBER(16,0),
                            PRIMARY KEY (TIPO_COBRO_DETALLE_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_COBRO_TIPO_DET');
    

    ----------------------------- D_PRC_COBRO_TIPO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_COBRO_TIPO'', 
                          ''TIPO_COBRO_ID NUMBER(16,0) NOT NULL,
                            TIPO_COBRO_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (TIPO_COBRO_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_COBRO_TIPO');
    

    ----------------------------- D_PRC_ACT_ESTIMACIONES --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ACT_ESTIMACIONES'', 
                          ''ACT_ESTIMACIONES_ID NUMBER(16,0) NOT NULL,
                            ACT_ESTIMACIONES_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (ACT_ESTIMACIONES_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ACT_ESTIMACIONES ');
    

    ----------------------------- D_PRC_CARTERA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_CARTERA'', 
                          ''CARTERA_PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                            CARTERA_PROCEDIMIENTO_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (CARTERA_PROCEDIMIENTO_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_CARTERA');
    

    ----------------------------- D_PRC_TITULAR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TITULAR '', 
                          ''TITULAR_PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                            TITULAR_PROCEDIMIENTO_DESC NUMBER(16,0) NOT NULL,
                            DOCUMENTO_ID VARCHAR2(20),
                            NOMBRE VARCHAR2(100),
                            APELLIDO_1 VARCHAR2(100),
                            APELLIDO_2 VARCHAR2(100),
                            PRIMARY KEY (TITULAR_PROCEDIMIENTO_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TITULAR');
    

    ------------------------------ D_PRC_ZONA_NIVEL_0 --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ZONA_NIVEL_0'', 
                          ''ZONA_NIVEL_0_ID NUMBER(16,0) NOT NULL,
                            ZONA_NIVEL_0_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (ZONA_NIVEL_0_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ZONA_NIVEL_0');
    

    ------------------------------ D_PRC_ZONA_NIVEL_1 --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ZONA_NIVEL_1'', 
                          ''ZONA_NIVEL_1_ID NUMBER(16,0) NOT NULL,
                            ZONA_NIVEL_1_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (ZONA_NIVEL_1_ID)';
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ZONA_NIVEL_1');
    
    
    ------------------------------ D_PRC_ZONA_NIVEL_2 --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ZONA_NIVEL_2'', 
                          ''ZONA_NIVEL_2_ID NUMBER(16,0) NOT NULL,
                            ZONA_NIVEL_2_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (ZONA_NIVEL_2_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ZONA_NIVEL_2');
    

    ------------------------------ D_PRC_ZONA_NIVEL_3 --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ZONA_NIVEL_3'', 
                          ''ZONA_NIVEL_3_ID NUMBER(16,0) NOT NULL,
                            ZONA_NIVEL_3_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (ZONA_NIVEL_3_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ZONA_NIVEL_3');
    

    ------------------------------ D_PRC_ZONA_NIVEL_4 --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ZONA_NIVEL_4'', 
                          ''ZONA_NIVEL_4_ID NUMBER(16,0) NOT NULL,
                            ZONA_NIVEL_4_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (ZONA_NIVEL_4_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ZONA_NIVEL_4');
    

    ------------------------------ D_PRC_ZONA_NIVEL_5 --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ZONA_NIVEL_5'', 
                          ''ZONA_NIVEL_5_ID NUMBER(16,0) NOT NULL,
                            ZONA_NIVEL_5_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (ZONA_NIVEL_5_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ZONA_NIVEL_5');
    

    ------------------------------ D_PRC_ZONA_NIVEL_6 --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ZONA_NIVEL_6'', 
                          ''ZONA_NIVEL_6_ID NUMBER(16,0) NOT NULL,
                            ZONA_NIVEL_6_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (ZONA_NIVEL_6_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ZONA_NIVEL_6');
    

    ------------------------------ D_PRC_ZONA_NIVEL_7 --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ZONA_NIVEL_7'', 
                          ''ZONA_NIVEL_7_ID NUMBER(16,0) NOT NULL,
                            ZONA_NIVEL_7_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (ZONA_NIVEL_7_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ZONA_NIVEL_7');
    

    ------------------------------ D_PRC_ZONA_NIVEL_8 --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ZONA_NIVEL_8'', 
                          ''ZONA_NIVEL_8_ID NUMBER(16,0) NOT NULL,
                            ZONA_NIVEL_8_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (ZONA_NIVEL_8_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ZONA_NIVEL_8');
    

    ------------------------------ D_PRC_ZONA_NIVEL_9 --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ZONA_NIVEL_9'', 
                          ''ZONA_NIVEL_9_ID NUMBER(16,0) NOT NULL,
                            ZONA_NIVEL_9_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (ZONA_NIVEL_9_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ZONA_NIVEL_9');
    

    ----------------------------- D_PRC --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC'', 
                          ''PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                            NUMERO_AUTO VARCHAR2(50 CHAR),
                            ANIO_CODIGO_AUTO VARCHAR2(250 CHAR),
                            GESTOR_PRC_ID NUMBER(16,0),
                            SUPERVISOR_PRC_ID NUMBER(16,0),
                            ASUNTO_ID NUMBER(16,0),
                            JUZGADO_ID NUMBER(16,0),
                            TIPO_RECLAMACION_ID NUMBER(16,0),
                            ZONA_NIVEL_0_ID NUMBER(16,0) NULL,
                            ZONA_NIVEL_1_ID NUMBER(16,0) NULL,
                            ZONA_NIVEL_2_ID NUMBER(16,0) NULL,
                            ZONA_NIVEL_3_ID NUMBER(16,0) NULL,
                            ZONA_NIVEL_4_ID NUMBER(16,0) NULL,
                            ZONA_NIVEL_5_ID NUMBER(16,0) NULL,
                            ZONA_NIVEL_6_ID NUMBER(16,0) NULL,
                            ZONA_NIVEL_7_ID NUMBER(16,0) NULL,
                            ZONA_NIVEL_8_ID NUMBER(16,0) NULL,
                            ZONA_NIVEL_9_ID NUMBER(16,0) NULL,                            
                            PRIMARY KEY (PROCEDIMIENTO_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC');
    

    ----------------------------- D_PRC_T_SALDO_TOTAL --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_T_SALDO_TOTAL'', 
                          ''T_SALDO_TOTAL_PRC_ID NUMBER(16,0) NOT NULL,
                            T_SALDO_TOTAL_PRC_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (T_SALDO_TOTAL_PRC_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_T_SALDO_TOTAL');
    

    ----------------------------- D_PRC_T_SALDO_RECUPERACION --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_T_SALDO_RECUPERACION'', 
                          ''T_SALDO_RECUPERACION_PRC_ID NUMBER(16,0) NOT NULL,
                            T_SALDO_RECUPERACION_PRC_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (T_SALDO_RECUPERACION_PRC_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_T_SALDO_RECUPERACION');
    
    
    ----------------------------- D_PRC_T_SALDO_TOTAL_CONCURSO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_T_SALDO_TOTAL_CONCURSO'', 
                          ''T_SALDO_TOTAL_CONCURSO_ID NUMBER(16,0) NOT NULL,
                            T_SALDO_TOTAL_CONCURSO_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (T_SALDO_TOTAL_CONCURSO_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_T_SALDO_TOTAL_CONCURSO');
    

    ----------------------------- D_PRC_TD_ULTIMA_ACTUALIZACION --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TD_ULTIMA_ACTUALIZACION'', 
                          ''TD_ULT_ACTUALIZACION_PRC_ID NUMBER(16,0) NOT NULL,
                            TD_ULT_ACTUALIZACION_PRC_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (TD_ULT_ACTUALIZACION_PRC_ID)'',
                            :error); END;';
    execute immediate V_SQL USING OUT error;    
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TD_ULTIMA_ACTUALIZACION');
    

    ----------------------------- D_PRC_TD_CONTRATO_VENCIDO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TD_CONTRATO_VENCIDO'', 
                          ''TD_CONTRATO_VENCIDO_ID NUMBER(16,0) NOT NULL,
                            TD_CONTRATO_VENCIDO_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (TD_CONTRATO_VENCIDO_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TD_CONTRATO_VENCIDO');
    

    ----------------------------- D_PRC_TD_CNT_VENC_CREACION_ASU --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TD_CNT_VENC_CREACION_ASU'', 
                          ''TD_CNT_VENC_CREACION_ASU_ID NUMBER(16,0) NOT NULL,
                            TD_CNT_VENC_CREACION_ASU_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (TD_CNT_VENC_CREACION_ASU_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TD_CNT_VENC_CREACION_ASU');
    

    ----------------------------- D_PRC_TD_CREA_ASU_A_INTERP_DEM --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TD_CREA_ASU_A_INTERP_DEM'', 
                          ''TD_CREA_ASU_A_INTERP_DEM_ID NUMBER(16,0) NOT NULL,
                            TD_CREA_ASU_A_INTERP_DEM_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (TD_CREA_ASU_A_INTERP_DEM_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TD_CREA_ASU_A_INTERP_DEM');
    

    ----------------------------- D_PRC_TD_CREACION_ASU_ACEPT --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TD_CREACION_ASU_ACEPT'', 
                          ''TD_CREACION_ASU_ACEPT_ID NUMBER(16,0) NOT NULL,
                            TD_CREACION_ASU_ACEPT_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (TD_CREACION_ASU_ACEPT_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TD_CREACION_ASU_ACEPT');
    

    ----------------------------- D_PRC_TD_ACEPT_ASU_INTERP_DEM --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TD_ACEPT_ASU_INTERP_DEM'', 
                          ''TD_ACEPT_ASU_INTERP_DEM_ID NUMBER(16,0) NOT NULL,
                            TD_ACEPT_ASU_INTERP_DEM_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (TD_ACEPT_ASU_INTERP_DEM_ID)'',
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TD_ACEPT_ASU_INTERP_DEM');
    

    ----------------------------- D_PRC_TD_CREA_ASU_REC_DOC_ACEP --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TD_CREA_ASU_REC_DOC_ACEP'', 
                          ''TD_CREA_ASU_REC_DOC_ACEP_ID NUMBER(16,0) NOT NULL,
                            TD_CREA_ASU_REC_DOC_ACEP_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (TD_CREA_ASU_REC_DOC_ACEP_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TD_CREA_ASU_REC_DOC_ACEP');
    

    ----------------------------- D_PRC_TD_REC_DOC_ACEPT_REG_TD --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TD_REC_DOC_ACEPT_REG_TD'', 
                          ''TD_REC_DOC_ACEPT_REG_TD_ID NUMBER(16,0) NOT NULL,
                            TD_REC_DOC_ACEPT_REG_TD_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (TD_REC_DOC_ACEPT_REG_TD_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TD_REC_DOC_ACEPT_REG_TD');
    

    ----------------------------- D_PRC_TD_REC_DOC_ACEPT_REC_DC --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TD_REC_DOC_ACEPT_REC_DC'', 
                          ''TD_REC_DOC_ACEPT_REC_DC_ID NUMBER(16,0) NOT NULL,
                            TD_REC_DOC_ACEPT_REC_DC_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (TD_REC_DOC_ACEPT_REC_DC_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TD_REC_DOC_ACEPT_REC_DC');
    

    ----------------------------- D_PRC_TD_AUTO_FC_DIA_ANALISIS --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TD_AUTO_FC_DIA_ANALISIS'', 
                          ''TD_AUTO_FC_DIA_ANALISIS_ID NUMBER(16,0) NOT NULL,
                            TD_AUTO_FC_DIA_ANALISIS_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (TD_AUTO_FC_DIA_ANALISIS_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TD_AUTO_FC_DIA_ANALISIS');
    

    ----------------------------- D_PRC_TD_AUTO_FC_LIQUIDACION --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TD_AUTO_FC_LIQUIDACION'', 
                          ''TD_AUTO_FC_LIQUIDACION_ID NUMBER(16,0) NOT NULL,
                            TD_AUTO_FC_LIQUIDACION_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (TD_AUTO_FC_LIQUIDACION_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TD_AUTO_FC_LIQUIDACION');
    

    ----------------------------- D_PRC_ESTADO_CONVENIO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ESTADO_CONVENIO'', 
                          ''ESTADO_CONVENIO_ID NUMBER(16,0) NOT NULL,
                            ESTADO_CONVENIO_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (ESTADO_CONVENIO_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ESTADO_CONVENIO');
    

    ----------------------------- D_PRC_SEGUIMIENTO_CONVENIO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_SEGUIMIENTO_CONVENIO'', 
                          ''SEGUIMIENTO_CONVENIO_ID NUMBER(16,0) NOT NULL,
                            SEGUIMIENTO_CONVENIO_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (SEGUIMIENTO_CONVENIO_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_SEGUIMIENTO_CONVENIO');
    

    ----------------------------- D_PRC_T_PORCENTAJE_QUITA_CONV --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_T_PORCENTAJE_QUITA_CONV'', 
                          ''T_PORCENTAJE_QUITA_ID NUMBER(16,0) NOT NULL,
                            T_PORCENTAJE_QUITA_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (T_PORCENTAJE_QUITA_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_T_PORCENTAJE_QUITA_CONV');
    

    ----------------------------- D_PRC_GARANTIA_CONCURSO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_GARANTIA_CONCURSO'', 
                          ''GARANTIA_CONCURSO_ID NUMBER(16,0) NOT NULL,
                            GARANTIA_CONCURSO_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (GARANTIA_CONCURSO_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_GARANTIA_CONCURSO');
    

    ----------------------------- D_PRC_TD_ID_DECL_RESOL_FIRME --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TD_ID_DECL_RESOL_FIRME'', 
                          ''TD_ID_DECL_RESOL_FIRME_ID NUMBER(16,0) NOT NULL,
                            TD_ID_DECL_RESOL_FIRME_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (TD_ID_DECL_RESOL_FIRME_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TD_ID_DECL_RESOL_FIRME');
    

    ----------------------------- D_PRC_TD_ID_ORD_INI_APREMIO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TD_ID_ORD_INI_APREMIO'', 
                          ''TD_ID_ORD_INI_APREMIO_ID NUMBER(16,0) NOT NULL,
                            TD_ID_ORD_INI_APREMIO_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (TD_ID_ORD_INI_APREMIO_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TD_ID_ORD_INI_APREMIO');
    

    ----------------------------- D_PRC_TD_ID_HIP_SUBASTA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TD_ID_HIP_SUBASTA'', 
                          ''TD_ID_HIP_SUBASTA_ID NUMBER(16,0) NOT NULL,
                            TD_ID_HIP_SUBASTA_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (TD_ID_HIP_SUBASTA_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TD_ID_HIP_SUBASTA');
    

    ----------------------------- D_PRC_TD_SUB_SOL_SUB_CEL --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TD_SUB_SOL_SUB_CEL'', 
                          ''TD_SUB_SOL_SUB_CEL_ID NUMBER(16,0) NOT NULL,
                            TD_SUB_SOL_SUB_CEL_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (TD_SUB_SOL_SUB_CEL_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TD_SUB_SOL_SUB_CEL');
    

    ----------------------------- D_PRC_TD_SUB_CEL_CESION_REMATE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TD_SUB_CEL_CESION_REMATE'', 
                          ''TD_SUB_CEL_CESION_REMATE_ID NUMBER(16,0) NOT NULL,
                            TD_SUB_CEL_CESION_REMATE_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (TD_SUB_CEL_CESION_REMATE_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TD_SUB_CEL_CESION_REMATE');
    

    ----------------------------- D_PRC_TD_CEL_ADJUDICACION --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TD_CEL_ADJUDICACION'', 
                          ''TD_CEL_ADJUDICACION_ID NUMBER(16,0) NOT NULL,
                            TD_CEL_ADJUDICACION_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (TD_CEL_ADJUDICACION_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TD_CEL_ADJUDICACION');
    

    ----------------------------- D_PRC_TD_RECEP_DECRE_ADJUDICA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TD_RECEP_DECRE_ADJUDICA'', 
                          ''TD_RECEP_DECRE_ADJUDICA_ID NUMBER(16,0) NOT NULL,
                            TD_RECEP_DECRE_ADJUDICA_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (TD_RECEP_DECRE_ADJUDICA_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TD_RECEP_DECRE_ADJUDICA');
    

    ----------------------------- D_PRC_FASE_SUBASTA_HIPOTECARIO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_FASE_SUBASTA_HIPOTECARIO'', 
                          ''FASE_SUBASTA_HIPOTECARIO_ID NUMBER(16,0) NOT NULL,
                            FASE_SUBASTA_HIPOTECARIO_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (FASE_SUBASTA_HIPOTECARIO_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_FASE_SUBASTA_HIPOTECARIO');
    

    ----------------------------- D_PRC_ULT_TAR_FASE_HIP --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ULT_TAR_FASE_HIP'', 
                          ''ULT_TAR_FASE_HIP_ID NUMBER(16,0) NOT NULL,
                            ULT_TAR_FASE_HIP_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (ULT_TAR_FASE_HIP_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ULT_TAR_FASE_HIP');
    

    ----------------------------- D_PRC_TD_ID_MON_DECRETO_FIN --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TD_ID_MON_DECRETO_FIN'', 
                          ''TD_ID_MON_DECRETO_FIN_ID NUMBER(16,0) NOT NULL,
                            TD_ID_MON_DECRETO_FIN_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (TD_ID_MON_DECRETO_FIN_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TD_ID_MON_DECRETO_FIN');
    

     ----------------------------- D_PRC_F_SUBASTA_EJEC_NOTARIAL --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_F_SUBASTA_EJEC_NOTARIAL'', 
                          ''F_SUBASTA_EJEC_NOTARIAL_ID NUMBER(16,0) NOT NULL,
                            F_SUBASTA_EJEC_NOTARIAL_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (F_SUBASTA_EJEC_NOTARIAL_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_F_SUBASTA_EJEC_NOTARIAL');
    

    ----------------------------- TMP_PRC_GESTOR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_PRC_GESTOR'', 
                          ''PROCEDIMIENTO_ID NUMBER(16,0),
                            GESTOR_PRC_ID NUMBER(16,0)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_PRC_GESTOR');
    
V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_GESTOR_IX'', ''TMP_PRC_GESTOR (PROCEDIMIENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT error;
			
    

    ----------------------------- TMP_PRC_SUPERVISOR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_PRC_SUPERVISOR'', 
                          ''PROCEDIMIENTO_ID NUMBER(16,0),
                            SUPERVISOR_PRC_ID NUMBER(16,0)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_PRC_SUPERVISOR');
    
V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_SUPER_IX'', ''TMP_PRC_SUPERVISOR (PROCEDIMIENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT error;
    
    
     ----------------------------- D_PRC_PARALIZADO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_PARALIZADO'', 
                          ''PRC_PARALIZADO_ID NUMBER(16,0) NOT NULL,
                            PRC_PARALIZADO_DESC VARCHAR2(20 CHAR),
                            PRIMARY KEY (PRC_PARALIZADO_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_PARALIZADO');

     ----------------------------- D_PRC_FINALIZADO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_FINALIZADO'', 
                          ''PRC_FINALIZADO_ID NUMBER(16,0) NOT NULL,
                            PRC_FINALIZADO_DESC VARCHAR2(20 CHAR),
                            PRIMARY KEY (PRC_FINALIZADO_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_FINALIZADO');
    
    

        ----------------------------- D_PRC_MOTIVO_PARALIZACION --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_MOTIVO_PARALIZACION'', 
                          ''MOTIVO_PARALIZACION_ID NUMBER(16,0) NOT NULL,
                            MOTIVO_PARALIZACION_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (MOTIVO_PARALIZACION_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_MOTIVO_PARALIZACION');


        ----------------------------- D_PRC_MOTIVO_FINALIZACION --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_MOTIVO_FINALIZACION'', 
                          ''MOTIVO_FINALIZACION_ID NUMBER(16,0) NOT NULL,
                            MOTIVO_FINALIZACION_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (MOTIVO_FINALIZACION_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_MOTIVO_FINALIZACION');
    

      ----------------------------- D_PRC_TIPO_ACUERDO -------------------------- 
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TIPO_ACUERDO'', 
                          ''TIPO_ACUERDO_PRC_ID NUMBER(16,0) NOT NULL,
                        TIPO_ACUERDO_PRC_DESC VARCHAR2(50 CHAR),
                        TIPO_ACUERDO_PRC_DESC_2 VARCHAR2(250 CHAR),
                        PRIMARY KEY (TIPO_ACUERDO_PRC_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
  DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ACUERDO_TIPO');



----------------------------- D_PRC_ESTADO_ACUERDO --------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ESTADO_ACUERDO'', 
                          ''ESTADO_ACUERDO_PRC_ID NUMBER(16,0) NOT NULL,
                        ESTADO_ACUERDO_PRC_DESC VARCHAR2(50 CHAR),
                        ESTADO_ACUERDO_PRC_DESC_2 VARCHAR2(250 CHAR),
                        PRIMARY KEY (ESTADO_ACUERDO_PRC_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
  DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ESTADO_ACUERDO');

   
   
    ------------------------------ D_PRC_TIPO_GESTOR--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TIPO_GESTOR'', 
                          ''TIPO_GESTOR_PRC_ID NUMBER(16,0) NOT NULL,
                            TIPO_GESTOR_PRC_DESC VARCHAR2(50 CHAR),
                            TIPO_GESTOR_PRC_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_GESTOR_PRC_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TIPO_GESTOR');
    
	
	----------------------------- D_PRC_FASE_SUBASTA_CONCURSAL --------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_FASE_SUBASTA_CONCURSAL'', 
                          ''FASE_SUBASTA_CONCURSAL_ID NUMBER(16,0) NOT NULL,
							FASE_SUBASTA_CONCURSAL_DESC VARCHAR2(250 CHAR),
							PRIMARY KEY (FASE_SUBASTA_CONCURSAL_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
	  DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_FASE_SUBASTA_CONCURSAL');
	
  
    ------------------------------ D_PRC_PROPIETARIO--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_PROPIETARIO'', 
                          ''PROPIETARIO_PRC_ID NUMBER(16,0) NOT NULL,
                            PROPIETARIO_PRC_DESC VARCHAR2(50 CHAR),
                            PROPIETARIO_PRC_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (PROPIETARIO_PRC_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_PROPIETARIO');
        
      
    ------------------------------ D_PRC_TIPO_PRE--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TIPO_PRE'', 
                          ''TIPO_PROCEDIMIENTO_PRE_ID NUMBER(16,0) NOT NULL,
                            TIPO_PROCEDIMIENTO_PRE_DESC VARCHAR2(100 CHAR),
                            TIPO_PROCEDIMIENTO_PRE_DESC_2 VARCHAR2(250 CHAR),
                            TIPO_PRE_AGR_ID NUMBER(16,0) NULL,
                            PRIMARY KEY (TIPO_PROCEDIMIENTO_PRE_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TIPO_PRE');
        

    ------------------------------ D_PRC_TIPO_PRE_AGR--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TIPO_PRE_AGR'', 
                          ''TIPO_PRE_AGR_ID NUMBER(16,0) NOT NULL,
                            TIPO_PRE_AGR_DESC VARCHAR2(100 CHAR),
                            TIPO_PRE_AGR_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_PRE_AGR_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TIPO_PRE_AGR');
        
    

    ------------------------------ D_PRC_ESTADO_PREPARACION--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ESTADO_PREPARACION'', 
                          ''ESTADO_PREPARACION_ID NUMBER(16,0) NOT NULL,
                            ESTADO_PREPARACION_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (ESTADO_PREPARACION_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ESTADO_PREPARACION');
       

    ------------------------------ D_PRC_TIPO_PREPARACION--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TIPO_PREPARACION'', 
                          ''TIPO_PREPARACION_ID NUMBER(16,0) NOT NULL,
                            TIPO_PREPARACION_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (TIPO_PREPARACION_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TIPO_PREPARACION');
    
    
    ------------------------------ D_PRC_ESTADO_BUROFAX--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ESTADO_BUROFAX'', 
                          ''ESTADO_BUROFAX_ID NUMBER(16,0) NOT NULL,
                            ESTADO_BUROFAX_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (ESTADO_BUROFAX_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ESTADO_BUROFAX');
    
    
    ------------------------------ D_PRC_RESULTADO_BUROFAX--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_RESULTADO_BUROFAX'', 
                          ''RESULTADO_BUROFAX_ID NUMBER(16,0) NOT NULL,
                            RESULTADO_BUROFAX_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (RESULTADO_BUROFAX_ID)'', 
                            :error); END;';
        execute immediate V_SQL USING OUT error;                        
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_RESULTADO_BUROFAX');
        
        

    ------------------------------ D_PRC_TIPO_BUROFAX_ENVIO--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TIPO_BUROFAX_ENVIO'', 
                          ''TIPO_BUROFAX_ENVIO_ID NUMBER(16,0) NOT NULL,
                            TIPO_BUROFAX_ENVIO_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (TIPO_BUROFAX_ENVIO_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TIPO_BUROFAX_ENVIO');
        

    ------------------------------ D_PRC_RESULT_BUROFAX_ENVIO--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_RESULT_BUROFAX_ENVIO'', 
                          ''RESULTADO_BUROFAX_ENVIO_ID NUMBER(16,0) NOT NULL,
                            RESULTADO_BUROFAX_ENVIO_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (RESULTADO_BUROFAX_ENVIO_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_RESULT_BUROFAX_ENVIO');
        

    ------------------------------ D_PRC_TIPO_DOCUMENTO--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TIPO_DOCUMENTO'', 
                          ''TIPO_DOCUMENTO_ID NUMBER(16,0) NOT NULL,
                            TIPO_DOCUMENTO_DESC VARCHAR2(150 CHAR),
                            TIPO_DOCUMENTO_DESC_2 VARCHAR2(200 CHAR),
                            PRIMARY KEY (TIPO_DOCUMENTO_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TIPO_DOCUMENTO');
        

------------------------------ D_PRC_ESTADO_DOCUMENTO--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ESTADO_DOCUMENTO'', 
                          ''ESTADO_DOCUMENTO_ID NUMBER(16,0) NOT NULL,
                            ESTADO_DOCUMENTO_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (ESTADO_DOCUMENTO_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ESTADO_DOCUMENTO');
	  

        

    ------------------------------ D_PRC_RESULTADO_SOLICITUD--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_RESULTADO_SOLICITUD'', 
                          ''RESULTADO_SOLICITUD_ID NUMBER(16,0) NOT NULL,
                            RESULTADO_SOLICITUD_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (RESULTADO_SOLICITUD_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_RESULTADO_SOLICITUD');
        
    
        ------------------------------ D_PRC_TIPO_ACTOR_SOLICITUD--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TIPO_ACTOR_SOLICITUD'', 
                          ''TIPO_ACTOR_SOLICITUD_ID NUMBER(16,0) NOT NULL,
                            TIPO_ACTOR_SOLICITUD_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (TIPO_ACTOR_SOLICITUD_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TIPO_ACTOR_SOLICITUD');
        
    
    ------------------------------ D_PRC_USUARIO_SOLICITUD--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_USUARIO_SOLICITUD'', 
                          ''USUARIO_SOLICITUD_ID NUMBER(16,0) NOT NULL,
                            USUARIO_SOLICITUD_NOMBRE VARCHAR2(50 CHAR),
                            USUARIO_SOLICITUD_APELLIDO1 VARCHAR2(50 CHAR),
                            USUARIO_SOLICITUD_APELLIDO2 VARCHAR2(50 CHAR),
                            PRIMARY KEY (USUARIO_SOLICITUD_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_USUARIO_SOLICITUD');
        
    
    ------------------------------ D_PRC_LIQUIDACION_ESTADO--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_LIQUIDACION_ESTADO'', 
                          ''ESTADO_LIQUIDACION_ID NUMBER(16,0) NOT NULL,
                            ESTADO_LIQUIDACION_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (ESTADO_LIQUIDACION_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_LIQUIDACION_ESTADO');
     
    
    
    ------------------------------ D_PRC_MOTIVO_CANCELACION--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_MOTIVO_CANCELACION'', 
                          ''MOTIVO_CANCELACION_ID NUMBER(16,0) NOT NULL,
                            MOTIVO_CANCELACION_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (MOTIVO_CANCELACION_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_MOTIVO_CANCELACION');
     
    
    ------------------------------ D_PRC_MOTIVO_SUBSANACION--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_MOTIVO_SUBSANACION'', 
                          ''MOTIVO_SUBSANACION_ID NUMBER(16,0) NOT NULL,
                            MOTIVO_SUBSANACION_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (MOTIVO_SUBSANACION_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_MOTIVO_SUBSANACION');
     
    
    ------------------------------ D_PRC_TRAMO_SUBSANACION--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TRAMO_SUBSANACION'', 
                          ''TRAMO_SUBSANACION_ID NUMBER(16,0) NOT NULL,
                            TRAMO_SUBSANACION_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (TRAMO_SUBSANACION_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TRAMO_SUBSANACION');
     
    
    ------------------------------ D_PRC_TRAMO_AVANCE_DOCUMENTO--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TRAMO_AVANCE_DOCUMENTO'', 
                          ''TRAMO_AVANCE_DOCUMENTO_ID NUMBER(16,0) NOT NULL,
                            TRAMO_AVANCE_DOCUMENTO_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (TRAMO_AVANCE_DOCUMENTO_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TRAMO_AVANCE_DOCUMENTO');
     

    ------------------------------ D_PRC_TRAMO_AVANCE_LIQUIDACION--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TRAMO_AVANCE_LIQUIDACION'', 
                          ''TRAMO_AVANCE_LIQUIDACION_ID NUMBER(16,0) NOT NULL,
                            TRAMO_AVANCE_LIQUIDACION_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (TRAMO_AVANCE_LIQUIDACION_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TRAMO_AVANCE_LIQUIDACION');
     
    
    ------------------------------ D_PRC_TRAMO_AVANCE_BUROFAX--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_TRAMO_AVANCE_BUROFAX'', 
                          ''TRAMO_AVANCE_BUROFAX_ID NUMBER(16,0) NOT NULL,
                            TRAMO_AVANCE_BUROFAX_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (TRAMO_AVANCE_BUROFAX_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_TRAMO_AVANCE_BUROFAX');
     

    ------------------------------ D_PRC_ESTADO_DOCUMENTO_PER_ANT--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ESTADO_DOCUMENTO_PER_ANT'', 
                          ''ESTADO_DOCUMENTO_PER_ANT_ID NUMBER(16,0) NOT NULL,
                            ESTADO_DOCUMENTO_PER_ANT_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (ESTADO_DOCUMENTO_PER_ANT_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ESTADO_DOCUMENTO_PER_ANT');
     
    

    ------------------------------ D_PRC_ESTADO_LIQ_PER_ANT--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ESTADO_LIQ_PER_ANT'', 
                          ''ESTADO_LIQ_PER_ANT_ID NUMBER(16,0) NOT NULL,
                            ESTADO_LIQ_PER_ANT_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (ESTADO_LIQ_PER_ANT_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ESTADO_LIQ_PER_ANT');
     
    
    ------------------------------ D_PRC_ENT_CEDENTE--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_ENT_CEDENTE'', 
                          ''ENT_CEDENTE_ID NUMBER(16,0) NOT NULL,
                            ENT_CEDENTE_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (ENT_CEDENTE_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_ENT_CEDENTE');
        
	
    ------------------------------ D_PRC_PROP_SAREB--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PRC_PROP_SAREB'', 
                          ''PROP_SAREB_ID NUMBER(16,0) NOT NULL,
                            PROP_SAREB_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (PROP_SAREB_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PRC_PROP_SAREB');
        
    
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;

 end;

END CREAR_DIM_PROCEDIMIENTO;
