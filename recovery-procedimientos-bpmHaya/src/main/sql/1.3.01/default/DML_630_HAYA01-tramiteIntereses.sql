/*
--##########################################
--## Author: JoseVi Jimenez
--## Adaptado a BP : Gonzalo Estellés
--## Finalidad: Tramite de Reapertura de concurso
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
      T_TIPO_TPO('H043',  'P. reapertura de concurso',  'P. reapertura de concurso',  '', 'tramiteReaperturaConcurso',  '0',  'DD', '0',  'CO', '', '', '1',  'MEJTipoProcedimiento', '1',  '0')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
      T_TIPO_TAP('H043',  'H043_registrarOposicion',  '', '', '( (valores[''H043_registrarOposicion''][''comboOposicion''] == DDSiNo.SI) && ((valores[''H043_registrarOposicion''][''fechaOposicion''] == null) || (valores[''H043_registrarOposicion''][''fechaVista''] == null)) ) ? ''tareaExterna.error.faltaAlgunaFecha'':null', 'valores[''H043_registrarOposicion''][''comboOposicion''] == DDSiNo.SI ? ''SI'' : (valores[''H043_registrarOposicion''][''comboOposicion''] == DDSiNo.NO ? ''NO'':''ALLANAMIENTO'')', '', '0',  'Registrar oposición',  '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GUCL', ''),
      T_TIPO_TAP('H043',  'H043_SolicitudConcursal',  '', '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>¡Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null',  '', '', '', '0',  'Presentar solicitud reapertura concurso',  '0',  'DD', '0',  '', '', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GUCL', ''),
      T_TIPO_TAP('H043',  'H043_ResolucionFirme', '', '', '', 'valores[''H043_RegistrarResolucion''][''comboResultado''] == DDFavorable.FAVORABLE ? ''Favorable'' : ''Desfavorable''',  '', '0',  'Resolución firme', '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GUCL', ''),
      T_TIPO_TAP('H043',  'H043_RegistrarVista',  '', '', '', '', '', '0',  'Registrar vista',  '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GUCL', ''),
      T_TIPO_TAP('H043',  'H043_RegistrarResolucion', '', '', '', '', '', '0',  'Registrar resolución', '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GUCL', ''),
      T_TIPO_TAP('H043',  'H043_ConfirmarNotificacionDemandado',  '', '', '', '', '', '0',  'Confirmar notificación al concursado', '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GUCL', ''),
      T_TIPO_TAP('H043',  'H043_ConfirmarAdmision', 'plugin/procedimientos/tramiteReaperturaConcurso/confirmarAdmision',  '', '', '', '', '0',  'Confirmar admisión', '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GUCL', ''),
      T_TIPO_TAP('H043',  'H043_BPMtramiteFaseComunOrdinario',  '', '', '', '', 'H045', '0',  'Ejecución del Trámite fase común ordinario', '0',  'DD', '0',  '', '', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GUCL', ''),
      T_TIPO_TAP('H043',  'H043_BPMtramiteFaseComunAbreviado',  '', '', '', '', 'H009', '0',  'Ejecución del Trámite fase común abreviado', '0',  'DD', '0',  '', '', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GUCL', ''),
      T_TIPO_TAP('H043',  'H043_AutoDeclarandoConcurso',  '', '', '', 'valores[''H043_AutoDeclarandoConcurso''][''comboEligeTramite''] == DDAccionAuto.ORDINARIO ? ''NO'' : ''SI''',  '', '0',  'Auto declarando reapertura de concurso', '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GUCL', '')
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
      T_TIPO_PLAZAS('', '', 'H043_SolicitudConcursal',  '15*24*60*60*1000L',  '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H043_ConfirmarAdmision', 'damePlazo(valores[''H043_SolicitudConcursal''][''fecha'']) + 30*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H043_ConfirmarNotificacionDemandado',  'damePlazo(valores[''H043_ConfirmarAdmision''][''fecha'']) + 15*24*60*60*1000L',  '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H043_registrarOposicion',  'damePlazo(valores[''H043_ConfirmarNotificacionDemandado''][''fecha'']) + 5*24*60*60*1000L',  '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H043_RegistrarVista',  'damePlazo(valores[''H043_registrarOposicion''][''fechaVista'']) + 2*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H043_RegistrarResolucion', 'damePlazo(valores[''H043_RegistrarVista''][''fecha'']) + 15*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H043_ResolucionFirme', 'damePlazo(valores[''H043_RegistrarResolucion''][''fecha'']) + 5*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H043_AutoDeclarandoConcurso',  'valores[''H043_registrarOposicion''][''comboOposicion''] == DDSiNo.SI ? damePlazo(valores[''H043_ResolucionFirme''][''fechaResolucion'']) + 5*24*60*60*1000L : damePlazo(valores[''H043_ConfirmarNotificacionDemandado''][''fecha'']) + 15*24*60*60*1000L',  '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H043_BPMtramiteFaseComunAbreviado',  '300*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H043_BPMtramiteFaseComunOrdinario',  '300*24*60*60*1000L', '0',  '0',  'DD')
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
      T_TIPO_TFI('H043_SolicitudConcursal', '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Consignar fecha de presentaci&oacute;n de la solicitud concursal. Ind&iacute;quese la plaza del juzgado y procurador que representa a la entidad.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; &quot;Confirmar admisi&oacute;n&quot;.</p></div>', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H043_SolicitudConcursal', '1',  'date', 'fecha',  'Fecha de presentación',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H043_SolicitudConcursal', '2',  'combo',  'plazaJuzgado', 'Plaza del juzgado',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  'damePlaza()',  'TipoPlaza',  '0',  'DD'),
      T_TIPO_TFI('H043_SolicitudConcursal', '3',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H043_ConfirmarAdmision',  '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Ind&iacute;quese la fecha en la que se nos notifica la admisi&oacute;n de la solicitud concursal, el juzgado en el que ha reca&iacute;do y el n&uacute;mero de procedimiento.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; &quot;Confirmar notificaci&oacute;n demandado&quot;.</p></div>', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H043_ConfirmarAdmision',  '1',  'date', 'fecha',  'Fecha',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H043_ConfirmarAdmision',  '2',  'combo',  'nPlaza', 'Plaza',  '', '', '', 'TipoPlaza',  '0',  'DD'),
      T_TIPO_TFI('H043_ConfirmarAdmision',  '3',  'combo',  'numJuzgado', 'Nº Juzgado', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  'dameNumJuzgado()', 'TipoJuzgado',  '0',  'DD'),
      T_TIPO_TFI('H043_ConfirmarAdmision',  '4',  'textproc', 'procedimiento',  'Nº Procedimiento', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  'dameNumAuto()',  '', '0',  'DD'),
      T_TIPO_TFI('H043_ConfirmarAdmision',  '5',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H043_ConfirmarNotificacionDemandado', '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debe indicar la fecha de la notificaci&oacute;n al concursado.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; &quot;Registrar oposici&oacute;n&quot;</div>', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H043_ConfirmarNotificacionDemandado', '1',  'date', 'fecha',  'Fecha',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H043_ConfirmarNotificacionDemandado', '2',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H043_registrarOposicion', '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez notificado al demandado, en esta pantalla ha de indicar si el mismo se ha opuesto o no a la solicitud.</p><p style="margin-bottom: 10px">En el supuesto de que exista oposici&oacute;n, deber&aacute; consignar tanto la fecha de notificaci&oacute;n como la fecha de celebraci&oacute;n de la vista.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute;:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">Si no hay oposici&oacute;n: &quot;Auto declarando concurso&quot;.</li><li style="margin-bottom: 10px; margin-left: 35px;">Si hay oposici&oacute;n: &quot;Registrar vista&quot;.</li></ul></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H043_registrarOposicion', '1',  'combo',  'comboOposicion', 'Existe oposición', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', 'DDSiNoAllanamiento', '0',  'DD'),
      T_TIPO_TFI('H043_registrarOposicion', '2',  'date', 'fechaOposicion', 'Fecha oposición',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H043_registrarOposicion', '3',  'date', 'fechaVista', 'Fecha vista',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H043_registrarOposicion', '4',  'textarea', 'observaciones',  'Observaciones',  '', 'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H043_RegistrarVista', '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debemos de consignar la fecha de celebraci&oacute;n de la vista. En el caso de que se aplace la vista deber&aacute; solicitar la consiguiente pr&oacute;rroga al supervisor, para de este modo aplazar la fecha de fin de esta tarea.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; &quot;Registrar resoluci&oacute;n&quot;.</p></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H043_RegistrarVista', '1',  'date', 'fecha',  'Fecha',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H043_RegistrarVista', '2',  'textarea', 'observaciones',  'Observaciones',  '', 'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H043_RegistrarResolucion',  '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se deber&aacute; de consignar la fecha de notificaci&oacute;n de la Resoluci&oacute;n que hubiere reca&iacute;do como consecuencia de la vista celebrada.</p><p style="margin-bottom: 10px">Se indicar&aacute; si el resultado de dicha resoluci&oacute;n ha sido favorable para los intereses de la entidad o no.</p><p style="margin-bottom: 10px">Para el supuesto de que la resoluci&oacute;n no fuere favorable para la entidad, deber&aacute; comunicar dicha circunstancia al responsable interno de la misma a traves del bot&oacute;n &quot;Comunicaci&oacute;n&quot;. Una vez reciba la aceptación del supervisor deber&aacute; gestionar el recurso por medio de la pestaña &quot;Recursos&quot;.</p><p style="margin-bottom: 10px">Para el supuesto de anuncio del recurso por la parte contraria se deber&aacute; gestionar directamente a trav&eacute;s de la pestaña &quot;Recursos&quot;.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; &quot;Resoluci&oacute;n firme&quot;.</p></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H043_RegistrarResolucion',  '1',  'date', 'fecha',  'Fecha',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H043_RegistrarResolucion',  '2',  'combo',  'comboResultado', 'Resultado',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', 'DDFavorable',  '0',  'DD'),
      T_TIPO_TFI('H043_RegistrarResolucion',  '3',  'textarea', 'observaciones',  'Observaciones',  '', 'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H043_ResolucionFirme',  '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se deber&aacute; consignar la fecha en la que la Resoluci&oacute;n adquiere firmeza.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute;:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">Si la sentencia nos ha sido Favorable: &quot;Auto declarando concurso&quot;.</li><li style="margin-bottom: 10px; margin-left: 35px;">Si la sentencia nos ha sido Desfavorable: Se le abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</li></ul></div>', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H043_ResolucionFirme',  '1',  'date', 'fechaResolucion',  'Fecha firmeza',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H043_ResolucionFirme',  '2',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H043_AutoDeclarandoConcurso', '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se deber&aacute; consignar la fecha del auto declarando concurso as&iacute; como el tr&aacute;mite que se quiere iniciar a continuaci&oacute;n, bien sea un Fase com&uacute;n ordinario o Abreviado..</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se iniciar&aacute; el tr&aacute;mite que haya elegido.</p><p style="margin-bottom: 10px">En el campo "Situación concursal" deberá indicar la situación en la que queda el concurso una vez completada esta tarea.</div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H043_AutoDeclarandoConcurso', '1',  'date', 'fecha',  'Fecha',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H043_AutoDeclarandoConcurso', '2',  'combo',  'comboEligeTramite',  'Trámite a iniciar',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', 'DDAccionAuto', '0',  'DD'),
      T_TIPO_TFI('H043_AutoDeclarandoConcurso', '3',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H043_BPMtramiteFaseComunOrdinario', '0',  'label',  'titulo', 'Ejecución del Trámite fase común ordinario', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H043_BPMtramiteFaseComunAbreviado', '0',  'label',  'titulo', 'Ejecución del Trámite fase común abreviado', '', '', '', '', '0',  'DD')
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