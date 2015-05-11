/*
--######################################################################
--## Author: Roberto
--## Tarea: http://link.pfsgroup.es/jira/browse/HR-453
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
	
    V_MSQL := 'update dd_ptp_plazos_tareas_plazas '
    		|| ' set dd_ptp_plazo_script=''((valores[''''H032_RegistrarCelebracionVista''''] != null) && valores[''''H032_RegistrarCelebracionVista''''][''''fecha''''] != '''''''' ? damePlazo(valores[''''H032_RegistrarCelebracionVista''''][''''fecha'''']) + 20*24*60*60*1000L : damePlazo(valores[''''H032_ConfirmarPresImpugnacion''''][''''fecha'''']) + 60*24*60*60*1000L)'' '
    		|| ' where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo=''H032_RegistrarResolucion'') ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;    
    
    V_MSQL := 'update tfi_tareas_form_items set tfi_business_operation=''DDFavorable'' where tfi_nombre=''resultado'' and tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo=''H032_RegistrarResolucion'') ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;    
    
    V_MSQL := 'update tap_tarea_procedimiento set tap_script_decision=''valores[''''H032_RegistrarResolucion''''][''''resultado''''] == DDFavorable.FAVORABLE ? ''''favorable'''' : ''''desfavorable'''' '' where tap_codigo=''H032_ResolucionFirme'' ';
 
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