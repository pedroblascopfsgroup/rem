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

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-547');
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
          ' SET TAP_SCRIPT_VALIDACION = ''comprobarMinimoBienLote() ? (comprobarBienesSolitudSubasta() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Todos los bienes incluidos los lotes de la subasta deben tener informado la informaci&oacute;n de las cargas, si es vivienda habitual y la situaci&oacute;n posesoria.</div>'''') : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Al menos un bien debe estar asignado a un lote</div>'''''' ' ||
          ' WHERE TAP_CODIGO = ''H002_SolicitudSubasta'' ';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
          ' SET TAP_SCRIPT_VALIDACION = ''comprobarExisteDocumentoESRAS() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento Edicto de subasta y resoluci&oacute;n acordando se&ntilde;alamiento</div>'''' '' ' ||
          ' WHERE TAP_CODIGO = ''H002_SenyalamientoSubasta'' ';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			' SET TAP_SCRIPT_VALIDACION = ''comprobarMinimoBienLote() ? (comprobarExisteDocumentoESRAS() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento Edicto de subasta y resoluci&oacute;n acordando se&ntilde;alamiento</div>'''') : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Al menos un bien debe estar asignado a un lote</div>'''' '' ' ||
			' WHERE TAP_CODIGO = ''H004_SenyalamientoSubasta'' ';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-547');

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-642');
	V_TAREA:='H004_LecturaConfirmacionInstrucciones';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS' ||
          ' SET DD_PTP_PLAZO_SCRIPT = ''damePlazo(valores[''''H004_SenyalamientoSubasta''''][''''fechaSenyalamiento''''])-3*24*60*60*1000L''' ||
          ' WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-642');
	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-615');
	V_TAREA:='H048_TrasladoDocuDeteccionOcupantes';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_TIPO=''combo'' ' ||
	  ' ,TFI_BUSINESS_OPERATION=''DDSiNo'' ' ||
	  ' ,TFI_VALOR_INICIAL=''valores[''''H011_RevisarInformeLetradoMoratoria''''][''''comboConformidad'''']'' ' ||
	  ' WHERE TFI_NOMBRE=''presentarAlegaciones'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-615');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-602');
	V_TAREA:='H015_SuspensionLanzamiento';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_ERROR_VALIDACION=''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio''' ||
	  ' ,TFI_VALIDACION=''valor != null && valor != '''''''' ? true : false''' ||
	  ' WHERE TFI_NOMBRE=''fechaParalizacion'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-602');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-657');
	V_TAREA:='H062_confirmarAnotacionRegistro';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">En esta pantalla se ha de informar la fecha de anotación de los embargos trabados en el Registro de la Propiedad correspondiente.</p><p style="margin-bottom: 10px">Para el supuesto de la existencia de embargo de varios bienes y que estos se encuentren inscritos en diferentes Registros de la Propiedad, se deberá informar en esta pantalla únicamente el de la anotación del primero de ellos. Se deberá abrir la pestaña de "Bienes" para introducir la fecha de anotación en el Registro de la Propiedad de cada uno de los bienes embargados.</p><p style="margin-bottom: 10px">En el caso de que no se haya admitido el registro de alguno de los embargos solicitados, informelo en observaciones.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Para finalizar la tarea, deberá adjuntar a través de la pestaña de Adjuntos, el mandamiento de embargo inscrito.</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-657');

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-656');
	V_TAREA:='H044_RegistrarResultadoInvestigacion';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Dado que hemos solicitado anteriormente la averiguación de la solvencia del ejecutado, en esta pantalla se persigue la identificación del resultado de la misma, debiéndose informar en cada campo lo que proceda en virtud del resultado obtenido en función de la contestación de cada uno de los organismos que se señalan en los diferentes campos que se ofrecen, o bien indicar en el campo de "otros", el resultado de la meritada gestión.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento. En el presente caso en el campo observaciones se deberá identificar el resultado positivo si se hubiere marcado alguno de ellos, ya sean bienes inmuebles, muebles, salarios, etc.</p><p style="margin-bottom: 10px">En caso de que el resultado fuese positivo, la siguiente tarea será "Revisar resultado investigación y actualización de datos". En caso contrario, se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-656');

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-655');
	V_TAREA:='H042_RegistrarResolucionVista';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="font-family: Arial; font-size: medium; margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Se deberá informar la fecha de resolución de la vista..</span></font></p><p style="font-family: Arial; font-size: medium; margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Se indicará si el resultado de dicha resolución ha sido favorable para los intereses de la entidad o no.</span></font></p><p style="font-family: Arial; font-size: medium; margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Para el supuesto de que la resolución no fuere favorable para la entidad, deberá notificar dicha circunstancia al responsable interno de la misma a través del botón "Anotación". Una vez reciba la aceptación del supervisor deberá gestionar el recurso por medio de la pestaña "Recursos".</span></font></p><p style="font-family: Arial; font-size: medium; margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Para el supuesto de anuncio del recurso por la parte contraria se deberá gestionar directamente a través de la pestaña "Recursos".</span></font></p><p style="font-family: Arial; font-size: medium; margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></font></p><p style="font-family: Arial; font-size: medium; margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Una vez rellene esta pantalla se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</span></font></p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-655');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-654');
	V_TAREA:='H038_SolicitarNotificacion';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que se ha procedido al embargo, por parte del juzgado, de salario del ejecutado, en esta pantalla, se ha de informar la fecha del escrito presentado para la notificaci&oacute;n de tal extremo al pagador, con solicitud de que informe de la base sobre la que se va a realizar la retenci&oacute;n.</p><p style="margin-bottom: 10px">En el segundo campo se deber&aacute;, cuando se conozca, establecer el importe sobre el que se ha de practicar la retenci&oacute;n.</p><p style="margin-bottom: 10px">En el tercer campo de esta pantalla se ha de informar el importe de la retenci&oacute;n que, sobre la base, se practica y que es consignada en el juzgado, en la cuenta de consignaciones del mismo.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute; &quot;Confirmar requerimiento y resultado&quot;</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-654');
	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-653');
	V_TAREA:='H032_RegistrarSolCostasContrario';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debemos de informar la fecha de celebración de la vista.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	V_TAREA:='H032_ConfirmarPresImpugnacion';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">En esta pantalla debemos informar la fecha de presentación en el Juzgado del escrito de impugnación de la oposición presentada por el contrario.</p><p style="margin-bottom: 10px">El campo de fecha de vista, para los supuestos en los que se señale que el tipo de impugnación sea por costas indebidas y/o ambas, provocará que la siguiente tarea sea registrar celebración de la misma.</p><p style="margin-bottom: 10px">En el caso de que el motivo de la impugnación de costas sea por considerar éstas excesivas la siguiente tarea será "Registrar Resolución".</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será "Registrar celebración vista", si el tipo de impugnación señalado sea por costas indebidas o ambas. En caso de que el tipo de impugnación sea excesivas, la siguiente tarea será "Registrar resolución".</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	V_TAREA:='H032_ResolucionFirme';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Se deberá informar la fecha en la que la Resolución adquiere firmeza. En el momento se obtenga el testimonio de firmeza deberá adjuntarlo como documento acreditativo, aunque no tiene carácter obligatorio para la finalización de la tarea.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla, en caso de que la resolución sea favorable por Indebida, se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad. En el caso de que la resolución sea Desfavorable o favorable por excesiva, la siguiente tarea será "Registrar pago".</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-653');

	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-652');
	V_TAREA:='H064_solicitarAutorizacionConsignacionSareb';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&aacute; adjuntar al procedimiento el documento por el que requiere la autorizaci&oacute;n para la consignaci&oacute;n e informar de la fecha en la que realiza la solicitud.</p><p style="margin-bottom: 10px">En el campo Observaciones informar de cualquier aspecto relevante que le interesa quede reflejado en ese punto.</p><p style="margin-bottom: 10px">La siguiente tarea será "Resultado de la solicitud de consignación".</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	V_TAREA:='H064_resultadoSolicitudConsignacion';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; dejar constancia del resultado de la solicitud de consignaci&oacute;n formulada por el letrado, as&iacute; como la fecha en la que toma esta decisi&oacute;n.</p><p style="margin-bottom: 10px">En el campo Observaciones informar de cualquier aspecto relevante que le interesa quede reflejado en ese punto.</p><p style="margin-bottom: 10px">En el caso que el resultado sea aceptada, se lanzará  la tarea "Confirmar la realización de la consignación" y, en el caso que el resultado fuera denegada, se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	V_TAREA:='H064_confirmarRealizacionConsignacion';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&aacute; realizar la consignaci&oacute;n mediante el pago correspondiente y deber&aacute; adjuntar el justificante de pago para que el letrado pueda presentar al juzgado a partir de ese momento.</p><p style="margin-bottom: 10px">En el campo Observaciones informar de cualquier aspecto relevante que le interesa quede reflejado en ese punto.</p><p style="margin-bottom: 10px">La siguiente tarea será "Presentación en el juzgado".</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	V_TAREA:='H064_presentacionJuzgado';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&aacute; presentar en el Juzgado en tiempo y forma la presentaci&oacute;n de la consignaci&oacute;n adjuntando el escrito en el Juzgado como documento que acredite este hecho.</p><p style="margin-bottom: 10px">En el campo Observaciones informar de cualquier aspecto relevante que le interesa quede reflejado en ese punto.</p><p style="margin-bottom: 10px">Una vez completada esta tarea, finalizará el trámite.</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-652');

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-651');
	V_TAREA:='H028_ResolucionFirme';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS' ||
          ' SET DD_PTP_PLAZO_SCRIPT = ''damePlazo(valores[''''H028_RegistrarResolucion''''][''''fecha'''']) + 20*24*60*60*1000L''' ||
          ' WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-651');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-650');
	V_TAREA:='H028_RegistrarResolucion';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">En esta pantalla se deberá de informar la fecha de notificación de la resolución que hubiere recaído como consecuencia de la vista celebrada y adjuntar la resolución como documento obligatorio para dar por finalizada la tarea.</p><p style="margin-bottom: 10px">Se indicará si el resultado de dicha resolución ha sido favorable para los intereses de la entidad o no.</p><p style="margin-bottom: 10px">Para el supuesto de que la resolución no fuere favorable para la entidad, deberá notificar dicha circunstancia al responsable interno de la misma a través del botón "Anotación". Una vez reciba la aceptación del supervisor deberá gestionar el recurso por medio de la pestaña "Recursos".</p><p style="margin-bottom: 10px">Para el supuesto de anuncio del recurso por la parte contraria se deberá gestionar directamente a través de la pestaña "Recursos".</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellené esta pantalla la siguiente tarea será "Resolución firme"</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	V_TAREA:='H028_ResolucionFirme';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Se deberá informar la fecha en la que la Resolución adquiere firmeza. En el momento se obtenga el testimonio de firmeza deberá adjuntarlo como documento acreditativo, aunque no tiene caracter obligatorio para la finalización de la tarea.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-650');
	

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-649');
	V_TAREA:='H026_InterposicionDemanda';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Informar fecha de presentación de la demanda. Indíquese la plaza del juzgado y procurador que representa a la entidad.</p><p style="margin-bottom: 10px">Se ha de indicar la fecha de cierre de la deuda junto con el principal de la demanda, el capital vencido, juntos con los intereses ordinarios y de demora que se han generado en el cierre.</p><p style="margin-bottom: 10px">En el campo "Solicitar provisión de fondos" deberá indicar va a solicitar o no provisión de fondos.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será "Confirmar admisión de la demanda" y si ha marcado que requiere provisión de fondos, se lanzará el "Trámite de solicitud de fondos".</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	V_TAREA:='H026_RegistrarJuicio';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">En esta pantalla debemos de informar la fecha de celebración del juicio.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será "Registrar resolución".</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	V_TAREA:='H026_RegistrarResolucion';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">En esta pantalla se deberá de informar la fecha de notificación de la resolución que hubiere recaído como consecuencia de la vista celebrada y, adjuntar la resolución del juzgado.</p><p style="margin-bottom: 10px">Se indicará si el resultado de dicha resolución ha sido favorable para los intereses de la entidad o no.</p><p style="margin-bottom: 10px">Para el supuesto de que la resolución no fuere favorable para la entidad, deberá notificar dicha circunstancia al responsable interno de la misma a través del botón "Anotación". Una vez reciba la aceptación del supervisor deberá gestionar el recurso por medio de la pestaña "Recursos".</p><p style="margin-bottom: 10px">Para el supuesto de anuncio del recurso por la parte contraria se deberá gestionar directamente a través de la pestaña "Recursos".</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será "Resolución firme".</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	V_TAREA:='H026_ResolucionFirme';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Se deberá informar la fecha en la que la Resolución adquiere firmeza. En el momento se obtenga el testimonio de firmeza deberá adjuntarlo como documento acreditativo, aunque no tiene carácter obligatorio para la finalización de la tarea.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-649');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-648');
	V_TAREA:='H024_InterposicionDemanda';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Informar fecha de presentación de la demanda e indíquese la plaza del juzgado.</p><p style="margin-bottom: 10px">Se ha de indicar la fecha de cierre de la deuda junto con el principal de la demanda, el capital vencido, juntos con los intereses ordinarios y de demora que se han generado en el cierre.</p><p style="margin-bottom: 10px">En el campo "Solicitar provisión de fondos" deberá indicar va a solicitar o no provisión de fondos.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será "Confirmar admisión de la demanda" y si ha marcado que requiere provisión de fondos, se lanzará el "Trámite de solicitud de fondos".</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	V_TAREA:='H024_ResolucionFirme';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Se deberá informar la fecha en la que la Resolución adquiere firmeza. En el momento se obtenga el testimonio de firmeza deberá adjuntarlo como documento acreditativo, aunque no tiene carácter obligatorio para la finalización de la tarea.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-648');

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-647');
	V_TAREA:='H024_ResolucionFirme';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS' ||
          ' SET DD_PTP_PLAZO_SCRIPT = ''damePlazo(valores[''''H024_RegistrarResolucion''''][''''fecha'''']) + 20*24*60*60*1000L''' ||
          ' WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-647');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-646');
	V_TAREA:='H022_InterposicionDemanda';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Informar fecha de presentación de la demanda e indíquese la plaza del juzgado.</p><p style="margin-bottom: 10px">Se ha de indicar la fecha de cierre de la deuda junto con el principal de la demanda, el capital vencido, juntos con los intereses ordinarios y de demora que se han generado en el cierre.</p><p style="margin-bottom: 10px">En el campo "Solicitar provisión de fondos" deberá indicar va a solicitar o no provisión de fondos.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será "Confirmar admisión de la demanda" y si ha marcado que requiere provisión de fondos, se lanzará el "Trámite de solicitud de fondos".</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	V_TAREA:='H022_ConfirmarOposicionCuantia';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Una vez notificado al demandado el requerimiento de pago, en esta pantalla ha de indicar si el mismo se ha opuesto o no a la demanda.</p><p style="margin-bottom: 10px">Los campos Nº Procedimiento y Principal vienen predeterminados y son de mera lectura.</p><p style="margin-bottom: 10px">En el supuesto de que exista oposición, deberá informar su fecha de notificación.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será:</p><p style="margin-bottom: 10px">-Si no hay oposición y tras 20 días se lanza automáticamente el trámite de "Ejecución de Título Judicial".</p><p style="margin-bottom: 10px">-Si hay oposición se lanzará un trámite u otro en función de la cuantía del principal. En los casos en los que el importe sea igual o inferior a 6000 euros, se lanzará el Procedimiento Verbal desde Monitorio. En caso contrario, se lanzará el Procedimiento Ordinario.</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-646');

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-645');
	V_TAREA:='H016_interposicionDemandaMasBienes';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Informar fecha de presentación de la demanda y la plaza del juzgado.</p><p style="margin-bottom: 10px">Se ha de indicar la fecha de cierre de la deuda junto con el principal de la demanda, el capital vencido, juntos con los intereses ordinarios y de demora que se han generado en el cierre.</p><p style="margin-bottom: 10px">Deberá adjuntar como documento obligatorio el escrito de la demanda.</p><p style="margin-bottom: 10px">Usted debe introducir la fecha de solicitud de embargo para cada uno de los bienes en la pestaña de "Bienes".</p><p style="margin-bottom: 10px">En el campo "Solicitar provisión de fondos" deberá indicar si va a solicitar o no provisión de fondos.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será "Auto despachando ejecución + marcado de bienes decreto embargo" y si ha marcado que requiere provisión de fondos, se lanzará el "Trámite de solicitud de fondos".</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-645');

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-644');
	V_TAREA:='H058_SolicitarAvaluo';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">En el primer campo debemos indicar la fecha que se nos notifica por el Juzgado el avalúo practicado, se ha de abrir la pestaña "Bienes" y registrar los importes determinados en cada uno de los bienes embargados.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-644');

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-643');
	V_TAREA:='H004_SenyalamientoSubasta';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Una vez comunicada la subasta, en esta pantalla, debe informar de la fecha de notificación y de la fecha de celebración de la subasta e indicar el letrado asignado a esta subasta y el procurador si procede.</p><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deberá acceder a la pestaña Subastas del asunto correspondiente y asociar uno o mas bienes a la subasta que corresponda. Una vez agregados los bienes a la subasta, deberá indicar a través de la ficha del bien las cargas anteriores y posteriores, si es vivienda habitual o no y la situación posesoria.</p><p style="margin-bottom: 10px">Una vez conozca la fecha de celebración de la subasta deberán enviar una anotación a través de la herramienta al supervisor de contencioso gestión.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene ésta pantalla se lanzarán las siguientes tareas:</p><p style="margin-bottom: 10px">-"Celebración subasta".</p><p style="margin-bottom: 10px">-"Revisar documentación”.</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-643');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-641');
	V_TAREA:='H066_registrarEntregaTitulo';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; de informar de la fecha en que recibe la informaci&oacute;n sobre los documentos asignados que se le han enviado.</p><p style="margin-bottom: 10px">Antes de dar por terminada esta tarea deber&aacute;:</p><p style="margin-bottom: 10px; margin-left: 40px;">- Liquidar impuestos  en  plazo  seg&uacute;n CCAA. En caso de personas jur&iacute;dicas existir&aacute; una consulta previa realizada sobre la posible liquidaci&oacute;n de IVA. Esta informaci&oacute;n podr&aacute; consultarla a trav&eacute;s de la ficha de cada uno de los bienes incluidos.</p><p style="margin-bottom: 10px; margin-left: 40px;">- Verificar situaci&oacute;n ocupacional de la finca para manifestaci&oacute;n de libertad arrendamientos de cara a inscripci&oacute;n (LAU).</p><p style="margin-bottom: 10px; margin-left: 40px;">- Redactar en su caso, certificado de Libertad de Arrendamiento (por poder de la Entidad), para presentaci&oacute;n  en el registro junto con el testimonio y los mandamientos.</p><p style="margin-bottom: 10px; margin-left: 40px;">- Realizar notificaci&oacute;n fehaciente a inquilinos para la inscripci&oacute;n  (en casos de inmueble con arrendamiento reconocido)</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzará la tarea “Registrar presentación en hacienda” y, al mismo tiempo, el "Trámite de posesión".</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-642');

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-640');
	V_TAREA:='H020_InterposicionDemandaMasBienes';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Informar fecha de presentaci&oacute;n de la demanda e ind&iacute;quese la plaza del juzgado.</p><p style="margin-bottom: 10px">Se ha de indicar la fecha de cierre de la deuda junto con el principal de la demanda, el capital vencido, capital no vencido, juntos con los intereses ordinarios y de demora que se han generado en el cierre.</p><p style="margin-bottom: 10px">Debe introducir la fecha de solicitud de embargo para cada uno de los bienes en la pesta&ntilde;a de "Bienes".</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">En el campo "Solicitar provisión de fondos" deberá indicar va a solicitar o no provisión de fondos.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será "Auto despachando ejecución + marcado de bienes decreto embargo" y si ha marcado que requiere provisión de fondos, se lanzará el "Trámite de solicitud de fondos".</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-640');

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-639');
	V_TAREA:='H018_InterposicionDemanda';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Informar fecha de presentaci&oacute;n de la demanda. Ind&iacute;quese la plaza y n&uacute;mero de juzgado.</p><p style="margin-bottom: 10px">Usted debe introducir la fecha de solicitud de embargo para cada uno de los bienes en la pesta&ntilde;a de "Bienes".</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será "Auto Despachando ejecución + Marcado de bienes decreto embargo" y si ha marcado que requiere provisión de fondos, se lanzará el "Trámite de solicitud de fondos".</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-639');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-670');
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
          ' SET TAP_SCRIPT_VALIDACION = ''!asuntoConProcurador() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'''' : (comprobarExisteDocumentoEDCSDE() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>Es necesario adjuntar el documento Escrito de demanda completo + copia sellada de la demanda.</p></div>'''')'' ' ||
          ' WHERE TAP_CODIGO = ''H026_InterposicionDemanda'' ';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-670');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-671');
	V_TAREA:='H030_RegistrarCertificacion';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TFI_NOMBRE=''comboResultado'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_ORDEN=''1''' ||
	  ' WHERE TFI_NOMBRE=''fecha'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_ORDEN=''2''' ||
	  ' WHERE TFI_NOMBRE=''observaciones'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-671');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-673');
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
          ' SET TAP_SCRIPT_VALIDACION = ''comprobarExisteDocumentoLIBARR() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Debe adjuntar el documento "Certificado de Libertad de arrendamientos".</div>'''''' ' ||
          ' WHERE TAP_CODIGO = ''HC101_EmitirCertificado'' ';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-673');

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-674');
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
          ' SET TAP_SCRIPT_VALIDACION = ''comprobarExisteDocumentoSOLCONS() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Debe adjuntar el documento "Solicitud de consignaci&oacute;n".</div>'''''' ' ||
          ' WHERE TAP_CODIGO = ''H064_solicitarAutorizacionConsignacionSareb'' ';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-674');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-607');
	V_TAREA:='H048_PresentarEscritoAlegaciones';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS' ||
          ' SET DD_PTP_PLAZO_SCRIPT = ''damePlazo(valores[''''H048_TrasladoDocuDeteccionOcupantes''''][''''fechaFinAle''''])''' ||
          ' WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-607');

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-616');
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
          ' SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''H011_RegistrarAdmisionYEmplazamiento''''][''''comboVista''''] == DDSiNo.SI && valores[''''H011_RegistrarAdmisionYEmplazamiento''''][''''fechaSenyalamiento''''] == null ? ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">La fecha fin de se&ntilde;alamiento es obligatoria</div>'''' : null'' ' ||
          ' WHERE TAP_CODIGO = ''H011_RegistrarAdmisionYEmplazamiento'' ';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-616');

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-677');
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
          ' SET TAP_SCRIPT_VALIDACION = ''comprobarExisteDocumentoDTCCE() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Debe adjuntar el documento "Decreto tasaci&oacute;n costas".</div>'''''' ' ||
          ' WHERE TAP_CODIGO = ''H032_RegistrarDecTasacionCostas'' ';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-677');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-539');
	V_TAREA:='H001_PresentarAlegaciones';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''Fecha comparecencia''' ||
	  ' WHERE TFI_NOMBRE=''fechaComparecencia'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-539');
	
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