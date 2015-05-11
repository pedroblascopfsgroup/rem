--/*
--##########################################
--## Author: Óscar
--## Finalidad: DML
--##            
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script. 

BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO]');


execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set dd_sta_id = (select dd_sta_id from '||V_ESQUEMA_M||'.dd_sta_subtipo_tarea_base where dd_sta_codigo = ''101'') where dd_tpo_id = (select dd_tpo_id from '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P415'')';

execute immediate 'update '||V_ESQUEMA||'.tfi_Tareas_form_items set tfi_label = ''Titulizado'' where tfi_nombre = ''comboTitularizado'' and tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P410_RealizacionCesionRemate'')';

execute immediate 'update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = null, tfi_error_validacion = null where tfi_nombre = ''fechaAudiencia'' and tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P03_ConfirmarOposicion'' and dd_tpo_id = (select dd_tpo_id from '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P03''))';

--INC 94
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion_jbpm = ''((valores[''''P03_ConfirmarOposicion''''][''''comboResultado''''] == DDSiNo.SI) && ((valores[''''P03_ConfirmarOposicion''''][''''fechaOposicion''''] == null) || (valores[''''P03_ConfirmarOposicion''''][''''fechaAudiencia''''] == null)))?''''Debe introducir la fecha de oposición y fecha de audiencia'''':null'' where tap_codigo = ''P03_ConfirmarOposicion'' and dd_tpo_id = (select dd_tpo_id from '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P03'')';

--INC 116
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion_jbpm = ''((valores[''''P401_SenyalamientoSubasta''''][''''principal'''']).toDouble() >= ((valores[''''P401_SenyalamientoSubasta''''][''''costasLetrado'''']).toDouble())) ? ''''null'''' :  ''''<p>&iexcl;Atenci&oacute;n! Las costas del letrado no pueden superar el 5% del principal.</p>'''''' where tap_codigo = ''P401_SenyalamientoSubasta''';

--INC 108
execute immediate 'update '||V_ESQUEMA||'.dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = ''5*24*60*60*1000L'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P406_RegistrarPublicacionSolArticulo'')';
execute immediate 'update '||V_ESQUEMA||'.dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = ''5*24*60*60*1000L'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P406_RegistrarAperturaNegociaciones'')';
execute immediate 'update '||V_ESQUEMA||'.dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = ''60*24*60*60*1000L'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P406_RegistrarPropuestaAcuerdo'')';
execute immediate 'update '||V_ESQUEMA||'.dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = ''10*24*60*60*1000L'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P406_AceptarPropuestaAcuerdo'')';
execute immediate 'update '||V_ESQUEMA||'.dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = ''2*24*60*60*1000L'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P406_LecturaAceptacionInstrucciones'')';
execute immediate 'update '||V_ESQUEMA||'.dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = ''2*24*60*60*1000L'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P406_RegistrarResultadoAcuerdo'')';
execute immediate 'update '||V_ESQUEMA||'.dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = ''15*24*60*60*1000L'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P406_RegistrarResHomologacionJudicial'')';
execute immediate 'update '||V_ESQUEMA||'.dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = ''damePlazo(valores[''''P406_RegistrarResHomologacionJudicial''''][''''fecha'''']) + 1*24*60*60*1000L'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P406_RegistrarEntradaEnVigor'')';
execute immediate 'update '||V_ESQUEMA||'.dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = ''5*24*60*60*1000L'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P406_BPMTramiteDemandaIncidental'')';

--INC 109
execute immediate 'update '||V_ESQUEMA||'.dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = ''3*24*60*60*1000L'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P412_RegistrarPublicacionBOE'')';
execute immediate 'update '||V_ESQUEMA||'.dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = ''damePlazo(valores[''''P412_RegistrarPublicacionBOE''''][''''fecha'''']) + 15*24*60*60*1000L'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P412_RegistrarInsinuacionCreditos'')';
execute immediate 'update '||V_ESQUEMA||'.dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = ''damePlazo(valores[''''P412_RegistrarPublicacionBOE''''][''''fecha'''']) + 22*24*60*60*1000L'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P412_RevisarInsinuacionCreditos'')';
execute immediate 'update '||V_ESQUEMA||'.dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = ''damePlazo(valores[''''P412_RegistrarPublicacionBOE''''][''''fecha'''']) + 28*24*60*60*1000L'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P412_PresentarEscritoInsinuacion'')';
execute immediate 'update '||V_ESQUEMA||'.dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = ''damePlazo(valores[''''P412_RegistrarPublicacionBOE''''][''''fecha'''']) + 60*24*60*60*1000L'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P412_RegistrarProyectoInventario'')';
execute immediate 'update '||V_ESQUEMA||'.dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = ''damePlazo(valores[''''P412_RegistrarProyectoInventario''''][''''fechaComunicacion'''']) + 7*24*60*60*1000L'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P412_PresentarRectificacion'')';
execute immediate 'update '||V_ESQUEMA||'.dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = ''damePlazo(valores[''''P412_RegistrarProyectoInventario''''][''''fechaComunicacion'''']) + 10*24*60*60*1000L'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P412_RegistrarInformeAdmonConcursal'')';
execute immediate 'update '||V_ESQUEMA||'.dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = ''damePlazo(valores[''''P412_RegistrarInformeAdmonConcursal''''][''''fecha'''']) + 2*24*60*60*1000L'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P412_RevisarResultadoInfAdmon'')';
execute immediate 'update '||V_ESQUEMA||'.dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = ''damePlazo(valores[''''P412_RegistrarInformeAdmonConcursal''''][''''fecha'''']) + 7*24*60*60*1000L'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P412_ValidarAlegaciones'')';
execute immediate 'update '||V_ESQUEMA||'.dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = ''1*24*60*60*1000L'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P412_ActualizarEstadoCreditos'')';
execute immediate 'update '||V_ESQUEMA||'.dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = ''180*24*60*60*1000L'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P412_RegistrarResolucionFaseComun'')';

--INC 80
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_view = ''plugin/procedimientos/genericFormOverSize'' where tap_codigo = ''P413_notificacionDecretoAdjudicacionAEntidad''';

--INC 87
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_evitar_reorg = 1 where dd_tpo_id = (select dd_tpo_id from '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento where dd_tpo_codigo =''P401'') and tap_codigo <> ''P401_SolicitudSubasta''';
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_evitar_reorg = 1 where dd_tpo_id = (select dd_tpo_id from '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento where dd_tpo_codigo =''P409'') and tap_codigo <> ''P409_SolicitudSubasta''';
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_evitar_reorg = 1 where dd_tpo_id = (select dd_tpo_id from '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento where dd_tpo_codigo =''P413'') and tap_codigo <> ''P413_SolicitudDecretoAdjudicacion''';
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_evitar_reorg = 1 where dd_tpo_id = (select dd_tpo_id from '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento where dd_tpo_codigo =''P416'') and tap_codigo <> ''P416_RegistrarSolicitudPosesion''';
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_evitar_reorg = 1 where dd_tpo_id = (select dd_tpo_id from '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento where dd_tpo_codigo =''P417'') and tap_codigo <> ''P417_RegistrarCambioCerradura''';
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_evitar_reorg = 1 where dd_tpo_id = (select dd_tpo_id from '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento where dd_tpo_codigo =''P419'') and tap_codigo <> ''P419_TrasladoDocuDeteccionOcupantes''';
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_evitar_reorg = 1 where dd_tpo_id = (select dd_tpo_id from '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento where dd_tpo_codigo =''P418'') and tap_codigo <> ''P418_RegistrarSolicitudMoratoria''';
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_evitar_reorg = 1 where dd_tpo_id = (select dd_tpo_id from '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento where dd_tpo_codigo =''P415'') and tap_codigo <> ''P415_RevisarEstadoCargas''';



--INC 89
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_view = ''plugin/procedimientos/genericFormOverSize'' where tap_codigo = ''P401_PrepararCesionRemate''';
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_view = ''plugin/procedimientos/genericFormOverSize'' where tap_codigo = ''P409_PrepararCesionRemate''';
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_view = ''plugin/procedimientos/genericFormOverSize'' where tap_codigo = ''P401_AprobacionPropCesionRemate''';
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_view = ''plugin/procedimientos/genericFormOverSize'' where tap_codigo = ''P409_AprobacionPropCesionRemate''';

--INC 76
execute immediate 'update tap_tarea_procedimiento set tap_descripcion = ''Validar asignación de letrado y procurador'' where tap_codigo = ''P404_ValidarAsignacionLetrado''';
execute immediate 'update tfi_tareas_form_items set tfi_label =''Fecha validación'' where tfi_nombre = ''fechaValidacion'' and tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = ''P404_ValidarAsignacionLetrado'')';
execute immediate 'update tfi_tareas_form_items set tfi_label =''Asignación correcta'' where tfi_nombre = ''decisionAsignacion'' and tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = ''P404_ValidarAsignacionLetrado'')';
execute immediate 'update tfi_tareas_form_items set tfi_label =''Observaciones'' where tfi_nombre = ''observacionesAsignacion'' and tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = ''P404_ValidarAsignacionLetrado'')';

--INC 118
execute immediate 'update tfi_tareas_form_items set tfi_validacion = null, tfi_error_validacion = null where tfi_nombre in (''fechaTestimonio'',''fechaEnvioGestoria'') and tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = ''P413_ConfirmarTestimonio'')';
execute immediate 'update tap_tarea_procedimiento set tap_script_validacion_jbpm = ''valores[''''P413_ConfirmarTestimonio''''][''''comboSubsanacion''''] == DDSiNo.SI ? ''''null'''' : ((valores[''''P413_ConfirmarTestimonio''''][''''fechaTestimonio''''] == null || valores[''''P413_ConfirmarTestimonio''''][''''fechaEnvioGestoria''''] == null) ? ''''Las fechas testimonio y envio gestoría son obligatorias'''' : ''''null'''')'' where tap_codigo = ''P413_ConfirmarTestimonio''';

--INC 73
DBMS_OUTPUT.PUT_LINE('[INICIO] FUNCION ROLE_VER_TAB_DOCUMENTOS'); 
    V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''ROLE_VER_TAB_DOCUMENTOS''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := 'Insert into '||V_ESQUEMA_M||'.FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values ('||V_ESQUEMA_M||'.s_fun_funciones.nextval, ''Permite ver tab documentos'', ''ROLE_VER_TAB_DOCUMENTOS'', 0, ''DD'', SYSDATE, 0)';
      EXECUTE IMMEDIATE V_SQL ;
    END IF ;  
    

--INC 103
execute immediate 'ALTER MATERIALIZED VIEW '||V_ESQUEMA||'.V_BUSQUEDA_ASUNTOS_FILTRO_AGEN REFRESH COMPLETE START WITH TRUNC(SYSDATE) + 8/24 next(sysdate+30/1440)';  
    

--inc xx
execute immediate 'update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_label = ''<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea, deberá acceder a la pestaña Subastas del asunto correspondiente y asociar uno o más bienes a la subasta que corresponda. Una vez agregados los bienes a la subasta deberá indicar a través de la ficha de cada bien las cargas anteriores y posteriores, si es vivienda habitual o no y la situación posesoria. </p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En caso de que la subasta haya sito instada por terceros, deberá indicar dicha circunstancia en el campo "Solicitud de subasta por terceros" en este caso no será obligatorio introducir la Fecha de solicitud de la subasta.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo Fecha solicitud deberá consignar la fecha en la que haya realizado la solicitud de subasta.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzará la tarea "Señalamiento de subasta" a realizar por el letrado.</p></div>'' where tfi_nombre = ''titulo'' and tap_id in (SELECT tap_id FROM '||V_ESQUEMA||'.tap_tarea_procedimiento WHERE tap_codigo in (''P401_SolicitudSubasta'', ''P409_SolicitudSubasta''))';

execute immediate 'delete from '||V_ESQUEMA||'.tfi_tareas_form_items where tfi_nombre = ''comboMotivo'' and tap_id in (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo in (''P401_SuspenderSubasta'',''P409_SuspenderSubasta''))';

execute immediate 'update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_label = ''<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez se celebre la subasta, en esta pantalla debe introducir la siguiente informaci&oacute;n:</p><p>En el campo Celebrada deberá indicar si la subasta ha sido celebrada o no. En caso de haberse celebrado deberá indicar en cada uno de los bienes subastados el resultado de la subasta a través de los campos:
</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">    Entidad adjudicataria: donde deberá indicar si la adjudicación es a favor de la entidad, un fondo o un tercero.
</li><li style="margin-bottom: 10px; margin-left: 35px;">    Importe adjudicación: Importe por el cual se adjudica el bien.
</li><li style="margin-bottom: 10px; margin-left: 35px;">    Fondo: donde deberá indicar, en caso de adjudicación a fondo, el fondo que corresponda.
</li><li style="margin-bottom: 10px; margin-left: 35px;">    Cesión de remate: Donde indicar sí el bien es objeto de cesión de remate o no.</li></ul>
</p><p>En caso de suspensi&oacute;n de la subasta deber&aacute; indicar dicha circunstancia en el campo "Celebrada", en el campo "Decisi&oacute;n suspensi&oacute;n" deber&aacute; consignar quien ha provocado dicha suspensi&oacute;n y en el campo "Motivo suspensi&oacute;n" deber&aacute; indicar el motivo por el cual se ha suspendido.</p><p>En caso de haberse adjudicado alguno de los bienes la Entidad, deber&aacute; indicar si ha habido Postores o no en la subasta y en el campo Cesi&oacute;n deber&aacute; indicar si se debe cursar la cesi&oacute;n de remate o no, seg&uacute;n el procedimiento establecido por la entidad.</p><p>En caso de haber cesi&oacute;n del remate deber&aacute; indicar si es requerida la preparaci&oacute;n o no seg&uacute;n el procedimiento establecido por la Entidad.</p><p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p>Una vez rellene esta pantalla la siguiente tarea ser&aacute;:
</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">    En caso de haber indicado la suspensión de la subasta por decisión de terceros, se lanzará un nuevo trámite de subasta dando por finalizado el actual.
</li><li style="margin-bottom: 10px; margin-left: 35px;">    En caso de haberse suspendido la subasta por decisión de la entidad, se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.
</li><li style="margin-bottom: 10px; margin-left: 35px;">    En caso de haberse producido la subasta se lanzará la tarea "Registrar acta de subasta".
</li><li style="margin-bottom: 10px; margin-left: 35px;">    En caso de haberse producido la subasta,  haber marcado algún bien con cesión de remate y haber indicado que es necesaria la elevación de propuesta de cesión de remate se lanzará la tarea "Preparar cesión de remate" a realizar por el supervisor.
</li><li style="margin-bottom: 10px; margin-left: 35px;">    En caso de haberse producido la subasta,  haber marcado algún bien con cesión de remate y haber indicado que no es necesaria la elevación de propuesta de cesión de remate se iniciará el trámite de cesión de remate.
</li><li style="margin-bottom: 10px; margin-left: 35px;">    En caso de haber uno o más bienes adjudicados a un tercero se lanzará la tarea "Solicitar mandamiento de pago".
</li><li style="margin-bottom: 10px; margin-left: 35px;">    En caso de haber uno o más bienes  adjudicados a la entidad sin cesión de remate, se lanzará la tarea "Contabilizar archivo y cierre de deudas" y un trámite de adjudicación por cada uno de esos bienes.
</li></ul></div>'' where tfi_nombre = ''titulo'' and tap_id in (SELECT tap_id FROM '||V_ESQUEMA||'.tap_tarea_procedimiento WHERE tap_codigo in (''P401_CelebracionSubasta'', ''P409_CelebracionSubasta''))';


execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion_jbpm = ''valores[''''P401_CelebracionSubasta''''][''''comboCelebrada''''] == ''''02'''' ? (valores[''''P401_CelebracionSubasta''''][''''comboSuspension''''] == null ? ''''El campo suspensión es obligatorio'''' : (valores[''''P401_CelebracionSubasta''''][''''comboMotivo''''] == null ? ''''Campo motivo es obligatorio'''' : null )) : (valores[''''P401_CelebracionSubasta''''][''''comboPostores''''] == null ? ''''Campo postores es obligatorio'''' : (valores[''''P401_CelebracionSubasta''''][''''comboPostores''''] == ''''01'''' ? (valores[''''P401_CelebracionSubasta''''][''''comboComite''''] == null ? ''''Campo comité es obligatorio'''' : null) : null ))'' WHERE tap_codigo in (''P401_CelebracionSubasta'', ''P409_CelebracionSubasta'')';

execute immediate 'update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_label = ''<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deberá de adjuntar el acta de subasta al procedimiento correspondiente a través de la pestaña Adjuntos.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo fecha consignar la fecha en que da por terminada el acta de subasta y proceda a subirla a la plataforma.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>'' where tfi_nombre= ''titulo'' and tap_id in (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo in (''P401_RegistrarActaSubasta'',''P409_RegistrarActaSubasta'')) ';


--INC 87
DBMS_OUTPUT.PUT_LINE('[INICIO] FUNCION ROLE_VER_TAB_DOCUMENTOS'); 
    V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO WHERE DD_TFA_CODIGO= ''ADC''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := 'Insert into '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO (DD_TFA_ID, DD_TFA_CODIGO, DD_TFA_DESCRIPCION, DD_TFA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TAC_ID) values   (s_dd_tfa_fichero_adjunto.nextval, ''ADC'', ''Auto de declaración del Concurso'', ''Auto de declaración del Concurso'', 0, ''DML'', SYSDATE, 0, 3)';
      EXECUTE IMMEDIATE V_SQL ;
    END IF ;  
    


DBMS_OUTPUT.PUT_LINE('[INICIO] FUNCION ROLE_VER_TAB_DOCUMENTOS'); 
    V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO WHERE DD_TFA_CODIGO= ''ECC''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := 'Insert into DD_TFA_FICHERO_ADJUNTO (DD_TFA_ID, DD_TFA_CODIGO, DD_TFA_DESCRIPCION, DD_TFA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TAC_ID) values   (s_dd_tfa_fichero_adjunto.nextval, ''ECC'', ''Escrito de comunicación de créditos'', ''Escrito de comunicación de créditos'', 0, ''DML'', SYSDATE, 0, 3)';
      EXECUTE IMMEDIATE V_SQL ;
    END IF ;  
    
DBMS_OUTPUT.PUT_LINE('[INICIO] FUNCION ROLE_VER_TAB_DOCUMENTOS'); 
    V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO WHERE DD_TFA_CODIGO= ''IPAC''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := 'Insert into DD_TFA_FICHERO_ADJUNTO (DD_TFA_ID, DD_TFA_CODIGO, DD_TFA_DESCRIPCION, DD_TFA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TAC_ID) values   (s_dd_tfa_fichero_adjunto.nextval, ''IPAC'', ''Informe provisional del AC'', ''Informe provisional del AC'', 0, ''DML'', SYSDATE, 0, 3)';
      EXECUTE IMMEDIATE V_SQL ;
    END IF ;  
    
DBMS_OUTPUT.PUT_LINE('[INICIO] FUNCION ROLE_VER_TAB_DOCUMENTOS'); 
    V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO WHERE DD_TFA_CODIGO= ''TDAC''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := 'Insert into DD_TFA_FICHERO_ADJUNTO (DD_TFA_ID, DD_TFA_CODIGO, DD_TFA_DESCRIPCION, DD_TFA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TAC_ID) values   (s_dd_tfa_fichero_adjunto.nextval, ''TDAC'', ''Textos definitivos del AC'', ''Textos definitivos del AC'', 0, ''DML'', SYSDATE, 0, 3)';
      EXECUTE IMMEDIATE V_SQL ;
    END IF ;  
    
DBMS_OUTPUT.PUT_LINE('[INICIO] FUNCION ROLE_VER_TAB_DOCUMENTOS'); 
    V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO WHERE DD_TFA_CODIGO= ''PC''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := 'Insert into DD_TFA_FICHERO_ADJUNTO (DD_TFA_ID, DD_TFA_CODIGO, DD_TFA_DESCRIPCION, DD_TFA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TAC_ID) values   (s_dd_tfa_fichero_adjunto.nextval, ''PC'', ''Propuestas de Convenio'', ''Propuestas de Convenio'', 0, ''DML'', SYSDATE, 0, 3)';
      EXECUTE IMMEDIATE V_SQL ;
    END IF ;  
    
DBMS_OUTPUT.PUT_LINE('[INICIO] FUNCION ROLE_VER_TAB_DOCUMENTOS'); 
    V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO WHERE DD_TFA_CODIGO= ''PL''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := 'Insert into DD_TFA_FICHERO_ADJUNTO (DD_TFA_ID, DD_TFA_CODIGO, DD_TFA_DESCRIPCION, DD_TFA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TAC_ID) values   (s_dd_tfa_fichero_adjunto.nextval, ''PL'', ''Planes de Liquidación'', ''Planes de Liquidación'', 0, ''DML'', SYSDATE, 0, 3)';
      EXECUTE IMMEDIATE V_SQL ;
    END IF ;  
    
DBMS_OUTPUT.PUT_LINE('[INICIO] FUNCION ROLE_VER_TAB_DOCUMENTOS'); 
    V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO WHERE DD_TFA_CODIGO= ''ASDJM''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := 'Insert into DD_TFA_FICHERO_ADJUNTO (DD_TFA_ID, DD_TFA_CODIGO, DD_TFA_DESCRIPCION, DD_TFA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TAC_ID) values   (s_dd_tfa_fichero_adjunto.nextval, ''ASDJM'', ''Auto o Sentencia dictada por el Juzgado de lo Mercantil'', ''Auto o Sentencia dictada por el Juzgado de lo Mercantil'', 0, ''DML'', SYSDATE, 0, 3)';
      EXECUTE IMMEDIATE V_SQL ;
    END IF ;  

DBMS_OUTPUT.PUT_LINE('[INICIO] FUNCION INITIAL_TAB_NOTHING'); 
    V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''INITIAL_TAB_NOTHING''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := 'Insert into '||V_ESQUEMA_M||'.FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values ('||V_ESQUEMA_M||'.s_fun_funciones.nextval, ''Permite ver nada inicialmente'', ''INITIAL_TAB_NOTHING'', 0, ''DD'', SYSDATE, 0)';
      EXECUTE IMMEDIATE V_SQL ;
    END IF ;  


COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN] INCIDENCIA');



EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT

    