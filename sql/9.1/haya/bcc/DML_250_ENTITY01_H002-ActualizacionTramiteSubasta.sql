--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20150924
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-817
--## PRODUCTO=NO
--##
--## Finalidad: Modificación trámite subasta
--## INSTRUCCIONES: Relanzable
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TAREA VARCHAR(100 CHAR);
BEGIN	
	
	
	/* ------------------- -------------------------- */
	/* --------------  ACTUALIZACIONES --------------- */
	/* ------------------- -------------------------- */
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = ''comprobarExisteDocumento("ESCSUS") ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento "Escrito de suspensi&oacute;n".</div>'''''' WHERE TAP_CODIGO = ''H002_SolicitarSuspenderSubasta''';
	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_SolicitarSuspenderSubasta actualizada.');
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla deber&aacute; informa de la fecha en la que el juzgado notifica la resoluci&oacute;n a la solicitud de suspensi&oacute;n de la subasta as&iacute; como indicar si la subasta se ha suspendido o no.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez finaliza esta tarea, se lanzar&aacute; un nuevo tr&aacute;mite de subasta paralizado por 60 d&iacute;as. En caso de no ser necesario realizar una nueva subasta, deber&aacute; finalizar el nuevo tr&aacute;mite.</p></div>'' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_RegistrarResSuspSubasta'')';
	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_RegistrarResSuspSubasta actualizada.');
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez se celebre la subasta, en esta pantalla debe introducir la siguiente informaci&oacute;n:</p><p style="margin-bottom: 10px; margin-left: 40px;">-En el campo Celebrada deber&aacute; indicar si la subasta ha sido celebrada o no.</p><p style="margin-bottom: 10px; margin-left: 40px;">-En caso de haberse celebrado deber&aacute; indicar a trav&eacute;s de la pesta&ntilde;a Subastas de la ficha del asunto correspondiente, el resultado de la subasta para cada uno de los bienes subastados.</p><p style="margin-bottom: 10px; margin-left: 40px;">-En la ficha del bien se debe recoger el resultado de la adjudicaci&oacute;n y el valor de la adjudicaci&oacute;n.</p><p style="margin-bottom: 10px; margin-left: 40px;">-En el campo Observaciones informar cualquier aspecto  relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; adjuntar el acta de subasta al procedimiento a trav&eacute;s de la pesta&ntilde;a "Adjuntos" y anotar la situaci&oacute;n final de cada bien en la ficha del bien.</p><p style="margin-bottom: 10px">La siguiente tarea ser&aacute;:</p><p style="margin-bottom: 10px; margin-left: 40px;">-En caso de haber uno o m&aacute;s bienes adjudicados a un tercero se lanzar&aacute; la tarea “Solicitar mandamiento de pago”.</p><p style="margin-bottom: 10px; margin-left: 40px;">-En caso de haber uno o m&aacute;s bienes con cesi&oacute;n de remate se lanzar&aacute; la tarea "Tr&aacute;mite de Cesi&oacute;n de Remate" por cada uno de ellos.</p><p style="margin-bottom: 10px; margin-left: 40px;">-En caso de haber uno o m&aacute;s bienes adjudicados a la entidad, se lanzar&aacute; el "Tr&aacute;mite de Adjudicaci&oacute;n" por cada uno de ellos.</p><p style="margin-bottom: 10px; margin-left: 40px;">-En caso de suspensi&oacute;n de la subasta deber&aacute; indicar dicha circunstancia en el campo "Celebrada", en el campo "Decisi&oacute;n suspensi&oacute;n" deber&aacute; informar quien ha provocado dicha suspensi&oacute;n y en el campo "Motivo suspensi&oacute;n" deber&aacute; indicar el motivo por el cual se ha suspendido. Si la suspensi&oacute;n ha sido por parte de la entidad, se lanzar&aacute; un nuevo tr&aacute;mite de subasta paralizado por 60 d&iacute;as. En caso de no ser necesario realizar una nueva subasta, deber&aacute; finalizar el nuevo tr&aacute;mite. Si la suspensi&oacute;n ha sido por motivos de un tercero, se lanzar&aacute; un nuevo tr&aacute;mite de subasta.</p><p style="margin-bottom: 10px; margin-left: 40px;">-En caso de que alg&uacute;n bien haya sido adjudicado a la entidad o con cesi&oacute;n de remate, se lanzar&aacute; el "Tr&aacute;mite de solvencia patrimonial" para averiguar la solvencia del deudor.</p></div>'' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_CelebracionSubasta'')';
	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_CelebracionSubasta actualizada.');
	
	V_TAREA:='H002_SuspenderDecision';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.DD_PTP_PLAZOS_TAREAS_PLAZAS WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=SYSDATE,USUARIOBORRAR=''ALBERTO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] H002_SuspenderDecision eliminado.');
	    
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