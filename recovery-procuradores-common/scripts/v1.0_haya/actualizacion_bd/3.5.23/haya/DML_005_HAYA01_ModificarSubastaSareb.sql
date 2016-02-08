--/*
--##########################################
--## AUTOR=Nacho A
--## FECHA_CREACION=20150520
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.0.1-rc03-hy
--## INCIDENCIA_LINK=HR-900
--## PRODUCTO=NO
--##
--## Finalidad:
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquema Master
   	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar 
   	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
	          ' SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''H002_CelebracionSubasta''''][''''comboCelebrada''''] == DDSiNo.NO ? ' || 
	          '(valores[''''H002_CelebracionSubasta''''][''''comboDecisionSuspension''''] == null ? ''''El campo Decisi&oacute;n suspensi&oacute;n es obligatorio'''' : null) : ' || 
	          '(comprobarExisteDocumentoACS() ? (validarBienesCelebracionSubasta() ? null : ''''Debe rellenar en cada bien los datos de adjudicaci&oacute;n o de cesi&oacute;n remate'''') : ' || 
	          ' ''''Es necesario adjuntar el documento Acta de subasta'''') '' ' ||
	          ' WHERE TAP_CODIGO = ''H002_CelebracionSubasta''';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando label de los campos.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Label de los campos actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
	          ' SET BORRADO = 1 ' ||
	          ' WHERE TAP_CODIGO = ''H002_EsperaPosibleCesionRemate''';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando borrado de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Borrado lógico de la tarea realizado.');
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
	          ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">' || 
	          'Una vez se celebre la subasta, en esta pantalla debe introducir la siguiente informaci&oacute;n:</p><p style="margin-bottom: 10px">' ||
	          'En el campo Celebrada deber&aacute; indicar si la subasta ha sido celebrada o no. En caso de haberse celebrado deber&aacute; ' || 
	          'indicar en cada unos de los bienes subastados el resultado de la subasta a trav&eacute;s de los campos:</p><p style="margin-bottom: 10px; margin-left: 40px;">' || 
	          '- Entidad Adjudicataria: deber&aacute; indicar si la adjudicaci&oacute;n es a favor de la entidad con auto o de un tercero.' || 
	          '</p><p style="margin-bottom: 10px; margin-left: 40px;">- Importe Adjudicacion: Importe por el cual se adjudica el bien.</p><p style="margin-bottom: 10px; margin-left: 40px;">' || 
	          '- Cesi&oacute;n de Remate: deber&aacute; indicar si el bien es objeto de cesi&oacute;n de remate o no.</p><p style="margin-bottom: 10px; margin-left: 40px;">' || 
	          '- Importe Cesion de Remate: Importe por el cual se cede a remate el bien.</p><p style="margin-bottom: 10px">En caso de suspensi&oacute;n de la subasta deber&aacute; ' || 
	          'indicar dicha circunstancia en el campo “Celebrada”, en el campo “Decisi&oacute;n suspensi&oacute;n” deber&aacute; informar quien ha provocado dicha suspensi&oacute;n y en el campo ' || 
	          '“Motivo suspensi&oacute;n” deber&aacute; indicar el motivo por el cual se ha suspendido.</p><p style="margin-bottom: 10px">En caso de haberse adjudicado alguno de los bienes la Entidad, ' || 
	          'deber&aacute; indicar si ha habido Postores o no en la subasta.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede ' || 
	          'reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla, la siguiente tarea ser&aacute;:</p>' || 
	          '<p style="margin-bottom: 10px; margin-left: 40px;">* En caso de haber indicado la suspensi&oacute;n de la subasta por decisi&oacute;n de terceros, ' || 
	          'se lanzar&aacute; un nuevo tramite de subasta dando por finalizado el actual.</p><p style="margin-bottom: 10px; margin-left: 40px;">' || 
	          '* En caso de haberse suspendido la subasta por decisi&oacute;n de la entidad, se le abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, ' || 
	          'la siguiente actuaci&oacute;n al responsable de la entidad.</p><p style="margin-bottom: 10px; margin-left: 40px;">* En caso de haberse producido la subasta, ' || 
	          'haber marcado alg&uacute;n bien con cesi&oacute;n de remate, se lanzar&aacute; el tramite de cesi&oacute;n de remate.</p><p style="margin-bottom: 10px; margin-left: 40px;">' || 
	          '*En caso de haberse producido la subasta, haber marcado alg&uacute;n bien adjudicado a un tercero se lanzar&aacute; la tarea "Solicitar Mandamiento de Pago".' || 
	          '</p><p style="margin-bottom: 10px; margin-left: 40px;">*En caso de haberse producido la subasta, haber marcado alg&uacute;n bien adjudicado la entidad sin cesi&oacute;n de remate, ' || 
	          'se lanzar&aacute; el tramite de adjudicaci&oacute;n.</p><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; adjuntar el acta de subasta al ' || 
	          'procedimiento a trav&eacute;s de la pesta&ntilde;a Adjuntos.</p></div>'' ' ||
	          ' WHERE TFI_NOMBRE = ''titulo'' AND' ||
	          ' TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_CelebracionSubasta'')';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando intrucciones.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Instrucciones actualizadas.');
	
	V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
	          ' WHERE TFI_NOMBRE = ''comboCesionRemate'' AND' ||
	          ' TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_CelebracionSubasta'')';
    DBMS_OUTPUT.PUT_LINE('[INFO] Borrando campo.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Campo borrado.');
    
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
	          ' WHERE TFI_NOMBRE = ''comboAdjudicadoEntidad'' AND' ||
	          ' TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_CelebracionSubasta'')';
    DBMS_OUTPUT.PUT_LINE('[INFO] Borrando campo.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Campo borrado.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
	          ' SET TFI_LABEL = ''Decisi&oacute;n suspensi&oacute;n'' ' ||
	          ' WHERE TFI_NOMBRE = ''comboDecisionSuspension'' AND' ||
	          ' TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_CelebracionSubasta'')';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando label de los campos.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Label de los campos actualizada.');

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
	          ' SET TFI_ORDEN = 3 ' ||
	          ' WHERE TFI_NOMBRE = ''comboDecisionSuspension'' AND' ||
	          ' TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_CelebracionSubasta'')';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando orden de los campos.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Orden de los campos actualizados.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
	          ' SET TFI_ORDEN = 4 ' ||
	          ' WHERE TFI_NOMBRE = ''comboMotivoSuspension'' AND' ||
	          ' TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_CelebracionSubasta'')';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando orden de los campos.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Orden de los campos actualizados.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
	          ' SET TFI_ORDEN = 5 ' ||
	          ' WHERE TFI_NOMBRE = ''observaciones'' AND' ||
	          ' TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_CelebracionSubasta'')';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando orden de los campos.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Orden de los campos actualizados.');
    
    COMMIT;

EXCEPTION
     
    -- Opcional: Excepciones particulares que se quieran tratar
    -- Como esta, por ejemplo:
    -- WHEN TABLE_EXISTS_EXCEPTION THEN
        -- DBMS_OUTPUT.PUT_LINE('Ya se ha realizado la copia en la tabla TMP_MOV_'||TODAY);
 
 
    -- SIEMPRE DEBE HABER UN OTHERS
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
 
EXIT;
  	