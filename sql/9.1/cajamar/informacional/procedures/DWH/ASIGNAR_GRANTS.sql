create or replace PROCEDURE ASIGNAR_GRANTS(O_ERROR_STATUS OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Diego Pérez, PFS Group
-- Fecha creación: Marzo 2015
-- Responsable ultima modificacion: María Villanueva, PFS Group
-- Fecha ultima modificacion: 02/12/2015
-- Motivos del cambio: Se corrige referencia a datastage
-- Cliente: Recovery BI Cajamar
--
-- Descripción: Asigna los permisos de las tablas
-- ===============================================================================================
V_DATASTAGE VARCHAR2(100);
V_ESQUEMA VARCHAR2(100);


BEGIN
select valor into V_DATASTAGE from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DATASTAGE';
select valor into V_ESQUEMA from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DWH'; 

  for rs in (select table_name 
                 from ALL_TABLES 
           where UPPER(OWNER) = (V_DATASTAGE)
                 order by table_name) loop            
      EXECUTE IMMEDIATE 'GRANT INDEX, SELECT, INSERT, UPDATE ON '||V_DATASTAGE||'.' || rs.table_name || ' TO '||V_ESQUEMA||'';  
  end loop;

EXCEPTION
   WHEN OTHERS THEN
    O_ERROR_STATUS := 'Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM; 


END ASIGNAR_GRANTS;
