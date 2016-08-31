create or replace PROCEDURE CREAR_DIM_SUBASTA (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Rafael Aracil, PFS Group
-- Fecha creacion: Agosto 2015
-- Responsable ultima modificacion: Pedro S., PFS Group
-- Fecha ultima modificacion: 25/04/2016
-- Motivos del cambio: Parametrización índices con esquema indices
-- Cliente: Recovery BI PRODUCTO
--
-- Descripcion: Procedimiento almancenado que carga las tablas de la dimension SUBASTA.
-- ===============================================================================================

-- -------------------------------------------- INDICE -------------------------------------------
-- DIMENSION SUBASTA
    -- D_SUB
    -- D_SUB_LOTE
    -- D_SUB_TIPO_SUBASTA
    -- D_SUB_ESTADO_SUBASTA
    -- D_SUB_MOTIVO_SUSPEN
    -- D_SUB_SUBMOTIVO_SUSPEN
    -- D_SUB_MOTIVO_CANCEL
    -- D_SUB_TIPO_ADJUDICACION
    -- D_SUB_TD_SENYALAMIENTO_SOLIC
    -- D_SUB_TD_SENYALAMIENTO_ANUNC
    -- D_SUB_TD_ANUNCIO_SOLICITUD

BEGIN
  declare
  nCount NUMBER;
  V_SQL varchar2(16000); 
  V_NOMBRE VARCHAR2(50) := 'CREAR_DIM_SUBASTA';
  
  begin
  
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
    
    ------------------------------ D_SUB --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_SUB'', 
                          ''SUBASTA_ID NUMBER(16,0) NOT NULL ENABLE,
                            SUBASTA_DESC VARCHAR2(50 CHAR),
                            SUBASTA_DESC_2 VARCHAR2(250 CHAR)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
	
 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_SUB_PK'', ''D_SUB (SUBASTA_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_SUB_LOTE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_SUB_LOTE'', 
                          ''LOTE_ID NUMBER(16,0) NOT NULL ENABLE,
                            LOTE_DESC VARCHAR2(50 CHAR),
                            LOTE_DESC_2 VARCHAR2(250 CHAR)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;

 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_SUB_LOTE_PK'', ''D_SUB_LOTE (LOTE_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
	
    ------------------------------ D_SUB_TIPO_SUBASTA--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_SUB_TIPO_SUBASTA'', 
                          ''TIPO_SUBASTA_ID NUMBER(16,0) NOT NULL ENABLE,
                            TIPO_SUBASTA_DESC VARCHAR2(50 CHAR),
                            TIPO_SUBASTA_DESC_2 VARCHAR2(250 CHAR)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;

 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_SUB_TIPO_SUBASTA_PK'', ''D_SUB_TIPO_SUBASTA (TIPO_SUBASTA_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
	
    ------------------------------ D_SUB_ESTADO_SUBASTA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_SUB_ESTADO_SUBASTA'', 
                          ''ESTADO_SUBASTA_ID NUMBER(16,0) NOT NULL ENABLE,
                            ESTADO_SUBASTA_DESC VARCHAR2(50 CHAR),
                            ESTADO_SUBASTA_DESC_2 VARCHAR2(250 CHAR)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;

 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_SUB_ESTADO_SUBASTA_PK'', ''D_SUB_ESTADO_SUBASTA (ESTADO_SUBASTA_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
	
    ------------------------------ D_SUB_MOTIVO_SUSPEN  --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_SUB_MOTIVO_SUSPEN'', 
                          ''MOTIVO_SUSPEN_ID NUMBER(16,0) NOT NULL ENABLE,
                            MOTIVO_SUSPEN_DESC VARCHAR2(50 CHAR),
                            MOTIVO_SUSPEN_DESC_2 VARCHAR2(250 CHAR)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;

 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_SUB_MOTIVO_SUSPEN_PK'', ''D_SUB_MOTIVO_SUSPEN (MOTIVO_SUSPEN_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
	
    ------------------------------ D_SUB_SUBMOTIVO_SUSPEN --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_SUB_SUBMOTIVO_SUSPEN'', 
                          ''SUBMOTIVO_SUSPEN_ID NUMBER(16,0) NOT NULL ENABLE,
                            SUBMOTIVO_SUSPEN_DESC VARCHAR2(50 CHAR),
                            SUBMOTIVO_SUSPEN_DESC_2 VARCHAR2(250 CHAR)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;

 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_SUB_SUBMOTIVO_SUSPEN_PK'', ''D_SUB_SUBMOTIVO_SUSPEN (SUBMOTIVO_SUSPEN_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
	
    ------------------------------ D_SUB_MOTIVO_CANCEL --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_SUB_MOTIVO_CANCEL'', 
                          ''MOTIVO_CANCEL_ID NUMBER(16,0) NOT NULL ENABLE,
                            MOTIVO_CANCEL_DESC VARCHAR2(50 CHAR),
                            MOTIVO_CANCEL_DESC_2 VARCHAR2(250 CHAR)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;

 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_SUB_MOTIVO_CANCEL_PK'', ''D_SUB_MOTIVO_CANCEL (MOTIVO_CANCEL_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
	
    ------------------------------ D_SUB_TIPO_ADJUDICACION --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_SUB_TIPO_ADJUDICACION'', 
                          ''TIPO_ADJUDICACION_ID NUMBER(16,0) NOT NULL ENABLE,
                            TIPO_ADJUDICACION_DESC VARCHAR2(50 CHAR),
                            TIPO_ADJUDICACION_DESC_2 VARCHAR2(250 CHAR)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;

 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_SUB_TIPO_ADJUDICACION_PK'', ''D_SUB_TIPO_ADJUDICACION (TIPO_ADJUDICACION_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
	
    ------------------------------ D_SUB_TD_SENYALAMIENTO_SOLIC --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_SUB_TD_SENYALAMIENTO_SOLIC'', 
                          ''TD_SENYALAMIENTO_SOLIC_ID NUMBER(16,0) NOT NULL ENABLE,
                            TD_SENYALAMIENTO_SOLIC_DESC VARCHAR2(50 CHAR)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;

 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_SUB_TD_SENYALAMIENTO_SOLI_PK'', ''D_SUB_TD_SENYALAMIENTO_SOLIC (TD_SENYALAMIENTO_SOLIC_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
	
    ------------------------------ D_SUB_TD_SENYALAMIENTO_ANUNC --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_SUB_TD_SENYALAMIENTO_ANUNC'', 
                          ''TD_SENYALAMIENTO_ANUNC_ID NUMBER(16,0) NOT NULL ENABLE,
                            TD_SENYALAMIENTO_ANUNC_DESC VARCHAR2(50 CHAR)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;

 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_SUB_TD_SENYALAMIENTO_ANUN_PK'', ''D_SUB_TD_SENYALAMIENTO_ANUNC (TD_SENYALAMIENTO_ANUNC_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
	
    ------------------------------ D_SUB_TD_ANUNCIO_SOLICITUD --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_SUB_TD_ANUNCIO_SOLICITUD'', 
                          ''TD_ANUNCIO_SOLICITUD_ID NUMBER(16,0) NOT NULL ENABLE,
                            TD_ANUNCIO_SOLICITUD_DESC VARCHAR2(50 CHAR)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;

 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_SUB_TD_ANUNCIO_SOLICITUD_PK'', ''D_SUB_TD_ANUNCIO_SOLICITUD (TD_ANUNCIO_SOLICITUD_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
	
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;
    

  end;

END CREAR_DIM_SUBASTA;