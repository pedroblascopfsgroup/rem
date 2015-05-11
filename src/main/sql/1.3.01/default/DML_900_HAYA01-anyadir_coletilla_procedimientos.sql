/*
--######################################################################################
--## Author: Roberto
--## Finalidad: Quitar la coletilla " - HAYA" del nombre de los procedimientos si existe
--## VERSIONES:
--##        0.1 Versión inicial
--######################################################################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
declare
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    /*
    * VARIABLES DEL SCRIPT
    *---------------------------------------------------------------------
    */    
    V_MSQL VARCHAR2(32000 CHAR);                        -- Sentencia a ejecutar 
        
begin
	
	--1) Actualizo los procedimientos para que ponga ' - HAYA' en los que pueden modificar sus instrucciones o plazos
	V_MSQL := 'update dd_tpo_tipo_procedimiento '
				|| ' set dd_tpo_descripcion=dd_tpo_descripcion||'' - HAYA'' '
				|| ' where ( '
				|| '           dd_tpo_codigo like ''H%'' '
				|| '           or '
				|| '           dd_tpo_codigo in (''P400'',''P404'',''P420'') '
				|| '      ) '
				|| '      and dd_tpo_descripcion not like ''% - HAYA'' ';
				
    EXECUTE IMMEDIATE V_MSQL;				
  
  
--2) Actualizo el resto de procedimientos para que ponga 'PARA ELIMINAR - ' delante y así que no los modifiquen
	V_MSQL := 'update dd_tpo_tipo_procedimiento '
				|| ' set dd_tpo_descripcion=''PARA ELIMINAR - ''||dd_tpo_descripcion '
				|| ' where dd_tpo_descripcion not like ''% - HAYA'' ';
        
    EXECUTE IMMEDIATE V_MSQL;   

  	commit;
  
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
end;
/
EXIT;