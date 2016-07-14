create or replace PROCEDURE TRUNCAR_DIM_ASUNTO (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Febrero 2014
-- Responsable última modificación: Pedro Sebastián, PFS Group
-- Fecha última modificación: 01/09/2015
-- Motivos del cambio: D_ASU_GESTION_ASUNTO
-- Cliente: Recovery BI Bankia 
--
-- Descripción: Procedimiento almancenado que trunca las tablas de la dimensión Asunto.
-- ===============================================================================================

  V_NOMBRE VARCHAR2(50) := 'TRUNCAR_DIM_ASUNTO';
  V_SQL VARCHAR2(16000);
  
BEGIN

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_LOG_PROCESO(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
    
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_ASU_ESTADO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_ASU_DESPACHO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_ASU_TIPO_DESPACHO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_ASU_DESPACHO_GESTOR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_ASU_TIPO_DESPACHO_GESTOR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_ASU_GESTOR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_ASU_ENTIDAD_GESTOR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_ASU_ROL_GESTOR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_ASU_NVL_DESPACHO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_ASU_OFI_DESPACHO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_ASU_PROV_DESPACHO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_ASU_ZONA_DESPACHO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_ASU_NVL_DESPACHO_GESTOR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_ASU_OFI_DESPACHO_GESTOR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_ASU_PROV_DESPACHO_GESTOR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_ASU_ZONA_DESPACHO_GESTOR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_ASU_PROPIETARIO_ASUNTO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_ASU'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_DESPACHO_ASUNTO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_ASU_GESTION_ASUNTO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  
  --Log_Proceso 
  execute immediate 'BEGIN INSERTAR_LOG_PROCESO(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;
  
END TRUNCAR_DIM_ASUNTO;