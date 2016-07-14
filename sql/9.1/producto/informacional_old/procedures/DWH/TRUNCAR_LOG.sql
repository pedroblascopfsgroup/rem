create or replace PROCEDURE TRUNCAR_LOG (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Diego P�rez, PFS Group
-- Fecha creaci�n: Febrero 2015
-- Responsable �ltima modificaci�n: Mar�a Villanueva, PFS Group
-- Fecha �ltima modificaci�n: 01/12/2015
-- Motivos del cambio: usuario propietario
-- Cliente: Recovery BI Producto 
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
  commit; 
  
END TRUNCAR_LOG;
