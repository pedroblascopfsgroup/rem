/*
--##########################################
--## Author: JoseVi Jimenez
--## Adaptado a BP : Gonzalo Estellés
--## Finalidad: Tramite de Depósito
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
      T_TIPO_TPO('H034',  'T. de depósito', 'Trámite de depósito',  '', 'tramiteDeposito',  '0',  'DD', '0',  'TR', '', '', '1',  'MEJTipoProcedimiento', '1',  '0')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
      T_TIPO_TAP('H034',  'H034_SolicitarRemocion', '', '', '', '', '', '0',  'Solicitar remoción de depósito', '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '01', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GDEU', ''),
      T_TIPO_TAP('H034',  'H034_SolicitarNombramiento', '', '', '', '', '', '0',  'Solicitar nombramiento de depositario',  '0',  'DD', '0',  '', '', '01', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GDEU', ''),
      T_TIPO_TAP('H034',  'H034_NombramientoDepositario', '', '', '', '', '', '0',  'Nombramiento de depositario',  '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '01', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GDEU', ''),
      T_TIPO_TAP('H034',  'H034_AcuerdoEntrega',  '', '', '', '', '', '0',  'Acuerdo de entrega a depositario', '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '01', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GDEU', ''),
      T_TIPO_TAP('H034',  'H034_ContactarDeudor', '', '', '', '', '', '0',  'Contactar con el deudor',  '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '01', '1',  'EXTTareaProcedimiento',  '3',  '', '803', '', 'SDEU', ''),
      T_TIPO_TAP('H034',  'H034_AceptacionCargoDepositario',  '', 'comprobarExisteDocumentoDJAC() ? null : ''Es necesario adjuntar el Documento del Juzgado de Aceptación del Cargo.''', '', '', '', '0',  'Aceptación cargo de depositário',  '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '01', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GDEU', '')
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
      T_TIPO_PLAZAS('', '', 'H034_SolicitarNombramiento', '4*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H034_NombramientoDepositario', '30*24*60*60*1000L',  '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H034_AceptacionCargoDepositario',  '30*24*60*60*1000L',  '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H034_SolicitarRemocion', '10*24*60*60*1000L',  '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H034_ContactarDeudor', '2*24*60*60*1000L',  '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H034_AcuerdoEntrega',  '30*24*60*60*1000L',  '0',  '0',  'DD')
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
      T_TIPO_TFI('H034_SolicitarNombramiento',  '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En este campo se ha de indicar la fecha en la que se solicita del Juzgado el nombramiento de depositario del bien que ha sido objeto de embargo.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H034_SolicitarNombramiento',  '1',  'date', 'fechaSolicitud', 'Fecha solicitud',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H034_SolicitarNombramiento',  '2',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H034_NombramientoDepositario',  '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que hemos solicitado nombramiento de depositario, en esta pantalla se ha de consignar la fecha en la que por el Juzgado se nos notifica el nombramiento de depositario.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H034_NombramientoDepositario',  '1',  'date', 'fecha',  'Fecha',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H034_NombramientoDepositario',  '2',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H034_AceptacionCargoDepositario', '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se ha de determinar la fecha en la que el Depositario ha sido citado en el Juzgado para la aceptaci&oacute;n del cargo, siendo que la misma se ha de consignar en el supuesto en el que &eacute;ste hubiere aceptado.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H034_AceptacionCargoDepositario', '1',  'date', 'fecha',  'Fecha',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H034_AceptacionCargoDepositario', '2',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H034_SolicitarRemocion',  '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En este campo &uacute;nicamente se ha de introducir la fecha en la que se presenta en el Juzgado escrito solicitando la remoci&oacute;n de dep&oacute;sito para constancia en la herramienta.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H034_SolicitarRemocion',  '1',  'date', 'fecha',  'Fecha',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H034_SolicitarRemocion',  '2',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H034_ContactarDeudor',  '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta tarea el gestor de deuda correspondiente, deber&aacute; ponerse en contacto con el deudor para realizar la comunicación pertinente.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H034_ContactarDeudor',  '1',  'date', 'fecha',  'Fecha',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H034_ContactarDeudor',  '2',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H034_AcuerdoEntrega', '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se ha de introducir en esta pantalla la fecha en la que el Juzgado acuerda la entrega del bien objeto de embargo al depositario, con cuantos tr&aacute;mites sean necesarios para la pr&aacute;ctica de la remoci&oacute;n.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H034_AcuerdoEntrega', '1',  'date', 'fecha',  'Fecha',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H034_AcuerdoEntrega', '2',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD')
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