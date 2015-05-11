/*
--##########################################
--## Author: Roberto
--## BPM: Tramite Adjudicación (H005)
--## Finalidad: Insertar datos en tablas de configuración del BPM
--## INSTRUCCIONES: Configurar variables iniciales
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
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

    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
      
      T_TIPO_TPO('H005','Trámite de Adjudicación','Trámite de Adjudicación',null,'haya_tramiteAdjudicacionV4','0','DD','0','AP',null,null,'1','MEJTipoProcedimiento','1','0')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(2000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
    
      T_TIPO_TAP('H005','H005_BPMTramiteDePosesion',null,null,null,null,'H015','0','Llamada al BPM de Trámite de Trámite de Posesión','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
      
      T_TIPO_TAP('H005','H005_BPMTramiteNotificacion',null,null,null,null,'P400','0','Llamada al BPM de Trámite de Trámite de Notificación','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
      
      T_TIPO_TAP('H005','H005_BPMTramiteSaneamientoCargas',null,null,null,null,'H008','0','Llamada al BPM de Trámite de Trámite de Saneamiento de Cargas','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
      
      T_TIPO_TAP('H005','H005_BPMTramiteSubsanacionEmbargo1',null,null,null,null,'H052','0','Llamada al BPM de Trámite de Subsanación de Adjudicación','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
      
      T_TIPO_TAP('H005','H005_BPMTramiteSubsanacionEmbargo2',null,null,null,null,'H052','0','Llamada al BPM de Trámite de Subsanación de Adjudicación','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
      
      T_TIPO_TAP('H005','H005_BPMTramiteSubsanacionEmbargo3',null,null,null,null,'H052','0','Llamada al BPM de Trámite de Subsanación de Adjudicación','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
      
      T_TIPO_TAP('H005','H005_RegistrarEntregaTitulo','plugin/procedimientos/genericFormOverSize',null,' comprobarExisteDocumentoRECGES() ? null : ''Es necesario adjuntar el Recib&'||'iacute; de Gestor&'||'iacute;a.'' ',null,null,'0','Registrar entrega del título','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
      
      T_TIPO_TAP('H005','H005_RegistrarInscripcionDelTitulo','plugin/procedimientos/genericFormOverSize',null,' comprobarGestoriaAsignadaAlSaneamientoDeCargasDeBienes() ? comprobarAdjuntoDocumentoTestimonioInscritoEnRegistro() ? null : ''Debe adjuntar el Documento de Testimonio inscrito en el Registro.'' : ''Debe asignar la Gestor&'||'iacute;a encargada del saneamiento de cargas del bien.'' ','( valores[''H005_RegistrarInscripcionDelTitulo''][''comboSituacionTitulo''] == ''PEN'' ? ''SI'':''NO'')',null,'0','Registrar Inscripción del Título','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
      
      T_TIPO_TAP('H005','H005_RegistrarPresentacionEnHacienda',null,null,' comprobarAdjuntoDocumentoLiquidacionImpuestos() ? comprobarExisteDocumentoCALHAC() ? null : ''Debe adjuntar la copia de la autoliquidación presentada en Hacienda.'' : ''Debe adjuntar la copia escaneada del Documento de Liquidaci&'||'oacute;n de Impuestos.'' ',null,null,'0','Registrar presentación en Hacienda','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
      
      T_TIPO_TAP('H005','H005_RegistrarPresentacionEnRegistro',null,null,null,null,null,'0','Registrar presentación en Registro','0','DD','0',null,'tareaExterna.cancelarTarea',null,'0','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
      
      T_TIPO_TAP('H005','H005_SolicitudDecretoAdjudicacion',null,null,'comprobarBienAsociadoPrc() ? null : ''El bien debe estar asociado al tr&'||'aacute;mite, as&'||'oacute;cielo desde la pestaña de Bienes del procedimiento para poder finalizar esta tarea.''',null,null,'0','Solicitud de Decreto de Adjudicación','0','DD','0',null,null,null,'0','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
      
      T_TIPO_TAP('H005','H005_SolicitudTestimonioDecretoAdjudicacion',null,null,null,null,null,'0','Solicitud de Testimonio del Decreto de Adjudicación','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
      
      T_TIPO_TAP('H005','H005_notificacionDecretoAdjudicacionAlContrario',null,null,null,'( valores[''H005_notificacionDecretoAdjudicacionAlContrario''][''comboNotificacion''] == DDSiNo.SI ? ''SI'':''NO'')',null,'0','Notificación del Decreto de Adjudicación al Contrario','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),      
      
	  T_TIPO_TAP(
	  	/*DD_TPO_ID*/ 'H005',
	  	/*TAP_CODIGO*/ 'H005_ConfirmarTestimonio',
	  	/*TAP_VIEW*/ 'plugin/procedimientos/genericFormOverSize',
	  	/*TAP_SCRIPT_VALIDACION*/ ' comprobarGestoriaAsignadaPrc() ? comprobarAdjuntoDecretoFirmeAdjudicacion() ? comprobarExisteDocumentoMP()? null : ''Debe adjuntar el Mandamiento de Pago'' : ''Debe adjuntar el Decreto Firme de Adjudicacion.'' : ''Debe asignar la Gestoría encargada de tramitar la adjudicación.'' ',
	  	/*TAP_SCRIPT_VALIDACION_JBPM*/ null,
	  	/*TAP_SCRIPT_DECISION*/ '( valores[''H005_ConfirmarTestimonio''][''comboSubsanacion''] == DDSiNo.SI ? ''SI'':''NO'')',
	  	/*DD_TPO_ID_BPM*/ null,
	  	/*TAP_SUPERVISOR*/ '0',
	  	/*TAP_DESCRIPCION*/ 'Confirmar el Testimonio',
	  	/*VERSION*/ '0',
	  	/*USUARIOCREAR*/ 'DD',
	  	/*BORRADO*/ '0',
	  	/*TAP_ALERT_NO_RETORNO*/ null,
	  	/*TAP_ALERT_VUELTA_ATRAS*/ 'tareaExterna.cancelarTarea',
	  	/*DD_FAP_ID*/ null,
	  	/*TAP_AUTOPRORROGA*/ '1',
	  	/*DTYPE*/ 'EXTTareaProcedimiento',
	  	/*TAP_MAX_AUTOP*/ '3',
	  	/*DD_TGE_ID*/ null,
	  	/*DD_STA_ID*/ '39',
	  	/*TAP_EVITAR_REORG*/ null,
	  	/*DD_TSUP_ID*/ 'GUCL',
	  	/*TAP_BUCLE_BPM*/ null
	  ),      	  
	  
      T_TIPO_TAP('H005','H005_notificacionDecretoAdjudicacionAEntidad','plugin/procedimientos/genericFormOverSize',
      ' comprobarAdjuntoDecretoFirmeAdjudicacion() ? null : ''Debe adjuntar el Decreto Firme de Adjudicaci&'||'oacute;n.'' ',
      null,      
      '( valores[''H005_notificacionDecretoAdjudicacionAEntidad''][''comboSubsanacion''] == DDSiNo.SI ? ''SI'' : valores[''H005_notificacionDecretoAdjudicacionAEntidad''][''comboEntidadAdjudicataria''] == ''BANKIA'' ? ''BANKIA'' : ''SAREB'')',      
      null,'0','Notificación del Decreto de Adjudicación a Entidad','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
      
      T_TIPO_TAP('H005','H005_ConfirmarContabilidad',null,null,null,null,null,'0','Confirmar contabilidad','0','DD','0',null,null,null,'0','EXTTareaProcedimiento','3',null,'805',null,'SSDE',null),
      
      T_TIPO_TAP('H005','H005_BPMLiquidacionTributacionBienesBankia',null,null,null,null,'H014','0','Llamada al BPM de Trámite de Liquidacion de Tributacion en Bienes','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
      T_TIPO_TAP('H005','H005_BPMLiquidacionTributacionBienesSareb',null,null,null,null,'H013','0','Llamada al BPM de Trámite de Liquidacion de Tributacion en Bienes','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null)
      	
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
    
        T_TIPO_PLAZAS(null,null,'H005_SolicitudDecretoAdjudicacion','valores[''P401_RegistrarActaSubasta''] != null && valores[''P401_RegistrarActaSubasta''][''fecha''] != null ? damePlazo(valores[''P401_RegistrarActaSubasta''][''fecha'']) + 20*24*60*60*1000L:5*24*60*60*1000L','0','0','DD'),
        
        T_TIPO_PLAZAS(null,null,'H005_notificacionDecretoAdjudicacionAEntidad','valores[''P401_RegistrarActaSubasta''] != null && valores[''P401_RegistrarActaSubasta''][''fecha''] != null ? damePlazo(valores[''P401_RegistrarActaSubasta''][''fecha'']) + 30*24*60*60*1000L:30*24*60*60*1000L','0','0','DD'),
        
        T_TIPO_PLAZAS(null,null,'H005_notificacionDecretoAdjudicacionAlContrario','damePlazo(valores[''H005_notificacionDecretoAdjudicacionAEntidad''][''fecha''])+30*24*60*60*1000L','0','0','DD'),
        
        T_TIPO_PLAZAS(null,null,'H005_SolicitudTestimonioDecretoAdjudicacion','damePlazo(valores[''H005_notificacionDecretoAdjudicacionAlContrario''][''fecha''])+20*24*60*60*1000L','0','0','DD'),
        
        T_TIPO_PLAZAS(null,null,'H005_ConfirmarTestimonio','damePlazo(valores[''H005_SolicitudTestimonioDecretoAdjudicacion''][''fecha''])+30*24*60*60*1000L','0','0','DD'),
        
        T_TIPO_PLAZAS(null,null,'H005_RegistrarEntregaTitulo','damePlazo(valores[''H005_ConfirmarTestimonio''][''fechaTestimonio''])+7*24*60*60*1000L','0','0','DD'),
        
        T_TIPO_PLAZAS(null,null,'H005_RegistrarPresentacionEnHacienda','damePlazo(valores[''H005_ConfirmarTestimonio''][''fechaTestimonio''])+30*24*60*60*1000L','0','0','DD'),
        
        T_TIPO_PLAZAS(null,null,'H005_RegistrarPresentacionEnRegistro','valores[''P414_EntregarNuevoDecreto''] != null ? damePlazo(valores[''P414_EntregarNuevoDecreto''][''fechaEnvio''])+10*24*60*60*1000L : damePlazo(valores[''H005_RegistrarPresentacionEnHacienda''][''fechaPresentacion''])+10*24*60*60*1000L ','0','0','DD'),
        
        T_TIPO_PLAZAS(null,null,'H005_RegistrarInscripcionDelTitulo','damePlazo(valores[''H005_RegistrarPresentacionEnRegistro''][''fechaPresentacion''])+60*24*60*60*1000L','0','0','DD'),
        
        T_TIPO_PLAZAS(null,null,'H005_BPMTramiteSubsanacionEmbargo1','300*24*60*60*1000L','0','0','DD'),
        
        T_TIPO_PLAZAS(null,null,'H005_BPMTramiteNotificacion','300*24*60*60*1000L','0','0','DD'),
        
        T_TIPO_PLAZAS(null,null,'H005_BPMTramiteDePosesion','300*24*60*60*1000L','0','0','DD'),
        
        T_TIPO_PLAZAS(null,null,'H005_BPMTramiteSaneamientoCargas','300*24*60*60*1000L','0','0','DD'),
        
        T_TIPO_PLAZAS(null,null,'H005_BPMTramiteSubsanacionEmbargo2','300*24*60*60*1000L','0','0','DD'),
        
        T_TIPO_PLAZAS(null,null,'H005_BPMTramiteSubsanacionEmbargo3','300*24*60*60*1000L','0','0','DD'),        
        
        T_TIPO_PLAZAS(null,null,'H005_ConfirmarContabilidad','7*24*60*60*1000L','0','0','DD'),
        
        T_TIPO_PLAZAS(null,null,'H005_BPMLiquidacionTributacionBienesBankia','300*24*60*60*1000L','0','0','DD'),
        
        T_TIPO_PLAZAS(null,null,'H005_BPMLiquidacionTributacionBienesSareb','300*24*60*60*1000L','0','0','DD')

    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
    
      T_TIPO_TFI('H005_ConfirmarTestimonio','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por completada esta tarea deber&aacute; de acceder a la pestaña Gestores del asunto correspondiente y asignar el tipo de gestor "Gestor&iacute;a adjudicaci&oacute;n" seg&uacute;n el protocolo que tiene establecido la entidad.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A trav&eacute;s de esta pantalla se ha de marcar la fecha que el Juzgado hace entrega del Testimonio del Decreto a favor de la Entidad. Se ha de tener en cuenta que desde la fecha que se indique en esta pantalla se inicia el plazo para liquidar los impuestos que correspondan.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez confirmado con el procurador el env&iacute;o a la gestor&iacute;a, se deber&aacute; informar dicha fecha en el campo "Fecha env&iacute;o a Gestor&iacute;a" y del nombre de la gestor&iacute;a.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Con el objeto de evitar calificaciones desfavorables y subsanaciones posteriores que retrasan la inscripción deber&aacute;:<br>Obtenido el testimonio, se revisar&aacute; la  fecha de expedici&oacute;n  para liquidaci&oacute;n de impuestos en plazo, seg&uacute;n normativa de CCAA. La verificaci&oacute;n de la fecha del t&iacute;tulo es necesaria y fundamental para que la gestor&iacute;a pueda realizar la liquidaci&oacute;n en plazo.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Adicionalmente se  revisar&aacute;n el contenido fundamental y de forma, para evitar subsanaciones posteriores que retrasen la inscripci&oacute;n.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Contenido b&aacute;sico para revisar en testimonio decreto de adjudicaci&oacute;n  y mandamientos:<br>- Datos procesales b&aacute;sicos: (Nº autos, tipo de procedimiento, cantidad reclamada)<br>- Datos de la Entidad demandante (nombre CIF, domicilio) y en su caso de los adjudicados.<br>- Datos  de los demandados y titulares registrales.<br>- Importe de adjudicaci&oacute;n y cesi&oacute;n de remate (en su caso).<br>- Orden de cancelaci&oacute;n de la nota marginal y cancelaci&oacute;n de la carga objeto de ejecuci&oacute;n as&iacute; como cargas posteriores)<br>- Descripci&oacute;n  y datos registrales completos de la finca adjudicada.<br>- Declaraci&oacute;n en el auto de la firmeza de la resoluci&oacute;n</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez analizados los puntos descritos, en el campo Requiere subsanaci&oacute;n deber&aacute; indicar el resultado de dicho an&aacute;lisis.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deber&aacute; de adjuntar al procedimiento correspondiente una copia escaneada del decreto firme de adjudicaci&oacute;n.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzar&aacute;, en caso de requerir subsanaci&oacute;n el tr&aacute;mite de subsanaci&oacute;n de adjudicaci&oacute;n, y en caso contrario se lanzar&aacute; por un lado la tarea  "Registrar entrega del t&iacute;tulo" y por otro el tr&aacute;mite de posesi&oacute;n.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('H005_ConfirmarTestimonio','1','date','fechaTestimonio','Fecha Testimonio','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
      T_TIPO_TFI('H005_ConfirmarTestimonio','2','combo','comboSubsanacion','Requiere Subsanación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
      T_TIPO_TFI('H005_ConfirmarTestimonio','3','date','fechaEnvioGestoria','Fecha Envío a Gestoría','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
      T_TIPO_TFI('H005_ConfirmarTestimonio','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
      
      T_TIPO_TFI('H005_RegistrarEntregaTitulo','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A trav&eacute;s de esta pantalla deber&aacute; de informar de la fecha en que recibe la informaci&oacute;n sobre los documentos asignados que se le han enviado.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por terminada esta tarea deber&aacute;:<br>- Liquidar impuestos  en  plazo  seg&uacute;n CCAA. En caso de personas jur&iacute;dicas existir&aacute; una consulta previa realizada sobre la posible liquidaci&oacute;n de IVA. Esta informaci&oacute;n podr&aacute; consultarla a trav&eacute;s de la ficha de cada uno de los bienes incluidos.<br>- Verificar situaci&oacute;n ocupacional de la finca para manifestaci&oacute;n de libertad arrendamientos de cara a inscripci&oacute;n (LAU).<br>- Redactar en su caso, certificado de Libertad de Arrendamiento (por poder de la Entidad), para presentaci&oacute;n  en el registro junto con el testimonio y los mandamientos.<br>- Realizar notificaci&oacute;n fehaciente a inquilinos para la inscripci&oacute;n  (en casos de inmueble con arrendamiento reconocido)</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzar&aacute; la tarea "Registrar presentaci&oacute;n en hacienda".</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('H005_RegistrarEntregaTitulo','1','date','fechaRecepcion','Fecha de Recepción','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
      T_TIPO_TFI('H005_RegistrarEntregaTitulo','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
      
      T_TIPO_TFI('H005_RegistrarPresentacionEnHacienda','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deber&aacute; presentar la liquidaci&oacute;n del testimonio en Hacienda, una vez realizado esto deber&aacute; adjuntar al procedimiento correspondiente copia escaneada del documento de liquidaci&oacute;n de impuestos.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzar&aacute; la tarea "Registrar presentaci&oacute;n en el registro".</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('H005_RegistrarPresentacionEnHacienda','1','date','fechaPresentacion','Fecha Presentación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
      T_TIPO_TFI('H005_RegistrarPresentacionEnHacienda','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
      
      T_TIPO_TFI('H005_RegistrarPresentacionEnRegistro','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En caso de que se haya tenido que presentar subsanaci&oacute;n y por tanto estemos a la espera de recibir el nuevo testimonio decreto de adjudicaci&oacute;n, en el campo fecha nuevo decreto</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzar&aacute; la tarea "Registrar inscripci&oacute;n del t&iacute;tulo".</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('H005_RegistrarPresentacionEnRegistro','1','date','fechaPresentacion','Fecha Presentación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
      T_TIPO_TFI('H005_RegistrarPresentacionEnRegistro','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
      
      T_TIPO_TFI('H005_RegistrarInscripcionDelTitulo','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deber&aacute; indicar la situaci&oacute;n en que queda el t&iacute;tulo ya sea inscrito en el registro o pendiente de subsanaci&oacute;n, a trav&eacute;s de la ficha del bien correspondiente deber&aacute; de actualizar los campos: folio, libro, tomo, inscripci&oacute;n Xª, referencia catastral, porcentaje de propiedad, nº de finca -si hubiera cambios Actualizado. Una vez actualizados estos campos deber&aacute; de marcar la fecha de actualizaci&oacute;n en la ficha del bien.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En caso de haberse producido una resoluci&oacute;n desfavorable y haber marcado el bien en situaci&oacute;n "Subsanar", deber&aacute; informar la fecha de env&iacute;o de decreto para adici&oacute;n y proceder a la remisi&oacute;n de los documentos al Procurador e informa al Letrado.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En caso de haber quedado inscrito el bien, deber&aacute; informar la fecha en que se haya producido dicha inscripci&oacute;n.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por terminada esta tarea y una vez obtenido el testimonio inscrito en el registro, deber&aacute; adjuntar dicho documento al procedimiento correspondiente.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzar&aacute;, en caso de requerir subsanaci&oacute;n el tr&aacute;mite de subsanaci&oacute;n de decreto de adjudicaci&oacute;n  a realizar por el letrado, y en caso contrario se iniciar&aacute; el tr&aacute;mite de saneamiento de cargas para el bien afecto a este tr&aacute;mite.</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('H005_RegistrarInscripcionDelTitulo','1','combo','comboSituacionTitulo','Título Inscrito en el Registro','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSituacionTitulo','0','DD'),
      T_TIPO_TFI('H005_RegistrarInscripcionDelTitulo','2','date','fechaInscripcion','Fecha Inscripción','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
      T_TIPO_TFI('H005_RegistrarInscripcionDelTitulo','3','date','fechaEnvioDecretoAdicion','Fecha Envío Decreto Adición','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
      T_TIPO_TFI('H005_RegistrarInscripcionDelTitulo','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
      
      T_TIPO_TFI('H005_BPMTramiteSubsanacionEmbargo1','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Subsanación de Embargo.</p></div>',null,null,null,null,'0','DD'),      
      T_TIPO_TFI('H005_BPMTramiteNotificacion','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Notificación.</p></div>',null,null,null,null,'0','DD'),      
      T_TIPO_TFI('H005_BPMTramiteDePosesion','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Posesión.</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('H005_BPMTramiteSaneamientoCargas','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Saneamiento de Cargas.</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('H005_BPMTramiteSubsanacionEmbargo2','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Subsanación de Embargo.</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('H005_BPMTramiteSubsanacionEmbargo3','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Subsanación de Embargo.</p></div>',null,null,null,null,'0','DD'),
      
      T_TIPO_TFI('H005_SolicitudDecretoAdjudicacion','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Tanto si en la subasta no han concurrido postores, como si SAREB ha resultado mejor postor, el letrado deber&aacute; solicitar la adjudicaci&oacute;n a favor de SAREB con reserva de la facultad de ceder el remate, por lo que a trav&eacute;s de esta tarea deber&aacute; de informar la fecha de presentaci&oacute;n en el Juzgado del escrito de solicitud del Decreto de Adjudicaci&oacute;n.En caso de no haber un bien ya vinculado al procedimiento, antes de dar por completada esta tarea el sistema le obligar&aacute; a asociarlo a trav&eacute;s de la pestaña bienes del procedimiento el bien que corresponda.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En caso de haber interesados en la cesi&oacute;n de remate se deber&iacute;a lanzar desde aqu&iacute; el tr&eacute;mite de la cesi&oacute;n. Si llegado el final del plazo concedido para ceder el remate no hubieran aparecido interesados en la cesi&oacute;n, se renunciar&aacute; a la misma y se solicitar&aacute; la adjudicaci&oacute;n a favor de SAREB.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzará la tarea "Notificaci&oacute;n decreto de adjudicaci&oacute;n a la entidad".</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('H005_SolicitudDecretoAdjudicacion','1','date','fechaSolicitud','Fecha Solicitud','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
      T_TIPO_TFI('H005_SolicitudDecretoAdjudicacion','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
      
      T_TIPO_TFI('H005_notificacionDecretoAdjudicacionAEntidad','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A trav&eacute;s de esta pantalla deber&aacute; de informar la fecha en la que se notifica por el Juzgado el Decreto de Adjudicaci&oacute;n, la entidad adjudicataria de los bienes afectos.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Deber&aacute; revisar que el Decreto es conforme a la subasta celebrada y contiene lo preceptuado para su correcta inscripci&oacute;n en el Registro de la Propiedad, para ello deber&aacute; revisar:<br>- Datos procesales b&aacute;sicos: (Nº autos, tipo de procedimiento, cantidad reclamada)<br>- Datos de la Entidad demandante (nombre CIF, domicilio) y de los adjudicatarios<br>- Datos  de los demandados y titulares registrales.<br>- Importe de adjudicaci&oacute;n.<br>- Orden de cancelaci&oacute;n de la nota marginal y cancelaci&oacute;n de la carga objeto de ejecuci&oacute;n as&iacute; como cargas posteriores)<br>- Descripci&oacute;n  y datos registrales completos de la finca adjudicada.<br>- Declaraci&oacute;n en el auto de la firmeza de la resoluci&oacute;n<br></p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez analizados los puntos descritos, en el campo Requiere subsanaci&oacute;n deber&aacute; indicar el resultado de dicho an&aacute;lisis.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez emitido el Auto Decreto de Adjudicaci&oacute;n, se lanzar&aacute; el Tr&aacute;mite de Liquidaci&oacute;n de la Tributaci&oacute;n.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzar&aacute;, en caso de requerir subsanaci&oacute;n, el Tr&aacute;mite de subsanaci&oacute;n de adjudicaci&oacute;n, en caso contrario se lanzar&aacute; la tarea "Notificaci&oacute;n decreto adjudicaci&oacute;n al contrario".</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el caso de venir de una ejecuci&oacute;n notarial, de acuerdo con el deudor, no ser&aacute; necesario la notificaci&oacute;n del decreto de adjudicaci&oacute;n de la parte contraria y, por tanto,  la siguiente tarea que lanzar&aacute; ser&aacute;  Solicitud de Testimonio de decreto de Adjudicaci&oacute;n.</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('H005_notificacionDecretoAdjudicacionAEntidad','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
      T_TIPO_TFI('H005_notificacionDecretoAdjudicacionAEntidad','2','combo','comboEntidadAdjudicataria','Entidad Adjudicataria','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDEntidadAdjudicataria','0','DD'),
      T_TIPO_TFI('H005_notificacionDecretoAdjudicacionAEntidad','3','combo','comboFondo','Fondo','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDTipoFondo','0','DD'),
      T_TIPO_TFI('H005_notificacionDecretoAdjudicacionAEntidad','4','combo','comboSubsanacion','Requiere Subsanación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
      T_TIPO_TFI('H005_notificacionDecretoAdjudicacionAEntidad','5','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
      
      T_TIPO_TFI('H005_notificacionDecretoAdjudicacionAlContrario','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A trav&eacute;s de esta pantalla se deber&aacute; informar del resultado de la notificaci&oacute;n del decreto de adjudicaci&oacute;n a la parte ejecutada, en caso de notificaci&oacute;n positiva se informar&aacute; de la fecha de notificaci&oacute;n del Decreto de Adjudicaci&oacute;n.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzar&aacute;, en caso de notificaci&oacute;n negativa a la parte contraria el tr&aacute;mite de notificaci&oacute;n, y en caso contrario la tarea "Solicitud de testimonio de decreto de adjudicaci&oacute;n".</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('H005_notificacionDecretoAdjudicacionAlContrario','1','combo','comboNotificacion','Notificado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
      T_TIPO_TFI('H005_notificacionDecretoAdjudicacionAlContrario','2','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
      T_TIPO_TFI('H005_notificacionDecretoAdjudicacionAlContrario','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
      
      T_TIPO_TFI('H005_SolicitudTestimonioDecretoAdjudicacion','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por completada esta tarea deber&aacute; de informar la Fecha de solicitud del testimonio de decreto de adjudicaci&oacute;n.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzar&aacute;, en caso de notificaci&oacute;n negativa a la parte contraria el tr&aacute;mite de notificaci&oacute;n, y en caso contrario la tarea "Confirmar testimonio decreto de adjudicaci&oacute;n".</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('H005_SolicitudTestimonioDecretoAdjudicacion','1','date','fecha','Fecha Solicitud','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
      T_TIPO_TFI('H005_SolicitudTestimonioDecretoAdjudicacion','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
      
      T_TIPO_TFI('H005_ConfirmarContabilidad','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Desde Soporte Deuda,  deben confirmar en esta tarea que han realizado la contabilizaci&oacute;n del bien adjudicado, una vez se reciba el testimonio  de decreto de adjudicaci&oacute;n.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo Observaciones informar cualquier aspecto relevante que le interese quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('H005_ConfirmarContabilidad','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
      T_TIPO_TFI('H005_ConfirmarContabilidad','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
      
	  T_TIPO_TFI('H005_BPMLiquidacionTributacionBienesBankia','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Liquidación de Tributacion en Bienes.</p></div>',null,null,null,null,'0','DD'),
	  T_TIPO_TFI('H005_BPMLiquidacionTributacionBienesSareb','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Liquidación de Tributacion en Bienes.</p></div>',null,null,null,null,'0','DD')      
      
    ); 
    V_TMP_TIPO_TFI T_TIPO_TFI;
    
BEGIN	

    -- LOOP Insertando valores en TAP_TAREA_PROCEDIMIENTO
    VAR_TABLENAME := 'DD_TPO_TIPO_PROCEDIMIENTO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar TAREAS');
    FOR I IN V_TIPO_TPO.FIRST .. V_TIPO_TPO.LAST
      LOOP
        V_TMP_TIPO_TPO := V_TIPO_TPO(I);
        --Comprobamos el dato
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

            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TPO(1) ||''','''||TRIM(V_TMP_TIPO_TPO(2))||'''');
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
        -- Comprobamos el dato
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE DD_TPO_ID = (SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(1))||''' ) and TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO... Ya existe la tarea '''|| TRIM(V_TMP_TIPO_TAP(1)) ||''' and TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(2))||'''');
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || ' (' ||
                    'TAP_ID,DD_TPO_ID,TAP_CODIGO,TAP_VIEW,TAP_SCRIPT_VALIDACION,TAP_SCRIPT_VALIDACION_JBPM,TAP_SCRIPT_DECISION,DD_TPO_ID_BPM,' ||
                    'TAP_SUPERVISOR,TAP_DESCRIPCION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,TAP_ALERT_NO_RETORNO,TAP_ALERT_VUELTA_ATRAS,DD_FAP_ID,' ||
                    'TAP_AUTOPRORROGA,DTYPE,TAP_MAX_AUTOP,DD_TGE_ID,DD_STA_ID,TAP_EVITAR_REORG,DD_TSUP_ID,TAP_BUCLE_BPM) ' ||
                    'SELECT ' ||
                    'S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL, ' ||
                    '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(1)),'''','''''')  || '''),' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(2)),'''','''''') || ''',''' 
                    || REPLACE(TRIM(V_TMP_TIPO_TAP(3)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(4)),'''','''''') || ''',''' 
                    || REPLACE(TRIM(V_TMP_TIPO_TAP(5)),'''','''''') || ''',''' 
                    || REPLACE(TRIM(V_TMP_TIPO_TAP(6)),'''','''''') || ''',' || 
                    '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(7)),'''','''''') || '''),' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(8)),'''','''''') || ''',''' 
                    || REPLACE(TRIM(V_TMP_TIPO_TAP(9)),'''','''''') || ''',''' 
                    || REPLACE(TRIM(V_TMP_TIPO_TAP(10)),'''','''''') || ''',''' 
                    || REPLACE(TRIM(V_TMP_TIPO_TAP(11)),'''','''''') || ''',' ||
                    'sysdate,''' 
                    || REPLACE(TRIM(V_TMP_TIPO_TAP(12)),'''','''''') || ''',''' 
                    || REPLACE(TRIM(V_TMP_TIPO_TAP(13)),'''','''''') || ''',''' 
                    || REPLACE(TRIM(V_TMP_TIPO_TAP(14)),'''','''''') || ''',''' 
                    || REPLACE(TRIM(V_TMP_TIPO_TAP(15)),'''','''''') || ''',''' 
                    || REPLACE(TRIM(V_TMP_TIPO_TAP(16)),'''','''''') || ''',''' 
                    || REPLACE(TRIM(V_TMP_TIPO_TAP(17)),'''','''''') || ''','''
                    || REPLACE(TRIM(V_TMP_TIPO_TAP(18)),'''','''''') || ''','''
                    || REPLACE(TRIM(V_TMP_TIPO_TAP(19)),'''','''''') || ''','
                    || '(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.dd_tge_tipo_gestor WHERE DD_TGE_CODIGO=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(20)),'''','''''') || '''),' 
                    || '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(21)),'''','''''') || ''',' 
                    || '(SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(22)) || '''),' 
                    || REPLACE(TRIM(V_TMP_TIPO_TAP(23)),'''','''''') 
                    || ''''' FROM DUAL';
                    
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TAP(2)||''','''||TRIM(V_TMP_TIPO_TAP(9))||'''');
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
        -- Comprobamos el dato
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_PLAZAS(3))||''')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_PTP_PLAZOS_TAREAS_PLAZAS... Ya existe el plazo '''|| TRIM(V_TMP_TIPO_PLAZAS(3)) ||'''');
        ELSE
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
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_PLAZAS(3) ||''','''||TRIM(V_TMP_TIPO_PLAZAS(4))||'''');
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
        -- Comprobamos el dato
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TFI(1))||''') and TFI_ORDEN = '||TRIM(V_TMP_TIPO_TFI(2));
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TFI_TAREAS_FORM_ITEMS... Ya existe el item '''|| TRIM(V_TMP_TIPO_TFI(1)) ||''' and TFI_ORDEN = '||TRIM(V_TMP_TIPO_TFI(2))||' ');
        ELSE
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
          END IF;
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Campos');
    
    /*
     * Desactivamos trámites antiguos si existen
     */
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO IN (''P05'',''P413'') AND BORRADO=0 ';
        
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN
	    V_SQL := 'UPDATE '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO SET BORRADO=1 WHERE DD_TPO_CODIGO IN (''P05'',''P413'') AND BORRADO=0 ';
        DBMS_OUTPUT.PUT_LINE('Trámite antiguo desactivado.');
        EXECUTE IMMEDIATE V_SQL;        
	END IF;    
	
    /*
    * COMMIT ALL BLOCK-CODE
    *---------------------------------------------------------------------
    */
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[COMMIT ALL]...............................................');
    DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]-----------------------------------------------------------');
    /*
    *---------------------------------------------------------------------------------------------------------
    *                                FIN - BLOQUE DE CODIGO DEL SCRIPT
    *---------------------------------------------------------------------------------------------------------
    */	
    
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