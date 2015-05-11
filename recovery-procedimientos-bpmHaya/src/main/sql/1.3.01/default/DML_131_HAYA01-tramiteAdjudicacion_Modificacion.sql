/*
--######################################################################
--## Author: Nacho
--## BPM: T. Adjudicación (H005) - modificación del BPM
--## Finalidad: Modificación del BPM
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
        /*DD_TPO_ID(FK)................:*/ 'H005',
        /*TAP_CODIGO...................:*/ 'H005_declararIVAeIGIC',
        /*TAP_VIEW.....................:*/ '',
        /*TAP_SCRIPT_VALIDACION........:*/ '',
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ null,
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Declarar IVA e IGIC',
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
        /*DD_STA_ID(FK)................:*/ '805',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ 'SSDE',
        /*TAP_BUCLE_BPM................:*/ null   
        )    
        
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;
    
    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
    
      T_TIPO_PLAZAS(null,null,'H005_declararIVAeIGIC','3*24*60*60*1000L','0','0','DD')

    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
    
      T_TIPO_TFI('H005_declararIVAeIGIC','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez emitido el auto decreto de adjudicaci&oacute;n, se deber&aacute; realizar la declaraci&oacute;n en funci&oacute;n del tipo de tributaci&oacute;n definido en el informe fiscal. En el caso de el tipo de tributaci&oacute;n sea IVA sujeto y deducible, adem&aacute;s de la declaraci&oacute;n se deber&aacute; auto emitir una factura.</p><p style="margin-bottom: 10px">Se indicar&aacute; la fecha en la que se ha declarado el IVA/IGIC de la operaci&oacute;n.</p><p style="margin-bottom: 10px">En el campo Observaciones infomar de cualquier aspecto relevante que le interese quede reflejado en este punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('H005_declararIVAeIGIC','1','date','fecha','Fecha declaración IVA/IGIC','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
      T_TIPO_TFI('H005_declararIVAeIGIC','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD')
      
    ); 
    V_TMP_TIPO_TFI T_TIPO_TFI;
    
BEGIN	
	
	V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET BORRADO = 1 '
 				|| ' WHERE TAP_CODIGO = ''H005_BPMLiquidacionTributacionBienesBankia''';	
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
	V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET BORRADO = 1 '
 				|| ' WHERE TAP_CODIGO = ''H005_BPMLiquidacionTributacionBienesSareb''';	
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_DECISION = ''valores[''''H005_notificacionDecretoAdjudicacionAEntidad''''][''''comboSubsanacion''''] == DDSiNo.SI ? ''''SUBSANACION'''' :(comprobarBienSujetoIVA() ? ''''IMPCONTRARIO'''' : ''''CONTRARIO'''')'' '
 				|| ' WHERE TAP_CODIGO = ''H005_notificacionDecretoAdjudicacionAEntidad''';	
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    COMMIT;
    
	V_MSQL := 'UPDATE DD_PTP_PLAZOS_TAREAS_PLAZAS '
				|| ' SET BORRADO = 1 '
 				|| ' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H005_BPMLiquidacionTributacionBienesBankia'')';	
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;    

	V_MSQL := 'UPDATE DD_PTP_PLAZOS_TAREAS_PLAZAS '
				|| ' SET BORRADO = 1 '
 				|| ' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H005_BPMLiquidacionTributacionBienesSareb'')';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET BORRADO = 1 '
 				|| ' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H005_BPMLiquidacionTributacionBienesBankia'')';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET BORRADO = 1 '
 				|| ' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H005_BPMLiquidacionTributacionBienesSareb'')';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; de informar la fecha en la que se notifica por el Juzgado el Decreto de Adjudicaci&oacute;n, la entidad adjudicataria de los bienes afectos.</p><p style="margin-bottom: 10px">Deber&aacute; revisar que el Decreto es conforme a la subasta celebrada y contiene lo preceptuado para su correcta inscripci&oacute;n en el Registro de la Propiedad, para ello deber&aacute; revisar:</p><p style="margin-bottom: 10px; margin-left: 40px;">• Datos procesales b&aacute;sicos: (Nº autos, tipo de procedimiento, cantidad reclamada)</p><p style="margin-bottom: 10px; margin-left: 40px;">• Datos de la Entidad demandante (nombre CIF, domicilio) y de los adjudicatarios</p><p style="margin-bottom: 10px; margin-left: 40px;">• Datos  de los demandados y titulares registrales.</p><p style="margin-bottom: 10px; margin-left: 40px;">• Importe de adjudicaci&oacute;n.</p><p style="margin-bottom: 10px; margin-left: 40px;">• Orden de cancelaci&oacute;n de la nota marginal y cancelaci&oacute;n de la carga objeto de ejecuci&oacute;n as&iacute; como cargas   posteriores)</p><p style="margin-bottom: 10px; margin-left: 40px;">• Descripci&oacute;n  y datos registrales completos de la finca adjudicada.</p><p style="margin-bottom: 10px; margin-left: 40px;">• Declaraci&oacute;n en el auto de la firmeza de la resoluci&oacute;n</p><p style="margin-bottom: 10px">Una vez analizados los puntos descritos, en el campo Requiere subsanaci&oacute;n deber&aacute; indicar el resultado de dicho an&aacute;lisis.</p><p style="margin-bottom: 10px">Una vez emitido el Auto Decreto de Adjudicaci&oacute;n y si la operaci&oacute;n est&aacute; sujeta a IVA o IGIC (recogido en la ficha del bien), se lanzar&aacute; la tarea "Declarar IVA e IGIC".</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute;, en caso de requerir subsanaci&oacute;n, el Tr&aacute;mite de subsanaci&oacute;n de adjudicaci&oacute;n, en caso contrario se lanzar&aacute; la tarea “Notificaci&oacute;n decreto adjudicaci&oacute;n al contrario.</p><p style="margin-bottom: 10px">En el caso de venir de una ejecuci&oacute;n notarial, de acuerdo con el deudor, no ser&aacute; ncesario la notificaci&oacute;n del decreto de adjudicaci&oacute;n de la parte contraria y, por tanto,  la siguiente tarea que lanzar&aacute; ser&aacute;  Solicitud de Testimonio de decreto de Adjudicaci&oacute;n.</p></div>'' '
 				|| ' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H005_notificacionDecretoAdjudicacionAEntidad'')';
 
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
    
    -- LOOP Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    VAR_TABLENAME := 'DD_PTP_PLAZOS_TAREAS_PLAZAS';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar PLAZOS');
    FOR I IN V_TIPO_PLAZAS.FIRST .. V_TIPO_PLAZAS.LAST
      LOOP
        V_TMP_TIPO_PLAZAS := V_TIPO_PLAZAS(I);
        -- Comprobamos el dato
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_PLAZAS(3))||''')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_PTP_PLAZOS_TAREAS_PLAZAS... Ya existe el plazo '''|| TRIM(V_TMP_TIPO_PLAZAS(3)) ||'''');
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || 
                    '(DD_PTP_ID,DD_JUZ_ID,DD_PLA_ID,TAP_ID,DD_PTP_PLAZO_SCRIPT,VERSION,BORRADO,USUARIOCREAR,FECHACREAR)' ||
                    'SELECT ' ||
                    'S_DD_PTP_PLAZOS_TAREAS_PLAZAS.NEXTVAL, ' ||
                    '(SELECT DD_JUZ_ID FROM ' || V_ESQUEMA || '.DD_JUZ_JUZGADOS_PLAZA WHERE DD_JUZ_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(1)) || '''), ' ||
                    '(SELECT DD_PLA_ID FROM ' || V_ESQUEMA || '.DD_PLA_PLAZAS WHERE DD_PLA_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(2)) || '''), ' ||
                    '(SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(3)) || '''), ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(5)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(6)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(7)),'''','''''') || ''', sysdate FROM DUAL'; 

            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_PLAZAS(3) ||''','''||TRIM(V_TMP_TIPO_PLAZAS(4))||'''');
            EXECUTE IMMEDIATE V_MSQL;
          END IF;
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Plazos');

    -- LOOP Insertando valores en TFI_TAREAS_FORM_ITEMS
    VAR_TABLENAME := 'TFI_TAREAS_FORM_ITEMS';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar Campos de tareas');
    FOR I IN V_TIPO_TFI.FIRST .. V_TIPO_TFI.LAST
      LOOP
        V_TMP_TIPO_TFI := V_TIPO_TFI(I);
        -- Comprobamos el dato
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TFI(1))||''') and TFI_ORDEN = '||TRIM(V_TMP_TIPO_TFI(2));
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TFI_TAREAS_FORM_ITEMS... Ya existe el item '''|| TRIM(V_TMP_TIPO_TFI(1)) ||''' and TFI_ORDEN = '||TRIM(V_TMP_TIPO_TFI(2))||' ');
        ELSE
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
          END IF;
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