/*
--##########################################
--## AUTOR=SERGIO NIETO
--## FECHA_CREACION=20160706
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.7
--## INCIDENCIA_LINK=RECOVERY-2026
--## PRODUCTO=NO
--##
--## Finalidad: BPM - Procedimiento Cambiario
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear


    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    
    --FALTA CAMBIAR LA RUTA DE LAS JSP
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
		T_TIPO_TAP('CJ030','CJ030_SolicitudCertificacion' ,null ,null ,null ,null ,null ,'0','Solicitud de certificación de dominios y cargas' ,'0','RECOVERY-2026','0' ,null ,null ,1,'1' ,'EXTTareaProcedimiento','3',null ,'814',null ,null,null),
		T_TIPO_TAP('CJ030','CJ030_SolicitarInformacionCargasAnt' ,null ,null ,'((valores[''CJ030_SolicitarInformacionCargasAnt''][''comboResultado''] == DDSiNo.SI) && (valores[''CJ030_SolicitarInformacionCargasAnt''][''fecha''] == null))?''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe introducir la fecha de presentaci&oacute;n</div>'':null' ,'valores[''CJ030_SolicitarInformacionCargasAnt''][''comboResultado''] == DDSiNo.SI ? ''SI'' : ''NO''' ,null ,'0','Solicitar información de cargas anteriores' ,'0','RECOVERY-2026','0' ,null ,null ,1,'0' ,'EXTTareaProcedimiento','0',null ,'814',null ,null,null),
		T_TIPO_TAP('CJ030','CJ030_RequerirInfoFalta' ,null ,null ,null ,null ,null ,'0','Requerir información que falta' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,1,'0' ,'EXTTareaProcedimiento','0',null ,'814',null ,null,null),
		T_TIPO_TAP('CJ030','CJ030_RegistrarInformacionCargasAnt' ,null ,null ,null ,'valores[''CJ030_RegistrarInformacionCargasAnt''][''comboCompletitud''] == DDCompletitud.COMPLETO ? ''Completo'' : ''Incompleto''' ,null ,'0','Registrar recepción información cargas anteriores' ,'0','RECOVERY-2026','0' ,null ,null ,1,'0' ,'EXTTareaProcedimiento','0',null ,'814',null ,null,null),
		T_TIPO_TAP('CJ030','CJ030_RegistrarCertificacion' ,null ,'comprobarCargasBienesProcedimiento() ? comprobarExisteDocumentoCCB() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento Certificado de cargas de cada bien.</div>'' : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Tiene que completar la informaci&oacute;n en la pesta&ntilde;a de cargas en la ficha del bien.</div>''' ,'((valores[''CJ030_RegistrarCertificacion''][''comboResultado''] == DDSiNo.SI) && (valores[''CJ030_RegistrarCertificacion''][''fecha''] == null))?''tareaExterna.error.CJ030_RegistrarCertificacion.fechaOblgatoria'':null' ,'valores[''CJ030_RegistrarCertificacion''][''comboResultado''] == DDSiNo.SI ? ''SI'' : ''NO''' ,null ,'0','Registrar certificación','0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,1,'1' ,'EXTTareaProcedimiento','3',null ,'814',null ,null,null),
		T_TIPO_TAP('CJ030','CJ030_ActualizarDatosTerceria' ,null ,null ,null ,null ,null ,'0','Actualizar datos y estudiar tercería mejor derecho' ,'0','RECOVERY-2026','0' ,null ,null ,1,'0' ,'EXTTareaProcedimiento','0',null ,'814',null ,null,null),
		T_TIPO_TAP('CJ030','CJ030_ActualizaDatosAnteriores' ,null ,null ,null ,null ,null ,'0','Actualizar datos anteriores' ,'0','RECOVERY-2026','0' ,null ,null ,1,'0' ,'EXTTareaProcedimiento','0',null ,'814',null ,null,null),
		T_TIPO_TAP('CJ030','CJ030_CertificacionDecision' ,null ,null ,null ,null ,null ,'0','Tarea toma de decisión' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,'814',null ,null,null)
    );
	V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
		T_TIPO_PLAZAS(null ,null ,'CJ030_SolicitudCertificacion','4*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ030_RegistrarCertificacion','30*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ030_SolicitarInformacionCargasAnt','5*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ030_ActualizaDatosAnteriores','5*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ030_ActualizarDatosTerceria','5*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ030_RegistrarInformacionCargasAnt','5*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ030_RequerirInfoFalta','30*24*60*60*1000L' ,'0','0','RECOVERY-2026')
    ); 
	V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
		T_TIPO_TFI('CJ030_SolicitudCertificacion','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que tenemos bienes embargados y anotado el embargo en el registro, en esta pantalla, debemos informar la fecha de presentación en el juzgado del escrito solicitando la certificación de cargas del bien o bienes respecto de los cuales se ha iniciado la vía de apremio.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será "Registrar certificación".</p></div>' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ030_SolicitudCertificacion','1','date' ,'fecha','Fecha solicitud' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ030_SolicitudCertificacion','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ030_SolicitarInformacionCargasAnt','0','label' ,'titulo','<div align="justify" style="margin-bottom: 30px;"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Dado que hemos obtenido la certificación de cargas de los bienes trabados, y analizada dicha documentación, en esta pantalla debemos especificar, para el supuesto de cargas inscritas con anterioridad o preferencia(urbanísticas, Ayto IBI, Cdad Propietarios) a la inscripción &nbsp;del embargo practicado por la entidad, embargo siempre si se solicita información sobre dichas cargas a los ejecutantes que nos preceden. Para el supuesto contrario se deberá especificar, en el primer campo de esta pantalla, que "no" se solicita.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">De haber solicitado dicha información, se deberá informar la fecha de presentación del escrito en el juzgado.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Una vez rellene esta pantalla la siguiente tarea será:</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">-Si se ha solicitado la información: "Registrar recepción información cargas anteriores".</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">-Si no se ha solicitado la información se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</span></font></p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ030_SolicitarInformacionCargasAnt','1','combo' ,'comboResultado','Solicitada' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ030_SolicitarInformacionCargasAnt','2','date' ,'fecha','Fecha' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ030_SolicitarInformacionCargasAnt','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ030_RequerirInfoFalta','0','label' ,'titulo','<div align="justify" style="margin-bottom: 30px;"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Para el supuesto de que la información solicitada haya sido incompleta o falta la contestación al requerimiento efectuado por el juzgado por alguno de los que tienen anotado embargo con anterioridad al de la entidad, en esta pantalla, se deberá informar la fecha en la que se presenta nuevo escrito al juzgado para que se requiera la información aún no aportada al procedimiento.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Una vez rellene ésta pantalla la siguiente tarea será "Registrar recepción información de cargas anteriores"</span></font></p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ030_RequerirInfoFalta','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ030_RequerirInfoFalta','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ030_RegistrarInformacionCargasAnt','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se debe informar la fecha de en la que se recibe notificación de la información solicitada. </p><p style="margin-bottom: 10px">En el segundo campo se ha de determinar si la información recibida se corresponde con toda la solicitada, en cuyo caso se deberá seleccionar la palabra "Completo". En caso contrario estaremos obligados a seleccionar el dato como "Incompleto".</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene ésta pantalla la siguiente tarea será:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">Si la información es incompleta: "Requerir información que falta".</li><li style="margin-bottom: 10px; margin-left: 35px;">Si la información es completa: "Actualizar datos y estudiar tercería mejor derecho".</li></ul></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ030_RegistrarInformacionCargasAnt','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ030_RegistrarInformacionCargasAnt','2','combo' ,'comboCompletitud','Información cargas' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDCompletitud','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ030_RegistrarInformacionCargasAnt','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ030_RegistrarCertificacion','0','label' ,'titulo','<div align="justify" style="margin-bottom: 30px;"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">La tramitación y obtención de la certificación de cartas será realizada por nuestro procurador. En esta pantalla se deberá confirmar la fecha de la obtención por parte del Registro de la Propiedad de la certificación solicitada.&nbsp;</span></font></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">La certificación obtenida se deberá incorporar como documento obligatorio para consulta por el responsable de la entidad. Deberá informar a nivel de bien todo lo necesario para su correcta identificación así como las cargas anteriores y posteriores.</span></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">Una vez rellene ésta pantalla la siguiente tarea será "Solicitar información de cargas anteriores".</span></p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ030_RegistrarCertificacion','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ030_RegistrarCertificacion','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ030_ActualizarDatosTerceria','0','label' ,'titulo','<div align="justify" style="margin-bottom: 30px;"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Una vez se dispone de toda la información sobre las cargas anteriores recogidas en la certificación emitida por el Registro de la Propiedad, en esta pantalla, se ha de informar la fecha en la que hemos analizado todas ellas y en consecuencia estamos en disposición de seleccionar, en el segundo campo de la pantalla, si cabe o no plantear tercería de mejor derecho sobre carga anotada con anterioridad a la de la entidad.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Una vez rellene ésta pantalla se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</span></font></p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ030_ActualizarDatosTerceria','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ030_ActualizarDatosTerceria','2','combo' ,'comboTerceria','Tercería mejor derecho' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ030_ActualizarDatosTerceria','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ030_ActualizaDatosAnteriores','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que el externo ha obtenido del Registro de la Propiedad certificaci&oacute;n de cargas de los bienes embargados, y dicho documento deber&aacute; hacerlo llegar al responsable de la entidad, en esta pantalla deber&aacute; de informar la fecha de recepci&oacute;n de dicha documentaci&oacute;n, debiendo proceder a la actualizaci&oacute;n de los datos sobre solvencia que obren en su poder.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ030_ActualizaDatosAnteriores','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ030_ActualizaDatosAnteriores','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026')
    );
    V_TMP_TIPO_TFI T_TIPO_TFI;
    
BEGIN	
	
    -- LOOP Insertando valores en TAP_TAREA_PROCEDIMIENTO
    VAR_TABLENAME := 'TAP_TAREA_PROCEDIMIENTO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar TAREAS');
    FOR I IN V_TIPO_TAP.FIRST .. V_TIPO_TAP.LAST
      LOOP
        V_TMP_TIPO_TAP := V_TIPO_TAP(I);
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
          ' DD_TSUP_ID=(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(22)) || '''),' ||
          ' USUARIOMODIFICAR=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(11)),'''','''''') || ''',' ||
          ' FECHAMODIFICAR=sysdate ' ||
        	' WHERE DD_TPO_ID = (SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(1))||''') and TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(2))||'''';
			--DBMS_OUTPUT.PUT_LINE(V_SQL);
		    EXECUTE IMMEDIATE V_SQL;	
            DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||VAR_TABLENAME||'... Actualizada la tarea '''|| TRIM(V_TMP_TIPO_TAP(2)) ||''', ' || TRIM(V_TMP_TIPO_TAP(3)));
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || ' (' ||
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
                    '(SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' || 
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(21)),'''','''''') || ''',' ||
		    '(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(22)) || '''),' ||
		    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(23)),'''','''''') || ''' FROM DUAL';
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TAP(2)||''','''||TRIM(V_TMP_TIPO_TAP(9))||'''');
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
          END IF;
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Tareas');


    -- LOOP Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    VAR_TABLENAME := 'DD_PTP_PLAZOS_TAREAS_PLAZAS';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar PLAZOS');
    FOR I IN V_TIPO_PLAZAS.FIRST .. V_TIPO_PLAZAS.LAST
      LOOP
        V_TMP_TIPO_PLAZAS := V_TIPO_PLAZAS(I);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_PLAZAS(3))||''')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
        IF V_NUM_TABLAS > 0 THEN				
	  V_SQL := 'UPDATE '||V_ESQUEMA||'.'||VAR_TABLENAME||' SET DD_PTP_PLAZO_SCRIPT=''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(4)),'''','''''') || ''',' ||
            ' USUARIOMODIFICAR=''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(7)),'''','''''') || ''',' ||
            ' FECHAMODIFICAR=sysdate ' ||
        	  ' WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_PLAZAS(3))||''')';
          EXECUTE IMMEDIATE V_SQL;
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_PTP_PLAZOS_TAREAS_PLAZAS... Se actualiza el plazo '''|| TRIM(V_TMP_TIPO_PLAZAS(3)) ||'''');
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || 
                    '(DD_PTP_ID,DD_JUZ_ID,DD_PLA_ID,TAP_ID,DD_PTP_PLAZO_SCRIPT,VERSION,BORRADO,USUARIOCREAR,FECHACREAR)' ||
                    'SELECT ' ||
                    ''||V_ESQUEMA||'.S_DD_PTP_PLAZOS_TAREAS_PLAZAS.NEXTVAL, ' ||
                    '(SELECT DD_JUZ_ID FROM ' || V_ESQUEMA || '.DD_JUZ_JUZGADOS_PLAZA WHERE DD_JUZ_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(1)) || '''), ' ||
                    '(SELECT DD_PLA_ID FROM ' || V_ESQUEMA || '.DD_PLA_PLAZAS WHERE DD_PLA_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(2)) || '''), ' ||
                    '(SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(3)) || '''), ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(5)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(6)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(7)),'''','''''') || ''', sysdate FROM DUAL'; 
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_PLAZAS(3) ||''','''||TRIM(V_TMP_TIPO_PLAZAS(4))||'''');
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
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
          ' FECHAMODIFICAR=sysdate ' ||
        	' WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TFI(1))||''') and TFI_ORDEN = '||TRIM(V_TMP_TIPO_TFI(2));
			--DBMS_OUTPUT.PUT_LINE(V_SQL);
		    EXECUTE IMMEDIATE V_SQL;	
	        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TFI_TAREAS_FORM_ITEMS... Actualizado el item '''|| TRIM(V_TMP_TIPO_TFI(1)) ||''' and TFI_NOMBRE = '||TRIM(V_TMP_TIPO_TFI(4))||' ');
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || 
                    '(TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)' ||
                    'SELECT ' ||
                    ''||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL, ' ||
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