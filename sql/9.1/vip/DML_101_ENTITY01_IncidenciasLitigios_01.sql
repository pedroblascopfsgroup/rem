--/*
--##########################################
--## AUTOR=Alberto Campos
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TAREA VARCHAR(50 CHAR);
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-658');
	V_TAREA:='H016_interposicionDemandaMasBienes';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO tap SET tap.TAP_SCRIPT_VALIDACION = ''!asuntoConProcurador() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'''' : !comprobarExisteDocumentoEDH() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>Es necesario adjuntar el Escrito de la demanda completo + copia sellada de la demanda.</p></div>'''' : tieneBienes() && !isBienesConFechaSolicitud() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><div id="permiteGuardar"><p>&iexcl;Atenci&oacute;n! En  caso de que haya bienes a embargar, deber&iacute;a de marcarlos a trav&eacute;s de la pesta&ntilde;a Bienes dentro de la ficha de la propia actuaci&oacute;n.</p></div></div>'''' : null'' WHERE tap.TAP_CODIGO = '''|| V_TAREA ||'''';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Informar fecha de presentaci&oacute;n de la demanda y la plaza del juzgado.</p><p style="margin-bottom: 10px">Se ha de indicar la fecha de cierre de la deuda junto con el principal de la demanda, el capital vencido, capital no vencido, juntos con los intereses ordinarios y de demora que se han generado en el cierre.</p><p style="margin-bottom: 10px">Deber&aacute; adjuntar como documento obligatorio el escrito de la demanda.</p><p style="margin-bottom: 10px">Usted debe introducir la fecha de solicitud de embargo para cada uno de los bienes en la pestaña de "Bienes".</p><p style="margin-bottom: 10px">En el campo "Solicitar provisi&oacute;n de fondos" deber&aacute; indicar si va a solicitar o no provisi&oacute;n de fondos.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Auto Despachando ejecuci&oacute;n + Marcado de bienes decreto embargo" y si ha marcado que requiere provisi&oacute;n de fondos, se lanzar&aacute; el "Tr&aacute;mite de solicitud de fondos".</p></div>'' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''|| V_TAREA ||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW = ''plugin/procedimientos-bpmHaya-plugin/tramiteCambiario/interposicionDemanda'' WHERE TAP_CODIGO = '''|| V_TAREA ||'''';
	
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-658');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-637');
	V_TAREA:='H002_CelebracionSubasta';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = ''comprobarExisteDocumentoACS() ? null  : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento Acta de subasta</div>'''''', TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''H002_CelebracionSubasta''''][''''comboCelebrada''''] == DDSiNo.NO ? (valores[''''H002_CelebracionSubasta''''][''''comboDecisionSuspension''''] == null ? ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">El campo Decisi&oacute;n suspensi&oacute;n es obligatorio</div>'''' : null) : (validarBienesCelebracionSubasta() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe rellenar en cada bien los datos de adjudicaci&oacute;n o de cesi&oacute;n remate</div>'''')'' WHERE TAP_CODIGO = '''|| V_TAREA ||'''';

	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-637');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-659');
	V_TAREA:='H022_InterposicionDemanda';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = ''!asuntoConProcurador() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'''' : comprobarExisteDocumentoEDCSDE() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el Escrito de demanda completo + copia sellada de la demanda.</div>'''''' WHERE TAP_CODIGO = '''|| V_TAREA ||'''';

	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-659');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-635');
	V_TAREA:='H065_registrarPresentacionEscrituraSub';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS SET DD_PTP_PLAZO_SCRIPT = ''(valoresBPMPadre[''''H066_registrarInscripcionTitulo''''] != null ? (valoresBPMPadre[''''H066_registrarInscripcionTitulo''''][''''fechaEnvio''''] != '''''''') ? (damePlazo(valoresBPMPadre[''''H066_registrarInscripcionTitulo''''][''''fechaEnvio'''']) + 5*24*60*60*1000L) : 10*24*60*60*1000L : 10*24*60*60*1000L)'' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''|| V_TAREA ||''')';

	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-635');

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-662');
	V_TAREA:='H028_RegistrarResolucion';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' || ' SET TAP_SCRIPT_VALIDACION = ''comprobarExisteDocumentoREVM() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Debe adjuntar el documento "Resoluci&oacute;n del Juzgado".</div>'''''' WHERE TAP_CODIGO = '''|| V_TAREA ||''' ';
	
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-662');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-663');
	V_TAREA:='H022_ConfirmarOposicionCuantia';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW = ''plugin/procedimientos-bpmHaya-plugin/procedimientoMonitorio/confirmarOposicionCuantia'' WHERE TAP_CODIGO = '''|| V_TAREA ||'''';
	
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-663');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-668');
	V_TAREA:='H024_ConfirmarOposicion';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = NULL, TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''H024_ConfirmarOposicion''''][''''comboResultado''''] == DDSiNo.SI ? comprobarExisteDocumentoEOO() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento Escrito de Oposici&oacute;n del P. Ordinario.</div>'''': null'' WHERE TAP_CODIGO = '''|| V_TAREA ||'''';
	
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-668');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-675');
	V_TAREA:='H007_Impugnacion';
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW = ''plugin/procedimientos-bpmHaya-plugin/tramiteCostas/impugnacion'' WHERE TAP_CODIGO = '''|| V_TAREA ||'''';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ERROR_VALIDACION = NULL, TFI_VALIDACION = NULL WHERE TFI_NOMBRE IN (''fechaImpugnacion'', ''vistaImpugnacion'', ''comboResultado'') AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''|| V_TAREA ||''')';
	
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-675');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-676');
	V_TAREA:='H007_ConfirmarNotificacion';
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW = ''plugin/procedimientos-bpmHaya-plugin/tramiteCostas/confirmarNotificacion'' WHERE TAP_CODIGO = '''|| V_TAREA ||'''';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ERROR_VALIDACION = NULL, TFI_VALIDACION = NULL WHERE TFI_NOMBRE = ''fecha'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''|| V_TAREA ||''')';
	
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-676');

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-678');
	V_TAREA:='H032_ResolucionFirme';

	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''H032_RegistrarResolucion''''][''''resultado''''] == DDFavorable.FAVORABLE && valores[''''H032_ConfirmarPresImpugnacion''''][''''tipoImpugnacion''''] == ''''IND'''' ? ''''desfavorable'''' : ''''favorable'''''' WHERE TAP_CODIGO = '''|| V_TAREA ||'''';
	
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-678');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-681');
	V_TAREA:='H038_ConfirmarRequerimientoResultado';

	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION=''valores[''''H038_ConfirmarRequerimientoResultado''''][''''comboRequerido''''] == DDSiNo.NO ? ''''ConfirmadoNo'''' : valores[''''H038_ConfirmarRequerimientoResultado''''][''''comboResultado''''] == DDPositivoNegativo.NEGATIVO ? ''''ConfirmadoSi'''' : ''''ConfirmadoPositivo'''''' WHERE TAP_CODIGO = '''|| V_TAREA ||'''';

	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-681');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-491');
	V_TAREA:='H015_RegistrarPosesionYLanzamiento';
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''H015_RegistrarPosesionYLanzamiento''''][''''comboOcupado''''] == DDSiNo.SI ? ''''conOcupantes'''' : ''''sinOcupantes'''''' WHERE TAP_CODIGO = '''|| V_TAREA ||'''';

	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-491');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-772');
	V_TAREA:='H009_RegistrarProyectoInventario';
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL= ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se deber&aacute; informar la fecha con la que se nos comunica mediante correo electr&oacute;nico por la Administraci&oacute;n Concursal el proyecto de inventario.</p><p style="margin-bottom: 10px">Igualmente, deberemos informar si es favorable o desfavorable a los intereses de la Entidad el proyecto remitido por la Administraci&oacute;n Concursal. En el caso de que sea favorable, se deber&aacute; esperar a la siguiente tarea sobre el informe presentado por la Administraci&oacute;n Concursal ante el juez.</p><p style="margin-bottom: 10px">En el caso de que sea desfavorable, deber&aacute; comprobar si el error ha sido cometido por la Entidad a la hora de elaborar la insinuaci&oacute;n de cr&eacute;ditos. Si la insinuaci&oacute;n ha sido incorrecta deber&aacute; ponerse en contacto con la Administraci&oacute;n Concursal para su aclaraci&oacute;n. Con independencia de que sea aclarada o no la discrepancia con la Administraci&oacute;n Concursal, se deber&aacute; remitir igualmente correo electr&oacute;nico a la Administraci&oacute;n Concursal solicitando su subsanaci&oacute;n para su constancia por escrito, haciendo menci&oacute;n en su caso de la aclaraci&oacute;n efectuada previamente.</p><p style="margin-bottom: 10px">En todo caso, tanto si el proyecto es favorable como desfavorable, deberemos modificar el estado de todos los cr&eacute;ditos al estado "3. Pendiente revisi&oacute;n IAC" para completar esta tarea.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Registrar informe de la administraci&oacute;n concursal".</p></div>'' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''|| V_TAREA ||''')';
	
	V_TAREA:='H009_PresentacionAdenda';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL= ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; revisar si procede presentar adenda seg&uacute;n el gestor del concurso.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla:<ul style="list-style-type:square;margin-left:35px;"><li>Si ha decidido no presentar adenda, se iniciar&aacute; la tarea "Actualizar estados de los cr&eacute;ditos insinuados".</li><li>Si ha decidido presentar adenda se lanzar&aacute; la tarea "Presentaci&oacute;n en el juzgado".</li></ul></p></div>'' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''|| V_TAREA ||''')';

	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-772');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-725');
	V_TAREA:='CJ004_ConfirmarRecepcionMandamientoDePago';
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS SET DD_PTP_PLAZO_SCRIPT = ''damePlazo(valores[''''CJ004_SolicitarMandamientoPago''''][''''fecha'''']) + 10*24*60*60*1000L'' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''|| V_TAREA ||''')';
	
	V_TAREA:='CJ004_CelebracionSubasta';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_BUSINESS_OPERATION = ''DDSiNo'' WHERE TFI_NOMBRE = ''comboOtorgamiento'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''|| V_TAREA ||''')';

	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-725');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-728');
	V_TAREA:='CJ005_CelebracionReunion';

	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; indicar la fecha en la que se celebra la reuni&oacute;n, su resultado y si ha habido consentimiento o no por parte de la entidad.</p><p style="margin-bottom: 10px">Deber&aacute; notificar a la oficina del resultado de la reuni&oacute;n a trav&eacute;s del bot&oacute;n "Anotaci&oacute;n".</p><p style="margin-bottom: 10px">En caso de que el resultado sea positivo deber&aacute; notificar a Administración contable  (administracioncontab@cajamar.int).</p><p style="margin-bottom: 10px">En caso de que haya consentimiento deber&aacute; notificar, adem&aacute;s, a An&aacute;lisis de recuperaciones (AnalisisdeRecuperacion@cajamar.int) y Asesor&iacute;a concursal (ServiciosJuridicosConcursal@bcc.es)</p><p style="margin-bottom: 10px">En caso de resultado negativo deber&aacute; enviar una notificaci&oacute;n a Administraci&oacute;n Contable (administracioncontab@cajamar.int), Asesor&iacute;a concursal (ServiciosJuridicosConcursal@bcc.es), a HRE (HAYA–PRECONTENCIOSO-CONCURSAL@cajamar.int) y al Staff de consultor&iacute;a (StaffJuridicoConsultoriayContratacion@cajamar.int)</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellena esta pantalla:<ul style="list-style-type:square;margin-left:35px;"><li>Si el resultado ha sido positivo con consentimiento se lanzar&aacute; el "Tr&aacute;mite seguimiento cumplimiento acuerdo".</li><li>Si adem&aacute;s del resultado positivo no ha habido consentimiento, se lanzar&aacute; en paralelo la tarea "Realizar informe concursal".</li><li>Si el resultado de la reuni&oacute;n ha sido negativo, se lanzar&aacute; la tarea "Apertura concurso consecutivo".</li></ul></p></div>'' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''|| V_TAREA ||''')';
		
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-728');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-729');
	V_TAREA:='H027_RegistrarPublicacionSolArticulo';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL=''<div align="justify" style="margin-bottom: 30px;"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Para dar por terminada esta tarea deberá informar la fecha en que se haya publicado la solicitud del artículo 5bis.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Registrar apertura de negociaciones".</span></font></p></div>'' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''|| V_TAREA ||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-729');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-732');
	
	V_TAREA:='H031_registrarPropAnticipadaConvenio';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL=''<div align="justify" style="margin-bottom: 30px;"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Para dar por terminada esta tarea deberá registrar un convenio de tipo anticipado, para ello deberá abrir la pestaña "Convenios"&nbsp;</span></font><span style="font-size: 10.6666669845581px; font-family: Arial;">de la ficha del asunto correspondiente y &nbsp;registrar un nuevo convenio, introduciendo la descripción de los créditos en el campo "Resumen propuesta convenio anticipado".</span></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">En el campo Fecha indicar la fecha en la que se registra el convenio.</span></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</span></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">Una vez rellene esta pantalla se lanzar&aacute; la tarea "Preparar informe".</span></p></div>'' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''|| V_TAREA ||''')';

	V_TAREA:='H031_ContabilizarConvenio';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se deber&aacute; de informar la fecha en la que ha contabilizado el convenio.</p><p style="margin-bottom: 10px">Deber&aacute; enviar una notificaci&oacute;n a trav&eacute;s de la herramienta al Staff de consultor&iacute;a (StaffJuridicoConsultoriayContratacion@cajamar.int), Administraci&oacute;n contable (administracioncontab@cajamar.int) y Administraci&oacute;n HRE (xxx@cajamar.int) indicando la resoluci&oacute;n del convenio en el caso de que se apruebe el convenio.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla finalizar&aacute; el tr&aacute;mite.</p></div>'' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''|| V_TAREA ||''')';
	
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-732');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-733');
	
	V_TAREA:='CJ002_RegistrarCumplimiento';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; informar la fecha en la que se produce la revisi&oacute;n del acuerdo, informar si se ha cumplido o no dicho acuerdo y por &uacute;ltimo, indicar si se da por finalizado el seguimiento del acuerdo o no.</p><p style="margin-bottom: 10px">En el campo Fecha acuerdo pago el gestor de la tarea podr&aacute; consultar la fecha en la que el deudor debe realizar el pago que se est&aacute; revisando seg&uacute;n el acuerdo alcanzado con &eacute;l.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez finalice esta tarea:<ul style="list-style-type:square;margin-left:35px;"><li>En caso de que se haya producido un incumplimiento de acuerdo se lanzar&aacute; la tarea "Notificar deudor" a la oficina.</li><li>En caso de indicar que finaliza el seguimiento se lanzar&aacute; una tarea al supervisor denominada "Validar fin de seguimiento" para que valide dicha finalizaci&oacute;n.</li><li>En caso de seguir con el seguimiento de acuerdo se volver&aacute; a lanzar esta misma tarea con fecha de vencimiento de a 30 d&iacute;as desde la fecha del siguiente pago.</li><li>En caso de que hayan transcurrido 90 d&iacute;as desde el primer incumplimiento, se cancelar&aacute; el seguimiento del convenio y lanzar&aacute; la tarea "Comunicaci&oacute;n al mediador".</li></ul></p></div>'' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''|| V_TAREA ||''')';

	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-733');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-735');
	
	V_TAREA:='H039_registrarConclusionConcurso';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta tarea deber&aacute; indicar si el concurso definitivamente ha llegado a conclusi&oacute;n o no, as&iacute; como la fecha de tal resoluci&oacute;n.</p><p style="margin-bottom: 10px">En caso de conclusi&oacute;n definitiva, se generar&aacute; una notificación a An&aacute;lisis de recuperaciones (AnalisisdeRecuperacion@cajamar.int) y  al Staff de consultor&iacute;a (StaffJuridicoConsultoriayContratacion@cajamar.int) y administraci&oacute;n contable (administracioncontab@cajamar.int) para que realicen las actuaciones pertinentes.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; para el caso de la no conclusi&oacute;n una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable  de la entidad, para el caso de que s&iacute; haya concluido el concurso se dar&aacute; por finalizado el mismo.</p></div>'' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''|| V_TAREA ||''')';

	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-735');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-734');
	
	V_TAREA:='H025_registrarResolucion';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se deber&aacute; de informar la fecha de notificaci&oacute;n de la Resoluci&oacute;n que hubiere reca&iacute;do.</p><p style="margin-bottom: 10px">Se indicar&aacute; si el resultado de dicha resoluci&oacute;n ha sido favorable para los intereses de la entidad o no.</p><p style="margin-bottom: 10px">Para el supuesto de que la resoluci&oacute;n si fuere favorable, deber&aacute; enviar una  notificaci&oacute;n a Control de Gesti&oacute;n Administraci&oacute;n (xxx@cajamar.int) informando de dicha circunstancia. Adem&aacute;s, se lanzará el Tr&aacute;mite de Costas.</p><p style="margin-bottom: 10px">Para el supuesto de que la resoluci&oacute;n no fuere favorable para la entidad, deber&aacute; notificar dicha circunstancia al responsable interno de la misma a trav&eacute;s del bot&oacute;n "Anotaci&oacute;n". Una vez reciba la aceptaci&oacute;n del supervisor deber&aacute; gestionar el recurso por medio de la pestaña "Recursos".</p><p style="margin-bottom: 10px">Para el supuesto de anuncio del recurso por la parte contraria se deber&aacute; gestionar directamente a trav&eacute;s de la pestaña "Recursos".</p><p style="margin-bottom: 10px">En caso de condena en costas deber&aacute; indicarlo en el campo correspondiente e informar de la cuant&iacute;a. En caso de p&eacute;rdida de garant&iacute;as deber&aacute; indicarlo expresamente as&iacute; como informar del importe de dichas garant&iacute;as rescindidas. En caso de cancelaci&oacute;n de operaci&oacute;n deber&aacute; indicarlo en el campo "Cancelaci&oacute;n operaci&oacute;n". En caso de que la resoluci&oacute;n no fuera favorable por ninguno de los motivos anteriores, deber&aacute; especificar el motivo en el campo Otros.</p><p style="margin-bottom: 10px">En caso de p&eacute;rdida de garant&iacute;a deber&aacute; enviar una notificaci&oacute;n v&iacute;a Recovery a la Unidad de Registro Hipotecario (xxx@cajamar.int).</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Resoluci&oacute;n firme".</p></div>'' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''|| V_TAREA ||''')';
	
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-734');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-682');
	
	V_TAREA:='H043_SalariosDecision';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO = ''H038_SalariosDecision'' WHERE TAP_CODIGO='''|| V_TAREA ||'''';
	
	V_TAREA:='H038_ConfirmarRequerimientoResultado';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''H038_ConfirmarRequerimientoResultado''''][''''comboRequerido''''] == DDSiNo.NO ? ''''ConfirmadoNo'''' : valores[''''H038_ConfirmarRequerimientoResultado''''][''''comboResultado''''] == DDPositivoNegativo.NEGATIVO ? ''''ConfirmadoNo'''' : ''''ConfirmadoPositivo'''''' WHERE TAP_CODIGO='''|| V_TAREA ||'''';
	
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-682');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-603');
	
	V_TAREA:='H015_RegistrarSolicitudPosesion';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Antes de dar por completada esta tarea deber&aacute; de haber un bien vinculado al procedimiento, esto podr&aacute; comprobarlo a trav&eacute;s de la pestaña Bienes del procedimiento, en caso de no haberlo, a trav&eacute;s de esa misma pestaña dispone de la opci&oacute;n de Agregar por la cual se le permite vincular un bien al procedimiento.</p><p style="margin-bottom: 10px">A trav&eacute;s de esta tarea deber&aacute; de informar si hay una posible posesi&oacute;n o no. En caso de que no sea posible la posesi&oacute;n deber&aacute; anotar si existe un contrato de arrendamiento v&aacute;lido vinculado al bien. En caso de que proceda, la fecha de solicitud de la posesi&oacute;n, si el bien se encuentra ocupado o no,  si se ha producido una petici&oacute;n de moratoria y en cualquier caso se deber&aacute; informar la condici&oacute;n del bien respecto a si es vivienda habitual o no.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla y dependiendo de la informaci&oacute;n registrada se lanzar&aacute;:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">En caso de haber solicitud de moratoria de posesi&oacute;n se iniciar&aacute; el tr&aacute;mite para tal efecto.</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de encontrarse el bien con ocupantes, se lanzar&aacute; el tr&aacute;mite de ocupantes.</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de encontrarse el bien sin ocupantes, se lanzar&aacute; la tarea "Registrar señalamiento de la posesi&oacute;n".</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de que haya indicado que existe un contrato v&aacute;lido, se lanzar&aacute; la tarea Confirmar notificaci&oacute;n deudor.</li><li style="margin-bottom: 10px; margin-left: 35px;">En el caso de que el bien no est&eacute; en ninguna de las situaciones expuestas y no haya una posible posesi&oacute;n, se le abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</li></ul></div>'' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''|| V_TAREA ||''')';
	
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-603');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-683');
	
	V_TAREA:='H042_ValidarLiquidacionIntereses';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''DEL_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''GONZALO'' WHERE TAP_CODIGO='''||V_TAREA||'''';

	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-683');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-684');
	
	V_TAREA:='H042_ValidarLiquidacionIntereses';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = NULL, TAP_SCRIPT_VALIDACION_JBPM = ''((valores[''''H044_RegistrarResultadoInvestigacion''''][''''comboRegistro''''] == DDPositivoNegativo.POSITIVO) && (valores[''''H044_RegistrarResultadoInvestigacion''''][''''comboAgTribut''''] == '''''''') && (valores[''''H044_RegistrarResultadoInvestigacion''''][''''comboSegSocial''''] == '''''''') && (valores[''''H044_RegistrarResultadoInvestigacion''''][''''comboCatastro''''] == '''''''') && (valores[''''H044_RegistrarResultadoInvestigacion''''][''''comboAyto''''] == '''''''') && (valores[''''H044_RegistrarResultadoInvestigacion''''][''''comboOtros''''] == '''''''') )?''''tareaExterna.error.H044_RegistrarImpugnacion.algunComboObligatorio'''': valores[''''H044_RegistrarResultadoInvestigacion''''][''''comboRegistro''''] == DDPositivoNegativo.POSITIVO && !comprobarExisteDocumentoDRO() ? ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento registrado de cada Organismo.</div>'''' : null'' WHERE TAP_CODIGO = '''||V_TAREA||'''';
	
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-684');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-696');
	
	V_TAREA:='H036_DictarInstruccionesSubasta';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL=''valores[''''H036_ElevarPropuestaAComite''''] != null && valores[''''H036_ElevarPropuestaAComite''''][''''comboResultado''''] != null && valores[''''H036_ElevarPropuestaAComite''''][''''comboResultado''''] == ''''SUS'''' ? DDSiNo.SI : DDSiNo.NO'' WHERE TFI_NOMBRE=''comboSuspension'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';

	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-696');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-609');
	
	V_TAREA:='H048_ResolucionFirme';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''vieneDeTramitePosesion() ? ''''desfavorableTP'''' : ''''desfavorable'''''' WHERE TAP_CODIGO = '''||V_TAREA||'''';

	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-609');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-697');
	
	V_TAREA:='H036_DictarInstruccionesSubasta';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''H036_ElevarPropuestaAComite''''] != null && valores[''''H036_ElevarPropuestaAComite''''][''''comboResultado''''] != null && valores[''''H036_ElevarPropuestaAComite''''][''''comboResultado''''] == ''''SUS'''' ? ''''suspender'''' : ''''continuar'''''' WHERE TAP_CODIGO = '''||V_TAREA||'''';
	
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-697');
	
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