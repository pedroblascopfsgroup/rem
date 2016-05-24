--/*
--##########################################
--## Author: Equipo Fase II - Bankia
--## Adaptado a BP : Óscar Dorado
--## Finalidad: DML del trámite notificación
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
    t_tipo_tpo('P419', 'T. de ocupantes', 'Trámite de ocupantes',     NULL, 'tramiteOcupantes', 2, NULL, NULL, 8, 'MEJTipoProcedimiento',     1, 0)
  ); 
  V_TMP_TIPO_TPO T_TIPO_TPO; 
  
  
  --Insertando valores en DD_TAP
  TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(2048);
  TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
  V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
    t_tipo_tap('(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P419'')', 'P419_ConfirmarVista', NULL,    NULL, NULL, 'valores[''''P419_ConfirmarVista''''][''''comboVista''''] == DDSiNo.SI ? ''''hayVista'''' : ''''noHayVista''''', NULL, 0,    'Confirmar vista', NULL,    NULL, NULL, 1, 'EXTTareaProcedimiento', 3,    NULL, NULL, NULL, NULL, NULL),
    t_tipo_tap('(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P419'')', 'P419_PresentarEscritoAlegaciones', NULL,    NULL, NULL, NULL, NULL, 0,    'Presentar escrito de alegaciones', NULL,    'tareaExterna.cancelarTarea', NULL, 1, 'EXTTareaProcedimiento', 3,    NULL, NULL, NULL, NULL, NULL),
    t_tipo_tap('(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P419'')', 'P419_RegistrarCelebracionVista', NULL,    NULL, NULL, NULL, NULL, 0,    'Registrar celebración vista', NULL,    NULL, NULL, 1, 'EXTTareaProcedimiento', 3,    NULL, NULL, NULL, NULL, NULL),
    t_tipo_tap('(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P419'')', 'P419_RegistrarInformeSituacion', NULL,    'comprobarExisteDocumentoISP() ? null : ''''Es necesario adjuntar el documento informe de situación de la posesión''''', NULL, NULL, NULL, 0,    'Registrar informe de situación', NULL,    NULL, NULL, 1, 'EXTTareaProcedimiento', 3,    NULL, NULL, NULL, NULL, NULL),
    t_tipo_tap('(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P419'')', 'P419_RegistrarRecepcionDoc', NULL,    NULL, NULL, NULL, NULL, 0,    'Registrar recepción de la documentación', NULL,    'tareaExterna.cancelarTarea', NULL, 1, 'EXTTareaProcedimiento', 3,    NULL, NULL, NULL, NULL, NULL),
    t_tipo_tap('(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P419'')', 'P419_RegistrarResolucion', NULL,    NULL, NULL, NULL, NULL, 0,    'Registrar resolución', NULL,    NULL, NULL, 1, 'EXTTareaProcedimiento', 3,    NULL, NULL, NULL, NULL, NULL),
    t_tipo_tap('(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P419'')', 'P419_ResolucionFirme', NULL,    NULL, NULL, 'valores[''''P419_RegistrarResolucion''''][''''comboResultado''''] == DDPositivoNegativo.NEGATIVO ? ( vieneDeTramitePosesion() ? ''''desfavorableTP'''' : ''''desfavorable'''') : ''''favorable''''', NULL, 0,    'Resolución firme', NULL,    'tareaExterna.cancelarTarea', NULL, 1, 'EXTTareaProcedimiento', 3,    NULL, NULL, NULL, NULL, NULL),
    t_tipo_tap('(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P419'')', 'P419_RevisarInformeLetrado', NULL,    NULL, NULL, 'valores[''''P419_RevisarInformeLetrado''''][''''comboResultado''''] == ''''MOD'''' ? ''''requiereModificacion'''' : (valores[''''P419_RevisarInformeLetrado''''][''''comboResultado''''] == ''''HA'''' ? ''''siHayAleg'''' : (valores[''''P419_RevisarInformeLetrado''''][''''comboResultado''''] == ''''NHASHV'''' ? ''''noHayAlegSiHayVista'''' : ''''noHayAlegNoHayVista''''))', NULL, 1,    'Revisar informe de letrado', NULL,    'tareaExterna.cancelarTarea', NULL, 1, 'EXTTareaProcedimiento', 3,    NULL, 40, NULL, NULL, NULL),
    t_tipo_tap('(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P419'')', 'P419_SolicitudRequerimientoDocOcupantes', NULL,    NULL, NULL, NULL, NULL, 0,    'Solicitud de requerimiento documentación de ocupantes', NULL,    'tareaExterna.cancelarTarea', NULL, 1, 'EXTTareaProcedimiento', 3,    NULL, NULL, NULL, NULL, NULL),
    t_tipo_tap('(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P419'')', 'P419_TrasladoDocuDeteccionOcupantes', NULL,    NULL, NULL, 'valores[''''P419_TrasladoDocuDeteccionOcupantes''''][''''comboDocumentacion''''] == DDSiNo.SI ? ''''conDocumentacion'''' : ''''sinDocumentacion''''', NULL, 0,    'Traslado de documentación detección de ocupantes', NULL,    NULL, NULL, 1, 'EXTTareaProcedimiento', 3,    NULL, NULL, NULL, NULL, NULL)
  ); 
  V_TMP_TIPO_TAP T_TIPO_TAP; 
      
  --Insertando valores en DD_PTP
  TYPE T_TIPO_PTP IS TABLE OF VARCHAR2(2048);
  TYPE T_ARRAY_PTP IS TABLE OF T_TIPO_PTP;
  V_TIPO_PTP T_ARRAY_PTP := T_ARRAY_PTP(
    t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo=''P419_ConfirmarVista'')', '1*24*60*60*1000L'),
	t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo=''P419_RevisarInformeLetrado'')', '5*24*60*60*1000L'),
	t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo=''P419_SolicitudRequerimientoDocOcupantes'')', '3*24*60*60*1000L'),
	t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo=''P419_RegistrarInformeSituacion'')', 'valores[''''P419_RegistrarRecepcionDoc''''] == null ? (5*24*60*60*1000L): (valores[''''P419_RegistrarRecepcionDoc''''][''''FechaRecepcion''''] == null ? (5*24*60*60*1000L) : (damePlazo(valores[''''P419_RegistrarRecepcionDoc ''''][''''fechaRecepcion''''])+20*24*60*60*1000L))'),
	t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo=''P419_TrasladoDocuDeteccionOcupantes'')', '3'),
	t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo=''P419_RegistrarRecepcionDoc'')', 'damePlazo(valores[''''P419_SolicitudRequerimientoDocOcupantes''''][''''fechaSolicitud''''])+20*24*60*60*1000L'),
	t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo=''P419_ResolucionFirme'')', 'damePlazo(valores[''''P419_RegistrarCelebracionVista''''][''''fechaResolucion''''])+5*24*60*60*1000L'),
	t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo=''P419_PresentarEscritoAlegaciones'')', '5*24*60*60*1000L'),
	t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo=''P419_RegistrarCelebracionVista'')', '1*24*60*60*1000L'),
	t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo=''P419_RegistrarResolucion'')', 'damePlazo(valores[''''P419_ConfirmarVista''''][''''fechaVista''''])+20*24*60*60*1000L')
); 
  V_TMP_TIPO_PTP T_TIPO_PTP; 
  
  --Insertando valores en DD_TFI
  TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(2048);
  TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
  V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_RegistrarRecepcionDoc'')', 0, 'label', 'titulo',    '	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por completada esta tarea deberá de consignar la fecha en que haya recibido la documentación solicitada a los ocupantes.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Los campos Fecha vista y Fecha fin para alegaciones deberá de consignarlos en caso de ya disponer de dicha información.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene ésta pantalla se lanzará la tarea "Registrar informe de situación".</p></div>', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_RegistrarInformeSituacion'')', 1, 'date', 'fecha',    'Fecha', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_RegistrarRecepcionDoc'')', 1, 'date', 'fecha',    'Fecha', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_RegistrarRecepcionDoc'')', 3, 'date', 'fechaFinAle',    'Fecha fin alegaciones', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_RegistrarInformeSituacion'')', 2, 'combo', 'comboResultado',    'Resultado', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', NULL, 'DDPositivoNegativo'),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_RegistrarCelebracionVista'')', 1, 'date', 'fechaResolucion',    'Fecha resolucion', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_ConfirmarVista'')', 0, 'label', 'titulo',    '	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través de esta tarea debe confirmar si hay vista o no, en caso de haberla deberá de consignar la fecha de celebración de la misma.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene ésta pantalla se lanzará la tarea, en caso de haber vista "Registrar vista" y en caso contrario "Registrar resolución".</p></div>', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_ResolucionFirme'')', 0, 'label', 'titulo',    '	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través de esta pantalla deberá consignar la fecha en la que la Resolución adquiere firmeza.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene ésta pantalla y en caso de haber obtenido una resolución desfavorable y no venir de un trámite de posesión se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad. En caso contrario se dará por terminada la actuación.</p></div>', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_TrasladoDocuDeteccionOcupantes'')', 6, 'date', 'fechaVista',    'Fecha vista', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_RevisarInformeLetrado'')' , 3, 'textarea', 'observaciones',    'Observaciones', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_PresentarEscritoAlegaciones'')', 1, 'date', 'fechaPresentacion',    'Fecha presentación', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_RegistrarCelebracionVista'')', 2, 'textarea', 'observaciones',    'Observaciones', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_ResolucionFirme'')', 2, 'textarea', 'observaciones',    'Observaciones', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_PresentarEscritoAlegaciones'')', 0, 'label', 'titulo',    '	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través de esta pantalla deberá de consignar la fecha en que haya presentado las alegaciones en el juzgado. En el campo fecha vista deberá consignar, si procede, la fecha en que ha quedado señalada la vista.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene ésta pantalla se lanzará la tarea "Confirmar vista".</p></div>', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_TrasladoDocuDeteccionOcupantes'')', 1, 'combo', 'comboOcupado',    'Bien ocupado', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', NULL, 'DDSiNo'),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_TrasladoDocuDeteccionOcupantes'')', 7, 'date', 'fechaFinAle',    'Fecha fin alegaciones', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_TrasladoDocuDeteccionOcupantes'')', 8, 'textarea', 'observaciones',    'Observaciones', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_RegistrarRecepcionDoc'')', 4, 'textarea', 'observaciones',    'Observaciones', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_ConfirmarVista'')', 2, 'date', 'fechaVista',    'Fecha vista', NULL, NULL, 'valores[''''P419_RegistrarRecepcionDoc''''][''''fechaVista''''] == null ? (valores[''''P419_TrasladoDocuDeteccionOcupantes''''][''''fechaVista'''']) : valores[''''P419_RegistrarRecepcionDoc''''][''''fechaVista'''']', NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_RegistrarResolucion'')', 1, 'date', 'fechaResolucion',    'Fecha resolucion', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_ResolucionFirme'')', 1, 'date', 'fechaResolucion',    'Fecha resolucion', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_RevisarInformeLetrado'')', 0, 'label', 'titulo',    '	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través de esta tarea se le informa de que dispone en la pestaña adjuntos del procedimiento, del informe de situación de la posesión propuesta por el letrado respecto al bien afecto. En el campo Resultado deberá indicar su aprobación o no de dicho informe.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo Fecha deberá consignar la fecha en que da por finalizada la revisión del informe propuesto por el letrado. </p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene ésta pantalla y dependiendo de los datos introducidos se podrán lanzar las siguientes tareas:	En caso de haber indicado que el informe requiere de modificaciones se lanzará la tarea "Registrar informe de situación" al letrado.	En caso de no requerir modificación el informe propuesto por el letrado y de que se haya indicado anteriormente que se deben presentar alegaciones, se lanzará la tarea "Presentar escrito de alegaciones" al letrado.	En caso de no requerir modificación el informe propuesto por el letrado y de que se haya indicado anteriormente que hay vista señalada, se lanzará la tarea "Registrar celebración de la vista".	En caso de no requerir modificación el informe propuesto por el letrado, de que no haya que presentar alegaciones y que no se haya fijado fecha para la vista, se lanzará la tarea "Confirmar vista" al letrado.</p></div>', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_TrasladoDocuDeteccionOcupantes'')', 2, 'combo', 'comboDocumentacion',    'Documentacion', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', NULL, 'DDSiNo'),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_RevisarInformeLetrado'')', 1, 'date', 'fecha',    'Fecha', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_ConfirmarVista'')', 3, 'textarea', 'observaciones',    'Observaciones', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_RegistrarCelebracionVista'')', 0, 'label', 'titulo',    '	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Después de celebrada la vista, en esta pantalla debemos de consignar la fecha en la que se ha celebrado. </p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; "> En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene ésta pantalla se lanzará la tarea "Registrar resolución"</p></div>', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_TrasladoDocuDeteccionOcupantes'')', 3, 'combo', 'comboInquilino',    'Existe algún inquilino', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', NULL, 'DDSiNo'),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_TrasladoDocuDeteccionOcupantes'')', 4, 'date', 'fechaContrato',    'Fecha contrato arrendamiento', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_SolicitudRequerimientoDocOcupantes'')', 2, 'textarea', 'observaciones',    'Observaciones', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_RegistrarInformeSituacion'')', 3, 'textarea', 'observaciones',    'Observaciones', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_RevisarInformeLetrado'')', 2, 'combo', 'comboResultado',    'Resultado', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', NULL, 'DDResultadoInforme'),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_PresentarEscritoAlegaciones'')', 3, 'textarea', 'observaciones',    'Observaciones', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_RegistrarResolucion'')', 3, 'textarea', 'observaciones',    'Observaciones', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_RegistrarInformeSituacion'')', 0, 'label', 'titulo',    '	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por completada esta tarea deberá adjuntar al procedimiento el informe de situación de los ocupantes según el formato establecido por la entidad. Una vez adjuntado el informe deberá consignar el resultado de dicho informe, ya sea positivo o no para los intereses de la entidad y la fecha en que haya dado por finalizada la preparación del informe.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene ésta pantalla se lanzará la tarea "Revisar informe de letrado".</p></div>', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_PresentarEscritoAlegaciones'')', 2, 'date', 'fechaVista',    'Fecha vista', NULL, NULL, 'valores[''''P419_RegistrarRecepcionDoc''''][''''fechaVista''''] == null ? (valores[''''P419_TrasladoDocuDeteccionOcupantes''''][''''fechaVista'''']) : valores[''''P419_RegistrarRecepcionDoc''''][''''fechaVista'''']', NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_RegistrarResolucion'')', 0, 'label', 'titulo',    '	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En ésta pantalla se deberá de consignar la fecha de notificación de la Resolución que hubiere recaído como consecuencia del juicio celebrado. Se indicará si el resultado de dicha resolución ha sido favorable para los intereses de la entidad o no.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para el supuesto de que la resolución no fuere favorable para la entidad, deberá comunicar dicha circunstancia al responsable interno de la misma a través del botón "Comunicación". Una vez reciba la aceptación del supervisor deberá gestionar el recurso por medio de la pestaña "Recursos".</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para el supuesto de anuncio del recurso por la parte contraria se deberá gestionar directamente a través de la pestaña "Recursos".</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene ésta pantalla la siguiente tarea será "Resolución firme"</p></div>', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_TrasladoDocuDeteccionOcupantes'')', 5, 'text', 'nombreArrendatario',    'Nombre arrendatario', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 'dameNumAuto()', NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_SolicitudRequerimientoDocOcupantes'')', 0, 'label', 'titulo',    '	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través de esta tarea deberá consignar la fecha en que haya solicitado el requerimiento de documentación a los ocupantes.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene ésta pantalla se lanzará la tarea "Registrar recepción de la documentación".</p></div>', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_SolicitudRequerimientoDocOcupantes'')', 1, 'date', 'fechaSolicitud',    'Fecha solicitud', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_RegistrarRecepcionDoc'')', 2, 'date', 'fechaVista',    'Fecha vista', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_TrasladoDocuDeteccionOcupantes'')', 0, 'label', 'titulo',    '	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por completada esta tarea deberá de haber un bien vinculado al procedimiento, esto podrá comprobarlo a través de la pestaña Bienes del procedimiento, en caso de no haberlo, a través de esa misma pestaña dispone de la opción de Agregar por la cual se le permite vincular un bien al procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través de esta pantalla deberá confirmar si el bien se encuentra ocupado o no, si dispone de la documentación de detección de ocupantes, en caso afirmativo, deberá indicar si existe o no inquilino y en tal caso la fecha del contrato de arrendamiento y el nombre del arrendatario. </p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Los campos Fecha vista y Fecha fin para alegaciones deberá de consignarlos en caso de ya disponer de dicha información.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene ésta pantalla en caso de no disponer de la documentación de detección se lanzará la tarea "Solicitud de requerimiento documentación a ocupantes", en caso contrario se lanzará la tarea "Realizar alegaciones".</p></div>', NULL, NULL, NULL, NULL),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_ConfirmarVista'')', 1, 'combo', 'comboVista',    'Vista', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', NULL, 'DDSiNo'),
	t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P419_RegistrarResolucion'')', 2, 'combo', 'comboResultado',    'Resultado', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', NULL, 'DDPositivoNegativo')
	); 
  V_TMP_TIPO_TFI T_TIPO_TFI; 
  
BEGIN 
    
    -- 1) LOOP Insertando valores en DD_TPO_TIPO_PROCEDIMIENTO
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO... Empezando a insertar datos en el diccionario');
    FOR I IN V_TIPO_TPO.FIRST .. V_TIPO_TPO.LAST
      LOOP
        V_TMP_TIPO_TPO := V_TIPO_TPO(I);
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
        -- Comporbamos el dato
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
                      ''''||TRIM(V_TMP_TIPO_TAP(5)) || ''','''||TRIM(V_TMP_TIPO_TAP(6))||''','''||TRIM(V_TMP_TIPO_TAP(7))||''','''||TRIM(V_TMP_TIPO_TAP(8))||''','''||TRIM(V_TMP_TIPO_TAP(9))||''','||
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
                       DBMS_OUTPUT.PUT_LINE(V_MSQL);
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