create or replace PROCEDURE CREAR_H_PRE_DET_LIQ (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Jaime Sánchez-Cuenca Bellido, PFS Group
-- Fecha creacion: Agosto 2015
-- Responsable ultima modificacion: María Villanueva, PFS Group
-- Fecha ultima modificacion: 13/11/2015
-- Motivos del cambio: usuario propietario
-- Cliente: Recovery BI Haya
--
-- Descripcion: Procedimiento almancenado que crea las tablas del Hecho Precontecioso Detalle Liquidación
-- ===============================================================================================

-- -------------------------------------------- INDICE -------------------------------------------
-- HECHO PRECONTENCIOSO DETALLE BUROFAX
    -- TMP_H_PRE_DET_LIQ
    -- H_PRE_DET_LIQ
    -- H_PRE_DET_LIQ_SEMANA
    -- H_PRE_DET_LIQ_MES
    -- H_PRE_DET_LIQ_TRIMESTRE
    -- H_PRE_DET_LIQ_ANIO
    
BEGIN
  declare
  nCount NUMBER;
  V_SQL VARCHAR2(16000);
  V_NOMBRE VARCHAR2(50) := 'CREAR_H_PRE_DET_LIQ';

  begin

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;

------------------------------ TMP_H_PRE_DET_LIQ --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_H_PRE_DET_LIQ'', 
                            ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ultimo dia cargado
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              LIQUIDACION_ID NUMBER(16,0) NOT NULL,
                              ESTADO_LIQUIDACION_ID NUMBER(16,0),
                              ESTADO_LIQ_PER_ANT_ID NUMBER(16,0),
                              CONTRATO_ID NUMBER(16,0),
                              FECHA_SOLICITUD_LIQ DATE,
                              FECHA_RECEP_LIQ  DATE,
                              FECHA_CONFIRMACION_LIQ DATE,
                              FECHA_CIERRE_LIQ DATE,
                              NUM_LIQUIDACIONES INTEGER,
                              CAPITAL_VENCIDO_LIQ NUMBER(14,2),
                              CAPITAL_NO_VENCIDO_LIQ NUMBER(14,2),
                              INTERESES_ORDINARIOS_LIQ NUMBER(14,2),
                              INTERESES_DEMORA_LIQ NUMBER(14,2),
                              COMISIONES_LIQ NUMBER(14,2),
                              GASTOS_LIQ  NUMBER(14,2),
                              TOTAL_LIQ  NUMBER(14,2),
                              P_LIQ_SOLICITUD_CIERRE INTEGER'', :error); END;';
   execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_H_PRE_DET_LIQ');

   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_PRE_DET_LIQ_IX'', ''  TMP_H_PRE_DET_LIQ (DIA_ID, PROCEDIMIENTO_ID, LIQUIDACION_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

    
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRE_DET_LIQ');
    

    ------------------------------ H_PRE_DET_LIQ --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_DET_LIQ'', 
                            ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ultimo dia cargado
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              LIQUIDACION_ID NUMBER(16,0) NOT NULL,
                              ESTADO_LIQUIDACION_ID NUMBER(16,0),
                              ESTADO_LIQ_PER_ANT_ID NUMBER(16,0),
                              CONTRATO_ID NUMBER(16,0),
                              FECHA_SOLICITUD_LIQ DATE,
                              FECHA_RECEP_LIQ  DATE,
                              FECHA_CONFIRMACION_LIQ DATE,
                              FECHA_CIERRE_LIQ DATE,
                              NUM_LIQUIDACIONES INTEGER,
                              CAPITAL_VENCIDO_LIQ NUMBER(14,2),
                              CAPITAL_NO_VENCIDO_LIQ NUMBER(14,2),
                              INTERESES_ORDINARIOS_LIQ NUMBER(14,2),
                              INTERESES_DEMORA_LIQ NUMBER(14,2),
                              COMISIONES_LIQ NUMBER(14,2),
                              GASTOS_LIQ  NUMBER(14,2),
                              TOTAL_LIQ  NUMBER(14,2),
                              P_LIQ_SOLICITUD_CIERRE INTEGER )
			  SEGMENT CREATION IMMEDIATE 
					TABLESPACE "recovery_haya02_DWH" 
                    PARTITION BY RANGE ("DIA_ID")
                    INTERVAL(NUMTOYMINTERVAL(1, ''''MONTH''''))
                    (PARTITION "p1" VALUES LESS THAN (TO_DATE('''' 2014-11-01 00:00:00'''', ''''SYYYY-MM-DD HH24:MI:SS'''', ''''NLS_CALENDAR=GREGORIAN''''))'', :error); END;';
	 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRE_DET_LIQ');

   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_LIQ_IX'', '' H_PRE_DET_LIQ (DIA_ID, PROCEDIMIENTO_ID, LIQUIDACION_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

 
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRE_DET_LIQ');
    

    ------------------------------ H_PRE_DET_LIQ_SEMANA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_DET_LIQ_SEMANA'', 
                            ''SEMANA_ID NUMBER(16,0) NOT NULL, 
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ultimo dia cargado
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              LIQUIDACION_ID NUMBER(16,0) NOT NULL,
                              ESTADO_LIQUIDACION_ID NUMBER(16,0),
                              ESTADO_LIQ_PER_ANT_ID NUMBER(16,0),
                              CONTRATO_ID NUMBER(16,0),
                              FECHA_SOLICITUD_LIQ DATE,
                              FECHA_RECEP_LIQ  DATE,
                              FECHA_CONFIRMACION_LIQ DATE,
                              FECHA_CIERRE_LIQ DATE,
                              NUM_LIQUIDACIONES INTEGER,
                              CAPITAL_VENCIDO_LIQ NUMBER(14,2),
                              CAPITAL_NO_VENCIDO_LIQ NUMBER(14,2),
                              INTERESES_ORDINARIOS_LIQ NUMBER(14,2),
                              INTERESES_DEMORA_LIQ NUMBER(14,2),
                              COMISIONES_LIQ NUMBER(14,2),
                              GASTOS_LIQ  NUMBER(14,2),
                              TOTAL_LIQ  NUMBER(14,2),
                              P_LIQ_SOLICITUD_CIERRE INTEGER )
                              SEGMENT CREATION IMMEDIATE NOLOGGING
                           	TABLESPACE "recovery_haya02_DWH"   
                           	PARTITION BY RANGE ("SEMANA_ID") INTERVAL (1) 
                           	(PARTITION "P1" VALUES LESS THAN (201501) 
                           	TABLESPACE "recovery_haya02_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRE_DET_LIQ_SEMANA');

   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_LIQ_SEMANA_IX'', ''  H_PRE_DET_LIQ_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID, LIQUIDACION_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

    
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRE_DET_LIQ_SEMANA');
        
    
    ------------------------------ H_PRE_DET_LIQ_MES --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_DET_LIQ_MES'', 
                            ''MES_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ultimo dia cargado
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              LIQUIDACION_ID NUMBER(16,0) NOT NULL,
                              ESTADO_LIQUIDACION_ID NUMBER(16,0),
                              ESTADO_LIQ_PER_ANT_ID NUMBER(16,0),
                              CONTRATO_ID NUMBER(16,0),
                              FECHA_SOLICITUD_LIQ DATE,
                              FECHA_RECEP_LIQ  DATE,
                              FECHA_CONFIRMACION_LIQ DATE,
                              FECHA_CIERRE_LIQ DATE,
                              NUM_LIQUIDACIONES INTEGER,
                              CAPITAL_VENCIDO_LIQ NUMBER(14,2),
                              CAPITAL_NO_VENCIDO_LIQ NUMBER(14,2),
                              INTERESES_ORDINARIOS_LIQ NUMBER(14,2),
                              INTERESES_DEMORA_LIQ NUMBER(14,2),
                              COMISIONES_LIQ NUMBER(14,2),
                              GASTOS_LIQ  NUMBER(14,2),
                              TOTAL_LIQ  NUMBER(14,2),
                              P_LIQ_SOLICITUD_CIERRE INTEGER
                           )
                              SEGMENT CREATION IMMEDIATE NOLOGGING
                           	TABLESPACE "recovery_haya02_DWH"   
                           	PARTITION BY RANGE ("MES_ID") INTERVAL (1) 
                           	(PARTITION "P1" VALUES LESS THAN (201501) 
                           	TABLESPACE "recovery_haya02_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H__PRE_DET_LIQ_MES');

    
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_LIQ_MES_IX'', ''  H_PRE_DET_LIQ_MES (MES_ID, PROCEDIMIENTO_ID, LIQUIDACION_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRE_DET_LIQ_MES');
    
    
    ------------------------------ H_PRE_DET_LIQ_TRIMESTRE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_DET_LIQ_TRIMESTRE'', 
                            ''TRIMESTRE_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ultimo dia cargado
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              LIQUIDACION_ID NUMBER(16,0) NOT NULL,
                              ESTADO_LIQUIDACION_ID NUMBER(16,0),
                              ESTADO_LIQ_PER_ANT_ID NUMBER(16,0),
                              CONTRATO_ID NUMBER(16,0),
                              FECHA_SOLICITUD_LIQ DATE,
                              FECHA_RECEP_LIQ  DATE,
                              FECHA_CONFIRMACION_LIQ DATE,
                              FECHA_CIERRE_LIQ DATE,
                              NUM_LIQUIDACIONES INTEGER,
                              CAPITAL_VENCIDO_LIQ NUMBER(14,2),
                              CAPITAL_NO_VENCIDO_LIQ NUMBER(14,2),
                              INTERESES_ORDINARIOS_LIQ NUMBER(14,2),
                              INTERESES_DEMORA_LIQ NUMBER(14,2),
                              COMISIONES_LIQ NUMBER(14,2),
                              GASTOS_LIQ  NUMBER(14,2),
                              TOTAL_LIQ  NUMBER(14,2),
                              P_LIQ_SOLICITUD_CIERRE INTEGER
                          )
                              SEGMENT CREATION IMMEDIATE NOLOGGING
                            	TABLESPACE "recovery_haya02_DWH"   
                            	PARTITION BY RANGE ("TRIMESTRE_ID") INTERVAL (1) 
                            	(PARTITION "P1" VALUES LESS THAN (201501) 
                            	TABLESPACE "recovery_haya02_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRE_DET_LIQ_TRIMESTRE');

   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_LIQ_TRIMESTRE_IX'', ''  H_PRE_DET_LIQ_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID, LIQUIDACION_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRE_DET_LIQ_TRIMESTRE');
    

    ------------------------------ H_PRE_DET_LIQ_ANIO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_DET_LIQ_ANIO'', 
                            ''ANIO_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ultimo dia cargado
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              LIQUIDACION_ID NUMBER(16,0) NOT NULL,
                              ESTADO_LIQUIDACION_ID NUMBER(16,0),
                              ESTADO_LIQ_PER_ANT_ID NUMBER(16,0),
                              CONTRATO_ID NUMBER(16,0),
                              FECHA_SOLICITUD_LIQ DATE,
                              FECHA_RECEP_LIQ  DATE,
                              FECHA_CONFIRMACION_LIQ DATE,
                              FECHA_CIERRE_LIQ DATE,
                              NUM_LIQUIDACIONES INTEGER,
                              CAPITAL_VENCIDO_LIQ NUMBER(14,2),
                              CAPITAL_NO_VENCIDO_LIQ NUMBER(14,2),
                              INTERESES_ORDINARIOS_LIQ NUMBER(14,2),
                              INTERESES_DEMORA_LIQ NUMBER(14,2),
                              COMISIONES_LIQ NUMBER(14,2),
                              GASTOS_LIQ  NUMBER(14,2),
                              TOTAL_LIQ  NUMBER(14,2),
                              P_LIQ_SOLICITUD_CIERRE INTEGER
                           )
                             SEGMENT CREATION IMMEDIATE NOLOGGING
                            	TABLESPACE "recovery_haya02_DWH"   
                            	PARTITION BY RANGE ("ANIO_ID") INTERVAL (1) 
                            	(PARTITION "P1" VALUES LESS THAN (2015) 
                            	TABLESPACE "recovery_haya02_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRE_DET_LIQ_ANIO');

   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_LIQ_ANIO_IX'', ''  H_PRE_DET_LIQ_ANIO (ANIO_ID, PROCEDIMIENTO_ID, LIQUIDACION_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRE_DET_LIQ_ANIO');
    

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;

  end;

END CREAR_H_PRE_DET_LIQ;
