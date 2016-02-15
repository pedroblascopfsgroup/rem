create or replace PROCEDURE CREAR_H_SUBASTA (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Rafael Aracil, PFS Group
-- Fecha creacion: Agosto 2015
-- Responsable ultima modificacion: María Villanueva, PFS Group
-- Fecha ultima modificacion: 11/11/2015
-- Motivos del cambio: usuario propietario
-- Cliente: Recovery BI PRODUCTO
--
-- Descripcion: Procedimiento almancenado que carga las tablas del Hecho SUBASTA.
-- ===============================================================================================



BEGIN
  declare
  nCount NUMBER;
  V_SQL VARCHAR2(16000);
  V_NOMBRE VARCHAR2(50) := 'CREAR_H_SUBASTA';
  
  begin
  
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
	
	
	  
	

	
    ------------------------------ TMP_H_SUB --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_H_SUB'', 
							''DIA_ID DATE NOT NULL, -- PK ID del dia de analisis
                              FECHA_CARGA_DATOS DATE NOT NULL,-- PK ID del ultimo dia cargado (en la tabla diaria coincide con el DIA_ID)
                              ASUNTO_ID NUMBER(16,0) NOT NULL, -- PK ID del asunto
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              SUBASTA_ID NUMBER(16,0) NOT NULL, -- PK ID de la subasta
                              LOTE_ID NUMBER(16,0) NOT NULL, -- PK ID del lote
                              NUMERO_AUTO_ID VARCHAR2(50 CHAR),
                              TIPO_SUBASTA_ID NUMBER(16,0),
                              ESTADO_SUBASTA_ID NUMBER(16,0),
                              MOTIVO_SUSPEN_ID NUMBER(16,0),
                              SUBMOTIVO_SUSPEN_ID NUMBER(16,0),
                              MOTIVO_CANCEL_ID NUMBER(16,0),
                              TIPO_ADJUDICACION_ID NUMBER(16,0),
                              FECHA_ANUNCIO_SUBASTA DATE,
                              FECHA_SOLICITUD_SUBASTA DATE,
                              FECHA_SENYALAMIENTO_SUBASTA DATE,
                              TD_ANUNCIO_SOLICITUD NUMBER(16,0),
                              TD_SENYALAMIENTO_ANUNCIO NUMBER(16,0),
                              TD_SENYALAMIENTO_SOLICITUD NUMBER(16,0),
                              -- Metricas
                              IMP_PUJA_SIN_POSTORES NUMBER(16,2),
                              IMP_PUJA_CON_POSTORES_DESDE NUMBER(16,2),
                              IMP_PUJA_CON_POSTORES_HASTA NUMBER(16,2),
                              IMP_VALOR_SUBASTA NUMBER(16,2),
                              IMP_DEUDA_JUDICIAL NUMBER(16,2),
                              P_ANUNCIO_SOLICITUD INTEGER, 
                              P_SENYALAMIENTO_ANUNCIO INTEGER,
                              P_SENYALAMIENTO_SOLICITUD INTEGER,
                              NUM_PROCEDIMIENTO INTEGER'', :error); END;';
							  execute immediate V_SQL USING OUT error;
							    
	   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_SUB_IX'', ''TMP_H_SUB (DIA_ID,ASUNTO_ID,PROCEDIMIENTO_ID, SUBASTA_ID,LOTE_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

     

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_H_SUB');
    


    ------------------------------ H_SUB --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_SUB'', 
							''DIA_ID DATE NOT NULL, -- PK ID del dia de analisis
                              FECHA_CARGA_DATOS DATE NOT NULL,-- PK ID del ultimo dia cargado (en la tabla diaria coincide con el DIA_ID)
                              ASUNTO_ID NUMBER(16,0) NOT NULL, -- PK ID del asunto
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              SUBASTA_ID NUMBER(16,0) NOT NULL, -- PK ID de la subasta
                              LOTE_ID NUMBER(16,0) NOT NULL, -- PK ID del lote
                              NUMERO_AUTO_ID VARCHAR2(50 CHAR),
                              TIPO_SUBASTA_ID NUMBER(16,0),
                              ESTADO_SUBASTA_ID NUMBER(16,0),
                              MOTIVO_SUSPEN_ID NUMBER(16,0),
                              SUBMOTIVO_SUSPEN_ID NUMBER(16,0),
                              MOTIVO_CANCEL_ID NUMBER(16,0),
                              TIPO_ADJUDICACION_ID NUMBER(16,0),
                              FECHA_ANUNCIO_SUBASTA DATE,
                              FECHA_SOLICITUD_SUBASTA DATE,
                              FECHA_SENYALAMIENTO_SUBASTA DATE,
                              TD_ANUNCIO_SOLICITUD NUMBER(16,0),
                              TD_SENYALAMIENTO_ANUNCIO NUMBER(16,0),
                              TD_SENYALAMIENTO_SOLICITUD NUMBER(16,0),
                              -- Metricas
                              IMP_PUJA_SIN_POSTORES NUMBER(16,2),
                              IMP_PUJA_CON_POSTORES_DESDE NUMBER(16,2),
                              IMP_PUJA_CON_POSTORES_HASTA NUMBER(16,2),
                              IMP_VALOR_SUBASTA NUMBER(16,2),
                              IMP_DEUDA_JUDICIAL NUMBER(16,2),
                              P_ANUNCIO_SOLICITUD INTEGER, 
                              P_SENYALAMIENTO_ANUNCIO INTEGER,
                              P_SENYALAMIENTO_SOLICITUD INTEGER,
                              NUM_PROCEDIMIENTO INTEGER)
					SEGMENT CREATION IMMEDIATE 
					TABLESPACE "RECOVERY_PRODUC_DWH" 
                    PARTITION BY RANGE ("DIA_ID")
                    INTERVAL(NUMTOYMINTERVAL(1, ''''MONTH''''))
                    (PARTITION "p1" VALUES LESS THAN (TO_DATE('''' 2014-11-01 00:00:00'''', ''''SYYYY-MM-DD HH24:MI:SS'''', ''''NLS_CALENDAR=GREGORIAN''''))'', :error); END;';
					
	 execute immediate V_SQL USING OUT error;

V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_SUB_IX'', ''H_SUB (DIA_ID,ASUNTO_ID, PROCEDIMIENTO_ID, SUBASTA_ID,LOTE_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
	

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_SUB');
    

    ------------------------------ D_SUB_TIPO_SUBASTA--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_SUB_SEMANA'', 
							  ''SEMANA_ID NUMBER(16,0) NOT NULL, -- PK ID de la semana de analisis
                                FECHA_CARGA_DATOS DATE NOT NULL,-- PK ID del ultimo dia cargado (en la tabla diaria coincide con el DIA_ID)
                                ASUNTO_ID NUMBER(16,0) NOT NULL, -- PK ID del asunto
                                PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                                SUBASTA_ID NUMBER(16,0) NOT NULL, -- PK ID de la subasta
                                LOTE_ID NUMBER(16,0) NOT NULL, -- PK ID del lote
                                NUMERO_AUTO_ID VARCHAR2(50 CHAR),
                                TIPO_SUBASTA_ID NUMBER(16,0),
                                ESTADO_SUBASTA_ID NUMBER(16,0),
                                MOTIVO_SUSPEN_ID NUMBER(16,0),
                                SUBMOTIVO_SUSPEN_ID NUMBER(16,0),
                                MOTIVO_CANCEL_ID NUMBER(16,0),
                                TIPO_ADJUDICACION_ID NUMBER(16,0),
                                FECHA_ANUNCIO_SUBASTA DATE,
                                FECHA_SOLICITUD_SUBASTA DATE,
                                FECHA_SENYALAMIENTO_SUBASTA DATE,
                                TD_ANUNCIO_SOLICITUD NUMBER(16,0),
                                TD_SENYALAMIENTO_ANUNCIO NUMBER(16,0),
                                TD_SENYALAMIENTO_SOLICITUD NUMBER(16,0),
                                -- Metricas
                                IMP_PUJA_SIN_POSTORES NUMBER(16,2),
                                IMP_PUJA_CON_POSTORES_DESDE NUMBER(16,2),
                                IMP_PUJA_CON_POSTORES_HASTA NUMBER(16,2),
                                IMP_VALOR_SUBASTA NUMBER(16,2),
                                IMP_DEUDA_JUDICIAL NUMBER(16,2),
                                P_ANUNCIO_SOLICITUD INTEGER, 
                                P_SENYALAMIENTO_ANUNCIO INTEGER,
                                P_SENYALAMIENTO_SOLICITUD INTEGER,
                                NUM_PROCEDIMIENTO INTEGER)
			    SEGMENT CREATION IMMEDIATE NOLOGGING
                            TABLESPACE "RECOVERY_PRODUC_DWH"   
                            PARTITION BY RANGE ("SEMANA_ID") INTERVAL (1) 
                           (PARTITION "P1" VALUES LESS THAN (201501) 
                           TABLESPACE "RECOVERY_PRODUC_DWH"'', :error); END;';

	execute immediate V_SQL USING OUT error;
	  DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_SUB_SEMANA');
	  
	V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_SUB_SEMANA_IX'', ''H_SUB_SEMANA (SEMANA_ID,ASUNTO_ID, PROCEDIMIENTO_ID, SUBASTA_ID,LOTE_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
	
	  DBMS_OUTPUT.PUT_LINE('---- Creacion indices H_SUB_SEMANA');


    ------------------------------  H_SUB_MES --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_SUB_MES'', 
							  ''MES_ID NUMBER(16,0) NOT NULL, -- PK ID del mes de analisis
                              FECHA_CARGA_DATOS DATE NOT NULL,-- PK ID del ultimo dia cargado (en la tabla diaria coincide con el DIA_ID)
                              ASUNTO_ID NUMBER(16,0) NOT NULL, -- PK ID del asunto
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              SUBASTA_ID NUMBER(16,0) NOT NULL, -- PK ID de la subasta
                              LOTE_ID NUMBER(16,0) NOT NULL, -- PK ID del lote
                              NUMERO_AUTO_ID VARCHAR2(50 CHAR),
                              TIPO_SUBASTA_ID NUMBER(16,0),
                              ESTADO_SUBASTA_ID NUMBER(16,0),
                              MOTIVO_SUSPEN_ID NUMBER(16,0),
                              SUBMOTIVO_SUSPEN_ID NUMBER(16,0),
                              MOTIVO_CANCEL_ID NUMBER(16,0),
                              TIPO_ADJUDICACION_ID NUMBER(16,0),
                              FECHA_ANUNCIO_SUBASTA DATE,
                              FECHA_SOLICITUD_SUBASTA DATE,
                              FECHA_SENYALAMIENTO_SUBASTA DATE,
                              TD_ANUNCIO_SOLICITUD NUMBER(16,0),
                              TD_SENYALAMIENTO_ANUNCIO NUMBER(16,0),
                              TD_SENYALAMIENTO_SOLICITUD NUMBER(16,0),
                              -- Metricas
                              IMP_PUJA_SIN_POSTORES NUMBER(16,2),
                              IMP_PUJA_CON_POSTORES_DESDE NUMBER(16,2),
                              IMP_PUJA_CON_POSTORES_HASTA NUMBER(16,2),
                              IMP_VALOR_SUBASTA NUMBER(16,2),
                              IMP_DEUDA_JUDICIAL NUMBER(16,2),
                              P_ANUNCIO_SOLICITUD INTEGER, 
                              P_SENYALAMIENTO_ANUNCIO INTEGER,
                              P_SENYALAMIENTO_SOLICITUD INTEGER,
                              NUM_PROCEDIMIENTO INTEGER)
                		    SEGMENT CREATION IMMEDIATE NOLOGGING
                           	TABLESPACE "RECOVERY_PRODUC_DWH"   
                           	PARTITION BY RANGE ("MES_ID") INTERVAL (1) 
                           	(PARTITION "P1" VALUES LESS THAN (201501) 
                           	TABLESPACE "RECOVERY_PRODUC_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;

		V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_SUB_MES_IX'', ''H_SUB_MES (MES_ID,ASUNTO_ID, PROCEDIMIENTO_ID, SUBASTA_ID,LOTE_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla  H_SUB_MES');

    ------------------------------ H_SUB_TRIMESTRE  --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_SUB_TRIMESTRE'', 
							  ''TRIMESTRE_ID NUMBER(16,0) NOT NULL, -- PK ID del trimestre de anAlisis
                              FECHA_CARGA_DATOS DATE NOT NULL,-- PK ID del ultimo dia cargado (en la tabla diaria coincide con el DIA_ID)
                              ASUNTO_ID NUMBER(16,0) NOT NULL, -- PK ID del asunto
                              PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                              SUBASTA_ID NUMBER(16,0) NOT NULL, -- PK ID de la subasta
                              LOTE_ID NUMBER(16,0) NOT NULL, -- PK ID del lote
                              NUMERO_AUTO_ID VARCHAR2(50 CHAR),
                              TIPO_SUBASTA_ID NUMBER(16,0),
                              ESTADO_SUBASTA_ID NUMBER(16,0),
                              MOTIVO_SUSPEN_ID NUMBER(16,0),
                              SUBMOTIVO_SUSPEN_ID NUMBER(16,0),
                              MOTIVO_CANCEL_ID NUMBER(16,0),
                              TIPO_ADJUDICACION_ID NUMBER(16,0),
                              FECHA_ANUNCIO_SUBASTA DATE,
                              FECHA_SOLICITUD_SUBASTA DATE,
                              FECHA_SENYALAMIENTO_SUBASTA DATE,
                              TD_ANUNCIO_SOLICITUD NUMBER(16,0),
                              TD_SENYALAMIENTO_ANUNCIO NUMBER(16,0),
                              TD_SENYALAMIENTO_SOLICITUD NUMBER(16,0),
                              -- Metricas
                              IMP_PUJA_SIN_POSTORES NUMBER(16,2),
                              IMP_PUJA_CON_POSTORES_DESDE NUMBER(16,2),
                              IMP_PUJA_CON_POSTORES_HASTA NUMBER(16,2),
                              IMP_VALOR_SUBASTA NUMBER(16,2),
                              IMP_DEUDA_JUDICIAL NUMBER(16,2),
                              P_ANUNCIO_SOLICITUD INTEGER, 
                              P_SENYALAMIENTO_ANUNCIO INTEGER,
                              P_SENYALAMIENTO_SOLICITUD INTEGER,
                              NUM_PROCEDIMIENTO INTEGER)
                            	SEGMENT CREATION IMMEDIATE NOLOGGING
                            	TABLESPACE "RECOVERY_PRODUC_DWH"   
                            	PARTITION BY RANGE ("TRIMESTRE_ID") INTERVAL (1) 
                            	(PARTITION "P1" VALUES LESS THAN (201501) 
                            	TABLESPACE "RECOVERY_PRODUC_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;

		V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_SUB_TRIMESTRE_IX'', ''H_SUB_TRIMESTRE (TRIMESTRE_ID,ASUNTO_ID, PROCEDIMIENTO_ID, SUBASTA_ID,LOTE_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_SUB_TRIMESTRE');
	  
	  
	 ------------------------------  H_SUB_ANIO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_SUB_ANIO'', 
							  ''ANIO_ID NUMBER(16,0) NOT NULL, -- PK ID del año de analisis
                            FECHA_CARGA_DATOS DATE NOT NULL,-- PK ID del ultimo dia cargado 
                            ASUNTO_ID NUMBER(16,0) NOT NULL, -- PK ID del asunto
                            PROCEDIMIENTO_ID NUMBER(16,0) NOT NULL,
                            SUBASTA_ID NUMBER(16,0) NOT NULL, -- PK ID de la subasta
                            LOTE_ID NUMBER(16,0) NOT NULL, -- PK ID del lote
                            NUMERO_AUTO_ID VARCHAR2(50 CHAR),
                            TIPO_SUBASTA_ID NUMBER(16,0),
                            ESTADO_SUBASTA_ID NUMBER(16,0),
                            MOTIVO_SUSPEN_ID NUMBER(16,0),
                            SUBMOTIVO_SUSPEN_ID NUMBER(16,0),
                            MOTIVO_CANCEL_ID NUMBER(16,0),
                            TIPO_ADJUDICACION_ID NUMBER(16,0),
                            FECHA_ANUNCIO_SUBASTA DATE,
                            FECHA_SOLICITUD_SUBASTA DATE,
                            FECHA_SENYALAMIENTO_SUBASTA DATE,
                            TD_ANUNCIO_SOLICITUD NUMBER(16,0),
                            TD_SENYALAMIENTO_ANUNCIO NUMBER(16,0),
                            TD_SENYALAMIENTO_SOLICITUD NUMBER(16,0),
                            -- Metricas
                            IMP_PUJA_SIN_POSTORES NUMBER(16,2),
                            IMP_PUJA_CON_POSTORES_DESDE NUMBER(16,2),
                            IMP_PUJA_CON_POSTORES_HASTA NUMBER(16,2),
                            IMP_VALOR_SUBASTA NUMBER(16,2),
                            IMP_DEUDA_JUDICIAL NUMBER(16,2),
                            P_ANUNCIO_SOLICITUD INTEGER, 
                            P_SENYALAMIENTO_ANUNCIO INTEGER,
                            P_SENYALAMIENTO_SOLICITUD INTEGER,
                            NUM_PROCEDIMIENTO INTEGER)
                            	SEGMENT CREATION IMMEDIATE NOLOGGING
                            TABLESPACE "RECOVERY_PRODUC_DWH"   
                            PARTITION BY RANGE ("ANIO_ID") INTERVAL (1) 
                           (PARTITION "P1" VALUES LESS THAN (2015) 
                           TABLESPACE "RECOVERY_PRODUC_DWH"'', :error); END;';

							execute immediate V_SQL USING OUT error;

			V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_GSUB_ANIO_IX'', ''H_GSUB_ANIO (ANIO_ID,ASUNTO_ID, PROCEDIMIENTO_ID, SUBASTA_ID,LOTE_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla  H_SUB_ANIO');

   


    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;
    

  end;

END CREAR_H_SUBASTA;