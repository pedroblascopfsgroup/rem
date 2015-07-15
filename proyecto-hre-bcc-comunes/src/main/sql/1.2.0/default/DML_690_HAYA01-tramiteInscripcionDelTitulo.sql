/*
--######################################################################
--## Author: Nacho
--## BPM: T. Ejecución Notarial (H066)
--## Finalidad: Insertar datos en tablas de configuración del BPM
--## INSTRUCCIONES: Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--######################################################################
--*/
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
    
    CODIGO_PROCEDIMIENTO_ANTIGUO_1 VARCHAR2(10 CHAR) := ''; -- Variable con el código (DD_TPO_ID) del procedimiento antiguo para poder desactivarlo
    --CODIGO_PROCEDIMIENTO_ANTIGUO_2 VARCHAR2(10 CHAR) := 'P409'; -- Variable con el código (DD_TPO_ID) del procedimiento antiguo para poder desactivarlo

    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
        T_TIPO_TPO(
        /*DD_TPO_CODIGO.............::*/ 'H066',
        /*DD_TPO_DESCRIPCION.........:*/ 'T. de inscripción del título',
        /*DD_TPO_DESCRIPCION_LARGA...:*/ 'Trámite de inscripción del título',
        /*DD_TPO_HTML................:*/ null,
        /*DD_TPO_XML_JBPM............:*/ 'haya_tramiteInscripcionDelTitulo',
        /*VERSION....................:*/ '0',
        /*USUARIOCREAR...............:*/ 'DD',
        /*BORRADO....................:*/ '0',
        /*DD_TAC_ID..................:*/ 'EX',
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
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(   
    
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H066',
			/*TAP_CODIGO*/ 'H066_obtenerMinuta',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ 'comprobarExisteDocumentoMINUTA() ? null : ''Es necesario adjuntar la minuta.''',
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
			/*DD_STA_ID*/ '39',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ 'SFIS',
			/*TAP_BUCLE_BPM*/ ''
		),
		
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H066',
			/*TAP_CODIGO*/ 'H066_validarMinuta',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ '',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '(valores[''H066_validarMinuta''][''comboValidacion''] == DDSiNo.SI && (valores[''H066_validarMinuta''][''fecha''] == null || valores[''H066_validarMinuta''][''fecha''] == '''')) ? ''El campo "Fecha validaci&oacute;n minuta" es obligatorio'' : null',
			/*TAP_SCRIPT_DECISION*/ 'valores[''H066_validarMinuta''][''comboValidacion''] == DDSiNo.SI ? ''SI'' : ''NO''',
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
			/*DD_TPO_ID*/ 'H066',
			/*TAP_CODIGO*/ 'H066_registrarRecepcionEscritura',
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
			/*DD_STA_ID*/ '39',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ 'GUCL',
			/*TAP_BUCLE_BPM*/ ''
		),
		
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H066',
			/*TAP_CODIGO*/ 'H066_registrarEntregaTitulo',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ 'comprobarExisteDocumentoRECIGEST() ? null : ''Es necesario adjuntar el documento "Recib&iacute; de gestor&iacute;a (Inscripci&oacute;n T&iacute;tulo)".''',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ '',
			/*DD_TPO_ID_BPM*/ '',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Registrar entrega del título',
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
			/*DD_STA_ID*/ '201',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ 'GAREO',
			/*TAP_BUCLE_BPM*/ ''
		),
		
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H066',
			/*TAP_CODIGO*/ 'H066_registrarPresentacionHacienda',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ 'comprobarExisteDocumentoCOAPH() ? null : ''Es necesario adjuntar el documento "Copia de la autoliquidaci&oacute;n presentada en Hacienda".''',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ '',
			/*DD_TPO_ID_BPM*/ '',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Registrar presentación en Hacienda',
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
			/*DD_STA_ID*/ '201',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ 'GAREO',
			/*TAP_BUCLE_BPM*/ ''
		),
		
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H066',
			/*TAP_CODIGO*/ 'H066_registrarPresentacionRegistro',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ '',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ '',
			/*DD_TPO_ID_BPM*/ '',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Registrar presentación en el registro',
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
			/*DD_STA_ID*/ '201',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ 'GAREO',
			/*TAP_BUCLE_BPM*/ ''
		),
		
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H066',
			/*TAP_CODIGO*/ 'H066_registrarInscripcionTitulo',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ '',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ 'valores[''H066_registrarInscripcionTitulo''][''situacionTitulo''] == ''INS'' ? (valores[''H066_registrarInscripcionTitulo''][''fechaInscripcion''] == null || valores[''H066_registrarInscripcionTitulo''][''fechaInscripcion''] == '''' ? ''El campo "Fecha inscripci&oacute;n es obligatorio"'' : null) : (valores[''H066_registrarInscripcionTitulo''][''fechaEnvio''] == null || valores[''H066_registrarInscripcionTitulo''][''fechaEnvio''] == '''' ? ''El campo "Fecha env&iacute;o escrito subsanaci&oacute;n" es obligatorio'' : null)',
			/*TAP_SCRIPT_DECISION*/ 'valores[''H066_registrarInscripcionTitulo''][''situacionTitulo''] == ''INS'' ? ''INSCRITO'' : ''SUBSANACION''',
			/*DD_TPO_ID_BPM*/ '',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Registrar inscripción del título',
			/*VERSION*/ '0',
			/*USUARIOCREAR*/ 'DD',
			/*BORRADO*/ '0',
			/*TAP_ALERT_NO_RETORNO*/ '',
			/*TAP_ALERT_VUELTA_ATRAS*/ 'tareaExterna.cancelarTarea',
			/*DD_FAP_ID*/ '09',
			/*TAP_AUTOPRORROGA*/ '1',
			/*DTYPE*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP*/ '1',
			/*DD_TGE_ID*/ '',
			/*DD_STA_ID*/ '201',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ 'GAREO',
			/*TAP_BUCLE_BPM*/ ''
		),
		
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H066',
			/*TAP_CODIGO*/ 'H066_BPMTramitePosesion',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ '',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ '',
			/*DD_TPO_ID_BPM*/ 'H015',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Ejecutar trámite de posesión',
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
			/*DD_STA_ID*/ '39',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ 'GUCL',
			/*TAP_BUCLE_BPM*/ ''),
                
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H066',
			/*TAP_CODIGO*/ 'H066_BPMTramiteSubsanacionEscritura',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ '',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ '',
			/*DD_TPO_ID_BPM*/ 'H065',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Ejecutar trámite subsanación de escritura',
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
			/*DD_STA_ID*/ '39',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ 'GUCL',
			/*TAP_BUCLE_BPM*/ ''),					
			
		T_TIPO_TAP(
			/*DD_TPO_ID*/ 'H066',
			/*TAP_CODIGO*/ 'H066_BPMTramiteSaneamientoCargas',
			/*TAP_VIEW*/ '',
			/*TAP_SCRIPT_VALIDACION*/ '',
			/*TAP_SCRIPT_VALIDACION_JBPM*/ '',
			/*TAP_SCRIPT_DECISION*/ '',
			/*DD_TPO_ID_BPM*/ 'H008',
			/*TAP_SUPERVISOR*/ '0',
			/*TAP_DESCRIPCION*/ 'Ejecutar trámite saneamiento de cargas',
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
			/*DD_STA_ID*/ '39',
			/*TAP_EVITAR_REORG*/ '1',
			/*DD_TSUP_ID*/ 'GUCL',
			/*TAP_BUCLE_BPM*/ '')
			
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI( 

		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H066_obtenerMinuta',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla, el letrado debe infomar de la fecha de recepci&oacute;n de la minuta y, adjuntar la minuta para poder dar por finalizada la tarea.</p><p style="margin-bottom: 10px">En el campo observaciones infomar cualquier aspecto relevanete que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta tarea se lanzar&aacute; la tarea "Validar la minuta".</p></div>',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H066_obtenerMinuta',
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
			/*DD_TAP_ID*/ 'H066_obtenerMinuta',
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
			/*DD_TAP_ID*/ 'H066_validarMinuta',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla, el area fiscal debe validar la minuta recibida por parte del letrado e informar de la fecha de validaci&oacute;n de la misma.</p><p style="margin-bottom: 10px">En el campo observaciones infomar cualquier aspecto relevanete que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">En el supuesto de que A. Fiscal no valide la minuta, deber&aacute; enviar una comunicaci&oacute;n al Letrado para que indique al Notario que debe corregirla. La siguiente tarea ser&aacute; "Obtener minuta".</p><p style="margin-bottom: 10px">En caso de que A. Fiscal valide la minuta, la siguiente tarea ser&aacute; "Registrar repceci&oacute;n de escritura".</p></div>',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),
		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H066_validarMinuta',
			/*TFI_ORDEN*/ '1',
			/*TFI_TIPO*/ 'combo',
			/*TFI_NOMBRE*/ 'comboValidacion',
			/*TFI_LABEL*/ 'Minuta validada',
			/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
			/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ 'DDSiNo',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),
		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H066_validarMinuta',
			/*TFI_ORDEN*/ '2',
			/*TFI_TIPO*/ 'date',
			/*TFI_NOMBRE*/ 'fecha',
			/*TFI_LABEL*/ 'Fecha validación minuta',
			/*TFI_ERROR_VALIDACION*/ null,
			/*TFI_VALIDACION*/ null,
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),
		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H066_validarMinuta',
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
			/*DD_TAP_ID*/ 'H066_registrarRecepcionEscritura',
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
			/*DD_TAP_ID*/ 'H066_registrarRecepcionEscritura',
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
			/*DD_TAP_ID*/ 'H066_registrarRecepcionEscritura',
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
			/*DD_TAP_ID*/ 'H066_registrarEntregaTitulo',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; de informar de la fecha en que recibe la informaci&oacute;n sobre los documentos asignados que se le han enviado.</p><p style="margin-bottom: 10px">Antes de dar por terminada esta tarea deber&aacute;:</p><p style="margin-bottom: 10px; margin-left: 40px;">- Liquidar impuestos  en  plazo  seg&uacute;n CCAA. En caso de personas jur&iacute;dicas existir&aacute; una consulta previa realizada sobre la posible liquidaci&oacute;n de IVA. Esta informaci&oacute;n podr&aacute; consultarla a trav&eacute;s de la ficha de cada uno de los bienes incluidos.</p><p style="margin-bottom: 10px; margin-left: 40px;">- Verificar situaci&oacute;n ocupacional de la finca para manifestaci&oacute;n de libertad arrendamientos de cara a inscripci&oacute;n (LAU).</p><p style="margin-bottom: 10px; margin-left: 40px;">- Redactar en su caso, certificado de Libertad de Arrendamiento (por poder de la Entidad), para presentaci&oacute;n  en el registro junto con el testimonio y los mandamientos.</p><p style="margin-bottom: 10px; margin-left: 40px;">- Realizar notificaci&oacute;n fehaciente a inquilinos para la inscripci&oacute;n  (en casos de inmueble con arrendamiento reconocido)</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea “Registrar presentaci&oacute;n en hacienda”.</p></div>',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H066_registrarEntregaTitulo',
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
			/*DD_TAP_ID*/ 'H066_registrarEntregaTitulo',
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
			/*DD_TAP_ID*/ 'H066_registrarPresentacionHacienda',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; presentar la liquidaci&oacute;n del testimonio en Hacienda, una vez realizado esto deber&aacute; adjuntar al procedimiento correspondiente copia escaneada del documento de liquidaci&oacute;n de impuestos.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea “Registrar presentaci&oacute;n en el registro”.</p></div>',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H066_registrarPresentacionHacienda',
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
			/*DD_TAP_ID*/ 'H066_registrarPresentacionHacienda',
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
			/*DD_TAP_ID*/ 'H066_registrarPresentacionRegistro',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En caso de que se haya tenido que presentar subsanaci&oacute;n y por tanto estemos a la espera de recibir el nuevo testimonio decreto de adjudicaci&oacute;n, en el campo fecha nuevo decreto.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea “Registrar inscripci&oacute;n del t&iacute;tulo”.</p></div>',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),
		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H066_registrarPresentacionRegistro',
			/*TFI_ORDEN*/ '1',
			/*TFI_TIPO*/ 'date',
			/*TFI_NOMBRE*/ 'fechaPresentacion',
			/*TFI_LABEL*/ 'Fecha presentación',
			/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
			/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),
		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H066_registrarPresentacionRegistro',
			/*TFI_ORDEN*/ '2',
			/*TFI_TIPO*/ 'date',
			/*TFI_NOMBRE*/ 'fechaTestimonio',
			/*TFI_LABEL*/ 'Fecha nuevo testimonio',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H066_registrarPresentacionRegistro',
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
			/*DD_TAP_ID*/ 'H066_registrarInscripcionTitulo',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; indicar la situaci&oacute;n en que queda el t&iacute;tulo ya sea inscrito en el registro o pendiente de subsanaci&oacute;n, a trav&eacute;s de la ficha del bien correspondiente deber&aacute; de actualizar los campos: folio, libro, tomo, inscripci&oacute;n Xª, referencia catastral, porcentaje de propiedad, nº de finca -si hubiera cambios Actualizado. Una vez actualizados estos campos deber&aacute; de marcar la fecha de actualizaci&oacute;n en la ficha del bien.</p><p style="margin-bottom: 10px">En caso de haberse producido una resoluci&oacute;n desfavorable y haber marcado el bien en situación "Subsanar", deber&aacute; informar la fecha de env&iacute;o de escrito de subsanaci&oacute;n y proceder a la remisi&oacute;n de los documentos al Procurador e informa al Letrado.</p><p style="margin-bottom: 10px">En caso de haber quedado inscrito el bien, deber&aacute; informar la fecha en que se haya producido dicha inscripci&oacute;n.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute;, en caso de requerir subsanaci&oacute;n el tr&aacute;mite de subsanaci&oacute;n de escritura  a realizar por el letrado, y en caso contrario se iniciar&aacute; el tr&aacute;mite de saneamiento de cargas para el bien afecto a este tr&aacute;mite.</p></div>',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),	

		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H066_registrarInscripcionTitulo',
			/*TFI_ORDEN*/ '1',
			/*TFI_TIPO*/ 'combo',
			/*TFI_NOMBRE*/ 'situacionTitulo',
			/*TFI_LABEL*/ 'Situación del título',
			/*TFI_ERROR_VALIDACION*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
			/*TFI_VALIDACION*/ 'valor != null && valor != '''' ? true : false',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ 'DDSituacionTitulo',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		
		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H066_registrarInscripcionTitulo',
			/*TFI_ORDEN*/ '2',
			/*TFI_TIPO*/ 'date',
			/*TFI_NOMBRE*/ 'fechaInscripcion',
			/*TFI_LABEL*/ 'Fecha inscripción',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '0',
			/*USUARIOCREAR*/ 'DD'),		
		
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H066_registrarInscripcionTitulo',
			/*TFI_ORDEN*/ '3',
			/*TFI_TIPO*/ 'date',
			/*TFI_NOMBRE*/ 'fechaEnvio',
			/*TFI_LABEL*/ 'Fecha envío escrito subsanación',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '0',
			/*USUARIOCREAR*/ 'DD'),	
		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H066_registrarInscripcionTitulo',
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
			/*DD_TAP_ID*/ 'H066_BPMTramitePosesion',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Ejecuci&oacute;n del tr&aacute;mite de Posesi&oacute;n</p></div>',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		

		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H066_BPMTramiteSaneamientoCargas',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Ejecuci&oacute;n del tr&aacute;mite de Saneamiento de Cargas</p></div>',
			/*TFI_ERROR_VALIDACION*/ '',
			/*TFI_VALIDACION*/ '',
			/*TFI_VALOR_INICIAL*/ '',
			/*TFI_BUSINESS_OPERATION*/ '',
			/*VERSION*/ '1',
			/*USUARIOCREAR*/ 'DD'
		),		

		T_TIPO_TFI(
			/*DD_TAP_ID*/ 'H066_BPMTramiteSubsanacionEscritura',
			/*TFI_ORDEN*/ '0',
			/*TFI_TIPO*/ 'label',
			/*TFI_NOMBRE*/ 'titulo',
			/*TFI_LABEL*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Ejecuci&oacute;n del tr&aacute;mite de Subsanaci&oacute;n de Escritura</p></div>',
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
			/*TAP_ID*/ 'H066_obtenerMinuta',
			/*DD_PTP_PLAZO_SCRIPT*/ '5*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),
		
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H066_validarMinuta',
			/*DD_PTP_PLAZO_SCRIPT*/ '2*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),

		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H066_registrarRecepcionEscritura',
			/*DD_PTP_PLAZO_SCRIPT*/ 'damePlazo(valoresBPMPadre[''H036_registrarAnuncioSubasta''][''fechaSubasta'']) + 20*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),		

		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H066_registrarEntregaTitulo',
			/*DD_PTP_PLAZO_SCRIPT*/ '7*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),		

		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H066_registrarPresentacionHacienda',
			/*DD_PTP_PLAZO_SCRIPT*/ 'damePlazo(valores[''H066_registrarEntregaTitulo''][''fecha'']) + 10*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),		

		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H066_registrarPresentacionRegistro',
			/*DD_PTP_PLAZO_SCRIPT*/ '(valores[''H066_registrarInscripcionTitulo''] != null && (valores[''H066_registrarInscripcionTitulo''][''fechaEnvio''] != null || valores[''H066_registrarInscripcionTitulo''][''fechaEnvio''] != '''')) ? 10*24*60*60*1000L : damePlazo(valores[''H066_registrarPresentacionHacienda''][''fecha'']) + 10*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),		

		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H066_registrarInscripcionTitulo',
			/*DD_PTP_PLAZO_SCRIPT*/ 'damePlazo(valores[''H066_registrarPresentacionRegistro''][''fechaPresentacion'']) + 45*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),		

		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H066_BPMTramitePosesion',
			/*DD_PTP_PLAZO_SCRIPT*/ '300*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),		

		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H066_BPMTramiteSubsanacionEscritura',
			/*DD_PTP_PLAZO_SCRIPT*/ '300*24*60*60*1000L',
			/*VERSION*/ '0',
			/*BORRADO*/ '0',
			/*USUARIOCREAR*/ 'DD'
		),		

		T_TIPO_PLAZAS(
			/*DD_JUZ_ID*/ '',
			/*DD_PLA_ID*/ '',
			/*TAP_ID*/ 'H066_BPMTramiteSaneamientoCargas',
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
	
	/*
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||PAR_TABLENAME_TPROC||' WHERE '||V_CODIGO_TPO||' = '''||CODIGO_PROCEDIMIENTO_ANTIGUO_2||''' AND BORRADO=0 ';
        
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN
	    V_SQL := 'UPDATE '||V_ESQUEMA||'.'||PAR_TABLENAME_TPROC||' SET BORRADO=1 WHERE '||V_CODIGO_TPO||' = '''||CODIGO_PROCEDIMIENTO_ANTIGUO_2||''' AND BORRADO=0 ';
        DBMS_OUTPUT.PUT_LINE('Trámite antiguo desactivado.');
        EXECUTE IMMEDIATE V_SQL; 
	END IF;
	*/	
    
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