--/*
--##########################################
--## Author: Equipo Fase II - Bankia
--## Adaptado a BP : Óscar Dorado
--## Finalidad: DML del trámite subasta sareb
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  
  V_ENTIDAD_ID NUMBER(16);
  --Insertando valores en DD_TPO_TIPO_PROCEDIMIENTO
  TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
  V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
    t_tipo_tpo('P409', 'T. de subasta SAREB', 'trámite de subasta SAREB',     NULL, 'tramiteSubastaSAREBV4', 2, NULL, NULL, 8, 'MEJTipoProcedimiento',     1, 0)
  ); 
  V_TMP_TIPO_TPO T_TIPO_TPO; 
  
  
  --Insertando valores en DD_TAP
  TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(2048);
  TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
  V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
    t_tipo_tap('(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo =''P409'')', 'P409_SolicitudSubasta', NULL,  'comprobarMinimoBienLote() ? (comprobarBienInformado() ? null : ''''Los bienes con lote deben tener informado las cargas anteriores y posteriores, si es vivienda habitual o no y la situación posesoria'''') : ''''Al menos un bien debe estar asignado a un lote''''', NULL, NULL, NULL, 0,  'Solicitud de subasta', NULL,  NULL, NULL, 1, 'EXTTareaProcedimiento', 3,  2, 39, NULL, NULL, NULL),
    t_tipo_tap('(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo =''P409'')', 'P409_SenyalamientoSubasta', 'plugin/procedimientos/tramiteSubasta/senyalamientoSubastaV4',  NULL, '((valores[''''P409_SenyalamientoSubasta''''][''''principal'''']).toDouble() > ((valores[''''P409_SenyalamientoSubasta''''][''''costasLetrado'''']).toDouble())) ? ''''null'''' : ''''<p>&iexcl;Atenci&oacute;n! Las costas del letrado no pueden superar el 5% del principal.</p>''''', NULL, NULL, 0,  'Señalamiento de subasta', NULL,  'tareaExterna.cancelarTarea', NULL, 1, 'EXTTareaProcedimiento', 3,  NULL, NULL, NULL, NULL, NULL),
    t_tipo_tap('(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo =''P409'')', 'P409_AdjuntarInformeSubasta', NULL,  'comprobarAdjuntoInformeSubasta() ? null : ''''Debe adjuntar el informe de subasta al procedimiento.''''', NULL, NULL, NULL, 0,  'Adjuntar informe de subasta', NULL,  NULL, NULL, 1, 'EXTTareaProcedimiento', 3,  NULL, NULL, NULL, NULL, NULL),
    t_tipo_tap('(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo =''P409'')', 'P409_PrepararPropuestaSubasta', NULL,  'comprobarInformacionCompletaInstrucciones() ? (comprobarExisteDocumentoPSSB() ? (comprobarExisteDocumentoFSSF() ? (comprobarExisteDocumentoFSSB() ? null : ''''Es necesario adjuntar el documento Ficha suelo SAREB'''') : ''''Es necesario adjuntar el documento Front-sheet SAREB'''') : ''''Es necesario adjuntar el documento Plantilla subasta SAREB'''') : ''''La información de las instrucciones de los lotes no está completa.''''', NULL, NULL, NULL, 0,  'Preparar propuesta de subasta', NULL,  NULL, NULL, 1, 'EXTTareaProcedimiento', 3,  NULL, NULL, NULL, NULL, NULL),
    t_tipo_tap('(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo =''P409'')', 'P409_ValidarPropuesta', NULL,  NULL, NULL, 'valores[''''P409_ValidarPropuesta''''][''''comboResultado''''] == ''''ACE'''' ? (comprobarIsDemandadoPerJuridica() ? ''''lecturaYTributacion'''' : ''''lectura'''') : (valores[''''P409_ValidarPropuesta''''][''''comboResultado''''] == ''''SUS'''' ? ''''SuspenderSubasta'''' : ''''ModificarInstrucciones'''')', NULL, 1,  'Validar propuesta', NULL,  'tareaExterna.cancelarTarea', NULL, 1, 'EXTTareaProcedimiento', 3,  NULL, 40, NULL, NULL, NULL),
    t_tipo_tap('(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo =''P409'')', 'P409_LecturaAceptacionInstrucciones', NULL,  NULL, NULL, NULL, NULL, 0,  'Lectura y aceptación de instrucciones', NULL,  NULL, NULL, 1, 'EXTTareaProcedimiento', 3,  NULL, NULL, NULL, NULL, NULL),
    t_tipo_tap('(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo =''P409'')', 'P409_BPMTramiteTributacionEnBienesV4', NULL,  NULL, NULL, NULL, '(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo =''P409'')', 0,  'Se inicia trámite tributación en bienes', NULL,  NULL, NULL, 1, 'EXTTareaProcedimiento', 3,  NULL, NULL, NULL, NULL, NULL),
    t_tipo_tap('(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo =''P409'')', 'P409_SuspenderSubasta', NULL,  NULL, NULL, NULL, NULL, 0,  'Suspender subasta', NULL,  'tareaExterna.cancelarTarea', NULL, 1, 'EXTTareaProcedimiento', 3,  NULL, NULL, NULL, NULL, NULL),
    t_tipo_tap('(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo =''P409'')', 'P409_CelebracionSubasta', 'plugin/procedimientos/tramiteSubasta/celebracionSubastaV4',  NULL, 'valores[''''P409_CelebracionSubasta''''][''''comboCelebrada''''] == ''''02'''' ? (valores[''''P409_CelebracionSubasta''''][''''comboSuspension''''] == null ? ''''El campo suspensión es obligatorio'''' : (valores[''''P409_CelebracionSubasta''''][''''comboMotivo''''] == null ? ''''Campo motivo es obligatorio'''' : null )) : (valores[''''P409_CelebracionSubasta''''][''''comboCesion''''] == null ? ''''Campo cesión es obligatorio'''' : (valores[''''P409_CelebracionSubasta''''][''''comboCesion''''] == ''''01'''' ? (valores[''''P409_CelebracionSubasta''''][''''comboComite''''] == null ? ''''Campo comité es obligatorio'''' : null) : null ))', 'valores[''''P409_CelebracionSubasta''''][''''comboCelebrada''''] == DDSiNo.NO ? (valores[''''P409_CelebracionSubasta''''][''''comboSuspension''''] == ''''ENT'''' ? ''''SuspendidaEntidad'''' : ''''SuspendidaTerceros'''' ) : (valores[''''P409_CelebracionSubasta''''][''''comboCesion''''] == DDSiNo.NO ? ''''CelebracionActaSubasta'''' : (valores[''''P409_CelebracionSubasta''''][''''comboComite''''] == DDSiNo.SI ? ''''CesionDeRemateConPreparacion'''': ''''CesionDeRemateSinPreparacion''''))', NULL, 0,  'Celebración de subasta', NULL,  NULL, NULL, 1, 'EXTTareaProcedimiento', 3,  NULL, NULL, NULL, NULL, NULL),
    t_tipo_tap('(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo =''P409'')', 'P409_BPMTramiteSubastaSAREBV4', NULL,  NULL, NULL, NULL, '(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo =''P409'')', 0,  'Se inicia trámite subasta', NULL,  NULL, NULL, 1, 'EXTTareaProcedimiento', 3,  NULL, 39, NULL, NULL, NULL),
    t_tipo_tap('(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo =''P409'')', 'P409_RegistrarActaSubasta', NULL,  NULL, NULL, 'valores[''''P409_CelebracionSubasta''''][''''comboSuspension''''] == ''''TER'''' ? ''''ParaBienesAdjudicadosAUnTercero'''' : ''''tramiteAdjudicacion''''', NULL, 0,  'Registrar acta de subasta', NULL,  'tareaExterna.cancelarTarea', NULL, 1, 'EXTTareaProcedimiento', 3,  NULL, NULL, NULL, NULL, NULL),
    t_tipo_tap('(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo =''P409'')', 'P409_BPMTramiteAdjudicacionV4', NULL,  NULL, NULL, NULL, NULL, 0,  'Se inicia trámite de adjudicación por cada bien', NULL,  'tareaExterna.cancelarTarea', NULL, 1, 'EXTTareaProcedimiento', 3,  NULL, NULL, NULL, NULL, NULL),
    t_tipo_tap('(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo =''P409'')', 'P409_SolicitarMtoPago', NULL,  NULL, NULL, NULL, NULL, 0,  'Solicitar mandamiento de pago', NULL,  'tareaExterna.cancelarTarea', NULL, 1, 'EXTTareaProcedimiento', 3,  NULL, NULL, NULL, NULL, NULL),
    t_tipo_tap('(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo =''P409'')', 'P409_ConfirmarRecepcionMtoPago', NULL,  NULL, NULL, NULL, NULL, 0,  'Confirmar recepcion mandamiento de pago', NULL,  'tareaExterna.cancelarTarea', NULL, 1, 'EXTTareaProcedimiento', 3,  NULL, NULL, NULL, NULL, NULL),
    t_tipo_tap('(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo =''P409'')', 'P409_PrepararCesionRemate', NULL,  NULL, NULL, NULL, NULL, 0,  'Preparar cesión de remate', NULL,  'tareaExterna.cancelarTarea', NULL, 1, 'EXTTareaProcedimiento', 3,  NULL, NULL, NULL, NULL, NULL),
    t_tipo_tap('(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo =''P409'')', 'P409_AprobacionPropCesionRemate', NULL,  NULL, NULL, 'valores[''''P409_AprobacionPropCesionRemate''''][''''comboAprobado''''] == DDSiNo.SI ? ''''OK'''' : ''''KO''''', NULL, 1,  'Aprobación propuesta de cesión de remate a terceros', NULL,  'tareaExterna.cancelarTarea', NULL, 1, 'EXTTareaProcedimiento', 3,  NULL, 40, NULL, NULL, NULL),
    t_tipo_tap('(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo =''P409'')', 'P409_BPMTramiteCesionRemateV4', NULL,  NULL, NULL, NULL, '(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo =''P409'')', 0,  'Se inicia trámite de cesión de remate', NULL,  NULL, NULL, 1, 'EXTTareaProcedimiento', 3,  NULL, 39, NULL, NULL, NULL),
    t_tipo_tap('(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo =''P409'')', 'P409_AnalizarDUEDiligence', NULL,  NULL, NULL, 'comprobarObraEnCurso() ? ''''hayObraEnCurso'''' : ''''noHayObraEnCurso''''', NULL, 0,  'Analizar DUE DILIGENCE', NULL,  NULL, NULL, 1, 'EXTTareaProcedimiento', 3,  NULL, 39, NULL, NULL, NULL),
    t_tipo_tap('(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo =''P409'')', 'P409_RegistrarResultadoDUE', NULL,  'comprobarExisteDocumentoDUEDIL() ? null : ''''Es necesario adjuntar el documento DUE-DILIGENCE''''', NULL, NULL, NULL, 0,  'Registrar resultado DUE DILIGENCE', NULL,  'tareaExterna.cancelarTarea', NULL, 1, 'EXTTareaProcedimiento', 3,  NULL, NULL, NULL, NULL, NULL),
    t_tipo_tap('(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo =''P409'')', 'P409_EnviarPropuestaControl', NULL,  NULL, NULL, NULL, NULL, 0,  'Enviar propuesta a control', NULL,  'tareaExterna.cancelarTarea', NULL, 1, 'EXTTareaProcedimiento', 3,  NULL, 39, NULL, NULL, NULL) 
  );  
  V_TMP_TIPO_TAP T_TIPO_TAP; 
  
  --Insertando valores en DD_PTP
  TYPE T_TIPO_PTP IS TABLE OF VARCHAR2(2048);
  TYPE T_ARRAY_PTP IS TABLE OF T_TIPO_PTP;
  V_TIPO_PTP T_ARRAY_PTP := T_ARRAY_PTP(
    t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_PrepararPropuestaSubasta'')','damePlazo(valores[''''P409_SenyalamientoSubasta''''][''''fechaAnuncio''''])-60*24*60*60*1000L'),
    t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_CelebracionSubasta'')', 'damePlazo(valores[''''P409_SenyalamientoSubasta''''][''''fechaAnuncio''''])-5*24*60*60*1000L'),
    t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_RegistrarActaSubasta'')', 'damePlazo(valores[''''P409_SenyalamientoSubasta''''][''''fechaAnuncio''''])+1*24*60*60*1000L'),
    t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_BPMTramiteAdjudicacionV4'')', 'damePlazo(valores[''''P409_RegistrarActaSubasta''''][''''fecha''''])+1*24*60*60*1000L'),
    t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_AnalizarDUEDiligence'')', 'damePlazo(valores[''''P409_SenyalamientoSubasta''''][''''fechaSenyalamiento'''']) - 60*24*60*60*1000L'),
    t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_EnviarPropuestaControl'')', 'damePlazo(valores[''''P409_RegistrarResultadoDUE''''][''''fecha''''])+5*24*60*60*1000L'),
    t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_BPMTramiteSubastaSAREBV4'')', '300*24*60*60*1000L'),
    t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_SolicitarMtoPago'')', 'damePlazo(valores[''''P409_SenyalamientoSubasta''''][''''fechaAnuncio''''])+20*24*60*60*1000L'),
    t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_PrepararCesionRemate'')', 'damePlazo(valores[''''P409_PrepararCesionRemate''''][''''fecha''''])+3*24*60*60*1000L'),
    t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_SolicitudSubasta'')', '5*24*60*60*1000L'),
    t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_LecturaAceptacionInstrucciones'')', 'damePlazo(valores[''''P409_SenyalamientoSubasta''''][''''fechaAnuncio''''])-5*24*60*60*1000L'),
    t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_BPMTramiteTributacionEnBienesV4'')', '300*24*60*60*1000L'),
    t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_RegistrarResultadoDUE'')', 'damePlazo(valores[''''P409_AnalizarDUEDiligence''''][''''fechaSolicitud'''']) + 21*24*60*60*1000L'),
    t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_ValidarPropuesta'')', 'damePlazo(valores[''''P409_SenyalamientoSubasta''''][''''fechaAnuncio''''])-50*24*60*60*1000L'),
    t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_BPMTramiteCesionRemateV4'')', '300*24*60*60*1000L'),
    t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_AdjuntarInformeSubasta'')', 'damePlazo(valores[''''P409_SenyalamientoSubasta''''][''''fechaSenyalamiento''''])+5*24*60*60*1000L'),
    t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_AprobacionPropCesionRemate'')', 'damePlazo(valores[''''P409_SenyalamientoSubasta''''][''''fechaSenyalamiento''''])+3*24*60*60*1000L'),
    t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_SenyalamientoSubasta'')', 'damePlazo(valores[''''P409_SolicitudSubasta''''][''''fechaSolicitud''''])+60*24*60*60*1000L'),
    t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_SuspenderSubasta'')', 'damePlazo(valores[''''P409_ValidarPropuesta''''][''''fechaDecision''''])+5*24*60*60*1000L'),
    t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_ConfirmarRecepcionMtoPago'')', 'damePlazo(valores[''''P409_SolicitarMtoPago''''][''''fechaPresentacion''''])+20*24*60*60*1000L')
  ); 
  V_TMP_TIPO_PTP T_TIPO_PTP; 
  
  --Insertando valores en DD_TFI
  TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5024);
  TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
  V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_SolicitudSubasta'')', 0, 'label', 'titulo', '	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea, deberá acceder a la pestaña Subastas del asunto correspondiente y asociar uno o más bienes a la subasta que corresponda. Una vez agregados los bienes a la subasta deberá indicar a través de la ficha de cada bien las cargas anteriores y posteriores, si es vivienda habitual o no y la situación posesoria.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo Fecha solicitud deberá consignar la fecha en la que haya realizado la solicitud de subasta.En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.Una vez rellene esta pantalla se lanzará la tarea "Señalamiento de subasta" a realizar por el letrado.</p></div>', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_SenyalamientoSubasta'')', 3, 'currency', 'costasLetrado', 'Costas letrado', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''''''' ? true : false', NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_SenyalamientoSubasta'')', 7, 'currency', 'principal', 'Principal', NULL, NULL, 'procedimientoManager.getProcedimiento(idProcedimiento).getSaldoRecuperacion()*5/100', NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_LecturaAceptacionInstrucciones'')', 2, 'textarea', 'observaciones', 'Observaciones', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_SuspenderSubasta'')', 1, 'date', 'fechaSuspension', 'Fecha suspension', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''''''' ? true : false', NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_SuspenderSubasta'')', 3, 'textarea', 'observaciones', 'Observaciones', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_CelebracionSubasta'')', 0, 'label', 'titulo',
 '	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez se celebre la subasta, en esta pantalla debe introducir la siguiente información:</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo Celebrada deberá indicar si la subasta ha sido celebrada o no. En caso de haberse celebrado deberá indicar a través de la pestaña Subastas de la ficha del asunto correspondiente, el resultado de la subasta para cada uno de los bienes subastados y en el caso de adjudicación por parte de la entidad deberá informar también del importe por el cual se le lo ha adjudicado la entidad.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En caso de suspensión de la subasta deberá indicar dicha circunstancia en el campo "Celebrada", en el campo "Decisión suspensión" deberá consignar quien ha provocado dicha suspensión y en el campo "Motivo suspensión" deberá indicar el motivo por el cual se ha suspendido.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En caso de haberse adjudicado alguno de los bienes la Entidad, deberá indicar si ha habido Postores o no en la subasta y en el campo Cesión deberá indicar si se debe cursar la cesión de remate o no, según el procedimiento establecido por la entidad.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En caso de haber cesión del remate deberá indicar si es requerida la preparación o no según el procedimiento establecido por la Entidad.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla la siguiente tarea será:<br>En caso de haberse producido la subasta se lanzará la tarea "Registrar acta de subasta".<br>En caso de haber cesión de remate y haber requerido la preparación de la misma "Preparar cesión de remate" a realizar por el supervisor.<br>En caso de haber cesión de remate y no haber requerido preparación de la misma, se lanzará directamente el trámite de cesión de remate.<br>
En caso de haberse suspendido la subasta, se lanzará la tarea "Señalamiento de subasta".</p></div>', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_ConfirmarRecepcionMtoPago'')', 2, 'textarea', 'observaciones', 'Observaciones', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_PrepararCesionRemate'')', 2, 'htmllabel', 'instrucciones', 'Instrucciones', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_PrepararCesionRemate'')', 3, 'textarea', 'observaciones', 'Observaciones', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_EnviarPropuestaControl'')', 2, 'textarea', 'observaciones', 'Observaciones', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_SolicitudSubasta'')', 3, 'textarea', 'observaciones', 'Observaciones', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_SenyalamientoSubasta'')', 5, 'currency', 'intereses', 'Intereses generados', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''''''' ? true : false', NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_BPMTramiteTributacionEnBienesV4'')', 0, 'label', 'titulo', 'Se inicia trámite tributación en bienes', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_CelebracionSubasta'')', 3, 'combo', 'comboComite', 'Requiere elevar comité', NULL, NULL, NULL, 'DDSiNo'),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_CelebracionSubasta'')', 4, 'combo', 'comboSuspension', 'Decisión suspensión', NULL, NULL, NULL, 'DDDecisionSuspension'),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_CelebracionSubasta'')', 6, 'textarea', 'observaciones', 'Observaciones', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_RegistrarActaSubasta'')', 1, 'date', 'fecha', 'Fecha', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_BPMTramiteAdjudicacionV4'')', 0, 'label', 'titulo', '    <div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia trámite de adjudicación por cada bien</p></div>', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_SolicitarMtoPago'')', 0, 'label', 'titulo', '	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Dado que alguno de los bienes ha sido adjudicado a un tercero, en esta pantalla debemos de consignar la fecha de presentación en el juzgado del escrito solicitando la entrega de las cantidades consignadas.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla la siguiente tarea será "Confirmar recepción mandamiento de pago"</p></div>', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_ConfirmarRecepcionMtoPago'')', 1, 'date', 'fecha', 'Fecha', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_EnviarPropuestaControl'')', 0, 'label', 'titulo', '	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deberá proceder a adjuntar a través de la pestaña Adjuntos del asunto correspondiente todos aquellos documentos necesarios para dar traslado de la DUE-DILIGENCE al comité.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo Fecha deberá de consignar la fecha en que se adjunta toda la información requerida al procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se dará por concluido el flujo de tarea correspondiente a obtención de la DUE-DILIGENCE.</p></div>', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_AnalizarDUEDiligence'')', 0, 'label', 'titulo', '	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea, deberá acceder a cada uno de los bienes asociados a la subasta de la pestaña Subastas del asunto correspondiente, y analizar si cada bien es de tipo "Obra en curso" o no, consignando el resultado en el campo "obra en curso" de la ficha de cada bien junto a la fecha del análisis realizado.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo Fecha deberá de consignar la fecha en que realiza la solicitud de la DUE-DILIGENCE en caso de ser necesario, en caso contrario dejar este campo en blanco. </p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla y en caso de haber registrado en alguno de los bienes como que es de tipo "Obra en curso" se lanzará la tarea "Registrar resultado DUE-DILIGENCE".</p></div>', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_SenyalamientoSubasta'')', 4, 'currency', 'costasProcurador', 'Costas procurador', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''''''' ? true : false', NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_AdjuntarInformeSubasta'')', 0, 'label', 'titulo', '	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea, antes deberá adjuntar al asunto correspondiente el informe sobre la subasta. Desde la pestaña Subastas del asunto correspondiente dispone de una función para descargar el informe de subasta ya generado y en formato Word, a partir de este documento puede modificarlo si así lo cree conveniente, y una vez modificado adjuntarlo al procedimiento a través de la pestaña Adjuntos.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo Fecha deberá consignar la fecha que adjunta el informe de subasta al procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla seguirá el flujo de tareas según especificación de la entidad.</p></div>', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_ValidarPropuesta'')', 0, 'label', 'titulo', '	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por finalizada esta tarea deberá de revisar y dictaminar sobre la propuesta de instrucciones dada por el supervisor. Para ello dispone de la funcionalidad "Gestión de subasta" por la cual es posible validar de forma masiva o puntual las subastas en estado "PENDIENTE COMITE".</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Dependiente del resultado del comité la siguiente tarea podrá ser:<br>"Suspender subasta" en caso de haber dictaminado la suspensión de la subasta.<br>"Lectura y aceptación por parte del letrado" En caso de haber aprobado las instrucciones de la subasta.<br>"Preparar propuesta de subasta" En caso de haber requerido al supervisor la modificación de las instrucciones para la subasta.</p></div>', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_ValidarPropuesta'')', 1, 'date', 'fechaDecision', 'Fecha decisión', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''''''' ? true : false', NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_ValidarPropuesta'')', 2, 'combo', 'comboResultado', 'Resultado comité', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''''''' ? true : false', NULL, 'DDResultadoComite'),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_ValidarPropuesta'')', 3, 'textarea', 'observaciones', 'Observaciones', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_CelebracionSubasta'')', 2, 'combo', 'comboCesion', 'cesión de remate', NULL, NULL, NULL, 'DDSiNo'),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_BPMTramiteSubastaSAREBV4'')', 0, 'label', 'titulo', 'Se inicia trámite subasta', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_BPMTramiteCesionRemateV4'')', 0, 'label', 'titulo', 'Se inicia trámite de cesión de remate', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_RegistrarResultadoDUE'')', 0, 'label', 'titulo', '	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Dado que se ha detectado que alguno de los bienes a subastar es de tipo "Obra en curso" para dar por completada esta tarea deberá esperar a recibir la DUE-DILIGENCE, una vez la tenga en su poder deberá adjuntar al procedimiento a través de la pestaña Adjuntos del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo Fecha deberá de consignar la fecha en que se recibe la DUE-DILIGENCE.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzará la tarea "Enviar propuesta a control".</p></div>', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_LecturaAceptacionInstrucciones'')', 1, 'date', 'fecha', 'Fecha', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_SuspenderSubasta'')', 2, 'combo', 'comboMotivo', 'Motivo suspensión', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''''''' ? true : false', NULL, 'DDMotivoSuspension'),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_RegistrarActaSubasta'')', 2, 'textarea', 'observaciones', 'Observaciones', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_ConfirmarRecepcionMtoPago'')', 0, 'label', 'titulo', '	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se ha de consignar la fecha en la que nos han entregado los mandamientos de pago de la cantidad consignada por un tercero en concepto de pago del bien adjudicado.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</p></div>', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_PrepararCesionRemate'')', 1, 'date', 'fecha', 'Fecha', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_AprobacionPropCesionRemate'')', 3, 'htmllabel', 'instrucciones', 'Instrucciones', NULL, NULL, 'valores[''''P409_PrepararCesionRemate''''][''''instrucciones'''']', NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_EnviarPropuestaControl'')', 1, 'date', 'fechaSolicitud', 'Fecha', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_SenyalamientoSubasta'')', 2, 'date', 'fechaSenyalamiento', 'Fecha señalamiento', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''''''' ? true : false', NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_SenyalamientoSubasta'')', 6, 'textarea', 'observaciones', 'Observaciones', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_AdjuntarInformeSubasta'')', 1, 'date', 'fechaInforme', 'Fecha informe', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''''''' ? true : false', NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_PrepararPropuestaSubasta'')', 0, 'label', 'titulo', '	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de completar esta tarea deberá esperar a que estén disponibles en Recovery todas las tasaciones correspondientes a los bienes afectos a la subasta, esto lo podrá consultar a través de la pestaña Subastas del asunto correspondiente.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por completada esta tarea deberá acceder desde la pestaña Subastas del asunto correspondiente a cada uno de los bienes afectos a la subasta e indicar los importes para la puja sin postores, puja con postores desde y puja con postores hasta. Una vez hecho esto podrá generar desde la pestaña Subastas el informe con la propuesta de instrucciones para la subasta en formato Word, de forma que en caso de ser necesario pueda modificarlo.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea, deberá adjuntar el informe con la propuesta de instrucciones para la subasta al procedimiento correspondiente.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo Fecha deberá consignar la fecha en la que haya adjuntado el informe con las instrucciones para la subasta.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzará la tarea "Validar propuesta de instrucciones" a realizar por el letrado.</p></div>', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_LecturaAceptacionInstrucciones'')', 0, 'label', 'titulo', '	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez que ha sido anunciada la subasta, y han sido dictadas las instrucciones por la entidad, antes de dar por completada esta tarea deberá acceder a la pestaña "Subasta" de la ficha del asunto correspondiente y revisar las instrucciones dadas para cada uno de los bienes a subastar.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Consignando la fecha se confirma haber recibido correctamente las instrucciones del responsable de la entidad, así como la aceptación de las mismas. Para el supuesto de que haya alguna duda al respecto, deberá ponerse en contacto con el responsable de la entidad para que se revisen o modifiquen dichas instrucciones.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento</p></div>', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_PrepararPropuestaSubasta'')', 1, 'date', 'fechaPropuesta', 'Fecha propuesta instrucciones', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''''''' ? true : false', NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_AprobacionPropCesionRemate'')', 0, 'label', 'titulo', '	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través de esta pantalla deberá de comprobar que las instrucciones dadas por el supervisor son correctas y estén en consonancia con la política de la entidad. En caso de haber discrepancia puede modificar las instrucciones directamente sobre el campo Instrucciones de forma que sean estas instrucciones las que lleguen al actor encargado de proceder con la cesión del remate.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez completada esta tarea el sistema iniciará automáticamente el trámite de cesión de remate.</p></div>', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_AnalizarDUEDiligence'')', 2, 'textarea', 'observaciones', 'Observaciones', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_RegistrarResultadoDUE'')', 1, 'date', 'fecha', 'Fecha', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_RegistrarResultadoDUE'')', 2, 'textarea', 'observaciones', 'Observaciones', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_SolicitudSubasta'')', 1, 'combo', 'comboSolicitud', 'Solicitud de subasta por terceros', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''''''' ? true : false', NULL, 'DDSiNo'),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_SolicitudSubasta'')', 2, 'date', 'fechaSolicitud', 'Fecha solicitud', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''''''' ? true : false', NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_SenyalamientoSubasta'')', 0, 'label', 'titulo', '	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez solicitada la subasta, en esta pantalla, debe consignar las fechas de anuncio y celebración de la misma así como las costas del letrado y procurador.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzarán las siguientes tareas:<br>"Celebración subasta y adjudicación" a realizar por el letrado.<br>"Adjuntar informe de subasta" a realizar por el letrado.<br>"Preparar propuesta de subasta" a realizar por el supervisor.</p></div>', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_SenyalamientoSubasta'')', 1, 'date', 'fechaAnuncio', 'Fecha anuncio', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''''''' ? true : false', NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_AdjuntarInformeSubasta'')', 2, 'textarea', 'observaciones', 'Observaciones', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_SuspenderSubasta'')', 0, 'label', 'titulo', '	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Dado que el comité ha decidido suspender la subasta, para dar por completada esta tarea deberá de proceder a dicha suspensión, indicando en el campo Fecha suspensión, la fecha en que se haya suspendido la subasta.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</p></div>', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_SolicitarMtoPago'')', 2, 'textarea', 'observaciones', 'Observaciones', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_AprobacionPropCesionRemate'')', 4, 'textarea', 'observaciones', 'Observaciones', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_AnalizarDUEDiligence'')', 1, 'date', 'fechaSolicitud', 'Fecha', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_PrepararCesionRemate'')', 0, 'label', 'titulo', '	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Dado que el letrado ha indicado que se requiere de preparación para la cesión del remate, para dar por completada esta tarea deberá introducir en el campo Instrucciones las instrucciones de la entidad para la cesión y en el campo Fecha consignar la fecha en que de por terminada la preparación de la cesión de remate.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla la siguiente tarea será "Aceptación de instrucciones para cesión" a realizar por el supervisor de la entidad.</p></div>', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_PrepararPropuestaSubasta'')', 2, 'textarea', 'observaciones', 'Observaciones', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_CelebracionSubasta'')', 1, 'combo', 'comboCelebrada', 'Subasta celebrada', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''''''' ? true : false', NULL, 'DDSiNo'),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_CelebracionSubasta'')', 5, 'combo', 'comboMotivo', 'Motivo suspensión', NULL, NULL, NULL, 'DDMotivoSuspSubasta'),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_RegistrarActaSubasta'')', 0, 'label', 'titulo', '	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deberá de adjuntar el acta de subasta al procedimiento correspondiente a través de la pestaña Adjuntos.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo fecha consignar la fecha en que da por terminada el acta de subasta y proceda a subirla a la plataforma.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla la siguiente tarea será, en caso de haber uno o más bienes adjudicados a un tercero "Solicitar mandamiento de pago" y en caso de habérselo adjudicado la entidad uno o más bienes "Contabilizar archivo y cierre de deuda".</p></div>', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_SolicitarMtoPago'')', 1, 'date', 'fechaPresentacion', 'Fecha', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_AprobacionPropCesionRemate'')', 1, 'date', 'fecha', 'Fecha', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_AprobacionPropCesionRemate'')', 2, 'combo', 'comboAprobado', 'Instrucciones correctas', NULL, NULL, NULL, 'DDSiNo')
	); 
  V_TMP_TIPO_TFI T_TIPO_TFI; 
  
BEGIN 
    
    -- 1) LOOP Insertando valores en DD_TPO_TIPO_PROCEDIMIENTO
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO... Empezando a insertar datos en el diccionario');
    FOR I IN V_TIPO_TPO.FIRST .. V_TIPO_TPO.LAST
      LOOP
        V_TMP_TIPO_TPO := V_TIPO_TPO(I);
        -- Comprobamos el dato
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||TRIM(V_TMP_TIPO_TPO(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;			
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO... Ya existe el procedimiento '''|| TRIM(V_TMP_TIPO_TPO(1)) ||'''');
        ELSE
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_TPO_TIPO_PROCEDIMIENTO.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_TPO_TIPO_PROCEDIMIENTO (
                    DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, DD_TPO_SALDO_MIN, DD_TPO_SALDO_MAX, FLAG_PRORROGA, DTYPE, FLAG_DERIVABLE, FLAG_UNICO_BIEN, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                    'SELECT '''|| V_ENTIDAD_ID || ''','''||TRIM(V_TMP_TIPO_TPO(1))||''','''||TRIM(V_TMP_TIPO_TPO(2))||''','''||TRIM(V_TMP_TIPO_TPO(3))||''','''||TRIM(V_TMP_TIPO_TPO(4))||''','||
                     ''''||TRIM(V_TMP_TIPO_TPO(5)) || ''','''||TRIM(V_TMP_TIPO_TPO(6))||''','''||TRIM(V_TMP_TIPO_TPO(7))||''','''||TRIM(V_TMP_TIPO_TPO(8))||''','''||TRIM(V_TMP_TIPO_TPO(9))||''','||                     
                     ''''||TRIM(V_TMP_TIPO_TPO(10)) || ''','''||TRIM(V_TMP_TIPO_TPO(11))||''','''||TRIM(V_TMP_TIPO_TPO(12))||''','|| 
                     '''DML'', sysdate, 0 FROM DUAL';
              DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TPO(1)||''','''||TRIM(V_TMP_TIPO_TPO(2)));
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO... Datos del diccionario insertado');
    
    
    -- 2) LOOP Insertando valores en TAP_TAREA_PROCEDIMIENTO
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO... Empezando a insertar datos en el diccionario');
    FOR I IN V_TIPO_TAP.FIRST .. V_TIPO_TAP.LAST
      LOOP
        V_TMP_TIPO_TAP := V_TIPO_TAP(I);
        -- Comprobamos el dato
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE DD_TPO_ID = '||TRIM(V_TMP_TIPO_TAP(1))||' and TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO... Ya existe la tarea '''|| TRIM(V_TMP_TIPO_TAP(1)) ||'''');
        ELSE
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID; 
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO (
                    TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SCRIPT_VALIDACION, TAP_SCRIPT_VALIDACION_JBPM, TAP_SCRIPT_DECISION, DD_TPO_ID_BPM, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_ALERT_NO_RETORNO, TAP_ALERT_VUELTA_ATRAS, DD_FAP_ID, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP, DD_TGE_ID, DD_STA_ID, TAP_EVITAR_REORG, DD_TSUP_ID, TAP_BUCLE_BPM, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                    'SELECT '''|| V_ENTIDAD_ID || ''', '||V_TMP_TIPO_TAP(1)||' ,'''||TRIM(V_TMP_TIPO_TAP(2))||''','''||TRIM(V_TMP_TIPO_TAP(3))||''','''||TRIM(V_TMP_TIPO_TAP(4))||''','||
                      ''''||TRIM(V_TMP_TIPO_TAP(5)) || ''','''||TRIM(V_TMP_TIPO_TAP(6))||''','||nvl(TRIM(V_TMP_TIPO_TAP(7)),'''''')||','''||TRIM(V_TMP_TIPO_TAP(8))||''','''||TRIM(V_TMP_TIPO_TAP(9))||''','||
                      ''''||TRIM(V_TMP_TIPO_TAP(10)) || ''','''||TRIM(V_TMP_TIPO_TAP(11))||''','''||TRIM(V_TMP_TIPO_TAP(12))||''','''||TRIM(V_TMP_TIPO_TAP(13))||''','''||TRIM(V_TMP_TIPO_TAP(14))||''','||                     
                      ''''||TRIM(V_TMP_TIPO_TAP(15)) || ''','''||TRIM(V_TMP_TIPO_TAP(16))||''','''||TRIM(V_TMP_TIPO_TAP(17))||''','''||TRIM(V_TMP_TIPO_TAP(18))||''','''||TRIM(V_TMP_TIPO_TAP(19))||''','||
                      ''''||TRIM(V_TMP_TIPO_TAP(20))||''','||
                      '''DML'', sysdate, 0 FROM DUAL';
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TAP(1)||''','''||TRIM(V_TMP_TIPO_TAP(2)));
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO... Datos del diccionario insertado');
    
    
    -- 3) LOOP Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS... Empezando a insertar datos en el diccionario');
    FOR I IN V_TIPO_PTP.FIRST .. V_TIPO_PTP.LAST
      LOOP
        V_TMP_TIPO_PTP := V_TIPO_PTP(I);
        -- Comprobamos el dato
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS WHERE TAP_ID = '||TRIM(V_TMP_TIPO_PTP(1));
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;      
        IF V_NUM_TABLAS > 0 THEN				
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_PTP_PLAZOS_TAREAS_PLAZAS... Ya existe el plazo '''|| TRIM(V_TMP_TIPO_PTP(1)) ||'''');
        ELSE
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.s_dd_ptp_plazos_tareas_plazas.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_PTP_PLAZOS_TAREAS_PLAZAS (
                    DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                    'SELECT '''|| V_ENTIDAD_ID || ''','||V_TMP_TIPO_PTP(1)||','''||TRIM(V_TMP_TIPO_PTP(2))||''','||
                      '''DML'', sysdate, 0 FROM DUAL';
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_PTP(1)||''','''||TRIM(V_TMP_TIPO_PTP(2)));
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS... Datos del diccionario insertado');
    
    -- 4) LOOP Insertando valores en TFI_TAREAS_FORM_ITEMS
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS... Empezando a insertar datos en el diccionario');
    FOR I IN V_TIPO_TFI.FIRST .. V_TIPO_TFI.LAST
      LOOP
        V_TMP_TIPO_TFI := V_TIPO_TFI(I);
        -- Comprobamos el dato
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = '||TRIM(V_TMP_TIPO_TFI(1))||' and TFI_ORDEN = '||TRIM(V_TMP_TIPO_TFI(2));
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TFI_TAREAS_FORM_ITEMS... Ya existe el item '''|| TRIM(V_TMP_TIPO_TFI(1)) ||''' and TFI_ORDEN = '||TRIM(V_TMP_TIPO_TFI(2))||' ');
        ELSE
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.s_tfi_tareas_form_items.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS (
                    TFI_ID, tap_id, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_VALOR_INICIAL, TFI_BUSINESS_OPERATION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                    'SELECT '''|| V_ENTIDAD_ID || ''', '||V_TMP_TIPO_TFI(1)||' ,'''||TRIM(V_TMP_TIPO_TFI(2))||''','''||TRIM(V_TMP_TIPO_TFI(3))||''','''||TRIM(V_TMP_TIPO_TFI(4))||''','||
                      ''''||TRIM(V_TMP_TIPO_TFI(5)) || ''','''||TRIM(V_TMP_TIPO_TFI(6))||''','''||TRIM(V_TMP_TIPO_TFI(7))||''','''||TRIM(V_TMP_TIPO_TFI(8))||''','''||TRIM(V_TMP_TIPO_TFI(9))||''','||
                      '''DML'', sysdate, 0 FROM DUAL';
                       --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TFI(1)||''','''||TRIM(V_TMP_TIPO_TFI(2)));
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS... Datos del diccionario insertado');

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