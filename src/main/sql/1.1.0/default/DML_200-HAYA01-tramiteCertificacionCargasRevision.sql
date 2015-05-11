/*
--##########################################
--## Author: JoseVi Jimenez
--## Adaptado a BP : Gonzalo Estellés
--## Finalidad: Tramite de Certificacion de cargas y revisión
--## INSTRUCCIONES:  Verificar esquemas correctos en el Declare
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
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

    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
      T_TIPO_TPO('H030',  'T. certificación de cargas y revisión',  'Trámite de certificación de cargas y revisión',  '', 'tramiteCertificacionCargasRevision', '0',  'DD', '0',  'AP', '', '', '1',  'MEJTipoProcedimiento', '1',  '0')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
      T_TIPO_TAP('H030',  'H030_SolicitudCertificacion',  '', '', '', '', '', '0',  'Solicitud de certificación de dominios y cargas',  '0',  'DD', '0',  '', '', '01', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GDEU', ''),
      T_TIPO_TAP('H030',  'H030_SolicitarInformacionCargasAnt',  '', '', '((valores[''H030_SolicitarInformacionCargasAnt''][''comboResultado''] == DDSiNo.SI) && (valores[''H030_SolicitarInformacionCargasAnt''][''fecha''] == null))?''Debe introducir la fecha de presentaci&oacute;n'':null',  'valores[''H030_SolicitarInformacionCargasAnt''][''comboResultado''] == DDSiNo.SI ? ''SI'' : ''NO''',  '', '0',  'Solicitar información de cargas anteriores', '0',  'DD', '0',  '', '', '01', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GDEU', ''),
      T_TIPO_TAP('H030',  'H030_RequerirInfoFalta', '', '', '', '', '', '0',  'Requerir información que falta', '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '01', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GDEU', ''),
      T_TIPO_TAP('H030',  'H030_RegistrarInformacionCargasAnt',  '', '', '', 'valores[''H030_RegistrarInformacionCargasAnt''][''comboCompletitud''] == DDCompletitud.COMPLETO ? ''Completo'' : ''Incompleto''', '', '0',  'Registrar recepción información cargas anteriores',  '0',  'DD', '0',  '', '', '01', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GDEU', ''),
      T_TIPO_TAP('H030',  'H030_RegistrarCertificacion',  '', 'comprobarExisteDocumentoCCB() ? null : ''Es necesario adjuntar el documento Certificado de cargas de cada bien.''', '((valores[''H030_RegistrarCertificacion''][''comboResultado''] == DDSiNo.SI) && (valores[''H030_RegistrarCertificacion''][''fecha''] == null))?''tareaExterna.error.H030_RegistrarCertificacion.fechaOblgatoria'':null', 'valores[''H030_RegistrarCertificacion''][''comboResultado''] == DDSiNo.SI ? ''SI'' : ''NO''',  '', '0',  'Registrar certificación',  '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '01', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GDEU', ''),
      T_TIPO_TAP('H030',  'H030_ActualizarDatosTerceria', '', '', '', '', '', '0',  'Actualizar datos y estudiar tercería mejor derecho', '0',  'DD', '0',  '', '', '01', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GDEU', ''),
      T_TIPO_TAP('H030',  'H030_ActualizaDatosAnteriores',  '', '', '', '', '', '0',  'Actualizar datos anteriores',  '0',  'DD', '0',  '', '', '01', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GDEU', '')
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
      T_TIPO_PLAZAS('', '', 'H030_SolicitudCertificacion',  '4*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H030_RegistrarCertificacion',  'nVecesTareaExterna == 0 ? 30*24*60*60*1000L : 15*24*60*60*1000L',  '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H030_SolicitarInformacionCargasAnt',  '5*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H030_ActualizaDatosAnteriores',  '5*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H030_ActualizarDatosTerceria', '5*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H030_RegistrarInformacionCargasAnt',  '5*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H030_RequerirInfoFalta', '30*24*60*60*1000L',  '0',  '0',  'DD')
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
      T_TIPO_TFI('H030_SolicitudCertificacion', '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que tenemos bienes embargados y anotado el embargo en el registro, en esta pantalla, debemos consignar la fecha de presentaci&oacute;n en el juzgado del escrito solicitando la certificaci&oacute;n de cargas del bien o bienes respecto de los cuales se ha iniciado la v&iacute;a de apremio.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute; &quot;Registrar certificaci&oacute;n&quot;.</p></div>', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H030_SolicitudCertificacion', '1',  'date', 'fecha',  'Fecha solicitud',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H030_SolicitudCertificacion', '2',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H030_RegistrarCertificacion', '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se deber&aacute; confirmar la obtenci&oacute;n por parte del Registro de la Propiedad de la certificaci&oacute;n solicitada.</p><p style="margin-bottom: 10px">Para el supuesto de haber reseñado &quot;Si&quot;, ser&aacute; obligatorio consignar la fecha de obtenci&oacute;n de la certificaci&oacute;n emitida.</p><p style="margin-bottom: 10px">Para el supuesto de llegar la fecha de vencimiento de la tarea y no hayamos obtenido la certificaci&oacute;n de cargas emitida o remitida por el registro deberemos reseñar &quot;No&quot; obtenida y marcar la fecha de vencimiento de la tarea.</p><p style="margin-bottom: 10px">La certificaci&oacute;n obtenida se deber&aacute; hacer llegar al responsable de la entidad.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute; &quot;Solicitar informaci&oacute;n de cargas anteriores&quot;.</p></div>', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H030_RegistrarCertificacion', '1',  'combo',  'comboResultado', 'Obtenida', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', 'DDSiNo', '0',  'DD'),
      T_TIPO_TFI('H030_RegistrarCertificacion', '2',  'date', 'fecha',  'Fecha',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H030_RegistrarCertificacion', '3',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H030_SolicitarInformacionCargasAnt', '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que hemos obtenido la certificaci&oacute;n de cargas de los bienes trabados, y analizada dicha documentaci&oacute;n, en esta pantalla debemos especificar, para el supuesto de cargas inscritas con anterioridad a la inscripci&oacute;n del embargo practicado por la entidad, si se solicita informaci&oacute;n sobre dichas cargas a los ejecutantes que nos preceden. Para el supuesto contrario se deber&aacute; especificar, en el primer campo de esta pantalla, que &quot;no&quot; se solicita.</p><p style="margin-bottom: 10px">De haber solicitado dicha informaci&oacute;n, se deber&aacute; consignar la fecha de presentaci&oacute;n del escrito en el juzgado.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute;:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">Si se ha solicitado la informaci&oacute;n: &quot;Registrar recepci&oacute;n informaci&oacute;n cargas anteriores&quot;.</li><li style="margin-bottom: 10px; margin-left: 35px;">Si no se ha solicitado la informaci&oacute;n se le abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</li></ul></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H030_SolicitarInformacionCargasAnt', '1',  'combo',  'comboResultado', 'Solicitada', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', 'DDSiNo', '0',  'DD'),
      T_TIPO_TFI('H030_SolicitarInformacionCargasAnt', '2',  'date', 'fecha',  'Fecha',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H030_SolicitarInformacionCargasAnt', '3',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H030_ActualizaDatosAnteriores', '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que el externo ha obtenido del Registro de la Propiedad certificaci&oacute;n de cargas de los bienes embargados, y dicho documento deber&aacute; hacerlo llegar al responsable de la entidad, en esta pantalla deber&aacute; de consignar la fecha de recepci&oacute;n de dicha documentaci&oacute;n, debiendo proceder a la actualizaci&oacute;n de los datos sobre solvencia que obren en su poder.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H030_ActualizaDatosAnteriores', '1',  'date', 'fecha',  'Fecha',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H030_ActualizaDatosAnteriores', '2',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H030_ActualizarDatosTerceria',  '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una  vez se dispone de toda la informaci&oacute;n sobre las cargas anteriores recogidas en la certificaci&oacute;n emitida por el Registro de la Propiedad, en esta pantalla, se ha de consignar la fecha en la que hemos analizado todas ellas y en consecuencia estamos en disposici&oacute;n de seleccionar, en el segundo campo de la pantalla, si cabe o no plantear tercer&iacute;a de mejor derecho sobre carga anotada con anterioridad a la de la entidad.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla se le abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H030_ActualizarDatosTerceria',  '1',  'date', 'fecha',  'Fecha',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H030_ActualizarDatosTerceria',  '2',  'combo',  'comboTerceria',  'Tercería mejor derecho', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', 'DDSiNo', '0',  'DD'),
      T_TIPO_TFI('H030_ActualizarDatosTerceria',  '3',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H030_RegistrarInformacionCargasAnt', '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se debe consignar la fecha de en la que se recibe notificaci&oacute;n de la informaci&oacute;n solicitada. </p><p style="margin-bottom: 10px">En el segundo campo se ha de determinar si la informaci&oacute;n recibida se corresponde con toda la solicitada, en cuyo caso se deber&aacute; seleccionar la palabra &quot;Completo&quot;. En caso contrario estaremos obligados a seleccionar el dato como &quot;Incompleto&quot;.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute;:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">Si la informaci&oacute;n es incompleta: &quot;Requerir informaci&oacute;n que falta&quot;.</li><li style="margin-bottom: 10px; margin-left: 35px;">Si la informaci&oacute;n es completa: &quot;Actualizar datos y estudiar tercer&iacute;a mejor derecho&quot;.</li></ul></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H030_RegistrarInformacionCargasAnt', '1',  'date', 'fecha',  'Fecha',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H030_RegistrarInformacionCargasAnt', '2',  'combo',  'comboCompletitud', 'Información cargas', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', 'DDCompletitud',  '0',  'DD'),
      T_TIPO_TFI('H030_RegistrarInformacionCargasAnt', '3',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H030_RequerirInfoFalta',  '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para el supuesto de que la informaci&oacute;n solicitada haya sido incompleta o falta la contestaci&oacute;n al requerimiento efectuado por el juzgado por alguno de los que tienen anotado embargo con anterioridad al de la entidad, en esta pantalla, se deber&aacute; consignar la fecha en la que se presenta nuevo escrito al juzgado para que se requiera la informaci&oacute;n a&uacute;n no aportada al procedimiento.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute; &quot;Registrar recepci&oacute;n informaci&oacute;n de cargas anteriores&quot;.</p></div>', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H030_RequerirInfoFalta',  '1',  'date', 'fecha',  'Fecha',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H030_RequerirInfoFalta',  '2',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD')
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
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(1)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(2)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(3)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(4)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(5)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(6)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(7)),'''','''''') || ''',sysdate,' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(8)),'''','''''') || ''',' ||
                    '(SELECT DD_TAC_ID FROM '|| V_ESQUEMA ||'.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO=''' || TRIM(V_TMP_TIPO_TPO(9)) || '''),' ||
                    '''' || TRIM(V_TMP_TIPO_TPO(10)) || ''',''' || TRIM(V_TMP_TIPO_TPO(11)) || ''',''' || TRIM(V_TMP_TIPO_TPO(12)) || ''',' ||
                    '''' || TRIM(V_TMP_TIPO_TPO(13)) || ''',''' || TRIM(V_TMP_TIPO_TPO(14)) || ''',''' || TRIM(V_TMP_TIPO_TPO(15)) || ''' FROM DUAL'; 

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