--/*
--##########################################
--## AUTOR=JOSE VILLEL
--## FECHA_CREACION=20150429
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.5.12
--## INCIDENCIA_LINK=FASE-1253
--## PRODUCTO=NO
--## Finalidad: DML
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);

BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO]');


-- Pasamos la validacion comprobarImporteEntidadAdjudicacionBienes() de PRE a POST para poder suspender la subasta sin esa validación. 

execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = ''comprobarMinimoBienLote() ? (comprobarBienInformado() ? (comprobarExisteDocumentoESRAS() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento Edicto de subasta y resoluci&oacute;n acordando se&ntilde;alamiento.</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Los bienes con lote deben tener informado las cargas anteriores y posteriores, si es vivienda habitual o no, la situaci&oacute;n posesoria y el tipo de subasta.</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Al menos un bien debe estar asignado a un lote.</div>'''''','||
'TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''P409_CelebracionSubasta''''][''''comboCelebrada''''] == ''''02'''' ? (valores[''''P409_CelebracionSubasta''''][''''comboSuspension''''] == null ? ''''El campo suspensi&oacute;n es obligatorio'''' : (valores[''''P409_CelebracionSubasta''''][''''comboMotivo''''] == null ? ''''Campo motivo es obligatorio'''' : null )) : (valores[''''P409_CelebracionSubasta''''][''''comboCesion''''] == null ? ''''Campo cesi&oacute;n es obligatorio'''' : (valores[''''P409_CelebracionSubasta''''][''''comboCesion''''] == ''''01'''' ? (valores[''''P409_CelebracionSubasta''''][''''comboComite''''] == null ? ''''Campo comit&eacute; es obligatorio'''' : comprobarImporteEntidadAdjudicacionBienes() ? null : ''''Debe rellenar en cada bien el importe adjudicaci&oacute;n y la entidad.'''') : null ))'' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''P409_CelebracionSubasta'')';

-- Borramos campo TAP_SCRIPT_DECISION de P409_AprobacionPropCesionRemate
-- Valor anterior --> valores['P409_AprobacionPropCesionRemate']['comboAprobado'] == DDSiNo.SI ? 'OK' : 'KO'

execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = NULL WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''P409_AprobacionPropCesionRemate'')';


-- Eliminamos de TFI_TAREAS_FORM_ITEMS el campo comboAprobado que corresponde con la decisión anterior, y modificamos el orden de los campos siguientes

execute immediate 'DELETE FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TFI_NOMBRE = ''comboAprobado'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''P409_AprobacionPropCesionRemate'')';

execute immediate 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ORDEN = 2 WHERE TFI_NOMBRE = ''instrucciones'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''P409_AprobacionPropCesionRemate'')';

execute immediate 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ORDEN = 3 WHERE TFI_NOMBRE = ''observaciones'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''P409_AprobacionPropCesionRemate'')';


-- Modificamos a null el campo TAP_ALERT_VUELTA_ATRAS de SolicitarMtoPago, RegistrarActaSubasta y PrepararCesionRemate porque no procede para SAREB.
-- Valor anterior --> tareaExterna.cancelarTarea

execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_ALERT_VUELTA_ATRAS = NULL WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''P409_SolicitarMtoPago'')';

execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_ALERT_VUELTA_ATRAS = NULL WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''P409_RegistrarActaSubasta'')';

execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_ALERT_VUELTA_ATRAS = NULL WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''P409_PrepararCesionRemate'')';


-- Borramos campo TAP_SCRIPT_DECISION de P401_AprobacionPropCesionRemate
-- Valor anterior --> valores['P401_AprobacionPropCesionRemate']['comboAprobado'] == DDSiNo.SI ? 'OK' : 'KO'

execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = NULL WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''P401_AprobacionPropCesionRemate'')';


-- Eliminamos de TFI_TAREAS_FORM_ITEMS el campo comboAprobado que corresponde con la decisión anterior, y modificamos el orden de los campos siguientes

execute immediate 'DELETE FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TFI_NOMBRE = ''comboAprobado'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''P401_AprobacionPropCesionRemate'')';

execute immediate 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ORDEN = 2 WHERE TFI_NOMBRE = ''instrucciones'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''P401_AprobacionPropCesionRemate'')';

execute immediate 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ORDEN = 3 WHERE TFI_NOMBRE = ''observaciones'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''P401_AprobacionPropCesionRemate'')';

--Error detectado al derivr un BPM
execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET DD_TPO_ID_BPM = (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''P411'') WHERE TAP_CODIGO = ''P401_BPMTramiteTributacionEnBienesV4''';

execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET DD_TPO_ID_BPM = (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''P411'') WHERE TAP_CODIGO = ''P409_BPMTramiteTributacionEnBienesV4''';



COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN]');



EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT

