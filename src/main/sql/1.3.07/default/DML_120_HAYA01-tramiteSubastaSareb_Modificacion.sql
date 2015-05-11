/*
--######################################################################
--## Author: Nacho
--## BPM: T. Subasta Sareb (H002) - modificación del BPM
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
	
	--HR-534 
    
    V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_LABEL = ''Intereses generados a fecha del se&ntilde;alamiento de subasta'' '
				|| ' WHERE TFI_NOMBRE = ''intereses'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_SenyalamientoSubasta'') ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    --HR-467
    
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_VALIDACION_JBPM = ''comprobarSubastaBienDueD() ? null : ''''Debe marcar el check "Solicitada Due" de, al menos, un bien de la subasta.'''' '' '
				|| ' WHERE TAP_CODIGO = ''H002_SolicitarDueDiligence'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_VALIDACION_JBPM = ''comprobarSubastaBienFechaRecDue() ? null : ''''Debe informar de la fecha de recepci&oacute;n de la Due Dilligence de todos los bienes de los que se haya solicitado.'''' '' '
				|| ' WHERE TAP_CODIGO = ''H002_RegistrarResultadoDueDiligence'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    --HR-578
    V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_ERROR_VALIDACION = '''', '
				|| ' TFI_VALIDACION = '''' '
				|| ' WHERE TFI_NOMBRE = ''comboDelegada'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_ValidarPropuesta'') ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    --HR-587
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''H002_CelebracionSubasta''''][''''comboCelebrada''''] == DDSiNo.NO ? (valores[''''H002_CelebracionSubasta''''][''''comboDecisionSuspension''''] == null ? ''''El campo Decisi&oacute;n suspensi&oacute;n Entidad/terceros es obligatorio'''' : null) : (comprobarExisteDocumentoACS() ? (valores[''''H002_CelebracionSubasta''''][''''comboCesionRemate''''] == null ? ''''El campo Cesi&oacute;n de remate es obligatorio'''' : (valores[''''H002_CelebracionSubasta''''][''''comboAdjudicadoEntidad''''] == null ? ''''El campo Adjudicado a Entidad con posibilidad de Cesi&oacute;n de remate es obligatorio'''' : (valores[''''H002_CelebracionSubasta''''][''''comboCesionRemate''''] == DDSiNo.NO && !comprobarImporteEntidadAdjudicacionBienes() ? ''''Debe rellenar en cada bien el importe adjudicaci&oacute;n y la entidad'''' : null) ) ) : ''''Es necesario adjuntar el documento Acta de subasta'''') '', '
				|| ' TAP_SCRIPT_VALIDACION  = '''' '
				|| ' WHERE TAP_CODIGO  = ''H002_CelebracionSubasta'' ';
 
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