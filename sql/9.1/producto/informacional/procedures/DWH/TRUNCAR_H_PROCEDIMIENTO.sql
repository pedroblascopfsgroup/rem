create or replace PROCEDURE TRUNCAR_H_PROCEDIMIENTO (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Agustin Mompo, PFS Group
-- Fecha creacion: Mayo 2014
-- Responsable ultima modificacion: María Villanueva, PFS Group
-- Fecha ultima modificacion: 04/11/2015
-- Motivos del cambio: Usuario propietario
-- Cliente: Recovery BI PRODUCTO
--
-- Descripcion: Procedimiento almancenado que trunca las tablas deL hecho Procedimiento
-- ===============================================================================================

V_NOMBRE VARCHAR2(50) := 'TRUNCAR_H_PROCEDIMIENTO';
V_SQL VARCHAR2(16000);
  
BEGIN

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_LOG_PROCESO(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;

 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_PRC'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_H_PRC'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_PRC_SEMANA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_PRC_MES'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_PRC_TRIMESTRE'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_PRC_ANIO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_PRC_DET_COBRO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_PRC_DET_COBRO_MES'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_PRC_DET_COBRO_TRIMESTRE'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_PRC_DET_COBRO_ANIO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_PRC_DET_CONTRATO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_PRC_DET_CONTRATO_MES'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_PRC_DET_CONTRATO_TRIMESTRE'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_PRC_DET_CONTRATO_ANIO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_CODIGO_PRIORIDAD'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_JERARQUIA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_DETALLE'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_TAREA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_AUTO_PRORROGAS'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_CONTRATO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_CONCURSO_CONTRATO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_CARTERA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_FECHA_CONTABLE_LITIGIO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_TITULAR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_DEMANDADO  '', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_COBROS'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_ESTIMACION'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_EXTRAS_RECOVERY_BI'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_DECISION'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_H_PRC_DET_COBRO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_PRC_DET_COBRO_SEMANA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_PRC_DET_ACUERDO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_PRC_DET_ACUERDO_SEMANA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_PRC_DET_ACUERDO_MES'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_PRC_DET_ACUERDO_TRIMESTRE'', '''', :O_ERROR_STATUS); END;'; 
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_PRC_DET_ACUERDO_ANIO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_H_PRC_DET_ACUERDO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   
  
  
   commit;
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;


END TRUNCAR_H_PROCEDIMIENTO;