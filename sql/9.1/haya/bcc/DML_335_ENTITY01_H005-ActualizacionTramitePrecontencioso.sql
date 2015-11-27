--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20151127
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-1344
--## PRODUCTO=NO
--##
--## Finalidad: Modificación trámite adjudicación
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

BEGIN		
	
	/* ------------------- -------------------------- */
	/* --------------  ACTUALIZACIONES --------------- */
	/* ------------------- -------------------------- */
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea deber&aacute; añadir el letrado al que asigna el expediente judicial en la pestaña "Gestores" del expediente.</p><p style="margin-bottom: 10px">En el campo Fecha, indicar la fecha en la completa la tarea.</p><p style="margin-bottom: 10px">En el campo "Motivo de asignaci&oacute;n a Letrado" deber&aacute; elegir una de entre las opciones disponibles.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla:<ul><li>En caso de que no esté conforme con la finalizaci&oacute;n del expediente, la pestaña de Preparaci&oacute;n Documental volver&aacute; a estar disponible y el Gestor de Documentaci&oacute;n deber&aacute; realizar los cambios que le indique el supervisor.</li><li>En caso de que haya indicado que est&aacute; conforme con la finalizaci&oacute;n del expediente, se lanzar&aacute; la tarea "Registrar aceptaci&oacute;n asunto" al letrado asignado.</li></ul></p></div>'' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_RevisarExpedienteAsignarLetrado'') AND TFI_NOMBRE = ''titulo''';
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea PCO_RevisarExpedienteAsignarLetrado actualizada.');
	
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