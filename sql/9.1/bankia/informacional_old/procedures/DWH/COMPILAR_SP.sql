create or replace PROCEDURE COMPILAR_SP (O_ERROR_STATUS OUT VARCHAR2) AS 
-- ===============================================================================================
-- Autor: Diego P�rez, PFS Group
-- Fecha creaci�n: Marzo 2015
-- Responsable ultima modificacion: Diego P�rez, PFS Group 
-- Fecha ultima modificacion: 13/05/2015
-- Motivos del cambio: A�adir O_ERROR_STATUS
-- Cliente: Recovery BI Bankia
--
-- Descripci�n: Compila los procedures
-- ===============================================================================================
begin
Declare
  V_DWH varchar2(100);
  V_SQL varchar2(16000);
  V_NOMBRE VARCHAR2(100);
BEGIN

  select valor into V_DWH from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DWH';
  
  begin
  for rs in (select OBJECT_NAME, OBJECT_TYPE from ALL_PROCEDURES where UPPER(owner) = V_DWH AND OBJECT_NAME not in ('COMPILAR_SP', 'LANZA_PROCESO_LOGADO', 'LANZAR_MASIVO_LOGADO') order by OBJECT_NAME) loop
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