create or replace PROCEDURE CREAR_DIM_PERSONA (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Agustin Mompo, PFS Group
-- Fecha creacion: Mayo 2014
-- Responsable ultima modificacion: Joaquín Sánchez, PFS Group
-- Fecha ultima modificacion: 11/08/2015
-- Motivos del cambio: Usuario Propietario
-- Cliente: Recovery BI Bankia
--
-- Descripcion: Procedimiento almancenado que crea las tablas de la dimension Expediente
-- ===============================================================================================

-- -------------------------------------------- INDICE -------------------------------------------
-- DIMENSION PERSONA
    -- D_PER_AMBITO_EXPEDIENTE
    -- D_PER_ARQUETIPO
    -- D_PER_ESTADO_FINANCIERO
    -- D_PER_GRUPO_GESTOR
    -- D_PER_ITINERARIO
    -- D_PER_NACIONALIDAD
    -- D_PER_NIVEL
    -- D_PER_OFICINA
    -- D_PER_PAIS_NACIMIENTO
    -- D_PER_PERFIL
    -- D_PER_POLITICA
    -- D_PER_PROVINCIA
    -- D_PER_RATING_AUXILIAR
    -- D_PER_RATING_EXTERNO
    -- D_PER_SEGMENTO
    -- D_PER_SEGMENTO_DETALLE
    -- D_PER_SEXO
    -- D_PER_TENDENCIA
    -- D_PER_TIPO_DOCUMENTO
    -- D_PER_TIPO_ITINERARIO
    -- D_PER_TIPO_PERSONA
    -- D_PER_TIPO_POLITICA
    -- D_PER_ZONA
    -- D_PER

BEGIN

declare
  nCount NUMBER;
  V_NOMBRE VARCHAR2(50) := 'CREAR_DIM_PERSONA';
  V_SQL varchar2(16000); 
  
  begin

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
    
    ------------------------------ D_PER_AMBITO_EXPEDIENTE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_AMBITO_EXPEDIENTE'', 
                          ''AMBITO_EXPEDIENTE_PER_ID NUMBER(16,0) NOT NULL,
                            AMBITO_EXPEDIENTE_PER_DESC VARCHAR2(250 CHAR),
                            AMBITO_EXPEDIENTE_PER_DESC_2 VARCHAR2(500 CHAR),
                            PRIMARY KEY (AMBITO_EXPEDIENTE_PER_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_PER_ARQUETIPO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_ARQUETIPO'', 
                          ''ARQUETIPO_PERSONA_ID NUMBER(16,0) NOT NULL,
                            ARQUETIPO_PERSONA_DESC VARCHAR2(100 CHAR),
                            ITINERARIO_PERSONA_ID NUMBER(16,0),
                            PRIMARY KEY (ARQUETIPO_PERSONA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_PER_ESTADO_FINANCIERO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_ESTADO_FINANCIERO'', 
                          ''ESTADO_FINANCIERO_PER_ID NUMBER(16,0) NOT NULL,
                            ESTADO_FINANCIERO_PER_DESC VARCHAR2(50 CHAR),
                            ESTADO_FINANCIERO_PER_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (ESTADO_FINANCIERO_PER_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_PER_GRUPO_GESTOR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_GRUPO_GESTOR'', 
                          ''GRUPO_GESTOR_ID NUMBER(16,0) NOT NULL,
                            GRUPO_GESTOR_DESC VARCHAR2(50 CHAR),
                            GRUPO_GESTOR_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (GRUPO_GESTOR_ID) '', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_PER_ITINERARIO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_ITINERARIO'', 
                              ''ITINERARIO_PERSONA_ID NUMBER(16,0) NOT NULL,
                                ITINERARIO_PERSONA_DESC VARCHAR2(100 CHAR),
                                TIPO_ITINERARIO_PERSONA_ID NUMBER(16,0),
                                AMBITO_EXPEDIENTE_PER_ID NUMBER(16,0),
                                PRIMARY KEY (ITINERARIO_PERSONA_ID)'', 
                              :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_PER_NACIONALIDAD --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_NACIONALIDAD'', 
                          ''NACIONALIDAD_ID NUMBER(16,0) NOT NULL,
                            NACIONALIDAD_DESC VARCHAR2(50 CHAR),
                            NACIONALIDAD_DEC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (NACIONALIDAD_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_PER_NIVEL --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_NIVEL'', 
                          ''NIVEL_PERSONA_ID NUMBER(16,0) NOT NULL,
                            NIVEL_PERSONA_DESC VARCHAR2(50 CHAR),
                            NIVEL_PERSONA_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (NIVEL_PERSONA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_PER_OFICINA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_OFICINA'', 
                          ''OFICINA_PERSONA_ID NUMBER(16,0) NOT NULL,
                            OFICINA_PERSONA_DESC VARCHAR2(50 CHAR),
                            OFICINA_PERSONA_DESC_2 VARCHAR2(250 CHAR),
                            PROVINCIA_PERSONA_ID NUMBER(16,0),
                            PRIMARY KEY (OFICINA_PERSONA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_PER_PAIS_NACIMIENTO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_PAIS_NACIMIENTO'', 
                          ''PAIS_NACIMIENTO_ID NUMBER(16,0) NOT NULL,
                            PAIS_NACIMIENTO_DESC VARCHAR2(50 CHAR),
                            PAIS_NACIMIENTO_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (PAIS_NACIMIENTO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_PER_PERFIL --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_PERFIL'', 
                          ''PERFIL_ID NUMBER(16,0) NOT NULL,
                            PERFIL_DESC VARCHAR2(50 CHAR),
                            PERFIL_DEC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (PERFIL_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_PER_POLITICA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_POLITICA'', 
                          ''POLITICA_PERSONA_ID NUMBER(16,0) NOT NULL,
                            POLITICA_PERSONA_DESC VARCHAR2(50 CHAR),
                            POLITICA_PERSONA_DESC_2 VARCHAR2(250 CHAR),
                            PROVINCIA_PERSONA_ID NUMBER(16,0),
                            PRIMARY KEY (POLITICA_PERSONA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_PER_PROVINCIA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_PROVINCIA'', 
                          ''PROVINCIA_PERSONA_ID NUMBER(16,0) NOT NULL,
                            PROVINCIA_PERSONA_DESC VARCHAR2(50 CHAR),
                            PROVINCIA_PERSONA_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (PROVINCIA_PERSONA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_PER_RATING_AUXILIAR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_RATING_AUXILIAR'', 
                          ''RATING_AUXILIAR_ID NUMBER(16,0) NOT NULL,
                            RATING_AUXILIAR_DESC VARCHAR2(50 CHAR),
                            RATING_AUXILIAR_DEC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (RATING_AUXILIAR_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_PER_RATING_EXTERNO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_RATING_EXTERNO'', 
                          ''RATING_EXTERNO_ID NUMBER(16,0) NOT NULL,
                            RATING_EXTERNO_DESC VARCHAR2(50 CHAR),
                            RATING_EXTERNO_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (RATING_EXTERNO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_PER_SEGMENTO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_SEGMENTO'', 
                          ''SEGMENTO_ID NUMBER(16,0) NOT NULL,
                            SEGMENTO_DESC VARCHAR2(50 CHAR),
                            SEGMENTO_DEC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (SEGMENTO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_PER_SEGMENTO_DETALLE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_SEGMENTO_DETALLE'', 
                          ''SEGMENTO_DETALLE_ID NUMBER(16,0) NOT NULL,
                            SEGMENTO_DETALLE_DESC VARCHAR2(50 CHAR),
                            SEGMENTO_DETALLE_DEC_2 VARCHAR2(250 CHAR),
                            SEGMENTO_ID NUMBER(16,0),
                            PRIMARY KEY (SEGMENTO_DETALLE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_PER_SEXO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_SEXO'', 
                          ''SEXO_ID NUMBER(16,0) NOT NULL,
                            SEXO_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (SEXO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_PER_TENDENCIA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_TENDENCIA'', 
                          ''TENDENCIA_PERSONA_ID NUMBER(16,0) NOT NULL,
                            TENDENCIA_PERSONA_DESC VARCHAR2(50 CHAR),
                            TENDENCIA_PERSONA_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (TENDENCIA_PERSONA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_PER_TIPO_DOCUMENTO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_TIPO_DOCUMENTO'', 
                          ''TIPO_DOCUMENTO_ID NUMBER(16,0) NOT NULL,
                            TIPO_DOCUMENTO_DESC VARCHAR2(50 CHAR),
                            TIPO_DOCUMENTO_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_DOCUMENTO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_PER_TIPO_ITINERARIO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_TIPO_ITINERARIO'', 
                          ''TIPO_ITINERARIO_PERSONA_ID NUMBER(16,0) NOT NULL,
                            TIPO_ITINERARIO_PERSONA_DESC VARCHAR2(50 CHAR),
                            TIPO_ITINERARIO_PERSONA_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_ITINERARIO_PERSONA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_PER_TIPO_PERSONA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_TIPO_PERSONA'', 
                          ''TIPO_PERSONA_ID NUMBER(16,0) NOT NULL,
                            TIPO_PERSONA_DESC VARCHAR2(50 CHAR),
                            TIPO_PERSONA_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_PERSONA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_PER_TIPO_POLITICA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_TIPO_POLITICA'', 
                          ''TIPO_POLITICA_PERSONA_ID NUMBER(16,0) NOT NULL,
                            TIPO_POLITICA_PERSONA_DESC VARCHAR2(50 CHAR),
                            TIPO_POLITICA_PERSONA_DESC_2 VARCHAR2(250 CHAR),
                            POLITICA_PERSONA_ID NUMBER(16,0),
                            TENDENCIA_PERSONA_ID NUMBER(16,0),
                            PRIMARY KEY (TIPO_POLITICA_PERSONA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_PER_ZONA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_PER_ZONA'', 
                          ''ZONA_PERSONA_ID NUMBER(16,0) NOT NULL,
                            ZONA_PERSONA_DESC VARCHAR2(50 CHAR),
                            ZONA_PERSONA_DESC_2 VARCHAR2(250 CHAR),
                            NIVEL_PERSONA_ID NUMBER(16,0),
                            OFICINA_PERSONA_ID NUMBER(16,0),
                            PRIMARY KEY (ZONA_PERSONA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

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
                           OFICINA_PERSONA_ID   NUMBER(16,0),
                           PAIS_NACIMIENTO_ID   NUMBER(16,0),
                           PERFIL_ID   NUMBER(16,0),
                           POLITICA_PERSONA_ID   NUMBER(16,0),
                           RATING_AUXILIAR_ID   NUMBER(16,0),
                           RATING_EXTERNO_ID   NUMBER(16,0),
                           SEGMENTO_ID   NUMBER(16,0),
                           SEGMENTO_DETALLE_ID   NUMBER(16,0),
                           SEXO_ID   NUMBER(16,0),
                           TIPO_DOCUMENTO_ID   NUMBER(16,0),
                           TIPO_PERSONA_ID   NUMBER(16,0),
                           TIPO_POLITICA_PERSONA_ID   NUMBER(16,0),
                           ZONA_PERSONA_ID   NUMBER(16,0),
                          CONSTRAINT D_PER_PK PRIMARY KEY (PERSONA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;



    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;
    
  end;

END CREAR_DIM_PERSONA;