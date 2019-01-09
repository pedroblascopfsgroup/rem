/*
--##########################################
--## AUTOR=MARIA PRESENCIA
--## FECHA_CREACION=20180917
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4488
--## PRODUCTO=NO
--##
--## Finalidad: Updatear registros TAP_TAREA_PROCEDIMIENTO
--## INSTRUCCIONES:  Ejecutar y definir las variables
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
SET DEFINE OFF
set timing ON
set linesize 2000

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_MSQL_1 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar  
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    V_NUM_SEQUENCE NUMBER(16); --Vble. que recoge el valor autoincremental.
    V_NUM_MAXID NUMBER(16); --Vble. que recoge el valor máximo de id.


    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
		 T_TIPO_TAP('T015',
			'T015_ResolucionExpediente',
			null,
			null,
			'checkComiteSancionadorAlquilerHaya() ? null : existeAdjuntoUGValidacion("45","E")',
			'valores[''T015_ResolucionExpediente''][''resolucionExpediente''] == ''01'' ? ''Aprobada'' : valores[''T015_ResolucionExpediente''][''resolucionExpediente''] == ''02'' ? ''Anulada'' : ''Contraofertar''',
			null,
			'0',
			'Resolución expediente',
			'0',
			'HREOS-4488',
			'0',
			null,
			null,
			null,
			'1',
			'EXTTareaProcedimiento',
			'3',
			'GESTCOMALQ',
			'TGCA',
			null,
			null,
			null)	
		,T_TIPO_TAP('T015',
			'T015_Firma',
			null,
			'existeAdjuntoUGValidacion("49","E")',
			null,
			null,
			null,
			'0',
			'Firma',
			'0',
			'HREOS-4488',
			'0',
			null,
			null,
			null,
			'1',
			'EXTTareaProcedimiento',
			'3',
			'GESTCOMALQ',
			'TGCA',
			null,
			null,
			null)	
		,T_TIPO_TAP('T015',
			'T015_CierreContrato',
			null,
			'existeAdjuntoUGValidacion("49","E")',
			'valores[''T015_CierreContrato''][''docOK''] != ''false'' ? null : ''Debe marcar la casilla "Documentaci&#243;n OK" para poder avanzar la tarea.''',
			null,
			null,
			'0',
			'Cierre contrato',
			'0',
			'HREOS-4488',
			'0',
			null,
			null,
			null,
			'1',
			'EXTTareaProcedimiento',
			'3',
			'GESTCOMALQ',
			'TGCA',
			null,
			null,
			null)	

    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    
BEGIN	
	
    
    -- LOOP Insertando valores en TAP_TAREA_PROCEDIMIENTO
    VAR_TABLENAME := 'TAP_TAREA_PROCEDIMIENTO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a actualizar TAREAS');
    FOR I IN V_TIPO_TAP.FIRST .. V_TIPO_TAP.LAST
      LOOP
        V_TMP_TIPO_TAP := V_TIPO_TAP(I);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||VAR_TABLENAME||' WHERE DD_TPO_ID = (SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(1))||''') and TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;  
        IF V_NUM_TABLAS > 0 THEN				
        	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||VAR_TABLENAME||' SET ' ||
        	' TAP_SCRIPT_VALIDACION=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(4)),'''','''''') || ''',' ||
        	' TAP_SCRIPT_VALIDACION_JBPM=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(5)),'''','''''') || ''',' ||
			' USUARIOMODIFICAR=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(11)),'''','''''') || ''',' ||
			' FECHAMODIFICAR=sysdate ' ||
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
                    'TAP_ID,
                    DD_TPO_ID,
                    TAP_CODIGO,
                    TAP_VIEW,
                    TAP_SCRIPT_VALIDACION,
                    TAP_SCRIPT_VALIDACION_JBPM,
                    TAP_SCRIPT_DECISION,
                    DD_TPO_ID_BPM,' ||
                    'TAP_SUPERVISOR,
                    TAP_DESCRIPCION,
                    VERSION,
                    USUARIOCREAR,
                    FECHACREAR,
                    BORRADO,
                    TAP_ALERT_NO_RETORNO,
                    TAP_ALERT_VUELTA_ATRAS,
                    DD_FAP_ID,' ||
                    'TAP_AUTOPRORROGA,
                    DTYPE,
                    TAP_MAX_AUTOP,
                    DD_TGE_ID,
                    DD_STA_ID,
                    TAP_EVITAR_REORG,
                    DD_TSUP_ID,
                    TAP_BUCLE_BPM) ' ||
                    'SELECT ' || V_ESQUEMA || '.' ||
                    'S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL, ' ||
                    '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(1)),'''','''''')  || '''),' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(2)),'''','''''') || ''','''
                     || REPLACE(TRIM(V_TMP_TIPO_TAP(3)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(4)),'''','''''') || ''',''' 
                    || REPLACE(TRIM(V_TMP_TIPO_TAP(5)),'''','''''') || ''',''' 
                    || REPLACE(TRIM(V_TMP_TIPO_TAP(6)),'''','''''') || ''',' || 
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(7)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(8)),'''','''''') || ''',''' 
                    || REPLACE(TRIM(V_TMP_TIPO_TAP(9)),'''','''''') || ''',''' 
                    || REPLACE(TRIM(V_TMP_TIPO_TAP(10)),'''','''''') || ''','''
                     || REPLACE(TRIM(V_TMP_TIPO_TAP(11)),'''','''''') || ''',' ||
                    'sysdate,''' 
                    || REPLACE(TRIM(V_TMP_TIPO_TAP(12)),'''','''''') || ''',''' 
                    || REPLACE(TRIM(V_TMP_TIPO_TAP(13)),'''','''''') || ''','''
                    || REPLACE(TRIM(V_TMP_TIPO_TAP(14)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(15)),'''','''''') || ''',''' 
                    || REPLACE(TRIM(V_TMP_TIPO_TAP(16)),'''','''''') || ''',''' 
                    || REPLACE(TRIM(V_TMP_TIPO_TAP(17)),'''','''''') || ''',''' 
                    || REPLACE(TRIM(V_TMP_TIPO_TAP(18)),'''','''''') || ''',' ||
                    '(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(19)) || '''),' ||
                    '(SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' || 
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(21)),'''','''''') || ''',' || 
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(22)),'''','''''') || ''',' ||
		    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(23)),'''','''''') || ''' FROM DUAL';
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TAP(2)||''','''||TRIM(V_TMP_TIPO_TAP(9))||'''');
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
          END IF;
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Tareas');

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
