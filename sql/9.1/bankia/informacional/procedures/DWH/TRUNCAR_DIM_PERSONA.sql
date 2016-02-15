create or replace PROCEDURE TRUNCAR_DIM_PERSONA (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Agustin Mompo, PFS Group
-- Fecha creacion: Mayo 2014
-- Responsable ultima modificacion: Joaquín Sánchez, PFS Group
-- Fecha ultima modificacion: 07/08/2015
-- Motivos del cambio: Usuario Propietario
-- Cliente: Recovery BI Bankia
--
-- Descripcion: Procedimiento almancenado que trunca las tablas de la dimension Persona
-- ===============================================================================================

V_NOMBRE VARCHAR2(50) := 'TRUNCAR_DIM_PERSONA';
V_SQL VARCHAR2(16000);

BEGIN  
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
  
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
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_OFICINA'', '''', :O_ERROR_STATUS); END;';
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
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_RATING_EXTERNO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_SEGMENTO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_SEGMENTO_DETALLE'', '''', :O_ERROR_STATUS); END;';
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
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_TIPO_POLITICA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER_ZONA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PER'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;
  
END TRUNCAR_DIM_PERSONA;