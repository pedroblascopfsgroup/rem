--######################################################################
--## Author: Nacho
--## BPM: T. Demandado en incidente (H025)
--## Finalidad: modificación de datos en tablas de configuración del BPM
--## INSTRUCCIONES: Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--######################################################################
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
    
BEGIN
	--HR-443
	 
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''H025_resolucionFirme''''][''''combo1''''] == DDSiNo.SI && (valores[''''H025_registrarImporteCuotasAbonar''''][''''importeLetrado1''''] == null || valores[''''H025_registrarImporteCuotasAbonar''''][''''importeLetrado1''''] == '''''''' || valores[''''H025_registrarImporteCuotasAbonar''''][''''importeProcurador1''''] == null || valores[''''H025_registrarImporteCuotasAbonar''''][''''importeProcurador1''''] == '''''''') ? ''''Los importes de 1ª instancia son obligatorios'''' : (valores[''''H025_resolucionFirme''''][''''combo2''''] == DDSiNo.SI && (valores[''''H025_registrarImporteCuotasAbonar''''][''''importeLetrado2''''] == null || valores[''''H025_registrarImporteCuotasAbonar''''][''''importeLetrado2''''] == '''''''' || valores[''''H025_registrarImporteCuotasAbonar''''][''''importeProcurador2''''] == null || valores[''''H025_registrarImporteCuotasAbonar''''][''''importeProcurador2''''] == '''''''') ? ''''Los importes de 2ª instancia son obligatorios'''' : null) '' '
				|| ' WHERE TAP_CODIGO = ''H025_registrarImporteCuotasAbonar'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 
    
    --HR-439
    V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_VALIDACION = ''valor != null && valor != '''''''' ? true : false'', '
				|| ' TFI_ERROR_VALIDACION = ''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'' '
				|| ' WHERE TFI_NOMBRE = ''tipoReclamacion'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H025_notificacionDemandaIncidental'') ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    --HR-442
    V_MSQL := '  UPDATE DD_PTP_PLAZOS_TAREAS_PLAZAS '
    		|| ' SET DD_PTP_PLAZO_SCRIPT = ''damePlazo(valores[''''H025_notificacionDemandaIncidental''''][''''fechaNot'''']) + 2*24*60*60*1000L'' '
    		|| ' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H025_validarInstrucciones'') ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    --HR-444
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_VIEW = ''plugin/procedimientos-bpmHaya/tramiteDemandadoEnIncidente/admisionEscritoOposicion'' '
				|| ' WHERE TAP_CODIGO = ''H025_admisionEscritoOposicion'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 
    
    --HR-441
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_VIEW = ''plugin/procedimientos-bpmHaya/tramiteDemandadoEnIncidente/registrarResolucion'' '
				|| ' WHERE TAP_CODIGO = ''H025_registrarResolucion'' ';
 
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
    