--/*
--##########################################
--## Author: Equipo Fase II - Bankia
--## Adaptado a BP : Óscar Dorado
--## Finalidad: DML del trámite moratoria
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
    t_tipo_tpo('P418', 'Trámite de moratoria de lanzamiento', 'Trámite de moratoria de lanzamiento',     NULL, 'tramiteMoratoriaLanzamiento', 8, NULL, NULL, 1, 'MEJTipoProcedimiento',     1, 1)
  ); 
  V_TMP_TIPO_TPO T_TIPO_TPO; 
  
  --Insertando valores en DD_TAP
  TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(5024);
  TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
  V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
          t_tipo_tap( '(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P418'')', 'P418_CelebracionVista', NULL,     NULL, NULL, NULL, NULL, 0,     'Celebración vista', NULL,     'tareaExterna.cancelarTarea', 5, 1, 'EXTTareaProcedimiento', 3,     2, 39, NULL, NULL, NULL),
          t_tipo_tap( '(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P418'')', 'P418_LecturaInstruccionesMoratoria', NULL ,   NULL, NULL, 'valores[''''P418_RegistrarAdmisionYEmplazamiento''''][''''comboVista''''] == DDPositivoNegativo.POSITIVO ? ''''HayVista'''' : valores[''''P418_RevisarInformeLetradoMoratoria''''][''''comboConformidad''''] == DDPositivoNegativo.POSITIVO ? ''''PresentarConformidad'''' : ''''NoHayVista''''', NULL, 0,    'Lectura de instrucciones moratoria', NULL,    'tareaExterna.cancelarTarea', 5, 1, 'EXTTareaProcedimiento', 3,    2, 39, NULL, NULL, NULL),
          t_tipo_tap( '(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P418'')', 'P418_PresentarConformidadMoratoria', NULL,    NULL, NULL, NULL, NULL, 0,    'Presentar conformidad a moratoria', NULL,    'tareaExterna.cancelarTarea', 5, 1, 'EXTTareaProcedimiento', 3,    2, 39, NULL, NULL, NULL),
          t_tipo_tap( '(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P418'')', 'P418_RegistrarAdmisionYEmplazamiento', 'plugin/procedimientos/tramiteMoratoria/registrarAdmisionYEmplazamiento' ,   NULL, NULL, NULL, NULL, 0,    'Registrar admisión y emplazamiento', NULL,    'tareaExterna.cancelarTarea', 5, 1, 'EXTTareaProcedimiento', 3,    2, 39, NULL, NULL, NULL),
          t_tipo_tap( '(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P418'')', 'P418_RegistrarInformeMoratoria', NULL,    NULL, NULL, NULL, NULL, 0,'Registar informe a moratoria', NULL ,   'tareaExterna.cancelarTarea', 5, 1, 'EXTTareaProcedimiento', 3,    2, 39, NULL, NULL, NULL),
          t_tipo_tap( '(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P418'')', 'P418_RegistrarResolucion', 'plugin/procedimientos/tramiteMoratoria/registrarResolucion',    NULL, NULL, 'valores[''''P418_RegistrarResolucion''''][''''comboFavDesf''''] == DDFavorable.FAVORABLE ? ''''Favorable'''' : ''''Desfavorable''''', NULL, 0,    'Registrar resolución', NULL,    'tareaExterna.cancelarTarea', 5, 1, 'EXTTareaProcedimiento', 3,    2, 39, NULL, NULL, NULL),
          t_tipo_tap( '(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P418'')', 'P418_RegistrarSolicitudMoratoria', NULL,    'comprobarBienAsociadoPrc() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>!Atenci&oacute;n! Para dar por completada esta tarea deber&aacute; vincular un bien al procedimiento.</p></div>''''', NULL, NULL, NULL, 0  ,  'Registrar solicitud de moratoria', NULL,    'tareaExterna.cancelarTarea', 5, 1, 'EXTTareaProcedimiento', 3 ,   2, 39, NULL, NULL, NULL),
          t_tipo_tap( '(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P418'')', 'P418_RevisarInformeLetradoMoratoria', NULL ,   NULL, NULL, NULL, NULL, 0,    'Revisar informe letrado moratoria', NULL,   'tareaExterna.cancelarTarea', 5, 1, 'EXTTareaProcedimiento', 3,    3, 40, NULL, NULL, NULL),
          t_tipo_tap( '(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P418'')', 'P418_SolicitarInstrucciones', NULL,    NULL, NULL, NULL, NULL, 0 ,   'Solicitar instrucciones', NULL,    'tareaExterna.cancelarTarea', 5, 1, 'EXTTareaProcedimiento', 3,    2, 39, NULL, NULL, NULL),
          t_tipo_tap( '(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P418'')', 'P418_nodoEsperaController', NULL,   NULL, NULL, 'estamosADosMeses() ? ''''solicita'''' : ''''espera''''', NULL, 0,    'Nodo espera 1', NULL,    NULL, 1, 1, 'EXTTareaProcedimiento', 3,    NULL, 39, NULL, NULL, NULL)
      ); 
  V_TMP_TIPO_TAP T_TIPO_TAP; 
  
  --Insertando valores en DD_PTP
  TYPE T_TIPO_PTP IS TABLE OF VARCHAR2(2048);
  TYPE T_ARRAY_PTP IS TABLE OF T_TIPO_PTP;
  V_TIPO_PTP T_ARRAY_PTP := T_ARRAY_PTP(
    t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P418_RevisarInformeLetradoMoratoria'')', '1*24*60*60*1000L'),
    t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P418_CelebracionVista'')', 'damePlazo(valores[''''P418_RegistrarAdmisionYEmplazamiento''''][''''fechaSenyalamiento''''])'),
    t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P418_RegistrarAdmisionYEmplazamiento'')', 'damePlazo(valores[''''P418_RegistrarSolicitudMoratoria''''][''''fechaSolicitud'''']) + 5*24*60*60*1000L'),
    t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P418_PresentarConformidadMoratoria'')', '5*24*60*60*1000L'),
    t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P418_RegistrarInformeMoratoria'')', 'damePlazo(valores[''''P418_RegistrarAdmisionYEmplazamiento''''][''''fechaNotificacion'''']) + 1*24*60*60*1000L'),
    t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P418_LecturaInstruccionesMoratoria'')', '1*24*60*60*1000L'),
    t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P418_RegistrarResolucion'')', 'damePlazo(valores[''''P418_RegistrarAdmisionYEmplazamiento''''][''''fechaSenyalamiento''''])'),
    t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P418_SolicitarInstrucciones'')', '60*24*60*60*1000L'),
    t_tipo_ptp('(select tap_id from tap_tarea_procedimiento where tap_codigo =''P418_RegistrarSolicitudMoratoria'')', '5*24*60*60*1000L')
  ); 
  V_TMP_TIPO_PTP T_TIPO_PTP; 
  
  --Insertando valores en DD_TFI
  TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(2048);
  TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
  V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P418_RegistrarSolicitudMoratoria'')', 2, 'date', 'fechaFinMoratoria','Fecha fin de moratoria', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P418_LecturaInstruccionesMoratoria'')', 2, 'textarea', 'presentarAlegaciones','Presentar alegaciones', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P418_RegistrarResolucion'')', 1, 'date', 'fechaResolucion','Fecha resolución', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P418_RegistrarResolucion'')', 2, 'combo', 'comboFavDesf','Resultado', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', NULL, 'DDFavorable'),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P418_RegistrarSolicitudMoratoria'')', 1, 'date', 'fechaSolicitud','Fecha de solicitud', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P418_RegistrarSolicitudMoratoria'')', 3, 'textarea', 'observaciones','Observaciones', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P418_LecturaInstruccionesMoratoria'')', 0, 'label', 'titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A trav&eacute;s de esta tarea deber&aacute; de leer las instrucciones dictadas por la entidad respecto a la moratoria.</p><p>Una vez acepte las instrucciones y en funci&oacute;n de los datos introducidos en tareas anteriores, la siguiente tarea ser&aacute; &ldquo;Celebraci&oacute;n de la vista&rdquo;, &ldquo;Registrar resoluci&oacute;n&rdquo; o &ldquo;Presentar escrito de conformidad&rdquo;</p></div>', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P418_PresentarConformidadMoratoria'')', 1, 'date', 'fechaPresentacion','Fecha presentación', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P418_SolicitarInstrucciones'')', 0, 'label', 'titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Dado que restan dos meses para que expire la fecha de moratoria dictaminada, a trav&eacute;s de esta tarea se le informa de que debe obtener instrucciones por parte de la entidad a este respecto.</p><p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p>Una vez termine esta tarea se lanzara una toma de decisi&oacute;n por la cual debe indicar la siguiente actuaci&oacute;n a realiza</p></div>', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P418_SolicitarInstrucciones'')', 2, 'textarea', 'observaciones','Observaciones', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P418_RegistrarSolicitudMoratoria'')', 0, 'label', 'titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por completada esta tarea deber&aacute; de haber un bien vinculado al procedimiento, esto podr&aacute; comprobarlo a trav&eacute;s de la pesta&ntilde;a Bienes del procedimiento, en caso de no haberlo, a trav&eacute;s de esa misma pesta&ntilde;a dispone de la opci&oacute;n  de Agregar por la cual se le permite vincular un bien al procedimiento.</p><p>En el campo &ldquo;Fecha solicitud&rdquo; deber&aacute; de consignar la fecha en la que se haya producido la solicitud de la moratoria.</p><p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p>Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute; &quot;Registrar admisi&oacute;n y emplazamiento&quot;.</p></div>', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P418_RegistrarResolucion'')', 0, 'label', 'titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deber&aacute; consignar el resultado que se haya dado, ya sea favorable para los intereses de la entidad o no, y solo en caso de haber sido desfavorable la fecha de fin de la moratoria.</p><p>Para el supuesto de que la resoluci&oacute;n no fuere favorable para la entidad, deber&aacute; comunicar dicha circunstancia al responsable interno de la misma a trav&eacute;s del bot&oacute;n &quot;Comunicaci&oacute;n&quot;. Una vez reciba la aceptaci&oacute;n del supervisor deber&aacute; gestionar el recurso por medio de la pesta&ntilde;a &quot;Recursos&quot;.</p><p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p>Una vez rellene &eacute;sta pantalla en caso de resoluci&oacute;n favorable para los intereses de la entidad se dar&aacute; por terminada esta actuaci&oacute;n continuando as&iacute; con la actuaci&oacute;n anterior, en caso contrario el sistema esperar&aacute; hasta 2 meses antes del fin de la moratoria para lanzar la tarea &ldquo;Solicitar instrucciones&rdquo;.</p></div>', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P418_CelebracionVista'')', 1, 'date', 'fechaCelebracion','Fecha celebración', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P418_RegistrarResolucion'')', 4, 'textarea', 'observaciones','Observaciones', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P418_RegistrarAdmisionYEmplazamiento'')', 2, 'combo', 'comboAdminEmplaza','Admisión y emplazamiento', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', NULL, 'DDSiNo'),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P418_RegistrarInformeMoratoria'')', 1, 'textarea', 'informeMoratoria','Informe moratoria', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P418_RegistrarAdmisionYEmplazamiento'')', 1, 'date', 'fechaNotificacion','Fecha de notificación', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P418_RegistrarAdmisionYEmplazamiento'')', 3, 'combo', 'comboVista','Vista', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', NULL, 'DDSiNo'),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P418_RegistrarAdmisionYEmplazamiento'')', 0, 'label', 'titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deber&aacute; consignar la fecha de notificaci&oacute;n de la moratoria, si ha habido admisi&oacute;n o no de la solicitud de moratoria, en caso de haber, indicar si hay vista o no y por &uacute;ltimo la fecha de se&ntilde;alamiento de la misma.</p><p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p>Una vez rellene esta pantalla la siguiente tarea ser&aacute; &rdquo;Registrar informe moratoria&rdquo;.</p></div>', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P418_RegistrarAdmisionYEmplazamiento'')', 4, 'date', 'fechaSenyalamiento','Fecha señalamiento', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P418_RevisarInformeLetradoMoratoria'')', 3, 'combo', 'comboConformidad','Presentar conformidad', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', NULL, 'DDSiNo'),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P418_LecturaInstruccionesMoratoria'')', 1, 'textarea', 'instruccionesMoratoria','Instrucciones moratoria', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 'valores[''''P418_RegistrarInformeMoratoria''''] == null ? '''' : ( valores[''''P418_RevisarInformeLetradoMoratoria''''][''''instruccionesMoratoria''''] )', NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P418_RegistrarResolucion'')', 3, 'date', 'fechaFinMoratoria','Fecha fin de moratoria', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P418_RegistrarAdmisionYEmplazamiento'')', 5, 'textarea', 'observaciones','Observaciones', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P418_RegistrarInformeMoratoria'')', 0, 'label', 'titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A trav&eacute;s de esta pantalla deber&aacute; dejar constancia si la moratoria solicitada por el deudor es acorde con lo establecido por la ley y por tanto es mejor presentar el escrito de conformidad a la moratoria, o si por el contrario se aprecia disconformidad a la ley y por tanto aconseja presentarse a la vista.</p><p>Una vez complete esta pantalla la siguiente tarea ser&aacute; &ldquo;Revisar informe letrado moratoria&rdquo; por la cual se mostrar&aacute; su informe al supervisor de la entidad para que dicte instrucciones.</p></div>', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P418_RevisarInformeLetradoMoratoria'')', 0, 'label', 'titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A trav&eacute;s de esta tarea deber&aacute; revisar el informe realizado por el letrado sobre la moratoria presentada por el demandado. En el campo Instrucciones deber&aacute; introducir las instrucciones a realizar por el letrado respecto a la moratoria. </p><p>En el campo &ldquo;Presentar conformidad&rdquo; deber&aacute; indicar si el letrado debe presentar el escrito de conformidad a la moratoria o no.</p><p>Una vez rellene esta pantalla la siguiente tarea ser&aacute; &rdquo;Lectura instrucciones moratoria&rdquo;.</p></div>', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P418_RevisarInformeLetradoMoratoria'')', 1, 'textarea', 'informeMoratoria','Informe moratoria', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 'valores[''''P418_RegistrarInformeMoratoria''''] == null ? '''' : ( valores[''''P418_RegistrarInformeMoratoria''''][''''informeMoratoria''''] )', NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P418_RevisarInformeLetradoMoratoria'')', 2, 'textarea', 'instruccionesMoratoria','Instrucciones moratoria', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P418_PresentarConformidadMoratoria'')', 0, 'label', 'titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Dado que la entidad ha decidido presentar el escrito de conformidad a la moratoria, a trav&eacute;s de esta tarea deber&aacute; de consignar la fecha de presentaci&oacute;n de dicho escrito.</p><p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p>Una vez rellene esta pantalla la siguiente tarea ser&aacute; &rdquo;Registrar resoluci&oacute;n&rdquo;. </p></div>', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P418_PresentarConformidadMoratoria'')', 2, 'textarea', 'observaciones','Observaciones', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P418_CelebracionVista'')', 0, 'label', 'titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deber&aacute; dejar indicada la fecha de celebraci&oacute;n de la vista, en caso de que no se hubiere celebrado deber&aacute; dejar en blanco la fecha de celebraci&oacute;n.</p><p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p>Una vez rellene &eacute;sta pantalla se lanzar&aacute; la tarea &ldquo;Registrar resoluci&oacute;n&rdquo;.</p></div>', NULL, NULL, NULL, NULL),
    t_tipo_tfi('(select tap_id from tap_tarea_procedimiento where tap_codigo = ''P418_SolicitarInstrucciones'')', 1, 'date', 'fechaInstrucciones','Fecha instrucciones', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', NULL, NULL)
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
            --  DBMS_OUTPUT.PUT_LINE(V_MSQL);
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