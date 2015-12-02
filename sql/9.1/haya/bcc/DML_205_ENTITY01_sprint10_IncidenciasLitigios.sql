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

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-746');
	V_TAREA:='HC105_SolicitudPosesionInterina';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_BUSINESS_OPERATION=''DDTipoBienCajamar''' ||
	  ' WHERE TFI_NOMBRE=''comboBien'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-746');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-747');
	V_TAREA:='H065_registrarPresentacionEscrituraSub';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">A través de esta tarea deberá de informar la fecha de presentación en Notaría de la escritura devuelta por el Registrador para su subsanación.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzará la tarea "Entregar nueva escritura publica de propiedad".</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-747');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-615');
	V_TAREA:='H011_LecturaInstruccionesMoratoria';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_ERROR_VALIDACION=NULL ' ||
	  ' ,TFI_VALIDACION=NULL ' ||
	  ' WHERE TFI_NOMBRE=''instruccionesMoratoria'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-615');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-744');
	V_TAREA:='H048_ResolucionFirme';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''vieneDeTramitePosesion() ? (valores[''''H048_RegistrarResolucion''''][''''comboResultado''''] == DDPositivoNegativo.NEGATIVO ? ''''desfavorable'''' : ''''favorable'''') : ''''desfavorableNTP'''''' WHERE TAP_CODIGO = '''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-744');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-741');
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			' SET TAP_SCRIPT_VALIDACION = ''comprobarExisteDocumentoESRAS() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento "Diligencia de se&ntilde;alamiento Edicto de subasta".</div>'''''' ' ||
			' WHERE TAP_CODIGO = ''H002_SenyalamientoSubasta'' ';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-741');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-661');
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			' SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''H022_ConfirmarAdmisionDemanda''''][''''comboResultado''''] == DDSiNo.SI ? comprobarExisteDocumentoADEM() ? null : ''''Es necesario adjuntar el documento Auto Despachando Ejecuci&oacute;n del P. Monitorio.'''' : null'' ' ||
			' WHERE TAP_CODIGO = ''H022_ConfirmarAdmisionDemanda'' ';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			' SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''H022_ConfirmarOposicionCuantia''''][''''comboResultado''''] == DDSiNo.SI ? comprobarExisteDocumentoEOM() ? null : ''''Es necesario adjuntar el documento Escrito de Oposici&oacute;n del P. Monitorio.'''' : null'' ' ||
			' WHERE TAP_CODIGO = ''H022_ConfirmarOposicionCuantia'' ';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-661');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-603');
	V_TAREA:='H015_RegistrarSolicitudPosesion';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Antes de dar por completada esta tarea deber&aacute; de haber un bien vinculado al procedimiento, esto podr&aacute; comprobarlo a trav&eacute;s de la pestaña Bienes del procedimiento, en caso de no haberlo, a trav&eacute;s de esa misma pestaña dispone de la opci&oacute;n de Agregar por la cual se le permite vincular un bien al procedimiento.</p><p style="margin-bottom: 10px">A trav&eacute;s de esta tarea deber&aacute; de informar si hay una posible posesi&oacute;n o no. En caso de que no sea posible la posesión deber&aacute; anotar si existe un contrato de arrendamiento v&aacute;lido vinculado al bien. En caso de que proceda, la fecha de solicitud de la posesi&oacute;n, si el bien se encuentra ocupado o no, si se ha producido una petici&oacute;n de moratoria y en cualquier caso se deber&aacute; informar la condici&oacute;n del bien respecto a si es vivienda habitual o no.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla y dependiendo de la informaci&oacute;n registrada se lanzar&aacute;:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">En caso de haber solicitud de moratoria de posesi&oacute;n se iniciar&aacute; el tr&aacute;mite para tal efecto.</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de encontrarse el bien con ocupantes, se lanzar&aacute; el tr&aacute;mite de ocupantes.</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de encontrarse el bien sin ocupantes, se lanzar&aacute; la tarea "Registrar señalamiento de la posesi&oacute;n".</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de que haya indicado que existe un contrato v&aacute;lido, se lanzar&aacute; la tarea Confirmar notificaci&oacute;n deudor.</li><li style="margin-bottom: 10px; margin-left: 35px;">En el caso de que el bien no est&eacute; en ninguna de las situaciones expuestas y no haya una posible posesi&oacute;n, se le abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</li></ul></div>'' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''|| V_TAREA ||''')';

	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-603');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-753');
	V_TAREA:='H016_confAdmiDecretoEmbargo';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL=''valores[''''H016_interposicionDemandaMasBienes''''][''''comboPlaza'''']'' WHERE TFI_NOMBRE=''comboPlaza'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''|| V_TAREA ||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW = ''plugin/cajamar/tramiteCambiario/confAdmiDecretoEmbargo'' WHERE TAP_CODIGO = '''|| V_TAREA ||'''';
	
	V_TAREA:='H016_interposicionDemandaMasBienes';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW = ''plugin/cajamar/tramiteCambiario/interposicionDemanda'' WHERE TAP_CODIGO = '''|| V_TAREA ||'''';
	
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-753');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-754');
	V_TAREA:='H016_confNotifRequerimientoPago';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = ''((valores[''''H016_confNotifRequerimientoPago''''][''''comboResultado''''] == DDPositivoNegativo.POSITIVO) && (valores[''''H016_confNotifRequerimientoPago''''][''''fecha''''] == null))?''''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'''':null'' WHERE TAP_CODIGO=''H016_confNotifRequerimientoPago''';

	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-754');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-684');
	
	V_TAREA:='H044_RegistrarResultadoInvestigacion';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = NULL, TAP_SCRIPT_VALIDACION_JBPM = ''((valores[''''H044_RegistrarResultadoInvestigacion''''][''''comboRegistro''''] == DDPositivoNegativo.POSITIVO) && (valores[''''H044_RegistrarResultadoInvestigacion''''][''''comboAgTribut''''] == '''''''') && (valores[''''H044_RegistrarResultadoInvestigacion''''][''''comboSegSocial''''] == '''''''') && (valores[''''H044_RegistrarResultadoInvestigacion''''][''''comboCatastro''''] == '''''''') && (valores[''''H044_RegistrarResultadoInvestigacion''''][''''comboAyto''''] == '''''''') && (valores[''''H044_RegistrarResultadoInvestigacion''''][''''comboOtros''''] == '''''''') )?''''tareaExterna.error.H044_RegistrarImpugnacion.algunComboObligatorio'''': valores[''''H044_RegistrarResultadoInvestigacion''''][''''comboRegistro''''] == DDPositivoNegativo.POSITIVO && !comprobarExisteDocumentoDRO() ? ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento registrado de cada Organismo.</div>'''' : null'' WHERE TAP_CODIGO = '''||V_TAREA||'''';
	
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-684');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-772');
	
	V_TAREA:='H024_ConfirmarAdmision';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = NULL, TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''H024_ConfirmarAdmision''''][''''comboResultado''''] == DDSiNo.SI && !comprobarExisteDocumentoADEO() ? ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento Auto Despachando Ejecuci&oacute;n del P. Ordinario.</div>'''' : null'' WHERE TAP_CODIGO = '''||V_TAREA||'''';

	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-772');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-773');
	
	V_TAREA:='H026_ConfirmarAdmisionDemanda';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = NULL, TAP_SCRIPT_VALIDACION_JBPM = ''(valores['''''||V_TAREA||'''''][''''comboAdmisionDemanda''''] == DDSiNo.SI) && (valores[''''H026_ConfirmarAdmisionDemanda''''][''''numJuzgado''''] == null) ? ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe poner el n&uacute;mero de juzgado</div>'''': valores['''''||V_TAREA||'''''][''''comboAdmisionDemanda''''] == DDSiNo.SI && !comprobarExisteDocumentoADEV() ? ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento Auto Despachando Ejecuci&oacute;n del P. Verbal.</div>'''' : null'' WHERE TAP_CODIGO = '''||V_TAREA||'''';

	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-773');
		
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-774');
	
	V_TAREA:='H042_ResolucionFirme';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS SET DD_PTP_PLAZO_SCRIPT = ''(valores[''''H042_RegistrarResolucionVista''''] != null ? damePlazo(valores[''''H042_RegistrarResolucionVista''''][''''fecha'''']) : 0) + 5*24*60*60*1000L'' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TAREA||''')';

	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-774');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-775');
	
	V_TAREA:='H036_CelebracionSubasta';
	EXECUTE IMMEDIATE 'DELETE FROM TFI_TAREAS_FORM_ITEMS WHERE TFI_NOMBRE IN (''adjudicacionEntidad'', ''cesionRemate'', ''adjudicacionAUnTercero'') AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TAREA||''')';

	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ORDEN = 3 WHERE TFI_NOMBRE = ''comboMotivoSuspension'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ORDEN = 4 WHERE TFI_NOMBRE = ''observaciones'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TAREA||''')';

	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-775');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-776');
	
	V_TAREA:='H036_CelebracionSubasta';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = ''valores['''''||V_TAREA||'''''][''''celebrada''''] == DDSiNo.NO ? (valores['''''||V_TAREA||'''''][''''comboMotivoSuspension''''] == null ? ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">El campo Motivo suspensi&oacute;n es obligatorio</div>'''' : null) : (validarBienesCelebracionSubasta() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe rellenar en cada bien los datos de adjudicaci&oacute;n o de cesi&oacute;n remate</div>'''')'' WHERE TAP_CODIGO = '''||V_TAREA||'''';

	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-776');

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-777');
	
	V_TAREA:='H036_CelebracionSubasta';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = ''!comprobarExisteDocumentoASU() ? ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el Acta de subasta</div>'''' : null'' WHERE TAP_CODIGO = '''||V_TAREA||'''';

	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-777');

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