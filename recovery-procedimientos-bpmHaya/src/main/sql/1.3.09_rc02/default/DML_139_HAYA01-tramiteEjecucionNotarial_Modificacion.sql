--######################################################################
--## Author: Nacho
--## BPM: T. Ejecución Notarial (H036)
--## Finalidad: Insertar y modificación de datos en tablas de configuración del BPM
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

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(   
    
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H036',
			/*TAP_CODIGO*/ 'H036_ObtenerMinuta',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ 'comprobarExisteDocumentoMINEN() ? null : ''Debe adjuntar el documento "Minuta (T. Ejecuci&oacute;n Notarial o Extrajudicial)"'' ',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ '',
			/*DD_TPO_ID_BPM*/ '',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Obtener la minuta',
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
			/*DD_TSUP_ID*/ 'SFIS',
			/*TAP_BUCLE_BPM*/ ''
		),
		
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H036',
			/*TAP_CODIGO*/ 'H036_ValidarMinuta',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ '',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ '',
			/*DD_TPO_ID_BPM*/ '',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Validar la minuta',
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
			/*DD_STA_ID*/ '809',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ 'SFIS',
			/*TAP_BUCLE_BPM*/ ''
		),
		
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H036',
			/*TAP_CODIGO*/ 'H036_RegistrarRecepcionEscritura',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ '',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ '',
			/*DD_TPO_ID_BPM*/ '',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Registrar recepción de escritura',
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
			/*TAP_CODIGO*/ 'H036_SolicitarMandamientoPago',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ '',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ '',
			/*DD_TPO_ID_BPM*/ '',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Solicitar mandamiento de pago',
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
			/*TAP_CODIGO*/ 'H036_ConfirmarRecepcionMandamientoPago',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ 'comprobarExisteDocumentoMPEN() ? null : ''Debe adjuntar el documento "Mandamiento de Pago (T. Ejecuci&oacute;n Notarial o Extrajudicial)"'' ',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ '',
			/*DD_TPO_ID_BPM*/ '',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Confirmar recepción de mandamiento de pago',
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
			/*TAP_CODIGO*/ 'H036_SolicitarServicioIndices',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ '',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ 'valores[''H036_SolicitarServicioIndices''][''comboDeuda''] == DDSiNo.SI ? ''DEUDACUBIERTA'' : ''DEUDANOCUBIERTA'' ',
			/*DD_TPO_ID_BPM*/ '',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Solicitar servicio índices',
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
			/*DD_STA_ID*/ '803',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ 'GUCL',
			/*TAP_BUCLE_BPM*/ ''
		),
		
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H036',
			/*TAP_CODIGO*/ 'H036_ElevarPropuestaSareb',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ 'comprobarExisteDocumentoRSIEN() ? null : ''Debe adjuntar el documento "Resultado servicio &iacute;ndices (T. Ejecuci&oacute;n Notarial o Extrajudicial)"'' ',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ '',
			/*DD_TPO_ID_BPM*/ '',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Elevar propuesta a Sareb (Servicio índices)',
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
			/*DD_STA_ID*/ '803',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ 'GUCL',
			/*TAP_BUCLE_BPM*/ ''
		),
		
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H036',
			/*TAP_CODIGO*/ 'H036_RegistrarRespuestaSareb',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ 'comprobarExisteDocumentoRSARINE() ? null : ''Debe adjuntar el documento "Respuesta Sareb &iacute;ndices (T. Ejecuci&oacute;n Notarial o Extrajudicial)"'' ',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ '',
			/*DD_TPO_ID_BPM*/ '',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Registrar respuesta Sareb (Servicio índices)',
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
			/*DD_STA_ID*/ '803',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ 'GUCL',
			/*TAP_BUCLE_BPM*/ ''
		),
		
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H036',
			/*TAP_CODIGO*/ 'H036_ElevarPropuestaSarebSub',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ 'comprobarExisteDocumentoPSUSB() ? null : ''Debe adjuntar el documento "Plantilla subasta SAREB (T. Ejecución Notarial o Extrajudicial)"'' ',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ '',
			/*DD_TPO_ID_BPM*/ '',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Elevar propuesta a Sareb',
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
			/*DD_TSUP_ID*/ 'DUCL',
			/*TAP_BUCLE_BPM*/ ''
		),
		
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H036',
			/*TAP_CODIGO*/ 'H036_RegistrarRespuestaSarebSub',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ 'comprobarExisteDocumentoRSARE() ? null : ''Debe adjuntar el documento "Respuesta SAREB (T. Ejecución Notarial o Extrajudicial)"'' ',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ 'valores[''H036_RegistrarRespuestaSarebSub''][''comboResultado''] == ''DENEGADA'' ? ''DENEGADA'': ''ACEPTADA'' ',
			/*DD_TPO_ID_BPM*/ '',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Registrar respuesta Sareb',
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
			/*DD_TSUP_ID*/ 'DUCL',
			/*TAP_BUCLE_BPM*/ ''
		)
			
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI( 

		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_ObtenerMinuta',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla, el letrado debe infomar de la fecha de recepci&oacute;n de la minuta y, adjuntar la minuta para poder dar por finalizada la tarea.</p><p style="margin-bottom: 10px">En el campo observaciones infomar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta tarea se lanzar&aacute; la tarea "Validar la minuta".</p></div>',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),	
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_ObtenerMinuta',
			/*TFI_ORDEN*/ '1',
			/*TFI_TIPO*/ 'date',
			/*TFI_NOMBRE*/ 'fecha',
			/*TFI_LABEL*/ 'Fecha recepción minuta',
			/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
			/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_ObtenerMinuta',
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
		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_ValidarMinuta',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla, el area fiscal debe validar la minuta recibida por parte del letrado e informar de la fecha de validaci&oacute;n de la misma.</p><p style="margin-bottom: 10px">En el campo observaciones infomar cualquier aspecto relevanete que le interesa quede reflejado en este punto del procedimiento.</p></div>',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_ValidarMinuta',
			/*TFI_ORDEN*/ '1',
			/*TFI_TIPO*/ 'date',
			/*TFI_NOMBRE*/ 'fecha',
			/*TFI_LABEL*/ 'Fecha validación minuta',
			/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
			/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_ValidarMinuta',
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

		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_RegistrarRecepcionEscritura',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; informar la fecha de recepci&oacute;n de la escritura del bien.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),	
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_RegistrarRecepcionEscritura',
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
			/*DD_TAP_ID*/ 'H036_RegistrarRecepcionEscritura',
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
		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_SolicitarMandamientoPago',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que alguno de los bienes ha sido adjudicado a un tercero, en esta pantalla debemos de informar la fecha de presentaci&oacute;n en el juzgado del escrito solicitando la entrega de las cantidades consignadas.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute; "Confirmar recepci&oacute;n mandamiento de pago".</p></div>',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),	
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_SolicitarMandamientoPago',
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
			/*DD_TAP_ID*/ 'H036_SolicitarMandamientoPago',
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
		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_ConfirmarRecepcionMandamientoPago',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que alguno de los bienes ha sido adjudicado a un tercero, en esta pantalla debemos de informar la fecha de presentaci&oacute;n en el juzgado del escrito solicitando la entrega de las cantidades consignadas.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute; "Confirmar recepci&oacute;n mandamiento de pago".</p></div>',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),	
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_ConfirmarRecepcionMandamientoPago',
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
			/*DD_TAP_ID*/ 'H036_ConfirmarRecepcionMandamientoPago',
			/*TFI_ORDEN*/ '2',
			/*TFI_TIPO*/ 'currency',
			/*TFI_NOMBRE*/ 'importe',
			/*TFI_LABEL*/ 'Importe',
			/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
			/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_ConfirmarRecepcionMandamientoPago',
			/*TFI_ORDEN*/ '3',
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
		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_SolicitarServicioIndices',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla, deber&aacute; informar si se ha cobrado total o parcialmente la deuda por la adjudicaci&oacute;n de un inmueble  por un tercero, en el supuesto de que el cobro haya sido parcial se debe solicitar servicio de &iacute;ndices para decidir c&oacute;mo continuar con el procedimiento.</p><p style="margin-bottom: 10px">En el campo Fecha deber&aacute; indicar la fecha en la que se realiza la petici&oacute;n.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">El siguiente paso ser&aacute; "Elevar una propuesta a Sareb" para decidir c&oacute;mo continuar el procedimiento.</p></div>',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),	
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_SolicitarServicioIndices',
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
			/*DD_TAP_ID*/ 'H036_SolicitarServicioIndices',
			/*TFI_ORDEN*/ '2',
			/*TFI_TIPO*/ 'combo',
			/*TFI_NOMBRE*/ 'comboDeuda',
			/*TFI_LABEL*/ 'Cubierta totalmente la deuda',
			/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
			/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ 'DDSiNo',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_SolicitarServicioIndices',
			/*TFI_ORDEN*/ '3',
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
		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_ElevarPropuestaSareb',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que se ha cobrado parcialmente la deuda por la adjudicaci&oacute;n de un inmueble por un tercero y se ha solicitado servicio de &iacute;ndices para decidir c&oacute;mo continuar con el procedimiento, se ha de solicitar instrucciones a SAREB al respecto de c&oacute;mo continuar el procedimiento.</p><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; adjuntar el informe con la propuesta elevada a SAREB v&iacute;a workflow.</p><p style="margin-bottom: 10px">En el campo Fecha indicar la fecha de presentaci&oacute;n de la solicitud v&iacute;a workflow.</p><p style="margin-bottom: 10px">En el campo N&uacute;m. Propuesta Sareb indicar el n&uacute;mero de la propuesta en workflow.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla se le abrir&aacute; una tarea para registrar la respuesta recibida desde SAREB.</p></div>',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),	
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_ElevarPropuestaSareb',
			/*TFI_ORDEN*/ '1',
			/*TFI_TIPO*/ 'date',
			/*TFI_NOMBRE*/ 'fecha',
			/*TFI_LABEL*/ 'Fecha presentación',
			/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
			/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_ElevarPropuestaSareb',
			/*TFI_ORDEN*/ '2',
			/*TFI_TIPO*/ 'number',
			/*TFI_NOMBRE*/ 'numProp',
			/*TFI_LABEL*/ 'Núm. Propuesta',
			/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
			/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_ElevarPropuestaSareb',
			/*TFI_ORDEN*/ '3',
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
		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_RegistrarRespuestaSareb',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea deber&aacute; registrar la respuesta de SAREB, obtenida v&iacute;a workflow, sobre la propuesta elevada a SAREB, que deber&aacute; adjuntar como adjunto al asunto.</p><p style="margin-bottom: 10px">En el campo Fecha indicar la fecha en la que se recibe la respuesta desde SAREB.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla se le abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),			
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_RegistrarRespuestaSareb',
			/*TFI_ORDEN*/ '1',
			/*TFI_TIPO*/ 'number',
			/*TFI_NOMBRE*/ 'numProp',
			/*TFI_LABEL*/ 'Núm. Propuesta',
			/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
			/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',
			/*TFI_VALOR_INICIAL*/ 'valores[''H036_ElevarPropuestaSareb''][''numProp'']',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),	
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_RegistrarRespuestaSareb',
			/*TFI_ORDEN*/ '2',
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
			/*DD_TAP_ID*/ 'H036_RegistrarRespuestaSareb',
			/*TFI_ORDEN*/ '3',
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
		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_ElevarPropuestaSarebSub',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el caso de que la propuesta de subasta no sea delegada, debe preparar instrucciones para la subasta y presentar v&iacute;a workflow la propuesta a Sareb para recibir instrucciones de Subasta.</p><p style="margin-bottom: 10px">Para dar por completada esta tarea tambi&eacute;n deber&aacute; adjuntar la siguiente documentaci&oacute;n dependiendo del tipo de bien a subastar:<p style="margin-bottom: 10px; margin-left: 40px;">• Plantilla subasta SAREB: Siempre<p style="margin-bottom: 10px; margin-left: 40px;">• Front-sheet SAREB: Cuando el bien es de tipo suelo u obra nueva<p style="margin-bottom: 10px; margin-left: 40px;">• Ficha suelo SAREB: Cuando el bien es de tipo suelo.<p style="margin-bottom: 10px; margin-left: 40px;">• Due Diligence en caso de haberla solicitado.<p style="margin-bottom: 10px; margin-left: 40px;">• Tasaci&oacute;n<p style="margin-bottom: 10px; margin-left: 40px;">• Edicto</p><p style="margin-bottom: 10px">En cualquier caso, para dar por terminada esta tarea, deber&aacute; adjuntar el informe con la propuesta de instrucciones para la subasta al asunto correspondiente.</p><p style="margin-bottom: 10px">En el campo Fecha indicar la fecha de presentaci&oacute;n de la solicitud v&iacute;a workflow, el tipo de propuesta y num. Propuesta Sareb.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p></div>',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),	
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_ElevarPropuestaSarebSub',
			/*TFI_ORDEN*/ '1',
			/*TFI_TIPO*/ 'date',
			/*TFI_NOMBRE*/ 'fecha',
			/*TFI_LABEL*/ 'Fecha propuesta',
			/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
			/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_ElevarPropuestaSarebSub',
			/*TFI_ORDEN*/ '2',
			/*TFI_TIPO*/ 'number',
			/*TFI_NOMBRE*/ 'numProp',
			/*TFI_LABEL*/ 'Núm. Propuesta',
			/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
			/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_ElevarPropuestaSarebSub',
			/*TFI_ORDEN*/ '3',
			/*TFI_TIPO*/ 'combo',
			/*TFI_NOMBRE*/ 'comboTipoPropuesta',
			/*TFI_LABEL*/ 'Tipo de propuesta',
			/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
			/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ 'DDTipoPropuestaSareb',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_ElevarPropuestaSarebSub',
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
		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_RegistrarRespuestaSarebSub',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea deber&aacute; registrar la respuesta de SAREB, obtenida v&iacute;a workflow, sobre la propuesta de instrucciones dada por el supervisor.</p><p style="margin-bottom: 10px">Dependiente del resultado, la siguiente tarea podr&aacute; ser:<p style="margin-bottom: 10px; margin-left: 40px;">• “Suspender subasta” en caso de haber dictaminado la suspensi&oacute;n de la subasta.<p style="margin-bottom: 10px; margin-left: 40px;">• “Lectura y aceptaci&oacute;n de instrucciones” En caso de haber aprobado las instrucciones de la subasta o recibir una propuesta modificada, que deber&iacute;a ser adjuntada a la herramienta.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento</p></div>',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_RegistrarRespuestaSarebSub',
			/*TFI_ORDEN*/ '1',
			/*TFI_TIPO*/ 'date',
			/*TFI_NOMBRE*/ 'fecha',
			/*TFI_LABEL*/ 'Fecha Resolución',
			/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
			/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_RegistrarRespuestaSarebSub',
			/*TFI_ORDEN*/ '2',
			/*TFI_TIPO*/ 'number',
			/*TFI_NOMBRE*/ 'numProp',
			/*TFI_LABEL*/ 'Núm. Propuesta',
			/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
			/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',
			/*TFI_VALOR_INICIAL*/ 'valores[''H036_ElevarPropuestaSarebSub''][''numProp'']',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_RegistrarRespuestaSarebSub',
			/*TFI_ORDEN*/ '3',
			/*TFI_TIPO*/ 'combo',
			/*TFI_NOMBRE*/ 'comboResultado',
			/*TFI_LABEL*/ 'Resultado',
			/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
			/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ 'DDTipoRespuestaElevacionSareb',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),	
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H036_RegistrarRespuestaSarebSub',
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
		)
		
		
                
    ); 
    V_TMP_TIPO_TFI T_TIPO_TFI;
    
    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(        
    
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H036_ObtenerMinuta',
			/*DD_PTP_PLAZO_SCRIPT*/ '2*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),
		
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H036_ValidarMinuta',
			/*DD_PTP_PLAZO_SCRIPT*/ '2*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),
				
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H036_RegistrarRecepcionEscritura',
			/*DD_PTP_PLAZO_SCRIPT*/ '5*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),
		
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H036_SolicitarMandamientoPago',
			/*DD_PTP_PLAZO_SCRIPT*/ 'damePlazo(valores[''H036_CelebracionSubasta''][''fechaSubasta'']) + 20*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),	
		
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H036_ConfirmarRecepcionMandamientoPago',
			/*DD_PTP_PLAZO_SCRIPT*/ 'damePlazo(valores[''H036_SolicitarMandamientoPago''][''fecha'']) + 10*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),	
		
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H036_SolicitarServicioIndices',
			/*DD_PTP_PLAZO_SCRIPT*/ '15*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),	
		
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H036_ElevarPropuestaSareb',
			/*DD_PTP_PLAZO_SCRIPT*/ '5*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),	
		
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H036_RegistrarRespuestaSareb',
			/*DD_PTP_PLAZO_SCRIPT*/ '7*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),
		
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H036_ElevarPropuestaSarebSub',
			/*DD_PTP_PLAZO_SCRIPT*/ 'damePlazo(valores[''H036_registrarAnuncioSubasta''][''fechaSubasta'']) - 30*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),	
		
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H036_RegistrarRespuestaSarebSub',
			/*DD_PTP_PLAZO_SCRIPT*/ '15*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		)
		
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;    
    
BEGIN
	
    
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