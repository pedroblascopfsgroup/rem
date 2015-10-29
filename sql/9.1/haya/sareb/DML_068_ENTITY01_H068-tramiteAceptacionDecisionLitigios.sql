--/*
--##########################################
--## AUTOR=NACHO ARCOS
--## FECHA_CREACION=20150914
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.6-hy-rc01
--## INCIDENCIA_LINK=HR-1164
--## PRODUCTO=NO
--##
--## Finalidad: Nuevo trámite de aceptación y decisión de litigios
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_CODIGO_TPO VARCHAR2(30 CHAR);
    V_COD_PROCEDIMIENTO VARCHAR (20 CHAR) := 'H068';
    CODIGO_PROCEDIMIENTO_ANTIGUO_1 VARCHAR2(10 CHAR) := 'P420'; -- Variable con el código (DD_TPO_ID) del procedimiento antiguo para poder desactivarlo
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    
     /*
    * ARRAY TABLA1: DD_TPO_TIPO_PROCEDIMIENTO
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
      T_TIPO_TPO(
        /*DD_TPO_CODIGO.............::*/ 'H068',
        /*DD_TPO_DESCRIPCION.........:*/ 'T. Aceptación Decisión Litigios',
        /*DD_TPO_DESCRIPCION_LARGA...:*/ 'Trámite de Aceptación Decisión Litigios',
        /*DD_TPO_HTML................:*/ null,
        /*DD_TPO_XML_JBPM............:*/ 'haya_tramiteAceDecLitigios',
        /*VERSION....................:*/ '0',
        /*USUARIOCREAR...............:*/ 'DD',
        /*BORRADO....................:*/ '0',
        /*DD_TAC_ID..................:*/ '03',
        /*DD_TPO_SALDO_MIN...........:*/ null,
        /*DD_TPO_SALDO_MAX...........:*/ null,
        /*FLAG_PRORROGA..............:*/ '1',
        /*DTYPE......................:*/ 'MEJTipoProcedimiento',
        /*FLAG_DERIVABLE.............:*/ '1',
        /*FLAG_UNICO_BIEN............:*/ '0'
        )  --Cerrar con ")," si no es la ultima fila. Cerrar con ")" si es ultima fila
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;


    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(2000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(

	    T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
        /*TAP_CODIGO...................:*/ 'H068_registrarAceptacion',
        /*TAP_VIEW.....................:*/ 'plugin/procedimientos-bpmHaya-plugin/tramiteAceptacionLitigios/regAceptacion',
        /*TAP_SCRIPT_VALIDACION........:*/ null,
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ 'valores[''H068_registrarAceptacion''][''comboConflicto''] == DDSiNo.SI || valores[''H068_registrarAceptacion''][''comboAceptacion''] == DDSiNo.NO ?  ''noAceptacion'' : ''aceptacion'' ',
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Registrar aceptación del asunto',
        /*VERSION......................:*/ '0',
        /*USUARIOCREAR.................:*/ 'DD',
        /*BORRADO......................:*/ '0',
        /*TAP_ALERT_NO_RETORNO.........:*/ null,
        /*TAP_ALERT_VUELTA_ATRAS.......:*/ null,
        /*DD_FAP_ID(FK)................:*/ null,
        /*TAP_AUTOPRORROGA.............:*/ '1',
        /*DTYPE........................:*/ 'EXTTareaProcedimiento',
        /*TAP_MAX_AUTOP................:*/ '3',
        /*DD_TGE_ID(FK)................:*/ null,
        /*DD_STA_ID(FK)................:*/ '814',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ 'SULI',
        /*TAP_BUCLE_BPM................:*/ null        
        ),
        
        T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
        /*TAP_CODIGO...................:*/ 'H068_registrarProcedimiento',
        /*TAP_VIEW.....................:*/ 'plugin/procedimientos-bpmHaya-plugin/tramiteAceptacionLitigios/regProcedimiento',
        /*TAP_SCRIPT_VALIDACION........:*/ null,
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ 'valores[''H068_registrarProcedimiento''][''comboDocCompleta'']==DDSiNo.NO && (valores[''H068_registrarProcedimiento''][''fechaEnvio'']==null || valores[''H068_registrarProcedimiento''][''observaciones'']==null) ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe indicar la fecha de env&iacute;o de la documentaci&oacute;n y el problema en el campo observaciones</div>'' : (valores[''H068_registrarProcedimiento''][''comboDocCompleta'']==DDSiNo.SI && valores[''H068_registrarProcedimiento''][''tipoProcedimiento'']==null ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe indicar el tipo de procedimiento a iniciar</div>'' : null)',
        /*TAP_SCRIPT_DECISION..........:*/ 'valores[''H068_registrarProcedimiento''][''comboDocCompleta'']==DDSiNo.NO ? ''requiereSubsanacion'' : ((valores[''H068_registrarProcedimiento''][''tipoPropuestoEntidad'']==null || valores[''H068_registrarProcedimiento''][''tipoPropuestoEntidad'']=='''' || valores[''H068_registrarProcedimiento''][''tipoProcedimiento'']==valores[''H068_registrarProcedimiento''][''tipoPropuestoEntidad'']) ? ''lanzar'' : ''cambioDocumento'')',
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Registrar toma de decisión',
        /*VERSION......................:*/ '0',
        /*USUARIOCREAR.................:*/ 'DD',
        /*BORRADO......................:*/ '0',
        /*TAP_ALERT_NO_RETORNO.........:*/ null,
        /*TAP_ALERT_VUELTA_ATRAS.......:*/ null,
        /*DD_FAP_ID(FK)................:*/ null,
        /*TAP_AUTOPRORROGA.............:*/ '1',
        /*DTYPE........................:*/ 'EXTTareaProcedimiento',
        /*TAP_MAX_AUTOP................:*/ '3',
        /*DD_TGE_ID(FK)................:*/ null,
        /*DD_STA_ID(FK)................:*/ '814',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ 'SULI',
        /*TAP_BUCLE_BPM................:*/ null        
        ),
        
        T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
        /*TAP_CODIGO...................:*/ 'H068_validarNoAceptacion',
        /*TAP_VIEW.....................:*/ 'plugin/procedimientos-bpmHaya-plugin/tramiteAceptacionLitigios/validarNoAceptacion',
        /*TAP_SCRIPT_VALIDACION........:*/ null,
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ null,
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Validar la no aceptación del Asunto',
        /*VERSION......................:*/ '0',
        /*USUARIOCREAR.................:*/ 'DD',
        /*BORRADO......................:*/ '0',
        /*TAP_ALERT_NO_RETORNO.........:*/ null,
        /*TAP_ALERT_VUELTA_ATRAS.......:*/ 'tareaExterna.cancelarTarea',
        /*DD_FAP_ID(FK)................:*/ null,
        /*TAP_AUTOPRORROGA.............:*/ '1',
        /*DTYPE........................:*/ 'EXTTareaProcedimiento',
        /*TAP_MAX_AUTOP................:*/ '3',
        /*DD_TGE_ID(FK)................:*/ null,
        /*DD_STA_ID(FK)................:*/ '817',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ 'DULI',
        /*TAP_BUCLE_BPM................:*/ null        
        ),
        
        T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
        /*TAP_CODIGO...................:*/ 'H068_validarCambioProcedimiento',
        /*TAP_VIEW.....................:*/ 'plugin/procedimientos-bpmHaya-plugin/tramiteAceptacionLitigios/validacionTipoProcedimientoPropuestoLetrado',
        /*TAP_SCRIPT_VALIDACION........:*/ null,
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ 'valores[''H068_validarCambioProcedimiento''][''comboValidacion''] == DDSiNo.NO ? ''No'' : ''Si'' ',
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Validar cambio de procedimiento',
        /*VERSION......................:*/ '0',
        /*USUARIOCREAR.................:*/ 'DD',
        /*BORRADO......................:*/ '0',
        /*TAP_ALERT_NO_RETORNO.........:*/ null,
        /*TAP_ALERT_VUELTA_ATRAS.......:*/ 'tareaExterna.cancelarTarea',
        /*DD_FAP_ID(FK)................:*/ null,
        /*TAP_AUTOPRORROGA.............:*/ '1',
        /*DTYPE........................:*/ 'EXTTareaProcedimiento',
        /*TAP_MAX_AUTOP................:*/ '3',
        /*DD_TGE_ID(FK)................:*/ null,
        /*DD_STA_ID(FK)................:*/ '817',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ 'DULI',
        /*TAP_BUCLE_BPM................:*/ null        
        ),
        
        T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
        /*TAP_CODIGO...................:*/ 'H068_SubsanarErrDocumentacion',
        /*TAP_VIEW.....................:*/ 'plugin/procedimientos-bpmHaya-plugin/tramiteAceptacionLitigios/subsanacionErrorDoc',
        /*TAP_SCRIPT_VALIDACION........:*/ null,
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ null,
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Subsanar error en documentación',
        /*VERSION......................:*/ '0',
        /*USUARIOCREAR.................:*/ 'DD',
        /*BORRADO......................:*/ '0',
        /*TAP_ALERT_NO_RETORNO.........:*/ null,
        /*TAP_ALERT_VUELTA_ATRAS.......:*/ 'tareaExterna.cancelarTarea',
        /*DD_FAP_ID(FK)................:*/ null,
        /*TAP_AUTOPRORROGA.............:*/ '1',
        /*DTYPE........................:*/ 'EXTTareaProcedimiento',
        /*TAP_MAX_AUTOP................:*/ '3',
        /*DD_TGE_ID(FK)................:*/ null,
        /*DD_STA_ID(FK)................:*/ '817',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ 'DULI',
        /*TAP_BUCLE_BPM................:*/ null        
        )
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
		T_TIPO_PLAZAS(null,null,'H068_registrarAceptacion','3*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H068_registrarProcedimiento','2*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H068_validarNoAceptacion','1*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H068_validarCambioProcedimiento','2*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H068_SubsanarErrDocumentacion','damePlazo(valores[''H068_registrarProcedimiento''][''fechaEnvio''])+10*24*60*60*1000L','0','0','DD')
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
		T_TIPO_TFI('H068_registrarAceptacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; indicar si acepta el Asunto asignado por la entidad o no.</p><p style="margin-bottom: 10px">En el campo "Conflicto de intereses" deber&aacute; informar la existencia de conflicto o no, que le impida aceptar la direcci&oacute;n de la acci&oacute;n a instar, en caso de que haya conflicto de intereses no se le permitir&aacute; la aceptaci&oacute;n del Asunto.</p><p style="margin-bottom: 10px">En el campo "Aceptaci&oacute;n del asunto " deber&aacute; indicar si acepta o no el asunto, si ha marcado con anterioridad que existe conflicto de intereses, deber&aacute; marcar, en todo caso, la no aceptaci&oacute;n del asunto.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Registrar recepci&oacute;n de la documantaci&oacute;n" en caso de que haya aceptado el asunto, en caso de no haber aceptado el asunto se crear&aacute; una tarea al supervisor para que tenga en cuenta su respuesta a la vez que reasigna el asunto a otro letrado.</p></div>',null,null,null,null,'0','DD'),	
		T_TIPO_TFI('H068_registrarAceptacion','1','currency','principal','Principal',null,null,'procedimientoManager.getProcedimiento(idProcedimiento).getSaldoRecuperacion()',null,'0','DD'),
		T_TIPO_TFI('H068_registrarAceptacion','2','combo','comboConflicto','Conflicto de intereses','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('H068_registrarAceptacion','3','combo','comboAceptacion','Aceptación del asunto','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('H068_registrarAceptacion','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H068_registrarProcedimiento','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla deber&aacute; informar la fecha en la que recibe la documentaci&oacute;n, en el campo ¿Documentaci&oacute;n completa y correcta¿ deber&aacute; indicar si la documentaci&oacute;n del expediente efectivamente es completa y correcta o no. En caso de no ser completa deber&aacute; indicar el problema en el campo Observaciones y la fecha en la que haya devuelto el expediente a la EDP. Es muy importante que revise la documentaci&oacute;n e indique el problema encontrado en caso de error.</p><p style="margin-bottom: 10px">En el campo "Procedimiento propuesto por la entidad" se le indica el tipo de procedimiento propuesto por la entidad. En caso de estar de acuerdo con dicha propuesta de actuaci&oacute;n, deber&aacute; informar en el campo "Procedimiento a iniciar" el mismo tipo de procedimiento, en caso contrario, deber&aacute; seleccionar otro procedimiento seg&uacute;n su criterio, el cual ser&aacute; propuesto al supervisor asignado a este asunto.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla, en caso de haber encontrado un problema en la documentaci&oacute;n se iniciar&aacute; la tarea ¿Subsanar error en documentaci&oacute;n¿ a realizar por la empresa de preparaci&oacute;n documental. En caso de no haber encontrado error en la documentaci&oacute;n y de haber seleccionado el mismo tipo de procedimiento que el comit&eacute; se iniciar&aacute; dicho procedimiento, en caso de haber seleccionado un procedimiento distinto al propuesto por la entidad, se iniciar&aacute; una tarea en la que el supervisor deber&aacute; validar el cambio de procedimiento que haya propuesto.</p></div>',null,null,null,null,'0','DD'),	
		T_TIPO_TFI('H068_registrarProcedimiento','1','date','fecha','Fecha recepción documentación',null,null,'procedimientoManager.getProcedimiento(idProcedimiento).getSaldoRecuperacion()',null,'0','DD'),
		T_TIPO_TFI('H068_registrarProcedimiento','2','combo','comboDocCompleta','Documentación completa y correcta','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('H068_registrarProcedimiento','3','date','fechaEnvio','Fecha envío documentación para subsanación',null,null,'procedimientoManager.getProcedimiento(idProcedimiento).getSaldoRecuperacion()',null,'0','DD'),
		T_TIPO_TFI('H068_registrarProcedimiento','4','combo','tipoPropuestoEntidad','Procedimiento propuesto por la entidad',null,null,'valoresBPMPadre[''H067_seleccionarProcedimiento''] != null ? valoresBPMPadre[''H067_seleccionarProcedimiento''][''comboProcedimiento''] : '''' ','TipoProcedimiento','0','DD'),
		T_TIPO_TFI('H068_registrarProcedimiento','5','combo','tipoProcedimiento','Procedimiento a iniciar','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'TipoProcedimiento','0','DD'),
		T_TIPO_TFI('H068_registrarProcedimiento','6','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H068_validarNoAceptacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla debe validar la no aceptaci&oacute;n del asunto por parte del letrado asignado, a continuaci&oacute;n se le muestra los datos introducidos por el letrado.</p><p style="margin-bottom: 10px">Para dar por terminada esta tarea primero deber&aacute; reasignar el asunto a un nuevo letrado a trav&eacute;s del bot&oacute;n "Cambiar gestor/supervisor" en la ficha del Asunto.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">Una vez termine esta tarea se lanzar&aacute; autom&aacute;ticamente un nuevo tr&aacute;mite de aceptaci&oacute;n y decisi&oacute;n al letrado que haya reasignado el Asunto.</p></div>',null,null,null,null,'0','DD'),	
		T_TIPO_TFI('H068_validarNoAceptacion','1','currency','principal','Principal',null,null,'procedimientoManager.getProcedimiento(idProcedimiento).getSaldoRecuperacion()',null,'0','DD'),
		T_TIPO_TFI('H068_validarNoAceptacion','2','combo','comboConflicto','Conflicto de intereses',null,null,'valores[''H068_registrarAceptacion''][''comboConflicto'']','DDSiNo','0','DD'),
		T_TIPO_TFI('H068_validarNoAceptacion','3','combo','comboAceptacion','Aceptación del asunto',null,null,'valores[''H068_registrarAceptacion''][''comboAceptacion'']','DDSiNo','0','DD'),
		T_TIPO_TFI('H068_validarNoAceptacion','4','textarea','observacionesLetrado','Observaciones letrado',null,null,'valores[''H068_registrarAceptacion''][''observaciones'']',null,'0','DD'),
		T_TIPO_TFI('H068_validarNoAceptacion','5','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H068_validarCambioProcedimiento','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; validar el cambio del tipo de actuaci&oacute;n propuesto por el letrado respecto a la decisi&oacute;n de la entidad.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">En caso de validar el cambio de actuaci&oacute;n se iniciar&aacute; la actuaci&oacute;n seleccionada, en caso contrario se lanzar&aacute; de nuevo la tarea "Registrar decisi&oacute;n" al letrado.</p></div>',null,null,null,null,'0','DD'),	
		T_TIPO_TFI('H068_validarCambioProcedimiento','1','combo','tipoProcedimiento','Tipo procedimiento propuesto por el letrado',null,null,'valores[''H068_registrarProcedimiento''] == null ? '''' : (valores[''H068_registrarProcedimiento''][''tipoProcedimiento''])',null,'0','DD'),
		T_TIPO_TFI('H068_validarCambioProcedimiento','2','combo','tipoPropuestoEntidad','Tipo procedimiento propuesto por la entidad',null,null,'valores[''H068_registrarProcedimiento''] == null ? '''' : (valores[''H068_registrarProcedimiento''][''tipoPropuestoEntidad''])',null,'0','DD'),
		T_TIPO_TFI('H068_validarCambioProcedimiento','3','combo','comboValidacion','Solicitud aceptada','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('H068_validarCambioProcedimiento','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H068_SubsanarErrDocumentacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que el letrado ha indicado que existe un problema en la documentaci&oacute;n del expediente, antes de dar por finalizada esta tarea deber&aacute; resolver el problema informado.</p><p style="margin-bottom: 10px">Una vez enviada la documentaci&oacute;n ya completa al letrado, deber&aacute; informar la fecha de env&iacute;o de dicha documentaci&oacute;n.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">Una vez complete esta tarea se lanzar&aacute; la tarea ¿Registrar toma de decisi&oacute;n¿ al letrado asignado al expediente.</p></div>',null,null,null,null,'0','DD'),	
		T_TIPO_TFI('H068_SubsanarErrDocumentacion','1','textarea','observacionesLetrado','Observaciones letrado',null,null,'valores[''H068_registrarProcedimiento''][''observaciones'']',null,'0','DD'),
		T_TIPO_TFI('H068_SubsanarErrDocumentacion','2','date','fechaEnvio','Fecha envío','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H068_SubsanarErrDocumentacion','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD')		
	); 
    V_TMP_TIPO_TFI T_TIPO_TFI;
    
    V_TAREA VARCHAR(50 CHAR);
    
BEGIN	
	
	
	 /*
    * LOOP ARRAY BLOCK-CODE: DD_TPO_TIPO_PROCEDIMIENTO
    *---------------------------------------------------------------------
    */
	VAR_TABLENAME := 'DD_TPO_TIPO_PROCEDIMIENTO';
    DBMS_OUTPUT.PUT('    [INSERT] '||V_ESQUEMA||'.' || VAR_TABLENAME || '......');
    FOR I IN V_TIPO_TPO.FIRST .. V_TIPO_TPO.LAST
      LOOP
        V_TMP_TIPO_TPO := V_TIPO_TPO(I);
        
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || ' (' ||
                    'DD_TPO_ID,DD_TPO_CODIGO,DD_TPO_DESCRIPCION,DD_TPO_DESCRIPCION_LARGA,' ||
                    'DD_TPO_HTML,DD_TPO_XML_JBPM,VERSION,USUARIOCREAR,' ||
                    'FECHACREAR,BORRADO,DD_TAC_ID,DD_TPO_SALDO_MIN,'||
                    'DD_TPO_SALDO_MAX,FLAG_PRORROGA,DTYPE,FLAG_DERIVABLE,FLAG_UNICO_BIEN) ' ||
                    'SELECT ' ||
                    'S_DD_TPO_TIPO_PROCEDIMIENTO.NEXTVAL, ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(1)),'''','''''') || ''',''' 
                         || REPLACE(TRIM(V_TMP_TIPO_TPO(2)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(3)),'''','''''') || ''',''' 
                         || REPLACE(TRIM(V_TMP_TIPO_TPO(4)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(5)),'''','''''') || ''',''' 
                         || REPLACE(TRIM(V_TMP_TIPO_TPO(6)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(7)),'''','''''') || ''',
                         sysdate,' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(8)),'''','''''') || ''',' ||
                         '(SELECT DD_TAC_ID FROM '|| V_ESQUEMA ||'.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO=''' || TRIM(V_TMP_TIPO_TPO(9)) || '''),' ||
                    '''' || TRIM(V_TMP_TIPO_TPO(10)) || ''',''' 
                         || TRIM(V_TMP_TIPO_TPO(11)) || ''',''' 
                         || TRIM(V_TMP_TIPO_TPO(12)) || ''',' ||
                    '''' || TRIM(V_TMP_TIPO_TPO(13)) || ''',''' 
                         || TRIM(V_TMP_TIPO_TPO(14)) || ''',''' 
                         || TRIM(V_TMP_TIPO_TPO(15)) 
                    || ''' FROM DUAL'; 

            --VAR_CURR_ROWARRAY := I;
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            --DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TPO(1) ||''','''||TRIM(V_TMP_TIPO_TPO(2))||'''');
            EXECUTE IMMEDIATE V_MSQL;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('DD_TPO OK]');


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

    -- LOOP Insertando valores en TFI_TAREAS_FORM_ITEMS
    VAR_TABLENAME := 'TFI_TAREAS_FORM_ITEMS';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar Campos de tareas');
    FOR I IN V_TIPO_TFI.FIRST .. V_TIPO_TFI.LAST
      LOOP
        V_TMP_TIPO_TFI := V_TIPO_TFI(I);
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
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Campos');
    
     /*
     * Desactivamos trámites antiguos si existen
     */
    VAR_TABLENAME := 'DD_TPO_TIPO_PROCEDIMIENTO';
    V_CODIGO_TPO := 'DD_TPO_CODIGO';
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||VAR_TABLENAME||' WHERE '||V_CODIGO_TPO||' = '''||CODIGO_PROCEDIMIENTO_ANTIGUO_1||''' AND BORRADO=0 ';
        
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN
	    V_SQL := 'UPDATE '||V_ESQUEMA||'.'||VAR_TABLENAME||' SET BORRADO=1 WHERE '||V_CODIGO_TPO||' = '''||CODIGO_PROCEDIMIENTO_ANTIGUO_1||''' AND BORRADO=0 ';
        DBMS_OUTPUT.PUT_LINE('Trámite antiguo desactivado.');
        EXECUTE IMMEDIATE V_SQL; 
	END IF;

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