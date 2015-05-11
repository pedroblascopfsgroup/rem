/*
--##########################################
--## Author: JoseVi Jimenez
--## Adaptado a BP : Gonzalo Estellés
--## Finalidad: Tramite de Embargo de Salarios
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
      T_TIPO_TPO('H038',  'T. de Embargo de Salarios',  'Trámite de Embargo de Salarios', '', 'haya_tramiteEmbargoSalarios', '0',  'DD', '0',  'TR', '', '', '1',  'MEJTipoProcedimiento', '1',  '0')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
      T_TIPO_TAP('H038',  'H038_SolicitarNotificacion', '', '', '', '', '', '0',  'Solicitud requerimiento retención al pagador', '0',  'DD', '0',  '', '', '01', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GUCL', ''),
      T_TIPO_TAP('H038',  'H038_GestionarProblemas',  '', '', '', 'valores[''H038_GestionarProblemas''][''comboCorr''] == DDPositivoNegativo.POSITIVO ? ''Correcto'' : ''Incorrecto''', '', '0',  'Gestionar problemas de retención', '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '01', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GUCL', ''),
      T_TIPO_TAP('H038',  'H038_ConfirmarRetenciones',  '', '', '', 'valores[''H038_ConfirmarRetenciones''][''comboCorr''] == DDCorrectoCobro.CORRECTO_COBROS_PENDIENTES ? ''CorrectoCobros'' : valores[''H038_ConfirmarRetenciones''][''comboCorr''] == DDCorrectoCobro.INCORRECTO_COBROS_PENDIENTES ? ''IncorrectoCobros'' : ''CorrectoFin''',  '', '0',  'Confirmar retención practicada', '0',  'DD', '0',  '', '', '01', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GUCL', ''),
      T_TIPO_TAP('H038',  'H038_ConfirmarRequerimientoResultado', '', '', '((valores[''H038_ConfirmarRequerimientoResultado''][''comboRequerido''] == DDSiNo.SI) && ((valores[''H038_ConfirmarRequerimientoResultado''][''comboResultado''] == '''')||(valores[''H038_ConfirmarRequerimientoResultado''][''comboResultado''] == null)||(valores[''H038_ConfirmarRequerimientoResultado''][''importeNom''] == '''')||(valores[''H038_ConfirmarRequerimientoResultado''][''importeRet''] == '''')) )?''tareaExterna.error.H038_ConfirmarRequerimientoResultado.importesYresultado'':null',  'valores[''H038_ConfirmarRequerimientoResultado''][''comboRequerido''] == DDSiNo.NO ? ''ConfirmadoNo'' : valores[''H038_ConfirmarRequerimientoResultado''][''comboResultado''] == DDPositivoNegativo.NEGATIVO ? ''ConfirmadoNo'' : ''ConfirmadoSi''', '', '0',  'Confirmar requerimiento y resultado',  '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '01', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GUCL', ''),
      T_TIPO_TAP('H038',  'H038_ActualizarDatos', '', '', '', '', '', '1',  'Actualizar datos solvencia cliente', '0',  'DD', '0',  '', '', '01', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GUCL', '')
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
      T_TIPO_PLAZAS('', '', 'H038_SolicitarNotificacion', '4*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H038_ConfirmarRequerimientoResultado', '15*24*60*60*1000L',  '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H038_ConfirmarRetenciones',  '30*24*60*60*1000L',  '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H038_GestionarProblemas',  '10*24*60*60*1000L',  '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H038_ActualizarDatos', '10*24*60*60*1000L',  '0',  '0',  'DD')
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
      T_TIPO_TFI('H038_SolicitarNotificacion',  '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que se ha procedido al embargo, por parte del juzgado, de salario del ejecutado, en esta pantalla, se ha de consignar la fecha del escrito presentado para la notificaci&oacute;n de tal extremo al pagador, con solicitud de que informe de la base sobre la que se va a realizar la retenci&oacute;n.</p><p style="margin-bottom: 10px">En el segundo campo se deber&aacute;, cuando se conozca, establecer el importe sobre el que se ha de practicar la retenci&oacute;n.</p><p style="margin-bottom: 10px">En el tercer campo de esta pantalla se ha de consignar el importe de la retenci&oacute;n que, sobre la base, se practica y que es consignada en el juzgado, en la cuenta de consignaciones del mismo.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Dado que se ha procedido al embargo, por parte del juzgado, de salario del ejecutado, en esta pantalla, se ha de consignar la fecha del escrito presentado para la notificaci&oacute;n de tal extremo al pagador, con solicitud de que informe de la base sobre la que se va a realizar la retenci&oacute;n.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute; &quot;Confirmar requerimiento y resultado&quot;</p></div>', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H038_SolicitarNotificacion',  '1',  'date', 'fecha',  'Fecha',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H038_SolicitarNotificacion',  '2',  'currency', 'importeNom', 'Importe base retención', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H038_SolicitarNotificacion',  '3',  'currency', 'importeRet', 'Importe de retención', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H038_SolicitarNotificacion',  '4',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H038_ConfirmarRequerimientoResultado',  '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debemos de confirmar que se ha producido el requerimiento antes solicitado para que se produzcan las retenciones de cantidad, para ello en el primer campo indicamos si el mismo se ha producido o no.</p><p style="margin-bottom: 10px">Si la respuesta a la pregunta anterior es positiva, se ha de indicar en el segundo campo si el resultado del requerimiento ha sido positivo o negativo, siendo que para el primer supuesto deberemos indicar los importes que luego se solicitan. En el caso de que el resultado sea negativo por la circunstancia que fuere, se deber&aacute; iniciar nueva b&uacute;squeda de bienes por el tr&aacute;mite correspondiente, mediante &quot;Proponer decisiones&quot;.</p><p style="margin-bottom: 10px">En el tercer campo se deber&aacute;, cuando se conozca, establecer el importe sobre el que se ha de practicar la retenci&oacute;n.</p><p style="margin-bottom: 10px">En el cuarto campo de esta pantalla se ha de consignar el importe de la retenci&oacute;n que, sobre la base, se practica y que es consignada en el juzgado, en la cuenta de consignaciones del mismo.</p></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H038_ConfirmarRequerimientoResultado',  '1',  'date', 'fecha',  'Fecha',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H038_ConfirmarRequerimientoResultado',  '2',  'combo',  'comboRequerido', 'Requerido',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', 'DDSiNo', '0',  'DD'),
      T_TIPO_TFI('H038_ConfirmarRequerimientoResultado',  '3',  'combo',  'comboResultado', 'Resultado',  '', '', '', 'DDPositivoNegativo', '0',  'DD'),
      T_TIPO_TFI('H038_ConfirmarRequerimientoResultado',  '4',  'currency', 'importeNom', 'Importe base retención', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H038_ConfirmarRequerimientoResultado',  '5',  'currency', 'importeRet', 'Importe retención',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H038_ConfirmarRequerimientoResultado',  '6',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H038_ConfirmarRetenciones', '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debemos consignar la fecha en la que se efect&uacute;a la entrega, por el juzgado, de los correspondientes mandamientos de pago de las cantidades consignadas en la cuenta del mismo.</p><p style="margin-bottom: 10px">En el desplegable del segundo campo de la presente pantalla se deber&aacute; seleccionar la situaci&oacute;n que se corresponda con la realidad de las retenciones practicadas.</p><p style="margin-bottom: 10px">Si la situaci&oacute;n sigue siendo la de proseguir con las retenciones ordenadas por el juzgado, se deber&aacute; marcar &quot;Situaci&oacute;n correcta, continuar&quot; y as&iacute; sucesivamente hasta el cobro de la deuda reclamada.</p><p style="margin-bottom: 10px">Si la situaci&oacute;n es de recuperaci&oacute;n del principal reclamado, se deber&aacute; marcar &quot;Situaci&oacute;n correcta, terminar&quot;, lo que originar&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p><p style="margin-bottom: 10px">Para el supuesto de que la situaci&oacute;n sobre las retenciones practicadas se haya visto modificada y se haya dejado de consignar en la cuenta del juzgado, se deber&aacute; marcar &quot;Situaci&oacute;n incorrecta&quot;, y deberemos gestionar los motivos que han dificultado o impedido las retenciones.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute;:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">Situaci&oacute;n correcta, continuar: &quot;Confirmar retenciones&quot;.</li><li style="margin-bottom: 10px; margin-left: 35px;">Situaci&oacute;n correcta, terminar: se le abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</li><li style="margin-bottom: 10px; margin-left: 35px;">Situaci&oacute;n incorrecta: &quot;Gestionar problemas retenci&oacute;n&quot;.</li></ul></div>', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H038_ConfirmarRetenciones', '1',  'date', 'fecha',  'Fecha',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H038_ConfirmarRetenciones', '2',  'combo',  'comboCorr',  'Situación',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', 'DDCorrectoCobro',  '0',  'DD'),
      T_TIPO_TFI('H038_ConfirmarRetenciones', '3',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H038_GestionarProblemas', '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Habi&eacute;ndose detectado problemas en las retenciones que se ven&iacute;an practicando sobre los ingresos del deudor, la gesti&oacute;n para el conocimiento y soluci&oacute;n de las causas motivadoras de dichos problemas, nos obliga a seleccionar si cabe la soluci&oacute;n de los mismos o no, y al mismo tiempo consignar la fecha de verificaci&oacute;n de la situaci&oacute;n actual.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute;:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">Si el resultado de la gesti&oacute;n es positivo: &quot;Confirmar retenciones&quot;.</li><li style="margin-bottom: 10px; margin-left: 35px;">Si el resultado de la gesti&oacute;n es negativo : &quot;Actualizar datos solvencia cliente&quot;.</li></ul></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H038_GestionarProblemas', '1',  'date', 'fecha',  'Fecha',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H038_GestionarProblemas', '2',  'combo',  'comboCorr',  'Resultado gestión',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', 'DDPositivoNegativo', '0',  'DD'),
      T_TIPO_TFI('H038_GestionarProblemas', '3',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H038_ActualizarDatos',  '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla se le abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H038_ActualizarDatos',  '1',  'date', 'fecha',  'Fecha',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H038_ActualizarDatos',  '2',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD')
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