--/*
--##########################################
--## AUTOR=María V.
--## FECHA_CREACION=20160704
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=RECOVERY-2286
--## PRODUCTO=NO
--## 
--## Finalidad: Se añade CONTRATO_COD_CONTRATO_15 para poner representación de 15 dígitos en atributo contrato
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
create or replace PROCEDURE CREAR_DIM_CONTRATO (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: María Villanueva, PFS Group
-- Fecha creacion: Agosto 2015
-- Responsable ultima modificacion: Pedro S., PFS Group
-- Fecha ultima modificacion: 04/07/2016
-- Motivos del cambio: Se añade CONTRATO_COD_CONTRATO_15 para poner representación de 15 dígitos en atributo contrato
-- Cliente: Recovery BI Cajamar
--
-- Descripcion: Procedimiento almancenado que crea las tablas de la dimension Contrato
-- ===============================================================================================

-- -------------------------------------------- INDICE -------------------------------------------
-- DIMENSION CONTRATO
    -- D_CNT_ESTADO_FINANCIERO
    -- D_CNT_ESTADO_FINANCIERO_AGR
    -- D_CNT_ESTADO_FINANCIERO_ANT
    -- D_CNT_ESTADO_FINA_ANT_AGR
    -- D_CNT_ESTADO_CONTRATO
    -- D_CNT_TIPO_PRODUCTO
    -- D_CNT_PRODUCTO
    -- D_CNT_FINALIDAD_CONTRATO
    -- D_CNT_FINALIDAD_OFICIAL
    -- D_CNT_GARANTIA_CONTABLE
    -- D_CNT_GARANTIA_CONTRATO
    -- D_CNT_MONEDA
    -- D_CNT_ZONA
    -- D_CNT_NIVEL
    -- D_CNT_OFICINA
    -- D_CNT_PROVINCIA
    -- D_CNT_CATALOGO_DETALLE_6
    -- D_CNT_CATALOGO_DETALLE_5
    -- D_CNT_CATALOGO_DETALLE_4
    -- D_CNT_CATALOGO_DETALLE_3
    -- D_CNT_CATALOGO_DETALLE_2
    -- D_CNT_CATALOGO_DETALLE_1
    -- D_CNT_NACIONALIDAD_TITULAR
    -- D_CNT_POLITICA_TITULAR
    -- D_CNT_SEGMENTO_TITULAR
    -- D_CNT_SEXO_TITULAR
    -- D_CNT_SITUACION
    -- D_CNT_SITUACION_DETALLE
    -- D_CNT_SITUACION_ANTERIOR
    -- D_CNT_SITUACION_ANT_DETALLE
    -- D_CNT_SITUACION_RESP_PER_ANT
    -- D_CNT_TIPO_PERSONA_TITULAR
    -- D_CNT_JUDICIALIZADO
    -- D_CNT_EST_INSINUACION_CNT
    -- D_CNT_CARTERA
    -- D_CNT_T_IRREG_DIAS
    -- D_CNT_T_IRREG_DIAS_PERIOD_ANT 
    -- D_CNT_T_IRREG_FASES
    -- D_CNT_T_IRREG_FASES_PER_ANT
    -- D_CNT_T_IRREG_FASES_AGR
    -- D_CNT_T_IRREG_F_AGR_PER_ANT
    -- D_CNT_TD_EN_GESTION_A_COBRO
    -- D_CNT_TD_IRREGULAR_A_COBRO
    -- D_CNT_GARANTIA_CONTRATO_AGR
    -- D_CNT_SEGMENTO_TITULAR_AGR
    -- D_CNT_RESULTADO_ACTUACION
    -- D_CNT_EN_GESTION_RECOBRO
    -- D_CNT_EN_IRREGULAR
    -- D_CNT_MODELO_RECOBRO
    -- D_CNT_PROVEEDOR_RECOBRO
    -- D_CNT_CON_DPS
    -- D_CNT_CON_CONTACTO_UTIL
    -- D_CNT_CON_ACTUACION_RECOBRO
    -- D_CNT_EST_FIN_INI_CAMP_REC
    -- D_CNT_EST_FIN_ANT_INI_CAMP_REC
    -- D_CNT_EN_GEST_REC_INI_CAMP_REC
    -- D_CNT_EN_IRREG_INI_CAMP_REC
    -- D_CNT_MODELO_REC_INI_CAMP_REC
    -- D_CNT_PROV_REC_INI_CAMP_REC
    -- D_CNT_T_IRREG_D_INI_CAMP_REC
    -- D_CNT_T_IRREG_F_INI_CAMP_REC
    -- D_CNT_T_IRREG_F_AGR_INI_REC
    -- D_CNT_EN_GESTION_ESPEC
    -- D_CNT_CON_PREVISION
    -- D_CNT_CON_PREVISION_REVISADA
    -- D_CNT_TIPO_PREVISION
    -- D_CNT_PREV_SITUACION_INICIAL
    -- D_CNT_PREV_SITUACION_AUTO
    -- D_CNT_PREV_SITUACION_MANUAL
    -- D_CNT_PREV_SITUACION_FINAL
    -- D_CNT_MOTIVO_PREVISION
    -- D_CNT_SITUACION_ESPECIALIZADA
    -- D_CNT_GESTOR_ESPECIALIZADA
    -- D_CNT_SUPERVISOR_N1_ESPEC
    -- D_CNT_SUPERVISOR_N2_ESPEC
    -- D_CNT_SUPERVISOR_N3_ESPEC
    -- D_CNT_EN_CARTERA_ESTUDIO
    -- D_CNT_MODELO_GESTION_CARTERA
    -- D_CNT_UNIDAD_GESTION_CARTERA
    -- D_CNT_CON_CAPITAL_FALLIDO
    -- D_CNT_TIPO_GESTION
    -- D_CNT_ESQUEMA
    -- D_CNT_CARTERA_EXPEDIENTE
    -- D_CNT_SUBCARTERA_EXPEDIENTE
    -- D_CNT_AGENCIA
    -- D_CNT_TIPO_SALIDA_EXPEDIENTE
    -- D_CNT_MOTIVO_SALIDA_EXP
    -- D_CNT_TIPO_INCIDENCIA_EXP
    -- D_CNT_ESTADO_INCIDENCIA_EXP
    -- D_CNT_T_SALDO_TOTAL
    -- D_CNT_T_SALDO_IRREGULAR
    -- D_CNT_T_DEUDA_IRREGULAR
    -- D_CNT_TIPO_COBRO
    -- D_CNT_TIPO_COBRO_DETALLE
    -- D_CNT_COBRO_FACTURADO
    -- D_CNT_REMESA_FACTURA
    -- D_CNT_CLASIFICACION
    -- D_CNT_SEGMENTO_CARTERA
    -- D_CNT_ENVIADO_AGENCIA
    -- D_CNT_ESQUEMA_COBRO
    -- D_CNT_CARTERA_COBRO
    -- D_CNT_SUBCARTERA_COBRO
    -- D_CNT_AGENCIA_COBRO
    -- D_CNT_TIPO_PRODUCTO_COBRO
    -- D_CNT_GARANTIA_COBRO
    -- D_CNT_SEGMENTO_CARTERA_COBRO
    -- D_CNT_TD_IRREG_COBRO
    -- D_CNT_T_DEUDA_IRREGULAR_COBRO
    -- D_CNT_ENVIADO_AGENCIA_COBRO
    -- D_CNT_FACTURA_COBRO
    -- D_CNT_MOTIVO_BAJA_CR
    -- D_CNT_ESQUEMA_CR
    -- D_CNT_CARTERA_CR
    -- D_CNT_SUBCARTERA_CR
    -- D_CNT_AGENCIA_CR
    -- D_CNT_SEGMENTO_CARTERA_CR
    -- D_CNT_ENVIADO_AGENCIA_CR
    -- D_CNT_ESTADO_ACUERDO
    -- D_CNT_SOLICITANTE_ACUERDO
    -- D_CNT_TIPO_ACUERDO
    -- D_CNT_ESQUEMA_ACUERDO
    -- D_CNT_CARTERA_ACUERDO
    -- D_CNT_SUBCARTERA_ACUERDO
    -- D_CNT_AGENCIA_ACUERDO
    -- D_CNT_ENVIADO_AGENCIA_ACUERDO
    -- D_CNT_TIPO_INCIDENCIA
    -- D_CNT_SITUACION_INCIDENCIA
    -- D_CNT_ESQUEMA_INCIDENCIA
    -- D_CNT_CARTERA_INCIDENCIA
    -- D_CNT_SUBCARTERA_INCIDENCIA
    -- D_CNT_AGENCIA_INCIDENCIA
    -- D_CNT_ENVIADO_AGENCIA_INCI
    -- D_CNT_ESQUEMA_ER
    -- D_CNT_CARTERA_ER
    -- D_CNT_SUBCARTERA_ER
    -- D_CNT_AGENCIA_ER
    -- D_CNT_TRAMO_RIESGO
    -- D_CNT_TIPO_ACCION
    -- D_CNT_RESULTADO_GESTION
    -- D_CNT_GESTOR_CREDITO
    -- D_CNT_DESPACHO_GESTOR_CREDITO
    -- D_CNT_ESTADO_INSI_CREDITO
    -- D_CNT_CALIF_INICIAL_CREDITO
    -- D_CNT_CALIF_GESTOR_CREDITO
    -- D_CNT_CALIF_FINAL_CREDITO
    -- D_CNT_GESTION_ESPECIAL
    -- D_CNT_TA_FECHA_CREACION
    -- D_CNT_PERIMETRO_GESTION
    -- D_CNT_MOTIVO_BAJA_DUDOSO
    -- D_CNT_MOTIVO_ALTA_DUDOSO
    -- D_CNT_T_ANTIGUEDAD_DEUDA
    -- D_CNT_SITUACION_CARTERA_DANADA
    -- D_CNT_TIPO_GESTION_EXP
    -- D_CNT_TIPO_VENCIDO
    -- D_CNT_TRAMO_CAP_VIVO
    -- D_CNT_DIR_TERRITORIAL
    -- D_CNT_ENTIDAD
    -- D_CNT_PERIMETRO_GESTION_CM
    -- D_CNT_MOTIVO_COBRO
	-- D_CNT_APLICATIVO_ORIGEN
    -- D_CNT
	-- D_CNT_PERIMETRO_SIN_GESTION, 
	-- D_CNT_PERIMETRO_EXP_SEG, 
	-- D_CNT_PERIMETRO_EXP_REC, 
	-- D_CNT_PERIMETRO_GES_EXTRA, 
	-- D_CNT_PERIMETRO_GES_PRE, 
	-- D_CNT_PERIMETRO_GES_JUDI, 
	-- D_CNT_PERIMETRO_GES_CONCU
    -- D_CNT_TITULAR
    -- D_CNT_TIPO_SOL_PREVISTA
    


BEGIN
  declare
  nCount NUMBER;
 V_SQL VARCHAR2(16000);
  V_NOMBRE VARCHAR2(50) := 'CREAR_DIM_CONTRATO';
  V_ESQUEMA varchar2(100);
  
  
  begin

  
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
	select valor into V_ESQUEMA from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DWH'; 
    
    ------------------------------ D_CNT_ESTADO_FINANCIERO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_ESTADO_FINANCIERO'', 
						  ''ESTADO_FINANCIERO_CNT_ID NUMBER(16,0) NOT NULL,
                            ESTADO_FINANCIERO_CNT_DESC VARCHAR2(50 CHAR),
                            ESTADO_FINANCIERO_CNT_DESC_2 VARCHAR2(250 CHAR),
                            ESTADO_FINANCIERO_CNT_AGR_ID NUMBER(16,0),
                            PRIMARY KEY (ESTADO_FINANCIERO_CNT_ID)'', :error); END;'; 		
							
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_ESTADO_FINANCIERO');
   

    ------------------------------ D_CNT_ESTADO_FINANCIERO_AGR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_ESTADO_FINANCIERO_AGR'', 
						  ''ESTADO_FINANCIERO_CNT_AGR_ID NUMBER(16,0) NOT NULL,
                            ESTADO_FINANCIERO_CNT_AGR_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (ESTADO_FINANCIERO_CNT_AGR_ID)'', :error); END;'; 		 
							
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_ESTADO_FINANCIERO_AGR');
   

    ------------------------------ D_CNT_ESTADO_FINANCIERO_ANT --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_ESTADO_FINANCIERO_ANT'', 
						  ''ESTADO_FINANCIERO_ANT_ID NUMBER(16,0) NOT NULL,
                            ESTADO_FINANCIERO_ANT_DESC VARCHAR2(50 CHAR),
                            ESTADO_FINANCIERO_ANT_DESC_2 VARCHAR2(250 CHAR),
                            ESTADO_FINANCIERO_ANT_AGR_ID NUMBER(16,0),
                            PRIMARY KEY (ESTADO_FINANCIERO_ANT_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_ESTADO_FINANCIERO_ANT');
   

    ------------------------------ D_CNT_ESTADO_FIN_ANT_AGR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_ESTADO_FIN_ANT_AGR'', 
						  ''ESTADO_FINANCIERO_ANT_AGR_ID NUMBER(16,0) NOT NULL,
                            ESTADO_FINANCIERO_ANT_AGR_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (ESTADO_FINANCIERO_ANT_AGR_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_ESTADO_FIN_ANT_AGR');
   

    ------------------------------ D_CNT_ESTADO_CONTRATO--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_ESTADO_CONTRATO'', 
						  ''ESTADO_CONTRATO_ID NUMBER(16,0) NOT NULL,
                            ESTADO_CONTRATO_DESC VARCHAR2(50 CHAR),
                            ESTADO_CONTRATO_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (ESTADO_CONTRATO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_ESTADO_CONTRATO');
   

    ------------------------------ D_CNT_TIPO_PRODUCTO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_TIPO_PRODUCTO'', 
						  ''TIPO_PRODUCTO_ID NUMBER(16,0) NOT NULL,
                            TIPO_PRODUCTO_DESC VARCHAR2(50 CHAR),
                            TIPO_PRODUCTO_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_PRODUCTO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_TIPO_PRODUCTO');
   

    ------------------------------ D_CNT_PRODUCTO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_PRODUCTO'', 
						  ''PRODUCTO_ID NUMBER(16,0) NOT NULL,
                            PRODUCTO_DESC VARCHAR2(50 CHAR),
                            PRODUCTO_DESC_2 VARCHAR2(250 CHAR),
                            TIPO_PRODUCTO_ID NUMBER(16,0) NULL,
                            PRIMARY KEY (PRODUCTO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_PRODUCTO');
   

    ------------------------------ D_CNT_FINALIDAD_CONTRATO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_FINALIDAD_CONTRATO'', 
						  ''FINALIDAD_CONTRATO_ID NUMBER(16,0) NOT NULL,
                            FINALIDAD_CONTRATO_DESC VARCHAR2(50 CHAR),
                            FINALIDAD_CONTRATO_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (FINALIDAD_CONTRATO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_FINALIDAD_CONTRATO');
   

    ------------------------------ D_CNT_FINALIDAD_OFICIAL --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_FINALIDAD_OFICIAL'', 
						  ''FINALIDAD_OFICIAL_ID NUMBER(16,0) NOT NULL,
                            FINALIDAD_OFICIAL_DESC VARCHAR2(50 CHAR),
                            FINALIDAD_OFICIAL_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (FINALIDAD_OFICIAL_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_FINALIDAD_OFICIAL');
   

    ------------------------------ D_CNT_GARANTIA_CONTABLE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_GARANTIA_CONTABLE'', 
						  ''GARANTIA_CONTABLE_ID NUMBER(16,0) NOT NULL,
                            GARANTIA_CONTABLE_DESC VARCHAR2(50 CHAR),
                            GARANTIA_CONTABLE_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (GARANTIA_CONTABLE_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_GARANTIA_CONTABLE');
   

    ------------------------------ D_CNT_GARANTIA_CONTRATO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_GARANTIA_CONTRATO'', 
						  ''GARANTIA_CONTRATO_ID NUMBER(16,0) NOT NULL,
                            GARANTIA_CONTRATO_DESC VARCHAR2(50 CHAR),
                            GARANTIA_CONTRATO_DESC_2 VARCHAR2(250 CHAR),
                            GARANTIA_CONTRATO_AGR_ID NUMBER(16,0),
                            PRIMARY KEY (GARANTIA_CONTRATO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_GARANTIA_CONTRATO');
   

    ------------------------------ D_CNT_MONEDA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_MONEDA'', 
						  ''MONEDA_ID NUMBER(16,0) NOT NULL,
                            MONEDA_DESC VARCHAR2(50 CHAR),
                            MONEDA_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (MONEDA_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_MONEDA');
   

    ------------------------------ D_CNT_ZONA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_ZONA'', 
						  ''ZONA_CONTRATO_ID NUMBER(16,0) NOT NULL,
                            ZONA_CONTRATO_DESC VARCHAR2(50 CHAR),
                            ZONA_CONTRATO_DESC_2 VARCHAR2(250 CHAR),
                            NIVEL_CONTRATO_ID NUMBER(16,0),
                            OFICINA_CONTRATO_ID NUMBER(16,0),
                            PRIMARY KEY (ZONA_CONTRATO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_ZONA');
   

    ------------------------------ D_CNT_NIVEL --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_NIVEL'', 
						  ''NIVEL_CONTRATO_ID NUMBER(16,0) NOT NULL,
                            NIVEL_CONTRATO_DESC VARCHAR2(50 CHAR),
                            NIVEL_CONTRATO_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (NIVEL_CONTRATO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_NIVEL');
   

    ------------------------------ D_CNT_OFICINA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_OFICINA'', 
						  ''OFICINA_CONTRATO_ID NUMBER(16,0) NOT NULL,
                            OFICINA_CONTRATO_DESC VARCHAR2(50 CHAR),
                            OFICINA_CONTRATO_DESC_2 VARCHAR2(250 CHAR),
                            PROVINCIA_CONTRATO_ID NUMBER(16,0),
                            PRIMARY KEY (OFICINA_CONTRATO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_OFICINA');
   

    ------------------------------ D_CNT_PROVINCIA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_PROVINCIA'', 
						  ''PROVINCIA_CONTRATO_ID NUMBER(16,0) NOT NULL,
                            PROVINCIA_CONTRATO_DESC VARCHAR2(50 CHAR),
                            PROVINCIA_CONTRATO_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (PROVINCIA_CONTRATO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_PROVINCIA');
   

    ------------------------------ D_CNT_CATALOGO_DETALLE_6 --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_CATALOGO_DETALLE_6'', 
						  ''CATALOGO_DETALLE_6_ID NUMBER(16,0) NOT NULL,
                            CATALOGO_DETALLE_6_DESC VARCHAR2(50 CHAR),
                            CATALOGO_DETALLE_6_DESC_2 VARCHAR2(250 CHAR),
                            CATALOGO_DETALLE_5_ID NUMBER(16,0),
                            PRIMARY KEY (CATALOGO_DETALLE_6_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_CATALOGO_DETALLE_6');
   

    ------------------------------ D_CNT_CATALOGO_DETALLE_5 --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_CATALOGO_DETALLE_5'', 
						  ''CATALOGO_DETALLE_5_ID NUMBER(16,0) NOT NULL,
                            CATALOGO_DETALLE_5_DESC VARCHAR2(50 CHAR),
                            CATALOGO_DETALLE_5_DESC_2 VARCHAR2(250 CHAR),
                            CATALOGO_DETALLE_4_ID NUMBER(16,0),
                            PRIMARY KEY (CATALOGO_DETALLE_5_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_CATALOGO_DETALLE_5');
   

    ------------------------------ D_CNT_CATALOGO_DETALLE_4 --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_CATALOGO_DETALLE_4'', 
						  ''CATALOGO_DETALLE_4_ID NUMBER(16,0) NOT NULL,
                            CATALOGO_DETALLE_4_DESC VARCHAR2(50 CHAR),
                            CATALOGO_DETALLE_4_DESC_2 VARCHAR2(250 CHAR),
                            CATALOGO_DETALLE_3_ID NUMBER(16,0),
                            PRIMARY KEY (CATALOGO_DETALLE_4_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_CATALOGO_DETALLE_4');
   

    ------------------------------ D_CNT_CATALOGO_DETALLE_3 --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_CATALOGO_DETALLE_3'', 
						  ''CATALOGO_DETALLE_3_ID NUMBER(16,0) NOT NULL,
                            CATALOGO_DETALLE_3_DESC VARCHAR2(50 CHAR),
                            CATALOGO_DETALLE_3_DESC_2 VARCHAR2(250 CHAR),
                            CATALOGO_DETALLE_2_ID NUMBER(16,0),
                            PRIMARY KEY (CATALOGO_DETALLE_3_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_CATALOGO_DETALLE_3');
   

    ------------------------------ D_CNT_CATALOGO_DETALLE_2 --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_CATALOGO_DETALLE_2'', 
						  ''CATALOGO_DETALLE_2_ID NUMBER(16,0) NOT NULL,
                            CATALOGO_DETALLE_2_DESC VARCHAR2(50 CHAR),
                            CATALOGO_DETALLE_2_DESC_2 VARCHAR2(250 CHAR),
                            CATALOGO_DETALLE_1_ID NUMBER(16,0),
                            PRIMARY KEY (CATALOGO_DETALLE_2_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_CATALOGO_DETALLE_2');
   

    ------------------------------ D_CNT_CATALOGO_DETALLE_1 --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_CATALOGO_DETALLE_1'', 
						  ''CATALOGO_DETALLE_1_ID NUMBER(16,0) NOT NULL,
                            CATALOGO_DETALLE_1_DESC VARCHAR2(50 CHAR),
                            CATALOGO_DETALLE_1_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (CATALOGO_DETALLE_1_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_CATALOGO_DETALLE_1');
   

   ------------------------------ D_CNT_NACIONALIDAD_TITULAR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_NACIONALIDAD_TITULAR'', 
						  ''NACIONALIDAD_TITULAR_ID NUMBER(16,0) NOT NULL,
                            NACIONALIDAD_TITULAR_DESC VARCHAR2(50 CHAR),
                            NACIONALIDAD_TITULAR_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (NACIONALIDAD_TITULAR_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_NACIONALIDAD_TITULAR');
   

   ------------------------------ D_CNT_POLITICA_TITULAR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_POLITICA_TITULAR'', 
						  ''POLITICA_TITULAR_ID NUMBER(16,0) NOT NULL,
                            POLITICA_TITULAR_DESC VARCHAR2(50 CHAR),
                            POLITICA_TITULAR_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (POLITICA_TITULAR_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_POLITICA_TITULAR');
   

   ------------------------------ D_CNT_SEGMENTO_TITULAR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_SEGMENTO_TITULAR'', 
						  ''SEGMENTO_TITULAR_ID NUMBER(16,0) NOT NULL,
                            SEGMENTO_TITULAR_DESC VARCHAR2(50 CHAR),
                            SEGMENTO_TITULAR_DESC_2 VARCHAR2(250 CHAR),
                            SEGMENTO_TITULAR_AGR_ID NUMBER(16,0),
                            PRIMARY KEY (SEGMENTO_TITULAR_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_SEGMENTO_TITULAR');
   

 ------------------------------ D_CNT_SEXO_TITULAR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_SEXO_TITULAR'', 
						  ''SEXO_TITULAR_ID NUMBER(16,0) NOT NULL,
                            SEXO_TITULAR_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (SEXO_TITULAR_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_SEXO_TITULAR');
   

    ------------------------------ D_CNT_SITUACION --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_SITUACION'', 
						  ''SITUACION_CONTRATO_ID NUMBER(16,0) NOT NULL,
                            SITUACION_CONTRATO_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (SITUACION_CONTRATO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_SITUACION');
   

    ------------------------------ D_CNT_SITUACION_DETALLE--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_SITUACION_DETALLE'', 
						  ''SITUACION_CNT_DETALLE_ID NUMBER(16,0) NOT NULL,
                            SITUACION_CNT_DETALLE_DESC VARCHAR2(250 CHAR),
                            SITUACION_CONTRATO_ID NUMBER(16,0),
                            PRIMARY KEY (SITUACION_CNT_DETALLE_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_SITUACION_DETALLE');
   

    ------------------------------ D_CNT_SITUACION_ANTERIOR--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_SITUACION_ANTERIOR'', 
						  ''SITUACION_ANT_CNT_ID NUMBER(16,0) NOT NULL,
                            SITUACION_ANT_CNT_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (SITUACION_ANT_CNT_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_SITUACION_ANTERIOR');
   

 ------------------------------ D_CNT_SITUACION_ANT_DETALLE--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_SITUACION_ANT_DETALLE'', 
						  ''SITUACION_ANT_CNT_DETALLE_ID NUMBER(16,0) NOT NULL,
                            SITUACION_ANT_CNT_DETALLE_DESC VARCHAR2(50 CHAR),
                            SITUACION_ANT_CNT_ID NUMBER(16,0),
                            PRIMARY KEY (SITUACION_ANT_CNT_DETALLE_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_SITUACION_ANT_DETALLE');
   

    ------------------------------ D_CNT_SITUACION_RESP_PER_ANT -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_SITUACION_RESP_PER_ANT'', 
						  ''SITUACION_RESP_PER_ANT_ID NUMBER(16,0) NOT NULL,
                            SITUACION_RESP_PER_ANT_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (SITUACION_RESP_PER_ANT_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_SITUACION_RESP_PER_ANT');
   

    ------------------------------ D_CNT_TIPO_PERSONA_TITULAR -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_TIPO_PERSONA_TITULAR'', 
						  ''TIPO_PERSONA_TITULAR_ID NUMBER(16,0) NOT NULL,
                            TIPO_PERSONA_TITULAR_DESC VARCHAR2(50 CHAR),
                            TIPO_PERSONA_TITULAR_DESC2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_PERSONA_TITULAR_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_TIPO_PERSONA_TITULAR');
   

    ------------------------------ D_CNT_JUDICIALIZADO -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_JUDICIALIZADO'', 
						  ''CONTRATO_JUDICIALIZADO_ID NUMBER(16,0) NOT NULL,
                            CONTRATO_JUDICIALIZADO_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (CONTRATO_JUDICIALIZADO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_JUDICIALIZADO');
   

    ------------------------------ D_CNT_EST_INSINUACION_CNT -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_EST_INSINUACION_CNT'', 
						  ''ESTADO_INSINUACION_CNT_ID NUMBER(16,0) NOT NULL,
                            ESTADO_INSINUACION_CNT_DESC VARCHAR2(50 CHAR),
                            ESTADO_INSINUACION_CNT_DESC2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (ESTADO_INSINUACION_CNT_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_EST_INSINUACION_CNT');
   

    ------------------------------ D_CNT_CARTERA -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_CARTERA'', 
						  ''CARTERA_CONTRATO_ID NUMBER(16,0) NOT NULL,
                            CARTERA_CONTRATO_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (CARTERA_CONTRATO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_CARTERA');
   

    ------------------------------ D_CNT_T_IRREG_DIAS -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_T_IRREG_DIAS'', 
						  ''T_IRREG_DIAS_ID NUMBER(16,0) NOT NULL,
                            T_IRREG_DIAS_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (T_IRREG_DIAS_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_T_IRREG_DIAS');
   

    ------------------------------ D_CNT_T_IRREG_DIAS_PERIODO_ANT -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_T_IRREG_DIAS_PERIODO_ANT'', 
						  ''T_IRREG_DIAS_PERIODO_ANT_ID NUMBER(16,0) NOT NULL,
                            T_IRREG_DIAS_PERIODO_ANT_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (T_IRREG_DIAS_PERIODO_ANT_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_T_IRREG_DIAS_PERIODO_ANT');
   

    ------------------------------ D_CNT_T_IRREG_FASES -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_T_IRREG_FASES'', 
						  ''T_IRREG_FASES_ID NUMBER(16,0) NOT NULL,
                            T_IRREG_FASES_DESC VARCHAR2(50 CHAR),
                            T_IRREG_FASES_AGR_ID NUMBER(16,0) NOT NULL,
                            PRIMARY KEY (T_IRREG_FASES_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_T_IRREG_FASES');
   

    ------------------------------ D_CNT_T_IRREG_FASES_PER_ANT -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_T_IRREG_FASES_PER_ANT'', 
						  ''T_IRREG_FASES_PER_ANT_ID NUMBER(16,0) NOT NULL,
                            T_IRREG_FASES_PER_ANT_DESC VARCHAR2(50 CHAR),
                            T_IRREG_F_AGR_PER_ANT_ID NUMBER(16,0) NOT NULL,
                            PRIMARY KEY (T_IRREG_FASES_PER_ANT_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_T_IRREG_FASES_PER_ANT');
   

    ------------------------------ D_CNT_T_IRREG_FASES_AGR -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_T_IRREG_FASES_AGR'', 
						  ''T_IRREG_FASES_AGR_ID NUMBER(16,0) NOT NULL,
                            T_IRREG_FASES_AGR_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (T_IRREG_FASES_AGR_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_T_IRREG_FASES__AGR');
   

    ------------------------------ D_CNT_T_IRREG_F_AGR_PER_ANT -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_T_IRREG_F_AGR_PER_ANT'', 
						  ''T_IRREG_F_AGR_PER_ANT_ID NUMBER(16,0) NOT NULL,
                            T_IRREG_F_AGR_PER_ANT_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (T_IRREG_F_AGR_PER_ANT_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_T_IRREG_F_AGR_PER_ANT');
   

    ------------------------------ D_CNT_TD_EN_GESTION_A_COBRO -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_TD_EN_GESTION_A_COBRO'', 
						  ''TD_EN_GESTION_A_COBRO_ID NUMBER(16,0) NOT NULL,
                            TD_EN_GESTION_A_COBRO_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (TD_EN_GESTION_A_COBRO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_TD_EN_GESTION_A_COBRO');
   

    ------------------------------ D_CNT_TD_IRREGULAR_A_COBRO -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_TD_IRREGULAR_A_COBRO'', 
						  ''TD_IRREGULAR_A_COBRO_ID NUMBER(16,0) NOT NULL,
                            TD_IRREGULAR_A_COBRO_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (TD_IRREGULAR_A_COBRO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_TD_IRREGULAR_A_COBRO');
   
    
    ------------------------------ D_CNT_GARANTIA_CONTRATO_AGR -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_GARANTIA_CONTRATO_AGR'', 
						  ''GARANTIA_CONTRATO_AGR_ID NUMBER(16,0) NOT NULL,
                            GARANTIA_CONTRATO_AGR_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (GARANTIA_CONTRATO_AGR_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_GARANTIA_CONTRATO_AGR');
   

    ------------------------------ D_CNT_SEGMENTO_TITULAR_AGR -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_SEGMENTO_TITULAR_AGR'', 
						  ''SEGMENTO_TITULAR_AGR_ID NUMBER(16,0) NOT NULL,
                            SEGMENTO_TITULAR_AGR_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (SEGMENTO_TITULAR_AGR_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_SEGMENTO_TITULAR_AGR');
   

    ------------------------------ D_CNT_RESULTADO_ACTUACION -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_RESULTADO_ACTUACION'', 
						  ''RESULTADO_ACTUACION_CNT_ID NUMBER(16,0) NOT NULL,
                            RESULTADO_ACTUACION_CNT_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (RESULTADO_ACTUACION_CNT_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_RESULTADO_ACTUACION');
   

    ------------------------------ D_CNT_EN_GESTION_RECOBRO -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_EN_GESTION_RECOBRO'', 
						  ''EN_GESTION_RECOBRO_ID NUMBER(16,0) NOT NULL,
                            EN_GESTION_RECOBRO_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (EN_GESTION_RECOBRO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_EN_GESTION_RECOBRO');
   

    ------------------------------ D_CNT_EN_IRREGULAR -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_EN_IRREGULAR'', 
						  ''CONTRATO_EN_IRREGULAR_ID NUMBER(16,0) NOT NULL,
                            CONTRATO_EN_IRREGULAR_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (CONTRATO_EN_IRREGULAR_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_EN_IRREGULAR');
   

    ------------------------------ D_CNT_MODELO_RECOBRO -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_MODELO_RECOBRO'', 
						  ''MODELO_RECOBRO_CONTRATO_ID NUMBER(16,0) NOT NULL,
                            MODELO_RECOBRO_CONTRATO_DESC VARCHAR2(50 CHAR),
                            MODELO_RECOBRO_CONTRATO_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (MODELO_RECOBRO_CONTRATO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_MODELO_RECOBRO');
   

    ------------------------------ D_CNT_PROVEEDOR_RECOBRO -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_PROVEEDOR_RECOBRO'', 
						  ''PROVEEDOR_RECOBRO_CNT_ID NUMBER(16,0) NOT NULL,
                            PROVEEDOR_RECOBRO_CNT_DESC VARCHAR2(50 CHAR),
                            PROVEEDOR_RECOBRO_CNT_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (PROVEEDOR_RECOBRO_CNT_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_PROVEEDOR_RECOBRO');
   

 ------------------------------ D_CNT_CON_DPS -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_CON_DPS'', 
						  ''CONTRATO_CON_DPS_ID NUMBER(16,0) NOT NULL,
                            CONTRATO_CON_DPS_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (CONTRATO_CON_DPS_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_CON_DPS');
   

    ------------------------------ D_CNT_CON_CONTACTO_UTIL -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_CON_CONTACTO_UTIL'', 
						  ''CNT_CON_CONTACTO_UTIL_ID NUMBER(16,0) NOT NULL,
                            CNT_CON_CONTACTO_UTIL_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (CNT_CON_CONTACTO_UTIL_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_CON_CONTACTO_UTIL');
   

    ------------------------------ D_CNT_CON_ACTUACION_RECOBRO -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_CON_ACTUACION_RECOBRO'', 
						  ''CNT_CON_ACTUACION_RECOBRO_ID NUMBER(16,0) NOT NULL,
                            CNT_CON_ACTUACION_RECOBRO_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (CNT_CON_ACTUACION_RECOBRO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_CON_ACTUACION_RECOBRO');
   

    ------------------------------ D_CNT_EST_FIN_INI_CAMP_REC -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_EST_FIN_INI_CAMP_REC'', 
						  ''EST_FIN_INI_CAMP_REC_ID NUMBER(16,0) NOT NULL,
                            EST_FIN_INI_CAMP_REC_DESC VARCHAR2(50 CHAR),
                            EST_FIN_INI_CAMP_REC_DESC2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (EST_FIN_INI_CAMP_REC_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_EST_FIN_INI_CAMP_REC');
   

    ------------------------------ D_CNT_EST_FIN_ANT_INI_CAMP_REC -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_EST_FIN_ANT_INI_CAMP_REC'', 
						  ''EST_FIN_ANT_INI_CAMP_REC_ID NUMBER(16,0) NOT NULL,
                            EST_FIN_ANT_INI_CAMP_REC_DESC VARCHAR2(50 CHAR),
                            EST_FIN_ANT_INI_CAMP_REC_DESC2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (EST_FIN_ANT_INI_CAMP_REC_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_EST_FIN_ANT_INI_CAMP_REC');
   

 ------------------------------ D_CNT_EN_GEST_REC_INI_CAMP_REC -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_EN_GEST_REC_INI_CAMP_REC'', 
						  ''EN_GEST_REC_INI_CAMP_REC_ID NUMBER(16,0) NOT NULL,
                            EN_GEST_REC_INI_CAMP_REC_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (EN_GEST_REC_INI_CAMP_REC_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_EN_GEST_REC_INI_CAMP_REC');
   

    ------------------------------ D_CNT_EN_IRREG_INI_CAMP_REC -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_EN_IRREG_INI_CAMP_REC'', 
						  ''EN_IRREG_INI_CAMP_REC_ID NUMBER(16,0) NOT NULL,
                            EN_IRREG_INI_CAMP_REC_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (EN_IRREG_INI_CAMP_REC_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_EN_IRREG_INI_CAMP_REC');
   

    ------------------------------ D_CNT_MODELO_REC_INI_CAMP_REC -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_MODELO_REC_INI_CAMP_REC'', 
						  ''MODELO_REC_INI_CAMP_REC_ID NUMBER(16,0) NOT NULL,
                            MODELO_REC_INI_CAMP_REC_DESC VARCHAR2(50 CHAR),
                            MODELO_REC_INI_CAMP_REC_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (MODELO_REC_INI_CAMP_REC_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_MODELO_REC_INI_CAMP_REC');
   

    ------------------------------ D_CNT_PROV_REC_INI_CAMP_REC -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_PROV_REC_INI_CAMP_REC'', 
						  ''PROV_REC_INI_CAMP_REC_ID NUMBER(16,0) NOT NULL,
                            PROV_REC_INI_CAMP_REC_DESC VARCHAR2(50 CHAR),
                            PROV_REC_INI_CAMP_REC_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (PROV_REC_INI_CAMP_REC_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_PROV_REC_INI_CAMP_REC');
   

    ------------------------------ D_CNT_T_IRREG_D_INI_CAMP_REC -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_T_IRREG_D_INI_CAMP_REC'', 
						  ''T_IRREG_D_INI_CAMP_REC_ID NUMBER(16,0) NOT NULL,
                            T_IRREG_D_INI_CAMP_REC_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (T_IRREG_D_INI_CAMP_REC_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_T_IRREG_D_INI_CAMP_REC');
   

    ------------------------------ D_CNT_T_IRREG_F_INI_CAMP_REC -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_T_IRREG_F_INI_CAMP_REC'', 
						  ''T_IRREG_F_INI_CAMP_REC_ID NUMBER(16,0) NOT NULL,
                            T_IRREG_F_INI_CAMP_REC_DESC VARCHAR2(50 CHAR),
                            T_IRREG_F_AGR_INI_REC_ID NUMBER(16,0),
                            PRIMARY KEY (T_IRREG_F_INI_CAMP_REC_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_T_IRREG_F_INI_CAMP_REC');
   

    ------------------------------ D_CNT_T_IRREG_F_AGR_INI_REC -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_T_IRREG_F_AGR_INI_REC'', 
						  ''T_IRREG_F_AGR_INI_REC_ID NUMBER(16,0) NOT NULL,
                            T_IRREG_F_AGR_INI_REC_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (T_IRREG_F_AGR_INI_REC_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_T_IRREG_F_AGR_INI_REC');
   

    ------------------------------ D_CNT_EN_GESTION_ESPEC -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_EN_GESTION_ESPEC'', 
						  ''EN_GESTION_ESPECIALIZADA_ID NUMBER(16,0) NOT NULL,
                            EN_GESTION_ESPECIALIZADA_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (EN_GESTION_ESPECIALIZADA_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_EN_GESTION_ESPEC');
   

    ------------------------------ D_CNT_CON_PREVISION -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_CON_PREVISION'', 
						  ''CONTRATO_CON_PREVISION_ID NUMBER(16,0) NOT NULL,
                            CONTRATO_CON_PREVISION_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (CONTRATO_CON_PREVISION_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_CON_PREVISION');
   

    ------------------------------ D_CNT_CON_PREVISION_REVISADA -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_CON_PREVISION_REVISADA'', 
						  ''CNT_CON_PREV_REVISADA_ID NUMBER(16,0) NOT NULL,
                            CNT_CON_PREV_REVISADA_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (CNT_CON_PREV_REVISADA_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_CON_PREVISION_REVISADA');
   

    ------------------------------ D_CNT_TIPO_PREVISION -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_TIPO_PREVISION'', 
						  ''TIPO_PREVISION_ID NUMBER(16,0) NOT NULL,
                            TIPO_PREVISION_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (TIPO_PREVISION_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_TIPO_PREVISION');
   

    ------------------------------ D_CNT_TIPO_PREV_SITUACION_INICIAL -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_PREV_SITUACION_INICIAL'', 
						  ''PREV_SITUACION_INICIAL_ID NUMBER(16,0) NOT NULL,
                            PREV_SITUACION_INICIAL_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (PREV_SITUACION_INICIAL_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_PREV_SITUACION_INICIAL');
   

    ------------------------------ D_CNT_PREV_SITUACION_AUTO -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_PREV_SITUACION_AUTO'', 
						  ''PREV_SITUACION_AUTO_ID NUMBER(16,0) NOT NULL,
                            PREV_SITUACION_AUTO_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (PREV_SITUACION_AUTO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_PREV_SITUACION_AUTO');
   

    ------------------------------ D_CNT_PREV_SITUACION_MANUAL -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_PREV_SITUACION_MANUAL'', 
						  ''PREV_SITUACION_MANUAL_ID NUMBER(16,0) NOT NULL,
                            PREV_SITUACION_MANUAL_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (PREV_SITUACION_MANUAL_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_PREV_SITUACION_MANUAL');
   

    ------------------------------ D_CNT_PREV_SITUACION_FINAL -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_PREV_SITUACION_FINAL'', 
						  ''PREV_SITUACION_FINAL_ID NUMBER(16,0) NOT NULL,
                            PREV_SITUACION_FINAL_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (PREV_SITUACION_FINAL_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_PREV_SITUACION_FINAL');
   

------------------------------ D_CNT_MOTIVO_PREVISION -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_MOTIVO_PREVISION'', 
						  ''MOTIVO_PREVISION_ID NUMBER(16,0) NOT NULL,
                            MOTIVO_PREVISION_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (MOTIVO_PREVISION_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_MOTIVO_PREVISION');
   

------------------------------ D_CNT_SITUACION_ESPECIALIZADA -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_SITUACION_ESPECIALIZADA'', 
						  ''SITUACION_ESPECIALIZADA_ID NUMBER(16,0) NOT NULL,
                            SITUACION_ESPECIALIZADA_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (SITUACION_ESPECIALIZADA_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_SITUACION_ESPECIALIZADA');
   

    ------------------------------ D_CNT_GESTOR_ESPECIALIZADA -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_GESTOR_ESPECIALIZADA'', 
						  ''GESTOR_ESPECIALIZADA_ID NUMBER(16,0) NOT NULL,
                            GESTOR_ESPECIALIZADA_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (GESTOR_ESPECIALIZADA_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_GESTOR_ESPECIALIZADA');
   

    ------------------------------ D_CNT_SUPERVISOR_N1_ESPEC -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_SUPERVISOR_N1_ESPEC'', 
						  ''SUPERVISOR_N1_ESPEC_ID NUMBER(16,0) NOT NULL,
                            SUPERVISOR_N1_ESPEC_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (SUPERVISOR_N1_ESPEC_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_SUPERVISOR_N1_ESPEC');
   

------------------------------ D_CNT_SUPERVISOR_N2_ESPEC -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_SUPERVISOR_N2_ESPEC'', 
						  ''SUPERVISOR_N2_ESPEC_ID NUMBER(16,0) NOT NULL,
                            SUPERVISOR_N2_ESPEC_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (SUPERVISOR_N2_ESPEC_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_SUPERVISOR_N2_ESPEC');
   

    ------------------------------ D_CNT_SUPERVISOR_N3_ESPEC -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_SUPERVISOR_N3_ESPEC'', 
						  ''SUPERVISOR_N3_ESPEC_ID NUMBER(16,0) NOT NULL,
                            SUPERVISOR_N3_ESPEC_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (SUPERVISOR_N3_ESPEC_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_SUPERVISOR_N3_ESPEC');
   

    ------------------------------ D_CNT_EN_CARTERA_ESTUDIO -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_EN_CARTERA_ESTUDIO'', 
						  ''EN_CARTERA_ESTUDIO_ID NUMBER(16,0) NOT NULL,
                            EN_CARTERA_ESTUDIO_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (EN_CARTERA_ESTUDIO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_EN_CARTERA_ESTUDIO');
   

    ------------------------------ D_CNT_MODELO_GESTION_CARTERA -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_MODELO_GESTION_CARTERA'', 
						  ''MODELO_GESTION_CARTERA_ID NUMBER(16,0) NOT NULL,
                            MODELO_GESTION_CARTERA_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (MODELO_GESTION_CARTERA_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_MODELO_GESTION_CARTERA');
   

    ------------------------------ D_CNT_UNIDAD_GESTION_CARTERA -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_UNIDAD_GESTION_CARTERA'', 
						  ''UNIDAD_GESTION_CARTERA_ID NUMBER(16,0) NOT NULL,
                            UNIDAD_GESTION_CARTERA_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (UNIDAD_GESTION_CARTERA_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_UNIDAD_GESTION_CARTERA');
   

    ------------------------------ D_CNT_CON_CAPITAL_FALLIDO -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_CON_CAPITAL_FALLIDO'', 
						  ''CNT_CON_CAPITAL_FALLIDO_ID NUMBER(16,0) NOT NULL,
                            CNT_CON_CAPITAL_FALLIDO_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (CNT_CON_CAPITAL_FALLIDO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_CON_CAPITAL_FALLIDO');
   

    ------------------------------ D_CNT_TIPO_GESTION -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_TIPO_GESTION'', 
						  ''TIPO_GESTION_CONTRATO_ID NUMBER(16,0) NOT NULL,
                            TIPO_GESTION_CONTRATO_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (TIPO_GESTION_CONTRATO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_TIPO_GESTION');
   

    ------------------------------ D_CNT_ESQUEMA -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_ESQUEMA'', 
						  ''ESQUEMA_CONTRATO_ID NUMBER(16,0) NOT NULL,
                            ESQUEMA_CONTRATO_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (ESQUEMA_CONTRATO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_ESQUEMA');
   

    ------------------------------ D_CNT_CARTERA_EXPEDIENTE -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_CARTERA_EXPEDIENTE'', 
						  ''CARTERA_EXPEDIENTE_CNT_ID NUMBER(16,0) NOT NULL,
                            CARTERA_EXPEDIENTE_CNT_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (CARTERA_EXPEDIENTE_CNT_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_CARTERA_EXPEDIENTE');
   

    ------------------------------ D_CNT_SUBCARTERA_EXPEDIENTE -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_SUBCARTERA_EXPEDIENTE'', 
						  ''SUBCARTERA_EXPEDIENTE_CNT_ID NUMBER(16,0) NOT NULL,
                            SUBCARTERA_EXPEDIENTE_CNT_DESC VARCHAR2(50 CHAR),
                            CARTERA_EXPEDIENTE_CNT_ID NUMBER(16,0) NULL,
                            PRIMARY KEY (SUBCARTERA_EXPEDIENTE_CNT_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_SUBCARTERA_EXPEDIENTE');
   

    ------------------------------ D_CNT_AGENCIA -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_AGENCIA'', 
						  ''AGENCIA_CONTRATO_ID NUMBER(16,0) NOT NULL,
                            AGENCIA_CONTRATO_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (AGENCIA_CONTRATO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_AGENCIA');
   

    ------------------------------ D_CNT_TIPO_SALIDA_EXPEDIENTE -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_TIPO_SALIDA_EXPEDIENTE'', 
						  ''TIPO_SALIDA_EXP_CNT_ID NUMBER(16,0) NOT NULL,
                            TIPO_SALIDA_EXP_CNT_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (TIPO_SALIDA_EXP_CNT_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_TIPO_SALIDA_EXPEDIENTE');
   

------------------------------ D_CNT_MOTIVO_SALIDA_EXP -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_MOTIVO_SALIDA_EXP'', 
						  ''MOTIVO_SALIDA_EXP_CNT_ID NUMBER(16,0) NOT NULL,
                            MOTIVO_SALIDA_EXP_CNT_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (MOTIVO_SALIDA_EXP_CNT_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_MOTIVO_SALIDA_EXP');
   

    ------------------------------ D_CNT_TIPO_INCIDENCIA_EXP -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_TIPO_INCIDENCIA_EXP'', 
						  ''TIPO_INCIDENCIA_EXP_CNT_ID NUMBER(16,0) NOT NULL,
                            TIPO_INCIDENCIA_EXP_CNT_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_INCIDENCIA_EXP_CNT_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_TIPO_INCIDENCIA_EXP');
   

    ------------------------------ D_CNT_ESTADO_INCIDENCIA_EXP -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_ESTADO_INCIDENCIA_EXP'', 
						  ''ESTADO_INCIDENCIA_EXP_CNT_ID NUMBER(16,0) NOT NULL,
                            ESTADO_INCIDENCIA_EXP_CNT_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (ESTADO_INCIDENCIA_EXP_CNT_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_ESTADO_INCIDENCIA_EXP');
   

    ------------------------------ D_CNT_T_SALDO_TOTAL -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_T_SALDO_TOTAL'', 
						  ''T_SALDO_TOTAL_CNT_ID NUMBER(16,0) NOT NULL,
                            T_SALDO_TOTAL_CNT_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (T_SALDO_TOTAL_CNT_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_T_SALDO_TOTAL');
   

    ------------------------------ D_CNT_T_SALDO_IRREGULAR -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_T_SALDO_IRREGULAR '', 
						  ''T_SALDO_IRREGULAR_CNT_ID NUMBER(16,0) NOT NULL,
                            T_SALDO_IRREGULAR_CNT_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (T_SALDO_IRREGULAR_CNT_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_T_SALDO_IRREGULAR');
   

    ------------------------------ D_CNT_T_DEUDA_IRREGULAR -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_T_DEUDA_IRREGULAR'', 
						  ''T_DEUDA_IRREGULAR_CNT_ID NUMBER(16,0) NOT NULL,
                            T_DEUDA_IRREGULAR_CNT_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (T_DEUDA_IRREGULAR_CNT_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_T_DEUDA_IRREGULAR');
   

    ------------------------------ D_CNT_TIPO_COBRO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_TIPO_COBRO'', 
						  ''TIPO_COBRO_ID NUMBER(16,0) NOT NULL,
                            TIPO_COBRO_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_COBRO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_TIPO_COBRO');
   

    ------------------------------ D_CNT_TIPO_COBRO_DETALLE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_TIPO_COBRO_DETALLE'', 
						  ''TIPO_COBRO_DET_ID NUMBER(16,0) NOT NULL,
                            TIPO_COBRO_DET_DESC VARCHAR2(250 CHAR),
                            TIPO_COBRO_ID NUMBER(16,0) NULL,
                            PRIMARY KEY (TIPO_COBRO_DET_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_TIPO_COBRO_DETALLE');
   
    
    ------------------------------ D_CNT_COBRO_FACTURADO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_COBRO_FACTURADO'', 
						  ''COBRO_FACTURADO_ID NUMBER(16,0) NOT NULL,
                            COBRO_FACTURADO_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (COBRO_FACTURADO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_COBRO_FACTURADO');
   

    ------------------------------ D_CNT_REMESA_FACTURA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_REMESA_FACTURA'', 
						  ''REMESA_FACTURA_ID NUMBER(16,0) NOT NULL,
                            REMESA_FACTURA_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (REMESA_FACTURA_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_REMESA_FACTURA');
   

    ------------------------------ D_CNT_CLASIFICACION --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_CLASIFICACION'', 
						  ''CLASIFICACION_CNT_ID NUMBER(16,0) NOT NULL,
                            CLASIFICACION_CNT_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (CLASIFICACION_CNT_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_CLASIFICACION');
   

    ------------------------------ D_CNT_SEGMENTO_CARTERA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_SEGMENTO_CARTERA'', 
						  ''SEGMENTO_CARTERA_ID NUMBER(16,0) NOT NULL,
                            SEGMENTO_CARTERA_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (SEGMENTO_CARTERA_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_SEGMENTO_CARTERA');
   
    
    ------------------------------ D_CNT_ENVIADO_AGENCIA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_ENVIADO_AGENCIA'', 
						  ''ENVIADO_AGENCIA_CNT_ID NUMBER(16,0) NOT NULL,
                            ENVIADO_AGENCIA_CNT_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (ENVIADO_AGENCIA_CNT_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_ENVIADO_AGENCIA');
   
    
    ------------------------------ D_CNT_ESQUEMA_COBRO -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_ESQUEMA_COBRO'', 
						  ''ESQUEMA_COBRO_ID NUMBER(16,0) NOT NULL,
                            ESQUEMA_COBRO_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (ESQUEMA_COBRO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_ESQUEMA_COBRO');
   

    ------------------------------ D_CNT_CARTERA_COBRO -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_CARTERA_COBRO'', 
						  ''CARTERA_COBRO_ID NUMBER(16,0) NOT NULL,
                            CARTERA_COBRO_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (CARTERA_COBRO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_CARTERA_COBRO');
   

    ------------------------------ D_CNT_SUBCARTERA_COBRO -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_SUBCARTERA_COBRO'', 
						  ''SUBCARTERA_COBRO_ID NUMBER(16,0) NOT NULL,
                            SUBCARTERA_COBRO_DESC VARCHAR2(250 CHAR),
                            CARTERA_COBRO_ID NUMBER(16,0) NULL,
                            PRIMARY KEY (SUBCARTERA_COBRO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_SUBCARTERA_COBRO');
   

    ------------------------------ D_CNT_AGENCIA_COBRO -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_AGENCIA_COBRO'', 
						  ''AGENCIA_COBRO_ID NUMBER(16,0) NOT NULL,
                            AGENCIA_COBRO_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (AGENCIA_COBRO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_AGENCIA_COBRO');
   
	
    ------------------------------ D_CNT_TIPO_PRODUCTO_COBRO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_TIPO_PRODUCTO_COBRO'', 
						  ''TIPO_PRODUCTO_COBRO_ID NUMBER(16,0) NOT NULL,
                            TIPO_PRODUCTO_COBRO_DESC VARCHAR2(50 CHAR),
                            TIPO_PRODUCTO_COBRO_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_PRODUCTO_COBRO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_TIPO_PRODUCTO_COBRO');
   
	
	
    ------------------------------ D_CNT_GARANTIA_COBRO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_GARANTIA_COBRO'', 
						  ''GARANTIA_COBRO_ID NUMBER(16,0) NOT NULL,
                            GARANTIA_COBRO_DESC VARCHAR2(50 CHAR),
                            GARANTIA_COBRO_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (GARANTIA_COBRO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_GARANTIA_COBRO');
   
	

    ------------------------------ D_CNT_SEGMENTO_CARTERA_COBRO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_SEGMENTO_CARTERA_COBRO'', 
						  ''SEGMENTO_CARTERA_COBRO_ID NUMBER(16,0) NOT NULL,
                            SEGMENTO_CARTERA_COBRO_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (SEGMENTO_CARTERA_COBRO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_SEGMENTO_CARTERA_COBRO');
   
	
    ------------------------------ D_CNT_TD_IRREG_COBRO -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_TD_IRREG_COBRO'', 
						  ''TD_IRREG_COBRO_ID NUMBER(16,0) NOT NULL,
                            TD_IRREG_COBRO_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (TD_IRREG_COBRO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_TD_IRREG_COBRO');
   
    
    ------------------------------ D_CNT_T_DEUDA_IRREGULAR_COBRO -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_T_DEUDA_IRREGULAR_COBRO'', 
						  ''T_DEUDA_IRREGULAR_COBRO_ID NUMBER(16,0) NOT NULL,
                            T_DEUDA_IRREGULAR_COBRO_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (T_DEUDA_IRREGULAR_COBRO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_T_DEUDA_IRREGULAR_COBRO');
   
    
    ------------------------------ D_CNT_ENVIADO_AGENCIA_COBRO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_ENVIADO_AGENCIA_COBRO'', 
						  ''ENVIADO_AGENCIA_COBRO_ID NUMBER(16,0) NOT NULL,
                            ENVIADO_AGENCIA_COBRO_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (ENVIADO_AGENCIA_COBRO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_ENVIADO_AGENCIA_COBRO');
   

    ------------------------------ D_CNT_FACTURA_COBRO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_FACTURA_COBRO'', 
						  ''FACTURA_COBRO_ID NUMBER(16,0) NOT NULL,
                            FACTURA_COBRO_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (FACTURA_COBRO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_FACTURA_COBRO');
   
    
    ------------------------------ D_CNT_MOTIVO_BAJA_CR -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_MOTIVO_BAJA_CR'', 
						  ''MOTIVO_BAJA_CR_ID NUMBER(16,0) NOT NULL,
                            MOTIVO_BAJA_CR_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (MOTIVO_BAJA_CR_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_MOTIVO_BAJA_CR');
   
    
    
    ------------------------------ D_CNT_ESQUEMA_CR -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_ESQUEMA_CR'', 
						  ''ESQUEMA_CR_ID NUMBER(16,0) NOT NULL,
                            ESQUEMA_CR_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (ESQUEMA_CR_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_ESQUEMA_CR');
   

    ------------------------------ D_CNT_CARTERA_CR -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_CARTERA_CR'', 
						  ''CARTERA_CR_ID NUMBER(16,0) NOT NULL,
                            CARTERA_CR_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (CARTERA_CR_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_CARTERA_CR');
   

    ------------------------------ D_CNT_SUBCARTERA_CR -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_SUBCARTERA_CR'', 
						  ''SUBCARTERA_CR_ID NUMBER(16,0) NOT NULL,
                            SUBCARTERA_CR_DESC VARCHAR2(250 CHAR),
                            CARTERA_CR_ID NUMBER(16,0) NULL,
                            PRIMARY KEY (SUBCARTERA_CR_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_SUBCARTERA_CR');
   

    ------------------------------ D_CNT_AGENCIA_CR -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_AGENCIA_CR'', 
						  ''AGENCIA_CR_ID NUMBER(16,0) NOT NULL,
                            AGENCIA_CR_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (AGENCIA_CR_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_AGENCIA_CR');
   

    ------------------------------ D_CNT_SEGMENTO_CARTERA_CR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_SEGMENTO_CARTERA_CR'', 
						  ''SEGMENTO_CARTERA_CR_ID NUMBER(16,0) NOT NULL,
                            SEGMENTO_CARTERA_CR_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (SEGMENTO_CARTERA_CR_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_SEGMENTO_CARTERA_CR');
   
    
    ------------------------------ D_CNT_ENVIADO_AGENCIA_CR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_ENVIADO_AGENCIA_CR'', 
						  ''ENVIADO_AGENCIA_CR_ID NUMBER(16,0) NOT NULL,
                            ENVIADO_AGENCIA_CR_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (ENVIADO_AGENCIA_CR_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_ENVIADO_AGENCIA_CR');
   
    
    
    ------------------------------ D_CNT_ESTADO_ACUERDO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_ESTADO_ACUERDO'', 
						  ''ESTADO_ACUERDO_ID NUMBER(16,0) NOT NULL,
                            ESTADO_ACUERDO_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (ESTADO_ACUERDO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_ESTADO_ACUERDO');
   
    
    ------------------------------ D_CNT_SOLICITANTE_ACUERDO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_SOLICITANTE_ACUERDO'', 
						  ''SOLICITANTE_ACUERDO_ID NUMBER(16,0) NOT NULL,
                            SOLICITANTE_ACUERDO_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (SOLICITANTE_ACUERDO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_SOLICITANTE_ACUERDO');
   

    ------------------------------ D_CNT_TIPO_ACUERDO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_TIPO_ACUERDO'', 
						  ''TIPO_ACUERDO_ID NUMBER(16,0) NOT NULL,
                            TIPO_ACUERDO_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_ACUERDO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_TIPO_ACUERDO');
   

    ------------------------------ D_CNT_ESQUEMA_ACUERDO -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_ESQUEMA_ACUERDO'', 
						  ''ESQUEMA_ACUERDO_ID NUMBER(16,0) NOT NULL,
                            ESQUEMA_ACUERDO_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (ESQUEMA_ACUERDO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_ESQUEMA_ACUERDO');
   

    ------------------------------ D_CNT_CARTERA_ACUERDO -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_CARTERA_ACUERDO'', 
						  ''CARTERA_ACUERDO_ID NUMBER(16,0) NOT NULL,
                            CARTERA_ACUERDO_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (CARTERA_ACUERDO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_CARTERA_ACUERDO');
   

    ------------------------------ D_CNT_SUBCARTERA_ACUERDO -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_SUBCARTERA_ACUERDO'', 
						  ''SUBCARTERA_ACUERDO_ID NUMBER(16,0) NOT NULL,
                            SUBCARTERA_ACUERDO_DESC VARCHAR2(250 CHAR),
                            CARTERA_ACUERDO_ID NUMBER(16,0) NULL,
                            PRIMARY KEY (SUBCARTERA_ACUERDO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_SUBCARTERA_ACUERDO');
   

    ------------------------------ D_CNT_AGENCIA_ACUERDO -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_AGENCIA_ACUERDO'', 
						  ''AGENCIA_ACUERDO_ID NUMBER(16,0) NOT NULL,
                            AGENCIA_ACUERDO_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (AGENCIA_ACUERDO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_AGENCIA_ACUERDO');
   
    
    ------------------------------ D_CNT_ENVIADO_AGENCIA_ACUERDO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_ENVIADO_AGENCIA_ACUERDO'', 
						  ''ENVIADO_AGENCIA_ACUERDO_ID NUMBER(16,0) NOT NULL,
                            ENVIADO_AGENCIA_ACUERDO_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (ENVIADO_AGENCIA_ACUERDO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_ENVIADO_AGENCIA_ACUERDO');
   

    ------------------------------ D_CNT_TIPO_INCIDENCIA -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_TIPO_INCIDENCIA'', 
						  ''TIPO_INCIDENCIA_ID NUMBER(16,0) NOT NULL,
                            TIPO_INCIDENCIA_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_INCIDENCIA_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_TIPO_INCIDENCIA');
   
    
    ------------------------------ D_CNT_SITUACION_INCIDENCIA -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_SITUACION_INCIDENCIA'', 
						  ''SITUACION_INCIDENCIA_ID NUMBER(16,0) NOT NULL,
                            SITUACION_INCIDENCIA_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (SITUACION_INCIDENCIA_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_SITUACION_INCIDENCIA');
   
    
    ------------------------------ D_CNT_ESQUEMA_INCIDENCIA -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_ESQUEMA_INCIDENCIA'', 
						  ''ESQUEMA_INCIDENCIA_ID NUMBER(16,0) NOT NULL,
                            ESQUEMA_INCIDENCIA_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (ESQUEMA_INCIDENCIA_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_ESQUEMA_INCIDENCIA');
   

    ------------------------------ D_CNT_CARTERA_INCIDENCIA -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_CARTERA_INCIDENCIA'', 
						  ''CARTERA_INCIDENCIA_ID NUMBER(16,0) NOT NULL,
                            CARTERA_INCIDENCIA_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (CARTERA_INCIDENCIA_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_CARTERA_INCIDENCIA');
   

    ------------------------------ D_CNT_SUBCARTERA_INCIDENCIA -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_SUBCARTERA_INCIDENCIA'', 
						  ''SUBCARTERA_INCIDENCIA_ID NUMBER(16,0) NOT NULL,
                            SUBCARTERA_INCIDENCIA_DESC VARCHAR2(250 CHAR),
                            CARTERA_INCIDENCIA_ID NUMBER(16,0) NULL,
                            PRIMARY KEY (SUBCARTERA_INCIDENCIA_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_SUBCARTERA_INCIDENCIA');
   

    ------------------------------ D_CNT_AGENCIA_INCIDENCIA -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_AGENCIA_INCIDENCIA'', 
						  ''AGENCIA_INCIDENCIA_ID NUMBER(16,0) NOT NULL,
                            AGENCIA_INCIDENCIA_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (AGENCIA_INCIDENCIA_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_AGENCIA_INCIDENCIA');
   
    
    ------------------------------ D_CNT_ENVIADO_AGENCIA_INCI --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_ENVIADO_AGENCIA_INCI'', 
						  ''ENVIADO_AGENCIA_INCI_ID NUMBER(16,0) NOT NULL,
                            ENVIADO_AGENCIA_INCI_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (ENVIADO_AGENCIA_INCI_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_ENVIADO_AGENCIA_INCI');
   

    ------------------------------ D_CNT_ESQUEMA_ER -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_ESQUEMA_ER'', 
						  ''ESQUEMA_ER_ID NUMBER(16,0) NOT NULL,
                            ESQUEMA_ER_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (ESQUEMA_ER_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_ESQUEMA_ER');
   

    ------------------------------ D_CNT_CARTERA_ER -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_CARTERA_ER '', 
						  ''CARTERA_ER_ID NUMBER(16,0) NOT NULL,
                            CARTERA_ER_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (CARTERA_ER_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_CARTERA_ER');
   

    ------------------------------ D_CNT_SUBCARTERA_ER -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_SUBCARTERA_ER'', 
						  ''SUBCARTERA_ER_ID NUMBER(16,0) NOT NULL,
                            SUBCARTERA_ER_DESC VARCHAR2(250 CHAR),
                            CARTERA_ER_ID NUMBER(16,0) NULL,
                            PRIMARY KEY (SUBCARTERA_ER_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_SUBCARTERA_ER');
   

    ------------------------------ D_CNT_AGENCIA_ER -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_AGENCIA_ER '', 
						  ''AGENCIA_ER_ID NUMBER(16,0) NOT NULL,
                            AGENCIA_ER_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (AGENCIA_ER_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_AGENCIA_ER');
   

	            ------------------------------ D_CNT_TRAMO_RIESGO -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_TRAMO_RIESGO'', 
						  ''TRAMO_RIESGO_CNT_ID NUMBER(16,0) NOT NULL,
                            TRAMO_RIESGO_CNT_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (TRAMO_RIESGO_CNT_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_TRAMO_RIESGO');
   
	
	  ------------------------------ D_CNT_CALIF_FINAL_CREDITO --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_CALIF_FINAL_CREDITO'', 
						  ''CALIFICACION_FINAL_ID NUMBER(16,0) NOT NULL,
                            CALIFICACION_FINAL_DESC VARCHAR2(250),
                         PRIMARY KEY (CALIFICACION_FINAL_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
						 
    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_CALIF_FINAL_CREDITO');
   
	
	
	 ------------------------------ D_CNT_CALIF_FINAL_CREDITO_INSI --------------------------
         V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_CALIF_FINAL_CREDITO_INSI'', 
						  ''CALIF_FINAL_CREDITO_ID NUMBER(16,0) NOT NULL,
                            CALIF_FINAL_CREDITO_DESC VARCHAR2(250),
                         PRIMARY KEY (CALIF_FINAL_CREDITO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
						 
       DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_CALIF_FINAL_CREDITO_INSI');
   






  ------------------------------ D_CNT_CALIF_INICIAL_CREDITO --------------------------
         V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_CALIF_INICIAL_CREDITO'', 
						  ''CALIFICACION_INICIAL_ID NUMBER(16,0) NOT NULL,
                            CALIFICACION_INICIAL_DESC VARCHAR2(250),
                         PRIMARY KEY (CALIFICACION_INICIAL_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
       DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_CALIF_INICIAL_CREDITO');
   



     
    ------------------------------ D_CNT_CALIF_GESTOR_CREDITO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_CALIF_GESTOR_CREDITO'', 
						  ''CALIFICACION_GESTOR_ID NUMBER(16,0) NOT NULL,
                            CALIFICACION_GESTOR_DESC VARCHAR2(250),
                         PRIMARY KEY (CALIFICACION_GESTOR_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_CALIF_GESTOR_CREDITO');
   





 ------------------------------ D_CNT_ESTADO_INSI_CREDITO --------------------------
        V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_ESTADO_INSI_CREDITO'', 
						  ''ESTADO_INSI_CREDITO_ID NUMBER(16,0) NOT NULL,
                            ESTADO_INSI_CREDITO_DESC VARCHAR2(250),
                         PRIMARY KEY (ESTADO_INSI_CREDITO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
       DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_ESTADO_INSI_CREDITO');
   






  ----------------------------- D_CNT_DESPACHO_GESTOR_CREDITO --------------------------
         V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_DESPACHO_GESTOR_CREDITO'', 
						  ''DESPACHO_GESTOR_CREDITO_ID NUMBER(16,0) NOT NULL,
                            DESPACHO_GESTOR_CREDITO_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (DESPACHO_GESTOR_CREDITO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
       DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_DESPACHO_GESTOR_CREDITO');
   




 ------------------------------ D_CNT_GESTOR_CREDITO --------------------------
         V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_GESTOR_CREDITO'', 
						  ''GESTOR_CREDITO_ID NUMBER(16,0) NOT NULL,
                            GESTOR_CREDITO_NOMBRE_COMPLETO VARCHAR2(250),
                            GESTOR_CREDITO_NOMBRE VARCHAR2(250),
                            GESTOR_CREDITO_APELLIDO1 VARCHAR2(250),
                            GESTOR_CREDITO_APELLIDO2 VARCHAR2(250),
                            DESPACHO_GESTOR_CREDITO_ID NUMBER(16,0),
                            PRIMARY KEY (GESTOR_CREDITO_ID,DESPACHO_GESTOR_CREDITO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
       DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_GESTOR_CREDITO');
   




    ------------------------------ D_CNT_RESULTADO_GESTION --------------------------
         V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_RESULTADO_GESTION'', 
						  ''RESULTADO_GESTION_ID NUMBER(16,0) NOT NULL,
                            RESULTADO_GESTION_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (RESULTADO_GESTION_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
       DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_RESULTADO_GESTION');
   






    ------------------------------ D_CNT_TIPO_ACCION --------------------------
         V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_TIPO_ACCION'', 
						  ''TIPO_ACCION_ID NUMBER(16,0) NOT NULL,
                            TIPO_ACCION_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_ACCION_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
       DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_TIPO_ACCION');
   
	
    ------------------------------ D_CNT_GESTION_ESPECIAL --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_GESTION_ESPECIAL'', 
						  ''GESTION_ESPECIAL_ID NUMBER(16,0) NOT NULL,
                            GESTION_ESPECIAL_COD_ID VARCHAR2(50 CHAR),
                            GESTION_ESPECIAL_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (GESTION_ESPECIAL_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_GESTION_ESPECIAL');
   
	
	  ------------------------------ D_CNT_TA_FECHA_CREACION --------------------------
	  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_TA_FECHA_CREACION'', 
						  ''TA_FECHA_CREACION_ID NUMBER(16,0) NOT NULL,
                            TA_FECHA_CREACION_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (TA_FECHA_CREACION_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_TA_FECHA_CREACION');
   
	
		  ------------------------------ D_CNT_PERIMETRO_GESTION --------------------------
	  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_PERIMETRO_GESTION'', 
						  ''PERIMETRO_GESTION_ID NUMBER(16,0) NOT NULL,
                            PERIMETRO_GESTION_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (PERIMETRO_GESTION_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_PERIMETRO_GESTION');
   

			  ------------------------------  D_CNT_MOTIVO_ALTA_DUDOSO --------------------------
	  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_MOTIVO_ALTA_DUDOSO'', 
						  ''MOTIVO_ALTA_DUDOSO_ID NUMBER(16,0) NOT NULL,
                            MOTIVO_ALTA_DUDOSO_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (MOTIVO_ALTA_DUDOSO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_MOTIVO_ALTA_DUDOSO');
    
	
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;
			  ------------------------------  D_CNT_MOTIVO_BAJA_DUDOSO --------------------------
	  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_MOTIVO_BAJA_DUDOSO'', 
						  ''MOTIVO_BAJA_DUDOSO_ID NUMBER(16,0) NOT NULL,
                            MOTIVO_BAJA_DUDOSO_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (MOTIVO_BAJA_DUDOSO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_MOTIVO_BAJA_DUDOSO');
    
	 
			  ------------------------------  D_CNT_T_ANTIGUEDAD_DEUDA --------------------------
	  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_T_ANTIGUEDAD_DEUDA'', 
						  ''TRAMO_ANTIGUEDAD_DEUDA_ID NUMBER(16,0) NOT NULL,
                            TRAMO_ANTIGUEDAD_DEUDA_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (TRAMO_ANTIGUEDAD_DEUDA_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_T_ANTIGUEDAD_DEUDA');
    
	
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;


    ------------------------------  D_CNT_SIT_CART_DANADA --------------------------
	  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_SIT_CART_DANADA'', 
						  ''SIT_CART_DANADA_ID NUMBER(16,0) NOT NULL,
                            SIT_CART_DANADA_DESC VARCHAR2(250 CHAR),
                            SIT_CART_DANADA_AGR_ID NUMBER(16,0) NULL,
                            PRIMARY KEY (SIT_CART_DANADA_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_SIT_CART_DANADA');
    
	
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;

    ------------------------------  D_CNT_SIT_CART_DANADA_AGR --------------------------
	  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_SIT_CART_DANADA_AGR'', 
						  ''SIT_CART_DANADA_AGR_ID NUMBER(16,0) NOT NULL,
                            SIT_CART_DANADA_AGR_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (SIT_CART_DANADA_AGR_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_SIT_CART_DANADA_AGR');
    
	
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;
    
    ------------------------------  D_CNT_TIPO_GESTION_EXP --------------------------
	  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_TIPO_GESTION_EXP'', 
						  ''TIPO_GESTION_EXP_ID NUMBER(16,0) NOT NULL,
                            TIPO_GESTION_EXP_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_GESTION_EXP_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_TIPO_GESTION_EXP');
    
	
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;
    
    ------------------------------  D_CNT_TIPO_VENCIDO --------------------------
	  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_TIPO_VENCIDO'', 
						  ''TIPO_VENCIDO_ID NUMBER(16,0) NOT NULL,
                            TIPO_VENCIDO_DESC VARCHAR2(50 CHAR),
                            TIPO_VENCIDO_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_VENCIDO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_TIPO_VENCIDO');
      

    ------------------------------  D_CNT_TRAMO_CAP_VIVO --------------------------
	  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_TRAMO_CAP_VIVO'', 
						  ''TRAMO_CAP_VIVO_ID NUMBER(16,0) NOT NULL,
                            TRAMO_CAP_VIVO_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (TRAMO_CAP_VIVO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_TRAMO_CAP_VIVO');
      
      
    ------------------------------  D_CNT_DIR_TERRITORIAL --------------------------
	  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_DIR_TERRITORIAL'', 
						  ''DIR_TERRITORIAL_ID NUMBER(16,0) NOT NULL,
                            DIR_TERRITORIAL_DESC VARCHAR2(50 CHAR),
                            DIR_TERRITORIAL_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (DIR_TERRITORIAL_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_DIR_TERRITORIAL');  
      
      
    ------------------------------  D_CNT_ENTIDAD --------------------------
	  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_ENTIDAD'', 
						  ''CONTRATO_ENTIDAD_ID NUMBER(16,0) NOT NULL,
                            CONTRATO_ENTIDAD_DESC VARCHAR2(50 CHAR),
                            CONTRATO_ENTIDAD_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (CONTRATO_ENTIDAD_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_ENTIDAD');      
    

    ------------------------------  D_CNT_PERIMETRO_GESTION_CM --------------------------
	  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_PERIMETRO_GESTION_CM'', 
						  ''PERIMETRO_GESTION_CM_ID NUMBER(16,0) NOT NULL,
                            PERIMETRO_GESTION_CM_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (PERIMETRO_GESTION_CM_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_PERIMETRO_GESTION_CM'); 
      
    ------------------------------  D_CNT_MOTIVO_COBRO --------------------------
	  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_MOTIVO_COBRO'', 
						  ''MOTIVO_COBRO_ID NUMBER(16,0) NOT NULL,
                            MOTIVO_COBRO_DESC VARCHAR2(50 CHAR),
                            MOTIVO_COBRO_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (MOTIVO_COBRO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_MOTIVO_COBRO');    
	  
	   ------------------------------ D_CNT_APLICATIVO_ORIGEN --------------------------
	 
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_APLICATIVO_ORIGEN'',
		''APLICATIVO_ORIGEN_CNT_ID NUMBER(16,0) NOT NULL ENABLE, 
	APLICATIVO_ORIGEN_CNT_DESC VARCHAR2(50 CHAR),
	APLICATIVO_ORIGEN_CNT_DESC2 VARCHAR2(250 CHAR),
	PRIMARY KEY (APLICATIVO_ORIGEN_CNT_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_APLICATIVO_ORIGEN');
      
    ------------------------------  D_CNT_PERIMETRO_SIN_GESTION --------------------------
	  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_PERIMETRO_SIN_GESTION'', 
						  ''PERIMETRO_SIN_GESTION_ID NUMBER(16,0) NOT NULL,
                            PERIMETRO_SIN_GESTION_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (PERIMETRO_SIN_GESTION_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_PERIMETRO_SIN_GESTION');
    

    ------------------------------  D_CNT_PERIMETRO_EXP_SEG --------------------------
	  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_PERIMETRO_EXP_SEG'', 
						  ''PERIMETRO_EXP_SEG_ID NUMBER(16,0) NOT NULL,
                            PERIMETRO_EXP_SEG_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (PERIMETRO_EXP_SEG_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_PERIMETRO_EXP_SEG');


    ------------------------------  D_CNT_PERIMETRO_EXP_REC --------------------------
	 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_PERIMETRO_EXP_REC'', 
						  ''PERIMETRO_EXP_REC_ID NUMBER(16,0) NOT NULL,
                            PERIMETRO_EXP_REC_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (PERIMETRO_EXP_REC_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_PERIMETRO_EXP_REC');

    
    ------------------------------  D_CNT_PERIMETRO_GES_EXTRA --------------------------
	  	 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_PERIMETRO_GES_EXTRA'', 
						  ''PERIMETRO_GES_EXTRA_ID NUMBER(16,0) NOT NULL,
                            PERIMETRO_GES_EXTRA_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (PERIMETRO_GES_EXTRA_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_PERIMETRO_GES_EXTRA');

    
    ------------------------------  D_CNT_PERIMETRO_GES_PRE --------------------------
	  	 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_PERIMETRO_GES_PRE'', 
						  ''PERIMETRO_GES_PRE_ID NUMBER(16,0) NOT NULL,
                            PERIMETRO_GES_PRE_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (PERIMETRO_GES_PRE_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_PERIMETRO_GES_PRE');
    
        
    ------------------------------  D_CNT_PERIMETRO_GES_JUDI --------------------------
	 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_PERIMETRO_GES_JUDI'', 
						  ''PERIMETRO_GES_JUDI_ID NUMBER(16,0) NOT NULL,
                            PERIMETRO_GES_JUDI_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (PERIMETRO_GES_JUDI_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_PERIMETRO_GES_JUDI');

        
    ------------------------------  D_CNT_PERIMETRO_GES_CONCU --------------------------
	  	 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_PERIMETRO_GES_CONCU'', 
						  ''PERIMETRO_GES_CONCU_ID NUMBER(16,0) NOT NULL,
                            PERIMETRO_GES_CONCU_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (PERIMETRO_GES_CONCU_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_PERIMETRO_GES_CONCU');
          
    ------------------------------  D_CNT_TITULAR --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_TITULAR'', 



                            ''CNT_TITULAR_ID NUMBER(16,0) NOT NULL,
                              CNT_TITULAR_DOCUMENTO_ID VARCHAR2(20),
                              CNT_TITULAR_NOMBRE VARCHAR2(100 CHAR),
                              CNT_TITULAR_APELLIDO_1 VARCHAR2(100 CHAR),
                              CNT_TITULAR_APELLIDO_2 VARCHAR2(100 CHAR),
                              
                            PRIMARY KEY (CNT_TITULAR_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_TITULAR');      

    ------------------------------ D_CNT_TIPO_SOL_PREVISTA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT_TIPO_SOL_PREVISTA'', 
						  ''TIPO_SOL_PREVISTA_ID NUMBER(16,0) NOT NULL,
                            TIPO_SOL_PREVISTA_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_SOL_PREVISTA_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT_TIPO_SOL_PREVISTA');
	  
    ------------------------------ D_CNT --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_CNT'', 
						  ''CONTRATO_ID NUMBER(16,0) NOT NULL,
                            CONTRATO_COD_ENTIDAD VARCHAR2(50 CHAR),
                            CONTRATO_COD_OFICINA VARCHAR2(50 CHAR),
                            CONTRATO_COD_CENTRO VARCHAR2(50 CHAR),
                            CONTRATO_COD_CONTRATO VARCHAR2(50 CHAR),
                            CCC_LITIGIO VARCHAR2(250 CHAR),
                            NUC_LITIGIO VARCHAR2(250 CHAR),
                            IBAN_RIESGO VARCHAR2(250 CHAR),
                            TIPO_PRODUCTO_ID NUMBER(16,0),
                            PRODUCTO_ID NUMBER(16,0) NULL,
                            FINALIDAD_CONTRATO_ID NUMBER(16,0),
                            FINALIDAD_OFICIAL_ID NUMBER(16,0),
                            GARANTIA_CONTABLE_ID NUMBER(16,0),
                            GARANTIA_CONTRATO_ID NUMBER(16,0),
                            MONEDA_ID NUMBER(16,0),
                            ZONA_CONTRATO_ID NUMBER(16,0),
                            OFICINA_CONTRATO_ID NUMBER(16,0),
                            CATALOGO_DETALLE_6_ID NUMBER(16,0),
                            NACIONALIDAD_TITULAR_ID NUMBER(16,0),
                            POLITICA_TITULAR_ID NUMBER(16,0),
                            SEGMENTO_TITULAR_ID NUMBER(16,0),
                            SEXO_TITULAR_ID NUMBER(16,0),
                            TIPO_PERSONA_TITULAR_ID NUMBER(16,0),
                            CARTERA_CONTRATO_ID NUMBER(16,0),
                            GESTION_ESPECIAL_ID NUMBER(16,0) NULL,
                            CNT_TITULAR_ID NUMBER(16,0),
							APLICATIVO_ORIGEN_CNT_ID NUMBER(16,0),
                            CONTRATO_COD_CONTRATO_15 VARCHAR2(50 CHAR)
                            CONSTRAINT D_CNT_PK PRIMARY KEY (CONTRATO_ID)'', :error); END;'; 		 
 execute immediate V_SQL USING OUT error;
         DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_CNT');
    
	 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_CNT_COD_CONTRATO_IX'', ''D_CNT (CONTRATO_COD_CONTRATO)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_CNT_CCC_LITIGIO_IX'', ''D_CNT (CCC_LITIGIO)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_CNT_NUC_IX'', ''D_CNT (NUC_LITIGIO)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      
      DBMS_OUTPUT.PUT_LINE('---- Creacion indices de la tabla D_CNT');
   
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;    
    
  end;
END CREAR_DIM_CONTRATO;
/
EXIT
