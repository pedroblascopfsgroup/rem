create or replace PROCEDURE TRUNCAR_H_EXPEDIENTE (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Agustin Mompo, PFS Group
-- Fecha creacion: Mayo 2014
-- Responsable ultima modificacion: María Villanueva, PFS Group
-- Fecha ultima modificacion: 03/11/2015
-- Motivos del cambio: Usuario propietario
-- Cliente: Recovery BI PRODUCTO
--
-- Descripcion: Procedimiento almancenado que trunca las tablas deL hecho Expediente
-- ===============================================================================================

V_NOMBRE VARCHAR2(50) := 'TRUNCAR_H_EXPEDIENTE';
V_SQL VARCHAR2(16000);
  
BEGIN

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_LOG_PROCESO(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_EXP'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_EXP_SEMANA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_EXP_MES'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_EXP_TRIMESTRE'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_EXP_ANIO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_EXP_CNT'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_EXP_ACCIONES'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_EXP_DET_CICLO_REC'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_EXP_DET_CICLO_REC'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_EXP_ENTSAL_D1'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_EXP_ENTSAL_D2'', '''', :O_ERROR_STATUS); END;';  
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_EXP_DET_CICLO_REC_SEMANA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_EXP_DET_CICLO_REC_MES'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_EXP_DET_CICLO_REC_TRIMESTRE'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_EXP_DET_CICLO_REC_ANIO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;

  

  commit;
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;
  
  
END TRUNCAR_H_EXPEDIENTE;