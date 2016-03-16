create or replace PROCEDURE CREAR_H_TAREA (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Agustin Mompo, PFS Group
-- Fecha creacion: Mayo 2014
-- Responsable ultima modificacion: María Villanueva, PFS Group
-- Fecha ultima modificacion: 03/02/2016
-- Motivos del cambio: ESTADO_PRORROGA_ID
-- Cliente: Recovery BI HAYA
--
-- Descripcion: Procedimiento almancenado que crea las tablas del Hecho Tarea
-- ===============================================================================================

-- -------------------------------------------- INDICE -------------------------------------------
-- HECHO TAREA
    -- H_TAR
    -- H_TAR_SEMANA
    -- H_TAR_MES
    -- H_TAR_TRIMESTRE
    -- H_TAR_ANIO
    -- TMP_TAR_JERARQUIA

BEGIN
  declare
  nCount NUMBER;
  V_SQL varchar2(16000);
  V_NOMBRE VARCHAR2(50) := 'CREAR_H_TAREA';

  begin

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;

    ------------------------------ H_TAR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_TAR'',
						  ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ?ltimo d?a cargado
                              TAREA_ID NUMBER(16,0) NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) ,                   -- ID de la primera fase del procedimiento (PRC_PRC_ID = ). Identifica al procedimiento (Secuencia de actuaciones)
                              EXPEDIENTE_ID NUMBER(16, 0),
                              FASE_ACTUAL_PROCEDIMIENTO NUMBER(16,0) ,
                              ASUNTO_ID NUMBER(16,0) ,                          -- Asunto al que pertenece el procedimiento
                              FECHA_CREACION_TAREA DATE ,
                              FECHA_VENC_ORIGINAL_TAREA DATE ,
                              FECHA_VENCIMIENTO_TAREA DATE ,
                              FECHA_FIN_TAREA DATE ,
                              -- Dimensiones
                              ESTADO_TAREA_ID NUMBER(16,0)  ,
                              RESPONSABLE_TAREA_ID NUMBER(16,0) ,
                              TIPO_PROCEDIMIENTO_DET_ID NUMBER(16,0) ,
                              CARTERA_PROCEDIMIENTO_ID NUMBER(16,0)  ,
                              GESTOR_EN_RECOVERY_PRC_ID NUMBER(16,0)  ,
                              CUMPLIMIENTO_TAREA_ID NUMBER(16,0)  ,
							  ESTADO_PRORROGA_ID NUMBER(16,0),
                              -- Metricas
                              NUM_TAREAS INTEGER ,
                              NUM_DIAS_VENCIDO INTEGER
                                )
			  SEGMENT CREATION IMMEDIATE 
					TABLESPACE "RECOVERY_HAYA02_DWH" 
                    PARTITION BY RANGE ("DIA_ID")
                    INTERVAL(NUMTOYMINTERVAL(1, ''''MONTH''''))
                    (PARTITION "p1" VALUES LESS THAN (TO_DATE('''' 2014-11-01 00:00:00'''', ''''SYYYY-MM-DD HH24:MI:SS'''', ''''NLS_CALENDAR=GREGORIAN''''))'', :error); END;';
	 execute immediate V_SQL USING OUT error;
     DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_TAR');


      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_TAR_IX'', ''H_TAR (DIA_ID, TAREA_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_TAR_VENC_IX'', ''H_TAR (DIA_ID, FECHA_VENCIMIENTO_TAREA, TAREA_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_TAR_PRC_IX'', ''H_TAR (DIA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_TAR_FASE_ACTUAL_PRC_IX'', ''H_TAR (DIA_ID, FASE_ACTUAL_PROCEDIMIENTO)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_TAR');

    

    ------------------------------ H_TAR_SEMANA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_TAR_SEMANA'',
						  ''SEMANA_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ?ltimo d?a cargado
                              TAREA_ID NUMBER(16,0) NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) ,                   -- ID de la primera fase del procedimiento (PRC_PRC_ID = ). Identifica al procedimiento (Secuencia de actuaciones)
                              EXPEDIENTE_ID NUMBER(16, 0),
                              FASE_ACTUAL_PROCEDIMIENTO NUMBER(16,0) ,
                              ASUNTO_ID NUMBER(16,0) ,                          -- Asunto al que pertenece el procedimiento
                              FECHA_CREACION_TAREA DATE ,
                              FECHA_VENC_ORIGINAL_TAREA DATE ,
                              FECHA_VENCIMIENTO_TAREA DATE ,
                              FECHA_FIN_TAREA DATE ,
                              -- Dimensiones
                              ESTADO_TAREA_ID NUMBER(16,0)  ,
                              RESPONSABLE_TAREA_ID NUMBER(16,0) ,
                              TIPO_PROCEDIMIENTO_DET_ID NUMBER(16,0) ,
                              CARTERA_PROCEDIMIENTO_ID NUMBER(16,0)  ,
                              GESTOR_EN_RECOVERY_PRC_ID NUMBER(16,0)  ,
                              CUMPLIMIENTO_TAREA_ID NUMBER(16,0)  ,
							  ESTADO_PRORROGA_ID NUMBER(16,0),

                              -- M?tricas
                              NUM_TAREAS INTEGER ,
                              NUM_DIAS_VENCIDO INTEGER)
                            SEGMENT CREATION IMMEDIATE NOLOGGING
                            PARTITION BY RANGE ("SEMANA_ID") INTERVAL (1) 
                           (PARTITION "P1" VALUES LESS THAN (201501)
                               '', :error); END;';
		 execute immediate V_SQL USING OUT error;
     DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_TAR_SEMANA');


      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_TAR_SEMANA_IX'', ''H_TAR_SEMANA (SEMANA_ID, TAREA_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_TAR_SEMANA_VENC_IX'', ''H_TAR_SEMANA (SEMANA_ID, FECHA_VENCIMIENTO_TAREA, TAREA_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_TAR_SEMANA_PRC_IX'', ''H_TAR_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_TAR_SEMANA');

    
    
    ------------------------------ H_TAR_MES --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_TAR_MES'',
						  ''MES_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ?ltimo d?a cargado
                              TAREA_ID NUMBER(16,0) NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) ,                   -- ID de la primera fase del procedimiento (PRC_PRC_ID = ). Identifica al procedimiento (Secuencia de actuaciones)
                              EXPEDIENTE_ID NUMBER(16, 0),
                              FASE_ACTUAL_PROCEDIMIENTO NUMBER(16,0) ,
                              ASUNTO_ID NUMBER(16,0) ,                          -- Asunto al que pertenece el procedimiento
                              FECHA_CREACION_TAREA DATE ,
                              FECHA_VENC_ORIGINAL_TAREA DATE ,
                              FECHA_VENCIMIENTO_TAREA DATE ,
                              FECHA_FIN_TAREA DATE ,
                              -- Dimensiones
                              ESTADO_TAREA_ID NUMBER(16,0)  ,
                              RESPONSABLE_TAREA_ID NUMBER(16,0) ,
                              TIPO_PROCEDIMIENTO_DET_ID NUMBER(16,0) ,
                              CARTERA_PROCEDIMIENTO_ID NUMBER(16,0)  ,
                              GESTOR_EN_RECOVERY_PRC_ID NUMBER(16,0)  ,
                              CUMPLIMIENTO_TAREA_ID NUMBER(16,0) ,
							  ESTADO_PRORROGA_ID NUMBER(16,0),

                              -- M?tricas
                              NUM_TAREAS INTEGER ,
                              NUM_DIAS_VENCIDO INTEGER)
                            	SEGMENT CREATION IMMEDIATE NOLOGGING
                           	PARTITION BY RANGE ("MES_ID") INTERVAL (1) 
                           	(PARTITION "P1" VALUES LESS THAN (201501)
                               '', :error); END;';
		 execute immediate V_SQL USING OUT error;
		 
     DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_TAR_MES');


      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_TAR_MES_IX'', ''H_TAR_MES (MES_ID, TAREA_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_TAR_MES_VENC_IX'', ''H_TAR_MES (MES_ID, FECHA_VENCIMIENTO_TAREA, TAREA_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_TAR_MES_PRC_IX'', ''H_TAR_MES (MES_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_TAR_MES');

    

    ------------------------------ H_TAR_TRIMESTRE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_TAR_TRIMESTRE'',
						  ''TRIMESTRE_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ?ltimo d?a cargado
                              TAREA_ID NUMBER(16,0) NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) ,                   -- ID de la primera fase del procedimiento (PRC_PRC_ID = ). Identifica al procedimiento (Secuencia de actuaciones)
                              EXPEDIENTE_ID NUMBER(16, 0),
                              FASE_ACTUAL_PROCEDIMIENTO NUMBER(16,0) ,
                              ASUNTO_ID NUMBER(16,0) ,                          -- Asunto al que pertenece el procedimiento
                              FECHA_CREACION_TAREA DATE ,
                              FECHA_VENC_ORIGINAL_TAREA DATE ,
                              FECHA_VENCIMIENTO_TAREA DATE ,
                              FECHA_FIN_TAREA DATE ,
                              -- Dimensiones
                              ESTADO_TAREA_ID NUMBER(16,0)  ,
                              RESPONSABLE_TAREA_ID NUMBER(16,0) ,
                              TIPO_PROCEDIMIENTO_DET_ID NUMBER(16,0) ,
                              CARTERA_PROCEDIMIENTO_ID NUMBER(16,0)  ,
                              GESTOR_EN_RECOVERY_PRC_ID NUMBER(16,0)  ,
                              CUMPLIMIENTO_TAREA_ID NUMBER(16,0)  ,
							  ESTADO_PRORROGA_ID NUMBER(16,0),

                              -- M?tricas
                              NUM_TAREAS INTEGER ,
                              NUM_DIAS_VENCIDO INTEGER)
                            	SEGMENT CREATION IMMEDIATE NOLOGGING
                            	PARTITION BY RANGE ("TRIMESTRE_ID") INTERVAL (1) 
                            	(PARTITION "P1" VALUES LESS THAN (201501)
                               '', :error); END;';
		 execute immediate V_SQL USING OUT error;
     DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_TAR_TRIMESTRE');


      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_TAR_TRIMESTRE_IX'', ''H_TAR_TRIMESTRE (TRIMESTRE_ID, TAREA_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_TAR_TRIMESTRE_VENC_IX'', ''H_TAR_TRIMESTRE (TRIMESTRE_ID, FECHA_VENCIMIENTO_TAREA, TAREA_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_TAR_TRIMESTRE_PRC_IX'', ''H_TAR_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_TAR_TRIMESTRE');

    

    ------------------------------ H_TAR_ANIO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_TAR_ANIO'',
						  ''ANIO_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ?ltimo d?a cargado
                              TAREA_ID NUMBER(16,0) NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) ,                   -- ID de la primera fase del procedimiento (PRC_PRC_ID = ). Identifica al procedimiento (Secuencia de actuaciones)
                              EXPEDIENTE_ID NUMBER(16, 0),
                              FASE_ACTUAL_PROCEDIMIENTO NUMBER(16,0) ,
                              ASUNTO_ID NUMBER(16,0) ,                          -- Asunto al que pertenece el procedimiento
                              FECHA_CREACION_TAREA DATE ,
                              FECHA_VENC_ORIGINAL_TAREA DATE ,
                              FECHA_VENCIMIENTO_TAREA DATE ,
                              FECHA_FIN_TAREA DATE ,
                              -- Dimensiones
                              ESTADO_TAREA_ID NUMBER(16,0)  ,
                              RESPONSABLE_TAREA_ID NUMBER(16,0) ,
                              TIPO_PROCEDIMIENTO_DET_ID NUMBER(16,0) ,
                              CARTERA_PROCEDIMIENTO_ID NUMBER(16,0)  ,
                              GESTOR_EN_RECOVERY_PRC_ID NUMBER(16,0)  ,
                              CUMPLIMIENTO_TAREA_ID NUMBER(16,0)  ,
							  ESTADO_PRORROGA_ID NUMBER(16,0),

                              -- M?tricas
                              NUM_TAREAS INTEGER ,
                              NUM_DIAS_VENCIDO INTEGER)
                            	SEGMENT CREATION IMMEDIATE NOLOGGING
                            	PARTITION BY RANGE ("ANIO_ID") INTERVAL (1) 
                            	(PARTITION "P1" VALUES LESS THAN (2015)
                               '', :error); END;';
		 execute immediate V_SQL USING OUT error;
     DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_TAR_ANIO');


      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_TAR_ANIO_IX'', ''H_TAR_ANIO (ANIO_ID, TAREA_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_TAR_ANIO_VENC_IX'', ''H_TAR_ANIO (ANIO_ID, FECHA_VENCIMIENTO_TAREA, TAREA_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_TAR_ANIO_PRC_IX'', ''H_TAR_ANIO (ANIO_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_TAR_ANIO');

    

    ------------------------------ TMP_TAR_JERARQUIA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_TAR_JERARQUIA'',
						  ''DIA_ID DATE NOT NULL,
                            ITER NUMBER(16,0) NOT NULL,
                            FASE_ACTUAL NUMBER(16,0)
                               '', :error); END;';
		 execute immediate V_SQL USING OUT error;
     DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_TAR_JERARQUIA');


      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_TAR_JRQ_FASE_ACT_IX'', ''TMP_TAR_JERARQUIA (DIA_ID, FASE_ACTUAL)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_TAR_JERARQUIA');

    

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;

  end;

END CREAR_H_TAREA;
