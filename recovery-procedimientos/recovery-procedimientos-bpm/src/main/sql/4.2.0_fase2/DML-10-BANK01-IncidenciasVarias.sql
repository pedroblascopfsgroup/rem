--/*
--##########################################
--## Author: Óscar
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script. 

BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO] INCIDENCIA INC-7');
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set  tap_script_validacion = ''comprobarBienAsociadoPrc() ? null : ''''El bien debe estar asociado al trámite, asócielo desde la pestaña de Bienes del procedimiento para poder finalizar esta tarea.'''''', tap_script_validacion_jbpm = null where tap_codigo = ''P413_SolicitudDecretoAdjudicacion'''; 

execute immediate 'update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_label = ''Cesión de remate'' where tfi_nombre =''comboCesion'' and tap_id in (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo in (''P401_CelebracionSubasta'',''P409_CelebracionSubasta''))'; 

execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_alert_vuelta_atras = null where tap_codigo = ''P401_ContabilizarCierreDeuda'''; 

execute immediate 'UPDATE '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento SET dd_tpo_descripcion = ''T. de subsanacion decreto/testimonio de adjudicación'', dd_tpo_descripcion_larga = ''T. de subsanacion decreto/testimonio de adjudicación'' WHERE dd_tpo_codigo = ''P414''';

execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set dd_tpo_id_bpm = (select dd_tpo_id from '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P410'') where tap_codigo in (''P401_BPMTramiteCesionRemateV4'',''P409_BPMTramiteCesionRemateV4'')';

execute immediate 'update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_label  =''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&aacute; acceder a la pesta&ntilde;a Subastas del asunto correspondiente y asociar uno o m&aacute;s bienes a la subasta que corresponda. Una vez agregados los bienes a la subasta deber&aacute; indicar a trav&eacute;s de la ficha de cada bien las cargas anteriores y posteriores y si no hay, la fecha de revisi&oacute;n de las cargas, si es vivienda habitual o no, la situaci&oacute;n posesoria y el tipo de subasta.</p><p style="margin-bottom: 10px">En el campo Fecha solicitud deber&aacute; consignar la fecha en la que haya realizado la solicitud de subasta.En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.Una vez rellene esta pantalla se lanzar&aacute; la tarea &quot;Se&ntilde;alamiento de subasta&quot; a realizar por el letrado.</p></div>'' where tfi_tipo = ''label'' and tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P401_SolicitudSubasta'') ' ;

execute immediate 'update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_label  =''<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea, deberá acceder a la pestaña Subastas del asunto correspondiente y asociar uno o más bienes a la subasta que corresponda. Una vez agregados los bienes a la subasta deberá indicar a través de la ficha de cada bien las cargas anteriores y posteriores y si no hay, la fecha de revisi&oacute;n de las cargas, si es vivienda habitual o no, la situación posesoria y el tipo de subasta.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo Fecha solicitud deberá consignar la fecha en la que haya realizado la solicitud de subasta.En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.Una vez rellene esta pantalla se lanzará la tarea "Señalamiento de subasta" a realizar por el letrado.</p></div>'' where tfi_tipo = ''label'' and tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P409_SolicitudSubasta'') ' ;

execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set dd_tpo_id_bpm = (select dd_tpo_id from '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P413'') where tap_codigo = ''P410_BPMTramiteAdjudicacion''';

execute immediate 'update '||V_ESQUEMA||'.tfi_Tareas_form_items set tfi_valor_inicial = ''valores[''''P401_PrepararCesionRemate''''] == null ? '''''''' : (valores[''''P401_PrepararCesionRemate''''][''''instrucciones''''])'' where tfi_nombre = ''instrucciones'' and tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P410_AperturaPlazo'')';

execute immediate 'update '||V_ESQUEMA||'.tfi_Tareas_form_items set TFI_TIPO = ''htmledit2'' where tfi_nombre=''instrucciones'' and tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P401_PrepararCesionRemate'')';

execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion_jbpm = ''valores[''''P413_RegistrarInscripcionDelTitulo''''][''''comboSituacionTitulo''''] == ''''PEN'''' ? null : (comprobarAdjuntoDocumentoTestimonioInscritoEnRegistro() ? ((valores[''''P413_RegistrarInscripcionDelTitulo''''][''''fechaInscripcion''''] == null || valores[''''P413_RegistrarInscripcionDelTitulo''''][''''fechaEnvioDecretoAdicion''''] == null) ? ''''Las fechas son obligatorias'''' : null) : ''''Debe adjuntar el Documento de Testimonio inscrito en el Registro.'''')'' where tap_codigo = ''P413_RegistrarInscripcionDelTitulo''';

execute immediate 'update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_error_validacion = null, tfi_validacion = null where tfi_nombre in (''fechaInscripcion'',''fechaEnvioDecretoAdicion'') and tap_id = (select tap_id from '||V_ESQUEMA||'.tap_Tarea_procedimiento where tap_codigo = ''P413_RegistrarInscripcionDelTitulo'')';

execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion_jbpm = ''((valores[''''P08_SolicitarInformacionCargas''''][''''comboResultado''''] == DDSiNo.SI) && (valores[''''P08_SolicitarInformacionCargas''''][''''fecha''''] == null))?''''Debe introducir la fecha de presentaci&oacute;n'''':null'' where tap_codigo = ''P08_SolicitarInformacionCargas''';

execute immediate 'update '||V_ESQUEMA||'.tap_Tarea_procedimiento set tap_Script_validacion_jbpm = ''((valores[''''P16_RegistrarOposicion''''][''''comboSiNo''''] == DDSiNo.SI) && ((valores[''''P16_RegistrarOposicion''''][''''fecha''''] == null)))?''''Debe introducir la fecha de oposici&oacute;n'''':null''  where tap_codigo = ''P16_RegistrarOposicion''';

execute immediate 'update '||V_ESQUEMA||'.dd_tsu_tipo_subasta set dd_tsu_descripcion = ''DELEGADA'' WHERE DD_TSU_CODIGO = ''DEL''';

execute immediate 'UPDATE '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO SET DD_TFA_DESCRIPCION  = ''Informe de subasta'', dd_tfa_descripcion_larga = ''Informe de subasta'' where dd_tfa_codigo =''INS''';

--hipotecario
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_codigo = ''P01_BPMTramiteSubastaBankia'' where tap_codigo = ''P01_BPMTramiteSubasta''';

--execute immediate 'Insert into TAP_TAREA_PROCEDIMIENTO (TAP_ID, DD_TPO_ID, TAP_CODIGO, DD_TPO_ID_BPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP, DD_STA_ID) Values   (s_tap_tarea_procedimiento.nextval, 1, ''P01_BPMTramiteSubastaSareb'', (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P409''), 0, ''Se inicia trámite de subastas SAREB'', 0, ''DD'', sysdate, 0, 1, ''EXTTareaProcedimiento'', 3, 39)';

execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW = ''plugin/procedimientos/genericFormOverSize'' WHERE TAP_CODIGO = ''P408_registrarResultadoComite''';

execute immediate 'update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_label = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el primer campo indíquese si se quiere que el gestor registre una propuesta de convenio de la propia entidad, en el segundo campo indíquese si se quiere realizar un seguimiento de los convenios propuestos por terceros que puedan surgir durante la fase convenio. Si ya hubiere Convenio propio de la entidad registrado, o adhesión a otro convenio propio o presentado por otros, no se deberán registrar más convenio.</p><p style="margin-bottom: 10px"><p>En caso de que no quiera registrar un convenio propio en estos momentos, puede hacerlo cuando quiera hasta la fecha hábil por medio del "Trámite de presentación propuesta de convenio" que le guiará para dar de alta el convenio propio en la pestaña "Convenios" de la ficha del asunto correspondiente.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se iniciará una tarea por cada una de las decisiones tomadas, en el caso de querer registrar un convenio propio se iniciará un "Trámite presentación de propuesta de convenio propia" o en el caso de querer hacer un seguimiento sobre otras propuestas se creará la tarea "Actualizar propuesta de convenio".</p><p style="margin-bottom: 10px">En caso de no querer registrar ningún convenio propio o de terceros, no se lanzará ninguna otra tarea respecto al seguimiento de los convenios.</p></div>'' where tfi_nombre=''titulo'' and tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P408_decidirSobreFaseComun'')';

--
execute immediate 'update '||V_ESQUEMA||'.tap_Tarea_procedimiento set tap_script_validacion = ''comprobarMinimoBienLote() ? (comprobarBienInformado() ? null : ''''Los bienes con lote deben tener informado las cargas anteriores y posteriores, si es vivienda habitual o no y la situación posesoria'''') : ''''Al menos un bien debe estar asignado a un lote'''''' where tap_codigo = ''P401_SolicitudSubasta''';

execute immediate 'update '||V_ESQUEMA||'.tap_Tarea_procedimiento set tap_script_validacion = ''comprobarMinimoBienLote() ? (comprobarBienInformado() ? null : ''''Los bienes con lote deben tener informado las cargas anteriores y posteriores, si es vivienda habitual o no y la situación posesoria'''') : ''''Al menos un bien debe estar asignado a un lote'''''' where tap_codigo = ''P409_SolicitudSubasta''';

execute immediate 'update '||V_ESQUEMA||'.tap_Tarea_procedimiento set tap_script_validacion = ''comprobarTipoSubastaInformado() ? (comprobarExisteDocumentoESRAS() ? null : ''''Es necesario adjuntar el documento Edicto de subasta y resolución acordando señalamiento'''') : ''''Los bienes con lote deben tener informado el tipo de subasta'''''' where tap_codigo = ''P401_SenyalamientoSubasta''';

execute immediate 'update '||V_ESQUEMA||'.tap_Tarea_procedimiento set tap_script_validacion = ''comprobarTipoSubastaInformado() ? (comprobarExisteDocumentoESRAS() ? null : ''''Es necesario adjuntar el documento Edicto de subasta y resolución acordando señalamiento'''') : ''''Los bienes con lote deben tener informado el tipo de subasta'''''' where tap_codigo = ''P409_SenyalamientoSubasta''';

execute immediate 'update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_label = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&aacute; acceder a la pesta&ntilde;a Subastas del asunto correspondiente y asociar uno o m&aacute;s bienes a la subasta que corresponda. Una vez agregados los bienes a la subasta deber&aacute; indicar a trav&eacute;s de la ficha de cada bien las cargas anteriores y posteriores y si no hay, la fecha de revisi&oacute;n de las cargas, si es vivienda habitual o no y la situaci&oacute;n posesoria.</p><p style="margin-bottom: 10px">En el campo Fecha solicitud deber&aacute; consignar la fecha en la que haya realizado la solicitud de subasta.En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.Una vez rellene esta pantalla se lanzar&aacute; la tarea &quot;Se&ntilde;alamiento de subasta&quot; a realizar por el letrado.</p></div>'' where tfi_nombre = ''titulo'' and tap_id in (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo in (''P401_SolicitudSubasta'',''P409_SolicitudSubasta''))';

execute immediate 'update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_label = ''<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez agregados los bienes a la subasta deberá indicar a través de la ficha de cada bien el tipo de subasta.</p><p style="margin-bottom: 10px">Una vez solicitada la subasta, en esta pantalla, debe consignar las fechas de anuncio y celebración de la misma así como las costas del letrado y procurador.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzarán las siguientes tareas:<br>-   "Celebración subasta y adjudicación" a realizar por el letrado.<br>-   "Adjuntar informe de subasta" a realizar por el letrado.<br>-   "Preparar propuesta de subasta" a realizar por el supervisor.</p></div>'' where tfi_nombre = ''titulo'' and tap_id in (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo in (''P401_SenyalamientoSubasta'',''P409_SenyalamientoSubasta''))';

EXECUTE IMMEDIATE 'delete from '||V_ESQUEMA||'.dd_tfa_fichero_adjunto where DD_TFA_CODIGO=''INFDUE''';

execute immediate 'update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_label = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta pantalla debemos indicar tanto si se ha admitido el resultado de la junta de acreedores como si hay oposición.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será:</p><p>- Si se presenta oposición: "Registrar resolución oposición"</p><p>- Si no se admite el resultado: "Registrar resultado subsanación"</p><p>- En caso de que se admita y no haya oposición se termina el trámite en curso por lo que se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</p></div>'' where tfi_nombre = ''titulo'' and tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P408_RegistrarOposicionAdmon'')';

execute immediate 'update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_label = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Consignar fecha en la que se nos notifica auto por el que se inicia la fase de convenio, así como la fecha en la que se celebrará la junta de acreedores.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.'' where tfi_nombre = ''titulo'' and tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P408_autoApertura'')';

--update tfi_Tareas_form_items set tfi_label = replace(tfi_label, '</div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;">','') where tfi_nombre = 'titulo'  and tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P408_autoApertura');

execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_decision = ''decidirPrepararPropuestaSubasta()'' where tap_codigo = ''P401_PrepararPropuestaSubasta''';


COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN] INCIDENCIA INC-7');



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

