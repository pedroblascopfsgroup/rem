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
		T_TIPO_TAP('CJ066','CJ066_obtenerMinuta' ,null ,'comprobarExisteDocumentoMINUTA() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar la minuta.</div>''' ,null ,null ,null ,'0','Obtener la minuta' ,'0','RECOVERY-2026','0' ,null ,null ,9,'0' ,'EXTTareaProcedimiento','0',null ,null,1 ,null,null),
		T_TIPO_TAP('CJ066','CJ066_validarMinuta' ,null ,null ,'(valores[''CJ066_validarMinuta''][''comboValidacion''] == DDSiNo.SI && (valores[''CJ066_validarMinuta''][''fecha''] == null || valores[''CJ066_validarMinuta''][''fecha''] == '''')) ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">El campo "Fecha validaci&oacute;n minuta" es obligatorio</div>'' : null' ,'valores[''CJ066_validarMinuta''][''comboValidacion''] == DDSiNo.SI ? ''SI'' : ''NO''' ,null ,'0','Validar la minuta' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,9,'0' ,'EXTTareaProcedimiento','0',null ,null,1 ,null,null),
		T_TIPO_TAP('CJ066','CJ066_registrarRecepcionEscritura' ,null ,null ,null ,null ,null ,'0','Registrar recepción de escritura' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,9,'0' ,'EXTTareaProcedimiento','0',null ,null,1 ,null,null),
		T_TIPO_TAP('CJ066','CJ066_registrarEntregaTitulo' ,null ,'comprobarExisteDocumentoRECIGEST() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento "Recib&iacute; de gestor&iacute;a (Inscripci&oacute;n T&iacute;tulo)".</div>''' ,null ,null ,null ,'0','Registrar entrega del título' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,9,'0' ,'EXTTareaProcedimiento','0',null ,null,1 ,null,null),
		T_TIPO_TAP('CJ066','CJ066_registrarPresentacionHacienda' ,null ,'comprobarExisteDocumentoCOAPH() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento "Copia de la autoliquidaci&oacute;n presentada en Hacienda".</div>''' ,null ,null ,null ,'0','Registrar presentación en Hacienda' ,'0','RECOVERY-2026','0' ,null ,null ,9,'0' ,'EXTTareaProcedimiento','0',null ,null,1 ,null,null),
		T_TIPO_TAP('CJ066','CJ066_registrarPresentacionRegistro' ,null ,null ,null ,null ,null ,'0','Registrar presentación en el registro' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,9,'0' ,'EXTTareaProcedimiento','0',null ,null,1 ,null,null),
		T_TIPO_TAP('CJ066','CJ066_registrarInscripcionTitulo' ,null ,null ,'valores[''CJ066_registrarInscripcionTitulo''][''situacionTitulo''] == ''INS'' ? (valores[''CJ066_registrarInscripcionTitulo''][''fechaInscripcion''] == null || valores[''CJ066_registrarInscripcionTitulo''][''fechaInscripcion''] == '''' ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">El campo "Fecha inscripci&oacute;n es obligatorio"</div>'' : null) : (valores[''CJ066_registrarInscripcionTitulo''][''fechaEnvio''] == null || valores[''CJ066_registrarInscripcionTitulo''][''fechaEnvio''] == '''' ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">El campo "Fecha env&iacute;o escrito subsanaci&oacute;n" es obligatorio</div>'' : null)' ,'valores[''CJ066_registrarInscripcionTitulo''][''situacionTitulo''] == ''INS'' ? ''INSCRITO'' : ''SUBSANACION''' ,null ,'0','Registrar inscripción del título' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,9,'1' ,'EXTTareaProcedimiento','3',null ,null,1 ,null,null),
		T_TIPO_TAP('CJ066','CJ066_BPMTramitePosesion' ,null ,null ,null ,null ,'CJ015' ,'0','Ejecutar trámite de posesión' ,'0','RECOVERY-2026','0' ,null ,null ,9,'0' ,'EXTTareaProcedimiento','0',null ,null,1 ,null,null),
		T_TIPO_TAP('CJ066','CJ066_BPMTramiteSubsanacionEscritura' ,null ,null ,null ,null ,'CJ065' ,'0','Ejecutar trámite subsanación de escritura' ,'0','RECOVERY-2026','0' ,null ,null ,9,'0' ,'EXTTareaProcedimiento','0',null ,null,1 ,null,null),
		T_TIPO_TAP('CJ066','CJ066_BPMTramiteSaneamientoCargas' ,null ,null ,null ,null ,'CJ008' ,'0','Ejecutar trámite saneamiento de cargas' ,'0','RECOVERY-2026','0' ,null ,null ,9,'0' ,'EXTTareaProcedimiento','0',null ,null,1 ,null,null)
    );
	V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
		T_TIPO_PLAZAS(null ,null ,'CJ066_obtenerMinuta','2*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ066_validarMinuta','2*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ066_registrarRecepcionEscritura','3*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ066_registrarEntregaTitulo','5*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ066_registrarPresentacionHacienda','damePlazo(valores[''CJ066_registrarEntregaTitulo''][''fecha'']) + 10*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ066_registrarPresentacionRegistro','(valores[''CJ066_registrarInscripcionTitulo''] != null && (valores[''CJ066_registrarInscripcionTitulo''][''fechaEnvio''] != null || valores[''CJ066_registrarInscripcionTitulo''][''fechaEnvio''] != '''')) ? 10*24*60*60*1000L : damePlazo(valores[''CJ066_registrarPresentacionHacienda''][''fecha'']) + 10*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ066_registrarInscripcionTitulo','damePlazo(valores[''CJ066_registrarPresentacionRegistro''][''fechaPresentacion'']) + 18*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ066_BPMTramitePosesion','300*24*60*60*1000L' ,'0','0','RECOVERY-2026')
    ); 
	V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
		T_TIPO_TFI('CJ066_obtenerMinuta','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla, el letrado debe infomar de la fecha de recepci&oacute;n de la minuta y, adjuntar la minuta para poder dar por finalizada la tarea.</p><p style="margin-bottom: 10px">En el campo observaciones infomar cualquier aspecto relevanete que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta tarea se lanzar&aacute; la tarea "Validar la minuta".</p></div>' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ066_obtenerMinuta','1','date' ,'fecha','Fecha recepción minuta' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ066_obtenerMinuta','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ066_validarMinuta','0','label' ,'titulo','<div align="justify" style="margin-bottom: 30px;"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">A través de esta pantalla, el área fiscal debe validar la minuta recibida por parte del letrado e informar de la fecha de validación de la misma.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En el supuesto de que A. Fiscal no valide la minuta, deberá enviar una notificación al Letrado para que indique al Notario que debe corregirla. La siguiente tarea será "Obtener minuta".</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En caso de que A. Fiscal valide la minuta, la siguiente tarea será "Registrar recepción de escritura".</span></font></p></div>' ,null ,null ,null ,null,'2','RECOVERY-2026'),
		T_TIPO_TFI('CJ066_validarMinuta','1','combo' ,'comboValidacion','Minuta validada' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','1','RECOVERY-2026'),
		T_TIPO_TFI('CJ066_validarMinuta','2','date' ,'fecha','Fecha validación minuta' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ066_validarMinuta','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ066_registrarRecepcionEscritura','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; informar la fecha de recepci&oacute;n de la escritura del bien.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ066_registrarRecepcionEscritura','1','date' ,'fecha','Fecha recepción' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ066_registrarRecepcionEscritura','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ066_registrarEntregaTitulo','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; de informar de la fecha en que recibe la informaci&oacute;n sobre los documentos asignados que se le han enviado.</p><p style="margin-bottom: 10px">Antes de dar por terminada esta tarea deber&aacute;:</p><p style="margin-bottom: 10px; margin-left: 40px;">- Liquidar impuestos  en  plazo  seg&uacute;n CCAA. En caso de personas jur&iacute;dicas existir&aacute; una consulta previa realizada sobre la posible liquidaci&oacute;n de IVA. Esta informaci&oacute;n podr&aacute; consultarla a trav&eacute;s de la ficha de cada uno de los bienes incluidos.</p><p style="margin-bottom: 10px; margin-left: 40px;">- Verificar situaci&oacute;n ocupacional de la finca para manifestaci&oacute;n de libertad arrendamientos de cara a inscripci&oacute;n (LAU).</p><p style="margin-bottom: 10px; margin-left: 40px;">- Redactar en su caso, certificado de Libertad de Arrendamiento (por poder de la Entidad), para presentaci&oacute;n  en el registro junto con el testimonio y los mandamientos.</p><p style="margin-bottom: 10px; margin-left: 40px;">- Realizar notificaci&oacute;n fehaciente a inquilinos para la inscripci&oacute;n  (en casos de inmueble con arrendamiento reconocido)</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzará la tarea “Registrar presentación en hacienda” y, al mismo tiempo, el "Trámite de posesión".</p></div>' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ066_registrarEntregaTitulo','1','date' ,'fecha','Fecha recepción' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ066_registrarEntregaTitulo','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ066_registrarPresentacionHacienda','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; presentar la liquidaci&oacute;n del testimonio en Hacienda, una vez realizado esto deber&aacute; adjuntar al procedimiento correspondiente copia escaneada del documento de liquidaci&oacute;n de impuestos.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea "Registrar presentaci&oacute;n en el registro".</p></div>' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ066_registrarPresentacionHacienda','1','date' ,'fecha','Fecha presentación' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ066_registrarPresentacionHacienda','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ066_registrarPresentacionRegistro','0','label' ,'titulo','<div align="justify" style="margin-bottom: 30px;"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En caso de que se haya tenido que presentar subsanación y por tanto estemos a la espera de recibir el nuevo testimonio decreto de adjudicación, en el campo fecha nuevo testimonio debe reflejar la fecha en la que se recibe el nuevo testimonio.</span></font></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">Una vez rellene esta pantalla se lanzará la tarea "Registrar inscripción del título".</span></p></div>' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ066_registrarPresentacionRegistro','1','date' ,'fechaPresentacion','Fecha presentación' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ066_registrarPresentacionRegistro','2','date' ,'fechaTestimonio','Fecha nuevo testimonio' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ066_registrarPresentacionRegistro','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ066_registrarInscripcionTitulo','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deberá indicar la situación en que queda el título ya sea inscrito en el registro o pendiente de subsanación, a través de la ficha del bien correspondiente deberá de actualizar los campos: folio, libro, tomo, inscripción Xª, referencia catastral, porcentaje de propiedad, nº de finca -si hubiera cambios Actualizado. Una vez actualizados estos campos deberá de marcar la fecha de actualización en la ficha del bien.</p><p style="margin-bottom: 10px">En caso de haberse producido una resolución desfavorable y haber marcado el bien en situación "Subsanar", deberá informar la fecha de envío de escrito de subsanación y proceder a la remisión de los documentos al Procurador e informar al Letrado.</p><p style="margin-bottom: 10px">En caso de haber quedado inscrito el bien, deberá informar la fecha en que se haya producido dicha inscripción.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzará, en caso de requerir subsanación el trámite de subsanación de escritura  a realizar por el letrado, y en caso contrario se iniciará el trámite de saneamiento de cargas para el bien afecto a este trámite.</p></div>' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ066_registrarInscripcionTitulo','1','combo' ,'situacionTitulo','Situación del título' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSituacionTitulo','1','RECOVERY-2026'),
		T_TIPO_TFI('CJ066_registrarInscripcionTitulo','2','date' ,'fechaInscripcion','Fecha inscripción' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ066_registrarInscripcionTitulo','3','date' ,'fechaEnvio','Fecha envío escrito subsanación' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ066_registrarInscripcionTitulo','4','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ066_BPMTramitePosesion','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Ejecuci&oacute;n del tr&aacute;mite de Posesi&oacute;n</p></div>' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ066_BPMTramiteSubsanacionEscritura','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Ejecuci&oacute;n del tr&aacute;mite de Subsanaci&oacute;n de Escritura</p></div>' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ066_BPMTramiteSaneamientoCargas','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Ejecuci&oacute;n del tr&aacute;mite de Saneamiento de Cargas</p></div>' ,null ,null ,null ,null,'1','RECOVERY-2026')
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