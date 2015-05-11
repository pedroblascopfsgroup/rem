--/*
--##########################################
--## Author: Equipo Fase II - Bankia
--## Adaptado a BP : Óscar Dorado
--## Finalidad: DML del trámite subasta sareb
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  
  V_ENTIDAD_ID NUMBER(16);
  --Insertando valores en DD_TPO_TIPO_PROCEDIMIENTO
  TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
  V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
    t_tipo_tpo('P414', 'T. de subsanación de decreto de embargo', 'Trámite de subsanación de decreto de embargo',     NULL, 'tramiteSubsanacionEmbargo', 2, NULL, NULL, 8, 'MEJTipoProcedimiento',     1, 0)
  ); 
  V_TMP_TIPO_TPO T_TIPO_TPO; 
  
  
  --Insertando valores en DD_TAP
  TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(2048);
  TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
  V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
       t_tipo_tap('(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P414'')', 'P414_EntregarNuevoDecreto', NULL,     NULL, NULL, NULL, NULL, 0,     'Entregar nuevo decreto/testimonio decreto de adjudicación', NULL,     NULL, NULL, 1, 'EXTTareaProcedimiento', 3,     NULL, NULL, NULL, NULL, NULL),
	   t_tipo_tap('(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P414'')', 'P414_RegistrarPresentacionEscritoSub', NULL,     NULL, NULL, NULL, NULL, 0,     'Registrar presentación de escrito de subsanación', NULL,     NULL, NULL, 1, 'EXTTareaProcedimiento', 3,     NULL, NULL, NULL, NULL, NULL))
   ; 
  V_TMP_TIPO_TAP T_TIPO_TAP; 
  
  --Insertando valores en DD_PTP
  TYPE T_TIPO_PTP IS TABLE OF VARCHAR2(2048);
  TYPE T_ARRAY_PTP IS TABLE OF T_TIPO_PTP;
  V_TIPO_PTP T_ARRAY_PTP := T_ARRAY_PTP(
    t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P414_EntregarNuevoDecreto'')', 'damePlazo(valores[''''P414_RegistrarPresentacionEscritoSub''''][''''fechaPresentacion''''])+60*24*60*60*1000L'),
	t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P414_RegistrarPresentacionEscritoSub'')', '10*24*60*60*1000L')
); 
  V_TMP_TIPO_PTP T_TIPO_PTP; 
  
  --Insertando valores en DD_TFI
  TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(2048);
  TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
  V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P414_EntregarNuevoDecreto'')', 0, 'label', 'titulo',    '	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Solo en el supuesto que este trámite se haya lanzado para la subsanación del testimonio de adjudicación, deberá informar de la fecha en que procede al envío del nuevo testimonio a la gestoría que corresponda.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se dará por terminado este trámite retomando así el trámite de adjudicación.</p></div>', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P414_EntregarNuevoDecreto'')', 1, 'date', 'fechaEnvio',    'Fecha', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P414_EntregarNuevoDecreto'')', 2, 'textarea', 'observaciones',    'Observaciones', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P414_RegistrarPresentacionEscritoSub'')', 0, 'label', 'titulo',    '	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través de esta tarea deberá de consignar la fecha de presentación en el Juzgado del escrito de subsanación.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzará la tarea "Entregar nuevo testimonio decreto de adjudicación".</p></div>', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P414_RegistrarPresentacionEscritoSub'')', 1, 'date', 'fechaPresentacion',    'Fecha', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P414_RegistrarPresentacionEscritoSub'')', 2, 'textarea', 'observaciones',    'Observaciones', NULL, NULL, NULL, NULL)
	); 
  V_TMP_TIPO_TFI T_TIPO_TFI; 
  
BEGIN 
    
    -- 1) LOOP Insertando valores en DD_TPO_TIPO_PROCEDIMIENTO
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO... Empezando a insertar datos en el diccionario');
    FOR I IN V_TIPO_TPO.FIRST .. V_TIPO_TPO.LAST
      LOOP
        V_TMP_TIPO_TPO := V_TIPO_TPO(I);
        -- Comprobamos el dato
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||TRIM(V_TMP_TIPO_TPO(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;			
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO... Ya existe el procedimiento '''|| TRIM(V_TMP_TIPO_TPO(1)) ||'''');
        ELSE
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_TPO_TIPO_PROCEDIMIENTO.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_TPO_TIPO_PROCEDIMIENTO (
                    DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, DD_TPO_SALDO_MIN, DD_TPO_SALDO_MAX, FLAG_PRORROGA, DTYPE, FLAG_DERIVABLE, FLAG_UNICO_BIEN, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                    'SELECT '''|| V_ENTIDAD_ID || ''','''||TRIM(V_TMP_TIPO_TPO(1))||''','''||TRIM(V_TMP_TIPO_TPO(2))||''','''||TRIM(V_TMP_TIPO_TPO(3))||''','''||TRIM(V_TMP_TIPO_TPO(4))||''','||
                     ''''||TRIM(V_TMP_TIPO_TPO(5)) || ''','''||TRIM(V_TMP_TIPO_TPO(6))||''','''||TRIM(V_TMP_TIPO_TPO(7))||''','''||TRIM(V_TMP_TIPO_TPO(8))||''','''||TRIM(V_TMP_TIPO_TPO(9))||''','||                     
                     ''''||TRIM(V_TMP_TIPO_TPO(10)) || ''','''||TRIM(V_TMP_TIPO_TPO(11))||''','''||TRIM(V_TMP_TIPO_TPO(12))||''','|| 
                     '''DML'', sysdate, 0 FROM DUAL';
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TPO(1)||''','''||TRIM(V_TMP_TIPO_TPO(2)));
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO... Datos del diccionario insertado');
    
    
    -- 2) LOOP Insertando valores en TAP_TAREA_PROCEDIMIENTO
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO... Empezando a insertar datos en el diccionario');
    FOR I IN V_TIPO_TAP.FIRST .. V_TIPO_TAP.LAST
      LOOP
        V_TMP_TIPO_TAP := V_TIPO_TAP(I);
        -- Comprobamos el dato
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE DD_TPO_ID = '||TRIM(V_TMP_TIPO_TAP(1))||' and TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO... Ya existe la tarea '''|| TRIM(V_TMP_TIPO_TAP(1)) ||'''');
        ELSE
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO (
                    TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SCRIPT_VALIDACION, TAP_SCRIPT_VALIDACION_JBPM, TAP_SCRIPT_DECISION, DD_TPO_ID_BPM, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_ALERT_NO_RETORNO, TAP_ALERT_VUELTA_ATRAS, DD_FAP_ID, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP, DD_TGE_ID, DD_STA_ID, TAP_EVITAR_REORG, DD_TSUP_ID, TAP_BUCLE_BPM, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                    'SELECT '''|| V_ENTIDAD_ID || ''', '||V_TMP_TIPO_TAP(1)||' ,'''||TRIM(V_TMP_TIPO_TAP(2))||''','''||TRIM(V_TMP_TIPO_TAP(3))||''','''||TRIM(V_TMP_TIPO_TAP(4))||''','||
                      ''''||TRIM(V_TMP_TIPO_TAP(5)) || ''','''||TRIM(V_TMP_TIPO_TAP(6))||''','''||TRIM(V_TMP_TIPO_TAP(7))||''','''||TRIM(V_TMP_TIPO_TAP(8))||''','''||TRIM(V_TMP_TIPO_TAP(9))||''','||
                      ''''||TRIM(V_TMP_TIPO_TAP(10)) || ''','''||TRIM(V_TMP_TIPO_TAP(11))||''','''||TRIM(V_TMP_TIPO_TAP(12))||''','''||TRIM(V_TMP_TIPO_TAP(13))||''','''||TRIM(V_TMP_TIPO_TAP(14))||''','||                     
                      ''''||TRIM(V_TMP_TIPO_TAP(15)) || ''','''||TRIM(V_TMP_TIPO_TAP(16))||''','''||TRIM(V_TMP_TIPO_TAP(17))||''','''||TRIM(V_TMP_TIPO_TAP(18))||''','''||TRIM(V_TMP_TIPO_TAP(19))||''','||
                      ''''||TRIM(V_TMP_TIPO_TAP(20))||''','||
                      '''DML'', sysdate, 0 FROM DUAL';
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TAP(1)||''','''||TRIM(V_TMP_TIPO_TAP(2)));
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO... Datos del diccionario insertado');
    
    
    -- 3) LOOP Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS... Empezando a insertar datos en el diccionario');
    FOR I IN V_TIPO_PTP.FIRST .. V_TIPO_PTP.LAST
      LOOP
        V_TMP_TIPO_PTP := V_TIPO_PTP(I);
        -- Comprobamos el dato
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS WHERE TAP_ID = '||TRIM(V_TMP_TIPO_PTP(1));
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;        
        IF V_NUM_TABLAS > 0 THEN				
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_PTP_PLAZOS_TAREAS_PLAZAS... Ya existe el plazo '''|| TRIM(V_TMP_TIPO_PTP(1)) ||'''');
        ELSE
            V_MSQL := 'SELECT '|| V_ESQUEMA ||'.s_dd_ptp_plazos_tareas_plazas.NEXTVAL FROM DUAL';
            EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
            V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_PTP_PLAZOS_TAREAS_PLAZAS (
                        DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                        'SELECT '''|| V_ENTIDAD_ID || ''','||V_TMP_TIPO_PTP(1)||','''||TRIM(V_TMP_TIPO_PTP(2))||''','||
                          '''DML'', sysdate, 0 FROM DUAL';
                DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_PTP(1)||''','''||TRIM(V_TMP_TIPO_PTP(2)));
            EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS... Datos del diccionario insertado');
    
    -- 4) LOOP Insertando valores en TFI_TAREAS_FORM_ITEMS
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS... Empezando a insertar datos en el diccionario');
    FOR I IN V_TIPO_TFI.FIRST .. V_TIPO_TFI.LAST
      LOOP
        V_TMP_TIPO_TFI := V_TIPO_TFI(I);
        -- Comprobamos el dato
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = '||TRIM(V_TMP_TIPO_TFI(1))||' and TFI_ORDEN = '||TRIM(V_TMP_TIPO_TFI(2));
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TFI_TAREAS_FORM_ITEMS... Ya existe el item '''|| TRIM(V_TMP_TIPO_TFI(1)) ||''' and TFI_ORDEN = '||TRIM(V_TMP_TIPO_TFI(2))||' ');
        ELSE
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.s_tfi_tareas_form_items.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS (
                      TFI_ID, tap_id, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_VALOR_INICIAL, TFI_BUSINESS_OPERATION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '''|| V_ENTIDAD_ID || ''', '||V_TMP_TIPO_TFI(1)||' ,'''||TRIM(V_TMP_TIPO_TFI(2))||''','''||TRIM(V_TMP_TIPO_TFI(3))||''','''||TRIM(V_TMP_TIPO_TFI(4))||''','||
                        ''''||TRIM(V_TMP_TIPO_TFI(5)) || ''','''||TRIM(V_TMP_TIPO_TFI(6))||''','''||TRIM(V_TMP_TIPO_TFI(7))||''','''||TRIM(V_TMP_TIPO_TFI(8))||''','''||TRIM(V_TMP_TIPO_TFI(9))||''','||
                        '''DML'', sysdate, 0 FROM DUAL';
                         DBMS_OUTPUT.PUT_LINE(V_MSQL);
              DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TFI(1)||''','''||TRIM(V_TMP_TIPO_TFI(2)));
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS... Datos del diccionario insertado');

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