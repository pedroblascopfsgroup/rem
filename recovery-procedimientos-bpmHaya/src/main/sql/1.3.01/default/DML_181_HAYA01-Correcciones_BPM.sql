/*
--######################################################################################
--## Author: Roberto
--## Finalidad: Correcciones BPM
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
   
    V_MSQL := 'update tap_tarea_procedimiento '
				|| ' set dd_tpo_id_bpm=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo=''H009'') '
				|| ' where tap_codigo=''H021_BPMtramiteFaseComun'' ';
        
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