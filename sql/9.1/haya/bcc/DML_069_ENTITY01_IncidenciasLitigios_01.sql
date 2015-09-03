--/*
--##########################################
--## AUTOR=GONZALO ESTELLES
--## FECHA_CREACION=20150802
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3-hcj
--## INCIDENCIA_LINK=VARIAS
--## PRODUCTO=NO
--##
--## Finalidad: Resolución de varias incidencias de Litigios
--## INSTRUCCIONES: Relanzable
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    V_TAREA VARCHAR(50 CHAR);
    
BEGIN	
	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-539');
	-- BORRADO DE TAREA (lógico)
	V_TAREA:='H001_PresentarAlegaciones';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_VALOR_INICIAL=''valores[''''H001_ConfirmarSiExisteOposicion''''][''''fechaComparecencia'''']''' ||
	  ' WHERE TFI_NOMBRE=''fechaComparecencia'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-539');

	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-538');
	V_TAREA:='H001_PresentarAlegaciones';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">En esta pantalla se deberá de informar la fecha de notificación de la Resolución que hubiere recaído como consecuencia de la comparecencia celebrada.</p><p style="margin-bottom: 10px">Se indicará si el resultado de dicha resolución ha sido favorable para los intereses de la entidad o no.</p><p style="margin-bottom: 10px">Para el supuesto de que la resolución no fuere favorable para la entidad, deberá comunicar dicha circunstancia al responsable interno de la misma a través del botón "Anotación". Una vez reciba la aceptación del supervisor deberá gestionar el recurso por medio de la pestaña "Recursos".</p><p style="margin-bottom: 10px">Para el supuesto de anuncio del recurso por la parte contraria se deberá gestionar directamente a través de la pestaña "Recursos".</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será "Resolución firme".</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''fechaComparecencia'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-538');

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-541');
	V_TAREA:='H001_PresentarAlegaciones';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET ' ||
	' TAP_SCRIPT_VALIDACION_JBPM=''comprobarTipoCargaBienInscrito() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Tiene que completar la informaci&oacute;n en la pesta&ntilde;a de cargas en la ficha del bien.</div>'''''' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-541');

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-545');
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.tap_tarea_procedimiento set tap_script_validacion=replace(tap_script_validacion, ''á'', ''&aacute;''), tap_script_validacion_jbpm=replace(tap_script_validacion_jbpm, ''á'', ''&aacute;'') where tap_script_validacion_jbpm like ''%á%'' or tap_script_validacion like ''%á%''';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.tap_tarea_procedimiento set tap_script_validacion=replace(tap_script_validacion, ''é'', ''&eacute;''), tap_script_validacion_jbpm=replace(tap_script_validacion_jbpm, ''é'', ''&eacute;'') where tap_script_validacion_jbpm like ''%é%'' or tap_script_validacion like ''%é%''';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.tap_tarea_procedimiento set tap_script_validacion=replace(tap_script_validacion, ''í'', ''&iacute;''), tap_script_validacion_jbpm=replace(tap_script_validacion_jbpm, ''í'', ''&iacute;'') where tap_script_validacion_jbpm like ''%ó%'' or tap_script_validacion like ''%í%''';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.tap_tarea_procedimiento set tap_script_validacion=replace(tap_script_validacion, ''ó'', ''&oacute;''), tap_script_validacion_jbpm=replace(tap_script_validacion_jbpm, ''ó'', ''&oacute;'') where tap_script_validacion_jbpm like ''%ó%'' or tap_script_validacion like ''%ó%''';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.tap_tarea_procedimiento set tap_script_validacion=replace(tap_script_validacion, ''ú'', ''&uacute;''), tap_script_validacion_jbpm=replace(tap_script_validacion_jbpm, ''ú'', ''&uacute;'') where tap_script_validacion_jbpm like ''%ú%'' or tap_script_validacion like ''%ú%''';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.tap_tarea_procedimiento set tap_script_validacion=replace(tap_script_validacion, ''ñ'', ''&ntilde;''), tap_script_validacion_jbpm=replace(tap_script_validacion_jbpm, ''ñ'', ''&ntilde;'') where tap_script_validacion_jbpm like ''%ñ%'' or tap_script_validacion like ''%ñ%''';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items set tfi_label=replace(tfi_label, ''&ó'', ''&o'')  where Tfi_Label like ''%&ó%''';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-545');
	

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-547');
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
          ' SET TAP_SCRIPT_VALIDACION = ''comprobarExisteDocumentoESRAS() ? (comprobarProvLocFinBien() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Los bienes con lote deben tener informado el tipo de inmueble, provincia, localidad y n&uacute;mero de finca.</div>'''') : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento Edicto de subasta y resoluci&oacute;n acordando se&ntilde;alamiento</div>'''' '' ' ||
          ' WHERE TAP_CODIGO = ''H002_SenyalamientoSubasta'' ';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			' SET TAP_SCRIPT_VALIDACION = ''comprobarMinimoBienLote() ? (comprobarExisteDocumentoESRAS() ? (comprobarProvLocFinBien() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Los bienes con lote deben tener informado el tipo de inmueble, provincia, localidad y n&uacute;mero de finca.</div>'''') : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento Edicto de subasta y resoluci&oacute;n acordando se&ntilde;alamiento</div>'''') : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Al menos un bien debe estar asignado a un lote</div>'''' '' ' ||
			' WHERE TAP_CODIGO = ''H004_SenyalamientoSubasta'' ';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-547');

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-544');
	V_TAREA:='H002_LecturaConfirmacionInstrucciones';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS' ||
          ' SET DD_PTP_PLAZO_SCRIPT = ''damePlazo(valores[''''H002_SenyalamientoSubasta''''][''''fechaSenyalamiento''''])-3*24*60*60*1000L''' ||
          ' WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-544');

	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-554');
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
          ' SET TAP_SCRIPT_DECISION = ''valores[''''H002_RegistrarResSuspSubasta''''][''''comboSuspension''''] == DDSiNo.SI ? ''''Aceptado'''' : ''''Denegado'''''' ' ||
          ' WHERE TAP_CODIGO = ''H002_RegistrarResSuspSubasta'' ';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-554');
	
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
