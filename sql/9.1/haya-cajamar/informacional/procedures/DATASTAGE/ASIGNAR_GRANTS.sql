create or replace PROCEDURE ASIGNAR_GRANTS(O_ERROR_STATUS OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Diego Pérez, PFS Group
-- Fecha creación: Abril 2015
-- Responsable ultima modificacion: 
-- Fecha ultima modificacion: 
-- Motivos del cambio: 
-- Cliente: Recovery BI Haya
--
-- Descripción: Asigna los permisos de las tablas
-- ===============================================================================================

BEGIN

  for rs in (select table_name 
                 from ALL_TABLES 
           where UPPER(OWNER) = 'recovery_haya02_DATASTAGE'
                 order by table_name) loop            
      EXECUTE IMMEDIATE 'GRANT INDEX, SELECT, INSERT, UPDATE ON recovery_haya02_DATASTAGE.' || rs.table_name || ' TO recovery_haya02_DWH';  
  end loop;

EXCEPTION
   WHEN OTHERS THEN
    O_ERROR_STATUS := 'Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM; 


END ASIGNAR_GRANTS;