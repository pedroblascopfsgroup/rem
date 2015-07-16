--/*
--##########################################
--## AUTOR=NACHO ARCOS
--## FECHA_CREACION=2015715
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
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA_CJ#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
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
      
      T_TIPO_TAP('H001','H001_ConfirmarNotificacionReqPago',null,null,'(valores[''H001_ConfirmarNotificacionReqPago''][''comboResultado''] == DDPositivoNegativo.POSITIVO && valores[''H001_ConfirmarNotificacionReqPago''][''fecha''] == null) ? ''Si indica como resultado de notificacion "Positivo", debe informar la "Fecha de Notificaci&oacute;n"'':null','valores[''H001_ConfirmarNotificacionReqPago''][''comboResultado''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''',null,'0','Confirmar notificación del auto despachando ejecución','0','DD','0',null,null,null,'0','EXTTareaProcedimiento','3',null,'814',null,'GULI',null),
      T_TIPO_TAP('H001','H001_ContactarConDeudor',null,null,null,null,null,'0','Contactar con el deudor','0','DD','0',null,null,null,'0','EXTTareaProcedimiento','3',null,'803',null,'SDEU',null),
      T_TIPO_TAP('H001','H001_ConfirmarSiExisteOposicion','plugin/procedimientos/procedimientoHipotecario/confirmarSiExisteOposicion',null,'valores[''H001_ConfirmarSiExisteOposicion''][''comboResultado''] == DDSiNo.SI ? (!comprobarExisteDocumentoEOH() ? ''Es necesario adjuntar el Escrito de oposici&oacute;n.'' : ((valores[''H001_ConfirmarSiExisteOposicion''][''fechaOposicion''] == null || valores[''H001_ConfirmarSiExisteOposicion''][''motivoOposicion''] == null || valores[''H001_ConfirmarSiExisteOposicion''][''fechaComparecencia''] == null) ? ''Si indica que hay oposici&oacute;n, debe registrar tambi&eacute;n "Fecha Oposici&oacute;n", "Motivo Oposici&oacute;n" y "Fecha Comparecencia"'' : null)) : null ','valores[''H001_ConfirmarSiExisteOposicion''][''comboResultado''] == DDSiNo.SI ? ''SI'' : ''NO''',null,'0','Confirmar si existe oposición','0','DD','0',null,'tareaExterna.cancelarTarea',null,'0','EXTTareaProcedimiento','3',null,'814',null,'GULI',null),
      T_TIPO_TAP('H001','H001_RegistrarComparecencia',null,null,null,null,null,'0','Registrar comparecencia','0','DD','0',null,'tareaExterna.cancelarTarea',null,'0','EXTTareaProcedimiento','3',null,'814',null,'GULI',null),
      T_TIPO_TAP('H001','H001_RegistrarResolucion',null,null,null,null,null,'0','Registrar resolución','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'814',null,'GULI',null),
      T_TIPO_TAP('H001','H001_ResolucionFirme',null,null,null,null,null,'0','Resolución firme','0','DD','0',null,'tareaExterna.cancelarTarea',null,'0','EXTTareaProcedimiento','3',null,'814',null,'GULI',null),
      T_TIPO_TAP('H001','H001_BPMTramiteSubasta',null,null,null,null,'H002','0','Ejecución del trámite de Subasta','0','DD','0',null,'tareaExterna.cancelarTarea',null,'0','EXTTareaProcedimiento','3',null,'814',null,null,null),
      T_TIPO_TAP('H001','H001_BPMTramiteNotificacion',null,null,null,null,'P400','0','Ejecución del trámite de notificación','0','DD','0',null,'tareaExterna.cancelarTarea',null,'0','EXTTareaProcedimiento','3',null,'814',null,null,null),
      T_TIPO_TAP('H001','H001_AutoDespachandoDecision',null,null,null,null,null,'0','Tarea toma de decisión','0','DD','0',null,null,null,'0','EXTTareaProcedimiento','3',null,'819',null,'GULI',null),
      T_TIPO_TAP('H001','H001_ResolucionFirmeDecision',null,null,null,null,null,'0','Tarea toma de decisión','0','DD','0',null,null,null,'0','EXTTareaProcedimiento','3',null,'819',null,'GULI',null)
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
      T_TIPO_PLAZAS(null,null,'H002_RevisarDocumentacion','2*24*60*60*1000L','0','0','DD'),   
      T_TIPO_PLAZAS(null,null,'H002_AdjuntarNotasSimples','damePlazo(valores[''H002_SenyalamientoSubasta''][''fechaSenyalamiento'']) - 20*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'H002_AdjuntarTasaciones','damePlazo(valores[''H002_SenyalamientoSubasta''][''fechaSenyalamiento'']) - 30*24*60*60*1000L','0','0','DD'),
      
      T_TIPO_PLAZAS(null,null,'H001_ConfirmarNotificacionReqPago','60*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'H001_ContactarConDeudor','2*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'H001_ConfirmarSiExisteOposicion','valores[''H001_ConfirmarNotificacionReqPago''][''fecha''] != null ? damePlazo(valores[''H001_ConfirmarNotificacionReqPago''][''fecha'']) + 10*24*60*60*1000L : 10*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'H001_RegistrarComparecencia','damePlazo(valores[''H001_ConfirmarSiExisteOposicion''][''fechaComparecencia''])','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'H001_RegistrarResolucion','damePlazo(valores[''H001_RegistrarComparecencia''][''fecha'']) + 15*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'H001_ResolucionFirme','damePlazo(valores[''H001_RegistrarResolucion''][''fecha'']) + 20*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'H001_BPMTramiteSubasta','300*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'H001_BPMTramiteNotificacion','300*24*60*60*1000L','0','0','DD')       
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
        T_TIPO_TFI('H002_RevisarDocumentacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea deber&aacute; revisar:</p><p style="margin-bottom: 10px; margin-left: 40px;">-Si todos los bienes incluidos en la Subasta han de ser efectivamente subastados o, por el contrario, excluya manualmente los que no deban ser subastados</p><p style="margin-bottom: 10px; margin-left: 40px;">-La antigüedad de la certificaci&oacute;n de cargas de cada uno de los bienes en la ficha del bien. En caso de que tengan una antigüedad superior a 3 meses, solicite las notas simples actualizadas.</p><p style="margin-bottom: 10px; margin-left: 40px;">-La antigüedad de la de la tasaci&oacute;n de cada uno de los bienes. En caso de que sea superior a 6 meses solicite una nueva tasaci&oacute;n a trav&eacute;s de la ficha del bien.</p><p style="margin-bottom: 10px; margin-left: 40px;">-Si es necesario el informe fiscal en cuyo caso deber&aacute; solicitarlo a la entidad una vez tenga las tasaciones actualizadas.</p><p style="margin-bottom: 10px">Una vez determine qu&eacute; documentaci&oacute;n necesita deber&aacute; ponerse en contacto con el departamento correspondiente para solicitarla y dejar constancia en Recovery.</p><p style="margin-bottom: 10px">En el campo Fecha deber&aacute; se&ntilde;alar la fecha en la que hace esta revisi&oacute;n.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea "Preparar informe de subasta" y:</p><p style="margin-bottom: 10px; margin-left: 40px;">-Si ha indicado que solicita tasaci&oacute;n, se lanzar&aacute; la tarea "Adjutar tasaciones".</p><p style="margin-bottom: 10px; margin-left: 40px;">-Si ha indicado que solicita tasaci&oacute;n, se lanzar&aacute; la tarea "Adjuntar nota simple".</p><p style="margin-bottom: 10px; margin-left: 40px;">-Si no ha solicitado tasaciones y ha indicado que va a solictar el informe fiscal, se lanzar&aacute; la tarea "Adjuntar informe fiscal".</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H002_RevisarDocumentacion','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H002_RevisarDocumentacion','2','combo','comboNota',' Solicita nota simple','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
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
        
        
        T_TIPO_TFI('H001_DemandaCertificacionCargas','7','currency','interesesOrdinariosEnElCierre','Intereses ordinarios (en el cierre)','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H001_DemandaCertificacionCargas','8','currency','interesesDeDemoraEnElCierre','Intereses de demora (en el cierre)','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H001_DemandaCertificacionCargas','10','currency','respHipCap','Responsabilidad hipotecaria máxima por capital','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H001_DemandaCertificacionCargas','11','currency','respHipIntRem','Responsabilidad hipotecaria máxima por intereses remuneratorios','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H001_DemandaCertificacionCargas','12','currency','respHipDem','Responsabilidad hipotecaria máxima por demora','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H001_DemandaCertificacionCargas','13','currency','respHipCosGas','Responsabilidad hipotecaria máxima por costas y gastos','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H001_DemandaCertificacionCargas','14','currency','creditoSupl','Crédito supletorio','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H001_DemandaCertificacionCargas','15','combo','provisionFondos','Provisión Fondos','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('H001_DemandaCertificacionCargas','16','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),   
        T_TIPO_TFI('H001_AutoDespachandoEjecucion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Ind&iacute;quese la fecha en la que se nos notifica auto por el que se despacha ejecuci&oacute;n, el juzgado en el que ha reca&iacute;do la demanda y el n&uacute;mero de procedimiento.</p><p style="margin-bottom: 10px">Se ha de indicar si la demanda interpuesta ha sido admitida o no, lo que supondr&aacute;, seg&uacute;n su contestaci&oacute;n, que la tarea siguiente sea una u otra de las que se le indica con posterioridad.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute;:<br>- Si ha sido admitida a tr&aacute;mite la demanda "Confirmar notificaci&oacute;n del auto despachando ejecuci&oacute;n" al ejecutado.<br>- Si no ha sido admitida la demanda se le abrir&aacute; tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_AutoDespachandoEjecucion','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H001_AutoDespachandoEjecucion','2','combo','nPlaza','Plaza del juzgado',null,null,'damePlaza()','TipoPlaza','0','DD'),
        T_TIPO_TFI('H001_AutoDespachandoEjecucion','3','combo','numJuzgado','Número de juzgado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','dameNumJuzgado()','TipoJuzgado','0','DD'),
        T_TIPO_TFI('H001_AutoDespachandoEjecucion','4','textproc','numProcedimiento','Número de procedimiento','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','dameNumAuto()',null,'0','DD'),
        T_TIPO_TFI('H001_AutoDespachandoEjecucion','5','combo','comboResultado','Admisión','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('H001_AutoDespachandoEjecucion','6','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_RegistrarCertificadoCargas','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Paralelamente antes de confirmar la notificaci&oacute;n del autodespachando ejecuci&oacute;n, se debe revisar el certificado de cargas informando si existen cargas previas y su cuant&iacute;a.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_RegistrarCertificadoCargas','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H001_RegistrarCertificadoCargas','2','combo','cargasPrevias','Tiene cargas Previas','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('H001_RegistrarCertificadoCargas','3','currency','cuantiaCargasPrevias','Cuantía cargas previas',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_RegistrarCertificadoCargas','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_ConfirmarNotificacionReqPago','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Debe indicar si la notificaci&oacute;n del auto a los deudores (y en su caso el requerimiento de pago) se ha realizado satisfactoriamente.</p><p style="margin-bottom: 10px">Deber&aacute; informar la fecha de notificaci&oacute;n &uacute;nicamente en el supuesto de que &eacute;sta se hubiese efectuado.</p><p style="margin-bottom: 10px">Si no se hubiera requerido en la persona del ejecutado, deber&aacute; notificar dicha circunstancia al supervisor v&iacute;a notificaci&oacute;n interna por si hubiera lugar a iniciar el Tr&aacute;mite de Ocupantes.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute;:<br>- Notificaci&oacute;n positiva: "Confirmar si existe oposici&oacute;n"<br>- Notificaci&oacute;n negativa: en este caso se iniciar&aacute; el tr&aacute;mite de notificaci&oacute;n.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_ConfirmarNotificacionReqPago','1','combo','comboResultado','Resultado notificación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDPositivoNegativo','0','DD'),
        T_TIPO_TFI('H001_ConfirmarNotificacionReqPago','2','date','fecha','Fecha notificación',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_ConfirmarNotificacionReqPago','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_ContactarConDeudor','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, el gestor de deuda deber&aacute; informar de la fecha en la que se ha puesto en contacto con el deudor y el resultado del acuerdo se lo comunicar&aacute; a su supervisor.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_ContactarConDeudor','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H001_ContactarConDeudor','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_ConfirmarSiExisteOposicion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Una vez notificado al demandado el auto de despacho de ejecuci&oacute;n, en esta pantalla ha de indicar si el mismo se ha opuesto o no a la demanda.</p><p style="margin-bottom: 10px">En el supuesto de que exista oposici&oacute;n, deberá informar su fecha de notificaci&oacute;n e indicar la fecha que el juzgado ha designado para la comparecencia.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute;:<br>- Si no hay oposici&oacute;n: se iniciar&aacute; el tr&aacute;mite de subasta, con lo que le aparecer&aacute; la primera tarea de dicho tr&aacute;mite.<br>- Si hay oposici&oacute;n: "Registrar comparecencia".</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_ConfirmarSiExisteOposicion','1','combo','comboResultado','Existe oposición','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('H001_ConfirmarSiExisteOposicion','2','date','fechaOposicion','Fecha oposición',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_ConfirmarSiExisteOposicion','3','textarea','motivoOposicion','Motivo oposición',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_ConfirmarSiExisteOposicion','4','date','fechaComparecencia','Fecha comparecencia',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_ConfirmarSiExisteOposicion','5','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_RegistrarComparecencia','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Dado que en éste proceso ha habido oposici&oacute;n, en esta pantalla debemos de informar la fecha de celebraci&oacute;n de la comparecencia en el supuesto de que la misma se hubiere celebrado. En caso contrario se deber&aacute; solicitar pr&oacute;rroga para &eacute;sta tarea, en la que deber&aacute; indicar la nueva fecha de celebraci&oacute;n de la comparecencia.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute; "Registrar resoluci&oacute;n"</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_RegistrarComparecencia','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H001_RegistrarComparecencia','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_RegistrarResolucion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">En &eacute;sta pantalla se deber&aacute; de informar la fecha de notificaci&oacute;n de la Resoluci&oacute;n que hubiere reca&iacute;do como consecuencia de la comparecencia celebrada.</p><p style="margin-bottom: 10px">Se indicar&aacute; si el resultado de dicha resoluci&oacute;n ha sido favorable para los intereses de la entidad o no.</p><p style="margin-bottom: 10px">Para el supuesto de que la resoluci&oacute;n no fuere favorable para la entidad, deber&aacute; comunicar dicha circunstancia al responsable interno de la misma a trav&eacute;s del bot&oacute;n "Comunicaci&oacute;n". Una vez reciba la aceptaci&oacute;n del supervisor deber&aacute; gestionar el recurso por medio de la pestaña "Recursos".</p><p style="margin-bottom: 10px">Para el supuesto de anuncio del recurso por la parte contraria se deber&aacute; gestionar directamente a trav&eacute;s de la pestaña "Recursos".</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute; "Resoluci&oacute;n firme"</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_RegistrarResolucion','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H001_RegistrarResolucion','2','combo','resultado','Resultado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDFavorable','0','DD'),
        T_TIPO_TFI('H001_RegistrarResolucion','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_ResolucionFirme','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Se deber&aacute; informar la fecha en la que la Resoluci&oacute;n adquiere firmeza.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla se le abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_ResolucionFirme','1','date','fechaFirmeza','Fecha firmeza','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H001_ResolucionFirme','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_BPMTramiteSubasta','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Ejecuci&oacute;n del tr&aacute;mite de subasta</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_BPMTramiteNotificacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Ejecuci&oacute;n del tr&aacute;mite de notificaci&oacute;n</p></div>',null,null,null,null,'0','DD')
    ); 
    V_TMP_TIPO_TFI T_TIPO_TFI;
    
    V_TAREA VARCHAR(30 CHAR);
    
BEGIN	
	
	
	/* ------------------- --------------------------------- */
	/* --------------  ACTUALIZACIONES TAREAS--------------- */
	/* ------------------- --------------------------------- */
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''CJ-814'')' ||
	          ' ,DD_TGE_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GCONPR'')' ||
			  ' WHERE TAP_CODIGO = ''H002_SolicitudSubasta''';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando gestor tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_SolicitudSubasta actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''CJ-814'')' ||
	          ' ,DD_TGE_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GCONGE'')' ||
			  ' WHERE TAP_CODIGO = ''H002_SenyalamientoSubasta''';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando gestor tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_SenyalamientoSubasta actualizada.');
	
    
    /* ------------------- --------------------------------- */
	/* --------------  ACTUALIZACIONES CAMPOS--------------- */
	/* ------------------- --------------------------------- */
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_ORDEN = 5' ||
			  ' WHERE TFI_NOMBRE = ''observaciones'' AND TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_SenyalamientoSubasta'')';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando gestor tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_SenyalamientoSubasta actualizada.');
    
    /* ------------------- --------------------------------- */
	/* --------------  BORRADO CAMPOS--------------- */
	/* ------------------- --------------------------------- */
    EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS WHERE TFI_NOMBRE = ''principal'' AND TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_SenyalamientoSubasta'')';
    DBMS_OUTPUT.PUT_LINE('[INFO] Campo principal de Tarea H002_SenyalamientoSubasta eliminado.');
    EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS WHERE TFI_NOMBRE = ''intereses'' AND TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_SenyalamientoSubasta'')';
	DBMS_OUTPUT.PUT_LINE('[INFO] Campo intereses de Tarea H002_SenyalamientoSubasta eliminado.');
    
	
	--V_TAREA:='H001_DemandaCertificacionCargas';
	--EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	--EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	--EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate(),USUARIOBORRAR=''GONZALO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	
	 	
	
	
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
                    '(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(19)) || '''),' || 
                    '(SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' || 
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(21)),'''','''''')
										|| ''',' ||'(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO='''|| REPLACE(TRIM(V_TMP_TIPO_TAP(22)),'''','''''') || ''')'
										|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(23)),'''','''''') || ''' FROM DUAL';
          
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
