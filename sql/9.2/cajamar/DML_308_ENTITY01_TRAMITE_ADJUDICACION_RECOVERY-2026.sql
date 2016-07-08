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
		T_TIPO_TAP('CJ067','CJ067_BPMTramiteDePosesion' ,null ,null ,null ,null ,'CJ015' ,'0','Llamada al BPM de Trámite de Trámite de Posesión' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ067','CJ067_BPMTramiteNotificacion' ,null ,null ,null ,null ,'P400' ,'0','Llamada al BPM de Trámite de Trámite de Notificación' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ067','CJ067_BPMTramiteSaneamientoCargas' ,null ,null ,null ,null ,'CJ008' ,'0','Llamada al BPM de Trámite de Trámite de Saneamiento de Cargas' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ067','CJ067_BPMTramiteSubsanacionEmbargo1' ,null ,null ,null ,null ,'CJ052' ,'0','Llamada al BPM de Trámite de Subsanación de Adjudicación' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ067','CJ067_BPMTramiteSubsanacionEmbargo2' ,null ,null ,null ,null ,'CJ052' ,'0','Llamada al BPM de Trámite de Subsanación de Adjudicación' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ067','CJ067_BPMTramiteSubsanacionEmbargo3' ,null ,null ,null ,null ,'CJ052' ,'0','Llamada al BPM de Trámite de Subsanación de Adjudicación' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ067','CJ067_RegistrarInscripcionDelTitulo' ,'plugin/procedimientos/genericFormOverSize' ,'comprobarExisteDocumentoNOSI() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar la Nota simple.</div>''' ,'(valores[''CJ067_RegistrarInscripcionDelTitulo''][''comboSituacionTitulo''] == ''INS'') ? ((valores[''CJ067_RegistrarInscripcionDelTitulo''][''fechaInscripcion''] == null || valores[''CJ067_RegistrarInscripcionDelTitulo''][''fechaInscripcion''] == '''') ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Si el t&iacute;tulo se ha inscrito, es necesario indicar la fecha de inscripci&oacute;n</div>'' : null ) : ((valores[''CJ067_RegistrarInscripcionDelTitulo''][''fechaEnvioDecretoAdicion''] == null || valores[''CJ067_RegistrarInscripcionDelTitulo''][''fechaEnvioDecretoAdicion''] == '''') ?  ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Si el t&iacute;tulo est&aacute; pde. subsanacion, es necesario indicar la fecha env&iacute;o decreto adici&oacute;n</div>'' : null )' ,'( valores[''CJ067_RegistrarInscripcionDelTitulo''][''comboSituacionTitulo''] == ''PEN'' ? ''SI'':''NO'')' ,null ,'0','Registrar Inscripción del Título' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ067','CJ067_RegistrarPresentacionEnRegistro' ,null ,null ,null ,null ,null ,'0','Registrar presentación en Registro' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ067','CJ067_SolicitudDecretoAdjudicacion' ,null ,'comprobarBienAsociadoPrc() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Este tr&aacute;mite requiere tener un solo bien asociado. Vaya a la pesta&nacute;a de bienes del procedimiento y aseg&uacute;rese de que hay un bien asociado y no m&aacute;s de uno.</div>'' ' ,null ,null ,null ,'0','Solicitud de Decreto de Adjudicación' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ067','CJ067_SolicitudTestimonioDecretoAdjudicacion' ,null ,null ,null ,null ,null ,'0','Solicitud de Testimonio del Decreto de Adjudicación' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ067','CJ067_notificacionDecretoAdjudicacionAlContrario' ,'plugin/cajamar/tramiteAdjudicacion/notificacionDecretoAdjudicacionAlContrario' ,null ,null ,'( valores[''CJ067_notificacionDecretoAdjudicacionAlContrario''][''comboNotificacion''] == DDSiNo.SI ? ''SI'':''NO'')' ,null ,'0','Notificación del Decreto de Adjudicación al Contrario' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ067','CJ067_BPMLiquidacionTributacionBienesBankia' ,null ,null ,null ,null ,null ,'0','Llamada al BPM de Trámite de Liquidacion de Tributacion en Bienes' ,'0','RECOVERY-2026','1' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ067','CJ067_BPMLiquidacionTributacionBienesSareb' ,null ,null ,null ,null ,null ,'0','Llamada al BPM de Trámite de Liquidacion de Tributacion en Bienes' ,'0','RECOVERY-2026','1' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ067','CJ067_DeclaracionIVAIGIC' ,null ,null ,null ,null ,null ,'0','Declarar IVA e IGIC' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ067','CJ067_notificacionDecretoAdjudicacionAEntidad' ,'plugin/cajamar/tramiteAdjudicacion/notifDecAdjuEntidad' ,'existeAdjuntoUG("DA","PRC")? null : existeAdjuntoUGMensaje("DA","PRC")' ,'comprobarInformadoComboTributacion() ? (comprobarComboComunicacionAdicionalNOTIFENT() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe indicar la si requiere comunicaci&oacute;n adicional y en caso afirmativo la fecha l&iacute;mite de comunicaci&oacute;n</div>'') : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario informar el tipo de tributaci&oacute;n</div>''' ,'valores[''CJ067_notificacionDecretoAdjudicacionAEntidad''][''comboSubsanacion'']==DDSiNo.SI ? ''SI'' : ''NO''' ,null ,'0','Notificación del Decreto de Adjudicación a Entidad' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ067','CJ067_ConfirmarTestimonio' ,'plugin/cajamar/tramiteAdjudicacion/confirmarTestimonio','!comprobarExisteDocumento(''MANCANCAR'') ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el documento "Mandamiento de cancelaci&oacute;n de cargas"</div>'' : null' ,'(valores[''CJ067_ConfirmarTestimonio''][''comboAdicional'']==DDSiNo.SI && valores[''CJ067_ConfirmarTestimonio''][''fechaLimite'']==null) ? ''Si requiere comunicaci&oacute;n adicional debe indicar la fecha l&iacute;mite de comunicaci&oacute;n'' : null' ,'valores[''CJ067_ConfirmarTestimonio''][''comboSubsanacion'']==DDSiNo.SI ? ''SI'' : (existeTipoGestor("CENTROPROCURA") ? ''ANTI'' : ''NO'')' ,null ,'0','Confirmar el Testimonio' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ067','CJ067_RevisionComAdicional' ,null ,null ,null ,null ,null ,'0','Revisión documentación y comunicación adicional' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ067','CJ067_NotifComAdicional' ,null ,'comprobarExisteDocumentoCOMAD() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el documento Comunicaci&oacute;n Adicional.</div>''' ,null ,null ,null ,'0','Notificación comunicación adicional' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ067','CJ067_BPMProvisionFondos' ,null ,null ,null ,null ,'HC103' ,'0','Se inicia el trámite de provisión de fondos' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ067','CJ067_RevisarInfoContable' ,null ,null ,null ,null ,null ,'0','Revisar y obtener información contable' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ067','CJ067_ConfirmarContabilidad' ,'plugin/cajamar/tramiteAdjudicacion/confirmarContabilidad' ,null ,null ,null ,null ,'0','Confirmar Contabilidad' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ067','CJ067_BPMNotifNotarialOcupante' ,null ,null ,null ,null ,null ,'0','Trámite de Notificación notarial de ocupantes' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ067','CJ067_BPMCertfLibertadArrendamiento' ,null ,null ,null ,null ,'HC101' ,'0','Trámite de Certificado libertad de arrendamiento' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ067','CJ067_ValorarLanzamiento' ,null ,null ,null ,'valores[''CJ067_ValorarLanzamiento''][''comboSolicitud''] == ''01'' ? ''Si'':''No''' ,null ,'0','Valorar lanzamiento trámite Solicitud de solvencia patrimonial' ,'0','RECOVERY-2026','0',null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ067','CJ067_RegistrarPresentacionHacienda' ,'plugin/cajamar/tramiteAdjudicacion/registrarPresentacionHacienda' ,null ,'valores[''CJ067_RegistrarPresentacionHacienda''][''comboLiquidacion''] == ''01'' ? (existeAdjuntoUG(''CALHAC'', ''PRC'') ? ((valores[''CJ067_RegistrarPresentacionHacienda''][''comboLiquidacion''] == ''01'' && valores[''CJ067_RegistrarPresentacionHacienda''][''fechaPresentacion''] == null) ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">El campo fecha de presentacion es obligatorio si Liquidaci&oacute;n testimonio es Si</div>'' : null) : (existeAdjuntoUGMensaje(''CALHAC'',''PRC''))) : null' ,null ,null ,'0','Registrar presentación en hacienda' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ067','CJ067_BPMTramiteSolicitudSolvenciaPatrimonial' ,null ,null ,null ,null ,'HC104' ,'0','Se inicia el trámite de solicitud solvencia patrimonial.' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ067','CJ067_BPMAnticipoFondos' ,null ,null ,null ,null ,'P460' ,'0','Se inicia el trámite de anticipo de fondos y pago de suplidos' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null)
    );
	V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
		T_TIPO_PLAZAS(null ,null ,'CJ067_SolicitudDecretoAdjudicacion','20*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ067_notificacionDecretoAdjudicacionAlContrario','damePlazo(valores[''CJ067_notificacionDecretoAdjudicacionAEntidad''][''fecha''])+30*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ067_SolicitudTestimonioDecretoAdjudicacion','damePlazo(valores[''CJ067_notificacionDecretoAdjudicacionAlContrario''][''fecha'']) + 3*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ067_RegistrarInscripcionDelTitulo','damePlazo(valores[''CJ067_RegistrarPresentacionEnRegistro''][''fechaPresentacion'']) + 18*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ067_BPMTramiteSubsanacionEmbargo1','300*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ067_BPMTramiteNotificacion','300*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ067_BPMTramiteDePosesion','300*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ067_BPMTramiteSaneamientoCargas','300*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ067_BPMTramiteSubsanacionEmbargo2','300*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ067_BPMTramiteSubsanacionEmbargo3','300*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ067_notificacionDecretoAdjudicacionAEntidad','damePlazo(valores[''CJ067_SolicitudDecretoAdjudicacion''][''fechaSolicitud'']) + 30*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ067_ConfirmarTestimonio','(valoresBPMPadre[''CJ052_RegistrarPresentacionEscritoSub''] != null && valoresBPMPadre[''CJ052_RegistrarPresentacionEscritoSub''][''fechaPresentacion''] != null) ?  (damePlazo(valoresBPMPadre[''CJ052_RegistrarPresentacionEscritoSub''][''fechaPresentacion'']) + 2*24*60*60*1000L) : (damePlazo(valores[''CJ067_SolicitudTestimonioDecretoAdjudicacion''][''fecha'']) + 20*24*60*60*1000L)' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ067_RevisionComAdicional','2*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ067_NotifComAdicional','damePlazo(valores[''CJ067_ConfirmarTestimonio'']!=null && valores[''CJ067_ConfirmarTestimonio''][''fechaLimite'']!=null ? valores[''CJ067_ConfirmarTestimonio''][''fechaLimite''] : valores[''CJ067_notificacionDecretoAdjudicacionAEntidad''][''fechaLimite'']) - 1*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ067_BPMProvisionFondos','300*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ067_RevisarInfoContable','10*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ067_ConfirmarContabilidad','5*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ067_BPMNotifNotarialOcupante','300*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ067_BPMCertfLibertadArrendamiento','300*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ067_DeclaracionIVAIGIC','3*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ067_RegistrarPresentacionEnRegistro','damePlazo(valores[''CJ067_ConfirmarTestimonio''][''fechaTestimonio'']) + 20*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ067_ValorarLanzamiento','5*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ067_RegistrarPresentacionHacienda','(valores[''CJ067_ConfirmarTestimonio''] !=null && valores[''CJ067_ConfirmarTestimonio''][''fechaTestimonio''] !=null) ? damePlazo(valores[''CJ067_ConfirmarTestimonio''][''fechaTestimonio'']) + 5*24*60*60*1000L : 5*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ067_BPMTramiteSolicitudSolvenciaPatrimonial','300*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ067_BPMAnticipoFondos','300*24*60*60*1000L' ,'0','0','RECOVERY-2026')
    ); 
	V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
		T_TIPO_TFI('CJ067_BPMTramiteDePosesion','0','label' ,'titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Posesión.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_BPMTramiteNotificacion','0','label' ,'titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Notificación.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_BPMTramiteSaneamientoCargas','0','label' ,'titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Saneamiento de Cargas.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_BPMTramiteSubsanacionEmbargo1','0','label' ,'titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Subsanación de Embargo.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_BPMTramiteSubsanacionEmbargo2','0','label' ,'titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Subsanación de Embargo.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_BPMTramiteSubsanacionEmbargo3','0','label' ,'titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Subsanación de Embargo.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RegistrarInscripcionDelTitulo','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">Para dar por terminada esta tarea deberá indicar la situación en que queda el título ya sea inscrito en el registro o pendiente de subsanación, a través de la ficha del bien correspondiente deberá de actualizar los campos: folio, libro, tomo, inscripción Xª, referencia catastral, porcentaje de propiedad, nº de finca (si hubiera cambios deberá actualizarlos). Una vez actualizados estos campos deberá de marcar la fecha de actualización en la ficha del bien.</p><p style="margin-bottom: 10px;">En caso de haberse producido una resolución desfavorable y haber marcado el bien en situación “Subsanar”, deberá informar la fecha de envío de decreto para adición y proceder a la remisión de los documentos al Procurador e informa al Letrado.</p><p style="margin-bottom: 10px;">En caso de haber quedado inscrito el bien, deberá informar la fecha en que se haya producido dicha inscripción.</p><p style="margin-bottom: 10px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">Una vez rellene esta pantalla se lanzará, en caso de requerir subsanación, el Trámite de subsanación de decreto de adjudicación a realizar por el letrado. En caso contrario habrá finalizado el trámite.</p></div>' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RegistrarInscripcionDelTitulo','1','combo' ,'comboSituacionTitulo','Título Inscrito en el Registro' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSituacionTitulo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RegistrarInscripcionDelTitulo','2','date' ,'fechaInscripcion','Fecha Inscripción' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RegistrarInscripcionDelTitulo','3','date','fechaEnvioDecretoAdicion','Fecha Envío Decreto Adición' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RegistrarInscripcionDelTitulo','4','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RegistrarPresentacionEnRegistro','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">En caso de que se haya tenido que presentar subsanación y por tanto estemos a la espera de recibir el nuevo testimonio decreto de adjudicación, en el campo fecha nuevo testimonio se debe informar de la fecha en la que se recibe el nuevo testimonio</p><p style="margin-bottom: 10px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">Una vez rellene esta pantalla se lanzará la tarea "Registrar inscripción del título".</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RegistrarPresentacionEnRegistro','1','date' ,'fechaPresentacion','Fecha Presentación' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RegistrarPresentacionEnRegistro','2','date' ,'fechaNuevoTest','Fecha nuevo testimonio' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RegistrarPresentacionEnRegistro','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_SolicitudDecretoAdjudicacion','0','label' ,'titulo','<div align="justify" style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="margin-bottom: 10px;">Tanto si en la subasta no han concurrido postores, como si la entidad ha resultado mejor postor, el letrado deberá solicitar la adjudicación a favor de la entidad con reserva de la facultad de ceder el remate, por lo que a través de esta tarea deberá de informar la fecha de presentación en el Juzgado del escrito de solicitud del Decreto de Adjudicación.</p><p style="margin-bottom: 10px;">En caso de no haber un bien ya vinculado al procedimiento, antes de dar por completada esta tarea el sistema le obligará a asociarlo a través de la pestaña bienes del procedimiento el bien que corresponda.</p><p style="margin-bottom: 10px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">Una vez rellene esta pantalla se lanzará la tarea "Notificación decreto de adjudicación a la entidad".</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_SolicitudDecretoAdjudicacion','1','date' ,'fechaSolicitud','Fecha Solicitud' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_SolicitudDecretoAdjudicacion','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_SolicitudTestimonioDecretoAdjudicacion','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">Para dar por completada esta tarea deberá de informar la Fecha de solicitud del testimonio de decreto de adjudicación.</p><p>En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><br></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_SolicitudTestimonioDecretoAdjudicacion','1','date' ,'fecha','Fecha Solicitud' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_SolicitudTestimonioDecretoAdjudicacion','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_notificacionDecretoAdjudicacionAlContrario','0','label' ,'titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A trav&eacute;s de esta pantalla se deber&aacute; informar del resultado de la notificaci&oacute;n del decreto de adjudicaci&oacute;n a la parte ejecutada, en caso de notificaci&oacute;n positiva se informar&aacute; de la fecha de notificaci&oacute;n del Decreto de Adjudicaci&oacute;n.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzar&aacute;, en caso de notificaci&oacute;n negativa a la parte contraria el tr&aacute;mite de notificaci&oacute;n, y en caso contrario la tarea "Solicitud de testimonio de decreto de adjudicaci&oacute;n".</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_notificacionDecretoAdjudicacionAlContrario','1','combo' ,'comboNotificacion','Notificado' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_notificacionDecretoAdjudicacionAlContrario','2','date' ,'fecha','Fecha' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_notificacionDecretoAdjudicacionAlContrario','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_DeclaracionIVAIGIC','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez emitido el auto decreto de adjudicaci&oacute;n, la entidad deber&aacute; realizar la declaraci&oacute;n en funci&oacute;n del tipo de tributaci&oacute;n definido en el informe fiscal. En el caso de el tipo de tributaci&oacute;n sea IVA sujeto y deducible, adem&aacute;s de la declaraci&oacute;n la entidad deber&aacute; auto emitir una factura.</p><p style="margin-bottom: 10px">Se indicar&aacute; la fecha en la que se ha declarado el IVA/IGIC de la operaci&oacute;n.</p><p style="margin-bottom: 10px">En el campo Observaciones informar de cualquier aspecto relevante que le interese quede reflejado en este punto del procedimiento.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_notificacionDecretoAdjudicacionAEntidad','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">A través de esta pantalla deberá de informar la fecha en la que se notifica, por el Juzgado el Decreto de Adjudicación, la entidad adjudicataria de los bienes afectos, así como la fecha de la resolución del juzgado.</p><p style="margin-bottom: 10px;">Deberá revisar que el Decreto es conforme a la subasta celebrada y contiene lo preceptuado para su correcta inscripción en el Registro de la Propiedad, para ello deberá revisar:</p><p style="margin-bottom: 10px;">- Datos procesales básicos: (Nº autos, tipo de procedimiento, cantidad reclamada)</p><p style="margin-bottom: 10px;">- Datos de la Entidad demandante (nombre CIF, domicilio) y de los adjudicatarios</p><p style="margin-bottom: 10px;">- Datos  de los demandados y titulares registrales.</p><p style="margin-bottom: 10px;">- Importe de adjudicación.</p><p style="margin-bottom: 10px;">- Orden de cancelación de la nota marginal y cancelación de la carga objeto de ejecución así como cargas posteriores.</p><p style="margin-bottom: 10px;">- Descripción y datos registrales completos de la finca adjudicada.</p><p style="margin-bottom: 10px;">- Declaración en el auto de la firmeza de la resolución.</p><p style="margin-bottom: 10px;">Una vez analizados los puntos descritos, en el campo Requiere subsanación deberá indicar el resultado de dicho análisis.</p><p style="margin-bottom: 10px;">En el campo Comunicación adicional requerida, deberá indicarse si es necesario, en función de la legislación vigente en la Comunidad Autónoma donde se encuentra ubicado el bien, realizar notificación a la oficina de la vivienda que corresponda.</p><p style="margin-bottom: 10px;">Si es necesaria una comunicación adicional, se informará además la fecha límite de acuerdo con la legislación aplicable.</p><p style="margin-bottom: 10px;">Una vez emitido el  Decreto de Adjudicación y si la operación está sujeta a IVA o IGIC, se lanzará la tarea "Declarar IVA/IGIC". Es necesario revisar la ficha del bien para verificar que está informado el tipo de tributación. En caso de que no estuviese informado, deberá enviar notificación a la entidad para le informe del tipo de tributación y completar este dato en la ficha del Bien.</p><p style="margin-bottom: 10px;">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">Una vez rellene esta pantalla:</p><p style="margin-bottom: 10px;">-En caso de requerir subsanación, se lanzará el "Trámite de subsanación de decreto de adjudicación".</p><p style="margin-bottom: 10px;">-En caso contrario se lanzará la tarea “Notificación decreto adjudicación al contrario" por un lado y por otro, si el bien ha sido adjudicado a la entidad, se lanzará el "Trámite de saneamiento de cargas" si existen cargas previas. Si no existen cargas se lanzará la tarea "Revisar  y obtener información contable".</p><p style="margin-bottom: 10px;">-En caso de que sea necesario comunicación adicional, se lanzará la tarea "Revisión documentación y comunicación adicional".</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_notificacionDecretoAdjudicacionAEntidad','1','date' ,'fecha','Fecha notificación' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_notificacionDecretoAdjudicacionAEntidad','2','date' ,'fechaResol','Fecha resolución' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_notificacionDecretoAdjudicacionAEntidad','3','combo' ,'comboSubsanacion','Requiere Subsanación' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_notificacionDecretoAdjudicacionAEntidad','4','combo' ,'comboAdicional','Comunicación adicional requerida' ,null ,null ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_notificacionDecretoAdjudicacionAEntidad','5','date' ,'fechaLimite','Fecha límite comunicación' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_notificacionDecretoAdjudicacionAEntidad','6','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_ConfirmarTestimonio','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">A través de esta pantalla se ha de marcar la fecha que el Juzgado emite y hace entrega del Testimonio del Decreto a favor de la Entidad. Se ha de tener en cuenta que desde la fecha testimonio que se indique en esta pantalla se inicia el plazo para liquidar los impuestos que correspondan.</p><p style="margin-bottom: 10px">En el campo Fecha notificación testimonio, indicar la fecha en la que se notifica a la entidad el Testimonio del Decreto de Adjudicación.</p><p style="margin-bottom: 10px">Con el objeto de evitar calificaciones desfavorables y subsanaciones posteriores que retrasan la inscripción deberá: </p><p style="margin-bottom: 10px">Obtenido el testimonio, revisar la fecha de expedición para liquidación de impuestos en plazo, según normativa de CCAA. La verificación de la fecha del título es necesaria y fundamental para que la gestoría pueda realizar la liquidación en plazo.</p><p style="margin-bottom: 10px">Adicionalmente se revisarán el contenido fundamental y de forma, para evitar subsanaciones posteriores que retrasen la inscripción.</p><p style="margin-bottom: 10px">Contenido básico para revisar en testimonio decreto de adjudicación  y mandamientos:</p><p style="margin-bottom: 10px">- Datos procesales básicos: (Nº autos, tipo de procedimiento, cantidad reclamada).</p><p style="margin-bottom: 10px">- Datos de la Entidad demandante (nombre CIF, domicilio) y en su caso de los adjudicados.</p><p style="margin-bottom: 10px">- Datos  de los demandados y titulares registrales.</p><p style="margin-bottom: 10px">- Importe de adjudicación y cesión de remate (en su caso).</p><p style="margin-bottom: 10px">- Orden de cancelación de la nota marginal y cancelación de la carga objeto de ejecución así como cargas posteriores.</p><p style="margin-bottom: 10px">- Descripción y datos registrales completos de la finca adjudicada.</p><p style="margin-bottom: 10px">- Declaración en el auto de la firmeza de la resolución.</p><p style="margin-bottom: 10px">Una vez analizados los puntos descritos, en el campo Requiere subsanación deberá indicar el resultado de dicho análisis.</p><p style="margin-bottom: 10px">En el campo "Comunicación adicional requerida", deberá indicarse si es necesario, en función de la legislación vigente en la Comunidad Autónoma del bien, realizar notificación a la oficina de la vivienda. Si es necesaria una comunicación adicional, se informará además la fecha límite de acuerdo con la legislación aplicable.</p><p style="margin-bottom: 10px">En el supuesto de que haya constancia en el procedimiento de que hay ocupantes en el bien, deberá indicarlo en el campo pertinente.</p><p style="margin-bottom: 10px">Para dar por terminada esta tarea deberá de adjuntar al procedimiento correspondiente una copia escaneada del decreto firme de adjudicación.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla:</p><p style="margin-bottom: 10px">-En caso de requerir subsanación, se lanzará el "Trámite de subsanación de decreto de adjudicación".</p><p style="margin-bottom: 10px">-Se lanzará el "Trámite de provisión de fondos".</p><p style="margin-bottom: 10px">-Se lanzará el "Trámite de Posesión".</p><p style="margin-bottom: 10px">-En caso de que sea necesario comunicación adicional, se lanzará la tarea "Revisión documentación y comunicación adicional".</p><p style="margin-bottom: 10px">-En caso de que haya indicado que no hay constancia en el procedimiento de que hay ocupantes, se lanzará el trámite de "Certificado libertad de arrendamiento.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_ConfirmarTestimonio','1','date' ,'fechaTestimonio','Fecha Testimonio' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_ConfirmarTestimonio','2','date' ,'fechaNotificacion','Fecha notificación testimonio' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_ConfirmarTestimonio','3','combo' ,'comboSubsanacion','Requiere Subsanación' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_ConfirmarTestimonio','4','combo' ,'comboAdicional','Comunicación adicional requerida' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != ''? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_ConfirmarTestimonio','5','date' ,'fechaLimite','Fecha límite comunicación' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_ConfirmarTestimonio','6','combo' ,'comboOcupantes','Constancia de ocupantes' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != ''? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_ConfirmarTestimonio','7','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RevisionComAdicional','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">Puesto que en la tarea anterior ha indicado que se requiere de comunicación adicional, para cerrar esta tarea se deberá revisar la documentación y los requisitos de comunicación. </p><p style="margin-bottom: 10px;">En el campo Fecha deberá indicar la fecha en la que completa esta tarea.</p><p style="margin-bottom: 10px;">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">La siguiente tarea será "Notificación comunicación adicional"</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RevisionComAdicional','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RevisionComAdicional','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_NotifComAdicional','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">Deberá informarse la fecha en que se realizó la comunicación pertinente y adjuntar el documento que acredite la comunicación realizada.</p><p style="margin-bottom: 10px;">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_NotifComAdicional','1','date' ,'fecha','Fecha comunicacion' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_NotifComAdicional','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_BPMProvisionFondos','0','label' ,'titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el trámite provisión de fondos - HCJ.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RevisarInfoContable','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">Antes de dar por finalizada esta tarea deberá revisar que dispone de la siguiente información en la herramienta:</p><p style="margin-bottom: 10px;">-Decreto de adjudicación en la pestaña Adjuntos de la actuación</p><p style="margin-bottom: 10px;">-Tasación del bien, en la ficha del Bien</p><p style="margin-bottom: 10px;">En esta pantalla deberá indicar cómo distribuye el importe cobrado en los diferentes conceptos.</p><p style="margin-bottom: 10px;">Si la operación es titulizada o si requiere  autorización, deberá solicitar autorización a la entidad para la contabilidad del bien. </p><p style="margin-bottom: 10px;">En el campo Fecha deberá indicar la fecha en la que realiza las gestiones.</p><p style="margin-bottom: 10px;">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">Una vez rellene esta pantalla, se lanzará la tarea "Confirmar Contabilidad".</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RevisarInfoContable','1','date' ,'fecha','Fecha Presentación' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RevisarInfoContable','2','currency' ,'nominal','Nominal' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RevisarInfoContable','3','currency' ,'intereses','Intereses' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RevisarInfoContable','4','currency' ,'demora','Demora' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RevisarInfoContable','5','currency' ,'gAbogado','Gastos abogado' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RevisarInfoContable','6','currency' ,'gProcurador','Gastos procurador' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RevisarInfoContable','7','currency' ,'gOtros','Otros gastos' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RevisarInfoContable','8','currency' ,'aOpTramite','A op. trámite' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RevisarInfoContable','9','currency' ,'tEntregas','Total entregas a pendiente' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RevisarInfoContable','10','combo' ,'cbTipoEntrega','Tipo de entrega' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDAdjContableTipoEntrega','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RevisarInfoContable','11','combo' ,'cbConcepto','Concepto de entrega' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDAdjContableConceptoEntrega','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RevisarInfoContable','12','currency' ,'paseFallido','Pase a fallido' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RevisarInfoContable','13','currency' ,'qNominal','Quita Nominal' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RevisarInfoContable','14','currency' ,'qIntereses','Quita Intereses' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RevisarInfoContable','15','currency','qDemoras','Quita Demoras' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RevisarInfoContable','16','currency' ,'tQuitasGastos','Total Quita Gastos' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RevisarInfoContable','17','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_ConfirmarContabilidad','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">Antes de finalizar esta tarea podrá consultar la siguiente información en la pestaña "Adjuntos" del procedimiento:</p><p style="margin-bottom: 10px;">-Decreto de adjudición</p><p style="margin-bottom: 10px;">-Tasación del bien, en la ficha del Bien</p><p style="margin-bottom: 10px;">En esta pantalla le aperecerá preinformado el importe a contabilizar en cada uno de los diferentes conceptos de acuerdo a lo indicado por el gestor en la tarea previa.</p><p style="margin-bottom: 10px;">En este tarea debe confirmar la fecha en la que ha realizado la contabilización de la operación.</p><p style="margin-bottom: 10px;">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese procedimiento.</p><p style="margin-bottom: 10px;">Una vez rellene esta pantalla finalizará el trámite.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_ConfirmarContabilidad','1','date' ,'fecha','Fecha Presentación' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_ConfirmarContabilidad','2','currency' ,'nominal','Nominal' ,null ,null ,'valores[''CJ067_RevisarInfoContable''][''nominal'']' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_ConfirmarContabilidad','3','currency' ,'intereses','Intereses' ,null ,null ,'valores[''CJ067_RevisarInfoContable''][''intereses'']' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_ConfirmarContabilidad','4','currency' ,'demora','Demora' ,null ,null ,'valores[''CJ067_RevisarInfoContable''][''demora'']' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_ConfirmarContabilidad','5','currency' ,'gAbogado','Gastos abogado' ,null ,null ,'valores[''CJ067_RevisarInfoContable''][''gAbogado'']' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_ConfirmarContabilidad','6','currency' ,'gProcurador','Gastos procurador' ,null ,null ,'valores[''CJ067_RevisarInfoContable''][''gProcurador'']' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_ConfirmarContabilidad','7','currency' ,'gOtros','Otros gastos' ,null ,null ,'valores[''CJ067_RevisarInfoContable''][''gOtros'']' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_ConfirmarContabilidad','8','currency' ,'aOpTramite','A op. trámite' ,null ,null ,'valores[''CJ067_RevisarInfoContable''][''aOpTramite'']' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_ConfirmarContabilidad','9','currency' ,'tEntregas','Total entregas a pendiente' ,null ,null ,'valores[''CJ067_RevisarInfoContable''][''tEntregas'']' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_ConfirmarContabilidad','10','combo' ,'cbTipoEntrega','Tipo de entrega' ,null ,null ,'valores[''CJ067_RevisarInfoContable''][''cbTipoEntrega'']' ,'DDAdjContableTipoEntrega','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_ConfirmarContabilidad','11','combo' ,'cbConcepto','Concepto de entrega' ,null ,null ,'valores[''CJ067_RevisarInfoContable''][''cbConcepto'']' ,'DDAdjContableConceptoEntrega','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_ConfirmarContabilidad','12','currency' ,'paseFallido','Pase a fallido' ,null ,null ,'valores[''CJ067_RevisarInfoContable''][''paseFallido'']' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_ConfirmarContabilidad','13','currency' ,'qNominal','Quita Nominal' ,null ,null ,'valores[''CJ067_RevisarInfoContable''][''qNominal'']' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_ConfirmarContabilidad','14','currency' ,'qIntereses','Quita Intereses' ,null ,null ,'valores[''CJ067_RevisarInfoContable''][''qIntereses'']' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_ConfirmarContabilidad','15','currency' ,'qDemoras','Quita Demoras' ,null ,null ,'valores[''CJ067_RevisarInfoContable''][''qDemoras'']' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_ConfirmarContabilidad','16','currency' ,'tQuitasGastos','Total Quita Gastos' ,null ,null ,'valores[''CJ067_RevisarInfoContable''][''tQuitasGastos'']' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_ConfirmarContabilidad','17','textarea' ,'obsContables','Observaciones contables' ,null ,null ,'valores[''CJ067_RevisarInfoContable''][''observaciones'']' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_ConfirmarContabilidad','18','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_BPMNotifNotarialOcupante','0','label' ,'titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Notificación notarial de ocupantes.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_BPMCertfLibertadArrendamiento','0','label' ,'titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Certificado libertad de arrendamiento.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_ValorarLanzamiento','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">A través de esta tarea, deberá usted indicar si se debe o no lanzar el Trámite de Solicitud de Solvencia Patrimonial.</p><p>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><br></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_ValorarLanzamiento','1','combo' ,'comboSolicitud','Solicitud de solvencia patrimonial' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_ValorarLanzamiento','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RegistrarPresentacionHacienda','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">A través de esta tarea, deberá informar, de acuerdo con los impuestos que apliquen, si corresponde o no presentar la liquidación del testimonio en Hacienda.</p><p>En caso positivo y para dar por terminada esta tarea deberá presentar la liquidación del testimonio en Hacienda, una vez realizado esto deberá adjuntar al procedimiento correspondiente copia escaneada del documento de liquidación de impuestos.</p><p>En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p>Una vez rellene esta pantalla se lanzará la tarea “Registrar presentación en el registro”.</p><br></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RegistrarPresentacionHacienda','1','combo' ,'comboLiquidacion','Liquidación del testimonio' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RegistrarPresentacionHacienda','2','date' ,'fechaPresentacion','Fecha presentación' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_RegistrarPresentacionHacienda','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_BPMTramiteSolicitudSolvenciaPatrimonial','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se inicia el trámite de inscripción de solicitud solvencia patrimonial</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ067_BPMAnticipoFondos','0','label' ,'titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el trámite anticipo de fondos y pago de suplidos.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026')
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