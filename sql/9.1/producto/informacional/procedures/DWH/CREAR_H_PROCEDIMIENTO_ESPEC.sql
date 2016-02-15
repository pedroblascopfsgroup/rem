create or replace PROCEDURE CREAR_H_PROCEDIMIENTO_ESPEC (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Febrero 2014
-- Responsable ultima modificacion: María Villanueva, PFS Group
-- Fecha ultima modificacion: 01/12/2015
-- Motivos del cambio: Usuario propietario
-- Cliente: Recovery BI Producto
--
-- Descripcion: Procedimiento almancenado que crea las tablas del Hecho Procedimiento Especifico
-- ===============================================================================================

-- -------------------------------------------- INDICE -------------------------------------------
-- HECHO PROCEDIMIENTO_ESPEC?FICO
    -- TMP_PRC_ESPECIFICO_JERARQUIA
    -- TMP_PRC_ESPECIFICO_DETALLE
    -- TMP_PRC_ESPECIFICO_DECISION
    -- TMP_PRC_ESPECIFICO_RECURSO
    -- H_CONCU
    -- H_CONCU_SEMANA
    -- H_CONCU_MES
    -- H_CONCU_TRIMESTRE
    -- H_CONCU_ANIO
    -- TMP_CONCU_JERARQUIA
    -- TMP_CONCU_DETALLE
    -- TMP_CONCU_TAREA
    -- TMP_CONCU_CONVENIO
    -- TMP_CONCU_AUX
    -- TMP_CONCU_CONTRATO
    -- H_DECL
    -- H_DECL_SEMANA
    -- H_DECL_MES
    -- H_DECL_TRIMESTRE
    -- H_DECL_ANIO
    -- TMP_DECL_JERARQUIA
    -- TMP_DECL_DETALLE
    -- TMP_DECL_TAREA
    -- H_EJEC_ORD
    -- H_EJEC_ORD_SEMANA
    -- H_EJEC_ORD_MES
    -- H_EJEC_ORD_TRIMESTRE
    -- H_EJEC_ORD_ANIO
    -- TMP_EJEC_ORD_JERARQUIA
    -- TMP_EJEC_ORD_DETALLE
    -- TMP_EJEC_ORD_TAREA
    -- H_HIPO
    -- H_HIPO_SEMANA
    -- H_HIPO_MES
    -- H_HIPO_TRIMESTRE
    -- H_HIPO_ANIO
    -- TMP_HIPO_JERARQUIA
    -- TMP_HIPO_DETALLE
    -- TMP_HIPO_TAREA
    -- H_MON
    -- H_MON_SEMANA
    -- H_MON_MES
    -- H_MON_TRIMESTRE
    -- H_MON_ANIO
    -- TMP_MON_JERARQUIA
    -- TMP_MON_DETALLE
    -- TMP_MON_TAREA
    -- H_EJEC_NOT
    -- H_EJEC_NOT_SEMANA
    -- H_EJEC_NOT_MES
    -- H_EJEC_NOT_TRIMESTRE
    -- H_EJEC_NOT_ANIO
    -- TMP_EJEC_NOT_JERARQUIA
    -- TMP_EJEC_NOT_DETALLE
    -- TMP_EJEC_NOT_TAREA
    -- H_PRE_CONCU
    -- H_PRE_CONCU_SEMANA
    -- H_PRE_CONCU_MES
    -- H_PRE_CONCU_TRIMESTRE
    -- H_PRE_CONCU_ANIO
    -- TMP_PRE_CONCU_JERARQUIA
    -- TMP_PRE_CONCU_DETALLE
    -- TMP_PRE_CONCU_TAREA
	
BEGIN
  declare
  nCount NUMBER;
  v_sql LONG;
  V_NOMBRE VARCHAR2(50) := 'CREAR_H_PROCEDIMIENTO_ESPEC';

  begin

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;

    ------------------------------ TMP_PRC_ESPECIFICO_JERARQUIA --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_PRC_ESPECIFICO_JERARQUIA'',
						  ''DIA_ID DATE  NOT NULL,
                          ITER NUMBER(16,0)  NOT NULL,
                          FASE_ACTUAL NUMBER(16,0)  ,
                          FASE_MAX_PRIORIDAD NUMBER(16,0)  ,
                          NIVEL NUMBER(2,0)  ,
                          CONTEXTO VARCHAR2(600)  ,
                          CODIGO_FASE_ACTUAL VARCHAR2(20)  ,
                          PRIORIDAD_FASE INTEGER  ,
                          ASUNTO NUMBER(16,0)  ,
                          PRIORIDAD_PROCEDIMIENTO INTEGER  ,
                          TIPO_PROCEDIMIENTO_DET NUMBER(16,0)  ,
                          FASE_PARALIZADA INTEGER  ,
                          FASE_FINALIZADA INTEGER  ,
                          FASE_CON_RECURSO INTEGER

                         '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_PRC_ESPECIFICO_JERARQUIA');

        V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_ESPEC_JRQ_ITER_IX'', ''TMP_PRC_ESPECIFICO_JERARQUIA (DIA_ID, ITER)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
        V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_ESPEC_JRQ_FASE_ACT_IX'', ''TMP_PRC_ESPECIFICO_JERARQUIA (DIA_ID, FASE_ACTUAL)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_PRC_ESPECIFICO_JERARQUIA');

    

    ------------------------------ TMP_PRC_ESPECIFICO_DETALLE --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_PRC_ESPECIFICO_DETALLE'',
						  ''ITER NUMBER(16,0)  NOT NULL,
                          MAX_PRIORIDAD NUMBER(16,0)  ,
                          FASE_MAX_PRIORIDAD NUMBER(16,0)

                         '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_PRC_ESPECIFICO_DETALLE');

        V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_ESPECIFICO_DETALLE_IX'', ''TMP_PRC_ESPECIFICO_DETALLE (ITER)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_PRC_ESPECIFICO_DETALLE');

    

    ------------------------------ TMP_PRC_ESPECIFICO_DECISION --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_PRC_ESPECIFICO_DECISION'',
						  ''FASE_ACTUAL NUMBER(16,0),
                          FASE_PARALIZADA INTEGER,
                          FASE_FINALIZADA INTEGER,
                          FECHA_HASTA DATE

                          '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_PRC_ESPECIFICO_DECISION');

        V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_ESPECIFICO_DECISION_IX'', ''TMP_PRC_ESPECIFICO_DECISION (FASE_ACTUAL)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_PRC_ESPECIFICO_DECISION');


    

    ------------------------------ TMP_PRC_ESPECIFICO_RECURSO --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_PRC_ESPECIFICO_RECURSO'',
						  ''FASE_ACTUAL NUMBER(16,0),
                          FASE_CON_RECURSO INTEGER,
                          FECHA_RESOLUCION DATE

                         '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_PRC_ESPECIFICO_RECURSO');

       V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_ESPECIFICO_RECURSO_IX'', ''TMP_PRC_ESPECIFICO_RECURSO (FASE_ACTUAL)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_PRC_ESPECIFICO_RECURSO');


    

    ------------------------------ H_CONCU --------------------------



    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CONCU'',
						  ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              -- Dimensiones
                              FECHA_AUTO_FASE_COMUN DATE ,
                              FECHA_LIQUIDACION DATE ,
                              FECHA_PUBLICACION_BOE DATE ,
                              FECHA_INSINUACION_FINAL_CRED DATE ,
                              FECHA_AUTO_APERTURA_CONVENIO DATE ,
                              FECHA_REGISTRAR_IAC DATE ,
                              FECHA_INTERPOSICION_DEMANDA DATE ,
                              FECHA_JUNTA_ACREEDORES DATE ,
                              FECHA_REG_RESOL_APERTURA_LIQ DATE ,
                              TD_AUTO_FC_DIA_ANALISIS_ID NUMBER(16,0) ,
                              TD_AUTO_FC_LIQUIDACION_ID NUMBER(16,0) ,
                              ESTADO_CONVENIO_ID NUMBER(16,0) ,
                              SEGUIMIENTO_CONVENIO_ID NUMBER(16,0) ,
                              T_PORCENTAJE_QUITA_ID NUMBER(16,0) ,
                              GARANTIA_CONCURSO_ID NUMBER(16,0) ,
                              -- M?tricas
                              NUM_CONCURSOS INTEGER ,
                              P_AUTO_FC_DIA_ANALISIS INTEGER ,
                              P_AUTO_FC_LIQUIDACION INTEGER ,
                              P_PUB_BOE_INSI_CRE INTEGER ,
                              P_AUTO_FC_AUTO_APER_CONV INTEGER ,
                              P_REG_IAC_INTERP_DEM INTEGER ,
                              P_AUTO_APER_CONV_J_ACREE INTEGER ,
                              P_AUTO_FC_REG_RESOL_APER_LIQ_D INTEGER ,
                              P_AUTO_FC_REG_RESOL_APER_LIQ_C INTEGER ,
                              CUANTIA_CONVENIO NUMBER(14,2) ,
                              QUITA_CONVENIO NUMBER(14,2) ,
							  FASE_SUBASTA_CONCURSAL_ID NUMBER(16,0)

                            )
			  SEGMENT CREATION IMMEDIATE 
					TABLESPACE "RECOVERY_PRODUC_DWH" 
                    PARTITION BY RANGE ("DIA_ID")
                    INTERVAL(NUMTOYMINTERVAL(1, ''''MONTH''''))
                    (PARTITION "p1" VALUES LESS THAN (TO_DATE('''' 2014-11-01 00:00:00'''', ''''SYYYY-MM-DD HH24:MI:SS'''', ''''NLS_CALENDAR=GREGORIAN''''))'', :error); END;';
	 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CONCU');

       V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CONCU_IX'', ''H_CONCU (DIA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CONCU');



    

    ------------------------------ H_CONCU_SEMANA --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CONCU_SEMANA'',
						  ''SEMANA_ID NUMBER(16,0) NOT NULL,
                          FECHA_CARGA_DATOS DATE NOT NULL,
                          PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                          -- Dimensiones
                          FECHA_AUTO_FASE_COMUN DATE ,
                          FECHA_LIQUIDACION DATE ,
                          FECHA_PUBLICACION_BOE DATE ,
                          FECHA_INSINUACION_FINAL_CRED DATE ,
                          FECHA_AUTO_APERTURA_CONVENIO DATE ,
                          FECHA_REGISTRAR_IAC DATE ,
                          FECHA_INTERPOSICION_DEMANDA DATE ,
                          FECHA_JUNTA_ACREEDORES DATE ,
                          FECHA_REG_RESOL_APERTURA_LIQ DATE ,
                          TD_AUTO_FC_DIA_ANALISIS_ID NUMBER(16,0) ,
                          TD_AUTO_FC_LIQUIDACION_ID NUMBER(16,0) ,
                          ESTADO_CONVENIO_ID NUMBER(16,0) ,
                          SEGUIMIENTO_CONVENIO_ID NUMBER(16,0) ,
                          T_PORCENTAJE_QUITA_ID NUMBER(16,0) ,
                          GARANTIA_CONCURSO_ID NUMBER(16,0) ,
                          -- M?tricas
                          NUM_CONCURSOS INTEGER ,
                          P_AUTO_FC_DIA_ANALISIS INTEGER ,
                          P_AUTO_FC_LIQUIDACION INTEGER ,
                          P_PUB_BOE_INSI_CRE INTEGER ,
                          P_AUTO_FC_AUTO_APER_CONV INTEGER ,
                          P_REG_IAC_INTERP_DEM INTEGER ,
                          P_AUTO_APER_CONV_J_ACREE INTEGER ,
                          P_AUTO_FC_REG_RESOL_APER_LIQ_D INTEGER ,
                          P_AUTO_FC_REG_RESOL_APER_LIQ_C INTEGER ,
                          CUANTIA_CONVENIO NUMBER(14,2) ,
                          QUITA_CONVENIO NUMBER(14,2) ,
						  FASE_SUBASTA_CONCURSAL_ID NUMBER(16,0)

                        '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CONCU_SEMANA');

       V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CONCU_SEMANA_IX'', ''H_CONCU_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CONCU_SEMANA');



    
    
    ------------------------------ H_CONCU_MES --------------------------



    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CONCU_MES'',
						  ''MES_ID NUMBER(16,0) NOT NULL,
                          FECHA_CARGA_DATOS DATE NOT NULL,
                          PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                          -- Dimensiones
                          FECHA_AUTO_FASE_COMUN DATE ,
                          FECHA_LIQUIDACION DATE ,
                          FECHA_PUBLICACION_BOE DATE ,
                          FECHA_INSINUACION_FINAL_CRED DATE ,
                          FECHA_AUTO_APERTURA_CONVENIO DATE ,
                          FECHA_REGISTRAR_IAC DATE ,
                          FECHA_INTERPOSICION_DEMANDA DATE ,
                          FECHA_JUNTA_ACREEDORES DATE ,
                          FECHA_REG_RESOL_APERTURA_LIQ DATE ,
                          TD_AUTO_FC_DIA_ANALISIS_ID NUMBER(16,0) ,
                          TD_AUTO_FC_LIQUIDACION_ID NUMBER(16,0) ,
                          ESTADO_CONVENIO_ID NUMBER(16,0) ,
                          SEGUIMIENTO_CONVENIO_ID NUMBER(16,0) ,
                          T_PORCENTAJE_QUITA_ID NUMBER(16,0) ,
                          GARANTIA_CONCURSO_ID NUMBER(16,0) ,
                          -- M?tricas
                          NUM_CONCURSOS INTEGER ,
                          P_AUTO_FC_DIA_ANALISIS INTEGER ,
                          P_AUTO_FC_LIQUIDACION INTEGER ,
                          P_PUB_BOE_INSI_CRE INTEGER ,
                          P_AUTO_FC_AUTO_APER_CONV INTEGER ,
                          P_REG_IAC_INTERP_DEM INTEGER ,
                          P_AUTO_APER_CONV_J_ACREE INTEGER ,
                          P_AUTO_FC_REG_RESOL_APER_LIQ_D INTEGER ,
                          P_AUTO_FC_REG_RESOL_APER_LIQ_C INTEGER ,
                          CUANTIA_CONVENIO NUMBER(14,2) ,
                          QUITA_CONVENIO NUMBER(14,2) ,
						  FASE_SUBASTA_CONCURSAL_ID NUMBER(16,0)

                         '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CONCU_MES');

        V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CONCU_MES_IX'', ''H_CONCU_MES (MES_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CONCU_MES');



    

    ------------------------------ H_CONCU_TRIMESTRE --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CONCU_TRIMESTRE'',
						  ''TRIMESTRE_ID NUMBER(16,0) NOT NULL,
                          FECHA_CARGA_DATOS DATE NOT NULL,
                          PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                          -- Dimensiones
                          FECHA_AUTO_FASE_COMUN DATE ,
                          FECHA_LIQUIDACION DATE ,
                          FECHA_PUBLICACION_BOE DATE ,
                          FECHA_INSINUACION_FINAL_CRED DATE ,
                          FECHA_AUTO_APERTURA_CONVENIO DATE ,
                          FECHA_REGISTRAR_IAC DATE ,
                          FECHA_INTERPOSICION_DEMANDA DATE ,
                          FECHA_JUNTA_ACREEDORES DATE ,
                          FECHA_REG_RESOL_APERTURA_LIQ DATE ,
                          TD_AUTO_FC_DIA_ANALISIS_ID NUMBER(16,0) ,
                          TD_AUTO_FC_LIQUIDACION_ID NUMBER(16,0) ,
                          ESTADO_CONVENIO_ID NUMBER(16,0) ,
                          SEGUIMIENTO_CONVENIO_ID NUMBER(16,0) ,
                          T_PORCENTAJE_QUITA_ID NUMBER(16,0) ,
                          GARANTIA_CONCURSO_ID NUMBER(16,0) ,
                          -- M?tricas
                          NUM_CONCURSOS INTEGER ,
                          P_AUTO_FC_DIA_ANALISIS INTEGER ,
                          P_AUTO_FC_LIQUIDACION INTEGER ,
                          P_PUB_BOE_INSI_CRE INTEGER ,
                          P_AUTO_FC_AUTO_APER_CONV INTEGER ,
                          P_REG_IAC_INTERP_DEM INTEGER ,
                          P_AUTO_APER_CONV_J_ACREE INTEGER ,
                          P_AUTO_FC_REG_RESOL_APER_LIQ_D INTEGER ,
                          P_AUTO_FC_REG_RESOL_APER_LIQ_C INTEGER ,
                          CUANTIA_CONVENIO NUMBER(14,2) ,
                          QUITA_CONVENIO NUMBER(14,2) ,
						  FASE_SUBASTA_CONCURSAL_ID NUMBER(16,0)

                          '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CONCU_TRIMESTRE');

        V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CONCU_TRIMESTRE_IX'', ''H_CONCU_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CONCU_TRIMESTRE');



    

    ------------------------------ H_CONCU_ANIO --------------------------



    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_CONCU_ANIO'',
						  ''ANIO_ID NUMBER(16,0) NOT NULL,
                          FECHA_CARGA_DATOS DATE NOT NULL,
                          PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                          -- Dimensiones
                          FECHA_AUTO_FASE_COMUN DATE ,
                          FECHA_LIQUIDACION DATE ,
                          FECHA_PUBLICACION_BOE DATE ,
                          FECHA_INSINUACION_FINAL_CRED DATE ,
                          FECHA_AUTO_APERTURA_CONVENIO DATE ,
                          FECHA_REGISTRAR_IAC DATE ,
                          FECHA_INTERPOSICION_DEMANDA DATE ,
                          FECHA_JUNTA_ACREEDORES DATE ,
                          FECHA_REG_RESOL_APERTURA_LIQ DATE ,
                          TD_AUTO_FC_DIA_ANALISIS_ID NUMBER(16,0) ,
                          TD_AUTO_FC_LIQUIDACION_ID NUMBER(16,0) ,
                          ESTADO_CONVENIO_ID NUMBER(16,0) ,
                          SEGUIMIENTO_CONVENIO_ID NUMBER(16,0) ,
                          T_PORCENTAJE_QUITA_ID NUMBER(16,0) ,
                          GARANTIA_CONCURSO_ID NUMBER(16,0) ,
                          -- M?tricas
                          NUM_CONCURSOS INTEGER ,
                          P_AUTO_FC_DIA_ANALISIS INTEGER ,
                          P_AUTO_FC_LIQUIDACION INTEGER ,
                          P_PUB_BOE_INSI_CRE INTEGER ,
                          P_AUTO_FC_AUTO_APER_CONV INTEGER ,
                          P_REG_IAC_INTERP_DEM INTEGER ,
                          P_AUTO_APER_CONV_J_ACREE INTEGER ,
                          P_AUTO_FC_REG_RESOL_APER_LIQ_D INTEGER ,
                          P_AUTO_FC_REG_RESOL_APER_LIQ_C INTEGER ,
                          CUANTIA_CONVENIO NUMBER(14,2) ,
                          QUITA_CONVENIO NUMBER(14,2) ,
						  FASE_SUBASTA_CONCURSAL_ID NUMBER(16,0)

                          '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_CONCU_ANIO');

        V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CONCU_ANIO_IX'', ''H_CONCU_ANIO (ANIO_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_CONCU_ANIO');



    

    ------------------------------ TMP_CONCU_JERARQUIA --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_CONCU_JERARQUIA'',
						  ''DIA_ID DATE NOT NULL,
                            ITER NUMBER(16,0) NOT NULL,
                            FASE_ACTUAL NUMBER(16,0) ,
                            FASE_MAX_PRIORIDAD NUMBER(16,0) ,
                            NIVEL NUMBER(2,0) ,
                            CONTEXTO VARCHAR2(600) ,
                            CODIGO_FASE_ACTUAL VARCHAR2(20) ,
                            PRIORIDAD_FASE INTEGER ,
                            ASUNTO NUMBER(16,0) ,
                            PRIORIDAD_PROCEDIMIENTO INTEGER ,
                            TIPO_PROCEDIMIENTO_DET NUMBER(16,0) ,
                            FASE_PARALIZADA INTEGER ,
                            FASE_FINALIZADA INTEGER ,
                            FASE_CON_RECURSO INTEGER

                         '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_CONCU_JERARQUIA');

      
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CONCU_JRQ_ITER_IX'', ''TMP_CONCU_JERARQUIA (DIA_ID, ITER)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
        V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CONCU_JRQ_FASE_ACT_IX'', ''TMP_CONCU_JERARQUIA (DIA_ID, FASE_ACTUAL)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_CONCU_JERARQUIA');



    

    ------------------------------ TMP_CONCU_DETALLE --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_CONCU_DETALLE'',
						  ''ITER NUMBER(16,0)  ,
                            MAX_PRIORIDAD NUMBER(16,0) ,
                            FASE_MAX_PRIORIDAD NUMBER(16,0) ,
                            FECHA_AUTO_FASE_COMUN DATE ,
                            FECHA_LIQUIDACION DATE ,
                            FECHA_PUBLICACION_BOE DATE ,
                            FECHA_INSINUACION_FINAL_CRED DATE ,
                            FECHA_AUTO_APERTURA_CONVENIO DATE ,
                            FECHA_REGISTRAR_IAC DATE ,
                            FECHA_INTERPOSICION_DEMANDA DATE ,
                            FECHA_JUNTA_ACREEDORES DATE ,
                            FECHA_REG_RESOL_APERTURA_LIQ DATE ,
                            ESTADO_CONVENIO NUMBER(16,0) ,
                            SEGUIMIENTO_CONVENIO NUMBER(16,0) ,
                            CUANTIA_CONVENIO NUMBER(14,2) ,
                            QUITA_CONVENIO NUMBER(14,2) ,
                            GARANTIA_CONCURSO NUMBER(16,0) ,
							FASE_SUBASTA_CONCURSAL_ID NUMBER(16,0)

                          '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_CONCU_DETALLE');

        V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CONCU_DETALLE_IX'', ''TMP_CONCU_DETALLE (TMP_CONCU_DETALLE)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_CONCU_DETALLE');



    

    ------------------------------ TMP_CONCU_TAREA --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_CONCU_TAREA'',
						  ''ITER NUMBER(16,0) ,
                            FASE NUMBER(16,0) ,
                            TAREA NUMBER(16,0) ,
                            DESCRIPCION_TAREA VARCHAR2(100) ,
                            FECHA_INI TIMESTAMP ,
                            FECHA_FIN TIMESTAMP ,
                            TAP_ID NUMBER(16,0) ,
                            TAR_ID NUMBER(16,0) ,
                            TEX_ID NUMBER(16,0) ,
                            DESCRIPCION_FORMULARIO VARCHAR2(50) ,        -- TEV_NOMBRE (TEV_TAREA_EXTERNA_VALOR)
                            FECHA_FORMULARIO DATE ,                     -- TEV_VALOR (TEV_TAREA_EXTERNA_VALOR)
                            VALOR_FORMULARIO  VARCHAR2(50)               -- TEV_VALOR (cuando no es fecha)

                         '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_CONCU_TAREA');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CONCU_TAREA_IX'', ''TMP_CONCU_TAREA (ITER, TAREA)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_CONCU_TAREA');


    

    ------------------------------ TMP_CONCU_CONVENIO --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_CONCU_CONVENIO'',
						  ''ITER NUMBER(16,0) ,
                            FASE NUMBER(16,0) ,
                            TAREA NUMBER(16,0) ,
                            DESCRIPCION_TAREA VARCHAR2(100) ,
                            FECHA_INI TIMESTAMP ,
                            FECHA_FIN TIMESTAMP ,
                            TAP_ID NUMBER(16,0) ,
                            TAR_ID NUMBER(16,0) ,
                            TEX_ID NUMBER(16,0) ,
                            MAX_FECHA_FIN TIMESTAMP,
                            DESCRIPCION_FORMULARIO VARCHAR2(50) ,        -- TEV_NOMBRE (TEV_TAREA_EXTERNA_VALOR)
                            FECHA_FORMULARIO DATE ,                     -- TEV_VALOR (TEV_TAREA_EXTERNA_VALOR)
                            VALOR_FORMULARIO  VARCHAR2(50)               -- TEV_VALOR (cuando no es fecha)

                         '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_CONCU_CONVENIO');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CONCU_CONVENIO_IX'', ''TMP_CONCU_CONVENIO (ITER, TAREA)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_CONCU_CONVENIO');


    

    ------------------------------ TMP_CONCU_AUX --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_CONCU_AUX'',
						  ''ITER NUMBER(16,0) ,
                            TAREA NUMBER(16,0) ,
                            FECHA_INI TIMESTAMP ,
                            MAX_FECHA_INI TIMESTAMP

                         '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_CONCU_AUX');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CONCU_AUX_IX'', ''TMP_CONCU_AUX (ITER, TAREA)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_CONCU_AUX');


    

    ------------------------------ TMP_CONCU_CONTRATO --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_CONCU_CONTRATO'',
						  ''PROCEDIMIENTO_ID NUMBER(16,0) ,
                            CONTRATO_ID NUMBER(16,0) ,
                            GARANTIA NUMBER(16,0)

                        '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_CONCU_CONTRATO');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CONCU_CONTRATO_IX'', ''TMP_CONCU_CONTRATO (PROCEDIMIENTO_ID, CONTRATO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_CONCU_CONTRATO');


    

    ------------------------------ H_DECL --------------------------



    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_DECL'',
						  ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              -- Dimensiones
                              FECHA_INTERP_DEM_DECLARATIVO DATE ,
                              FECHA_RESOLUCION_FIRME DATE ,
                              TD_ID_DECL_RESOL_FIRME_ID NUMBER(16,0) ,
                              -- M?tricas
                              NUM_DECLARATIVOS INTEGER ,
                              P_ID_DECL_RESOL_FIRME INTEGER
                            )
			  SEGMENT CREATION IMMEDIATE 
					TABLESPACE "RECOVERY_PRODUC_DWH" 
                    PARTITION BY RANGE ("DIA_ID")
                    INTERVAL(NUMTOYMINTERVAL(1, ''''MONTH''''))
                    (PARTITION "p1" VALUES LESS THAN (TO_DATE('''' 2014-11-01 00:00:00'''', ''''SYYYY-MM-DD HH24:MI:SS'''', ''''NLS_CALENDAR=GREGORIAN''''))'', :error); END;';
	 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_DECL');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_DECL_IX'', ''H_DECL (DIA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_DECL');



    
    
    ------------------------------ H_DECL_SEMANA --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_DECL_SEMANA'',
						  ''SEMANA_ID NUMBER(16,0) NOT NULL,
                          FECHA_CARGA_DATOS DATE NOT NULL,
                          PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                          -- Dimensiones
                          FECHA_INTERP_DEM_DECLARATIVO DATE ,
                          FECHA_RESOLUCION_FIRME DATE ,
                          TD_ID_DECL_RESOL_FIRME_ID NUMBER(16,0) ,
                          -- M?tricas
                          NUM_DECLARATIVOS INTEGER ,
                          P_ID_DECL_RESOL_FIRME INTEGER

                          '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_DECL_SEMANA');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_DECL_SEMANA_IX'', ''H_DECL_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_DECL_SEMANA');



    
    
    ------------------------------ H_DECL_MES --------------------------



    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_DECL_MES'',
						  ''MES_ID NUMBER(16,0) NOT NULL,
                          FECHA_CARGA_DATOS DATE NOT NULL,
                          PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                          -- Dimensiones
                          FECHA_INTERP_DEM_DECLARATIVO DATE ,
                          FECHA_RESOLUCION_FIRME DATE ,
                          TD_ID_DECL_RESOL_FIRME_ID NUMBER(16,0) ,
                          -- M?tricas
                          NUM_DECLARATIVOS INTEGER ,
                          P_ID_DECL_RESOL_FIRME INTEGER

                          '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_DECL_MES');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_DECL_MES_IX'', ''H_DECL_MES (MES_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_DECL_MES');



    

    ------------------------------ H_DECL_TRIMESTRE --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_DECL_TRIMESTRE'',
						  ''TRIMESTRE_ID NUMBER(16,0) NOT NULL,
                          FECHA_CARGA_DATOS DATE NOT NULL,
                          PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                          -- Dimensiones
                          FECHA_INTERP_DEM_DECLARATIVO DATE ,
                          FECHA_RESOLUCION_FIRME DATE ,
                          TD_ID_DECL_RESOL_FIRME_ID NUMBER(16,0) ,
                          -- M?tricas
                          NUM_DECLARATIVOS INTEGER ,
                          P_ID_DECL_RESOL_FIRME INTEGER

                          '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_DECL_TRIMESTRE');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_DECL_TRIMESTRE_IX'', ''H_DECL_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_DECL_TRIMESTRE');



    

    ------------------------------ H_DECL_ANIO --------------------------



    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_DECL_ANIO'',
						  ''ANIO_ID NUMBER(16,0) NOT NULL,
                          FECHA_CARGA_DATOS DATE NOT NULL,
                          PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                          -- Dimensiones
                          FECHA_INTERP_DEM_DECLARATIVO DATE ,
                          FECHA_RESOLUCION_FIRME DATE ,
                          TD_ID_DECL_RESOL_FIRME_ID NUMBER(16,0) ,
                          -- M?tricas
                          NUM_DECLARATIVOS INTEGER ,
                          P_ID_DECL_RESOL_FIRME INTEGER

                          '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_DECL_ANIO');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_DECL_ANIO_IX'', ''H_DECL_ANIO (ANIO_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_DECL_ANIO');



    

    ------------------------------ TMP_DECL_JERARQUIA --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_DECL_JERARQUIA'',
						  ''DIA_ID DATE NOT NULL,
                          ITER NUMBER(16,0) NOT NULL,
                          FASE_ACTUAL NUMBER(16,0) ,
                          FASE_MAX_PRIORIDAD NUMBER(16,0) ,
                          NIVEL NUMBER(2,0) ,
                          CONTEXTO VARCHAR2(600) ,
                          CODIGO_FASE_ACTUAL VARCHAR2(20) ,
                          PRIORIDAD_FASE INTEGER ,
                          ASUNTO NUMBER(16,0) ,
                          PRIORIDAD_PROCEDIMIENTO INTEGER ,
                          TIPO_PROCEDIMIENTO_DET NUMBER(16,0) ,
                          FASE_PARALIZADA INTEGER ,
                          FASE_FINALIZADA INTEGER ,
                          FASE_CON_RECURSO INTEGER

                          '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_DECL_JERARQUIA');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_DECL_JRQ_ITER_IX'', ''TMP_DECL_JERARQUIA (DIA_ID, ITER)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_DECL_JRQ_FASE_ACT_IX'', ''TMP_DECL_JERARQUIA (DIA_ID, FASE_ACTUAL)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_DECL_JERARQUIA');



    

    ------------------------------ TMP_DECL_DETALLE --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_DECL_DETALLE'',
						  ''ITER NUMBER(16,0),
                            MAX_PRIORIDAD NUMBER(16,0),
                            FASE_MAX_PRIORIDAD NUMBER(16,0),
                            FECHA_INTERP_DEM_DECLARATIVO DATE,
                            FECHA_RESOLUCION_FIRME DATE

                          '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_DECL_DETALLE');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_DECL_DETALLE_IX'', ''TMP_DECL_DETALLE (ITER)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_DECL_DETALLE');



    

    ------------------------------ TMP_DECL_TAREA --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_DECL_TAREA'',
						  ''ITER NUMBER(16,0) ,
                              FASE NUMBER(16,0) ,
                              TAREA NUMBER(16,0) ,
                              DESCRIPCION_TAREA VARCHAR2(100) ,
                              FECHA_INI TIMESTAMP ,
                              FECHA_FIN TIMESTAMP ,
                              TAP_ID NUMBER(16,0) ,
                              TAR_ID NUMBER(16,0) ,
                              TEX_ID NUMBER(16,0) ,
                              DESCRIPCION_FORMULARIO VARCHAR2(50) ,        -- TEV_NOMBRE (TEV_TAREA_EXTERNA_VALOR)
                              FECHA_FORMULARIO DATE                       -- TEV_VALOR (TEV_TAREA_EXTERNA_VALOR)

                           '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_DECL_TAREA');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_DECL_TAREA_IX'', ''TMP_DECL_TAREA (ITER, TAREA)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_DECL_TAREA');



    

    ------------------------------ H_EJEC_ORD --------------------------



    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_EJEC_ORD'',
						  ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              -- Dimensiones
                              FECHA_INTERP_DEM_EJEC_ORD DATE ,
                              FECHA_INICIO_APREMIO DATE ,
                              TD_ID_ORD_INI_APREMIO_ID NUMBER(16,0) ,
                              -- M?tricas
                              NUM_EJECUCION_ORDINARIAS INTEGER ,
                              P_ID_ORD_INI_APREMIO INTEGER

                             )
			  SEGMENT CREATION IMMEDIATE 
					TABLESPACE "RECOVERY_PRODUC_DWH" 
                    PARTITION BY RANGE ("DIA_ID")
                    INTERVAL(NUMTOYMINTERVAL(1, ''''MONTH''''))
                    (PARTITION "p1" VALUES LESS THAN (TO_DATE('''' 2014-11-01 00:00:00'''', ''''SYYYY-MM-DD HH24:MI:SS'''', ''''NLS_CALENDAR=GREGORIAN''''))'', :error); END;';
	 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_EJEC_ORD');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EJEC_ORD_IX'', ''H_EJEC_ORD (DIA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_EJEC_ORD');


    

    ------------------------------ H_EJEC_ORD_SEMANA --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_EJEC_ORD_SEMANA'',
						  ''SEMANA_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              -- Dimensiones
                              FECHA_INTERP_DEM_EJEC_ORD DATE ,
                              FECHA_INICIO_APREMIO DATE ,
                              TD_ID_ORD_INI_APREMIO_ID NUMBER(16,0) ,
                              -- M?tricas
                              NUM_EJECUCION_ORDINARIAS INTEGER ,
                              P_ID_ORD_INI_APREMIO INTEGER

                            '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_EJEC_ORD_SEMANA');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EJEC_ORD_SEMANA_IX'', ''H_EJEC_ORD_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_EJEC_ORD_SEMANA');


    

    ------------------------------ H_EJEC_ORD_MES --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_EJEC_ORD_MES'',
						  ''MES_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              -- Dimensiones
                              FECHA_INTERP_DEM_EJEC_ORD DATE ,
                              FECHA_INICIO_APREMIO DATE ,
                              TD_ID_ORD_INI_APREMIO_ID NUMBER(16,0) ,
                              -- M?tricas
                              NUM_EJECUCION_ORDINARIAS INTEGER ,
                              P_ID_ORD_INI_APREMIO INTEGER

                            '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_EJEC_ORD_MES');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EJEC_ORD_MES_IX'', ''H_EJEC_ORD_MES (MES_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_EJEC_ORD_MES');


    

    ------------------------------ H_EJEC_ORD_TRIMESTRE --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_EJEC_ORD_TRIMESTRE'',
						  ''TRIMESTRE_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              -- Dimensiones
                              FECHA_INTERP_DEM_EJEC_ORD DATE ,
                              FECHA_INICIO_APREMIO DATE ,
                              TD_ID_ORD_INI_APREMIO_ID NUMBER(16,0) ,
                              -- M?tricas
                              NUM_EJECUCION_ORDINARIAS INTEGER ,
                              P_ID_ORD_INI_APREMIO INTEGER

                           '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_EJEC_ORD_TRIMESTRE');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EJEC_ORD_TRIMESTRE_IX'', ''H_EJEC_ORD_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_EJEC_ORD_TRIMESTRE');


    

    ------------------------------ H_EJEC_ORD_ANIO --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_EJEC_ORD_ANIO'',
						  ''ANIO_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              -- Dimensiones
                              FECHA_INTERP_DEM_EJEC_ORD DATE ,
                              FECHA_INICIO_APREMIO DATE ,
                              TD_ID_ORD_INI_APREMIO_ID NUMBER(16,0) ,
                              -- M?tricas
                              NUM_EJECUCION_ORDINARIAS INTEGER ,
                              P_ID_ORD_INI_APREMIO INTEGER

                            '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_EJEC_ORD_ANIO');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EJEC_ORD_ANIO_IX'', ''H_EJEC_ORD_ANIO (ANIO_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_EJEC_ORD_ANIO');


    

    ------------------------------ TMP_EJEC_ORD_JERARQUIA --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_EJEC_ORD_JERARQUIA'',
						  ''DIA_ID DATE NOT NULL,
                          ITER NUMBER(16,0) NOT NULL,
                          FASE_ACTUAL NUMBER(16,0) ,
                          FASE_MAX_PRIORIDAD NUMBER(16,0) ,
                          NIVEL NUMBER(2,0) ,
                          CONTEXTO VARCHAR2(600) ,
                          CODIGO_FASE_ACTUAL VARCHAR2(20) ,
                          PRIORIDAD_FASE INTEGER ,
                          ASUNTO NUMBER(16,0) ,
                          PRIORIDAD_PROCEDIMIENTO INTEGER ,
                          TIPO_PROCEDIMIENTO_DET NUMBER(16,0) ,
                          FASE_PARALIZADA INTEGER ,
                          FASE_FINALIZADA INTEGER ,
                          FASE_CON_RECURSO INTEGER

                         '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_EJEC_ORD_JERARQUIA');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_EJEC_ORD_JRQ_ITER_IX'', ''TMP_EJEC_ORD_JERARQUIA (DIA_ID, ITER)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_EJEC_ORD_JRQ_FASE_ACT_IX'', ''TMP_EJEC_ORD_JERARQUIA (DIA_ID, FASE_ACTUAL)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_EJEC_ORD_JERARQUIA');



    

    ------------------------------ TMP_EJEC_ORD_DETALLE --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_EJEC_ORD_DETALLE'',
						  ''ITER NUMBER(16,0)  ,
                          MAX_PRIORIDAD NUMBER(16,0) ,
                          FASE_MAX_PRIORIDAD NUMBER(16,0) ,
                          FECHA_INTERP_DEM_EJEC_ORD DATE ,
                          FECHA_INICIO_APREMIO DATE

                          '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_EJEC_ORD_DETALLE');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_EJEC_ORD_DETALLE_IX'', ''TMP_EJEC_ORD_DETALLE (ITER)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_EJEC_ORD_DETALLE');



    

    ------------------------------ TMP_EJEC_ORD_TAREA --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_EJEC_ORD_TAREA'',
						  ''ITER NUMBER(16,0) ,
                          FASE NUMBER(16,0) ,
                          TAREA NUMBER(16,0) ,
                          DESCRIPCION_TAREA VARCHAR2(100) ,
                          FECHA_INI TIMESTAMP ,
                          FECHA_FIN TIMESTAMP ,
                          TAP_ID NUMBER(16,0) ,
                          TAR_ID NUMBER(16,0) ,
                          TEX_ID NUMBER(16,0) ,
                          DESCRIPCION_FORMULARIO VARCHAR2(50) ,        -- TEV_NOMBRE (TEV_TAREA_EXTERNA_VALOR)
                          FECHA_FORMULARIO DATE                     -- TEV_VALOR (TEV_TAREA_EXTERNA_VALOR)

                         '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_EJEC_ORD_TAREA');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_EJEC_ORD_TAREA_IX'', ''TMP_EJEC_ORD_TAREA (ITER, TAREA)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_EJEC_ORD_TAREA');


    

    ------------------------------ H_HIPO --------------------------



    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_HIPO'',
						  ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              -- Dimensiones
                              FECHA_CREACION_ASUNTO DATE ,
                              FECHA_INTERP_DEM_HIP DATE ,
                              FECHA_SUBASTA_SOLICITADA DATE ,
                              FECHA_SUBASTA DATE ,
                              FECHA_CESION_REMATE DATE ,
                              FECHA_SOL_DECRETO_ADJ DATE ,
                              FECHA_CELEBRACION_SUBASTA DATE ,
                              FECHA_RECEP_TESTIMONIO DATE ,
                              FECHA_DECRETO_ADJ DATE ,
                              FASE_SUBASTA_HIPOTECARIO_ID NUMBER(16,0) ,
                              ULT_TAR_FASE_HIP_ID NUMBER(16,0) NOT NULL ,
                              TD_ID_HIP_SUBASTA_ID NUMBER(16,0) ,
                              TD_SUB_SOL_SUB_CEL_ID NUMBER(16,0) ,
                              TD_SUB_CEL_CESION_REMATE_ID NUMBER(16,0) ,
                              TD_CEL_ADJUDICACION_ID NUMBER(16,0) ,
                              TD_RECEP_DECRE_ADJUDICA_ID NUMBER(16,0) ,
                              -- M?tricas
                              NUM_HIPOTECARIOS INTEGER,
                              P_CREACION_ASU_SUBASTA INTEGER,
                              P_CREACION_ASU_CESION_REMATE INTEGER,
                              P_CREACION_ASU_ADJUDICACION INTEGER,
                              P_ID_HIP_SUBASTA INTEGER,
                              P_INTERP_DEM_HIP_CESION_REMATE INTEGER,
                              P_INTERP_DEM_HIP_ADJUDICACION INTEGER ,
                              P_SUBASTA_ADJUDICACION INTEGER,
                              P_SUB_SOL_SUB_CEL INTEGER,
                              P_SUB_CEL_CESION_REMATE INTEGER,
                              P_CEL_ADJUDICACION INTEGER,
                              P_ENTRA_REG_RECEPCION INTEGER

                            )
			  SEGMENT CREATION IMMEDIATE 
					TABLESPACE "RECOVERY_PRODUC_DWH" 
                    PARTITION BY RANGE ("DIA_ID")
                    INTERVAL(NUMTOYMINTERVAL(1, ''''MONTH''''))
                    (PARTITION "p1" VALUES LESS THAN (TO_DATE('''' 2014-11-01 00:00:00'''', ''''SYYYY-MM-DD HH24:MI:SS'''', ''''NLS_CALENDAR=GREGORIAN''''))'', :error); END;';
	 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_HIPO');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_HIPO_IX'', ''H_HIPO (DIA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_HIPO');



    

    ------------------------------ H_HIPO_SEMANA --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_HIPO_SEMANA'',
						  ''SEMANA_ID NUMBER(16,0) NOT NULL,
                          FECHA_CARGA_DATOS DATE NOT NULL,
                          PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                          -- Dimensiones
                          FECHA_CREACION_ASUNTO DATE ,
                          FECHA_INTERP_DEM_HIP DATE ,
                          FECHA_SUBASTA_SOLICITADA DATE ,
                          FECHA_SUBASTA DATE ,
                          FECHA_CESION_REMATE DATE ,
                          FECHA_SOL_DECRETO_ADJ DATE ,
                          FECHA_CELEBRACION_SUBASTA DATE ,
                          FECHA_RECEP_TESTIMONIO DATE ,
                          FECHA_DECRETO_ADJ DATE ,
                          FASE_SUBASTA_HIPOTECARIO_ID NUMBER(16,0) ,
                          ULT_TAR_FASE_HIP_ID NUMBER(16,0) NOT NULL ,
                          TD_ID_HIP_SUBASTA_ID NUMBER(16,0) ,
                          TD_SUB_SOL_SUB_CEL_ID NUMBER(16,0) ,
                          TD_SUB_CEL_CESION_REMATE_ID NUMBER(16,0) ,
                          TD_CEL_ADJUDICACION_ID NUMBER(16,0) ,
                          TD_RECEP_DECRE_ADJUDICA_ID NUMBER(16,0) ,
                          -- M?tricas
                          NUM_HIPOTECARIOS INTEGER,
                          P_CREACION_ASU_SUBASTA INTEGER,
                          P_CREACION_ASU_CESION_REMATE INTEGER,
                          P_CREACION_ASU_ADJUDICACION INTEGER,
                          P_ID_HIP_SUBASTA INTEGER,
                          P_INTERP_DEM_HIP_CESION_REMATE INTEGER,
                          P_INTERP_DEM_HIP_ADJUDICACION INTEGER ,
                          P_SUBASTA_ADJUDICACION INTEGER,
                          P_SUB_SOL_SUB_CEL INTEGER,
                          P_SUB_CEL_CESION_REMATE INTEGER,
                          P_CEL_ADJUDICACION INTEGER,
                          P_ENTRA_REG_RECEPCION INTEGER

                          '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_HIPO_SEMANA');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_HIPO_SEMANA_IX'', ''H_HIPO_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_HIPO_SEMANA');



        

    ------------------------------ H_HIPO_MES --------------------------



    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_HIPO_MES'',
						  ''MES_ID NUMBER(16,0) NOT NULL,
                          FECHA_CARGA_DATOS DATE NOT NULL,
                          PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                          -- Dimensiones
                          FECHA_CREACION_ASUNTO DATE ,
                          FECHA_INTERP_DEM_HIP DATE ,
                          FECHA_SUBASTA_SOLICITADA DATE ,
                          FECHA_SUBASTA DATE ,
                          FECHA_CESION_REMATE DATE ,
                          FECHA_SOL_DECRETO_ADJ DATE ,
                          FECHA_CELEBRACION_SUBASTA DATE ,
                          FECHA_RECEP_TESTIMONIO DATE ,
                          FECHA_DECRETO_ADJ DATE ,
                          FASE_SUBASTA_HIPOTECARIO_ID NUMBER(16,0) ,
                          ULT_TAR_FASE_HIP_ID NUMBER(16,0) NOT NULL ,
                          TD_ID_HIP_SUBASTA_ID NUMBER(16,0) ,
                          TD_SUB_SOL_SUB_CEL_ID NUMBER(16,0) ,
                          TD_SUB_CEL_CESION_REMATE_ID NUMBER(16,0) ,
                          TD_CEL_ADJUDICACION_ID NUMBER(16,0) ,
                          TD_RECEP_DECRE_ADJUDICA_ID NUMBER(16,0) ,
                          -- M?tricas
                          NUM_HIPOTECARIOS INTEGER,
                          P_CREACION_ASU_SUBASTA INTEGER,
                          P_CREACION_ASU_CESION_REMATE INTEGER,
                          P_CREACION_ASU_ADJUDICACION INTEGER,
                          P_ID_HIP_SUBASTA INTEGER,
                          P_INTERP_DEM_HIP_CESION_REMATE INTEGER,
                          P_INTERP_DEM_HIP_ADJUDICACION INTEGER ,
                          P_SUBASTA_ADJUDICACION INTEGER,
                          P_SUB_SOL_SUB_CEL INTEGER,
                          P_SUB_CEL_CESION_REMATE INTEGER,
                          P_CEL_ADJUDICACION INTEGER,
                          P_ENTRA_REG_RECEPCION INTEGER

                          '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_HIPO_MES');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_HIPO_MES_IX'', ''H_HIPO_MES (MES_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_HIPO_MES');



    

    ------------------------------ H_HIPO_TRIMESTRE --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_HIPO_TRIMESTRE'',
						  ''TRIMESTRE_ID NUMBER(16,0) NOT NULL,
                          FECHA_CARGA_DATOS DATE NOT NULL,
                          PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                          -- Dimensiones
                          FECHA_CREACION_ASUNTO DATE ,
                          FECHA_INTERP_DEM_HIP DATE ,
                          FECHA_SUBASTA_SOLICITADA DATE ,
                          FECHA_SUBASTA DATE ,
                          FECHA_CESION_REMATE DATE ,
                          FECHA_SOL_DECRETO_ADJ DATE ,
                          FECHA_CELEBRACION_SUBASTA DATE ,
                          FECHA_RECEP_TESTIMONIO DATE ,
                          FECHA_DECRETO_ADJ DATE ,
                          FASE_SUBASTA_HIPOTECARIO_ID NUMBER(16,0) ,
                          ULT_TAR_FASE_HIP_ID NUMBER(16,0) NOT NULL ,
                          TD_ID_HIP_SUBASTA_ID NUMBER(16,0) ,
                          TD_SUB_SOL_SUB_CEL_ID NUMBER(16,0) ,
                          TD_SUB_CEL_CESION_REMATE_ID NUMBER(16,0) ,
                          TD_CEL_ADJUDICACION_ID NUMBER(16,0) ,
                          TD_RECEP_DECRE_ADJUDICA_ID NUMBER(16,0) ,
                          -- M?tricas
                          NUM_HIPOTECARIOS INTEGER,
                          P_CREACION_ASU_SUBASTA INTEGER,
                          P_CREACION_ASU_CESION_REMATE INTEGER,
                          P_CREACION_ASU_ADJUDICACION INTEGER,
                          P_ID_HIP_SUBASTA INTEGER,
                          P_INTERP_DEM_HIP_CESION_REMATE INTEGER,
                          P_INTERP_DEM_HIP_ADJUDICACION INTEGER ,
                          P_SUBASTA_ADJUDICACION INTEGER,
                          P_SUB_SOL_SUB_CEL INTEGER,
                          P_SUB_CEL_CESION_REMATE INTEGER,
                          P_CEL_ADJUDICACION INTEGER,
                          P_ENTRA_REG_RECEPCION INTEGER

                         '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_HIPO_TRIMESTRE');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_HIPO_TRIMESTRE_IX'', ''H_HIPO_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_HIPO_TRIMESTRE');



    

    ------------------------------ H_HIPO_ANIO --------------------------



    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_HIPO_ANIO'',
						  ''ANIO_ID NUMBER(16,0) NOT NULL,
                          FECHA_CARGA_DATOS DATE NOT NULL,
                          PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                          -- Dimensiones
                          FECHA_CREACION_ASUNTO DATE ,
                          FECHA_INTERP_DEM_HIP DATE ,
                          FECHA_SUBASTA_SOLICITADA DATE ,
                          FECHA_SUBASTA DATE ,
                          FECHA_CESION_REMATE DATE ,
                          FECHA_SOL_DECRETO_ADJ DATE ,
                          FECHA_CELEBRACION_SUBASTA DATE ,
                          FECHA_RECEP_TESTIMONIO DATE ,
                          FECHA_DECRETO_ADJ DATE ,
                          FASE_SUBASTA_HIPOTECARIO_ID NUMBER(16,0) ,
                          ULT_TAR_FASE_HIP_ID NUMBER(16,0) NOT NULL ,
                          TD_ID_HIP_SUBASTA_ID NUMBER(16,0) ,
                          TD_SUB_SOL_SUB_CEL_ID NUMBER(16,0) ,
                          TD_SUB_CEL_CESION_REMATE_ID NUMBER(16,0) ,
                          TD_CEL_ADJUDICACION_ID NUMBER(16,0) ,
                          TD_RECEP_DECRE_ADJUDICA_ID NUMBER(16,0) ,
                          -- M?tricas
                          NUM_HIPOTECARIOS INTEGER,
                          P_CREACION_ASU_SUBASTA INTEGER,
                          P_CREACION_ASU_CESION_REMATE INTEGER,
                          P_CREACION_ASU_ADJUDICACION INTEGER,
                          P_ID_HIP_SUBASTA INTEGER,
                          P_INTERP_DEM_HIP_CESION_REMATE INTEGER,
                          P_INTERP_DEM_HIP_ADJUDICACION INTEGER ,
                          P_SUBASTA_ADJUDICACION INTEGER,
                          P_SUB_SOL_SUB_CEL INTEGER,
                          P_SUB_CEL_CESION_REMATE INTEGER,
                          P_CEL_ADJUDICACION INTEGER,
                          P_ENTRA_REG_RECEPCION INTEGER

                         '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_HIPO_ANIO');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_HIPO_ANIO_IX'', ''H_HIPO_ANIO (ANIO_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_HIPO_ANIO');



    

    ------------------------------ TMP_HIPO_JERARQUIA --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_HIPO_JERARQUIA'',
						  ''DIA_ID DATE NOT NULL,
                          ITER NUMBER(16,0) NOT NULL,
                          FASE_ACTUAL NUMBER(16,0) ,
                          FASE_MAX_PRIORIDAD NUMBER(16,0) ,
                          NIVEL NUMBER(2,0) ,
                          CONTEXTO VARCHAR2(600) ,
                          CODIGO_FASE_ACTUAL VARCHAR2(20) ,
                          PRIORIDAD_FASE INTEGER ,
                          ASUNTO NUMBER(16,0) ,
                          PRIORIDAD_PROCEDIMIENTO INTEGER ,
                          TIPO_PROCEDIMIENTO_DET NUMBER(16,0) ,
                          FASE_PARALIZADA INTEGER ,
                          FASE_FINALIZADA INTEGER ,
                          FASE_CON_RECURSO INTEGER

                         '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_HIPO_JERARQUIA');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_HIPO_JRQ_ITER_IX'', ''TMP_HIPO_JERARQUIA (DIA_ID, ITER)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_HIPO_JRQ_FASE_ACT_IX'', ''TMP_HIPO_JERARQUIA (DIA_ID, FASE_ACTUAL)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_HIPO_JERARQUIA');



    

    ------------------------------ TMP_HIPO_DETALLE --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_HIPO_DETALLE'',
						  ''ITER NUMBER(16,0)  ,
                          ASUNTO NUMBER(16,0) ,
                          MAX_PRIORIDAD NUMBER(16,0) ,
                          FASE_MAX_PRIORIDAD NUMBER(16,0) ,
                          FECHA_CREACION_ASUNTO DATE ,
                          FECHA_INTERP_DEM_HIP DATE ,
                          FECHA_SUBASTA_SOLICITADA DATE ,
                          FECHA_SUBASTA DATE ,
                          FECHA_CESION_REMATE DATE ,
                          FECHA_SOL_DECRETO_ADJ DATE ,
                          FECHA_CELEBRACION_SUBASTA DATE ,
                          ULT_TAR_CREADA NUMBER(16,0) ,
                          FECHA_ULT_TAR_CREADA TIMESTAMP ,
                          TAP_ID_ULT_TAR_CREADA NUMBER(16,0) ,
                          FASE_SUBASTA NUMBER(16,0) ,
                          FECHA_RECEP_TESTIMONIO DATE ,
                          FECHA_DECRETO_ADJ DATE

                          '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_HIPO_DETALLE');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_HIPO_DETALLE_IX'', ''TMP_HIPO_DETALLE (ITER)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_HIPO_DETALLE');



    

    ------------------------------ TMP_HIPO_TAREA --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_HIPO_TAREA'',
						  ''ITER NUMBER(16,0) ,
                              FASE NUMBER(16,0) ,
                              TAREA NUMBER(16,0) ,
                              DESCRIPCION_TAREA VARCHAR2(100) ,
                              FECHA_INI TIMESTAMP ,
                              FECHA_FIN TIMESTAMP ,
                              TAP_ID NUMBER(16,0) ,
                              TAR_ID NUMBER(16,0) ,
                              TEX_ID NUMBER(16,0) ,
                              DESCRIPCION_FORMULARIO VARCHAR2(50) ,        -- TEV_NOMBRE (TEV_TAREA_EXTERNA_VALOR)
                              FECHA_FORMULARIO DATE                       -- TEV_VALOR (TEV_TAREA_EXTERNA_VALOR)

                            '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_HIPO_TAREA');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_HIPO_TAREA_IX'', ''TMP_HIPO_TAREA (ITER, TAREA)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_HIPO_TAREA');



    

    ------------------------------ H_MON --------------------------



    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_MON'',
						  ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              -- Dimensiones
                              FECHA_INTERP_DEM_MON DATE ,
                              FECHA_DECRETO_FINALIZACION DATE ,
                              TD_ID_MON_DECRETO_FIN_ID NUMBER(16,0) ,
                              -- M?tricas
                              NUM_MONITORIOS INTEGER,
                              P_ID_MON_DECRETO_FIN INTEGER

                            )
			  SEGMENT CREATION IMMEDIATE 
					TABLESPACE "RECOVERY_PRODUC_DWH" 
                    PARTITION BY RANGE ("DIA_ID")
                    INTERVAL(NUMTOYMINTERVAL(1, ''''MONTH''''))
                    (PARTITION "p1" VALUES LESS THAN (TO_DATE('''' 2014-11-01 00:00:00'''', ''''SYYYY-MM-DD HH24:MI:SS'''', ''''NLS_CALENDAR=GREGORIAN''''))'', :error); END;';
	 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_MON');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_MON_IX'', ''H_MON (DIA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_MON');



    

    ------------------------------ H_MON_SEMANA --------------------------



    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_MON_SEMANA'',
						  ''SEMANA_ID NUMBER(16,0) NOT NULL,
                          FECHA_CARGA_DATOS DATE NOT NULL,
                          PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                          -- Dimensiones
                          FECHA_INTERP_DEM_MON DATE ,
                          FECHA_DECRETO_FINALIZACION DATE ,
                          TD_ID_MON_DECRETO_FIN_ID NUMBER(16,0) ,
                          -- M?tricas
                          NUM_MONITORIOS INTEGER,
                          P_ID_MON_DECRETO_FIN INTEGER

                         '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_MON_SEMANA');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_MON_SEMANA_IX'', ''H_MON_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_MON_SEMANA');



    
    
    ------------------------------ H_MON_MES --------------------------



    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_MON_MES'',
						  ''MES_ID NUMBER(16,0) NOT NULL,
                          FECHA_CARGA_DATOS DATE NOT NULL,
                          PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                          -- Dimensiones
                          FECHA_INTERP_DEM_MON DATE ,
                          FECHA_DECRETO_FINALIZACION DATE ,
                          TD_ID_MON_DECRETO_FIN_ID NUMBER(16,0) ,
                          -- M?tricas
                          NUM_MONITORIOS INTEGER,
                          P_ID_MON_DECRETO_FIN INTEGER

                         '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_MON_MES');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_MON_MES_IX'', ''H_MON_MES (MES_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_MON_MES');



    

    ------------------------------ H_MON_TRIMESTRE --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_MON_TRIMESTRE'',
						  ''TRIMESTRE_ID NUMBER(16,0) NOT NULL,
                          FECHA_CARGA_DATOS DATE NOT NULL,
                          PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                          -- Dimensiones
                          FECHA_INTERP_DEM_MON DATE ,
                          FECHA_DECRETO_FINALIZACION DATE ,
                          TD_ID_MON_DECRETO_FIN_ID NUMBER(16,0) ,
                          -- M?tricas
                          NUM_MONITORIOS INTEGER,
                          P_ID_MON_DECRETO_FIN INTEGER

                          '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_MON_TRIMESTRE');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''MON_TRIMESTRE_IX'', ''H_MON_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_MON_TRIMESTRE');



    

    ------------------------------ H_MON_ANIO --------------------------



    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_MON_ANIO'',
						  ''ANIO_ID NUMBER(16,0) NOT NULL,
                          FECHA_CARGA_DATOS DATE NOT NULL,
                          PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                           -- Dimensiones
                          FECHA_INTERP_DEM_MON DATE ,
                          FECHA_DECRETO_FINALIZACION DATE ,
                          TD_ID_MON_DECRETO_FIN_ID NUMBER(16,0) ,
                          -- M?tricas
                          NUM_MONITORIOS INTEGER,
                          P_ID_MON_DECRETO_FIN INTEGER

                          '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_MON_ANIO');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_MON_ANIO_IX'', ''H_MON_ANIO (ANIO_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_MON_ANIO');



    

    ------------------------------ TMP_MON_JERARQUIA --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_MON_JERARQUIA'',
						  ''DIA_ID DATE NOT NULL,
                          ITER NUMBER(16,0) NOT NULL,
                          FASE_ACTUAL NUMBER(16,0) ,
                          FASE_MAX_PRIORIDAD NUMBER(16,0) ,
                          NIVEL NUMBER(2,0) ,
                          CONTEXTO VARCHAR2(600) ,
                          CODIGO_FASE_ACTUAL VARCHAR2(20) ,
                          PRIORIDAD_FASE INTEGER ,
                          ASUNTO NUMBER(16,0) ,
                          PRIORIDAD_PROCEDIMIENTO INTEGER ,
                          TIPO_PROCEDIMIENTO_DET NUMBER(16,0) ,
                          FASE_PARALIZADA INTEGER ,
                          FASE_FINALIZADA INTEGER ,
                          FASE_CON_RECURSO INTEGER

                          '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_MON_JERARQUIA');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_MON_JRQ_ITER_IX'', ''TMP_MON_JERARQUIA (DIA_ID, ITER)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_MON_JRQ_FASE_ACT_IX'', ''TMP_MON_JERARQUIA (DIA_ID, FASE_ACTUAL)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_MON_JERARQUIA');



    

    ------------------------------ TMP_MON_DETALLE --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_MON_DETALLE'',
						  ''ITER NUMBER(16,0)  ,
                          MAX_PRIORIDAD NUMBER(16,0) ,
                          FASE_MAX_PRIORIDAD NUMBER(16,0) ,
                          FECHA_INTERP_DEM_MON DATE ,
                          FECHA_DECRETO_FINALIZACION DATE

                         '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_MON_DETALLE');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_MON_DETALLE_IX'', ''TMP_MON_DETALLE (ITER)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_MON_DETALLE');



    

    ------------------------------ TMP_MON_TAREA --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_MON_TAREA'',
						  ''ITER NUMBER(16,0) ,
                              FASE NUMBER(16,0) ,
                              TAREA NUMBER(16,0) ,
                              DESCRIPCION_TAREA VARCHAR2(100) ,
                              FECHA_INI TIMESTAMP ,
                              FECHA_FIN TIMESTAMP ,
                              TAP_ID NUMBER(16,0) ,
                              TAR_ID NUMBER(16,0) ,
                              TEX_ID NUMBER(16,0) ,
                              DESCRIPCION_FORMULARIO VARCHAR2(50) ,        -- TEV_NOMBRE (TEV_TAREA_EXTERNA_VALOR)
                              FECHA_FORMULARIO DATE                       -- TEV_VALOR (TEV_TAREA_EXTERNA_VALOR)

                            '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_MON_TAREA');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_MON_TAREA_IX'', ''TMP_MON_TAREA (ITER, TAREA)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_MON_TAREA');



    

    ------------------------------ H_EJEC_NOT --------------------------



    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_EJEC_NOT'',
						  ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              -- Dimensiones
                              FECHA_SUBASTA_EJEC_NOT DATE ,
                              F_SUBASTA_EJEC_NOTARIAL_ID NUMBER(16,0),
                              -- M?tricas
                              NUM_EJECUCIONES_NOTARIALES INTEGER

                            )
			  SEGMENT CREATION IMMEDIATE 
					TABLESPACE "RECOVERY_PRODUC_DWH" 
                    PARTITION BY RANGE ("DIA_ID")
                    INTERVAL(NUMTOYMINTERVAL(1, ''''MONTH''''))
                    (PARTITION "p1" VALUES LESS THAN (TO_DATE('''' 2014-11-01 00:00:00'''', ''''SYYYY-MM-DD HH24:MI:SS'''', ''''NLS_CALENDAR=GREGORIAN''''))'', :error); END;';
	 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_EJEC_NOT');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EJEC_NOT_IX'', ''H_EJEC_NOT (DIA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_EJEC_NOT');



    

    ------------------------------ H_EJEC_NOT_SEMANA --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_EJEC_NOT_SEMANA'',
						  ''SEMANA_ID NUMBER(16,0) NOT NULL,
                          FECHA_CARGA_DATOS DATE NOT NULL,
                          PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                          -- Dimensiones
                          FECHA_SUBASTA_EJEC_NOT DATE ,
                          F_SUBASTA_EJEC_NOTARIAL_ID NUMBER(16,0),
                          -- M?tricas
                          NUM_EJECUCIONES_NOTARIALES INTEGER

                          '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_EJEC_NOT_SEMANA');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EJEC_NOT_SEMANA_IX'', ''H_EJEC_NOT_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_EJEC_NOT_SEMANA');



    

    ------------------------------ H_EJEC_NOT_MES --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_EJEC_NOT_MES'',
						  ''MES_ID NUMBER(16,0) NOT NULL,
                          FECHA_CARGA_DATOS DATE NOT NULL,
                          PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                          -- Dimensiones
                          FECHA_SUBASTA_EJEC_NOT DATE ,
                          F_SUBASTA_EJEC_NOTARIAL_ID NUMBER(16,0),
                          -- M?tricas
                          NUM_EJECUCIONES_NOTARIALES INTEGER

                         '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_EJEC_NOT_MES');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EJEC_NOT_MES_IX'', ''H_EJEC_NOT_MES (MES_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_EJEC_NOT_MES');



    

    ------------------------------ H_EJEC_NOT_TRIMESTRE --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_EJEC_NOT_TRIMESTRE'',
						  ''TRIMESTRE_ID NUMBER(16,0) NOT NULL,
                          FECHA_CARGA_DATOS DATE NOT NULL,
                          PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                          -- Dimensiones
                          FECHA_SUBASTA_EJEC_NOT DATE ,
                          F_SUBASTA_EJEC_NOTARIAL_ID NUMBER(16,0),
                          -- M?tricas
                          NUM_EJECUCIONES_NOTARIALES INTEGER

                         '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_EJEC_NOT_TRIMESTRE');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EJEC_NOT_TRIMESTRE_IX'', ''H_EJEC_NOT_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_EJEC_NOT_TRIMESTRE');



    

    ------------------------------ H_EJEC_NOT_ANIO --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_EJEC_NOT_ANIO'',
						  ''ANIO_ID NUMBER(16,0) NOT NULL,
                          FECHA_CARGA_DATOS DATE NOT NULL,
                          PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                           -- Dimensiones
                          FECHA_SUBASTA_EJEC_NOT DATE ,
                          F_SUBASTA_EJEC_NOTARIAL_ID NUMBER(16,0),
                          -- M?tricas
                          NUM_EJECUCIONES_NOTARIALES INTEGER

                          '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_EJEC_NOT_ANIO');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EJEC_NOT_ANIO_IX'', ''H_EJEC_NOT_ANIO (ANIO_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_EJEC_NOT_ANIO');



    

    ------------------------------ TMP_EJEC_NOT_JERARQUIA --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_EJEC_NOT_JERARQUIA'',
						  ''DIA_ID DATE NOT NULL,
                          ITER NUMBER(16,0) NOT NULL,
                          FASE_ACTUAL NUMBER(16,0) ,
                          FASE_MAX_PRIORIDAD NUMBER(16,0) ,
                          NIVEL NUMBER(2,0) ,
                          CONTEXTO VARCHAR2(600) ,
                          CODIGO_FASE_ACTUAL VARCHAR2(20) ,
                          PRIORIDAD_FASE INTEGER ,
                          ASUNTO NUMBER(16,0) ,
                          PRIORIDAD_PROCEDIMIENTO INTEGER ,
                          TIPO_PROCEDIMIENTO_DET NUMBER(16,0) ,
                          FASE_PARALIZADA INTEGER ,
                          FASE_FINALIZADA INTEGER ,
                          FASE_CON_RECURSO INTEGER

                         '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_EJEC_NOT_JERARQUIA');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_EJEC_NOT_JRQ_ITER_IX'', ''TMP_EJEC_NOT_JERARQUIA (DIA_ID, ITER)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_EJEC_NOT_JRQ_FASE_ACT_IX'', ''TMP_EJEC_NOT_JERARQUIA (DIA_ID, FASE_ACTUAL)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_EJEC_NOT_JERARQUIA');



    

    ------------------------------ TMP_EJEC_NOT_DETALLE --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_EJEC_NOT_DETALLE'',
						  ''ITER NUMBER(16,0)  ,
                          MAX_PRIORIDAD NUMBER(16,0) ,
                          FASE_MAX_PRIORIDAD NUMBER(16,0) ,
                          FECHA_SUBASTA_EJEC_NOT DATE,
                          ULT_TAR_CREADA NUMBER(16,0),
                          FECHA_ULT_TAR_CREADA TIMESTAMP,
                          TAP_ID_ULT_TAR_CREADA NUMBER(16,0),
                          FASE_SUBASTA NUMBER(16,0)

                        '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_EJEC_NOT_DETALLE');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_EJEC_NOT_DETALLE_IX'', ''TMP_EJEC_NOT_DETALLE (ITER)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_EJEC_NOT_DETALLE');



    

    ------------------------------ TMP_EJEC_NOT_TAREA --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_EJEC_NOT_TAREA'',
						  ''ITER NUMBER(16,0) ,
                              FASE NUMBER(16,0) ,
                              TAREA NUMBER(16,0) ,
                              DESCRIPCION_TAREA VARCHAR2(100) ,
                              FECHA_INI TIMESTAMP ,
                              FECHA_FIN TIMESTAMP ,
                              TAP_ID NUMBER(16,0) ,
                              TAR_ID NUMBER(16,0) ,
                              TEX_ID NUMBER(16,0) ,
                              DESCRIPCION_FORMULARIO VARCHAR2(50) ,        -- TEV_NOMBRE (TEV_TAREA_EXTERNA_VALOR)
                              FECHA_FORMULARIO DATE                       -- TEV_VALOR (TEV_TAREA_EXTERNA_VALOR)

                            '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_EJEC_NOT_TAREA');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_EJEC_NOT_TAREA_IX'', ''TMP_EJEC_NOT_TAREA (ITER, TAREA)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_EJEC_NOT_TAREA');


    

    ------------------------------ H_PRE_CONCU --------------------------



    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_CONCU'',
						  ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              -- Dimensiones
                              ENT_CEDENTE_ID NUMBER(16,0) ,
                              PROP_SAREB_ID NUMBER(16,0) ,
                              FECHA_SOL_ART5_BIS DATE ,
                              FECHA_PREP_DEC_PROP DATE ,
                              FECHA_ULT_PROPUESTA DATE ,
                              -- M?tricas
                              NUM_PRE_CONCURSOS INTEGER

                            )
			  SEGMENT CREATION IMMEDIATE 
					TABLESPACE "RECOVERY_PRODUC_DWH" 
                    PARTITION BY RANGE ("DIA_ID")
                    INTERVAL(NUMTOYMINTERVAL(1, ''''MONTH''''))
                    (PARTITION "p1" VALUES LESS THAN (TO_DATE('''' 2014-11-01 00:00:00'''', ''''SYYYY-MM-DD HH24:MI:SS'''', ''''NLS_CALENDAR=GREGORIAN''''))'', :error); END;';
	 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRE_CONCU');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_CONCU_IX'', ''H_PRE_CONCU (DIA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRE_CONCU');



    

    ------------------------------ H_PRE_CONCU_SEMANA --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_CONCU_SEMANA'',
						  ''SEMANA_ID NUMBER(16,0) NOT NULL,
                          FECHA_CARGA_DATOS DATE NOT NULL,
                          PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                          -- Dimensiones
                          ENT_CEDENTE_ID NUMBER(16,0) ,
                          PROP_SAREB_ID NUMBER(16,0) ,
                          FECHA_SOL_ART5_BIS DATE ,
                          FECHA_PREP_DEC_PROP DATE ,
                          FECHA_ULT_PROPUESTA DATE ,
                          -- M?tricas
                          NUM_PRE_CONCURSOS INTEGER

                         '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRE_CONCU_SEMANA');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_CONCU_SEMANA_IX'', ''H_PRE_CONCU_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRE_CONCU_SEMANA');



    
    
    ------------------------------ H_PRE_CONCU_MES --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_CONCU_MES'',
						  ''MES_ID NUMBER(16,0) NOT NULL,
                          FECHA_CARGA_DATOS DATE NOT NULL,
                          PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                          -- Dimensiones
                          ENT_CEDENTE_ID NUMBER(16,0) ,
                          PROP_SAREB_ID NUMBER(16,0) ,
                          FECHA_SOL_ART5_BIS DATE ,
                          FECHA_PREP_DEC_PROP DATE ,
                          FECHA_ULT_PROPUESTA DATE ,
                          -- M?tricas
                          NUM_PRE_CONCURSOS INTEGER

                         '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRE_CONCU_MES');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_CONCU_MES_IX'', ''H_PRE_CONCU_MES (MES_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRE_CONCU_MES');



    

    ------------------------------ H_PRE_CONCU_TRIMESTRE --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_CONCU_TRIMESTRE'',
						  ''TRIMESTRE_ID NUMBER(16,0) NOT NULL,
                          FECHA_CARGA_DATOS DATE NOT NULL,
                          PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                          -- Dimensiones
                          ENT_CEDENTE_ID NUMBER(16,0) ,
                          PROP_SAREB_ID NUMBER(16,0) ,
                          FECHA_SOL_ART5_BIS DATE ,
                          FECHA_PREP_DEC_PROP DATE ,
                          FECHA_ULT_PROPUESTA DATE ,
                          -- M?tricas
                          NUM_PRE_CONCURSOS INTEGER

                          '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRE_CONCU_TRIMESTRE');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_CONCU_TRIMESTRE_IX'', ''H_PRE_CONCU_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRE_CONCU_TRIMESTRE');



    

    ------------------------------ H_PRE_CONCU_ANIO --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_CONCU_ANIO'',
						  ''ANIO_ID NUMBER(16,0) NOT NULL,
                          FECHA_CARGA_DATOS DATE NOT NULL,
                          PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                          -- Dimensiones
                          ENT_CEDENTE_ID NUMBER(16,0) ,
                          PROP_SAREB_ID NUMBER(16,0) ,
                          FECHA_SOL_ART5_BIS DATE ,
                          FECHA_PREP_DEC_PROP DATE ,
                          FECHA_ULT_PROPUESTA DATE ,
                          -- M?tricas
                          NUM_PRE_CONCURSOS INTEGER

                          '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRE_CONCU_ANIO');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_CONCU_ANIO_IX'', ''H_PRE_CONCU_ANIO (ANIO_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRE_CONCU_ANIO');



    

    ------------------------------ TMP_PRE_CONCU_JERARQUIA --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_PRE_CONCU_JERARQUIA'',
						  ''DIA_ID DATE NOT NULL,
                            ITER NUMBER(16,0) NOT NULL,
                            FASE_ACTUAL NUMBER(16,0) ,
                            FASE_MAX_PRIORIDAD NUMBER(16,0) ,
                            NIVEL NUMBER(2,0) ,
                            CONTEXTO VARCHAR2(600) ,
                            CODIGO_FASE_ACTUAL VARCHAR2(20) ,
                            PRIORIDAD_FASE INTEGER ,
                            ASUNTO NUMBER(16,0) ,
                            PRIORIDAD_PROCEDIMIENTO INTEGER ,
                            TIPO_PROCEDIMIENTO_DET NUMBER(16,0) ,
                            FASE_PARALIZADA INTEGER ,
                            FASE_FINALIZADA INTEGER ,
                            FASE_CON_RECURSO INTEGER

                          '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_PRE_CONCU_JERARQUIA');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRE_CONCU_JRQ_ITER_IX'', ''TMP_PRE_CONCU_JERARQUIA (DIA_ID, ITER)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRE_CONCU_JRQ_FASE_ACT_IX'', ''TMP_PRE_CONCU_JERARQUIA (DIA_ID, FASE_ACTUAL)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_PRE_CONCU_JERARQUIA');



    

    ------------------------------ TMP_PRE_CONCU_DETALLE --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_PRE_CONCU_DETALLE'',
						  ''ITER NUMBER(16,0)  ,
                            MAX_PRIORIDAD NUMBER(16,0) ,
                            FASE_MAX_PRIORIDAD NUMBER(16,0) ,
							ENT_CEDENTE_ID NUMBER(16,0) ,
							PROP_SAREB_ID NUMBER(16,0) ,
							FECHA_SOL_ART5_BIS DATE ,
							FECHA_PREP_DEC_PROP DATE ,
							FECHA_ULT_PROPUESTA DATE 

                          '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_PRE_CONCU_DETALLE');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRE_CONCU_DETALLE_IX'', ''TMP_PRE_CONCU_DETALLE (ITER)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_PRE_CONCU_DETALLE');



    

    ------------------------------ TMP_PRE_CONCU_TAREA --------------------------


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_PRE_CONCU_TAREA'',
						  ''ITER NUMBER(16,0) ,
                            FASE NUMBER(16,0) ,
                            TAREA NUMBER(16,0) ,
                            DESCRIPCION_TAREA VARCHAR2(100) ,
                            FECHA_INI TIMESTAMP ,
                            FECHA_FIN TIMESTAMP ,
                            TAP_ID NUMBER(16,0) ,
                            TAR_ID NUMBER(16,0) ,
                            TEX_ID NUMBER(16,0) ,
                            DESCRIPCION_FORMULARIO VARCHAR2(50) ,        -- TEV_NOMBRE (TEV_TAREA_EXTERNA_VALOR)
                            FECHA_FORMULARIO DATE ,                     -- TEV_VALOR (TEV_TAREA_EXTERNA_VALOR)
                            VALOR_FORMULARIO  VARCHAR2(50)               -- TEV_VALOR (cuando no es fecha)

                         '', :error); END;';
		 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_PRE_CONCU_TAREA');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRE_CONCU_TAREA_IX'', ''TMP_PRE_CONCU_TAREA (ITER, TAREA)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_PRE_CONCU_TAREA');


    
	
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;

  end;

END CREAR_H_PROCEDIMIENTO_ESPEC;
