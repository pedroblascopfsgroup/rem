--/*
--##########################################
--## AUTOR=NACHO ARCOS
--## FECHA_CREACION=2015728
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-382
--## PRODUCTO=NO
--##
--## Finalidad: Modificación trámite subasta
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_COD_PROCEDIMIENTO VARCHAR (20 CHAR) := 'H002';
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
      T_TIPO_TPO(V_COD_PROCEDIMIENTO,'T. de subasta','Trámite de subasta','','hcj_tramiteSubasta','0','dd','0','AP',null,null,'1','MEJTipoProcedimiento','1','0')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
      T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ 'H002',
        /*TAP_CODIGO...................:*/ 'H002_RevisarDocumentacion',
        /*TAP_VIEW.....................:*/ null,
        /*TAP_SCRIPT_VALIDACION........:*/ null,
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ null,
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Revisar documentación',
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
        /*DD_STA_ID(FK)................:*/ 'TGCONGE',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ 'SUCONGE',
        /*TAP_BUCLE_BPM................:*/ null        
        ),     
      T_TIPO_TAP('H002','H002_AdjuntarNotasSimples',null,null,null,null,null,'0','Adjuntar notas simples','0','DD','0',null,'tareaExterna.cancelarTarea',null,'0','EXTTareaProcedimiento','3',null,'TGCONGE',null,'SUCONGE',null),
      T_TIPO_TAP('H002','H002_AdjuntarTasaciones',null,null,null,'valores[''H002_AdjuntarTasaciones''][''comboInforme''] == DDSiNo.SI ?  ''SI'' : ''NO''',null,'0','Adjuntar tasaciones','0','DD','0',null,null,null,'0','EXTTareaProcedimiento','3',null,'TGCONGE',null,'SUCONGE',null),      
      T_TIPO_TAP('H002','H002_SolicitarInformeFiscal',null,null,null,null,null,'0','Solicitar informe fiscal','0','DD','0',null,null,null,'0','EXTTareaProcedimiento','3',null,'TGCONGE',null,'SUCONGE',null),
      T_TIPO_TAP('H002','H002_AdjuntarInformeFiscal',null,'comprobarExisteDocumentoIFISCAL() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el Informe Fiscal.</div>''',null,null,null,'0','Adjuntar informe fiscal','0','DD','0',null,null,null,'0','EXTTareaProcedimiento','3',null,'803',null,'SDEU',null),      
      T_TIPO_TAP('H002','H002_ValidarInformeDeSubasta',null,'comprobarExisteDocumentoINSUFI() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el Informe Subasta Firmado.</div>''',null,'valores[''H002_ValidarInformeDeSubasta''][''comboInforme''] == DDSiNo.NO ? ''Rechazado'' : (valores[''H002_ValidarInformeDeSubasta''][''comboAtribuciones''] == DDSiNo.NO ? ''AceptadoSinAtribuciones'' :''AceptadoConAtribuciones'')',null,'0','Validar informe de subasta','0','DD','0',null,'tareaExterna.cancelarTarea',null,'0','EXTTareaProcedimiento','3',null,'TSUCONGE',null,'SUCONT',null),
      T_TIPO_TAP('H002','H002_ObtenerValidacionComite',null,null,null,'valores[''H002_ObtenerValidacionComite''][''comboResultado''] == ''REC'' ? ''Rechazada'' : ''Aceptada''',null,'0','Obtener validación comité','0','DD','0',null,'tareaExterna.cancelarTarea',null,'0','EXTTareaProcedimiento','3',null,'CJ-TGESEXT',null,'CJ-SUEXT',null),     
      T_TIPO_TAP('H002','H002_DictarInstruccionesSubasta',null,'comprobarInformacionCompletaInstrucciones() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">La informaci&oacute;n de las instrucciones de los lotes no est&aacute; completa.</div>''',null,'valores[''H002_DictarInstruccionesSubasta''][''comboResultado''] == ''SUS'' ? ''Suspender'' : ''NoSuspender''',null,'0','Dictar instrucciones','0','DD','0',null,'tareaExterna.cancelarTarea',null,'0','EXTTareaProcedimiento','3',null,'TGCONGE',null,'SUCONGE',null),     
      T_TIPO_TAP('H002','H002_SolicitarSuspenderSubasta',null,null,null,null,null,'0','Solicitar suspender subasta','0','DD','0',null,'tareaExterna.cancelarTarea',null,'0','EXTTareaProcedimiento','3',null,'CJ-814',null,'GCONGE',null),
      T_TIPO_TAP('H002','H002_RegistrarResSuspSubasta',null,null,null,null,null,'0','Registrar resolución suspensión subasta','0','DD','0',null,'tareaExterna.cancelarTarea',null,'0','EXTTareaProcedimiento','3',null,'CJ-814',null,'GCONGE',null),
      T_TIPO_TAP('H002','H002_DictarInstruccionesDeneSuspension',null,'comprobarInformacionCompletaInstrucciones() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">La informaci&oacute;n de las instrucciones de los lotes no est&aacute; completa.</div>''',null,null,null,'0','Dictar instrucciones por denegación de suspensión','0','DD','0',null,'tareaExterna.cancelarTarea',null,'0','EXTTareaProcedimiento','3',null,'TGCONGE',null,'SUCONGE',null),
      T_TIPO_TAP('H002','H002_BPMTramiteSolSolvenciaPatrimonial',null,null,null,null,'HC104','0','Ejecución del trámite de Solicitud de Solvencia Patrimonial','0','DD','0',null,'tareaExterna.cancelarTarea',null,'0','EXTTareaProcedimiento','3',null,'CJ-814',null,'GCONGE',null),
      T_TIPO_TAP('H002','H002_RecepcionMandamientoPago',null,null,null,'esTodosViviendaHabitualAdjTerceros() ? ''ViviendaHabitual'' : (valores[''H002_RecepcionMandamientoPago''][''comboDeuda''] == DDSiNo.SI ? ''DeudaCubierta'' : ''DeudaNoCubierta'' )',null,'0','Recepción mandamiento de pago','0','DD','0',null,'tareaExterna.cancelarTarea',null,'0','EXTTareaProcedimiento','3',null,'TGCONGE',null,'SUCONGE',null),
      T_TIPO_TAP('H002','H002_ConfirmarContabilidad',null,null,null,null,null,'0','Confirmar contabilidad','0','DD','0',null,'tareaExterna.cancelarTarea',null,'0','EXTTareaProcedimiento','3',null,'TGCON',null,'CJ-SCON',null)
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
      T_TIPO_PLAZAS(null,null,'H002_RevisarDocumentacion','2*24*60*60*1000L','0','0','DD'),   
      T_TIPO_PLAZAS(null,null,'H002_AdjuntarNotasSimples','damePlazo(valores[''H002_SenyalamientoSubasta''][''fechaSenyalamiento'']) - 20*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'H002_AdjuntarTasaciones','damePlazo(valores[''H002_SenyalamientoSubasta''][''fechaSenyalamiento'']) - 30*24*60*60*1000L','0','0','DD'),      
      T_TIPO_PLAZAS(null,null,'H002_SolicitarInformeFiscal','damePlazo(valores[''H002_SenyalamientoSubasta''][''fechaSenyalamiento'']) - 25*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'H002_AdjuntarInformeFiscal','damePlazo(valores[''H002_SenyalamientoSubasta''][''fechaSenyalamiento'']) - 20*24*60*60*1000L','0','0','DD'),     
      T_TIPO_PLAZAS(null,null,'H002_ValidarInformeDeSubasta','damePlazo(valores[''H002_SenyalamientoSubasta''][''fechaSenyalamiento'']) - 10*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'H002_ObtenerValidacionComite','7*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'H002_DictarInstruccionesSubasta','3*24*60*60*1000L','0','0','DD'),      
      T_TIPO_PLAZAS(null,null,'H002_SolicitarSuspenderSubasta','1*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'H002_RegistrarResSuspSubasta','damePlazo(valores[''H002_SenyalamientoSubasta''][''fechaSenyalamiento'']) - 1*24*60*60*1000L','0','0','DD'),     
      T_TIPO_PLAZAS(null,null,'H002_DictarInstruccionesDeneSuspension','1*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'H002_BPMTramiteSolSolvenciaPatrimonial','300*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'H002_RecepcionMandamientoPago','damePlazo(valores[''H002_ConfirmarRecepcionMandamientoDePago''][''fechaEnvio'']) + 10*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'H002_ConfirmarContabilidad','5*24*60*60*1000L','0','0','DD')   
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(20000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
        T_TIPO_TFI('H002_RevisarDocumentacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea deber&aacute; revisar:</p><p style="margin-bottom: 10px; margin-left: 40px;">-Si todos los bienes incluidos en la Subasta han de ser efectivamente subastados o, por el contrario, excluya manualmente los que no deban ser subastados</p><p style="margin-bottom: 10px; margin-left: 40px;">-La antigüedad de la certificaci&oacute;n de cargas de cada uno de los bienes en la ficha del bien. En caso de que tengan una antigüedad superior a 3 meses, solicite las notas simples actualizadas.</p><p style="margin-bottom: 10px; margin-left: 40px;">-La antigüedad de la de la tasaci&oacute;n de cada uno de los bienes. En caso de que sea superior a 6 meses solicite una nueva tasaci&oacute;n a trav&eacute;s de la ficha del bien.</p><p style="margin-bottom: 10px; margin-left: 40px;">-Si es necesario el informe fiscal en cuyo caso deber&aacute; solicitarlo a la entidad una vez tenga las tasaciones actualizadas.</p><p style="margin-bottom: 10px">Una vez determine qu&eacute; documentaci&oacute;n necesita deber&aacute; ponerse en contacto con el departamento correspondiente para solicitarla y dejar constancia en Recovery.</p><p style="margin-bottom: 10px">En el campo Fecha deber&aacute; se&ntilde;alar la fecha en la que hace esta revisi&oacute;n.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea "Preparar informe de subasta" y:</p><p style="margin-bottom: 10px; margin-left: 40px;">-Si ha indicado que solicita tasaci&oacute;n, se lanzar&aacute; la tarea "Adjutar tasaciones".</p><p style="margin-bottom: 10px; margin-left: 40px;">-Si ha indicado que solicita tasaci&oacute;n, se lanzar&aacute; la tarea "Adjuntar nota simple".</p><p style="margin-bottom: 10px; margin-left: 40px;">-Si no ha solicitado tasaciones y ha indicado que va a solictar el informe fiscal, se lanzar&aacute; la tarea "Adjuntar informe fiscal".</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H002_RevisarDocumentacion','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H002_RevisarDocumentacion','2','combo','comboNota','Solicita nota simple','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('H002_RevisarDocumentacion','3','combo','comboTasacion','Solicita tasación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('H002_RevisarDocumentacion','4','combo','comboInforme','Solicita informe fiscal','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('H002_RevisarDocumentacion','5','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        
        T_TIPO_TFI('H002_AdjuntarNotasSimples','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; actualizar la informaci&oacute;n en la ficha del "Bien"  de cada uno de los bienes de la subasta.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H002_AdjuntarNotasSimples','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H002_AdjuntarNotasSimples','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        
        T_TIPO_TFI('H002_AdjuntarTasaciones','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; actualizar la informaci&oacute;n en la ficha del "Bien"  de cada uno de los bienes de la subasta.</p><p style="margin-bottom: 10px">En caso de que requiera solicitar el informe fiscal, deber&aacute; dejar constancia de ello en la herramienta y ponerse en contacto con el &aacute;rea Fiscal para que generen el informe.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellena esta pantalla, la siguiente tarea ser&aacute;, si ha marcado que solicita el informe fiscal, "Solicitar informe fiscal".</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H002_AdjuntarTasaciones','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H002_AdjuntarTasaciones','2','combo','comboInforme','Solicita informe fiscal','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','valores[''H002_RevisarDocumentacion''][''comboInforme'']','DDSiNo','0','DD'),
        T_TIPO_TFI('H002_AdjuntarTasaciones','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        
        T_TIPO_TFI('H002_SolicitarInformeFiscal','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; solicitar el informe fiscal a la entidad y dejar constancia en la herramieenta de la fecha en la que ha realizado dicha solicitud.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla, la siguiente tarea ser&aacute; "adjuntar informe fiscal".</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H002_SolicitarInformeFiscal','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H002_SolicitarInformeFiscal','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        
        T_TIPO_TFI('H002_AdjuntarInformeFiscal','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; actualizar la informaci&oacute;n en la ficha del "Bien"  de cada uno de los bienes de la subasta y adjuntar el informe fiscal al procedimiento.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H002_AdjuntarInformeFiscal','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H002_AdjuntarInformeFiscal','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        
        T_TIPO_TFI('H002_ValidarInformeDeSubasta','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea deber&aacute;  revisar y dictaminar sobre la propuesta de instrucciones. En caso de que tenga atribuciones y requiera informar a la entidad del celebramiento de la subasta deber&aacute; notific&aacute;rselo a trav&eacute;s de la herramienta mediante el bot&oacute;n "Anotaci&oacute;n".</p><p style="margin-bottom: 10px">En caso de que no tenga atribuciones para validar el informe de subasta, deber&aacute; se&ntilde;alar el motivo de autorizaci&oacute;n de entre los posibles motivos listados.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">La siguiente tarea ser&aacute;:</p><p style="margin-bottom: 10px; margin-left: 40px;">-En caso de aceptar el informe y tenga atribuciones, se lanzar&aacute; la tarea de  “Dictar instrucciones”.</p><p style="margin-bottom: 10px; margin-left: 40px;">-En caso de aceptar el informe y no tenga atribuciones, se lanzar&aacute; la tarea de  “Obtener validaci&oacute;n comit&eacute;”.</p><p style="margin-bottom: 10px; margin-left: 40px;">-Se lanzar&aacute; la tarea “Preparar informe de subasta" en caso de no aceptar el informe.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H002_ValidarInformeDeSubasta','1','combo','comboAtribuciones','Con Atribuciones','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('H002_ValidarInformeDeSubasta','2','combo','comboInforme','Acepta informe','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('H002_ValidarInformeDeSubasta','3','combo','comboAutorizacion','Motivo autorización','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDMotivoAutorizacion','0','DD'),
        T_TIPO_TFI('H002_ValidarInformeDeSubasta','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        
        T_TIPO_TFI('H002_ObtenerValidacionComite','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&aacute; indicar la fecha en la que el comit&eacute; decide sobre el informe de subasta.</p><p style="margin-bottom: 10px">En caso de que la recomendaci&óacute;n del informe sea suspender subasta, o bien la entidad decida suspenderla, deber&aacute; indicar ene l campo "Motivo de suspensi&óacute;n", el motivo por el que se suspende la subasta.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">La siguiente tarea ser&aacute;:</p><p style="margin-bottom: 10px; margin-left: 40px;">-En el caso que sea la respuesta del comit&eacute; sea " Cntinuar subasta" o "Suspender subasta", se lanzar&aacute; la siguiente tarea al gestor de contencioso gesti&óacute;n de "Dictar instrucciones".</p><p style="margin-bottom: 10px; margin-left: 40px;">-En el caso que sea la respuesta del comit&eacute; sea "Rechazar" el informe, se volver&aacute; a la tarea de "Preparar informe de Subasta".</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H002_ObtenerValidacionComite','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H002_ObtenerValidacionComite','2','combo','comboResultado','Resultado del Comité','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDResultadoComite','0','DD'),
        T_TIPO_TFI('H002_ObtenerValidacionComite','3','combo','comboMotivo','Motivo de suspensión',null,null,null,'DDMotivoSuspension','0','DD'),
        T_TIPO_TFI('H002_ObtenerValidacionComite','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        
        T_TIPO_TFI('H002_DictarInstruccionesSubasta','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez aprobada la propuesta por su supervisor, en esta tarea el gestor de contencioso gesti&oacute;n deber&aacute; dictar las instrucciones de la subasta al letrado.</p><p style="margin-bottom: 10px">El campo Fecha deber&aacute; anotar la fecha en que se realiza esta tarea.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">La siguiente tarea ser&aacute; "Lectura y confirmaci&oacute;n de instrucciones" en caso de continuar con la subasta o "Suspender subasta" en caso de suspensi&oacute;n de la subasta.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H002_DictarInstruccionesSubasta','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H002_DictarInstruccionesSubasta','2','textarea','instrucciones','Instrucciones subasta',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H002_DictarInstruccionesSubasta','3','combo','comboSuspender','Solicitar suspensión','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','valores[''H002_ObtenerValidacionComite''][''comboResultado''] == ''SUS'' ? DDSiNo.SI : DDSiNo.NO','DDSiNo','0','DD'),
        T_TIPO_TFI('H002_DictarInstruccionesSubasta','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        
        T_TIPO_TFI('H002_SolicitarSuspenderSubasta','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que la entidad ha decidido suspender la subasta, para dar por completada esta tarea deber&aacute; solicitar en el juzgado la suspensi&oacute;n de la subasta e informar en el campo "Fecha solicitud", la fecha en que se haya presentado la solicitud de suspensi&oacute;n.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez complete esta pantalla, se lanzar&aacute; la tarea "Registrar suspensi&oacute;n subasta".</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H002_SolicitarSuspenderSubasta','1','date','fecha','Fecha solicitud','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H002_SolicitarSuspenderSubasta','3','combo','comboMotivo','Motivo de suspensión','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','valores[''H002_ObtenerValidacionComite''][''comboMotivo'']','DDMotivoSuspension','0','DD'),
        T_TIPO_TFI('H002_SolicitarSuspenderSubasta','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        
        T_TIPO_TFI('H002_RegistrarResSuspSubasta','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla deber&aacute; informa de la fecha en la que el juzgado notifica la resoluci&oacute;n a la solicitud de suspensi&oacute;n de la subasta as&iacute; como indicar si la subasta se ha suspendido o no.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez finaliza esta tarea,  se le abrir&aacute; tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H002_RegistrarResSuspSubasta','1','date','fecha','Fecha resolución','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H002_RegistrarResSuspSubasta','2','combo','comboSuspension','Subasta suspendida','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('H002_RegistrarResSuspSubasta','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        
        T_TIPO_TFI('H002_DictarInstruccionesDeneSuspension','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Puesto que el letrado ha indicado en la tarea anterior que el juzgado ha denegado la suspensi&oacute;n de la subasta, en esta tarea el gestor deber&aacute; dictar las instrucciones de subasta.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H002_DictarInstruccionesDeneSuspension','1','date','fecha','Fecha resolución','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H002_DictarInstruccionesDeneSuspension','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        
        T_TIPO_TFI('H002_BPMTramiteSolSolvenciaPatrimonial','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Ejecuci&oacute;n del tr&aacute;mite de solicitud de solvencia patrimonial</p></div>',null,null,null,null,'0','DD'),
        
        T_TIPO_TFI('H002_ConfirmarRecepcionMandamientoDePago','2','date','fechaEnvio','Fecha envío','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        
        T_TIPO_TFI('H002_RecepcionMandamientoPago','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea deber&aacute; revisar que puede realizarse la contabilizaci&oacute;n de los importes recibidos e indicar la fecha en la que recepciona el mandamiento de pago.</p><p style="margin-bottom: 10px">En caso de que la deuda no quede totalmente cubierta y alguno de los bienes no sea vivienda habitual, se continuar&aacute; con la averiguaci&oacute;n patrimonial. En el supuesto de que el bien o los bienes estuvieran marcados como vivienda habitual, se deber&aacute; considerar&aacute; fallido procesal y no se continuar&aacute; con la solvencia patrimonial.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez finalice esta tarea se lanzar&aacute; la tarea "Confirmar contabilidad" y, en caso de continuar con la averiguaci&oacute;n patrimonial, se lanzar&aacute; el "Tr&aacute;mite de solicitud de solvencia patrimonial".</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H002_RecepcionMandamientoPago','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H002_RecepcionMandamientoPago','2','currency','importe','Importe','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','valores[''H002_ConfirmarRecepcionMandamientoDePago''][''importe'']',null,'0','DD'),
        T_TIPO_TFI('H002_RecepcionMandamientoPago','3','combo','comboDeuda','Cubierta totalmente la deuda','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('H002_RecepcionMandamientoPago','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        
        T_TIPO_TFI('H002_ConfirmarContabilidad','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta tarea deber&aacute; informar la fecha en la que queda contabilizado en el sistema el pago realizado por el tercero.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H002_ConfirmarContabilidad','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H002_ConfirmarContabilidad','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD')      
    ); 
    V_TMP_TIPO_TFI T_TIPO_TFI;
    
    V_TAREA VARCHAR(100 CHAR);
    
BEGIN	
	
	
	/* ------------------- --------------------------------- */
	/* --------------  ACTUALIZACIONES TAREAS--------------- */
	/* ------------------- --------------------------------- */
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''CJ-814'')' ||
	          ' ,DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GCONPR'')' ||
			  ' WHERE TAP_CODIGO = ''H002_SolicitudSubasta''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_SolicitudSubasta actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''CJ-814'')' ||
	          ' ,DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GCONGE'')' ||
	          ' ,TAP_SCRIPT_VALIDACION_JBPM = ''comprobarCostasLetradoValidas() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;"><p>&iexcl;Atenci&oacute;n! Las costas del letrado no pueden superar el 5% del principal.</p></div>'''' '' ' ||
	          ' ,TAP_VIEW = null' ||
			  ' WHERE TAP_CODIGO = ''H002_SenyalamientoSubasta''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_SenyalamientoSubasta actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''TGCONGE'')' ||
	          ' ,DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SUCONGE'')' ||
	          ' ,TAP_CODIGO = ''H002_PrepararInformeSubasta'' ' ||
	          ' ,TAP_DESCRIPCION = ''Preparar informe de subasta'' ' ||
	          ' ,TAP_SCRIPT_VALIDACION = ''comprobarInformacionCompletaInstrucciones() ? (comprobarExisteDocumentoINS()? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el informe de subasta</div>'''') : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">La informaci&oacute;n de las instrucciones de los lotes no est&aacute; completa.</div>'''' ''' ||
			  ' WHERE TAP_CODIGO = ''H002_PrepararPropuestaSubasta''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_PrepararInformeSubasta actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''CJ-819'')' ||
	          ' ,DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GCONGE'')' ||
			  ' WHERE TAP_CODIGO = ''H002_SuspenderDecision''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Decisión H002_SuspenderDecision actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''CJ-814'')' ||
	          ' ,DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GCONGE'')' ||
	          ' ,TAP_CODIGO = ''H002_LecturaConfirmacionInstrucciones'' ' ||
	          ' ,TAP_DESCRIPCION = ''Lectura y confirmación de instrucciones'' ' ||
			  ' WHERE TAP_CODIGO = ''H002_LecturaAceptacionInstrucciones''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_LecturaConfirmacionInstrucciones actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''CJ-814'')' ||
	          ' ,DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GCONGE'')' ||
			  ' WHERE TAP_CODIGO = ''H002_CelebracionSubasta''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_CelebracionSubasta actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''CJ-819'')' ||
	          ' ,DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GCONGE'')' ||
			  ' WHERE TAP_CODIGO = ''H002_CelebracionDecision''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_CelebracionDecision actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''CJ-814'')' ||
	          ' ,DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GCONGE'')' ||
	          ' ,TAP_CODIGO = ''H002_BPMTramiteSubasta'' ' ||
			  ' WHERE TAP_CODIGO = ''H002_BPMTramiteSubastaSareb''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_BPMTramiteSubasta actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''CJ-814'')' ||
	          ' ,DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GCONGE'')' ||
	          ' ,TAP_CODIGO = ''H002_BPMTramiteAdjudicacion'' ' ||
			  ' WHERE TAP_CODIGO = ''H002_BPMTramiteAdjudicacionV4''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_BPMTramiteAdjudicacion actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''CJ-814'')' ||
	          ' ,DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GCONGE'')' ||
			  ' WHERE TAP_CODIGO = ''H002_BPMTramiteCesionRemate''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_BPMTramiteCesionRemate actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''CJ-814'')' ||
	          ' ,DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GCONGE'')' ||
			  ' WHERE TAP_CODIGO = ''H002_SolicitarMandamientoPago''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_SolicitarMandamientoPago actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''CJ-814'')' ||
	          ' ,DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GCONGE'')' ||
	          ' ,TAP_DESCRIPCION = ''Confirmar recepción y envio de mandamiento de pago'' ' ||
			  ' WHERE TAP_CODIGO = ''H002_ConfirmarRecepcionMandamientoDePago''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_ConfirmarRecepcionMandamientoDePago actualizada.');
    
    /* ------------------- --------------------------------- */
	/* --------------  ACTUALIZACIONES PLAZOS--------------- */
	/* ------------------- --------------------------------- */
	 V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS' ||
			  ' SET DD_PTP_PLAZO_SCRIPT = ''damePlazo(valores[''''H002_SenyalamientoSubasta''''][''''fechaSenyalamiento''''])-15*24*60*60*1000L'' ' ||
			  ' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_PrepararInformeSubasta'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Plazo de H002_PrepararInformeSubasta actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS' ||
			  ' SET DD_PTP_PLAZO_SCRIPT = ''damePlazo(valores[''''H002_SenyalamientoSubasta''''][''''fechaSenyalamiento''''])-3*24*60*60*1000L'' ' ||
			  ' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_LecturaAceptacionInstrucciones'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Plazo de H002_LecturaAceptacionInstrucciones actualizada.');
    
    /* ------------------- --------------------------------- */
	/* --------------  ACTUALIZACIONES CAMPOS--------------- */
	/* ------------------- --------------------------------- */
     V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&aacute; acceder a la pesta&ntilde;a Subastas del asunto correspondiente y asociar uno o m&aacute;s bienes a la subasta que corresponda. Una vez agregados los bienes a la subasta deber&aacute; indicar a trav&eacute;s de la ficha de cada bien las cargas anteriores y posteriores, si es vivienda habitual o no y la situaci&oacute;n posesoria.</p><p style="margin-bottom: 10px">En el campo Fecha solicitud deber&aacute; informar la fecha en la que haya realizado la solicitud de subasta.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea “Se&ntilde;alamiento de subasta”.</p></div>'' ' ||
			  ' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_SolicitudSubasta'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_SolicitudSubasta actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez solicitada la subasta, en esta pantalla, debe informar las fechas de anuncio y celebraci&oacute;n de la misma as&iacute; como las costas del letrado y procurador.</p><p style="margin-bottom: 10px">Una vez conozca la fecha de celebraci&oacute;n de la subasta deber&aacute;n enviar una anotaci&oacute;n a trav&eacute;s de la herramienta al supervisor de contencioso gesti&oacute;n.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute;n las tareas "Celebraci&oacute;n subasta" y "Revisar documentaci&oacute;n" al gestor de contencioso gesti&oacute;n.</p></div>'' ' ||
			  ' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_SenyalamientoSubasta'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_SenyalamientoSubasta actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_ORDEN = 5' ||
			  ' WHERE TFI_NOMBRE = ''observaciones'' AND TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_SenyalamientoSubasta'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_SenyalamientoSubasta actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deber&aacute; acceder desde la pesta&ntilde;a Subastas del asunto correspondiente a cada uno de los bienes afectos a la subasta e indicar los importes para la puja sin postores  y puja con postores.</p><p style="margin-bottom: 10px">Adem&aacute;s, deber&aacute; adjuntar el informe de subasta, preparar el cuadro de pujas y obtener la tasaci&oacute;n, notas simple e informe fiscal, en caso de que las solicitara en la tarea anterior, as&iacute; como actualizar dicha informaci&oacute;n en la herramienta.</p><p style="margin-bottom: 10px">Una vez hecho esto podr&aacute; generar desde la pesta&ntilde;a Subastas el informe con la propuesta de instrucciones para la subasta en formato Word, de forma que en caso de ser necesario pueda modificarlo.</p><p style="margin-bottom: 10px">En el campo Fecha deber&aacute; informar la fecha en la que haya adjuntado el informe con las instrucciones para la subasta.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea “Validar informe de subasta”.</p></div>'' ' ||
			  ' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_PrepararInformeSubasta'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_PrepararInformeSubasta actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez que ha sido anunciada la subasta, y han sido dictadas las instrucciones por la entidad, antes de dar por completada esta tarea deber&aacute; acceder a la pesta&ntilde;a “Subastas” de la ficha del asunto correspondiente y revisar las instrucciones dadas para cada uno de los bienes a subastar.</p><p style="margin-bottom: 10px">Informando la fecha se confirma haber recibido correctamente las instrucciones del responsable de la entidad. Para el supuesto de que haya alguna duda al respecto, deber&aacute; ponerse en contacto con el responsable de la entidad para que se revisen o modifiquen dichas instrucciones.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>'' ' ||
			  ' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_LecturaAceptacionInstrucciones'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_LecturaAceptacionInstrucciones actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez se celebre la subasta, en esta pantalla debe introducir la siguiente informaci&oacute;n:</p><p style="margin-bottom: 10px; margin-left: 40px;">-En el campo Celebrada deber&aacute; indicar si la subasta ha sido celebrada o no.</p><p style="margin-bottom: 10px; margin-left: 40px;">-En caso de haberse celebrado deber&aacute; indicar a trav&eacute;s de la pesta&ntilde;a Subastas de la ficha del asunto correspondiente, el resultado de la subasta para cada uno de los bienes subastados.</p><p style="margin-bottom: 10px; margin-left: 40px;">-En la ficha del bien se debe recoger el resultado de la adjudicaci&oacute;n y el valor de la adjudicaci&oacute;n.</p><p style="margin-bottom: 10px; margin-left: 40px;">-En el campo Observaciones informar cualquier aspecto ' || 
			  ' relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; adjuntar el acta de subasta al procedimiento a trav&eacute;s de la pesta&ntilde;a "Adjuntos" y anotar la situaci&oacute;n final de cada bien en la ficha del bien.</p><p style="margin-bottom: 10px">La siguiente tarea ser&aacute;:</p><p style="margin-bottom: 10px; margin-left: 40px;">-En caso de haber uno o m&aacute;s bienes adjudicados a un tercero se lanzar&aacute; la tarea “Solicitar mandamiento de pago”.</p><p style="margin-bottom: 10px; margin-left: 40px;">-En caso de haber uno o m&aacute;s bienes con cesi&oacute;n de remate se lanzar&aacute; la tarea "Tr&aacute;mite de Cesi&oacute;n de Remate" por cada uno de ellos.</p><p style="margin-bottom: 10px; margin-left: 40px;">-En caso de haber uno o m&aacute;s bienes adjudicados a la entidad,' ||
			  ' se lanzar&aacute; el "Tr&aacute;mite de Adjudicaci&oacute;n" por cada uno de ellos.</p><p style="margin-bottom: 10px; margin-left: 40px;">-En caso de suspensi&oacute;n de la subasta deber&aacute; indicar dicha circunstancia en el campo “Celebrada”, en el campo “Decisi&oacute;n suspensi&oacute;n” deber&aacute; informar quien ha provocado dicha suspensi&oacute;n y en el campo “Motivo suspensi&oacute;n” deber&aacute; indicar el motivo por el cual se ha suspendido y se le abrir&aacute; tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p><p style="margin-bottom: 10px; margin-left: 40px;">-En caso de que alg&uacute;n bien haya sido adjudicado a la entidad o con cesi&oacute;n de remate, se lanzar&aacute; el "Tr&aacute;mite de solvencia patrimonial" para averiguar la solvencia del deudor.</p></div>'' ' ||
			  ' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_CelebracionSubasta'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_CelebracionSubasta actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Ejecuci&oacute;n del tr&aacute;mite de Subasta</p></div>'' ' ||
			  ' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_BPMTramiteSubasta'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_BPMTramiteSubasta actualizada.');
    
     V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que alguno de los bienes ha sido adjudicado a un tercero, en esta pantalla debemos de informar la fecha de presentaci&oacute;n en el juzgado del escrito solicitando la entrega de las cantidades informadas.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Confirmar recepci&oacute;n mandamiento de pago".</p></div>'' ' ||
			  ' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_SolicitarMandamientoPago'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_SolicitarMandamientoPago actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se ha de informar la fecha y el importe en la que nos han entregado los mandamientos de pago de la cantidad informada por un tercero en concepto de pago del bien o bienes adjudicados, as&iacute; como la fecha de env&iacute;o a HRE para su contabilizaci&oacute;n.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">La siguiente tarea ser&aacute; "Recepci&oacute;n de mandamiento de pago".</p></div>'' ' ||
			  ' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_ConfirmarRecepcionMandamientoDePago'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_ConfirmarRecepcionMandamientoDePago actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''Fecha recepción'' ' ||
			  ' WHERE TFI_NOMBRE = ''fecha'' AND TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_ConfirmarRecepcionMandamientoDePago'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_ConfirmarRecepcionMandamientoDePago actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_ORDEN = 3' ||
			  ' WHERE TFI_NOMBRE = ''importe'' AND TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_ConfirmarRecepcionMandamientoDePago'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_ConfirmarRecepcionMandamientoDePago actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_ORDEN = 4' ||
			  ' WHERE TFI_NOMBRE = ''observaciones'' AND TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_ConfirmarRecepcionMandamientoDePago'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_ConfirmarRecepcionMandamientoDePago actualizada.');
    
    /* ------------------- --------------------------------- */
	/* --------------  BORRADO CAMPOS--------------- */
	/* ------------------- --------------------------------- */
    EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS WHERE TFI_NOMBRE = ''principal'' AND TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_SenyalamientoSubasta'')';
    DBMS_OUTPUT.PUT_LINE('[INFO] Campo principal de Tarea H002_SenyalamientoSubasta eliminado.');
    EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS WHERE TFI_NOMBRE = ''intereses'' AND TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_SenyalamientoSubasta'')';
	DBMS_OUTPUT.PUT_LINE('[INFO] Campo intereses de Tarea H002_SenyalamientoSubasta eliminado.');
    
	 /* ------------------- --------------------------------- */
	/* --------------  BORRADO TAREAS--------------- */
	/* ------------------- --------------------------------- */
	V_TAREA:='H002_ValidarInformeDeSubastaYPrepararCuadroDePujas';
	V_MSQL := 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE  V_MSQL;	
	V_MSQL := 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE  V_MSQL;
	V_MSQL := 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO='''||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE  V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] H002_ValidarInformeDeSubastaYPrepararCuadroDePujas eliminado.');
	
	V_TAREA:='H002_ElevarPropuestaAComite';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] H002_ElevarPropuestaAComite eliminado.');
	
	V_TAREA:='H002_SuspenderSubasta';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] H002_SuspenderSubasta eliminado.');
	
	V_TAREA:='H002_BPMTramiteTributacion';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] H002_BPMTramiteTributacion eliminado.');
	
	V_TAREA:='H002_SolicitarServicioIndices';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] H002_SolicitarServicioIndices eliminado.');
	
	V_TAREA:='H002_ActualizarTasacion';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] H002_ActualizarTasacion eliminado.');
	
	V_TAREA:='H002_EsperaPosibleCesionRemate';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] H002_EsperaPosibleCesionRemate eliminado.');
	
	V_TAREA:='H002_RegistrarRespuestaSareb';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] H002_RegistrarRespuestaSareb eliminado.');
	
	V_TAREA:='H002_SolicitarDueDiligence';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] H002_SolicitarDueDiligence eliminado.');
	
	V_TAREA:='H002_RegistrarResultadoDueDiligence';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] H002_RegistrarResultadoDueDiligence eliminado.');
	
	V_TAREA:='H002_AdjuntarInformeSubasta';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] H002_AdjuntarInformeSubasta eliminado.');
	
	V_TAREA:='H002_SuspenderSubasta';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] H002_SuspenderSubasta eliminado.');
	
	V_TAREA:='H002_ContactarConDeudorYPrepararInformeSubastaFisc';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO='''||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] H002_ContactarConDeudorYPrepararInformeSubastaFisc eliminado.');
	
	V_TAREA:='H002_CumplimentarParteEconomica';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] H002_CumplimentarParteEconomica eliminado.');
	
	V_TAREA:='H002_ValidarPropuesta';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] H002_ValidarPropuesta eliminado.');
	
	V_TAREA:='H002_ElevarPropuestaASareb';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] H002_ElevarPropuestaASareb eliminado.');
	
	V_TAREA:='H002_ElevarPropuestaASarebIndices';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] H002_ElevarPropuestaASarebIndices eliminado.');
	
	V_TAREA:='H002_RegistrarRespuestaSarebIndices';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] H002_RegistrarRespuestaSarebIndices eliminado.');
	 	
	
	
	/* ------------------- -------------------------- */
	/* ------------------- -------------------------- */

	
	-- LOOP Insertando valores en DD_TPO_TIPO_PROCEDIMIENTO
    VAR_TABLENAME := 'DD_TPO_TIPO_PROCEDIMIENTO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar Procedimientos');
    FOR I IN V_TIPO_TPO.FIRST .. V_TIPO_TPO.LAST
      LOOP
        V_TMP_TIPO_TPO := V_TIPO_TPO(I);
        V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.' || VAR_TABLENAME || ' SET ' ||
        		' DD_TPO_CODIGO='''||REPLACE(TRIM(V_TMP_TIPO_TPO(1)),'''','''''') ||''''||
        		' ,DD_TPO_DESCRIPCION='''||REPLACE(TRIM(V_TMP_TIPO_TPO(2)),'''','''''') ||''''||
        		' ,DD_TPO_DESCRIPCION_LARGA='''||REPLACE(TRIM(V_TMP_TIPO_TPO(3)),'''','''''') ||''''||
        		' ,DD_TPO_XML_JBPM='''||REPLACE(TRIM(V_TMP_TIPO_TPO(5)),'''','''''')||''''||
				' WHERE DD_TPO_CODIGO='''||REPLACE(TRIM(V_TMP_TIPO_TPO(1)),'''','''''') ||'''';
        /*V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || ' (' ||
                    'DD_TPO_ID,DD_TPO_CODIGO,DD_TPO_DESCRIPCION,DD_TPO_DESCRIPCION_LARGA,' ||
                    'DD_TPO_HTML,DD_TPO_XML_JBPM,VERSION,USUARIOCREAR,' ||
                    'FECHACREAR,BORRADO,DD_TAC_ID,DD_TPO_SALDO_MIN,'||
                    'DD_TPO_SALDO_MAX,FLAG_PRORROGA,DTYPE,FLAG_DERIVABLE,FLAG_UNICO_BIEN) ' ||
                    'SELECT ' ||
                    'S_DD_TPO_TIPO_PROCEDIMIENTO.NEXTVAL, ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(1)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(2)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(3)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(4)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(5)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(6)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(7)),'''','''''') || ''',sysdate,' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(8)),'''','''''') || ''',' ||
                    '(SELECT DD_TAC_ID FROM '|| V_ESQUEMA ||'.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO=''' || TRIM(V_TMP_TIPO_TPO(9)) || '''),' ||
                    '''' || TRIM(V_TMP_TIPO_TPO(10)) || ''',''' || TRIM(V_TMP_TIPO_TPO(11)) || ''',''' || TRIM(V_TMP_TIPO_TPO(12)) || ''',' ||
                    '''' || TRIM(V_TMP_TIPO_TPO(13)) || ''',''' || TRIM(V_TMP_TIPO_TPO(14)) || ''',''' || TRIM(V_TMP_TIPO_TPO(15)) || ''' FROM DUAL'; 
			*/
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TPO(1) ||''','''||TRIM(V_TMP_TIPO_TPO(2))||'''');
            EXECUTE IMMEDIATE V_MSQL;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Procedimiento');
    
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
                    '(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_M || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(19)) || '''),' || 
                    '(SELECT DD_STA_ID FROM ' || V_ESQUEMA_M || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' || 
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(21)),'''','''''')
										|| ''',' ||'(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_M || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO='''|| REPLACE(TRIM(V_TMP_TIPO_TAP(22)),'''','''''') || ''')'
										|| ',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(23)),'''','''''') || ''' FROM DUAL';
          
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TAP(2)||''','''||TRIM(V_TMP_TIPO_TAP(9))||'''');
            DBMS_OUTPUT.PUT_LINE(V_MSQL);
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
    COMMIT;
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