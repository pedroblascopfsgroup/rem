/*
--##########################################
--## AUTOR=Carlos Martos
--## FECHA_CREACION=20160411
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1093
--## PRODUCTO=NO
--##
--## Finalidad: BPM - Subasta Electronica
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

    --Insertando valores en DD_TPO_TIPO_PROCEDIMIENTO
    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
      T_TIPO_TPO('P458','T. de circuito de Subasta Electrónica','T. de circuito de Subasta Electrónica',null,'tramiteSubastaElectronica','0','PRODUCTO-1093','0','AP',null,null,'1','MEJTipoProcedimiento','1','0')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
		T_TIPO_TAP('P458','P458_SolicitudDeSubasta',null,null,null,null,null,'0','Solicitud de Subasta','0','PRODUCTO-1093','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'814',null,'GCONPR',null)
		,T_TIPO_TAP('P458','P458_DecretoConvocatoriaDeSubasta',null,null,null,null,null,'0','Decreto Convocatoria de Subasta','0','PRODUCTO-1093','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'814',null,'GCONGE',null)
		,T_TIPO_TAP('P458','P458_EntregaYRecepcionEdictoEImpresoTasa','plugin/cajamar/tramiteSubastaElectronica/entregaYRecepcionEdictoEImpresoTasa',null,'(valores[''P458_EntregaYRecepcionEdictoEImpresoTasa''][''comboEdicto''] == ''01'' && valores[''P458_EntregaYRecepcionEdictoEImpresoTasa''][''comboCorrecto''] == null) ? ''El campo correcto es obligatorio'' : null','valores[''P458_EntregaYRecepcionEdictoEImpresoTasa''][''comboEdicto''] == ''02'' ? ''no'' : (valores[''P458_EntregaYRecepcionEdictoEImpresoTasa''][''comboCorrecto''] == ''01'' ? ''siYCorreco'' : ''siYIncorrecto'')',null,'0','Entrega Y Recepcion Edicto e Impreso Tasa','0','PRODUCTO-1093','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'814',null,'GCONGE',null)
		,T_TIPO_TAP('P458','P458_PedirCorreccionDelEdicto',null,null,null,null,null,'0','Pedir Correccion del Edicto','0','PRODUCTO-1093','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'814',null,'GCONGE',null)
		,T_TIPO_TAP('P458','P458_ConfirmarCorreccionDelEdicto',null,null,null,null,null,'0','Confirmar Correccion Del Edicto','0','PRODUCTO-1093','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'814',null,'GCONGE',null)
		,T_TIPO_TAP('P458','P458_ConfirmarLecturaInstruccionesDeSubastaYPagoDeTasa',null,null,null,null,null,'0','Confirmar Lectura Instrucciones de Subasta y Pago de Tasa','0','PRODUCTO-1093','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'814',null,'GCONGE',null)
		,T_TIPO_TAP('P458','P458_RegistrarElPagoDeLaTasaParaPublicacionBOE',null,null,null,null,null,'0','Registrar el Pago de la Tasa para Publicacion BOE','0','PRODUCTO-1093','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'814',null,'GCONGE',null)
		,T_TIPO_TAP('P458','P458_RegistrarPublicacionDeSubastaEnElBOE',null,null,null,'valores[''P458_RegistrarPublicacionDeSubastaEnElBOE''][''comboEdictoCorrecto''] == ''01'' ? ''si'' : ''no''',null,'0','Registrar Publicación de Subasta en el BOE','0','PRODUCTO-1093','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'814',null,'GCONGE',null)
		,T_TIPO_TAP('P458','P458_PedirCorreccionDelEdictoPublicacionBOE',null,null,null,null,null,'0','Pedir Corrección del Edicto Publicación BOE','0','PRODUCTO-1093','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'814',null,'GCONGE',null)
		,T_TIPO_TAP('P458','P458_ConfirmarCorrecccionDelEdictoPublicacionBOE',null,null,null,'valores[''P458_ConfirmarCorrecccionDelEdictoPublicacionBOE''][''comboPagoTasa''] == ''01'' ? ''si'' : ''no''',null,'0','Confirmar Corrección del Edicto Publicación BOE','0','PRODUCTO-1093','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'814',null,'GCONGE',null)

		,T_TIPO_TAP('P458','P458_RegistrarResultadoDeLaSubasta',null,null,null,null,null,'0','Registrar Resultado de la Subasta','0','PRODUCTO-1093','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'814',null,'GCONGE',null)

		,T_TIPO_TAP('P458','P458_SolicitarAdjudicacionSegunInstruccionesEntidad',null,null,null,null,null,'0','Solicitar Adjudicación Según Instrucciones Entidad','0','PRODUCTO-1093','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'814',null,'GCONGE',null)
		,T_TIPO_TAP('P458','P458_RegistrarResultadoPresentacionEscritoAlJuzgado','plugin/cajamar/tramiteSubastaElectronica/registrarResultadoPresentacionEscritoJuzgado',null,'(valores[''P458_RegistrarResultadoPresentacionEscritoAlJuzgado''][''comboAdjudicacionConCesion''] == ''01'' && valores[''P458_RegistrarResultadoPresentacionEscritoAlJuzgado''][''comboEntidadConCesion''] == null) ? ''El campo entidad con cesion es obligatorio'' : null','valores[''P458_RegistrarResultadoPresentacionEscritoAlJuzgado''][''comboAdjudicacionConCesion''] == ''01'' ? ''conCesion'' : ''sinCesion''',null,'0','Registrar Resultado Presentación Escrito al Juzgado','0','PRODUCTO-1093','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'814',null,'GCONGE',null)
		,T_TIPO_TAP('P458','P458_BPMTramiteAdjudicacion',null,null,null,null,null,'0','Llamada al BPM de Tramite Adjudicación','0','PRODUCTO-1093','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null)
		,T_TIPO_TAP('P458','P458_BPMTramiteCesionDeRemate',null,null,null,null,null,'0','Llamada al BPM de Tramite Cesión de Remate','0','PRODUCTO-1093','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null)
		,T_TIPO_TAP('P458','P458_BPMTramiteAdjudicacionTerceros',null,null,null,null,null,'0','Llamada al BPM de Tramite Adjudicación de Terceros','0','PRODUCTO-1093','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null)
		,T_TIPO_TAP('P458','P458_RevisarDocumentacion',null,null,null,null,null,'0','Revisar Documentación','0','PRODUCTO-1093','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'TGCONGE',null,'SUCONGE',null)
		,T_TIPO_TAP('P458','P458_AdjuntarNotasSimples',null,null,null,null,null,'0','Adjuntar Notas Simples','0','PRODUCTO-1093','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'TGCONGE',null,'SUCONGE',null)
		,T_TIPO_TAP('P458','P458_AdjuntarTasaciones',null,null,null,'valores[''P458_AdjuntarTasaciones''][''comboSolicitar''] == ''01'' ? ''si'' : ''no''',null,'0','Adjuntar Tasaciones','0','PRODUCTO-1093','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'TGCONGE',null,'SUCONGE',null)
		,T_TIPO_TAP('P458','P458_SolicitarInformeFiscal',null,null,null,null,null,'0','Solicitar Informe Fiscal','0','PRODUCTO-1093','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'TGCONGE',null,'SUCONGE',null)
		,T_TIPO_TAP('P458','P458_AdjuntarInformeFiscal',null,null,null,null,null,'0','Adjuntar Informe Fiscal','0','PRODUCTO-1093','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'TGCONGE',null,'SUCONGE',null)
		,T_TIPO_TAP('P458','P458_PrepararInformeDeSubasta',null,null,null,null,null,'0','Preparar Informe de Subasta','0','PRODUCTO-1093','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'TGCONGE',null,'SUCONGE',null)
		,T_TIPO_TAP('P458','P458_ValidarInformeDeSubasta',null,null,'(valores[''P458_ValidarInformeDeSubasta''][''comboAceptarInforme''] == ''01'' && valores[''P458_ValidarInformeDeSubasta''][''comboAtribuciones''] == null) ? ''El campo atribuciones es obligatorio'' : null','valores[''P458_ValidarInformeDeSubasta''][''comboAceptarInforme''] == ''02'' ? ''rechazado'' : (valores[''P458_ValidarInformeDeSubasta''][''comboAtribuciones''] == ''01'' ? ''aceptadoConAtribuciones'' : ''aceptadoSinAtribuciones'')',null,'0','Validar Informe de Subasta','0','PRODUCTO-1093','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'RESPRO_SUCONGE',null,'SUCONGEN2',null)
		,T_TIPO_TAP('P458','P458_ObtenerValidacionComite','plugin/cajamar/tramiteSubastaElectronica/obtenerValidacionComite',null,'(valores[''P458_ObtenerValidacionComite''][''comboResultadoComite''] == ''02'' && valores[''P458_ObtenerValidacionComite''][''comboResultadoComite''] == null) ? ''El campo motivo de no pagar tasa es obligatorio'' : null','valores[''P458_ObtenerValidacionComite''][''comboResultadoComite''] == ''02'' ? ''rechazado'' : (valores[''P458_ObtenerValidacionComite''][''comboResultadoComite''] == ''01'' ? ''siPagarTasa'' : ''noPagarTasa'')',null,'0','Obtener Validación Comité','0','PRODUCTO-1093','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'TGCTRGE',null,'DRECU',null)
		,T_TIPO_TAP('P458','P458_PendienteConfirmacionPagoDeTasa',null,null,null,'valores[''P458_PendienteConfirmacionPagoDeTasa''][''comboResolucionDefinitiva''] == ''01'' ? ''si'' : ''no''',null,'0','Pendiente Confirmación Pago de Tasa','0','PRODUCTO-1093','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'TGCTRGE',null,'DRECU',null)
		,T_TIPO_TAP('P458','P458_DictarInstruccionesDeSubastaYPagoDeTasa',null,null,null,null,null,'0','Dictar Instrucciones de Subasta y Pago de Tasa','0','PRODUCTO-1093','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'TGCONGE',null,'SUCONGE',null)	

	--MIRAR RESPRO_SUCONGE Solicitar Prorroga PRC Supervisor Contencioso Gestion

    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
		T_TIPO_PLAZAS(null,null,'P458_SolicitudDeSubasta','3*24*60*60*1000L','0','0','PRODUCTO-1093')
		,T_TIPO_PLAZAS(null,null,'P458_DecretoConvocatoriaDeSubasta','(valores[''P458_SolicitudDeSubasta''] !=null && valores[''P458_SolicitudDeSubasta''][''fechaSolicitud''] !=null) ? damePlazo(valores[''P458_SolicitudDeSubasta''][''fechaSolicitud''])+60*24*60*60*1000L : 60*24*60*60*1000L','0','0','PRODUCTO-1093')
		,T_TIPO_PLAZAS(null,null,'P458_EntregaYRecepcionEdictoEImpresoTasa','20*24*60*60*1000L','0','0','PRODUCTO-1093')
		,T_TIPO_PLAZAS(null,null,'P458_PedirCorreccionDelEdicto','3*24*60*60*1000L','0','0','PRODUCTO-1093')
		,T_TIPO_PLAZAS(null,null,'P458_ConfirmarCorreccionDelEdicto','10*24*60*60*1000L','0','0','PRODUCTO-1093')
		,T_TIPO_PLAZAS(null,null,'P458_ConfirmarLecturaInstruccionesDeSubastaYPagoDeTasa','2*24*60*60*1000L','0','0','PRODUCTO-1093')
		,T_TIPO_PLAZAS(null,null,'P458_RegistrarElPagoDeLaTasaParaPublicacionBOE','5*24*60*60*1000L','0','0','PRODUCTO-1093')
		,T_TIPO_PLAZAS(null,null,'P458_RegistrarPublicacionDeSubastaEnElBOE','10*24*60*60*1000L','0','0','PRODUCTO-1093') 
		,T_TIPO_PLAZAS(null,null,'P458_PedirCorreccionDelEdictoPublicacionBOE','3*24*60*60*1000L','0','0','PRODUCTO-1093')
		,T_TIPO_PLAZAS(null,null,'P458_ConfirmarCorrecccionDelEdictoPublicacionBOE','10*24*60*60*1000L','0','0','PRODUCTO-1093')
		,T_TIPO_PLAZAS(null,null,'P458_RegistrarResultadoDeLaSubasta','(valores[''P458_RegistrarPublicacionDeSubastaEnElBOE''] !=null && valores[''P458_RegistrarPublicacionDeSubastaEnElBOE''][''fechaFinPeriodoPujas''] !=null) ? damePlazo(valores[''P458_RegistrarPublicacionDeSubastaEnElBOE''][''fechaFinPeriodoPujas''])+2*24*60*60*1000L : 2*24*60*60*1000L','0','0','PRODUCTO-1093') 
		,T_TIPO_PLAZAS(null,null,'P458_SolicitarAdjudicacionSegunInstruccionesEntidad','(valores[''P458_RegistrarPublicacionDeSubastaEnElBOE''] !=null && valores[''P458_RegistrarPublicacionDeSubastaEnElBOE''][''fechaFinPeriodoPujas''] !=null) ? damePlazo(valores[''P458_RegistrarPublicacionDeSubastaEnElBOE''][''fechaFinPeriodoPujas''])+2*24*60*60*1000L : 2*24*60*60*1000L','0','0','PRODUCTO-1093')
		,T_TIPO_PLAZAS(null,null,'P458_RegistrarResultadoPresentacionEscritoAlJuzgado','30*24*60*60*1000L','0','0','PRODUCTO-1093')
		,T_TIPO_PLAZAS(null,null,'P458_BPMTramiteAdjudicacion','300*24*60*60*1000L','0','0','PRODUCTO-1093') 
		,T_TIPO_PLAZAS(null,null,'P458_BPMTramiteCesionDeRemate','300*24*60*60*1000L','0','0','PRODUCTO-1093')
		,T_TIPO_PLAZAS(null,null,'P458_BPMTramiteAdjudicacionTerceros','300*24*60*60*1000L','0','0','PRODUCTO-1093') 
		,T_TIPO_PLAZAS(null,null,'P458_RevisarDocumentacion','2*24*60*60*1000L','0','0','PRODUCTO-1093')
		,T_TIPO_PLAZAS(null,null,'P458_AdjuntarNotasSimples','7*24*60*60*1000L','0','0','PRODUCTO-1093')
		,T_TIPO_PLAZAS(null,null,'P458_AdjuntarTasaciones','30*24*60*60*1000L','0','0','PRODUCTO-1093')
		,T_TIPO_PLAZAS(null,null,'P458_SolicitarInformeFiscal','5*24*60*60*1000L','0','0','PRODUCTO-1093')
		,T_TIPO_PLAZAS(null,null,'P458_AdjuntarInformeFiscal','2*24*60*60*1000L','0','0','PRODUCTO-1093')
		,T_TIPO_PLAZAS(null,null,'P458_PrepararInformeDeSubasta','(valores[''P458_RevisarDocumentacion''] !=null && valores[''P458_RevisarDocumentacion''][''fecha''] !=null) ? damePlazo(valores[''P458_RevisarDocumentacion''][''fecha''])+45*24*60*60*1000L : 45*24*60*60*1000L','0','0','PRODUCTO-1093') 
		,T_TIPO_PLAZAS(null,null,'P458_ValidarInformeDeSubasta','3*24*60*60*1000L','0','0','PRODUCTO-1093')
		,T_TIPO_PLAZAS(null,null,'P458_ObtenerValidacionComite','3*24*60*60*1000L','0','0','PRODUCTO-1093')
		,T_TIPO_PLAZAS(null,null,'P458_PendienteConfirmacionPagoDeTasa','25*24*60*60*1000L','0','0','PRODUCTO-1093')
		,T_TIPO_PLAZAS(null,null,'P458_DictarInstruccionesDeSubastaYPagoDeTasa','3*24*60*60*1000L','0','0','PRODUCTO-1093') 
	); 
	V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
	 T_TIPO_TFI('P458_SolicitudDeSubasta','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deberá acceder a la pestaña Subastas del asunto correspondiente y asociar uno o más bienes a la subasta que corresponda. Una vez agregados los bienes a la subasta deberá indicar a través de la ficha de cada bien las cargas anteriores y posteriores, si es vivienda habitual o no y la situación posesoria. Le recordamos que es obligatorio solicitar en este escrito que se nos de traslado del Edicto en cuanto el mismo se dicte y con anterioridad a su envío al portal de subasta, con el fin de validar que todo es correcto.</p>En el campo Fecha solicitud deberá informar la fecha en la que haya realizado la solicitud de subasta. Además, deberá informar las costas del letrado y del procurador.</p>Igualmente, deberá incluir la información referente al gestor/profesional que será identificado para el acceso al portal de subasta como representante de la parte actora, así como correo/mail y número de teléfono para notificaciones de las pujas que se puedan realizar. Todo ello con el fin de que sea recogido bien en el decreto o bien en la diligencia de ordenación que se dicte por el Juzgado.</p>Deberá incluir igualmente la Solicitud al Juzgado de Notificación del Edicto con antelación a su envío al portal de Subastas.</p>Una vez rellene esta pantalla se lanzarán las tareas “Decreto Convocatoria de subasta”.</p>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_SolicitudDeSubasta','1','date','fechaSolicitud','Fecha Solicitud','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_SolicitudDeSubasta','2','number','costasLetrado','Costas Letrado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_SolicitudDeSubasta','3','number','costasProcurador','Costas Procurador','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_SolicitudDeSubasta','4','text','nombreGestorRep','Nombre Gestor/Representante','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_SolicitudDeSubasta','5','text','nifRep','NIF Representante','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_SolicitudDeSubasta','6','text','correoElectronicoRep','Correo Electrónico Representante','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_SolicitudDeSubasta','7','number','telefonoRep','Telefono Representante','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_SolicitudDeSubasta','8','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1093')

	,T_TIPO_TFI('P458_DecretoConvocatoriaDeSubasta','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez solicitada la subasta, en esta pantalla, debe informar la fecha de notificación del Decreto.</p>Una vez rellene esta pantalla se lanzará las tareas "Entrega y Recepción Edicto e Impreso Tasa" y "Revisar documentación".</p>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>
',null,null,null,null,'0','PRODUCTO-1093')
   	,T_TIPO_TFI('P458_DecretoConvocatoriaDeSubasta','1','date','fechaNotificacionDecreto','Fecha Notificación del Decreto','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1093')
    ,T_TIPO_TFI('P458_DecretoConvocatoriaDeSubasta','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1093')

    ,T_TIPO_TFI('P458_EntregaYRecepcionEdictoEImpresoTasa','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta tarea deberá usted informar de:<br>- La fecha de entrega de Edicto para la Subasta solicitada.<br>- La fecha de entrega del impreso formalizado para el pago de la tasa.	</p>Según instrucciones de la Entidad, Vd deberá hacer todo lo posible para conseguir la entrega del Edicto. En caso contrario no deberá dar por concluida esta tarea. Solo para el supuesto de negativa radical del Letrado de la Administración de Justicia a su entrega, Vd deberá solicitar autorización expresa por medio de notificación a su Supervisor para continuar en la tramitación del Trámite. Para el supuesto de que hubiese notificado el edicto de la subasta, deberá revisarlo e informar si éste es correcto o necesita subsanación.</p>En caso de que no haya edicto y se haya obtenido autorización para continuar por parte del supervisor, se lanzará la siguiente tarea: "Confirmar lectura instrucciones de subasta y pago de tasa".</p>En caso de que haya edicto y sea correcto, se lanzará la siguiente tarea: "Confirmar lectura instrucciones de subasta y pago de tasa".</p>En caso de que haya edicto y requiera subsanación, se lanzará la tarea al letrado: "Pedir corrección del Edicto".</p>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-1093')
    ,T_TIPO_TFI('P458_EntregaYRecepcionEdictoEImpresoTasa','1','date','fechaEntregaEdicto','Fecha Entrega del Edicto','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_EntregaYRecepcionEdictoEImpresoTasa','2','combo','comboEdicto','Edicto',null,null,null,'DDSiNo','0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_EntregaYRecepcionEdictoEImpresoTasa','3','combo','comboCorrecto','Correcto',null,null,null,'DDSiNo','0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_EntregaYRecepcionEdictoEImpresoTasa','4','date','fechaEntregaImpresoLiquidacionTasa','Fecha Entrega Impreso Liquidación Tasa',null,null,null,null,'0','PRODUCTO-1093')
    ,T_TIPO_TFI('P458_EntregaYRecepcionEdictoEImpresoTasa','5','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1093')

    ,T_TIPO_TFI('P458_PedirCorreccionDelEdicto','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Deberá solicitar la corrección del edicto para subsanar los errores del mismo e indicar en la tarea la fecha de solicitud de corrección del Edicto.</p>Una vez rellene esta pantalla, se lanzará la tarea "Confirmar corrección del edicto".</p>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_PedirCorreccionDelEdicto','1','date','fechaSolicitudCorreccion','Fecha Solicitud Corrección','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1093')     
	,T_TIPO_TFI('P458_PedirCorreccionDelEdicto','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1093')

	,T_TIPO_TFI('P458_ConfirmarCorreccionDelEdicto','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez recibida la corrección del Edicto por parte del Juzgado, deberá adjuntar el nuevo edicto de subasta e indicar la fecha en la que se produjo dicha corrección.</p>Una vez rellene esta pantalla, la siguiente tarea será "Orden de Publicación del Anuncio de convocatoria".</p>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_ConfirmarCorreccionDelEdicto','1','date','fechaCorreccionEdicto','Fecha Corrección del Edicto','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1093')     
	,T_TIPO_TFI('P458_ConfirmarCorreccionDelEdicto','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1093')

	,T_TIPO_TFI('P458_ConfirmarLecturaInstruccionesDeSubastaYPagoDeTasa','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta tarea deberá revisar las instrucciones enviadas por contencioso y confirmar la recepción de las mismas. Si en dichas instrucciones se incluye la de NO PAGO DE LA TASA, Vd., deberá lanzar una autoprórroga o solicitar una prorroga hasta la fecha que se le hubiere indicado. En cualquier caso VD. No deberá ordenar al Procurador que proceda al pago de la tasa hasta que no reciba una instrucción clara al respecto.</p>Una vez rellene esta pantalla, se lanzará la tarea "Registrar el pago de la tasa para publicación BOE".</p>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_ConfirmarLecturaInstruccionesDeSubastaYPagoDeTasa','1','date','fechaConfirmacionInstrucciones','Fecha Confirmación Instrucciones','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1093')     
	,T_TIPO_TFI('P458_ConfirmarLecturaInstruccionesDeSubastaYPagoDeTasa','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1093')

	,T_TIPO_TFI('P458_RegistrarElPagoDeLaTasaParaPublicacionBOE','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta tarea deberá adjuntarse el pago de la tasa para la publicación de la Subasta en el BOE y que el Procurador ha notificado correctamente dicho pago al órgano correspondiente. Deberá tener en cuenta si el pago de la tasa se ha abonado previamente y se ha adjuntado correctamente al procedimiento.</p>Una vez rellene esta pantalla, se lanzará la tarea "Registrar publicación de Subasta en el BOE".</p>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_RegistrarElPagoDeLaTasaParaPublicacionBOE','1','date','fechaPagoTasa','Fecha Pago Tasa','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1093')     
	,T_TIPO_TFI('P458_RegistrarElPagoDeLaTasaParaPublicacionBOE','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1093')

	,T_TIPO_TFI('P458_RegistrarPublicacionDeSubastaEnElBOE','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Deberá indicar la fecha de publicación en el BOE.<br>Si no se hubiese conseguido el Edicto en fase anterior del procedimiento y se hubiere continuado por autorización expresa de HRE, en esta tarea deberá verificar la corrección del edicto publicado y en caso de error en el mismo, deberá solicitar su rectificación.<br>De manera que si el edicto no fuese correcto se pediría su corrección así como la suspensión de la subasta si es necesario (dependerá del Letrado de la Administración).<br>En caso de que fuera correcto, deberá informar la fecha límite del período de pujas que se utilizará como fecha de vencimiento de la siguiente tarea.<br></p>En caso de que no haya edicto, se lanzará la siguiente tarea: "Registrar resultado de la Subasta".<br>En caso de que haya edicto y sea correcto, se lanzará la siguiente tarea: "Registrar resultado de la Subasta".<br>En caso de que haya edicto y requiera subsanación, se lanzará la tarea al letrado: "Pedir corrección del Edicto".</p>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_RegistrarPublicacionDeSubastaEnElBOE','1','date','fechaPublicacionBOE','Fecha Publicación BOE','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_RegistrarPublicacionDeSubastaEnElBOE','2','combo','comboEdictoCorrecto','Edicto Correcto',null,null,null,'DDSiNo','0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_RegistrarPublicacionDeSubastaEnElBOE','3','date','fechaFinPeriodoPujas','Fecha Fin del Periodo de Pujas','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1093')     
	,T_TIPO_TFI('P458_RegistrarPublicacionDeSubastaEnElBOE','4','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1093')

	,T_TIPO_TFI('P458_PedirCorreccionDelEdictoPublicacionBOE','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Deberá solicitar la corrección del edicto para subsanar los errores del mismo e indicar en la tarea la fecha de solicitud de corrección del Edicto.</p>Una vez rellene esta pantalla, se lanzará la tarea "Confirmar corrección del edicto Publicación BOE".</p>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_PedirCorreccionDelEdictoPublicacionBOE','1','date','fechaCorreccionEdicto','Fecha Corrección del Edicto','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1093')     
	,T_TIPO_TFI('P458_PedirCorreccionDelEdictoPublicacionBOE','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1093')
	
	,T_TIPO_TFI('P458_ConfirmarCorrecccionDelEdictoPublicacionBOE','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez recibida la corrección del Edicto por parte del Juzgado, deberá adjuntar el nuevo edicto de subasta e indicar la fecha en la que se produjo dicha corrección.</p>Por otro lado, deberá indicar si se requiere un nuevo pago de las tasas.</p>Una vez rellene esta pantalla:<br>- Si se requiere nuevo pago de la tasa, la siguiente tarea será "Registrar el pago de la tasa para publicación BOE".<br>- Si no se requiere nuevo pago de la tasa, la siguiente tarea será "Registrar publicación de Subasta en el BOE".</p>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_ConfirmarCorrecccionDelEdictoPublicacionBOE','1','date','fechaCorreccionEdicto','Fecha Corrección del Edicto','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1093')     
	,T_TIPO_TFI('P458_ConfirmarCorrecccionDelEdictoPublicacionBOE','2','combo','comboPagoTasa','Pago Tasa Nueva','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_ConfirmarCorrecccionDelEdictoPublicacionBOE','3','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1093')

	,T_TIPO_TFI('P458_RegistrarResultadoDeLaSubasta','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez finalizado el período de pujas:	</p>- Si el Resultado de la Subasta es el mismo para todos los bienes. Si el Resultado de la Subasta varía en los diferentes bienes de la Subasta, se deberá actualizar la ficha de cada uno de los bienes indicando el Resultado de la Subasta. En caso de que el Resultado sea el mismo, se habilitará el siguiente campo en el que indicaremos si ha habido o no postores. Esta información, se trasladará a la ficha de los bienes.
Además, si ha habido postores en todos los bienes corresponde iniciar el mismo trámite, se indicará en el campo "Detalle Resultado Con Postores", cuya información se trasladará a la ficha de cada uno de los bienes de la Subasta.</p>- Si el Resultado de la Subasta, varía en función del bien subastado, deberá informarse en la ficha del bien si en la puja del bien ha habido o no postores, si se lo ha adjudicado la entidad o un tercero, el resultado de la  adjudicación y el valor de la adjudicación.<br>- En caso de suspensión de la subasta deberá indicar dicha circunstancia en el campo “Suspensión” deberá informar quien ha provocado dicha suspensión y en el campo “Motivo suspensión” deberá indicar el motivo por el cual se ha suspendido.<br>- En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p>Para dar por terminada esta tarea deberá adjuntar el acta de subasta al procedimiento a través de la pestaña "Adjuntos".</p>Una vez recogida toda la informacióndel resultado de la subasta:<br>- En caso de suspensión, se irá a la toma de decisión.<br>- En caso de no suspensión de la subasta, se lanzará un trámite u otro por bien en función de la información recogida en la ficha de cada uno de los bienes de la Subasta:<br>- En caso de que se haya adjudicado el bien a un tercero se lanzará el Trámite Adjudicación Terceros.<br>- En caso de que se haya adjudicado el bien la entidad, se lanzará el Trámite Adjudicacion.<br>- En caso de que el bien se haya adjudicado a la entidad con cesión de remate, se lanzará el Trámite de Cesión de Remate.</p>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_RegistrarResultadoDeLaSubasta','1','combo','comboSubastaBienes','Coincidencia del Resultado de la Subasta en los Bienes','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_RegistrarResultadoDeLaSubasta','2','combo','comboPostores','Con Postores','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_RegistrarResultadoDeLaSubasta','3','combo','comboDetalle','Detalle Resultado con Postores',null,null,null,'NUEVODICCIONARIO','0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_RegistrarResultadoDeLaSubasta','4','combo','comboDecision','Decisión Suspensión',null,null,null,'NUEVODICCIONARIO','0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_RegistrarResultadoDeLaSubasta','5','combo','comboMotivo','Motivo Suspensión',null,null,null,'NUEVODICCIONARIO','0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_RegistrarResultadoDeLaSubasta','6','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1093')

	,T_TIPO_TFI('P458_SolicitarAdjudicacionSegunInstruccionesEntidad','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En caso de que el Resultado de la Subasta haya sido "sin postores", deberá proceder a la redacción del escrito en el que se solicite la adjudicación del bien o biens  de acuerdo a las instrucciones de la entidad.</p>Una vez rellene esta pantalla se lanzará la tarea “Registrar Resultado Presentación escrito al Juzgado".</p>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_SolicitarAdjudicacionSegunInstruccionesEntidad','1','date','fechaPresentacionEscrito','Fecha Presentación Escrito','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1093')     
	,T_TIPO_TFI('P458_RegistrarResultadoDeLaSubasta','2','combo','comboCuantia','Cuantía','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'NUEVODICCIONARIO','0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_SolicitarAdjudicacionSegunInstruccionesEntidad','3','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1093')

	,T_TIPO_TFI('P458_RegistrarResultadoPresentacionEscritoAlJuzgado','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla deberá recoger el resultado del escrito enviado al Juzgado. Si el resultado es Desfavorable, es decir que el Juzgado no ha admitido la adjudicación por la cantidad solicitada,  deberá ponerse en contacto con su Supervisor para tomar la decisión que corresponda según sus instrucciones. Si se decide Recurrir deberá indicarlo por la pestaña habilitada al efecto.</p>Si la resolución ha acogido de forma favorable la solicitud de adjudicación formulada, antes de finalizar esta tarea, deberá ir a la ficha del bien y actualizar los campos que corresponda de la pestaña de "Adjudicación y posesión".</p>Una vez rellene esta pantalla:<br>- En caso de que el bien sea Adjudicado a la Entidad y no haya Cesión de remate, se lanzará la tarea "Solicitud Decreto de Adjudicación".<br>- En caso de que el bien se Adjudique con cesión de remate se lanzará el Trámite "Trámite de Cesión de Remate".</p>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_RegistrarResultadoPresentacionEscritoAlJuzgado','1','date','fechaResolucion','Fecha Resolución','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1093')     
	,T_TIPO_TFI('P458_RegistrarResultadoPresentacionEscritoAlJuzgado','2','combo','comboResultado','Resultado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDFavorable','0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_RegistrarResultadoPresentacionEscritoAlJuzgado','3','combo','comboAdjudicacionConCesion','Adjudicación con Cesión de Remate','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_RegistrarResultadoPresentacionEscritoAlJuzgado','4','combo','comboEntidadConCesion','Entidad con Cesión de Remate',null,null,null,'NUEVODICCIONARIO','0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_RegistrarResultadoPresentacionEscritoAlJuzgado','5','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1093')
	
	,T_TIPO_TFI('P458_BPMTramiteAdjudicacion','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite Adjudicación.</p></div>',null,null,null,null,'0','PRODUCTO-1093')

	,T_TIPO_TFI('P458_BPMTramiteCesionDeRemate','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite Cesión de Remate.</p></div>',null,null,null,null,'0','PRODUCTO-1093')

	,T_TIPO_TFI('P458_BPMTramiteAdjudicacionTerceros','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite Adjudicación a Terceros.</p></div>',null,null,null,null,'0','PRODUCTO-1093')

	,T_TIPO_TFI('P458_RevisarDocumentacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea deberá revisar:<br>- Si todos los bienes incluidos en la Subasta han de ser efectivamente subastados o, por el contrario, excluya manualmente los que no deban ser subastados<br>- La antigüedad de la certificación de cargas de cada uno de los bienes en la ficha del bien. En caso de que tengan una antigüedad superior a 3 meses, solicite las notas simples actualizadas.<br>- La antigüedad de la de la tasación de cada uno de los bienes. En caso de que sea superior a 6 meses solicite una nueva tasación a través de la ficha del bien.<br>- Si es necesario el informe fiscal en cuyo caso deberá solicitarlo a la entidad una vez tenga las tasaciones actualizadas.</p>Una vez determine qué documentación necesita deberá ponerse en contacto con el departamento correspondiente para solicitarla y dejar constancia en Recovery.</p>En el campo Fecha deberá señalar la fecha en la que hace esta revisión.</p>Una vez rellene esta pantalla se lanzará la tarea "Preparar informe de subasta" y:<br>- Si ha indicado que solicita tasación, se lanzará la tarea "Adjutar tasaciones".<br>- Si ha indicado que solicita tasación, se lanzará la tarea "Adjuntar nota simple".<br>- Si no ha solicitado tasaciones y ha indicado que va a solictar el informe fiscal, se lanzará la tarea "Adjuntar informe fiscal".</p>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_RevisarDocumentacion','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1093')     
	,T_TIPO_TFI('P458_RevisarDocumentacion','2','combo','comboNotaSimple','Solicita Nota Simple','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_RevisarDocumentacion','3','combo','comboTasacion','Solicita Tasación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_RevisarDocumentacion','4','combo','comboFiscal','Solicita Informe Fiscal','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_RevisarDocumentacion','5','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1093')

	,T_TIPO_TFI('P458_AdjuntarNotasSimples','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deberá actualizar la información en la ficha del "Bien"  de cada uno de los bienes de la subasta.</p>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-1093')
    	,T_TIPO_TFI('P458_AdjuntarNotasSimples','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_AdjuntarNotasSimples','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1093')

	,T_TIPO_TFI('P458_AdjuntarTasaciones','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deberá actualizar la información en la ficha del "Bien"  de cada uno de los bienes de la subasta.</p>En caso de que requiera solicitar el informe fiscal, deberá dejar constancia de ello en la herramienta y ponerse en contacto con el Área Fiscal para que generen el informe.</p>Una vez rellena esta pantalla, la siguiente tarea será, si ha marcado que solicita el informe fiscal, "Solicitar informe fiscal".</p>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-1093')
    	,T_TIPO_TFI('P458_AdjuntarTasaciones','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_AdjuntarTasaciones','2','combo','comboSolicitar','Solicitar Informe Fiscal','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_AdjuntarTasaciones','3','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1093')

	,T_TIPO_TFI('P458_SolicitarInformeFiscal','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deberá solicitar el informe fiscal a la entidad y dejar constancia en la herramienta de la fecha en la que ha realizado dicha solicitud.</p>Una vez rellene esta pantalla, la siguiente tarea será "adjuntar informe fiscal".</p>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-1093')
    	,T_TIPO_TFI('P458_SolicitarInformeFiscal','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_SolicitarInformeFiscal','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1093')

	,T_TIPO_TFI('P458_AdjuntarInformeFiscal','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deberá actualizar la información en la ficha del "Bien"  de cada uno de los bienes de la subasta y adjuntar el informe fiscal al procedimiento.</p>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-1093')
    	,T_TIPO_TFI('P458_AdjuntarInformeFiscal','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_AdjuntarInformeFiscal','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1093')

	,T_TIPO_TFI('P458_PrepararInformeDeSubasta','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deberá acceder desde la pestaña Subastas del asunto correspondiente a cada uno de los bienes afectos a la subasta e indicar los importes para la puja sin postores  y puja con postores.</p>Además, deberá adjuntar el informe de subasta, preparar el cuadro de pujas y obtener la tasación, notas simple e informe fiscal, en caso de que las solicitara en la tarea anterior, así como actualizar dicha información en la herramienta.</p>Una vez hecho esto podrá generar desde la pestaña Subastas el informe con la propuesta de instrucciones para la subasta en formato Word, de forma que en caso de ser necesario pueda modificarlo.</p>En el campo Fecha deberá informar la fecha en la que haya adjuntado el informe con las instrucciones para la subasta.</p>Una vez rellene esta pantalla se lanzará la tarea “Validar informe de subasta”.</p>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-1093')
    	,T_TIPO_TFI('P458_PrepararInformeDeSubasta','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_PrepararInformeDeSubasta','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1093')

	,T_TIPO_TFI('P458_ValidarInformeDeSubasta','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea deberá  revisar y dictaminar sobre la propuesta de instrucciones. En caso de que tenga atribuciones y la deuda judicial calculada sea superior a 500mil euros deberá informar a la entidad del celebramiento de la subasta y las instrucciones de puja a través de la herramienta mediante el botón "Anotación".</p>En caso de que no tenga atribuciones para validar el informe de subasta, deberá señalar el motivo de autorización de entre los posibles motivos listados.</p>La siguiente tarea será:<br>- En caso de aceptar el informe y tenga atribuciones, se lanzará la tarea de  “Dictar instrucciones”.<br>- En caso de aceptar el informe y no tenga atribuciones, se lanzará la tarea de  “Obtener validación comité”.<br>- Se lanzará la tarea “Preparar informe de subasta" en caso de no aceptar el informe.</p>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_ValidarInformeDeSubasta','1','combo','comboAceptarInforme','Aceptar Informe','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_ValidarInformeDeSubasta','2','combo','comboAtribuciones','Con Atribuciones',null,null,null,'DDSiNo','0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_ValidarInformeDeSubasta','3','combo','comboMotivo','Motivo de Autorización','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'NUEVODICCIONARIO','0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_ValidarInformeDeSubasta','4','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1093')

	,T_TIPO_TFI('P458_ObtenerValidacionComite','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deberá indicar la fecha en la que el comité decide sobre el informe de subasta.</p>En caso de que la recomendación del informe sea suspender subasta, o bien la entidad decida suspenderla, deberá indicar en el campo "Motivo de suspensión", el motivo por el que se suspende la subasta.</p>La siguiente tarea será:<br>- En el caso de que la respuesta del comité sea "Continuar subasta", se lanzará la siguiente tarea al gestor de contencioso gestión de "Dictar instrucciones".<br>- En el caso de que la respuesta del comité sea "Rechazar" el informe, se volverá a la tarea de "Preparar informe de Subasta".<br>- En el caso de que la respuesta del Comité sea "No pagar tasa", se lanzará la siguiente tarea "Pendiente confirmación pago de tasa".</p>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_ObtenerValidacionComite','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1093')	
	,T_TIPO_TFI('P458_ObtenerValidacionComite','2','combo','comboResultadoComite','Resultado del Comité','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'NUEVODICCIONARIO','0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_ObtenerValidacionComite','3','combo','comboMotivoImpago','Motivo de No Pagar la Tasa',null,null,null,'NUEVODICCIONARIO','0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_ObtenerValidacionComite','4','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1093')

	,T_TIPO_TFI('P458_PendienteConfirmacionPagoDeTasa','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta tarea y puesto que anteriormente la respuesta del Comité fue "No pagar tasa", usted deberá contactar con el Banco para preguntarle si pueden pagar la tasa o recibir nuevas instrucciones al respecto.<br>En función de la respuesta obtenida por el Banco deberá informar si se procede al pago de la tasa o no.<br>Si no ha obtenido respuesta, deberá autoprorrogarse esta tarea o paralizar el procedimiento durante el tiempo que le haya indicado la Entidad. </p>Una vez realizada esta tarea, se evaluará la información de la Resolución definitiva:<br>- Si se ha informado "Pagar tasa", la siguiente tarea será "Dictar instrucciones  de subasta y pago de tasa".<br>- Si se ha informado "No Pagar Tasa", saltará una toma de decisión.</p>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_PendienteConfirmacionPagoDeTasa','1','text','motivoImpago','Motivo de No Pagar Tasa',null,null,'(valores[''P458_ObtenerValidacionComite''] !=null && valores[''P454_ObtenerValidacionComite''][''comboMotivoImpago''] !=null) ? valores[''P458_ObtenerValidacionComite''][''comboMotivoImpago''] : null',null,'0','PRODUCTO-1093')	
	,T_TIPO_TFI('P458_PendienteConfirmacionPagoDeTasa','2','combo','comboResolucionDefinitiva','Resolución Definitiva','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'NUEVODICCIONARIO','0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_PendienteConfirmacionPagoDeTasa','3','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1093')

	,T_TIPO_TFI('P458_DictarInstruccionesDeSubastaYPagoDeTasa','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez aprobada la propuesta por su supervisor, en esta tarea el gestor de contencioso gestión deberá dictar las instrucciones de la subasta al letrado.</p>El campo Fecha deberá anotar la fecha en que se realiza esta tarea.</p>Una vez realizada esta tarea, se enviará un mensaje al Letrado a través de una notificación:<br>"Se han dictado instrucciones y la autorización para proceder al pago de la tasa".</p>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_DictarInstruccionesDeSubastaYPagoDeTasa','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1093')	
	,T_TIPO_TFI('P458_DictarInstruccionesDeSubastaYPagoDeTasa','2','textarea','instrucciones','Instrucciones','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1093')
	,T_TIPO_TFI('P458_DictarInstruccionesDeSubastaYPagoDeTasa','3','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1093')
       
        ); 
    V_TMP_TIPO_TFI T_TIPO_TFI;
    
BEGIN	
	
    -- LOOP Insertando valores en DD_TPO_TIPO_PROCEDIMIENTO
    VAR_TABLENAME := 'DD_TPO_TIPO_PROCEDIMIENTO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar TIPO DE PROCEDIMIENTO');
    FOR I IN V_TIPO_TPO.FIRST .. V_TIPO_TPO.LAST
      LOOP
        V_TMP_TIPO_TPO := V_TIPO_TPO(I);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||TRIM(V_TMP_TIPO_TPO(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;			
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO... Ya existe el procedimiento '''|| TRIM(V_TMP_TIPO_TPO(1)) ||'''');
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || ' (' ||
                    'DD_TPO_ID,DD_TPO_CODIGO,DD_TPO_DESCRIPCION,DD_TPO_DESCRIPCION_LARGA,' ||
                    'DD_TPO_HTML,DD_TPO_XML_JBPM,VERSION,USUARIOCREAR,' ||
                    'FECHACREAR,BORRADO,DD_TAC_ID,DD_TPO_SALDO_MIN,'||
                    'DD_TPO_SALDO_MAX,FLAG_PRORROGA,DTYPE,FLAG_DERIVABLE,FLAG_UNICO_BIEN) ' ||
                    'SELECT '||V_ESQUEMA ||'.S_DD_TPO_TIPO_PROCEDIMIENTO.NEXTVAL, ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(1)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(2)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(3)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(4)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(5)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(6)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(7)),'''','''''') || ''',sysdate,' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(8)),'''','''''') || ''',' ||
                    '(SELECT DD_TAC_ID FROM '|| V_ESQUEMA ||'.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO=''' || TRIM(V_TMP_TIPO_TPO(9)) || '''),' ||
                    '''' || TRIM(V_TMP_TIPO_TPO(10)) || ''',''' || TRIM(V_TMP_TIPO_TPO(11)) || ''',''' || TRIM(V_TMP_TIPO_TPO(12)) || ''',' ||
                    '''' || TRIM(V_TMP_TIPO_TPO(13)) || ''',''' || TRIM(V_TMP_TIPO_TPO(14)) || ''',''' || TRIM(V_TMP_TIPO_TPO(15)) || ''' FROM DUAL'; 
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TPO(1) ||''','''||TRIM(V_TMP_TIPO_TPO(2))||'''');
            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Procedimiento');
    
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
		' DD_TPO_ID_BPM=(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || TRIM(V_TMP_TIPO_TAP(7)) || '''),' ||
        	' DD_STA_ID=(SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' || 
		' DD_TSUP_ID=(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(22)) || ''')' ||
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
	  V_SQL := 'UPDATE '||V_ESQUEMA||'.'||VAR_TABLENAME||' SET DD_PTP_PLAZO_SCRIPT=''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(4)),'''','''''') || '''' ||
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
        	' TFI_BUSINESS_OPERATION=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(9)),'''','''''') || '''' ||
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