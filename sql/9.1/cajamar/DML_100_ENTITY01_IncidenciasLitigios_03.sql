--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20150802
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3-hcj
--## INCIDENCIA_LINK=VARIAS
--## PRODUCTO=NO
--##
--## Finalidad: Resolución de varias incidencias de Litigios
--## INSTRUCCIONES: Relanzable
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';    -- [PARAMETRO] Configuracion Esquemas
    
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_SQL VARCHAR2(4000 CHAR);                          -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16);                            -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    PAR_TABLENAME_TPROC VARCHAR2(50 CHAR) := 'DD_TPO_TIPO_PROCEDIMIENTO';   -- [PARAMETRO] TABLA para tipo de procedimiento. Por defecto DD_TPO_TIPO_PROCEDIMIENTO
    PAR_TABLENAME_TARPR VARCHAR2(50 CHAR) := 'TAP_TAREA_PROCEDIMIENTO';     -- [PARAMETRO] TABLA para tareas del procedimiento. Por defecto TAP_TAREA_PROCEDIMIENTO
    VAR_CURR_ROWARRAY VARCHAR2(25 CHAR);                -- Variable con fila array actual - para excepciones
    VAR_CURR_TABLE VARCHAR2(50 CHAR);                   -- Variable con tabla actual - para excepciones
    
    V_CODIGO_TAP VARCHAR2(100 CHAR); -- Variable para nombre campo FK con codigo de Tap tareas
    V_TAREA VARCHAR(50 CHAR);
    V_COD_PROCEDIMIENTO VARCHAR(10 CHAR) := 'HC104'; -- Código de procedimiento para reemplazar
    
    /*
    * ARRAY TABLA2: TAP_TAREA_PROCEDIMIENTO
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(2000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
	      T_TIPO_TAP(
	        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
	        /*TAP_CODIGO...................:*/ 'HC104_SolicitudSolvenciaPatrimonial',
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
	        /*DD_STA_ID(FK)................:*/ 'DGAEST',
	        /*TAP_EVITAR_REORG.............:*/ null,
	        /*DD_TSUP_ID(FK)...............:*/ null,
	        /*TAP_BUCLE_BPM................:*/ null        
	        )
       );
        
        V_TMP_TIPO_TAP T_TIPO_TAP;    
    
BEGIN	
	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-628');
	V_TAREA:='HC103_SolicitarProvision';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valoresBPMPadre[''''H005_ConfirmarTestimonio''''] != null ? ''''SI'''' : ''''NO'''''' WHERE TAP_CODIGO = '''|| V_TAREA ||'''';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-628');

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-672');
	V_TAREA:='H030_RegistrarCertificacion';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION=''comprobarCargasBienesProcedimiento() ? comprobarExisteDocumentoCCB() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento Certificado de cargas de cada bien.</div>'''' : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Tiene que completar la informaci&oacute;n en la pesta&ntilde;a de cargas en la ficha del bien.</div>'''''' WHERE TAP_CODIGO = '''|| V_TAREA ||'''';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-672');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-630');
	V_TAREA:='H008_PropuestaCancelacionCargas';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION=NULL WHERE TAP_CODIGO = '''|| V_TAREA ||'''';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-630');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-618');
	V_TAREA:='HC104_RegistrarResultadoSolvencia';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = ''comprobarExisteDocumentoASP() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>Debe adjuntar el documento "Resultado averiguaci&oacute;n solvencia patrimonial".</p></div>'''''' WHERE TAP_CODIGO = '''|| V_TAREA ||'''';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-618');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-631');
	V_TAREA:='H005_BPMDeclaracionIVAIGIC';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez emitido el auto decreto de adjudicaci&oacute;n, la entidad deber&aacute; realizar la declaraci&oacute;n en funci&oacute;n del tipo de tributaci&oacute;n definido en el informe fiscal. En el caso de el tipo de tributaci&oacute;n sea IVA sujeto y deducible, adem&aacute;s de la declaraci&oacute;n la entidad deber&aacute; auto emitir una factura.</p><p style="margin-bottom: 10px">Se indicar&aacute; la fecha en la que se ha declarado el IVA/IGIC de la operaci&oacute;n.</p><p style="margin-bottom: 10px">En el campo Observaciones informar de cualquier aspecto relevante que le interese quede reflejado en este punto del procedimiento.</p></div>'' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''|| V_TAREA ||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-631');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-603');
	V_TAREA:='H015_RegistrarSolicitudPosesion';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Antes de dar por completada esta tarea deber&aacute; de haber un bien vinculado al procedimiento, esto podr&aacute; comprobarlo a trav&eacute;s de la pestaña Bienes del procedimiento, en caso de no haberlo, a trav&eacute;s de esa misma pestaña dispone de la opci&oacute;n de Agregar por la cual se le permite vincular un bien al procedimiento.</p><p style="margin-bottom: 10px">A trav&eacute;s de esta tarea deber&aacute; de informar si hay una posible posesi&oacute;n o no. En caso de que no sea posible la posesi&oacute;n deber&aacute; anotar si existe un contrato de arrendamiento v&aacute;lido vinculado al bien. En caso de que proceda, la fecha de solicitud de la posesi&oacute;n, si el bien se encuentra ocupado o no,  si se ha producido una petici&oacute;n de moratoria y en cualquier caso se deber&aacute; informar la condici&oacute;n del bien respecto a si es vivienda habitual o no.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla y dependiendo de la informaci&oacute;n registrada se lanzar&aacute;:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">En caso de haber solicitud de moratoria de posesi&oacute;n se iniciar&aacute; el tr&aacute;mite para tal efecto.</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de encontrarse el bien con ocupantes, se lanzar&aacute; el tr&aacute;mite de ocupantes.</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de encontrarse el bien sin ocupantes, se lanzar&aacute; la tarea "Registrar señalamiento de la posesi&oacute;n".</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de que haya indicado que existe un contrato v&aacute;lido, se lanzar&aacute; la tarea Confirmar notificaci&oacute;n deudor.</li><li style="margin-bottom: 10px; margin-left: 35px;">En el caso de que el bien no est&eacute; en ninguna de las situaciones expuestas y no haya una posible posesi&oacute;n, se le abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</li></ul></div>'' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''|| V_TAREA ||''')';

	V_TAREA:='H015_RegistrarPosesionYLanzamiento';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deber&aacute; informar en primer lugar si el bien se encuentra ocupado, y en caso negativo indicar la fecha de realizaci&oacute;n de la posesi&oacute;n, necesario fuerza p&uacute;blica y si el lanzamiento es necesario o no.</p><p style="margin-bottom: 10px">En caso de haberse producido la posesi&oacute;n deber&aacute; de adjuntar al procedimiento el documento "Diligencia judicial de la posesi&oacute;n"</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez completada esta tarea se lanzar&aacute;:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">En caso de haber marcado el bien como ocupado, se lanzar&aacute; el tr&aacute;mite de ocupantes.</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de Lanzamiento necesario se lanzar&aacute; la tarea "Registrar señalamiento del lanzamiento".</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de no ser necesario el lanzamiento se lanzar&aacute; la tarea "Registrar decisi&oacute;n sobre llaves".</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de que el bien sea la vivienda habitual, se lanzar&aacute; la tarea "Solicitud alquiler social".</li></ul></div>'' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''|| V_TAREA ||''')';
	
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-603');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-632');
	V_TAREA:='H018_InterposicionDemanda';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO tap SET tap.TAP_SCRIPT_VALIDACION = ''!asuntoConProcurador() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'''' : !comprobarExisteDocumentoEDH() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>Es necesario adjuntar el Escrito de la demanda completo + copia sellada de la demanda.</p></div>'''' : tieneBienes() && !isBienesConFechaSolicitud() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><div id="permiteGuardar"><p>&iexcl;Atenci&oacute;n! En  caso de que haya bienes a embargar, deber&iacute;a de marcarlos a trav&eacute;s de la pesta&ntilde;a Bienes dentro de la ficha de la propia actuaci&oacute;n.</p></div></div>'''' : null'' WHERE tap.TAP_CODIGO = '''|| V_TAREA ||'''';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Informar fecha de presentaci&oacute;n de la demanda. Ind&iacute;quese la plaza y n&uacute;mero de juzgado.</p><p style="margin-bottom: 10px">Usted debe introducir la fecha de solicitud de embargo para cada uno de los bienes en la pesta&ntilde;a de "Bienes".</p><p style="margin-bottom: 10px">En el campo "Solicitar provisi&oacute;n de fondos" deber&aacute; indicar si va a solicitar o no provisi&oacute;n de fondos.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Auto Despachando ejecuci&oacute;n + Marcado de bienes decreto embargo" y si ha marcado que requiere provisi&oacute;n de fondos, se lanzar&aacute; el "Tr&aacute;mite de solicitud de fondos".</p></div>'' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''|| V_TAREA ||''')';
	
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-632');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-633');
	V_TAREA:='H020_InterposicionDemandaMasBienes';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO tap SET tap.TAP_SCRIPT_VALIDACION = ''!asuntoConProcurador() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'''' : !comprobarExisteDocumentoEDH() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>Es necesario adjuntar el Escrito de la demanda completo + copia sellada de la demanda.</p></div>'''' : tieneBienes() && !isBienesConFechaSolicitud() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><div id="permiteGuardar"><p>&iexcl;Atenci&oacute;n! En  caso de que haya bienes a embargar, deber&iacute;a de marcarlos a trav&eacute;s de la pesta&ntilde;a Bienes dentro de la ficha de la propia actuaci&oacute;n.</p></div></div>'''' : null'' WHERE tap.TAP_CODIGO = '''|| V_TAREA ||'''';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Informar fecha de presentaci&oacute;n de la demanda e ind&iacute;quese la plaza del juzgado.</p><p style="margin-bottom: 10px">Se ha de indicar la fecha de cierre de la deuda junto con el principal de la demanda, el capital vencido, capital no vencido, juntos con los intereses ordinarios y de demora que se han generado en el cierre.</p><p style="margin-bottom: 10px">Debe introducir la fecha de solicitud de embargo para cada uno de los bienes en la pestaña de "Bienes".</p><p style="margin-bottom: 10px">En el campo "Solicitar provisi&oacute;n de fondos" deber&aacute; indicar si va a solicitar o no provisi&oacute;n de fondos.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Auto Despachando ejecuci&oacute;n + Marcado de bienes decreto embargo" y si ha marcado que requiere provisi&oacute;n de fondos, se lanzar&aacute; el "Tr&aacute;mite de solicitud de fondos".</p></div>'' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''|| V_TAREA ||''')';
	
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-633');
	
	
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

        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||VAR_CURR_TABLE||' WHERE '||V_CODIGO_TAP||' = '''|| V_TMP_TIPO_TAP(2) ||''' ';
        --DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

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
                        '(SELECT DD_TGE_ID FROM ' || V_ESQUEMA || '.DD_TGE_TIPO_GESTION WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(19)) || '''),' || 
                        '(SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' || 
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(21)),'''','''''') || ''',' 
                             ||'(select dd_tge_id from ' || V_ESQUEMA_MASTER || '.dd_tge_tipo_gestor where dd_tge_codigo='''|| REPLACE(TRIM(V_TMP_TIPO_TAP(22)),'''','''''') || '''),''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(23)),'''','''''') 
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