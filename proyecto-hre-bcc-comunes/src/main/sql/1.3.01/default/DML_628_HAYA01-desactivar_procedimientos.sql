--######################################################################################
--## Author: Roberto
--## Finalidad: Desactivar trámites H043, H026 y H028 para volver a crearlos.
--## VERSIONES:
--##        0.1 Versión inicial
--######################################################################################
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
    
	--1. Desactivar procedimiento y tareas
	update tap_tarea_procedimiento
	set borrado=1, tap_codigo='B043'||tap_codigo
	where tap_codigo like '%H043%';
	
						
		
	
	update dd_tpo_tipo_procedimiento
	set borrado=1, dd_tpo_codigo='B043'||dd_tpo_codigo
	where dd_tpo_codigo like '%H043%';
					
						
						
	
	--1.2 'H026',  'P. verbal'
	update tap_tarea_procedimiento
	set borrado=1, tap_codigo='B026'||tap_codigo
	where tap_codigo like '%H026%';
	
										
						
	
	update dd_tpo_tipo_procedimiento
	set borrado=1, dd_tpo_codigo='B026'||dd_tpo_codigo
	where dd_tpo_codigo like '%H026%';
	
										
						
					
	--1.3 'H028',  'P. Verbal desde Monitorio'
	update tap_tarea_procedimiento
	set borrado=1, tap_codigo='B028'||tap_codigo
	where tap_codigo like '%H028%';
	
						
		
					
	update dd_tpo_tipo_procedimiento
	set borrado=1, dd_tpo_codigo='B028'||dd_tpo_codigo
	where dd_tpo_codigo like '%H028%';
				
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