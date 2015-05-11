/*
--######################################################################
--## Author: Roberto
--## BPM: T. Subasta Concursal (H003) - correcciones y ampliación del BPM
--## Finalidad: Correcciones y ampliación del BPM
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
    
    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(                    
      T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ 'H003',
        /*TAP_CODIGO...................:*/ 'H003_EsperaPosibleCesionRemate2',
        /*TAP_VIEW.....................:*/ '',
        /*TAP_SCRIPT_VALIDACION........:*/ '',
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ null,
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Espera de 20 días por posible Cesión de Remate',
        /*VERSION......................:*/ '0',
        /*USUARIOCREAR.................:*/ 'DD',
        /*BORRADO......................:*/ '0',
        /*TAP_ALERT_NO_RETORNO.........:*/ null,
        /*TAP_ALERT_VUELTA_ATRAS.......:*/ null,
        /*DD_FAP_ID(FK)................:*/ null,
        /*TAP_AUTOPRORROGA.............:*/ '0',
        /*DTYPE........................:*/ 'EXTTareaProcedimiento',
        /*TAP_MAX_AUTOP................:*/ '3',
        /*DD_TGE_ID(FK)................:*/ null,
        /*DD_STA_ID(FK)................:*/ '814',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ 'GUCL',
        /*TAP_BUCLE_BPM................:*/ null   
        ),
        
      T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ 'H003',
        /*TAP_CODIGO...................:*/ 'H003_BPMTramiteInscripcionDelTitulo',
        /*TAP_VIEW.....................:*/ '',
        /*TAP_SCRIPT_VALIDACION........:*/ '',
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ null,
        /*DD_TPO_ID_BPM(FK)............:*/ 'H066',
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Llamada al Trámite de Inscripción del Título',
        /*VERSION......................:*/ '0',
        /*USUARIOCREAR.................:*/ 'DD',
        /*BORRADO......................:*/ '0',
        /*TAP_ALERT_NO_RETORNO.........:*/ null,
        /*TAP_ALERT_VUELTA_ATRAS.......:*/ null,
        /*DD_FAP_ID(FK)................:*/ null,
        /*TAP_AUTOPRORROGA.............:*/ '0',
        /*DTYPE........................:*/ 'EXTTareaProcedimiento',
        /*TAP_MAX_AUTOP................:*/ '3',
        /*DD_TGE_ID(FK)................:*/ null,
        /*DD_STA_ID(FK)................:*/ '814',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ 'GUCL',
        /*TAP_BUCLE_BPM................:*/ null   
        )        
        
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;        
    
BEGIN	

	V_MSQL := 'update TFI_TAREAS_FORM_ITEMS '
				|| ' set tfi_label=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Una vez se celebre la subasta, en esta pantalla debe introducir la siguiente informaci&oacute;n:</p><p style="margin-bottom: 10px">En el campo Celebrada deber&aacute; indicar si la subasta ha sido celebrada o no. En caso de haberse celebrado deber&aacute; indicar a trav&eacute;s de la pestaña Subastas de la ficha del asunto correspondiente, el resultado de la subasta para cada uno de los bienes subastados.<br>- En caso de haber uno o m&aacute;s bienes adjudicados a un tercero, se lanzar&aacute; la tarea "Solicitar mandamiento de pago".<br>- Que exista cesi&oacute;n de remate y en ese caso se lanzar&aacute; el "Tr&aacute;mite de Cesi&oacute;n de Remate".<br>- En el caso de hab&eacute;rselo adjudicado el bien la entidad, pueden darse dos situaciones: <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Que exista posibilidad de remate, para ello habr&aacute; una tarea de espera de 20 d&iacute;as y transcurrido ese plazo, en el caso que sea necesario otorgamiento de escritura, se lanzar&aacute; el T.Inscripci&oacute;n del T&iacute;tulo y en el caso que no sea necesario el otorgamiento de escritura se lanzar&aacute; el de T.Adjudicaci&oacute;n.<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Que no exista posibilidad de remate. Se lanzar&aacute; el T.Adjudicaci&oacute;n si no hay otorgamiento de escritura, y en caso contrario, se lanzar&aacute; el T.Inscripci&oacute;n del t&iacute;tulo.</p><p style="margin-bottom: 10px">En la ficha del bien se debe recoger el resultado de la  adjudicación y el valor de la adjudicación.</p><p style="margin-bottom: 10px">En caso de suspensi&oacute;n de la subasta deber&aacute; indicar dicha circunstancia en el campo "Celebrada", en el campo "Decisi&oacute;n suspensi&oacute;n" deber&aacute; informar quien ha provocado dicha suspensi&oacute;n y en el campo "Motivo suspensi&oacute;n" deber&aacute; indicar el motivo por el cual se ha suspendido.</p><p style="margin-bottom: 10px">En caso de haberse adjudicado alguno de los bienes la Entidad, deber&aacute; indicar si ha habido Postores o no en la subasta y en el campo Cesi&oacute;n deber&aacute; indicar si se debe cursar la cesi&oacute;n de remate o no, seg&uacute;n el procedimiento establecido por la entidad.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Para dar por terminada esta tarea deberá adjuntar el acta de subasta al procedimiento a trav&eacute;s de la pestaña Adjuntos.</p></div>'''
 				|| ' where tfi_nombre=''titulo'' '
 				|| '       and tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo=''H003_CelebracionSubasta'')';	
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
	V_MSQL := 'update TFI_TAREAS_FORM_ITEMS '
				|| ' set TFI_ORDEN=''6'' '
 				|| ' where tfi_nombre=''comboDecisionSuspension'' '
 				|| '       and tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo=''H003_CelebracionSubasta'')';	
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
	V_MSQL := 'update TFI_TAREAS_FORM_ITEMS '
				|| ' set TFI_ORDEN=''7'' '
 				|| ' where tfi_nombre=''comboMotivoSuspension'' '
 				|| '       and tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo=''H003_CelebracionSubasta'')';	
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;    

	V_MSQL := 'update TFI_TAREAS_FORM_ITEMS '
				|| ' set TFI_ORDEN=''8'' '
 				|| ' where tfi_nombre=''observaciones'' '
 				|| '       and tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo=''H003_CelebracionSubasta'')';	
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;   
    
    
    --Quitamos restricciones de campos
	V_MSQL := 'update TFI_TAREAS_FORM_ITEMS '
				|| ' set TFI_VALIDACION=null, tfi_error_validacion=null '
				|| ' where tfi_nombre in ( '
				|| ' ''comboPostores'','
				|| ' ''comboCesionRemate'','
				|| ' ''comboAdjudicadoEntidad'','
				|| ' ''comboOtorgamientoEscritura'','
				|| ' ''comboDecisionSuspension'','
				|| ' ''comboMotivoSuspension'' '
				|| ' )'
  				|| '      and tap_id in (select tap_id from tap_tarea_procedimiento where tap_codigo in (''H002_CelebracionSubasta'',''H003_CelebracionSubasta'',''H004_CelebracionSubasta''))';	
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;    
    
    --Quitamos restricciones de tareas
    V_MSQL := 'update tap_tarea_procedimiento '
    			|| ' set TAP_SCRIPT_DECISION=null '
				|| ' where tap_codigo in (''H002_CelebracionSubasta'',''H003_CelebracionSubasta'',''H004_CelebracionSubasta'')';

    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 
	
	--Combo nuevo "Otorgamiento de escritura"
	V_MSQL := 'INSERT INTO TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values ( '
				|| ' S_TFI_TAREAS_FORM_ITEMS.NEXTVAL,' 
				|| ' (select tap_id from tap_tarea_procedimiento where tap_codigo=''H003_CelebracionSubasta''),'
				|| ' 5,'
				|| ' ''combo'','
				|| ' ''comboOtorgamientoEscritura'','
				|| ' ''Otorgamiento de escritura'','
				|| ' null,'
				|| ' null,'
				|| ' null,'
				|| ' ''DDSiNo'','
				|| ' 0,'
				|| ' ''DML'','
				|| ' sysdate,'
				|| ' 0'
				|| ' )';	
	
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;   
    
    --Nuevas tareas
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