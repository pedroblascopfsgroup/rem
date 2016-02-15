create or replace PROCEDURE TRUNCAR_DIM_TAREA (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Agustin Mompo, PFS Group
-- Fecha creacion: Mayo 2014
-- Responsable ultima modificacion: María Villanueva, PFS Group
-- Fecha ultima modificacion: 03/11/2015
-- Motivos del cambio: Usuario propietario
-- Cliente: Recovery BI Haya
--
-- Descripcion: Procedimiento almancenado que trunca las tablas de la dimension Tarea
-- ===============================================================================================

V_NOMBRE VARCHAR2(50) := 'TRUNCAR_DIM_TAREA';
V_SQL VARCHAR2(16000);

BEGIN

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;


  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_TAR_TIPO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_TAR_TIPO_DETALLE'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_TAR_RESOLUCION_PRORROGA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_TAR_MOTIVO_PRORROGA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_TAR_PENDIENTE_RESPUESTA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_TAR_ESTADO_PRORROGA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_TAR_ALERTA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_TAR_AMBITO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_TAR_REALIZACION'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_TAR_CUMPLIMIENTO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_TAR_DESP_GESTOR'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_TAR_TIPO_DESP_GESTOR'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_TAR_GESTOR'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_TAR_TIPO_GESTOR'', '''', :O_ERROR_STATUS); END;';  
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_TAR_ENTIDAD_GESTOR'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_TAR_NIVEL_DESP_GESTOR'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_TAR_OFICINA_DESP_GESTOR'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_TAR_PROV_DESP_GESTOR'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_TAR_ZONA_DESP_GESTOR'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_TAR_DESP_SUPERVISOR'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_TAR_TIPO_DESP_SUPERVISOR'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_TAR_SUPERVISOR'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_TAR_ENTIDAD_SUPERVISOR'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_TAR_NIVEL_DESP_SUPERVISOR'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_TAR_OFICINA_DESP_SUPERVISOR'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_TAR_PROV_DESP_SUPERVISOR'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_TAR_ZONA_DESP_SUPERVISOR'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_TAR_DESCRIPCION'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_TAR_RESPONSABLE'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_TAR_ESTADO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_TAR'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_TAR_GESTOR'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_TAR_SUPERVISOR'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error; 
  
  commit;


  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;


END TRUNCAR_DIM_TAREA;
