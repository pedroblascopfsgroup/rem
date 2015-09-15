--/*
--##########################################
--## AUTOR=GONZALO ESTELLES
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    V_TAREA VARCHAR(50 CHAR);

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(2000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
      T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ 'H009',
        /*TAP_CODIGO...................:*/ 'H009_BPMCreditosContingentes',
        /*TAP_VIEW.....................:*/ null,
        /*TAP_SCRIPT_VALIDACION........:*/ null,
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ null,
        /*DD_TPO_ID_BPM(FK)............:*/ 'HC103',
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Trámite Créditos contigentes',
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
        /*DD_STA_ID(FK)................:*/ 'CJ-814',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ null,
        /*TAP_BUCLE_BPM................:*/ null        
        ) 
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
      T_TIPO_PLAZAS(null,null,'H009_BPMCreditosContingentes','300*24*60*60*1000L','0','0','DD')
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;

    
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-741');
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			' SET TAP_SCRIPT_VALIDACION = ''comprobarMinimoBienLote() ? (comprobarExisteDocumentoESRAS() ? (comprobarProvLocFinBien() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Los bienes con lote deben tener informado el tipo de inmueble, provincia, localidad y n&uacute;mero de finca.</div>'''') : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento "Diligencia de se&ntilde;alamiento Edicto de subasta".</div>'''') : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Al menos un bien debe estar asignado a un lote</div>'''''' ' ||
			' WHERE TAP_CODIGO = ''CJ004_SenyalamientoSubasta'' ';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-741');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-768');
	V_TAREA:='H009_RevisarInsinuacionCreditos';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_ERROR_VALIDACION=NULL ' ||
	  ' ,TFI_VALIDACION=NULL ' ||
	  ' WHERE TFI_NOMBRE=''numCreditos'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET ' ||
	' TAP_VIEW = ''plugin/cajamar/tramiteFaseComun/revisarInsinuacionCreditos''' ||
	' ,TAP_SCRIPT_VALIDACION_JBPM=''valores[''''H009_RevisarInsinuacionCreditos''''][''''comboRectificacion'''']==DDSiNo.SI && valores[''''H009_RevisarInsinuacionCreditos''''][''''numCreditos'''']==null ? ''''Debe indicar el n&uacute;mero de cr&eacute;ditos rectificados.'''' : null'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-768');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-770');
	V_TAREA:='H009_PresentacionAdenda';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET ' ||
	' TAP_SCRIPT_VALIDACION = NULL' ||
	' ,TAP_SCRIPT_VALIDACION_JBPM=''valores[''''H009_PresentacionAdenda''''][''''comboAdenda'''']==DDSiNo.SI && !comprobarExisteDocumentoRESADE() ? ''''Debe adjuntar el documento "Resoluci&oacute;n de la adenda"'''' : null'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-770');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-760');
	V_TAREA:='CJ001_RegistrarRespuestaComite';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET ' ||
	' TAP_VIEW = ''plugin/cajamar/tramiteVentaDirecta/registrarRespuestaComite''' ||
	' ,TAP_SCRIPT_VALIDACION_JBPM=''valores[''''CJ001_RegistrarRespuestaComite''''][''''comboResultado'''']==''''CON_OFE'''' && valores[''''CJ001_RegistrarRespuestaComite''''][''''importe'''']==null ? ''''Debe indicar el importe.'''' : null'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-760');

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-761');
	V_TAREA:='CJ001_ContactarDeudor';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_ERROR_VALIDACION=''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio''' ||
	  ' ,TFI_VALIDACION=''valor != null && valor != '''' ? true : false''' ||
	  ' WHERE TFI_NOMBRE=''comboAdministrador'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-761');

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-759');
	V_TAREA:='CJ001_ResolucionFirme';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET ' ||
	' TAP_SCRIPT_VALIDACION = NULL' ||
	' ,TAP_SCRIPT_VALIDACION_JBPM=''valores[''''CJ001_AdmisionJuzgado''''][''''comboAdmision'''']==DDSiNo.SI && !comprobarExisteDocumentoAUTO() ? ''''Para completar esta tarea debe adjuntar el documento "Auto" al procedimiento.'''' : null'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-759');
	
	
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
                    'S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL, ' ||
                    '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(1)),'''','''''')  || '''),' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(2)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(3)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(5)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(6)),'''','''''') || ''',' || 
                    '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(7)),'''','''''') || '''),' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(8)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(9)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(10)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(11)),'''','''''') || ''',' ||
                    'sysdate,''' || REPLACE(TRIM(V_TMP_TIPO_TAP(12)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(13)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(14)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(15)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(16)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(17)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(18)),'''','''''') || ''',' ||
                    '(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(19)) || '''),' || 
                    '(SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' || 
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(21)),'''','''''')
										|| ''',' ||'(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO='''|| REPLACE(TRIM(V_TMP_TIPO_TAP(22)),'''','''''') || ''')'
										|| ',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(23)),'''','''''') || ''' FROM DUAL';
          
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