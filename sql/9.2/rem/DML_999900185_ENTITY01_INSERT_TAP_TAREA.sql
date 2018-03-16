/*
--##########################################
--## AUTOR=Jose Navarro
--## FECHA_CREACION=20180301
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3891
--## PRODUCTO=SI
--##
--## Finalidad: BPM - Modificación del Trámite comercial venta
--## INSTRUCCIONES:  Ejecutar y definir las variables.
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
SET TIMING ON;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_MSQL_1 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar  
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla. 
	V_NUM_ID NUMBER(16);  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_SEQUENCE NUMBER(16);
  	V_NUM_MAXID NUMBER(16);

    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    --Modificación valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_B_TAP T_ARRAY_TAP := T_ARRAY_TAP(
   		--			CODIGO TAREA 					DECISION
        T_TIPO_TAP('T013_ResolucionExpediente', 	'valores[''T013_ResolucionExpediente''][''comboProcede''] == DDDevolucionReserva.CODIGO_SI_DUPLICADOS || valores[''T013_ResolucionExpediente''][''comboProcede''] == DDDevolucionReserva.CODIGO_SI_SIMPLES ? checkBankia() ? ''DevolucionSi'' : ''DevolucionNo'' : ''DevolucionNo''')
    ); 
    V_MODIFICAR_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
	T_TIPO_TAP('T013','T013_RespuestaBankiaDevolucion','','','','','','0','Respuesta Bankia sobre la devolución','0','HREOS-3891','0','','',null,'0','EXTTareaProcedimiento','3','','811','','SUPER','')
    	,T_TIPO_TAP('T013','T013_PendienteDevolucion','','','','','','0','Pendiente de la devolución','0','HREOS-3891','0','','',null,'0','EXTTareaProcedimiento','3','','811','','SUPER','')
        ,T_TIPO_TAP('T013','T013_RespuestaBankiaAnulacionDevolucion','','','','','','0','Respuesta Bankia sobre la anulación de la devolución','0','HREOS-3891','0','','',null,'0','EXTTareaProcedimiento','3','','811','','SUPER','')
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
        T_TIPO_PLAZAS('','','T013_RespuestaBankiaDevolucion','3*24*60*60*1000L','0','0','HREOS-3891')
	,T_TIPO_PLAZAS('','','T013_PendienteDevolucion','3*24*60*60*1000L','0','0','HREOS-3891')
        ,T_TIPO_PLAZAS('','','T013_RespuestaBankiaAnulacionDevolucion','3*24*60*60*1000L','0','0','HREOS-3891')
	); 
	V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;

    -- Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
        T_TIPO_TFI('T013_RespuestaBankiaDevolucion','0','label','titulo','<p style="margin-bottom: 10px"></p>','','','','','0','HREOS-3891')
	,T_TIPO_TFI('T013_RespuestaBankiaDevolucion','1','date','fecha','Fecha respuesta','','false','','','0','HREOS-3891')
        ,T_TIPO_TFI('T013_RespuestaBankiaDevolucion','2','combo','comboRespuesta','Respuesta de la devolución','','false','','DDSiNo','0','HREOS-3891')
	,T_TIPO_TFI('T013_RespuestaBankiaDevolucion','3','textarea','observaciones','Observaciones','','','','','0','HREOS-3891')
	,T_TIPO_TFI('T013_PendienteDevolucion','0','label','titulo','<p style="margin-bottom: 10px"></p>','','','','','0','HREOS-3891')
	,T_TIPO_TFI('T013_PendienteDevolucion','1','date','fecha','Fecha respuesta','','false','','','0','HREOS-3891')
        ,T_TIPO_TFI('T013_PendienteDevolucion','2','combo','comboRespuesta','Respuesta de la devolución','','false','','DDSiNo','0','HREOS-3891')
	,T_TIPO_TFI('T013_PendienteDevolucion','3','textarea','observaciones','Observaciones','','','','','0','HREOS-3891')
	,T_TIPO_TFI('T013_RespuestaBankiaAnulacionDevolucion','0','label','titulo','<p style="margin-bottom: 10px"></p>','','','','','0','HREOS-3891')
        ,T_TIPO_TFI('T013_RespuestaBankiaAnulacionDevolucion','1','date','fecha','Fecha respuesta','','false','','','0','HREOS-3891')
	,T_TIPO_TFI('T013_RespuestaBankiaAnulacionDevolucion','2','combo','comboRespuesta','Respuesta anulación de la devolución','','false','','DDSiNo','0','HREOS-3891')
	,T_TIPO_TFI('T013_RespuestaBankiaAnulacionDevolucion','3','textarea','observaciones','Observaciones','','','','','0','HREOS-3891')
	); 
    V_TMP_TIPO_TFI T_TIPO_TFI;

BEGIN
	-- LOOP Modificación valores tareas
	DBMS_OUTPUT.PUT_LINE('[INICIO] Empezando a updatear tareas');
	FOR I IN V_TIPO_B_TAP.FIRST .. V_TIPO_B_TAP.LAST
		LOOP
			V_MODIFICAR_TIPO_TAP := V_TIPO_B_TAP(I);
			IF(V_MODIFICAR_TIPO_TAP(1) IS NOT NULL) THEN
				V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_MODIFICAR_TIPO_TAP(1))||'''';
				EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
				IF V_NUM_TABLAS > 0 THEN
					V_SQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET
						TAP_SCRIPT_DECISION = '''||REPLACE(TRIM(V_MODIFICAR_TIPO_TAP(2)),'''','''''')||'''
						,USUARIOMODIFICAR = ''HREOS-3891''
						,FECHAMODIFICAR = SYSDATE
						WHERE TAP_CODIGO = '''||TRIM(V_MODIFICAR_TIPO_TAP(1))||'''';
					EXECUTE IMMEDIATE V_SQL;
					DBMS_OUTPUT.PUT_LINE('[INFO] Modificada fila en TAP_TAREA_PROCEDIMIENTO para el TAP_CODIGO '''||TRIM(V_MODIFICAR_TIPO_TAP(1))||'''.');
				END IF;
			END IF;
	END LOOP;
	DBMS_OUTPUT.PUT_LINE('[FIN] Finalizado el updateo de tareas');
	DBMS_OUTPUT.PUT_LINE('');

	-- LOOP Insertando valores en TAP_TAREA_PROCEDIMIENTO
    VAR_TABLENAME := 'TAP_TAREA_PROCEDIMIENTO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar TAREAS');
    FOR I IN V_TIPO_TAP.FIRST .. V_TIPO_TAP.LAST
      LOOP
        V_TMP_TIPO_TAP := V_TIPO_TAP(I);
        IF(V_TMP_TIPO_TAP(1) IS NOT NULL) THEN 
	        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||VAR_TABLENAME||' WHERE DD_TPO_ID = (SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(1))||''') and TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(2))||'''';
	        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;  
	        IF V_NUM_TABLAS > 0 THEN				
	        	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||VAR_TABLENAME||' SET TAP_VIEW=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(3)),'''','''''') || ''',' ||
	        	' TAP_SCRIPT_VALIDACION=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(4)),'''','''''') || ''',' ||
	        	' TAP_SCRIPT_VALIDACION_JBPM=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(5)),'''','''''') || ''',' ||
	        	' TAP_SCRIPT_DECISION=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(6)),'''','''''') || ''',' ||
	          	' TAP_DESCRIPCION=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(9)),'''','''''') || ''',' ||
	          	' DD_TPO_ID_BPM=(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || TRIM(V_TMP_TIPO_TAP(7)) || '''),' ||
	          	' TAP_ALERT_VUELTA_ATRAS=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(14)),'''','''''') || ''',' ||
	         	' DD_FAP_ID=(SELECT DD_FAP_ID FROM ' || V_ESQUEMA || '.DD_FAP_FASE_PROCESAL WHERE DD_FAP_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(15)) || '''),' || 
	          	' TAP_AUTOPRORROGA=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(16)),'''','''''') || ''',' ||
	          	' TAP_MAX_AUTOP=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(18)),'''','''''') || ''',' ||
	        	' DD_STA_ID=(SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' || 
	          	' DD_TGE_ID=(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(22)) || '''),' ||
	          	' USUARIOMODIFICAR=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(11)),'''','''''') || ''',' ||
	          	' FECHAMODIFICAR=sysdate ,' ||
                ' BORRADO = 0 ' ||
	        	' WHERE DD_TPO_ID = (SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(1))||''') and TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(2))||'''';
				--DBMS_OUTPUT.PUT_LINE(V_SQL);
			    EXECUTE IMMEDIATE V_SQL;	
	            DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||VAR_TABLENAME||'... Actualizada la tarea '''|| TRIM(V_TMP_TIPO_TAP(2)) ||''', ' || TRIM(V_TMP_TIPO_TAP(3)));
	        ELSE
				-- Comprobar secuencias en TAP_TAREA_PROCEDIMIENTO.
				V_SQL := 'SELECT '||V_ESQUEMA||'.S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL FROM DUAL';
			 	EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
			   
			  	V_SQL := 'SELECT NVL(MAX(TAP_ID), 0) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO';
			 	EXECUTE IMMEDIATE V_SQL INTO V_NUM_MAXID;
			   
			  	WHILE V_NUM_SEQUENCE < V_NUM_MAXID LOOP
				  	V_SQL := 'SELECT '||V_ESQUEMA||'.S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL FROM DUAL';
				   	EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
				END LOOP;
	
	        	V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || ' (' ||
                    'TAP_ID,DD_TPO_ID,TAP_CODIGO,TAP_VIEW,TAP_SCRIPT_VALIDACION,TAP_SCRIPT_VALIDACION_JBPM,TAP_SCRIPT_DECISION,DD_TPO_ID_BPM,' ||
                    'TAP_SUPERVISOR,TAP_DESCRIPCION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,TAP_ALERT_NO_RETORNO,TAP_ALERT_VUELTA_ATRAS,DD_FAP_ID,' ||
                    'TAP_AUTOPRORROGA,DTYPE,TAP_MAX_AUTOP,DD_TSUP_ID,DD_STA_ID,TAP_EVITAR_REORG,DD_TGE_ID,TAP_BUCLE_BPM) ' ||
                    'SELECT '||V_ESQUEMA||'.S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL, ' ||
                    '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(1)),'''','''''')  || '''),' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(2)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(3)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(5)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(6)),'''','''''') || ''',' || 
                    '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(7)),'''','''''') || '''),' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(8)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(9)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(10)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(11)),'''','''''') || ''',' ||
                    'sysdate,''' || REPLACE(TRIM(V_TMP_TIPO_TAP(12)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(13)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(14)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(15)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(16)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(17)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(18)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(19)),'''','''''') || ''',' || 
                    '(SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' || 
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(21)),'''','''''') || ''',' ||
		    		'(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(22)) || '''),' ||
		    		'''' || REPLACE(TRIM(V_TMP_TIPO_TAP(23)),'''','''''') || ''' FROM DUAL';
            	DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TAP(2)||''','''||TRIM(V_TMP_TIPO_TAP(9))||'''');
	            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
	            EXECUTE IMMEDIATE V_MSQL;
          END IF;
        END IF;
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Tareas');


    -- LOOP Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    VAR_TABLENAME := 'DD_PTP_PLAZOS_TAREAS_PLAZAS';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar PLAZOS');
    FOR I IN V_TIPO_PLAZAS.FIRST .. V_TIPO_PLAZAS.LAST
      LOOP
        V_TMP_TIPO_PLAZAS := V_TIPO_PLAZAS(I);
        IF(V_TMP_TIPO_PLAZAS(3) IS NOT NULL) THEN 
	        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_PLAZAS(3))||''')';
	        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
	        IF V_NUM_TABLAS > 0 THEN				
			 	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||VAR_TABLENAME||' SET DD_PTP_PLAZO_SCRIPT=''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(4)),'''','''''') || ''',' ||
		            ' USUARIOMODIFICAR=''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(7)),'''','''''') || ''',' ||
		            ' FECHAMODIFICAR=sysdate , ' ||
		            ' BORRADO = 0 ' ||
		        	' WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_PLAZAS(3))||''')';
				EXECUTE IMMEDIATE V_SQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_PTP_PLAZOS_TAREAS_PLAZAS... Se actualiza el plazo '''|| TRIM(V_TMP_TIPO_PLAZAS(3)) ||'''');
        	ELSE
	        	-- Comprobar secuencias en DD_PTP_PLAZOS_TAREAS_PLAZAS.
				V_SQL := 'SELECT '||V_ESQUEMA||'.S_DD_PTP_PLAZOS_TAREAS_PLAZAS.NEXTVAL FROM DUAL';
				EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
	
				V_SQL := 'SELECT NVL(MAX(DD_PTP_ID), 0) FROM '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS';
				EXECUTE IMMEDIATE V_SQL INTO V_NUM_MAXID;
	
				WHILE V_NUM_SEQUENCE < V_NUM_MAXID LOOP
					V_SQL := 'SELECT '||V_ESQUEMA||'.S_DD_PTP_PLAZOS_TAREAS_PLAZAS.NEXTVAL FROM DUAL';
					EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
				END LOOP;
	
				V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || 
	                '(DD_PTP_ID,DD_JUZ_ID,DD_PLA_ID,TAP_ID,DD_PTP_PLAZO_SCRIPT,VERSION,BORRADO,USUARIOCREAR,FECHACREAR)' ||
	                'SELECT '||V_ESQUEMA||'.S_DD_PTP_PLAZOS_TAREAS_PLAZAS.NEXTVAL, ' ||
	                '(SELECT DD_JUZ_ID FROM ' || V_ESQUEMA || '.DD_JUZ_JUZGADOS_PLAZA WHERE DD_JUZ_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(1)) || '''), ' ||
	                '(SELECT DD_PLA_ID FROM ' || V_ESQUEMA || '.DD_PLA_PLAZAS WHERE DD_PLA_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(2)) || '''), ' ||
	                '(SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(3)) || '''), ' ||
	                '''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(5)),'''','''''') || ''',' ||
	                '''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(6)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(7)),'''','''''') || ''', sysdate FROM DUAL'; 
	            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_PLAZAS(3) ||''','''||TRIM(V_TMP_TIPO_PLAZAS(4))||'''');
	            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
	            EXECUTE IMMEDIATE V_MSQL;
        	END IF;
        END IF;
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Plazos');


    -- LOOP Insertando valores en TFI_TAREAS_FORM_ITEMS
    VAR_TABLENAME := 'TFI_TAREAS_FORM_ITEMS';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar Campos de tareas');
    FOR I IN V_TIPO_TFI.FIRST .. V_TIPO_TFI.LAST
      LOOP
        V_TMP_TIPO_TFI := V_TIPO_TFI(I);
        IF(V_TMP_TIPO_TFI(1) IS NOT NULL) THEN 
	        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TFI(1))||''') and TFI_ORDEN = '||TRIM(V_TMP_TIPO_TFI(2));
	        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	        IF V_NUM_TABLAS > 0 THEN
	        	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||VAR_TABLENAME||' SET TFI_TIPO=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(3)),'''','''''') || ''',' ||
	        	' TFI_NOMBRE=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(4)),'''','''''') || ''',' ||
	        	' TFI_LABEL=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(5)),'''','''''') || ''',' ||
	        	' TFI_ERROR_VALIDACION=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(6)),'''','''''') || ''',' ||
	        	' TFI_VALIDACION=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(7)),'''','''''') || ''',' ||
	        	' TFI_VALOR_INICIAL=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(8)),'''','''''') || ''',' ||
	        	' TFI_BUSINESS_OPERATION=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(9)),'''','''''') || ''',' ||
	          ' USUARIOMODIFICAR=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(11)),'''','''''') || ''',' ||
	          ' FECHAMODIFICAR=sysdate ,' ||
	          ' BORRADO = 0 ' ||
	        	' WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TFI(1))||''') and TFI_ORDEN = '||TRIM(V_TMP_TIPO_TFI(2));
				--DBMS_OUTPUT.PUT_LINE(V_SQL);
			    EXECUTE IMMEDIATE V_SQL;	
		        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TFI_TAREAS_FORM_ITEMS... Actualizado el item '''|| TRIM(V_TMP_TIPO_TFI(1)) ||''' and TFI_NOMBRE = '||TRIM(V_TMP_TIPO_TFI(4))||' ');
	        ELSE
	        	-- Comprobar secuencias en TFI_TAREAS_FORM_ITEMS.
				V_SQL := 'SELECT '||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL FROM DUAL';
				EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;

				V_SQL := 'SELECT NVL(MAX(TFI_ID), 0) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS';
				EXECUTE IMMEDIATE V_SQL INTO V_NUM_MAXID;

				WHILE V_NUM_SEQUENCE < V_NUM_MAXID LOOP
					V_SQL := 'SELECT '||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL FROM DUAL';
					EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
				END LOOP;

				V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || 
	                '(TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)' ||
	                'SELECT '||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL, ' ||
	                '(SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_TFI(1)) || '''), ' ||
	                '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(2)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(3)),'''','''''') || ''',' ||
	                '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(5)),'''','''''') || ''',' ||
	                '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(6)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(7)),'''','''''') || ''',' ||
	                '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(8)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(9)),'''','''''') || ''',' ||
	                '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(10)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(11)),'''','''''') || ''',sysdate,0 FROM DUAL'; 
	            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TFI(1) ||''','''||TRIM(V_TMP_TIPO_TFI(4))||'''');
	            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
	            EXECUTE IMMEDIATE V_MSQL;
        	END IF;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Campos');

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
