
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
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquemas       
        
begin  
    --Actualizamos datos
  		
	update tfi_tareas_form_items
	set TFI_BUSINESS_OPERATION='DDTipoRespuestaElevacionSareb'
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H010_RespuestaSareb')
		and tfi_nombre='comboResultado';	
		
	update tfi_tareas_form_items
	set TFI_BUSINESS_OPERATION='DDTipoRespuestaElevacionSareb'
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H012_RespuestaSareb')
		and tfi_nombre='comboResultado';	
		
	update tap_tarea_procedimiento
	set tap_script_decision='( (valores[''H002_ElevarPropuestaAComite''][''comboResultadoComite''] == ''ACEPTADA'' || valores[''H002_ElevarPropuestaAComite''][''comboResultadoComite''] == ''ACCONCAM'' ) ? ''Aceptada'' : ( valores[''H002_ElevarPropuestaAComite''][''comboResultadoComite''] == ''MODIFICAR'' ? ''Modificar'' : ''Rechazada'' ) )'	
	where tap_codigo='H002_ElevarPropuestaAComite';		
	
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