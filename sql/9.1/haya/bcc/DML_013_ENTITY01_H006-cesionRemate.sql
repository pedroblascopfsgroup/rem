--/*
--##########################################
--## AUTOR=GONZALO ESTELLES
--## FECHA_CREACION=2015715
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-371
--## PRODUCTO=NO
--##
--## Finalidad: Modificación trámite Cesión de remate
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

    V_COD_PROCEDIMIENTO VARCHAR (20 CHAR) := 'H006';
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
      T_TIPO_TPO(V_COD_PROCEDIMIENTO,'T. de cesión de remate - HAYA','T. de cesión de remate',null,'hcj_tramiteCesionRemate','0','DD','0','AP',null,null,'1','MEJTipoProcedimiento','1','0')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(2000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
	    --EQ T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H006_AperturaPlazo',null,null,null,'( valores[''H006_AperturaPlazo''][''comboFinaliza''] == DDSiNo.SI ? ''SI'':''NO'')',null,'0','Apertura plazo cesión de remate','0','DD','0',null,null,null,'0','EXTTareaProcedimiento','3',null,'814',null,'GULI',null),
		--EQ T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H006_NoCesionRemateDecision',null,null,null,null,null,'0','Tarea toma de decisión','0','DD','0',null,null,null,'0','EXTTareaProcedimiento','3',null,'819',null,'GULI',null)
		--EQ T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H006_ResenyarFechaComparecencia',null,null,null,null,null,'0','Registrar comparecencia','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'814',null,'GULI',null),
	    T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
        /*TAP_CODIGO...................:*/ 'H006_ConfirmarDocCompleta',
        /*TAP_VIEW.....................:*/ null,
        /*TAP_SCRIPT_VALIDACION........:*/ null,
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ null,
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Confirmar documentación completa',
        /*VERSION......................:*/ '0',
        /*USUARIOCREAR.................:*/ 'DD',
        /*BORRADO......................:*/ '0',
        /*TAP_ALERT_NO_RETORNO.........:*/ null,
        /*TAP_ALERT_VUELTA_ATRAS.......:*/ 'tareaExterna.cancelarTarea',
        /*DD_FAP_ID(FK)................:*/ null,
        /*TAP_AUTOPRORROGA.............:*/ '0',
        /*DTYPE........................:*/ 'EXTTareaProcedimiento',
        /*TAP_MAX_AUTOP................:*/ '3',
        /*DD_TGE_ID(FK)................:*/ null,
        /*DD_STA_ID(FK)................:*/ '',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ '',
        /*TAP_BUCLE_BPM................:*/ null        
        ), 
	    T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
        /*TAP_CODIGO...................:*/ 'H006_SolicitudAutYPago',
        /*TAP_VIEW.....................:*/ 'plugin/cajamar/tramiteCesionRemate/solicitarAutPago',
        /*TAP_SCRIPT_VALIDACION........:*/ null,
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ null,
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Solicitar autorización y transferencia de pago',
        /*VERSION......................:*/ '0',
        /*USUARIOCREAR.................:*/ 'DD',
        /*BORRADO......................:*/ '0',
        /*TAP_ALERT_NO_RETORNO.........:*/ null,
        /*TAP_ALERT_VUELTA_ATRAS.......:*/ 'tareaExterna.cancelarTarea',
        /*DD_FAP_ID(FK)................:*/ null,
        /*TAP_AUTOPRORROGA.............:*/ '0',
        /*DTYPE........................:*/ 'EXTTareaProcedimiento',
        /*TAP_MAX_AUTOP................:*/ '3',
        /*DD_TGE_ID(FK)................:*/ null,
        /*DD_STA_ID(FK)................:*/ '',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ '',
        /*TAP_BUCLE_BPM................:*/ null        
        ), 
	    T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
        /*TAP_CODIGO...................:*/ 'H006_ConfirmarTransferencia',
        /*TAP_VIEW.....................:*/ null,
        /*TAP_SCRIPT_VALIDACION........:*/ 'comprobarExisteDocumentoCRRESTRA() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el Resguardo de la transferencia.</div>''',
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ null,
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Confirmar transferencia realizada',
        /*VERSION......................:*/ '0',
        /*USUARIOCREAR.................:*/ 'DD',
        /*BORRADO......................:*/ '0',
        /*TAP_ALERT_NO_RETORNO.........:*/ null,
        /*TAP_ALERT_VUELTA_ATRAS.......:*/ 'tareaExterna.cancelarTarea',
        /*DD_FAP_ID(FK)................:*/ null,
        /*TAP_AUTOPRORROGA.............:*/ '0',
        /*DTYPE........................:*/ 'EXTTareaProcedimiento',
        /*TAP_MAX_AUTOP................:*/ '3',
        /*DD_TGE_ID(FK)................:*/ null,
        /*DD_STA_ID(FK)................:*/ '',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ '',
        /*TAP_BUCLE_BPM................:*/ null        
        ), 
	    T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
        /*TAP_CODIGO...................:*/ 'H006_RegistrarRecepcionPago',
        /*TAP_VIEW.....................:*/ null,
        /*TAP_SCRIPT_VALIDACION........:*/ null,
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ 'valores[''H006_SolicitudAutYPago''][''cbCertificado'']==DDSiNo.SI && valores[''H006_RegistrarRecepcionPago''][''fechaCert'']==null ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Ha indicado que hay emisi&oacute;m de certificado por lo tanto debe indicar la fecha de emisi&oacute;n del certificado.</div>'' : null',
        /*TAP_SCRIPT_DECISION..........:*/ null,
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Registrar recepción transferencia de pago y emisión certificado',
        /*VERSION......................:*/ '0',
        /*USUARIOCREAR.................:*/ 'DD',
        /*BORRADO......................:*/ '0',
        /*TAP_ALERT_NO_RETORNO.........:*/ null,
        /*TAP_ALERT_VUELTA_ATRAS.......:*/ 'tareaExterna.cancelarTarea',
        /*DD_FAP_ID(FK)................:*/ null,
        /*TAP_AUTOPRORROGA.............:*/ '0',
        /*DTYPE........................:*/ 'EXTTareaProcedimiento',
        /*TAP_MAX_AUTOP................:*/ '3',
        /*DD_TGE_ID(FK)................:*/ null,
        /*DD_STA_ID(FK)................:*/ '',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ '',
        /*TAP_BUCLE_BPM................:*/ null        
        ), 
	    T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
        /*TAP_CODIGO...................:*/ 'H006_BPMTramiteSaneamientoCargas',
        /*TAP_VIEW.....................:*/ null,
        /*TAP_SCRIPT_VALIDACION........:*/ null,
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ null,
        /*DD_TPO_ID_BPM(FK)............:*/ 'H008',
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Se inicia el trámite de Saneamiento de cargas adj.',
        /*VERSION......................:*/ '0',
        /*USUARIOCREAR.................:*/ 'DD',
        /*BORRADO......................:*/ '0',
        /*TAP_ALERT_NO_RETORNO.........:*/ null,
        /*TAP_ALERT_VUELTA_ATRAS.......:*/ 'tareaExterna.cancelarTarea',
        /*DD_FAP_ID(FK)................:*/ null,
        /*TAP_AUTOPRORROGA.............:*/ '0',
        /*DTYPE........................:*/ 'EXTTareaProcedimiento',
        /*TAP_MAX_AUTOP................:*/ '3',
        /*DD_TGE_ID(FK)................:*/ null,
        /*DD_STA_ID(FK)................:*/ '',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ '',
        /*TAP_BUCLE_BPM................:*/ null        
        ), 
		--EQ T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H006_RealizacionCesionRemate',null,null,null,'( valores[''H006_RealizacionCesionRemate''][''comboTitularizado''] == DDSiNo.SI ? ''SI'':''NO'')',null,'0','Realización de la cesión de remate','0','DD','0',null,'tareaExterna.cancelarTarea',null,'0','EXTTareaProcedimiento','3',null,'814',null,'GULI',null),
		--EQ T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H006_BPMTramiteAdjudicacion',null,null,null,null,'H005','0','Trámite de Adjudicación','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'814',null,null,null),
		--DEL T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H006_ConfirmarContabilidad',null,null,null,null,null,'0','Confirmar contabilidad','0','DD','0',null,null,null,'0','EXTTareaProcedimiento','3',null,'805',null,'GULI',null),
	    T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
        /*TAP_CODIGO...................:*/ 'H006_RevisarInfoContable',
        /*TAP_VIEW.....................:*/ null,
        /*TAP_SCRIPT_VALIDACION........:*/ null,
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ null,
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Revisar y completar información contable',
        /*VERSION......................:*/ '0',
        /*USUARIOCREAR.................:*/ 'DD',
        /*BORRADO......................:*/ '0',
        /*TAP_ALERT_NO_RETORNO.........:*/ null,
        /*TAP_ALERT_VUELTA_ATRAS.......:*/ null,
        /*DD_FAP_ID(FK)................:*/ null,
        /*TAP_AUTOPRORROGA.............:*/ '0',
        /*DTYPE........................:*/ 'EXTTareaProcedimiento',
        /*TAP_MAX_AUTOP................:*/ '3',
        /*DD_TGE_ID(FK)................:*/ null,
        /*DD_STA_ID(FK)................:*/ '',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ '',
        /*TAP_BUCLE_BPM................:*/ null        
        ), 
	    T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
        /*TAP_CODIGO...................:*/ 'H006_ConfirmarContabilidad',
        /*TAP_VIEW.....................:*/ 'plugin/cajamar/tramiteCesionRemate/confirmarContabilidad',
        /*TAP_SCRIPT_VALIDACION........:*/ null,
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ null,
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Confirmar Contabilidad',
        /*VERSION......................:*/ '0',
        /*USUARIOCREAR.................:*/ 'DD',
        /*BORRADO......................:*/ '0',
        /*TAP_ALERT_NO_RETORNO.........:*/ null,
        /*TAP_ALERT_VUELTA_ATRAS.......:*/ 'tareaExterna.cancelarTarea',
        /*DD_FAP_ID(FK)................:*/ null,
        /*TAP_AUTOPRORROGA.............:*/ '0',
        /*DTYPE........................:*/ 'EXTTareaProcedimiento',
        /*TAP_MAX_AUTOP................:*/ '3',
        /*DD_TGE_ID(FK)................:*/ null,
        /*DD_STA_ID(FK)................:*/ '',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ '',
        /*TAP_BUCLE_BPM................:*/ null        
        )

        



    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
    	--EQ T_TIPO_PLAZAS(null,null,'H006_AperturaPlazo','valoresBPMPadre[''H002_SenyalamientoSubasta''] == null ? 5*24*60*60*1000L : damePlazo(valoresBPMPadre[''H002_SenyalamientoSubasta''][''fechaSenyalamiento''])+5*24*60*60*1000L','0','0','DD'),
		--EQ T_TIPO_PLAZAS(null,null,'H006_ResenyarFechaComparecencia','damePlazo(valores[''H006_AperturaPlazo''][''fecha''])+5*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H006_ConfirmarDocCompleta','damePlazo(valores[''H006_ResenyarFechaComparecencia''][''fecha''])-20*24*60*60*1000L','0','0','DD'),  
		T_TIPO_PLAZAS(null,null,'H006_SolicitudAutYPago','damePlazo(valores[''H006_ResenyarFechaComparecencia''][''fecha''])-15*24*60*60*1000L','0','0','DD'),    
		T_TIPO_PLAZAS(null,null,'H006_ConfirmarTransferencia','damePlazo(valores[''H006_ResenyarFechaComparecencia''][''fecha''])-12*24*60*60*1000L','0','0','DD'),    
		T_TIPO_PLAZAS(null,null,'H006_RegistrarRecepcionPago','damePlazo(valores[''H006_ResenyarFechaComparecencia''][''fecha''])-10*24*60*60*1000L','0','0','DD'),    
		--EQ T_TIPO_PLAZAS(null,null,'H006_RealizacionCesionRemate','damePlazo(valores[''H006_ResenyarFechaComparecencia''][''fecha''])','0','0','DD'),
		--EQ T_TIPO_PLAZAS(null,null,'H006_BPMTramiteAdjudicacion','300*24*60*60*1000L','0','0','DD'),
		--DEL T_TIPO_PLAZAS(null,null,'H006_ConfirmarContabilidad','7*24*60*60*1000L','0','0','DD')
		T_TIPO_PLAZAS(null,null,'H006_BPMTramiteSaneamientoCargas','300*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H006_RevisarInfoContable','2*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H006_ConfirmarContabilidad','1*24*60*60*1000L','0','0','DD')
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
		T_TIPO_TFI('H006_AperturaPlazo','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">En caso de que la entidad haya dado instrucciones específicas para la cesión de remate, éstas aparecerán precargadas  en el campo instrucciones.</p><p style="margin-bottom: 10px;">El letrado deberá realizar la solicitud de la adjudicación con reserva de facultad de cesión de remate. En el caso de no realizarse las mismas, deberá comunicar a su gestor el motivo por el que no se considera necesario.</p><p style="margin-bottom: 10px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">Una vez rellene esta pantalla y en el caso de haber realizado las gestiones necesarias para la cesión de remate se lanzará la tarea "Registrar comparecencia", en caso contrario se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H006_AperturaPlazo','1','combo','comboFinaliza','Realizadas gestiones','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('H006_AperturaPlazo','2','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H006_AperturaPlazo','3','textarea','instrucciones','Instrucciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H006_AperturaPlazo','4','combo','cbCresionRemate','Cesión de remate','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDCesionRemateAdjudicado','0','DD'),
		T_TIPO_TFI('H006_AperturaPlazo','5','combo','cbTitulizado','Titulizado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('H006_AperturaPlazo','6','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H006_ResenyarFechaComparecencia','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">En esta pantalla, deberá informar la fecha que ha señalado el juzgado para la realización de la comparecencia en la que se formalizará la cesión de remate, así como enviar una anotación a través de la herramienta a su supervisor informándole de la misma.</p><p style="margin-bottom: 10px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">Una vez rellene esta pantalla se lanzará la tarea "Registrar realización cesión de remate" en el caso de que la cesión sea a favor de un tercero. En caso de que la cesión sea a favor de Cimenta2, se lanzará la tarea "Confirmar documentación completa".</p></div>',null,null,null,null,'0','DD'),
		--EQ T_TIPO_TFI('H006_ResenyarFechaComparecencia','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		--EQ T_TIPO_TFI('H006_ResenyarFechaComparecencia','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H006_ConfirmarDocCompleta','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">A través de esta tarea, el letrado deberá confirmar que dispone de toda la documentación necesaria para tramitar la cesión de remate. En caso negativo deberá indicar qué documentación necesita.</p><p style="margin-bottom: 10px;">Una vez rellene esta pantalla la siguiente tarea será "Solicitar autorización y transferencia de pago".</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H006_ConfirmarDocCompleta','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H006_ConfirmarDocCompleta','2','combo','cbDocCompleta','Documentación completa','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('H006_ConfirmarDocCompleta','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H006_SolicitudAutYPago','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">Antes de dar por finalizada esta tarea deberá deberá revisar las observaciones del letrado y facilitarle la documentación requierida si fuera el caso. Además, deberá obtener la autorización del órgano competente antes de solicitar la transferencia del pago.</p><p style="margin-bottom: 10px;">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">Una vez rellene esta pantalla la siguiente tarea será "Registrar recepción transferencia de pago y emisión certificado".</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H006_SolicitudAutYPago','1','date','fecha','Fecha solicitud','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H006_SolicitudAutYPago','2','textarea','obsLetrado','Observaciones Letrado',null,null,'valores[''H006_ConfirmarDocCompleta''][''observaciones'']','DDSiNo','0','DD'),
		T_TIPO_TFI('H006_SolicitudAutYPago','3','combo','cbAutorizado','Autorizado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('H006_SolicitudAutYPago','4','combo','cbCertificado','Emisión certificado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('H006_SolicitudAutYPago','5','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H006_ConfirmarTransferencia','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">Para dar por finalizada esta tarea deberá adjuntar el resguardo de la transferencia realizada así como indicar la fecha en la que se realizó la misma.</p><p style="margin-bottom: 10px;">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">Una vez rellene esta pantalla la siguiente tarea será "Registrar recepción de pago y emisión de certificado.</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H006_ConfirmarTransferencia','1','date','fecha','Fecha transferencia','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H006_ConfirmarTransferencia','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H006_RegistrarRecepcionPago','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">Para dar por terminada esta tarea deberá indicar la fecha en la que recepciona el pago acordado en la cesión de remate así como la fecha en la que se emite el certificado de deuda, en caso de que sea necesiaria su emisión.</p><p style="margin-bottom: 10px;">Una vez haya recepcionado el pago y el certificado deberá remitirlos al procurador.</p><p style="margin-bottom: 10px;">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H006_RegistrarRecepcionPago','1','date','fechaPago','Fecha recepción pago','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H006_RegistrarRecepcionPago','2','date','fechaCert','Fecha emisión certificado',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H006_RegistrarRecepcionPago','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H006_RealizacionCesionRemate','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">En esta pantalla, se deberá poner la fecha en la que se formaliza la comparecencia para la cesión del remate. Así mismo, en caso de que se trate de una operación titulizada, deberá enviar una notificación a través de Recovery al departamento de titulización.</p><p style="margin-bottom: 10px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">El siguiente paso será:</p><p style="margin-bottom: 10px;">-Si existen cargas, se lanzará el "Trámite de saneamiento de cargas".</p><p style="margin-bottom: 10px;">-Si no existen cargas, se lanzará la tarea "Revisar y completar información contable".</p><p style="margin-bottom: 10px;">-Tanto si existen cargas como si no, se lanzará el "Trámite de Adjudicación" en caso de que la cesión sea a favor de Cimenta2 o se trate de una operación titulizada.</p></div>',null,null,null,null,'0','DD'),
		--EQ T_TIPO_TFI('H006_RealizacionCesionRemate','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		--EQ T_TIPO_TFI('H006_RealizacionCesionRemate','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		--DEL T_TIPO_TFI('H006_RealizacionCesionRemate','3','combo','comboTitularizado','Titularizado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		--EQ T_TIPO_TFI('H006_BPMTramiteAdjudicacion','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Adjudicación.</p></div>',null,null,null,null,'0','DD'),
		--DEL T_TIPO_TFI('H006_ConfirmarContabilidad','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Desde Soporte Deuda deben confirmar en esta tarea que han realizado la contabilizaci&oacute;n del bien adjudicado.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interese quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
		--DEL T_TIPO_TFI('H006_ConfirmarContabilidad','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		--DEL T_TIPO_TFI('H006_ConfirmarContabilidad','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD')
		T_TIPO_TFI('H006_BPMTramiteSaneamientoCargas','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Saneamiento de cargas.</p></div>',null,null,null,null,'0','DD'),
		
		T_TIPO_TFI('H006_RevisarInfoContable','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">En esta pantalla deberá indicar cómo distribuye el importe cobrado en los diferentes conceptos.</p><p style="margin-bottom: 10px;">Si la operación es titulizada o si requiere  autorización, deberá solicitar autorización a la entidad para la contabilidad del bien.</p><p style="margin-bottom: 10px;">Si la operación es titulizada o si requiere  autorización, deberá solicitar autorización a la entidad para la contabilidad del bien.</p><p style="margin-bottom: 10px;">En el campo Fecha deberá indicar la fecha en la que realiza las gestiones.</p><p style="margin-bottom: 10px;">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">Una vez rellene esta pantalla, volverá a la tarea "Confirmar Contabilidad".</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H006_RevisarInfoContable','1','date','fecha','Fecha Presentación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H006_RevisarInfoContable','2','currency','nominal','Nominal','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H006_RevisarInfoContable','3','currency','intereses','Intereses','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H006_RevisarInfoContable','4','currency','demora','Demora','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H006_RevisarInfoContable','5','currency','gAbogado','Gastos abogado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H006_RevisarInfoContable','6','currency','gProcurador','Gastos procurador','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H006_RevisarInfoContable','7','currency','gOtros','Otros gastos','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H006_RevisarInfoContable','8','currency','aOpTramite','A op. trámite','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H006_RevisarInfoContable','9','currency','tEntregas','Total entregas a pendiente','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H006_RevisarInfoContable','10','combo','cbTipoEntrega','Tipo de entrega','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDAdjContableTipoEntrega','0','DD'),
		T_TIPO_TFI('H006_RevisarInfoContable','11','combo','cbConcepto','Concepto de entrega','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDAdjContableConceptoEntrega','0','DD'),
		T_TIPO_TFI('H006_RevisarInfoContable','12','currency','paseFallido','Pase a fallido','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H006_RevisarInfoContable','13','currency','qNominal','Quita Nominal','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H006_RevisarInfoContable','14','currency','qIntereses','Quita Intereses','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H006_RevisarInfoContable','15','currency','qDemoras','Quita Demoras','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H006_RevisarInfoContable','16','currency','tQuitasGastos','Total Quita Gastos','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H006_RevisarInfoContable','17','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H006_ConfirmarContabilidad','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">En esta pantalla le aperecerá preinformado el importe a contabilizar en cada uno de los diferentes conceptos de acuerdo a lo indicado por el gestor en la tarea previa.</p><p style="margin-bottom: 10px;">En este tarea debe confirmar la fecha en la que ha realizado la contabilización de la operación.</p><p style="margin-bottom: 10px;">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese procedimiento.</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H006_ConfirmarContabilidad','1','date','fecha','Fecha Presentación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H006_ConfirmarContabilidad','2','currency','nominal','Nominal',null,null,'valores[''H006_RevisarInfoContable''][''nominal'']',null,'0','DD'),
		T_TIPO_TFI('H006_ConfirmarContabilidad','3','currency','intereses','Intereses',null,null,'valores[''H006_RevisarInfoContable''][''intereses'']',null,'0','DD'),
		T_TIPO_TFI('H006_ConfirmarContabilidad','4','currency','demora','Demora',null,null,'valores[''H006_RevisarInfoContable''][''demora'']',null,'0','DD'),
		T_TIPO_TFI('H006_ConfirmarContabilidad','5','currency','gAbogado','Gastos abogado',null,null,'valores[''H006_RevisarInfoContable''][''gAbogado'']',null,'0','DD'),
		T_TIPO_TFI('H006_ConfirmarContabilidad','6','currency','gProcurador','Gastos procurador',null,null,'valores[''H006_RevisarInfoContable''][''gProcurador'']',null,'0','DD'),
		T_TIPO_TFI('H006_ConfirmarContabilidad','7','currency','gOtros','Otros gastos',null,null,'valores[''H006_RevisarInfoContable''][''gOtros'']',null,'0','DD'),
		T_TIPO_TFI('H006_ConfirmarContabilidad','8','currency','aOpTramite','A op. trámite',null,null,'valores[''H006_RevisarInfoContable''][''aOpTramite'']',null,'0','DD'),
		T_TIPO_TFI('H006_ConfirmarContabilidad','9','currency','tEntregas','Total entregas a pendiente',null,null,'valores[''H006_RevisarInfoContable''][''tEntregas'']',null,'0','DD'),
		T_TIPO_TFI('H006_ConfirmarContabilidad','10','combo','cbTipoEntrega','Tipo de entrega',null,null,'valores[''H006_RevisarInfoContable''][''cbTipoEntrega'']','DDAdjContableTipoEntrega','0','DD'),
		T_TIPO_TFI('H006_ConfirmarContabilidad','11','combo','cbConcepto','Concepto de entrega',null,null,'valores[''H006_RevisarInfoContable''][''cbConcepto'']','DDAdjContableConceptoEntrega','0','DD'),
		T_TIPO_TFI('H006_ConfirmarContabilidad','12','currency','paseFallido','Pase a fallido',null,null,'valores[''H006_RevisarInfoContable''][''paseFallido'']',null,'0','DD'),
		T_TIPO_TFI('H006_ConfirmarContabilidad','13','currency','qNominal','Quita Nominal',null,null,'valores[''H006_RevisarInfoContable''][''qNominal'']',null,'0','DD'),
		T_TIPO_TFI('H006_ConfirmarContabilidad','14','currency','qIntereses','Quita Intereses',null,null,'valores[''H006_RevisarInfoContable''][''qIntereses'']',null,'0','DD'),
		T_TIPO_TFI('H006_ConfirmarContabilidad','15','currency','qDemoras','Quita Demoras',null,null,'valores[''H006_RevisarInfoContable''][''qDemoras'']',null,'0','DD'),
		T_TIPO_TFI('H006_ConfirmarContabilidad','16','currency','tQuitasGastos','Total Quita Gastos',null,null,'valores[''H006_RevisarInfoContable''][''tQuitasGastos'']',null,'0','DD'),
		T_TIPO_TFI('H006_ConfirmarContabilidad','17','textarea','obsContables','Observaciones contables',null,null,'valores[''H006_RevisarInfoContable''][''observaciones'']',null,'0','DD'),
		T_TIPO_TFI('H006_ConfirmarContabilidad','18','textarea','observaciones','Observaciones',null,null,null,null,'0','DD')
		
	); 
    V_TMP_TIPO_TFI T_TIPO_TFI;
    
    V_TAREA VARCHAR(50 CHAR);
    
BEGIN	
	
	
	/* ------------------- -------------------------- */
	/* --------------  ACTUALIZACIONES --------------- */
	/* ------------------- -------------------------- */


	V_TAREA:='H006_AperturaPlazo';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET ' ||
		' TAP_VIEW=''plugin/cajamar/tramiteCesionRemate/aperturaPlazo'', ' ||
		' TAP_DESCRIPCION=''Apertura del plazo de cesión de remate'', ' ||
		' TAP_SCRIPT_VALIDACION=''comprobarExisteDocumentoCRSOLADJ() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar la Solicitud de adjudicaci&oacute;n con reserva de facultad de cesi&oacute;n de remate.</div>'''''' ' ||
		' WHERE TAP_CODIGO='''||V_TAREA||'''';

	V_TAREA:='H006_ResenyarFechaComparecencia';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET ' ||
		' TAP_DESCRIPCION=''Registrar fecha comparecencia'', ' ||
		' TAP_SCRIPT_DECISION=''valores[''''H006_AperturaPlazo''''][''''cbCresionRemate'''']==''''CIM2'''' ? ''''aCimenta2'''' : ''''aTerceros'''''' ' ||
		' WHERE TAP_CODIGO='''||V_TAREA||'''';

	V_TAREA:='H006_RealizacionCesionRemate';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TFI_NOMBRE=''comboTitularizado'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET ' ||
		' TAP_SCRIPT_DECISION=''valores[''''H006_AperturaPlazo''''][''''cbTitulizado'''']==DDSiNo.SI || valores[''''H006_AperturaPlazo''''][''''cbCresionRemate'''']==''''CIM2'''' ? ''''cimenta2oTitulizado'''' : ''''sinAdjudicacion'''''', ' ||
		' TAP_ALERT_VUELTA_ATRAS=NULL, ' ||
		' TAP_SCRIPT_VALIDACION=''comprobarTipoCargaBienIns() ? (comprobarExisteDocumentoCRACCES() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el acta de cesi&oacute;n.</div>'''') :  ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe revisar el estado de las cargas.</div>'''''', ' ||
		' TAP_DESCRIPCION=''Registrar realización cesión de remate'' ' ||
		' WHERE TAP_CODIGO='''||V_TAREA||'''';
		
	-- BORRADO DE TAREA (lógico)
	V_TAREA:='H006_ConfirmarContabilidad';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''DEL_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''GONZALO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
		

	/* ------------------- -------------------------- */
	/* ------------------- -------------------------- */

	-- LOOP Insertando valores en TAP_TAREA_PROCEDIMIENTO
    VAR_TABLENAME := 'DD_TPO_TIPO_PROCEDIMIENTO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar TAREAS');
    FOR I IN V_TIPO_TPO.FIRST .. V_TIPO_TPO.LAST
      LOOP
        V_TMP_TIPO_TPO := V_TIPO_TPO(I);
        V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.' || VAR_TABLENAME || ' SET ' ||
        		' DD_TPO_CODIGO='''||REPLACE(TRIM(V_TMP_TIPO_TPO(1)),'''','''''') ||''''|| 
        		' ,DD_TPO_XML_JBPM='''||REPLACE(TRIM(V_TMP_TIPO_TPO(5)),'''','''''')||''''||
				' WHERE DD_TPO_CODIGO='''||REPLACE(TRIM(V_TMP_TIPO_TPO(1)),'''','''''') ||'''';
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TPO(1) ||''','''||TRIM(V_TMP_TIPO_TPO(2))||'''');
            EXECUTE IMMEDIATE V_MSQL;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Procedimiento');

    -- LOOP Insertando valores en TAP_TAREA_PROCEDIMIENTO
    VAR_TABLENAME := 'TAP_TAREA_PROCEDIMIENTO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar TAREAS');
    FOR I IN V_TIPO_TAP.FIRST .. V_TIPO_TAP.LAST
      LOOP
        V_TMP_TIPO_TAP := V_TIPO_TAP(I);
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || ' (' ||
                    'TAP_ID,DD_TPO_ID,TAP_CODIGO,TAP_VIEW,TAP_SCRIPT_VALIDACION,TAP_SCRIPT_VALIDACION_JBPM,TAP_SCRIPT_DECISION,DD_TPO_ID_BPM,' ||
                    'TAP_SUPERVISOR,TAP_DESCRIPCION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,TAP_ALERT_NO_RETORNO,TAP_ALERT_VUELTA_ATRAS,DD_FAP_ID,' ||
                    'TAP_AUTOPRORROGA,DTYPE,TAP_MAX_AUTOP,DD_TGE_ID,DD_STA_ID,TAP_EVITAR_REORG,DD_TSUP_ID,TAP_BUCLE_BPM) ' ||
                    'SELECT ' ||
                    'S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL, ' ||
                    '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(1)),'''','''''')  || '''),' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(2)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(3)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(5)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(6)),'''','''''') || ''',' || 
                    '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(7)),'''','''''') || '''),' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(8)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(9)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(10)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(11)),'''','''''') || ''',' ||
                    'sysdate,''' || REPLACE(TRIM(V_TMP_TIPO_TAP(12)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(13)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(14)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(15)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(16)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(17)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(18)),'''','''''') || ''',' ||
                    '(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(19)) || '''),' || 
                    '(SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' || 
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(21)),'''','''''')
										|| ''',' ||'(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO='''|| REPLACE(TRIM(V_TMP_TIPO_TAP(22)),'''','''''') || ''')'
										|| ',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(23)),'''','''''') || ''' FROM DUAL';
          
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TAP(2)||''','''||TRIM(V_TMP_TIPO_TAP(9))||'''');
            EXECUTE IMMEDIATE V_MSQL;
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Tareas');


    -- LOOP Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    VAR_TABLENAME := 'DD_PTP_PLAZOS_TAREAS_PLAZAS';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar PLAZOS');
    FOR I IN V_TIPO_PLAZAS.FIRST .. V_TIPO_PLAZAS.LAST
      LOOP
        V_TMP_TIPO_PLAZAS := V_TIPO_PLAZAS(I);
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || 
                    '(DD_PTP_ID,DD_JUZ_ID,DD_PLA_ID,TAP_ID,DD_PTP_PLAZO_SCRIPT,VERSION,BORRADO,USUARIOCREAR,FECHACREAR)' ||
                    'SELECT ' ||
                    'S_DD_PTP_PLAZOS_TAREAS_PLAZAS.NEXTVAL, ' ||
                    '(SELECT DD_JUZ_ID FROM ' || V_ESQUEMA || '.DD_JUZ_JUZGADOS_PLAZA WHERE DD_JUZ_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(1)) || '''), ' ||
                    '(SELECT DD_PLA_ID FROM ' || V_ESQUEMA || '.DD_PLA_PLAZAS WHERE DD_PLA_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(2)) || '''), ' ||
                    '(SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(3)) || '''), ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(5)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(6)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(7)),'''','''''') || ''', sysdate FROM DUAL'; 

            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_PLAZAS(3) ||''','''||TRIM(V_TMP_TIPO_PLAZAS(4))||'''');
            EXECUTE IMMEDIATE V_MSQL;
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Plazos');

    -- LOOP Insertando valores en TFI_TAREAS_FORM_ITEMS
    VAR_TABLENAME := 'TFI_TAREAS_FORM_ITEMS';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar Campos de tareas');
    FOR I IN V_TIPO_TFI.FIRST .. V_TIPO_TFI.LAST
      LOOP
        V_TMP_TIPO_TFI := V_TIPO_TFI(I);
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || 
                    '(TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)' ||
                    'SELECT ' ||
                    'S_TFI_TAREAS_FORM_ITEMS.NEXTVAL, ' ||
                    '(SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_TFI(1)) || '''), ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(2)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(3)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(5)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(6)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(7)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(8)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(9)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(10)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(11)),'''','''''') || ''',sysdate,0 FROM DUAL'; 
            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TFI(1) ||''','''||TRIM(V_TMP_TIPO_TFI(4))||'''');
            EXECUTE IMMEDIATE V_MSQL;
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Campos');

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