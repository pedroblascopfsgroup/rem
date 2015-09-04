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

    V_COD_PROCEDIMIENTO VARCHAR (20 CHAR) := 'H005';
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
      T_TIPO_TPO(V_COD_PROCEDIMIENTO,'Trámite de Adjudicación','Trámite de Adjudicación',null,'hcj_tramiteAdjudicacion','0','DD','0','AP',null,null,'1','MEJTipoProcedimiento','1','1')      
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(2000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(

		--EQ T_TIPO_TAP('H005','H005_SolicitudDecretoAdjudicacion',null,'comprobarBienAsociadoPrc() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Este tr&aacute;mite requiere tener un solo bien asociado. Vaya a la pesta&nacute;a de bienes del procedimiento y aseg&uacute;rese de que hay un bien asociado y no m&aacute;s de uno.</div>'' ',null,null,null,'0','Solicitud de Decreto de Adjudicación','0','DD','0',null,null,null,'0','EXTTareaProcedimiento','3',null,'814',null,'GULI',null),
	    T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
        /*TAP_CODIGO...................:*/ 'H005_notificacionDecretoAdjudicacionAEntidad',
        /*TAP_VIEW.....................:*/ 'plugin/cajamar/tramiteAdjudicacion/notifDecAdjuEntidad',
        /*TAP_SCRIPT_VALIDACION........:*/ 'comprobarExisteDocumentoDFA() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el Decreto Firme de Adjudicaci&oacute;n.</div>''',
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ 'comprobarInformadoComboTributacion() ? (comprobarComboComunicacionAdicionalNOTIFENT() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe indicar la si requiere comunicaci&oacute;n adicional y en caso afirmativo la fecha l&iacute;mite de comunicaci&oacute;n</div>'') : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario informar el tipo de tributaci&oacute;n</div>''',
        /*TAP_SCRIPT_DECISION..........:*/ 'valores[''H005_notificacionDecretoAdjudicacionAEntidad''][''comboSubsanacion'']==DDSiNo.SI ? ''SI'' : ''NO''',
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Notificación del Decreto de Adjudicación a Entidad',
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
        /*DD_STA_ID(FK)................:*/ '',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ '',
        /*TAP_BUCLE_BPM................:*/ null        
        ), 
		--EQ T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H005_BPMTramiteSaneamientoCargas',null,null,null,null,'H008','0','Llamada al BPM de Trámite de Trámite de Saneamiento de Cargas','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
		--EQ T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H005_BPMTramiteSubsanacionEmbargo1',null,null,null,null,'H052','0','Llamada al BPM de Trámite de Subsanación de Adjudicación','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
		--EQ T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H005_declararIVAeIGIC',null,null,null,null,null,'0','Declarar IVA e IGIC','0','DD','0',null,null,null,'0','EXTTareaProcedimiento','3',null,'807',null,'SCON',null)    
		--EQ T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H005_notificacionDecretoAdjudicacionAlContrario',null,null,null,'( valores[''H005_notificacionDecretoAdjudicacionAlContrario''][''comboNotificacion''] == DDSiNo.SI ? ''SI'':''NO'')',null,'0','Notificación del Decreto de Adjudicación al Contrario','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'814',null,'GULI',null),
   		--EQ T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H005_BPMTramiteNotificacion',null,null,null,null,'P400','0','Llamada al BPM de Trámite de Trámite de Notificación','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
		--EQ T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H005_SolicitudTestimonioDecretoAdjudicacion',null,null,null,null,null,'0','Solicitud de Testimonio del Decreto de Adjudicación','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'814',null,'GULI',null),
		--EQ T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H005_ConfirmarTestimonio','plugin/procedimientos/genericFormOverSize','comprobarExisteDocumentoDFA() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el Decreto Firme de Adjudicacion.</div>'' ',null,'( valores[''H005_ConfirmarTestimonio''][''comboSubsanacion''] == DDSiNo.SI ? ''SI'':''NO'')',null,'0','Confirmar el Testimonio','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'814',null,'GULI',null),
	    T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
        /*TAP_CODIGO...................:*/ 'H005_ConfirmarTestimonio',
        /*TAP_VIEW.....................:*/ 'plugin/cajamar/tramiteAdjudicacion/confirmarTestimonio',
        /*TAP_SCRIPT_VALIDACION........:*/ 'comprobarExisteDocumentoDFA() ? (comprobarExisteDocumentoMP() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el Mandamiento de Pago.</div>'') : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el Decreto Firme de Adjudicaci&oacute;n.</div>''',
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ 'comprobarComboComunicacionAdicionalCONFTESTI() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe indicar la si hay constancia de ocupantes, si requiere comunicaci&oacute;n adicional y en caso afirmativo la fecha l&iacute;mite de comunicaci&oacute;n</div>''',
        /*TAP_SCRIPT_DECISION..........:*/ 'valores[''H005_ConfirmarTestimonio''][''comboSubsanacion'']==DDSiNo.SI ? ''SI'' : ''NO''',
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Confirmar el Testimonio',
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
        /*DD_STA_ID(FK)................:*/ '',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ '',
        /*TAP_BUCLE_BPM................:*/ null        
        ), 
	    T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
        /*TAP_CODIGO...................:*/ 'H005_RevisionComAdicional',
        /*TAP_VIEW.....................:*/ null,
        /*TAP_SCRIPT_VALIDACION........:*/ null,
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ null,
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Revisión documentación y comunicación adicional',
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
        /*DD_STA_ID(FK)................:*/ '',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ '',
        /*TAP_BUCLE_BPM................:*/ null        
        ), 
	    T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
        /*TAP_CODIGO...................:*/ 'H005_NotifComAdicional',
        /*TAP_VIEW.....................:*/ null,
        /*TAP_SCRIPT_VALIDACION........:*/ 'comprobarExisteDocumentoCOMAD() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el documento Comunicaci&oacute;n Adicional.</div>''',
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ null,
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Notificación comunicación adicional',
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
        /*DD_STA_ID(FK)................:*/ '',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ '',
        /*TAP_BUCLE_BPM................:*/ null        
        ), 
	    T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
        /*TAP_CODIGO...................:*/ 'H005_BPMProvisionFondos',
        /*TAP_VIEW.....................:*/ null,
        /*TAP_SCRIPT_VALIDACION........:*/ null,
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ null,
        /*DD_TPO_ID_BPM(FK)............:*/ 'HC103',
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Tramite de provisión de fondos',
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
        /*DD_STA_ID(FK)................:*/ '',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ '',
        /*TAP_BUCLE_BPM................:*/ null        
        ), 
    	--EQ T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H005_BPMTramiteDePosesion',null,null,null,null,'H015','0','Llamada al BPM de Trámite de Trámite de Posesión','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
		--EQ T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H005_BPMTramiteSubsanacionEmbargo2',null,null,null,null,'H052','0','Llamada al BPM de Trámite de Subsanación de Adjudicación','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
		--EQ T_TIPO_TAP('H005','H005_RegistrarPresentacionEnRegistro',null,null,null,null,null,'0','Registrar presentación en Registro','0','DD','0',null,'tareaExterna.cancelarTarea',null,'0','EXTTareaProcedimiento','3',null,'1001',null,null,null),
		--EQ T_TIPO_TAP('H005','H005_RegistrarInscripcionDelTitulo','plugin/procedimientos/genericFormOverSize',null,'(valores[''H005_RegistrarInscripcionDelTitulo''][''comboSituacionTitulo''] == ''INS'') ? ((valores[''H005_RegistrarInscripcionDelTitulo''][''fechaInscripcion''] == null || valores[''H005_RegistrarInscripcionDelTitulo''][''fechaInscripcion''] == '') ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Si el t&iacute;tulo se ha inscrito, es necesario indicar la fecha de inscripci&oacute;n</div>'' : null ) : ((valores[''H005_RegistrarInscripcionDelTitulo''][''fechaEnvioDecretoAdicion''] == null || valores[''H005_RegistrarInscripcionDelTitulo''][''fechaEnvioDecretoAdicion''] == '') ?  ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Si el t&iacute;tulo est&aacute; pde. subsanacion, es necesario indicar la fecha env&iacute;o decreto adici&oacute;n</div>'' : null )','( valores[''H005_RegistrarInscripcionDelTitulo''][''comboSituacionTitulo''] == ''PEN'' ? ''SI'':''NO'')',null,'0','Registrar Inscripción del Título','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'1001',null,null,null),
		--EQ T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H005_BPMTramiteSubsanacionEmbargo3',null,null,null,null,'H052','0','Llamada al BPM de Trámite de Subsanación de Adjudicación','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
		--DEL T_TIPO_TAP('H005','H005_RegistrarEntregaTitulo','plugin/procedimientos/genericFormOverSize',null,'comprobarExisteDocumentoRECGES() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el Recib&iacute; de Gestor&iacute;a.</div>''',null,null,'0','Registrar entrega del título','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'1001',null,null,null),
		--DEL T_TIPO_TAP('H005','H005_RegistrarPresentacionEnHacienda',null,'comprobarExisteDocumentoCALHAC() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar la copia de la autoliquidación presentada en Hacienda.</div>''',null,null,null,'0','Registrar presentación en Hacienda','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'1001',null,null,null),
		--DEL T_TIPO_TAP('H005','H005_ConfirmarContabilidad',null,null,null,null,null,'0','Confirmar contabilidad','0','DD','0',null,null,null,'0','EXTTareaProcedimiento','3',null,'805',null,'SSDE',null),
	    T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
        /*TAP_CODIGO...................:*/ 'H005_RevisarInfoContable',
        /*TAP_VIEW.....................:*/ null,
        /*TAP_SCRIPT_VALIDACION........:*/ null,
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ null,
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Revisar y obtener información contable',
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
        /*DD_STA_ID(FK)................:*/ '',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ '',
        /*TAP_BUCLE_BPM................:*/ null        
        ), 
	    T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
        /*TAP_CODIGO...................:*/ 'H005_ConfirmarContabilidad',
        /*TAP_VIEW.....................:*/ 'plugin/cajamar/tramiteAdjudicacion/confirmarContabilidad',
        /*TAP_SCRIPT_VALIDACION........:*/ null,
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ null,
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Confirmar Contabilidad',
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
        /*DD_STA_ID(FK)................:*/ '',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ '',
        /*TAP_BUCLE_BPM................:*/ null        
        ), 
	    T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
        /*TAP_CODIGO...................:*/ 'H005_BPMNotifNotarialOcupante',
        /*TAP_VIEW.....................:*/ null,
        /*TAP_SCRIPT_VALIDACION........:*/ null,
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ null,
        /*DD_TPO_ID_BPM(FK)............:*/ 'HC106',
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Trámite de Notificación notarial de ocupantes',
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
        /*DD_STA_ID(FK)................:*/ '',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ '',
        /*TAP_BUCLE_BPM................:*/ null        
        ), 
	    T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
        /*TAP_CODIGO...................:*/ 'H005_BPMCertfLibertadArrendamiento',
        /*TAP_VIEW.....................:*/ null,
        /*TAP_SCRIPT_VALIDACION........:*/ null,
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ null,
        /*DD_TPO_ID_BPM(FK)............:*/ 'HC101',
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Trámite de Certificado libertad de arrendamiento',
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
        /*DD_STA_ID(FK)................:*/ '',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ '',
        /*TAP_BUCLE_BPM................:*/ null        
        ) 
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
    	--EQ T_TIPO_PLAZAS(null,null,'H005_SolicitudDecretoAdjudicacion','3*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H005_notificacionDecretoAdjudicacionAEntidad','damePlazo(valores[''H005_SolicitudDecretoAdjudicacion''][''fechaSolicitud'']) + 30*24*60*60*1000L','0','0','DD'),
		--EQ T_TIPO_PLAZAS(null,null,'H005_BPMTramiteSaneamientoCargas','300*24*60*60*1000L','0','0','DD'),
		--EQ T_TIPO_PLAZAS(null,null,'H005_BPMTramiteSubsanacionEmbargo1','300*24*60*60*1000L','0','0','DD'),
		--EQ T_TIPO_PLAZAS(null,null,'H005_declararIVAeIGIC','3*24*60*60*1000L','0','0','DD')
		--EQ T_TIPO_PLAZAS(null,null,'H005_notificacionDecretoAdjudicacionAlContrario','damePlazo(valores[''H005_notificacionDecretoAdjudicacionAEntidad''][''fecha''])+30*24*60*60*1000L','0','0','DD'),
		--EQ T_TIPO_PLAZAS(null,null,'H005_BPMTramiteNotificacion','300*24*60*60*1000L','0','0','DD'),
		--EQ T_TIPO_PLAZAS(null,null,'H005_SolicitudTestimonioDecretoAdjudicacion','damePlazo(valores[''H005_notificacionDecretoAdjudicacionAlContrario''][''fecha'']) + 3*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H005_ConfirmarTestimonio','damePlazo(valores[''H005_SolicitudTestimonioDecretoAdjudicacion''][''fecha'']) + 20*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H005_RevisionComAdicional','2*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H005_NotifComAdicional','damePlazo(valores[''H005_ConfirmarTestimonio'']!=null && valores[''H005_ConfirmarTestimonio''][''fechaLimite'']!=null ? valores[''H005_ConfirmarTestimonio''][''fechaLimite''] : valores[''H005_notificacionDecretoAdjudicacionAEntidad''][''fechaLimite'']) - 1*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H005_BPMProvisionFondos','300*24*60*60*1000L','0','0','DD'),
		--EQ T_TIPO_PLAZAS(null,null,'H005_BPMTramiteDePosesion','300*24*60*60*1000L','0','0','DD'),
		--EQ T_TIPO_PLAZAS(null,null,'H005_BPMTramiteSubsanacionEmbargo2','300*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H005_RegistrarPresentacionEnRegistro','damePlazo(valores[''H005_ConfirmarTestimonio''][''fechaTestimonio'']) + 20*24*60*60*1000L','0','0','DD'),
		--EQ T_TIPO_PLAZAS(null,null,'H005_RegistrarInscripcionDelTitulo','damePlazo(valores[''H005_RegistrarPresentacionEnRegistro''][''fechaPresentacion'']) + 18*24*60*60*1000L','0','0','DD'),
		--EQ T_TIPO_PLAZAS(null,null,'H005_BPMTramiteSubsanacionEmbargo3','300*24*60*60*1000L','0','0','DD'),
		--DEL T_TIPO_PLAZAS(null,null,'H005_RegistrarEntregaTitulo','damePlazo(valores[''H005_ConfirmarTestimonio''][''fechaTestimonio''])+7*24*60*60*1000L','0','0','DD'),
		--DEL T_TIPO_PLAZAS(null,null,'H005_RegistrarPresentacionEnHacienda','damePlazo(valores[''H005_ConfirmarTestimonio''][''fechaTestimonio'']) + 5*24*60*60*1000L','0','0','DD'),
		--DEL T_TIPO_PLAZAS(null,null,'H005_ConfirmarContabilidad','7*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H005_RevisarInfoContable','2*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H005_ConfirmarContabilidad','1*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H005_BPMNotifNotarialOcupante','300*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H005_BPMCertfLibertadArrendamiento','300*24*60*60*1000L','0','0','DD')
		
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(

		--EQ T_TIPO_TFI('H005_SolicitudDecretoAdjudicacion','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Tanto si en la subasta no han concurrido postores, como si SAREB ha resultado mejor postor, el letrado deberá solicitar la adjudicación a favor de SAREB con reserva de la facultad de ceder el remate, por lo que a través de esta tarea deberá de informar la fecha de presentación en el Juzgado del escrito de solicitud del Decreto de Adjudicación.En caso de no haber un bien ya vinculado al procedimiento, antes de dar por completada esta tarea el sistema le obligará a asociarlo a través de la pestaña bienes del procedimiento el bien que corresponda.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; "><span style="font-size: 8pt;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzará la tarea "Notificación decreto de adjudicación a la entidad".</p></div>',null,null,null,null,'0','DD'),
		--EQ T_TIPO_TFI('H005_SolicitudDecretoAdjudicacion','1','date','fechaSolicitud','Fecha Solicitud','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		--EQ T_TIPO_TFI('H005_SolicitudDecretoAdjudicacion','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H005_notificacionDecretoAdjudicacionAEntidad','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">A través de esta pantalla deberá de informar la fecha en la que se notifica, por el Juzgado el Decreto de Adjudicación, la entidad adjudicataria de los bienes afectos, así como la fecha de la resolución del juzgado.</p><p style="margin-bottom: 10px;">Deberá revisar que el Decreto es conforme a la subasta celebrada y contiene lo preceptuado para su correcta inscripción en el Registro de la Propiedad, para ello deberá revisar:</p><p style="margin-bottom: 10px;">- Datos procesales básicos: (Nº autos, tipo de procedimiento, cantidad reclamada)</p><p style="margin-bottom: 10px;">- Datos de la Entidad demandante (nombre CIF, domicilio) y de los adjudicatarios</p><p style="margin-bottom: 10px;">- Datos  de los demandados y titulares registrales.</p><p style="margin-bottom: 10px;">- Importe de adjudicación.</p><p style="margin-bottom: 10px;">- Orden de cancelación de la nota marginal y cancelación de la carga objeto de ejecución así como cargas posteriores.</p><p style="margin-bottom: 10px;">- Descripción y datos registrales completos de la finca adjudicada.</p><p style="margin-bottom: 10px;">- Declaración en el auto de la firmeza de la resolución.</p><p style="margin-bottom: 10px;">Una vez analizados los puntos descritos, en el campo Requiere subsanación deberá indicar el resultado de dicho análisis.</p><p style="margin-bottom: 10px;">En el campo Comunicación adicional requerida, deberá indicarse si es necesario, en función de la legislación vigente en la Comunidad Autónoma donde se encuentra ubicado el bien, realizar notificación a la oficina de la vivienda que corresponda.</p><p style="margin-bottom: 10px;">Si es necesaria una comunicación adicional, se informará además la fecha límite de acuerdo con la legislación aplicable.</p><p style="margin-bottom: 10px;">Una vez emitido el  Decreto de Adjudicación y si la operación está sujeta a IVA o IGIC, se lanzará la tarea "Declarar IVA/IGIC". Es necesario revisar la ficha del bien para verificar que está informado el tipo de tributación. En caso de que no estuviese informado, deberá enviar notificación a la entidad para le informe del tipo de tributación y completar este dato en la ficha del Bien.</p><p style="margin-bottom: 10px;">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">Una vez rellene esta pantalla:</p><p style="margin-bottom: 10px;">-En caso de requerir subsanación, se lanzará el "Trámite de subsanación de decreto de adjudicación".</p><p style="margin-bottom: 10px;">-En caso contrario se lanzará la tarea “Notificación decreto adjudicación al contrario" por un lado y por otro, si el bien ha sido adjudicado a la entidad, se lanzará el "Trámite de saneamiento de cargas" si existen cargas previas. Si no existen cargas se lanzará la tarea "Revisar  y obtener información contable".</p><p style="margin-bottom: 10px;">-En caso de que sea necesario comunicación adicional, se lanzará la tarea "Revisión documentación y comunicación adicional".</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H005_notificacionDecretoAdjudicacionAEntidad','1','date','fecha','Fecha notificación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H005_notificacionDecretoAdjudicacionAEntidad','2','date','fechaResol','Fecha resolución','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H005_notificacionDecretoAdjudicacionAEntidad','3','combo','comboSubsanacion','Requiere Subsanación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('H005_notificacionDecretoAdjudicacionAEntidad','4','combo','comboAdicional','Comunicación adicional requerida',null,null,null,'DDSiNo','0','DD'),
		T_TIPO_TFI('H005_notificacionDecretoAdjudicacionAEntidad','5','date','fechaLimite','Fecha límite comunicación',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H005_notificacionDecretoAdjudicacionAEntidad','6','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		--EQ T_TIPO_TFI('H005_BPMTramiteSaneamientoCargas','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Saneamiento de Cargas.</p></div>',null,null,null,null,'0','DD'),
		--EQ T_TIPO_TFI('H005_BPMTramiteSubsanacionEmbargo1','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Subsanación de Embargo.</p></div>',null,null,null,null,'0','DD'),
		--EQ T_TIPO_TFI('H005_declararIVAeIGIC','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez emitido el auto decreto de adjudicaci&oacute;n, se deber&aacute; realizar la declaraci&oacute;n en funci&oacute;n del tipo de tributaci&oacute;n definido en el informe fiscal. En el caso de el tipo de tributaci&oacute;n sea IVA sujeto y deducible, adem&aacute;s de la declaraci&oacute;n se deber&aacute; auto emitir una factura.</p><p style="margin-bottom: 10px">Se indicar&aacute; la fecha en la que se ha declarado el IVA/IGIC de la operaci&oacute;n.</p><p style="margin-bottom: 10px">En el campo Observaciones infomar de cualquier aspecto relevante que le interese quede reflejado en este punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
		--EQ T_TIPO_TFI('H005_declararIVAeIGIC','1','date','fecha','Fecha declaraci&oacute;n IVA/IGIC','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		--EQ T_TIPO_TFI('H005_declararIVAeIGIC','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD')
		--EQ T_TIPO_TFI('H005_notificacionDecretoAdjudicacionAlContrario','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A trav&eacute;s de esta pantalla se deber&aacute; informar del resultado de la notificaci&oacute;n del decreto de adjudicaci&oacute;n a la parte ejecutada, en caso de notificaci&oacute;n positiva se informar&aacute; de la fecha de notificaci&oacute;n del Decreto de Adjudicaci&oacute;n.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzar&aacute;, en caso de notificaci&oacute;n negativa a la parte contraria el tr&aacute;mite de notificaci&oacute;n, y en caso contrario la tarea "Solicitud de testimonio de decreto de adjudicaci&oacute;n".</p></div>',null,null,null,null,'0','DD'),
		--EQ T_TIPO_TFI('H005_notificacionDecretoAdjudicacionAlContrario','1','combo','comboNotificacion','Notificado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		--EQ T_TIPO_TFI('H005_notificacionDecretoAdjudicacionAlContrario','2','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		--EQ T_TIPO_TFI('H005_notificacionDecretoAdjudicacionAlContrario','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		--EQ T_TIPO_TFI('H005_BPMTramiteNotificacion','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Notificación.</p></div>',null,null,null,null,'0','DD'),
		--EQ T_TIPO_TFI('H005_SolicitudTestimonioDecretoAdjudicacion','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por completada esta tarea deber&aacute; de informar la Fecha de solicitud del testimonio de decreto de adjudicaci&oacute;n.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzar&aacute;, en caso de notificaci&oacute;n negativa a la parte contraria el tr&aacute;mite de notificaci&oacute;n, y en caso contrario la tarea "Confirmar testimonio decreto de adjudicaci&oacute;n".</p></div>',null,null,null,null,'0','DD'),
		--EQ T_TIPO_TFI('H005_SolicitudTestimonioDecretoAdjudicacion','1','date','fecha','Fecha Solicitud','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		--EQ T_TIPO_TFI('H005_SolicitudTestimonioDecretoAdjudicacion','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H005_ConfirmarTestimonio','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">A través de esta pantalla se ha de marcar la fecha que el Juzgado hace entrega del Testimonio del Decreto a favor de la Entidad. Se ha de tener en cuenta que desde la fecha que se indique en esta pantalla se inicia el plazo para liquidar los impuestos que correspondan.</p><p style="margin-bottom: 10px;">Con el objeto de evitar calificaciones desfavorables y subsanaciones posteriores que retrasan la inscripción deberá:</p><p style="margin-bottom: 10px;">Obtenido el testimonio, revisar la fecha de expedición para liquidación de impuestos en plazo, según normativa de CCAA. La verificación de la fecha del título es necesaria y fundamental para que la gestoría pueda realizar la liquidación en plazo.</p><p style="margin-bottom: 10px;">Adicionalmente se revisarán el contenido fundamental y de forma, para evitar subsanaciones posteriores que retrasen la inscripción.</p><p style="margin-bottom: 10px;">Contenido básico para revisar en testimonio decreto de adjudicación  y mandamientos: </p><p style="margin-bottom: 10px;">- Datos procesales básicos: (Nº autos, tipo de procedimiento, cantidad reclamada).</p><p style="margin-bottom: 10px;">- Datos de la Entidad demandante (nombre CIF, domicilio) y en su caso de los adjudicados.</p><p style="margin-bottom: 10px;">- Datos  de los demandados y titulares registrales.</p><p style="margin-bottom: 10px;">- Importe de adjudicación y cesión de remate (en su caso).</p><p style="margin-bottom: 10px;">- Orden de cancelación de la nota marginal y cancelación de la carga objeto de ejecución así como cargas posteriores.</p><p style="margin-bottom: 10px;">- Descripción y datos registrales completos de la finca adjudicada.</p><p style="margin-bottom: 10px;">- Declaración en el auto de la firmeza de la resolución.</p><p style="margin-bottom: 10px;">Una vez analizados los puntos descritos, en el campo Requiere subsanación deberá indicar el resultado de dicho análisis.</p><p style="margin-bottom: 10px;">En el campo ""Comunicación adicional requerida"", deberá indicarse si es necesario, en función de la legislación vigente en la Comunidad Autónoma del bien, realizar notificación a la oficina de la vivienda. Si es necesaria una comunicación adicional, se informará además la fecha límite de acuerdo con la legislación aplicable.</p><p style="margin-bottom: 10px;">En el supuesto de que haya constancia en el procedimiento de que hay ocupantes en el bien, deberá indicarlo en el campo pertinente.</p><p style="margin-bottom: 10px;">Para dar por terminada esta tarea deberá de adjuntar al procedimiento correspondiente una copia escaneada del decreto firme de adjudicación.</p><p style="margin-bottom: 10px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">Una vez rellene esta pantalla:</p><p style="margin-bottom: 10px;">-En caso de requerir subsanación, se lanzará el "Trámite de subsanación de decreto de adjudicación".</p><p style="margin-bottom: 10px;">-Se lanzará el "Trámite de provisión de fondos".</p><p style="margin-bottom: 10px;">-Se lanzará el "Trámite de Posesión".</p><p style="margin-bottom: 10px;">-En caso de que sea necesario comunicación adicional, se lanzará la tarea "Revisión documentación y comunicación adicional".</p><p style="margin-bottom: 10px;">-En caso de que haya indicado que hay constancia en el procedimiento de que hay ocupantes, se lanzará el trámite de "Notificación notarial de ocupantes". En caso contrario, se lanzará el trámite de "Certificado libertad de arrendamiento".</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H005_ConfirmarTestimonio','1','date','fechaTestimonio','Fecha Testimonio','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H005_ConfirmarTestimonio','2','combo','comboSubsanacion','Requiere Subsanación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('H005_ConfirmarTestimonio','3','combo','comboAdicional','Comunicación adicional requerida',null,null,null,'DDSiNo','0','DD'),
		T_TIPO_TFI('H005_ConfirmarTestimonio','4','date','fechaLimite','Fecha límite comunicación',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H005_ConfirmarTestimonio','5','combo','comboOcupantes','Constancia de ocupantes',null,null,null,'DDSiNo','0','DD'),
		T_TIPO_TFI('H005_ConfirmarTestimonio','6','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H005_RevisionComAdicional','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">Puesto que en la tarea anterior ha indicado que se requiere de comunicación adicional, para cerrar esta tarea se deberá revisar la documentación y los requisitos de comunicación. </p><p style="margin-bottom: 10px;">En el campo Fecha deberá indicar la fecha en la que completa esta tarea.</p><p style="margin-bottom: 10px;">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">La siguiente tarea será "Notificación comunicación adicional"</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H005_RevisionComAdicional','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H005_RevisionComAdicional','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H005_NotifComAdicional','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">Deberá informarse la fecha en que se realizó la comunicación pertinente y adjuntar el documento que acredite la comunicación realizada.</p><p style="margin-bottom: 10px;">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H005_NotifComAdicional','1','date','fecha','Fecha comunicacion','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H005_NotifComAdicional','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H005_BPMProvisionFondos','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Provisión de fondos.</p></div>',null,null,null,null,'0','DD'),
		--EQ T_TIPO_TFI('H005_BPMTramiteDePosesion','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Posesión.</p></div>',null,null,null,null,'0','DD'),
		--EQ T_TIPO_TFI('H005_BPMTramiteSubsanacionEmbargo2','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Subsanación de Embargo.</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H005_RegistrarPresentacionEnRegistro','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">En caso de que se haya tenido que presentar subsanación y por tanto estemos a la espera de recibir el nuevo testimonio decreto de adjudicación, en el campo fecha nuevo testimonio se debe informar de la fecha en la que se recibe el nuevo testimonio</p><p style="margin-bottom: 10px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">Una vez rellene esta pantalla se lanzará la tarea "Registrar inscripción del título".</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H005_RegistrarPresentacionEnRegistro','1','date','fechaPresentacion','Fecha Presentación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H005_RegistrarPresentacionEnRegistro','2','date','fechaNuevoTest','Fecha nuevo testimonio',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H005_RegistrarPresentacionEnRegistro','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H005_RegistrarInscripcionDelTitulo','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">Para dar por terminada esta tarea deberá indicar la situación en que queda el título ya sea inscrito en el registro o pendiente de subsanación, a través de la ficha del bien correspondiente deberá de actualizar los campos: folio, libro, tomo, inscripción Xª, referencia catastral, porcentaje de propiedad, nº de finca (si hubiera cambios deberá actualizarlos). Una vez actualizados estos campos deberá de marcar la fecha de actualización en la ficha del bien.</p><p style="margin-bottom: 10px;">En caso de haberse producido una resolución desfavorable y haber marcado el bien en situación “Subsanar”, deberá informar la fecha de envío de decreto para adición y proceder a la remisión de los documentos al Procurador e informa al Letrado.</p><p style="margin-bottom: 10px;">En caso de haber quedado inscrito el bien, deberá informar la fecha en que se haya producido dicha inscripción.</p><p style="margin-bottom: 10px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">Una vez rellene esta pantalla se lanzará, en caso de requerir subsanación, el Trámite de subsanación de decreto de adjudicación a realizar por el letrado. En caso contrario habrá finalizado el trámite.</p></div>',null,null,null,null,'1','DD'),
		T_TIPO_TFI('H005_RegistrarInscripcionDelTitulo','1','combo','comboSituacionTitulo','Título Inscrito en el Registro','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSituacionTitulo','0','DD'),
		T_TIPO_TFI('H005_RegistrarInscripcionDelTitulo','2','date','fechaInscripcion','Fecha Inscripción',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H005_RegistrarInscripcionDelTitulo','3','date','fechaEnvioDecretoAdicion','Fecha Envío Decreto Adición',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H005_RegistrarInscripcionDelTitulo','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		--EQ T_TIPO_TFI('H005_BPMTramiteSubsanacionEmbargo3','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Subsanación de Embargo.</p></div>',null,null,null,null,'0','DD'),
		--DEL T_TIPO_TFI('H005_RegistrarEntregaTitulo','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A trav&eacute;s de esta pantalla deber&aacute; de informar de la fecha en que recibe la informaci&oacute;n sobre los documentos asignados que se le han enviado.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por terminada esta tarea deber&aacute;:<br>- Liquidar impuestos  en  plazo  seg&uacute;n CCAA. En caso de personas jur&iacute;dicas existir&aacute; una consulta previa realizada sobre la posible liquidaci&oacute;n de IVA. Esta informaci&oacute;n podr&aacute; consultarla a trav&eacute;s de la ficha de cada uno de los bienes incluidos.<br>- Verificar situaci&oacute;n ocupacional de la finca para manifestaci&oacute;n de libertad arrendamientos de cara a inscripci&oacute;n (LAU).<br>- Redactar en su caso, certificado de Libertad de Arrendamiento (por poder de la Entidad), para presentaci&oacute;n  en el registro junto con el testimonio y los mandamientos.<br>- Realizar notificaci&oacute;n fehaciente a inquilinos para la inscripci&oacute;n  (en casos de inmueble con arrendamiento reconocido)</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzar&aacute; la tarea "Registrar presentaci&oacute;n en hacienda".</p></div>',null,null,null,null,'0','DD'),
		--DEL T_TIPO_TFI('H005_RegistrarEntregaTitulo','1','date','fechaRecepcion','Fecha de Recepción','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		--DEL T_TIPO_TFI('H005_RegistrarEntregaTitulo','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		--DEL T_TIPO_TFI('H005_RegistrarPresentacionEnHacienda','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deber&aacute; presentar la liquidaci&oacute;n del testimonio en Hacienda, una vez realizado esto deber&aacute; adjuntar al procedimiento correspondiente copia escaneada del documento de liquidaci&oacute;n de impuestos.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzar&aacute; la tarea "Registrar presentaci&oacute;n en el registro".</p></div>',null,null,null,null,'0','DD'),
		--DEL T_TIPO_TFI('H005_RegistrarPresentacionEnHacienda','1','date','fechaPresentacion','Fecha Presentación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		--DEL T_TIPO_TFI('H005_RegistrarPresentacionEnHacienda','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		--DEL T_TIPO_TFI('H005_ConfirmarContabilidad','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Desde Soporte Deuda,  deben confirmar en esta tarea que han realizado la contabilizaci&oacute;n del bien adjudicado, una vez se reciba el testimonio  de decreto de adjudicaci&oacute;n.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo Observaciones informar cualquier aspecto relevante que le interese quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
		--DEL T_TIPO_TFI('H005_ConfirmarContabilidad','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		--DEL T_TIPO_TFI('H005_ConfirmarContabilidad','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H005_RevisarInfoContable','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">Antes de dar por finalizada esta tarea deberá revisar que dispone de la siguiente información en la herramienta:</p><p style="margin-bottom: 10px;">-Decreto de adjudicación en la pestaña Adjuntos de la actuación</p><p style="margin-bottom: 10px;">-Tasación del bien, en la ficha del Bien</p><p style="margin-bottom: 10px;">En esta pantalla deberá indicar cómo distribuye el importe cobrado en los diferentes conceptos.</p><p style="margin-bottom: 10px;">Si la operación es titulizada o si requiere  autorización, deberá solicitar autorización a la entidad para la contabilidad del bien. </p><p style="margin-bottom: 10px;">En el campo Fecha deberá indicar la fecha en la que realiza las gestiones.</p><p style="margin-bottom: 10px;">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">Una vez rellene esta pantalla, se lanzará la tarea "Confirmar Contabilidad".</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H005_RevisarInfoContable','1','date','fecha','Fecha Presentación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H005_RevisarInfoContable','2','currency','nominal','Nominal','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H005_RevisarInfoContable','3','currency','intereses','Intereses','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H005_RevisarInfoContable','4','currency','demora','Demora','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H005_RevisarInfoContable','5','currency','gAbogado','Gastos abogado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H005_RevisarInfoContable','6','currency','gProcurador','Gastos procurador','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H005_RevisarInfoContable','7','currency','gOtros','Otros gastos','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H005_RevisarInfoContable','8','currency','aOpTramite','A op. trámite','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H005_RevisarInfoContable','9','currency','tEntregas','Total entregas a pendiente','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H005_RevisarInfoContable','10','combo','cbTipoEntrega','Tipo de entrega','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDAdjContableTipoEntrega','0','DD'),
		T_TIPO_TFI('H005_RevisarInfoContable','11','combo','cbConcepto','Concepto de entrega','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDAdjContableConceptoEntrega','0','DD'),
		T_TIPO_TFI('H005_RevisarInfoContable','12','currency','paseFallido','Pase a fallido','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H005_RevisarInfoContable','13','currency','qNominal','Quita Nominal','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H005_RevisarInfoContable','14','currency','qIntereses','Quita Intereses','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H005_RevisarInfoContable','15','currency','qDemoras','Quita Demoras','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H005_RevisarInfoContable','16','currency','tQuitasGastos','Total Quita Gastos','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H005_RevisarInfoContable','17','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H005_ConfirmarContabilidad','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">Antes de finalizar esta tarea podrá consultar la siguiente información en la pestaña "Adjuntos" del procedimiento:</p><p style="margin-bottom: 10px;">-Decreto de adjudición</p><p style="margin-bottom: 10px;">-Tasación del bien, en la ficha del Bien</p><p style="margin-bottom: 10px;">En esta pantalla le aperecerá preinformado el importe a contabilizar en cada uno de los diferentes conceptos de acuerdo a lo indicado por el gestor en la tarea previa.</p><p style="margin-bottom: 10px;">En este tarea debe confirmar la fecha en la que ha realizado la contabilización de la operación.</p><p style="margin-bottom: 10px;">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese procedimiento.</p><p style="margin-bottom: 10px;">Una vez rellene esta pantalla finalizará el trámite.</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H005_ConfirmarContabilidad','1','date','fecha','Fecha Presentación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H005_ConfirmarContabilidad','2','currency','nominal','Nominal',null,null,'valores[''H005_RevisarInfoContable''][''nominal'']',null,'0','DD'),
		T_TIPO_TFI('H005_ConfirmarContabilidad','3','currency','intereses','Intereses',null,null,'valores[''H005_RevisarInfoContable''][''intereses'']',null,'0','DD'),
		T_TIPO_TFI('H005_ConfirmarContabilidad','4','currency','demora','Demora',null,null,'valores[''H005_RevisarInfoContable''][''demora'']',null,'0','DD'),
		T_TIPO_TFI('H005_ConfirmarContabilidad','5','currency','gAbogado','Gastos abogado',null,null,'valores[''H005_RevisarInfoContable''][''gAbogado'']',null,'0','DD'),
		T_TIPO_TFI('H005_ConfirmarContabilidad','6','currency','gProcurador','Gastos procurador',null,null,'valores[''H005_RevisarInfoContable''][''gProcurador'']',null,'0','DD'),
		T_TIPO_TFI('H005_ConfirmarContabilidad','7','currency','gOtros','Otros gastos',null,null,'valores[''H005_RevisarInfoContable''][''gOtros'']',null,'0','DD'),
		T_TIPO_TFI('H005_ConfirmarContabilidad','8','currency','aOpTramite','A op. trámite',null,null,'valores[''H005_RevisarInfoContable''][''aOpTramite'']',null,'0','DD'),
		T_TIPO_TFI('H005_ConfirmarContabilidad','9','currency','tEntregas','Total entregas a pendiente',null,null,'valores[''H005_RevisarInfoContable''][''tEntregas'']',null,'0','DD'),
		T_TIPO_TFI('H005_ConfirmarContabilidad','10','combo','cbTipoEntrega','Tipo de entrega',null,null,'valores[''H005_RevisarInfoContable''][''cbTipoEntrega'']','DDAdjContableTipoEntrega','0','DD'),
		T_TIPO_TFI('H005_ConfirmarContabilidad','11','combo','cbConcepto','Concepto de entrega',null,null,'valores[''H005_RevisarInfoContable''][''cbConcepto'']','DDAdjContableConceptoEntrega','0','DD'),
		T_TIPO_TFI('H005_ConfirmarContabilidad','12','currency','paseFallido','Pase a fallido',null,null,'valores[''H005_RevisarInfoContable''][''paseFallido'']',null,'0','DD'),
		T_TIPO_TFI('H005_ConfirmarContabilidad','13','currency','qNominal','Quita Nominal',null,null,'valores[''H005_RevisarInfoContable''][''qNominal'']',null,'0','DD'),
		T_TIPO_TFI('H005_ConfirmarContabilidad','14','currency','qIntereses','Quita Intereses',null,null,'valores[''H005_RevisarInfoContable''][''qIntereses'']',null,'0','DD'),
		T_TIPO_TFI('H005_ConfirmarContabilidad','15','currency','qDemoras','Quita Demoras',null,null,'valores[''H005_RevisarInfoContable''][''qDemoras'']',null,'0','DD'),
		T_TIPO_TFI('H005_ConfirmarContabilidad','16','currency','tQuitasGastos','Total Quita Gastos',null,null,'valores[''H005_RevisarInfoContable''][''tQuitasGastos'']',null,'0','DD'),
		T_TIPO_TFI('H005_ConfirmarContabilidad','17','textarea','obsContables','Observaciones contables',null,null,'valores[''H005_RevisarInfoContable''][''observaciones'']',null,'0','DD'),
		T_TIPO_TFI('H005_ConfirmarContabilidad','18','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H005_BPMNotifNotarialOcupante','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Notificación notarial de ocupantes.</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H005_BPMCertfLibertadArrendamiento','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Certificado libertad de arrendamiento.</p></div>',null,null,null,null,'0','DD')
		
	); 
    V_TMP_TIPO_TFI T_TIPO_TFI;
    
    V_TAREA VARCHAR(50 CHAR);
    
BEGIN	
	
	
	/* ------------------- -------------------------- */
	/* --------------  ACTUALIZACIONES --------------- */
	/* ------------------- -------------------------- */

	
	V_TAREA:='H005_SolicitudDecretoAdjudicacion';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items SET ' ||
	  ' tfi_label=''<div align="justify" style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="margin-bottom: 10px;">Tanto si en la subasta no han concurrido postores, como si la entidad ha resultado mejor postor, el letrado deberá solicitar la adjudicación a favor de la entidad con reserva de la facultad de ceder el remate, por lo que a través de esta tarea deberá de informar la fecha de presentación en el Juzgado del escrito de solicitud del Decreto de Adjudicación.</p><p style="margin-bottom: 10px;">En caso de no haber un bien ya vinculado al procedimiento, antes de dar por completada esta tarea el sistema le obligará a asociarlo a través de la pestaña bienes del procedimiento el bien que corresponda.</p><p style="margin-bottom: 10px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">Una vez rellene esta pantalla se lanzará la tarea "Notificación decreto de adjudicación a la entidad".</p></div>''' ||
	  ' WHERE tfi_nombre=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	
	-- BORRADO DE TAREA (lógico)
	V_TAREA:='H005_notificacionDecretoAdjudicacionAEntidad';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''DEL_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''GONZALO'' WHERE TAP_CODIGO='''||V_TAREA||'''';

	V_TAREA:='H005_notificacionDecretoAdjudicacionAlContrario';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_ALERT_VUELTA_ATRAS=NULL WHERE TAP_CODIGO='''||V_TAREA||'''';
	
	V_TAREA:='H005_SolicitudTestimonioDecretoAdjudicacion';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_ALERT_VUELTA_ATRAS=NULL WHERE TAP_CODIGO='''||V_TAREA||'''';
	
	-- BORRADO DE TAREA (lógico)
	V_TAREA:='H005_ConfirmarTestimonio';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''DEL_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''GONZALO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	
	V_TAREA:='H005_RegistrarPresentacionEnRegistro';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	
	V_TAREA:='H005_RegistrarInscripcionDelTitulo';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION=''comprobarExisteDocumentoNOSI() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar la Nota simple.</div>'' WHERE TAP_CODIGO='''||V_TAREA||'''';


	-- BORRADO DE TAREA (lógico)
	V_TAREA:='H005_RegistrarEntregaTitulo';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''DEL_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''GONZALO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	-- BORRADO DE TAREA (lógico)
	V_TAREA:='H005_RegistrarPresentacionEnHacienda';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''DEL_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''GONZALO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	-- BORRADO DE TAREA (lógico)
	V_TAREA:='H005_ConfirmarContabilidad';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''DEL_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''GONZALO'' WHERE TAP_CODIGO='''||V_TAREA||'''';

	--V_TAREA:='H005_notificacionDecretoAdjudicacionAlContrario';
	--EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW=''plugin/cajamar/tramiteAdjudicacion/notifDecAdjuContrario'',TAP_SCRIPT_VALIDACION_JBPM=''valores['''''||V_TAREA||'''''][''''comboNotificacion'''']==DDSiNo.SI && valores['''''||V_TAREA||'''''][''''fecha'''']==null ? ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe indicar la fecha de notificaci&oacute;n.</div>'''' : null'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	--EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items SET TFI_ERROR_VALIDACION=NULL,TFI_VALIDACION=NULL WHERE TFI_NOMBRE=''fecha'' TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	
	V_TAREA:='H005_declararIVAeIGIC';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS WHERE TFI_NOMBRE IN (''fecha'', ''observaciones'') AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez emitido el auto decreto de adjudicaci&oacute;n, la entidad deber&aacute; realizar la declaraci&oacute;n en funci&oacute;n del tipo de tributaci&oacute;n definido en el informe fiscal. En el caso de el tipo de tributaci&oacute;n sea IVA sujeto y deducible, adem&aacute;s de la declaraci&oacute;n la entidad deber&aacute; auto emitir una factura.</p></div>'' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET DD_TPO_ID_BPM = (SELECT DD_TPO_ID FROM '||V_ESQUEMA ||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''HCJ001''), TAP_CODIGO = ''H005_BPMDeclaracionIVAIGIC'' WHERE TAP_CODIGO = '''||V_TAREA||''')';
	
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
