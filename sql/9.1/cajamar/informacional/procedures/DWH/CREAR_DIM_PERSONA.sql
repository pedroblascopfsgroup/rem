create or replace PROCEDURE CREAR_DIM_PERSONA (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: María Villanueva, PFS Group
-- Fecha creacion: Agosto 2015
-- Responsable ultima modificacion: María Villanueva, PFS Group
-- Fecha ultima modificacion: 30/03/2016
-- Motivos del cambio:Se añade CODIGO_RECOVERY a D_PER
-- Cliente: Recovery BI Cajamar
--
-- Descripcion: Procedimiento almancenado que crea las tablas de la dimension Persona
-- ===============================================================================================

-- -------------------------------------------- INDICE -------------------------------------------
-- DIMENSION PERSONA

    -- D_PER_OFICINA
    -- D_PER_POLITICA
    -- D_PER_POLITICA_ANTERIOR
    -- D_PER_RATING_EXTERNO
    -- D_PER_RATING_EXTERNO_ANTERIOR
    -- D_PER_TRAMO_PUNTUACION
    -- D_PER_GRUPO_ECONOMICO
    -- D_PER_SEGMENTO
    -- D_PER_SEGMENTO_DETALLE
    -- D_PER_TIPO_POLITICA
    -- D_PER_TIPO_POLITICA_ANT
    -- D_PER_ZONA
    -- D_PER_TRAMO_ALERTA
    -- D_PER_TIPO_ALERTA
    -- D_PER_CALIFICACION_ALERTA
    -- D_PER_GESTION_ALERTA
	
	------------ ATRIBUTOS AÑADIDOS DE BANKIA ---------------------
	
    -- D_PER_AMBITO_EXPEDIENTE
    -- D_PER_ARQUETIPO
    -- D_PER_ESTADO_FINANCIERO
    -- D_PER_GRUPO_GESTOR
    -- D_PER_ITINERARIO
    -- D_PER_NACIONALIDAD
    -- D_PER_NIVEL
    -- D_PER_PAIS_NACIMIENTO
    -- D_PER_PERFIL
    -- D_PER_PROVINCIA
    -- D_PER_RATING_AUXILIAR
    -- D_PER_SEXO
    -- D_PER_TENDENCIA
    -- D_PER_TIPO_DOCUMENTO
    -- D_PER_TIPO_ITINERARIO
    -- D_PER_TIPO_PERSONA
    -- D_PER_TRAMO_VOLUMEN_RIESGO
---------------------------------------------------------------------------
    -- D_PER

BEGIN

declare
  nCount NUMBER;
  V_SQL varchar2(16000);
  V_NOMBRE VARCHAR2(50) := 'CREAR_DIM_PERSONA';

  begin

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
    
   

    ------------------------------ D_PER_OFICINA --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_OFICINA'',
						  ''OFICINA_PERSONA_ID NUMBER(16,0) NOT NULL,
                            OFICINA_PERSONA_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (OFICINA_PERSONA_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER_OFICINA');
    

    

    ------------------------------ D_PER_POLITICA --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_POLITICA'',
						  ''POLITICA_PERSONA_ID NUMBER(16,0) NOT NULL,
                            POLITICA_PERSONA_DESC VARCHAR2(50 CHAR),
                            POLITICA_PERSONA_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (POLITICA_PERSONA_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER_POLITICA');
    

    ------------------------------ D_PER_POLITICA_ANTERIOR --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_POLITICA_ANTERIOR'',
						  ''POLITICA_PERSONA_ANT_ID NUMBER(16,0) NOT NULL ENABLE,
                          POLITICA_PERSONA_ANT_DESC VARCHAR2(50 CHAR),
                          POLITICA_PERSONA_ANT_DESC_2 VARCHAR2(250 CHAR),
                          PRIMARY KEY (POLITICA_PERSONA_ANT_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
   DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER_POLITICA_ANTERIOR');
     
    
    ------------------------------ D_PER_RATING_EXTERNO --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_RATING_EXTERNO'',
						  ''RATING_EXTERNO_ID NUMBER(16,0) NOT NULL,
                            RATING_EXTERNO_DESC VARCHAR2(50 CHAR),
                            RATING_EXTERNO_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (RATING_EXTERNO_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER_RATING_EXTERNO');
    


    ------------------------------ D_PER_RATING_EXTERNO_ANTERIOR --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_RATING_EXTERNO_ANTERIOR'',
						''RATING_ANT_ID NUMBER(16,0) NOT NULL ENABLE,
                        RATING_ANT_DESC VARCHAR2(50 CHAR),
                        RATING_ANT_DESC_2 VARCHAR2(250 CHAR),
                        PRIMARY KEY (RATING_ANT_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
   DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER_RATING_EXTERNO_ANTERIOR');
    
    
     ------------------------------ D_PER_TRAMO_PUNTUACION --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_TRAMO_PUNTUACION'',
			    ''TRAMO_PUNTUACION_ID NUMBER(16,0) NOT NULL ENABLE,
                  TRAMO_PUNTUACION_DESC VARCHAR2(50 CHAR),
                  PRIMARY KEY (TRAMO_PUNTUACION_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER_TRAMO_PUNTUACION');
    
    
   ------------------------------ D_PER_GRUPO_ECONOMICO --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_GRUPO_ECONOMICO'',
			''GRUPO_ECONOMICO_ID NUMBER(16,0) NOT NULL ENABLE,
              GRUPO_ECONOMICO_DESC VARCHAR2(50 CHAR),
              PRIMARY KEY (GRUPO_ECONOMICO_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;

DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER_GRUPO_ECONOMICO');
    
    ------------------------------ D_PER_SEGMENTO --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_SEGMENTO'',
						  ''SEGMENTO_ID NUMBER(16,0) NOT NULL,
                            SEGMENTO_DESC VARCHAR2(50 CHAR),
                            SEGMENTO_DEC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (SEGMENTO_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER_SEGMENTO');
    

    ------------------------------ D_PER_SEGMENTO_DETALLE --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_SEGMENTO_DETALLE'',
						  ''SEGMENTO_DETALLE_ID NUMBER(16,0) NOT NULL,
                            SEGMENTO_DETALLE_DESC VARCHAR2(50 CHAR),
                            SEGMENTO_DETALLE_DEC_2 VARCHAR2(250 CHAR),
                            SEGMENTO_ID NUMBER(16,0),
                            PRIMARY KEY (SEGMENTO_DETALLE_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER_SEGMENTO_DETALLE');
    

  

    ------------------------------ D_PER_TIPO_POLITICA --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_TIPO_POLITICA'',
						  ''TIPO_POLITICA_PERSONA_ID NUMBER(16,0) NOT NULL,
                            TIPO_POLITICA_PERSONA_DESC VARCHAR2(50 CHAR),
                            TIPO_POLITICA_PERSONA_DESC_2 VARCHAR2(250 CHAR),
                            POLITICA_PERSONA_ID NUMBER(16,0),
                            PRIMARY KEY (TIPO_POLITICA_PERSONA_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER_TIPO_POLITICA');

	  ------------------------------ D_PER_TIPO_POLITICA_ANT --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_TIPO_POLITICA_ANT'',
						  ''TIPO_POLITICA_PER_ANT_ID NUMBER(16,0) NOT NULL,
                            TIPO_POLITICA_PER_ANT_DESC VARCHAR2(50 CHAR),
                            TIPO_POLITICA_PER_ANT_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_POLITICA_PER_ANT_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER_TIPO_POLITICA_ANT');


    ------------------------------ D_PER_ZONA --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_ZONA'',
						  ''ZONA_PERSONA_ID NUMBER(16,0) NOT NULL,
                            ZONA_PERSONA_DESC VARCHAR2(50 CHAR),
                            ZONA_PERSONA_DESC_2 VARCHAR2(250 CHAR),
                            OFICINA_PERSONA_ID NUMBER(16,0),
                            PRIMARY KEY (ZONA_PERSONA_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER_ZONA');
    
    ------------------------------ D_PER_TRAMO_ALERTA --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_TRAMO_ALERTA'',
			''TRAMO_ALERTA_ID NUMBER(16,0) NOT NULL ENABLE,
              TRAMO_ALERTA_DESC VARCHAR2(50 CHAR),
              PRIMARY KEY (TRAMO_ALERTA_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER_TRAMO_ALERTA');
    
    
    
       ------------------------------ D_PER_TIPO_ALERTA --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_TIPO_ALERTA'',
		''TIPO_ALERTA_ID NUMBER(16,0) NOT NULL ENABLE,
          TIPO_ALERTA_DESC VARCHAR2(50 CHAR),
          PRIMARY KEY (TIPO_ALERTA_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER_TIPO_ALERTA');
    
     
     
       ------------------------------ D_PER_CALIFICACION_ALERTA --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_CALIFICACION_ALERTA'',
		''CALIFICACION_ALERTA_ID NUMBER(16,0) NOT NULL ENABLE,
          CALIFICACION_ALERTA_DESC VARCHAR2(50 CHAR),
          PRIMARY KEY (CALIFICACION_ALERTA_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER_CALIFICACION_ALERTA');
         
    
        ------------------------------ D_PER_GESTION_ALERTA --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_GESTION_ALERTA'',
		''GESTION_ALERTA_ID NUMBER(16,0) NOT NULL ENABLE,
          GESTION_ALERTA_DESC VARCHAR2(50 CHAR),
          PRIMARY KEY (GESTION_ALERTA_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER_GESTION_ALERTA');
        
	
	
------------------------------ D_PER_AMBITO_EXPEDIENTE --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_AMBITO_EXPEDIENTE'',
						  ''AMBITO_EXPEDIENTE_PER_ID NUMBER(16,0) NOT NULL,
                            AMBITO_EXPEDIENTE_PER_DESC VARCHAR2(250 CHAR),
                            AMBITO_EXPEDIENTE_PER_DESC_2 VARCHAR2(500 CHAR),
                            PRIMARY KEY (AMBITO_EXPEDIENTE_PER_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER_AMBITO_EXPEDIENTE');
    

    ------------------------------ D_PER_ARQUETIPO --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_ARQUETIPO'',
						  ''ARQUETIPO_PERSONA_ID NUMBER(16,0) NOT NULL,
                            ARQUETIPO_PERSONA_DESC VARCHAR2(100 CHAR),
                            ITINERARIO_PERSONA_ID NUMBER(16,0),
                            PRIMARY KEY (ARQUETIPO_PERSONA_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER_ARQUETIPO');
    

    ------------------------------ D_PER_ESTADO_FINANCIERO --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_ESTADO_FINANCIERO'',
						  ''ESTADO_FINANCIERO_PER_ID NUMBER(16,0) NOT NULL,
                            ESTADO_FINANCIERO_PER_DESC VARCHAR2(50 CHAR),
                            ESTADO_FINANCIERO_PER_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (ESTADO_FINANCIERO_PER_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER_ESTADO_FINANCIERO');
    

    ------------------------------ D_PER_GRUPO_GESTOR --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_GRUPO_GESTOR'',
						  ''GRUPO_GESTOR_ID NUMBER(16,0) NOT NULL,
                            GRUPO_GESTOR_DESC VARCHAR2(50 CHAR),
                            GRUPO_GESTOR_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (GRUPO_GESTOR_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER_GRUPO_GESTOR');
    

    ------------------------------ D_PER_ITINERARIO --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_ITINERARIO'',
						  ''ITINERARIO_PERSONA_ID NUMBER(16,0) NOT NULL,
                            ITINERARIO_PERSONA_DESC VARCHAR2(100 CHAR),
                            TIPO_ITINERARIO_PERSONA_ID NUMBER(16,0),
                            AMBITO_EXPEDIENTE_PER_ID NUMBER(16,0),
                            PRIMARY KEY (ITINERARIO_PERSONA_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER_ITINERARIO');
    

    ------------------------------ D_PER_NACIONALIDAD --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_NACIONALIDAD'',
						  ''NACIONALIDAD_ID NUMBER(16,0) NOT NULL,
                            NACIONALIDAD_DESC VARCHAR2(50 CHAR),
                            NACIONALIDAD_DEC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (NACIONALIDAD_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER_NACIONALIDAD');
    

    ------------------------------ D_PER_NIVEL --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_NIVEL'',
						  ''NIVEL_PERSONA_ID NUMBER(16,0) NOT NULL,
                            NIVEL_PERSONA_DESC VARCHAR2(50 CHAR),
                            NIVEL_PERSONA_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (NIVEL_PERSONA_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER_NIVEL');
    
	
 ------------------------------ D_PER_PAIS_NACIMIENTO --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_PAIS_NACIMIENTO'',
						  ''PAIS_NACIMIENTO_ID NUMBER(16,0) NOT NULL,
                            PAIS_NACIMIENTO_DESC VARCHAR2(50 CHAR),
                            PAIS_NACIMIENTO_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (PAIS_NACIMIENTO_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER_PAIS_NACIMIENTO');
    

    ------------------------------ D_PER_PERFIL --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_PERFIL'',
						  ''PERFIL_ID NUMBER(16,0) NOT NULL,
                            PERFIL_DESC VARCHAR2(50 CHAR),
                            PERFIL_DEC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (PERFIL_ID)'',
                      :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER_PERFIL');
    
	
    ------------------------------ D_PER_PROVINCIA --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_PROVINCIA'',
						  ''PROVINCIA_PERSONA_ID NUMBER(16,0) NOT NULL,
                            PROVINCIA_PERSONA_DESC VARCHAR2(50 CHAR),
                            PROVINCIA_PERSONA_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (PROVINCIA_PERSONA_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER_PROVINCIA');
    

    ------------------------------ D_PER_RATING_AUXILIAR --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_RATING_AUXILIAR'',
						  ''RATING_AUXILIAR_ID NUMBER(16,0) NOT NULL,
                            RATING_AUXILIAR_DESC VARCHAR2(50 CHAR),
                            RATING_AUXILIAR_DEC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (RATING_AUXILIAR_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER_RATING_AUXILIAR');
    
	
	
    ------------------------------ D_PER_SEXO --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_SEXO'',
						  ''SEXO_ID NUMBER(16,0) NOT NULL,
                            SEXO_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (SEXO_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER_SEXO');
    

    ------------------------------ D_PER_TENDENCIA --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_TENDENCIA'',
						  ''TENDENCIA_PERSONA_ID NUMBER(16,0) NOT NULL,
                            TENDENCIA_PERSONA_DESC VARCHAR2(50 CHAR),
                            TENDENCIA_PERSONA_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (TENDENCIA_PERSONA_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER_TENDENCIA');
    

    ------------------------------ D_PER_TIPO_DOCUMENTO --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_TIPO_DOCUMENTO'',
						  ''TIPO_DOCUMENTO_ID NUMBER(16,0) NOT NULL,
                            TIPO_DOCUMENTO_DESC VARCHAR2(50 CHAR),
                            TIPO_DOCUMENTO_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_DOCUMENTO_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER_TIPO_DOCUMENTO');
    

    ------------------------------ D_PER_TIPO_ITINERARIO --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_TIPO_ITINERARIO'',
						  ''TIPO_ITINERARIO_PERSONA_ID NUMBER(16,0) NOT NULL,
                            TIPO_ITINERARIO_PERSONA_DESC VARCHAR2(50 CHAR),
                            TIPO_ITINERARIO_PERSONA_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_ITINERARIO_PERSONA_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER_TIPO_ITINERARIO');
    

    ------------------------------ D_PER_TIPO_PERSONA --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_TIPO_PERSONA'',
						  ''TIPO_PERSONA_ID NUMBER(16,0) NOT NULL,
                            TIPO_PERSONA_DESC VARCHAR2(50 CHAR),
                            TIPO_PERSONA_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_PERSONA_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER_TIPO_PERSONA');
    

    ------------------------------ D_PER_TRAMO_VOLUMEN_RIESGO --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_TRAMO_VOLUMEN_RIESGO'',
						  ''TRAMO_VOLUMEN_RIESGO_ID NUMBER(16,0) NOT NULL,
                            TRAMO_VOLUMEN_RIESGO_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (TRAMO_VOLUMEN_RIESGO_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER_TRAMO_VOLUMEN_RIESGO');
    
    
   ------------------------------ D_PER --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER'',
						  ''PERSONA_ID   NUMBER(16,0) NOT NULL ,
                           DOCUMENTO_ID  VARCHAR2(20),
                           NOMBRE  VARCHAR2(100 CHAR),
                           APELLIDO_1  VARCHAR2(100 CHAR),
                           APELLIDO_2  VARCHAR2(100 CHAR),
                           TELEFONO_1  VARCHAR2(20 CHAR),
                           TELEFONO_2  VARCHAR2(20 CHAR),
                           MOVIL_1  VARCHAR2(20 CHAR),
                           MOVIL_2  VARCHAR2(20 CHAR),
                           EMAIL  VARCHAR2(100 CHAR),
                           ARQUETIPO_PERSONA_ID   NUMBER(16,0),
                           ESTADO_FINANCIERO_PER_ID   NUMBER(16,0),
                           GRUPO_GESTOR_ID   NUMBER(16,0),
                           NACIONALIDAD_ID   NUMBER(16,0),
                           PAIS_NACIMIENTO_ID   NUMBER(16,0),
                           PERFIL_ID   NUMBER(16,0),
                           RATING_AUXILIAR_ID   NUMBER(16,0),
                           SEGMENTO_ID   NUMBER(16,0),
                           SEGMENTO_DETALLE_ID   NUMBER(16,0),
                           SEXO_ID   NUMBER(16,0),
                           TIPO_DOCUMENTO_ID   NUMBER(16,0),
                           TIPO_PERSONA_ID   NUMBER(16,0),
						               GRUPO_ECONOMICO_ID  NUMBER(16,0),
                           CODIGO_RECOVERY  NUMBER(16,0),
                           CONSTRAINT D_PER_PK PRIMARY KEY (PERSONA_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_PER');
    


    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;
    
  end;

END CREAR_DIM_PERSONA;
