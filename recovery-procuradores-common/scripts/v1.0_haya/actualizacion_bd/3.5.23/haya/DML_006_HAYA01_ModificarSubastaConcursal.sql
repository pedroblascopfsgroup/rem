--/*
--##########################################
--## AUTOR=Nacho A
--## FECHA_CREACION=20150526
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.0.1-rc03-hy
--## INCIDENCIA_LINK=HR-900
--## PRODUCTO=NO
--##
--## Finalidad:
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquema Master
   	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar 
   	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    PAR_TABLENAME_TARPR VARCHAR2(50 CHAR) := 'TAP_TAREA_PROCEDIMIENTO';     -- [PARAMETRO] TABLA para tareas del procedimiento. Por defecto TAP_TAREA_PROCEDIMIENTO
    PAR_TABLENAME_TPROC VARCHAR2(50 CHAR) := 'DD_TPO_TIPO_PROCEDIMIENTO';   -- [PARAMETRO] TABLA para tipo de procedimiento. Por defecto DD_TPO_TIPO_PROCEDIMIENTO 
	VAR_SEQUENCENAME VARCHAR2(50 CHAR);                 -- Variable para secuencias
    VAR_CURR_ROWARRAY VARCHAR2(25 CHAR);                -- Variable con fila array actual - para excepciones
    VAR_CURR_TABLE VARCHAR2(50 CHAR);                   -- Variable con tabla actual - para excepciones
    V_CODIGO_TAP VARCHAR2(100 CHAR); -- Variable para nombre campo FK con codigo de Tap tareas
    
     /*
    * ARRAY TABLA2: TAP_TAREA_PROCEDIMIENTO
    *---------------------------------------------------------------------
    */
    
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(2000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
	    T_TIPO_TAP(
	        /*DD_TPO_ID(FK)................:*/ 'H003',
	        /*TAP_CODIGO...................:*/ 'H003_SuspenderDecision',
	        /*TAP_VIEW.....................:*/ null,
	        /*TAP_SCRIPT_VALIDACION........:*/ null,
	        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
	        /*TAP_SCRIPT_DECISION..........:*/ null,
	        /*DD_TPO_ID_BPM(FK)............:*/ null,
	        /*TAP_SUPERVISOR,..............:*/ '0',
	        /*TAP_DESCRIPCION,.............:*/ 'Tarea toma de decisión',
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
	        /*DD_STA_ID(FK)................:*/ '819',
	        /*TAP_EVITAR_REORG.............:*/ null,
	        /*DD_TSUP_ID(FK)...............:*/ 'GULI',
	        /*TAP_BUCLE_BPM................:*/ null        
	        )
    );
    V_TMP_TIPO_TAP T_TIPO_TAP;

BEGIN
	--MODIFICACIONES
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
	          ' SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''H003_CelebracionSubasta''''][''''comboCelebrada''''] == DDSiNo.NO ? ' || 
	          '(valores[''''H003_CelebracionSubasta''''][''''comboDecisionSuspension''''] == null ? ''''El campo Decisi&oacute;n suspensi&oacute;n es obligatorio'''' : null) : ' || 
	          '(comprobarExisteDocumentoACS() ? (validarBienesDocCelebracionSubasta() ? null : ''''Debe rellenar en cada bien los datos de adjudicaci&oacute;n o de cesi&oacute;n remate'''') : ' || 
	          ' ''''Es necesario adjuntar el documento Acta de subasta'''') '' ' ||
	          ' WHERE TAP_CODIGO = ''H003_CelebracionSubasta''';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando label de los campos.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Label de los campos actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
	          ' SET BORRADO = 1 ' ||
	          ' WHERE TAP_CODIGO = ''H003_EsperaPosibleCesionRemate''';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando borrado de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Borrado lógico de la tarea realizado.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
	          ' SET BORRADO = 1 ' ||
	          ' WHERE TAP_CODIGO = ''H003_EsperaPosibleCesionRemate2''';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando borrado de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Borrado lógico de la tarea realizado.');
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
	          ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;">' || 
	          '<p style="margin-bottom: 10px">Una vez se celebre la subasta, en esta pantalla debe introducir la siguiente informaci&oacute;n:</p>' || 
	          '<p style="margin-bottom: 10px">En el campo Celebrada deber&aacute; indicar si la subasta ha sido celebrada o no. ' || 
	          'En caso de haberse celebrado deber&aacute; indicar en cada unos de los bienes subastados el resultado de la subasta a trav&eacute;s ' || 
	          'de los campos:</p><p style="margin-bottom: 10px; margin-left: 40px;">- Entidad Adjudicataria: deber&aacute; ' || 
	          'indicar si la adjudicaci&oacute;n es a favor de la entidad con auto, entidad escritura o de un tercero.</p>' || 
	          '<p style="margin-bottom: 10px; margin-left: 40px;">- Importe Adjudicacion: Importe por el cual se adjudica el bien.</p>' || 
	          '<p style="margin-bottom: 10px; margin-left: 40px;">- Cesi&oacute;n de Remate: deber&aacute; indicar si el bien es objeto de ' || 
	          'cesi&oacute;n de remate o no.</p><p style="margin-bottom: 10px; margin-left: 40px;">- Importe Cesion de Remate: Importe por el cual ' || 
	          'se cede a remate el bien.</p><p style="margin-bottom: 10px">En caso de suspensi&oacute;n de la subasta deber&aacute; ' || 
	          'indicar dicha circunstancia en el campo “Celebrada”, en el campo “Decisi&oacute;n suspensi&oacute;n” deber&aacute; ' || 
	          'informar quien ha provocado dicha suspensi&oacute;n y en el campo “Motivo suspensi&oacute;n” deber&aacute; indicar el motivo por el ' || 
	          'cual se ha suspendido.</p><p style="margin-bottom: 10px">En caso de haberse adjudicado alguno de los bienes la Entidad, ' || 
	          'deber&aacute; indicar si ha habido Postores o no en la subasta.</p><p style="margin-bottom: 10px">En el campo observaciones ' || 
	          'informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">' || 
	          'Una vez rellene esta pantalla, la siguiente tarea ser&aacute;:</p><p style="margin-bottom: 10px; margin-left: 40px;">* En caso de ' || 
	          'haber indicado la suspensi&oacute;n de la subasta por decisi&oacute;n de terceros, se le abrir&aacute; una tarea en la que ' || 
	          'propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad..</p>' || 
	          '<p style="margin-bottom: 10px; margin-left: 40px;">* En caso de haberse suspendido la subasta por decisi&oacute;n de la entidad, ' || 
	          'se le abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable ' || 
	          'de la entidad.</p><p style="margin-bottom: 10px; margin-left: 40px;">* En caso de haberse producido la subasta, haber ' || 
	          'marcado alg&uacute;n bien con cesi&oacute;n de remate, se lanzar&aacute; el tramite de cesi&oacute;n de remate.</p>' || 
	          '<p style="margin-bottom: 10px; margin-left: 40px;">*En caso de haberse producido la subasta, haber marcado alg&uacute;n ' || 
	          'bien adjudicado a un tercero se lanzar&aacute; la tarea "Solicitar Mandamiento de Pago".</p>' || 
	          '<p style="margin-bottom: 10px; margin-left: 40px;">*En caso de haberse producido la subasta, haber marcado alg&uacute;n ' || 
	          'bien adjudicado la entidad sin cesi&oacute;n de remate, con auto de adjudicaci&oacute;n se lanzar&aacute; el tramite de ' || 
	          'adjudicaci&oacute;n.</p><p style="margin-bottom: 10px; margin-left: 40px;">*En caso de haberse producido la subasta, haber ' || 
	          'marcado algun bien adjudicado la entidad  sin cesi&oacute;n de remate, con escritura se lanzar&aacute; el tr&aacute;mite de ' || 
	          'Inscripci&oacute;n del titulo.</p><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; adjuntar el ' || 
	          'acta de subasta al procedimiento a trav&eacute;s de la pesta&ntilde;a Adjuntos.</p></div>'' ' ||
	          ' WHERE TFI_NOMBRE = ''titulo'' AND' ||
	          ' TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H003_CelebracionSubasta'')';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando instrucciones.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Instrucciones actualizadas.');
	
	V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
	          ' WHERE TFI_NOMBRE = ''comboCesionRemate'' AND' ||
	          ' TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H003_CelebracionSubasta'')';
    DBMS_OUTPUT.PUT_LINE('[INFO] Borrando campo.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Campo borrado.');
    
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
	          ' WHERE TFI_NOMBRE = ''comboAdjudicadoEntidad'' AND' ||
	          ' TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H003_CelebracionSubasta'')';
    DBMS_OUTPUT.PUT_LINE('[INFO] Borrando campo.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Campo borrado.');
    
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
	          ' WHERE TFI_NOMBRE = ''comboOtorgamientoEscritura'' AND' ||
	          ' TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H003_CelebracionSubasta'')';
    DBMS_OUTPUT.PUT_LINE('[INFO] Borrando campo.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Campo borrado.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
	          ' SET TFI_LABEL = ''Decisi&oacute;n suspensi&oacute;n'' ' ||
	          ' WHERE TFI_NOMBRE = ''comboDecisionSuspension'' AND' ||
	          ' TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H003_CelebracionSubasta'')';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando label de los campos.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Label de los campos actualizada.');

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
	          ' SET TFI_ORDEN = 3 ' ||
	          ' WHERE TFI_NOMBRE = ''comboDecisionSuspension'' AND' ||
	          ' TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H003_CelebracionSubasta'')';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando orden de los campos.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Orden de los campos actualizados.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
	          ' SET TFI_ORDEN = 4 ' ||
	          ' WHERE TFI_NOMBRE = ''comboMotivoSuspension'' AND' ||
	          ' TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H003_CelebracionSubasta'')';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando orden de los campos.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Orden de los campos actualizados.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
	          ' SET TFI_ORDEN = 5 ' ||
	          ' WHERE TFI_NOMBRE = ''observaciones'' AND' ||
	          ' TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H003_CelebracionSubasta'')';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando orden de los campos.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Orden de los campos actualizados.');
    
    --INSERCIONES
    /*
    * LOOP ARRAY BLOCK-CODE: TAP_TAREA_PROCEDIMIENTO
    *---------------------------------------------------------------------
    */
    VAR_CURR_TABLE := PAR_TABLENAME_TARPR;
    V_CODIGO_TAP := 'TAP_CODIGO';
    VAR_CURR_ROWARRAY := 0;
    DBMS_OUTPUT.PUT('    [INSERT] '||V_ESQUEMA||'.' || PAR_TABLENAME_TARPR || '........');
    FOR I IN V_TIPO_TAP.FIRST .. V_TIPO_TAP.LAST
      LOOP
        V_TMP_TIPO_TAP := V_TIPO_TAP(I);

        --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
        -- si ya existían los registros en la tabla, se informa de q existen y no se hace nada
        -----------------------------------------------------------------------------------------------------------
        DBMS_OUTPUT.PUT_LINE('[INFO] Array codigo '||V_CODIGO_TAP||' = '''||V_TMP_TIPO_TAP(2)||''' Descripcion = '''||V_TMP_TIPO_TAP(9)||'''---------------------------------'); 
        DBMS_OUTPUT.PUT('[INFO] Verificando existencia de REGISTROS de la tabla '||VAR_CURR_TABLE||', con codigo '||V_CODIGO_TAP||' = '''||V_TMP_TIPO_TAP(2)||'''...'); 

        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||VAR_CURR_TABLE||' WHERE '||V_CODIGO_TAP||' = '''|| V_TMP_TIPO_TAP(2) ||''' ';
        --DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('OK - YA existe');
            DBMS_OUTPUT.PUT_LINE('[INFO] NO se inserta el registro del array porque ya existe en '||VAR_CURR_TABLE);
        ELSE
            DBMS_OUTPUT.PUT_LINE('OK - NO existe');

            V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || PAR_TABLENAME_TARPR || ' (' ||
                        'TAP_ID,DD_TPO_ID,TAP_CODIGO,TAP_VIEW,TAP_SCRIPT_VALIDACION,TAP_SCRIPT_VALIDACION_JBPM,TAP_SCRIPT_DECISION,DD_TPO_ID_BPM,' ||
                        'TAP_SUPERVISOR,TAP_DESCRIPCION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,TAP_ALERT_NO_RETORNO,TAP_ALERT_VUELTA_ATRAS,DD_FAP_ID,' ||
                        'TAP_AUTOPRORROGA,DTYPE,TAP_MAX_AUTOP,DD_TGE_ID,DD_STA_ID,TAP_EVITAR_REORG,DD_TSUP_ID,TAP_BUCLE_BPM) ' ||
                        'SELECT ' ||
                        'S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL, ' ||
                        '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.' || PAR_TABLENAME_TPROC || ' WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(1)),'''','''''')  || '''),' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(2)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(3)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(4)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(5)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(6)),'''','''''') || ''',' || 
                        '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.' || PAR_TABLENAME_TPROC || ' WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(7)),'''','''''') || '''),' ||
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
                        '(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_M || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(19)) || '''),' || 
                        '(SELECT DD_STA_ID FROM ' || V_ESQUEMA_M || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' || 
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(21)),'''','''''') || ''',' || 
                        '(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_M || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(22)) || '''),' || 
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(23)),'''','''''') 
                        || ''' FROM DUAL';

                VAR_CURR_ROWARRAY := I;
                --DBMS_OUTPUT.PUT_LINE(V_MSQL);
                --DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TAP(2)||''','''||TRIM(V_TMP_TIPO_TAP(9))||'''');
                EXECUTE IMMEDIATE V_MSQL;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('['||VAR_CURR_ROWARRAY||' filas-OK]');
    
    COMMIT;

EXCEPTION
     
    -- Opcional: Excepciones particulares que se quieran tratar
    -- Como esta, por ejemplo:
    -- WHEN TABLE_EXISTS_EXCEPTION THEN
        -- DBMS_OUTPUT.PUT_LINE('Ya se ha realizado la copia en la tabla TMP_MOV_'||TODAY);
 
 
    -- SIEMPRE DEBE HABER UN OTHERS
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
 
EXIT;
  	