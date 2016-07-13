create or replace PROCEDURE CREAR_H_PRE_DET_BURO (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Jaime Sánchez-Cuenca Bellido, PFS Group
-- Fecha creación: Septiembre 2015
-- Responsable ultima modificacion: María Villanueva, PFS Group
-- Fecha ultima modificacion: 18/11/2015
-- Motivos del cambio: usuario propietario
-- Cliente: Recovery BI BANKIA
--
-- Descripcion: Procedimiento almancenado que crea las tablas del Hecho Precontecioso Detalle Burofax
-- ===============================================================================================

-- -------------------------------------------- INDICE -------------------------------------------
-- HECHO PRECONTENCIOSO DETALLE BUROFAX
    -- TMP_H_PRE_DET_BURO
    -- H_PRE_DET_BURO
    -- H_PRE_DET_BURO_SEMANA
    -- H_PRE_DET_BURO_MES
    -- H_PRE_DET_BURO_TRIMESTRE
    -- H_PRE_DET_BURO_ANIO
    -- TMP_H_PRE_DET_BURO_ENV
    -- H_PRE_DET_BURO_ENV
    -- H_PRE_DET_BURO_ENV_SEMANA
    -- H_PRE_DET_BURO_ENV_MES
    -- H_PRE_DET_BURO_ENV_TRIMESTRE
    -- H_PRE_DET_BURO_ENV_ANIO
    
BEGIN
  declare
  nCount NUMBER;
  V_SQL VARCHAR2(16000);
  V_NOMBRE VARCHAR2(50) := 'CREAR_H_PRE_DET_BURO';

  begin

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;

    ------------------------------ TMP_H_PRE_DET_BURO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_H_PRE_DET_BURO'', 
                            ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ultimo dia cargado
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              BUROFAX_ID NUMBER(16,0) NOT NULL,
                              ESTADO_BUROFAX_ID NUMBER(16,0),
                              RESULTADO_BUROFAX_ID NUMBER(16,0),
                              PERSONA_ID NUMBER(16,0),
                              NUM_BUROFAX INTEGER'', :error); END;';
   execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_H_PRE_DET_BURO');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_PRE_DET_BURO_IX'', ''  TMP_H_PRE_DET_BURO (DIA_ID, PROCEDIMIENTO_ID, BUROFAX_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_PRE_DET_BURO_PER_IX'', ''  TMP_H_PRE_DET_BURO (DIA_ID, PROCEDIMIENTO_ID, PERSONA_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

     
      DBMS_OUTPUT.PUT_LINE('---- Creacion indices en TMPH_PRE_DET_BURO');



    ------------------------------ H_PRE_DET_BURO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_DET_BURO'', 
                            ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ultimo dia cargado
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              BUROFAX_ID NUMBER(16,0) NOT NULL,
                              ESTADO_BUROFAX_ID NUMBER(16,0),
                              RESULTADO_BUROFAX_ID NUMBER(16,0),
                              PERSONA_ID NUMBER(16,0),
                              NUM_BUROFAX INTEGER
                           )
			  SEGMENT CREATION IMMEDIATE 
					TABLESPACE "RECOVERY_BANKIA_DWH" 
                    PARTITION BY RANGE ("DIA_ID")
                    INTERVAL(NUMTOYMINTERVAL(1, ''''MONTH''''))
                    (PARTITION "p1" VALUES LESS THAN (TO_DATE('''' 2014-11-01 00:00:00'''', ''''SYYYY-MM-DD HH24:MI:SS'''', ''''NLS_CALENDAR=GREGORIAN''''))'', :error); END;';
	 execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRE_DET_BURO');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_BURO_IX'', ''  H_PRE_DET_BURO (DIA_ID, PROCEDIMIENTO_ID, BUROFAX_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_BURO_PER_IX'', ''  H_PRE_DET_BURO (DIA_ID, PROCEDIMIENTO_ID, PERSONA_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

      
      DBMS_OUTPUT.PUT_LINE('---- Creacion indices en H_PRE_DET_BURO');
   

    ------------------------------ H_PRE_DET_BURO_SEMANA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_DET_BURO_SEMANA'', 
                            ''SEMANA_ID NUMBER(16,0) NOT NULL, 
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ultimo dia cargado
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              BUROFAX_ID NUMBER(16,0) NOT NULL,
                              ESTADO_BUROFAX_ID NUMBER(16,0),
                              RESULTADO_BUROFAX_ID NUMBER(16,0),
                              PERSONA_ID NUMBER(16,0),
                              NUM_BUROFAX INTEGER)
			    SEGMENT CREATION IMMEDIATE NOLOGGING
                            TABLESPACE "RECOVERY_BANKIA_DWH"   
                            PARTITION BY RANGE ("SEMANA_ID") INTERVAL (1) 
                           (PARTITION "P1" VALUES LESS THAN (201501) 
                           TABLESPACE "RECOVERY_BANKIA_DWH"'', :error); END;';

	execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRE_DET_BURO_SEMANA');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_BURO_SEMANA_IX'', ''  H_PRE_DET_BURO_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID, BUROFAX_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_BURO_PER_SEMANA_IX'', ''  H_PRE_DET_BURO_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID, PERSONA_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

           DBMS_OUTPUT.PUT_LINE('---- Creacion indices en H_PRE_DET_BURO_SEMANA');
        
    
    ------------------------------ H_PRE_MES --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_DET_BURO_MES'', 
                            ''MES_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ultimo dia cargado
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              BUROFAX_ID NUMBER(16,0) NOT NULL,
                              ESTADO_BUROFAX_ID NUMBER(16,0),
                              RESULTADO_BUROFAX_ID NUMBER(16,0),
                              PERSONA_ID NUMBER(16,0),
                              NUM_BUROFAX INTEGER
                           )
                              SEGMENT CREATION IMMEDIATE NOLOGGING
                           	TABLESPACE "RECOVERY_BANKIA_DWH"   
                           	PARTITION BY RANGE ("MES_ID") INTERVAL (1) 
                           	(PARTITION "P1" VALUES LESS THAN (201501) 
                           	TABLESPACE "RECOVERY_BANKIA_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_DET_BURO_PRE_MES');
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_BURO_MES_IX'', ''  H_PRE_DET_BURO_MES (MES_ID, PROCEDIMIENTO_ID, PERSONA_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_BURO_PER_MES_IX'', ''  H_PRE_DET_BURO_MES (MES_ID, PROCEDIMIENTO_ID, PERSONA_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;


      DBMS_OUTPUT.PUT_LINE('---- Creacion indices en H_PRE_DET_BURO_MES');
    
    
    ------------------------------ H_PRE_DET_BURO_TRIMESTRE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_DET_BURO_TRIMESTRE'', 
                            ''TRIMESTRE_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ultimo dia cargado
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              BUROFAX_ID NUMBER(16,0) NOT NULL,
                              ESTADO_BUROFAX_ID NUMBER(16,0),
                              RESULTADO_BUROFAX_ID NUMBER(16,0),
                              PERSONA_ID NUMBER(16,0),
                              NUM_BUROFAX INTEGER
                          )
                              SEGMENT CREATION IMMEDIATE NOLOGGING
                            	TABLESPACE "RECOVERY_BANKIA_DWH"   
                            	PARTITION BY RANGE ("TRIMESTRE_ID") INTERVAL (1) 
                            	(PARTITION "P1" VALUES LESS THAN (201501) 
                            	TABLESPACE "RECOVERY_BANKIA_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRE_DET_BURO_TRIMESTRE');

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_DET_BURO_PRE_MES');
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_BURO_TRIMESTRE_IX'', ''  H_PRE_DET_BURO_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID, PERSONA_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_BURO_PER_TRIMESTRE_IX'', ''  H_PRE_DET_BURO_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID, PERSONA_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

    
      DBMS_OUTPUT.PUT_LINE('---- Creacion indices en H_PRE_DET_BURO_TRIMESTRE');
    

    ------------------------------ H_PRE_DET_BURO_ANIO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_DET_BURO_ANIO'', 
                            ''ANIO_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ultimo dia cargado
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              BUROFAX_ID NUMBER(16,0) NOT NULL,
                              ESTADO_BUROFAX_ID NUMBER(16,0),
                              RESULTADO_BUROFAX_ID NUMBER(16,0),
                              PERSONA_ID NUMBER(16,0),
                              NUM_BUROFAX INTEGER
                           )
                             SEGMENT CREATION IMMEDIATE NOLOGGING
                            	TABLESPACE "RECOVERY_BANKIA_DWH"   
                            	PARTITION BY RANGE ("ANIO_ID") INTERVAL (1) 
                            	(PARTITION "P1" VALUES LESS THAN (2015) 
                            	TABLESPACE "RECOVERY_BANKIA_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRE_DET_BURO_ANIO');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_BURO_ANIO_IX'', ''  H_PRE_DET_BURO_ANIO (ANIO_ID, PROCEDIMIENTO_ID, PERSONA_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_BURO_PER_ANIO_IX'', ''  H_PRE_DET_BURO_ANIO (ANIO_ID, PROCEDIMIENTO_ID, PERSONA_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion indices en H_PRE_DET_BURO_ANIO');
    

    ------------------------------ TMP_H_PRE_DET_BURO_ENV --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_H_PRE_DET_BURO_ENV'', 
                            ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ultimo dia cargado
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              BUROFAX_ENVIO_ID NUMBER(16,0) NOT NULL,
                              BUROFAX_ID NUMBER(16,0) NOT NULL,
                              TIPO_BUROFAX_ENVIO_ID NUMBER(16,0),
                              RESULTADO_BUROFAX_ENVIO_ID NUMBER(16,0),
                              FECHA_SOLICITUD_BURO_ENV DATE,
                              FECHA_ENVIO_BURO_ENV DATE,
                              FECHA_ACUSE_BURO_ENV DATE,
                              NUM_ENVIOS_BUROFAX INTEGER,
                              P_BURO_SOLICITUD_ACUSE INTEGER'', :error); END;';
   execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_H_PRE_DET_BURO_ENV');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_PRE_DET_BURO_ENV_IX'', ''  TMP_H_PRE_DET_BURO_ENV (DIA_ID, PROCEDIMIENTO_ID, BUROFAX_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

 
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_H_PRE_DET_BURO_ENV');
    

    ------------------------------ H_PRE_DET_BURO_ENV --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_DET_BURO_ENV'', 
                            ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ultimo dia cargado
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              BUROFAX_ENVIO_ID NUMBER(16,0) NOT NULL,
                              BUROFAX_ID NUMBER(16,0) NOT NULL,
                              TIPO_BUROFAX_ENVIO_ID NUMBER(16,0),
                              RESULTADO_BUROFAX_ENVIO_ID NUMBER(16,0),
                              FECHA_SOLICITUD_BURO_ENV DATE,
                              FECHA_ENVIO_BURO_ENV DATE,
                              FECHA_ACUSE_BURO_ENV DATE,
                              NUM_ENVIOS_BUROFAX INTEGER,
                              P_BURO_SOLICITUD_ACUSE INTEGER
                         )
			  SEGMENT CREATION IMMEDIATE 
					TABLESPACE "RECOVERY_BANKIA_DWH" 
                    PARTITION BY RANGE ("DIA_ID")
                    INTERVAL(NUMTOYMINTERVAL(1, ''''MONTH''''))
                    (PARTITION "p1" VALUES LESS THAN (TO_DATE('''' 2014-11-01 00:00:00'''', ''''SYYYY-MM-DD HH24:MI:SS'''', ''''NLS_CALENDAR=GREGORIAN''''))'', :error); END;';
	 execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRE_DET_BURO_ENV');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_BURO_ENV_IX'', ''  H_PRE_DET_BURO_ENV (DIA_ID, PROCEDIMIENTO_ID, BUROFAX_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

     
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRE_DET_BURO_ENV');
    

    ------------------------------ H_PRE_DET_BURO_ENV_SEMANA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_DET_BURO_ENV_SEMANA'', 
                            ''SEMANA_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ultimo dia cargado
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              BUROFAX_ENVIO_ID NUMBER(16,0) NOT NULL,
                              BUROFAX_ID NUMBER(16,0) NOT NULL,
                              TIPO_BUROFAX_ENVIO_ID NUMBER(16,0),
                              RESULTADO_BUROFAX_ENVIO_ID NUMBER(16,0),
                              FECHA_SOLICITUD_BURO_ENV DATE,
                              FECHA_ENVIO_BURO_ENV DATE,
                              FECHA_ACUSE_BURO_ENV DATE,
                              NUM_ENVIOS_BUROFAX INTEGER,
                              P_BURO_SOLICITUD_ACUSE INTEGER
                          )
			    SEGMENT CREATION IMMEDIATE NOLOGGING
                            TABLESPACE "RECOVERY_BANKIA_DWH"   
                            PARTITION BY RANGE ("SEMANA_ID") INTERVAL (1) 
                           (PARTITION "P1" VALUES LESS THAN (201501) 
                           TABLESPACE "RECOVERY_BANKIA_DWH"'', :error); END;';

	execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRE_DET_BURO_ENV_SEMANA');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_BURO_ENV_SEMANA_IX'', ''  H_PRE_DET_BURO_ENV_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID, BUROFAX_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

    
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRE_DET_BURO_ENV_SEMANA');
    
    

    ------------------------------ H_PRE_DET_BURO_ENV_MES --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_DET_BURO_ENV_MES'', 
                            ''MES_ID NUMBER(16,0)  NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ultimo dia cargado
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              BUROFAX_ENVIO_ID NUMBER(16,0) NOT NULL,
                              BUROFAX_ID NUMBER(16,0) NOT NULL,
                              TIPO_BUROFAX_ENVIO_ID NUMBER(16,0),
                              RESULTADO_BUROFAX_ENVIO_ID NUMBER(16,0),
                              FECHA_SOLICITUD_BURO_ENV DATE,
                              FECHA_ENVIO_BURO_ENV DATE,
                              FECHA_ACUSE_BURO_ENV DATE,
                              NUM_ENVIOS_BUROFAX INTEGER,
                              P_BURO_SOLICITUD_ACUSE INTEGER
                           )
                              SEGMENT CREATION IMMEDIATE NOLOGGING
                           	TABLESPACE "RECOVERY_BANKIA_DWH"   
                           	PARTITION BY RANGE ("MES_ID") INTERVAL (1) 
                           	(PARTITION "P1" VALUES LESS THAN (201501) 
                           	TABLESPACE "RECOVERY_BANKIA_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRE_DET_BURO_ENV_MES');

                    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_BURO_ENV_MES_IX'', ''  H_PRE_DET_BURO_ENV_MES (MES_ID, PROCEDIMIENTO_ID, BUROFAX_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRE_DET_BURO_ENV_MES');
    
 
    ------------------------------ H_PRE_DET_BURO_ENV_TRIMESTRE --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_DET_BURO_ENV_TRIMESTRE'', 
                            ''TRIMESTRE_ID NUMBER(16,0)  NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ultimo dia cargado
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              BUROFAX_ENVIO_ID NUMBER(16,0) NOT NULL,
                              BUROFAX_ID NUMBER(16,0) NOT NULL,
                              TIPO_BUROFAX_ENVIO_ID NUMBER(16,0),
                              RESULTADO_BUROFAX_ENVIO_ID NUMBER(16,0),
                              FECHA_SOLICITUD_BURO_ENV DATE,
                              FECHA_ENVIO_BURO_ENV DATE,
                              FECHA_ACUSE_BURO_ENV DATE,
                              NUM_ENVIOS_BUROFAX INTEGER,
                              P_BURO_SOLICITUD_ACUSE INTEGER)
                              SEGMENT CREATION IMMEDIATE NOLOGGING
                            	TABLESPACE "RECOVERY_BANKIA_DWH"   
                            	PARTITION BY RANGE ("TRIMESTRE_ID") INTERVAL (1) 
                            	(PARTITION "P1" VALUES LESS THAN (201501) 
                            	TABLESPACE "RECOVERY_BANKIA_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRE_DET_BURO_ENV_TRIMESTRE');

                        V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_BURO_ENV_TRIMESTRE_IX'', ''  H_PRE_DET_BURO_ENV_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID, BUROFAX_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRE_DET_BURO_ENV_TRIMESTRE');
     

    ------------------------------ H_PRE_DET_BURO_ENV_ANIO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_DET_BURO_ENV_ANIO'', 
                            ''ANIO_ID NUMBER(16,0)  NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ultimo dia cargado
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              BUROFAX_ENVIO_ID NUMBER(16,0) NOT NULL,
                              BUROFAX_ID NUMBER(16,0) NOT NULL,
                              TIPO_BUROFAX_ENVIO_ID NUMBER(16,0),
                              RESULTADO_BUROFAX_ENVIO_ID NUMBER(16,0),
                              FECHA_SOLICITUD_BURO_ENV DATE,
                              FECHA_ENVIO_BURO_ENV DATE,
                              FECHA_ACUSE_BURO_ENV DATE,
                              NUM_ENVIOS_BUROFAX INTEGER,
                              P_BURO_SOLICITUD_ACUSE INTEGER
                           )
                             SEGMENT CREATION IMMEDIATE NOLOGGING
                            	TABLESPACE "RECOVERY_BANKIA_DWH"   
                            	PARTITION BY RANGE ("ANIO_ID") INTERVAL (1) 
                            	(PARTITION "P1" VALUES LESS THAN (2015) 
                            	TABLESPACE "RECOVERY_BANKIA_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRE_DET_BURO_ENV_ANIO');

                         V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_BURO_ENV_ANIO_IX'', ''  H_PRE_DET_BURO_ENV_ANIO (ANIO_ID, PROCEDIMIENTO_ID, BUROFAX_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRE_DET_BURO_ENV_ANIO');
     

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;

  end;

END CREAR_H_PRE_DET_BURO;
