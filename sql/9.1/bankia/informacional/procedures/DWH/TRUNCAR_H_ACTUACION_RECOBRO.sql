create or replace PROCEDURE TRUNCAR_H_ACTUACION_RECOBRO (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Agustin Mompo, PFS Group
-- Fecha creacion: Mayo 2014
-- Responsable ultima modificacion: Joaquín Sánchez, PFS Group
-- Fecha ultima modificacion: 07/08/2015
-- Motivos del cambio: Usuario Propietario
-- Cliente: Recovery BI Bankia
--
-- Descripcion: Procedimiento almancenado que trunca las tablas deL hecho Actuacion Recobro
-- ===============================================================================================

V_NOMBRE VARCHAR2(50) := 'TRUNCAR_H_ACTUACION_RECOBRO';
V_SQL VARCHAR2(16000);

BEGIN

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_ACT_REC'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;


END TRUNCAR_H_ACTUACION_RECOBRO;