create or replace PROCEDURE  INSERTAR_LOG_CARGAR_TABLA (NOMBRE_TABLA IN VARCHAR2, NUM_BLOQUE IN NUMBER, NUM_ORDEN IN NUMBER, DESCRIPCION IN VARCHAR2, TAB IN INTEGER) AS
-- ===============================================================================================
-- Autor: Diego Pérez, PFS Group
-- Fecha creacion: Abril 2015
-- Responsable ultima modificacion:
-- Fecha ultima modificacion:
-- Motivos del cambio:
-- Cliente: Recovery BI PRODUCTO
--
-- Descripcion: Procedimiento almacenado para lanzar insertar LOGS en la tabla LOG_CARGAR_TABLA
-- ===============================================================================================
  V_SID NUMBER;
  
BEGIN
  select sys_context('USERENV','SID') INTO V_SID from dual;
  
  insert into LOG_CARGAR_TABLA (FILA_ID, FECHA, NUM_SID, NUM_BLOQUE, NUM_ORDEN, NOMBRE_TABLA, DESCRIPCION, TAB)
  values (INCR_LOG_CARGAR_TABLA.nextval, systimestamp, V_SID, NUM_BLOQUE, NUM_ORDEN, substr(NOMBRE_TABLA, 1, 50), substr(DESCRIPCION, 1, 250), TAB);
  commit;   
END;