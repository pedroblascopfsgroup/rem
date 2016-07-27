create or replace PROCEDURE TRUNCAR_DIM_FECHA (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Agustin Mompo, PFS Group
-- Fecha creacion: Mayo 2014
-- Responsable ultima modificacion: María Villanueva, PFS Group
-- Fecha ultima modificacion: 23/11/2015
-- Motivos del cambio: Uusario propietario
-- Cliente: Recovery BI Producto
--
-- Descripcion: Procedimiento almancenado que trunca las tablas de la dimension Fecha
-- ===============================================================================================

V_NOMBRE VARCHAR2(50) := 'TRUNCAR_DIM_FECHA';
V_SQL VARCHAR2(16000);

BEGIN

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_F_ANIO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_F_DIA_SEMANA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_F_MES'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_F_MES_ANIO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_F_TRIMESTRE'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_F_DIA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_F_SEMANA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_F_SEMANA_ANIO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_F_MTD'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_F_QTD'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_F_YTD'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_F_ULT_6_MESES'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_F_ULT_12_MESES'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;
  
END TRUNCAR_DIM_FECHA;
