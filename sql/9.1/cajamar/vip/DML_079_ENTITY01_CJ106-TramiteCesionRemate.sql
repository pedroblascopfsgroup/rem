--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20150822
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.1-hy-rc02
--## INCIDENCIA_LINK=CMREC-416
--## PRODUCTO=NO
--##
--## Finalidad: Adaptar BPM's Haya-Cajamar
--## INSTRUCCIONES: Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE

	/*
    * CONFIGURACION: ESQUEMAS
    *---------------------------------------------------------------------
    */
    PAR_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';               -- [PARAMETRO] Configuracion Esquemas
    PAR_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';    -- [PARAMETRO] Configuracion Esquemas

    /*
    * CONFIGURACION: TABLAS
    *---------------------------------------------------------------------
    */    
    PAR_TABLENAME_TPROC VARCHAR2(50 CHAR) := 'DD_TPO_TIPO_PROCEDIMIENTO';   -- [PARAMETRO] TABLA para tipo de procedimiento. Por defecto DD_TPO_TIPO_PROCEDIMIENTO
    PAR_TABLENAME_TARPR VARCHAR2(50 CHAR) := 'TAP_TAREA_PROCEDIMIENTO';     -- [PARAMETRO] TABLA para tareas del procedimiento. Por defecto TAP_TAREA_PROCEDIMIENTO
    PAR_TABLENAME_TPLAZ VARCHAR2(50 CHAR) := 'DD_PTP_PLAZOS_TAREAS_PLAZAS'; -- [PARAMETRO] TABLA para plazos de tareas. Por defecto DD_PTP_PLAZOS_TAREAS_PLAZAS
    PAR_TABLENAME_TFITE VARCHAR2(50 CHAR) := 'TFI_TAREAS_FORM_ITEMS';       -- [PARAMETRO] TABLA para items del form de tareas. Por defecto TFI_TAREAS_FORM_ITEMS

    /*
    * CONFIGURACION: IDENTIDAD SCRIPT
    *---------------------------------------------------------------------
    */
    PAR_TIT_TRAMITE VARCHAR2(50 CHAR)   := 'Trámite de cesión de remate';   -- [PARAMETRO] Título del trámite
    PAR_AUTHOR VARCHAR2(20 CHAR)        := 'Alberto';                            -- [PARAMETRO] Nick del autor
    PAR_AUTHOR_EMAIL VARCHAR2(50 CHAR)  := 'alberto.campos@pfsgroup.es';   -- [PARAMETRO] Email del autor
    PAR_AUTHOR_TELF VARCHAR2(10 CHAR)   := '2052';                              -- [PARAMETRO] Teléfono del autor

    /*
    * VARIABLES DEL SCRIPT
    *---------------------------------------------------------------------
    */    
    V_MSQL VARCHAR2(32000 CHAR);                        -- Sentencia a ejecutar     
    V_SQL VARCHAR2(4000 CHAR);                          -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16);                            -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);                                 -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR);                        -- Vble. auxiliar para registrar errores en el script.

    VAR_SEQUENCENAME VARCHAR2(50 CHAR);                 -- Variable para secuencias
    VAR_CURR_ROWARRAY VARCHAR2(25 CHAR);                -- Variable con fila array actual - para excepciones
    VAR_CURR_TABLE VARCHAR2(50 CHAR);                   -- Variable con tabla actual - para excepciones

    V_CODIGO_TPO VARCHAR2(100 CHAR); -- Variable para nombre campo FK con codigo de Tipo procedimiento
    V_CODIGO_TAP VARCHAR2(100 CHAR); -- Variable para nombre campo FK con codigo de Tap tareas
    V_CODIGO_PLAZAS VARCHAR2(100 CHAR); -- Variable para nombre campo FK con codigo de Plazos
    V_CODIGO1_TFI VARCHAR2(100 CHAR); -- Variable para nombre campo1 FK con codigo de TFI Items
    V_CODIGO2_TFI VARCHAR2(100 CHAR); -- Variable para nombre campo2 FK con codigo de TFI Items
    V_COD_PROCEDIMIENTO VARCHAR(10 CHAR) := 'CJ106'; -- Código de procedimiento para reemplazar

	/*
    * ARRAY TABLA1: DD_TPO_TIPO_PROCEDIMIENTO
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
    	T_TIPO_TPO(V_COD_PROCEDIMIENTO, 'T. de cesión de remate - CJ','T. de cesión de remate','','cj_tramiteCesionRemate',0,'DD',0,'AP', null, null,1,'MEJTipoProcedimiento',1,0)
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;
    
    /*
    * ARRAY TABLA2: TAP_TAREA_PROCEDIMIENTO
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(2000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ106_AperturaPlazo','plugin/cajamar/tramiteCesionRemate/aperturaPlazo','','valores[''CJ106_AperturaPlazo''][''comboFinaliza''] == DDSiNo.SI && !comprobarExisteDocumentoCRSOLADJ() ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar la Solicitud de adjudicaci&oacute;n con reserva de facultad de cesi&oacute;n de remate.</div>'' : null','( valores[''CJ106_AperturaPlazo''][''comboFinaliza''] == DDSiNo.SI ? ''SI'':''NO'')','',0,'Apertura del plazo de cesión de remate',0,'DD',0,'','','',0,'EXTTareaProcedimiento',0,'','', null,'',''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ106_BPMTramiteAdjudicacion','','','','','CJ105',0,'Trámite de Adjudicación',0,'DD',0,'','','',0,'EXTTareaProcedimiento',0,'','', null,'',''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ106_RealizacionCesionRemate','','comprobarTipoCargaBienIns() ? (comprobarExisteDocumentoCRACCES() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el acta de cesi&oacute;n.</div>'') :  ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe revisar el estado de las cargas.</div>''','','valores[''CJ106_AperturaPlazo''][''cbTitulizado'']==DDSiNo.SI || valores[''CJ106_AperturaPlazo''][''cbCresionRemate'']==''CIM2'' ? ''cimenta2oTitulizado'' : ''sinAdjudicacion''','',0,'Registrar realización cesión de remate',0,'DD',0,'','','',0,'EXTTareaProcedimiento',0,'','', null,'',''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ106_ResenyarFechaComparecencia','','','','valores[''CJ106_AperturaPlazo''][''cbCresionRemate'']==''CIM2'' ? ''aCimenta2'' : ''aTerceros''','',0,'Registrar fecha comparecencia',0,'DD',0,'','tareaExterna.cancelarTarea','',1,'EXTTareaProcedimiento',3,'','', null,'',''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ106_NoCesionRemateDecision','','','','','',0,'Tarea toma de decisión',0,'DD',0,'','','',0,'EXTTareaProcedimiento',0,'','', null,'',''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ106_ConfirmarDocCompleta','','','','','',0,'Confirmar documentación completa',0,'DD',0,'','tareaExterna.cancelarTarea','',1,'EXTTareaProcedimiento',3,'','', null,'',''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ106_SolicitudAutYPago','plugin/cajamar/tramiteCesionRemate/solicitarAutPago','','','','',0,'Solicitar autorización y transferencia de pago',0,'DD',0,'','tareaExterna.cancelarTarea','',1,'EXTTareaProcedimiento',3,'','', null,'',''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ106_ConfirmarTransferencia','','comprobarExisteDocumentoCRRESTRA() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el Resguardo de la transferencia.</div>''','','','',0,'Confirmar transferencia realizada',0,'DD',0,'','tareaExterna.cancelarTarea','',1,'EXTTareaProcedimiento',3,'','', null,'',''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ106_RegistrarRecepcionPago','','','valores[''CJ106_SolicitudAutYPago''][''cbCertificado'']==DDSiNo.SI && valores[''CJ106_RegistrarRecepcionPago''][''fechaCert'']==null ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Ha indicado que hay emisi&oacute;m de certificado por lo tanto debe indicar la fecha de emisi&oacute;n del certificado.</div>'' : null','','',0,'Registrar recepción transferencia de pago y emisión certificado',0,'DD',0,'','tareaExterna.cancelarTarea','',1,'EXTTareaProcedimiento',3,'','', null,'',''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ106_BPMTramiteSaneamientoCargas','','','','','CJ008',0,'Se inicia el trámite de Saneamiento de cargas adj.',0,'DD',0,'','tareaExterna.cancelarTarea','',0,'EXTTareaProcedimiento',0,'','', null,'',''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ106_RevisarInfoContable','','','','','',0,'Revisar y completar información contable',0,'DD',0,'','','',1,'EXTTareaProcedimiento',3,'','', null,'',''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ106_ConfirmarContabilidad','plugin/cajamar/tramiteCesionRemate/confirmarContabilidad','','','','',0,'Confirmar Contabilidad',0,'DD',0,'','tareaExterna.cancelarTarea','',0,'EXTTareaProcedimiento',0,'','', null,'','')
	);
	V_TMP_TIPO_TAP T_TIPO_TAP;    
    
    /*
    * ARRAYS TABLA3: DD_PTP_PLAZOS_TAREAS_PLAZAS
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
		T_TIPO_PLAZAS('','','CJ106_AperturaPlazo','valoresBPMPadre[''H002_SenyalamientoSubasta''] == null ? 5*24*60*60*1000L : damePlazo(valoresBPMPadre[''H002_SenyalamientoSubasta''][''fechaSenyalamiento''])+5*24*60*60*1000L',0,0,'DD'),
		T_TIPO_PLAZAS('','','CJ106_BPMTramiteAdjudicacion','300*24*60*60*1000L',0,0,'DD'),
		T_TIPO_PLAZAS('','','CJ106_RealizacionCesionRemate','damePlazo(valores[''CJ106_ResenyarFechaComparecencia''][''fecha''])',0,0,'DD'),
		T_TIPO_PLAZAS('','','CJ106_ResenyarFechaComparecencia','damePlazo(valores[''CJ106_AperturaPlazo''][''fecha''])+5*24*60*60*1000L',0,0,'DD'),
		T_TIPO_PLAZAS('','','CJ106_ConfirmarDocCompleta','damePlazo(valores[''CJ106_ResenyarFechaComparecencia''][''fecha''])-20*24*60*60*1000L',0,0,'DD'),
		T_TIPO_PLAZAS('','','CJ106_SolicitudAutYPago','damePlazo(valores[''CJ106_ResenyarFechaComparecencia''][''fecha''])-15*24*60*60*1000L',0,0,'DD'),
		T_TIPO_PLAZAS('','','CJ106_ConfirmarTransferencia','damePlazo(valores[''CJ106_ResenyarFechaComparecencia''][''fecha''])-12*24*60*60*1000L',0,0,'DD'),
		T_TIPO_PLAZAS('','','CJ106_RegistrarRecepcionPago','damePlazo(valores[''CJ106_ResenyarFechaComparecencia''][''fecha''])-10*24*60*60*1000L',0,0,'DD'),
		T_TIPO_PLAZAS('','','CJ106_BPMTramiteSaneamientoCargas','300*24*60*60*1000L',0,0,'DD'),
		T_TIPO_PLAZAS('','','CJ106_RevisarInfoContable','2*24*60*60*1000L',0,0,'DD'),
		T_TIPO_PLAZAS('','','CJ106_ConfirmarContabilidad','1*24*60*60*1000L',0,0,'DD')
	); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
        
    /*
    * ARRAYS TABLA4: TFI_TAREAS_FORM_ITEMS
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
		T_TIPO_TFI ('CJ106_AperturaPlazo',0,'label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">En caso de que la entidad haya dado instrucciones específicas para la cesión de remate, éstas aparecerán precargadas  en el campo instrucciones.</p><p style="margin-bottom: 10px;">El letrado deberá realizar la solicitud de la adjudicación con reserva de facultad de cesión de remate. En el caso de no realizarse las mismas, deberá comunicar a su gestor el motivo por el que no se considera necesario.</p><p style="margin-bottom: 10px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">Una vez rellene esta pantalla y en el caso de haber realizado las gestiones necesarias para la cesión de remate se lanzará la tarea "Registrar comparecencia", en caso contrario se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</p></div>','','','','',0,'DD'),
		T_TIPO_TFI ('CJ106_AperturaPlazo',1,'combo','comboFinaliza','Realizada solicitud con facultad de cesión de remate','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','DDSiNo',0,'DD'),
		T_TIPO_TFI ('CJ106_AperturaPlazo',2,'date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DD'),
		T_TIPO_TFI ('CJ106_AperturaPlazo',3,'textarea','instrucciones','Instrucciones','','','','',0,'DD'),
		T_TIPO_TFI ('CJ106_AperturaPlazo',4,'combo','cbCresionRemate','Cesión de remate','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','DDCesionRemateAdjudicado',0,'DD'),
		T_TIPO_TFI ('CJ106_AperturaPlazo',5,'combo','cbTitulizado','Titulizado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','DDSiNo',0,'DD'),
		T_TIPO_TFI ('CJ106_AperturaPlazo',6,'textarea','observaciones','Observaciones','','','','',0,'DD'),
		T_TIPO_TFI ('CJ106_BPMTramiteAdjudicacion',0,'label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Adjudicación.</p></div>','','','','',0,'DD'),
		T_TIPO_TFI ('CJ106_RealizacionCesionRemate',0,'label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">En esta pantalla, se deberá poner la fecha en la que se formaliza la comparecencia para la cesión del remate. Así mismo, en caso de que se trate de una operación titulizada, deberá enviar una notificación a través de Recovery al departamento de titulización.</p><p style="margin-bottom: 10px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">El siguiente paso será:</p><p style="margin-bottom: 10px;">-Si existen cargas, se lanzará el "Trámite de saneamiento de cargas".</p><p style="margin-bottom: 10px;">-Si no existen cargas, se lanzará la tarea "Revisar y completar información contable".</p><p style="margin-bottom: 10px;">-Tanto si existen cargas como si no, se lanzará el "Trámite de Adjudicación" en caso de que la cesión sea a favor de Cimenta2 o se trate de una operación titulizada.</p></div>','','','','',0,'DD'),
		T_TIPO_TFI ('CJ106_RealizacionCesionRemate',1,'date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DD'),
		T_TIPO_TFI ('CJ106_RealizacionCesionRemate',2,'textarea','observaciones','Observaciones','','','','',0,'DD'),
		T_TIPO_TFI ('CJ106_ResenyarFechaComparecencia',0,'label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">En esta pantalla, deberá informar la fecha que ha señalado el juzgado para la realización de la comparecencia en la que se formalizará la cesión de remate, así como enviar una anotación a través de la herramienta a su supervisor informándole de la misma.</p><p style="margin-bottom: 10px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">Una vez rellene esta pantalla se lanzará la tarea "Registrar realización cesión de remate" en el caso de que la cesión sea a favor de un tercero. En caso de que la cesión sea a favor de Cimenta2, se lanzará la tarea "Confirmar documentación completa".</p></div>','','','','',0,'DD'),
		T_TIPO_TFI ('CJ106_ResenyarFechaComparecencia',1,'date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DD'),
		T_TIPO_TFI ('CJ106_ResenyarFechaComparecencia',2,'textarea','observaciones','Observaciones','','','','',0,'DD'),
		T_TIPO_TFI ('CJ106_ConfirmarDocCompleta',0,'label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">A través de esta tarea, el letrado deberá confirmar que dispone de toda la documentación necesaria para tramitar la cesión de remate. En caso negativo deberá indicar qué documentación necesita.</p><p style="margin-bottom: 10px;">Una vez rellene esta pantalla la siguiente tarea será "Solicitar autorización y transferencia de pago".</p></div>','','','','',0,'DD'),
		T_TIPO_TFI ('CJ106_ConfirmarDocCompleta',1,'date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DD'),
		T_TIPO_TFI ('CJ106_ConfirmarDocCompleta',2,'combo','cbDocCompleta','Documentación completa','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','DDSiNo',0,'DD'),
		T_TIPO_TFI ('CJ106_ConfirmarDocCompleta',3,'textarea','observaciones','Observaciones','','','','',0,'DD'),
		T_TIPO_TFI ('CJ106_SolicitudAutYPago',0,'label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">Antes de dar por finalizada esta tarea deberá deberá revisar las observaciones del letrado y facilitarle la documentación requierida si fuera el caso. Además, deberá obtener la autorización del órgano competente antes de solicitar la transferencia del pago.</p><p style="margin-bottom: 10px;">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">Una vez rellene esta pantalla la siguiente tarea será "Registrar recepción transferencia de pago y emisión certificado".</p></div>','','','','',0,'DD'),
		T_TIPO_TFI ('CJ106_SolicitudAutYPago',1,'date','fecha','Fecha solicitud','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DD'),
		T_TIPO_TFI ('CJ106_SolicitudAutYPago',2,'textarea','obsLetrado','Observaciones Letrado','','','valores[''CJ106_ConfirmarDocCompleta''][''observaciones'']','DDSiNo',0,'DD'),
		T_TIPO_TFI ('CJ106_SolicitudAutYPago',3,'combo','cbAutorizado','Autorizado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','DDSiNo',0,'DD'),
		T_TIPO_TFI ('CJ106_SolicitudAutYPago',4,'combo','cbCertificado','Emisión certificado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','DDSiNo',0,'DD'),
		T_TIPO_TFI ('CJ106_SolicitudAutYPago',5,'textarea','observaciones','Observaciones','','','','',0,'DD'),
		T_TIPO_TFI ('CJ106_ConfirmarTransferencia',0,'label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">Para dar por finalizada esta tarea deberá adjuntar el resguardo de la transferencia realizada así como indicar la fecha en la que se realizó la misma.</p><p style="margin-bottom: 10px;">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">Una vez rellene esta pantalla la siguiente tarea será "Registrar recepción de pago y emisión de certificado.</p></div>','','','','',0,'DD'),
		T_TIPO_TFI ('CJ106_ConfirmarTransferencia',1,'date','fecha','Fecha transferencia','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DD'),
		T_TIPO_TFI ('CJ106_ConfirmarTransferencia',2,'textarea','observaciones','Observaciones','','','','',0,'DD'),
		T_TIPO_TFI ('CJ106_RegistrarRecepcionPago',0,'label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">Para dar por terminada esta tarea deberá indicar la fecha en la que recepciona el pago acordado en la cesión de remate así como la fecha en la que se emite el certificado de deuda, en caso de que sea necesiaria su emisión.</p><p style="margin-bottom: 10px;">Una vez haya recepcionado el pago y el certificado deberá remitirlos al procurador.</p><p style="margin-bottom: 10px;">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p>','','','','',0,'DD'),
		T_TIPO_TFI ('CJ106_RegistrarRecepcionPago',1,'date','fechaPago','Fecha recepción pago','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DD'),
		T_TIPO_TFI ('CJ106_RegistrarRecepcionPago',2,'date','fechaCert','Fecha emisión certificado','','','','',0,'DD'),
		T_TIPO_TFI ('CJ106_RegistrarRecepcionPago',3,'textarea','observaciones','Observaciones','','','','',0,'DD'),
		T_TIPO_TFI ('CJ106_BPMTramiteSaneamientoCargas',0,'label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Saneamiento de cargas.</p></div>','','','','',0,'DD'),
		T_TIPO_TFI ('CJ106_RevisarInfoContable',0,'label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">En esta pantalla deberá indicar cómo distribuye el importe cobrado en los diferentes conceptos.</p><p style="margin-bottom: 10px;">Si la operación es titulizada o si requiere  autorización, deberá solicitar autorización a la entidad para la contabilidad del bien.</p><p style="margin-bottom: 10px;"><span style="font-size: 8pt;">En el campo Fecha deberá indicar la fecha en la que realiza las gestiones.</span></p><p style="margin-bottom: 10px;">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">Una vez rellene esta pantalla, volverá a la tarea "Confirmar Contabilidad".</p></div>','','','','',1,'DD'),
		T_TIPO_TFI ('CJ106_RevisarInfoContable',1,'date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DD'),
		T_TIPO_TFI ('CJ106_RevisarInfoContable',2,'currency','nominal','Nominal','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DD'),
		T_TIPO_TFI ('CJ106_RevisarInfoContable',3,'currency','intereses','Intereses','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DD'),
		T_TIPO_TFI ('CJ106_RevisarInfoContable',4,'currency','demora','Demora','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DD'),
		T_TIPO_TFI ('CJ106_RevisarInfoContable',5,'currency','gAbogado','Gastos abogado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DD'),
		T_TIPO_TFI ('CJ106_RevisarInfoContable',6,'currency','gProcurador','Gastos procurador','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DD'),
		T_TIPO_TFI ('CJ106_RevisarInfoContable',7,'currency','gOtros','Otros gastos','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DD'),
		T_TIPO_TFI ('CJ106_RevisarInfoContable',8,'currency','aOpTramite','A op. trámite','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DD'),
		T_TIPO_TFI ('CJ106_RevisarInfoContable',9,'currency','tEntregas','Total entregas a pendiente','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DD'),
		T_TIPO_TFI ('CJ106_RevisarInfoContable',10,'combo','cbTipoEntrega','Tipo de entrega','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','DDAdjContableTipoEntrega',0,'DD'),
		T_TIPO_TFI ('CJ106_RevisarInfoContable',11,'combo','cbConcepto','Concepto de entrega','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','DDAdjContableConceptoEntrega',0,'DD'),
		T_TIPO_TFI ('CJ106_RevisarInfoContable',12,'currency','paseFallido','Pase a fallido','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DD'),
		T_TIPO_TFI ('CJ106_RevisarInfoContable',13,'currency','qNominal','Quita Nominal','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DD'),
		T_TIPO_TFI ('CJ106_RevisarInfoContable',14,'currency','qIntereses','Quita Intereses','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DD'),
		T_TIPO_TFI ('CJ106_RevisarInfoContable',15,'currency','qDemoras','Quita Demoras','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DD'),
		T_TIPO_TFI ('CJ106_RevisarInfoContable',16,'currency','tQuitasGastos','Total Quita Gastos','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DD'),
		T_TIPO_TFI ('CJ106_RevisarInfoContable',17,'textarea','observaciones','Observaciones','','','','',0,'DD'),
		T_TIPO_TFI ('CJ106_ConfirmarContabilidad',0,'label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">En esta pantalla le aperecerá preinformado el importe a contabilizar en cada uno de los diferentes conceptos de acuerdo a lo indicado por el gestor en la tarea previa.</p><p style="margin-bottom: 10px;">En este tarea debe confirmar la fecha en la que ha realizado la contabilización de la operación.</p><p style="margin-bottom: 10px;">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese procedimiento.</p></div>','','','','',0,'DD'),
		T_TIPO_TFI ('CJ106_ConfirmarContabilidad',1,'date','fecha','Fecha contabilidad','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DD'),
		T_TIPO_TFI ('CJ106_ConfirmarContabilidad',2,'currency','nominal','Nominal','','','valores[''CJ106_RevisarInfoContable''][''nominal'']','',0,'DD'),
		T_TIPO_TFI ('CJ106_ConfirmarContabilidad',3,'currency','intereses','Intereses','','','valores[''CJ106_RevisarInfoContable''][''intereses'']','',0,'DD'),
		T_TIPO_TFI ('CJ106_ConfirmarContabilidad',4,'currency','demora','Demora','','','valores[''CJ106_RevisarInfoContable''][''demora'']','',0,'DD'),
		T_TIPO_TFI ('CJ106_ConfirmarContabilidad',5,'currency','gAbogado','Gastos abogado','','','valores[''CJ106_RevisarInfoContable''][''gAbogado'']','',0,'DD'),
		T_TIPO_TFI ('CJ106_ConfirmarContabilidad',6,'currency','gProcurador','Gastos procurador','','','valores[''CJ106_RevisarInfoContable''][''gProcurador'']','',0,'DD'),
		T_TIPO_TFI ('CJ106_ConfirmarContabilidad',7,'currency','gOtros','Otros gastos','','','valores[''CJ106_RevisarInfoContable''][''gOtros'']','',0,'DD'),
		T_TIPO_TFI ('CJ106_ConfirmarContabilidad',8,'currency','aOpTramite','A op. trámite','','','valores[''CJ106_RevisarInfoContable''][''aOpTramite'']','',0,'DD'),
		T_TIPO_TFI ('CJ106_ConfirmarContabilidad',9,'currency','tEntregas','Total entregas a pendiente','','','valores[''CJ106_RevisarInfoContable''][''tEntregas'']','',0,'DD'),
		T_TIPO_TFI ('CJ106_ConfirmarContabilidad',10,'combo','cbTipoEntrega','Tipo de entrega','','','valores[''CJ106_RevisarInfoContable''][''cbTipoEntrega'']','DDAdjContableTipoEntrega',0,'DD'),
		T_TIPO_TFI ('CJ106_ConfirmarContabilidad',11,'combo','cbConcepto','Concepto de entrega','','','valores[''CJ106_RevisarInfoContable''][''cbConcepto'']','DDAdjContableConceptoEntrega',0,'DD'),
		T_TIPO_TFI ('CJ106_ConfirmarContabilidad',12,'currency','paseFallido','Pase a fallido','','','valores[''CJ106_RevisarInfoContable''][''paseFallido'']','',0,'DD'),
		T_TIPO_TFI ('CJ106_ConfirmarContabilidad',13,'currency','qNominal','Quita Nominal','','','valores[''CJ106_RevisarInfoContable''][''qNominal'']','',0,'DD'),
		T_TIPO_TFI ('CJ106_ConfirmarContabilidad',14,'currency','qIntereses','Quita Intereses','','','valores[''CJ106_RevisarInfoContable''][''qIntereses'']','',0,'DD'),
		T_TIPO_TFI ('CJ106_ConfirmarContabilidad',15,'currency','qDemoras','Quita Demoras','','','valores[''CJ106_RevisarInfoContable''][''qDemoras'']','',0,'DD'),
		T_TIPO_TFI ('CJ106_ConfirmarContabilidad',16,'currency','tQuitasGastos','Total Quita Gastos','','','valores[''CJ106_RevisarInfoContable''][''tQuitasGastos'']','',0,'DD'),
		T_TIPO_TFI ('CJ106_ConfirmarContabilidad',17,'textarea','obsContables','Observaciones contables','','','valores[''CJ106_RevisarInfoContable''][''observaciones'']','',0,'DD'),
		T_TIPO_TFI ('CJ106_ConfirmarContabilidad',18,'textarea','observaciones','Observaciones','','','','',0,'DD')
    ); --Cerrar con ")," si no es la ultima fila. Cerrar con ")" si es ultima fila
    V_TMP_TIPO_TFI T_TIPO_TFI;
BEGIN
	/*
    *---------------------------------------------------------------------------------------------------------
    *                                COMIENZO - BLOQUE DE CODIGO DEL SCRIPT
    *---------------------------------------------------------------------------------------------------------
    */
    DBMS_OUTPUT.PUT_LINE('[INICIO-SCRIPT]------------------------------------------------------- ');
    DBMS_OUTPUT.PUT_LINE('    Generacion de datos BPM: '||PAR_TIT_TRAMITE);

    /*
    * LOOP ARRAY BLOCK-CODE: DD_TPO_TIPO_PROCEDIMIENTO
    *---------------------------------------------------------------------
    */
    VAR_CURR_TABLE := PAR_TABLENAME_TPROC;
    V_CODIGO_TPO := 'DD_TPO_CODIGO';
    VAR_CURR_ROWARRAY := 0;
    DBMS_OUTPUT.PUT('    [INSERT] '||PAR_ESQUEMA||'.' || PAR_TABLENAME_TPROC || '......');
    FOR I IN V_TIPO_TPO.FIRST .. V_TIPO_TPO.LAST
      LOOP
        V_TMP_TIPO_TPO := V_TIPO_TPO(I);
        
        --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
        -- si ya existían los registros en la tabla, se informa de q existen y no se hace nada
        -----------------------------------------------------------------------------------------------------------
        DBMS_OUTPUT.PUT_LINE('[INFO] Array codigo '||V_CODIGO_TPO||' = '''||V_TMP_TIPO_TPO(1)||''' Descripcion = '''||V_TMP_TIPO_TPO(2)||'''---------------------------------'); 
        DBMS_OUTPUT.PUT('[INFO] Verificando existencia de REGISTROS de la tabla '||VAR_CURR_TABLE||', con codigo '||V_CODIGO_TPO||' = '''||V_TMP_TIPO_TPO(1)||'''...'); 

        V_SQL := 'SELECT COUNT(1) FROM '||PAR_ESQUEMA||'.'||VAR_CURR_TABLE||' WHERE '||V_CODIGO_TPO||' = '''|| V_TMP_TIPO_TPO(1) ||''' ';
        --DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('OK - YA existe');
            DBMS_OUTPUT.PUT_LINE('[INFO] NO se inserta el registro del array porque ya existe en '||VAR_CURR_TABLE);
        ELSE
            DBMS_OUTPUT.PUT_LINE('OK - NO existe');

            V_MSQL := 'INSERT INTO '|| PAR_ESQUEMA ||'.' || PAR_TABLENAME_TPROC || ' (' ||
                        'DD_TPO_ID,DD_TPO_CODIGO,DD_TPO_DESCRIPCION,DD_TPO_DESCRIPCION_LARGA,' ||
                        'DD_TPO_HTML,DD_TPO_XML_JBPM,VERSION,USUARIOCREAR,' ||
                        'FECHACREAR,BORRADO,DD_TAC_ID,DD_TPO_SALDO_MIN,'||
                        'DD_TPO_SALDO_MAX,FLAG_PRORROGA,DTYPE,FLAG_DERIVABLE,FLAG_UNICO_BIEN) ' ||
                        'SELECT ' ||
                        'S_DD_TPO_TIPO_PROCEDIMIENTO.NEXTVAL, ' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(1)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TPO(2)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(3)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TPO(4)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(5)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TPO(6)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(7)),'''','''''') || ''',
                             sysdate,' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(8)),'''','''''') || ''',' ||
                             '(SELECT DD_TAC_ID FROM '|| PAR_ESQUEMA ||'.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO=''' || TRIM(V_TMP_TIPO_TPO(9)) || '''),' ||
                        '''' || TRIM(V_TMP_TIPO_TPO(10)) || ''',''' 
                             || TRIM(V_TMP_TIPO_TPO(11)) || ''',''' 
                             || TRIM(V_TMP_TIPO_TPO(12)) || ''',' ||
                        '''' || TRIM(V_TMP_TIPO_TPO(13)) || ''',''' 
                             || TRIM(V_TMP_TIPO_TPO(14)) || ''',''' 
                             || TRIM(V_TMP_TIPO_TPO(15)) 
                        || ''' FROM DUAL'; 

                VAR_CURR_ROWARRAY := I;
                --DBMS_OUTPUT.PUT_LINE(V_MSQL);
                --DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TPO(1) ||''','''||TRIM(V_TMP_TIPO_TPO(2))||'''');
                EXECUTE IMMEDIATE V_MSQL;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('['||VAR_CURR_ROWARRAY||' filas-OK]');


    /*
    * LOOP ARRAY BLOCK-CODE: TAP_TAREA_PROCEDIMIENTO
    *---------------------------------------------------------------------
    */
    VAR_CURR_TABLE := PAR_TABLENAME_TARPR;
    V_CODIGO_TAP := 'TAP_CODIGO';
    VAR_CURR_ROWARRAY := 0;
    DBMS_OUTPUT.PUT('    [INSERT] '||PAR_ESQUEMA||'.' || PAR_TABLENAME_TARPR || '........');
    FOR I IN V_TIPO_TAP.FIRST .. V_TIPO_TAP.LAST
      LOOP
        V_TMP_TIPO_TAP := V_TIPO_TAP(I);

        --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
        -- si ya existían los registros en la tabla, se informa de q existen y no se hace nada
        -----------------------------------------------------------------------------------------------------------
        DBMS_OUTPUT.PUT_LINE('[INFO] Array codigo '||V_CODIGO_TAP||' = '''||V_TMP_TIPO_TAP(2)||''' Descripcion = '''||V_TMP_TIPO_TAP(9)||'''---------------------------------'); 
        DBMS_OUTPUT.PUT('[INFO] Verificando existencia de REGISTROS de la tabla '||VAR_CURR_TABLE||', con codigo '||V_CODIGO_TAP||' = '''||V_TMP_TIPO_TAP(2)||'''...'); 

        V_SQL := 'SELECT COUNT(1) FROM '||PAR_ESQUEMA||'.'||VAR_CURR_TABLE||' WHERE '||V_CODIGO_TAP||' = '''|| V_TMP_TIPO_TAP(2) ||''' ';
        --DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('OK - YA existe');
            DBMS_OUTPUT.PUT_LINE('[INFO] NO se inserta el registro del array porque ya existe en '||VAR_CURR_TABLE);
        ELSE
            DBMS_OUTPUT.PUT_LINE('OK - NO existe');

            V_MSQL := 'INSERT INTO '|| PAR_ESQUEMA ||'.' || PAR_TABLENAME_TARPR || ' (' ||
                        'TAP_ID,DD_TPO_ID,TAP_CODIGO,TAP_VIEW,TAP_SCRIPT_VALIDACION,TAP_SCRIPT_VALIDACION_JBPM,TAP_SCRIPT_DECISION,DD_TPO_ID_BPM,' ||
                        'TAP_SUPERVISOR,TAP_DESCRIPCION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,TAP_ALERT_NO_RETORNO,TAP_ALERT_VUELTA_ATRAS,DD_FAP_ID,' ||
                        'TAP_AUTOPRORROGA,DTYPE,TAP_MAX_AUTOP,DD_TGE_ID,DD_STA_ID,TAP_EVITAR_REORG,DD_TSUP_ID,TAP_BUCLE_BPM) ' ||
                        'SELECT ' ||
                        'S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL, ' ||
                        '(SELECT DD_TPO_ID FROM ' || PAR_ESQUEMA || '.' || PAR_TABLENAME_TPROC || ' WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(1)),'''','''''')  || '''),' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(2)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(3)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(4)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(5)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(6)),'''','''''') || ''',' || 
                        '(SELECT DD_TPO_ID FROM ' || PAR_ESQUEMA || '.' || PAR_TABLENAME_TPROC || ' WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(7)),'''','''''') || '''),' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(8)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(9)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(10)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(11)),'''','''''') || ''',' ||
                        'sysdate,''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(12)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(13)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(14)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(15)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(16)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(17)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(18)),'''','''''') || ''',' ||
                        '(SELECT DD_TGE_ID FROM ' || PAR_ESQUEMA || '.DD_TGE_TIPO_GESTION WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(19)) || '''),' || 
                        '(SELECT DD_STA_ID FROM ' || PAR_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' || 
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(21)),'''','''''') || ''',' 
                             ||'(select dd_tge_id from ' || PAR_ESQUEMA_MASTER || '.dd_tge_tipo_gestor where dd_tge_codigo='''|| REPLACE(TRIM(V_TMP_TIPO_TAP(22)),'''','''''') || '''),''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(23)),'''','''''') 
                        || ''' FROM DUAL';

                VAR_CURR_ROWARRAY := I;
                --DBMS_OUTPUT.PUT_LINE(V_MSQL);
                --DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TAP(2)||''','''||TRIM(V_TMP_TIPO_TAP(9))||'''');
                EXECUTE IMMEDIATE V_MSQL;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('['||VAR_CURR_ROWARRAY||' filas-OK]');



    /*
    * LOOP ARRAY BLOCK-CODE: DD_PTP_PLAZOS_TAREAS_PLAZAS
    *---------------------------------------------------------------------
    */
    VAR_CURR_TABLE := PAR_TABLENAME_TPLAZ;
    V_CODIGO_PLAZAS := 'TAP_CODIGO';
    VAR_CURR_ROWARRAY := 0;
    DBMS_OUTPUT.PUT('    [INSERT] '||PAR_ESQUEMA||'.' || PAR_TABLENAME_TPLAZ || '....');
    FOR I IN V_TIPO_PLAZAS.FIRST .. V_TIPO_PLAZAS.LAST
      LOOP
        V_TMP_TIPO_PLAZAS := V_TIPO_PLAZAS(I);

        --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
        -- si ya existían los registros en la tabla, se informa de q existen y no se hace nada
        -----------------------------------------------------------------------------------------------------------
        DBMS_OUTPUT.PUT_LINE('[INFO] Array codigo '||V_CODIGO_PLAZAS||' = '''||V_TMP_TIPO_PLAZAS(3)||''' Descripcion = '''||V_TMP_TIPO_PLAZAS(4)||'''---------------------------------'); 
        DBMS_OUTPUT.PUT('[INFO] Verificando existencia de REGISTROS de la tabla '||VAR_CURR_TABLE||', con codigo '||V_CODIGO_PLAZAS||' = '''||V_TMP_TIPO_PLAZAS(3)||'''...'); 

        V_SQL := 'SELECT COUNT(1) FROM '||PAR_ESQUEMA||'.'||VAR_CURR_TABLE||' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''|| V_TMP_TIPO_PLAZAS(3) ||''') ';
        --DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('OK - YA existe');
            DBMS_OUTPUT.PUT_LINE('[INFO] NO se inserta el registro del array porque ya existe en '||VAR_CURR_TABLE);
        ELSE
            DBMS_OUTPUT.PUT_LINE('OK - NO existe');

            V_MSQL := 'INSERT INTO '|| PAR_ESQUEMA ||'.' || PAR_TABLENAME_TPLAZ || 
                        '(DD_PTP_ID,DD_JUZ_ID,DD_PLA_ID,TAP_ID,DD_PTP_PLAZO_SCRIPT,VERSION,BORRADO,USUARIOCREAR,FECHACREAR)' ||
                        'SELECT ' ||
                        'S_DD_PTP_PLAZOS_TAREAS_PLAZAS.NEXTVAL, ' ||
                        '(SELECT DD_JUZ_ID FROM ' || PAR_ESQUEMA || '.DD_JUZ_JUZGADOS_PLAZA WHERE DD_JUZ_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(1)) || '''), ' ||
                        '(SELECT DD_PLA_ID FROM ' || PAR_ESQUEMA || '.DD_PLA_PLAZAS WHERE DD_PLA_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(2)) || '''), ' ||
                        '(SELECT TAP_ID FROM ' || PAR_ESQUEMA || '.' || PAR_TABLENAME_TARPR || ' WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(3)) || '''), ' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(4)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(5)),'''','''''') || ''','   ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(6)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(7)),'''','''''') || 
                        ''', sysdate FROM DUAL'; 

                VAR_CURR_ROWARRAY := I;
                --DBMS_OUTPUT.PUT_LINE(V_MSQL);
                --DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_PLAZAS(3) ||''','''||TRIM(V_TMP_TIPO_PLAZAS(4))||'''');
                EXECUTE IMMEDIATE V_MSQL;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('['||VAR_CURR_ROWARRAY||' filas-OK]');



    /*
    * LOOP ARRAY BLOCK-CODE: TFI_TAREAS_FORM_ITEMS
    *---------------------------------------------------------------------
    */
    VAR_CURR_TABLE := PAR_TABLENAME_TFITE;
    V_CODIGO1_TFI := 'TAP_CODIGO';
    V_CODIGO2_TFI := 'TFI_NOMBRE';
    VAR_CURR_ROWARRAY := 0;
    DBMS_OUTPUT.PUT('    [INSERT] '||PAR_ESQUEMA||'.' || PAR_TABLENAME_TFITE || '..........');
    FOR I IN V_TIPO_TFI.FIRST .. V_TIPO_TFI.LAST
      LOOP
        V_TMP_TIPO_TFI := V_TIPO_TFI(I);

        --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
        -- si ya existían los registros en la tabla, se informa de q existen y no se hace nada
        -----------------------------------------------------------------------------------------------------------
        DBMS_OUTPUT.PUT_LINE('[INFO] Array codigos '||V_CODIGO1_TFI||' = '''||V_TMP_TIPO_TFI(1)||''', '||V_CODIGO2_TFI||' = '''||V_TMP_TIPO_TFI(4)||''' Descripcion = '''||V_TMP_TIPO_TFI(5)||'''---------------------------------'); 
        DBMS_OUTPUT.PUT('[INFO] Verificando existencia de REGISTROS de la tabla '||VAR_CURR_TABLE||', con codigo '||V_CODIGO1_TFI||' = '''||V_TMP_TIPO_TFI(1)||''', '||V_CODIGO2_TFI||' = '''||V_TMP_TIPO_TFI(4)||'''...'); 

        V_SQL := 'SELECT COUNT(1) FROM '||PAR_ESQUEMA||'.'||VAR_CURR_TABLE||' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE '||V_CODIGO1_TFI||' = '''||V_TMP_TIPO_TFI(1)||''') AND '||V_CODIGO2_TFI||' = '''||V_TMP_TIPO_TFI(4)||''' ';
        --DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('OK - YA existe');
            DBMS_OUTPUT.PUT_LINE('[INFO] NO se inserta el registro del array porque ya existe en '||VAR_CURR_TABLE);
        ELSE
            DBMS_OUTPUT.PUT_LINE('OK - NO existe');

            V_MSQL := 'INSERT INTO '|| PAR_ESQUEMA ||'.' || PAR_TABLENAME_TFITE || 
                        '(TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)' ||
                        'SELECT ' ||
                        'S_TFI_TAREAS_FORM_ITEMS.NEXTVAL, ' ||
                        '(SELECT TAP_ID FROM ' || PAR_ESQUEMA || '.' || PAR_TABLENAME_TARPR || ' WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_TFI(1)) || '''), ' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(2)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TFI(3)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(4)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TFI(5)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(6)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TFI(7)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(8)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TFI(9)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(10)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TFI(11)),'''','''''') || 
                        ''',sysdate,0 FROM DUAL';

                VAR_CURR_ROWARRAY := I;
                --DBMS_OUTPUT.PUT_LINE(V_MSQL);
                --DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TFI(1) ||''','''||TRIM(V_TMP_TIPO_TFI(4))||'''');
                EXECUTE IMMEDIATE V_MSQL;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('['||VAR_CURR_ROWARRAY||' filas-OK]');
    
    /*
	 * ---------------------------------------------------------------------------------------------------------
	 * 								ACTUALIZACIONES
	 * ---------------------------------------------------------------------------------------------------------
	 */
	EXECUTE IMMEDIATE 'UPDATE TAP_TAREA_PROCEDIMIENTO SET DD_TPO_ID_BPM = (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO=''' || V_COD_PROCEDIMIENTO || ''') WHERE TAP_CODIGO = ''H025_BPMTramiteCostas''';
	
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

    /*
    *---------------------------------------------------------------------------------------------------------
    *                                   TRATAMIENTO DE EXCEPCIONES
    *---------------------------------------------------------------------------------------------------------
    */
    WHEN OTHERS THEN
        /*
        * EXCEPTION: WHATEVER ERROR
        *---------------------------------------------------------------------
        */     
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT('[KO]');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          IF (ERR_NUM = -1427 OR ERR_NUM = -1) THEN
            DBMS_OUTPUT.put_line('[INFO] Ya existen los registros de este script insertados en la tabla '||VAR_CURR_TABLE
                              ||'. Encontrada fila num '||VAR_CURR_ROWARRAY||' de su array.');
            DBMS_OUTPUT.put_line('[INFO] Ejecute el script de limpieza del tramite '||PAR_TIT_TRAMITE||' y vuelva a ejecutar.');
          END IF;
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line('SQL que ha fallado:');
          DBMS_OUTPUT.put_line(V_MSQL);
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('[ROLLBACK ALL].............................................');
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line('Contacto incidencia.....: '||PAR_AUTHOR);
          DBMS_OUTPUT.put_line('Email...................: '||PAR_AUTHOR_EMAIL);
          DBMS_OUTPUT.put_line('Telf....................: '||PAR_AUTHOR_TELF);
          DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]-----------------------------------------------------------');                    
          RAISE;
END;          
/ 
EXIT;
