/*
--######################################################################
--## Author: Nacho
--## BPM: T. Tributación bienes Sareb (H043) - modificación del BPM
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
	
	--HR-641
	 V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''H043_registrarOposicion''''][''''comboOposicion''''] == DDSiNo.SI ? (comprobarExisteDocumentoEORC() ? (((valores[''''H043_registrarOposicion''''][''''fechaOposicion''''] == null) || (valores[''''H043_registrarOposicion''''][''''fechaVista''''] == null)) ? ''''tareaExterna.error.faltaAlgunaFecha'''' : null) : ''''Debe adjuntar el documento "Escrito de Oposici&oacute;n (Reapertura del concurso)"'''') : null'' '
				|| ' WHERE TAP_CODIGO = ''H043_registrarOposicion'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_VALIDACION = '''' '
 				|| ' WHERE TFI_NOMBRE = ''observaciones'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H043_registrarOposicion'')';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_VALIDACION = '''' '
 				|| ' WHERE TFI_NOMBRE = ''observaciones'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H043_RegistrarVista'')';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_VALIDACION = '''' '
 				|| ' WHERE TFI_NOMBRE = ''observaciones'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H043_RegistrarResolucion'')';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    --HR-644
     V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_DECISION = '''' '
				|| ' WHERE TAP_CODIGO = ''H043_AutoDeclarandoConcurso'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
    			|| ' SET BORRADO = 1 '
				|| ' WHERE TAP_CODIGO = ''H043_BPMtramiteFaseComunAbreviado'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
    			|| ' SET DD_TPO_ID_BPM = (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''H009'') '
				|| ' WHERE TAP_CODIGO = ''H043_BPMtramiteFaseComunOrdinario'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'DELETE FROM TFI_TAREAS_FORM_ITEMS '
				|| ' WHERE TFI_NOMBRE = ''comboEligeTramite'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H043_AutoDeclarandoConcurso'') ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_ORDEN = 2 '
 				|| ' WHERE TFI_NOMBRE = ''observaciones'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H043_AutoDeclarandoConcurso'')';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    --HR-640
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_VALIDACION = ''comprobarExisteDocumentoESSORE() ? null : ''''Debe adjuntar el documento "Escrito de Solicitud de Reapertura"'''' '' '
				|| ' WHERE TAP_CODIGO = ''H043_SolicitudConcursal'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    --HR-643
    V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_VALOR_INICIAL = ''valores[''''H043_SolicitudConcursal''''][''''plazaJuzgado'''']'' '
 				|| ' WHERE TFI_NOMBRE = ''nPlaza'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H043_ConfirmarAdmision'')';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_VIEW = '''' '
				|| ' WHERE TAP_CODIGO = ''H043_ConfirmarAdmision'' ';
 
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