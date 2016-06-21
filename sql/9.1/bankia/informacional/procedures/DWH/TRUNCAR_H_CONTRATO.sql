create or replace PROCEDURE TRUNCAR_H_CONTRATO (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Agustin Mompo, PFS Group
-- Fecha creacion: Mayo 2014
-- Responsable ultima modificacion: Joaquín Sánchez, PFS Group
-- Fecha ultima modificacion: 07/08/2015
-- Motivos del cambio: Usuario Propietario
-- Cliente: Recovery BI Bankia
--
-- Descripcion: Procedimiento almancenado que trunca las tablas deL hecho Contrato
-- ===============================================================================================

V_NOMBRE VARCHAR2(50) := 'TRUNCAR_H_CONTRATO';
V_SQL VARCHAR2(16000);

BEGIN

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_CNT'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_CNT_SEMANA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_CNT_MES'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_CNT_TRIMESTRE'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_CNT_ANIO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_CNT_DET_COBRO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_CNT_DET_COBRO_SEMANA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_CNT_DET_COBRO_MES'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_CNT_DET_COBRO_TRIMESTRE'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_CNT_DET_COBRO_ANIO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_CNT_DET_CICLO_REC'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_CNT_DET_CICLO_REC_SEMANA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_CNT_DET_CICLO_REC_MES'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_CNT_DET_CICLO_REC_TRIMESTRE'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_CNT_DET_CICLO_REC_ANIO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_CNT_INICIO_CAMPANA_RECOBRO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_CNT_DET_ACUERDO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CNT_DET_ACUERDO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_CNT_DET_ACUERDO_SEMANA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_CNT_DET_ACUERDO_MES'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_CNT_DET_ACUERDO_TRIMESTRE'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_CNT_DET_ACUERDO_ANIO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_CNT_DET_INCI'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CNT_DET_INCI'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_CNT_DET_INCI_SEMANA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_CNT_DET_INCI_MES'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_CNT_DET_INCI_TRIMESTRE'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_CNT_DET_INCI_ANIO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_H'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_ANT'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_MANTIENE'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_ALTA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_BAJA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CNT_PROCEDIMIENTO_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CNT_PROCEDIMIENTO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CNT_EXPEDIENTE'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CNT_SITUACION_FINANCIERA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CNT_CREDITO_INSINUADO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CNT_RECOBRO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CNT_DPS'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CNT_ACTIVIDAD'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CNT_ESPECIALIZADA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CNT_PREVISIONES'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CNT_PREVISIONES_DIA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_LOAN_INFORMATION'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_ESTUDIO_CARTERA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_EN_MASIVA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Terminar ' || V_NOMBRE, 2;


END TRUNCAR_H_CONTRATO;