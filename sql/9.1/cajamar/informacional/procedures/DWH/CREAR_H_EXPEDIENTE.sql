create or replace PROCEDURE CREAR_H_EXPEDIENTE (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Gonzalo Martin, PFS Group
-- Fecha creacion: Mayo 2014
-- Responsable ultima modificacion: María Villanueva, PFS Group
-- Fecha Última modificación: 01/12/2015
-- Motivos del cambio: usuario propietario
-- Cliente: Recovery BI Cajamar
--
-- Descripcion: Procedimiento almancenado que crea las tablas del Hecho Expediente
-- ===============================================================================================

-- -------------------------------------------- INDICE -------------------------------------------
-- HECHO EXPEDIENTE
    -- H_EXP
    -- TMP_H_EXP
    -- H_EXP_SEMANA
    -- H_EXP_MES
    -- H_EXP_TRIMESTRE
    -- H_EXP_ANIO        
    -- TMP_EXP_CNT
    -- TMP_EXP_ACCIONES    
    -- H_EXP_DET_CICLO_REC
    -- TMP_EXP_DET_CICLO_REC
    -- TMP_EXP_ENTSAL_D1
    -- TMP_EXP_ENTSAL_D2
    -- H_EXP_DET_CICLO_REC_SEMANA
    -- H_EXP_DET_CICLO_REC_MES
    -- H_EXP_DET_CICLO_REC_TRIMESTRE
    -- H_EXP_DET_CICLO_REC_ANIO
    
BEGIN

  declare
  nCount NUMBER;
   V_SQL varchar2(16000);
  V_NOMBRE VARCHAR2(50) := 'CREAR_H_EXPEDIENTE';

  begin

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
    
    ------------------------------ H_EXP --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_EXP'',
						  ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                          -- Fecha ultimo dia cargado
                              EXPEDIENTE_ID NUMBER(16,0) NOT NULL,                      -- ID del expediente
                              FECHA_CREACION_EXPEDIENTE DATE ,
                              FECHA_ROTURA_EXPEDIENTE DATE ,
                              FECHA_ENTRADA_AGENCIA_EXP DATE ,
                              FECHA_SALIDA_AGENCIA_EXP DATE ,
                              FECHA_OFRECIMIENTO_PROPUESTA DATE ,
                              FECHA_FORMALIZACION_PROPUESTA DATE ,
                              FECHA_SANCION_PROPUESTA DATE ,
                              FECHA_ACTIVACION_INCIDENCIA DATE ,
                              FECHA_RESOLUCION_INCIDENCIA DATE ,
                              FECHA_ELEVACION_COMITE DATE ,
                              FECHA_ULTIMO_COBRO DATE ,
                              FECHA_MEJOR_GESTION DATE ,
							  FECHA_INICIO_CE DATE,
							  FECHA_INICIO_RE DATE,
							  FECHA_INICIO_DC DATE,
                              FECHA_INICIO_FP DATE,
							  FECHA_FIN_CE DATE,
							  FECHA_FIN_RE DATE,
							  FECHA_FIN_DC DATE,
                              FECHA_FIN_FP DATE,
                              -- Dimensiones
                              ENVIADO_AGENCIA_EXP_ID NUMBER(16,0)  ,
                              ESQUEMA_EXPEDIENTE_ID NUMBER(16,0)  ,
                              AGENCIA_EXPEDIENTE_ID NUMBER(16,0)  ,
                              SUBCARTERA_EXPEDIENTE_ID NUMBER(16,0)  ,
                              TIPO_SALIDA_ID NUMBER(16,0)  ,
                              MOTIVO_SALIDA_ID NUMBER(16,0)  ,
                              TIPO_PALANCA_ID NUMBER(16,0)  ,
                              ESTADO_PALANCA_ID NUMBER(16,0)  ,
                              TIPO_SANCION_ID NUMBER(16,0)  ,
                              TIPO_INCIDENCIA_ID NUMBER(16,0)  ,
                              ESTADO_INCIDENCIA_ID NUMBER(16,0)  ,
                              TIPO_GESTION_EXP_ID NUMBER(16,0),  
                              RESULTADO_GESTION_EXP_ID NUMBER(16,0)  ,
                              T_SALDO_TOTAL_EXP_ID NUMBER(16,0)  ,
                              T_SALDO_IRREGULAR_EXP_ID NUMBER(16,0)  ,
                              T_DEUDA_IRREGULAR_EXP_ID NUMBER(16,0) ,
                              T_DEUDA_IRREGULAR_ENV_EXP_ID NUMBER(16,0) ,
                              T_ROTACIONES_EXP_ID NUMBER(16,0)  ,
                              TD_ENTRADA_GEST_EXP_ID NUMBER(16,0) ,
                              TD_CREACION_EXP_COBRO_ID NUMBER(16,0)  ,                              
                GESTOR_EXP_ID NUMBER(16,0)  ,
                GESTOR_COMITE_EXP_ID NUMBER(16,0)  ,
                SUPERVISOR_EXP_ID NUMBER(16,0)  ,
                FASE_EXPEDIENTE_ID NUMBER(16,0)  ,
                ESTADO_EXPEDIENTE_ID NUMBER(16,0)  ,                
                              -- Metricas
                              NUM_EXPEDIENTES INTEGER ,
                              NUM_CONTRATOS INTEGER ,
                              NUM_COBROS INTEGER ,
                              NUM_ROTACIONES INTEGER ,
                              NUM_DIAS_CREACION_A_ROTURA INTEGER ,
                              NUM_DIAS_CREACION INTEGER ,
                              NUM_DIAS_SANCION_FORMALIZACION INTEGER ,
                              NUM_DIAS_ACTIVACION_RESOLUCION INTEGER ,
                              NUM_DIAS_OFREC_PROPUESTA INTEGER ,
                              NUM_DIAS_COMITE_SANCION INTEGER ,
                              NUM_DIAS_CREACION_EXP_COBRO INTEGER ,
							  NUM_DIAS_COMPLETAR_A_REVISION INTEGER ,
							  NUM_DIAS_REVISION_A_DECISION INTEGER ,
							  NUM_DIAS_COMPLETAR_A_DECISION INTEGER ,
                              NUM_DIAS_DECISION_A_FORMALIZAR INTEGER ,
							  NUM_DIAS_ACTUAL_A_COMPLETAR INTEGER ,
							  NUM_DIAS_ACTUAL_A_REVISION INTEGER ,
							  NUM_DIAS_ACTUAL_A_DECISION INTEGER ,
                              NUM_DIAS_ACTUAL_A_FORMALIZAR INTEGER,
                              SALDO_VENCIDO NUMBER(14,2)  ,                            -- Saldo vencido de los contratos asociados al expediente
                              SALDO_NO_VENCIDO NUMBER(14,2)  ,                         -- Saldo no vencido de los contratos asociados al expediente
                              SALDO_NO_VENCIDO_ENV_AGENCIA NUMBER(14,2)  ,             -- Saldo no vencido de los contratos asociados al expediente enviados a agencia  
                              SALDO_TOTAL NUMBER(14,2)  ,                              -- Suma de los saldos vencido y no vencido de los contratos asociados al expediente
                              RIESGO_VIVO NUMBER(14,2)  ,                              -- Riesgo vivo de los contratos asociados al expediente
                              RIESGO_VIVO_ENV_AGENCIA NUMBER(14,2)  ,                  -- Riesgo vivo de los contratos asociados al expediente enviados a agencia
                              DEUDA_IRREGULAR NUMBER(14,2) ,                           -- Deuda irregular de los contratos asociados al expediente
                              DEUDA_IRREGULAR_ENV_AGENCIA NUMBER(14,2) ,               -- Deuda irregular de los contratos asociados al expediente enviados a agencia
                              SALDO_DUDOSO NUMBER(14,2)  ,                             -- Saldo dudoso de los contratos asociados al expediente
                              SALDO_A_RECLAMAR NUMBER(14,2)  ,                         -- Saldo a reclamar de los contratos asociados al expediente
                              IMPORTE_COBROS NUMBER(14,2)  ,                           -- Importe de los cobros asociados a contratos del expediente
                              INTERESES_REMUNERATORIOS NUMBER(14,2) DEFAULT NULL,      -- INTEGERereses remuneratorios de los contratos asociados al expediente
                              INTERESES_MORATORIOS NUMBER(14,2) DEFAULT NULL,          -- INTEGERereses moratorios de los contratos asociados al expediente
                              COMISIONES NUMBER(14,2)  ,                               -- Comsiones de los contratos asociados al expediente
                              GASTOS NUMBER(14,2),                                     -- Gastos de los contratos asociados al expediente
                              IMPORTE_COMPROMETIDO NUMBER(14,2))
			  SEGMENT CREATION IMMEDIATE 
					TABLESPACE "RECOVERY_CM_DWH" 
                    PARTITION BY RANGE ("DIA_ID")
                    INTERVAL(NUMTOYMINTERVAL(1, ''''MONTH''''))
                    (PARTITION "p1" VALUES LESS THAN (TO_DATE('''' 2014-11-01 00:00:00'''', ''''SYYYY-MM-DD HH24:MI:SS'''', ''''NLS_CALENDAR=GREGORIAN''''))'', :error); END;';
	 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_EXP');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_IX'', ''H_EXP (DIA_ID, EXPEDIENTE_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_EXP');
    


    ------------------------------ TMP_H_EXP --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_H_EXP'',
						  ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                          -- Fecha ultimo dia cargado
                              EXPEDIENTE_ID NUMBER(16,0) NOT NULL,                      -- ID del expediente
                              FECHA_CREACION_EXPEDIENTE DATE ,
                              FECHA_ROTURA_EXPEDIENTE DATE ,
                              FECHA_ENTRADA_AGENCIA_EXP DATE ,
                              FECHA_SALIDA_AGENCIA_EXP DATE ,
                              FECHA_OFRECIMIENTO_PROPUESTA DATE ,
                              FECHA_FORMALIZACION_PROPUESTA DATE ,
                              FECHA_SANCION_PROPUESTA DATE ,
                              FECHA_ACTIVACION_INCIDENCIA DATE ,
                              FECHA_RESOLUCION_INCIDENCIA DATE ,
                              FECHA_ELEVACION_COMITE DATE ,
                              FECHA_ULTIMO_COBRO DATE ,
                              FECHA_MEJOR_GESTION DATE ,
							  FECHA_INICIO_CE DATE,
							  FECHA_INICIO_RE DATE,
							  FECHA_INICIO_DC DATE,
                              FECHA_INICIO_FP DATE,
							  FECHA_FIN_CE DATE,
							  FECHA_FIN_RE DATE,
							  FECHA_FIN_DC DATE,
                              FECHA_FIN_FP DATE,
                              -- Dimensiones
                              ENVIADO_AGENCIA_EXP_ID NUMBER(16,0)  ,
                              ESQUEMA_EXPEDIENTE_ID NUMBER(16,0)  ,
                              AGENCIA_EXPEDIENTE_ID NUMBER(16,0)  ,
                              SUBCARTERA_EXPEDIENTE_ID NUMBER(16,0)  ,
                              TIPO_SALIDA_ID NUMBER(16,0)  ,
                              MOTIVO_SALIDA_ID NUMBER(16,0)  ,
                              TIPO_PALANCA_ID NUMBER(16,0)  ,
                              ESTADO_PALANCA_ID NUMBER(16,0)  ,
                              TIPO_SANCION_ID NUMBER(16,0)  ,
                              TIPO_INCIDENCIA_ID NUMBER(16,0)  ,
                              ESTADO_INCIDENCIA_ID NUMBER(16,0)  ,
                              TIPO_GESTION_EXP_ID NUMBER(16,0),  
                              RESULTADO_GESTION_EXP_ID NUMBER(16,0)  ,
                              T_SALDO_TOTAL_EXP_ID NUMBER(16,0)  ,
                              T_SALDO_IRREGULAR_EXP_ID NUMBER(16,0)  ,
                              T_DEUDA_IRREGULAR_EXP_ID NUMBER(16,0) ,
                              T_DEUDA_IRREGULAR_ENV_EXP_ID NUMBER(16,0) ,
                              T_ROTACIONES_EXP_ID NUMBER(16,0)  ,
                              TD_ENTRADA_GEST_EXP_ID NUMBER(16,0) ,
                              TD_CREACION_EXP_COBRO_ID NUMBER(16,0)  ,
                GESTOR_EXP_ID NUMBER(16,0)  ,
                GESTOR_COMITE_EXP_ID NUMBER(16,0)  ,
                SUPERVISOR_EXP_ID NUMBER(16,0)  ,
                FASE_EXPEDIENTE_ID NUMBER(16,0)  ,
                ESTADO_EXPEDIENTE_ID NUMBER(16,0)  ,                
                              -- Metricas
                              NUM_EXPEDIENTES INTEGER ,
                              NUM_CONTRATOS INTEGER ,
                              NUM_COBROS INTEGER ,
                              NUM_ROTACIONES INTEGER ,
                              NUM_DIAS_CREACION_A_ROTURA INTEGER ,
                              NUM_DIAS_CREACION INTEGER ,
                              NUM_DIAS_SANCION_FORMALIZACION INTEGER ,
                              NUM_DIAS_ACTIVACION_RESOLUCION INTEGER ,
                              NUM_DIAS_OFREC_PROPUESTA INTEGER ,
                              NUM_DIAS_COMITE_SANCION INTEGER ,
                              NUM_DIAS_CREACION_EXP_COBRO INTEGER ,
							  NUM_DIAS_COMPLETAR_A_REVISION INTEGER ,
							  NUM_DIAS_REVISION_A_DECISION INTEGER ,
							  NUM_DIAS_COMPLETAR_A_DECISION INTEGER ,
                              NUM_DIAS_DECISION_A_FORMALIZAR INTEGER ,
							  NUM_DIAS_ACTUAL_A_COMPLETAR INTEGER ,
							  NUM_DIAS_ACTUAL_A_REVISION INTEGER ,
							  NUM_DIAS_ACTUAL_A_DECISION INTEGER ,
                              NUM_DIAS_ACTUAL_A_FORMALIZAR INTEGER,
                              SALDO_VENCIDO NUMBER(14,2)  ,                            -- Saldo vencido de los contratos asociados al expediente
                              SALDO_NO_VENCIDO NUMBER(14,2)  ,                         -- Saldo no vencido de los contratos asociados al expediente
                              SALDO_NO_VENCIDO_ENV_AGENCIA NUMBER(14,2)  ,             -- Saldo no vencido de los contratos asociados al expediente enviados a agencia  
                              SALDO_TOTAL NUMBER(14,2)  ,                              -- Suma de los saldos vencido y no vencido de los contratos asociados al expediente
                              RIESGO_VIVO NUMBER(14,2)  ,                              -- Riesgo vivo de los contratos asociados al expediente
                              RIESGO_VIVO_ENV_AGENCIA NUMBER(14,2)  ,                  -- Riesgo vivo de los contratos asociados al expediente enviados a agencia
                              DEUDA_IRREGULAR NUMBER(14,2) ,                           -- Deuda irregular de los contratos asociados al expediente
                              DEUDA_IRREGULAR_ENV_AGENCIA NUMBER(14,2) ,               -- Deuda irregular de los contratos asociados al expediente enviados a agencia
                              SALDO_DUDOSO NUMBER(14,2)  ,                             -- Saldo dudoso de los contratos asociados al expediente
                              SALDO_A_RECLAMAR NUMBER(14,2)  ,                         -- Saldo a reclamar de los contratos asociados al expediente
                              IMPORTE_COBROS NUMBER(14,2)  ,                           -- Importe de los cobros asociados a contratos del expediente
                              INTERESES_REMUNERATORIOS NUMBER(14,2) DEFAULT NULL,      -- INTEGERereses remuneratorios de los contratos asociados al expediente
                              INTERESES_MORATORIOS NUMBER(14,2) DEFAULT NULL,          -- INTEGERereses moratorios de los contratos asociados al expediente
                              COMISIONES NUMBER(14,2)  ,                               -- Comsiones de los contratos asociados al expediente
                              GASTOS NUMBER(14,2),                                     -- Gastos de los contratos asociados al expediente
                              IMPORTE_COMPROMETIDO NUMBER(14,2)                        -- Importe comprometido mediante acciones extrajudiciales
                            '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_H_EXP');

       V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_EXP_IX'', ''TMP_H_EXP (DIA_ID, EXPEDIENTE_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_EXP_CNT_IX'', ''TMP_H_EXP (EXPEDIENTE_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_H_EXP');
    
    
    ------------------------------ H_EXP_SEMANA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_EXP_SEMANA'',
						  ''SEMANA_ID NUMBER(16,0) NOT NULL,                                   -- Semana de analisis
                              FECHA_CARGA_DATOS DATE NOT NULL,                                    -- Fecha ultimo dia cargado
                              EXPEDIENTE_ID NUMBER(16,0) NOT NULL,                               -- ID del expediente
                              FECHA_CREACION_EXPEDIENTE DATE ,
                              FECHA_ROTURA_EXPEDIENTE DATE ,
                              FECHA_ENTRADA_AGENCIA_EXP DATE ,
                              FECHA_SALIDA_AGENCIA_EXP DATE ,
                              FECHA_OFRECIMIENTO_PROPUESTA DATE ,
                              FECHA_FORMALIZACION_PROPUESTA DATE ,
                              FECHA_SANCION_PROPUESTA DATE ,
                              FECHA_ACTIVACION_INCIDENCIA DATE ,
                              FECHA_RESOLUCION_INCIDENCIA DATE ,
                              FECHA_ELEVACION_COMITE DATE ,
                              FECHA_ULTIMO_COBRO DATE ,
                              FECHA_MEJOR_GESTION DATE ,
							  FECHA_INICIO_CE DATE,
							  FECHA_INICIO_RE DATE,
							  FECHA_INICIO_DC DATE,
                              FECHA_INICIO_FP DATE,
							  FECHA_FIN_CE DATE,
							  FECHA_FIN_RE DATE,
							  FECHA_FIN_DC DATE,
                              FECHA_FIN_FP DATE,
                              -- Dimensiones
                              ENVIADO_AGENCIA_EXP_ID NUMBER(16,0)  ,
                              ESQUEMA_EXPEDIENTE_ID NUMBER(16,0)  ,
                              AGENCIA_EXPEDIENTE_ID NUMBER(16,0)  ,
                              SUBCARTERA_EXPEDIENTE_ID NUMBER(16,0)  ,
                              TIPO_SALIDA_ID NUMBER(16,0)  ,
                              MOTIVO_SALIDA_ID NUMBER(16,0)  ,
                              TIPO_PALANCA_ID NUMBER(16,0)  ,
                              ESTADO_PALANCA_ID NUMBER(16,0)  ,
                              TIPO_SANCION_ID NUMBER(16,0)  ,
                              TIPO_INCIDENCIA_ID NUMBER(16,0)  ,
                              ESTADO_INCIDENCIA_ID NUMBER(16,0)  ,
                              TIPO_GESTION_EXP_ID NUMBER(16,0),  
                              RESULTADO_GESTION_EXP_ID NUMBER(16,0)  ,
                              T_SALDO_TOTAL_EXP_ID NUMBER(16,0)  ,
                              T_SALDO_IRREGULAR_EXP_ID NUMBER(16,0)  ,
                              T_DEUDA_IRREGULAR_EXP_ID NUMBER(16,0) ,
                              T_DEUDA_IRREGULAR_ENV_EXP_ID NUMBER(16,0) ,
                              T_ROTACIONES_EXP_ID NUMBER(16,0)  ,
                              TD_ENTRADA_GEST_EXP_ID NUMBER(16,0) ,
                              TD_CREACION_EXP_COBRO_ID NUMBER(16,0)  ,
                GESTOR_EXP_ID NUMBER(16,0)  ,
                GESTOR_COMITE_EXP_ID NUMBER(16,0)  ,
                SUPERVISOR_EXP_ID NUMBER(16,0)  ,
                FASE_EXPEDIENTE_ID NUMBER(16,0)  ,
                ESTADO_EXPEDIENTE_ID NUMBER(16,0)  ,                
                              -- Metricas
                              NUM_EXPEDIENTES INTEGER ,
                              NUM_CONTRATOS INTEGER ,
                              NUM_COBROS INTEGER ,
                              NUM_ROTACIONES INTEGER ,
                              NUM_DIAS_CREACION_A_ROTURA INTEGER ,
                              NUM_DIAS_CREACION INTEGER ,
                              NUM_DIAS_SANCION_FORMALIZACION INTEGER ,
                              NUM_DIAS_ACTIVACION_RESOLUCION INTEGER ,
                              NUM_DIAS_OFREC_PROPUESTA INTEGER ,
                              NUM_DIAS_COMITE_SANCION INTEGER ,
                              NUM_DIAS_CREACION_EXP_COBRO INTEGER ,
							  NUM_DIAS_COMPLETAR_A_REVISION INTEGER ,
							  NUM_DIAS_REVISION_A_DECISION INTEGER ,
							  NUM_DIAS_COMPLETAR_A_DECISION INTEGER ,
                              NUM_DIAS_DECISION_A_FORMALIZAR INTEGER ,
							  NUM_DIAS_ACTUAL_A_COMPLETAR INTEGER ,
							  NUM_DIAS_ACTUAL_A_REVISION INTEGER ,
							  NUM_DIAS_ACTUAL_A_DECISION INTEGER ,
                              NUM_DIAS_ACTUAL_A_FORMALIZAR INTEGER,
                              SALDO_VENCIDO NUMBER(14,2)  ,                            -- Saldo vencido de los contratos asociados al expediente
                              SALDO_NO_VENCIDO NUMBER(14,2)  ,                         -- Saldo no vencido de los contratos asociados al expediente
                              SALDO_NO_VENCIDO_ENV_AGENCIA NUMBER(14,2)  ,             -- Saldo no vencido de los contratos asociados al expediente enviados a agencia  
                              SALDO_TOTAL NUMBER(14,2)  ,                              -- Suma de los saldos vencido y no vencido de los contratos asociados al expediente
                              RIESGO_VIVO NUMBER(14,2)  ,                              -- Riesgo vivo de los contratos asociados al expediente
                              RIESGO_VIVO_ENV_AGENCIA NUMBER(14,2)  ,                  -- Riesgo vivo de los contratos asociados al expediente enviados a agencia
                              DEUDA_IRREGULAR NUMBER(14,2) ,                           -- Deuda irregular de los contratos asociados al expediente
                              DEUDA_IRREGULAR_ENV_AGENCIA NUMBER(14,2) ,               -- Deuda irregular de los contratos asociados al expediente enviados a agencia
                              SALDO_DUDOSO NUMBER(14,2)  ,                             -- Saldo dudoso de los contratos asociados al expediente
                              SALDO_A_RECLAMAR NUMBER(14,2)  ,                         -- Saldo a reclamar de los contratos asociados al expediente
                              IMPORTE_COBROS NUMBER(14,2)  ,                           -- Importe de los cobros asociados a contratos del expediente
                              INTERESES_REMUNERATORIOS NUMBER(14,2) DEFAULT NULL,      -- INTEGERereses remuneratorios de los contratos asociados al expediente
                              INTERESES_MORATORIOS NUMBER(14,2) DEFAULT NULL,          -- INTEGERereses moratorios de los contratos asociados al expediente
                              COMISIONES NUMBER(14,2)  ,                               -- Comsiones de los contratos asociados al expediente
                              GASTOS NUMBER(14,2),                                     -- Gastos de los contratos asociados al expediente
                              IMPORTE_COMPROMETIDO NUMBER(14,2)                        -- Importe comprometido mediante acciones extrajudiciales
                              )
                              SEGMENT CREATION IMMEDIATE NOLOGGING
                            TABLESPACE "RECOVERY_CM_DWH"   
                            PARTITION BY RANGE ("SEMANA_ID") INTERVAL (1) 
                           (PARTITION "P1" VALUES LESS THAN (201501) 
                           TABLESPACE "RECOVERY_CM_DWH"'', :error); END;';
	execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_EXP_SEMANA');

       V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_SEMANA_IX'', ''H_EXP_SEMANA (SEMANA_ID,EXPEDIENTE_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_EXP_SEMANA');


    

    ------------------------------ H_EXP_MES --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_EXP_MES'',
						  ''MES_ID NUMBER(16,0) NOT NULL,                            -- Mes de analisis
                              FECHA_CARGA_DATOS DATE NOT NULL,                         -- Fecha ultimo dia cargado
                              EXPEDIENTE_ID NUMBER(16,0) NOT NULL,                     -- ID del expediente
                              FECHA_CREACION_EXPEDIENTE DATE ,
                              FECHA_ROTURA_EXPEDIENTE DATE ,
                              FECHA_ENTRADA_AGENCIA_EXP DATE ,
                              FECHA_SALIDA_AGENCIA_EXP DATE ,
                              FECHA_OFRECIMIENTO_PROPUESTA DATE ,
                              FECHA_FORMALIZACION_PROPUESTA DATE ,
                              FECHA_SANCION_PROPUESTA DATE ,
                              FECHA_ACTIVACION_INCIDENCIA DATE ,
                              FECHA_RESOLUCION_INCIDENCIA DATE ,
                              FECHA_ELEVACION_COMITE DATE ,
                              FECHA_ULTIMO_COBRO DATE ,
                              FECHA_MEJOR_GESTION DATE ,
							  FECHA_INICIO_CE DATE,
							  FECHA_INICIO_RE DATE,
							  FECHA_INICIO_DC DATE,
                              FECHA_INICIO_FP DATE,
							  FECHA_FIN_CE DATE,
							  FECHA_FIN_RE DATE,
							  FECHA_FIN_DC DATE,
                              FECHA_FIN_FP DATE,
                              -- Dimensiones
                              ENVIADO_AGENCIA_EXP_ID NUMBER(16,0)  ,
                              ESQUEMA_EXPEDIENTE_ID NUMBER(16,0)  ,
                              AGENCIA_EXPEDIENTE_ID NUMBER(16,0)  ,
                              SUBCARTERA_EXPEDIENTE_ID NUMBER(16,0)  ,
                              TIPO_SALIDA_ID NUMBER(16,0)  ,
                              MOTIVO_SALIDA_ID NUMBER(16,0)  ,
                              TIPO_PALANCA_ID NUMBER(16,0)  ,
                              ESTADO_PALANCA_ID NUMBER(16,0)  ,
                              TIPO_SANCION_ID NUMBER(16,0)  ,
                              TIPO_INCIDENCIA_ID NUMBER(16,0)  ,
                              ESTADO_INCIDENCIA_ID NUMBER(16,0)  ,
                              TIPO_GESTION_EXP_ID NUMBER(16,0),  
                              RESULTADO_GESTION_EXP_ID NUMBER(16,0)  ,
                              T_SALDO_TOTAL_EXP_ID NUMBER(16,0)  ,
                              T_SALDO_IRREGULAR_EXP_ID NUMBER(16,0)  ,
                              T_DEUDA_IRREGULAR_EXP_ID NUMBER(16,0) ,
                              T_DEUDA_IRREGULAR_ENV_EXP_ID NUMBER(16,0) ,
                              T_ROTACIONES_EXP_ID NUMBER(16,0)  ,
                              TD_ENTRADA_GEST_EXP_ID NUMBER(16,0) ,
                              TD_CREACION_EXP_COBRO_ID NUMBER(16,0)  ,
                GESTOR_EXP_ID NUMBER(16,0)  ,
                GESTOR_COMITE_EXP_ID NUMBER(16,0)  ,
                SUPERVISOR_EXP_ID NUMBER(16,0)  ,
                FASE_EXPEDIENTE_ID NUMBER(16,0)  ,
                ESTADO_EXPEDIENTE_ID NUMBER(16,0)  ,                                              
                              -- Metricas
                              NUM_EXPEDIENTES INTEGER ,
                              NUM_CONTRATOS INTEGER ,
                              NUM_COBROS INTEGER ,
                              NUM_ROTACIONES INTEGER ,
                              NUM_DIAS_CREACION_A_ROTURA INTEGER ,
                              NUM_DIAS_CREACION INTEGER ,
                              NUM_DIAS_SANCION_FORMALIZACION INTEGER ,
                              NUM_DIAS_ACTIVACION_RESOLUCION INTEGER ,
                              NUM_DIAS_OFREC_PROPUESTA INTEGER ,
                              NUM_DIAS_COMITE_SANCION INTEGER ,
                              NUM_DIAS_CREACION_EXP_COBRO INTEGER ,
							  NUM_DIAS_COMPLETAR_A_REVISION INTEGER ,
							  NUM_DIAS_REVISION_A_DECISION INTEGER ,
							  NUM_DIAS_COMPLETAR_A_DECISION INTEGER ,
                              NUM_DIAS_DECISION_A_FORMALIZAR INTEGER ,
							  NUM_DIAS_ACTUAL_A_COMPLETAR INTEGER ,
							  NUM_DIAS_ACTUAL_A_REVISION INTEGER ,
							  NUM_DIAS_ACTUAL_A_DECISION INTEGER ,
                              NUM_DIAS_ACTUAL_A_FORMALIZAR INTEGER,
                              SALDO_VENCIDO NUMBER(14,2)  ,                            -- Saldo vencido de los contratos asociados al expediente
                              SALDO_NO_VENCIDO NUMBER(14,2)  ,                         -- Saldo no vencido de los contratos asociados al expediente
                              SALDO_NO_VENCIDO_ENV_AGENCIA NUMBER(14,2)  ,             -- Saldo no vencido de los contratos asociados al expediente enviados a agencia  
                              SALDO_TOTAL NUMBER(14,2)  ,                              -- Suma de los saldos vencido y no vencido de los contratos asociados al expediente
                              RIESGO_VIVO NUMBER(14,2)  ,                              -- Riesgo vivo de los contratos asociados al expediente
                              RIESGO_VIVO_ENV_AGENCIA NUMBER(14,2)  ,                  -- Riesgo vivo de los contratos asociados al expediente enviados a agencia
                              DEUDA_IRREGULAR NUMBER(14,2) ,                           -- Deuda irregular de los contratos asociados al expediente
                              DEUDA_IRREGULAR_ENV_AGENCIA NUMBER(14,2) ,               -- Deuda irregular de los contratos asociados al expediente enviados a agencia
                              SALDO_DUDOSO NUMBER(14,2)  ,                             -- Saldo dudoso de los contratos asociados al expediente
                              SALDO_A_RECLAMAR NUMBER(14,2)  ,                         -- Saldo a reclamar de los contratos asociados al expediente
                              IMPORTE_COBROS NUMBER(14,2)  ,                           -- Importe de los cobros asociados a contratos del expediente
                              INTERESES_REMUNERATORIOS NUMBER(14,2) DEFAULT NULL,      -- INTEGERereses remuneratorios de los contratos asociados al expediente
                              INTERESES_MORATORIOS NUMBER(14,2) DEFAULT NULL,          -- INTEGERereses moratorios de los contratos asociados al expediente
                              COMISIONES NUMBER(14,2)  ,                               -- Comsiones de los contratos asociados al expediente
                              GASTOS NUMBER(14,2),                                     -- Gastos de los contratos asociados al expediente
                              IMPORTE_COMPROMETIDO NUMBER(14,2)                        -- Importe comprometido mediante acciones extrajudiciales
                             )
                              SEGMENT CREATION IMMEDIATE NOLOGGING
                           	TABLESPACE "RECOVERY_CM_DWH"   
                           	PARTITION BY RANGE ("MES_ID") INTERVAL (1) 
                           	(PARTITION "P1" VALUES LESS THAN (201501) 
                           	TABLESPACE "RECOVERY_CM_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_EXP_MES');

       V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_MES_IX'', ''H_EXP_MES (MES_ID,EXPEDIENTE_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_EXP_MES');


    

    ------------------------------ H_EXP_TRIMESTRE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_EXP_TRIMESTRE'',
						  ''TRIMESTRE_ID NUMBER(16,0) NOT NULL,                      -- Trimestre de analisis
                              FECHA_CARGA_DATOS DATE NOT NULL,                         -- Fecha ultimo dia cargado
                              EXPEDIENTE_ID NUMBER(16,0) NOT NULL,                     -- ID del expediente
                              FECHA_CREACION_EXPEDIENTE DATE ,
                              FECHA_ROTURA_EXPEDIENTE DATE ,
                              FECHA_ENTRADA_AGENCIA_EXP DATE ,
                              FECHA_SALIDA_AGENCIA_EXP DATE ,
                              FECHA_OFRECIMIENTO_PROPUESTA DATE ,
                              FECHA_FORMALIZACION_PROPUESTA DATE ,
                              FECHA_SANCION_PROPUESTA DATE ,
                              FECHA_ACTIVACION_INCIDENCIA DATE ,
                              FECHA_RESOLUCION_INCIDENCIA DATE ,
                              FECHA_ELEVACION_COMITE DATE ,
                              FECHA_ULTIMO_COBRO DATE ,
                              FECHA_MEJOR_GESTION DATE ,
							  FECHA_INICIO_CE DATE,
							  FECHA_INICIO_RE DATE,
							  FECHA_INICIO_DC DATE,
                              FECHA_INICIO_FP DATE,
							  FECHA_FIN_CE DATE,
							  FECHA_FIN_RE DATE,
							  FECHA_FIN_DC DATE,
                              FECHA_FIN_FP DATE,
                              -- Dimensiones
                              ENVIADO_AGENCIA_EXP_ID NUMBER(16,0)  ,
                              ESQUEMA_EXPEDIENTE_ID NUMBER(16,0)  ,
                              AGENCIA_EXPEDIENTE_ID NUMBER(16,0)  ,
                              SUBCARTERA_EXPEDIENTE_ID NUMBER(16,0)  ,
                              TIPO_SALIDA_ID NUMBER(16,0)  ,
                              MOTIVO_SALIDA_ID NUMBER(16,0)  ,
                              TIPO_PALANCA_ID NUMBER(16,0)  ,
                              ESTADO_PALANCA_ID NUMBER(16,0)  ,
                              TIPO_SANCION_ID NUMBER(16,0)  ,
                              TIPO_INCIDENCIA_ID NUMBER(16,0)  ,
                              ESTADO_INCIDENCIA_ID NUMBER(16,0)  ,
                              TIPO_GESTION_EXP_ID NUMBER(16,0),  
                              RESULTADO_GESTION_EXP_ID NUMBER(16,0)  ,
                              T_SALDO_TOTAL_EXP_ID NUMBER(16,0)  ,
                              T_SALDO_IRREGULAR_EXP_ID NUMBER(16,0)  ,
                              T_DEUDA_IRREGULAR_EXP_ID NUMBER(16,0) ,
                              T_DEUDA_IRREGULAR_ENV_EXP_ID NUMBER(16,0) ,
                              T_ROTACIONES_EXP_ID NUMBER(16,0)  ,
                              TD_ENTRADA_GEST_EXP_ID NUMBER(16,0) ,
                              TD_CREACION_EXP_COBRO_ID NUMBER(16,0)  ,
                GESTOR_EXP_ID NUMBER(16,0)  ,
                GESTOR_COMITE_EXP_ID NUMBER(16,0)  ,
                SUPERVISOR_EXP_ID NUMBER(16,0)  ,
                FASE_EXPEDIENTE_ID NUMBER(16,0)  ,
                ESTADO_EXPEDIENTE_ID NUMBER(16,0)  ,                                              
                              -- Metricas
                              NUM_EXPEDIENTES INTEGER ,
                              NUM_CONTRATOS INTEGER ,
                              NUM_COBROS INTEGER ,
                              NUM_ROTACIONES INTEGER ,
                              NUM_DIAS_CREACION_A_ROTURA INTEGER ,
                              NUM_DIAS_CREACION INTEGER ,
                              NUM_DIAS_SANCION_FORMALIZACION INTEGER ,
                              NUM_DIAS_ACTIVACION_RESOLUCION INTEGER ,
                              NUM_DIAS_OFREC_PROPUESTA INTEGER ,
                              NUM_DIAS_COMITE_SANCION INTEGER ,
                              NUM_DIAS_CREACION_EXP_COBRO INTEGER ,
							  NUM_DIAS_COMPLETAR_A_REVISION INTEGER ,
							  NUM_DIAS_REVISION_A_DECISION INTEGER ,
							  NUM_DIAS_COMPLETAR_A_DECISION INTEGER ,
                              NUM_DIAS_DECISION_A_FORMALIZAR INTEGER ,
							  NUM_DIAS_ACTUAL_A_COMPLETAR INTEGER ,
							  NUM_DIAS_ACTUAL_A_REVISION INTEGER ,
							  NUM_DIAS_ACTUAL_A_DECISION INTEGER ,
                              NUM_DIAS_ACTUAL_A_FORMALIZAR INTEGER,
                              SALDO_VENCIDO NUMBER(14,2)  ,                            -- Saldo vencido de los contratos asociados al expediente
                              SALDO_NO_VENCIDO NUMBER(14,2)  ,                         -- Saldo no vencido de los contratos asociados al expediente
                              SALDO_NO_VENCIDO_ENV_AGENCIA NUMBER(14,2)  ,             -- Saldo no vencido de los contratos asociados al expediente enviados a agencia  
                              SALDO_TOTAL NUMBER(14,2)  ,                              -- Suma de los saldos vencido y no vencido de los contratos asociados al expediente
                              RIESGO_VIVO NUMBER(14,2)  ,                              -- Riesgo vivo de los contratos asociados al expediente
                              RIESGO_VIVO_ENV_AGENCIA NUMBER(14,2)  ,                  -- Riesgo vivo de los contratos asociados al expediente enviados a agencia
                              DEUDA_IRREGULAR NUMBER(14,2) ,                           -- Deuda irregular de los contratos asociados al expediente
                              DEUDA_IRREGULAR_ENV_AGENCIA NUMBER(14,2) ,               -- Deuda irregular de los contratos asociados al expediente enviados a agencia
                              SALDO_DUDOSO NUMBER(14,2)  ,                             -- Saldo dudoso de los contratos asociados al expediente
                              SALDO_A_RECLAMAR NUMBER(14,2)  ,                         -- Saldo a reclamar de los contratos asociados al expediente
                              IMPORTE_COBROS NUMBER(14,2)  ,                           -- Importe de los cobros asociados a contratos del expediente
                              INTERESES_REMUNERATORIOS NUMBER(14,2) DEFAULT NULL,      -- INTEGERereses remuneratorios de los contratos asociados al expediente
                              INTERESES_MORATORIOS NUMBER(14,2) DEFAULT NULL,          -- INTEGERereses moratorios de los contratos asociados al expediente
                              COMISIONES NUMBER(14,2)  ,                               -- Comsiones de los contratos asociados al expediente
                              GASTOS NUMBER(14,2),                                     -- Gastos de los contratos asociados al expediente
                              IMPORTE_COMPROMETIDO NUMBER(14,2)                        -- Importe comprometido mediante acciones extrajudiciales
                              )
                              SEGMENT CREATION IMMEDIATE NOLOGGING
                            	TABLESPACE "RECOVERY_CM_DWH"   
                            	PARTITION BY RANGE ("TRIMESTRE_ID") INTERVAL (1) 
                            	(PARTITION "P1" VALUES LESS THAN (201501) 
                            	TABLESPACE "RECOVERY_CM_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_EXP_TRIMESTRE');

       V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_TRIMESTRE_IX'', ''H_EXP_TRIMESTRE (TRIMESTRE_ID,EXPEDIENTE_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_EXP_TRIMESTRE');


    

    ------------------------------ H_EXP_ANIO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_EXP_ANIO'',
						  ''ANIO_ID NUMBER(16,0) NOT NULL,                           -- Ano de analisis
                              FECHA_CARGA_DATOS DATE NOT NULL,                         -- Fecha ultimo dia cargado
                              EXPEDIENTE_ID NUMBER(16,0) NOT NULL,                     -- ID del expediente
                              FECHA_CREACION_EXPEDIENTE DATE ,
                              FECHA_ROTURA_EXPEDIENTE DATE ,
                              FECHA_ENTRADA_AGENCIA_EXP DATE ,
                              FECHA_SALIDA_AGENCIA_EXP DATE ,
                              FECHA_OFRECIMIENTO_PROPUESTA DATE ,
                              FECHA_FORMALIZACION_PROPUESTA DATE ,
                              FECHA_SANCION_PROPUESTA DATE ,
                              FECHA_ACTIVACION_INCIDENCIA DATE ,
                              FECHA_RESOLUCION_INCIDENCIA DATE ,
                              FECHA_ELEVACION_COMITE DATE ,
                              FECHA_ULTIMO_COBRO DATE ,
                              FECHA_MEJOR_GESTION DATE ,
							  FECHA_INICIO_CE DATE,
							  FECHA_INICIO_RE DATE,
							  FECHA_INICIO_DC DATE,
                              FECHA_INICIO_FP DATE,
							  FECHA_FIN_CE DATE,
							  FECHA_FIN_RE DATE,
							  FECHA_FIN_DC DATE,
                              FECHA_FIN_FP DATE,
                              -- Dimensiones
                              ENVIADO_AGENCIA_EXP_ID NUMBER(16,0)  ,
                              ESQUEMA_EXPEDIENTE_ID NUMBER(16,0)  ,
                              AGENCIA_EXPEDIENTE_ID NUMBER(16,0)  ,
                              SUBCARTERA_EXPEDIENTE_ID NUMBER(16,0)  ,
                              TIPO_SALIDA_ID NUMBER(16,0)  ,
                              MOTIVO_SALIDA_ID NUMBER(16,0)  ,
                              TIPO_PALANCA_ID NUMBER(16,0)  ,
                              ESTADO_PALANCA_ID NUMBER(16,0)  ,
                              TIPO_SANCION_ID NUMBER(16,0)  ,
                              TIPO_INCIDENCIA_ID NUMBER(16,0)  ,
                              ESTADO_INCIDENCIA_ID NUMBER(16,0)  ,
                              TIPO_GESTION_EXP_ID NUMBER(16,0),  
                              RESULTADO_GESTION_EXP_ID NUMBER(16,0)  ,
                              T_SALDO_TOTAL_EXP_ID NUMBER(16,0)  ,
                              T_SALDO_IRREGULAR_EXP_ID NUMBER(16,0)  ,
                              T_DEUDA_IRREGULAR_EXP_ID NUMBER(16,0) ,
                              T_DEUDA_IRREGULAR_ENV_EXP_ID NUMBER(16,0) ,
                              T_ROTACIONES_EXP_ID NUMBER(16,0)  ,
                              TD_ENTRADA_GEST_EXP_ID NUMBER(16,0) ,
                              TD_CREACION_EXP_COBRO_ID NUMBER(16,0)  ,
                GESTOR_EXP_ID NUMBER(16,0)  ,
                GESTOR_COMITE_EXP_ID NUMBER(16,0)  ,
                SUPERVISOR_EXP_ID NUMBER(16,0)  ,
                FASE_EXPEDIENTE_ID NUMBER(16,0)  ,
                ESTADO_EXPEDIENTE_ID NUMBER(16,0)  ,                                              
                              -- Metricas
                              NUM_EXPEDIENTES INTEGER ,
                              NUM_CONTRATOS INTEGER ,
                              NUM_COBROS INTEGER ,
                              NUM_ROTACIONES INTEGER ,
                              NUM_DIAS_CREACION_A_ROTURA INTEGER ,
                              NUM_DIAS_CREACION INTEGER ,
                              NUM_DIAS_SANCION_FORMALIZACION INTEGER ,
                              NUM_DIAS_ACTIVACION_RESOLUCION INTEGER ,
                              NUM_DIAS_OFREC_PROPUESTA INTEGER ,
                              NUM_DIAS_COMITE_SANCION INTEGER ,
                              NUM_DIAS_CREACION_EXP_COBRO INTEGER ,
							  NUM_DIAS_COMPLETAR_A_REVISION INTEGER ,
							  NUM_DIAS_REVISION_A_DECISION INTEGER ,
							  NUM_DIAS_COMPLETAR_A_DECISION INTEGER ,
                              NUM_DIAS_DECISION_A_FORMALIZAR INTEGER ,
							  NUM_DIAS_ACTUAL_A_COMPLETAR INTEGER ,
							  NUM_DIAS_ACTUAL_A_REVISION INTEGER ,
							  NUM_DIAS_ACTUAL_A_DECISION INTEGER ,
                              NUM_DIAS_ACTUAL_A_FORMALIZAR INTEGER,
                              SALDO_VENCIDO NUMBER(14,2)  ,                            -- Saldo vencido de los contratos asociados al expediente
                              SALDO_NO_VENCIDO NUMBER(14,2)  ,                         -- Saldo no vencido de los contratos asociados al expediente
                              SALDO_NO_VENCIDO_ENV_AGENCIA NUMBER(14,2)  ,             -- Saldo no vencido de los contratos asociados al expediente enviados a agencia  
                              SALDO_TOTAL NUMBER(14,2)  ,                              -- Suma de los saldos vencido y no vencido de los contratos asociados al expediente
                              RIESGO_VIVO NUMBER(14,2)  ,                              -- Riesgo vivo de los contratos asociados al expediente
                              RIESGO_VIVO_ENV_AGENCIA NUMBER(14,2)  ,                  -- Riesgo vivo de los contratos asociados al expediente enviados a agencia
                              DEUDA_IRREGULAR NUMBER(14,2) ,                           -- Deuda irregular de los contratos asociados al expediente
                              DEUDA_IRREGULAR_ENV_AGENCIA NUMBER(14,2) ,               -- Deuda irregular de los contratos asociados al expediente enviados a agencia
                              SALDO_DUDOSO NUMBER(14,2)  ,                             -- Saldo dudoso de los contratos asociados al expediente
                              SALDO_A_RECLAMAR NUMBER(14,2)  ,                         -- Saldo a reclamar de los contratos asociados al expediente
                              IMPORTE_COBROS NUMBER(14,2)  ,                           -- Importe de los cobros asociados a contratos del expediente
                              INTERESES_REMUNERATORIOS NUMBER(14,2) DEFAULT NULL,      -- INTEGERereses remuneratorios de los contratos asociados al expediente
                              INTERESES_MORATORIOS NUMBER(14,2) DEFAULT NULL,          -- INTEGERereses moratorios de los contratos asociados al expediente
                              COMISIONES NUMBER(14,2)  ,                               -- Comsiones de los contratos asociados al expediente
                              GASTOS NUMBER(14,2),                                     -- Gastos de los contratos asociados al expediente
                              IMPORTE_COMPROMETIDO NUMBER(14,2)                        -- Importe comprometido mediante acciones extrajudiciales
                            )
                             SEGMENT CREATION IMMEDIATE NOLOGGING
                            	TABLESPACE "RECOVERY_CM_DWH"   
                            	PARTITION BY RANGE ("ANIO_ID") INTERVAL (1) 
                            	(PARTITION "P1" VALUES LESS THAN (2015) 
                            	TABLESPACE "RECOVERY_CM_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_EXP_ANIO');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_ANIO_IX'', ''H_EXP_ANIO (ANIO_ID,EXPEDIENTE_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
	
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_EXP_ANIO');
    





   ------------------------------ TMP_EXP_CNT --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_EXP_CNT'',
						  ''EXPEDIENTE_ID NUMBER(16,0),
                              CONTRATO NUMBER(16,0),
                              ENVIADO_AGENCIA NUMBER(16,0),
                              CEX_ID NUMBER(16,0),
                              MAX_MOV_ID NUMBER(16,0),
                              SALDO_VENCIDO NUMBER(14,2),
                              SALDO_NO_VENCIDO NUMBER(14,2),
                              DEUDA_IRREGULAR  NUMBER(14,2),
                              SALDO_DUDOSO NUMBER(14,2) DEFAULT NULL,
                              SALDO_RECLAMAR NUMBER(14,2) DEFAULT NULL,
                              INT_REMUNERATORIOS NUMBER(14,2) DEFAULT NULL,
                              INT_MORATORIOS NUMBER(14,2) DEFAULT NULL,
                              COMISIONES NUMBER(14,2) DEFAULT NULL,
                              GASTOS NUMBER(14,2) DEFAULT NULL, 
                              FECHA_ACTUACION DATE,
                              FECHA_COMPROMETIDA_PAGO DATE,
                              IMPORTE_COMPROMETIDO NUMBER(14,2),
                              TIPO_GESTION NUMBER(16,0),
                              RESULTADO_ACTUACION NUMBER(16,0),
                              MAX_PRIORIDAD_ACTUACION NUMBER(16,0)    
                             '', :error); END;';
							 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_EXP_CNT');

     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_EXP_CNT_IX'', ''TMP_EXP_CNT (EXPEDIENTE_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
       V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_EXP_CNT_CNT_IX'', ''TMP_EXP_CNT (CONTRATO)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_EXP_CNT_CEX_IX'', ''TMP_EXP_CNT (CEX_ID, CONTRATO)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_EXP_CNT');
      

      
   ------------------------------ TMP_EXP_ACCIONES --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_EXP_ACCIONES'',
						  ''CONTRATO NUMBER(16,0),
                              FECHA_ACTUACION DATE,
                              FECHA_COMPROMETIDA_PAGO DATE,
                              IMPORTE_COMPROMETIDO NUMBER(14,2),
                              TIPO_GESTION NUMBER(16,0),
                              RESULTADO_ACTUACION NUMBER(16,0),
                              PRIORIDAD_ACTUACION NUMBER(16,0)                           
                              '', :error); END;';
							 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_EXP_ACCIONES');

     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_EXP_ACCIONES_IX'', ''TMP_EXP_ACCIONES (CONTRATO)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_EXP_ACCIONES');
      


    ------------------------------ H_EXP_DET_CICLO_REC --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_EXP_DET_CICLO_REC'',
						    ''DIA_ID DATE NOT NULL, 
                              FECHA_ALTA_EXP_CR DATE, 
                              FECHA_BAJA_EXP_CR DATE, 
                              FECHA_CARGA_DATOS DATE NOT NULL, 
                              EXPEDIENTE_ID NUMBER(16,0) NOT NULL, 
                              -- Dimensiones
                              MOTIVO_BAJA_EXP_CR_ID NUMBER(16,0), --DE CRE_CICLO_RECOBRO_EXP, DD_MOB_MOTIVOS_BAJA
                              ESQUEMA_EXP_CR_ID NUMBER(16,0), 
                              SUBCARTERA_EXP_CR_ID NUMBER(16,0), 
                              AGENCIA_EXP_CR_ID NUMBER(16,0),   
                              ENVIADO_AGENCIA_EXP_CR_ID NUMBER(16,0),   
                              -- Metricas  
                              NUM_EXPEDIENTE_CICLO_REC NUMBER(*,0), 
                              SALDO_VENCIDO_EXP_CR NUMBER(14,2)  ,      -- Saldo vencido de los contratos asociados al expediente
                              SALDO_NO_VENCIDO_EXP_CR NUMBER(14,2)  ,   -- Saldo no vencido de los contratos asociados al expediente
                              SALDO_TOTAL_EXP_CR NUMBER(14,2)  ,        -- Suma de los saldos vencido y no vencido de los contratos asociados al expediente
                              RIESGO_VIVO_EXP_CR NUMBER(14,2)  ,        -- Riesgo vivo de los contratos asociados al expediente
                              DEUDA_IRREGULAR_EXP_CR NUMBER(14,2)       -- Deuda irregular de los contratos asociados al expediente  
                           '', :error); END;';
							 execute immediate V_SQL USING OUT error;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_DET_CICLO_REC_IX'', ''H_EXP_DET_CICLO_REC (DIA_ID, EXPEDIENTE_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
    

    ------------------------------ TMP_EXP_DET_CICLO_REC --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_EXP_DET_CICLO_REC'',
						  ''DIA_ID DATE NOT NULL, 
                              FECHA_ALTA_EXP_CR DATE, 
                              FECHA_BAJA_EXP_CR DATE, 
                              FECHA_CARGA_DATOS DATE NOT NULL, 
                              EXPEDIENTE_ID NUMBER(16,0) NOT NULL, 
                              -- Dimensiones
                              MOTIVO_BAJA_EXP_CR_ID NUMBER(16,0), --DE CRE_CICLO_RECOBRO_EXP, DD_MOB_MOTIVOS_BAJA
                              ESQUEMA_EXP_CR_ID NUMBER(16,0), 
                              SUBCARTERA_EXP_CR_ID NUMBER(16,0), 
                              AGENCIA_EXP_CR_ID NUMBER(16,0),   
                              ENVIADO_AGENCIA_EXP_CR_ID NUMBER(16,0),   
                              NUM_EXPEDIENTE_CICLO_REC NUMBER(*,0), 
                              -- Metricas  
                              SALDO_VENCIDO_EXP_CR NUMBER(14,2)  ,      -- Saldo vencido de los contratos asociados al expediente
                              SALDO_NO_VENCIDO_EXP_CR NUMBER(14,2)  ,   -- Saldo no vencido de los contratos asociados al expediente
                              SALDO_TOTAL_EXP_CR NUMBER(14,2)  ,        -- Suma de los saldos vencido y no vencido de los contratos asociados al expediente
                              RIESGO_VIVO_EXP_CR NUMBER(14,2)  ,        -- Riesgo vivo de los contratos asociados al expediente
                              DEUDA_IRREGULAR_EXP_CR NUMBER(14,2)       -- Deuda irregular de los contratos asociados al expediente  
                            '', :error); END;';
							 execute immediate V_SQL USING OUT error;

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_EXP_DET_CICLO_REC_IX'', ''TMP_EXP_DET_CICLO_REC (DIA_ID, EXPEDIENTE_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
    

    ------------------------------ TMP_EXP_ENTSAL_D1 --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_EXP_ENTSAL_D1'',
						  ''DIA_ID DATE NOT NULL, 
                              EXPEDIENTE_ID NUMBER(16,0) NOT NULL, 
                              -- Dimensiones
                              MOTIVO_BAJA_EXP_CR_ID NUMBER(16,0), --DE CRE_CICLO_RECOBRO_EXP, DD_MOB_MOTIVOS_BAJA
                              ESQUEMA_EXP_CR_ID NUMBER(16,0), 
                              SUBCARTERA_EXP_CR_ID NUMBER(16,0), 
                              AGENCIA_EXP_CR_ID NUMBER(16,0),   
                              ENVIADO_AGENCIA_EXP_CR_ID NUMBER(16,0),   
                              NUM_EXPEDIENTE_CICLO_REC NUMBER(*,0), 
                              -- Metricas  
                              SALDO_VENCIDO_EXP_CR NUMBER(14,2)  ,      -- Saldo vencido de los contratos asociados al expediente
                              SALDO_NO_VENCIDO_EXP_CR NUMBER(14,2)  ,   -- Saldo no vencido de los contratos asociados al expediente
                              SALDO_TOTAL_EXP_CR NUMBER(14,2)  ,        -- Suma de los saldos vencido y no vencido de los contratos asociados al expediente
                              RIESGO_VIVO_EXP_CR NUMBER(14,2)  ,        -- Riesgo vivo de los contratos asociados al expediente
                              DEUDA_IRREGULAR_EXP_CR NUMBER(14,2)       -- Deuda irregular de los contratos asociados al expediente  
                            '', :error); END;';
							 execute immediate V_SQL USING OUT error;

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_EXP_ENTSAL_D1_IX'', ''TMP_EXP_ENTSAL_D1 (DIA_ID, EXPEDIENTE_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
    

    ------------------------------ TMP_EXP_ENTSAL_D2 --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_EXP_ENTSAL_D2'',
						  ''DIA_ID DATE NOT NULL, 
                              EXPEDIENTE_ID NUMBER(16,0) NOT NULL, 
                              -- Dimensiones
                              MOTIVO_BAJA_EXP_CR_ID NUMBER(16,0), --DE CRE_CICLO_RECOBRO_EXP, DD_MOB_MOTIVOS_BAJA
                              ESQUEMA_EXP_CR_ID NUMBER(16,0), 
                              SUBCARTERA_EXP_CR_ID NUMBER(16,0), 
                              AGENCIA_EXP_CR_ID NUMBER(16,0),   
                              ENVIADO_AGENCIA_EXP_CR_ID NUMBER(16,0),   
                              NUM_EXPEDIENTE_CICLO_REC NUMBER(*,0), 
                              -- Metricas  
                              SALDO_VENCIDO_EXP_CR NUMBER(14,2)  ,      -- Saldo vencido de los contratos asociados al expediente
                              SALDO_NO_VENCIDO_EXP_CR NUMBER(14,2)  ,   -- Saldo no vencido de los contratos asociados al expediente
                              SALDO_TOTAL_EXP_CR NUMBER(14,2)  ,        -- Suma de los saldos vencido y no vencido de los contratos asociados al expediente
                              RIESGO_VIVO_EXP_CR NUMBER(14,2)  ,        -- Riesgo vivo de los contratos asociados al expediente
                              DEUDA_IRREGULAR_EXP_CR NUMBER(14,2)       -- Deuda irregular de los contratos asociados al expediente  
                            '', :error); END;';
							 execute immediate V_SQL USING OUT error;

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_EXP_ENTSAL_D2_IX'', ''TMP_EXP_ENTSAL_D2 (DIA_ID, EXPEDIENTE_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
    
    
    ------------------------------ H_EXP_DET_CICLO_REC_SEMANA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_EXP_DET_CICLO_REC_SEMANA'',
						  ''SEMANA_ID NUMBER(16,0) NOT NULL, 
                              FECHA_ALTA_EXP_CR DATE, 
                              FECHA_BAJA_EXP_CR DATE, 
                              FECHA_CARGA_DATOS DATE NOT NULL, 
                              EXPEDIENTE_ID NUMBER(16,0) NOT NULL, 
                              MOTIVO_BAJA_EXP_CR_ID NUMBER(16,0), --DE CRE_CICLO_RECOBRO_EXP, DD_MOB_MOTIVOS_BAJA
                              ESQUEMA_EXP_CR_ID NUMBER(16,0), 
                              SUBCARTERA_EXP_CR_ID NUMBER(16,0), 
                              AGENCIA_EXP_CR_ID NUMBER(16,0),   
                              ENVIADO_AGENCIA_EXP_CR_ID NUMBER(16,0),   
                              NUM_EXPEDIENTE_CICLO_REC NUMBER(*,0), 
                              -- Metricas  
                              SALDO_VENCIDO_EXP_CR NUMBER(14,2)  ,      -- Saldo vencido de los contratos asociados al expediente
                              SALDO_NO_VENCIDO_EXP_CR NUMBER(14,2)  ,   -- Saldo no vencido de los contratos asociados al expediente
                              SALDO_TOTAL_EXP_CR NUMBER(14,2)  ,        -- Suma de los saldos vencido y no vencido de los contratos asociados al expediente
                              RIESGO_VIVO_EXP_CR NUMBER(14,2)  ,        -- Riesgo vivo de los contratos asociados al expediente
                              DEUDA_IRREGULAR_EXP_CR NUMBER(14,2)       -- Deuda irregular de los contratos asociados al expediente  
                            '', :error); END;';
							 execute immediate V_SQL USING OUT error;

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_DET_CICLO_REC_SEMANA_IX'', ''H_EXP_DET_CICLO_REC_SEMANA (SEMANA_ID, EXPEDIENTE_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
        

    ------------------------------ H_EXP_DET_CICLO_REC_MES --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_EXP_DET_CICLO_REC_MES'',
						  ''MES_ID NUMBER(16,0) NOT NULL, 
                              FECHA_ALTA_EXP_CR DATE, 
                              FECHA_BAJA_EXP_CR DATE, 
                              FECHA_CARGA_DATOS DATE NOT NULL, 
                              EXPEDIENTE_ID NUMBER(16,0) NOT NULL, 
                              MOTIVO_BAJA_EXP_CR_ID NUMBER(16,0), --DE CRE_CICLO_RECOBRO_EXP, DD_MOB_MOTIVOS_BAJA
                              ESQUEMA_EXP_CR_ID NUMBER(16,0), 
                              SUBCARTERA_EXP_CR_ID NUMBER(16,0), 
                              AGENCIA_EXP_CR_ID NUMBER(16,0),   
                              ENVIADO_AGENCIA_EXP_CR_ID NUMBER(16,0),   
                              NUM_EXPEDIENTE_CICLO_REC NUMBER(*,0), 
                              -- Metricas  
                              SALDO_VENCIDO_EXP_CR NUMBER(14,2)  ,      -- Saldo vencido de los contratos asociados al expediente
                              SALDO_NO_VENCIDO_EXP_CR NUMBER(14,2)  ,   -- Saldo no vencido de los contratos asociados al expediente
                              SALDO_TOTAL_EXP_CR NUMBER(14,2)  ,        -- Suma de los saldos vencido y no vencido de los contratos asociados al expediente
                              RIESGO_VIVO_EXP_CR NUMBER(14,2)  ,        -- Riesgo vivo de los contratos asociados al expediente
                              DEUDA_IRREGULAR_EXP_CR NUMBER(14,2)       -- Deuda irregular de los contratos asociados al expediente  
                            '', :error); END;';
							 execute immediate V_SQL USING OUT error;

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_DET_CICLO_REC_MES_IX'', ''H_EXP_DET_CICLO_REC_MES (MES_ID, EXPEDIENTE_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
        
    
    ------------------------------ H_EXP_DET_CICLO_REC_TRIMESTRE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_EXP_DET_CICLO_REC_TRIMESTRE '',
						  ''TRIMESTRE_ID NUMBER(16,0) NOT NULL, 
                              FECHA_ALTA_EXP_CR DATE, 
                              FECHA_BAJA_EXP_CR DATE, 
                              FECHA_CARGA_DATOS DATE NOT NULL, 
                              EXPEDIENTE_ID NUMBER(16,0) NOT NULL, 
                              MOTIVO_BAJA_EXP_CR_ID NUMBER(16,0), --DE CRE_CICLO_RECOBRO_EXP, DD_MOB_MOTIVOS_BAJA
                              ESQUEMA_EXP_CR_ID NUMBER(16,0), 
                              SUBCARTERA_EXP_CR_ID NUMBER(16,0), 
                              AGENCIA_EXP_CR_ID NUMBER(16,0),   
                              ENVIADO_AGENCIA_EXP_CR_ID NUMBER(16,0),   
                              NUM_EXPEDIENTE_CICLO_REC NUMBER(*,0), 
                              -- Metricas  
                              SALDO_VENCIDO_EXP_CR NUMBER(14,2)  ,      -- Saldo vencido de los contratos asociados al expediente
                              SALDO_NO_VENCIDO_EXP_CR NUMBER(14,2)  ,   -- Saldo no vencido de los contratos asociados al expediente
                              SALDO_TOTAL_EXP_CR NUMBER(14,2)  ,        -- Suma de los saldos vencido y no vencido de los contratos asociados al expediente
                              RIESGO_VIVO_EXP_CR NUMBER(14,2)  ,        -- Riesgo vivo de los contratos asociados al expediente
                              DEUDA_IRREGULAR_EXP_CR NUMBER(14,2)       -- Deuda irregular de los contratos asociados al expediente  
                            '', :error); END;';
							 execute immediate V_SQL USING OUT error;

   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_DET_CICLO_REC_TRI_IX'', ''H_EXP_DET_CICLO_REC_TRIMESTRE (TRIMESTRE_ID, EXPEDIENTE_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
       

    ------------------------------ H_EXP_DET_CICLO_REC_ANIO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_EXP_DET_CICLO_REC_ANIO'',
						  ''ANIO_ID NUMBER(16,0) NOT NULL, 
                              FECHA_ALTA_EXP_CR DATE, 
                              FECHA_BAJA_EXP_CR DATE, 
                              FECHA_CARGA_DATOS DATE NOT NULL, 
                              EXPEDIENTE_ID NUMBER(16,0) NOT NULL, 
                              MOTIVO_BAJA_EXP_CR_ID NUMBER(16,0), --DE CRE_CICLO_RECOBRO_EXP, DD_MOB_MOTIVOS_BAJA
                              ESQUEMA_EXP_CR_ID NUMBER(16,0), 
                              SUBCARTERA_EXP_CR_ID NUMBER(16,0), 
                              AGENCIA_EXP_CR_ID NUMBER(16,0),   
                              ENVIADO_AGENCIA_EXP_CR_ID NUMBER(16,0),   
                              NUM_EXPEDIENTE_CICLO_REC NUMBER(*,0), 
                              -- Metricas  
                              SALDO_VENCIDO_EXP_CR NUMBER(14,2)  ,      -- Saldo vencido de los contratos asociados al expediente
                              SALDO_NO_VENCIDO_EXP_CR NUMBER(14,2)  ,   -- Saldo no vencido de los contratos asociados al expediente
                              SALDO_TOTAL_EXP_CR NUMBER(14,2)  ,        -- Suma de los saldos vencido y no vencido de los contratos asociados al expediente
                              RIESGO_VIVO_EXP_CR NUMBER(14,2)  ,        -- Riesgo vivo de los contratos asociados al expediente
                              DEUDA_IRREGULAR_EXP_CR NUMBER(14,2)       -- Deuda irregular de los contratos asociados al expediente  
                           '', :error); END;';
							 execute immediate V_SQL USING OUT error;

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_DET_CICLO_REC_ANIO_IX'', ''H_EXP_DET_CICLO_REC_ANIO (ANIO_ID, EXPEDIENTE_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
       
    
        
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;
    
  end;
END CREAR_H_EXPEDIENTE;
