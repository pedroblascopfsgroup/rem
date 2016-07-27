create or replace PROCEDURE COMPILAR_SP (O_ERROR_STATUS OUT VARCHAR2) AS 
-- ===============================================================================================
-- Autor: Diego Pérez, PFS Group
-- Fecha creación: Marzo 2015
-- Responsable ultima modificacion: María Villanueva, PFS Group 
-- Fecha ultima modificacion: 23/11/2015
-- Motivos del cambio: usuario propietario
-- Cliente: Recovery BI PRODUCTO
--
-- Descripción: Compila los procedures
-- ===============================================================================================

begin
Declare
  V_ESQUEMA varchar2(100);
  V_SQL varchar2(16000);
  V_NOMBRE VARCHAR2(100);
BEGIN

  select valor into V_ESQUEMA from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DATASTAGE';
  
  begin
  for rs in (select OBJECT_NAME, OBJECT_TYPE from ALL_PROCEDURES where UPPER(owner) = V_ESQUEMA AND OBJECT_NAME <> 'COMPILAR_SP' order by OBJECT_NAME) loop
    if(rs.OBJECT_TYPE = 'PROCEDURE') then

        
        V_NOMBRE := trim(substr(rs.OBJECT_NAME, 1, 100));
        
        V_SQL :=  'BEGIN OPERACION_DDL.DDL_PROCEDURE(''ALTER'', ''' || V_NOMBRE || ''', ''COMPILE'', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
        
     end if;



    end loop;
  end;
  
EXCEPTION
   WHEN OTHERS THEN
    O_ERROR_STATUS := 'Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM; 

end;
END COMPILAR_SP;
