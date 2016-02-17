create or replace PROCEDURE CREAR_H_PER (error OUT VARCHAR2) AS 
-- ===============================================================================================
-- Autor: María Villanueva, PFS Group
-- Fecha creacion: Septiembre 2015 2015
-- Responsable ultima modificacion: María Villanueva, PFS Group
-- Fecha Última modificación: 01/12/2015

-- Motivos del cambio: usuario propietario
-- Cliente: Recovery BI Cajamar
--
-- Descripcion: Procedimiento almancenado que crea las tablas del Hecho Persona
-- ===============================================================================================
-- -------------------------------------------- INDICE -------------------------------------------
-- HECHO PROCEDIMIENTO
    -- H_PER
    -- TMP_H_PER
    -- H_PER_SEMANA
    -- H_PER_MES
    -- H_PER_TRIMESTRE
    -- H_PER_ANIO
    -- TMP_FECHA_PER
    -- H_PER_DET_ALERTA
    -- H_PER_DET_ALERTA_SEMANA
    -- H_PER_DET_ALERTA_MES
    -- H_PER_DET_ALERTA_TRIMESTRE
    -- H_PER_DET_ALERTA_ANIO
    -- TMP_H_PER_DET_ALERTA
BEGIN
  declare
  nCount NUMBER;
 V_SQL varchar2(16000);

  V_NOMBRE VARCHAR2(50) := 'CREAR_H_PER';
 begin

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
    
        ------------------------------ H_PER --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PER'',



						  ''DIA_ID DATE NOT NULL ,
                            FECHA_CARGA_DATOS DATE NOT NULL , 
                            PERSONA_ID NUMBER(16,0) NOT NULL ,  
                            POLITICA_PERSONA_ID NUMBER(16,0) , 
                            POLITICA_PERSONA_ANT_ID NUMBER(16,0), 
                            TIPO_POLITICA_PERSONA_ID NUMBER(16,0) , 
                            TIPO_POLITICA_PER_ANT_ID NUMBER(16,0),
                            RATING_ID NUMBER(16,0) , 
                            RATING_ANT_ID NUMBER(16,0) , 
                            ZONA_PERSONA_ID NUMBER(16,0) , 
                            OFICINA_PERSONA_ID NUMBER(16,0) , 
                            TRAMO_PUNTUACION_ID NUMBER(16,0), 
                            TRAMO_ALERTA_ID NUMBER(16,0),
                            TRAMO_VOLUMEN_RIESGO_ID NUMBER(16,0) NULL,
                            NUM_CLIENTES NUMBER(16,0), 
                            VOLUMEN_RIESGO NUMBER(14,2) , 
                            POS_VENCIDA NUMBER(14,2) , 
                            POS_NO_VENCIDA NUMBER(14,2) 
                          )
			  SEGMENT CREATION IMMEDIATE 
					TABLESPACE "RECOVERY_CM_DWH" 
                    PARTITION BY RANGE ("DIA_ID")
                    INTERVAL(NUMTOYMINTERVAL(1, ''''MONTH''''))
                    (PARTITION "p1" VALUES LESS THAN (TO_DATE('''' 2014-11-01 00:00:00'''', ''''SYYYY-MM-DD HH24:MI:SS'''', ''''NLS_CALENDAR=GREGORIAN''''))'', :error); END;';
	 execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PER');
       V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PER_IX'', ''H_PER (DIA_ID, PERSONA_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

       DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PER');
    

    
    
      ------------------------------ TMP_H_PER --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_H_PER'',



						  ''DIA_ID DATE NOT NULL ,
                            FECHA_CARGA_DATOS DATE NOT NULL , 
                            PERSONA_ID NUMBER(16,0) NOT NULL ,  
                            POLITICA_PERSONA_ID NUMBER(16,0) , 
                            POLITICA_PERSONA_ANT_ID NUMBER(16,0) , 
                            TIPO_POLITICA_PERSONA_ID NUMBER(16,0) , 
                            TIPO_POLITICA_PER_ANT_ID NUMBER(16,0),
                            RATING_ID NUMBER(16,0), 
                            RATING_ANT_ID NUMBER(16,0) , 
                            ZONA_PERSONA_ID NUMBER(16,0), 
                            OFICINA_PERSONA_ID NUMBER(16,0), 
                            TRAMO_PUNTUACION_ID NUMBER(16,0), 
                            TRAMO_ALERTA_ID NUMBER(16,0),
                            TRAMO_VOLUMEN_RIESGO_ID NUMBER(16,0) NULL,
                            NUM_CLIENTES NUMBER(16,0), 
                            VOLUMEN_RIESGO NUMBER(14,2), 
                            POS_VENCIDA NUMBER(14,2) , 
                            POS_NO_VENCIDA NUMBER(14,2)
                            '', :error); END;';
		 execute immediate V_SQL USING OUT error;

     DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_H_PER');
       V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_PER_IX'', ''TMP_H_PER (DIA_ID, PERSONA_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

       DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_H_PER');
    

    
------------------------------ H_PER_SEMANA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PER_SEMANA'',



						  ''SEMANA_ID NUMBER(16,0) NOT NULL,
                            FECHA_CARGA_DATOS DATE NOT NULL ,  
                            PERSONA_ID NUMBER(16,0) NOT NULL ,  
                            POLITICA_PERSONA_ID NUMBER(16,0), 
                            POLITICA_PERSONA_ANT_ID NUMBER(16,0) , 
                            TIPO_POLITICA_PERSONA_ID NUMBER(16,0) , 
                            TIPO_POLITICA_PER_ANT_ID NUMBER(16,0),
                            RATING_ID NUMBER(16,0) , 
                            RATING_ANT_ID NUMBER(16,0) , 
                            ZONA_PERSONA_ID NUMBER(16,0) , 
                            OFICINA_PERSONA_ID NUMBER(16,0) , 
                            TRAMO_PUNTUACION_ID NUMBER(16,0) , 
                            TRAMO_ALERTA_ID NUMBER(16,0) ,
                            TRAMO_VOLUMEN_RIESGO_ID NUMBER(16,0) NULL,
                            NUM_CLIENTES NUMBER(16,0), 
                            VOLUMEN_RIESGO NUMBER(14,2) , 
                            POS_VENCIDA NUMBER(14,2) , 
                            POS_NO_VENCIDA NUMBER(14,2) 
                          )
                              SEGMENT CREATION IMMEDIATE NOLOGGING
                            TABLESPACE "RECOVERY_CM_DWH"   
                            PARTITION BY RANGE ("SEMANA_ID") INTERVAL (1) 
                           (PARTITION "P1" VALUES LESS THAN (201501) 
                           TABLESPACE "RECOVERY_CM_DWH"'', :error); END;';
	execute immediate V_SQL USING OUT error;

       DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PER_SEMANA');
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PER_SEMANA_IX'', ''H_PER_SEMANA (SEMANA_ID, PERSONA_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
       DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PER_SEMANA');
     

    
    ------------------------------ H_PER_MES --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PER_MES'',



						  ''MES_ID NUMBER(16,0) NOT NULL, 
                            FECHA_CARGA_DATOS DATE NOT NULL ,  
                            PERSONA_ID NUMBER(16,0) NOT NULL , 
                            POLITICA_PERSONA_ID NUMBER(16,0) , 
                            POLITICA_PERSONA_ANT_ID NUMBER(16,0) , 
                            TIPO_POLITICA_PERSONA_ID NUMBER(16,0) , 
                            TIPO_POLITICA_PER_ANT_ID NUMBER(16,0),
                            RATING_ID NUMBER(16,0) , 
                            RATING_ANT_ID NUMBER(16,0) , 
                            ZONA_PERSONA_ID NUMBER(16,0) , 
                            OFICINA_PERSONA_ID NUMBER(16,0) , 
                            TRAMO_PUNTUACION_ID NUMBER(16,0) , 
                            TRAMO_ALERTA_ID NUMBER(16,0) ,
                            TRAMO_VOLUMEN_RIESGO_ID NUMBER(16,0) NULL,
                            NUM_CLIENTES NUMBER(16,0), 
                            VOLUMEN_RIESGO NUMBER(14,2) , 
                            POS_VENCIDA NUMBER(14,2) , 
                            POS_NO_VENCIDA NUMBER(14,2) 
                           )
                              SEGMENT CREATION IMMEDIATE NOLOGGING
                           	TABLESPACE "RECOVERY_CM_DWH"   
                           	PARTITION BY RANGE ("MES_ID") INTERVAL (1) 
                           	(PARTITION "P1" VALUES LESS THAN (201501) 
                           	TABLESPACE "RECOVERY_CM_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;
       V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PER_MES_IX'', ''H_PER_MES (MES_ID, PERSONA_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;



       DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PER_MES');
     

    
    
 ------------------------------ H_PER_TRIMESTRE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PER_TRIMESTRE'',



						  ''TRIMESTRE_ID NUMBER(16,0) NOT NULL, 
                            FECHA_CARGA_DATOS DATE NOT NULL ,  
                            PERSONA_ID NUMBER(16,0) NOT NULL , 
                            POLITICA_PERSONA_ID NUMBER(16,0) , 
                            POLITICA_PERSONA_ANT_ID NUMBER(16,0) , 
                            TIPO_POLITICA_PERSONA_ID NUMBER(16,0) , 
                            TIPO_POLITICA_PER_ANT_ID NUMBER(16,0),
                            RATING_ID NUMBER(16,0) , 
                            RATING_ANT_ID NUMBER(16,0) , 
                            ZONA_PERSONA_ID NUMBER(16,0) , 
                            OFICINA_PERSONA_ID NUMBER(16,0) , 
                            TRAMO_PUNTUACION_ID NUMBER(16,0) , 
                            TRAMO_ALERTA_ID NUMBER(16,0) ,
                            TRAMO_VOLUMEN_RIESGO_ID NUMBER(16,0) NULL,
                            NUM_CLIENTES NUMBER(16,0), 
                            VOLUMEN_RIESGO NUMBER(14,2) , 
                            POS_VENCIDA NUMBER(14,2) , 
                            POS_NO_VENCIDA NUMBER(14,2) 
                             )
                              SEGMENT CREATION IMMEDIATE NOLOGGING
                            	TABLESPACE "RECOVERY_CM_DWH"   
                            	PARTITION BY RANGE ("TRIMESTRE_ID") INTERVAL (1) 
                            	(PARTITION "P1" VALUES LESS THAN (201501) 
                            	TABLESPACE "RECOVERY_CM_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;

       DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PER_TRIMESTRE');
       V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PER_TRIMESTRE_IX'', ''H_PER_TRIMESTRE (TRIMESTRE_ID, PERSONA_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
       DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PER_TRIMESTRE');
     

    
------------------------------ H_PER_ANIO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PER_ANIO'',



						  ''ANIO_ID NUMBER(16,0) NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL ,  
                              PERSONA_ID NUMBER(16,0) NOT NULL ,  
                              POLITICA_PERSONA_ID NUMBER(16,0) , 
                              POLITICA_PERSONA_ANT_ID NUMBER(16,0) , 
                              TIPO_POLITICA_PERSONA_ID NUMBER(16,0) , 
                              TIPO_POLITICA_PER_ANT_ID NUMBER(16,0),
                              RATING_ID NUMBER(16,0) , 
                              RATING_ANT_ID NUMBER(16,0) , 
                              ZONA_PERSONA_ID NUMBER(16,0) , 
                              OFICINA_PERSONA_ID NUMBER(16,0) , 
                              TRAMO_PUNTUACION_ID NUMBER(16,0) , 
                              TRAMO_ALERTA_ID NUMBER(16,0) ,
                              TRAMO_VOLUMEN_RIESGO_ID NUMBER(16,0) NULL,
                              NUM_CLIENTES NUMBER(16,0), 
                              VOLUMEN_RIESGO NUMBER(14,2) , 
                              POS_VENCIDA NUMBER(14,2) , 
                              POS_NO_VENCIDA NUMBER(14,2) 
                                )
                             SEGMENT CREATION IMMEDIATE NOLOGGING
                            	TABLESPACE "RECOVERY_CM_DWH"   
                            	PARTITION BY RANGE ("ANIO_ID") INTERVAL (1) 
                            	(PARTITION "P1" VALUES LESS THAN (2015) 
                            	TABLESPACE "RECOVERY_CM_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;

   DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PER_ANIO');
       V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PER_ANIO_IX'', ''H_PER_ANIO (ANIO_ID, PERSONA_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;

       DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PER_ANIO');
         

    

------------------------------ H_PER_DET_ALERTA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PER_DET_ALERTA'',




						  ''DIA_ID DATE NOT NULL, 
                            FECHA_CARGA_DATOS DATE NOT NULL , 
                            PERSONA_ID NUMBER(16,0) NOT NULL , 
                            ALERTA_ID NUMBER(16,0) NOT NULL , 
                            CONTRATO_ID NUMBER(16,0) NULL,
                            TIPO_ALERTA_ID NUMBER(16,0) NOT NULL , 
                            CALIFICACION_ALERTA_ID NUMBER(16,0) NOT NULL ,
                            GESTION_ALERTA_ID NUMBER(16,0) NOT NULL ,
                            NUM_ALERTAS NUMBER(16,0)
							)
                        SEGMENT CREATION IMMEDIATE 
					TABLESPACE "RECOVERY_CM_DWH" 
                    PARTITION BY RANGE ("DIA_ID")
                    INTERVAL(NUMTOYMINTERVAL(1, ''''MONTH''''))
                    (PARTITION "p1" VALUES LESS THAN (TO_DATE('''' 2014-11-01 00:00:00'''', ''''SYYYY-MM-DD HH24:MI:SS'''', ''''NLS_CALENDAR=GREGORIAN''''))'', :error); END;';
	 execute immediate V_SQL USING OUT error;
	 
   DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PER_DET_ALERTA');
  
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PER_DET_ALERTA_IX'', ''H_PER_DET_ALERTA (DIA_ID, PERSONA_ID,ALERTA_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
   DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PER_DET_ALERTA');
    

   

------------------------------ H_PER_DET_ALERTA_SEMANA --------------------------



    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PER_DET_ALERTA_SEMANA'',
						  ''SEMANA_ID NUMBER(16,0) NOT NULL , 
                              FECHA_CARGA_DATOS DATE NOT NULL , 
                              PERSONA_ID NUMBER(16,0) NOT NULL , 
                              ALERTA_ID NUMBER(16,0) NOT NULL , 
                              CONTRATO_ID NUMBER(16,0) NULL,
                              TIPO_ALERTA_ID NUMBER(16,0) NOT NULL , 
                              CALIFICACION_ALERTA_ID NUMBER(16,0) NOT NULL ,
                              GESTION_ALERTA_ID NUMBER(16,0) NOT NULL ,
                              NUM_ALERTAS NUMBER(16,0)
                          )
                              SEGMENT CREATION IMMEDIATE NOLOGGING
                            TABLESPACE "RECOVERY_CM_DWH"   
                            PARTITION BY RANGE ("SEMANA_ID") INTERVAL (1) 
                           (PARTITION "P1" VALUES LESS THAN (201501) 
                           TABLESPACE "RECOVERY_CM_DWH"'', :error); END;';
	execute immediate V_SQL USING OUT error;

   DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PER_DET_ALERTA_SEMANA');
  
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PER_DET_ALERTA_SEMANA_IX'', ''H_PER_DET_ALERTA_SEMANA (SEMANA_ID, PERSONA_ID,ALERTA_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
   DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PER_DET_ALERTA_SEMANA');
    

   
 ------------------------------ H_PER_DET_ALERTA_MES --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PER_DET_ALERTA_MES'',




						  ''MES_ID NUMBER(16,0) NOT NULL , 
                          FECHA_CARGA_DATOS DATE NOT NULL , 
                          PERSONA_ID NUMBER(16,0) NOT NULL , 
                          ALERTA_ID NUMBER(16,0) NOT NULL , 
                          CONTRATO_ID NUMBER(16,0) NULL,
                          TIPO_ALERTA_ID NUMBER(16,0) NOT NULL , 
                          CALIFICACION_ALERTA_ID NUMBER(16,0) NOT NULL ,
                          GESTION_ALERTA_ID NUMBER(16,0) NOT NULL ,
                          NUM_ALERTAS NUMBER(16,0)
                       )
                              SEGMENT CREATION IMMEDIATE NOLOGGING
                           	TABLESPACE "RECOVERY_CM_DWH"   
                           	PARTITION BY RANGE ("MES_ID") INTERVAL (1) 
                           	(PARTITION "P1" VALUES LESS THAN (201501) 
                           	TABLESPACE "RECOVERY_CM_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;

   DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PER_DET_ALERTA_MES');
  
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PER_DET_ALERTA_MES_IX'', ''H_PER_DET_ALERTA_MES (MES_ID, PERSONA_ID,ALERTA_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
   DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PER_DET_ALERTA_MES');
      

   
  ------------------------------ H_PER_DET_ALERTA_TRIMESTRE --------------------------



    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PER_DET_ALERTA_TRIMESTRE'',
						  ''TRIMESTRE_ID NUMBER(16,0) NOT NULL , 
                              FECHA_CARGA_DATOS DATE NOT NULL , 
                              PERSONA_ID NUMBER(16,0) NOT NULL , 
                              ALERTA_ID NUMBER(16,0) NOT NULL , 
                              CONTRATO_ID NUMBER(16,0) NULL,
                              TIPO_ALERTA_ID NUMBER(16,0) NOT NULL , 
                              CALIFICACION_ALERTA_ID NUMBER(16,0) NOT NULL ,
                              GESTION_ALERTA_ID NUMBER(16,0) NOT NULL ,
                              NUM_ALERTAS NUMBER(16,0)
                             )
                              SEGMENT CREATION IMMEDIATE NOLOGGING
                            	TABLESPACE "RECOVERY_CM_DWH"   
                            	PARTITION BY RANGE ("TRIMESTRE_ID") INTERVAL (1) 
                            	(PARTITION "P1" VALUES LESS THAN (201501) 
                            	TABLESPACE "RECOVERY_CM_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;

   DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PER_DET_ALERTA_TRIMESTRE');
  
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PER_DET_ALERTA_TRIMESTRE_IX'', ''H_PER_DET_ALERTA_TRIMESTRE (TRIMESTRE_ID, PERSONA_ID,ALERTA_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
   DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PER_DET_ALERTA_TRIMESTRE');
        

   
   ------------------------------ H_PER_DET_ALERTA_ANIO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_PER_DET_ALERTA_ANIO'',




						  ''ANIO_ID NUMBER(16,0) NOT NULL , 
                          FECHA_CARGA_DATOS DATE NOT NULL , 
                          PERSONA_ID NUMBER(16,0) NOT NULL , 
                          ALERTA_ID NUMBER(16,0) NOT NULL ,
                          CONTRATO_ID NUMBER(16,0) NULL,
                          TIPO_ALERTA_ID NUMBER(16,0) NOT NULL , 
                          CALIFICACION_ALERTA_ID NUMBER(16,0) NOT NULL ,
                          GESTION_ALERTA_ID NUMBER(16,0) NOT NULL ,
                          NUM_ALERTAS NUMBER(16,0)
                        )
                             SEGMENT CREATION IMMEDIATE NOLOGGING
                            	TABLESPACE "RECOVERY_CM_DWH"   
                            	PARTITION BY RANGE ("ANIO_ID") INTERVAL (1) 
                            	(PARTITION "P1" VALUES LESS THAN (2015) 
                            	TABLESPACE "RECOVERY_CM_DWH"'', :error); END;';
      execute immediate V_SQL USING OUT error;

   DBMS_OUTPUT.PUT_LINE('---- Creacion tabla H_PER_DET_ALERTA_ANIO');
  
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PER_DET_ALERTA_ANIO_IX'', ''H_PER_DET_ALERTA_ANIO (ANIO_ID, PERSONA_ID,ALERTA_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
   DBMS_OUTPUT.PUT_LINE('---- Creacion indice en H_PER_DET_ALERTA_ANIO');
       

   
------------------------------ TMP_H_PER_DET_ALERTA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_H_PER_DET_ALERTA'',




						  ''DIA_ID DATE NOT NULL , 
                            FECHA_CARGA_DATOS DATE NOT NULL , 
                            PERSONA_ID NUMBER(16,0) NOT NULL , 
                            ALERTA_ID NUMBER(16,0) NOT NULL ,
                            CONTRATO_ID NUMBER(16,0) NULL,
                            TIPO_ALERTA_ID NUMBER(16,0) NOT NULL , 
                            CALIFICACION_ALERTA_ID NUMBER(16,0) NOT NULL ,
                            GESTION_ALERTA_ID NUMBER(16,0) NOT NULL ,
                            NUM_ALERTAS NUMBER(16,0)
                          '', :error); END;';
							 execute immediate V_SQL USING OUT error;

   DBMS_OUTPUT.PUT_LINE('---- Creacion tabla TMP_H_PER_DET_ALERTA');
  
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_PER_DET_ALERTA_IX'', ''TMP_H_PER_DET_ALERTA (DIA_ID, PERSONA_ID,ALERTA_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
   DBMS_OUTPUT.PUT_LINE('---- Creacion indice en TMP_H_PER_DET_ALERTA');
       

   
	
    
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;

  end;   
END CREAR_H_PER;
