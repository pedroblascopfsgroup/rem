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

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-606');
	V_TAREA:='H006_RevisarInfoContable';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''Fecha''' ||
	  ' WHERE TFI_NOMBRE=''fecha'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	V_TAREA:='H006_ConfirmarContabilidad';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''Fecha contabilidad''' ||
	  ' WHERE TFI_NOMBRE=''fecha'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-606');

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-608');
	V_TAREA:='H048_TrasladoDocuDeteccionOcupantes';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por completada esta tarea deberá de haber un bien vinculado al procedimiento, esto podrá comprobarlo a través de la pestaña Bienes del procedimiento, en caso de no haberlo, a través de esa misma pestaña dispone de la opción de Agregar por la cual se le permite vincular un bien al procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través de esta pantalla deberá confirmar si el bien se encuentra ocupado o no, si dispone de la documentación de detección de ocupantes, en caso afirmativo, deberá indicar si existe o no inquilino y en tal caso la fecha del contrato de arrendamiento y el nombre del arrendatario. </p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Los campos Fecha vista y Fecha fin para alegaciones deberá de informarlos en caso de ya disponer de dicha información.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla en caso de no disponer de la documentación de detección se lanzará la tarea "Solicitud de requerimiento documentación a ocupantes", en caso contrario se lanzará la tarea "Obtener aprobación alquiler".</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	V_TAREA:='H048_RegistrarRecepcionDoc';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por completada esta tarea deberá de informar la fecha en que haya recibido la documentación solicitada a los ocupantes.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Los campos Fecha vista y Fecha fin para alegaciones deberá de informarlos en caso de ya disponer de dicha información.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzará la tarea "Obtener aprobación de alquiler".</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-608');
	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-602');
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
          ' SET TAP_DESCRIPCION = ''Suspensión lanzamiento'' ' ||
          ' WHERE TAP_CODIGO = ''H015_SuspensionLanzamiento'' ';
	V_TAREA:='H015_SuspensionLanzamiento';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_ERROR_VALIDACION=''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio''' ||
	  ' ,TFI_VALIDACION=''valor != null && valor != '''' ? true : false''' ||
	  ' WHERE TFI_NOMBRE=''fechaParalizacion'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-602');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-614');
	V_TAREA:='H054_ConfirmarComEmpresario';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="margin-bottom: 30px;"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Deberá comprobar si, para los bienes sujetos a IVA, en la comunicación de deuda enviada en la preparación del expediente judicial se incluyó las menciones fiscales pertinentes a la referencia a la tributación. En caso de no haberse incluido, deberá remitir burofax a la parte demandada con certificación en el que manifieste lo siguiente:</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">"La entidad de acuerdo con lo dispuesto &nbsp;en el articulo 24 quarter del Real Decreto 1624/1992, por el que se aprueba el Reglamento del Impuesto del Valor Añadido, le comunica que la adquisición del inmueble que se llegara a realizar en ejecución de la presente garantía, será efectuada en el ámbito empresarial del ejecutante".</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En el campo Fecha indicará la fecha en la que realiza la comprobación / envío de los burofaxes.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></font></p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-614');
	
	
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