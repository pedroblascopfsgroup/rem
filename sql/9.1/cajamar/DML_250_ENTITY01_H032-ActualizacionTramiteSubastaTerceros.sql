--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20150925
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-826
--## PRODUCTO=NO
--##
--## Finalidad: Modificación trámite de subasta de terceros
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
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';    -- [PARAMETRO] Configuracion Esquemas
    
    
    ERR_NUM NUMBER(25);                                 -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR);                        -- Vble. auxiliar para registrar errores en el script.

BEGIN		
	
	/* ------------------- -------------------------- */
	/* --------------  ACTUALIZACIONES --------------- */
	/* ------------------- -------------------------- */
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = ''comprobarExisteDocumento(''''ESCSUS'''') ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento "Escrito de suspensi&oacute;n"</div>'''''' WHERE TAP_CODIGO = ''H004_SolicitarSuspenderSubasta''';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = ''valores[''''H004_ObtenerValidacionComite''''] != null ? valores[''''H004_ObtenerValidacionComite''''][''''comboMotivo''''] : null'' WHERE TFI_NOMBRE = ''comboMotivo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H004_SolicitarSuspenderSubasta'')';
	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H004_SolicitarSuspenderSubasta actualizada.');
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla deber&aacute; informa de la fecha en la que el juzgado notifica la resoluci&oacute;n a la solicitud de suspensi&oacute;n de la subasta as&iacute; como indicar si la subasta se ha suspendido o no.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez finaliza esta tarea, se lanzar&aacute; un nuevo tr&aacute;mite de subasta paralizado por 60 días. En caso de no ser necesario realizar una nueva subasta, deber&aacute; finalizar el nuevo tr&aacute;mite.</p></div>'' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H004_RegistrarResSuspSubasta'')';
	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H004_RegistrarResSuspSubasta actualizada.');
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea deber&aacute; revisar y dictaminar sobre la propuesta de instrucciones. En caso de que tenga atribuciones y la deuda judicial calculada sea superior a 500mil euros deber&aacute; informar a la entidad del celebramiento de la subasta y las instrucciones de puja a trav&eacute;s de la herramienta mediante el bot&oacute;n "Anotaci&oacute;n".</p><p style="margin-bottom: 10px">En caso de que no tenga atribuciones para validar el informe de subasta, deber&aacute; se&ntilde;alar el motivo de autorizaci&oacute;n de entre los posibles motivos listados.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">La siguiente tarea ser&aacute;:</p><p style="margin-bottom: 10px; margin-left: 40px;">-En caso de aceptar el informe y tenga atribuciones, se lanzar&aacute; la tarea de  “Dictar instrucciones”.</p><p style="margin-bottom: 10px; margin-left: 40px;">-En caso de aceptar el informe y no tenga atribuciones, se lanzar&aacute; la tarea de  “Obtener validaci&oacute;n comit&eacute;”.</p><p style="margin-bottom: 10px; margin-left: 40px;">-Se lanzar&aacute; la tarea "Preparar informe de subasta" en caso de no aceptar el informe.</p></div>'' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H004_ValidarInformeDeSubasta'')';
	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H004_ValidarInformeDeSubasta actualizada.');
	
	/*
    * COMMIT ALL BLOCK-CODE
    *---------------------------------------------------------------------
    */
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[COMMIT ALL]...............................................');
    DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]-----------------------------------------------------------');
    /*
    *---------------------------------------------------------------------------------------------------------
    *                                FIN - BLOQUE DE CODIGO DEL SCRIPT
    *---------------------------------------------------------------------------------------------------------
    */
 
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