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
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';    -- [PARAMETRO] Configuracion Esquemas
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN		
	
	/* ------------------- -------------------------- */
	/* --------------  ACTUALIZACIONES --------------- */
	/* ------------------- -------------------------- */
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_DESCRIPCION = ''Autorizar solicitud'', DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_MASTER||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''TGCTRGE''), DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''GCTRGE'') WHERE TAP_CODIGO = ''HC103_ConfirmarSolicitud''';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''Resultado'', TFI_BUSINESS_OPERATION = ''DDAceptadoDenegado'' WHERE TFI_NOMBRE = ''resultado'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''HC103_ConfirmarSolicitud'')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = NULL WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''HC103_ConfirmarSolicitud'')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS SET DD_PTP_PLAZO_SCRIPT = ''3*24*60*60*1000L'' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''HC103_ConfirmarSolicitud'')';

	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea HC103_ConfirmarSolicitud actualizada.');
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_MASTER||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''CJ-814'') WHERE TAP_CODIGO = ''HC103_ConfirmarTransferencia''';
	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea HC103_ConfirmarTransferencia actualizada.');
	
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