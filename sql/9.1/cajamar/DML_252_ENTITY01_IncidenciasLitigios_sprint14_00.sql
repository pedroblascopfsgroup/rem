--/*
--##########################################
--## AUTOR=Gonzalo E
--## FECHA_CREACION=20151026
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.7-hy
--## INCIDENCIA_LINK=VARIAS
--## PRODUCTO=NO
--##
--## Finalidad: Resolución de varias incidencias de Concursos
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
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-900');
	V_TAREA:='H002_CelebracionSubasta';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Una vez se celebre la subasta, en esta pantalla debe introducir la siguiente información:</p><p style="margin-bottom: 10px">-En el campo Celebrada deberá indicar si la subasta ha sido celebrada o no. </p><p style="margin-bottom: 10px">-En caso de haberse celebrado deberá indicar a través de la pestaña Subastas de la ficha del asunto correspondiente, el resultado de la subasta para cada uno de los bienes subastados.</p><p style="margin-bottom: 10px">-En la ficha del bien se debe recoger el resultado de la  adjudicación y el valor de la adjudicación.</p><p style="margin-bottom: 10px">-En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Para dar por terminada esta tarea deberá adjuntar el acta de subasta al procedimiento a través de la pestaña "Adjuntos" y anotar la situación final de cada bien en la ficha del bien.</p><p style="margin-bottom: 10px">La siguiente tarea será:</p><p style="margin-bottom: 10px">-En caso de haber uno o más bienes adjudicados a un tercero se lanzará la tarea “Solicitar mandamiento de pago”.</p><p style="margin-bottom: 10px">-En caso de haber uno o más bienes con cesión de remate se lanzará la tarea "Trámite de Cesión de Remate" por cada uno de ellos.</p><p style="margin-bottom: 10px">-En caso de haber uno o más bienes adjudicados a la entidad, se lanzará el "Trámite de Adjudicación" por cada uno de ellos.</p><p style="margin-bottom: 10px">-En caso de suspensión de la subasta deberá indicar dicha circunstancia en el campo “Celebrada”, en el campo “Decisión suspensión” deberá informar quien ha provocado dicha suspensión y en el campo “Motivo suspensión” deberá indicar el motivo por el cual se ha suspendido. Si la suspensión ha sido por parte de la entidad, se lanzará un nuevo trámite de subasta paralizado por 60 días. En caso de no ser necesario realizar una nueva subasta, deberá finalizar el nuevo trámite. Si la suspensión ha sido por motivos de un tercero, se lanzará un nuevo trámite de subasta.</p><p style="margin-bottom: 10px">-En caso de que algún bien haya sido adjudicado a la entidad o con cesión de remate, se lanzará el "Trámite de solvencia patrimonial" para averiguar la solvencia del deudor.</p></div>'' ' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-900');

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-903');
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
          ' SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''H015_ConfirmarFormalizacion''''][''''alquilerFormalizado''''] == DDSiNo.SI && !comprobarExisteDocumento(''''CAS'''') ? ''''Debe adjuntar el documento "Contrato de alquiler social".'''' : null'' ' ||
          ' WHERE TAP_CODIGO = ''H015_ConfirmarFormalizacion'' ';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
          ' SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''H015_RegistrarPosesionYLanzamiento''''][''''comboLanzamiento''''] == DDSiNo.SI && valores[''''H015_RegistrarSenyalamientoLanzamiento''''][''''fecha''''] == null  && (valores[''''H015_FormalizacionAlquilerSocial''''][''''alquilerFormalizado''''] == DDSiNo.SI || valores[''''H015_FormalizacionAlquilerSocial''''][''''posibleFormalizacion''''] == DDSiNo.SI) ? ''''Es necesario haber informado de la fecha de lanzamiento en la tarea "Registrar se&ntilde;alamiento del lanzamiento" para finalizar esta tarea.'''' : valores[''''H015_FormalizacionAlquilerSocial''''][''''alquilerFormalizado''''] == DDSiNo.SI ? comprobarExisteDocumento(''''CAS'''') ? null : ''''<div id="permiteGuardar">Debe adjuntar el documento "Contrato de alquiler social".</div>'''' : null'' ' ||
          ' WHERE TAP_CODIGO = ''H015_FormalizacionAlquilerSocial'' ';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-903');

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-901');
	V_TAREA:='H005_ConfirmarTestimonio';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">A través de esta pantalla se ha de marcar la fecha que el Juzgado emite y hace entrega del Testimonio del Decreto a favor de la Entidad. Se ha de tener en cuenta que desde la fecha testimonio que se indique en esta pantalla se inicia el plazo para liquidar los impuestos que correspondan.</p><p style="margin-bottom: 10px">En el campo Fecha notificación testimonio, indicar la fecha en la que se notifica a la entidad el Testimonio del Decreto de Adjudicación.</p><p style="margin-bottom: 10px">Con el objeto de evitar calificaciones desfavorables y subsanaciones posteriores que retrasan la inscripción deberá: </p><p style="margin-bottom: 10px">Obtenido el testimonio, revisar la fecha de expedición para liquidación de impuestos en plazo, según normativa de CCAA. La verificación de la fecha del título es necesaria y fundamental para que la gestoría pueda realizar la liquidación en plazo.</p><p style="margin-bottom: 10px">Adicionalmente se revisarán el contenido fundamental y de forma, para evitar subsanaciones posteriores que retrasen la inscripción.</p><p style="margin-bottom: 10px">Contenido básico para revisar en testimonio decreto de adjudicación  y mandamientos:</p><p style="margin-bottom: 10px">- Datos procesales básicos: (Nº autos, tipo de procedimiento, cantidad reclamada).</p><p style="margin-bottom: 10px">- Datos de la Entidad demandante (nombre CIF, domicilio) y en su caso de los adjudicados.</p><p style="margin-bottom: 10px">- Datos  de los demandados y titulares registrales.</p><p style="margin-bottom: 10px">- Importe de adjudicación y cesión de remate (en su caso).</p><p style="margin-bottom: 10px">- Orden de cancelación de la nota marginal y cancelación de la carga objeto de ejecución así como cargas posteriores.</p>' || 
	  '<p style="margin-bottom: 10px">- Descripción y datos registrales completos de la finca adjudicada.</p><p style="margin-bottom: 10px">- Declaración en el auto de la firmeza de la resolución.</p><p style="margin-bottom: 10px">Una vez analizados los puntos descritos, en el campo Requiere subsanación deberá indicar el resultado de dicho análisis.</p><p style="margin-bottom: 10px">En el campo "Comunicación adicional requerida", deberá indicarse si es necesario, en función de la legislación vigente en la Comunidad Autónoma del bien, realizar notificación a la oficina de la vivienda. Si es necesaria una comunicación adicional, se informará además la fecha límite de acuerdo con la legislación aplicable.</p><p style="margin-bottom: 10px">En el supuesto de que haya constancia en el procedimiento de que hay ocupantes en el bien, deberá indicarlo en el campo pertinente.</p><p style="margin-bottom: 10px">Para dar por terminada esta tarea deberá de adjuntar al procedimiento correspondiente una copia escaneada del decreto firme de adjudicación.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla:</p><p style="margin-bottom: 10px">-En caso de requerir subsanación, se lanzará el "Trámite de subsanación de decreto de adjudicación".</p><p style="margin-bottom: 10px">-Se lanzará el "Trámite de provisión de fondos".</p><p style="margin-bottom: 10px">-Se lanzará el "Trámite de Posesión".</p><p style="margin-bottom: 10px">-En caso de que sea necesario comunicación adicional, se lanzará la tarea "Revisión documentación y comunicación adicional".</p><p style="margin-bottom: 10px">-En caso de que haya indicado que no hay constancia en el procedimiento de que hay ocupantes, se lanzará el trámite de "Certificado libertad de arrendamiento.</p></div>'' ' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-901');

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-904');
	V_TAREA:='H015_AutorizarSuspension';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">En esta tarea, la entidad se deberá confirmar si autoriza la suspensión del lanzamiento propuesta por el gestor.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla, y en caso de que la Entidad autorice la suspensión, se lanzará la tarea "Suspensión lanzamiento". En caso contrario, la Entidad deberá indicar cómo proceder.</p></div>'' ' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-904');
	
	--parte nueva Alberto
	--------------------------
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-910');
	V_TAREA:='H004_RegistrarResSuspSubasta';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla deber&aacute; informa de la fecha en la que el juzgado notifica la resoluci&oacute;n a la solicitud de suspensi&oacute;n de la subasta as&iacute; como indicar si la subasta se ha suspendido o no.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez finaliza esta tarea, se le abrirá tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</p></div>'' ' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-910');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-906');
	V_TAREA:='HC103_RealizarTransferencia';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea, deberá hacer una transferencia por el importe aprobado y se generará una notificación al letrado.</p><p style="margin-bottom: 10px">En el campo Fecha indicar la fecha en la que realiza la transferencia.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellena esta pantalla, se lanzará la tarea Confirmar transferencia realizada.</p></div>'' ' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-906');
	
	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-902');
	V_TAREA:='H005_ConfirmarTestimonio';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_ERROR_VALIDACION=''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'' ' ||
	  ' WHERE TFI_NOMBRE=''comboAdicional'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';

	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_VALIDACION=''valor != null && valor != ''''''''? true : false'' ' ||
	  ' WHERE TFI_NOMBRE=''comboAdicional'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';

	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_ERROR_VALIDACION=''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'' ' ||
	  ' WHERE TFI_NOMBRE=''comboOcupantes'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';

	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_VALIDACION=''valor != null && valor != ''''''''? true : false'' ' ||
	  ' WHERE TFI_NOMBRE=''comboOcupantes'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
      ' SET TAP_SCRIPT_VALIDACION_JBPM = ''(valores[''''H005_ConfirmarTestimonio''''][''''comboAdicional'''']==DDSiNo.SI && valores[''''H005_ConfirmarTestimonio''''][''''fechaLimite'''']==null) ? ''''Si requiere comunicaci&oacute;n adicional debe indicar la fecha l&iacute;mite de comunicaci&oacute;n'''' : null'' ' ||
      ' WHERE TAP_CODIGO = ''H005_ConfirmarTestimonio'' ';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-902');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-905');
	V_TAREA:='H015_ConfirmarFormalizacion';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.DD_PTP_PLAZOS_TAREAS_PLAZAS SET ' ||
	  ' DD_PTP_PLAZO_SCRIPT=''damePlazo(valores[''''H015_SuspensionLanzamiento''''][''''fechaParalizacion'''']) + 30*24*60*60*1000L'' ' ||
	  ' WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-905');

	-- Gonzalo Sprint 15
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-930');
	V_TAREA:='H015_ConfirmarFormalizacion';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Tras la suspensión del lanzamiento, deberá indicar la fecha en la que finalmente formaliza el alquiler social. En caso de que no se llegase a formalizar, deberán indicarlo en el campo correspondiente.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellena esta pantalla, en caso de que haya formalizado el contrato, deberá finalizar esta actuación a través de la pestaña "Decisiones" indicando el motivo de la finalización. En caso contrario, se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</p></div>'' ' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-930');
	
	V_TAREA:='H004_RegistrarResSuspSubasta';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">En esta pantalla deberá informa de la fecha en la que el juzgado notifica la resolución a la solicitud de suspensión de la subasta así como indicar si la subasta se ha suspendido o no.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez finaliza esta tarea,  se le abrirá tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</p></div>'' ' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';

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