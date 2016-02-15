create or replace PROCEDURE CREAR_H_PRECONTENCIOSO (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Jaime Sánchez-Cuenca Bellido, PFS Group
-- Fecha creacion: Agosto 2015
-- Responsable ultima modificacion: María Villanueva, PFS Group
-- Fecha ultima modificacion: 13/11/2015
-- Motivos del cambio: nuevos plazos
-- Cliente: Recovery BI Haya
--
-- Descripcion: Procedimiento almancenado que crea las tablas del Hecho Precontecioso
-- ===============================================================================================

-- -------------------------------------------- INDICE -------------------------------------------
-- HECHO PRECONTENCIOSO
    -- TMP_H_PRE
    -- H_PRE
    -- H_PRE_SEMANA
    -- H_PRE_MES
    -- H_PRE_TRIMESTRE
    -- H_PRE_ANIO
    
BEGIN
  declare
  nCount NUMBER;
  V_SQL VARCHAR2(16000);
  V_NOMBRE VARCHAR2(50) := 'CREAR_H_PRECONTENCIOSO';

  begin

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;

     ------------------------------ TMP_H_PRE --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_H_PRE'', 
                            ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL, 
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              FECHA_INICIO_PRE  DATE,
                              FECHA_ESTUDIO_PRE DATE,
                              FECHA_PREPARADO_PRE DATE,
                              FECHA_ENV_LET_PRE DATE,
                              FECHA_FINALIZADO_PRE  DATE,
                              FECHA_ULT_SUBSANACION_PRE DATE,
                              FECHA_CANCELADO_PRE DATE,
                              FECHA_PARALIZADO_PRE DATE,
                              PROPIETARIO_PRC_ID NUMBER(16,0),
                              TIPO_PROCEDIMIENTO_PRE_ID NUMBER(16,0),
                              ESTADO_PREPARACION_ID NUMBER(16,0),
                              TIPO_PREPARACION_ID NUMBER(16,0),
                              GESTOR_PRE_ID NUMBER(16,0), 
                              MOTIVO_CANCELACION_ID NUMBER(16,0) NULL,
                              MOTIVO_SUBSANACION_ID NUMBER(16,0) NULL,
                              TRAMO_SUBSANACION_ID NUMBER(16,0) NULL,
                              TRAMO_AVANCE_DOCUMENTO_ID NUMBER(16,0) NULL,
                              TRAMO_AVANCE_LIQUIDACION_ID NUMBER(16,0) NULL,
                              TRAMO_AVANCE_BUROFAX_ID NUMBER(16,0) NULL,                              
                              NUM_PREJUDICIALES INTEGER,
                              P_PRE_INICIO_PREPARADO INTEGER,
                              P_PRE_PREPARADO_ENV_LET INTEGER,
                              P_PRE_ENV_LET_FINALIZADO INTEGER,
                              P_PRE_INICIO_FINALIZADO INTEGER,
                              GRADO_AVANCE_DOCUMENTOS NUMBER(14,2),
                              GRADO_AVANCE_LIQUIDACIONES NUMBER(14,2),
                              GRADO_AVANCE_BUROFAXES NUMBER(14,2)'', :error); END;';
   execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_H_PRE');

 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_PRE_IX'', ''  TMP_H_PRE (DIA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

  
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_H_PRE');
    
    
    ------------------------------ H_PRE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE'', 
                            ''DIA_ID DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL, 
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              FECHA_INICIO_PRE  DATE,
                              FECHA_ESTUDIO_PRE DATE,
                              FECHA_PREPARADO_PRE DATE,
                              FECHA_ENV_LET_PRE DATE,
                              FECHA_FINALIZADO_PRE  DATE,
                              FECHA_ULT_SUBSANACION_PRE DATE,
                              FECHA_CANCELADO_PRE DATE,
                              FECHA_PARALIZADO_PRE DATE,
                              PROPIETARIO_PRC_ID NUMBER(16,0),
                              TIPO_PROCEDIMIENTO_PRE_ID NUMBER(16,0),
                              ESTADO_PREPARACION_ID NUMBER(16,0),
                              TIPO_PREPARACION_ID NUMBER(16,0),
                              GESTOR_PRE_ID NUMBER(16,0), 
                              MOTIVO_CANCELACION_ID NUMBER(16,0) NULL,
                              MOTIVO_SUBSANACION_ID NUMBER(16,0) NULL,
                              TRAMO_SUBSANACION_ID NUMBER(16,0) NULL,
                              TRAMO_AVANCE_DOCUMENTO_ID NUMBER(16,0) NULL,
                              TRAMO_AVANCE_LIQUIDACION_ID NUMBER(16,0) NULL,
                              TRAMO_AVANCE_BUROFAX_ID NUMBER(16,0) NULL,                              
                              NUM_PREJUDICIALES INTEGER,
                              P_PRE_INICIO_PREPARADO INTEGER,
                              P_PRE_PREPARADO_ENV_LET INTEGER,
                              P_PRE_ENV_LET_FINALIZADO INTEGER,
                              P_PRE_INICIO_FINALIZADO INTEGER,
                              GRADO_AVANCE_DOCUMENTOS NUMBER(14,2),
                              GRADO_AVANCE_LIQUIDACIONES NUMBER(14,2),
                              GRADO_AVANCE_BUROFAXES NUMBER(14,2) )
			  SEGMENT CREATION IMMEDIATE 
					TABLESPACE "RECOVERY_HAYA_DWH" 
                    PARTITION BY RANGE ("DIA_ID")
                    INTERVAL(NUMTOYMINTERVAL(1, ''''MONTH''''))
                    (PARTITION "p1" VALUES LESS THAN (TO_DATE('''' 2014-11-01 00:00:00'''', ''''SYYYY-MM-DD HH24:MI:SS'''', ''''NLS_CALENDAR=GREGORIAN''''))'', :error); END;';
	 execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRE');

 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_IX'', ''  H_PRE (DIA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;

  
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRE');
    

    ------------------------------ H_PRE_SEMANA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_SEMANA'', 
                            ''SEMANA_ID NUMBER(16,0) NOT NULL, 

                              FECHA_CARGA_DATOS DATE NOT NULL, 
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              FECHA_INICIO_PRE  DATE,
                              FECHA_ESTUDIO_PRE DATE,
                              FECHA_PREPARADO_PRE DATE,
                              FECHA_ENV_LET_PRE DATE,
                              FECHA_FINALIZADO_PRE  DATE,
                              FECHA_ULT_SUBSANACION_PRE DATE,
                              FECHA_CANCELADO_PRE DATE,
                              FECHA_PARALIZADO_PRE DATE,
                              PROPIETARIO_PRC_ID NUMBER(16,0),
                              TIPO_PROCEDIMIENTO_PRE_ID NUMBER(16,0),
                              ESTADO_PREPARACION_ID NUMBER(16,0),
                              TIPO_PREPARACION_ID NUMBER(16,0),
                              GESTOR_PRE_ID NUMBER(16,0), 
                              MOTIVO_CANCELACION_ID NUMBER(16,0) NULL,
                              MOTIVO_SUBSANACION_ID NUMBER(16,0) NULL,
                              TRAMO_SUBSANACION_ID NUMBER(16,0) NULL,
                              TRAMO_AVANCE_DOCUMENTO_ID NUMBER(16,0) NULL,
                              TRAMO_AVANCE_LIQUIDACION_ID NUMBER(16,0) NULL,
                              TRAMO_AVANCE_BUROFAX_ID NUMBER(16,0) NULL,                              
                              NUM_PREJUDICIALES INTEGER,
                              P_PRE_INICIO_PREPARADO INTEGER,
                              P_PRE_PREPARADO_ENV_LET INTEGER,
                              P_PRE_ENV_LET_FINALIZADO INTEGER,
                              P_PRE_INICIO_FINALIZADO INTEGER,
                              GRADO_AVANCE_DOCUMENTOS NUMBER(14,2),
                              GRADO_AVANCE_LIQUIDACIONES NUMBER(14,2),
                              GRADO_AVANCE_BUROFAXES NUMBER(14,2)
                        )
                              SEGMENT CREATION IMMEDIATE NOLOGGING
                           	TABLESPACE "RECOVERY_HAYA_DWH"   
                           	PARTITION BY RANGE ("SEMANA_ID") INTERVAL (1) 
                           	(PARTITION "P1" VALUES LESS THAN (201501) 
                           	TABLESPACE "RECOVERY_HAYA_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRE_SEMANA');

 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_SEMANA_IX'', ''  H_PRE_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
     
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRE_SEMANA');
        
    
    ------------------------------ H_PRE_MES --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_MES'', 
                            ''MES_ID NUMBER(16,0) NOT NULL,

                              FECHA_CARGA_DATOS DATE NOT NULL, 
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              FECHA_INICIO_PRE  DATE,
                              FECHA_ESTUDIO_PRE DATE,
                              FECHA_PREPARADO_PRE DATE,
                              FECHA_ENV_LET_PRE DATE,
                              FECHA_FINALIZADO_PRE  DATE,
                              FECHA_ULT_SUBSANACION_PRE DATE,
                              FECHA_CANCELADO_PRE DATE,
                              FECHA_PARALIZADO_PRE DATE,
                              PROPIETARIO_PRC_ID NUMBER(16,0),
                              TIPO_PROCEDIMIENTO_PRE_ID NUMBER(16,0),
                              ESTADO_PREPARACION_ID NUMBER(16,0),
                              TIPO_PREPARACION_ID NUMBER(16,0),

                              GESTOR_PRE_ID NUMBER(16,0), 
                              MOTIVO_CANCELACION_ID NUMBER(16,0) NULL,
                              MOTIVO_SUBSANACION_ID NUMBER(16,0) NULL,
                              TRAMO_SUBSANACION_ID NUMBER(16,0) NULL,
                              TRAMO_AVANCE_DOCUMENTO_ID NUMBER(16,0) NULL,
                              TRAMO_AVANCE_LIQUIDACION_ID NUMBER(16,0) NULL,
                              TRAMO_AVANCE_BUROFAX_ID NUMBER(16,0) NULL,                              
                              NUM_PREJUDICIALES INTEGER,
                              P_PRE_INICIO_PREPARADO INTEGER,
                              P_PRE_PREPARADO_ENV_LET INTEGER,
                              P_PRE_ENV_LET_FINALIZADO INTEGER,
                              P_PRE_INICIO_FINALIZADO INTEGER,
                              GRADO_AVANCE_DOCUMENTOS NUMBER(14,2),
                              GRADO_AVANCE_LIQUIDACIONES NUMBER(14,2),
                              GRADO_AVANCE_BUROFAXES NUMBER(14,2)
                          )
                              SEGMENT CREATION IMMEDIATE NOLOGGING
                           	TABLESPACE "RECOVERY_HAYA_DWH"   
                           	PARTITION BY RANGE ("MES_ID") INTERVAL (1) 
                           	(PARTITION "P1" VALUES LESS THAN (201501) 
                           	TABLESPACE "RECOVERY_HAYA_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRE_MES');

     
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_MES_IX'', ''  H_PRE_MES (MES_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
  
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRE_MES');
    
    
    ------------------------------ H_PRE_TRIMESTRE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_TRIMESTRE'', 
                            ''TRIMESTRE_ID NUMBER(16,0) NOT NULL,

                              FECHA_CARGA_DATOS DATE NOT NULL, 
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              FECHA_INICIO_PRE  DATE,
                              FECHA_ESTUDIO_PRE DATE,
                              FECHA_PREPARADO_PRE DATE,
                              FECHA_ENV_LET_PRE DATE,
                              FECHA_FINALIZADO_PRE  DATE,
                              FECHA_ULT_SUBSANACION_PRE DATE,
                              FECHA_CANCELADO_PRE DATE,
                              FECHA_PARALIZADO_PRE DATE,
                              PROPIETARIO_PRC_ID NUMBER(16,0),
                              TIPO_PROCEDIMIENTO_PRE_ID NUMBER(16,0),
                              ESTADO_PREPARACION_ID NUMBER(16,0),
                              TIPO_PREPARACION_ID NUMBER(16,0),
                              GESTOR_PRE_ID NUMBER(16,0), 
                              MOTIVO_CANCELACION_ID NUMBER(16,0) NULL,
                              MOTIVO_SUBSANACION_ID NUMBER(16,0) NULL,
                              TRAMO_SUBSANACION_ID NUMBER(16,0) NULL,
                              TRAMO_AVANCE_DOCUMENTO_ID NUMBER(16,0) NULL,
                              TRAMO_AVANCE_LIQUIDACION_ID NUMBER(16,0) NULL,
                              TRAMO_AVANCE_BUROFAX_ID NUMBER(16,0) NULL,                              
                              NUM_PREJUDICIALES INTEGER,
                              P_PRE_INICIO_PREPARADO INTEGER,
                              P_PRE_PREPARADO_ENV_LET INTEGER,
                              P_PRE_ENV_LET_FINALIZADO INTEGER,
                              P_PRE_INICIO_FINALIZADO INTEGER,
                              GRADO_AVANCE_DOCUMENTOS NUMBER(14,2),
                              GRADO_AVANCE_LIQUIDACIONES NUMBER(14,2),
                              GRADO_AVANCE_BUROFAXES NUMBER(14,2)
                             )
                              SEGMENT CREATION IMMEDIATE NOLOGGING
                            	TABLESPACE "RECOVERY_HAYA_DWH"   
                            	PARTITION BY RANGE ("TRIMESTRE_ID") INTERVAL (1) 
                            	(PARTITION "P1" VALUES LESS THAN (201501) 
                            	TABLESPACE "RECOVERY_HAYA_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRE_TRIMESTRE');

    
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_TRIMESTRE_IX'', ''  H_PRE_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
  
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRE_TRIMESTRE');
    

    ------------------------------ H_PRE_ANIO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PRE_ANIO'', 
                            ''ANIO_ID NUMBER(16,0) NOT NULL,

                              FECHA_CARGA_DATOS DATE NOT NULL, 
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              FECHA_INICIO_PRE  DATE,
                              FECHA_ESTUDIO_PRE DATE,
                              FECHA_PREPARADO_PRE DATE,
                              FECHA_ENV_LET_PRE DATE,
                              FECHA_FINALIZADO_PRE  DATE,
                              FECHA_ULT_SUBSANACION_PRE DATE,
                              FECHA_CANCELADO_PRE DATE,
                              FECHA_PARALIZADO_PRE DATE,
                              PROPIETARIO_PRC_ID NUMBER(16,0),
                              TIPO_PROCEDIMIENTO_PRE_ID NUMBER(16,0),
                              ESTADO_PREPARACION_ID NUMBER(16,0),
                              TIPO_PREPARACION_ID NUMBER(16,0),
                              GESTOR_PRE_ID NUMBER(16,0), 
                              MOTIVO_CANCELACION_ID NUMBER(16,0) NULL,
                              MOTIVO_SUBSANACION_ID NUMBER(16,0) NULL,
                              TRAMO_SUBSANACION_ID NUMBER(16,0) NULL,
                              TRAMO_AVANCE_DOCUMENTO_ID NUMBER(16,0) NULL,
                              TRAMO_AVANCE_LIQUIDACION_ID NUMBER(16,0) NULL,
                              TRAMO_AVANCE_BUROFAX_ID NUMBER(16,0) NULL,                              
                              NUM_PREJUDICIALES INTEGER,
                              P_PRE_INICIO_PREPARADO INTEGER,
                              P_PRE_PREPARADO_ENV_LET INTEGER,
                              P_PRE_ENV_LET_FINALIZADO INTEGER,
                              P_PRE_INICIO_FINALIZADO INTEGER,
                              GRADO_AVANCE_DOCUMENTOS NUMBER(14,2),
                              GRADO_AVANCE_LIQUIDACIONES NUMBER(14,2),
                              GRADO_AVANCE_BUROFAXES NUMBER(14,2)
                          )
                             SEGMENT CREATION IMMEDIATE NOLOGGING
                            	TABLESPACE "RECOVERY_HAYA_DWH"   
                            	PARTITION BY RANGE ("ANIO_ID") INTERVAL (1) 
                            	(PARTITION "P1" VALUES LESS THAN (2015) 
                            	TABLESPACE "RECOVERY_HAYA_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PRE_ANIO');

   
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_ANIO_IX'', ''  H_PRE_ANIO (ANIO_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
 
      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PRE_ANIO');
    
    
    
    ------------------------------ TMP_PRE_FECHA_ESTADO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_PRE_FECHA_ESTADO'', 
                               ''PROCEDIMIENTO_ID NUMBER(16,0),
                                  PCO_PRC_ID NUMBER(16,0),
                                  FECHA_ACTUAL_ESTADO TIMESTAMP,
                                  ESTADO_PREPARACION_ID NUMBER(16,0)'', :error); END;';
   execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_PRE_FECHA_ESTADO ');
   
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRE_FECHA_ESTADO_IX'', ''  TMP_PRE_FECHA_ESTADO (PROCEDIMIENTO_ID)'', ''S'', '''', :error); END;';
  execute immediate V_SQL USING OUT error;
 

      DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_PRE_FECHA_ESTADO ');
    
    
    
    
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;

  end;

END CREAR_H_PRECONTENCIOSO;
