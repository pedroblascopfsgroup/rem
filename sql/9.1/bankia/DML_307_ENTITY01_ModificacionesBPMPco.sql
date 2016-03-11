--/*
--##########################################
--## AUTOR=MANUEL_MEJIAS
--## FECHA_CREACION=20151229
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3-hy
--## INCIDENCIA_LINK=PRODUCTO-542
--## PRODUCTO=NO
--##
--## Finalidad: -- Modificaciones BPM Precontencioso Bankia
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TABLENAME VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    
    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(2000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_AUX1 VARCHAR2(1000) := q'[valores['PCO_RevisarExpDigCONC']['docCompleta'] == DDSiNo.SI ?  'ok' : 'requiere_subsanar']';
    V_AUX2 VARCHAR2(1000) := q'[valores['PCO_RevisarSubsanacionCONC']['subsanar'] == DDSiNo.SI ? 'subsanar' : 'devolver' ]';

    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
       T_TIPO_TAP('PCO','PCO_RevisarSubsanacionCONC',null,null,null,V_AUX2,null,'1','Revisar Subsanación Propuesta',
            '0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'PCO_SUP',null,'PCO_SUP',null),
       T_TIPO_TAP('PCO','PCO_RevisarExpDigCONC',null,null,null,V_AUX1,null,'0','Revisar Expediente Digital',
            '0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'PCO_LET',null,'PCO_SUP',null),
       T_TIPO_TAP('PCO','PCO_ResolverIncidenciaExpCONC',null,null,null,null,null,'0','Resolver Incidencia en Expediente',
            '0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'PCO_PREDOC',null,'PCO_SUP',null)
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
      T_TIPO_PLAZAS(null,null,'PCO_RevisarSubsanacionCONC','2*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'PCO_RevisarExpDigCONC','5*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'PCO_ResolverIncidenciaExpCONC','10*24*60*60*1000L','0','0','DD')
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
		T_TIPO_TFI('PCO_RevisarSubsanacionCONC','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que el letrado ha solicitado subsanación sobre expediente judicial preparado. Para dar por terminada esta tarea deberá de comprobar que realmente hay un problema en la documentación y consignar el resultado en el campo “Resultado” indicando Subsanar en caso de que realmente sea necesario subsanar el problema en la documentación, o indicando Devolver en caso de que no proceda la subsanación.</p>En caso de requerir subsanación, deberá valorar si es necesario que la nueva preparación del expediente la realice el preparador del expediente original o es conveniente que lo realice otro actor, en caso de querer cambiar de preparador, deberá acceder a la pestaña gestores del expediente y registrar el nuevo preparador.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('PCO_RevisarSubsanacionCONC','1','textarea','observaciones_letrado','Observaciones letrado',null,null,q'[valores['PCO_RevisarExpDigCONC']['observaciones']]',null,'0','DD'),
        T_TIPO_TFI('PCO_RevisarSubsanacionCONC','2','date','fecha_revision','Fecha de revisión','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('PCO_RevisarSubsanacionCONC','3','combo','subsanar','Resultado (Subsanar=Sí, Devolver=No)','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('PCO_RevisarSubsanacionCONC','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
    
        T_TIPO_TFI('PCO_RevisarExpDigCONC','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que la empresa de preparaci&oacute;n del expediente digital, ha dado por finalizada dicha preparaci&oacute;n. Antes de dar por completada esta tarea deber&aacute; revisar la pesta&ntilde;a Adjuntos del Asunto correspondiente y comprobar que toda la documentaci&oacute;n que requiere est&aacute; disponible.</p><p style="margin-bottom: 10px">En el campo Fecha deber&aacute; informar la fecha en la que d&eacute; por finalizada la revisi&oacute;n del expediente digital.</p><p style="margin-bottom: 10px">En el campo “Documentaci&oacute;n completa y correcta” deber&aacute; indicar si la documentaci&oacute;n del expediente efectivamente es completa y correcta o no. En caso de no ser completa deber&aacute; indicar el problema detectado según sea por Documentos o por Liquidaciones.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla y en funci&oacute;n de la informaci&oacute;n facilitada podr&aacute;n darse las siguientes situaciones:</p><p style="margin-bottom: 10px"><ul><li>En caso de haber encontrado un problema en la Documentaci&oacute;n, o liquidaciones se iniciar&aacute; la tarea “Revisar subsanaci&oacute;n propuesta” a realizar por la entidad.</li><li>En caso de no haber encontrado error en la documentaci&oacute;n se dar&aacute; por finalizada esta actuaci&oacute;n.</ul></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('PCO_RevisarExpDigCONC','1','combo','docCompleta','Documentación completa y correcta','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('PCO_RevisarExpDigCONC','2','date','fecha_revision','Fecha de revisión','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('PCO_RevisarExpDigCONC','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),

        T_TIPO_TFI('PCO_ResolverIncidenciaExpCONC','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que el letrado ha indicado que existe un problema en la documentación del expediente, antes de dar por finalizada esta tarea deberá resolver el problema informado.</p>Una vez enviada la documentación ya completa al letrado, deberá informar la fecha de envío de dicha documentación.</p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p>Una vez complete esta tarea se lanzará la tarea "Revisión del expediente digital" al letrado asignado al expediente.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('PCO_ResolverIncidenciaExpCONC','1','textarea','observaciones_letrado','Observaciones letrado',null,null,q'[valores['PCO_RevisarExpDigCONC']['observaciones']]',null,'0','DD'),
        T_TIPO_TFI('PCO_ResolverIncidenciaExpCONC','2','date','fecha_exp_sub','Fecha expediente subsanado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('PCO_ResolverIncidenciaExpCONC','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD')
    ); 
    V_TMP_TIPO_TFI T_TIPO_TFI;

    -- Actualización de script de decision de las tareas
    TYPE T_LINEA3 IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_LINEA3 IS TABLE OF T_LINEA3;
    V_TIPO_LINEA3 T_ARRAY_LINEA3 := T_ARRAY_LINEA3(
        T_LINEA3('PCO_PrepararExpediente', 'dameDecisionPrepararExpediente()')
    ); 
    V_TMP_TIPO_LINEA3 T_LINEA3;

    V_CONFIG VARCHAR2(4000 CHAR);      
    
BEGIN	

    -- Modificar bpm del TPO
    V_TABLENAME := 'DD_TPO_TIPO_PROCEDIMIENTO';
    V_MSQL := 'UPDATE ' || V_ESQUEMA||'.' || V_TABLENAME ||  q'[ SET DD_TPO_XML_JBPM='precontenciosobankia' WHERE DD_TPO_CODIGO='PCO' ]';
    DBMS_OUTPUT.PUT_LINE('ACTUALIZANDO : ' || V_ESQUEMA||'.' || V_TABLENAME || ' A DD_TPO_XML_JBPM=''precontenciosobankia''');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;

    -- Nuevas TAP_TAREA_PROCEDIMIENTO PCO_RegResultadoDocG, PCO_RevisarExpDigCONC, PCO_ResolverIncidenciaExpCONC
	V_TABLENAME := 'TAP_TAREA_PROCEDIMIENTO';
	DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || V_TABLENAME || '... Empezando a insertar TAREAS');
	FOR I IN V_TIPO_TAP.FIRST .. V_TIPO_TAP.LAST
	  LOOP
	    V_TMP_TIPO_TAP := V_TIPO_TAP(I);
	    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLENAME||' WHERE DD_TPO_ID = (SELECT DD_TPO_ID FROM ' || 
	    	V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(1))||''') and TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(2))||'''';
	    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;  
	    IF V_NUM_TABLAS > 0 THEN				
	        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLENAME||'... Ya existe la tarea '''|| TRIM(V_TMP_TIPO_TAP(1)) ||'''');
	    ELSE
	        V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || V_TABLENAME || ' (' ||
	                'TAP_ID,DD_TPO_ID,TAP_CODIGO,TAP_VIEW,TAP_SCRIPT_VALIDACION,TAP_SCRIPT_VALIDACION_JBPM,TAP_SCRIPT_DECISION,DD_TPO_ID_BPM,' ||
	                'TAP_SUPERVISOR,TAP_DESCRIPCION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,TAP_ALERT_NO_RETORNO,TAP_ALERT_VUELTA_ATRAS,DD_FAP_ID,' ||
	                'TAP_AUTOPRORROGA,DTYPE,TAP_MAX_AUTOP,DD_TGE_ID,DD_STA_ID,TAP_EVITAR_REORG,DD_TSUP_ID,TAP_BUCLE_BPM) ' ||
	                'SELECT ' || V_ESQUEMA || '.' ||
	                'S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL, ' ||
	                '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(1)),'''','''''')  || '''),' ||
	                '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(2)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(3)),'''','''''') || ''',' ||
	                '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(5)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(6)),'''','''''') || ''',' || 
	                '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(7)),'''','''''') || '''),' ||
	                '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(8)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(9)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(10)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(11)),'''','''''') || ''',' ||
	                'sysdate,''' || REPLACE(TRIM(V_TMP_TIPO_TAP(12)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(13)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(14)),'''','''''') || ''',' ||
	                '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(15)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(16)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(17)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(18)),'''','''''') || ''',' ||
	                '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(19)),'''','''''') || ''',' || 
	                '(SELECT DD_STA_ID FROM ' || V_ESQUEMA_M || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' || 
	                '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(21)),'''','''''') || ''',' || 
                    '(SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO='''||TRIM(V_TMP_TIPO_TAP(22))||'''), ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(23)),'''','''''') || ''' FROM DUAL';
	        DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TAP(2)||''','''||TRIM(V_TMP_TIPO_TAP(9))||'''');
	        DBMS_OUTPUT.PUT_LINE(V_MSQL);
	        EXECUTE IMMEDIATE V_MSQL;
	      END IF;
	END LOOP;
	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || V_TABLENAME || '... Tareas');

    -- LOOP Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    V_TABLENAME := 'DD_PTP_PLAZOS_TAREAS_PLAZAS';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || V_TABLENAME || '... Empezando a insertar PLAZOS');
    FOR I IN V_TIPO_PLAZAS.FIRST .. V_TIPO_PLAZAS.LAST
      LOOP
        V_TMP_TIPO_PLAZAS := V_TIPO_PLAZAS(I);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_PLAZAS(3))||''')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_PTP_PLAZOS_TAREAS_PLAZAS... Ya existe el plazo '''|| TRIM(V_TMP_TIPO_PLAZAS(3)) ||'''');
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || V_TABLENAME || 
                    '(DD_PTP_ID,DD_JUZ_ID,DD_PLA_ID,TAP_ID,DD_PTP_PLAZO_SCRIPT,VERSION,BORRADO,USUARIOCREAR,FECHACREAR)' ||
                    'SELECT ' ||  V_ESQUEMA || '.' ||
                    'S_DD_PTP_PLAZOS_TAREAS_PLAZAS.NEXTVAL, ' ||
                    '(SELECT DD_JUZ_ID FROM ' || V_ESQUEMA || '.DD_JUZ_JUZGADOS_PLAZA WHERE DD_JUZ_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(1)) || '''), ' ||
                    '(SELECT DD_PLA_ID FROM ' || V_ESQUEMA || '.DD_PLA_PLAZAS WHERE DD_PLA_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(2)) || '''), ' ||
                    '(SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(3)) || '''), ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(5)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(6)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(7)),'''','''''') || ''', sysdate FROM DUAL'; 
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_PLAZAS(3) ||''','''||TRIM(V_TMP_TIPO_PLAZAS(4))||'''');
            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || V_TABLENAME || '... Plazos');

    -- LOOP Insertando valores en TFI_TAREAS_FORM_ITEMS
    V_TABLENAME := 'TFI_TAREAS_FORM_ITEMS';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || V_TABLENAME || '... Empezando a insertar Campos de tareas');
    FOR I IN V_TIPO_TFI.FIRST .. V_TIPO_TFI.LAST
      LOOP
        V_TMP_TIPO_TFI := V_TIPO_TFI(I);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TFI(1))||''') and TFI_ORDEN = '||TRIM(V_TMP_TIPO_TFI(2));
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TFI_TAREAS_FORM_ITEMS... Ya existe el item '''|| TRIM(V_TMP_TIPO_TFI(1)) ||''' and TFI_ORDEN = '||TRIM(V_TMP_TIPO_TFI(2))||' ');
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || V_TABLENAME || 
                    '(TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)' ||
                    'SELECT ' ||  V_ESQUEMA || '.' ||
                    'S_TFI_TAREAS_FORM_ITEMS.NEXTVAL, ' ||
                    '(SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_TFI(1)) || '''), ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(2)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(3)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(5)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(6)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(7)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(8)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(9)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(10)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(11)),'''','''''') || ''',sysdate,0 FROM DUAL'; 
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TFI(1) ||''','''||TRIM(V_TMP_TIPO_TFI(4))||'''');
            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || V_TABLENAME || '... Campos');
  
-- Modificación de campo de decisión de PCO_PrepararExpediente
    V_TABLENAME := 'TAP_TAREA_PROCEDIMIENTO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || V_TABLENAME || '... Empezando a actualizar campo decisión de tareas');
    FOR I IN V_TIPO_LINEA3.FIRST .. V_TIPO_LINEA3.LAST
      LOOP
        V_TMP_TIPO_LINEA3 := V_TIPO_LINEA3(I);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.' || V_TABLENAME || ' WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_LINEA3(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;      
        IF V_NUM_TABLAS > 0 THEN        
            V_MSQL := 'UPDATE  '||V_ESQUEMA||'.' || V_TABLENAME || 
                ' SET TAP_SCRIPT_DECISION=''' || TRIM(V_TMP_TIPO_LINEA3(2)) || 
                '''  WHERE TAP_CODIGO='''|| TRIM(V_TMP_TIPO_LINEA3(1)) ||'''';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || V_TABLENAME || ' ACTUALIZACION DE TAP_SCRIPT_DECISION DE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_LINEA3(1))||'''');
        ELSE
            DBMS_OUTPUT.PUT_LINE('HAY QUE INSERTAR ESTA FILA: '  || V_TMP_TIPO_LINEA3(1));
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || V_TABLENAME || '.');

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
EXIT
