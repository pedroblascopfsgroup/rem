create or replace procedure crear_h_contrato(
		error out varchar2)
as
	-- ===============================================================================================
	-- Autor: María Villanueva, PFS Group
	-- Fecha creacion: Septiembre 2015
	-- Responsable ultima modificacion: María Villanueva, PFS Group
	-- Fecha �ltima modificaci�n: 11/11/2015
	-- Motivos del cambio:Usuario propietario
	-- Cliente: Recovery BI PRODUCTO
	--
	-- Descripcion: Procedimiento almancenado que crea las tablas del Hecho Contrato
	-- ===============================================================================================
	-- -------------------------------------------- INDICE -------------------------------------------
-- HECHO CONTRATO
    -- H_CNT
    -- TMP_H_CNT
    -- H_CNT_SEMANA
    -- H_CNT_MES
    -- H_CNT_TRIMESTRE
    -- H_CNT_ANIO
    -- H_CNT_DET_COBRO
    -- TMP_H_CNT_DET_COBRO
    -- H_CNT_DET_COBRO_SEMANA
    -- H_CNT_DET_COBRO_MES
    -- H_CNT_DET_COBRO_TRIMESTRE
    -- H_CNT_DET_COBRO_ANIO
    -- H_CNT_DET_CICLO_REC
    -- TMP_CNT_DET_CICLO_REC
    -- H_CNT_DET_CICLO_REC_SEMANA
    -- H_CNT_DET_CICLO_REC_MES
    -- H_CNT_DET_CICLO_REC_TRIMESTRE
    -- H_CNT_DET_CICLO_REC_ANIO
    -- H_CNT_INICIO_CAMPANA_RECOBRO
    -- H_CNT_DET_ACUERDO
    -- TMP_CNT_DET_ACUERDO
    -- H_CNT_DET_ACUERDO_SEMANA
    -- H_CNT_DET_ACUERDO_MES
    -- H_CNT_DET_ACUERDO_TRIMESTRE
    -- H_CNT_DET_ACUERDO_ANIO
    -- H_CNT_DET_INCI
    -- TMP_CNT_DET_INCI
    -- H_CNT_DET_INCI_SEMANA
    -- H_CNT_DET_INCI_MES
    -- H_CNT_DET_INCI_TRIMESTRE
    -- H_CNT_DET_INCI_ANIO
    -- H_CNT_DET_EFICACIA
    -- TMP_H_CNT_DET_EFICACIA
    -- H_CNT_DET_EFICACIA_SEMANA
    -- H_CNT_DET_EFICACIA_TRIMESTRE
    -- H_CNT_DET_EFICACIAI_ANIO
    -- H_CNT_DET_CREDITO
    -- TMP_H_CNT_DET_CREDITO
    -- H_CNT_DET_CREDITO_SEMANA
    -- H_CNT_DET_CREDITO_MES
    -- H_CNT_DET_CREDITO_TRIMESTE
    -- H_CNT_DET_CREDITO_ANIO
    -- TMP_FECHA
    -- TMP_FECHA_AUX
    -- TMP_FECHA_CNT
    -- TMP_H
    -- TMP_ANT
    -- TMP_MANTIENE
    -- TMP_ALTA
    -- TMP_BAJA
    -- TMP_CNT_PROCEDIMIENTO_AUX
    -- TMP_CNT_PROCEDIMIENTO
    -- TMP_CNT_EXPEDIENTE
    -- TMP_CNT_SITUACION_FINANCIERA
    -- TMP_CNT_CREDITO_INSINUADO
    -- TMP_CNT_RECOBRO
    -- TMP_CNT_DPS
    -- TMP_CNT_ESPECIALIZADA
    -- TMP_CNT_PREVISIONES
    -- TMP_CNT_PREVISIONES_DIA
    -- TMP_LOAN_INFORMATION
    -- TMP_ESTUDIO_CARTERA
    -- TMP_EN_MASIVA
    -- TMP_CNT_COBRO
    -- TMP_CNT_ENVIO_AGENCIA
    -- TMP_ENTSAL_D1
    -- TMP_ENTSAL_D2
    -- TMP_CNT_FACTURACION
    -- TMP_DET_COBROS_PAGOS
    -- TMP_CNT_ACCIONES
    -- TMP_CNT_GESTOR_CREDITO
    
BEGIN

  declare
  nCount NUMBER;
  V_SQL VARCHAR2(16000);
  V_NOMBRE VARCHAR2(50) := 'CREAR_H_CONTRATO';
  
  begin

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
	
	

    ------------------------------ H_CNT --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT'', 
                            ''DIA_ID DATE NOT NULL,                             -- Fecha Extracci?n
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ?ltimo d?a cargado
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              -- Dimensiones
                              CLASIFICACION_CNT_ID NUMBER(16,0) NULL,
                              SEGMENTO_CARTERA_ID NUMBER(16,0) NULL,
                              ENVIADO_AGENCIA_CNT_ID NUMBER(16,0) NULL,
                              SITUACION_CNT_DETALLE_ID NUMBER(16,0),           -- 0 Normal, 1 Vencido < 30 d?as, 2 Vencido 30-60 d?as, ...
                              SITUACION_ANT_CNT_DETALLE_ID NUMBER(16,0),       -- 0 Normal, 1 Vencido < 30 d?as, 2 Vencido 30-60 d?as, ...
                              SITUACION_RESP_PER_ANT_ID NUMBER(16,0),          -- 0 Mantiene, 1 Alta, 2 Baja
                              DIA_POS_VENCIDA_ID DATE,
                              DIA_SALDO_DUDOSO_ID DATE,
                              ESTADO_FINANCIERO_CNT_ID NUMBER(16,0),
                              ESTADO_FINANCIERO_ANT_ID NUMBER(16,0),
                              ESTADO_CONTRATO_ID NUMBER(16,0),
                              CONTRATO_JUDICIALIZADO_ID NUMBER(16,0),
                              ESTADO_INSINUACION_CNT_ID NUMBER(16,0),
                              CNT_CON_CAPITAL_FALLIDO_ID NUMBER(16,0),
                              TIPO_GESTION_CONTRATO_ID NUMBER(16,0),
                              FECHA_CREACION_CONTRATO DATE,
                              FECHA_CONSTITUCION_CONTRATO DATE,
                              FECHA_CAMBIO_TRAMO DATE,
                              FECHA_ALTA_DUDOSO DATE,
                              FECHA_BAJA_DUDOSO DATE,
                              T_SALDO_TOTAL_CNT_ID NUMBER(16,0),
                              T_SALDO_IRREGULAR_CNT_ID NUMBER(16,0),
                              T_DEUDA_IRREGULAR_CNT_ID NUMBER(16,0),
                              TRAMO_RIESGO_CNT_ID NUMBER(16,0),
                              TA_FECHA_CREACION_ID NUMBER(16,0),
                              PERIMETRO_GESTION_ID NUMBER(16,0),
                              PERIMETRO_SIN_GESTION_ID NUMBER(16,0),
                              PERIMETRO_EXP_SEG_ID NUMBER(16,0),
                              PERIMETRO_EXP_REC_ID NUMBER(16,0),
                              PERIMETRO_GES_EXTRA_ID NUMBER(16,0),
                              PERIMETRO_GES_PRE_ID NUMBER(16,0),
                              PERIMETRO_GES_JUDI_ID NUMBER(16,0),
                              PERIMETRO_GES_CONCU_ID NUMBER(16,0),  
                              MOTIVO_ALTA_DUDOSO_ID NUMBER(16,0),
                              MOTIVO_BAJA_DUDOSO_ID NUMBER(16,0),
                              SIT_CART_DANADA_ID NUMBER(16,0),
                              TIPO_GESTION_EXP_ID NUMBER(16,0),
                              -- Recobro
                              EN_GESTION_RECOBRO_ID NUMBER(16,0),
                              FECHA_ALTA_GESTION_RECOBRO DATE,
                              FECHA_BAJA_GESTION_RECOBRO DATE,
                              FECHA_COMPROMETIDA_PAGO DATE,
                              FECHA_DPS DATE,
                              T_IRREG_DIAS_ID NUMBER(16,0),
                              T_IRREG_DIAS_PERIODO_ANT_ID NUMBER(16,0),
                              TRAMO_ANTIGUEDAD_DEUDA_ID NUMBER(16,0) NULL,
                              T_IRREG_FASES_ID NUMBER(16,0),
                              T_IRREG_FASES_PER_ANT_ID NUMBER(16,0),
                              TD_EN_GESTION_A_COBRO_ID NUMBER(16,0),
                              TD_IRREGULAR_A_COBRO_ID NUMBER(16,0),
                              RESULTADO_ACTUACION_CNT_ID NUMBER(16,0),
                              MODELO_RECOBRO_CONTRATO_ID NUMBER(16,0),
                              PROVEEDOR_RECOBRO_CNT_ID NUMBER(16,0),
                              CONTRATO_EN_IRREGULAR_ID NUMBER(16,0),
                              CONTRATO_CON_DPS_ID NUMBER(16,0),
                              CNT_CON_CONTACTO_UTIL_ID NUMBER(16,0),
                              CNT_CON_ACTUACION_RECOBRO_ID NUMBER(16,0),
                              -- Especializada
                              FECHA_PREVISION date,
                              EN_GESTION_ESPECIALIZADA_ID NUMBER(16,0),
                              CONTRATO_CON_PREVISION_ID NUMBER(16,0),
                              CNT_CON_PREV_REVISADA_ID NUMBER(16,0),
                              TIPO_PREVISION_ID NUMBER(16,0),
                              PREV_SITUACION_INICIAL_ID NUMBER(16,0),
                              PREV_SITUACION_AUTO_ID NUMBER(16,0),
                              PREV_SITUACION_MANUAL_ID NUMBER(16,0),
                              PREV_SITUACION_FINAL_ID NUMBER(16,0),
                              MOTIVO_PREVISION_ID NUMBER(16,0),
                              SITUACION_ESPECIALIZADA_ID NUMBER(16,0),
                              GESTOR_ESPECIALIZADA_ID NUMBER(16,0),
                              SUPERVISOR_N1_ESPEC_ID NUMBER(16,0),
                              SUPERVISOR_N2_ESPEC_ID NUMBER(16,0),
                              SUPERVISOR_N3_ESPEC_ID NUMBER(16,0),
                              -- Estudio Carteras
                              EN_CARTERA_ESTUDIO_ID NUMBER(16,0),
                              MODELO_GESTION_CARTERA_ID NUMBER(16,0),
                              UNIDAD_GESTION_CARTERA_ID NUMBER(16,0),
                              -- Expediente
                              EXPEDIENTE_ID NUMBER(16,0),
                              FECHA_CREACION_EXPEDIENTE DATE,
                              FECHA_ROTURA_EXPEDIENTE DATE,
                              FECHA_SALIDA_AGENCIA_EXP DATE,
                              ESQUEMA_CONTRATO_ID NUMBER(16,0),
                              AGENCIA_CONTRATO_ID NUMBER(16,0),
                              SUBCARTERA_EXPEDIENTE_CNT_ID NUMBER(16,0),
                              TIPO_SALIDA_EXP_CNT_ID NUMBER(16,0),
                              MOTIVO_SALIDA_EXP_CNT_ID NUMBER(16,0),
                              TIPO_INCIDENCIA_EXP_CNT_ID NUMBER(16,0),
                              ESTADO_INCIDENCIA_EXP_CNT_ID NUMBER(16,0),
                              -- Acciones
                              FECHA_ACCION DATE,
                              TIPO_ACCION_ID NUMBER(16,0),
                              RESULTADO_GESTION_ID NUMBER(16,0),
                              -- Metricas
                              NUM_CONTRATOS INTEGER,
                              NUM_CLIENTES_ASOCIADOS INTEGER,
                              NUM_EXPEDIENTES_ASOCIADOS INTEGER,
                              NUM_DIAS_VENCIDOS INTEGER,
                              NUM_DIAS_VENC_PERIODO_ANT INTEGER,
                              SALDO_TOTAL NUMBER(14,2),
                              RIESGO_VIVO NUMBER(14,2),
                              POS_VIVA_NO_VENC NUMBER(14,2),
                              POS_VIVA_VENC NUMBER(14,2),
                              SALDO_DUDOSO NUMBER(14,2),
                              PROVISION NUMBER(14,2),
                              INT_REMUNERATORIOS NUMBER(14,2),
                              INT_MORATORIOS NUMBER(14,2),
                              COMISIONES NUMBER(14,2),
                              GASTOS NUMBER(14,2),
                              RIESGO NUMBER(14,2),
                              DEUDA_IRREGULAR NUMBER(14,2),
                              DISPUESTO NUMBER(14,2),
                              SALDO_PASIVO NUMBER(14,2),
                              RIESGO_GARANTIA NUMBER(14,2),
                              SALDO_EXCE NUMBER(14,2),
                              LIMITE_DESC NUMBER(14,2),
                              MOV_EXTRA_1 NUMBER(14,2),
                              MOV_EXTRA_2 NUMBER(14,2),
                              MOV_LTV_INI NUMBER(16,0),
                              MOV_LTV_FIN NUMBER(16,0),
                              DD_MX3_ID NUMBER(16,0) DEFAULT NULL,
                              DD_MX4_ID NUMBER(16,0) DEFAULT NULL,
                              CNT_LIMITE_INI NUMBER(14,2) DEFAULT NULL,
                              CNT_LIMITE_FIN NUMBER(14,2) DEFAULT NULL,
                              NUM_CREDITOS_INSINUADOS INTEGER,
                              DEUDA_EXIGIBLE NUMBER(14,2) DEFAULT NULL,
                              CAPITAL_FALLIDO NUMBER(16,2) DEFAULT NULL,
                              CAPITAL_VIVO NUMBER(16,2) DEFAULT NULL,
                              IMPORTE_PTE_DIFER NUMBER(16,2) DEFAULT NULL,
                              -- Recobro
                              NUM_DPS INTEGER,
                              NUM_DPS_ACUMULADO INTEGER,
                              DPS NUMBER(14,2),
                              DPS_CAPITAL NUMBER(14,2),
                              DPS_ICG NUMBER(14,2),
                              DPS_ACUMULADO NUMBER(14,2),
                              DPS_CAPITAL_ACUMULADO NUMBER(14,2),
                              DPS_ICG_ACUMULADO NUMBER(14,2),
                              SALDO_MAXIMO_GESTION NUMBER(14,2),
                              IMPORTE_A_RECLAMAR NUMBER(14,2),
                              NUM_DIAS_EN_GESTION_A_COBRO INTEGER,
                              NUM_DIAS_IRREGULAR_A_COBRO INTEGER,
                              NUM_ACTUACIONES_RECOBRO INTEGER,
                              NUM_ACT_REC_ACUMULADO INTEGER,
                              NUM_ACT_REC_CONTACTO_UTIL INTEGER,
                              NUM_ACT_REC_CONTACTO_UTIL_ACU INTEGER,
                              -- Especializada
                              IMP_IRREGULAR_PREV_INICIO NUMBER(14,2),
                              IMP_IRREGULAR_PREV_AUTO NUMBER(14,2),
                              IMP_IRREGULAR_PREV_MANUAL NUMBER(14,2),
                              IMP_IRREGULAR_PREV_FINAL NUMBER(14,2),
                              IMP_RIESGO_PREV_INICIO NUMBER(14,2),
                              IMP_RIESGO_PREV_AUTO NUMBER(14,2),
                              IMP_RIESGO_PREV_MANUAL NUMBER(14,2),
                              IMP_RIESGO_PREV_FINAL NUMBER(14,2),
                              -- Acciones
                              IMPORTE_COMPROMETIDO NUMBER(14,2))
			  SEGMENT CREATION IMMEDIATE 
					TABLESPACE "RECOVERY_PRODUC_DWH" 
                    PARTITION BY RANGE ("DIA_ID")
                    INTERVAL(NUMTOYMINTERVAL(1, ''''MONTH''''))
                    (PARTITION "p1" VALUES LESS THAN (TO_DATE('''' 2014-11-01 00:00:00'''', ''''SYYYY-MM-DD HH24:MI:SS'''', ''''NLS_CALENDAR=GREGORIAN''''))'', :error); END;';
	 execute immediate V_SQL USING OUT error;
        DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT');

	    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_IX'', ''H_CNT (DIA_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

           DBMS_OUTPUT.PUT_LINE('---- Creacion INDICES en H_CNT');
 


    ------------------------------ TMP_H_CNT --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_H_CNT'', 
                            ''DIA_ID DATE NOT NULL,                             -- Fecha Extracci?n
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ?ltimo d?a cargado
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              -- Dimensiones
                              CLASIFICACION_CNT_ID NUMBER(16,0) NULL,
                              SEGMENTO_CARTERA_ID NUMBER(16,0) NULL,
                              ENVIADO_AGENCIA_CNT_ID NUMBER(16,0) NULL,
                              SITUACION_CNT_DETALLE_ID NUMBER(16,0),           -- 0 Normal, 1 Vencido < 30 d?as, 2 Vencido 30-60 d?as, ...
                              SITUACION_ANT_CNT_DETALLE_ID NUMBER(16,0),       -- 0 Normal, 1 Vencido < 30 d?as, 2 Vencido 30-60 d?as, ...
                              SITUACION_RESP_PER_ANT_ID NUMBER(16,0),          -- 0 Mantiene, 1 Alta, 2 Baja
                              DIA_POS_VENCIDA_ID DATE,
                              DIA_SALDO_DUDOSO_ID DATE,
                              ESTADO_FINANCIERO_CNT_ID NUMBER(16,0),
                              ESTADO_FINANCIERO_ANT_ID NUMBER(16,0),
                              ESTADO_CONTRATO_ID NUMBER(16,0),
                              CONTRATO_JUDICIALIZADO_ID NUMBER(16,0),
                              ESTADO_INSINUACION_CNT_ID NUMBER(16,0),
                              CNT_CON_CAPITAL_FALLIDO_ID NUMBER(16,0),
                              TIPO_GESTION_CONTRATO_ID NUMBER(16,0),
                              FECHA_CREACION_CONTRATO DATE,
                              FECHA_CONSTITUCION_CONTRATO DATE,
                              FECHA_CAMBIO_TRAMO DATE,
                              FECHA_ALTA_DUDOSO DATE,
                              FECHA_BAJA_DUDOSO DATE,
                              T_SALDO_TOTAL_CNT_ID NUMBER(16,0),
                              T_SALDO_IRREGULAR_CNT_ID NUMBER(16,0),
                              T_DEUDA_IRREGULAR_CNT_ID NUMBER(16,0),
                              TRAMO_RIESGO_CNT_ID NUMBER(16,0),
                              TA_FECHA_CREACION_ID NUMBER(16,0),
                              PERIMETRO_GESTION_ID NUMBER(16,0),
                              PERIMETRO_SIN_GESTION_ID NUMBER(16,0),
                              PERIMETRO_EXP_SEG_ID NUMBER(16,0),
                              PERIMETRO_EXP_REC_ID NUMBER(16,0),
                              PERIMETRO_GES_EXTRA_ID NUMBER(16,0),
                              PERIMETRO_GES_PRE_ID NUMBER(16,0),
                              PERIMETRO_GES_JUDI_ID NUMBER(16,0),
                              PERIMETRO_GES_CONCU_ID NUMBER(16,0),  
                              MOTIVO_ALTA_DUDOSO_ID NUMBER(16,0),
                              MOTIVO_BAJA_DUDOSO_ID NUMBER(16,0),
                              SIT_CART_DANADA_ID NUMBER(16,0),
                              TIPO_GESTION_EXP_ID NUMBER(16,0),
                              -- Recobro
                              EN_GESTION_RECOBRO_ID NUMBER(16,0),
                              FECHA_ALTA_GESTION_RECOBRO DATE,
                              FECHA_BAJA_GESTION_RECOBRO DATE,
                              FECHA_COMPROMETIDA_PAGO DATE,
                              FECHA_DPS DATE,
                              T_IRREG_DIAS_ID NUMBER(16,0),
                              T_IRREG_DIAS_PERIODO_ANT_ID NUMBER(16,0),
                              TRAMO_ANTIGUEDAD_DEUDA_ID NUMBER(16,0) NULL,
                              T_IRREG_FASES_ID NUMBER(16,0),
                              T_IRREG_FASES_PER_ANT_ID NUMBER(16,0),
                              TD_EN_GESTION_A_COBRO_ID NUMBER(16,0),
                              TD_IRREGULAR_A_COBRO_ID NUMBER(16,0),
                              RESULTADO_ACTUACION_CNT_ID NUMBER(16,0),
                              MODELO_RECOBRO_CONTRATO_ID NUMBER(16,0),
                              PROVEEDOR_RECOBRO_CNT_ID NUMBER(16,0),
                              CONTRATO_EN_IRREGULAR_ID NUMBER(16,0),
                              CONTRATO_CON_DPS_ID NUMBER(16,0),
                              CNT_CON_CONTACTO_UTIL_ID NUMBER(16,0),
                              CNT_CON_ACTUACION_RECOBRO_ID NUMBER(16,0),
                              -- Especializada
                              FECHA_PREVISION date,
                              EN_GESTION_ESPECIALIZADA_ID NUMBER(16,0),
                              CONTRATO_CON_PREVISION_ID NUMBER(16,0),
                              CNT_CON_PREV_REVISADA_ID NUMBER(16,0),
                              TIPO_PREVISION_ID NUMBER(16,0),
                              PREV_SITUACION_INICIAL_ID NUMBER(16,0),
                              PREV_SITUACION_AUTO_ID NUMBER(16,0),
                              PREV_SITUACION_MANUAL_ID NUMBER(16,0),
                              PREV_SITUACION_FINAL_ID NUMBER(16,0),
                              MOTIVO_PREVISION_ID NUMBER(16,0),
                              SITUACION_ESPECIALIZADA_ID NUMBER(16,0),
                              GESTOR_ESPECIALIZADA_ID NUMBER(16,0),
                              SUPERVISOR_N1_ESPEC_ID NUMBER(16,0),
                              SUPERVISOR_N2_ESPEC_ID NUMBER(16,0),
                              SUPERVISOR_N3_ESPEC_ID NUMBER(16,0),
                              -- Estudio Carteras
                              EN_CARTERA_ESTUDIO_ID NUMBER(16,0),
                              MODELO_GESTION_CARTERA_ID NUMBER(16,0),
                              UNIDAD_GESTION_CARTERA_ID NUMBER(16,0),
                              -- Expediente
                              EXPEDIENTE_ID NUMBER(16,0),
                              FECHA_CREACION_EXPEDIENTE DATE,
                              FECHA_ROTURA_EXPEDIENTE DATE,
                              FECHA_SALIDA_AGENCIA_EXP DATE,
                              ESQUEMA_CONTRATO_ID NUMBER(16,0),
                              AGENCIA_CONTRATO_ID NUMBER(16,0),
                              SUBCARTERA_EXPEDIENTE_CNT_ID NUMBER(16,0),
                              TIPO_SALIDA_EXP_CNT_ID NUMBER(16,0),
                              MOTIVO_SALIDA_EXP_CNT_ID NUMBER(16,0),
                              TIPO_INCIDENCIA_EXP_CNT_ID NUMBER(16,0),
                              ESTADO_INCIDENCIA_EXP_CNT_ID NUMBER(16,0),
                              -- Acciones
                              FECHA_ACCION DATE,
                              TIPO_ACCION_ID NUMBER(16,0),
                              RESULTADO_GESTION_ID NUMBER(16,0),
                              MAX_PRIORIDAD_ACTUACION  NUMBER(16,0),
                              -- Metricas
                              NUM_CONTRATOS INTEGER,
                              NUM_CLIENTES_ASOCIADOS INTEGER,
                              NUM_EXPEDIENTES_ASOCIADOS INTEGER,
                              NUM_DIAS_VENCIDOS INTEGER,
                              NUM_DIAS_VENC_PERIODO_ANT INTEGER,
                              SALDO_TOTAL NUMBER(14,2),
                              RIESGO_VIVO NUMBER(14,2),
                              POS_VIVA_NO_VENC NUMBER(14,2),
                              POS_VIVA_VENC NUMBER(14,2),
                              SALDO_DUDOSO NUMBER(14,2),
                              PROVISION NUMBER(14,2),
                              INT_REMUNERATORIOS NUMBER(14,2),
                              INT_MORATORIOS NUMBER(14,2),
                              COMISIONES NUMBER(14,2),
                              GASTOS NUMBER(14,2),
                              RIESGO NUMBER(14,2),
                              DEUDA_IRREGULAR NUMBER(14,2),
                              DISPUESTO NUMBER(14,2),
                              SALDO_PASIVO NUMBER(14,2),
                              RIESGO_GARANTIA NUMBER(14,2),
                              SALDO_EXCE NUMBER(14,2),
                              LIMITE_DESC NUMBER(14,2),
                              MOV_EXTRA_1 NUMBER(14,2),
                              MOV_EXTRA_2 NUMBER(14,2),
                              MOV_LTV_INI NUMBER(16,0),
                              MOV_LTV_FIN NUMBER(16,0),
                              DD_MX3_ID NUMBER(16,0) DEFAULT NULL,
                              DD_MX4_ID NUMBER(16,0) DEFAULT NULL,
                              CNT_LIMITE_INI NUMBER(14,2) DEFAULT NULL,
                              CNT_LIMITE_FIN NUMBER(14,2) DEFAULT NULL,
                              NUM_CREDITOS_INSINUADOS INTEGER,
                              DEUDA_EXIGIBLE NUMBER(14,2) DEFAULT NULL,
                              CAPITAL_FALLIDO NUMBER(16,2) DEFAULT NULL,
                              CAPITAL_VIVO NUMBER(16,2) DEFAULT NULL,
                              IMPORTE_PTE_DIFER NUMBER(16,2) DEFAULT NULL,
                              -- Recobro
                              NUM_DPS INTEGER,
                              NUM_DPS_ACUMULADO INTEGER,
                              DPS NUMBER(14,2),
                              DPS_CAPITAL NUMBER(14,2),
                              DPS_ICG NUMBER(14,2),
                              DPS_ACUMULADO NUMBER(14,2),
                              DPS_CAPITAL_ACUMULADO NUMBER(14,2),
                              DPS_ICG_ACUMULADO NUMBER(14,2),
                              SALDO_MAXIMO_GESTION NUMBER(14,2),
                              IMPORTE_A_RECLAMAR NUMBER(14,2),
                              NUM_DIAS_EN_GESTION_A_COBRO INTEGER,
                              NUM_DIAS_IRREGULAR_A_COBRO INTEGER,
                              NUM_ACTUACIONES_RECOBRO INTEGER,
                              NUM_ACT_REC_ACUMULADO INTEGER,
                              NUM_ACT_REC_CONTACTO_UTIL INTEGER,
                              NUM_ACT_REC_CONTACTO_UTIL_ACU INTEGER,
                              -- Especializada
                              IMP_IRREGULAR_PREV_INICIO NUMBER(14,2),
                              IMP_IRREGULAR_PREV_AUTO NUMBER(14,2),
                              IMP_IRREGULAR_PREV_MANUAL NUMBER(14,2),
                              IMP_IRREGULAR_PREV_FINAL NUMBER(14,2),
                              IMP_RIESGO_PREV_INICIO NUMBER(14,2),
                              IMP_RIESGO_PREV_AUTO NUMBER(14,2),
                              IMP_RIESGO_PREV_MANUAL NUMBER(14,2),
                              IMP_RIESGO_PREV_FINAL NUMBER(14,2),
                              -- Acciones
                              IMPORTE_COMPROMETIDO NUMBER(14,2)
                              '', :error); END;';
		 execute immediate V_SQL USING OUT error;
        	 DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_H_CNT');

	   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_CNT_IX'', ''TMP_H_CNT (DIA_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
	   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TTMP_H_CNT_CNT_IX'', ''TTMP_H_CNT (CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

        DBMS_OUTPUT.PUT_LINE('---- Creacion INDICES en TMP_H_CNT');

    
    ------------------------------ H_CNT_SEMANA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_SEMANA'', 
                            ''SEMANA_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ?ltimo d?a cargado
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              -- Dimensiones
                              CLASIFICACION_CNT_ID NUMBER(16,0) NULL,
                              SEGMENTO_CARTERA_ID NUMBER(16,0) NULL,
                              ENVIADO_AGENCIA_CNT_ID NUMBER(16,0) NULL,
                              SITUACION_CNT_DETALLE_ID NUMBER(16,0),           -- 0 Normal, 1 Vencido < 30 d?as, 2 Vencido 30-60 d?as, ...
                              SITUACION_ANT_CNT_DETALLE_ID NUMBER(16,0),       -- 0 Normal, 1 Vencido < 30 d?as, 2 Vencido 30-60 d?as, ...
                              SITUACION_RESP_PER_ANT_ID NUMBER(16,0),          -- 0 Mantiene, 1 Alta, 2 Baja
                              DIA_POS_VENCIDA_ID DATE,
                              DIA_SALDO_DUDOSO_ID DATE,
                              ESTADO_FINANCIERO_CNT_ID NUMBER(16,0),
                              ESTADO_FINANCIERO_ANT_ID NUMBER(16,0),
                              ESTADO_CONTRATO_ID NUMBER(16,0),
                              CONTRATO_JUDICIALIZADO_ID NUMBER(16,0),
                              ESTADO_INSINUACION_CNT_ID NUMBER(16,0),
                              CNT_CON_CAPITAL_FALLIDO_ID NUMBER(16,0),
                              TIPO_GESTION_CONTRATO_ID NUMBER(16,0),
                              FECHA_CREACION_CONTRATO DATE,
                              FECHA_CONSTITUCION_CONTRATO DATE,
                              FECHA_CAMBIO_TRAMO DATE,
                              FECHA_ALTA_DUDOSO DATE,
                              FECHA_BAJA_DUDOSO DATE,
                              T_SALDO_TOTAL_CNT_ID NUMBER(16,0),
                              T_SALDO_IRREGULAR_CNT_ID NUMBER(16,0),
                              T_DEUDA_IRREGULAR_CNT_ID NUMBER(16,0),
                              TRAMO_RIESGO_CNT_ID NUMBER(16,0),
                              TA_FECHA_CREACION_ID NUMBER(16,0),
                              PERIMETRO_GESTION_ID NUMBER(16,0),
                              PERIMETRO_SIN_GESTION_ID NUMBER(16,0),
                              PERIMETRO_EXP_SEG_ID NUMBER(16,0),
                              PERIMETRO_EXP_REC_ID NUMBER(16,0),
                              PERIMETRO_GES_EXTRA_ID NUMBER(16,0),
                              PERIMETRO_GES_PRE_ID NUMBER(16,0),
                              PERIMETRO_GES_JUDI_ID NUMBER(16,0),
                              PERIMETRO_GES_CONCU_ID NUMBER(16,0),  
                              MOTIVO_ALTA_DUDOSO_ID NUMBER(16,0),
                              MOTIVO_BAJA_DUDOSO_ID NUMBER(16,0),
                              SIT_CART_DANADA_ID NUMBER(16,0),
                              TIPO_GESTION_EXP_ID NUMBER(16,0),
                              -- Recobro
                              EN_GESTION_RECOBRO_ID NUMBER(16,0),
                              FECHA_ALTA_GESTION_RECOBRO DATE,
                              FECHA_BAJA_GESTION_RECOBRO DATE,
                              FECHA_COMPROMETIDA_PAGO DATE,
                              FECHA_DPS DATE,
                              T_IRREG_DIAS_ID NUMBER(16,0),
                              T_IRREG_DIAS_PERIODO_ANT_ID NUMBER(16,0),
                              TRAMO_ANTIGUEDAD_DEUDA_ID NUMBER(16,0) NULL,
                              T_IRREG_FASES_ID NUMBER(16,0),
                              T_IRREG_FASES_PER_ANT_ID NUMBER(16,0),
                              TD_EN_GESTION_A_COBRO_ID NUMBER(16,0),
                              TD_IRREGULAR_A_COBRO_ID NUMBER(16,0),
                              RESULTADO_ACTUACION_CNT_ID NUMBER(16,0),
                              MODELO_RECOBRO_CONTRATO_ID NUMBER(16,0),
                              PROVEEDOR_RECOBRO_CNT_ID NUMBER(16,0),
                              CONTRATO_EN_IRREGULAR_ID NUMBER(16,0),
                              CONTRATO_CON_DPS_ID NUMBER(16,0),
                              CNT_CON_CONTACTO_UTIL_ID NUMBER(16,0),
                              CNT_CON_ACTUACION_RECOBRO_ID NUMBER(16,0),
                              -- Especializada
                              FECHA_PREVISION date,
                              EN_GESTION_ESPECIALIZADA_ID NUMBER(16,0),
                              CONTRATO_CON_PREVISION_ID NUMBER(16,0),
                              CNT_CON_PREV_REVISADA_ID NUMBER(16,0),
                              TIPO_PREVISION_ID NUMBER(16,0),
                              PREV_SITUACION_INICIAL_ID NUMBER(16,0),
                              PREV_SITUACION_AUTO_ID NUMBER(16,0),
                              PREV_SITUACION_MANUAL_ID NUMBER(16,0),
                              PREV_SITUACION_FINAL_ID NUMBER(16,0),
                              MOTIVO_PREVISION_ID NUMBER(16,0),
                              SITUACION_ESPECIALIZADA_ID NUMBER(16,0),
                              GESTOR_ESPECIALIZADA_ID NUMBER(16,0),
                              SUPERVISOR_N1_ESPEC_ID NUMBER(16,0),
                              SUPERVISOR_N2_ESPEC_ID NUMBER(16,0),
                              SUPERVISOR_N3_ESPEC_ID NUMBER(16,0),
                              -- Estudio Carteras
                              EN_CARTERA_ESTUDIO_ID NUMBER(16,0),
                              MODELO_GESTION_CARTERA_ID NUMBER(16,0),
                              UNIDAD_GESTION_CARTERA_ID NUMBER(16,0),
                              -- Expediente
                              EXPEDIENTE_ID NUMBER(16,0),
                              FECHA_CREACION_EXPEDIENTE DATE,
                              FECHA_ROTURA_EXPEDIENTE DATE,
                              FECHA_SALIDA_AGENCIA_EXP DATE,
                              ESQUEMA_CONTRATO_ID NUMBER(16,0),
                              AGENCIA_CONTRATO_ID NUMBER(16,0),
                              SUBCARTERA_EXPEDIENTE_CNT_ID NUMBER(16,0),
                              TIPO_SALIDA_EXP_CNT_ID NUMBER(16,0),
                              MOTIVO_SALIDA_EXP_CNT_ID NUMBER(16,0),
                              TIPO_INCIDENCIA_EXP_CNT_ID NUMBER(16,0),
                              ESTADO_INCIDENCIA_EXP_CNT_ID NUMBER(16,0),
                              -- Acciones
                              FECHA_ACCION DATE,
                              TIPO_ACCION_ID NUMBER(16,0),
                              RESULTADO_GESTION_ID NUMBER(16,0),
                              -- Metricas
                              NUM_CONTRATOS INTEGER,
                              NUM_CLIENTES_ASOCIADOS INTEGER,
                              NUM_EXPEDIENTES_ASOCIADOS INTEGER,
                              NUM_DIAS_VENCIDOS INTEGER,
                              NUM_DIAS_VENC_PERIODO_ANT INTEGER,
                              SALDO_TOTAL NUMBER(14,2),
                              RIESGO_VIVO NUMBER(14,2),
                              POS_VIVA_NO_VENC NUMBER(14,2),
                              POS_VIVA_VENC NUMBER(14,2),
                              SALDO_DUDOSO NUMBER(14,2),
                              PROVISION NUMBER(14,2),
                              INT_REMUNERATORIOS NUMBER(14,2),
                              INT_MORATORIOS NUMBER(14,2),
                              COMISIONES NUMBER(14,2),
                              GASTOS NUMBER(14,2),
                              RIESGO NUMBER(14,2),
                              DEUDA_IRREGULAR NUMBER(14,2),
                              DISPUESTO NUMBER(14,2),
                              SALDO_PASIVO NUMBER(14,2),
                              RIESGO_GARANTIA NUMBER(14,2),
                              SALDO_EXCE NUMBER(14,2),
                              LIMITE_DESC NUMBER(14,2),
                              MOV_EXTRA_1 NUMBER(14,2),
                              MOV_EXTRA_2 NUMBER(14,2),
                              MOV_LTV_INI NUMBER(16,0),
                              MOV_LTV_FIN NUMBER(16,0),
                              DD_MX3_ID NUMBER(16,0) DEFAULT NULL,
                              DD_MX4_ID NUMBER(16,0) DEFAULT NULL,
                              CNT_LIMITE_INI NUMBER(14,2) DEFAULT NULL,
                              CNT_LIMITE_FIN NUMBER(14,2) DEFAULT NULL,
                              NUM_CREDITOS_INSINUADOS INTEGER,
                              DEUDA_EXIGIBLE NUMBER(14,2) DEFAULT NULL,
                              CAPITAL_FALLIDO NUMBER(16,2) DEFAULT NULL,
                              CAPITAL_VIVO NUMBER(16,2) DEFAULT NULL,
                              IMPORTE_PTE_DIFER NUMBER(16,2) DEFAULT NULL,
                              -- Recobro
                              NUM_DPS INTEGER,
                              NUM_DPS_ACUMULADO INTEGER,
                              DPS NUMBER(14,2),
                              DPS_CAPITAL NUMBER(14,2),
                              DPS_ICG NUMBER(14,2),
                              DPS_ACUMULADO NUMBER(14,2),
                              DPS_CAPITAL_ACUMULADO NUMBER(14,2),
                              DPS_ICG_ACUMULADO NUMBER(14,2),
                              SALDO_MAXIMO_GESTION NUMBER(14,2),
                              IMPORTE_A_RECLAMAR NUMBER(14,2),
                              NUM_DIAS_EN_GESTION_A_COBRO INTEGER,
                              NUM_DIAS_IRREGULAR_A_COBRO INTEGER,
                              NUM_ACTUACIONES_RECOBRO INTEGER,
                              NUM_ACT_REC_ACUMULADO INTEGER,
                              NUM_ACT_REC_CONTACTO_UTIL INTEGER,
                              NUM_ACT_REC_CONTACTO_UTIL_ACU INTEGER,
                              -- Especializada
                              IMP_IRREGULAR_PREV_INICIO NUMBER(14,2),
                              IMP_IRREGULAR_PREV_AUTO NUMBER(14,2),
                              IMP_IRREGULAR_PREV_MANUAL NUMBER(14,2),
                              IMP_IRREGULAR_PREV_FINAL NUMBER(14,2),
                              IMP_RIESGO_PREV_INICIO NUMBER(14,2),
                              IMP_RIESGO_PREV_AUTO NUMBER(14,2),
                              IMP_RIESGO_PREV_MANUAL NUMBER(14,2),
                              IMP_RIESGO_PREV_FINAL NUMBER(14,2),
                              -- Acciones
                              IMPORTE_COMPROMETIDO NUMBER(14,2))
                              SEGMENT CREATION IMMEDIATE NOLOGGING
                            TABLESPACE "RECOVERY_PRODUC_DWH"   
                            PARTITION BY RANGE ("SEMANA_ID") INTERVAL (1) 
                           (PARTITION "P1" VALUES LESS THAN (201501) 
                           TABLESPACE "RECOVERY_PRODUC_DWH"'', :error); END;';
	execute immediate V_SQL USING OUT error;

        DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_SEMANA');

	  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_SEMANA_IX'', ''H_CNT_SEMANA (SEMANA_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
        execute immediate V_SQL USING OUT error;


        DBMS_OUTPUT.PUT_LINE('---- Creacion INDICES en H_CNT_SEMANA');
    

    ------------------------------ H_CNT_MES --------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_MES'', 
                            ''MES_ID NUMBER(16,0)  NOT NULL,
                              FECHA_CARGA_DATOS DATE  NOT NULL,                 -- Fecha ?ltimo d?a cargado
                              CONTRATO_ID NUMBER(16,0)  NOT NULL,
                              -- Dimensiones
                              CLASIFICACION_CNT_ID NUMBER(16,0) NULL,
                              SEGMENTO_CARTERA_ID NUMBER(16,0) NULL,
                              ENVIADO_AGENCIA_CNT_ID NUMBER(16,0) NULL,
                              SITUACION_CNT_DETALLE_ID NUMBER(16,0),          -- 0 Normal, 1 Vencido < 30 d?as, 2 Vencido 30-60 d?as, ...
                              SITUACION_ANT_CNT_DETALLE_ID NUMBER(16,0),      -- 0 Normal, 1 Vencido < 30 d?as, 2 Vencido 30-60 d?as, ...
                              SITUACION_RESP_PER_ANT_ID NUMBER(16,0),         -- 0 Mantiene, 1 Alta, 2 Baja
                              DIA_POS_VENCIDA_ID DATE,
                              DIA_SALDO_DUDOSO_ID DATE,
                              ESTADO_FINANCIERO_CNT_ID NUMBER(16,0),
                              ESTADO_FINANCIERO_ANT_ID NUMBER(16,0),
                              ESTADO_CONTRATO_ID NUMBER(16,0),
                              CONTRATO_JUDICIALIZADO_ID NUMBER(16,0),
                              ESTADO_INSINUACION_CNT_ID NUMBER(16,0),
                              CNT_CON_CAPITAL_FALLIDO_ID NUMBER(16,0),
                              TIPO_GESTION_CONTRATO_ID NUMBER(16,0),
                              FECHA_CREACION_CONTRATO DATE,
                              FECHA_CONSTITUCION_CONTRATO DATE,
                              FECHA_CAMBIO_TRAMO DATE,
                              FECHA_ALTA_DUDOSO DATE,
                              FECHA_BAJA_DUDOSO DATE,
                              T_SALDO_TOTAL_CNT_ID NUMBER(16,0),
                              T_SALDO_IRREGULAR_CNT_ID NUMBER(16,0),
                              T_DEUDA_IRREGULAR_CNT_ID NUMBER(16,0),
                              TRAMO_RIESGO_CNT_ID NUMBER(16,0),
                              TA_FECHA_CREACION_ID NUMBER(16,0),
                              PERIMETRO_GESTION_ID NUMBER(16,0),
                              PERIMETRO_SIN_GESTION_ID NUMBER(16,0),
                              PERIMETRO_EXP_SEG_ID NUMBER(16,0),
                              PERIMETRO_EXP_REC_ID NUMBER(16,0),
                              PERIMETRO_GES_EXTRA_ID NUMBER(16,0),
                              PERIMETRO_GES_PRE_ID NUMBER(16,0),
                              PERIMETRO_GES_JUDI_ID NUMBER(16,0),
                              PERIMETRO_GES_CONCU_ID NUMBER(16,0),  
                              MOTIVO_ALTA_DUDOSO_ID NUMBER(16,0),
                              MOTIVO_BAJA_DUDOSO_ID NUMBER(16,0),
                              SIT_CART_DANADA_ID NUMBER(16,0),
                              TIPO_GESTION_EXP_ID NUMBER(16,0),
                              -- Recobro
                              EN_GESTION_RECOBRO_ID NUMBER(16,0),
                              FECHA_ALTA_GESTION_RECOBRO DATE,
                              FECHA_BAJA_GESTION_RECOBRO DATE,
                              FECHA_COMPROMETIDA_PAGO DATE,
                              FECHA_DPS DATE,
                              T_IRREG_DIAS_ID NUMBER(16,0),
                              T_IRREG_DIAS_PERIODO_ANT_ID NUMBER(16,0),
                              TRAMO_ANTIGUEDAD_DEUDA_ID NUMBER(16,0) NULL,
                              T_IRREG_FASES_ID NUMBER(16,0),
                              T_IRREG_FASES_PER_ANT_ID NUMBER(16,0),
                              TD_EN_GESTION_A_COBRO_ID NUMBER(16,0),
                              TD_IRREGULAR_A_COBRO_ID NUMBER(16,0),
                              RESULTADO_ACTUACION_CNT_ID NUMBER(16,0),
                              MODELO_RECOBRO_CONTRATO_ID NUMBER(16,0),
                              PROVEEDOR_RECOBRO_CNT_ID NUMBER(16,0),
                              CONTRATO_EN_IRREGULAR_ID NUMBER(16,0),
                              CONTRATO_CON_DPS_ID NUMBER(16,0),
                              CNT_CON_CONTACTO_UTIL_ID NUMBER(16,0),
                              CNT_CON_ACTUACION_RECOBRO_ID NUMBER(16,0),
                              -- Especializada
                              FECHA_PREVISION date,
                              EN_GESTION_ESPECIALIZADA_ID NUMBER(16,0) ,
                              CONTRATO_CON_PREVISION_ID NUMBER(16,0) ,
                              CNT_CON_PREV_REVISADA_ID NUMBER(16,0),
                              TIPO_PREVISION_ID NUMBER(16,0) ,
                              PREV_SITUACION_INICIAL_ID NUMBER(16,0) ,
                              PREV_SITUACION_AUTO_ID NUMBER(16,0) ,
                              PREV_SITUACION_MANUAL_ID NUMBER(16,0) ,
                              PREV_SITUACION_FINAL_ID NUMBER(16,0) ,
                              MOTIVO_PREVISION_ID NUMBER(16,0),
                              SITUACION_ESPECIALIZADA_ID NUMBER(16,0),
                              GESTOR_ESPECIALIZADA_ID NUMBER(16,0),
                              SUPERVISOR_N1_ESPEC_ID NUMBER(16,0) ,
                              SUPERVISOR_N2_ESPEC_ID NUMBER(16,0) ,
                              SUPERVISOR_N3_ESPEC_ID NUMBER(16,0) ,
                              -- Estudio Carteras
                              EN_CARTERA_ESTUDIO_ID NUMBER(16,0) ,
                              MODELO_GESTION_CARTERA_ID NUMBER(16,0),
                              UNIDAD_GESTION_CARTERA_ID NUMBER(16,0),
                              -- Expediente
                              EXPEDIENTE_ID NUMBER(16,0) ,
                              FECHA_CREACION_EXPEDIENTE DATE,
                              FECHA_ROTURA_EXPEDIENTE DATE,
                              FECHA_SALIDA_AGENCIA_EXP DATE,
                              ESQUEMA_CONTRATO_ID NUMBER(16,0),
                              AGENCIA_CONTRATO_ID NUMBER(16,0),
                              SUBCARTERA_EXPEDIENTE_CNT_ID NUMBER(16,0),
                              TIPO_SALIDA_EXP_CNT_ID NUMBER(16,0),
                              MOTIVO_SALIDA_EXP_CNT_ID NUMBER(16,0),
                              TIPO_INCIDENCIA_EXP_CNT_ID NUMBER(16,0),
                              ESTADO_INCIDENCIA_EXP_CNT_ID NUMBER(16,0),
                              -- Acciones
                              FECHA_ACCION DATE,
                              TIPO_ACCION_ID NUMBER(16,0),
                              RESULTADO_GESTION_ID NUMBER(16,0),
                              -- Metricas
                              NUM_CONTRATOS INTEGER,
                              NUM_CLIENTES_ASOCIADOS INTEGER,
                              NUM_EXPEDIENTES_ASOCIADOS INTEGER,
                              NUM_DIAS_VENCIDOS INTEGER,
                              NUM_DIAS_VENC_PERIODO_ANT INTEGER,
                              SALDO_TOTAL NUMBER(14,2),
                              RIESGO_VIVO NUMBER(14,2),
                              POS_VIVA_NO_VENC NUMBER(14,2),
                              POS_VIVA_VENC NUMBER(14,2),
                              SALDO_DUDOSO NUMBER(14,2),
                              PROVISION NUMBER(14,2),
                              INT_REMUNERATORIOS NUMBER(14,2),
                              INT_MORATORIOS NUMBER(14,2),
                              COMISIONES NUMBER(14,2),
                              GASTOS NUMBER(14,2),
                              RIESGO NUMBER(14,2),
                              DEUDA_IRREGULAR NUMBER(14,2),
                              DISPUESTO NUMBER(14,2),
                              SALDO_PASIVO NUMBER(14,2),
                              RIESGO_GARANTIA NUMBER(14,2),
                              SALDO_EXCE NUMBER(14,2),
                              LIMITE_DESC NUMBER(14,2),
                              MOV_EXTRA_1 NUMBER(14,2),
                              MOV_EXTRA_2 NUMBER(14,2),
                              MOV_LTV_INI NUMBER(16,0),
                              MOV_LTV_FIN NUMBER(16,0),
                              DD_MX3_ID NUMBER(16,0) DEFAULT  NULL,
                              DD_MX4_ID NUMBER(16,0) DEFAULT NULL,
                              CNT_LIMITE_INI NUMBER(14,2) DEFAULT NULL,
                              CNT_LIMITE_FIN NUMBER(14,2) DEFAULT NULL,
                              NUM_CREDITOS_INSINUADOS INTEGER,
                              DEUDA_EXIGIBLE NUMBER(14,2) DEFAULT NULL,
                              CAPITAL_FALLIDO NUMBER(16,2) DEFAULT NULL,
                              CAPITAL_VIVO NUMBER(16,2) DEFAULT NULL,
                              IMPORTE_PTE_DIFER NUMBER(16,2) DEFAULT NULL,
                              -- Recobro
                              NUM_DPS INTEGER,
                              NUM_DPS_ACUMULADO INTEGER,
                              DPS NUMBER(14,2),
                              DPS_CAPITAL NUMBER(14,2),
                              DPS_ICG NUMBER(14,2),
                              DPS_ACUMULADO NUMBER(14,2),
                              DPS_CAPITAL_ACUMULADO NUMBER(14,2),
                              DPS_ICG_ACUMULADO NUMBER(14,2),
                              SALDO_MAXIMO_GESTION NUMBER(14,2),
                              IMPORTE_A_RECLAMAR NUMBER(14,2),
                              NUM_DIAS_EN_GESTION_A_COBRO INTEGER,
                              NUM_DIAS_IRREGULAR_A_COBRO INTEGER,
                              NUM_ACTUACIONES_RECOBRO INTEGER,
                              NUM_ACT_REC_ACUMULADO INTEGER,
                              NUM_ACT_REC_CONTACTO_UTIL INTEGER,
                              NUM_ACT_REC_CONTACTO_UTIL_ACU INTEGER,
                              -- Especializada
                              IMP_IRREGULAR_PREV_INICIO NUMBER(14,2),
                              IMP_IRREGULAR_PREV_AUTO NUMBER(14,2),
                              IMP_IRREGULAR_PREV_MANUAL NUMBER(14,2),
                              IMP_IRREGULAR_PREV_FINAL NUMBER(14,2),
                              IMP_RIESGO_PREV_INICIO NUMBER(14,2),
                              IMP_RIESGO_PREV_AUTO NUMBER(14,2),
                              IMP_RIESGO_PREV_MANUAL NUMBER(14,2),
                              IMP_RIESGO_PREV_FINAL NUMBER(14,2),
                              -- Acciones
                              IMPORTE_COMPROMETIDO NUMBER(14,2))
                              SEGMENT CREATION IMMEDIATE NOLOGGING
                           	TABLESPACE "RECOVERY_PRODUC_DWH"   
                           	PARTITION BY RANGE ("MES_ID") INTERVAL (1) 
                           	(PARTITION "P1" VALUES LESS THAN (201501) 
                           	TABLESPACE "RECOVERY_PRODUC_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;

        DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_MES');


      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_MES_IX'', ''H_CNT_MES (MES_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
  
        DBMS_OUTPUT.PUT_LINE('---- Creacion INDICES en H_CNT_MES');
  

    ------------------------------ H_CNT_TRIMESTRE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_TRIMESTRE'', 
              		      ''TRIMESTRE_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ?ltimo d?a cargado
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              -- Dimensiones
                              CLASIFICACION_CNT_ID NUMBER(16,0) NULL,
                              SEGMENTO_CARTERA_ID NUMBER(16,0) NULL,
                              ENVIADO_AGENCIA_CNT_ID NUMBER(16,0) NULL,
                              SITUACION_CNT_DETALLE_ID NUMBER(16,0),           -- 0 Normal, 1 Vencido < 30 d?as, 2 Vencido 30-60 d?as, ...
                              SITUACION_ANT_CNT_DETALLE_ID NUMBER(16,0),       -- 0 Normal, 1 Vencido < 30 d?as, 2 Vencido 30-60 d?as, ...
                              SITUACION_RESP_PER_ANT_ID NUMBER(16,0),          -- 0 Mantiene, 1 Alta, 2 Baja
                              DIA_POS_VENCIDA_ID DATE,
                              DIA_SALDO_DUDOSO_ID DATE,
                              ESTADO_FINANCIERO_CNT_ID NUMBER(16,0),
                              ESTADO_FINANCIERO_ANT_ID NUMBER(16,0),
                              ESTADO_CONTRATO_ID NUMBER(16,0),
                              CONTRATO_JUDICIALIZADO_ID NUMBER(16,0),
                              ESTADO_INSINUACION_CNT_ID NUMBER(16,0),
                              CNT_CON_CAPITAL_FALLIDO_ID NUMBER(16,0),
                              TIPO_GESTION_CONTRATO_ID NUMBER(16,0),
                              FECHA_CREACION_CONTRATO DATE,
                              FECHA_CONSTITUCION_CONTRATO DATE,
                              FECHA_CAMBIO_TRAMO DATE,
                              FECHA_ALTA_DUDOSO DATE,
                              FECHA_BAJA_DUDOSO DATE,
                              T_SALDO_TOTAL_CNT_ID NUMBER(16,0),
                              T_SALDO_IRREGULAR_CNT_ID NUMBER(16,0),
                              T_DEUDA_IRREGULAR_CNT_ID NUMBER(16,0),
                              TRAMO_RIESGO_CNT_ID NUMBER(16,0),
                              TA_FECHA_CREACION_ID NUMBER(16,0),
                              PERIMETRO_GESTION_ID NUMBER(16,0),
                              PERIMETRO_SIN_GESTION_ID NUMBER(16,0),
                              PERIMETRO_EXP_SEG_ID NUMBER(16,0),
                              PERIMETRO_EXP_REC_ID NUMBER(16,0),
                              PERIMETRO_GES_EXTRA_ID NUMBER(16,0),
                              PERIMETRO_GES_PRE_ID NUMBER(16,0),
                              PERIMETRO_GES_JUDI_ID NUMBER(16,0),
                              PERIMETRO_GES_CONCU_ID NUMBER(16,0),  
                              MOTIVO_ALTA_DUDOSO_ID NUMBER(16,0),
                              MOTIVO_BAJA_DUDOSO_ID NUMBER(16,0),
                              SIT_CART_DANADA_ID NUMBER(16,0),
                              TIPO_GESTION_EXP_ID NUMBER(16,0),
                              -- Recobro
                              EN_GESTION_RECOBRO_ID NUMBER(16,0),
                              FECHA_ALTA_GESTION_RECOBRO DATE,
                              FECHA_BAJA_GESTION_RECOBRO DATE,
                              FECHA_COMPROMETIDA_PAGO DATE,
                              FECHA_DPS DATE,
                              T_IRREG_DIAS_ID NUMBER(16,0),
                              T_IRREG_DIAS_PERIODO_ANT_ID NUMBER(16,0),
                              TRAMO_ANTIGUEDAD_DEUDA_ID NUMBER(16,0) NULL,
                              T_IRREG_FASES_ID NUMBER(16,0),
                              T_IRREG_FASES_PER_ANT_ID NUMBER(16,0),
                              TD_EN_GESTION_A_COBRO_ID NUMBER(16,0),
                              TD_IRREGULAR_A_COBRO_ID NUMBER(16,0),
                              RESULTADO_ACTUACION_CNT_ID NUMBER(16,0),
                              MODELO_RECOBRO_CONTRATO_ID NUMBER(16,0),
                              PROVEEDOR_RECOBRO_CNT_ID NUMBER(16,0),
                              CONTRATO_EN_IRREGULAR_ID NUMBER(16,0),
                              CONTRATO_CON_DPS_ID NUMBER(16,0),
                              CNT_CON_CONTACTO_UTIL_ID NUMBER(16,0),
                              CNT_CON_ACTUACION_RECOBRO_ID NUMBER(16,0),
                              -- Especializada
                              FECHA_PREVISION date,
                              EN_GESTION_ESPECIALIZADA_ID NUMBER(16,0),
                              CONTRATO_CON_PREVISION_ID NUMBER(16,0),
                              CNT_CON_PREV_REVISADA_ID NUMBER(16,0),
                              TIPO_PREVISION_ID NUMBER(16,0),
                              PREV_SITUACION_INICIAL_ID NUMBER(16,0),
                              PREV_SITUACION_AUTO_ID NUMBER(16,0),
                              PREV_SITUACION_MANUAL_ID NUMBER(16,0),
                              PREV_SITUACION_FINAL_ID NUMBER(16,0),
                              MOTIVO_PREVISION_ID NUMBER(16,0),
                              SITUACION_ESPECIALIZADA_ID NUMBER(16,0),
                              GESTOR_ESPECIALIZADA_ID NUMBER(16,0),
                              SUPERVISOR_N1_ESPEC_ID NUMBER(16,0),
                              SUPERVISOR_N2_ESPEC_ID NUMBER(16,0),
                              SUPERVISOR_N3_ESPEC_ID NUMBER(16,0),
                              -- Estudio Carteras
                              EN_CARTERA_ESTUDIO_ID NUMBER(16,0),
                              MODELO_GESTION_CARTERA_ID NUMBER(16,0),
                              UNIDAD_GESTION_CARTERA_ID NUMBER(16,0),
                              -- Expediente
                              EXPEDIENTE_ID NUMBER(16,0),
                              FECHA_CREACION_EXPEDIENTE DATE,
                              FECHA_ROTURA_EXPEDIENTE DATE,
                              FECHA_SALIDA_AGENCIA_EXP DATE,
                              ESQUEMA_CONTRATO_ID NUMBER(16,0),
                              AGENCIA_CONTRATO_ID NUMBER(16,0),
                              SUBCARTERA_EXPEDIENTE_CNT_ID NUMBER(16,0),
                              TIPO_SALIDA_EXP_CNT_ID NUMBER(16,0),
                              MOTIVO_SALIDA_EXP_CNT_ID NUMBER(16,0),
                              TIPO_INCIDENCIA_EXP_CNT_ID NUMBER(16,0),
                              ESTADO_INCIDENCIA_EXP_CNT_ID NUMBER(16,0),
                              -- Acciones
                              FECHA_ACCION DATE,
                              TIPO_ACCION_ID NUMBER(16,0),
                              RESULTADO_GESTION_ID NUMBER(16,0),
                              -- Metricas
                              NUM_CONTRATOS INTEGER,
                              NUM_CLIENTES_ASOCIADOS INTEGER,
                              NUM_EXPEDIENTES_ASOCIADOS INTEGER,
                              NUM_DIAS_VENCIDOS INTEGER,
                              NUM_DIAS_VENC_PERIODO_ANT INTEGER,
                              SALDO_TOTAL NUMBER(14,2),
                              RIESGO_VIVO NUMBER(14,2),
                              POS_VIVA_NO_VENC NUMBER(14,2),
                              POS_VIVA_VENC NUMBER(14,2),
                              SALDO_DUDOSO NUMBER(14,2),
                              PROVISION NUMBER(14,2),
                              INT_REMUNERATORIOS NUMBER(14,2),
                              INT_MORATORIOS NUMBER(14,2),
                              COMISIONES NUMBER(14,2),
                              GASTOS NUMBER(14,2),
                              RIESGO NUMBER(14,2),
                              DEUDA_IRREGULAR NUMBER(14,2),
                              DISPUESTO NUMBER(14,2),
                              SALDO_PASIVO NUMBER(14,2),
                              RIESGO_GARANTIA NUMBER(14,2),
                              SALDO_EXCE NUMBER(14,2),
                              LIMITE_DESC NUMBER(14,2),
                              MOV_EXTRA_1 NUMBER(14,2),
                              MOV_EXTRA_2 NUMBER(14,2),
                              MOV_LTV_INI NUMBER(16,0),
                              MOV_LTV_FIN NUMBER(16,0),
                              DD_MX3_ID NUMBER(16,0) DEFAULT NULL,
                              DD_MX4_ID NUMBER(16,0) DEFAULT NULL,
                              CNT_LIMITE_INI NUMBER(14,2) DEFAULT NULL,
                              CNT_LIMITE_FIN NUMBER(14,2) DEFAULT NULL,
                              NUM_CREDITOS_INSINUADOS INTEGER,
                              DEUDA_EXIGIBLE NUMBER(14,2) DEFAULT NULL,
                              CAPITAL_FALLIDO NUMBER(16,2) DEFAULT NULL,
                              CAPITAL_VIVO NUMBER(16,2) DEFAULT NULL,
                              IMPORTE_PTE_DIFER NUMBER(16,2) DEFAULT NULL,
                              -- Recobro
                              NUM_DPS INTEGER,
                              NUM_DPS_ACUMULADO INTEGER,
                              DPS NUMBER(14,2),
                              DPS_CAPITAL NUMBER(14,2),
                              DPS_ICG NUMBER(14,2),
                              DPS_ACUMULADO NUMBER(14,2),
                              DPS_CAPITAL_ACUMULADO NUMBER(14,2),
                              DPS_ICG_ACUMULADO NUMBER(14,2),
                              SALDO_MAXIMO_GESTION NUMBER(14,2),
                              IMPORTE_A_RECLAMAR NUMBER(14,2),
                              NUM_DIAS_EN_GESTION_A_COBRO INTEGER,
                              NUM_DIAS_IRREGULAR_A_COBRO INTEGER,
                              NUM_ACTUACIONES_RECOBRO INTEGER,
                              NUM_ACT_REC_ACUMULADO INTEGER,
                              NUM_ACT_REC_CONTACTO_UTIL INTEGER,
                              NUM_ACT_REC_CONTACTO_UTIL_ACU INTEGER,
                              -- Especializada
                              IMP_IRREGULAR_PREV_INICIO NUMBER(14,2),
                              IMP_IRREGULAR_PREV_AUTO NUMBER(14,2),
                              IMP_IRREGULAR_PREV_MANUAL NUMBER(14,2),
                              IMP_IRREGULAR_PREV_FINAL NUMBER(14,2),
                              IMP_RIESGO_PREV_INICIO NUMBER(14,2),
                              IMP_RIESGO_PREV_AUTO NUMBER(14,2),
                              IMP_RIESGO_PREV_MANUAL NUMBER(14,2),
                              IMP_RIESGO_PREV_FINAL NUMBER(14,2),
                              -- Acciones
                              IMPORTE_COMPROMETIDO NUMBER(14,2))
                              SEGMENT CREATION IMMEDIATE NOLOGGING
                            	TABLESPACE "RECOVERY_PRODUC_DWH"   
                            	PARTITION BY RANGE ("TRIMESTRE_ID") INTERVAL (1) 
                            	(PARTITION "P1" VALUES LESS THAN (201501) 
                            	TABLESPACE "RECOVERY_PRODUC_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;

        DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_TRIMESTRE');

     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_TRIMESTRE_IX'', ''H_CNT_TRIMESTRE (TRIMESTRE_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

   
        DBMS_OUTPUT.PUT_LINE('---- Creacion INDICES en H_CNT_TRIMESTRE');


    ------------------------------ H_CNT_ANIO --------------------------
        V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_ANIO'', 
              		      ''ANIO_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                  -- Fecha ?ltimo d?a cargado
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              -- Dimensiones
                              CLASIFICACION_CNT_ID NUMBER(16,0) NULL,
                              SEGMENTO_CARTERA_ID NUMBER(16,0) NULL,
                              ENVIADO_AGENCIA_CNT_ID NUMBER(16,0) NULL,
                              SITUACION_CNT_DETALLE_ID NUMBER(16,0),           -- 0 Normal, 1 Vencido < 30 d?as, 2 Vencido 30-60 d?as, ...
                              SITUACION_ANT_CNT_DETALLE_ID NUMBER(16,0),       -- 0 Normal, 1 Vencido < 30 d?as, 2 Vencido 30-60 d?as, ...
                              SITUACION_RESP_PER_ANT_ID NUMBER(16,0),          -- 0 Mantiene, 1 Alta, 2 Baja
                              DIA_POS_VENCIDA_ID DATE,
                              DIA_SALDO_DUDOSO_ID DATE,
                              ESTADO_FINANCIERO_CNT_ID NUMBER(16,0),
                              ESTADO_FINANCIERO_ANT_ID NUMBER(16,0),
                              ESTADO_CONTRATO_ID NUMBER(16,0),
                              CONTRATO_JUDICIALIZADO_ID NUMBER(16,0),
                              ESTADO_INSINUACION_CNT_ID NUMBER(16,0),
                              CNT_CON_CAPITAL_FALLIDO_ID NUMBER(16,0),
                              TIPO_GESTION_CONTRATO_ID NUMBER(16,0),
                              FECHA_CREACION_CONTRATO DATE,
                              FECHA_CONSTITUCION_CONTRATO DATE,
                              FECHA_CAMBIO_TRAMO DATE,
                              FECHA_ALTA_DUDOSO DATE,
                              FECHA_BAJA_DUDOSO DATE,
                              T_SALDO_TOTAL_CNT_ID NUMBER(16,0),
                              T_SALDO_IRREGULAR_CNT_ID NUMBER(16,0),
                              T_DEUDA_IRREGULAR_CNT_ID NUMBER(16,0),
                              TRAMO_RIESGO_CNT_ID NUMBER(16,0),
                              TA_FECHA_CREACION_ID NUMBER(16,0),
                              PERIMETRO_GESTION_ID NUMBER(16,0),
                              PERIMETRO_SIN_GESTION_ID NUMBER(16,0),
                              PERIMETRO_EXP_SEG_ID NUMBER(16,0),
                              PERIMETRO_EXP_REC_ID NUMBER(16,0),
                              PERIMETRO_GES_EXTRA_ID NUMBER(16,0),
                              PERIMETRO_GES_PRE_ID NUMBER(16,0),
                              PERIMETRO_GES_JUDI_ID NUMBER(16,0),
                              PERIMETRO_GES_CONCU_ID NUMBER(16,0),  
                              MOTIVO_ALTA_DUDOSO_ID NUMBER(16,0),
                              MOTIVO_BAJA_DUDOSO_ID NUMBER(16,0),
                              SIT_CART_DANADA_ID NUMBER(16,0),
                              TIPO_GESTION_EXP_ID NUMBER(16,0),
                              -- Recobro
                              EN_GESTION_RECOBRO_ID NUMBER(16,0),
                              FECHA_ALTA_GESTION_RECOBRO DATE,
                              FECHA_BAJA_GESTION_RECOBRO DATE,
                              FECHA_COMPROMETIDA_PAGO DATE,
                              FECHA_DPS DATE,
                              T_IRREG_DIAS_ID NUMBER(16,0),
                              T_IRREG_DIAS_PERIODO_ANT_ID NUMBER(16,0),
                              TRAMO_ANTIGUEDAD_DEUDA_ID NUMBER(16,0) NULL,
                              T_IRREG_FASES_ID NUMBER(16,0),
                              T_IRREG_FASES_PER_ANT_ID NUMBER(16,0),
                              TD_EN_GESTION_A_COBRO_ID NUMBER(16,0),
                              TD_IRREGULAR_A_COBRO_ID NUMBER(16,0),
                              RESULTADO_ACTUACION_CNT_ID NUMBER(16,0),
                              MODELO_RECOBRO_CONTRATO_ID NUMBER(16,0),
                              PROVEEDOR_RECOBRO_CNT_ID NUMBER(16,0),
                              CONTRATO_EN_IRREGULAR_ID NUMBER(16,0),
                              CONTRATO_CON_DPS_ID NUMBER(16,0),
                              CNT_CON_CONTACTO_UTIL_ID NUMBER(16,0),
                              CNT_CON_ACTUACION_RECOBRO_ID NUMBER(16,0),
                              -- Especializada
                              FECHA_PREVISION date,
                              EN_GESTION_ESPECIALIZADA_ID NUMBER(16,0),
                              CONTRATO_CON_PREVISION_ID NUMBER(16,0),
                              CNT_CON_PREV_REVISADA_ID NUMBER(16,0),
                              TIPO_PREVISION_ID NUMBER(16,0),
                              PREV_SITUACION_INICIAL_ID NUMBER(16,0),
                              PREV_SITUACION_AUTO_ID NUMBER(16,0),
                              PREV_SITUACION_MANUAL_ID NUMBER(16,0),
                              PREV_SITUACION_FINAL_ID NUMBER(16,0),
                              MOTIVO_PREVISION_ID NUMBER(16,0),
                              SITUACION_ESPECIALIZADA_ID NUMBER(16,0),
                              GESTOR_ESPECIALIZADA_ID NUMBER(16,0),
                              SUPERVISOR_N1_ESPEC_ID NUMBER(16,0),
                              SUPERVISOR_N2_ESPEC_ID NUMBER(16,0),
                              SUPERVISOR_N3_ESPEC_ID NUMBER(16,0),
                              -- Estudio Carteras
                              EN_CARTERA_ESTUDIO_ID NUMBER(16,0),
                              MODELO_GESTION_CARTERA_ID NUMBER(16,0),
                              UNIDAD_GESTION_CARTERA_ID NUMBER(16,0),
                              -- Expediente
                              EXPEDIENTE_ID NUMBER(16,0),
                              FECHA_CREACION_EXPEDIENTE DATE,
                              FECHA_ROTURA_EXPEDIENTE DATE,
                              FECHA_SALIDA_AGENCIA_EXP DATE,
                              ESQUEMA_CONTRATO_ID NUMBER(16,0),
                              AGENCIA_CONTRATO_ID NUMBER(16,0),
                              SUBCARTERA_EXPEDIENTE_CNT_ID NUMBER(16,0),
                              TIPO_SALIDA_EXP_CNT_ID NUMBER(16,0),
                              MOTIVO_SALIDA_EXP_CNT_ID NUMBER(16,0),
                              TIPO_INCIDENCIA_EXP_CNT_ID NUMBER(16,0),
                              ESTADO_INCIDENCIA_EXP_CNT_ID NUMBER(16,0),
                              -- Acciones
                              FECHA_ACCION DATE,
                              TIPO_ACCION_ID NUMBER(16,0),
                              RESULTADO_GESTION_ID NUMBER(16,0),
                              -- Metricas
                              NUM_CONTRATOS INTEGER,
                              NUM_CLIENTES_ASOCIADOS INTEGER,
                              NUM_EXPEDIENTES_ASOCIADOS INTEGER,
                              NUM_DIAS_VENCIDOS INTEGER,
                              NUM_DIAS_VENC_PERIODO_ANT INTEGER,
                              SALDO_TOTAL NUMBER(14,2),
                              RIESGO_VIVO NUMBER(14,2),
                              POS_VIVA_NO_VENC NUMBER(14,2),
                              POS_VIVA_VENC NUMBER(14,2),
                              SALDO_DUDOSO NUMBER(14,2),
                              PROVISION NUMBER(14,2),
                              INT_REMUNERATORIOS NUMBER(14,2),
                              INT_MORATORIOS NUMBER(14,2),
                              COMISIONES NUMBER(14,2),
                              GASTOS NUMBER(14,2),
                              RIESGO NUMBER(14,2),
                              DEUDA_IRREGULAR NUMBER(14,2),
                              DISPUESTO NUMBER(14,2),
                              SALDO_PASIVO NUMBER(14,2),
                              RIESGO_GARANTIA NUMBER(14,2),
                              SALDO_EXCE NUMBER(14,2),
                              LIMITE_DESC NUMBER(14,2),
                              MOV_EXTRA_1 NUMBER(14,2),
                              MOV_EXTRA_2 NUMBER(14,2),
                              MOV_LTV_INI NUMBER(16,0),
                              MOV_LTV_FIN NUMBER(16,0),
                              DD_MX3_ID NUMBER(16,0) DEFAULT NULL,
                              DD_MX4_ID NUMBER(16,0) DEFAULT NULL,
                              CNT_LIMITE_INI NUMBER(14,2) DEFAULT NULL,
                              CNT_LIMITE_FIN NUMBER(14,2) DEFAULT NULL,
                              NUM_CREDITOS_INSINUADOS INTEGER,
                              DEUDA_EXIGIBLE NUMBER(14,2) DEFAULT NULL,
                              CAPITAL_FALLIDO NUMBER(16,2) DEFAULT NULL,
                              CAPITAL_VIVO NUMBER(16,2) DEFAULT NULL,
                              IMPORTE_PTE_DIFER NUMBER(16,2) DEFAULT NULL,
                              -- Recobro
                              NUM_DPS INTEGER,
                              NUM_DPS_ACUMULADO INTEGER,
                              DPS NUMBER(14,2),
                              DPS_CAPITAL NUMBER(14,2),
                              DPS_ICG NUMBER(14,2),
                              DPS_ACUMULADO NUMBER(14,2),
                              DPS_CAPITAL_ACUMULADO NUMBER(14,2),
                              DPS_ICG_ACUMULADO NUMBER(14,2),
                              SALDO_MAXIMO_GESTION NUMBER(14,2),
                              IMPORTE_A_RECLAMAR NUMBER(14,2),
                              NUM_DIAS_EN_GESTION_A_COBRO INTEGER,
                              NUM_DIAS_IRREGULAR_A_COBRO INTEGER,
                              NUM_ACTUACIONES_RECOBRO INTEGER,
                              NUM_ACT_REC_ACUMULADO INTEGER,
                              NUM_ACT_REC_CONTACTO_UTIL INTEGER,
                              NUM_ACT_REC_CONTACTO_UTIL_ACU INTEGER,
                              -- Especializada
                              IMP_IRREGULAR_PREV_INICIO NUMBER(14,2),
                              IMP_IRREGULAR_PREV_AUTO NUMBER(14,2),
                              IMP_IRREGULAR_PREV_MANUAL NUMBER(14,2),
                              IMP_IRREGULAR_PREV_FINAL NUMBER(14,2),
                              IMP_RIESGO_PREV_INICIO NUMBER(14,2),
                              IMP_RIESGO_PREV_AUTO NUMBER(14,2),
                              IMP_RIESGO_PREV_MANUAL NUMBER(14,2),
                              IMP_RIESGO_PREV_FINAL NUMBER(14,2),
                              -- Acciones
                              IMPORTE_COMPROMETIDO NUMBER(14,2))
                             SEGMENT CREATION IMMEDIATE NOLOGGING
                            	TABLESPACE "RECOVERY_PRODUC_DWH"   
                            	PARTITION BY RANGE ("ANIO_ID") INTERVAL (1) 
                            	(PARTITION "P1" VALUES LESS THAN (2015) 
                            	TABLESPACE "RECOVERY_PRODUC_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;

        DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_ANIO');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_ANIO_IX'', ''H_CNT_ANIO (ANIO_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

        DBMS_OUTPUT.PUT_LINE('---- Creacion INDICES en H_CNT_ANIO');




    ------------------------------ H_CNT_DET_COBRO --------------------------
         V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_DET_COBRO'', 
              		      ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              COBRO_ID NUMBER(16,0) NULL,
                              FECHA_CONTRATO DATE ,
                              FECHA_COBRO DATE ,
                              FECHA_FACTURA DATE ,
                              -- Dimensiones
                              TIPO_COBRO_DET_ID NUMBER(16,0) ,
                              COBRO_FACTURADO_ID NUMBER(16,0) ,
                              REMESA_FACTURA_ID NUMBER(16,0) ,
                              ESQUEMA_COBRO_ID NUMBER(16,0) NULL,
                              AGENCIA_COBRO_ID NUMBER(16,0) NULL,
                              SUBCARTERA_COBRO_ID NUMBER(16,0) NULL,
                              TIPO_PRODUCTO_COBRO_ID NUMBER(16,0) NULL,
                              GARANTIA_COBRO_ID NUMBER(16,0) NULL,
                              SEGMENTO_CARTERA_COBRO_ID NUMBER(16,0) NULL,
                              TD_IRREG_COBRO_ID NUMBER(16,0) NULL,
                              T_DEUDA_IRREGULAR_COBRO_ID NUMBER(16,0) NULL,
                              ENVIADO_AGENCIA_COBRO_ID NUMBER(16,0) NULL,
                              FACTURA_COBRO_ID NUMBER(16,0) NULL,
                              -- Metricas
                              NUM_COBROS INTEGER ,
                              IMPORTE_COBRO NUMBER(16,2) ,
                              POSICION_VENCIDA_COBRO NUMBER(16,2) ,
                              POSICION_NO_VENCIDA_COBRO NUMBER(16,2) ,
                              INT_REMUNERATORIOS_COBRO NUMBER(16,2) ,
                              INT_MORATORIOS_COBRO NUMBER(16,2) ,
                              COMISIONES_COBRO NUMBER(16,2) ,
                              GASTOS_COBRO NUMBER(16,2) ,       
                              DEUDA_IRREGULAR_COBRO NUMBER(14,2) ,
                              RIESGO_VIVO_COBRO NUMBER(14,2) ,
                              NUM_DIAS_VENCIDOS_COBRO INTEGER ,  
                              IMPORTE_FACTURA_TOTAL NUMBER(16,2) ,                       -- Importe factura total: IMPORTE_FACTURA_TARIFA + CORRECTOR_FACTURA
                              IMPORTE_FACTURA_TARIFA NUMBER(16,2) ,                      -- Importe factura tarifa: suma del desglose de la factura
                              CORRECTOR_FACTURA NUMBER(16,2) ,
                              POSICION_VENCIDA_FACTURA NUMBER(16,2) ,
                              POSICION_NO_VENCIDA_FACTURA NUMBER(16,2) ,
                              INT_REMUNERATORIOS_FACTURA NUMBER(16,2) ,
                              INT_MORATORIOS_FACTURA NUMBER(16,2) ,
                              COMISIONES_FACTURA NUMBER(16,2) ,
                              GASTOS_FACTURA NUMBER(16,2))
                           SEGMENT CREATION IMMEDIATE 
					TABLESPACE "RECOVERY_PRODUC_DWH" 
                    PARTITION BY RANGE ("DIA_ID")
                    INTERVAL(NUMTOYMINTERVAL(1, ''''MONTH''''))
                    (PARTITION "p1" VALUES LESS THAN (TO_DATE('''' 2014-11-01 00:00:00'''', ''''SYYYY-MM-DD HH24:MI:SS'''', ''''NLS_CALENDAR=GREGORIAN''''))'', :error); END;';
	 execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_DET_COBRO');

	    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_COBRO_IX'', ''H_CNT_DET_COBRO (DIA_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

	    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_COBRO_FECHA_IX'', ''H_CNT_DET_COBRO (FECHA_COBRO, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;


      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CNT_DET_COBRO');
      


    ------------------------------ TMP_H_CNT_DET_COBRO --------------------------
         V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_H_CNT_DET_COBRO'', 
              		      ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              COBRO_ID NUMBER(16,0) NULL,
                              FECHA_CONTRATO DATE ,
                              FECHA_COBRO DATE ,
                              FECHA_FACTURA DATE ,
                              -- Dimensiones
                              TIPO_COBRO_DET_ID NUMBER(16,0) ,
                              COBRO_FACTURADO_ID NUMBER(16,0) ,
                              REMESA_FACTURA_ID NUMBER(16,0) ,
                              ESQUEMA_COBRO_ID NUMBER(16,0) NULL,
                              AGENCIA_COBRO_ID NUMBER(16,0) NULL,
                              SUBCARTERA_COBRO_ID NUMBER(16,0) NULL,
                              TIPO_PRODUCTO_COBRO_ID NUMBER(16,0) NULL,
                              GARANTIA_COBRO_ID NUMBER(16,0) NULL,
                              SEGMENTO_CARTERA_COBRO_ID NUMBER(16,0) NULL,
                              TD_IRREG_COBRO_ID NUMBER(16,0) NULL,
                              T_DEUDA_IRREGULAR_COBRO_ID NUMBER(16,0) NULL,
                              ENVIADO_AGENCIA_COBRO_ID NUMBER(16,0) NULL,
                              FACTURA_COBRO_ID NUMBER(16,0) NULL,
                              -- Metricas
                              NUM_COBROS INTEGER ,
                              IMPORTE_COBRO NUMBER(16,2) ,
                              POSICION_VENCIDA_COBRO NUMBER(16,2) ,
                              POSICION_NO_VENCIDA_COBRO NUMBER(16,2) ,
                              INT_REMUNERATORIOS_COBRO NUMBER(16,2) ,
                              INT_MORATORIOS_COBRO NUMBER(16,2) ,
                              COMISIONES_COBRO NUMBER(16,2) ,
                              GASTOS_COBRO NUMBER(16,2) ,       
                              DEUDA_IRREGULAR_COBRO NUMBER(14,2) ,
                              RIESGO_VIVO_COBRO NUMBER(14,2) ,
                              NUM_DIAS_VENCIDOS_COBRO INTEGER ,  
                              IMPORTE_FACTURA_TOTAL NUMBER(16,2) ,                       -- Importe factura total: IMPORTE_FACTURA_TARIFA + CORRECTOR_FACTURA
                              IMPORTE_FACTURA_TARIFA NUMBER(16,2) ,                      -- Importe factura tarifa: suma del desglose de la factura
                              CORRECTOR_FACTURA NUMBER(16,2) ,
                              POSICION_VENCIDA_FACTURA NUMBER(16,2) ,
                              POSICION_NO_VENCIDA_FACTURA NUMBER(16,2) ,
                              INT_REMUNERATORIOS_FACTURA NUMBER(16,2) ,
                              INT_MORATORIOS_FACTURA NUMBER(16,2) ,
                              COMISIONES_FACTURA NUMBER(16,2) ,
                              GASTOS_FACTURA NUMBER(16,2)
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_H_CNT_DET_COBRO');

	    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_CNT_DET_COBRO_IX'', ''TMP_H_CNT_DET_COBRO (DIA_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
	    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_CNT_DET_COBRO_FCOB_IX'', ''TMP_H_CNT_DET_COBRO (FECHA_COBRO, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
	    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_CNT_DET_COBRO_FCNT_IX '', ''TMP_H_CNT_DET_COBRO (FECHA_CONTRATO, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
	    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_CNT_DET_COB_COBRO_ID_IX'', ''TMP_H_CNT_DET_COBRO (COBRO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_H_CNT_DET_COBRO');
      
 
        
    
    ------------------------------ H_CNT_DET_COBRO_SEMANA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_DET_COBRO_SEMANA'', 
              		      ''SEMANA_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              COBRO_ID NUMBER(16,0) NULL,
                              FECHA_CONTRATO DATE ,
                              FECHA_COBRO DATE ,
                              FECHA_FACTURA DATE ,
                              -- Dimensiones
                              TIPO_COBRO_DET_ID NUMBER(16,0) ,
                              COBRO_FACTURADO_ID NUMBER(16,0) ,
                              REMESA_FACTURA_ID NUMBER(16,0) ,
                              ESQUEMA_COBRO_ID NUMBER(16,0) NULL,
                              AGENCIA_COBRO_ID NUMBER(16,0) NULL,
                              SUBCARTERA_COBRO_ID NUMBER(16,0) NULL,
                              TIPO_PRODUCTO_COBRO_ID NUMBER(16,0) NULL,
                              GARANTIA_COBRO_ID NUMBER(16,0) NULL,
                              SEGMENTO_CARTERA_COBRO_ID NUMBER(16,0) NULL,
                              TD_IRREG_COBRO_ID NUMBER(16,0) NULL,
                              T_DEUDA_IRREGULAR_COBRO_ID NUMBER(16,0) NULL,
                              ENVIADO_AGENCIA_COBRO_ID NUMBER(16,0) NULL,
                              FACTURA_COBRO_ID NUMBER(16,0) NULL,
                              -- Metricas
                              NUM_COBROS INTEGER ,
                              IMPORTE_COBRO NUMBER(16,2) ,
                              POSICION_VENCIDA_COBRO NUMBER(16,2) ,
                              POSICION_NO_VENCIDA_COBRO NUMBER(16,2) ,
                              INT_REMUNERATORIOS_COBRO NUMBER(16,2) ,
                              INT_MORATORIOS_COBRO NUMBER(16,2) ,
                              COMISIONES_COBRO NUMBER(16,2) ,
                              GASTOS_COBRO NUMBER(16,2) ,       
                              DEUDA_IRREGULAR_COBRO NUMBER(14,2) ,
                              RIESGO_VIVO_COBRO NUMBER(14,2) ,
                              NUM_DIAS_VENCIDOS_COBRO INTEGER ,  
                              IMPORTE_FACTURA_TOTAL NUMBER(16,2) ,                       -- Importe factura total: IMPORTE_FACTURA_TARIFA + CORRECTOR_FACTURA
                              IMPORTE_FACTURA_TARIFA NUMBER(16,2) ,                      -- Importe factura tarifa: suma del desglose de la factura
                              CORRECTOR_FACTURA NUMBER(16,2) ,
                              POSICION_VENCIDA_FACTURA NUMBER(16,2) ,
                              POSICION_NO_VENCIDA_FACTURA NUMBER(16,2) ,
                              INT_REMUNERATORIOS_FACTURA NUMBER(16,2) ,
                              INT_MORATORIOS_FACTURA NUMBER(16,2) ,
                              COMISIONES_FACTURA NUMBER(16,2) ,
                              GASTOS_FACTURA NUMBER(16,2)
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_DET_COBRO_SEMANA');

	    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_COBRO_SEMANA_IX'', ''H_CNT_DET_COBRO_SEMANA (SEMANA_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;


      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CNT_DET_COBRO_SEMANA');



    ------------------------------ H_CNT_DET_COBRO_MES --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_DET_COBRO_MES'', 
              		      ''MES_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              COBRO_ID NUMBER(16,0) NULL,
                              FECHA_CONTRATO DATE ,
                              FECHA_COBRO DATE ,
                              FECHA_FACTURA DATE ,
                              -- Dimensiones
                              TIPO_COBRO_DET_ID NUMBER(16,0) ,
                              COBRO_FACTURADO_ID NUMBER(16,0) ,
                              REMESA_FACTURA_ID NUMBER(16,0) ,
                              ESQUEMA_COBRO_ID NUMBER(16,0) NULL,
                              AGENCIA_COBRO_ID NUMBER(16,0) NULL,
                              SUBCARTERA_COBRO_ID NUMBER(16,0) NULL,
                              TIPO_PRODUCTO_COBRO_ID NUMBER(16,0) NULL,
                              GARANTIA_COBRO_ID NUMBER(16,0) NULL,
                              SEGMENTO_CARTERA_COBRO_ID NUMBER(16,0) NULL,
                              TD_IRREG_COBRO_ID NUMBER(16,0) NULL,
                              T_DEUDA_IRREGULAR_COBRO_ID NUMBER(16,0) NULL,
                              ENVIADO_AGENCIA_COBRO_ID NUMBER(16,0) NULL,
                              FACTURA_COBRO_ID NUMBER(16,0) NULL,
                              -- Metricas
                              NUM_COBROS INTEGER ,
                              IMPORTE_COBRO NUMBER(16,2) ,
                              POSICION_VENCIDA_COBRO NUMBER(16,2) ,
                              POSICION_NO_VENCIDA_COBRO NUMBER(16,2) ,
                              INT_REMUNERATORIOS_COBRO NUMBER(16,2) ,
                              INT_MORATORIOS_COBRO NUMBER(16,2) ,
                              COMISIONES_COBRO NUMBER(16,2) ,
                              GASTOS_COBRO NUMBER(16,2) ,       
                              DEUDA_IRREGULAR_COBRO NUMBER(14,2) ,
                              RIESGO_VIVO_COBRO NUMBER(14,2) ,
                              NUM_DIAS_VENCIDOS_COBRO INTEGER ,  
                              IMPORTE_FACTURA_TOTAL NUMBER(16,2) ,                       -- Importe factura total: IMPORTE_FACTURA_TARIFA + CORRECTOR_FACTURA
                              IMPORTE_FACTURA_TARIFA NUMBER(16,2) ,                      -- Importe factura tarifa: suma del desglose de la factura
                              CORRECTOR_FACTURA NUMBER(16,2) ,
                              POSICION_VENCIDA_FACTURA NUMBER(16,2) ,
                              POSICION_NO_VENCIDA_FACTURA NUMBER(16,2) ,
                              INT_REMUNERATORIOS_FACTURA NUMBER(16,2) ,
                              INT_MORATORIOS_FACTURA NUMBER(16,2) ,
                              COMISIONES_FACTURA NUMBER(16,2) ,
                              GASTOS_FACTURA NUMBER(16,2)
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_DET_COBRO_MES');

	    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_COBRO_MES_IX'', ''H_CNT_DET_COBRO_MES (MES_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;


      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CNT_DET_COBRO_MES');
  

    ------------------------------ H_CNT_DET_COBRO_TRIMESTRE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_DET_COBRO_TRIMESTRE'', 
              		      ''TRIMESTRE_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              COBRO_ID NUMBER(16,0) NULL,
                              FECHA_CONTRATO DATE ,
                              FECHA_COBRO DATE ,
                              FECHA_FACTURA DATE ,
                              -- Dimensiones
                              TIPO_COBRO_DET_ID NUMBER(16,0) ,
                              COBRO_FACTURADO_ID NUMBER(16,0) ,
                              REMESA_FACTURA_ID NUMBER(16,0) ,
                              ESQUEMA_COBRO_ID NUMBER(16,0) NULL,
                              AGENCIA_COBRO_ID NUMBER(16,0) NULL,
                              SUBCARTERA_COBRO_ID NUMBER(16,0) NULL,
                              TIPO_PRODUCTO_COBRO_ID NUMBER(16,0) NULL,
                              GARANTIA_COBRO_ID NUMBER(16,0) NULL,
                              SEGMENTO_CARTERA_COBRO_ID NUMBER(16,0) NULL,
                              TD_IRREG_COBRO_ID NUMBER(16,0) NULL,
                              T_DEUDA_IRREGULAR_COBRO_ID NUMBER(16,0) NULL,
                              ENVIADO_AGENCIA_COBRO_ID NUMBER(16,0) NULL,
                              FACTURA_COBRO_ID NUMBER(16,0) NULL,
                              -- Metricas
                              NUM_COBROS INTEGER ,
                              IMPORTE_COBRO NUMBER(16,2) ,
                              POSICION_VENCIDA_COBRO NUMBER(16,2) ,
                              POSICION_NO_VENCIDA_COBRO NUMBER(16,2) ,
                              INT_REMUNERATORIOS_COBRO NUMBER(16,2) ,
                              INT_MORATORIOS_COBRO NUMBER(16,2) ,
                              COMISIONES_COBRO NUMBER(16,2) ,
                              GASTOS_COBRO NUMBER(16,2) ,       
                              DEUDA_IRREGULAR_COBRO NUMBER(14,2) ,
                              RIESGO_VIVO_COBRO NUMBER(14,2) ,
                              NUM_DIAS_VENCIDOS_COBRO INTEGER ,  
                              IMPORTE_FACTURA_TOTAL NUMBER(16,2) ,                       -- Importe factura total: IMPORTE_FACTURA_TARIFA + CORRECTOR_FACTURA
                              IMPORTE_FACTURA_TARIFA NUMBER(16,2) ,                      -- Importe factura tarifa: suma del desglose de la factura
                              CORRECTOR_FACTURA NUMBER(16,2) ,
                              POSICION_VENCIDA_FACTURA NUMBER(16,2) ,
                              POSICION_NO_VENCIDA_FACTURA NUMBER(16,2) ,
                              INT_REMUNERATORIOS_FACTURA NUMBER(16,2) ,
                              INT_MORATORIOS_FACTURA NUMBER(16,2) ,
                              COMISIONES_FACTURA NUMBER(16,2) ,
                              GASTOS_FACTURA NUMBER(16,2)
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_DET_COBRO_TRIMESTRE');

	    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_COBRO_TRIMESTRE_IX'', ''H_CNT_DET_COBRO_TRIMESTRE (TRIMESTRE_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;


      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CNT_DET_COBRO_TRIMESTRE');

   ------------------------------ H_CNT_DET_COBRO_ANIO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_DET_COBRO_ANIO'', 
              		      ''ANIO_ID DECIMAL(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              COBRO_ID NUMBER(16,0) NULL,
                              FECHA_CONTRATO DATE ,
                              FECHA_COBRO DATE ,
                              FECHA_FACTURA DATE ,
                              -- Dimensiones
                              TIPO_COBRO_DET_ID NUMBER(16,0) ,
                              COBRO_FACTURADO_ID NUMBER(16,0) ,
                              REMESA_FACTURA_ID NUMBER(16,0) ,
                              ESQUEMA_COBRO_ID NUMBER(16,0) NULL,
                              AGENCIA_COBRO_ID NUMBER(16,0) NULL,
                              SUBCARTERA_COBRO_ID NUMBER(16,0) NULL,
                              TIPO_PRODUCTO_COBRO_ID NUMBER(16,0) NULL,
                              GARANTIA_COBRO_ID NUMBER(16,0) NULL,
                              SEGMENTO_CARTERA_COBRO_ID NUMBER(16,0) NULL,
                              TD_IRREG_COBRO_ID NUMBER(16,0) NULL,
                              T_DEUDA_IRREGULAR_COBRO_ID NUMBER(16,0) NULL,
                              ENVIADO_AGENCIA_COBRO_ID NUMBER(16,0) NULL,
                              FACTURA_COBRO_ID NUMBER(16,0) NULL,
                              -- Metricas
                              NUM_COBROS INTEGER ,
                              IMPORTE_COBRO NUMBER(16,2) ,
                              POSICION_VENCIDA_COBRO NUMBER(16,2) ,
                              POSICION_NO_VENCIDA_COBRO NUMBER(16,2) ,
                              INT_REMUNERATORIOS_COBRO NUMBER(16,2) ,
                              INT_MORATORIOS_COBRO NUMBER(16,2) ,
                              COMISIONES_COBRO NUMBER(16,2) ,
                              GASTOS_COBRO NUMBER(16,2) ,       
                              DEUDA_IRREGULAR_COBRO NUMBER(14,2) ,
                              RIESGO_VIVO_COBRO NUMBER(14,2) ,
                              NUM_DIAS_VENCIDOS_COBRO INTEGER ,  
                              IMPORTE_FACTURA_TOTAL NUMBER(16,2) ,                       -- Importe factura total: IMPORTE_FACTURA_TARIFA + CORRECTOR_FACTURA
                              IMPORTE_FACTURA_TARIFA NUMBER(16,2) ,                      -- Importe factura tarifa: suma del desglose de la factura
                              CORRECTOR_FACTURA NUMBER(16,2) ,
                              POSICION_VENCIDA_FACTURA NUMBER(16,2) ,
                              POSICION_NO_VENCIDA_FACTURA NUMBER(16,2) ,
                              INT_REMUNERATORIOS_FACTURA NUMBER(16,2) ,
                              INT_MORATORIOS_FACTURA NUMBER(16,2) ,
                              COMISIONES_FACTURA NUMBER(16,2) ,
                              GASTOS_FACTURA NUMBER(16,2)
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_DET_COBRO_ANIO');

	    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_COBRO_ANIO_IX'', ''H_CNT_DET_COBRO_ANIO (ANIO_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CNT_DET_COBRO_ANIO');

      
   ------------------------------ H_CNT_DET_CICLO_REC --------------------------
V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_DET_CICLO_REC'', 
              		      ''DIA_ID DATE NOT NULL,
                              FECHA_ALTA_CICLO_REC DATE ,
                              FECHA_BAJA_CICLO_REC DATE ,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              -- Dimensiones
                              MOTIVO_BAJA_CR_ID NUMBER(16,0),
                              ESQUEMA_CR_ID NUMBER(16,0) NULL,
                              SUBCARTERA_CR_ID NUMBER(16,0) NULL,
                              AGENCIA_CR_ID NUMBER(16,0) NULL,
                              SEGMENTO_CARTERA_CR_ID NUMBER(16,0) NULL,
                              ENVIADO_AGENCIA_CR_ID NUMBER(16,0) NULL,
                              -- Metricas
                              NUM_CONTRATO_CICLO_REC INTEGER ,
                              POSICION_VENCIDA_CICLO_REC NUMBER(16,2) ,
                              POSICION_NO_VENCIDA_CICLO_REC NUMBER(16,2) ,
                              INT_ORDINARIOS_CICLO_REC NUMBER(16,2) ,
                              INT_MORATORIOS_CICLO_REC NUMBER(16,2) ,
                              COMISIONES_CICLO_REC NUMBER(16,2) ,
                              GASTOS_CICLO_REC NUMBER(16,2) ,
                              IMPUESTOS_CICLO_REC NUMBER(16,2),
                              DEUDA_IRREGULAR_CICLO_REC NUMBER(14,2))  
                              SEGMENT CREATION IMMEDIATE 
			      TABLESPACE "RECOVERY_PRODUC_DWH" 
                              PARTITION BY RANGE ("DIA_ID")
                              INTERVAL(NUMTOYMINTERVAL(1, ''''MONTH''''))
                              (PARTITION "p1" VALUES LESS THAN (TO_DATE('''' 2014-11-01 00:00:00'''', ''''SYYYY-MM-DD HH24:MI:SS'''', ''''NLS_CALENDAR=GREGORIAN''''))'', :error); END;';
	 execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_DET_CICLO_REC');

	    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_CICLO_REC_IX'', ''H_CNT_DET_CICLO_REC (DIA_ID, FECHA_ALTA_CICLO_REC, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;


      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CNT_DET_CICLO_REC');


    ------------------------------ TMP_CNT_DET_CICLO_REC --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_CNT_DET_CICLO_REC'', 
              		    ''DIA_ID DATE NOT NULL,
                              FECHA_ALTA_CICLO_REC DATE ,
                              FECHA_BAJA_CICLO_REC DATE ,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              -- Dimensiones
                              MOTIVO_BAJA_CR_ID NUMBER(16,0),
                              ESQUEMA_CR_ID NUMBER(16,0) NULL,
                              SUBCARTERA_CR_ID NUMBER(16,0) NULL,
                              AGENCIA_CR_ID NUMBER(16,0) NULL,
                              SEGMENTO_CARTERA_CR_ID NUMBER(16,0) NULL,
                              ENVIADO_AGENCIA_CR_ID NUMBER(16,0) NULL,
                              -- Metricas
                              NUM_CONTRATO_CICLO_REC INTEGER ,
                              POSICION_VENCIDA_CICLO_REC NUMBER(16,2) ,
                              POSICION_NO_VENCIDA_CICLO_REC NUMBER(16,2) ,
                              INT_ORDINARIOS_CICLO_REC NUMBER(16,2) ,
                              INT_MORATORIOS_CICLO_REC NUMBER(16,2) ,
                              COMISIONES_CICLO_REC NUMBER(16,2) ,
                              GASTOS_CICLO_REC NUMBER(16,2) ,
                              IMPUESTOS_CICLO_REC NUMBER(16,2),
                              DEUDA_IRREGULAR_CICLO_REC NUMBER(14,2)
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_CNT_DET_CICLO_REC');

	    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CNT_DET_CICLO_REC_IX'', ''TMP_CNT_DET_CICLO_REC (DIA_ID, FECHA_ALTA_CICLO_REC, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;


      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_CNT_DET_CICLO_REC');


    ------------------------------ H_CNT_DET_CICLO_REC_SEMANA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_DET_CICLO_REC_SEMANA'', 
              		    ''SEMANA_ID NUMBER(16,0) NOT NULL,
                              FECHA_ALTA_CICLO_REC DATE ,
                              FECHA_BAJA_CICLO_REC DATE ,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              -- Dimensiones
                              MOTIVO_BAJA_CR_ID NUMBER(16,0),
                              ESQUEMA_CR_ID NUMBER(16,0) NULL,
                              SUBCARTERA_CR_ID NUMBER(16,0) NULL,
                              AGENCIA_CR_ID NUMBER(16,0) NULL,
                              SEGMENTO_CARTERA_CR_ID NUMBER(16,0) NULL,
                              ENVIADO_AGENCIA_CR_ID NUMBER(16,0) NULL,
                              -- Metricas
                              NUM_CONTRATO_CICLO_REC INTEGER ,
                              POSICION_VENCIDA_CICLO_REC NUMBER(16,2) ,
                              POSICION_NO_VENCIDA_CICLO_REC NUMBER(16,2) ,
                              INT_ORDINARIOS_CICLO_REC NUMBER(16,2) ,
                              INT_MORATORIOS_CICLO_REC NUMBER(16,2) ,
                              COMISIONES_CICLO_REC NUMBER(16,2) ,
                              GASTOS_CICLO_REC NUMBER(16,2) ,
                              IMPUESTOS_CICLO_REC NUMBER(16,2),
                              DEUDA_IRREGULAR_CICLO_REC NUMBER(14,2)
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_DET_CICLO_REC_SEMANA');

	    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_CICLO_REC_SEMANA_IX'', ''H_CNT_DET_CICLO_REC_SEMANA (SEMANA_ID, FECHA_ALTA_CICLO_REC, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;


      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CNT_DET_CICLO_REC_SEMANA');

      
   ------------------------------ H_CNT_DET_CICLO_REC_MES --------------------------
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_DET_CICLO_REC_MES'', 
              		    ''MES_ID NUMBER(16,0) NOT NULL,
                              FECHA_ALTA_CICLO_REC DATE ,
                              FECHA_BAJA_CICLO_REC DATE ,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              -- Dimensiones
                              MOTIVO_BAJA_CR_ID NUMBER(16,0),
                              ESQUEMA_CR_ID NUMBER(16,0) NULL,
                              SUBCARTERA_CR_ID NUMBER(16,0) NULL,
                              AGENCIA_CR_ID NUMBER(16,0) NULL,
                              SEGMENTO_CARTERA_CR_ID NUMBER(16,0) NULL,
                              ENVIADO_AGENCIA_CR_ID NUMBER(16,0) NULL,
                              -- Metricas
                              NUM_CONTRATO_CICLO_REC INTEGER ,
                              POSICION_VENCIDA_CICLO_REC NUMBER(16,2) ,
                              POSICION_NO_VENCIDA_CICLO_REC NUMBER(16,2) ,
                              INT_ORDINARIOS_CICLO_REC NUMBER(16,2) ,
                              INT_MORATORIOS_CICLO_REC NUMBER(16,2) ,
                              COMISIONES_CICLO_REC NUMBER(16,2) ,
                              GASTOS_CICLO_REC NUMBER(16,2) ,
                              IMPUESTOS_CICLO_REC NUMBER(16,2),
                              DEUDA_IRREGULAR_CICLO_REC NUMBER(14,2)
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_DET_CICLO_REC_MES');

    	    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_CICLO_REC_MES_IX'', ''H_CNT_DET_CICLO_REC_MES (MES_ID, FECHA_ALTA_CICLO_REC, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CNT_DET_CICLO_REC_MES');
     
      
   ------------------------------ H_CNT_DET_CICLO_REC_TRIMESTRE --------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_DET_CICLO_REC_TRIMESTRE'', 
              		    ''TRIMESTRE_ID NUMBER(16,0) NOT NULL,
                              FECHA_ALTA_CICLO_REC DATE ,
                              FECHA_BAJA_CICLO_REC DATE ,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              -- Dimensiones
                              MOTIVO_BAJA_CR_ID NUMBER(16,0),
                              ESQUEMA_CR_ID NUMBER(16,0) NULL,
                              SUBCARTERA_CR_ID NUMBER(16,0) NULL,
                              AGENCIA_CR_ID NUMBER(16,0) NULL,
                              SEGMENTO_CARTERA_CR_ID NUMBER(16,0) NULL,
                              ENVIADO_AGENCIA_CR_ID NUMBER(16,0) NULL,
                              -- Metricas
                              NUM_CONTRATO_CICLO_REC INTEGER ,
                              POSICION_VENCIDA_CICLO_REC NUMBER(16,2) ,
                              POSICION_NO_VENCIDA_CICLO_REC NUMBER(16,2) ,
                              INT_ORDINARIOS_CICLO_REC NUMBER(16,2) ,
                              INT_MORATORIOS_CICLO_REC NUMBER(16,2) ,
                              COMISIONES_CICLO_REC NUMBER(16,2) ,
                              GASTOS_CICLO_REC NUMBER(16,2) ,
                              IMPUESTOS_CICLO_REC NUMBER(16,2),
                              DEUDA_IRREGULAR_CICLO_REC NUMBER(14,2)
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_DET_CICLO_REC_TRIMESTRE');

    	    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_CICLO_REC_TRIMESTRE_IX'', ''H_CNT_DET_CICLO_REC_TRIMESTRE (TRIMESTRE_ID, FECHA_ALTA_CICLO_REC, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;


      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CNT_DET_CICLO_REC_TRIMESTRE');

      
   ------------------------------ H_CNT_DET_CICLO_REC_ANIO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_DET_CICLO_REC_ANIO'', 
              		    ''ANIO_ID NUMBER(16,0) NOT NULL,
                              FECHA_ALTA_CICLO_REC DATE ,
                              FECHA_BAJA_CICLO_REC DATE ,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              -- Dimensiones
                              MOTIVO_BAJA_CR_ID NUMBER(16,0),
                              ESQUEMA_CR_ID NUMBER(16,0) NULL,
                              SUBCARTERA_CR_ID NUMBER(16,0) NULL,
                              AGENCIA_CR_ID NUMBER(16,0) NULL,
                              SEGMENTO_CARTERA_CR_ID NUMBER(16,0) NULL,
                              ENVIADO_AGENCIA_CR_ID NUMBER(16,0) NULL,
                              -- Metricas
                              NUM_CONTRATO_CICLO_REC INTEGER ,
                              POSICION_VENCIDA_CICLO_REC NUMBER(16,2) ,
                              POSICION_NO_VENCIDA_CICLO_REC NUMBER(16,2) ,
                              INT_ORDINARIOS_CICLO_REC NUMBER(16,2) ,
                              INT_MORATORIOS_CICLO_REC NUMBER(16,2) ,
                              COMISIONES_CICLO_REC NUMBER(16,2) ,
                              GASTOS_CICLO_REC NUMBER(16,2) ,
                              IMPUESTOS_CICLO_REC NUMBER(16,2),
                              DEUDA_IRREGULAR_CICLO_REC NUMBER(14,2)
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_DET_CICLO_REC_ANIO');

    	    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_CICLO_REC_ANIO_IX'', ''H_CNT_DET_CICLO_REC_ANIO (ANIO_ID, FECHA_ALTA_CICLO_REC, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;


      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CNT_DET_CICLO_REC_ANIO');


    ------------------------------ H_CNT_INICIO_CAMPANA_RECOBRO --------------------------
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_INICIO_CAMPANA_RECOBRO'', 
              		    ''FECHA_INICIO_CAMPANA_RECOBRO DATE NOT NULL,       -- Fecha ?ltimo d?a cargado
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              -- Dimensiones
                              EST_FIN_INI_CAMP_REC_ID NUMBER(16,0)  ,
                              EST_FIN_ANT_INI_CAMP_REC_ID NUMBER(16,0)  ,
                              -- Recobro
                              EN_GEST_REC_INI_CAMP_REC_ID NUMBER(16,0)  ,
                              T_IRREG_D_INI_CAMP_REC_ID NUMBER(16,0)  ,
                              T_IRREG_F_INI_CAMP_REC_ID NUMBER(16,0)  ,
                              MODELO_REC_INI_CAMP_REC_ID NUMBER(16,0)  ,
                              PROV_REC_INI_CAMP_REC_ID NUMBER(16,0)  ,
                              EN_IRREG_INI_CAMP_REC_ID NUMBER(16,0)  ,
                              -- M?tricas
                              NUM_CNT_INI_CAMP_REC INTEGER ,
                              NUM_DIAS_VENC_INI_CAMP_REC INTEGER ,
                              SALDO_TOTAL_INI_CAMP_REC NUMBER(14,2)  ,
                              POS_VIVA_NO_VENC_INI_CAMP_REC NUMBER(14,2)  ,
                              POS_VIVA_VENC_INI_CAMP_REC NUMBER(14,2)  ,
                              SALDO_DUDOSO_INI_CAMP_REC NUMBER(14,2)  ,
                              PROVISION_INI_CAMP_REC NUMBER(14,2)  ,
                              INT_REMUNERA_INI_CAMP_REC NUMBER(14,2)  ,
                              INT_MORA_INI_CAMP_REC NUMBER(14,2)  ,
                              COMISIONES_INI_CAMP_REC NUMBER(14,2)  ,
                              GASTOS_INI_CAMP_REC NUMBER(14,2)  ,
                              RIESGO_INI_CAMP_REC NUMBER(14,2)  ,
                              DEUDA_IRREGULAR_INI_CAMP_REC NUMBER(14,2)  ,
                              DISPUESTO_INI_CAMP_REC NUMBER(14,2)  ,
                              SALDO_PASIVO_INI_CAMP_REC NUMBER(14,2)  ,
                              RIESGO_GARANTIA_INI_CAMP_REC NUMBER(14,2)  ,
                              SALDO_EXCE_INI_CAMP_REC NUMBER(14,2)  ,
                              -- Recobro
                              IMPORTE_RECLAMAR_INI_CAMP_REC NUMBER(14,2)
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

        DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_INCIO_CAMPANA_RECOBRO');

    	    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_INI_CAMP_REC_IX'', ''H_CNT_INICIO_CAMPANA_RECOBRO (FECHA_INICIO_CAMPANA_RECOBRO, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

    	    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_INI_CAMP_REC_CNT_IX'', ''H_CNT_INICIO_CAMPANA_RECOBRO (CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;


        DBMS_OUTPUT.PUT_LINE('---- Creacion INDICES en H_CNT_INICIO_CAMPANA_RECOBRO');



   ------------------------------ H_CNT_DET_ACUERDO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_DET_ACUERDO'', 
              		    ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              ACUERDO_ID NUMBER(16,0) NOT NULL,
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              FECHA_PROPUESTA DATE ,
                              -- Dimensiones
                              TIPO_ACUERDO_ID NUMBER(16,0),
                              SOLICITANTE_ACUERDO_ID NUMBER(16,0) NULL,
                              ESTADO_ACUERDO_ID NUMBER(16,0) NULL,
                              ESQUEMA_ACUERDO_ID NUMBER(16,0) NULL,
                              SUBCARTERA_ACUERDO_ID NUMBER(16,0) NULL,
                              AGENCIA_ACUERDO_ID NUMBER(16,0) NULL,
                              ENVIADO_AGENCIA_ACUERDO_ID NUMBER(16,0) NULL,
                              -- Metricas
                              NUM_ACUERDOS INTEGER ,
                              IMPORTE_PAGO NUMBER(16,2) 
                             )
                           SEGMENT CREATION IMMEDIATE 
					TABLESPACE "RECOVERY_PRODUC_DWH" 
                    PARTITION BY RANGE ("DIA_ID")
                    INTERVAL(NUMTOYMINTERVAL(1, ''''MONTH''''))
                    (PARTITION "p1" VALUES LESS THAN (TO_DATE('''' 2014-11-01 00:00:00'''', ''''SYYYY-MM-DD HH24:MI:SS'''', ''''NLS_CALENDAR=GREGORIAN''''))'', :error); END;';
	 execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_DET_ACUERDO');


    	    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_ACUERDO_IX'', ''H_CNT_DET_ACUERDO (DIA_ID, FECHA_PROPUESTA, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CNT_DET_ACUERDO');


   ------------------------------ TMP_CNT_DET_ACUERDO --------------------------
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_CNT_DET_ACUERDO'', 
              		    ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              ACUERDO_ID NUMBER(16,0) NOT NULL,
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              FECHA_PROPUESTA DATE ,
                              -- Dimensiones
                              TIPO_ACUERDO_ID NUMBER(16,0),
                              SOLICITANTE_ACUERDO_ID NUMBER(16,0) NULL,
                              ESTADO_ACUERDO_ID NUMBER(16,0) NULL,
                              ESQUEMA_ACUERDO_ID NUMBER(16,0) NULL,
                              SUBCARTERA_ACUERDO_ID NUMBER(16,0) NULL,
                              AGENCIA_ACUERDO_ID NUMBER(16,0) NULL,
                              ENVIADO_AGENCIA_ACUERDO_ID NUMBER(16,0) NULL,
                              -- Metricas
                              NUM_ACUERDOS INTEGER ,
                              IMPORTE_PAGO NUMBER(16,2)
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_CNT_DET_ACUERDO');

    	    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CNT_DET_ACUERDO_IX'', ''TMP_CNT_DET_ACUERDO (DIA_ID, FECHA_PROPUESTA, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;


      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_CNT_DET_ACUERDO');
  

   ------------------------------ H_CNT_DET_ACUERDO_SEMANA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_DET_ACUERDO_SEMANA'', 
              		    ''SEMANA_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              ACUERDO_ID NUMBER(16,0) NOT NULL,
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              FECHA_PROPUESTA DATE ,
                              -- Dimensiones
                              TIPO_ACUERDO_ID NUMBER(16,0),
                              SOLICITANTE_ACUERDO_ID NUMBER(16,0) NULL,
                              ESTADO_ACUERDO_ID NUMBER(16,0) NULL,
                              ESQUEMA_ACUERDO_ID NUMBER(16,0) NULL,
                              SUBCARTERA_ACUERDO_ID NUMBER(16,0) NULL,
                              AGENCIA_ACUERDO_ID NUMBER(16,0) NULL,
                              ENVIADO_AGENCIA_ACUERDO_ID NUMBER(16,0) NULL,
                              -- Metricas
                              NUM_ACUERDOS INTEGER ,
                              IMPORTE_PAGO NUMBER(16,2)
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_DET_ACUERDO_SEMANA');

V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_ACUERDO_SEMANA_IX'', '' H_CNT_DET_ACUERDO_SEMANA (SEMANA_ID, FECHA_PROPUESTA, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

      
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CNT_DET_ACUERDO_SEMANA');
    
   ------------------------------ H_CNT_DET_ACUERDO_MES --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_DET_ACUERDO_MES'', 
              		    ''MES_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              ACUERDO_ID NUMBER(16,0) NOT NULL,
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              FECHA_PROPUESTA DATE ,
                              -- Dimensiones
                              TIPO_ACUERDO_ID NUMBER(16,0),
                              SOLICITANTE_ACUERDO_ID NUMBER(16,0) NULL,
                              ESTADO_ACUERDO_ID NUMBER(16,0) NULL,
                              ESQUEMA_ACUERDO_ID NUMBER(16,0) NULL,
                              SUBCARTERA_ACUERDO_ID NUMBER(16,0) NULL,
                              AGENCIA_ACUERDO_ID NUMBER(16,0) NULL,
                              ENVIADO_AGENCIA_ACUERDO_ID NUMBER(16,0) NULL,
                              -- Metricas
                              NUM_ACUERDOS INTEGER ,
                              IMPORTE_PAGO NUMBER(16,2) 
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_DET_ACUERDO_MES');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_ACUERDO_MES_IX'', '' H_CNT_DET_ACUERDO_MES (MES_ID, FECHA_PROPUESTA, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CNT_DET_ACUERDO_MES');


   ------------------------------ H_CNT_DET_ACUERDO_TRIMESTRE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_DET_ACUERDO_TRIMESTRE'', 
              		    ''TRIMESTRE_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              ACUERDO_ID NUMBER(16,0) NOT NULL,
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              FECHA_PROPUESTA DATE ,
                              -- Dimensiones
                              TIPO_ACUERDO_ID NUMBER(16,0),
                              SOLICITANTE_ACUERDO_ID NUMBER(16,0) NULL,
                              ESTADO_ACUERDO_ID NUMBER(16,0) NULL,
                              ESQUEMA_ACUERDO_ID NUMBER(16,0) NULL,
                              SUBCARTERA_ACUERDO_ID NUMBER(16,0) NULL,
                              AGENCIA_ACUERDO_ID NUMBER(16,0) NULL,
                              ENVIADO_AGENCIA_ACUERDO_ID NUMBER(16,0) NULL,
                              -- Metricas
                              NUM_ACUERDOS INTEGER ,
                              IMPORTE_PAGO NUMBER(16,2) 
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_DET_ACUERDO_TRIMESTRE');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_ACUERDO_TRIMESTRE_IX'', '' H_CNT_DET_ACUERDO_TRIMESTRE (TRIMESTRE_ID, FECHA_PROPUESTA, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CNT_DET_ACUERDO_TRIMESTRE');
  

   ------------------------------ H_CNT_DET_ACUERDO_ANIO --------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_DET_ACUERDO_ANIO'', 
              		    ''ANIO_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              ACUERDO_ID NUMBER(16,0) NOT NULL,
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              FECHA_PROPUESTA DATE ,
                              -- Dimensiones
                              TIPO_ACUERDO_ID NUMBER(16,0),
                              SOLICITANTE_ACUERDO_ID NUMBER(16,0) NULL,
                              ESTADO_ACUERDO_ID NUMBER(16,0) NULL,
                              ESQUEMA_ACUERDO_ID NUMBER(16,0) NULL,
                              SUBCARTERA_ACUERDO_ID NUMBER(16,0) NULL,
                              AGENCIA_ACUERDO_ID NUMBER(16,0) NULL,
                              ENVIADO_AGENCIA_ACUERDO_ID NUMBER(16,0) NULL,
                              -- Metricas
                              NUM_ACUERDOS INTEGER ,
                              IMPORTE_PAGO NUMBER(16,2) 
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_DET_ACUERDO_ANIO');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_ACUERDO_ANIO_IX'', '' H_CNT_DET_ACUERDO_ANIO (ANIO_ID, FECHA_PROPUESTA, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CNT_DET_ACUERDO_ANIO');
     

   ------------------------------ H_CNT_DET_INCI --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_DET_INCI'', 
              		    ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              INCIDENCIA_ID NUMBER(16,0) NOT NULL,
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              FECHA_INCIDENCIA DATE ,
                              -- Dimensiones
                              TIPO_INCIDENCIA_ID NUMBER(16,0),
                              SITUACION_INCIDENCIA_ID NUMBER(16,0) NULL,
                              ESQUEMA_INCIDENCIA_ID NUMBER(16,0) NULL,
                              SUBCARTERA_INCIDENCIA_ID NUMBER(16,0) NULL,
                              AGENCIA_INCIDENCIA_ID NUMBER(16,0) NULL,
                              ENVIADO_AGENCIA_INCI_ID NUMBER(16,0) NULL,
                              -- Metricas
                              NUM_INCIDENCIAS INTEGER
                             )
                           SEGMENT CREATION IMMEDIATE 
					TABLESPACE "RECOVERY_PRODUC_DWH" 
                    PARTITION BY RANGE ("DIA_ID")
                    INTERVAL(NUMTOYMINTERVAL(1, ''''MONTH''''))
                    (PARTITION "p1" VALUES LESS THAN (TO_DATE('''' 2014-11-01 00:00:00'''', ''''SYYYY-MM-DD HH24:MI:SS'''', ''''NLS_CALENDAR=GREGORIAN''''))'', :error); END;';
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_DET_INCI');

V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_INCI_IX'', '' H_CNT_DET_INCI (DIA_ID, FECHA_INCIDENCIA, CONTRATO_ID)'', ''S'', '''', :error); END;';

  execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CNT_DET_INCI');
    

   ------------------------------ TMP_CNT_DET_INCI --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_CNT_DET_INCI'', 
              		    ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              INCIDENCIA_ID NUMBER(16,0) NOT NULL,
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              FECHA_INCIDENCIA DATE ,
                              -- Dimensiones
                              TIPO_INCIDENCIA_ID NUMBER(16,0),
                              SITUACION_INCIDENCIA_ID NUMBER(16,0) NULL,
                              ESQUEMA_INCIDENCIA_ID NUMBER(16,0) NULL,
                              SUBCARTERA_INCIDENCIA_ID NUMBER(16,0) NULL,
                              AGENCIA_INCIDENCIA_ID NUMBER(16,0) NULL,
                              ENVIADO_AGENCIA_INCI_ID NUMBER(16,0) NULL,
                              -- Metricas
                              NUM_INCIDENCIAS INTEGER 
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_CNT_DET_INCI');


     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CNT_DET_INCI_IX'', '' TMP_CNT_DET_INCI (DIA_ID, FECHA_INCIDENCIA, CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_CNT_DET_INCI');

   ------------------------------ H_CNT_DET_INCI_SEMANA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_DET_INCI_SEMANA'', 
              		    ''SEMANA_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              INCIDENCIA_ID NUMBER(16,0) NOT NULL,
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              FECHA_INCIDENCIA DATE ,
                              -- Dimensiones
                              TIPO_INCIDENCIA_ID NUMBER(16,0),
                              SITUACION_INCIDENCIA_ID NUMBER(16,0) NULL,
                              ESQUEMA_INCIDENCIA_ID NUMBER(16,0) NULL,
                              SUBCARTERA_INCIDENCIA_ID NUMBER(16,0) NULL,
                              AGENCIA_INCIDENCIA_ID NUMBER(16,0) NULL,
                              ENVIADO_AGENCIA_INCI_ID NUMBER(16,0) NULL,
                              -- Metricas
                              NUM_INCIDENCIAS INTEGER 
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_DET_INCI_SEMANA');

V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_INCI_SEMANA_IX'', '' H_CNT_DET_INCI_SEMANA (SEMANA_ID, FECHA_INCIDENCIA, CONTRATO_ID)'', ''S'', '''', :error);
 END;';
  execute immediate V_SQL USING OUT error;

   
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CNT_DET_INCI_SEMANA');
  
   ------------------------------ H_CNT_DET_INCI_MES --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_DET_INCI_MES'', 
              		    ''MES_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              INCIDENCIA_ID NUMBER(16,0) NOT NULL,
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              FECHA_INCIDENCIA DATE ,
                              -- Dimensiones
                              TIPO_INCIDENCIA_ID NUMBER(16,0),
                              SITUACION_INCIDENCIA_ID NUMBER(16,0) NULL,
                              ESQUEMA_INCIDENCIA_ID NUMBER(16,0) NULL,
                              SUBCARTERA_INCIDENCIA_ID NUMBER(16,0) NULL,
                              AGENCIA_INCIDENCIA_ID NUMBER(16,0) NULL,
                              ENVIADO_AGENCIA_INCI_ID NUMBER(16,0) NULL,
                              -- Metricas
                              NUM_INCIDENCIAS INTEGER 
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_DET_INCI_MES');

 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_INCI_MES_IX'', '' H_CNT_DET_INCI_MES (MES_ID, FECHA_INCIDENCIA, CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CNT_DET_INCI_MES');


   ------------------------------ H_CNT_DET_INCI_TRIMESTRE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_DET_INCI_TRIMESTRE'', 
              		    ''TRIMESTRE_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              INCIDENCIA_ID NUMBER(16,0) NOT NULL,
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              FECHA_INCIDENCIA DATE ,
                              -- Dimensiones
                              TIPO_INCIDENCIA_ID NUMBER(16,0),
                              SITUACION_INCIDENCIA_ID NUMBER(16,0) NULL,
                              ESQUEMA_INCIDENCIA_ID NUMBER(16,0) NULL,
                              SUBCARTERA_INCIDENCIA_ID NUMBER(16,0) NULL,
                              AGENCIA_INCIDENCIA_ID NUMBER(16,0) NULL,
                              ENVIADO_AGENCIA_INCI_ID NUMBER(16,0) NULL,
                              -- Metricas
                              NUM_INCIDENCIAS INTEGER 
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_DET_INCI_TRIMESTRE');

   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_INCI_TRIMESTRE_IX'', '' H_CNT_DET_INCI_TRIMESTRE (TRIMESTRE_ID, FECHA_INCIDENCIA, CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CNT_DET_INCI_TRIMESTRE');
      

   ------------------------------ H_CNT_DET_INCI_ANIO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_DET_INCI_ANIO'', 
              		    ''ANIO_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              INCIDENCIA_ID NUMBER(16,0) NOT NULL,
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              FECHA_INCIDENCIA DATE ,
                              -- Dimensiones
                              TIPO_INCIDENCIA_ID NUMBER(16,0),
                              SITUACION_INCIDENCIA_ID NUMBER(16,0) NULL,
                              ESQUEMA_INCIDENCIA_ID NUMBER(16,0) NULL,
                              SUBCARTERA_INCIDENCIA_ID NUMBER(16,0) NULL,
                              AGENCIA_INCIDENCIA_ID NUMBER(16,0) NULL,
                              ENVIADO_AGENCIA_INCI_ID NUMBER(16,0) NULL,
                              -- Metricas
                              NUM_INCIDENCIAS INTEGER 
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_DET_INCI_ANIO');

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_INCI_ANIO_IX'', '' H_CNT_DET_INCI_ANIO (ANIO_ID, FECHA_INCIDENCIA, CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CNT_DET_INCI_ANIO');

      
    ------------------------------ H_CNT_DET_EFICACIA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_DET_EFICACIA'', 
              		    ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              -- Dimensiones
                              ESQUEMA_ER_ID NUMBER(16,0),
                              AGENCIA_ER_ID NUMBER(16,0),
                              SUBCARTERA_ER_ID NUMBER(16,0),
                              -- Metricas
                              ER_IMPORTE_COBRO NUMBER(14,2),
                              ER_DEUDA_IRREGULAR_STOCK_INI NUMBER(14,2),
                              ER_DEUDA_IRREGULAR_ENTRADAS NUMBER(14,2)
                             )
                           SEGMENT CREATION IMMEDIATE 
					TABLESPACE "RECOVERY_PRODUC_DWH" 
                    PARTITION BY RANGE ("DIA_ID")
                    INTERVAL(NUMTOYMINTERVAL(1, ''''MONTH''''))
                    (PARTITION "p1" VALUES LESS THAN (TO_DATE('''' 2014-11-01 00:00:00'''', ''''SYYYY-MM-DD HH24:MI:SS'''', ''''NLS_CALENDAR=GREGORIAN''''))'', :error); END;';
	execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_DET_EFICACIA');

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_EFICACIA_IX'', ''  H_CNT_DET_EFICACIA (DIA_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

           DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CNT_DET_EFICACIA');


    ------------------------------ TMP_H_CNT_DET_EFICACIA --------------------------
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_H_CNT_DET_EFICACIA'', 
              		    ''DIA_ID DATE NULL,  
                              SEMANA_ID NUMBER(16,0) NULL,
                              MES_ID NUMBER(16,0) NULL,
                              TRIMESTERE_ID NUMBER(16,0) NULL,
                              ANIO_ID NUMBER(16,0) NULL,
                              FECHA_CARGA_DATOS DATE NULL,
                              CONTRATO_ID NUMBER(16,0) NULL,
                              -- Dimensiones
                              ESQUEMA_ER_ID NUMBER(16,0),
                              AGENCIA_ER_ID NUMBER(16,0),
                              SUBCARTERA_ER_ID NUMBER(16,0),
                              -- Metricas
                              ER_IMPORTE_COBRO NUMBER(14,2),
                              ER_DEUDA_IRREGULAR_STOCK_INI NUMBER(14,2),
                              ER_DEUDA_IRREGULAR_ENTRADAS NUMBER(14,2) 
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_H_CNT_DET_EFICACIA');
      
      
    ------------------------------ H_CNT_DET_EFICACIA_SEMANA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_DET_EFICACIA_SEMANA'', 
              		    ''SEMANA_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              -- Dimensiones
                              ESQUEMA_ER_ID NUMBER(16,0),
                              AGENCIA_ER_ID NUMBER(16,0),
                              SUBCARTERA_ER_ID NUMBER(16,0),
                              -- Metricas
                              ER_IMPORTE_COBRO NUMBER(14,2),
                              ER_DEUDA_IRREGULAR_STOCK_INI NUMBER(14,2),
                              ER_DEUDA_IRREGULAR_ENTRADAS NUMBER(14,2) 
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_DET_EFICACIA_SEMANA');


  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_EFICACIA_SEMANA_IX'', ''  H_CNT_DET_EFICACIA_SEMANA (SEMANA_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
    
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CNT_DET_EFICACIA_SEMANA');
      
      
    ------------------------------ H_CNT_DET_EFICACIA_MES --------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_DET_EFICACIA_MES'', 
              		    ''MES_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              -- Dimensiones
                              ESQUEMA_ER_ID NUMBER(16,0),
                              AGENCIA_ER_ID NUMBER(16,0),
                              SUBCARTERA_ER_ID NUMBER(16,0),
                              -- Metricas
                              ER_IMPORTE_COBRO NUMBER(14,2),
                              ER_DEUDA_IRREGULAR_STOCK_INI NUMBER(14,2),
                              ER_DEUDA_IRREGULAR_ENTRADAS NUMBER(14,2) 
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_DET_EFICACIA_MES');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_EFICACIA_MES_IX'', ''  H_CNT_DET_EFICACIA_MES (MES_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CNT_DET_EFICACIA_MES');
      
      
    ------------------------------ H_CNT_DET_EFICACIA_TRIMESTRE --------------------------
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_DET_EFICACIA_TRIMESTRE'', 
              		    ''TRIMESTRE_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              -- Dimensiones
                              ESQUEMA_ER_ID NUMBER(16,0),
                              AGENCIA_ER_ID NUMBER(16,0),
                              SUBCARTERA_ER_ID NUMBER(16,0),
                              -- Metricas
                              ER_IMPORTE_COBRO NUMBER(14,2),
                              ER_DEUDA_IRREGULAR_STOCK_INI NUMBER(14,2),
                              ER_DEUDA_IRREGULAR_ENTRADAS NUMBER(14,2) 
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_DET_EFICACIA_TRIMESTRE');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_EFICACIA_TRIMESTRE_IX'', ''  H_CNT_DET_EFICACIA_TRIMESTRE (TRIMESTRE_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CNT_DET_EFICACIA_TRIMESTRE');
      

    ------------------------------ H_CNT_DET_EFICACIA_ANIO --------------------------
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_DET_EFICACIA_ANIO'', 
              		    ''ANIO_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              -- Dimensiones
                              ESQUEMA_ER_ID NUMBER(16,0),
                              AGENCIA_ER_ID NUMBER(16,0),
                              SUBCARTERA_ER_ID NUMBER(16,0),
                              -- Metricas
                              ER_IMPORTE_COBRO NUMBER(14,2),
                              ER_DEUDA_IRREGULAR_STOCK_INI NUMBER(14,2),
                              ER_DEUDA_IRREGULAR_ENTRADAS NUMBER(14,2) 
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_DET_EFICACIA_ANIO');

          V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_EFICACIA_ANIO_IX'', ''  H_CNT_DET_EFICACIA_ANIO (ANIO_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CNT_DET_EFICACIA_ANIO');
      
      
    --------------------------- H_CNT_DET_CREDITO ------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_DET_CREDITO'', 
              		    ''DIA_ID DATE NOT NULL,    
                                  FECHA_CARGA_DATOS DATE NOT NULL, 
                                  CREDITO_INSINUADO_ID NUMBER(16,0) NULL,
                                  CONTRATO_ID NUMBER(16,0) NULL, 
                                  FECHA_CREDITO_INSINUADO DATE NULL, 
                                  GESTOR_CREDITO_ID NUMBER(16,0) NULL ,
                                  ESTADO_INSI_CREDITO_ID NUMBER(16,0) NULL ,
                                  CALIFICACION_INICIAL_ID NUMBER(16,0) NULL ,
                                  CALIFICACION_GESTOR_ID NUMBER(16,0) NULL ,
                                  CALIFICACION_FINAL_ID NUMBER(16,0) NULL ,
                                  NUM_CREDITO_INSINUADO NUMBER NULL,
                                  PRINCIPAL_INICIAL NUMBER(16,2) NULL,
                                  PRINCIPAL_GESTOR NUMBER(16,2) NULL,
                                  PRINCIPAL_FINAL NUMBER(16,2) NULL
                                  )
                           SEGMENT CREATION IMMEDIATE 
					TABLESPACE "RECOVERY_PRODUC_DWH" 
                    PARTITION BY RANGE ("DIA_ID")
                    INTERVAL(NUMTOYMINTERVAL(1, ''''MONTH''''))
                    (PARTITION "p1" VALUES LESS THAN (TO_DATE('''' 2014-11-01 00:00:00'''', ''''SYYYY-MM-DD HH24:MI:SS'''', ''''NLS_CALENDAR=GREGORIAN''''))'', :error); END;';
	execute immediate V_SQL USING OUT error;

                                          
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_DET_CREDITO');

          V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_CREDITO_IX'', ''  H_CNT_DET_CREDITO (DIA_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
      

      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CNT_DET_CREDITO');
      
    
    --------------------------- TMP_H_CNT_DET_CREDITO ------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_H_CNT_DET_CREDITO'', 
              		    ''DIA_ID DATE NOT NULL,    
                                  FECHA_CARGA_DATOS DATE NOT NULL, 
                                  CREDITO_INSINUADO_ID NUMBER(16,0) NULL,
                                  CONTRATO_ID NUMBER(16,0) NULL, 
                                  PROCEDIMIENTO_ID NUMBER(16,0),
                                  CEX_ID NUMBER(16,0),
                                  FECHA_CREDITO_INSINUADO DATE NULL, 
                                  GESTOR_CREDITO_ID NUMBER(16,0) NULL ,
                                  ESTADO_INSI_CREDITO_ID NUMBER(16,0) NULL ,
                                  CALIFICACION_INICIAL_ID NUMBER(16,0) NULL ,
                                  CALIFICACION_GESTOR_ID NUMBER(16,0) NULL ,
                                  CALIFICACION_FINAL_ID NUMBER(16,0) NULL ,
                                  NUM_CREDITO_INSINUADO NUMBER NULL,
                                  PRINCIPAL_INICIAL NUMBER(16,2) NULL,
                                  PRINCIPAL_GESTOR NUMBER(16,2) NULL,
                                  PRINCIPAL_FINAL NUMBER(16,2) NULL 
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;
                                  
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_H_CNT_DET_CREDITO');

          V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_CNT_DET_CREDITO_IX'', ''  TMP_H_CNT_DET_CREDITO (DIA_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
      
     
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_H_CNT_DET_CREDITO');
      
    
    --------------------------- H_CNT_DET_CREDITO_SEMANA ------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_DET_CREDITO_SEMANA'', 
              		    ''SEMANA_ID NUMBER(16,0) NOT NULL,    
                                  FECHA_CARGA_DATOS DATE NOT NULL, 
                                  CREDITO_INSINUADO_ID NUMBER(16,0) NULL,
                                  CONTRATO_ID NUMBER(16,0) NULL, 
                                  FECHA_CREDITO_INSINUADO DATE NULL, 
                                  GESTOR_CREDITO_ID NUMBER(16,0) NULL ,
                                  ESTADO_INSI_CREDITO_ID NUMBER(16,0) NULL ,
                                  CALIFICACION_INICIAL_ID NUMBER(16,0) NULL ,
                                  CALIFICACION_GESTOR_ID NUMBER(16,0) NULL ,
                                  CALIFICACION_FINAL_ID NUMBER(16,0) NULL ,
                                  NUM_CREDITO_INSINUADO NUMBER NULL,
                                  PRINCIPAL_INICIAL NUMBER(16,2) NULL,
                                  PRINCIPAL_GESTOR NUMBER(16,2) NULL,
                                  PRINCIPAL_FINAL NUMBER(16,2) NULL 
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;
 
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_DET_CREDITO_SEMANA');
      
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_CNT_DET_CREDITO_SEMANA_IX'', ''  TMP_H_CNT_DET_CREDITO_SEMANA (SEMANA_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CNT_DET_CREDITO_SEMANA');
            
      
    --------------------------- H_CNT_DET_CREDITO_MES ------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_DET_CREDITO_MES'', 
              		    ''MES_ID NUMBER(16,0) NOT NULL,    
                                  FECHA_CARGA_DATOS DATE NOT NULL, 
                                  CREDITO_INSINUADO_ID NUMBER(16,0) NULL,
                                  CONTRATO_ID NUMBER(16,0) NULL, 
                                  FECHA_CREDITO_INSINUADO DATE NULL, 
                                  GESTOR_CREDITO_ID NUMBER(16,0) NULL ,
                                  ESTADO_INSI_CREDITO_ID NUMBER(16,0) NULL ,
                                  CALIFICACION_INICIAL_ID NUMBER(16,0) NULL ,
                                  CALIFICACION_GESTOR_ID NUMBER(16,0) NULL ,
                                  CALIFICACION_FINAL_ID NUMBER(16,0) NULL ,
                                  NUM_CREDITO_INSINUADO NUMBER NULL,
                                  PRINCIPAL_INICIAL NUMBER(16,2) NULL,
                                  PRINCIPAL_GESTOR NUMBER(16,2) NULL,
                                  PRINCIPAL_FINAL NUMBER(16,2) NULL 
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;
 
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_DET_CREDITO_MES');
      
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_CNT_DET_CREDITO_MES_IX'', ''  TMP_H_CNT_DET_CREDITO_MES (MES_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CNT_DET_CREDITO_MES');
      
      
            --------------------------- H_CNT_DET_CREDITO_TRIMESTRE ------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_DET_CREDITO_TRIMESTRE'', 
              		    ''TRIMESTRE_ID NUMBER(16,0) NOT NULL,    
                                  FECHA_CARGA_DATOS DATE NOT NULL, 
                                  CREDITO_INSINUADO_ID NUMBER(16,0) NULL,
                                  CONTRATO_ID NUMBER(16,0) NULL, 
                                  FECHA_CREDITO_INSINUADO DATE NULL, 
                                  GESTOR_CREDITO_ID NUMBER(16,0) NULL ,
                                  ESTADO_INSI_CREDITO_ID NUMBER(16,0) NULL ,
                                  CALIFICACION_INICIAL_ID NUMBER(16,0) NULL ,
                                  CALIFICACION_GESTOR_ID NUMBER(16,0) NULL ,
                                  CALIFICACION_FINAL_ID NUMBER(16,0) NULL ,
                                  NUM_CREDITO_INSINUADO NUMBER NULL,
                                  PRINCIPAL_INICIAL NUMBER(16,2) NULL,
                                  PRINCIPAL_GESTOR NUMBER(16,2) NULL,
                                  PRINCIPAL_FINAL NUMBER(16,2) NULL 
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;
 
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_DET_CREDITO_TRIMESTRE');
      
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_CNT_DET_CREDITO_TRIMESTRE_IX'', ''  TMP_H_CNT_DET_CREDITO_TRIMESTRE (TRIMESTRE_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CNT_DET_CREDITO_TRIMESTRE');
   
   
      --------------------------- H_CNT_DET_CREDITO_ANIO ------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CNT_DET_CREDITO_ANIO'', 
              		    ''ANIO_ID NUMBER(16,0) NOT NULL,    
                                  FECHA_CARGA_DATOS DATE NOT NULL, 
                                  CREDITO_INSINUADO_ID NUMBER(16,0) NULL,
                                  CONTRATO_ID NUMBER(16,0) NULL, 
                                  FECHA_CREDITO_INSINUADO DATE NULL, 
                                  GESTOR_CREDITO_ID NUMBER(16,0) NULL ,
                                  ESTADO_INSI_CREDITO_ID NUMBER(16,0) NULL ,
                                  CALIFICACION_INICIAL_ID NUMBER(16,0) NULL ,
                                  CALIFICACION_GESTOR_ID NUMBER(16,0) NULL ,
                                  CALIFICACION_FINAL_ID NUMBER(16,0) NULL ,
                                  NUM_CREDITO_INSINUADO NUMBER NULL,
                                  PRINCIPAL_INICIAL NUMBER(16,2) NULL,
                                  PRINCIPAL_GESTOR NUMBER(16,2) NULL,
                                  PRINCIPAL_FINAL NUMBER(16,2) NULL 
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;
 
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CNT_DET_CREDITO_ANIO');
      
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_CNT_DET_CREDITO_ANIO_IX'', ''  TMP_H_CNT_DET_CREDITO_ANIO (ANIO_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CNT_DET_CREDITO_ANIO');
      

    ------------------------------ TMP_FECHA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_FECHA'', 
              		    ''DIA_H DATE ,  -- Fecha H_TEMP
                              DIA_ANT DATE ,  -- Sig fecha
                              SEMANA_H INTEGER ,
                              SEMANA_ANT INTEGER,
                              MES_H INTEGER ,
                              MES_ANT INTEGER ,
                              TRIMESTRE_H INTEGER ,
                              TRIMESTRE_ANT INTEGER ,
                              ANIO_H INTEGER ,
                              ANIO_ANT INTEGER 
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

        DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_FECHA');
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_FECHA_DIA_IX'', ''  TMP_FECHA (DIA_H, DIA_ANT)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_FECHA_SEMANA_IX'', ''  TMP_FECHA (SEMANA_H, SEMANA_ANT)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_FECHA_MES_IX'', ''  TMP_FECHA (MES_H, MES_ANT)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_FECHA_TRIMESTRE_IX'', ''  TMP_FECHA (TRIMESTRE_H, TRIMESTRE_ANT)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_FECHA_ANIO_IX'', ''  TMP_FECHA (ANIO_H, ANIO_ANT)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;


        DBMS_OUTPUT.PUT_LINE('---- Creacion INDICES en TMP_FECHA');
    

    ------------------------------ TMP_FECHA_AUX --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_FECHA_AUX'', 
              		    ''DIA_AUX DATE ,
                              SEMANA_AUX INTEGER ,
                              MES_AUX INTEGER ,
                              TRIMESTRE_AUX INTEGER ,
                              ANIO_AUX INTEGER
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

        DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_FECHA');
    

    ------------------------------ TMP_FECHA_CNT --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_FECHA_CNT'', 
              		    ''DIA_CNT DATE
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

        DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_FECHA_CNT');
    

    ------------------------------ TMP_H --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_H'', 
              		    ''DIA_H DATE ,
                              SEMANA_H INTEGER ,
                              MES_H INTEGER ,
                              TRIMESTRE_H INTEGER ,
                              ANIO_H INTEGER ,
                              CONTRATO_H NUMBER(16,0) NOT NULL,
                              SITUACION_CONTRATO_DETALLE_H INTEGER ,
                              NUM_DIAS_VENCIDOS_H INTEGER ,
                              TRAMO_IRREGULARIDAD_FASES_H NUMBER(16,0)
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

        DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_H');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_DIA_IX'', ''  TMP_H (DIA_H, CONTRATO_H)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_SEMANA_IX'', ''  TMP_H (SEMANA_H, CONTRATO_H)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_MES_IX'', ''  TMP_H (MES_H, CONTRATO_H)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_TRIMESTRE_IX'', ''  TMP_H (TRIMESTRE_H, CONTRATO_H)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_ANIO_IX'', ''  TMP_H (ANIO_H, CONTRATO_H)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;


        DBMS_OUTPUT.PUT_LINE('---- Creacion INDICES en TMP_H');
    

    ------------------------------ TMP_ANT --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_ANT'', 
              		    ''DIA_ANT DATE ,
                              SEMANA_ANT INTEGER ,
                              MES_ANT INTEGER ,
                              TRIMESTRE_ANT INTEGER ,
                              ANIO_ANT INTEGER ,
                              CONTRATO_ANT NUMBER(16,0) NOT NULL,
                              SITUACION_CONTRATO_DETALLE_ANT INTEGER ,
                              NUM_DIAS_VENC_PERIODO_ANT INTEGER ,
                              T_IRREG_FASES_PER_ANT NUMBER(16,0)
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

        DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_ANT');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_ANT_DIA_IX'', ''  TMP_ANT (DIA_ANT, CONTRATO_ANT)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_ANT_SEMANA_IX'', ''  TMP_ANT (SEMANA_ANT, CONTRATO_ANT)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_ANT_MES_IX'', ''  TMP_ANT (MES_ANT, CONTRATO_ANT)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_ANT_TRIMESTRE_IX'', ''  TMP_ANT (TRIMESTRE_ANT, CONTRATO_ANT)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_ANT_ANIO_IX'', ''  TMP_ANT (ANIO_ANT, CONTRATO_ANT)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;


        DBMS_OUTPUT.PUT_LINE('---- Creacion INDICES en TMP_ANT');
    

    ------------------------------ TMP_MANTIENE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_MANTIENE'', 
              		    ''DIA_ID DATE ,
                              SEMANA_ID INTEGER ,
                              MES_ID INTEGER ,
                              TRIMESTRE_ID INTEGER ,
                              ANIO_ID INTEGER ,
                              CONTRATO_ID NUMBER(16,0) NOT NULL
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;


        DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_MANTIENE');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''MP_MANTIENE_DIA_IX'', ''  TMP_MANTIENE  (DIA_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''MP_MANTIENE_SEMANA_IX'', ''  TMP_MANTIENE  (SEMANA_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''MP_MANTIENE_MES_IX'', ''  TMP_MANTIENE  (MES_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''MP_MANTIENE_TRIMESTRE_IX'', ''  TMP_MANTIENE  (TRIMESTRE_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''MP_MANTIENE_ANIO_IX'', ''  TMP_MANTIENE  (ANIO_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;


        DBMS_OUTPUT.PUT_LINE('---- Creacion INDICES en TMP_MANTIENE');
    

    ------------------------------ TMP_ALTA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_ALTA'', 
              		    ''DIA_ID DATE ,
                              SEMANA_ID INTEGER ,
                              MES_ID INTEGER ,
                              TRIMESTRE_ID INTEGER ,
                              ANIO_ID INTEGER ,
                              CONTRATO_ID NUMBER(16,0) NOT NULL
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

        DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_ALTA');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_ALTA_DIA_IX'', ''  TMP_ALTA  (DIA_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_ALTA_SEMANA_IX'', ''  TMP_ALTA  (SEMANA_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_ALTA_MES_IX'', ''  TMP_ALTA  (MES_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_ALTA_TRIMESTRE_IX'', ''  TMP_ALTA  (TRIMESTRE_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_ALTA_ANIO_IX'', ''  TMP_ALTA  (ANIO_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;


        DBMS_OUTPUT.PUT_LINE('---- Creacion INDICES en TMP_ALTA');
    

    ------------------------------ TMP_BAJA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_BAJA'', 
              		    ''DIA_H DATE ,        -- Fecha en tabla hechos
                              DIA_MOV DATE ,      -- Fecha en Mov_Movimientos
                              SEMANA_H INTEGER ,         -- Mes en tabla hechos
                              SEMANA_MOV INTEGER ,       -- Mes en Mov_Movimientos
                              MES_H INTEGER ,         -- Mes en tabla hechos
                              MES_MOV INTEGER ,       -- Mes en Mov_Movimientos
                              TRIMESTRE_H INTEGER ,   -- Trimestre en tabla hechos
                              TRIMESTRE_MOV INTEGER , -- Trimestre en Mov_Movimientos
                              ANIO_H INTEGER ,        -- A?o en tabla hechos
                              ANIO_MOV INTEGER ,      -- A?o en Mov_Movimientos
                              CONTRATO_ID NUMBER(16,0) NOT NULL,
                              SITUACION_CONTRATO_DETALLE_ANT INTEGER ,
                              NUM_DIAS_VENC_PERIODO_ANT INTEGER ,
                              T_IRREG_FASES_PER_ANT NUMBER(16,0)
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

        DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_BAJA');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_BAJA_DIA_IX'', ''  TMP_BAJA  (DIA_MOV, CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_BAJA_SEMANA_IX'', ''  TMP_BAJA  (SEMANA_MOV, CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_BAJA_MES_IX'', ''  TMP_BAJA  (MES_MOV, CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_BAJA_TRIMESTRE_IX'', ''  TMP_BAJA  (TRIMESTRE_MOV, CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_BAJA_ANIO_IX'', ''  TMP_BAJA  (ANIO_MOV, CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

 
        DBMS_OUTPUT.PUT_LINE('---- Creacion INDICES en TMP_BAJA');
    



    ------------------------------ TMP_CNT_PROCEDIMIENTO_AUX --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_CNT_PROCEDIMIENTO_AUX'', 
              		    ''CONTRATO_ID NUMBER(16,0),
                                PROCEDIMIENTO_ID NUMBER(16,0),
                                TIPO_PROCEDIMIENTO_AGRUPADO_ID NUMBER(16,0)
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

        DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_CNT_PROCEDIMIENTO_AUX');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CNT_PROCEDIMIENTO_AUX_IX'', ''  TMP_CNT_PROCEDIMIENTO_AUX  (CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

    
        DBMS_OUTPUT.PUT_LINE('---- Creacion INDICES en TMP_CNT_PROCEDIMIENTO_AUX');
    

    ------------------------------ TMP_CNT_PROCEDIMIENTO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_CNT_PROCEDIMIENTO'', 
              		    ''CONTRATO_ID NUMBER(16,0),
                                LITIGIO NUMBER(16,0),
                                CONCURSO NUMBER(16,0)
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

        DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_CNT_PROCEDIMIENTO');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CNT_PROCEDIMIENTO_IX'', ''  TMP_CNT_PROCEDIMIENTO  (CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;


        DBMS_OUTPUT.PUT_LINE('---- Creacion INDICES en TMP_CNT_PROCEDIMIENTO');

    

    ------------------------------ TMP_CNT_EXPEDIENTE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_CNT_EXPEDIENTE'', 
              		    ''CONTRATO_ID NUMBER(16,0) ,
                              EXPEDIENTE_ID NUMBER(16,0)   ,
                              FECHA_CREACION_EXPEDIENTE DATE ,
                              FECHA_ROTURA_EXPEDIENTE DATE ,
                              FECHA_SALIDA_AGENCIA_EXP DATE ,
                              ESQUEMA_CONTRATO_ID NUMBER(16,0)  ,
                              AGENCIA_CONTRATO_ID NUMBER(16,0)  ,
                              SUBCARTERA_EXPEDIENTE_CNT_ID NUMBER(16,0) ,
                              TIPO_SALIDA_EXP_CNT_ID NUMBER(16,0)  ,
                              MOTIVO_SALIDA_EXP_CNT_ID NUMBER(16,0)  ,
                              TIPO_INCIDENCIA_EXP_CNT_ID NUMBER(16,0)  ,
                              ESTADO_INCIDENCIA_EXP_CNT_ID NUMBER(16,0)
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

        DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_CNT_EXPEDIENTE');


                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CNT_EXPEDIENTE_IX'', ''  TMP_CNT_EXPEDIENTE  (CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;


         DBMS_OUTPUT.PUT_LINE('---- Creacion INDICES en TMP_CNT_EXPEDIENTE');
    

    ------------------------------ TMP_CNT_SITUACION_FINANCIERA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_CNT_SITUACION_FINANCIERA'', 
              		    ''CONTRATO_ID NUMBER(16,0) ,
                              SITUACION_FINANCIERA_DESC VARCHAR2(50)
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

        DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_CNT_SITUACION_FINANCIERA');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_SITUACION_FINANCIERA_IX'', '' TMP_CNT_SITUACION_FINANCIERA  (CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;


        DBMS_OUTPUT.PUT_LINE('---- Creacion INDICES en TMP_CNT_SITUACION_FINANCIERA');
    

    ------------------------------ TMP_CNT_CREDITO_INSINUADO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_CNT_CREDITO_INSINUADO'', 
              		    ''CONTRATO_ID NUMBER(16,0) ,
                              CREDITO_ID NUMBER(16,0)  ,
                              ESTADO_INSINUACION_CNT_ID NUMBER(16,0) ,
                              CREDITO_PRINCIPAL_EXTERNO NUMBER(16,2) ,
                              CREDITO_PRINCIPAL_SUPERVISOR NUMBER(16,2) ,
                              CREDITO_PRINCIPAL_FINAL NUMBER(16,2) ,
                              FECHA_CREDITO DATE
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

        DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_CNT_CREDITO_INSINUADO');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CNT_CREDITO_INSINUADO_IX'', '' TMP_CNT_CREDITO_INSINUADO  (CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

       
        DBMS_OUTPUT.PUT_LINE('---- Creacion INDICES en TMP_CNT_CREDITO_INSINUADO');
    

    ------------------------------ TMP_CNT_RECOBRO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_CNT_RECOBRO'', 
              		    ''CONTRATO_ID NUMBER(16,0) ,
                          NUM_DPS_ACUMULADO INTEGER ,
                          DPS_ACUMULADO NUMBER(14,2) DEFAULT NULL ,
                          DPS_CAPITAL_ACUMULADO NUMBER(14,2) DEFAULT NULL ,
                          DPS_ICG_ACUMULADO NUMBER(14,2) DEFAULT NULL ,
                          RESULTADO_ACTUACION_CNT_ID NUMBER(16,0)  ,
                          FECHA_COMPROMETIDA_PAGO DATE ,
                          MODELO_RECOBRO_ID NUMBER(16,0) ,
                          MAX_PRIORIDAD_ACTUACION INTEGER ,
                          NUM_ACT_REC_ACUMULADO INTEGER ,
                          NUM_ACT_REC_CONTACTO_UTIL_ACU INTEGER
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

        DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_CNT_RECOBRO');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CNT_RECOBRO_IX'', '' TMP_CNT_RECOBRO  (CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

 
        DBMS_OUTPUT.PUT_LINE('---- Creacion INDICES en TMP_CNT_RECOBRO');
    

    ------------------------------ TMP_CNT_DPS --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_CNT_DPS'', 
              		    ''ID_CONTRATO NUMBER(16,0) ,
                          DPS_FINAL NUMBER(14,2),
                          DPS_CAPITAL NUMBER(14,2),
                          DPS_ICG NUMBER(14,2)
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_CNT_DPS');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CNT_DPS_IX'', '' TMP_CNT_DPS  (ID_CONTRATO)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;


      DBMS_OUTPUT.PUT_LINE('---- Creacion INDICES en TMP_CNT_DPS');
    

    ------------------------------ TMP_CNT_ESPECIALIZADA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', '' TMP_CNT_ESPECIALIZADA'', 
              		    ''CONTRATO_ID NUMBER(16,0) ,
                          SITUACION_ESPECIALIZADA_ID NUMBER(16,0)  ,
                          GESTOR_ESPECIALIZADA_ID NUMBER(16,0)  ,
                          SUPERVISOR_N1_ESPEC_ID NUMBER(16,0)   ,
                          SUPERVISOR_N2_ESPEC_ID NUMBER(16,0)   ,
                          SUPERVISOR_N3_ESPEC_ID NUMBER(16,0)
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_CNT_ESPECIALIZADA');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CNT_ESPECIALIZADA_IX'', '' TMP_CNT_ESPECIALIZADA  (CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;


      DBMS_OUTPUT.PUT_LINE('---- Creacion INDICES en TMP_CNT_ESPECIALIZADA');
    

    ------------------------------ TMP_CNT_PREVISIONES --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_CNT_PREVISIONES'', 
              		    ''CONTRATO_ID NUMBER(16,0) ,
                              FECHA_PREVISION date ,
                              FECHA_SIG_PREVISION date ,
                              CNT_CON_PREV_REVISADA_ID NUMBER(16,0)  ,
                              TIPO_PREVISION_ID NUMBER(16,0)   ,
                              PREV_SITUACION_INICIAL_ID NUMBER(16,0)   ,
                              PREV_SITUACION_AUTO_ID NUMBER(16,0)   ,
                              PREV_SITUACION_MANUAL_ID NUMBER(16,0)   ,
                              PREV_SITUACION_FINAL_ID NUMBER(16,0)   ,
                              MOTIVO_PREVISION_ID NUMBER(16,0)  ,
                              IMP_IRREGULAR_PREV_INICIO NUMBER(14,2) ,
                              IMP_IRREGULAR_PREV_AUTO NUMBER(14,2) ,
                              IMP_IRREGULAR_PREV_MANUAL NUMBER(14,2) ,
                              IMP_IRREGULAR_PREV_FINAL NUMBER(14,2) ,
                              IMP_RIESGO_PREV_INICIO NUMBER(14,2) ,
                              IMP_RIESGO_PREV_AUTO NUMBER(14,2) ,
                              IMP_RIESGO_PREV_MANUAL NUMBER(14,2) ,
                              IMP_RIESGO_PREV_FINAL NUMBER(14,2)
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

        DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_CNT_PREVISIONES');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CNT_PREVISIONES_IX'', '' TMP_CNT_PREVISIONES  (FECHA_PREVISION, CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CNT_PREVISIONES_CNT_IX'', '' TMP_CNT_PREVISIONES  (CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;



       DBMS_OUTPUT.PUT_LINE('---- Creacion INDICES en TMP_CNT_PREVISIONES');
    

    ------------------------------ TMP_CNT_PREVISIONES_DIA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_CNT_PREVISIONES_DIA'', 
              		    ''CONTRATO_ID NUMBER(16,0) ,
                              FECHA_PREVISION date ,
                              FECHA_SIG_PREVISION date ,
                              CNT_CON_PREV_REVISADA_ID NUMBER(16,0)  ,
                              TIPO_PREVISION_ID NUMBER(16,0)   ,
                              PREV_SITUACION_INICIAL_ID NUMBER(16,0)   ,
                              PREV_SITUACION_AUTO_ID NUMBER(16,0)   ,
                              PREV_SITUACION_MANUAL_ID NUMBER(16,0)   ,
                              PREV_SITUACION_FINAL_ID NUMBER(16,0)   ,
                              MOTIVO_PREVISION_ID NUMBER(16,0)  ,
                              IMP_IRREGULAR_PREV_INICIO NUMBER(14,2) ,
                              IMP_IRREGULAR_PREV_AUTO NUMBER(14,2) ,
                              IMP_IRREGULAR_PREV_MANUAL NUMBER(14,2) ,
                              IMP_IRREGULAR_PREV_FINAL NUMBER(14,2) ,
                              IMP_RIESGO_PREV_INICIO NUMBER(14,2) ,
                              IMP_RIESGO_PREV_AUTO NUMBER(14,2) ,
                              IMP_RIESGO_PREV_MANUAL NUMBER(14,2) ,
                              IMP_RIESGO_PREV_FINAL NUMBER(14,2)
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

        DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_CNT_PREVISIONES_DIA');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CNT_PREVISIONES_DIA_CNT_IX'', '' TMP_CNT_PREVISIONES_DIA  (CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CNT_PREVISIONES_DIA_IX'', '' TMP_CNT_PREVISIONES_DIA  (FECHA_PREVISION, CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;


        DBMS_OUTPUT.PUT_LINE('---- Creacion INDICES en TMP_CNT_PREVISIONES_DIA');
    

    ------------------------------ TMP_LOAN_INFORMATION --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_LOAN_INFORMATION'', 
              		    ''IN_SECURED_UNSECURED	VARCHAR2(250)  ,
                            NUC	NUMBER(16,0)  ,
                            NUC_RIESGO	NUMBER(16,0)  ,
                            CCC	VARCHAR2(250)  ,
                            CCC_RIESGO	VARCHAR2(250)  ,
                            FECHA_FORMALIZACION	VARCHAR2(250)  ,
                            FECHA_VENCIMIENTO	VARCHAR2(250)  ,
                            PRODUCTO_NIVEL_2 VARCHAR2(250)  ,
                            PRODUCTO_NIVEL_3 VARCHAR2(250)  ,
                            PRODUCTO_NIVEL_4 VARCHAR2(250)  ,
                            PRODUCTO_NIVEL_5 VARCHAR2(250)  ,
                            PRODUCTO_AGRUPADO	VARCHAR2(250)  ,
                            LTV_ORIGINAL	VARCHAR2(250)  ,
                            SITUACION_CONTABLE_NIVEL_1	VARCHAR2(250)  ,
                            SITUACION_CONTABLE_NIVEL_2	VARCHAR2(250)  ,
                            FECHA_ENTRADA_FALLIDO	VARCHAR2(250)  ,
                            FECHA_1ER_VCTO_PENDIENTE	VARCHAR2(250)  ,
                            FECHA_ENTRADA_MORA	VARCHAR2(250)  ,
                            DIAS_ATRASO	VARCHAR2(250)  ,
                            CUOTA_EMITIDA_NO_PAGADA	VARCHAR2(250)  ,
                            SALDO_DEUDOR	VARCHAR2(250)  ,
                            INTERESES_VENCIDOS	VARCHAR2(250)  ,
                            DISPONIBLE	VARCHAR2(250)  ,
                            CAPITAL_VENCIDO	VARCHAR2(250)  ,
                            CAPITAL_FALLIDO	VARCHAR2(250)  ,
                            FIRST_DELINCUENCY_DATE	VARCHAR2(250)  ,
                            LAST_DELINCUENCY_DATE	VARCHAR2(250)  ,
                            NUM_IRREGULAR_STATUS	VARCHAR2(250)  ,
                            NUM_NP_STATUS	VARCHAR2(250)  ,
                            TIPO_REFERENCIA	VARCHAR2(250)  ,
                            REFERENCIA	VARCHAR2(250)  ,
                            PERIODICIDAD_INDICE	VARCHAR2(250)  ,
                            FECHA_REVISION_TIPO	VARCHAR2(250)  ,
                            INTERES	VARCHAR2(250)  ,
                            DIFERENCIAL	VARCHAR2(250)  ,
                            DIFERENCIAL_BONIFICADO	VARCHAR2(250)  ,
                            INTERES_MINIMO	VARCHAR2(250)  ,
                            TASA_INTERES_DEMORA	VARCHAR2(250)  ,
                            COMISION_CANCELACION	VARCHAR2(250)  ,
                            IN_SEGURO_HIPOTECARIO	VARCHAR2(250)  ,
                            COMPANIA	VARCHAR2(250)  ,
                            CAPITAL_ASEGURADO	VARCHAR2(250)  ,
                            IN_SINDICADO	VARCHAR2(250)  ,
                            PORCENTAJE_PARTIPACION	VARCHAR2(250)  ,
                            PRINCIPAL	VARCHAR2(250)  ,
                            PRINCIPAL_ORIGINAL	VARCHAR2(250)  ,
                            NUM_LIMITE_REDUCE	VARCHAR2(250)  ,
                            NUM_LIMITE_INCREMENTA	VARCHAR2(250)  ,
                            CREDIT_SCORE	VARCHAR2(250)  ,
                            DEBT_TO_INCOME_RATIO	VARCHAR2(250)  ,
                            JUZGADO	VARCHAR2(250)  ,
                            PASO_PROCESAL_ID	VARCHAR2(250)  ,
                            PASO_PROCESAL	VARCHAR2(250)  ,
                            PROCEDIMIENTO_JUDICIAL	VARCHAR2(250)  ,
                            FASE_RECUPERACION	VARCHAR2(250)  ,
                            FECHA_PRESENTACION_DEMANDA	VARCHAR2(250)  ,
                            IMPORTE_RECLAMADO	VARCHAR2(250)  ,
                            FECHA_ADMISION_DEMANDA	VARCHAR2(250)  ,
                            FECHA_SUBASTA	VARCHAR2(250)  ,
                            IMPORTE_SUBASTA	VARCHAR2(250)  ,
                            FECHA_TOMA_POSESION	VARCHAR2(250) 
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

        DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_LOAN_INFORMATION');
    

    ------------------------------ TMP_ESTUDIO_CARTERA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_ESTUDIO_CARTERA'', 
              		    ''CONTRATO_ID NUMBER(16,0),
                              NUC NUMBER(16,0),
                              NUC_RIESGO NUMBER(16,0),
                              CAPITAL_FALLIDO VARCHAR2(250),
                              FECHA_PRIMER_VENCI_PEND DATE,
                              PASO NUMBER(16,0),
                              EN_MASIVA NUMBER(16,0),
                              NGB_UGAS NUMBER(16,0)
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

        DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_ESTUDIO_CARTERA');


    ------------------------------ TMP_EN_MASIVA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_EN_MASIVA'', 
              		    ''CONTRATO_ID NUMBER(16,0)
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

        DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_EN_MASIVA');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_EN_MASIVA_IX'', '' TMP_EN_MASIVA  (CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

        DBMS_OUTPUT.PUT_LINE('---- Creacion INDICES en TMP_EN_MASIVA');
    

    ------------------------------ TMP_CNT_COBRO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_CNT_COBRO'', 
              		    ''CONTRATO_ID NUMBER(16,0),
                              FECHA_COBRO DATE ,
                              MAX_FECHA_CONTRATO DATE
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

        DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_CNT_COBRO');
        
                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CNT_COBRO_IX'', '' TMP_CNT_COBRO  (CONTRATO_ID, FECHA_COBRO)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

 
        DBMS_OUTPUT.PUT_LINE('---- Creacion INDICES en TMP_CNT_COBRO');
    
    
    
    ------------------------------ TMP_CNT_ENVIO_AGENCIA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_CNT_ENVIO_AGENCIA'', 
              		    ''CONTRATO_ID NUMBER(16,0) ,
                              EXPEDIENTE_ID NUMBER(16,0) ,
                              AGENCIA_COBRO_ID NUMBER(16,0) ,
                              SUBCARTERA_COBRO_ID NUMBER(16,0) ,
                              POS_VIVA_NO_VENCIDA NUMBER(14,2) ,
                              POS_VIVA_VENCIDA NUMBER(14,2) ,
                              INT_ORDIN_DEVEN NUMBER(14,2) ,
                              INT_MORAT_DEVEN NUMBER(14,2) ,
                              COMISIONES NUMBER(14,2) ,
                              GASTOS NUMBER(14,2) ,
                              IMPUESTOS NUMBER(14,2) ,
                              ENTREGAS NUMBER(14,2) ,
                              INT_ENTREGAS NUMBER(14,2) ,
                              DEUDA_IRREGULAR NUMBER(14,2)
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

        DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_CNT_ENVIO_AGENCIA');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CNT_ENVIO_AGENCIA_IX'', '' TMP_CNT_ENVIO_AGENCIA  (CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
        

        DBMS_OUTPUT.PUT_LINE('---- Creacion INDICES en TMP_CNT_ENVIO_AGENCIA');
    


    ------------------------------ TMP_ENTSAL_D1 --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_ENTSAL_D1'', 
              		    ''DIA_ID DATE NOT NULL,
                            CONTRATO_ID NUMBER(16,0) NOT NULL,
                            -- Dimensiones
                            MOTIVO_BAJA_CR_ID NUMBER(16,0),
                            ESQUEMA_CR_ID NUMBER(16,0) NULL,
                            SUBCARTERA_CR_ID NUMBER(16,0) NULL,
                            AGENCIA_CR_ID NUMBER(16,0) NULL,
                            SEGMENTO_CARTERA_CR_ID NUMBER(16,0) NULL,
                            ENVIADO_AGENCIA_CR_ID NUMBER(16,0) NULL,
                            -- Metricas
                            NUM_CONTRATO_CICLO_REC INTEGER ,
                            POSICION_VENCIDA_CICLO_REC NUMBER(16,2) ,
                            POSICION_NO_VENCIDA_CICLO_REC NUMBER(16,2) ,
                            INT_ORDINARIOS_CICLO_REC NUMBER(16,2) ,
                            INT_MORATORIOS_CICLO_REC NUMBER(16,2) ,
                            COMISIONES_CICLO_REC NUMBER(16,2) ,
                            GASTOS_CICLO_REC NUMBER(16,2) ,
                            IMPUESTOS_CICLO_REC NUMBER(16,2),
                            DEUDA_IRREGULAR_CICLO_REC NUMBER(14,2)
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

     DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_ENTSAL_D1');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_ENTSAL_D1_IX'', '' TMP_ENTSAL_D1  (CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;


      DBMS_OUTPUT.PUT_LINE('---- Creacion INDICES en TMP_ENTSAL_D1');
    

    ------------------------------ TMP_ENTSAL_D2 --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_ENTSAL_D2'', 
              		    ''DIA_ID DATE NOT NULL,
                            CONTRATO_ID NUMBER(16,0) NOT NULL,
                            -- Dimensiones
                            MOTIVO_BAJA_CR_ID NUMBER(16,0),
                            ESQUEMA_CR_ID NUMBER(16,0) NULL,
                            SUBCARTERA_CR_ID NUMBER(16,0) NULL,
                            AGENCIA_CR_ID NUMBER(16,0) NULL,
                            SEGMENTO_CARTERA_CR_ID NUMBER(16,0) NULL,
                            ENVIADO_AGENCIA_CR_ID NUMBER(16,0) NULL,
                            -- Metricas
                            NUM_CONTRATO_CICLO_REC INTEGER ,
                            POSICION_VENCIDA_CICLO_REC NUMBER(16,2) ,
                            POSICION_NO_VENCIDA_CICLO_REC NUMBER(16,2) ,
                            INT_ORDINARIOS_CICLO_REC NUMBER(16,2) ,
                            INT_MORATORIOS_CICLO_REC NUMBER(16,2) ,
                            COMISIONES_CICLO_REC NUMBER(16,2) ,
                            GASTOS_CICLO_REC NUMBER(16,2) ,
                            IMPUESTOS_CICLO_REC NUMBER(16,2) ,
                            DEUDA_IRREGULAR_CICLO_REC NUMBER(14,2) 
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_ENTSAL_D2');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_ENTSAL_D2_IX'', '' TMP_ENTSAL_D2  (CONTRATO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion INDICES en TMP_ENTSAL_D2_IX');
    
    
    ------------------------------ TMP_CNT_FACTURACION --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_CNT_FACTURACION'', 
              		    ''COBRO_ID NUMBER(16,0),
                              CODIGO_COBRO VARCHAR2(250) ,
                              FECHA_FACTURA DATE,
                              FACTURA_ID NUMBER(16,0) ,
                              IMPORTE_FACTURA NUMBER(14,2),
                              TARIFA NUMBER(16,2),
                              CORRECTOR NUMBER(2,5)
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

        DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_CNT_COBRO');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CNT_FACTURACION_IX'', '' TMP_CNT_FACTURACION  (COBRO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
        
      
        DBMS_OUTPUT.PUT_LINE('---- Creacion INDICES en TMP_CNT_FACTURACION');
    

    ------------------------------ TMP_DET_COBROS_PAGOS --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_DET_COBROS_PAGOS'', 
              		    ''CPA_ID	NUMBER(16,0),
                                CPA_CODIGO_COBRO	VARCHAR2(20 BYTE),
                                CPA_FECHA_VALOR	DATE
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

        DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_DET_COBROS_PAGOS');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_DET_COBROS_PAGOS_IX'', '' TMP_DET_COBROS_PAGOS  (CPA_CODIGO_COBRO, CPA_FECHA_VALOR)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

        DBMS_OUTPUT.PUT_LINE('---- Creacion INDICES en TMP_DET_COBROS_PAGOS');
    

    ------------------------------ TMP_CNT_ACCIONES --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_CNT_ACCIONES'', 
              		    ''CONTRATO NUMBER(16,0),
                              FECHA_ACCION DATE,
                              FECHA_COMPROMETIDA_PAGO DATE,
                              IMPORTE_COMPROMETIDO NUMBER(14,2),
                              TIPO_ACCION NUMBER(16,0),
                              RESULTADO_GESTION NUMBER(16,0),
                              PRIORIDAD_GESTION NUMBER(16,0)
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_CNT_ACCIONES');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CNT_ACCIONES_IX'', '' TMP_CNT_ACCIONES  (CONTRATO)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

          DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_CNT_ACCIONES');
      

    ------------------------------ TMP_CNT_GESTOR_CREDITO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_CNT_GESTOR_CREDITO'', 
              		    ''PROCEDIMIENTO_ID NUMBER(16,0),
                              GESTOR_CREDITO_ID NUMBER(16,0) 
                            '', :error); END;';
	execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_CNT_GESTOR_CREDITO');

                V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CNT_GESTOR_CREDITO_IX'', '' TMP_CNT_GESTOR_CREDITO  (PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;


        DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_CNT_GESTOR_CREDITO');
  
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;
    
  end;

END CREAR_H_CONTRATO;