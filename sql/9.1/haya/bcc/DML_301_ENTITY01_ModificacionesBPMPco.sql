--/*
--##########################################
--## AUTOR=MANUEL_MEJIAS
--## FECHA_CREACION=20151103
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-cj-rc11
--## INCIDENCIA_LINK=PRODUCTO-180
--## PRODUCTO=NO
--##
--## Finalidad: -- Modificaciones BPM Precontencioso Cajamar
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
    
    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(2000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(    
       T_TIPO_TAP('PCO','PCO_RevisarExpedientePreparar','plugin/precontencioso/tramite/revisarExpedientePreparar',null,null,null,null,'0','Revisar expediente a preparar',
            '0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'PCO_CM_GE',null,'SUP_PCO',null),
       T_TIPO_TAP('PCO','PCO_AsignarGestorLiquidacion',null,null,null,null,null,'0','Asignar gestor de liquidación',
            '0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'PCO_CM_GD',null,'SUP_PCO',null),
       T_TIPO_TAP('PCO','PCO_RevisarExpedienteAsignarLetrado','plugin/precontencioso/tramite/revisarExpedienteAsignarLetrado',null,null,null,null,'0','Revisar expediente y Asignar letrado',
            '0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'SUP_PCO',null,'SUP_PCO',null)
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
      T_TIPO_PLAZAS(null,null,'PCO_RevisarExpedientePreparar','10*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'PCO_AsignarGestorLiquidacion','1*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'PCO_RevisarExpedienteAsignarLetrado','3*24*60*60*1000L','0','0','DD')
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
        T_TIPO_TFI('PCO_RevisarExpedientePreparar','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Antes de dar por terminada esta tarea, deberá realizar un estudio de las operaciones incluidas en el asunto y de la solvencia de los deudores para determinar si la recuperación de la deuda se hará por la vía judicial o a través de una agencia externa.</p><p style="margin-bottom: 10px">Para cada uno de los contratos incluidos en el expediente deberá informar en la ficha del contrato del riesgo operacional asociado al mismo. En caso de que no se ajuste a ninguno de los posibles deberá seleccionar “No procede” en la lista despegable.</p><p style="margin-bottom: 10px">En el campo “Fecha fin revisión” deberá indicar la fecha en la que finaliza este estudio.</p><p style="margin-bottom: 10px">En caso de que decida asignar el asunto a una agencia externa, deberá indicarlo en el Terminal Financiero de la entidad y seleccionar “SI” en el campo “Agencia externa”.En caso contrario deberá indicar en el selector de procedimiento el tipo de procedimiento a iniciar una vez termine la preparación del expediente judicial.</p><p style="margin-bottom: 10px">En caso de considerar necesaria la paralización de la preparación del expediente judicial, puede prorrogar esta tarea hasta que estime oportuno a través de la solicitud de una prórroga. De igual modo, en caso de encontrarse en negociación de un acuerdo extrajudicial, regístrelo a través de la pestaña Acuerdos de la ficha del asunto correspondiente.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla y si ha marcado No en “Agencia externa”, se lanzará la tarea “Asignar gestor de liquidación. En caso contrario, finalizará el trámite</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('PCO_RevisarExpedientePreparar','1','date','fecha_fin_revision','Fecha fin revisión','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),        
		T_TIPO_TFI('PCO_RevisarExpedientePreparar','2','combo','agencia_externa','Agencia externa','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('PCO_RevisarExpedientePreparar','3','combo','proc_iniciar','Procedimiento iniciar','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'TipoProcedimiento','0','DD'),
        T_TIPO_TFI('PCO_RevisarExpedientePreparar','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),

        T_TIPO_TFI('PCO_AsignarGestorLiquidacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deberá de asignar al asunto afecto a esta preparación del expediente judicial, el gestor de liquidación que se va a ocupar de obtener tanto las liquidaciones como los acuses de recibo.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla comenzará con la preparación del expediente judicial a través de la pantalla de “Prep. Documental”.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('PCO_AsignarGestorLiquidacion','1','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		
		T_TIPO_TFI('PCO_RevisarExpedienteAsignarLetrado','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea deberá añadir el letrado al que asigna el expediente judicial en la pestaña “Gestores” del expediente.</p><p style="margin-bottom: 10px">En el campo Fecha, indicar la fecha en la completa la tarea.</p><p style="margin-bottom: 10px">En el campo Letrado indicar el nombre del letrado asignado al asunto y en el campo “Motivo de asignación a Letrado” deberá elegir una de entre las opciones disponibles.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla:<ul><li>En caso de que no esté conforme con la finalización del expediente, la pestaña de Preparación Documental volverá a estar disponible y el Gestor de Documentación deberá realizar los cambios que le indique el supervisor.</li><li>En caso de que haya indicado que está conforme con la finalización del expediente, se lanzará la tarea “Registrar aceptación asunto” al letrado asignado.</li></ul></p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('PCO_RevisarExpedienteAsignarLetrado','1','date','fecha_revision','Fecha de revisión','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('PCO_RevisarExpedienteAsignarLetrado','2','combo','motivo_asignacion','Motivo de asignación a Letrado',null,null,null,'DDMotivoAsignacionLetrado','0','DD'),		
		T_TIPO_TFI('PCO_RevisarExpedienteAsignarLetrado','3','combo','expediente_correcto','Expediente correcto','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),		
		T_TIPO_TFI('PCO_RevisarExpedienteAsignarLetrado','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD')
    ); 
    V_TMP_TIPO_TFI T_TIPO_TFI;
    
    -- Actualización de script de decision de las tareas
    TYPE T_LINEA3 IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_LINEA3 IS TABLE OF T_LINEA3;
    V_TIPO_LINEA3 T_ARRAY_LINEA3 := T_ARRAY_LINEA3(
        T_LINEA3('PCO_PrepararExpediente', 'dameTipoAsunto()')
    ); 
    V_TMP_TIPO_LINEA3 T_LINEA3;
    
BEGIN	

    -- Modificar bpm del TPO
    V_TABLENAME := 'DD_TPO_TIPO_PROCEDIMIENTO';
    V_MSQL := 'UPDATE ' || V_ESQUEMA||'.' || V_TABLENAME ||  q'[ SET DD_TPO_XML_JBPM='precontenciosocajamar' WHERE DD_TPO_CODIGO='PCO' ]';
    DBMS_OUTPUT.PUT_LINE('ACTUALIZANDO : ' || V_ESQUEMA||'.' || V_TABLENAME || ' A DD_TPO_XML_JBPM=''precontenciosocajamar''');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;

    -- Nuevas TAP_TAREA_PROCEDIMIENTO 
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
                    'SELECT ' ||
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
                    'SELECT ' ||
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
