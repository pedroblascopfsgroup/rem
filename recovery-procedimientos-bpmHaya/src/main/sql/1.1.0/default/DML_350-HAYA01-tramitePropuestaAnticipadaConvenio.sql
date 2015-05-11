/*
--######################################################################
--## Author: Gonzalo
--## BPM: Trámite Propuesta Anticipada Convenio (H031)
--## Finalidad: Insertar datos en tablas de configuración del BPM
--## INSTRUCCIONES: Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--######################################################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    
    PAR_TABLENAME_TPROC VARCHAR2(50 CHAR) := 'DD_TPO_TIPO_PROCEDIMIENTO';   -- [PARAMETRO] TABLA para tipo de procedimiento. Por defecto DD_TPO_TIPO_PROCEDIMIENTO
    V_CODIGO_TPO VARCHAR2(100 CHAR); -- Variable para nombre campo FK con codigo de Tipo procedimiento
    
    CODIGO_PROCEDIMIENTO_ANTIGUO VARCHAR2(10 CHAR) := 'P30'; -- Variable con el código (DD_TPO_ID) del procedimiento antiguo para poder desactivarlo

    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
    	T_TIPO_TPO('H031','T. Propuesta Anticipada Convenio','T. Propuesta Anticipada Convenio',null,'haya_tramitePropuestaAnticipadaConvenio','0','DD','0','CO',null,null,'1','MEJTipoProcedimiento','1','0')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    
    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
		T_TIPO_TAP('H031','H031_resgistrarNumProcedimiento',null,'comprobarExisteDocumentoPRAC() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Para completar esta tarea debe adjuntar el documento "Propuesta Anticipada Convenio" al procedimiento.</div>''',null,null,null,'0','Confirmar solicitud','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H031','H031_registrarPropAnticipadaConvenio',null,null,'existeConvenioAnticipado() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.noHayConvenioAnticipado''',null,null,'0','Registrar propuesta anticipada convenio','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H031','H031_BPMElevarPropuestaSarebLitigios',null,null,null,null,'H012','0','Trámite Elevar Propuesta Sareb Litigios','0','DD','0',null,null,null,'0','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H031','H031_ValidarInstrucciones',null,null,null,null,null,'0','Validar Instrucciones','0','DD','0',null,null,null,'0','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H031','H031_admisionTramiteConvenio',null,'comprobarExisteDocumentoREAC() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Para completar esta tarea debe adjuntar el documento "Resoluci&oacute;n Admisi&oacute;n Convenio" al procedimiento.</div>''','existeConvenioAnticipado() ? ( valores[''H031_admisionTramiteConvenio''][''comboAdmitido''] == DDSiNo.SI ? (existeConvenioAnticipadoAdmitido() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.noHayConvenioAnticipadoAdmitido'') : (existeConvenioAnticipadoNoAdmitido() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.noHayConvenioAnticipadoNoAdmitido'')) : ''tareaExterna.procedimiento.tramiteFaseComun.noHayConvenioAnticipado''','valores[''H031_admisionTramiteConvenio''][''comboAdmitido''] == DDSiNo.SI ? ''SI'' : ''NO''',null,'0','Admisión a tramite propuesta de convenio','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H031','H031_informeAdmonConcursal',null,'comprobarExisteDocumentoIACPAC() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Para completar esta tarea debe adjuntar el documento "Informe AC (Propuesta Anticipada Convenio)" al procedimiento.</div>''','existeConvenioAnticipado() ? ( valores[''H031_informeAdmonConcursal''][''comboRatificacion''] == ''1'' ? null : (    
		(valores[''H031_informeAdmonConcursal''][''comboRatificacion''] == ''2'' ?        
		(existeConvenioAnticipadoNoAdmitidoTrasAprobacion() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.noHayConvenioAnticipadoNoAdmitidoTrasAprobacion'')     
		: (valores[''H031_informeAdmonConcursal''][''comboRatificacion''] == ''3'' ?           
		(existeConvenioAnticipadoAdmitidoTrasAprobacion() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.noHayConvenioAnticipadoAdmitidoTrasAprobacion'')          
		: null )    
		))) : ''tareaExterna.procedimiento.tramiteFaseComun.noHayConvenioAnticipado''','valores[''H031_informeAdmonConcursal''][''comboRatificacion''] == ''2'' ? ''noDescartar'' : ''favOContinuar''',null,'0','Registrar inf. admon. concursal sobre convenio  anticipado','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H031','H031_RegResolucionConvenio',null,null,'existeConvenioAnticipadoAdmitido() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.noHayConvenioAnticipadoAdmitido''',null,null,'0','Registrar resolución de convenio','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H031','H031_ContabilizarConvenio',null,null,null,null,null,'0','Contabilizar Convenio','0','DD','0',null,'tareaExterna.cancelarTarea',null,'0','EXTTareaProcedimiento','3',null,'805',null,'SSDE',null)
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
		T_TIPO_PLAZAS(null,null,'H031_resgistrarNumProcedimiento','5*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H031_registrarPropAnticipadaConvenio','2*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H031_BPMElevarPropuestaSarebLitigios','300*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H031_ValidarInstrucciones','2*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H031_admisionTramiteConvenio','30*24*60*60*1000L','0','0','DD'),
--		T_TIPO_PLAZAS(null,null,'H031_BPMTramiteAdhesionConvenio','300*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H031_informeAdmonConcursal','damePlazo(valores[''H031_admisionTramiteConvenio''][''fecha'']) + 10*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H031_RegResolucionConvenio','30*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H031_ContabilizarConvenio','5*24*60*60*1000L','0','0','DD')
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
		T_TIPO_TFI('H031_resgistrarNumProcedimiento','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Ind&iacute;quese el n&uacute;mero de procedimiento que fuere asignado, en caso de no haberlo o desconocerlo introduzca uno provisional, por ejemplo 00000/2010.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Registrar propuesta anticipada convenio".</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H031_resgistrarNumProcedimiento','1','textproc','procedimiento','Nº Procedimiento','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','dameNumAuto()',null,'0','DD'),
		T_TIPO_TFI('H031_resgistrarNumProcedimiento','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H031_registrarPropAnticipadaConvenio','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; registrar un convenio de tipo anticipado, para ello deber&aacute; abrir la pesta&ntilde;a "Convenios" de la ficha del asunto correspondiente y  registrar un nuevo convenio, introduciendo la descripci&oacute;n de los cr&eacute;ditos en el campo "Resumen propuesta convenio anticipado".</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Admisi&oacute;n a tr&aacute;mite convenio", al mismo tiempo se iniciar&aacute; el "Tr&aacute;mite de adhesi&oacute;n a convenio".</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H031_registrarPropAnticipadaConvenio','1','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H031_BPMElevarPropuestaSarebLitigios','0','label','titulo','Se inicia el trámite de Elevar Propuesta Sareb Litigios',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H031_ValidarInstrucciones','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla el letrado debe validar las instrucciones de Sareb y comunicarselo al deudor.</p><p style="margin-bottom: 10px">En el campo observaciones informar de cualquier aspecto relevante que le interese quede reflejado en este punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H031_ValidarInstrucciones','1','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H031_admisionTramiteConvenio','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Informar fecha de resoluci&oacute;n de la admisi&oacute;n o no a tr&aacute;mite, del convenio anticipado as&iacute; como el resultado. Para dar por terminada esta tarea deber&aacute; registrar el estado correspondiente en el convenio anticipado, para ello deber&aacute; abrir la pesta&ntilde;a "Convenios" de la ficha de asunto correspondiente e introducir el estado correcto en el campo Estado.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute;, si se ha admitido el convenio " Informe administraci&oacute;n concursal " y en caso contrario una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H031_admisionTramiteConvenio','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H031_admisionTramiteConvenio','2','combo','comboAdmitido','Admitido','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('H031_admisionTramiteConvenio','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
--		T_TIPO_TFI('H031_BPMTramiteAdhesionConvenio','0','label','titulo','Se inicia el trámite de adhesión a convenio',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H031_informeAdmonConcursal','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se deber&aacute; de informar la fecha de publicaci&oacute;n del informe de la administraci&oacute;n concursal que hubiere reca&iacute;do as&iacute; como la ratificaci&oacute;n judicial.</p><p style="margin-bottom: 10px">Se indicar&aacute; el resultado del informe concursal seg&uacute;n haya sido favorable o no al convenio anticipado presentado.</p><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; registrar el estado en el que queda el convenio anticipado, para ello deber&aacute; abrir la pesta&ntilde;a Convenios de la ficha del asunto correspondiente e introducir el estado correcto en el campo "Estado" ya sea "Aprobaci&oacute;n judicial" o "No aprobado".</p><p style="margin-bottom: 10px">Para el supuesto de que la resoluci&oacute;n no fuere favorable para la entidad, deber&aacute; comunicar dicha circunstancia al responsable interno de la misma a trav&eacute;s del bot&oacute;n "Comunicaci&oacute;n". Una vez reciba la aceptaci&oacute;n del supervisor deber&aacute; gestionar el recurso por medio de la pesta&ntilde;a "Recursos".</p><p style="margin-bottom: 10px">Para el supuesto de anuncio del recurso por la parte contraria se deber&aacute; gestionar directamente a trav&eacute;s de la pesta&ntilde;a "Recursos".</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute;, si el informe ha sido favorable "Registrar resoluci&oacute;n convenio" en caso contrario se iniciar&aacute;n una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H031_informeAdmonConcursal','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H031_informeAdmonConcursal','2','combo','comboResultado','Resultado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDFavorable','0','DD'),
		T_TIPO_TFI('H031_informeAdmonConcursal','3','combo','comboRatificacion','Ratificación judicial','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDRatificacionJudicial','0','DD'),
		T_TIPO_TFI('H031_informeAdmonConcursal','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H031_RegResolucionConvenio','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se deber&aacute; de informar la fecha de notificaci&oacute;n de la Resoluci&oacute;n del convenio.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se iniciar&aacute; una tarea para que desde soporte de deuda se proceda a la contabilizaci&oacute;n del convenio.</p></div>',null,null,null,null,'1','DD'),
		T_TIPO_TFI('H031_RegResolucionConvenio','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H031_RegResolucionConvenio','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H031_ContabilizarConvenio','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se deber&aacute; de informar la fecha en la que ha contabilizado el convenio.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se iniciar&aacute; una tarea en la que el letrado propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>',null,null,null,null,'1','DD'),
		T_TIPO_TFI('H031_ContabilizarConvenio','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H031_ContabilizarConvenio','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD')
    ); 
    V_TMP_TIPO_TFI T_TIPO_TFI;
    
BEGIN	

    -- LOOP Insertando valores en TAP_TAREA_PROCEDIMIENTO
    VAR_TABLENAME := 'DD_TPO_TIPO_PROCEDIMIENTO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar TAREAS');
    FOR I IN V_TIPO_TPO.FIRST .. V_TIPO_TPO.LAST
      LOOP
        V_TMP_TIPO_TPO := V_TIPO_TPO(I);
        
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || ' (' ||
                    'DD_TPO_ID,DD_TPO_CODIGO,DD_TPO_DESCRIPCION,DD_TPO_DESCRIPCION_LARGA,' ||
                    'DD_TPO_HTML,DD_TPO_XML_JBPM,VERSION,USUARIOCREAR,' ||
                    'FECHACREAR,BORRADO,DD_TAC_ID,DD_TPO_SALDO_MIN,'||
                    'DD_TPO_SALDO_MAX,FLAG_PRORROGA,DTYPE,FLAG_DERIVABLE,FLAG_UNICO_BIEN) ' ||
                    'SELECT ' ||
                    'S_DD_TPO_TIPO_PROCEDIMIENTO.NEXTVAL, ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(1)),'''','''''') 
                    || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(2)),'''','''''') 
                    || ''',' || '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(3)),'''','''''') 
                    || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(4)),'''','''''') 
                    || ''',' || '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(5)),'''','''''') 
                    || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(6)),'''','''''') 
                    || ''',' || '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(7)),'''','''''') 
                    || ''',sysdate,' 
                    || '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(8)),'''','''''') 
                    || ''',' || '(SELECT DD_TAC_ID FROM '|| V_ESQUEMA ||'.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO=''' || TRIM(V_TMP_TIPO_TPO(9)) || '''),' ||
                    '''' || TRIM(V_TMP_TIPO_TPO(10)) 
                    || ''',''' || TRIM(V_TMP_TIPO_TPO(11)) 
                    || ''',''' || TRIM(V_TMP_TIPO_TPO(12)) 
                    || ''',' || '''' || TRIM(V_TMP_TIPO_TPO(13)) 
                    || ''',''' || TRIM(V_TMP_TIPO_TPO(14)) 
                    || ''',''' || TRIM(V_TMP_TIPO_TPO(15)) 
                    || ''' FROM DUAL'; 

            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            --DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TPO(1) ||''','''||TRIM(V_TMP_TIPO_TPO(2))||'''');
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
                    	'S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL, ' 
                    	|| '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(1)),'''','''''')  || '''),' 
                    	|| '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(2)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(3)),'''','''''') 
                    	|| ''',' || '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(4)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(5)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(6)),'''','''''') 
                    	|| ''',' || '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(7)),'''','''''') || '''),' 
                    	|| '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(8)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(9)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(10)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(11)),'''','''''') 
                    	|| ''',' || 'sysdate,''' || REPLACE(TRIM(V_TMP_TIPO_TAP(12)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(13)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(14)),'''','''''') 
                    	|| ''',' || '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(15)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(16)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(17)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(18)),'''','''''') 
                    	|| ''',' || '(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(19)) || '''),' 
                    	|| '(SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' 
                    	|| ''''|| REPLACE(TRIM(V_TMP_TIPO_TAP(21)),'''','''''') 
                    	|| ''',' ||'(select dd_tge_id from ' || V_ESQUEMA_MASTER || '.dd_tge_tipo_gestor where dd_tge_codigo='''|| REPLACE(TRIM(V_TMP_TIPO_TAP(22)),'''','''''') || ''')'
                    	|| ',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(23)),'''','''''') 
                    	|| ''' FROM DUAL';
                    
            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            --DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TAP(2)||''','''||TRIM(V_TMP_TIPO_TAP(9))||'''');
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

            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            --DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_PLAZAS(3) ||''','''||TRIM(V_TMP_TIPO_PLAZAS(4))||'''');
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
            --DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TFI(1) ||''','''||TRIM(V_TMP_TIPO_TFI(4))||'''');
            EXECUTE IMMEDIATE V_MSQL;
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Campos');

    /*
     * Desactivamos trámites antiguos si existen
     */
    V_CODIGO_TPO := 'DD_TPO_CODIGO';
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||PAR_TABLENAME_TPROC||' WHERE '||V_CODIGO_TPO||' = '''||CODIGO_PROCEDIMIENTO_ANTIGUO||''' AND BORRADO=0 ';
        
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN
	    V_SQL := 'UPDATE '||V_ESQUEMA||'.'||PAR_TABLENAME_TPROC||' SET BORRADO=1 WHERE '||V_CODIGO_TPO||' = '''||CODIGO_PROCEDIMIENTO_ANTIGUO||''' AND BORRADO=0 ';
        DBMS_OUTPUT.PUT_LINE('Trámite antiguo desactivado.');
        EXECUTE IMMEDIATE V_SQL; 
	END IF;    
    
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