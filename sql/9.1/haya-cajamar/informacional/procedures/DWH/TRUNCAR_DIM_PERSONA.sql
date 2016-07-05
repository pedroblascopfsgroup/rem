create or replace PROCEDURE TRUNCAR_DIM_PERSONA (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: María Villanueva, PFS Group
-- Fecha creacion:Agosto 2015
-- Responsable ultima modificacion: María Villanueva Mares, PFS Group
-- Fecha ultima modificacion: 23/11/2015
-- Motivos del cambio:usuario propietario
-- Cliente: Recovery BI Haya
--
-- Descripcion: Procedimiento almancenado que trunca las tablas de la dimension Persona
-- ===============================================================================================

V_NOMBRE VARCHAR2(50) := 'TRUNCAR_DIM_PERSONA';
  V_SQL VARCHAR2(16000);

BEGIN

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
  

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

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_OFICINA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_POLITICA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_POLITICA_ANTERIOR'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_RATING_EXTERNO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_RATING_EXTERNO_ANTERIOR'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_TRAMO_PUNTUACION'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_GRUPO_ECONOMICO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_SEGMENTO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_SEGMENTO_DETALLE'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_TIPO_POLITICA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_TIPO_POLITICA_ANT'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_ZONA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_TRAMO_ALERTA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_TIPO_ALERTA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_CALIFICACION_ALERTA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_GESTION_ALERTA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_AMBITO_EXPEDIENTE'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_ARQUETIPO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_ESTADO_FINANCIERO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_GRUPO_GESTOR'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_ITINERARIO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_NACIONALIDAD'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_NIVEL'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_PAIS_NACIMIENTO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_PERFIL'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_POLITICA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_PROVINCIA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_RATING_AUXILIAR'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_SEXO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_TENDENCIA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_TIPO_DOCUMENTO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_TIPO_ITINERARIO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_TIPO_PERSONA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_TRAMO_VOLUMEN_RIESGO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER'', '''', :O_ERROR_STATUS); END;';
   execute immediate V_SQL USING OUT error;


  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;
  
END TRUNCAR_DIM_PERSONA;
