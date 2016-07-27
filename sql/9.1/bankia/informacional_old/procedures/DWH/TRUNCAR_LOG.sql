create or replace PROCEDURE TRUNCAR_LOG (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Diego P�rez, PFS Group
-- Fecha creaci�n: Febrero 2015
-- Responsable ultima modificacion: Joaqu�n S�nchez, PFS Group
-- Fecha ultima modificacion: 07/08/2015
-- Motivos del cambio: Usuario Propietario
-- Cliente: Recovery BI Bankia 
--
-- Descripci�n: Procedimiento almancenado que trunca las tablas de logs
-- ===============================================================================================

V_SQL VARCHAR2(16000);

BEGIN
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''LOG_GENERAL_PARAMETROS'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''LOG_GENERAL'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''LOG_PROCESO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  
END TRUNCAR_LOG;