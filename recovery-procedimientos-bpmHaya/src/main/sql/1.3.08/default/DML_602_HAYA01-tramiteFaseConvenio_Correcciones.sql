/*
--######################################################################
--## Author: Roberto
--## Tarea: http://link.pfsgroup.es/jira/browse/HR-423 - T. Fase convenio - tarea 3 los combos deben ser excluyentes
--## Finalidad: Modificación del BPM
--## INSTRUCCIONES: Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--######################################################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    
BEGIN
	
	V_MSQL := 'update tap_tarea_procedimiento set tap_view=''plugin/procedimientos-bpmHaya/tramiteFaseConvenio/decidirSobreFaseConvenio'' where tap_codigo=''H017_decidirSobreFaseConvenio'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;

	V_MSQL := 'update tfi_tareas_form_items set TFI_ERROR_VALIDACION=null, TFI_VALIDACION=null where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo=''H017_decidirSobreFaseConvenio'') and tfi_nombre=''comboPropio'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;    

	V_MSQL := 'update tfi_tareas_form_items set TFI_ERROR_VALIDACION=null, TFI_VALIDACION=null where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo=''H017_decidirSobreFaseConvenio'') and tfi_nombre=''comboSeguimiento'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;    
    
    
	COMMIT;				
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/

EXIT;