create or replace PROCEDURE CREAR_H_BIEN (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Rafael Aracil, PFS Group
-- Fecha creacion: Agosto 2015
-- Responsable ultima modificacion: María Villanueva, PFS Group
-- Fecha ultima modificacion: 11/11/2015
-- Motivos del cambio: Usuario propietario
-- Cliente: Recovery BI PRODUCTO
--
-- Descripcion: Procedimiento almancenado que carga las tablas del hecho BIEN.
-- ===============================================================================================

-- -------------------------------------------- INDICE -------------------------------------------


BEGIN
  declare
  nCount NUMBER;
  V_SQL VARCHAR2(16000);
  V_NOMBRE VARCHAR2(50) := 'CREAR_H_BIEN';
  
  begin
  
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
	
	
	
 
    
    ------------------------------ TMP_H_BIE --------------------------
    	V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_H_BIE'', 
                              ''DIA_ID DATE NOT NULL, 
				FECHA_CARGA_DATOS DATE NOT NULL,
				ASUNTO_ID NUMBER(16,0), 
				LOTE_ID NUMBER(16,0) NOT NULL, 
				BIE_ID NUMBER(16,0) NOT NULL, 
				TIPO_BIEN_ID NUMBER(16,0),
				SUBTIPO_BIEN_ID NUMBER(16,0),
				POBLACION_BIEN_ID NUMBER(16,0),
				BIEN_ADJUDICADO_ID NUMBER(16,0),
				ADJ_CESION_REM_BIEN_ID NUMBER(16,0),
				CODIGO_ACTIVO_BIEN_ID NUMBER(16,0),
				ENTIDAD_ADJUDICATARIA_ID NUMBER(16,0),
				 PROCEDIMIENTO_ID NUMBER(16,0),
				FASE_ACTUAL_DETALLE_ID NUMBER(16,0),
				 TIPO_PROCEDIMIENTO_DET_ID NUMBER(16,0),
				FASE_ACTUAL_AGR_ID NUMBER(16,0),
				TITULAR_PROCEDIMIENTO_ID NUMBER(16,0),
				IMP_VALOR_BIEN NUMBER(16,2),
				IMP_ADJUDICADO NUMBER(16,2),
				IMP_CESION_REMATE NUMBER(16,2),
        IMP_BIE_TIPO_SUBASTA NUMBER(16,2),
		BIE_FASE_ACTUAL_DETALLE_ID NUMBER(16,0)
         '', :error); END;';
		 execute immediate V_SQL USING OUT error;
 DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_H_BIE');
  
	   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_BIE_IX'', ''TMP_H_BIE (DIA_ID,LOTE_ID,BIE_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

  DBMS_OUTPUT.PUT_LINE('---- Creacion indices en TMP_H_BIE');

    ------------------------------ H_BIE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_BIE'', 
              ''DIA_ID DATE NOT NULL, 
				FECHA_CARGA_DATOS DATE NOT NULL,
				LOTE_ID NUMBER(16,0) NOT NULL, 
				BIE_ID NUMBER(16,0) NOT NULL, 
				TIPO_BIEN_ID NUMBER(16,0),
				SUBTIPO_BIEN_ID NUMBER(16,0),
				POBLACION_BIEN_ID NUMBER(16,0),
				BIEN_ADJUDICADO_ID NUMBER(16,0),
				ADJ_CESION_REM_BIEN_ID NUMBER(16,0),
				CODIGO_ACTIVO_BIEN_ID NUMBER(16,0),
				ENTIDAD_ADJUDICATARIA_ID NUMBER(16,0),
				PROCEDIMIENTO_ID NUMBER(16,0),
				FASE_ACTUAL_DETALLE_ID NUMBER(16,0),
				TIPO_PROCEDIMIENTO_DET_ID NUMBER(16,0),
				FASE_ACTUAL_AGR_ID NUMBER(16,0),
				TITULAR_PROCEDIMIENTO_ID NUMBER(16,0),
				IMP_VALOR_BIEN NUMBER(16,2),
				IMP_ADJUDICADO NUMBER(16,2),
				IMP_CESION_REMATE NUMBER(16,2),
				IMP_BIE_TIPO_SUBASTA NUMBER(16,2),
				BIE_FASE_ACTUAL_DETALLE_ID NUMBER(16,0))
				SEGMENT CREATION IMMEDIATE 
					TABLESPACE "RECOVERY_PRODUC_DWH" 
                    PARTITION BY RANGE ("DIA_ID")
                    INTERVAL(NUMTOYMINTERVAL(1, ''''MONTH''''))
                    (PARTITION "p1" VALUES LESS THAN (TO_DATE('''' 2014-11-01 00:00:00'''', ''''SYYYY-MM-DD HH24:MI:SS'''', ''''NLS_CALENDAR=GREGORIAN''''))'', :error); END;';
	 execute immediate V_SQL USING OUT error;
    
    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_BIE');

	    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_BIE_IX'', ''H_BIE (DIA_ID,LOTE_ID,BIE_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
      

      DBMS_OUTPUT.PUT_LINE('---- Creacion indices en H_BIE');

    ------------------------------ H_BIE_SEMANA--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_BIE_SEMANA'', 
              	              ''SEMANA_ID NUMBER(16,0) NOT NULL, 
				FECHA_CARGA_DATOS DATE NOT NULL,
				LOTE_ID NUMBER(16,0) NOT NULL, 
				BIE_ID NUMBER(16,0) NOT NULL,
				TIPO_BIEN_ID NUMBER(16,0),
				SUBTIPO_BIEN_ID NUMBER(16,0),
				POBLACION_BIEN_ID NUMBER(16,0),
				BIEN_ADJUDICADO_ID NUMBER(16,0),
				ADJ_CESION_REM_BIEN_ID NUMBER(16,0),
				CODIGO_ACTIVO_BIEN_ID NUMBER(16,0),
				ENTIDAD_ADJUDICATARIA_ID NUMBER(16,0),
				PROCEDIMIENTO_ID NUMBER(16,0),
				FASE_ACTUAL_DETALLE_ID NUMBER(16,0),
				TIPO_PROCEDIMIENTO_DET_ID NUMBER(16,0),
				FASE_ACTUAL_AGR_ID NUMBER(16,0),
				TITULAR_PROCEDIMIENTO_ID NUMBER(16,0),
				IMP_VALOR_BIEN NUMBER(16,2),
				IMP_ADJUDICADO NUMBER(16,2),
				IMP_CESION_REMATE NUMBER(16,2),
				IMP_BIE_TIPO_SUBASTA NUMBER(16,2),
				BIE_FASE_ACTUAL_DETALLE_ID NUMBER(16,0))
			    SEGMENT CREATION IMMEDIATE NOLOGGING
                            TABLESPACE "RECOVERY_PRODUC_DWH"   
                            PARTITION BY RANGE ("SEMANA_ID") INTERVAL (1) 
                           (PARTITION "P1" VALUES LESS THAN (201501) 
                           TABLESPACE "RECOVERY_PRODUC_DWH"'', :error); END;';


	execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_BIE_SEMANA');
	  
	  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_BIE_SEMANA_IX'', ''H_BIE_SEMANA (SEMANA_ID,LOTE_ID,BIE_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
	
	DBMS_OUTPUT.PUT_LINE('---- Creacion index H_BIE_SEMANA');

    ------------------------------  H_BIE_MES --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_BIE_MES'', 
              		      ''MES_ID NUMBER(16,0) NOT NULL, -- PK ID del mes de análisis
                                FECHA_CARGA_DATOS DATE NOT NULL,-- PK ID del ultimo dia cargado
                                LOTE_ID NUMBER(16,0) NOT NULL, -- PK ID del lote
                                BIE_ID NUMBER(16,0) NOT NULL, -- PK ID del bien
                                TIPO_BIEN_ID NUMBER(16,0),
                                SUBTIPO_BIEN_ID NUMBER(16,0),
                                POBLACION_BIEN_ID NUMBER(16,0),
                                BIEN_ADJUDICADO_ID NUMBER(16,0),
                                ADJ_CESION_REM_BIEN_ID NUMBER(16,0),
                                CODIGO_ACTIVO_BIEN_ID NUMBER(16,0),
                                ENTIDAD_ADJUDICATARIA_ID NUMBER(16,0),
                                PROCEDIMIENTO_ID NUMBER(16,0),
                                FASE_ACTUAL_DETALLE_ID NUMBER(16,0),
                                TIPO_PROCEDIMIENTO_DET_ID NUMBER(16,0),
                                FASE_ACTUAL_AGR_ID NUMBER(16,0),
                                TITULAR_PROCEDIMIENTO_ID NUMBER(16,0),
                                -- Metricas
                                IMP_VALOR_BIEN NUMBER(16,2),
                                IMP_ADJUDICADO NUMBER(16,2),
                                IMP_CESION_REMATE NUMBER(16,2),
                                IMP_BIE_TIPO_SUBASTA NUMBER(16,2),
				BIE_FASE_ACTUAL_DETALLE_ID NUMBER(16,0))
                		SEGMENT CREATION IMMEDIATE NOLOGGING
                           	TABLESPACE "RECOVERY_PRODUC_DWH"   
                           	PARTITION BY RANGE ("MES_ID") INTERVAL (1) 
                           	(PARTITION "P1" VALUES LESS THAN (201501) 
                           	TABLESPACE "RECOVERY_PRODUC_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla  H_BIE_MES');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_BIE_MES_IX'', ''H_BIE_MES (MES_ID,LOTE_ID,BIE_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion indices  H_BIE_MES');
    

    ------------------------------ H_BIE_TRIMESTRE  --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_BIE_TRIMESTRE'', 
              		      ''TRIMESTRE_ID NUMBER(16,0) NOT NULL, -- PK ID del trimestre de análisis
				FECHA_CARGA_DATOS DATE NOT NULL,-- PK ID del ultimo dia cargado
				LOTE_ID NUMBER(16,0) NOT NULL, -- PK ID del lote
				BIE_ID NUMBER(16,0) NOT NULL, -- PK ID del bien
				TIPO_BIEN_ID NUMBER(16,0),
				SUBTIPO_BIEN_ID NUMBER(16,0),
				POBLACION_BIEN_ID NUMBER(16,0),
				BIEN_ADJUDICADO_ID NUMBER(16,0),
				ADJ_CESION_REM_BIEN_ID NUMBER(16,0),
				CODIGO_ACTIVO_BIEN_ID NUMBER(16,0),
				ENTIDAD_ADJUDICATARIA_ID NUMBER(16,0),
        			PROCEDIMIENTO_ID NUMBER(16,0),
       				FASE_ACTUAL_DETALLE_ID NUMBER(16,0),
        			TIPO_PROCEDIMIENTO_DET_ID NUMBER(16,0),
        			FASE_ACTUAL_AGR_ID NUMBER(16,0),
        			TITULAR_PROCEDIMIENTO_ID NUMBER(16,0),
				-- Metricas
				IMP_VALOR_BIEN NUMBER(16,2),
				IMP_ADJUDICADO NUMBER(16,2),
				IMP_CESION_REMATE NUMBER(16,2),
        			IMP_BIE_TIPO_SUBASTA NUMBER(16,2),
				BIE_FASE_ACTUAL_DETALLE_ID NUMBER(16,0))
                            	SEGMENT CREATION IMMEDIATE NOLOGGING
                            	TABLESPACE "RECOVERY_PRODUC_DWH"   
                            	PARTITION BY RANGE ("TRIMESTRE_ID") INTERVAL (1) 
                            	(PARTITION "P1" VALUES LESS THAN (201501) 
                            	TABLESPACE "RECOVERY_PRODUC_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;

       DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_BIE_TRIMESTRE');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_BIE_TRIMESTRE_IX'', ''H_BIE_TRIMESTRE (TRIMESTRE_ID,LOTE_ID,BIE_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

             DBMS_OUTPUT.PUT_LINE('---- Creacion indices H_BIE_TRIMESTRE');
    

    ------------------------------  H_BIE_ANIO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_BIE_ANIO'', 
              		      ''ANIO_ID NUMBER(16,0) NOT NULL, -- PK ID del año de análisis
				FECHA_CARGA_DATOS DATE NOT NULL,-- PK ID del ultimo dia cargado
				LOTE_ID NUMBER(16,0) NOT NULL, -- PK ID del lote
				BIE_ID NUMBER(16,0) NOT NULL, -- PK ID del bien
				TIPO_BIEN_ID NUMBER(16,0),
				SUBTIPO_BIEN_ID NUMBER(16,0),
				POBLACION_BIEN_ID NUMBER(16,0),
				BIEN_ADJUDICADO_ID NUMBER(16,0),
				ADJ_CESION_REM_BIEN_ID NUMBER(16,0),
				CODIGO_ACTIVO_BIEN_ID NUMBER(16,0),
				ENTIDAD_ADJUDICATARIA_ID NUMBER(16,0),
        			PROCEDIMIENTO_ID NUMBER(16,0),
        			FASE_ACTUAL_DETALLE_ID NUMBER(16,0),
        			TIPO_PROCEDIMIENTO_DET_ID NUMBER(16,0),
        			FASE_ACTUAL_AGR_ID NUMBER(16,0),
        			TITULAR_PROCEDIMIENTO_ID NUMBER(16,0),
				-- Metricas
				IMP_VALOR_BIEN NUMBER(16,2),
				IMP_ADJUDICADO NUMBER(16,2),
				IMP_CESION_REMATE NUMBER(16,2),
        			IMP_BIE_TIPO_SUBASTA NUMBER(16,2),
				BIE_FASE_ACTUAL_DETALLE_ID NUMBER(16,0))
                            	SEGMENT CREATION IMMEDIATE NOLOGGING
                            	TABLESPACE "RECOVERY_PRODUC_DWH"   
                            	PARTITION BY RANGE ("ANIO_ID") INTERVAL (1) 
                            	(PARTITION "P1" VALUES LESS THAN (2015) 
                            	TABLESPACE "RECOVERY_PRODUC_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;

      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla  H_BIE_ANIO');

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_BIE_ANIO_IX'', ''H_BIE_ANIO (ANIO_ID,LOTE_ID,BIE_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;


      DBMS_OUTPUT.PUT_LINE('---- Creacion indices  H_BIE_ANIO');
    



    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;
    

  end;

END CREAR_H_BIEN;