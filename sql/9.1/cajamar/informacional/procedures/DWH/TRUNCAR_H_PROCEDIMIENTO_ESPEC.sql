create or replace PROCEDURE TRUNCAR_H_PROCEDIMIENTO_ESPEC (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Agustin Mompo, PFS Group
-- Fecha creacion: Mayo 2014
-- Responsable ultima modificacion: María Villanueva, PFS Group
-- Fecha ultima modificacion: 04/11/2015
-- Motivos del cambio: Usuario propietario
-- Cliente: Recovery BI CAJAMAR
--
-- Descripcion: Procedimiento almancenado que trunca las tablas deL hecho Procedimiento Especifico
-- ===============================================================================================

V_NOMBRE VARCHAR2(50) := 'TRUNCAR_H_PROCEDIMIENTO_ESPEC';
V_SQL VARCHAR2(16000);
  
BEGIN

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_LOG_PROCESO(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;

   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_ESPECIFICO_JERARQUIA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_ESPECIFICO_DETALLE'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_ESPECIFICO_DECISION'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_ESPECIFICO_RECURSO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_CONCU'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_CONCU_SEMANA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_CONCU_MES'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_CONCU_TRIMESTRE'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_CONCU_ANIO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CONCU_JERARQUIA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CONCU_DETALLE'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CONCU_TAREA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CONCU_CONVENIO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CONCU_AUX'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CONCU_CONTRATO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_DECL'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_DECL_SEMANA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_DECL_MES'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_DECL_TRIMESTRE'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_DECL_ANIO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_DECL_JERARQUIA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_DECL_DETALLE'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_DECL_TAREA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_EJEC_ORD'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_EJEC_ORD_SEMANA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_EJEC_ORD_MES'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_EJEC_ORD_TRIMESTRE'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_EJEC_ORD_ANIO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_EJEC_ORD_JERARQUIA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_EJEC_ORD_DETALLE'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_EJEC_ORD_TAREA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_HIPO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_HIPO_SEMANA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_HIPO_MES'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_HIPO_TRIMESTRE'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_HIPO_ANIO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_HIPO_JERARQUIA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_HIPO_DETALLE'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_HIPO_TAREA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_MON'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_MON_SEMANA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_MON_MES'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_MON_TRIMESTRE'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_MON_ANIO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_MON_JERARQUIA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_MON_DETALLE'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_MON_TAREA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_EJEC_NOT'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_EJEC_NOT_SEMANA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_EJEC_NOT_MES'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_EJEC_NOT_TRIMESTRE'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_EJEC_NOT_ANIO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_EJEC_NOT_JERARQUIA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_EJEC_NOT_DETALLE'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_EJEC_NOT_TAREA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_PRE_CONCU'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_PRE_CONCU_SEMANA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_PRE_CONCU_MES'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_PRE_CONCU_TRIMESTRE'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_PRE_CONCU_ANIO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRE_CONCU_JERARQUIA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRE_CONCU_DETALLE'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRE_CONCU_TAREA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
   

  commit;
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;



END TRUNCAR_H_PROCEDIMIENTO_ESPEC;