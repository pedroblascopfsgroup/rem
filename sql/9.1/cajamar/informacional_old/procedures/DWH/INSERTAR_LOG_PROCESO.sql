create or replace PROCEDURE  INSERTAR_LOG_PROCESO (NOMBRE_PROCESO IN VARCHAR2, DESCRIPCION IN VARCHAR2, TAB IN INTEGER) AS
-- ===============================================================================================
-- Autor: Diego Pérez, PFS Group
-- Fecha creacion: Enero 2015
-- Responsable ultima modificacion:
-- Fecha ultima modificacion:
-- Motivos del cambio:
-- Cliente: Recovery BI CAJAMAR
--
-- Descripcion: Procedimiento almacenado para lanzar insertar LOGS en la tabla LOG_PROCESO
-- ===============================================================================================
  V_SID NUMBER;
  
BEGIN
  select sys_context('USERENV','SID') INTO V_SID from dual;
  
  insert into LOG_PROCESO (FILA_ID, FECHA, NUM_SID, NOMBRE_PROCESO, DESCRIPCION, TAB)
  values (Incr_LOG_PROCESO.nextval, systimestamp, V_SID, substr(NOMBRE_PROCESO, 1, 50), substr(DESCRIPCION, 1, 250), TAB);
  commit;   
END;