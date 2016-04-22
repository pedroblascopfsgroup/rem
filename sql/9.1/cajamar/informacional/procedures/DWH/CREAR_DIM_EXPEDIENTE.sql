create or replace PROCEDURE CREAR_DIM_EXPEDIENTE (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Agustin Mompo, PFS Group
-- Fecha creacion: Mayo 2014

-- Responsable ultima modificacion: Pedro S., PFS Group
-- Fecha ultima modificacion: 14/04/2016
-- Motivos del cambio: Parametrización índices con esquema indices
-- Cliente: Recovery BI CAJAMAR
--
-- Descripcion: Procedimiento almancenado que crea las tablas de la dimension Expediente
-- ===============================================================================================

-- -------------------------------------------- INDICE -------------------------------------------
-- DIMENSION EXPEDIENTE
    -- D_EXP_ACTITUD
    -- D_EXP_AMBITO_EXPEDIENTE
    -- D_EXP_ARQUETIPO
    -- D_EXP_CAUSA_IMPAGO
    -- D_EXP_COMITE
    -- D_EXP_DECISION
    -- D_EXP_ENTIDAD_INFORMACION
    -- D_EXP_ESTADO_EXPEDIENTE
    -- D_EXP_ESTADO_ITINERARIO
    -- D_EXP_ITINERARIO
    -- D_EXP_NIVEL
    -- D_EXP_OFICINA
    -- D_EXP_PROPUESTA
    -- D_EXP_PROVINCIA
    -- D_EXP_SESION
    -- D_EXP_TIPO_ITINERARIO
    -- D_EXP_ZONA
    -- D_EXP_ESQUEMA
    -- D_EXP_CARTERA
    -- D_EXP_SUBCARTERA
    -- D_EXP_AGENCIA
    -- D_EXP_ENVIADO_AGENCIA
    -- D_EXP_T_SALDO_TOTAL
    -- D_EXP_T_SALDO_IRREGULAR
    -- D_EXP_T_DEUDA_IRREGULAR
    -- D_EXP_T_DEUDA_IRREGULAR_ENV
    -- D_EXP_TIPO_COBRO
    -- D_EXP_COBRO_FACTURADO
    -- D_EXP_REMESA_FACTURA
    -- D_EXP_TIPO_SALIDA
    -- D_EXP_MOTIVO_SALIDA
    -- D_EXP_TIPO_PALANCA
    -- D_EXP_ESTADO_PALANCA
    -- D_EXP_TIPO_SANCION
    -- D_EXP_TIPO_INCIDENCIA
    -- D_EXP_ESTADO_INCIDENCIA
    -- D_EXP_RESULTADO_GESTION
    -- D_EXP_RESULTADO_GESTION_CNT
    -- D_EXP_T_ROTACIONES
    -- D_EXP_TD_ENTRADA_GESTION
    -- D_EXP_TD_CREACION_EXP_COBRO
    -- D_EXP_TIPO_GESTION
    -- D_EXP_TIPO_GESTION_CNT
    -- D_EXP_CAUSA_IMPAGO
    -- D_EXP
    -- D_EXP_MODELOS_FACTURACION
    -- D_EXP_MOTIVO_BAJA_CR
    -- D_EXP_ESQUEMA_CR
    -- D_EXP_CARTERA_CR
    -- D_EXP_SUBCARTERA_CR
    -- D_EXP_AGENCIA_CR
    -- D_EXP_ENVIADO_AGENCIA_CR
    
    -- D_EXP_GESTOR
    -- D_EXP_GESTOR_COMITE
    -- D_EXP_SUPERVISOR
    -- D_EXP_FASE
    -- D_EXP_TIPO_EXPEDIENTE

    
BEGIN

declare
  nCount NUMBER;
 
  V_NOMBRE VARCHAR2(50) := 'CREAR_DIM_EXPEDIENTE';
  V_SQL varchar2(16000);
  
  begin

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;

    ------------------------------ D_EXP_ACTITUD --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_ACTITUD'', 



                          ''ACTITUD_ID NUMBER(16,0) NOT NULL,
                            ACTITUD_DESC VARCHAR2(50 CHAR),
                            ACTITUD_DESC_2 VARCHAR2(250 CHAR)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_ACTITUD_PK'', ''D_EXP_ACTITUD (ACTITUD_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
	
    ------------------------------ D_EXP_AMBITO_EXPEDIENTE --------------------------
  

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_AMBITO_EXPEDIENTE'', 
                          ''AMBITO_EXPEDIENTE_ID NUMBER(16,0) NOT NULL,
                            AMBITO_EXPEDIENTE_DESC VARCHAR2(250 CHAR),
                            AMBITO_EXPEDIENTE_DESC_2 VARCHAR2(500 CHAR)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
	
 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_AMBITO_EXPEDIENTE_PK'', ''D_EXP_AMBITO_EXPEDIENTE (AMBITO_EXPEDIENTE_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_EXP_ARQUETIPO --------------------------
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_ARQUETIPO'', 



                          ''ARQUETIPO_EXPEDIENTE_ID NUMBER(16,0) NOT NULL,
                            ARQUETIPO_EXPEDIENTE_DESC VARCHAR2(100 CHAR),
                            ITINERARIO_EXPEDIENTE_ID NUMBER(16,0)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_ARQUETIPO_PK'', ''D_EXP_ARQUETIPO (ARQUETIPO_EXPEDIENTE_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_EXP_CAUSA_IMPAGO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_CAUSA_IMPAGO'', 



                          ''CAUSA_IMPAGO_ID NUMBER(16,0) NOT NULL,
                            CAUSA_IMPAGO_DESC VARCHAR2(50 CHAR),
                            CAUSA_IMPAGO_DESC_2 VARCHAR2(250 CHAR)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
	
 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_CAUSA_IMPAGO_PK'', ''D_EXP_CAUSA_IMPAGO (CAUSA_IMPAGO_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_EXP_COMITE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_COMITE'', 



                              ''COMITE_ID NUMBER(16,0) NOT NULL,
                                COMITE_DESC VARCHAR2(100 CHAR),
                                ZONA_EXPEDIENTE_ID NUMBER(16,0)'', 
                              :error); END;';
    execute immediate V_SQL USING OUT error;

 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_COMITE_PK'', ''D_EXP_COMITE (COMITE_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
	
    ------------------------------ D_EXP_DECISION --------------------------
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_DECISION'', 



                              ''DECISION_ID NUMBER(16,0) NOT NULL,
                                DECISION_DESC VARCHAR2(100 CHAR),
                                SESION_ID NUMBER(16,0)'', 
                              :error); END;';
    execute immediate V_SQL USING OUT error;
	
 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_DECISION_PK'', ''D_EXP_DECISION (DECISION_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_EXP_ENTIDAD_INFORMACION --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_ENTIDAD_INFORMACION'', 
                          ''ENTIDAD_INFORMACION_ID NUMBER(16,0) NOT NULL,
                            ENTIDAD_INFORMACION_DESC VARCHAR2(50 CHAR),
                            ENTIDAD_INFORMACION_DESC_2 VARCHAR2(250 CHAR)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_ENTIDAD_INFORMACION_PK'', ''D_EXP_ENTIDAD_INFORMACION (ENTIDAD_INFORMACION_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
	
    ------------------------------ D_EXP_ESTADO_EXPEDIENTE --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_ESTADO_EXPEDIENTE'', 
                          ''ESTADO_EXPEDIENTE_ID NUMBER(16,0) NOT NULL,
                            ESTADO_EXPEDIENTE_DESC VARCHAR2(50 CHAR),
                            ESTADO_EXPEDIENTE_DESC_2 VARCHAR2(250 CHAR)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
	
 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_ESTADO_EXPEDIENTE_PK'', ''D_EXP_ESTADO_EXPEDIENTE (ESTADO_EXPEDIENTE_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_EXP_ESTADO_ITINERARIO --------------------------
 

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_ESTADO_ITINERARIO'', 
                          '' ESTADO_ITINERARIO_ID NUMBER(16,0) NOT NULL,
                            ESTADO_ITINERARIO_DESC VARCHAR2(50 CHAR),
                            ESTADO_ITINERARIO_DESC_2 VARCHAR2(250 CHAR),
                            ENTIDAD_INFORMACION_ID NUMBER(16,0) NULL'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_ESTADO_ITINERARIO_PK'', ''D_EXP_ESTADO_ITINERARIO (ESTADO_ITINERARIO_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
	
    ------------------------------ D_EXP_ITINERARIO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_ITINERARIO'', 



                          ''ITINERARIO_EXPEDIENTE_ID NUMBER(16,0) NOT NULL,
                            ITINERARIO_EXPEDIENTE_DESC VARCHAR2(100 CHAR),
                            TIPO_ITINERARIO_EXP_ID NUMBER(16,0),
                            AMBITO_EXPEDIENTE_ID NUMBER(16,0)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
	
 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_ITINERARIO_PK'', ''D_EXP_ITINERARIO (ITINERARIO_EXPEDIENTE_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
	
    ------------------------------ D_EXP_NIVEL --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_NIVEL'', 



                          ''NIVEL_EXPEDIENTE_ID NUMBER(16,0) NOT NULL,
                            NIVEL_EXPEDIENTE_DESC VARCHAR2(50 CHAR),
                            NIVEL_EXPEDIENTE_DESC_2 VARCHAR2(250 CHAR)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
	
 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_NIVEL_PK'', ''D_EXP_NIVEL (NIVEL_EXPEDIENTE_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
	
    ------------------------------ D_EXP_OFICINA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_OFICINA'', 



                          ''OFICINA_EXPEDIENTE_ID NUMBER(16,0) NOT NULL,
                            OFICINA_EXPEDIENTE_DESC VARCHAR2(50 CHAR),
                            OFICINA_EXPEDIENTE_DESC_2 VARCHAR2(250 CHAR),
                            PROVINCIA_EXPEDIENTE_ID NUMBER(16,0)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
	
 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_OFICINA_PK'', ''D_EXP_OFICINA (OFICINA_EXPEDIENTE_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
	
    ------------------------------ D_EXP_PROPUESTA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_PROPUESTA'', 



                          ''PROPUESTA_ID NUMBER(16,0) NOT NULL,
                            PROPUESTA_DESC VARCHAR2(50 CHAR),
                            PROPUESTA_DESC_2 VARCHAR2(250 CHAR)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_PROPUESTA_PK'', ''D_EXP_PROPUESTA (PROPUESTA_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_EXP_PROVINCIA --------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_PROVINCIA'', 



                          ''PROVINCIA_EXPEDIENTE_ID NUMBER(16,0) NOT NULL,
                            PROVINCIA_EXPEDIENTE_DESC VARCHAR2(50 CHAR),
                            PROVINCIA_EXPEDIENTE_DESC_2 VARCHAR2(250 CHAR)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
	
 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_PROVINCIA_PK'', ''D_EXP_PROVINCIA (PROVINCIA_EXPEDIENTE_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_EXP_SESION --------------------------
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_SESION'', 



                          ''SESION_ID NUMBER(16,0) NOT NULL,
                            SESION_FECHA_INICIO DATE,
                            SESION_FECHA_FIN DATE,
                            COMITE_ID NUMBER(16,0)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_SESION_PK'', ''D_EXP_SESION (SESION_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_EXP_TIPO_ITINERARIO --------------------------
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_TIPO_ITINERARIO'', 



                              ''TIPO_ITINERARIO_EXP_ID NUMBER(16,0) NOT NULL,
                                TIPO_ITINERARIO_EXP_DESC VARCHAR2(50 CHAR),
                                TIPO_ITINERARIO_EXP_DESC_2 VARCHAR2(250 CHAR)'', 
                              :error); END;';
    execute immediate V_SQL USING OUT error;

 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_TIPO_ITINERARIO_PK'', ''D_EXP_TIPO_ITINERARIO (TIPO_ITINERARIO_EXP_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_EXP_ZONA --------------------------

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_ZONA'', 



                          ''ZONA_EXPEDIENTE_ID NUMBER(16,0) NOT NULL,
                            ZONA_EXPEDIENTE_DESC VARCHAR2(50 CHAR),
                            ZONA_EXPEDIENTE_DESC_2 VARCHAR2(250 CHAR),
                            NIVEL_EXPEDIENTE_ID NUMBER(16,0),
                            OFICINA_EXPEDIENTE_ID NUMBER(16,0)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_ZONA_PK'', ''D_EXP_ZONA (ZONA_EXPEDIENTE_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_EXP_ESQUEMA --------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_ESQUEMA'', 



                          ''ESQUEMA_EXPEDIENTE_ID NUMBER(16,0) NOT NULL,
                            ESQUEMA_EXPEDIENTE_DESC VARCHAR2(250 CHAR)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_ESQUEMA_PK'', ''D_EXP_ESQUEMA (ESQUEMA_EXPEDIENTE_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_EXP_CARTERA --------------------------
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_CARTERA'', 



                              ''CARTERA_EXPEDIENTE_ID NUMBER(16,0) NOT NULL,
                                CARTERA_EXPEDIENTE_DESC VARCHAR2(250 CHAR)'', 
                              :error); END;';
    execute immediate V_SQL USING OUT error;

	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_CARTERA_PK'', ''D_EXP_CARTERA (CARTERA_EXPEDIENTE_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_EXP_SUBCARTERA --------------------------
V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_SUBCARTERA'', 



                              ''SUBCARTERA_EXPEDIENTE_ID NUMBER(16,0) NOT NULL,
                                SUBCARTERA_EXPEDIENTE_DESC VARCHAR2(250 CHAR),
                                CARTERA_EXPEDIENTE_ID NUMBER(16,0)'', 
                              :error); END;';
    execute immediate V_SQL USING OUT error;

	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_SUBCARTERA_PK'', ''D_EXP_SUBCARTERA (SUBCARTERA_EXPEDIENTE_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_EXP_AGENCIA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_AGENCIA'', 



                          ''AGENCIA_EXPEDIENTE_ID NUMBER(16,0) NOT NULL,
                            AGENCIA_EXPEDIENTE_DESC VARCHAR2(250 CHAR)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_AGENCIA_PK'', ''D_EXP_AGENCIA (AGENCIA_EXPEDIENTE_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

     ------------------------------ D_EXP_ENVIADO_AGENCIA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_ENVIADO_AGENCIA'', 



                              ''ENVIADO_AGENCIA_EXP_ID NUMBER(16,0) NOT NULL,
                                ENVIADO_AGENCIA_EXP_DESC VARCHAR2(250 CHAR)'', 
                              :error); END;';
    execute immediate V_SQL USING OUT error;

	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_ENVIADO_AGENCIA_PK'', ''D_EXP_ENVIADO_AGENCIA (ENVIADO_AGENCIA_EXP_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_EXP_T_SALDO_TOTAL --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_T_SALDO_TOTAL'', 



                          ''T_SALDO_TOTAL_EXP_ID NUMBER(16,0) NOT NULL,
                            T_SALDO_TOTAL_EXP_DESC VARCHAR2(250 CHAR)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_T_SALDO_TOTAL_PK'', ''D_EXP_T_SALDO_TOTAL (T_SALDO_TOTAL_EXP_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_EXP_T_SALDO_IRREGULAR --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_T_SALDO_IRREGULAR'', 
                              ''T_SALDO_IRREGULAR_EXP_ID NUMBER(16,0) NOT NULL,
                                T_SALDO_IRREGULAR_EXP_DESC VARCHAR2(250 CHAR)'', 
                              :error); END;';
    execute immediate V_SQL USING OUT error;

	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_T_SALDO_IRREGULAR_PK'', ''D_EXP_T_SALDO_IRREGULAR (T_SALDO_IRREGULAR_EXP_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_EXP_T_DEUDA_IRREGULAR --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_T_DEUDA_IRREGULAR'', 
                              ''T_DEUDA_IRREGULAR_EXP_ID NUMBER(16,0) NOT NULL,
                                T_DEUDA_IRREGULAR_EXP_DESC VARCHAR2(250 CHAR)'', 
                              :error); END;';
    execute immediate V_SQL USING OUT error;

	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_T_DEUDA_IRREGULAR_PK'', ''D_EXP_T_DEUDA_IRREGULAR (T_DEUDA_IRREGULAR_EXP_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_EXP_T_DEUDA_IRREGULAR_ENV --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_T_DEUDA_IRREGULAR_ENV'', 
                          ''T_DEUDA_IRREGULAR_ENV_EXP_ID NUMBER(16,0) NOT NULL,
                            T_DEUDA_IRREGULAR_ENV_EXP_DESC VARCHAR2(250 CHAR)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_T_DEUDA_IRREGULAR_ENV_PK'', ''D_EXP_T_DEUDA_IRREGULAR_ENV (T_DEUDA_IRREGULAR_ENV_EXP_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
   
/*
    ------------------------------ D_EXP_TIPO_COBRO --------------------------
    select count(*) into nCount from user_tables where table_name = 'D_EXP_TIPO_COBRO';
    if(nCount <= 0) then
      execute immediate 'CREATE TABLE D_EXP_TIPO_COBRO (
                            TIPO_COBRO_EXPEDIENTE_ID NUMBER(16,0) NOT NULL,
                            TIPO_COBRO_EXPEDIENTE_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_COBRO_EXPEDIENTE_ID))';
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_EXP_TIPO_COBRO');
    end if;

    ------------------------------ D_EXP_COBRO_FACTURADO --------------------------
    select count(*) into nCount from user_tables where table_name = 'D_EXP_COBRO_FACTURADO';
    if(nCount <= 0) then
      execute immediate 'CREATE TABLE D_EXP_COBRO_FACTURADO(
                            COBRO_FACTURADO_ID NUMBER(16,0) NOT NULL,
                            COBRO_FACTURADO_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (COBRO_FACTURADO_ID))';
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_EXP_COBRO_FACTURADO');
    end if;

    ------------------------------ D_EXP_REMESA_FACTURA --------------------------
    select count(*) into nCount from user_tables where table_name = 'D_EXP_REMESA_FACTURA';
    if(nCount <= 0) then
      execute immediate 'CREATE TABLE D_EXP_REMESA_FACTURA(
                            REMESA_FACTURA_ID NUMBER(16,0) NOT NULL,
                            REMESA_FACTURA_DESC VARCHAR2(250 CHAR),
                            PRIMARY KEY (REMESA_FACTURA_ID))';
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_EXP_REMESA_FACTURA');
    end if;
*/
   ------------------------------ D_EXP_TIPO_SALIDA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_TIPO_SALIDA'', 



                              ''TIPO_SALIDA_ID NUMBER(16,0) NOT NULL,
                                TIPO_SALIDA_DESC VARCHAR2(250 CHAR)'', 
                              :error); END;';
    execute immediate V_SQL USING OUT error;

	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_TIPO_SALIDA_PK'', ''D_EXP_TIPO_SALIDA (TIPO_SALIDA_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_EXP_MOTIVO_SALIDA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_MOTIVO_SALIDA'', 



                          ''MOTIVO_SALIDA_ID NUMBER(16,0) NOT NULL,
                            MOTIVO_SALIDA_DESC VARCHAR2(250 CHAR)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_MOTIVO_SALIDA_PK'', ''D_EXP_MOTIVO_SALIDA (MOTIVO_SALIDA_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_EXP_TIPO_PALANCA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_TIPO_PALANCA'', 



                          ''TIPO_PALANCA_ID NUMBER(16,0) NOT NULL,
                            TIPO_PALANCA_DESC VARCHAR2(250 CHAR)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_TIPO_PALANCA_PK'', ''D_EXP_TIPO_PALANCA (TIPO_PALANCA_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_EXP_ESTADO_PALANCA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_ESTADO_PALANCA'', 



                          ''ESTADO_PALANCA_ID NUMBER(16,0) NOT NULL,
                            ESTADO_PALANCA_DESC VARCHAR2(250 CHAR)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_ESTADO_PALANCA_PK'', ''D_EXP_ESTADO_PALANCA (ESTADO_PALANCA_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_EXP_TIPO_SANCION --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_TIPO_SANCION'', 



                          ''TIPO_SANCION_ID NUMBER(16,0) NOT NULL,
                            TIPO_SANCION_DESC VARCHAR2(250 CHAR)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_TIPO_SANCION_PK'', ''D_EXP_TIPO_SANCION (TIPO_SANCION_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_EXP_TIPO_INCIDENCIA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_TIPO_INCIDENCIA'', 



                          ''TIPO_INCIDENCIA_ID NUMBER(16,0) NOT NULL,
                            TIPO_INCIDENCIA_DESC VARCHAR2(250 CHAR)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_TIPO_INCIDENCIA_PK'', ''D_EXP_TIPO_INCIDENCIA (TIPO_INCIDENCIA_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

     ------------------------------ D_EXP_ESTADO_INCIDENCIA --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_ESTADO_INCIDENCIA'', 
                          ''ESTADO_INCIDENCIA_ID NUMBER(16,0) NOT NULL,
                            ESTADO_INCIDENCIA_DESC VARCHAR2(250 CHAR)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_ESTADO_INCIDENCIA_PK'', ''D_EXP_ESTADO_INCIDENCIA (ESTADO_INCIDENCIA_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
	
    ------------------------------ D_EXP_RESULTADO_GESTION --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_RESULTADO_GESTION'',
                            ''RESULTADO_GESTION_EXP_ID NUMBER(16,0) NOT NULL,
							  RESULTADO_GESTION_EXP_DESC VARCHAR2(250 CHAR)'',
							:error); END;';
    execute immediate V_SQL USING OUT error;

	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_RESULTADO_GESTION_PK'', ''D_EXP_RESULTADO_GESTION (RESULTADO_GESTION_EXP_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
	
    ------------------------------ D_EXP_RESULTADO_GESTION_CNT --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_RESULTADO_GESTION_CNT'',
                            ''RESULTADO_GESTION_EXP_CNT_ID NUMBER(16,0) NOT NULL,
                              RESULTADO_GESTION_EXP_CNT_DESC VARCHAR2(250 CHAR)'',
							:error); END;';
    execute immediate V_SQL USING OUT error;
	
	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_RESULTADO_GESTION_CNT_PK'', ''D_EXP_RESULTADO_GESTION_CNT (RESULTADO_GESTION_EXP_CNT_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
	
	
	
	

   ------------------------------ D_EXP_T_ROTACIONES --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_T_ROTACIONES'', 



                          ''T_ROTACIONES_EXP_ID NUMBER(16,0) NOT NULL,
                            T_ROTACIONES_EXP_DESC VARCHAR2(250 CHAR)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_T_ROTACIONES_PK'', ''D_EXP_T_ROTACIONES (T_ROTACIONES_EXP_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_EXP_TD_ENTRADA_GESTION --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_TD_ENTRADA_GESTION'', 
                          ''TD_ENTRADA_GEST_EXP_ID NUMBER(16,0) NOT NULL,
                            TD_ENTRADA_GEST_EXP_DESC VARCHAR2(250 CHAR)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_TD_ENTRADA_GESTION_PK'', ''D_EXP_TD_ENTRADA_GESTION (TD_ENTRADA_GEST_EXP_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_EXP_TD_CREACION_EXP_COBRO --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_TD_CREACION_EXP_COBRO'', 
                          ''TD_CREACION_EXP_COBRO_ID NUMBER(16,0) NOT NULL,
                            TD_CREACION_EXP_COBRO_DESC VARCHAR2(250 CHAR)'', 
                          :error); END;';

   execute immediate V_SQL USING OUT error;

	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_TD_CREACION_EXP_COBRO_PK'', ''D_EXP_TD_CREACION_EXP_COBRO (TD_CREACION_EXP_COBRO_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
   
    ------------------------------ D_EXP_TIPO_GESTION --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_TIPO_GESTION'',
                            ''TIPO_GESTION_EXP_ID NUMBER(16,0) NOT NULL,
                              TIPO_GESTION_EXP_DESC VARCHAR2(250 CHAR)'',
                          :error); END;';

   execute immediate V_SQL USING OUT error;

	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_TIPO_GESTION_PK'', ''D_EXP_TIPO_GESTION (TIPO_GESTION_EXP_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
   
    ------------------------------ D_EXP_TIPO_GESTION_CNT --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_TIPO_GESTION_CNT'',
                           '' TIPO_GESTION_EXP_CNT_ID NUMBER(16,0) NOT NULL,
                              TIPO_GESTION_EXP_CNT_DESC VARCHAR2(250 CHAR)'',
                          :error); END;';

   execute immediate V_SQL USING OUT error;
   
	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_TIPO_GESTION_CNT_PK'', ''D_EXP_TIPO_GESTION_CNT (TIPO_GESTION_EXP_CNT_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
   
   
     ------------------------------ D_EXP --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP'', 



                          ''EXPEDIENTE_ID NUMBER(16,0) NOT NULL,
                            EXPEDIENTE_DESC VARCHAR2(310 CHAR),
                            TIPO_EXPEDIENTE_ID NUMBER(16,0),
                            ACTITUD_ID NUMBER(16,0),
                            ARQUETIPO_EXPEDIENTE_ID NUMBER(16,0),
                            CAUSA_IMPAGO_ID NUMBER(16,0),
                            COMITE_ID NUMBER(16,0),
                            DECISION_ID NUMBER(16,0),

                            ESTADO_ITINERARIO_ID NUMBER(16,0),
                            OFICINA_EXPEDIENTE_ID NUMBER(16,0),
                            PROPUESTA_ID NUMBER(16,0)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
	
	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_PK'', ''D_EXP (EXPEDIENTE_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
	
	------------------------------ D_EXP_MODELOS_FACTURACION --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_MODELOS_FACTURACION'', 
                          ''MODELOS_FACT_EXP_ID NUMBER(16,0) NOT NULL,
                            MODELOS_FACT_EXP_DESC VARCHAR2(250 CHAR)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_MODELOS_FACTURACION_PK'', ''D_EXP_MODELOS_FACTURACION (MODELOS_FACT_EXP_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_EXP_MOTIVO_BAJA_CR -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_MOTIVO_BAJA_CR'', 



                          ''MOTIVO_BAJA_EXP_CR_ID NUMBER(16,0) NOT NULL,
                            MOTIVO_BAJA_EXP_CR_DESC VARCHAR2(50 CHAR)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;    

	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_MOTIVO_BAJA_CR_PK'', ''D_EXP_MOTIVO_BAJA_CR (MOTIVO_BAJA_EXP_CR_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
	
     ------------------------------ D_EXP_ESQUEMA_CR -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_ESQUEMA_CR'', 



                          ''ESQUEMA_EXP_CR_ID NUMBER(16,0) NOT NULL,
                            ESQUEMA_EXP_CR_DESC VARCHAR2(250 CHAR)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_ESQUEMA_CR_PK'', ''D_EXP_ESQUEMA_CR (ESQUEMA_EXP_CR_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_EXP_CARTERA_CR -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_CARTERA_CR'', 



                          ''CARTERA_EXP_CR_ID NUMBER(16,0) NOT NULL,
                            CARTERA_EXP_CR_DESC VARCHAR2(250 CHAR)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_CARTERA_CR_PK'', ''D_EXP_CARTERA_CR (CARTERA_EXP_CR_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_EXP_SUBCARTERA_CR -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_SUBCARTERA_CR'', 



                          ''SUBCARTERA_EXP_CR_ID NUMBER(16,0) NOT NULL,
                            SUBCARTERA_EXP_CR_DESC VARCHAR2(50 CHAR),
                            CARTERA_EXP_CR_ID NUMBER(16,0) NULL'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_SUBCARTERA_CR_PK'', ''D_EXP_SUBCARTERA_CR (SUBCARTERA_EXP_CR_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

     ------------------------------ D_EXP_AGENCIA_CR -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_AGENCIA_CR'', 



                          ''AGENCIA_EXP_CR_ID NUMBER(16,0) NOT NULL,
                            AGENCIA_EXP_CR_DESC VARCHAR2(50 CHAR)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_AGENCIA_CR_PK'', ''D_EXP_AGENCIA_CR (AGENCIA_EXP_CR_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
	
    ------------------------------ D_EXP_ENVIADO_AGENCIA_CR --------------------------

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_ENVIADO_AGENCIA_CR'', 
                          ''ENVIADO_AGENCIA_EXP_CR_ID NUMBER(16,0) NOT NULL,
                            ENVIADO_AGENCIA_EXP_CR_DESC VARCHAR2(250 CHAR)'', 
                          :error); END;';

    execute immediate V_SQL USING OUT error;
	
	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_ENVIADO_AGENCIA_CR_PK'', ''D_EXP_ENVIADO_AGENCIA_CR (ENVIADO_AGENCIA_EXP_CR_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
	
    ------------------------------ D_EXP_GESTOR --------------------------
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_GESTOR'',
                            ''GESTOR_EXP_ID NUMBER(16,0) NOT NULL,
                              GESTOR_EXP_NOMBRE_COMP VARCHAR2(250 CHAR),
                              GESTOR_EXP_NOMBRE VARCHAR2(250 CHAR),
                              GESTOR_EXP_APELLIDO1 VARCHAR2(250 CHAR),
                              GESTOR_EXP_APELLIDO2 VARCHAR2(250 CHAR)'', 
                          :error); END;';

    execute immediate V_SQL USING OUT error;
	
	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_GESTOR_PK'', ''D_EXP_GESTOR (GESTOR_EXP_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_EXP_GESTOR_COMITE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_GESTOR_COMITE'',
                            ''GESTOR_COMITE_EXP_ID NUMBER(16,0) NOT NULL,
                              GESTOR_COMITE_EXP_NOMBRE_COMP VARCHAR2(250 CHAR),
                              GESTOR_COMITE_EXP_NOMBRE VARCHAR2(250 CHAR),
                              GESTOR_COMITE_EXP_APELLIDO1 VARCHAR2(250 CHAR),
                              GESTOR_COMITE_EXP_APELLIDO2 VARCHAR2(250 CHAR)'', 
                          :error); END;';

    execute immediate V_SQL USING OUT error;

	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_GESTOR_COMITE_PK'', ''D_EXP_GESTOR_COMITE (GESTOR_COMITE_EXP_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
	
    ------------------------------ D_EXP_SUPERVISOR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_SUPERVISOR'',
                           ''SUPERVISOR_EXP_ID NUMBER(16,0) NOT NULL,
                              SUPERVISOR_EXP_NOMBRE_COMP VARCHAR2(250 CHAR),
                              SUPERVISOR_EXP_NOMBRE VARCHAR2(250 CHAR),
                              SUPERVISOR_EXP_APELLIDO1 VARCHAR2(250 CHAR),
                              SUPERVISOR_EXP_APELLIDO2 VARCHAR2(250 CHAR)'', 
                          :error); END;';

    execute immediate V_SQL USING OUT error;

	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_SUPERVISOR_PK'', ''D_EXP_SUPERVISOR (SUPERVISOR_EXP_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
	
    ------------------------------ D_EXP_FASE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_FASE'',
                           ''FASE_EXPEDIENTE_ID NUMBER(16,0) NOT NULL,
                             FASE_EXPEDIENTE_DESC VARCHAR2(250 CHAR),
                             FASE_EXPEDIENTE_DESC_2 VARCHAR2(250 CHAR)'', 
                          :error); END;';

    execute immediate V_SQL USING OUT error;
	
	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_FASE_PK'', ''D_EXP_FASE (FASE_EXPEDIENTE_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

       ------------------------------ D_EXP_TIPO_EXPEDIENTE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_EXP_TIPO_EXPEDIENTE'',
                            ''TIPO_EXPEDIENTE_ID NUMBER(16,0) NOT NULL,
                              TIPO_EXPEDIENTE_DESC VARCHAR2(250 CHAR),
                              TIPO_EXPEDIENTE_DESC_2 VARCHAR2(250 CHAR)'', 
                          :error); END;';

    execute immediate V_SQL USING OUT error;

	 V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_EXP_TIPO_EXPEDIENTE_PK'', ''D_EXP_TIPO_EXPEDIENTE (TIPO_EXPEDIENTE_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;


  end;

END CREAR_DIM_EXPEDIENTE;