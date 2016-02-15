create or replace PROCEDURE CREAR_DIM_BIEN (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Rafael Aracil, PFS Group
-- Fecha creacion: Agosto 2015
-- Responsable ultima modificacion: Rafael Aracil, PFS Group
-- Fecha ultima modificacion: 04/08/2015
-- Motivos del cambio: 
-- Cliente: Recovery BI Haya
--
-- Descripcion: Procedimiento almancenado que carga las tablas de la dimension SUBASTA.
-- ===============================================================================================

-- -------------------------------------------- INDICE -------------------------------------------
-- DIMENSION BIEN
    -- D_BIE
    -- D_BIE_TIPO_BIEN
    -- D_BIE_SUBTIPO_BIEN
    -- D_BIE_POBLACION
    -- D_BIE_ADJUDICADO
    -- D_BIE_ADJ_CESION_REM
    -- D_BIE_CODIGO_ACTIVO
    -- D_BIE_ENTIDAD_ADJUDICATARIA
    -- D_BIE_FASE_ACTUAL_DETALLE

BEGIN
  declare
  nCount NUMBER;
  V_SQL varchar2(16000);
  V_NOMBRE VARCHAR2(50) := 'CREAR_DIM_BIEN';
  
  begin
  
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
    
	

    ------------------------------ D_BIE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_BIE'',
						  ''BIE_ID NUMBER(16,0) NOT NULL ENABLE,
                            BIE_DESC VARCHAR2(50 CHAR),
                            BIE_DESC_2 VARCHAR2(250 CHAR),
                            BIE_DESC_3 VARCHAR2(50 CHAR),
                            PRIMARY KEY (BIE_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_BIE_TIPO_BIEN--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_BIE_TIPO_BIEN'',
						  ''TIPO_BIEN_ID NUMBER(16,0) NOT NULL ENABLE,
                            TIPO_BIEN_DESC VARCHAR2(50 CHAR),
                            TIPO_BIEN_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_BIEN_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_BIE_SUBTIPO_BIEN --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_BIE_SUBTIPO_BIEN'',
                          ''SUBTIPO_BIEN_ID NUMBER(16,0) NOT NULL ENABLE,
                            SUBTIPO_BIEN_DESC VARCHAR2(50 CHAR),
                            SUBTIPO_BIEN_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (SUBTIPO_BIEN_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_BIE_POBLACION  --------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_BIE_POBLACION'',
                          ''POBLACION_BIEN_ID NUMBER(16,0) NOT NULL ENABLE,
                            POBLACION_BIEN_DESC VARCHAR2(50 CHAR),
                            POBLACION_BIEN_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (POBLACION_BIEN_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_BIE_ADJUDICADO --------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_BIE_ADJUDICADO'',
                          ''BIEN_ADJUDICADO_ID NUMBER(16,0) NOT NULL ENABLE,
                            BIEN_ADJUDICADO_DESC VARCHAR2(50 CHAR),
                            BIEN_ADJUDICADO_DESC_2 VARCHAR2(250 CHAR),
                             PRIMARY KEY (BIEN_ADJUDICADO_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;


    ------------------------------ D_BIE_ADJ_CESION_REM --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_BIE_ADJ_CESION_REM'',
						  ''ADJ_CESION_REM_BIEN_ID NUMBER(16,0) NOT NULL ENABLE,
                            ADJ_CESION_REM_BIEN_DESC VARCHAR2(50 CHAR),
                            ADJ_CESION_REM_BIEN_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (ADJ_CESION_REM_BIEN_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_BIE_CODIGO_ACTIVO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_BIE_CODIGO_ACTIVO'',
                          ''CODIGO_ACTIVO_BIEN_ID NUMBER(16,0) NOT NULL ENABLE,
                            CODIGO_ACTIVO_BIEN_DESC VARCHAR2(50 CHAR),
                            CODIGO_ACTIVO_BIEN_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (CODIGO_ACTIVO_BIEN_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;


    ------------------------------ D_BIE_ENTIDAD_ADJUDICATARIA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_BIE_ENTIDAD_ADJUDICATARIA'',
                          ''ENTIDAD_ADJUDICATARIA_ID NUMBER(16,0) NOT NULL ENABLE ,
                            ENTIDAD_ADJUDICATARIA_DESC VARCHAR2(50 CHAR),
                            ENTIDAD_ADJUDICATARIA_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (ENTIDAD_ADJUDICATARIA_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;

    ----------------------------- D_BIE_FASE_ACTUAL_DETALLE --------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_BIE_FASE_ACTUAL_DETALLE'',
                         '' BIE_FASE_ACTUAL_DETALLE_ID NUMBER(16,0) NOT NULL,
                            BIE_FASE_ACTUAL_DETALLE_DESC VARCHAR2(100 CHAR),
                            BIE_FASE_ACTUAL_DETALLE_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (BIE_FASE_ACTUAL_DETALLE_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;

	
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;
    

  end;

END CREAR_DIM_BIEN;