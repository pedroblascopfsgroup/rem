create or replace PROCEDURE TRUNCAR_DIM_BIEN (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Febrero 2014
-- Responsable ultima modificacion: María Villanueva, PFS Group
-- Fecha ultima modificacion: 14/04/2016
-- Motivos del cambio: D_BIE_VIVIENDA_HABITUAL
-- Cliente: Recovery BI CAJAMAR
--
-- Descripción: Procedimiento almancenado que trunca las tablas de la dimensión Asunto.
-- ===============================================================================================

V_NOMBRE VARCHAR2(50) := 'TRUNCAR_DIM_BIEN';
V_SQL VARCHAR2(16000);
  
BEGIN

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_LOG_PROCESO(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
  

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_BIE_ENTIDAD_ADJUDICATARIA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_BIE_CODIGO_ACTIVO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_BIE_ADJ_CESION_REM'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_BIE_ADJUDICADO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_BIE_POBLACION'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_BIE_SUBTIPO_BIEN'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_BIE_TIPO_BIEN'', '''', :O_ERROR_STATUS); END;';  
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_BIE'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_BIE_FASE_ACTUAL_DETALLE'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_BIE_DESC_LANZAMIENTOS'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_BIE_PRIMER_TITULAR'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_BIE_NUM_OPERACION'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_BIE_ZONA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_BIE_OFICINA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_BIE_ENTIDAD'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_BIE_GARANTIA_NUM_OPE_BIE'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_BIE_GARANTIA_NUM_OPE_BIE_AGR'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_BIE_VIVIENDA_HABITUAL'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  commit;
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;
  
END TRUNCAR_DIM_BIEN;