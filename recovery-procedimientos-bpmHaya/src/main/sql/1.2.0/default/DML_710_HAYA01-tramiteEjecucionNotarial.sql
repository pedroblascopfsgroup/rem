--######################################################################
--## Author: Roberto
--## BPM: T. Ejecución Notarial (H036)
--## Finalidad: Insertar datos en tablas de configuración del BPM
--## INSTRUCCIONES: Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--######################################################################
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    
    PAR_TABLENAME_TPROC VARCHAR2(50 CHAR) := 'DD_TPO_TIPO_PROCEDIMIENTO';   -- [PARAMETRO] TABLA para tipo de procedimiento. Por defecto DD_TPO_TIPO_PROCEDIMIENTO
    V_CODIGO_TPO VARCHAR2(100 CHAR); -- Variable para nombre campo FK con codigo de Tipo procedimiento
    
    CODIGO_PROCEDIMIENTO_ANTIGUO_1 VARCHAR2(10 CHAR) := 'P95'; -- Variable con el código (DD_TPO_ID) del procedimiento antiguo para poder desactivarlo
    --CODIGO_PROCEDIMIENTO_ANTIGUO_2 VARCHAR2(10 CHAR) := 'P409'; -- Variable con el código (DD_TPO_ID) del procedimiento antiguo para poder desactivarlo

    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(	    
		T_TIPO_TPO(/*DD_TPO_CODIGO*/ 'H036',/*DD_TPO_DESCRIPCION*/ 'T. de ejecución notarial',/*DD_TPO_DESCRIPCION_LARGA*/ 'T. de ejecución notarial',/*DD_TPO_HTML*/ '',/*DD_TPO_XML_JBPM*/ 'haya_tramiteEjecucionNotarialV4',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD',/*BORRADO*/ '0',/*DD_TAC_ID*/ 'EX',/*DD_TPO_SALDO_MIN*/ '',/*DD_TPO_SALDO_MAX*/ '',/*FLAG_PRORROGA*/ '1',/*DTYPE*/ 'MEJTipoProcedimiento',/*FLAG_DERIVABLE*/ '1',/*FLAG_UNICO_BIEN*/ '0')		
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(   
    
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H036',
			/*TAP_CODIGO*/ 'H036_entregaActaRequerimiento',
			/*TAP_VIEW*/ 'plugin/procedimientos-bpmHaya/tramiteEjecucionNotarial/entregaActaRequerimiento',
			/*TAP_SCRIPT_VALIDACION*/ '',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ '',
			/*DD_TPO_ID_BPM*/ '',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Registrar entrega del acta de requerimiento a notario',
			/*VERSION*/ '0',
			/*USUARIOCREAR*/ 'DD',
			/*BORRADO*/ '0',
			/*TAP_ALERT_NO_RETORNO*/ '',
			/*TAP_ALERT_VUELTA_ATRAS*/ '',
			/*DD_FAP_ID*/ '09',
			/*TAP_AUTOPRORROGA*/ '0',
			/*DTYPE*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP*/ '3',
			/*DD_TGE_ID*/ '',
			/*DD_STA_ID*/ '814',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ 'GUCL',
			/*TAP_BUCLE_BPM*/ ''
		),
		
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H036',
			/*TAP_CODIGO*/ 'H036_registrarSolicitudCertCargas',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ '',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ '',
			/*DD_TPO_ID_BPM*/ '',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Registrar solicitud de certificación registral',
			/*VERSION*/ '0',
			/*USUARIOCREAR*/ 'DD',
			/*BORRADO*/ '0',
			/*TAP_ALERT_NO_RETORNO*/ '',
			/*TAP_ALERT_VUELTA_ATRAS*/ 'tareaExterna.cancelarTarea',
			/*DD_FAP_ID*/ '09',
			/*TAP_AUTOPRORROGA*/ '0',
			/*DTYPE*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP*/ '3',
			/*DD_TGE_ID*/ '',
			/*DD_STA_ID*/ '814',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ 'GUCL',
			/*TAP_BUCLE_BPM*/ ''
		),
		
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H036',
			/*TAP_CODIGO*/ 'H036_registrarRecepcionCertCargas',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ 'comprobarExisteDocumentoCRG() ? null : ''Es necesario adjuntar el documento Certificado Registral'' ',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ 'valores[''H036_registrarRecepcionCertCargas''][''comboCorrecto''] == DDSiNo.SI ? ''correcto'' : ''incorrecto''',
			/*DD_TPO_ID_BPM*/ '',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Registrar recepción de la certificación registral',
			/*VERSION*/ '0',
			/*USUARIOCREAR*/ 'DD',
			/*BORRADO*/ '0',
			/*TAP_ALERT_NO_RETORNO*/ '',
			/*TAP_ALERT_VUELTA_ATRAS*/ 'tareaExterna.cancelarTarea',
			/*DD_FAP_ID*/ '09',
			/*TAP_AUTOPRORROGA*/ '1',
			/*DTYPE*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP*/ '3',
			/*DD_TGE_ID*/ '',
			/*DD_STA_ID*/ '814',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ 'GUCL',
			/*TAP_BUCLE_BPM*/ ''
		),
		
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H036',
			/*TAP_CODIGO*/ 'H036_registrarRequerimientoAdeudor',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ '',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ 'valores[''H036_registrarRequerimientoAdeudor''][''comboResultado''] == DDSiNo.SI ? ''positivo'' : ''negativo''',
			/*DD_TPO_ID_BPM*/ '',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Registrar requerimiento al deudor',
			/*VERSION*/ '0',
			/*USUARIOCREAR*/ 'DD',
			/*BORRADO*/ '0',
			/*TAP_ALERT_NO_RETORNO*/ '',
			/*TAP_ALERT_VUELTA_ATRAS*/ 'tareaExterna.cancelarTarea',
			/*DD_FAP_ID*/ '09',
			/*TAP_AUTOPRORROGA*/ '1',
			/*DTYPE*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP*/ '3',
			/*DD_TGE_ID*/ '',
			/*DD_STA_ID*/ '814',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ 'GUCL',
			/*TAP_BUCLE_BPM*/ ''
		),
		
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H036',
			/*TAP_CODIGO*/ 'H036_registrarPagoDelDeudor',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ '',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ 'valores[''H036_registrarPagoDelDeudor''][''comboPagoEnPlazo''] == DDSiNo.SI ? ''positivo'' : ''negativo''',
			/*DD_TPO_ID_BPM*/ '',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Registrar pago del deudor',
			/*VERSION*/ '0',
			/*USUARIOCREAR*/ 'DD',
			/*BORRADO*/ '0',
			/*TAP_ALERT_NO_RETORNO*/ '',
			/*TAP_ALERT_VUELTA_ATRAS*/ 'tareaExterna.cancelarTarea',
			/*DD_FAP_ID*/ '09',
			/*TAP_AUTOPRORROGA*/ '0',
			/*DTYPE*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP*/ '3',
			/*DD_TGE_ID*/ '',
			/*DD_STA_ID*/ '814',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ 'GUCL',
			/*TAP_BUCLE_BPM*/ ''
		),
		
/*
El control de si quedan mas sujetos por notificar lo tenemos con el campo "Sujeto a notificar: SI/NO, 
y si se selecciona "Notificado" = NO, el tramite ira a decisión, independientemente de lo que se 
haya seleccionado antes para evitar un bucle en la tarea y avanzar. 
*/		
		
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H036',
			/*TAP_CODIGO*/ 'H036_registrarNotificacion',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ '',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ 'valores[''H036_registrarNotificacion''][''comboNotificado''] == DDSiNo.SI ? ''Positivo'' : ''Negativo''',
			/*DD_TPO_ID_BPM*/ '',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Registrar notificación de inicio de actuaciones',
			/*VERSION*/ '0',
			/*USUARIOCREAR*/ 'DD',
			/*BORRADO*/ '0',
			/*TAP_ALERT_NO_RETORNO*/ '',
			/*TAP_ALERT_VUELTA_ATRAS*/ 'tareaExterna.cancelarTarea',
			/*DD_FAP_ID*/ '09',
			/*TAP_AUTOPRORROGA*/ '1',
			/*DTYPE*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP*/ '3',
			/*DD_TGE_ID*/ '',
			/*DD_STA_ID*/ '814',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ 'GUCL',
			/*TAP_BUCLE_BPM*/ ''
		),
		
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H036',
			/*TAP_CODIGO*/ 'H036_registrarAnuncioSubasta',
			/*TAP_VIEW*/ 'plugin/procedimientos-bpmHaya/tramiteEjecucionNotarial/registrarAnuncioSubasta',
			/*TAP_SCRIPT_VALIDACION*/ '!comprobarBienAsociadoPrc() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom:10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea, deber&aacute; registrar al menos un bien, para ello debe acceder a la pesta&ntilde;a Bienes.</p></div>'': ( !tieneAlgunBienConFichaSubasta2() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea, deber&aacute; dictar instrucciones para subasta en al menos un bien, para ello debe acceder a la pesta&ntilde;a Bienes de la ficha del Procedimiento correspondiente y proceder a dictar instrucciones.</p></div>'' : (comprobarExisteDocumentoADS() ? (comprobarExisteDocumentoBOP() ? null : ''Es necesario adjuntar el documento Bolet&iacute;n Oficial Propiedad'' ) : ''Es necesario adjuntar el documento Auto declarando subasta'' ) )',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ '',
			/*DD_TPO_ID_BPM*/ '',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Registrar anuncio de subasta',
			/*VERSION*/ '0',
			/*USUARIOCREAR*/ 'DD',
			/*BORRADO*/ '0',
			/*TAP_ALERT_NO_RETORNO*/ '',
			/*TAP_ALERT_VUELTA_ATRAS*/ 'tareaExterna.cancelarTarea',
			/*DD_FAP_ID*/ '09',
			/*TAP_AUTOPRORROGA*/ '1',
			/*DTYPE*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP*/ '3',
			/*DD_TGE_ID*/ '',
			/*DD_STA_ID*/ '814',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ 'GUCL',
			/*TAP_BUCLE_BPM*/ ''
		),
		
/*
	H036_RegistrarEnvioComunicacionAlTitular
*/
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H036',
			/*TAP_CODIGO*/ 'H036_RegistrarEnvioComunicacionAlTitular',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ '',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ '',
			/*DD_TPO_ID_BPM*/ '',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Registrar envío comunicación al titular del dominio',
			/*VERSION*/ '0',
			/*USUARIOCREAR*/ 'DD',
			/*BORRADO*/ '0',
			/*TAP_ALERT_NO_RETORNO*/ '',
			/*TAP_ALERT_VUELTA_ATRAS*/ 'tareaExterna.cancelarTarea',
			/*DD_FAP_ID*/ '09',
			/*TAP_AUTOPRORROGA*/ '0',
			/*DTYPE*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP*/ '3',
			/*DD_TGE_ID*/ '',
			/*DD_STA_ID*/ '814',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ 'GUCL',
			/*TAP_BUCLE_BPM*/ ''
		),		
		
		
/*
	H036_RegistrarRecepcionComunicacionAlTitular
*/
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H036',
			/*TAP_CODIGO*/ 'H036_RegistrarRecepcionComunicacionAlTitular',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ '',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ '',
			/*DD_TPO_ID_BPM*/ '',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Registrar recepción de comunicación al titular del dominio',
			/*VERSION*/ '0',
			/*USUARIOCREAR*/ 'DD',
			/*BORRADO*/ '0',
			/*TAP_ALERT_NO_RETORNO*/ '',
			/*TAP_ALERT_VUELTA_ATRAS*/ 'tareaExterna.cancelarTarea',
			/*DD_FAP_ID*/ '09',
			/*TAP_AUTOPRORROGA*/ '1',
			/*DTYPE*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP*/ '3',
			/*DD_TGE_ID*/ '',
			/*DD_STA_ID*/ '814',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ 'GUCL',
			/*TAP_BUCLE_BPM*/ ''
		),		
		
/*
	H036_RegistrarSolicitudTasacion
*/
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H036',
			/*TAP_CODIGO*/ 'H036_RegistrarSolicitudTasacion',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ '',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ '',
			/*DD_TPO_ID_BPM*/ '',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Registrar solicitud de tasación',
			/*VERSION*/ '0',
			/*USUARIOCREAR*/ 'DD',
			/*BORRADO*/ '0',
			/*TAP_ALERT_NO_RETORNO*/ '',
			/*TAP_ALERT_VUELTA_ATRAS*/ 'tareaExterna.cancelarTarea',
			/*DD_FAP_ID*/ '09',
			/*TAP_AUTOPRORROGA*/ '0',
			/*DTYPE*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP*/ '3',
			/*DD_TGE_ID*/ '',
			/*DD_STA_ID*/ '801',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ 'SSUB',
			/*TAP_BUCLE_BPM*/ ''
		),		
		
/*
	H036_RegistrarRecepcionTasacion 
*/			
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H036',
			/*TAP_CODIGO*/ 'H036_RegistrarRecepcionTasacion',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ 'comprobarExisteDocumentoTSU() ? null : ''Es necesario adjuntar el documento Tasaci&oacute;n de la subasta'' ',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ '',
			/*DD_TPO_ID_BPM*/ '',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Registrar recepción de tasación',
			/*VERSION*/ '0',
			/*USUARIOCREAR*/ 'DD',
			/*BORRADO*/ '0',
			/*TAP_ALERT_NO_RETORNO*/ '',
			/*TAP_ALERT_VUELTA_ATRAS*/ 'tareaExterna.cancelarTarea',
			/*DD_FAP_ID*/ '09',
			/*TAP_AUTOPRORROGA*/ '0',
			/*DTYPE*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP*/ '3',
			/*DD_TGE_ID*/ '',
			/*DD_STA_ID*/ '801',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ 'SSUB',
			/*TAP_BUCLE_BPM*/ ''
		),		
		
/*
	H036_PrepararInformeSubasta
*/			
		
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H036',
			/*TAP_CODIGO*/ 'H036_PrepararInformeSubasta',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ 'comprobarInformacionCompletaInstrucciones() ? (comprobarExisteDocumentoPIN()? null : ''Es necesario adjuntar el documento propuesta de instrucciones'') : ''La informaci&oacute;n de las instrucciones de los lotes no est&aacute; completa.''',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ '',
			/*DD_TPO_ID_BPM*/ '',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Preparar informe subasta',
			/*VERSION*/ '0',
			/*USUARIOCREAR*/ 'DD',
			/*BORRADO*/ '0',
			/*TAP_ALERT_NO_RETORNO*/ '',
			/*TAP_ALERT_VUELTA_ATRAS*/ 'tareaExterna.cancelarTarea',
			/*DD_FAP_ID*/ '09',
			/*TAP_AUTOPRORROGA*/ '1',
			/*DTYPE*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP*/ '3',
			/*DD_TGE_ID*/ '',
			/*DD_STA_ID*/ '814',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ 'GUCL',
			/*TAP_BUCLE_BPM*/ ''
		),		
		
		
/*
	H036_ValidarPropuesta 
*/					
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H036',
			/*TAP_CODIGO*/ 'H036_ValidarPropuesta',
			/*TAP_VIEW*/ 'plugin/procedimientos-bpmHaya/tramiteEjecucionNotarial/validarPropuesta',
			/*TAP_SCRIPT_VALIDACION*/ 'comprobarExisteDocumentoPSUDUL() ? null : ''Es necesario adjuntar el documento Propuesta Subasta firmada por Dtor UCyL'' ',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ 'valores[''H036_ValidarPropuesta''][''suspender''] == DDSiNo.SI ? ''Rechazada'' : valores[''H036_ValidarPropuesta''][''delegada''] == DDSiNo.NO ? ''NoDelegada'' : valores[''H036_ValidarPropuesta''][''conAtribuciones''] == DDSiNo.SI ? ''DelegadaConAtribuciones'' : ''DelegadaSinAtribuciones'' ',
			/*DD_TPO_ID_BPM*/ '',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Validar propuesta',
			/*VERSION*/ '0',
			/*USUARIOCREAR*/ 'DD',
			/*BORRADO*/ '0',
			/*TAP_ALERT_NO_RETORNO*/ '',
			/*TAP_ALERT_VUELTA_ATRAS*/ 'tareaExterna.cancelarTarea',
			/*DD_FAP_ID*/ '09',
			/*TAP_AUTOPRORROGA*/ '1',
			/*DTYPE*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP*/ '3',
			/*DD_TGE_ID*/ '',
			/*DD_STA_ID*/ '800',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ 'SUP',
			/*TAP_BUCLE_BPM*/ ''
		),		
						
		
/*
	H036_SuspenderSubasta
*/		
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H036',
			/*TAP_CODIGO*/ 'H036_SuspenderSubasta',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ '',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ '',
			/*DD_TPO_ID_BPM*/ '',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Suspender subasta',
			/*VERSION*/ '0',
			/*USUARIOCREAR*/ 'DD',
			/*BORRADO*/ '0',
			/*TAP_ALERT_NO_RETORNO*/ '',
			/*TAP_ALERT_VUELTA_ATRAS*/ 'tareaExterna.cancelarTarea',
			/*DD_FAP_ID*/ '09',
			/*TAP_AUTOPRORROGA*/ '0',
			/*DTYPE*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP*/ '3',
			/*DD_TGE_ID*/ '',
			/*DD_STA_ID*/ '814',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ 'GUCL',
			/*TAP_BUCLE_BPM*/ ''
		),		
		
/*
	H036_ElevarPropuestaAComite 
*/		
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H036',
			/*TAP_CODIGO*/ 'H036_ElevarPropuestaAComite',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ '',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ '( valores[''H036_ElevarPropuestaAComite''][''comboResultadoComite''] == ''ACEPTADA'' ? ''Aceptada'' : ( valores[''H036_ElevarPropuestaAComite''][''comboResultadoComite''] == ''ACCONCAM'' ? ''Modificada'' : ''Rechazada'') )',
			/*DD_TPO_ID_BPM*/ '',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Elevar propuesta a Comité',
			/*VERSION*/ '0',
			/*USUARIOCREAR*/ 'DD',
			/*BORRADO*/ '0',
			/*TAP_ALERT_NO_RETORNO*/ '',
			/*TAP_ALERT_VUELTA_ATRAS*/ 'tareaExterna.cancelarTarea',
			/*DD_FAP_ID*/ '09',
			/*TAP_AUTOPRORROGA*/ '0',
			/*DTYPE*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP*/ '3',
			/*DD_TGE_ID*/ '',
			/*DD_STA_ID*/ '815',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ 'DUCL',
			/*TAP_BUCLE_BPM*/ ''
		),			
		
/*
	H036_LecturaYAceptacionInstrucciones
*/		
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H036',
			/*TAP_CODIGO*/ 'H036_LecturaYAceptacionInstrucciones',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ '',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ '',
			/*DD_TPO_ID_BPM*/ '',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Lectura y aceptación de instrucciones',
			/*VERSION*/ '0',
			/*USUARIOCREAR*/ 'DD',
			/*BORRADO*/ '0',
			/*TAP_ALERT_NO_RETORNO*/ '',
			/*TAP_ALERT_VUELTA_ATRAS*/ '',
			/*DD_FAP_ID*/ '09',
			/*TAP_AUTOPRORROGA*/ '0',
			/*DTYPE*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP*/ '3',
			/*DD_TGE_ID*/ '',
			/*DD_STA_ID*/ '814',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ 'GUCL',
			/*TAP_BUCLE_BPM*/ ''),		
			
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H036',
			/*TAP_CODIGO*/ 'H036_CelebracionSubasta',
			/*TAP_VIEW*/ 'plugin/procedimientos-bpmHaya/tramiteEjecucionNotarial/celebracionSubastaV4',
			/*TAP_SCRIPT_VALIDACION*/ 'comprobarExisteDocumentoASU() ? null : ''Es necesario adjuntar el Acta de subasta'' ',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ '',
			/*DD_TPO_ID_BPM*/ '',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Celebración Subasta',
			/*VERSION*/ '0',
			/*USUARIOCREAR*/ 'DD',
			/*BORRADO*/ '0',
			/*TAP_ALERT_NO_RETORNO*/ '',
			/*TAP_ALERT_VUELTA_ATRAS*/ '',
			/*DD_FAP_ID*/ '09',
			/*TAP_AUTOPRORROGA*/ '0',
			/*DTYPE*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP*/ '3',
			/*DD_TGE_ID*/ '',
			/*DD_STA_ID*/ '814',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ 'GUCL',
			/*TAP_BUCLE_BPM*/ ''),
                
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H036',
			/*TAP_CODIGO*/ 'H036_RegistrarCesionRemate',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ '',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ '',
			/*DD_TPO_ID_BPM*/ '',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Registrar cesión de remate',
			/*VERSION*/ '0',
			/*USUARIOCREAR*/ 'DD',
			/*BORRADO*/ '0',
			/*TAP_ALERT_NO_RETORNO*/ '',
			/*TAP_ALERT_VUELTA_ATRAS*/ 'tareaExterna.cancelarTarea',
			/*DD_FAP_ID*/ '09',
			/*TAP_AUTOPRORROGA*/ '0',
			/*DTYPE*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP*/ '3',
			/*DD_TGE_ID*/ '',
			/*DD_STA_ID*/ '814',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ 'GUCL',
			/*TAP_BUCLE_BPM*/ ''),					
			
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H036',
			/*TAP_CODIGO*/ 'H036_RegistrarLiquidacionPrecioDeRemate',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ '',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ '',
			/*DD_TPO_ID_BPM*/ '',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Registrar liquidación del precio de remate',
			/*VERSION*/ '0',
			/*USUARIOCREAR*/ 'DD',
			/*BORRADO*/ '0',
			/*TAP_ALERT_NO_RETORNO*/ '',
			/*TAP_ALERT_VUELTA_ATRAS*/ '',
			/*DD_FAP_ID*/ '09',
			/*TAP_AUTOPRORROGA*/ '0',
			/*DTYPE*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP*/ '3',
			/*DD_TGE_ID*/ '',
			/*DD_STA_ID*/ '814',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ 'GUCL',
			/*TAP_BUCLE_BPM*/ ''),						
																							
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H036',
			/*TAP_CODIGO*/ 'H036_BPMTramitePosesion',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ '',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ '',
			/*DD_TPO_ID_BPM*/ 'H015',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Llamada al Trámite de Posesión',
			/*VERSION*/ '0',
			/*USUARIOCREAR*/ 'DD',
			/*BORRADO*/ '0',
			/*TAP_ALERT_NO_RETORNO*/ '',
			/*TAP_ALERT_VUELTA_ATRAS*/ '',
			/*DD_FAP_ID*/ '09',
			/*TAP_AUTOPRORROGA*/ '1',
			/*DTYPE*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP*/ '3',
			/*DD_TGE_ID*/ '',
			/*DD_STA_ID*/ '814',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ '',
			/*TAP_BUCLE_BPM*/ ''),	
			
--H036_BPMTramiteElevacionPropSarebLitigios			
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H036',
			/*TAP_CODIGO*/ 'H036_BPMTramiteElevacionPropSarebLitigios',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ '',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ '',
			/*DD_TPO_ID_BPM*/ 'H012',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Llamada al Trámite de Elevación a Sareb',
			/*VERSION*/ '0',
			/*USUARIOCREAR*/ 'DD',
			/*BORRADO*/ '0',
			/*TAP_ALERT_NO_RETORNO*/ '',
			/*TAP_ALERT_VUELTA_ATRAS*/ '',
			/*DD_FAP_ID*/ '09',
			/*TAP_AUTOPRORROGA*/ '1',
			/*DTYPE*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP*/ '3',
			/*DD_TGE_ID*/ '',
			/*DD_STA_ID*/ '814',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ '',
			/*TAP_BUCLE_BPM*/ ''),		
			
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H036',
			/*TAP_CODIGO*/ 'H036_BPMTramiteInscripcionDelTitulo',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ '',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ '',
			/*DD_TPO_ID_BPM*/ 'H066',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Llamada al Trámite de Inscripción del Título',
			/*VERSION*/ '0',
			/*USUARIOCREAR*/ 'DD',
			/*BORRADO*/ '0',
			/*TAP_ALERT_NO_RETORNO*/ '',
			/*TAP_ALERT_VUELTA_ATRAS*/ '',
			/*DD_FAP_ID*/ '09',
			/*TAP_AUTOPRORROGA*/ '1',
			/*DTYPE*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP*/ '3',
			/*DD_TGE_ID*/ '',
			/*DD_STA_ID*/ '814',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ '',
			/*TAP_BUCLE_BPM*/ '')			
			
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI( 

		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_entregaActaRequerimiento',/*TFI_ORDEN*/ '0',/*TFI_TIPO*/ 'label',/*TFI_NOMBRE*/ 'titulo',
		/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; informar la fecha de entrega del acta de requerimiento a notario as&iacute; como el notario designado por el colegio de notarios.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Registrar solicitud de certificaci&oacute;n registral".</p></div>',
		/*TFI_ERROR_VALIDACION*/ '',/*TFI_VALIDACION*/ '',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ '',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_entregaActaRequerimiento',/*TFI_ORDEN*/ '1',/*TFI_TIPO*/ 'date',/*TFI_NOMBRE*/ 'fecha',/*TFI_LABEL*/ 'Fecha entrega del acta',/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ '',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_entregaActaRequerimiento',/*TFI_ORDEN*/ '2',/*TFI_TIPO*/ 'combo',/*TFI_NOMBRE*/ 'comboNotario',/*TFI_LABEL*/ 'Notario competente',/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ 'DDNotarios',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_entregaActaRequerimiento',/*TFI_ORDEN*/ '3',/*TFI_TIPO*/ 'textarea',/*TFI_NOMBRE*/ 'observaciones',/*TFI_LABEL*/ 'Observaciones',/*TFI_ERROR_VALIDACION*/ '',/*TFI_VALIDACION*/ '',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ '',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarSolicitudCertCargas',/*TFI_ORDEN*/ '0',/*TFI_TIPO*/ 'label',/*TFI_NOMBRE*/ 'titulo',
		/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; informar la fecha por la que realiza la solicitud de la certificaci&oacute;n registral.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Registrar recepci&oacute;n de certificaci&oacute;n registral".</p></div>',
		/*TFI_ERROR_VALIDACION*/ '',/*TFI_VALIDACION*/ '',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ '',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarSolicitudCertCargas',/*TFI_ORDEN*/ '1',/*TFI_TIPO*/ 'date',/*TFI_NOMBRE*/ 'fecha',/*TFI_LABEL*/ 'Fecha',/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ '',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarSolicitudCertCargas',/*TFI_ORDEN*/ '2',/*TFI_TIPO*/ 'textarea',/*TFI_NOMBRE*/ 'observaciones',/*TFI_LABEL*/ 'Observaciones',/*TFI_ERROR_VALIDACION*/ '',/*TFI_VALIDACION*/ '',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ '',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),							
		
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarRecepcionCertCargas',/*TFI_ORDEN*/ '0',/*TFI_TIPO*/ 'label',/*TFI_NOMBRE*/ 'titulo',
		/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; informar la fecha en la que se recibe la certificaci&oacute;n registral.</p><p style="margin-bottom: 10px">Tras el estudio de la certificaci&oacute;n registral deber&aacute; informar si es correcto o no, as&iacute; como los detalles que se le requieren en cuanto a propietarios.</p><p style="margin-bottom: 10px">El caso de que hubiere varios titulares de carga deber&aacute; introducir SI en el campo "Otros titulares de carga" e informar tanto el n&uacute;mero de dichos titulares como una descripci&oacute;n de los mismos en el campo "Descripci&oacute;n de otros titulares". Tenga en cuenta que dependiendo del n&uacute;mero de titulares de carga que informe deber&aacute;, m&aacute;s adelante, conseguir la notificaci&oacute;n a los mismos.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute;, en caso de que la certificaci&oacute;n registral sea correcta "Registrar requerimiento al deudor" y en caso contrario se iniciar&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>',
		/*TFI_ERROR_VALIDACION*/ '',/*TFI_VALIDACION*/ '',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ '',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarRecepcionCertCargas',/*TFI_ORDEN*/ '1',/*TFI_TIPO*/ 'date',/*TFI_NOMBRE*/ 'fechaRecepcion',/*TFI_LABEL*/ 'Fecha recepción',/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ '',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarRecepcionCertCargas',/*TFI_ORDEN*/ '2',/*TFI_TIPO*/ 'combo',/*TFI_NOMBRE*/ 'comboCorrecto',/*TFI_LABEL*/ 'Correcto',/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ 'DDSiNo',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarRecepcionCertCargas',/*TFI_ORDEN*/ '3',/*TFI_TIPO*/ 'text',/*TFI_NOMBRE*/ 'nuevoDomicilioDeudor',/*TFI_LABEL*/ 'Nuevo domicilio del deudor',/*TFI_ERROR_VALIDACION*/ '',/*TFI_VALIDACION*/ '',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ '',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarRecepcionCertCargas',/*TFI_ORDEN*/ '4',/*TFI_TIPO*/ 'text',/*TFI_NOMBRE*/ 'nuevoPropietario',/*TFI_LABEL*/ 'Nuevo propietario',/*TFI_ERROR_VALIDACION*/ '',/*TFI_VALIDACION*/ '',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ '',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarRecepcionCertCargas',/*TFI_ORDEN*/ '5',/*TFI_TIPO*/ 'text',/*TFI_NOMBRE*/ 'nuevoDomicilioPropietario',/*TFI_LABEL*/ 'Domicilio del nuevo propietario',/*TFI_ERROR_VALIDACION*/ '',/*TFI_VALIDACION*/ '',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ '',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarRecepcionCertCargas',/*TFI_ORDEN*/ '6',/*TFI_TIPO*/ 'combo',/*TFI_NOMBRE*/ 'comboOtrosTitulares',/*TFI_LABEL*/ 'Otros titulares de carga',/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ 'DDSiNo',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarRecepcionCertCargas',/*TFI_ORDEN*/ '7',/*TFI_TIPO*/ 'currency',/*TFI_NOMBRE*/ 'numeroDeOtrosTitulares',/*TFI_LABEL*/ 'Nmero de otros titulares de carga',/*TFI_ERROR_VALIDACION*/ '',/*TFI_VALIDACION*/ '',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ '',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarRecepcionCertCargas',/*TFI_ORDEN*/ '8',/*TFI_TIPO*/ 'textarea',/*TFI_NOMBRE*/ 'descripcionOtrosTitulares',/*TFI_LABEL*/ 'Descripción otros titulares',/*TFI_ERROR_VALIDACION*/ '',/*TFI_VALIDACION*/ '',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ '',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarRecepcionCertCargas',/*TFI_ORDEN*/ '9',/*TFI_TIPO*/ 'textarea',/*TFI_NOMBRE*/ 'observaciones',/*TFI_LABEL*/ 'Observaciones',/*TFI_ERROR_VALIDACION*/ '',/*TFI_VALIDACION*/ '',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ '',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarRequerimientoAdeudor',/*TFI_ORDEN*/ '0',/*TFI_TIPO*/ 'label',/*TFI_NOMBRE*/ 'titulo',
		/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">A trav&oecute;s de esta pantalla deber&aacute; informar la fecha en la que se emite el requerimiento al deudor as&iacute; como el resultado de dicho requerimiento.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute;, en caso de que el resultado del requerimiento sea Positivo "Registrar pago del deudor" y en caso contrario, que no se haya podido notificar al deudor, se iniciar&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>',
		/*TFI_ERROR_VALIDACION*/ '',/*TFI_VALIDACION*/ '',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ '',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarRequerimientoAdeudor',/*TFI_ORDEN*/ '1',/*TFI_TIPO*/ 'date',/*TFI_NOMBRE*/ 'fecha',/*TFI_LABEL*/ 'Fecha de requerimiento',/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ '',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarRequerimientoAdeudor',/*TFI_ORDEN*/ '2',/*TFI_TIPO*/ 'combo',/*TFI_NOMBRE*/ 'comboResultado',/*TFI_LABEL*/ 'Notificado',/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ 'DDSiNo',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarRequerimientoAdeudor',/*TFI_ORDEN*/ '3',/*TFI_TIPO*/ 'textarea',/*TFI_NOMBRE*/ 'observaciones',/*TFI_LABEL*/ 'Observaciones',/*TFI_ERROR_VALIDACION*/ '',/*TFI_VALIDACION*/ '',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ '',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
					
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarPagoDelDeudor',/*TFI_ORDEN*/ '0',/*TFI_TIPO*/ 'label',/*TFI_NOMBRE*/ 'titulo',
		/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; informar si el deudor ha pagado en plazo o no la deuda pendiente.</p><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute;, en caso de que el deudor no haya pagado "Registrar notificaci&oacute;n de inicio de actuaciones" y en caso de haber pagado se iniciar&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>',
		/*TFI_ERROR_VALIDACION*/ '',/*TFI_VALIDACION*/ '',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ '',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarPagoDelDeudor',/*TFI_ORDEN*/ '1',/*TFI_TIPO*/ 'combo',/*TFI_NOMBRE*/ 'comboPagoEnPlazo',/*TFI_LABEL*/ 'Pago del deudor en plazo',/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ 'DDSiNo',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarPagoDelDeudor',/*TFI_ORDEN*/ '2',/*TFI_TIPO*/ 'textarea',/*TFI_NOMBRE*/ 'observaciones',/*TFI_LABEL*/ 'Observaciones',/*TFI_ERROR_VALIDACION*/ '',/*TFI_VALIDACION*/ '',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ '',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarNotificacion',/*TFI_ORDEN*/ '0',/*TFI_TIPO*/ 'label',/*TFI_NOMBRE*/ 'titulo',
		/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; informar el sujeto a qui&eacute;n se quiere notificar as&iacute; como el resultado de la notificaci&oacute;n. En caso de haber podido notificar tambi&eacute;n deber&aacute; informar la fecha en la que se haya producido dicha notificaci&oacute;n.</p><p style="margin-bottom: 10px">En caso de que queden sujetos por notificar, se lanzar&aacute; el tr&aacute;mite de notificaci&oacute;n hasta que no queden sujetos por notificar.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">La tarea no quedar&aacute; finalizada hasta que no est&eacute;n todos los sujetos notificados. En el caso de no haber podido notificar a los sujetos, se iniciar&aacute; una tarea en la que propondr&aacute; seg&uacute;n su criterio la siguiente actuaci&oacute;n al responsable de la entidad.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Registrar anuncio de subasta".</p></div>',
		/*TFI_ERROR_VALIDACION*/ '',/*TFI_VALIDACION*/ '',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ '',/*VERSION*/ '2',/*USUARIOCREAR*/ 'DD'),		
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarNotificacion',/*TFI_ORDEN*/ '1',/*TFI_TIPO*/ 'textarea',/*TFI_NOMBRE*/ 'titularesConsignados',/*TFI_LABEL*/ 'Otros titulares consignados',/*TFI_ERROR_VALIDACION*/ '',/*TFI_VALIDACION*/ '',/*TFI_VALOR_INICIAL*/ 'valores[''H036_registrarRecepcionCertCargas''][''descripcionOtrosTitulares'']',/*TFI_BUSINESS_OPERATION*/ '',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarNotificacion',/*TFI_ORDEN*/ '2',/*TFI_TIPO*/ 'text',/*TFI_NOMBRE*/ 'sujeto',/*TFI_LABEL*/ 'Sujeto a notificar',/*TFI_ERROR_VALIDACION*/ '',/*TFI_VALIDACION*/ '',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ '',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarNotificacion',/*TFI_ORDEN*/ '3',/*TFI_TIPO*/ 'combo',/*TFI_NOMBRE*/ 'comboNotificado',/*TFI_LABEL*/ 'Notificado',/*TFI_ERROR_VALIDACION*/ '',/*TFI_VALIDACION*/ '',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ 'DDSiNo',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarNotificacion',/*TFI_ORDEN*/ '4',/*TFI_TIPO*/ 'date',/*TFI_NOMBRE*/ 'fecha',/*TFI_LABEL*/ 'Fecha notificación',/*TFI_ERROR_VALIDACION*/ '',/*TFI_VALIDACION*/ '',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ '',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarNotificacion',/*TFI_ORDEN*/ '5',/*TFI_TIPO*/ 'combo',/*TFI_NOMBRE*/ 'comboPorNotificar',/*TFI_LABEL*/ 'Quedan sujetos por notificar',/*TFI_ERROR_VALIDACION*/ '',/*TFI_VALIDACION*/ '',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ 'DDSiNo',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarNotificacion',/*TFI_ORDEN*/ '6',/*TFI_TIPO*/ 'textarea',/*TFI_NOMBRE*/ 'observaciones',/*TFI_LABEL*/ 'Observaciones',/*TFI_ERROR_VALIDACION*/ '',/*TFI_VALIDACION*/ '',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ '',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarAnuncioSubasta',/*TFI_ORDEN*/ '0',/*TFI_TIPO*/ 'label',/*TFI_NOMBRE*/ 'titulo',
		/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; informar, por un lado, fecha de auto declarando subasta, fecha de registro, la fecha de la subasta y fecha BOP o DG C.A. Tambi&eacute;n deber&aacute; informar si es vivienda Habitual en el campo correspondiente.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Registrar solicitud de tasaci&oacute;n"</p></div>',
		/*TFI_ERROR_VALIDACION*/ '',/*TFI_VALIDACION*/ '',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ '',/*VERSION*/ '1',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarAnuncioSubasta',/*TFI_ORDEN*/ '1',/*TFI_TIPO*/ 'date',/*TFI_NOMBRE*/ 'fechaAuto',/*TFI_LABEL*/ 'Fecha Auto',/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ '',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarAnuncioSubasta',/*TFI_ORDEN*/ '2',/*TFI_TIPO*/ 'date',/*TFI_NOMBRE*/ 'fechaSubasta',/*TFI_LABEL*/ 'Fecha señalamiento subasta',/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ '',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarAnuncioSubasta',/*TFI_ORDEN*/ '3',/*TFI_TIPO*/ 'date',/*TFI_NOMBRE*/ 'fechaRegistro',/*TFI_LABEL*/ 'Fecha registro',/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ '',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarAnuncioSubasta',/*TFI_ORDEN*/ '4',/*TFI_TIPO*/ 'combo',/*TFI_NOMBRE*/ 'comboVivienda',/*TFI_LABEL*/ 'Vivienda habitual',/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ 'DDSiNo',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarAnuncioSubasta',/*TFI_ORDEN*/ '5',/*TFI_TIPO*/ 'date',/*TFI_NOMBRE*/ 'fechaBOP',/*TFI_LABEL*/ 'Fecha BOP o DG CA',/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ '',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_TFI(/*DD_TAP_ID*/ 'H036_registrarAnuncioSubasta',/*TFI_ORDEN*/ '6',/*TFI_TIPO*/ 'textarea',/*TFI_NOMBRE*/ 'observaciones',/*TFI_LABEL*/ 'Observaciones',/*TFI_ERROR_VALIDACION*/ '',/*TFI_VALIDACION*/ '',/*TFI_VALOR_INICIAL*/ '',/*TFI_BUSINESS_OPERATION*/ '',/*VERSION*/ '0',/*USUARIOCREAR*/ 'DD'),
		
		
/*
	H036_RegistrarEnvioComunicacionAlTitular
*/
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_RegistrarEnvioComunicacionAlTitular',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; informar la fecha en la que envi&oacute; por correo certificado la comunicaci&oacute;n al titular del dominio.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Registrar recepci&oacute;n de comunicaci&oacute;n al titular del dominio".</p></div>',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),	
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_RegistrarEnvioComunicacionAlTitular',
			/*TFI_ORDEN*/ '1',
			/*TFI_TIPO*/ 'date',
			/*TFI_NOMBRE*/ 'fecha',
			/*TFI_LABEL*/ 'Fecha envío correo certificado',
			/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
			/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_RegistrarEnvioComunicacionAlTitular',
			/*TFI_ORDEN*/ '2',
			/*TFI_TIPO*/ 'textarea',
			/*TFI_NOMBRE*/ 'observaciones',
			/*TFI_LABEL*/ 'Observaciones',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
		
/*
	H036_RegistrarRecepcionComunicacionAlTitular
*/
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_RegistrarRecepcionComunicacionAlTitular',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; informar la fecha en la que fue recibido el correo certificado por el titular del dominio.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla, la siguiente tarea ser&aacute; "Celebraci&oacute;n de la subasta"</p></div>',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_RegistrarRecepcionComunicacionAlTitular',
			/*TFI_ORDEN*/ '1',
			/*TFI_TIPO*/ 'date',
			/*TFI_NOMBRE*/ 'fecha',
			/*TFI_LABEL*/ 'Fecha recepción correo certificado',
			/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
			/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_RegistrarRecepcionComunicacionAlTitular',
			/*TFI_ORDEN*/ '2',
			/*TFI_TIPO*/ 'textarea',
			/*TFI_NOMBRE*/ 'observaciones',
			/*TFI_LABEL*/ 'Observaciones',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
		
/*
	H036_RegistrarSolicitudTasacion
*/
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_RegistrarSolicitudTasacion',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; informar la fecha en la que solicita la tasaci&oacute;n interna sobre el bien.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Registrar recepci&oacute;n de la tasaci&oacute;n"</p></div>',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),	
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_RegistrarSolicitudTasacion',
			/*TFI_ORDEN*/ '1',
			/*TFI_TIPO*/ 'date',
			/*TFI_NOMBRE*/ 'fecha',
			/*TFI_LABEL*/ 'Fecha solicitud',
			/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
			/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_RegistrarSolicitudTasacion',
			/*TFI_ORDEN*/ '2',
			/*TFI_TIPO*/ 'textarea',
			/*TFI_NOMBRE*/ 'observaciones',
			/*TFI_LABEL*/ 'Observaciones',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
		
/*
	H036_RegistrarRecepcionTasacion 
*/
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_RegistrarRecepcionTasacion',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; informar la fecha en la que recibe la tasaci&oacute;n interna del bien.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_RegistrarRecepcionTasacion',
			/*TFI_ORDEN*/ '1',
			/*TFI_TIPO*/ 'date',
			/*TFI_NOMBRE*/ 'fecha',
			/*TFI_LABEL*/ 'Fecha recepción',
			/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
			/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_RegistrarRecepcionTasacion',
			/*TFI_ORDEN*/ '2',
			/*TFI_TIPO*/ 'textarea',
			/*TFI_NOMBRE*/ 'observaciones',
			/*TFI_LABEL*/ 'Observaciones',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		

		
/*
	H036_PrepararInformeSubasta
*/		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_PrepararInformeSubasta',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Para dar por completada esta tarea deber&aacute; acceder desde la pestaña Subastas del asunto correspondiente a cada uno de los bienes afectos a la subasta e indicar los importes para la puja sin postores, puja con postores desde y puja con postores hasta. Una vez hecho esto podr&aacute; generar desde la pestaña Subastas el informe con la propuesta de instrucciones para la subasta en formato Word, de forma que en caso de ser necesario pueda modificarlo.</p><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&aacute; adjuntar el informe con la propuesta de instrucciones para la subasta al procedimiento correspondiente.</p><p style="margin-bottom: 10px">En el campo Fecha deber&aacute; informar la fecha en la que haya adjuntado el informe con las instrucciones para la subasta.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea "Validar propuesta de instrucciones" a realizar por el gestor de concurso y litigios.</p></div>',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),	
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_PrepararInformeSubasta',
			/*TFI_ORDEN*/ '1',
			/*TFI_TIPO*/ 'date',
			/*TFI_NOMBRE*/ 'fecha',
			/*TFI_LABEL*/ 'Fecha',
			/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
			/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_PrepararInformeSubasta',
			/*TFI_ORDEN*/ '2',
			/*TFI_TIPO*/ 'textarea',
			/*TFI_NOMBRE*/ 'observaciones',
			/*TFI_LABEL*/ 'Observaciones',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
				
/*
	H036_ValidarPropuesta 
*/		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_ValidarPropuesta',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea deber&aacute;  revisar y dictaminar sobre la propuesta de instrucciones  e informar si la propuesta es delegada o no.</p><p style="margin-bottom: 10px">- En caso de seguir con la subasta y la propuesta est&eacute; delegada internamente  y disponga de atribuciones, se lanzar&aacute; la tarea de  "Lectura y aceptaci&oacute;n  de Instrucciones" y en el caso que no tenga atribuciones suficientes, se lanzar&aacute; la tarea de "Elevar Propuesta a Comit&eacute;" para  la aprobaci&oacute;n por el Comit&eacute;.</p><p style="margin-bottom: 10px">- En caso que la subasta sea No delegada, para decidir sobre la subasta, se lanzar&aacute; la tarea "Elevar propuesta a Sareb" para obtener instrucciones desde Sareb.</p><p style="margin-bottom: 10px">- En el caso que se haya dictaminado la suspensi&oacute;n de la subasta, debe indicarlo en el campo Suspender SI/NO y, se lanzar&aacute; la tarea de "Suspender Subasta"</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p></div>',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_ValidarPropuesta',
			/*TFI_ORDEN*/ '1',
			/*TFI_TIPO*/ 'combo',
			/*TFI_NOMBRE*/ 'suspender',
			/*TFI_LABEL*/ 'Suspender',
			/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
			/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ 'DDSiNo',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_ValidarPropuesta',
			/*TFI_ORDEN*/ '2',
			/*TFI_TIPO*/ 'combo',
			/*TFI_NOMBRE*/ 'delegada',
			/*TFI_LABEL*/ 'Delegada',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ 'DDSiNo',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),	
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_ValidarPropuesta',
			/*TFI_ORDEN*/ '3',
			/*TFI_TIPO*/ 'combo',
			/*TFI_NOMBRE*/ 'conAtribuciones',
			/*TFI_LABEL*/ 'Con atribuciones',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ 'DDSiNo',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),	
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_ValidarPropuesta',
			/*TFI_ORDEN*/ '4',
			/*TFI_TIPO*/ 'textarea',
			/*TFI_NOMBRE*/ 'observaciones',
			/*TFI_LABEL*/ 'Observaciones',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
				
		
/*
	H036_SuspenderSubasta
*/		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_SuspenderSubasta',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Dado que la entidad ha decidido suspender la subasta, para dar por completada esta tarea deber&aacute;  proceder a dicha suspensi&oacute;n, indicando en el campo Fecha suspensi&oacute;n, la fecha en que se haya suspendido la subasta y el motivo de suspensi&oacute;n.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla se le abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),
		T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H036_SuspenderSubasta',
            /*TFI_ORDEN..............:*/ '1',
            /*TFI_TIPO...............:*/ 'date',
            /*TFI_NOMBRE.............:*/ 'fechaSuspension',
            /*TFI_LABEL..............:*/ 'Fecha suspensión',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),  
        
		T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H036_SuspenderSubasta',
            /*TFI_ORDEN..............:*/ '2',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboMotivoSuspension',
            /*TFI_LABEL..............:*/ 'Motivo suspensión',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDMotivoSuspension',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        
		T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H036_SuspenderSubasta',
            /*TFI_ORDEN..............:*/ '3',
            /*TFI_TIPO...............:*/ 'textarea',
            /*TFI_NOMBRE.............:*/ 'observaciones',
            /*TFI_LABEL..............:*/ 'Observaciones',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),		
		
/*
	H036_ElevarPropuestaAComite 
*/		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_ElevarPropuestaAComite',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&aacute; elevar la propuesta de subasta al comit&eacute; para su aprobaci&oacute;n informando de la fecha en que eleva la propuesta. En el caso que sea aceptada la propuesta por el comit&eacute;, se lanzar&aacute; la siguiente tarea al letrado de "Lectura y Aceptaci&oacute;n de Instrucciones" y en el caso que se requiera de alguna modificaci&oacute;n, se volver&aacute; a la tarea de "Preparar Propuesta Subasta".</p><p style="margin-bottom: 10px">En el caso que el Comit&eacute; dictamine la suspensi&oacute;n de la subasta, se lanzar&aacute; la tarea de "Suspender la Subasta"</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p></div>',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
		T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H036_ElevarPropuestaAComite',
            /*TFI_ORDEN..............:*/ '1',
            /*TFI_TIPO...............:*/ 'date',
            /*TFI_NOMBRE.............:*/ 'fechaElevacion',
            /*TFI_LABEL..............:*/ 'Fecha que se eleva la propuesta',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        
		T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H036_ElevarPropuestaAComite',
            /*TFI_ORDEN..............:*/ '2',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboResultadoComite',
            /*TFI_LABEL..............:*/ 'Resultado del Comité',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDResultadoComiteConcursal',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),        
        
		T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H036_ElevarPropuestaAComite',
            /*TFI_ORDEN..............:*/ '3',
            /*TFI_TIPO...............:*/ 'textarea',
            /*TFI_NOMBRE.............:*/ 'observaciones',
            /*TFI_LABEL..............:*/ 'Observaciones',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),		
		
/*
	H036_LecturaYAceptacionInstrucciones
*/	
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_LecturaYAceptacionInstrucciones',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Una vez que ha sido anunciada la subasta, y han sido dictadas las instrucciones, antes de dar por completada esta tarea deber&aacute; acceder a la pestaña "Subastas" de la ficha del asunto correspondiente y revisar las instrucciones dadas para cada uno de los bienes a subastar.</p><p style="margin-bottom: 10px">Informando la fecha se confirma haber recibido correctamente las instrucciones del responsable de la entidad, as&iacute; como la aceptaci&oacute;n de las mismas. Para el supuesto de que haya alguna duda al respecto, deber&aacute; ponerse en contacto con el responsable de la entidad para que se revisen o modifiquen dichas instrucciones.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento</p></div>',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),	
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_LecturaYAceptacionInstrucciones',
			/*TFI_ORDEN*/ '1',
			/*TFI_TIPO*/ 'date',
			/*TFI_NOMBRE*/ 'fecha',
			/*TFI_LABEL*/ 'Fecha',
			/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
			/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_LecturaYAceptacionInstrucciones',
			/*TFI_ORDEN*/ '2',
			/*TFI_TIPO*/ 'textarea',
			/*TFI_NOMBRE*/ 'observaciones',
			/*TFI_LABEL*/ 'Observaciones',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
	
/* H036_CelebracionSubasta */
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_CelebracionSubasta',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; indicar si se ha celebrado la subasta o no. En caso de haberse celebrado deber&aacute; informar la fecha de celebraci&oacute;n, si la entidad se ha adjudicado el bien o si se lo ha adjudicado un tercero.</p><p style="margin-bottom: 10px">En el caso que no se celebre la subasta, deber&aacute; indicar  el motivo de suspensi&oacute;n  y tomar una decisi&oacute;n para seguir con la actuaci&oacute;n que corresponda.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute;, en caso de haberse adjudicado el bien la entidad sin cesi&oacute;n de remate "Registrar liquidaci&oacute;n del precio de remate", en el caso de hab&eacute;rsela adjudicado la Entidad con cesi&oacute;n de remate " Registrar cesi&oacute;n de remate" &oacute; en caso de hab&eacute;rselo adjudicado un tercero se iniciar&aacute; una tarea en la que propondr&aacute;, según su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),	
		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_CelebracionSubasta',
			/*TFI_ORDEN*/ '1',
			/*TFI_TIPO*/ 'combo',
			/*TFI_NOMBRE*/ 'celebrada',
			/*TFI_LABEL*/ 'Celebrada',
			/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
			/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ 'DDSiNo',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),	
		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_CelebracionSubasta',
			/*TFI_ORDEN*/ '2',
			/*TFI_TIPO*/ 'date',
			/*TFI_NOMBRE*/ 'fechaSubasta',
			/*TFI_LABEL*/ 'Fecha subasta',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ 'valores[''H036_registrarAnuncioSubasta''][''fechaSubasta'']',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_CelebracionSubasta',
			/*TFI_ORDEN*/ '3',
			/*TFI_TIPO*/ 'combo',
			/*TFI_NOMBRE*/ 'adjudicacionEntidad',
			/*TFI_LABEL*/ 'Adjudicación entidad',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ 'DDSiNo',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_CelebracionSubasta',
			/*TFI_ORDEN*/ '4',
			/*TFI_TIPO*/ 'combo',
			/*TFI_NOMBRE*/ 'cesionRemate',
			/*TFI_LABEL*/ 'Cesión remate',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ 'DDSiNo',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_CelebracionSubasta',
			/*TFI_ORDEN*/ '5',
			/*TFI_TIPO*/ 'combo',
			/*TFI_NOMBRE*/ 'adjudicacionAUnTercero',
			/*TFI_LABEL*/ 'Adjudicación a un tercero',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ 'DDSiNo',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),
		T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H036_CelebracionSubasta',
            /*TFI_ORDEN..............:*/ '6',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboMotivoSuspension',
            /*TFI_LABEL..............:*/ 'Motivo suspensión',
            /*TFI_ERROR_VALIDACION...:*/ '',
            /*TFI_VALIDACION.........:*/ '',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDMotivoSuspSubasta',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_CelebracionSubasta',
			/*TFI_ORDEN*/ '7',
			/*TFI_TIPO*/ 'textarea',
			/*TFI_NOMBRE*/ 'observaciones',
			/*TFI_LABEL*/ 'Observaciones',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
		

/* H036_RegistrarCesionRemate */
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_RegistrarCesionRemate',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; informar la fecha en la que se produce la cesi&oacute;n del remate.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Registrar liquidaci&oacute;n del precio de remate"</p></div>',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_RegistrarCesionRemate',
			/*TFI_ORDEN*/ '1',
			/*TFI_TIPO*/ 'date',
			/*TFI_NOMBRE*/ 'fechaCesion',
			/*TFI_LABEL*/ 'Fecha cesión',
			/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
			/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_RegistrarCesionRemate',
			/*TFI_ORDEN*/ '2',
			/*TFI_TIPO*/ 'textarea',
			/*TFI_NOMBRE*/ 'observaciones',
			/*TFI_LABEL*/ 'Observaciones',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
		

/* H036_RegistrarLiquidacionPrecioDeRemate */
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_RegistrarLiquidacionPrecioDeRemate',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; informar la fecha en la que se procede a la liquidaci&oacute;n del precio del remate as&iacute; como las cuant&iacute;as por las que se paga al acreedor, el sobrante y los gastos.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla en la siguiente tarea se lanzar&aacute; el T.Inscripci&oacute;n del t&iacute;tulo.</p></div>',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_RegistrarLiquidacionPrecioDeRemate',
			/*TFI_ORDEN*/ '1',
			/*TFI_TIPO*/ 'date',
			/*TFI_NOMBRE*/ 'fecha',
			/*TFI_LABEL*/ 'Fecha',
			/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
			/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),	
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_RegistrarLiquidacionPrecioDeRemate',
			/*TFI_ORDEN*/ '2',
			/*TFI_TIPO*/ 'currency',
			/*TFI_NOMBRE*/ 'pagoAcreedor',
			/*TFI_LABEL*/ 'Pago al acreedor',
			/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
			/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),	
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_RegistrarLiquidacionPrecioDeRemate',
			/*TFI_ORDEN*/ '3',
			/*TFI_TIPO*/ 'currency',
			/*TFI_NOMBRE*/ 'sobrante',
			/*TFI_LABEL*/ 'Sobrante',
			/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
			/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),	
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_RegistrarLiquidacionPrecioDeRemate',
			/*TFI_ORDEN*/ '4',
			/*TFI_TIPO*/ 'currency',
			/*TFI_NOMBRE*/ 'gastos',
			/*TFI_LABEL*/ 'Gastos',
			/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
			/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_RegistrarLiquidacionPrecioDeRemate',
			/*TFI_ORDEN*/ '5',
			/*TFI_TIPO*/ 'textarea',
			/*TFI_NOMBRE*/ 'observaciones',
			/*TFI_LABEL*/ 'Observaciones',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),			

/* H036_BPMTramitePosesion */
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_BPMTramitePosesion',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Ejecuci&'||'oacute;n del tr&'||'aacute;mite de Posesi&oacute;n</p></div>',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),				       
   
/* H036_BPMTramiteElevacionPropSarebLitigios */	
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_BPMTramiteElevacionPropSarebLitigios',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Ejecuci&'||'oacute;n del tr&'||'aacute;mite de Elevaci&oacute;n a Sareb</p></div>',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
		
/* H036_BPMTramiteInscripcionDelTitulo */	
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_BPMTramiteInscripcionDelTitulo',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Ejecuci&'||'oacute;n del tr&'||'aacute;mite de Inscripci&oacute;n del t&iacute;tulo</p></div>',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		)     
                
    ); 
    V_TMP_TIPO_TFI T_TIPO_TFI;
    
    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(        
    
		T_TIPO_PLAZAS(/*DD_JUZ_ID*/ '',/*DD_PLA_ID*/ '',/*TAP_ID*/ 'H036_entregaActaRequerimiento',/*DD_PTP_PLAZO_SCRIPT*/ '5*24*60*60*1000L',/*VERSION*/ '0',/*BORRADO*/ '0',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_PLAZAS(/*DD_JUZ_ID*/ '',/*DD_PLA_ID*/ '',/*TAP_ID*/ 'H036_registrarSolicitudCertCargas',/*DD_PTP_PLAZO_SCRIPT*/ 'damePlazo(valores[''H036_entregaActaRequerimiento''][''fecha'']) + 10*24*60*60*1000L',/*VERSION*/ '0',/*BORRADO*/ '0',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_PLAZAS(/*DD_JUZ_ID*/ '',/*DD_PLA_ID*/ '',/*TAP_ID*/ 'H036_registrarRecepcionCertCargas',/*DD_PTP_PLAZO_SCRIPT*/ 'damePlazo(valores[''H036_registrarSolicitudCertCargas''][''fecha'']) + 10*24*60*60*1000L',/*VERSION*/ '0',/*BORRADO*/ '0',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_PLAZAS(/*DD_JUZ_ID*/ '',/*DD_PLA_ID*/ '',/*TAP_ID*/ 'H036_registrarRequerimientoAdeudor',/*DD_PTP_PLAZO_SCRIPT*/ 'damePlazo(valores[''H036_registrarRecepcionCertCargas''][''fechaRecepcion'']) + 10*24*60*60*1000L',/*VERSION*/ '0',/*BORRADO*/ '0',/*USUARIOCREAR*/ 'DD'),
		T_TIPO_PLAZAS(/*DD_JUZ_ID*/ '',/*DD_PLA_ID*/ '',/*TAP_ID*/ 'H036_registrarPagoDelDeudor',/*DD_PTP_PLAZO_SCRIPT*/ 'damePlazo(valores[''H036_registrarRequerimientoAdeudor''][''fecha'']) + 10*24*60*60*1000L',/*VERSION*/ '0',/*BORRADO*/ '0',/*USUARIOCREAR*/ 'DD'),
		
		--10 días a contar desde el registro del requerimiento al deudor, o bien hasta que no queden sujetos por notificar				
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H036_registrarNotificacion',
			/*DD_PTP_PLAZO_SCRIPT*/ '( valores[''H036_registrarRequerimientoAdeudor''][''comboPorNotificar''] == DDSiNo.NO ?	1*24*60*60*1000L : damePlazo(valores[''H036_registrarRequerimientoAdeudor''][''fecha'']) + 10*24*60*60*1000L )',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),
		
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H036_registrarAnuncioSubasta',
			/*DD_PTP_PLAZO_SCRIPT*/ 'damePlazo(valores[''H036_registrarNotificacion''][''fecha'']) + 20*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),
		

/*
	H036_RegistrarEnvioComunicacionAlTitular
*/		
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H036_RegistrarEnvioComunicacionAlTitular',
			/*DD_PTP_PLAZO_SCRIPT*/ 'damePlazo(valores[''H036_registrarRecepcionCertCargas''][''fechaRecepcion'']) + 10*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),		
		
/*
	H036_RegistrarRecepcionComunicacionAlTitular
*/
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H036_RegistrarRecepcionComunicacionAlTitular',
			/*DD_PTP_PLAZO_SCRIPT*/ 'damePlazo(valores[''H036_RegistrarEnvioComunicacionAlTitular''][''fecha'']) + 20*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),
		
/*
	H036_RegistrarSolicitudTasacion
*/
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H036_RegistrarSolicitudTasacion',
			/*DD_PTP_PLAZO_SCRIPT*/ 'damePlazo(valores[''H036_registrarAnuncioSubasta''][''fechaSubasta'']) + 3*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),		
		
/*
	H036_RegistrarRecepcionTasacion 
*/		
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H036_RegistrarRecepcionTasacion',
			/*DD_PTP_PLAZO_SCRIPT*/ 'damePlazo(valores[''H036_RegistrarSolicitudTasacion''][''fecha'']) + 10*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),		
		
/*
	H036_PrepararInformeSubasta
*/		
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H036_PrepararInformeSubasta',
			/*DD_PTP_PLAZO_SCRIPT*/ 'damePlazo(valores[''H036_registrarAnuncioSubasta''][''fechaSubasta'']) - 60*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),		
		
		
/*
	H036_ValidarPropuesta 
*/		
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H036_ValidarPropuesta',
			/*DD_PTP_PLAZO_SCRIPT*/ 'damePlazo(valores[''H036_registrarAnuncioSubasta''][''fechaSubasta'']) - 50*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),		
			
		
/*
	H036_SuspenderSubasta
*/	
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H036_SuspenderSubasta',
			/*DD_PTP_PLAZO_SCRIPT*/ '5*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),		
		
/*
	H036_ElevarPropuestaAComite 
*/		
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H036_ElevarPropuestaAComite',
			/*DD_PTP_PLAZO_SCRIPT*/ '3*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),		
		
/*
	H036_LecturaYAceptacionInstrucciones
*/		
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H036_LecturaYAceptacionInstrucciones',
			/*DD_PTP_PLAZO_SCRIPT*/ 'damePlazo(valores[''H036_registrarAnuncioSubasta''][''fechaSubasta'']) - 5*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),			
		
/* H036_CelebracionSubasta */
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H036_CelebracionSubasta',
			/*DD_PTP_PLAZO_SCRIPT*/ 'damePlazo(valores[''H036_registrarAnuncioSubasta''][''fechaSubasta''])',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),		

/* H036_RegistrarCesionRemate */
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H036_RegistrarCesionRemate',
			/*DD_PTP_PLAZO_SCRIPT*/ 'damePlazo(valores[''H036_CelebracionSubasta''][''fechaSubasta'']) + 20*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),		

/* H036_RegistrarLiquidacionPrecioDeRemate */
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H036_RegistrarLiquidacionPrecioDeRemate',
			/*DD_PTP_PLAZO_SCRIPT*/ 'damePlazo(valores[''H036_CelebracionSubasta''][''fechaSubasta'']) + 20*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),			

/* H036_BPMTramitePosesion */
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H036_BPMTramitePosesion',
			/*DD_PTP_PLAZO_SCRIPT*/ '300*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),
		
--H036_BPMTramiteElevacionPropSarebLitigios
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H036_BPMTramiteElevacionPropSarebLitigios',
			/*DD_PTP_PLAZO_SCRIPT*/ '300*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),
		
/* H036_BPMTramiteInscripcionDelTitulo */	
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H036_BPMTramiteInscripcionDelTitulo',
			/*DD_PTP_PLAZO_SCRIPT*/ '300*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		)		
				
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;    
    
BEGIN	

    -- LOOP Insertando valores en TAP_TAREA_PROCEDIMIENTO
    VAR_TABLENAME := 'DD_TPO_TIPO_PROCEDIMIENTO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar TAREAS');
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
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(1)),'''','''''') 
                    || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(2)),'''','''''') 
                    || ''',' || '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(3)),'''','''''') 
                    || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(4)),'''','''''') 
                    || ''',' || '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(5)),'''','''''') 
                    || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(6)),'''','''''') 
                    || ''',' || '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(7)),'''','''''') 
                    || ''',sysdate,' 
                    || '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(8)),'''','''''') 
                    || ''',' || '(SELECT DD_TAC_ID FROM '|| V_ESQUEMA ||'.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO=''' || TRIM(V_TMP_TIPO_TPO(9)) || '''),' ||
                    '''' || TRIM(V_TMP_TIPO_TPO(10)) 
                    || ''',''' || TRIM(V_TMP_TIPO_TPO(11)) 
                    || ''',''' || TRIM(V_TMP_TIPO_TPO(12)) 
                    || ''',' || '''' || TRIM(V_TMP_TIPO_TPO(13)) 
                    || ''',''' || TRIM(V_TMP_TIPO_TPO(14)) 
                    || ''',''' || TRIM(V_TMP_TIPO_TPO(15)) 
                    || ''' FROM DUAL'; 

            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            --DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TPO(1) ||''','''||TRIM(V_TMP_TIPO_TPO(2))||'''');
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
                    	'S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL, ' 
                    	|| '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(1)),'''','''''')  || '''),' 
                    	|| '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(2)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(3)),'''','''''') 
                    	|| ''',' || '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(4)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(5)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(6)),'''','''''') 
                    	|| ''',' || '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(7)),'''','''''') || '''),' 
                    	|| '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(8)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(9)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(10)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(11)),'''','''''') 
                    	|| ''',' || 'sysdate,''' || REPLACE(TRIM(V_TMP_TIPO_TAP(12)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(13)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(14)),'''','''''') 
                    	|| ''',' || '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(15)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(16)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(17)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(18)),'''','''''') 
                    	|| ''',' || '(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(19)) || '''),' 
                    	|| '(SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' 
                    	|| ''''|| REPLACE(TRIM(V_TMP_TIPO_TAP(21)),'''','''''') 
                    	|| ''',' ||'(select dd_tge_id from ' || V_ESQUEMA_MASTER || '.dd_tge_tipo_gestor where dd_tge_codigo='''|| REPLACE(TRIM(V_TMP_TIPO_TAP(22)),'''','''''') || ''')'
                    	|| ',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(23)),'''','''''') 
                    	|| ''' FROM DUAL';
                    
            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            --DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TAP(2)||''','''||TRIM(V_TMP_TIPO_TAP(9))||'''');
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

            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            --DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_PLAZAS(3) ||''','''||TRIM(V_TMP_TIPO_PLAZAS(4))||'''');
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
            --DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TFI(1) ||''','''||TRIM(V_TMP_TIPO_TFI(4))||'''');
            EXECUTE IMMEDIATE V_MSQL;
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Campos');

    /*
     * Desactivamos trámites antiguos si existen
     */
    V_CODIGO_TPO := 'DD_TPO_CODIGO';
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||PAR_TABLENAME_TPROC||' WHERE '||V_CODIGO_TPO||' = '''||CODIGO_PROCEDIMIENTO_ANTIGUO_1||''' AND BORRADO=0 ';
        
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN
	    V_SQL := 'UPDATE '||V_ESQUEMA||'.'||PAR_TABLENAME_TPROC||' SET BORRADO=1 WHERE '||V_CODIGO_TPO||' = '''||CODIGO_PROCEDIMIENTO_ANTIGUO_1||''' AND BORRADO=0 ';
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