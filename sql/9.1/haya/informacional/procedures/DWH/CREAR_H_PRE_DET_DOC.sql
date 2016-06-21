create or replace PROCEDURE CREAR_H_PRE_DET_DOC (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Jaime Sánchez-Cuenca Bellido, PFS Group
-- Fecha creacion: Agosto 2015
-- Responsable ultima modificacion: María Villanueva, PFS Group
-- Fecha ultima modificacion: 13/11/2015
-- Motivos del cambio: usuario propietario
-- Cliente: Recovery BI Haya
--
-- Descripcion: Procedimiento almancenado que crea las tablas del Hecho Precontecioso Detalle Documento
-- ===============================================================================================

-- -------------------------------------------- INDICE -------------------------------------------
-- HECHO PRECONTENCIOSO DETALLE DOCUMENTO
    -- TMP_H_PRE_DET_DOC
    -- H_PRE_DET_DOC
    -- H_PRE_DET_DOC_SEMANA
    -- H_PRE_DET_DOC_MES
    -- H_PRE_DET_DOC_TRIMESTRE
    -- H_PRE_DET_DOC_ANIO
    -- TMP_H_PRE_DET_DOC_SOL
    -- H_PRE_DET_DOC_SOL
    -- H_PRE_DET_DOC_SOL_SEMANA
    -- H_PRE_DET_DOC_SOL_MES
    -- H_PRE_DET_DOC_SOL_TIMESTRE
    -- H_PRE_DET_DOC_SOL_ANIO
    
BEGIN
  declare
  nCount NUMBER;
  V_SQL VARCHAR2(16000);
  V_NOMBRE VARCHAR2(50) := 'CREAR_H_PRE_DET_DOC';

  begin

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;

    ------------------------------ TMP_H_PRE_DET_DOC --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_H_PRE_DET_DOC'', 
                            ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ultimo dia cargado
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              DOCUMENTO_ID NUMBER(16,0) NOT NULL,
                              TIPO_DOCUMENTO_ID NUMBER(16,0),
                              ESTADO_DOCUMENTO_ID NUMBER(16,0),
                              ESTADO_DOCUMENTO_PER_ANT_ID NUMBER(16,0) NULL,
                              NUM_DOCUMENTOS INTEGER,
                              NUM_BUROFAX INTEGER'', :error); END;';
   execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_H_PRE_DET_DOC');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_PRE_DET_DOC_IX'', ''  TMP_H_PRE_DET_DOC (DIA_ID, PROCEDIMIENTO_ID, DOCUMENTO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_H_PRE_DET_DOC');
    

    ------------------------------ H_PRE_DET_DOC --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_DET_DOC'', 
                            ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ultimo dia cargado
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              DOCUMENTO_ID NUMBER(16,0) NOT NULL,
                              TIPO_DOCUMENTO_ID NUMBER(16,0),
                              ESTADO_DOCUMENTO_ID NUMBER(16,0),
                              ESTADO_DOCUMENTO_PER_ANT_ID NUMBER(16,0) NULL,
                              NUM_DOCUMENTOS INTEGER )
			  SEGMENT CREATION IMMEDIATE 
					TABLESPACE "RECOVERY_HAYA_DWH" 
                    PARTITION BY RANGE ("DIA_ID")
                    INTERVAL(NUMTOYMINTERVAL(1, ''''MONTH''''))
                    (PARTITION "p1" VALUES LESS THAN (TO_DATE('''' 2014-11-01 00:00:00'''', ''''SYYYY-MM-DD HH24:MI:SS'''', ''''NLS_CALENDAR=GREGORIAN''''))'', :error); END;';
	 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRE_DET_DOC');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_DOC_IX'', ''  H_PRE_DET_DOC (DIA_ID, PROCEDIMIENTO_ID, DOCUMENTO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

  
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRE_DET_DOC');
    

    ------------------------------ H_PRE_DET_DOC_SEMANA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_DET_DOC_SEMANA'', 
                            ''SEMANA_ID NUMBER(16,0) NOT NULL, 
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ultimo dia cargado
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              DOCUMENTO_ID NUMBER(16,0) NOT NULL,
                              TIPO_DOCUMENTO_ID NUMBER(16,0),
                              ESTADO_DOCUMENTO_ID NUMBER(16,0),
                              ESTADO_DOCUMENTO_PER_ANT_ID NUMBER(16,0) NULL,
                              NUM_DOCUMENTOS INTEGER)
			  SEGMENT CREATION IMMEDIATE 
					TABLESPACE "RECOVERY_HAYA_DWH" 
                    PARTITION BY RANGE ("SEMANA_ID")
                    INTERVAL (1) 
                           	(PARTITION "P1" VALUES LESS THAN (201501) '', :error); END;';
	 execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRE_DET_DOC_SEMANA');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_DOC_SEMANA_IX'', ''  H_PRE_DET_DOC_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID, DOCUMENTO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;


      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRE_DET_DOC_SEMANA');
        
    
    ------------------------------ H_PRE_DET_DOC_MES --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_DET_DOC_MES'', 
                            ''MES_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ultimo dia cargado
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              DOCUMENTO_ID NUMBER(16,0) NOT NULL,
                              TIPO_DOCUMENTO_ID NUMBER(16,0),
                              ESTADO_DOCUMENTO_ID NUMBER(16,0),
                              ESTADO_DOCUMENTO_PER_ANT_ID NUMBER(16,0) NULL,
                              NUM_DOCUMENTOS INTEGER
                           )
                              SEGMENT CREATION IMMEDIATE NOLOGGING
                           	TABLESPACE "RECOVERY_HAYA_DWH"   
                           	PARTITION BY RANGE ("MES_ID") INTERVAL (1) 
                           	(PARTITION "P1" VALUES LESS THAN (201501) 
                           	TABLESPACE "RECOVERY_HAYA_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H__PRE_DET_DOC_MES');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_DOC_MES_IX'', ''  H_PRE_DET_DOC_MES (MES_ID, PROCEDIMIENTO_ID, DOCUMENTO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRE_DET_DOC_MES');
    
    
    ------------------------------ H_PRE_DET_DOC_TRIMESTRE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_DET_DOC_TRIMESTRE'', 
                            ''TRIMESTRE_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ultimo dia cargado
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              DOCUMENTO_ID NUMBER(16,0) NOT NULL,
                              TIPO_DOCUMENTO_ID NUMBER(16,0),
                              ESTADO_DOCUMENTO_ID NUMBER(16,0),
                              ESTADO_DOCUMENTO_PER_ANT_ID NUMBER(16,0) NULL,
                              NUM_DOCUMENTOS INTEGER
                          )
                              SEGMENT CREATION IMMEDIATE NOLOGGING
                            	TABLESPACE "RECOVERY_HAYA_DWH"   
                            	PARTITION BY RANGE ("TRIMESTRE_ID") INTERVAL (1) 
                            	(PARTITION "P1" VALUES LESS THAN (201501) 
                            	TABLESPACE "RECOVERY_HAYA_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRE_DET_DOC_TRIMESTRE');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_DOC_TRIMESTRE_IX'', ''  H_PRE_DET_DOC_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID, DOCUMENTO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRE_DET_DOC_TRIMESTRE');
    

    ------------------------------ H_PRE_DET_DOC_ANIO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_DET_DOC_ANIO'', 
                            ''ANIO_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ultimo dia cargado
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              DOCUMENTO_ID NUMBER(16,0) NOT NULL,
                              TIPO_DOCUMENTO_ID NUMBER(16,0),
                              ESTADO_DOCUMENTO_ID NUMBER(16,0),
                              ESTADO_DOCUMENTO_PER_ANT_ID NUMBER(16,0) NULL,
                              NUM_DOCUMENTOS INTEGER
                           )
                             SEGMENT CREATION IMMEDIATE NOLOGGING
                            	TABLESPACE "RECOVERY_HAYA_DWH"   
                            	PARTITION BY RANGE ("ANIO_ID") INTERVAL (1) 
                            	(PARTITION "P1" VALUES LESS THAN (2015) 
                            	TABLESPACE "RECOVERY_HAYA_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRE_DET_DOC_ANIO');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_DOC_ANIO_IX'', ''  H_PRE_DET_DOC_ANIO (ANIO_ID, PROCEDIMIENTO_ID, DOCUMENTO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRE_DET_DOC_ANIO');
    

    ------------------------------ TMP_H_PRE_DET_DOC_SOL --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_H_PRE_DET_DOC_SOL'', 
                            ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ultimo dia cargado
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              SOLICITUD_DOCUMENTO_ID NUMBER(16,0) NOT NULL,
                              DOCUMENTO_ID NUMBER(16,0) NOT NULL,
                              RESULTADO_SOLICITUD_ID NUMBER(16,0),
                              TIPO_ACTOR_SOLICITUD_ID NUMBER(16,0),
                              USUARIO_SOLICITUD_ID NUMBER(16,0),
                              FECHA_SOLICITUD_DOC_SOL DATE,
                              FECHA_ENVIO_DOC_SOL DATE,
                              FECHA_RESULT_DOC_SOL DATE,
                              FECHA_RECEP_DOC_SOL DATE,
                              NUM_SOLICITUDES INTEGER,
                              P_DOC_SOLICITUD_ENVIO INTEGER,
                              P_DOC_SOLICITUD_RESULTADO INTEGER,
                              P_DOC_SOLICITUD_RECEPCION INTEGER'', :error); END;';
   execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_H_PRE_DET_DOC_SOL');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_PRE_DET_DOC_SOL_IX'', ''  TMP_H_PRE_DET_DOC_SOL (DIA_ID, PROCEDIMIENTO_ID, DOCUMENTO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

     
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_H_PRE_DET_DOC_SOL');
    

    ------------------------------ H_PRE_DET_DOC_SOL --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_DET_DOC_SOL'', 
                            ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ultimo dia cargado
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              SOLICITUD_DOCUMENTO_ID NUMBER(16,0) NOT NULL,
                              DOCUMENTO_ID NUMBER(16,0) NOT NULL,
                              RESULTADO_SOLICITUD_ID NUMBER(16,0),
                              TIPO_ACTOR_SOLICITUD_ID NUMBER(16,0),
                              USUARIO_SOLICITUD_ID NUMBER(16,0),
                              FECHA_SOLICITUD_DOC_SOL DATE,
                              FECHA_ENVIO_DOC_SOL DATE,
                              FECHA_RESULT_DOC_SOL DATE,
                              FECHA_RECEP_DOC_SOL DATE,
                              NUM_SOLICITUDES INTEGER,
                              P_DOC_SOLICITUD_ENVIO INTEGER,
                              P_DOC_SOLICITUD_RESULTADO INTEGER,
                              P_DOC_SOLICITUD_RECEPCION INTEGER )
			  SEGMENT CREATION IMMEDIATE 
					TABLESPACE "RECOVERY_HAYA_DWH" 
                    PARTITION BY RANGE ("DIA_ID")
                    INTERVAL(NUMTOYMINTERVAL(1, ''''MONTH''''))
                    (PARTITION "p1" VALUES LESS THAN (TO_DATE('''' 2014-11-01 00:00:00'''', ''''SYYYY-MM-DD HH24:MI:SS'''', ''''NLS_CALENDAR=GREGORIAN''''))'', :error); END;';
	 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRE_DET_DOC_SOL');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_DOC_SOL_IX'', ''  H_PRE_DET_DOC_SOL (DIA_ID, PROCEDIMIENTO_ID, DOCUMENTO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;


      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRE_DET_DOC_SOL');
    

    ------------------------------ H_PRE_DET_DOC_SOL_SEMANA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_DET_DOC_SOL_SEMANA'', 
                            ''SEMANA_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ultimo dia cargado
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              SOLICITUD_DOCUMENTO_ID NUMBER(16,0) NOT NULL,
                              DOCUMENTO_ID NUMBER(16,0) NOT NULL,
                              RESULTADO_SOLICITUD_ID NUMBER(16,0),
                              TIPO_ACTOR_SOLICITUD_ID NUMBER(16,0),
                              USUARIO_SOLICITUD_ID NUMBER(16,0),
                              FECHA_SOLICITUD_DOC_SOL DATE,
                              FECHA_ENVIO_DOC_SOL DATE,
                              FECHA_RESULT_DOC_SOL DATE,
                              FECHA_RECEP_DOC_SOL DATE,
                              NUM_SOLICITUDES INTEGER,
                              P_DOC_SOLICITUD_ENVIO INTEGER,
                              P_DOC_SOLICITUD_RESULTADO INTEGER,
                              P_DOC_SOLICITUD_RECEPCION INTEGER )
                              SEGMENT CREATION IMMEDIATE NOLOGGING
                           	TABLESPACE "RECOVERY_HAYA_DWH"   
                           	PARTITION BY RANGE ("SEMANA_ID") INTERVAL (1) 
                           	(PARTITION "P1" VALUES LESS THAN (201501) 
                           	TABLESPACE "RECOVERY_HAYA_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRE_DET_DOC_SOL_SEMANA');


                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_DOC_SOL_SEMANA_IX'', ''  H_PRE_DET_DOC_SOL_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID, DOCUMENTO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRE_DET_DOC_SOL_SEMANA');
    
    

    ------------------------------ H_PRE_DET_DOC_SOL_MES --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_DET_DOC_SOL_MES'', 
                            ''MES_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ultimo dia cargado
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              SOLICITUD_DOCUMENTO_ID NUMBER(16,0) NOT NULL,
                              DOCUMENTO_ID NUMBER(16,0) NOT NULL,
                              RESULTADO_SOLICITUD_ID NUMBER(16,0),
                              TIPO_ACTOR_SOLICITUD_ID NUMBER(16,0),
                              USUARIO_SOLICITUD_ID NUMBER(16,0),
                              FECHA_SOLICITUD_DOC_SOL DATE,
                              FECHA_ENVIO_DOC_SOL DATE,
                              FECHA_RESULT_DOC_SOL DATE,
                              FECHA_RECEP_DOC_SOL DATE,
                              NUM_SOLICITUDES INTEGER,
                              P_DOC_SOLICITUD_ENVIO INTEGER,
                              P_DOC_SOLICITUD_RESULTADO INTEGER,
                              P_DOC_SOLICITUD_RECEPCION INTEGER
                           )
                              SEGMENT CREATION IMMEDIATE NOLOGGING
                           	TABLESPACE "RECOVERY_HAYA_DWH"   
                           	PARTITION BY RANGE ("MES_ID") INTERVAL (1) 
                           	(PARTITION "P1" VALUES LESS THAN (201501) 
                           	TABLESPACE "RECOVERY_HAYA_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRE_DET_DOC_SOL_MES');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_DOC_SOL_MES_IX'', ''  H_PRE_DET_DOC_SOL_MES (MES_ID, PROCEDIMIENTO_ID, DOCUMENTO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRE_DET_DOC_SOL_MES');
    
 
    ------------------------------ H_PRE_DET_DOC_SOL_TRIMESTRE --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_DET_DOC_SOL_TRIMESTRE'', 
                            ''TRIMESTRE_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ultimo dia cargado
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              SOLICITUD_DOCUMENTO_ID NUMBER(16,0) NOT NULL,
                              DOCUMENTO_ID NUMBER(16,0) NOT NULL,
                              RESULTADO_SOLICITUD_ID NUMBER(16,0),
                              TIPO_ACTOR_SOLICITUD_ID NUMBER(16,0),
                              USUARIO_SOLICITUD_ID NUMBER(16,0),
                              FECHA_SOLICITUD_DOC_SOL DATE,
                              FECHA_ENVIO_DOC_SOL DATE,
                              FECHA_RESULT_DOC_SOL DATE,
                              FECHA_RECEP_DOC_SOL DATE,
                              NUM_SOLICITUDES INTEGER,
                              P_DOC_SOLICITUD_ENVIO INTEGER,
                              P_DOC_SOLICITUD_RESULTADO INTEGER,
                              P_DOC_SOLICITUD_RECEPCION INTEGER
                          )
                              SEGMENT CREATION IMMEDIATE NOLOGGING
                            	TABLESPACE "RECOVERY_HAYA_DWH"   
                            	PARTITION BY RANGE ("TRIMESTRE_ID") INTERVAL (1) 
                            	(PARTITION "P1" VALUES LESS THAN (201501) 
                            	TABLESPACE "RECOVERY_HAYA_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRE_DET_DOC_SOL_TRIMESTRE');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_DOC_SOL_TRIMESTRE_IX'', ''  H_PRE_DET_DOC_SOL_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID, DOCUMENTO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRE_DET_DOC_SOL_TRIMESTRE');
     

    ------------------------------ H_PRE_DET_DOC_SOL_ANIO --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_DET_DOC_SOL_ANIO'', 
                            ''ANIO_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ultimo dia cargado
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              SOLICITUD_DOCUMENTO_ID NUMBER(16,0) NOT NULL,
                              DOCUMENTO_ID NUMBER(16,0) NOT NULL,
                              RESULTADO_SOLICITUD_ID NUMBER(16,0),
                              TIPO_ACTOR_SOLICITUD_ID NUMBER(16,0),
                              USUARIO_SOLICITUD_ID NUMBER(16,0),
                              FECHA_SOLICITUD_DOC_SOL DATE,
                              FECHA_ENVIO_DOC_SOL DATE,
                              FECHA_RESULT_DOC_SOL DATE,
                              FECHA_RECEP_DOC_SOL DATE,
                              NUM_SOLICITUDES INTEGER,
                              P_DOC_SOLICITUD_ENVIO INTEGER,
                              P_DOC_SOLICITUD_RESULTADO INTEGER,
                              P_DOC_SOLICITUD_RECEPCION INTEGER
                           )
                             SEGMENT CREATION IMMEDIATE NOLOGGING
                            	TABLESPACE "RECOVERY_HAYA_DWH"   
                            	PARTITION BY RANGE ("ANIO_ID") INTERVAL (1) 
                            	(PARTITION "P1" VALUES LESS THAN (2015) 
                            	TABLESPACE "RECOVERY_HAYA_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;


      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRE_DET_DOC_SOL_ANIO');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_DOC_SOL_ANIO_IX'', ''  H_PRE_DET_DOC_SOL_ANIO (ANIO_ID, PROCEDIMIENTO_ID, DOCUMENTO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRE_DET_DOC_SOL_ANIO');
     

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;

  end;

END CREAR_H_PRE_DET_DOC;
