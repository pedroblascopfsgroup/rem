/*
--######################################################################################
--## Author: Roberto
--## Finalidad: Activar los gestores de tipo 'GGADJ', 'GGSAN', 'SGADJ', 'SGSAN'
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
	
    V_MSQL := 'update HAYAMASTER.dd_tge_tipo_gestor '
    			|| ' set dd_tge_descripcion=''Gestor gestoría adjudicación'' '
    			|| ', dd_tge_descripcion_larga=''Gestor gestoría adjudicación'' '
    			|| ', usuarioborrar=null'
    			|| ', fechaborrar=null'
				|| ', borrado=0 '
				|| ' where dd_tge_codigo=''GGADJ'' ';
	
	DBMS_OUTPUT.put_line(V_MSQL);        				
    EXECUTE IMMEDIATE V_MSQL;   
    
    V_MSQL := 'update HAYAMASTER.dd_tge_tipo_gestor '
    		|| ' set usuarioborrar=null, '
    		|| ' fechaborrar=null, '
    		|| ' borrado=0 '
    		|| ' where dd_tge_codigo=''GGSAN'' '; 
    		
	DBMS_OUTPUT.put_line(V_MSQL);        				
    EXECUTE IMMEDIATE V_MSQL;    
    
    V_MSQL := 'update HAYAMASTER.dd_tge_tipo_gestor '
    		|| ' set usuarioborrar=null, '
    		|| ' fechaborrar=null, '
    		|| ' borrado=0 '
    		|| ' where dd_tge_codigo=''SGADJ'' '; 
    		
	DBMS_OUTPUT.put_line(V_MSQL);        				
    EXECUTE IMMEDIATE V_MSQL;     
    
    V_MSQL := 'update HAYAMASTER.dd_tge_tipo_gestor '
    		|| ' set usuarioborrar=null, '
    		|| ' fechaborrar=null, '
    		|| ' borrado=0 '
    		|| ' where dd_tge_codigo=''SGSAN'' '; 
    		
	DBMS_OUTPUT.put_line(V_MSQL);        				
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