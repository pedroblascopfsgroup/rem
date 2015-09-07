--/*
--##########################################
--## AUTOR=GONZALO ESTELLES
--## FECHA_CREACION=2015715
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-363
--## PRODUCTO=NO
--##
--## Finalidad: Modificación trámite hipotecario
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

    V_COD_PROCEDIMIENTO VARCHAR (20 CHAR) := 'H001';
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
      T_TIPO_TPO(V_COD_PROCEDIMIENTO,
        'P. hipotecario - HAYA',
        'Procedimiento hipotecario',
        '<div align="justify" style="font-size:8pt;font-family:Arial;margin-bottom:30px;margin-top:1em;"><ul style="list-style-type:square;margin-left:35px;"><li>Original de la escritura de pr&eacute;stamo con garantía hipotecaria.</li><li>Acta de requerimiento efectuada al demandado por el Notario.</li><li>Acta mercantil de Liquidaci&oacute;n de saldo.</li><li>Certificado expedido por la Entidad acreedora intervenido por Notario.</li><li>Certificado de la variaci&oacute;n del tipo de inter&eacute;s del Pr&eacute;stamo (cuando sea a tipo variable)</li><li>Extracto de certificaci&oacute;n de deuda de Pr&eacute;stamo intervenido por Notario.</li></ul></div>',
        'hcj_procedimientoHipotecario',
        '0','dd','0','EJ',null,null,'1',
        'MEJTipoProcedimiento','1','0')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(2000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
      T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
        /*TAP_CODIGO...................:*/ 'H001_DemandaCertificacionCargas',
        /*TAP_VIEW.....................:*/ 'plugin/procedimientos/genericFormOverSize',
        /*TAP_SCRIPT_VALIDACION........:*/ 'comprobarExisteDocumentoEDH() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el Escrito de demanda completo + copia sellada de la demanda.</div>''',
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ 'valores[''H001_DemandaCertificacionCargas''][''provisionFondos'']==DDSiNo.SI ? ''SI'' : ''NO''',
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Interposición demanda + Certificación de cargas',
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
        /*DD_TSUP_ID(FK)...............:*/ 'TGCONPR',
        /*TAP_BUCLE_BPM................:*/ null        
        ), 
      T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
        /*TAP_CODIGO...................:*/ 'H001_BPMProvisionFondos',
        /*TAP_VIEW.....................:*/ null,
        /*TAP_SCRIPT_VALIDACION........:*/ null,
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ null,
        /*DD_TPO_ID_BPM(FK)............:*/ 'HC103',
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Trámite Provisión de Fondos',
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
        /*DD_TSUP_ID(FK)...............:*/ 'TGCONPR',
        /*TAP_BUCLE_BPM................:*/ null        
        ), 
      --T_TIPO_TAP('H001','H001_AutoDespachandoEjecucion','plugin/procedimientos-bpmHaya-plugin/procedimientoHipotecario/autoDespachandoEjecucion','comprobarExisteDocumentoADEH() ? null : ''Es necesario adjuntar el documento Auto despachando ejecuci&oacute;n.''',null,'valores[''H001_AutoDespachandoEjecucion''][''comboResultado''] == DDSiNo.SI ? ''SI'' : ''NO''',null,'0','Auto despachando ejecución','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'814',null,'GULI',null),
      T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
        /*TAP_CODIGO...................:*/ 'H001_RegistrarCertificadoCargas',
        /*TAP_VIEW.....................:*/ null,
        /*TAP_SCRIPT_VALIDACION........:*/ 'comprobarBienAsociadoPrc() ? (comprobarTipoCargaBienInscrito() ? (comprobarExisteDocumentoCCH() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el Certificado de cargas.</div>'') : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Tiene que completar la información en la pesta&ntilde;a de cargas en la ficha del bien.</div>'') : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Tiene que asociar un bien al procedimiento.</div>''',
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ 'existenCargasPreviasActivas() ? ''conCargas'': ''sinCargas''',
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Cumplimentar mandamiento de certificación de cargas',
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
        /*DD_TSUP_ID(FK)...............:*/ 'TGCONPR',
        /*TAP_BUCLE_BPM................:*/ null        
        ), 
      T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
        /*TAP_CODIGO...................:*/ 'H001_SolicitudOficioJuzgado',
        /*TAP_VIEW.....................:*/ null,
        /*TAP_SCRIPT_VALIDACION........:*/ null,
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ null,
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Solicitud oficio en el juzgado',
        /*VERSION......................:*/ '0',
        /*USUARIOCREAR.................:*/ 'DD',
        /*BORRADO......................:*/ '0',
        /*TAP_ALERT_NO_RETORNO.........:*/ null,
        /*TAP_ALERT_VUELTA_ATRAS.......:*/ 'tareaExterna.cancelarTarea',
        /*DD_FAP_ID(FK)................:*/ null,
        /*TAP_AUTOPRORROGA.............:*/ '0',
        /*DTYPE........................:*/ 'EXTTareaProcedimiento',
        /*TAP_MAX_AUTOP................:*/ '3',
        /*DD_TGE_ID(FK)................:*/ null,
        /*DD_STA_ID(FK)................:*/ 'CJ-814',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ 'TGCONPR',
        /*TAP_BUCLE_BPM................:*/ null        
        ), 
      --'(valores[''H001_RegistrarCertificadoCargas''][''cargasPrevias''] == DDSiNo.SI && valores[''H001_RegistrarCertificadoCargas''][''cuantiaCargasPrevias''] == null) ? ''Si indica que existen cargas previas, debe informar el campo "Cuant&iacute;a de cargas previas"'':null',
      T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
        /*TAP_CODIGO...................:*/ 'H001_RegResolucionJuzgado',
        /*TAP_VIEW.....................:*/ null,
        /*TAP_SCRIPT_VALIDACION........:*/ null,
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ 'valores[''H001_RegResolucionJuzgado''][''resultado'']==DDPositivoNegativo.POSITIVO ? ''positivo'' : ''negativo''',
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Registrar resolución Juzgado',
        /*VERSION......................:*/ '0',
        /*USUARIOCREAR.................:*/ 'DD',
        /*BORRADO......................:*/ '0',
        /*TAP_ALERT_NO_RETORNO.........:*/ null,
        /*TAP_ALERT_VUELTA_ATRAS.......:*/ 'tareaExterna.cancelarTarea',
        /*DD_FAP_ID(FK)................:*/ null,
        /*TAP_AUTOPRORROGA.............:*/ '0',
        /*DTYPE........................:*/ 'EXTTareaProcedimiento',
        /*TAP_MAX_AUTOP................:*/ '3',
        /*DD_TGE_ID(FK)................:*/ null,
        /*DD_STA_ID(FK)................:*/ 'CJ-814',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ 'TGCONPR',
        /*TAP_BUCLE_BPM................:*/ null        
        ), 
      T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
        /*TAP_CODIGO...................:*/ 'H001_ContactarAcreedorPref',
        /*TAP_VIEW.....................:*/ null,
        /*TAP_SCRIPT_VALIDACION........:*/ null,
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ null,
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Contactar con el acreedor preferente',
        /*VERSION......................:*/ '0',
        /*USUARIOCREAR.................:*/ 'DD',
        /*BORRADO......................:*/ '0',
        /*TAP_ALERT_NO_RETORNO.........:*/ null,
        /*TAP_ALERT_VUELTA_ATRAS.......:*/ 'tareaExterna.cancelarTarea',
        /*DD_FAP_ID(FK)................:*/ null,
        /*TAP_AUTOPRORROGA.............:*/ '0',
        /*DTYPE........................:*/ 'EXTTareaProcedimiento',
        /*TAP_MAX_AUTOP................:*/ '3',
        /*DD_TGE_ID(FK)................:*/ null,
        /*DD_STA_ID(FK)................:*/ 'TGCONPR',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ 'SUCONPR',
        /*TAP_BUCLE_BPM................:*/ null        
        ), 
      --T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H001_ConfirmarNotificacionReqPago',null,null,'(valores[''H001_ConfirmarNotificacionReqPago''][''comboResultado''] == DDPositivoNegativo.POSITIVO && valores[''H001_ConfirmarNotificacionReqPago''][''fecha''] == null) ? ''Si indica como resultado de notificacion "Positivo", debe informar la "Fecha de Notificaci&oacute;n"'':null','valores[''H001_ConfirmarNotificacionReqPago''][''comboResultado''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''',null,'0','Confirmar notificación del auto despachando ejecución','0','DD','0',null,null,null,'0','EXTTareaProcedimiento','3',null,'814',null,'GULI',null),
      T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
        /*TAP_CODIGO...................:*/ 'H001_ConfirmarSiExisteOposicion',
        /*TAP_VIEW.....................:*/ 'plugin/procedimientos/procedimientoHipotecario/confirmarSiExisteOposicion',
        /*TAP_SCRIPT_VALIDACION........:*/ null,
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ 'valores[''H001_ConfirmarSiExisteOposicion''][''comboResultado''] == DDSiNo.SI ? (!comprobarExisteDocumentoEOH() ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el Escrito de oposici&oacute;n.</div>'' : ((valores[''H001_ConfirmarSiExisteOposicion''][''fechaOposicion''] == null || valores[''H001_ConfirmarSiExisteOposicion''][''motivoOposicion''] == null || valores[''H001_ConfirmarSiExisteOposicion''][''fechaComparecencia''] == null) ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Si indica que hay oposici&oacute;n, debe registrar tambi&eacute;n "Fecha Oposici&oacute;n", "Motivo Oposici&oacute;n" y "Fecha Comparecencia"</div>'' : (valores[''H001_ConfirmarSiExisteOposicion''][''alegaciones''] == DDSiNo.SI && valores[''H001_ConfirmarSiExisteOposicion''][''fechaFinAlegaciones''] == null ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe indicar la fecha de alegaciones</div>'' : null))) : null',
        /*TAP_SCRIPT_DECISION..........:*/ 'valores[''H001_ConfirmarSiExisteOposicion''][''comboResultado''] == DDSiNo.SI ? (valores[''H001_ConfirmarSiExisteOposicion''][''alegaciones''] == DDSiNo.SI ? ''SI_ALEGACIONES'' : ''NO_ALEGACIONES'') : ''NO''',
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Confirmar si existe oposición',
        /*VERSION......................:*/ '0',
        /*USUARIOCREAR.................:*/ 'DD',
        /*BORRADO......................:*/ '0',
        /*TAP_ALERT_NO_RETORNO.........:*/ null,
        /*TAP_ALERT_VUELTA_ATRAS.......:*/ 'tareaExterna.cancelarTarea',
        /*DD_FAP_ID(FK)................:*/ null,
        /*TAP_AUTOPRORROGA.............:*/ '0',
        /*DTYPE........................:*/ 'EXTTareaProcedimiento',
        /*TAP_MAX_AUTOP................:*/ '3',
        /*DD_TGE_ID(FK)................:*/ null,
        /*DD_STA_ID(FK)................:*/ 'CJ-814',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ 'TGCONPR',
        /*TAP_BUCLE_BPM................:*/ null        
        ), 
        T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
        /*TAP_CODIGO...................:*/ 'H001_PresentarAlegaciones',
        /*TAP_VIEW.....................:*/ null,
        /*TAP_SCRIPT_VALIDACION........:*/ 'comprobarExisteDocumentoHEDIMP() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el Escrito de impugnaci&oacute;n.</div>''',
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ 'valores[''H001_PresentarAlegaciones''][''comparecencia''] == DDSiNo.SI && valores[''H001_PresentarAlegaciones''][''fechaComparecencia''] == null ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe indicar la fecha de comparecencia</div>'' : null',
        /*TAP_SCRIPT_DECISION..........:*/ 'valores[''H001_PresentarAlegaciones''][''comparecencia''] == DDSiNo.SI ? ''hayComparecencia'' : ''noHayComparecencia''',
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Presentar alegaciones',
        /*VERSION......................:*/ '0',
        /*USUARIOCREAR.................:*/ 'DD',
        /*BORRADO......................:*/ '0',
        /*TAP_ALERT_NO_RETORNO.........:*/ null,
        /*TAP_ALERT_VUELTA_ATRAS.......:*/ 'tareaExterna.cancelarTarea',
        /*DD_FAP_ID(FK)................:*/ null,
        /*TAP_AUTOPRORROGA.............:*/ '0',
        /*DTYPE........................:*/ 'EXTTareaProcedimiento',
        /*TAP_MAX_AUTOP................:*/ '3',
        /*DD_TGE_ID(FK)................:*/ null,
        /*DD_STA_ID(FK)................:*/ 'CJ-814',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ 'TGCONPR',
        /*TAP_BUCLE_BPM................:*/ null        
        )
      --T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H001_RegistrarComparecencia',null,null,null,null,null,'0','Registrar comparecencia','0','DD','0',null,'tareaExterna.cancelarTarea',null,'0','EXTTareaProcedimiento','3',null,'814',null,'GULI',null),
      --T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H001_RegistrarResolucion',null,null,null,null,null,'0','Registrar resolución','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'814',null,'GULI',null),
      --T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H001_ResolucionFirme',null,null,null,null,null,'0','Resolución firme','0','DD','0',null,'tareaExterna.cancelarTarea',null,'0','EXTTareaProcedimiento','3',null,'814',null,'GULI',null),
      
      --T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H001_BPMTramiteSubasta',null,null,null,null,'H002','0','Ejecución del trámite de Subasta','0','DD','0',null,'tareaExterna.cancelarTarea',null,'0','EXTTareaProcedimiento','3',null,'814',null,null,null),
      --T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H001_BPMTramiteNotificacion',null,null,null,null,'P400','0','Ejecución del trámite de notificación','0','DD','0',null,'tareaExterna.cancelarTarea',null,'0','EXTTareaProcedimiento','3',null,'814',null,null,null),
      --T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H001_AutoDespachandoDecision',null,null,null,null,null,'0','Tarea toma de decisión','0','DD','0',null,null,null,'0','EXTTareaProcedimiento','3',null,'819',null,'GULI',null),
      --T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H001_ResolucionFirmeDecision',null,null,null,null,null,'0','Tarea toma de decisión','0','DD','0',null,null,null,'0','EXTTareaProcedimiento','3',null,'819',null,'GULI',null)
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
      T_TIPO_PLAZAS(null,null,'H001_DemandaCertificacionCargas','10*24*60*60*1000L','0','0','DD'),
      --T_TIPO_PLAZAS(null,null,'H001_AutoDespachandoEjecucion','damePlazo(valores[''H001_DemandaCertificacionCargas''][''fechaPresentacionDemanda'']) + 60*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'H001_RegistrarCertificadoCargas','7*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'H001_SolicitudOficioJuzgado','5*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'H001_RegResolucionJuzgado','40*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'H001_ContactarAcreedorPref','10*24*60*60*1000L','0','0','DD'),
      --T_TIPO_PLAZAS(null,null,'H001_ConfirmarNotificacionReqPago','60*24*60*60*1000L','0','0','DD'),
      --T_TIPO_PLAZAS(null,null,'H001_ContactarConDeudor','2*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'H001_ConfirmarSiExisteOposicion','valores[''H001_ConfirmarNotificacionReqPago''][''fecha''] != null ? damePlazo(valores[''H001_ConfirmarNotificacionReqPago''][''fecha'']) + 10*24*60*60*1000L : 10*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'H001_PresentarAlegaciones','damePlazo(valores[''H001_ConfirmarSiExisteOposicion''][''fechaFinAlegaciones''])','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'H001_BPMProvisionFondos','300*24*60*60*1000L','0','0','DD')
      
      
      --T_TIPO_PLAZAS(null,null,'H001_RegistrarComparecencia','damePlazo(valores[''H001_ConfirmarSiExisteOposicion''][''fechaComparecencia''])','0','0','DD'),
      --T_TIPO_PLAZAS(null,null,'H001_RegistrarResolucion','damePlazo(valores[''H001_RegistrarComparecencia''][''fecha'']) + 15*24*60*60*1000L','0','0','DD'),
      --T_TIPO_PLAZAS(null,null,'H001_ResolucionFirme','damePlazo(valores[''H001_RegistrarResolucion''][''fecha'']) + 20*24*60*60*1000L','0','0','DD'),
      --T_TIPO_PLAZAS(null,null,'H001_BPMTramiteSubasta','300*24*60*60*1000L','0','0','DD'),
      --T_TIPO_PLAZAS(null,null,'H001_BPMTramiteNotificacion','300*24*60*60*1000L','0','0','DD')       
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
        T_TIPO_TFI('H001_DemandaCertificacionCargas','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Informar fecha de presentación de la demanda con solicitud de certificación de cargas e indíquese la plaza del juzgado.</p><p style="margin-bottom: 10px">Se ha de indicar la fecha de cierre de la deuda junto con el principal de la demanda, el capital vencido, capital no vencido, juntos con los intereses ordinarios, de demora que se han generado en el cierre y el crédito supletorio. RESPONSABILIDAD HIPOTECARIA: por capital, por intereses remuneratorios, por demora y por costas y gastos.</p><p style="margin-bottom: 10px">Para dar por finalizada la tarea deberá adjuntar el escrito de demanda completo así como la primera hoja sellada por el juzgado.</p><p style="margin-bottom: 10px">En el campo "Solicitar provisión de fondos" deberá indicar va a solicitar o no provisión de fondos.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será "Auto despachando ejecución" y paralelamente se lanzará el "trámite de provisión de fondos" si ha indicado que solicita provisión de fondos.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_DemandaCertificacionCargas','1','date','fechaPresentacionDemanda','Fecha presentación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H001_DemandaCertificacionCargas','2','combo','plazaJuzgado','Plaza del juzgado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','damePlaza()','TipoPlaza','0','DD'),
        T_TIPO_TFI('H001_DemandaCertificacionCargas','3','date','fechaCierreDeuda','Fecha cierre de la deuda','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H001_DemandaCertificacionCargas','4','currency','principalDeLaDemanda','Principal de la demanda','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H001_DemandaCertificacionCargas','5','currency','capitalVencidoEnElCierre','Capital vencido (en el cierre)','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H001_DemandaCertificacionCargas','6','currency','capitalNoVencidoEnElCierre','Capital no vencido (en el cierre)','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H001_DemandaCertificacionCargas','7','currency','interesesOrdinariosEnElCierre','Intereses ordinarios (en el cierre)','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H001_DemandaCertificacionCargas','8','currency','interesesDeDemoraEnElCierre','Intereses de demora (en el cierre)','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H001_DemandaCertificacionCargas','9','currency','respHipCap','Responsabilidad hipotecaria máxima por capital','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H001_DemandaCertificacionCargas','10','currency','respHipIntRem','Responsabilidad hipotecaria máxima por intereses remuneratorios','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H001_DemandaCertificacionCargas','11','currency','respHipDem','Responsabilidad hipotecaria máxima por demora','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H001_DemandaCertificacionCargas','12','currency','respHipCosGas','Responsabilidad hipotecaria máxima por costas y gastos','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H001_DemandaCertificacionCargas','13','currency','creditoSupl','Crédito supletorio','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H001_DemandaCertificacionCargas','14','combo','provisionFondos','Provisión Fondos','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('H001_DemandaCertificacionCargas','15','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        --T_TIPO_TFI('H001_AutoDespachandoEjecucion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Ind&iacute;quese la fecha en la que se nos notifica auto por el que se despacha ejecuci&oacute;n, el juzgado en el que ha reca&iacute;do la demanda y el n&uacute;mero de procedimiento.</p><p style="margin-bottom: 10px">Se ha de indicar si la demanda interpuesta ha sido admitida o no, lo que supondr&aacute;, seg&uacute;n su contestaci&oacute;n, que la tarea siguiente sea una u otra de las que se le indica con posterioridad.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute;:<br>- Si ha sido admitida a tr&aacute;mite la demanda "Confirmar notificaci&oacute;n del auto despachando ejecuci&oacute;n" al ejecutado.<br>- Si no ha sido admitida la demanda se le abrir&aacute; tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
        --T_TIPO_TFI('H001_AutoDespachandoEjecucion','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        --T_TIPO_TFI('H001_AutoDespachandoEjecucion','2','combo','nPlaza','Plaza del juzgado',null,null,'damePlaza()','TipoPlaza','0','DD'),
        --T_TIPO_TFI('H001_AutoDespachandoEjecucion','3','combo','numJuzgado','Número de juzgado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','dameNumJuzgado()','TipoJuzgado','0','DD'),
        --T_TIPO_TFI('H001_AutoDespachandoEjecucion','4','textproc','numProcedimiento','Número de procedimiento','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','dameNumAuto()',null,'0','DD'),
        --T_TIPO_TFI('H001_AutoDespachandoEjecucion','5','combo','comboResultado','Admisión','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        --T_TIPO_TFI('H001_AutoDespachandoEjecucion','6','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_RegistrarCertificadoCargas','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Paralelamente antes de confirmar la notificación del autodespachando ejecución, deberá de revisar las cargas anteriores y posteriores registradas en el bien vinculado al procedimiento. En caso de no haber un bien ya vinculado al procedimiento, antes de dar por completada esta tarea el sistema le obligará a asociarlo a través de la pestaña bienes del procedimiento. Para cada carga deberá indicar si es de tipo Registral y/o si es de tipo Económico y en caso de no existir cargas indicarlo expresamente en el campo destinado a tal efecto. En cualquier caso deberá indicar en la ficha de cargas del bien la fecha en que haya realizado la revisión de las mismas.</p><p style="margin-bottom: 10px">En el supuesto de que existan cargas previas deberá presentar escrito en el juzgado para averiguar el estado de las cargas</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">En caso de que hubiera indicado que existen cargas ajenas previas, se lanzará la tarea "Solicitar oficio en el juzgado".</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_RegistrarCertificadoCargas','1','date','fecha','Fecha de la certificación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        --T_TIPO_TFI('H001_RegistrarCertificadoCargas','2','combo','cargasPrevias','Cargas ajenas previas','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        --T_TIPO_TFI('H001_RegistrarCertificadoCargas','3','currency','cuantiaCargasPrevias','Cuantía cargas previas',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_RegistrarCertificadoCargas','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_SolicitudOficioJuzgado','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Antes de dar por finalizada esta tarea deberá solicitar en el juzgado para que se personen los titulares de las cargas.</p><p style="margin-bottom: 10px">En el campo "Fecha solicitud" deberá informar de la fecha en la realiza la solicitud.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Un vez rellene esta pantalla, la siguiente tarea será "Registrar resolución juzgado".</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_SolicitudOficioJuzgado','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H001_SolicitudOficioJuzgado','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_RegResolucionJuzgado','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea, y en el supuesto de que la resolución del juzgado fuere positivo, deberá ir a la pestaña de "Bienes" del asunto y actualizar las cargas según la notificación del juzgado una vez personados los titulares de dichas cargas.</p><p style="margin-bottom: 10px">En el campo "Fecha resolución" deberá informar la fecha en la que el juzgado resuelve la solicitud.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Un vez rellene esta pantalla, en caso de que el resultado fuere negativo, se lanzará la tarea "Contactar con acreedor preferente" al gestor de contencioso gestión.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_RegResolucionJuzgado','1','date','fecha','Fecha Resolución','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H001_RegResolucionJuzgado','2','combo','resultado','Resultado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDPositivoNegativo','0','DD'),
        T_TIPO_TFI('H001_RegResolucionJuzgado','3','currency','cuantiaCargasPrevias','Cuantía cargas previas',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_RegResolucionJuzgado','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_ContactarAcreedorPref','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Puesto que la resolución del juzgado a la solicitud de oficio ha sido negativa, el gestor de esta tarea deberá ponerse en contacto con el acreedor preferente titular de las cargas previas para averiguar el estado de las mismas.</p><p style="margin-bottom: 10px">Para dar por finalizada esta tarea, deberá ir a la pestaña de "Bienes" del asunto y actualizar el estado de las cargas de acuerdo a sus averiguaciones.</p><p style="margin-bottom: 10px">En el campo Fecha deberá informar de la fecha que realiza esta tarea.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_ContactarAcreedorPref','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H001_ContactarAcreedorPref','2','currency','cuantiaCargasPrevias','Cuantía cargas previas',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_ContactarAcreedorPref','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        --T_TIPO_TFI('H001_ConfirmarNotificacionReqPago','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Debe indicar si la notificaci&oacute;n del auto a los deudores (y en su caso el requerimiento de pago) se ha realizado satisfactoriamente.</p><p style="margin-bottom: 10px">Deber&aacute; informar la fecha de notificaci&oacute;n &uacute;nicamente en el supuesto de que &eacute;sta se hubiese efectuado.</p><p style="margin-bottom: 10px">Si no se hubiera requerido en la persona del ejecutado, deber&aacute; notificar dicha circunstancia al supervisor v&iacute;a notificaci&oacute;n interna por si hubiera lugar a iniciar el Tr&aacute;mite de Ocupantes.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute;:<br>- Notificaci&oacute;n positiva: "Confirmar si existe oposici&oacute;n"<br>- Notificaci&oacute;n negativa: en este caso se iniciar&aacute; el tr&aacute;mite de notificaci&oacute;n.</p></div>',null,null,null,null,'0','DD'),
        --T_TIPO_TFI('H001_ConfirmarNotificacionReqPago','1','combo','comboResultado','Resultado notificación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDPositivoNegativo','0','DD'),
        --T_TIPO_TFI('H001_ConfirmarNotificacionReqPago','2','date','fecha','Fecha notificación',null,null,null,null,'0','DD'),
        --T_TIPO_TFI('H001_ConfirmarNotificacionReqPago','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        --T_TIPO_TFI('H001_ContactarConDeudor','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, el gestor de deuda deber&aacute; informar de la fecha en la que se ha puesto en contacto con el deudor y el resultado del acuerdo se lo comunicar&aacute; a su supervisor.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
        --T_TIPO_TFI('H001_ContactarConDeudor','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        --T_TIPO_TFI('H001_ContactarConDeudor','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_ConfirmarSiExisteOposicion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Una vez notificado al demandado el auto de despacho de ejecución, en esta pantalla ha de indicar si el mismo se ha opuesto o no a la demanda.</p><p style="margin-bottom: 10px">En el supuesto de que exista oposición, deberá informar su fecha de notificación e indicar la fecha que el juzgado ha designado para la comparecencia.</p><p style="margin-bottom: 10px">En caso de que se decida presentar alegaciones deberá señalarlo en el campo "Presentar alegaciones" e indicar la fecha de fin de alegaciones</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será:</p><p style="margin-bottom: 10px">-Si no hay oposición: se iniciará el trámite de subasta, con lo que le aparecerá la primera tarea de dicho trámite.</p><p style="margin-bottom: 10px">-Si hay oposición y no presenta alegaciones: "Registrar comparecencia".</p><p style="margin-bottom: 10px">-Si hay oposición y presenta alegaciones: "Presentar alegaciones".</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_ConfirmarSiExisteOposicion','1','combo','comboResultado','Existe oposición','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('H001_ConfirmarSiExisteOposicion','2','date','fechaOposicion','Fecha oposición',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_ConfirmarSiExisteOposicion','3','textarea','motivoOposicion','Motivo oposición',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_ConfirmarSiExisteOposicion','4','date','fechaComparecencia','Fecha comparecencia',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_ConfirmarSiExisteOposicion','5','combo','alegaciones','Presentar alegaciones','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('H001_ConfirmarSiExisteOposicion','6','date','fechaFinAlegaciones','Fecha fin alegaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_ConfirmarSiExisteOposicion','7','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_PresentarAlegaciones','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Puesto que se ha decidido presentar alegaciones, en esta pantalla deberá dejar reflejada la fecha en que éstas se presentan en el juzgado y adjuntar el "Escrito de Impugnación" para dar por finalizada esta tarea.</p><p style="margin-bottom: 10px">En el campo Comparecencia deberá indicar si habrá o no habrá comparecencia. En caso de que la haya, deberá informar de la fecha de comparecencia.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será "Registrar comparecencia" en caso de que indique que habrá comparecencia o "Registrar resolución" en caso de que no haya comparecencia.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_PresentarAlegaciones','1','date','fecha','Fecha presentación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('H001_PresentarAlegaciones','2','combo','comparecencia','Comparecencia','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('H001_PresentarAlegaciones','3','date','fechaComparecencia','Fecha comparecencia',null,null,null,null,'0','DD'),
        T_TIPO_TFI('H001_PresentarAlegaciones','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        --T_TIPO_TFI('H001_RegistrarComparecencia','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Dado que en éste proceso ha habido oposici&oacute;n, en esta pantalla debemos de informar la fecha de celebraci&oacute;n de la comparecencia en el supuesto de que la misma se hubiere celebrado. En caso contrario se deber&aacute; solicitar pr&oacute;rroga para &eacute;sta tarea, en la que deber&aacute; indicar la nueva fecha de celebraci&oacute;n de la comparecencia.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute; "Registrar resoluci&oacute;n"</p></div>',null,null,null,null,'0','DD'),
        --T_TIPO_TFI('H001_RegistrarComparecencia','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        --T_TIPO_TFI('H001_RegistrarComparecencia','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        --T_TIPO_TFI('H001_RegistrarResolucion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">En &eacute;sta pantalla se deber&aacute; de informar la fecha de notificaci&oacute;n de la Resoluci&oacute;n que hubiere reca&iacute;do como consecuencia de la comparecencia celebrada.</p><p style="margin-bottom: 10px">Se indicar&aacute; si el resultado de dicha resoluci&oacute;n ha sido favorable para los intereses de la entidad o no.</p><p style="margin-bottom: 10px">Para el supuesto de que la resoluci&oacute;n no fuere favorable para la entidad, deber&aacute; comunicar dicha circunstancia al responsable interno de la misma a trav&eacute;s del bot&oacute;n "Comunicaci&oacute;n". Una vez reciba la aceptaci&oacute;n del supervisor deber&aacute; gestionar el recurso por medio de la pestaña "Recursos".</p><p style="margin-bottom: 10px">Para el supuesto de anuncio del recurso por la parte contraria se deber&aacute; gestionar directamente a trav&eacute;s de la pestaña "Recursos".</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute; "Resoluci&oacute;n firme"</p></div>',null,null,null,null,'0','DD'),
        --T_TIPO_TFI('H001_RegistrarResolucion','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        --T_TIPO_TFI('H001_RegistrarResolucion','2','combo','resultado','Resultado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDFavorable','0','DD'),
        --T_TIPO_TFI('H001_RegistrarResolucion','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        --T_TIPO_TFI('H001_ResolucionFirme','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Se deber&aacute; informar la fecha en la que la Resoluci&oacute;n adquiere firmeza.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla se le abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>',null,null,null,null,'0','DD'),
        --T_TIPO_TFI('H001_ResolucionFirme','1','date','fechaFirmeza','Fecha firmeza','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        --T_TIPO_TFI('H001_ResolucionFirme','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        --T_TIPO_TFI('H001_BPMTramiteSubasta','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Ejecuci&oacute;n del tr&aacute;mite de subasta</p></div>',null,null,null,null,'0','DD'),
        --T_TIPO_TFI('H001_BPMTramiteNotificacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Ejecuci&oacute;n del tr&aacute;mite de notificaci&oacute;n</p></div>',null,null,null,null,'0','DD')
        T_TIPO_TFI('H001_BPMProvisionFondos','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Se inicia el tr&aacute;mite de provisión de fondos</p></div>',null,null,null,null,'0','DD')

    ); 
    V_TMP_TIPO_TFI T_TIPO_TFI;
    
    V_TAREA VARCHAR(50 CHAR);
    
BEGIN	
	
	
	/* ------------------- -------------------------- */
	/* --------------  ACTUALIZACIONES --------------- */
	/* ------------------- -------------------------- */
	-- BORRADO DE TAREA (lógico)
	V_TAREA:='H001_DemandaCertificacionCargas';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''DEL_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''GONZALO'' WHERE TAP_CODIGO='''||V_TAREA||'''';

	-- UPDATE
	V_TAREA:='H001_AutoDespachandoEjecucion';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items SET ' ||
	  ' tfi_label=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Indíquese la fecha en la que se nos notifica auto por el que se despacha ejecución, el juzgado en el que ha recaído la demanda y el número de procedimiento.</p><p style="margin-bottom: 10px">Se ha de indicar si la demanda interpuesta ha sido admitida o no, lo que supondrá, según su contestación, que la tarea siguiente sea una u otra de las que se le indica con posterioridad.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será:</p><p style="margin-bottom: 10px">-Si ha sido admitida a trámite la demanda, se lanzarán las tareas "Confirmar notificación del auto despachando ejecución" y "Cumplimentar mandamiento de certificación de cargas".</p><p style="margin-bottom: 10px">-Si no ha sido admitida la demanda se le abrirá tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</p></div>''' ||
	  ' WHERE tfi_nombre=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';

	-- BORRADO DE TAREA (lógico)
	V_TAREA:='H001_RegistrarCertificadoCargas';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''DEL_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''GONZALO'' WHERE TAP_CODIGO='''||V_TAREA||'''';

	-- BORRADO DE TAREA (lógico)
	V_TAREA:='H001_ContactarConDeudor';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''DEL_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''GONZALO'' WHERE TAP_CODIGO='''||V_TAREA||'''';

	-- BORRADO DE TAREA (lógico)
	V_TAREA:='H001_ConfirmarSiExisteOposicion';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''DEL_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''GONZALO'' WHERE TAP_CODIGO='''||V_TAREA||'''';

	-- BORRADO DE TAREA (lógico)
	V_TAREA:='H001_RegistrarResolucion';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_ALERT_VUELTA_ATRAS=null, TAP_SCRIPT_VALIDACION=''comprobarExisteDocumentoHRESOL() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;">Es necesario adjuntar el documento de resoluci&oacute;n.</div>'''''' WHERE TAP_CODIGO='''||V_TAREA||'''';

	V_TAREA:='H001_RegistrarComparecencia';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas SET DD_PTP_PLAZO_SCRIPT=''damePlazo(valores[''''H001_PresentarAlegaciones'''']!=null ? valores[''''H001_PresentarAlegaciones''''][''''fechaComparecencia''''] : valores[''''H001_ConfirmarSiExisteOposicion''''][''''fechaComparecencia''''])'' WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
		
	V_TAREA:='H001_RegistrarResolucion';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas SET DD_PTP_PLAZO_SCRIPT=''damePlazo(valores[''''H001_PresentarAlegaciones'''']!=null ? valores[''''H001_PresentarAlegaciones''''][''''fechaComparecencia''''] : valores[''''H001_ConfirmarSiExisteOposicion''''][''''fechaComparecencia'''']) + 15*24*60*60*1000L'' WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	
	/* ------------------- -------------------------- */
	/* ------------------- -------------------------- */

	-- LOOP Insertando valores en TAP_TAREA_PROCEDIMIENTO
    VAR_TABLENAME := 'DD_TPO_TIPO_PROCEDIMIENTO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar TAREAS');
    FOR I IN V_TIPO_TPO.FIRST .. V_TIPO_TPO.LAST
      LOOP
        V_TMP_TIPO_TPO := V_TIPO_TPO(I);
        V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.' || VAR_TABLENAME || ' SET ' ||
        		' DD_TPO_CODIGO='''||REPLACE(TRIM(V_TMP_TIPO_TPO(1)),'''','''''') ||''''|| 
        		' ,DD_TPO_XML_JBPM='''||REPLACE(TRIM(V_TMP_TIPO_TPO(5)),'''','''''')||''''||
				' WHERE DD_TPO_CODIGO='''||REPLACE(TRIM(V_TMP_TIPO_TPO(1)),'''','''''') ||'''';
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