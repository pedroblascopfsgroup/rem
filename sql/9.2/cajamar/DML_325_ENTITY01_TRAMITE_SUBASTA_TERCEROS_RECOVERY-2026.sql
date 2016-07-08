/*
--##########################################
--## AUTOR=SERGIO NIETO
--## FECHA_CREACION=20160706
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.7
--## INCIDENCIA_LINK=RECOVERY-2026
--## PRODUCTO=NO
--##
--## Finalidad: BPM - Tramite subasta terceros
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
		T_TIPO_TAP('CJ070','CJ070_SenyalamientoSubasta' ,null ,'comprobarMinimoBienLote() ? (existeAdjuntoUG("ESRAS","PRC") ? null : existeAdjuntoUGMensaje("ESRAS","PRC")) : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Al menos un bien debe estar asignado a un lote</div>''' ,null ,null ,null ,'0','Comunicación con señalamiento de subasta' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ070','CJ070_ValidarInformeDeSubastaPrepararCuadroDePujas' ,'plugin/procedimientos-cajamar-plugin/tramiteSubastaTerceros/validarInformeSubasta',null ,'(valores[''CJ070_ValidarInformeDeSubastaYPrepararCuadroDePujas''][''comboNotaSimple''] == DDSiNo.SI ? (comprobarExisteDocumentoNOSI() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento Nota Simple</div>'' ) : null)' ,'( valores[''CJ070_ValidarInformeDeSubastaYPrepararCuadroDePujas''][''comboRequerida''] == DDSiNo.NO ? (valores[''CJ070_ValidarInformeDeSubastaYPrepararCuadroDePujas''][''comboConsignacion''] == DDSiNo.NO ? ''Fin'' : ''TramiteConsignacion'') : (valores[''CJ070_ValidarInformeDeSubastaYPrepararCuadroDePujas''][''comboConsignacion''] == DDSiNo.NO ? ''SolicitarDueDiligence'' : ''DueDiligenceYTramiteConsignacion''))' ,null ,'0','Validar informe de subasta y preparar cuadro de pujas' ,'0','RECOVERY-2026','1' ,null ,'tareaExterna.cancelarTarea' ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ070','CJ070_ContactarConDeudorPrepararInformeSubastaFisc' ,null ,'comprobarExisteDocumentoINS() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento Informe de subasta al procedimiento.</div>''' ,null ,null ,null ,'0','Preparar informe subasta/fiscal' ,'0','RECOVERY-2026','1' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ070','CJ070_PrepararInformeSubasta' ,null ,'comprobarInformacionCompletaInstrucciones() ? (comprobarExisteDocumentoINS()? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el informe de subasta</div>'') : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">La informaci&oacute;n de las instrucciones de los lotes no est&aacute; completa.</div>'' ' ,null ,null ,null ,'0','Preparar informe de subasta' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ070','CJ070_LecturaConfirmacionInstrucciones' ,null ,null ,null ,null ,null ,'0','Lectura y confirmación de instrucciones' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null,null,null ,null,null),
		T_TIPO_TAP('CJ070','CJ070_CelebracionSubasta' ,'plugin/procedimientos-cajamar-plugin/tramiteSubastaTerceros/celebracionSubastaV4' ,null ,'valores[''CJ070_CelebracionSubasta''][''comboCelebrada''] == DDSiNo.NO ? (valores[''CJ070_CelebracionSubasta''][''comboDecisionSuspension''] == null ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">El campo Decisi&oacute;n suspensi&oacute;n es obligatorio</div>'' : null) : (comprobarExisteDocumentoACS() ? (validarBienesDocCelebracionSubasta() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe rellenar en cada bien los datos de adjudicaci&oacute;n o de cesi&oacute;n remate</div>'') : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento Acta de subasta</div>'')' ,null ,null ,'0','Celebración de subasta' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ070','CJ070_SolicitarMandamientoPago' ,null ,null ,null ,null ,null ,'0','Solicitar mandamiento de pago' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ070','CJ070_ConfirmarRecepcionMandamientoDePago' ,null ,'comprobarExisteDocumentoMP() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el Mandamiento de Pago</div>''' ,null ,null ,null,'0','Confirmar recepción y envio de mandamiento de pago' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ070','CJ070_BPMTramiteCesionRemate' ,null ,null ,null ,null ,'CJ068' ,'0','Llamada al Trámite de Cesión de Remate' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ070','CJ070_BPMTramiteAdjudicacion' ,null ,null ,null ,null ,'CJ067' ,'0','Llamada al Trámite de Adjudicación' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ070','CJ070_CelebracionDecision' ,null ,null ,null ,null ,null ,'0','Tarea toma de decisión' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ070','CJ070_RevisarDocumentacion' ,null ,null ,null ,null ,null ,'0','Revisar documentación' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ070','CJ070_AdjuntarNotasSimples' ,null ,null ,null ,null ,null ,'0','Adjuntar notas simples' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ070','CJ070_AdjuntarTasaciones' ,null ,null ,null ,'valores[''CJ070_AdjuntarTasaciones''][''comboInforme''] == DDSiNo.SI ?  ''SI'' : ''NO''' ,null ,'0','Adjuntar tasaciones' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ070','CJ070_SolicitarInformeFiscal' ,null ,null ,null ,null ,null ,'0','Solicitar informe fiscal' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ070','CJ070_AdjuntarInformeFiscal' ,null ,'comprobarExisteDocumentoIFISCAL() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el Informe Fiscal.</div>''' ,null ,null ,null ,'0','Adjuntar informe fiscal' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ070','CJ070_ValidarInformeDeSubasta' ,'plugin/procedimientos-cajamar-plugin/tramiteSubastaTerceros/validarInformeSubastaCajamar' ,'comprobarExisteDocumentoINSUFI() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el Informe Subasta Firmado.</div>''' ,null ,'valores[''CJ070_ValidarInformeDeSubasta''][''comboInforme''] == DDSiNo.NO ? ''Rechazado'' : (valores[''CJ070_ValidarInformeDeSubasta''][''comboAtribuciones''] == DDSiNo.NO ? ''AceptadoSinAtribuciones'' :''AceptadoConAtribuciones'')' ,null ,'0','Validar informe de subasta' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ070','CJ070_ObtenerValidacionComite' ,null ,null ,null ,'valores[''CJ070_ObtenerValidacionComite''][''comboResultado''] == ''REC'' ? ''Rechazada'' : ''Aceptada''' ,null ,'0','Obtener validación comité' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ070','CJ070_DictarInstruccionesSubasta' ,null ,'comprobarInformacionCompletaInstrucciones() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">La informaci&oacute;n de las instrucciones de los lotes no est&aacute; completa.</div>''' ,null ,'valores[''CJ070_DictarInstruccionesSubasta''][''comboSuspender''] == DDSiNo.SI ? ''Suspender'' : ''NoSuspender'' ' ,null ,'0','Dictar instrucciones' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ070','CJ070_SolicitarSuspenderSubasta' ,null ,'comprobarExisteDocumento(''ESCSUS'') ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento "Escrito de suspensi&oacute;n"</div>''' ,null ,null ,null ,'0','Solicitar suspender subasta' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ070','CJ070_RegistrarResSuspSubasta' ,null ,null ,null ,null ,null ,'0','Registrar resolución suspensión subasta' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ070','CJ070_BPMTramiteSolSolvenciaPatrimonial' ,null ,null ,null ,null ,null ,'0','Ejecución del trámite de Solicitud de Solvencia Patrimonial' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ070','CJ070_RecepcionMandamientoPago' ,null ,null ,null ,'esTodosViviendaHabitualAdjTerceros() ? ''ViviendaHabitual'' : (valores[''CJ070_RecepcionMandamientoPago''][''comboDeuda''] == DDSiNo.SI ? ''DeudaCubierta'' : ''DeudaNoCubierta'' )' ,null ,'0','Recepción mandamiento de pago' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ070','CJ070_ConfirmarContabilidad' ,null ,null ,null ,null ,null ,'0','Confirmar contabilidad' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ070','CJ070_SuspenderDecision' ,null ,null ,null ,null ,null ,'0','Tarea toma de decisión' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null)
    );
	V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
		T_TIPO_PLAZAS(null ,null ,'CJ070_SenyalamientoSubasta','1*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ070_PrepararInformeSubasta','damePlazo(valores[''CJ070_SenyalamientoSubasta''][''fechaSenyalamiento''])-15*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ070_LecturaConfirmacionInstrucciones','damePlazo(valores[''CJ070_SenyalamientoSubasta''][''fechaSenyalamiento''])-3*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ070_CelebracionSubasta','damePlazo(valores[''CJ070_SenyalamientoSubasta''][''fechaSenyalamiento''])' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ070_SolicitarMandamientoPago','damePlazo(valores[''CJ070_SenyalamientoSubasta''][''fechaSenyalamiento''])+20*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ070_ConfirmarRecepcionMandamientoDePago','damePlazo(valores[''CJ070_SolicitarMandamientoPago''][''fecha''])+10*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ070_BPMTramiteCesionRemate','300*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ070_BPMTramiteAdjudicacion','300*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ070_RevisarDocumentacion','damePlazo(valores[''CJ070_SenyalamientoSubasta''][''fechaSenyalamiento'']) - 45*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ070_AdjuntarNotasSimples','damePlazo(valores[''CJ070_SenyalamientoSubasta''][''fechaSenyalamiento'']) - 20*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ070_AdjuntarTasaciones','damePlazo(valores[''CJ070_SenyalamientoSubasta''][''fechaSenyalamiento'']) - 30*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ070_SolicitarInformeFiscal','damePlazo(valores[''CJ070_SenyalamientoSubasta''][''fechaSenyalamiento'']) - 25*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ070_AdjuntarInformeFiscal','damePlazo(valores[''CJ070_SenyalamientoSubasta''][''fechaSenyalamiento'']) - 20*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ070_ValidarInformeDeSubasta','damePlazo(valores[''CJ070_SenyalamientoSubasta''][''fechaSenyalamiento'']) - 10*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ070_ObtenerValidacionComite','7*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ070_DictarInstruccionesSubasta','3*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ070_SolicitarSuspenderSubasta','1*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ070_RegistrarResSuspSubasta','damePlazo(valores[''CJ070_SenyalamientoSubasta''][''fechaSenyalamiento'']) - 1*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ070_BPMTramiteSolSolvenciaPatrimonial','300*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ070_RecepcionMandamientoPago','damePlazo(valores[''CJ070_ConfirmarRecepcionMandamientoDePago''][''fechaEnvio'']) + 10*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ070_ConfirmarContabilidad','5*24*60*60*1000L' ,'0','0','RECOVERY-2026')
    ); 
	V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
		T_TIPO_TFI('CJ070_SenyalamientoSubasta','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Una vez comunicada la subasta, en esta pantalla, debe informar de la fecha de notificación y de la fecha de celebración de la subasta e indicar el letrado asignado a esta subasta y el procurador si procede.</p><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deberá acceder a la pestaña Subastas del asunto correspondiente y asociar uno o mas bienes a la subasta que corresponda. Una vez agregados los bienes a la subasta, deberá indicar a través de la ficha del bien las cargas anteriores y posteriores, si es vivienda habitual o no y la situación posesoria.</p><p style="margin-bottom: 10px">Una vez conozca la fecha de celebración de la subasta deberán enviar una anotación a través de la herramienta al supervisor de contencioso gestión.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene ésta pantalla se lanzarán las siguientes tareas:</p><p style="margin-bottom: 10px">-"Celebración subasta".</p><p style="margin-bottom: 10px">-"Revisar documentación”.</p></div>' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_SenyalamientoSubasta','1','date' ,'fechaAnuncio','Fecha notificación subasta' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_SenyalamientoSubasta','2','date' ,'fechaSenyalamiento','Fecha Celebración' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_SenyalamientoSubasta','3','textproc' ,'numAuto','Nº Auto' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,'dameNumAuto()' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_SenyalamientoSubasta','4','textarea' ,'solicitante','Solicitante' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_SenyalamientoSubasta','5','textarea' ,'letradoYOProcurador','Indicar el letrado y/o procurador' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_SenyalamientoSubasta','6','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_PrepararInformeSubasta','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deber&aacute; acceder desde la pesta&ntilde;a Subastas del asunto correspondiente a cada uno de los bienes afectos a la subasta e indicar los importes para la puja sin postores  y puja con postores.</p><p style="margin-bottom: 10px">Adem&aacute;s, deber&aacute; adjuntar el informe de subasta, preparar el cuadro de pujas y obtener la tasaci&oacute;n, notas simple e informe fiscal, en caso de que las solicitara en la tarea anterior, as&iacute; como actualizar dicha informaci&oacute;n en la herramienta.</p><p style="margin-bottom: 10px">Una vez hecho esto podr&aacute; generar desde la pesta&ntilde;a Subastas el informe con la propuesta de instrucciones para la subasta en formato Word, de forma que en caso de ser necesario pueda modificarlo.</p><p style="margin-bottom: 10px">En el campo Fecha deber&aacute; informar la fecha en la que haya adjuntado el informe con las instrucciones para la subasta.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea “Validar informe de subasta”.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_PrepararInformeSubasta','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_PrepararInformeSubasta','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_LecturaConfirmacionInstrucciones','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Una vez que ha sido anunciada la subasta, y han sido dictadas las instrucciones por la entidad, antes de dar por completada esta tarea deberá acceder a la pesta&ntilde;a "Subastas" de la ficha del asunto correspondiente y revisar las instrucciones dadas para cada uno de los bienes a subastar.</p><p style="margin-bottom: 10px">Informando la fecha se confirma haber recibido correctamente las instrucciones del responsable de la entidad, así como la aceptaci&oacute;n de las mismas. Para el supuesto de que haya alguna duda al respecto, deberá ponerse en contacto con el responsable de la entidad para que se revisen o modifiquen dichas instrucciones.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_LecturaConfirmacionInstrucciones','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_LecturaConfirmacionInstrucciones','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_CelebracionSubasta','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez se celebre la subasta, en esta pantalla debe introducir la siguiente informaci&oacute;n:</p><p style="margin-bottom: 10px; margin-left: 40px;">-En el campo Celebrada deber&aacute; indicar si la subasta ha sido celebrada o no.</p><p style="margin-bottom: 10px; margin-left: 40px;">-En caso de haberse celebrado deber&aacute; indicar a trav&eacute;s de la pesta&ntilde;a Subastas de la ficha del asunto correspondiente, el resultado de la subasta para cada uno de los bienes subastados.</p><p style="margin-bottom: 10px; margin-left: 40px;">-En la ficha del bien se debe recoger el resultado de la adjudicaci&oacute;n y el valor de la adjudicaci&oacute;n.</p><p style="margin-bottom: 10px; margin-left: 40px;">-En el campo Observaciones informar cualquier aspecto relevante que le  interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; adjuntar el acta de subasta al procedimiento a trav&eacute;s de la pesta&ntilde;a "Adjuntos" y anotar la situaci&oacute;n final de cada bien en la ficha del bien.</p><p style="margin-bottom: 10px">La siguiente tarea ser&aacute;:</p><p style="margin-bottom: 10px; margin-left: 40px;">-En caso de haber uno o m&aacute;s bienes adjudicados a un tercero se lanzar&aacute; la tarea “Solicitar mandamiento de pago”.</p><p style="margin-bottom: 10px; margin-left: 40px;">-En caso de haber uno o m&aacute;s bienes con cesi&oacute;n de remate se lanzar&aacute; la tarea "Tr&aacute;mite de Cesi&oacute;n de Remate" por cada uno de ellos.</p><p style="margin-bottom: 10px; margin-left: 40px;">-En caso de haber uno o m&aacute;s bienes adjudicados a la entidad, se lanzar&aacute;  el "Tr&aacute;mite de Adjudicaci&oacute;n" por cada uno de ellos.</p><p style="margin-bottom: 10px; margin-left: 40px;">-En caso de suspensi&oacute;n de la subasta deber&aacute;'||
		'indicar dicha circunstancia en el campo “Celebrada”, en el campo “Decisi&oacute;n suspensi&oacute;n” deber&aacute; informar quien ha provocado dicha suspensi&oacute;n y en el campo “Motivo suspensi&oacute;n” deber&aacute; indicar el motivo por el cual se ha suspendido y se le abrir&aacute; tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p><p style="margin-bottom: 10px; margin-left: 40px;">-En caso de que alg&uacute;n bien haya sido adjudicado a la entidad o con cesi&oacute;n de remate, se lanzar&aacute; el "Tr&aacute;mite de solvencia patrimonial" para averiguar la solvencia del deudor.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_CelebracionSubasta','1','combo' ,'comboCelebrada','Celebrada' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_CelebracionSubasta','2','combo' ,'comboPostores','Con postores' ,null ,null ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_CelebracionSubasta','3','combo' ,'comboDecisionSuspension','Decisi&oacute;n suspensi&oacute;n' ,null ,null ,null ,'DDDecisionSuspension','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_CelebracionSubasta','4','combo' ,'comboMotivoSuspension','Motivo suspensión' ,null ,null ,null ,'DDMotivoSuspSubasta','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_CelebracionSubasta','5','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_SolicitarMandamientoPago','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que alguno de los bienes ha sido adjudicado a un tercero, en esta pantalla debemos de informar la fecha de presentaci&oacute;n en el juzgado del escrito solicitando la entrega de las cantidades informadas.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Confirmar recepci&oacute;n mandamiento de pago".</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_SolicitarMandamientoPago','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_SolicitarMandamientoPago','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_ConfirmarRecepcionMandamientoDePago','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se ha de informar la fecha y el importe en la que nos han entregado los mandamientos de pago de la cantidad informada por un tercero en concepto de pago del bien o bienes adjudicados, as&iacute; como la fecha de env&iacute;o a HRE para su contabilizaci&oacute;n.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">La siguiente tarea ser&aacute; "Recepci&oacute;n de mandamiento de pago".</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_ConfirmarRecepcionMandamientoDePago','1','date' ,'fecha','Fecha recepción' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_ConfirmarRecepcionMandamientoDePago','2','date' ,'fechaEnvio','Fecha envío' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_ConfirmarRecepcionMandamientoDePago','3','currency' ,'importe','Importe' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_ConfirmarRecepcionMandamientoDePago','4','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_BPMTramiteCesionRemate','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Ejecuci&oacute;n del tr&aacute;mite de Cesi&oacute;n de remate</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_BPMTramiteAdjudicacion','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Ejecuci&oacute;n del tr&aacute;mite de Adjudicaci&oacute;n</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_RevisarDocumentacion','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea deber&aacute; revisar:</p><p style="margin-bottom: 10px; margin-left: 40px;">-Si todos los bienes incluidos en la Subasta han de ser efectivamente subastados o, por el contrario, excluya manualmente los que no deban ser subastados</p><p style="margin-bottom: 10px; margin-left: 40px;">-La antigüedad de la certificaci&oacute;n de cargas de cada uno de los bienes en la ficha del bien. En caso de que tengan una antigüedad superior a 3 meses, solicite las notas simples actualizadas.</p><p style="margin-bottom: 10px; margin-left: 40px;">-La antigüedad de la de la tasaci&oacute;n de cada uno de los bienes. En caso de que sea superior a 6 meses solicite una nueva tasaci&oacute;n a trav&eacute;s de la ficha del bien.</p><p style="margin-bottom: 10px; margin-left: 40px;">-Si es necesario el informe fiscal en cuyo caso deber&aacute; solicitarlo a la entidad una vez tenga las tasaciones actualizadas.</p><p style="margin-bottom: 10px">Una vez determine qu&eacute; documentaci&oacute;n necesita deber&aacute; ponerse en contacto con el departamento correspondiente para solicitarla y dejar constancia en Recovery.</p><p style="margin-bottom: 10px">En el campo Fecha deber&aacute; se&ntilde;alar la fecha en la que hace esta revisi&oacute;n.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea "Preparar informe de subasta" y:</p><p style="margin-bottom: 10px; margin-left: 40px;">-Si ha indicado que solicita tasaci&oacute;n, se lanzar&aacute; la tarea "Adjutar tasaciones".</p><p style="margin-bottom: 10px; margin-left: 40px;">-Si ha indicado que solicita tasaci&oacute;n, se lanzar&aacute; la tarea "Adjuntar nota simple".</p><p style="margin-bottom: 10px; margin-left: 40px;">-'||
		'Si no ha solicitado tasaciones y ha indicado que va a solictar el informe fiscal, se lanzar&aacute; la tarea "Adjuntar informe fiscal".</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_RevisarDocumentacion','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_RevisarDocumentacion','2','combo' ,'comboNota','Solicita nota simple' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_RevisarDocumentacion','3','combo' ,'comboTasacion','Solicita tasación' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_RevisarDocumentacion','4','combo' ,'comboInforme','Solicita informe fiscal' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_RevisarDocumentacion','5','textarea' ,'observaciones','Observaciones',null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_AdjuntarNotasSimples','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; actualizar la informaci&oacute;n en la ficha del "Bien"  de cada uno de los bienes de la subasta.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>' ,null,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_AdjuntarNotasSimples','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_AdjuntarNotasSimples','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_AdjuntarTasaciones','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; actualizar la informaci&oacute;n en la ficha del "Bien"  de cada uno de los bienes de la subasta.</p><p style="margin-bottom: 10px">En caso de que requiera solicitar el informe fiscal, deber&aacute; dejar constancia de ello en la herramienta y ponerse en contacto con el &aacute;rea Fiscal para que generen el informe.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellena esta pantalla, la siguiente tarea ser&aacute;, si ha marcado que solicita el informe fiscal, "Solicitar informe fiscal".</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_AdjuntarTasaciones','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_AdjuntarTasaciones','2','combo' ,'comboInforme','Solicita informe fiscal' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,'valores[''CJ070_RevisarDocumentacion''][''comboInforme'']' ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_AdjuntarTasaciones','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_SolicitarInformeFiscal','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; solicitar el informe fiscal a la entidad y dejar constancia en la herramieenta de la fecha en la que ha realizado dicha solicitud.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla, la siguiente tarea ser&aacute; "adjuntar informe fiscal".</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_SolicitarInformeFiscal','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_SolicitarInformeFiscal','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_AdjuntarInformeFiscal','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; actualizar la informaci&oacute;n en la ficha del "Bien"  de cada uno de los bienes de la subasta y adjuntar el informe fiscal al procedimiento.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_AdjuntarInformeFiscal','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_AdjuntarInformeFiscal','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_ValidarInformeDeSubasta','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea deber&aacute; revisar y dictaminar sobre la propuesta de instrucciones. En caso de que tenga atribuciones y la deuda judicial calculada sea superior a 500mil euros deber&aacute; informar a la entidad del celebramiento de la subasta y las instrucciones de puja a trav&eacute;s de la herramienta mediante el bot&oacute;n "Anotaci&oacute;n".</p><p style="margin-bottom: 10px">En caso de que no tenga atribuciones para validar el informe de subasta, deber&aacute; se&ntilde;alar el motivo de autorizaci&oacute;n de entre los posibles motivos listados.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">La siguiente tarea ser&aacute;:</p><p style="margin-bottom: 10px; margin-left: 40px;">-En caso de aceptar el informe y tenga atribuciones, se lanzar&aacute; la tarea de  “Dictar instrucciones”.</p><p style="margin-bottom: 10px; margin-left: 40px;">-En caso de aceptar el informe y no tenga atribuciones, se lanzar&aacute; la tarea de  “Obtener validaci&oacute;n comit&eacute;”.</p><p style="margin-bottom: 10px; margin-left: 40px;">-Se lanzar&aacute; la tarea "Preparar informe de subasta" en caso de no aceptar el informe.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_ValidarInformeDeSubasta','1','combo' ,'comboAtribuciones','Con Atribuciones' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_ValidarInformeDeSubasta','2','combo' ,'comboInforme','Acepta informe' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_ValidarInformeDeSubasta','3','combo' ,'comboAutorizacion','Motivo autorización' ,null ,null ,null ,'DDMotivoAutorizacion','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_ValidarInformeDeSubasta','4','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_ObtenerValidacionComite','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&aacute; indicar la fecha en la que el comit&eacute; decide sobre el informe de subasta.</p><p style="margin-bottom: 10px">En caso de que la recomendaci&oacute;n del informe sea suspender subasta, o bien la entidad decida suspenderla, deber&aacute; indicar ene l campo "Motivo de suspensi&oacute;n", el motivo por el que se suspende la subasta.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">La siguiente tarea ser&aacute;:</p><p style="margin-bottom: 10px; margin-left: 40px;">-En el caso que sea la respuesta del comit&eacute; sea " Cntinuar subasta" o "Suspender subasta", se lanzar&aacute; la siguiente tarea al gestor de contencioso gesti&oacute;n de "Dictar instrucciones".</p><p style="margin-bottom: 10px; margin-left: 40px;">-En el caso que sea la respuesta del comit&eacute; sea "Rechazar" el informe, se volver&aacute; a la tarea de "Preparar informe de Subasta".</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_ObtenerValidacionComite','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_ObtenerValidacionComite','2','combo' ,'comboResultado','Resultado del Comité' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDResultadoComite','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_ObtenerValidacionComite','3','combo' ,'comboSuspension','Motivo de suspensión' ,null ,null ,null ,'DDMotivoSuspension','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_ObtenerValidacionComite','4','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_DictarInstruccionesSubasta','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez aprobada la propuesta por su supervisor, en esta tarea el gestor de contencioso gesti&oacute;n deber&aacute; dictar las instrucciones de la subasta al letrado.</p><p style="margin-bottom: 10px">El campo Fecha deber&aacute; anotar la fecha en que se realiza esta tarea.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">La siguiente tarea ser&aacute; "Lectura y confirmaci&oacute;n de instrucciones" en caso de continuar con la subasta o "Suspender subasta" en caso de suspensi&oacute;n de la subasta.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_DictarInstruccionesSubasta','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_DictarInstruccionesSubasta','2','textarea' ,'instrucciones','Instrucciones subasta' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_DictarInstruccionesSubasta','3','combo' ,'comboSuspender','Solicitar suspensión' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,'valores[''CJ070_ObtenerValidacionComite''] != null ? (valores[''CJ070_ObtenerValidacionComite''][''comboResultado''] == ''SUS'' ? DDSiNo.SI : DDSiNo.NO) : null' ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_DictarInstruccionesSubasta','4','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_SolicitarSuspenderSubasta','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que la entidad ha decidido suspender la subasta, para dar por completada esta tarea deber&aacute; solicitar en el juzgado la suspensi&oacute;n de la subasta e informar en el campo "Fecha solicitud", la fecha en que se haya presentado la solicitud de suspensi&oacute;n.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez complete esta pantalla, se lanzar&aacute; la tarea "Registrar suspensi&oacute;n subasta".</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_SolicitarSuspenderSubasta','1','date' ,'fecha','Fecha solicitud' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_SolicitarSuspenderSubasta','2','combo' ,'comboMotivo','Motivo de suspensión' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,'valores[''CJ070_ObtenerValidacionComite''] != null ? valores[''CJ070_ObtenerValidacionComite''][''comboMotivo''] : null' ,'DDMotivoSuspension','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_SolicitarSuspenderSubasta','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_RegistrarResSuspSubasta','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">En esta pantalla deberá informa de la fecha en la que el juzgado notifica la resolución a la solicitud de suspensión de la subasta así como indicar si la subasta se ha suspendido o no.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez finaliza esta tarea,  se le abrirá tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_RegistrarResSuspSubasta','1','date' ,'fecha','Fecha resolución' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_RegistrarResSuspSubasta','2','combo' ,'comboSuspension','Subasta suspendida' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_RegistrarResSuspSubasta','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_BPMTramiteSolSolvenciaPatrimonial','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Ejecuci&oacute;n del tr&aacute;mite de solicitud de solvencia patrimonial</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_RecepcionMandamientoPago','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea deber&aacute; revisar que puede realizarse la contabilizaci&oacute;n de los importes recibidos e indicar la fecha en la que recepciona el mandamiento de pago.</p><p style="margin-bottom: 10px">En caso de que la deuda no quede totalmente cubierta y alguno de los bienes no sea vivienda habitual, se continuar&aacute; con la averiguaci&oacute;n patrimonial. En el supuesto de que el bien o los bienes estuvieran marcados como vivienda habitual, se deber&aacute; considerar&aacute; fallido procesal y no se continuar&aacute; con la solvencia patrimonial.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez finalice esta tarea se lanzar&aacute; la tarea "Confirmar contabilidad" y, en caso de continuar con la averiguaci&oacute;n patrimonial, se lanzar&aacute; el "Tr&aacute;mite de solicitud de solvencia patrimonial".</p></div>' ,null,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_RecepcionMandamientoPago','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_RecepcionMandamientoPago','2','currency' ,'importe','Importe' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,'valores[''CJ070_ConfirmarRecepcionMandamientoDePago''][''importe'']' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_RecepcionMandamientoPago','3','combo' ,'comboDeuda','Cubierta totalmente la deuda' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_RecepcionMandamientoPago','4','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_ConfirmarContabilidad','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta tarea deber&aacute; informar la fecha en la que queda contabilizado en el sistema el pago realizado por el tercero.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_ConfirmarContabilidad','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ070_ConfirmarContabilidad','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026')
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