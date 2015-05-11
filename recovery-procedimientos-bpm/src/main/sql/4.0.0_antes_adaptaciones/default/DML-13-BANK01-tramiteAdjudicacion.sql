SET DEFINE OFF;

--1. *********************************************** Trámite de Adjudicación V4 
INSERT
INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
  (
    DD_TPO_ID,
    DD_TPO_CODIGO,
    DD_TPO_DESCRIPCION,
    DD_TPO_DESCRIPCION_LARGA,
    DD_TPO_XML_JBPM,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO,
    DD_TAC_ID,
    FLAG_PRORROGA,
    DTYPE
  )
  VALUES
  (
    S_DD_TPO_TIPO_PROCEDIMIENTO.NEXTVAL,
    'P413',
    'Trámite de Adjudicación',
    'Trámite de Adjudicación',
    'tramiteAdjudicacionV4',
    0,
    'DD',
    SYSDATE,
    0,
    (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AP'),
    1,
    'MEJTipoProcedimiento'
  );


--2. *********************************************** P413_SolicitudDecretoAdjudicacion
INSERT
INTO BANK01.TAP_TAREA_PROCEDIMIENTO
  (
    TAP_ID,
    DD_TPO_ID,
    TAP_CODIGO,
    TAP_SCRIPT_DECISION,
tap_script_validacion_jbpm,
    TAP_SUPERVISOR,
    TAP_DESCRIPCION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO,
    TAP_AUTOPRORROGA,
    DTYPE,
    TAP_MAX_AUTOP,
    DD_STA_ID
  )
  VALUES
  (
    S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL,
    (SELECT DD_TPO_ID
    FROM BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    WHERE dd_tpo_xml_jbpm = 'tramiteAdjudicacionV4'
    ),
    'P413_SolicitudDecretoAdjudicacion',
    null,
'comprobarBienAsociadoPrc() ? null : ''El bien debe estar asociado al trámite, asócielo desde la pestaña de Bienes del procedimiento para poder finalizar esta tarea.''',
    0,
    'Solicitud de Decreto de Adjudicación',
    0,
    'DD',
    SYSDATE,
    0,
    1,
    'EXTTareaProcedimiento',
    3,
    39
  );

INSERT
INTO BANK01.dd_ptp_plazos_tareas_plazas
  (
    DD_PTP_ID,
    DD_JUZ_ID,
    DD_PLA_ID,
    TAP_ID,
    DD_PTP_PLAZO_SCRIPT,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    USUARIOMODIFICAR,
    FECHAMODIFICAR,
    USUARIOBORRAR,
    FECHABORRAR,
    BORRADO
  )
  VALUES
  (
    s_dd_ptp_plazos_tareas_plazas.nextval,
    NULL,
    NULL,
    (SELECT tap_id
    FROM BANK01.TAP_TAREA_PROCEDIMIENTO tareas
    WHERE tap_codigo='P413_SolicitudDecretoAdjudicacion'
    ),
    '5*24*60*60*1000L',
    '0',
    'DD',
    sysdate,
    NULL,
    NULL,
    NULL,
    NULL,
    '0'
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_SolicitudDecretoAdjudicacion'
    ),
    0,
    'label',
    'titulo',
    '<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Dado que la entidad se ha adjudicado uno o más bienes en la subasta celebrada, a través de esta tarea deberá de consignar la fecha de presentación en el Juzgado del escrito de solicitud del Decreto de Adjudicación. En caso de no haber un bien ya vinculado al procedimiento, antes de dar por completada esta tarea el sistema le obligará a asociarlo a través de la pestaña bienes del procedimiento el bien que corresponda.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzará la tarea "Notificación decreto de adjudicación a la entidad".</p></div>',
    0,
    'DD',
    sysdate,
    0
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    TFI_ERROR_VALIDACION,
    TFI_VALIDACION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_SolicitudDecretoAdjudicacion'
    ),
    1,
    'date',
    'fechaSolicitud',
    'Fecha Solicitud',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null '||'&'||'&'||' valor != '''' ? true : false',
    0,
    'DD',
    sysdate,
    0
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_SolicitudDecretoAdjudicacion'
    ),
    2,
    'textarea',
    'observaciones',
    'Observaciones',
    0,
    'DD',
    sysdate,
    0
  );

--3. *********************************************** P413_notificacionDecretoAdjudicacionAEntidad
INSERT
INTO BANK01.TAP_TAREA_PROCEDIMIENTO
  (
    TAP_ID,
    DD_TPO_ID,
    TAP_CODIGO,
    TAP_SCRIPT_DECISION,
    TAP_SUPERVISOR,
    TAP_DESCRIPCION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO,
    TAP_AUTOPRORROGA,
    DTYPE,
    TAP_MAX_AUTOP,
    DD_STA_ID,
tap_alert_vuelta_atras
  )
  VALUES
  (
    S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL,
    (SELECT DD_TPO_ID
    FROM BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    WHERE dd_tpo_xml_jbpm = 'tramiteAdjudicacionV4'
    ),
    'P413_notificacionDecretoAdjudicacionAEntidad',
    '( valores[''P413_notificacionDecretoAdjudicacionAEntidad''][''comboSubsanacion''] == DDSiNo.SI ? ''SI'':''NO'')',
    0,
    'Notificación del Decreto de Adjudicación a Entidad',
    0,
    'DD',
    SYSDATE,
    0,
    1,
    'EXTTareaProcedimiento',
    3,
    39,
'tareaExterna.cancelarTarea'
  );

INSERT
INTO BANK01.dd_ptp_plazos_tareas_plazas
  (
    DD_PTP_ID,
    DD_JUZ_ID,
    DD_PLA_ID,
    TAP_ID,
    DD_PTP_PLAZO_SCRIPT,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    USUARIOMODIFICAR,
    FECHAMODIFICAR,
    USUARIOBORRAR,
    FECHABORRAR,
    BORRADO
  )
  VALUES
  (
    s_dd_ptp_plazos_tareas_plazas.nextval,
    NULL,
    NULL,
    (SELECT tap_id
    FROM BANK01.TAP_TAREA_PROCEDIMIENTO tareas
    WHERE tap_codigo='P413_notificacionDecretoAdjudicacionAEntidad'
    ),
    '5*24*60*60*1000L',
    '0',
    'DD',
    sysdate,
    NULL,
    NULL,
    NULL,
    NULL,
    '0'
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_notificacionDecretoAdjudicacionAEntidad'
    ),
    0,
    'label',
    'titulo',
    '<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través de esta pantalla deberá de consignar la fecha en la que se notifica por el Juzgado el Decreto de Adjudicación, la entidad adjudicataria de los bienes afectos y en el caso de ser un fondo deberá consignar el fondo que corresponda.</p><p>Deberá revisar que el Decreto es conforme a la subasta celebrada y contiene lo preceptuado para su correcta inscripción en el Registro de la Propiedad, para ello deberá revisar:</p><p>- Datos procesales básicos: (No autos, tipo de procedimiento, cantidad reclamada)</p><p>- Datos de la Entidad demandante (nombre CIF, domicilio) y cesionaria (en caso de cesión de remate a Fondos de titulización)</p><p>- Datos de los demandados y titulares registrales.</p><p>- Importe de adjudicación.</p><p>- Orden de cancelación de la nota marginal y cancelación de la carga objeto de ejecución así como cargas posteriores)</p><p>- Descripción y datos registrales completos de la finca adjudicada.</p><p>- Declaración en el auto de la firmeza de la resolución</p><p>Una vez analizados los puntos descritos, en el campo Requiere subsanación deberá indicar el resultado de dicho análisis.</p><p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p>Una vez rellene esta pantalla se lanzará, en caso de requerir subsanación el trámite de subsanación de adjudicación, en caso contrario se lanzará la tarea "Notificación decreto adjudicación al contrario".</p></div>',
    0,
    'DD',
    sysdate,
    0
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    TFI_ERROR_VALIDACION,
    TFI_VALIDACION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_notificacionDecretoAdjudicacionAEntidad'
    ),
    1,
    'date',
    'fecha',
    'Fecha',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null '||'&'||'&'||' valor != '''' ? true : false',
    0,
    'DD',
    sysdate,
    0
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    TFI_ERROR_VALIDACION,
    TFI_VALIDACION,
    TFI_BUSINESS_OPERATION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_notificacionDecretoAdjudicacionAEntidad'
    ),
    2,
    'combo',
    'comboEntidadAdjudicataria',
    'Entidad Adjudicataria',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null '||'&'||'&'||' valor != '''' ? true : false',
    'DDEntidadAdjudicataria',
    0,
    'DD',
    sysdate,
    0
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    TFI_ERROR_VALIDACION,
    TFI_VALIDACION,
    TFI_BUSINESS_OPERATION,    
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_notificacionDecretoAdjudicacionAEntidad'
    ),
    3,
    'combo',
    'comboFondo',
    'Fondo',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null '||'&'||'&'||' valor != '''' ? true : false',
    'DDTipoFondo',    
    0,
    'DD',
    sysdate,
    0
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    TFI_ERROR_VALIDACION,
    TFI_VALIDACION,
    TFI_BUSINESS_OPERATION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_notificacionDecretoAdjudicacionAEntidad'
    ),
    4,
    'combo',
    'comboSubsanacion',
    'Requiere Subsanación',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null '||'&'||'&'||' valor != '''' ? true : false',
    'DDSiNo',
    0,
    'DD',
    sysdate,
    0
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_notificacionDecretoAdjudicacionAEntidad'
    ),
    5,
    'textarea',
    'observaciones',
    'Observaciones',
    0,
    'DD',
    sysdate,
    0
  );


--5. *********************************************** P413_notificacionDecretoAdjudicacionAlContrario
INSERT
INTO BANK01.TAP_TAREA_PROCEDIMIENTO
  (
    TAP_ID,
    DD_TPO_ID,
    TAP_CODIGO,
    TAP_SCRIPT_DECISION,
    TAP_SUPERVISOR,
    TAP_DESCRIPCION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO,
    TAP_AUTOPRORROGA,
    DTYPE,
    TAP_MAX_AUTOP,
    DD_STA_ID,
tap_alert_vuelta_atras
  )
  VALUES
  (
    S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL,
    (SELECT DD_TPO_ID
    FROM BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    WHERE dd_tpo_xml_jbpm = 'tramiteAdjudicacionV4'
    ),
    'P413_notificacionDecretoAdjudicacionAlContrario',
    '( valores[''P413_notificacionDecretoAdjudicacionAlContrario''][''comboNotificacion''] == DDSiNo.SI ? ''SI'':''NO'')',
    0,
    'Notificación del Decreto de Adjudicación al Contrario',
    0,
    'DD',
    SYSDATE,
    0,
    1,
    'EXTTareaProcedimiento',
    3,
    39,
'tareaExterna.cancelarTarea'
  );

INSERT
INTO BANK01.dd_ptp_plazos_tareas_plazas
  (
    DD_PTP_ID,
    DD_JUZ_ID,
    DD_PLA_ID,
    TAP_ID,
    DD_PTP_PLAZO_SCRIPT,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    USUARIOMODIFICAR,
    FECHAMODIFICAR,
    USUARIOBORRAR,
    FECHABORRAR,
    BORRADO
  )
  VALUES
  (
    s_dd_ptp_plazos_tareas_plazas.nextval,
    NULL,
    NULL,
    (SELECT tap_id
    FROM BANK01.TAP_TAREA_PROCEDIMIENTO tareas
    WHERE tap_codigo='P413_notificacionDecretoAdjudicacionAlContrario'
    ),
    'damePlazo(valores[''P413_notificacionDecretoAdjudicacionAEntidad''][''fecha''])+30*24*60*60*1000L',
    '0',
    'DD',
    sysdate,
    NULL,
    NULL,
    NULL,
    NULL,
    '0'
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_notificacionDecretoAdjudicacionAlContrario'
    ),
    0,
    'label',
    'titulo',
    '<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través de esta pantalla se deberá informar del resultado de la notificación del decreto de adjudicación a la parte ejecutada, en caso de notificación positiva se informará de la fecha de notificación del Decreto de Adjudicación.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzará, en caso de notificación negativa a la parte contraria el trámite de notificación, y en caso contrario la tarea “Solicitud de testimonio de decreto de adjudicación”.</p></div>',
    0,
    'DD',
    sysdate,
    0
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    TFI_ERROR_VALIDACION,
    TFI_VALIDACION,
    TFI_BUSINESS_OPERATION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_notificacionDecretoAdjudicacionAlContrario'
    ),
    1,
    'combo',
    'comboNotificacion',
    'Notificado',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null '||'&'||'&'||' valor != '''' ? true : false',
    'DDSiNo',
    0,
    'DD',
    sysdate,
    0
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    TFI_ERROR_VALIDACION,
    TFI_VALIDACION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_notificacionDecretoAdjudicacionAlContrario'
    ),
    2,
    'date',
    'fecha',
    'Fecha',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null '||'&'||'&'||' valor != '''' ? true : false',
    0,
    'DD',
    sysdate,
    0
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_notificacionDecretoAdjudicacionAlContrario'
    ),
    3,
    'textarea',
    'observaciones',
    'Observaciones',
    0,
    'DD',
    sysdate,
    0
  );


--6. *********************************************** P413_SolicitudTestimonioDecretoAdjudicacion
INSERT
INTO BANK01.TAP_TAREA_PROCEDIMIENTO
  (
    TAP_ID,
    DD_TPO_ID,
    TAP_CODIGO,
    TAP_SCRIPT_DECISION,
    TAP_SUPERVISOR,
    TAP_DESCRIPCION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO,
    TAP_AUTOPRORROGA,
    DTYPE,
    TAP_MAX_AUTOP,
    DD_STA_ID,
tap_alert_vuelta_atras
  )
  VALUES
  (
    S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL,
    (SELECT DD_TPO_ID
    FROM BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    WHERE dd_tpo_xml_jbpm = 'tramiteAdjudicacionV4'
    ),
    'P413_SolicitudTestimonioDecretoAdjudicacion',
    null,
    0,
    'Solicitud de Testimonio del Decreto de Adjudicación',
    0,
    'DD',
    SYSDATE,
    0,
    1,
    'EXTTareaProcedimiento',
    3,
    39,
'tareaExterna.cancelarTarea'
  );

INSERT
INTO BANK01.dd_ptp_plazos_tareas_plazas
  (
    DD_PTP_ID,
    DD_JUZ_ID,
    DD_PLA_ID,
    TAP_ID,
    DD_PTP_PLAZO_SCRIPT,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    USUARIOMODIFICAR,
    FECHAMODIFICAR,
    USUARIOBORRAR,
    FECHABORRAR,
    BORRADO
  )
  VALUES
  (
    s_dd_ptp_plazos_tareas_plazas.nextval,
    NULL,
    NULL,
    (SELECT tap_id
    FROM BANK01.TAP_TAREA_PROCEDIMIENTO tareas
    WHERE tap_codigo='P413_SolicitudTestimonioDecretoAdjudicacion'
    ),
    'damePlazo(valores[''P413_notificacionDecretoAdjudicacionAlContrario''][''fecha''])+20*24*60*60*1000L',
    '0',
    'DD',
    sysdate,
    NULL,
    NULL,
    NULL,
    NULL,
    '0'
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_SolicitudTestimonioDecretoAdjudicacion'
    ),
    0,
    'label',
    'titulo',
    '<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por completada esta tarea deberá de consignar la Fecha de solicitud del testimonio de decreto de adjudicación.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzará, en caso de notificación negativa a la parte contraria el trámite de notificación, y en caso contrario la tarea "Confirmar testimonio decreto de adjudicación".</p></div>',
    0,
    'DD',
    sysdate,
    0
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    TFI_ERROR_VALIDACION,
    TFI_VALIDACION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_SolicitudTestimonioDecretoAdjudicacion'
    ),
    1,
    'date',
    'fecha',
    'Fecha Solicitud',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null '||'&'||'&'||' valor != '''' ? true : false',
    0,
    'DD',
    sysdate,
    0
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_SolicitudTestimonioDecretoAdjudicacion'
    ),
    2,
    'textarea',
    'observaciones',
    'Observaciones',
    0,
    'DD',
    sysdate,
    0
  );


--6. *********************************************** P413_ConfirmarTestimonio
INSERT
INTO BANK01.TAP_TAREA_PROCEDIMIENTO
  (
    TAP_ID,
    DD_TPO_ID,
    TAP_CODIGO,
    TAP_SCRIPT_DECISION,
    TAP_SUPERVISOR,
    TAP_DESCRIPCION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO,
    TAP_AUTOPRORROGA,
    DTYPE,
    TAP_MAX_AUTOP,
    DD_STA_ID,
tap_alert_vuelta_atras,
tap_script_validacion_jbpm,
tap_script_validacion
  )
  VALUES
  (
    S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL,
    (SELECT DD_TPO_ID
    FROM BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    WHERE dd_tpo_xml_jbpm = 'tramiteAdjudicacionV4'
    ),
    'P413_ConfirmarTestimonio',
    '( valores[''P413_ConfirmarTestimonio''][''comboSubsanacion''] == DDSiNo.SI ? ''SI'':''NO'')',
    0,
    'Confirmar el Testimonio',
    0,
    'DD',
    SYSDATE,
    0,
    1,
    'EXTTareaProcedimiento',
    3,
    39,
'tareaExterna.cancelarTarea',
' comprobarGestoriaAsignadaPrc() ? null : ''Debe asignar la Gestoría encargada de tramitar la adjudicación.'' ',
'comprobarExisteDocumentoDFA() ? null : ''Es necesario adjuntar el documento decreto firme de adjudicación'''
  );

INSERT
INTO BANK01.dd_ptp_plazos_tareas_plazas
  (
    DD_PTP_ID,
    DD_JUZ_ID,
    DD_PLA_ID,
    TAP_ID,
    DD_PTP_PLAZO_SCRIPT,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    USUARIOMODIFICAR,
    FECHAMODIFICAR,
    USUARIOBORRAR,
    FECHABORRAR,
    BORRADO
  )
  VALUES
  (
    s_dd_ptp_plazos_tareas_plazas.nextval,
    NULL,
    NULL,
    (SELECT tap_id
    FROM BANK01.TAP_TAREA_PROCEDIMIENTO tareas
    WHERE tap_codigo='P413_ConfirmarTestimonio'
    ),
    'damePlazo(valores[''P413_SolicitudTestimonioDecretoAdjudicacion''][''fecha''])+30*24*60*60*1000L',
    '0',
    'DD',
    sysdate,
    NULL,
    NULL,
    NULL,
    NULL,
    '0'
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_ConfirmarTestimonio'
    ),
    0,
    'label',
    'titulo',
    '<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por completada esta tarea deberá de acceder a la pestaña Gestores del asunto correspondiente y asignar el tipo de gestor "Gestoría adjudicación" según el protocolo que tiene establecido la entidad.</p><p>A través de esta pantalla se ha de marcar la fecha que el Juzgado hace entrega del Testimonio del Decreto a favor de la Entidad. Se ha de tener en cuenta que desde la fecha que se indique en esta pantalla se inicia el plazo para liquidar los impuestos que correspondan.</p><p>Una vez confirmado con el procurador el envío a la gestoría, se deberá consignar dicha fecha en el campo "Fecha envío a Gestoría".</p><p>Con el objeto de evitar calificaciones desfavorables y subsanaciones posteriores que retrasan la inscripción deberá:</p><p>- Obtenido el testimonio, se revisará la fecha de expedición para liquidación de impuestos en plazo, según normativa de CCAA. La verificación de la fecha del título es necesaria y fundamental para que la gestoría pueda realizar la liquidación en plazo.</p><p>- Adicionalmente se revisarán el contenido fundamental y de forma, para evitar subsanaciones posteriores que retrasen la inscripción. Contenido básico para revisar en testimonio decreto de adjudicación y mandamientos:<br>'||'&'||'nbsp;'||'&'||'nbsp;'||'&'||'nbsp;- Datos procesales básicos: (No autos, tipo de procedimiento, cantidad reclamada)<br>'||'&'||'nbsp;'||'&'||'nbsp;'||'&'||'nbsp;- Datos de la Entidad demandante (nombre CIF, domicilio) y cesionaria (en caso de cesión de remate a Fondos de titulización)<br>'||'&'||'nbsp;'||'&'||'nbsp;'||'&'||'nbsp;- Datos de los demandados y titulares registrales.<br>'||'&'||'nbsp;'||'&'||'nbsp;'||'&'||'nbsp;- Importe de adjudicación y cesión de remate (en su caso).<br>'||'&'||'nbsp;'||'&'||'nbsp;'||'&'||'nbsp;- Orden de cancelación de la nota marginal y cancelación de la carga objeto de ejecución así como cargas posteriores).<br>'||'&'||'nbsp;'||'&'||'nbsp;'||'&'||'nbsp;- Descripción y datos registrales completos de la finca adjudicada.<br>'||'&'||'nbsp;'||'&'||'nbsp;'||'&'||'nbsp;- Declaración en el auto de la firmeza de la resolución<br></p><p>Una vez analizados los puntos descritos, en el campo Requiere subsanación deberá indicar el resultado de dicho análisis.</p><p>Para dar por terminada esta tarea deberá de adjuntar al procedimiento correspondiente una copia escaneada del decreto firme de adjudicación.</p><p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p>Una vez rellene esta pantalla se lanzará, en caso de requerir subsanación el trámite de subsanación de adjudicación, y en caso contrario se lanzará por un lado la tarea "Registrar entrega del título" y por otro el trámite de posesión.</p></div>',
    0,
    'DD',
    sysdate,
    0
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    TFI_ERROR_VALIDACION,
    TFI_VALIDACION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_ConfirmarTestimonio'
    ),
    1,
    'date',
    'fechaTestimonio',
    'Fecha Testimonio',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null '||'&'||'&'||' valor != '''' ? true : false',
    0,
    'DD',
    sysdate,
    0
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    TFI_ERROR_VALIDACION,
    TFI_VALIDACION,
    TFI_BUSINESS_OPERATION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_ConfirmarTestimonio'
    ),
    2,
    'combo',
    'comboSubsanacion',
    'Requiere Subsanación',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null '||'&'||'&'||' valor != '''' ? true : false',
    'DDSiNo',
    0,
    'DD',
    sysdate,
    0
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    TFI_ERROR_VALIDACION,
    TFI_VALIDACION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_ConfirmarTestimonio'
    ),
    3,
    'date',
    'fechaEnvioGestoria',
    'Fecha Envío a Gestoría',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null '||'&'||'&'||' valor != '''' ? true : false',
    0,
    'DD',
    sysdate,
    0
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_ConfirmarTestimonio'
    ),
    4,
    'textarea',
    'observaciones',
    'Observaciones',
    0,
    'DD',
    sysdate,
    0
  );


--7. *********************************************** P413_RegistrarEntregaTitulo
INSERT
INTO BANK01.TAP_TAREA_PROCEDIMIENTO
  (
    TAP_ID,
    DD_TPO_ID,
    TAP_CODIGO,
    TAP_SCRIPT_DECISION,
    TAP_SUPERVISOR,
    TAP_DESCRIPCION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO,
    TAP_AUTOPRORROGA,
    DTYPE,
    TAP_MAX_AUTOP,
    DD_STA_ID
  )
  VALUES
  (
    S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL,
    (SELECT DD_TPO_ID
    FROM BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    WHERE dd_tpo_xml_jbpm = 'tramiteAdjudicacionV4'
    ),
    'P413_RegistrarEntregaTitulo',
    null,
    1,
    'Registrar entrega del título',
    0,
    'DD',
    SYSDATE,
    0,
    1,
    'EXTTareaProcedimiento',
    3,
    100
  );

INSERT
INTO BANK01.dd_ptp_plazos_tareas_plazas
  (
    DD_PTP_ID,
    DD_JUZ_ID,
    DD_PLA_ID,
    TAP_ID,
    DD_PTP_PLAZO_SCRIPT,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    USUARIOMODIFICAR,
    FECHAMODIFICAR,
    USUARIOBORRAR,
    FECHABORRAR,
    BORRADO
  )
  VALUES
  (
    s_dd_ptp_plazos_tareas_plazas.nextval,
    NULL,
    NULL,
    (SELECT tap_id
    FROM BANK01.TAP_TAREA_PROCEDIMIENTO tareas
    WHERE tap_codigo='P413_RegistrarEntregaTitulo'
    ),
    'damePlazo(valores[''P413_ConfirmarTestimonio''][''fechaTestimonio''])+7*24*60*60*1000L',
    '0',
    'DD',
    sysdate,
    NULL,
    NULL,
    NULL,
    NULL,
    '0'
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_RegistrarEntregaTitulo'
    ),
    0,
    'label',
    'titulo',
    '<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través de esta pantalla deberá de informar de la fecha en que recibe la información sobre los documentos asignados que se le han enviado.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por terminada esta tarea deberá:</p><p>- Liquidar impuestos en plazo según CCAA. En caso de personas jurídicas existirá una consulta previa realizada sobre la posible liquidación de IVA. Esta información podrá consultarla a través de la ficha de cada uno de los bienes incluidos.</p><p>- Verificar situación ocupacional de la finca para manifestación de libertad arrendamientos de cara a inscripción (LAU).</p><p>- Redactar en su caso, certificado de Libertad de Arrendamiento (por poder de la Entidad), para presentación en el registro junto con el testimonio y los mandamientos.</p><p>- Realizar notificación fehaciente a inquilinos para la inscripción (en casos de inmueble con arrendamiento reconocido)</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzará la tarea "Registrar presentación en hacienda".</p></div>',
    0,
    'DD',
    sysdate,
    0
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    TFI_ERROR_VALIDACION,
    TFI_VALIDACION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_RegistrarEntregaTitulo'
    ),
    1,
    'date',
    'fechaRecepcion',
    'Fecha de Recepción',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null '||'&'||'&'||' valor != '''' ? true : false',
    0,
    'DD',
    sysdate,
    0
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_RegistrarEntregaTitulo'
    ),
    2,
    'textarea',
    'observaciones',
    'Observaciones',
    0,
    'DD',
    sysdate,
    0
  );


--8. *********************************************** P413_RegistrarPresentacionEnHacienda
INSERT
INTO BANK01.TAP_TAREA_PROCEDIMIENTO
  (
    TAP_ID,
    DD_TPO_ID,
    TAP_CODIGO,
    TAP_SCRIPT_DECISION,
    TAP_SUPERVISOR,
    TAP_DESCRIPCION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO,
    TAP_AUTOPRORROGA,
    DTYPE,
    TAP_MAX_AUTOP,
    DD_STA_ID,
tap_alert_vuelta_atras,
tap_script_validacion
  )
  VALUES
  (
    S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL,
    (SELECT DD_TPO_ID
    FROM BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    WHERE dd_tpo_xml_jbpm = 'tramiteAdjudicacionV4'
    ),
    'P413_RegistrarPresentacionEnHacienda',
    null,
    1,
    'Registrar presentación en Hacienda',
    0,
    'DD',
    SYSDATE,
    0,
    1,
    'EXTTareaProcedimiento',
    3,
    100,
'tareaExterna.cancelarTarea',
'comprobarExisteDocumentoLII() ? null : ''Liquidación de impuestos'''
  );

INSERT
INTO BANK01.dd_ptp_plazos_tareas_plazas
  (
    DD_PTP_ID,
    DD_JUZ_ID,
    DD_PLA_ID,
    TAP_ID,
    DD_PTP_PLAZO_SCRIPT,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    USUARIOMODIFICAR,
    FECHAMODIFICAR,
    USUARIOBORRAR,
    FECHABORRAR,
    BORRADO
  )
  VALUES
  (
    s_dd_ptp_plazos_tareas_plazas.nextval,
    NULL,
    NULL,
    (SELECT tap_id
    FROM BANK01.TAP_TAREA_PROCEDIMIENTO tareas
    WHERE tap_codigo='P413_RegistrarPresentacionEnHacienda'
    ),
    'damePlazo(valores[''P413_ConfirmarTestimonio''][''fechaTestimonio''])+30*24*60*60*1000L',
    '0',
    'DD',
    sysdate,
    NULL,
    NULL,
    NULL,
    NULL,
    '0'
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_RegistrarPresentacionEnHacienda'
    ),
    0,
    'label',
    'titulo',
    '<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deberá presentar la liquidación del testimonio en Hacienda, una vez realizado esto deberá adjuntar al procedimiento correspondiente copia escaneada del documento de liquidación de impuestos.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzará la tarea "Registrar presentación en el registro".</p></div>',
    0,
    'DD',
    sysdate,
    0
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    TFI_ERROR_VALIDACION,
    TFI_VALIDACION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_RegistrarPresentacionEnHacienda'
    ),
    1,
    'date',
    'fechaPresentacion',
    'Fecha Presentación',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null '||'&'||'&'||' valor != '''' ? true : false',
    0,
    'DD',
    sysdate,
    0
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_RegistrarPresentacionEnHacienda'
    ),
    2,
    'textarea',
    'observaciones',
    'Observaciones',
    0,
    'DD',
    sysdate,
    0
  );


--9. *********************************************** P413_RegistrarPresentacionEnRegistro
INSERT
INTO BANK01.TAP_TAREA_PROCEDIMIENTO
  (
    TAP_ID,
    DD_TPO_ID,
    TAP_CODIGO,
    TAP_SCRIPT_DECISION,
    TAP_SUPERVISOR,
    TAP_DESCRIPCION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO,
    TAP_AUTOPRORROGA,
    DTYPE,
    TAP_MAX_AUTOP,
    DD_STA_ID,
tap_alert_vuelta_atras
  )
  VALUES
  (
    S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL,
    (SELECT DD_TPO_ID
    FROM BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    WHERE dd_tpo_xml_jbpm = 'tramiteAdjudicacionV4'
    ),
    'P413_RegistrarPresentacionEnRegistro',
    null,
    1,
    'Registrar presentación en Registro',
    0,
    'DD',
    SYSDATE,
    0,
    1,
    'EXTTareaProcedimiento',
    3,
    100,
'tareaExterna.cancelarTarea'
  );

INSERT
INTO BANK01.dd_ptp_plazos_tareas_plazas
  (
    DD_PTP_ID,
    DD_JUZ_ID,
    DD_PLA_ID,
    TAP_ID,
    DD_PTP_PLAZO_SCRIPT,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    USUARIOMODIFICAR,
    FECHAMODIFICAR,
    USUARIOBORRAR,
    FECHABORRAR,
    BORRADO
  )
  VALUES
  (
    s_dd_ptp_plazos_tareas_plazas.nextval,
    NULL,
    NULL,
    (SELECT tap_id
    FROM BANK01.TAP_TAREA_PROCEDIMIENTO tareas
    WHERE tap_codigo='P413_RegistrarPresentacionEnRegistro'
    ),
    'valores[''P414_EntregarNuevoDecreto''] != null ? damePlazo(valores[''P414_EntregarNuevoDecreto''][''fechaEnvio''])+10*24*60*60*1000L : damePlazo(valores[''P413_RegistrarPresentacionEnHacienda''][''fechaPresentacion''])+10*24*60*60*1000L ',
    '0',
    'DD',
    sysdate,
    NULL,
    NULL,
    NULL,
    NULL,
    '0'
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_RegistrarPresentacionEnRegistro'
    ),
    0,
    'label',
    'titulo',
    '<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deberá consignar la fecha de presentación en el registro, ya sea del testimonio decreto de adjudicación original o del testimonio decreto de adjudicación una vez subsanados los errores encontrados con anterioridad.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzará la tarea “Registrar inscripción del título”.</p></div>',
    0,
    'DD',
    sysdate,
    0
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    TFI_ERROR_VALIDACION,
    TFI_VALIDACION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_RegistrarPresentacionEnRegistro'
    ),
    1,
    'date',
    'fechaPresentacion',
    'Fecha Presentación',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null '||'&'||'&'||' valor != '''' ? true : false',
    0,
    'DD',
    sysdate,
    0
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_RegistrarPresentacionEnRegistro'
    ),
    2,
    'textarea',
    'observaciones',
    'Observaciones',
    0,
    'DD',
    sysdate,
    0
  );


--10. *********************************************** P413_RegistrarInscripcionDelTitulo
INSERT
INTO BANK01.TAP_TAREA_PROCEDIMIENTO
  (
    TAP_ID,
    DD_TPO_ID,
    TAP_CODIGO,
    TAP_SCRIPT_DECISION,
    TAP_SUPERVISOR,
    TAP_DESCRIPCION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO,
    TAP_AUTOPRORROGA,
    DTYPE,
    TAP_MAX_AUTOP,
    DD_STA_ID,
tap_alert_vuelta_atras,
tap_script_validacion_jbpm,
tap_script_validacion
  )
  VALUES
  (
    S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL,
    (SELECT DD_TPO_ID
    FROM BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    WHERE dd_tpo_xml_jbpm = 'tramiteAdjudicacionV4'
    ),
    'P413_RegistrarInscripcionDelTitulo',
    '( valores[''P413_RegistrarInscripcionDelTitulo''][''comboSituacionTitulo''] == ''PEN'' ? ''SI'':''NO'')',
    1,
    'Registrar Inscripción del Título',
    0,
    'DD',
    SYSDATE,
    0,
    1,
    'EXTTareaProcedimiento',
    3,
    100,
'tareaExterna.cancelarTarea',
' comprobarGestoriaAsignadaAlSaneamientoDeCargasDeBienes() ? null : ''Debe asignar la Gestoría encargada del saneamiento de cargas del bien.'' ',
'comprobarExisteDocumentoTIRNR() ? null : ''Es necesario adjuntar el documento testimonio inscrito en el registro y nota registral'''
  );

INSERT
INTO BANK01.dd_ptp_plazos_tareas_plazas
  (
    DD_PTP_ID,
    DD_JUZ_ID,
    DD_PLA_ID,
    TAP_ID,
    DD_PTP_PLAZO_SCRIPT,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    USUARIOMODIFICAR,
    FECHAMODIFICAR,
    USUARIOBORRAR,
    FECHABORRAR,
    BORRADO
  )
  VALUES
  (
    s_dd_ptp_plazos_tareas_plazas.nextval,
    NULL,
    NULL,
    (SELECT tap_id
    FROM BANK01.TAP_TAREA_PROCEDIMIENTO tareas
    WHERE tap_codigo='P413_RegistrarInscripcionDelTitulo'
    ),
    'damePlazo(valores[''P413_RegistrarPresentacionEnRegistro''][''fechaPresentacion''])+60*24*60*60*1000L',
    '0',
    'DD',
    sysdate,
    NULL,
    NULL,
    NULL,
    NULL,
    '0'
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_RegistrarInscripcionDelTitulo'
    ),
    0,
    'label',
    'titulo',
    '<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deberá indicar la situación en que queda el título ya sea inscrito en el registro o pendiente de subsanación, a través de la ficha del bien correspondiente deberá de actualizar los campos: folio, libro, tomo, inscripción Xa, referencia catastral, porcentaje de propiedad, no de finca -si hubiera cambios Actualizado. Una vez actualizados estos campos deberá de marcar la fecha de actualización en la ficha del bien.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En caso de haberse producido una resolución desfavorable y haber marcado el bien en situación “Subsanar”, deberá informar la fecha de envío de decreto para adición y proceder a la remisión de los documentos al Procurador e informa al Letrado.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En caso de haber quedado inscrito el bien, deberá informar la fecha en que se haya producido dicha inscripción.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por terminada esta tarea y una vez obtenido el testimonio inscrito en el registro, deberá adjuntar dicho documento al procedimiento correspondiente.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzará, en caso de requerir subsanación el trámite de subsanación de decreto de adjudicación a realizar por el letrado, y en caso contrario se iniciará el trámite de saneamiento de cargas para el bien afecto a este trámite.</p></div>',
    0,
    'DD',
    sysdate,
    0
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    TFI_ERROR_VALIDACION,
    TFI_VALIDACION,
    TFI_BUSINESS_OPERATION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_RegistrarInscripcionDelTitulo'
    ),
    1,
    'combo',
    'comboSituacionTitulo',
    'Título Inscrito en el Registro',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null '||'&'||'&'||' valor != '''' ? true : false',
    'DDSituacionTitulo',
    0,
    'DD',
    sysdate,
    0
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    TFI_ERROR_VALIDACION,
    TFI_VALIDACION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_RegistrarInscripcionDelTitulo'
    ),
    2,
    'date',
    'fechaInscripcion',
    'Fecha Inscripción',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null '||'&'||'&'||' valor != '''' ? true : false',
    0,
    'DD',
    sysdate,
    0
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    TFI_ERROR_VALIDACION,
    TFI_VALIDACION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_RegistrarInscripcionDelTitulo'
    ),
    3,
    'date',
    'fechaEnvioDecretoAdicion',
    'Fecha Envío Decreto Adición',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null '||'&'||'&'||' valor != '''' ? true : false',
    0,
    'DD',
    sysdate,
    0
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_RegistrarInscripcionDelTitulo'
    ),
    4,
    'textarea',
    'observaciones',
    'Observaciones',
    0,
    'DD',
    sysdate,
    0
  );


--11. *********************************************** P413_BPMTramiteSubsanacionEmbargo1
--tramiteSubsanacionEmbargo
INSERT
INTO BANK01.TAP_TAREA_PROCEDIMIENTO
  (
    TAP_ID,
    DD_TPO_ID,
    TAP_CODIGO,
    TAP_SCRIPT_DECISION,
    TAP_SUPERVISOR,
    TAP_DESCRIPCION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO,
    TAP_AUTOPRORROGA,
    DTYPE,
    TAP_MAX_AUTOP,
    DD_STA_ID
  )
  VALUES
  (
    S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL,
    (SELECT DD_TPO_ID
    FROM BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    WHERE dd_tpo_xml_jbpm = 'tramiteAdjudicacionV4'
    ),
    'P413_BPMTramiteSubsanacionEmbargo1',
    null,
    0,
    'Llamada al BPM de Trámite de Subsanación de Adjudicación',
    0,
    'DD',
    SYSDATE,
    0,
    1,
    'EXTTareaProcedimiento',
    3,
    39
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_BPMTramiteSubsanacionEmbargo1'
    ),
    0,
    'label',
    'titulo',
    '<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Subsanación de Embargo.</p></div>',
    0,
    'DD',
    sysdate,
    0
  );

INSERT
INTO BANK01.dd_ptp_plazos_tareas_plazas
  (
    DD_PTP_ID,
    DD_JUZ_ID,
    DD_PLA_ID,
    TAP_ID,
    DD_PTP_PLAZO_SCRIPT,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    USUARIOMODIFICAR,
    FECHAMODIFICAR,
    USUARIOBORRAR,
    FECHABORRAR,
    BORRADO
  )
  VALUES
  (
    s_dd_ptp_plazos_tareas_plazas.nextval,
    NULL,
    NULL,
    (SELECT tap_id
    FROM BANK01.TAP_TAREA_PROCEDIMIENTO tareas
    WHERE tap_codigo='P413_BPMTramiteSubsanacionEmbargo1'
    ),
    '300*24*60*60*1000L',
    '0',
    'DD',
    sysdate,
    NULL,
    NULL,
    NULL,
    NULL,
    '0'
  );


--12. *********************************************** P413_BPMTramiteNotificacion
INSERT
INTO BANK01.TAP_TAREA_PROCEDIMIENTO
  (
    TAP_ID,
    DD_TPO_ID,
    TAP_CODIGO,
    TAP_SCRIPT_DECISION,
    TAP_SUPERVISOR,
    TAP_DESCRIPCION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO,
    TAP_AUTOPRORROGA,
    DTYPE,
    TAP_MAX_AUTOP,
    DD_STA_ID
  )
  VALUES
  (
    S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL,
    (SELECT DD_TPO_ID
    FROM BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    WHERE dd_tpo_xml_jbpm = 'tramiteAdjudicacionV4'
    ),
    'P413_BPMTramiteNotificacion',
    null,
    0,
    'Llamada al BPM de Trámite de Trámite de Notificación',
    0,
    'DD',
    SYSDATE,
    0,
    1,
    'EXTTareaProcedimiento',
    3,
    39
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_BPMTramiteNotificacion'
    ),
    0,
    'label',
    'titulo',
    '<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Notificación.</p></div>',
    0,
    'DD',
    sysdate,
    0
  );

INSERT
INTO BANK01.dd_ptp_plazos_tareas_plazas
  (
    DD_PTP_ID,
    DD_JUZ_ID,
    DD_PLA_ID,
    TAP_ID,
    DD_PTP_PLAZO_SCRIPT,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    USUARIOMODIFICAR,
    FECHAMODIFICAR,
    USUARIOBORRAR,
    FECHABORRAR,
    BORRADO
  )
  VALUES
  (
    s_dd_ptp_plazos_tareas_plazas.nextval,
    NULL,
    NULL,
    (SELECT tap_id
    FROM BANK01.TAP_TAREA_PROCEDIMIENTO tareas
    WHERE tap_codigo='P413_BPMTramiteNotificacion'
    ),
    '300*24*60*60*1000L',
    '0',
    'DD',
    sysdate,
    NULL,
    NULL,
    NULL,
    NULL,
    '0'
  );

--13. *********************************************** P413_BPMTramiteDePosesion
INSERT
INTO BANK01.TAP_TAREA_PROCEDIMIENTO
  (
    TAP_ID,
    DD_TPO_ID,
    TAP_CODIGO,
    TAP_SCRIPT_DECISION,
    TAP_SUPERVISOR,
    TAP_DESCRIPCION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO,
    TAP_AUTOPRORROGA,
    DTYPE,
    TAP_MAX_AUTOP,
    DD_STA_ID
  )
  VALUES
  (
    S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL,
    (SELECT DD_TPO_ID
    FROM BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    WHERE dd_tpo_xml_jbpm = 'tramiteAdjudicacionV4'
    ),
    'P413_BPMTramiteDePosesion',
    null,
    0,
    'Llamada al BPM de Trámite de Trámite de Posesión',
    0,
    'DD',
    SYSDATE,
    0,
    1,
    'EXTTareaProcedimiento',
    3,
    39
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_BPMTramiteDePosesion'
    ),
    0,
    'label',
    'titulo',
    '<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Posesión.</p></div>',
    0,
    'DD',
    sysdate,
    0
  );

INSERT
INTO BANK01.dd_ptp_plazos_tareas_plazas
  (
    DD_PTP_ID,
    DD_JUZ_ID,
    DD_PLA_ID,
    TAP_ID,
    DD_PTP_PLAZO_SCRIPT,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    USUARIOMODIFICAR,
    FECHAMODIFICAR,
    USUARIOBORRAR,
    FECHABORRAR,
    BORRADO
  )
  VALUES
  (
    s_dd_ptp_plazos_tareas_plazas.nextval,
    NULL,
    NULL,
    (SELECT tap_id
    FROM BANK01.TAP_TAREA_PROCEDIMIENTO tareas
    WHERE tap_codigo='P413_BPMTramiteDePosesion'
    ),
    '300*24*60*60*1000L',
    '0',
    'DD',
    sysdate,
    NULL,
    NULL,
    NULL,
    NULL,
    '0'
  );


--14. *********************************************** P413_BPMTramiteSaneamientoCargas
INSERT
INTO BANK01.TAP_TAREA_PROCEDIMIENTO
  (
    TAP_ID,
    DD_TPO_ID,
    TAP_CODIGO,
    TAP_SCRIPT_DECISION,
    TAP_SUPERVISOR,
    TAP_DESCRIPCION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO,
    TAP_AUTOPRORROGA,
    DTYPE,
    TAP_MAX_AUTOP,
    DD_STA_ID
  )
  VALUES
  (
    S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL,
    (SELECT DD_TPO_ID
    FROM BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    WHERE dd_tpo_xml_jbpm = 'tramiteAdjudicacionV4'
    ),
    'P413_BPMTramiteSaneamientoCargas',
    null,
    0,
    'Llamada al BPM de Trámite de Trámite de Saneamiento de Cargas',
    0,
    'DD',
    SYSDATE,
    0,
    1,
    'EXTTareaProcedimiento',
    3,
    39
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_BPMTramiteSaneamientoCargas'
    ),
    0,
    'label',
    'titulo',
    '<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Saneamiento de Cargas.</p></div>',
    0,
    'DD',
    sysdate,
    0
  );

INSERT
INTO BANK01.dd_ptp_plazos_tareas_plazas
  (
    DD_PTP_ID,
    DD_JUZ_ID,
    DD_PLA_ID,
    TAP_ID,
    DD_PTP_PLAZO_SCRIPT,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    USUARIOMODIFICAR,
    FECHAMODIFICAR,
    USUARIOBORRAR,
    FECHABORRAR,
    BORRADO
  )
  VALUES
  (
    s_dd_ptp_plazos_tareas_plazas.nextval,
    NULL,
    NULL,
    (SELECT tap_id
    FROM BANK01.TAP_TAREA_PROCEDIMIENTO tareas
    WHERE tap_codigo='P413_BPMTramiteSaneamientoCargas'
    ),
    '300*24*60*60*1000L',
    '0',
    'DD',
    sysdate,
    NULL,
    NULL,
    NULL,
    NULL,
    '0'
  );


--15. *********************************************** P413_BPMTramiteSubsanacionEmbargo2
--tramiteSubsanacionEmbargo
INSERT
INTO BANK01.TAP_TAREA_PROCEDIMIENTO
  (
    TAP_ID,
    DD_TPO_ID,
    TAP_CODIGO,
    TAP_SCRIPT_DECISION,
    TAP_SUPERVISOR,
    TAP_DESCRIPCION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO,
    TAP_AUTOPRORROGA,
    DTYPE,
    TAP_MAX_AUTOP,
    DD_STA_ID
  )
  VALUES
  (
    S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL,
    (SELECT DD_TPO_ID
    FROM BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    WHERE dd_tpo_xml_jbpm = 'tramiteAdjudicacionV4'
    ),
    'P413_BPMTramiteSubsanacionEmbargo2',
    null,
    0,
    'Llamada al BPM de Trámite de Subsanación de Adjudicación',
    0,
    'DD',
    SYSDATE,
    0,
    1,
    'EXTTareaProcedimiento',
    3,
    39
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_BPMTramiteSubsanacionEmbargo2'
    ),
    0,
    'label',
    'titulo',
    '<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Subsanación de Embargo.</p></div>',
    0,
    'DD',
    sysdate,
    0
  );

INSERT
INTO BANK01.dd_ptp_plazos_tareas_plazas
  (
    DD_PTP_ID,
    DD_JUZ_ID,
    DD_PLA_ID,
    TAP_ID,
    DD_PTP_PLAZO_SCRIPT,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    USUARIOMODIFICAR,
    FECHAMODIFICAR,
    USUARIOBORRAR,
    FECHABORRAR,
    BORRADO
  )
  VALUES
  (
    s_dd_ptp_plazos_tareas_plazas.nextval,
    NULL,
    NULL,
    (SELECT tap_id
    FROM BANK01.TAP_TAREA_PROCEDIMIENTO tareas
    WHERE tap_codigo='P413_BPMTramiteSubsanacionEmbargo2'
    ),
    '300*24*60*60*1000L',
    '0',
    'DD',
    sysdate,
    NULL,
    NULL,
    NULL,
    NULL,
    '0'
  );


--16. *********************************************** P413_BPMTramiteSubsanacionEmbargo3
--tramiteSubsanacionEmbargo
INSERT
INTO BANK01.TAP_TAREA_PROCEDIMIENTO
  (
    TAP_ID,
    DD_TPO_ID,
    TAP_CODIGO,
    TAP_SCRIPT_DECISION,
    TAP_SUPERVISOR,
    TAP_DESCRIPCION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO,
    TAP_AUTOPRORROGA,
    DTYPE,
    TAP_MAX_AUTOP,
    DD_STA_ID
  )
  VALUES
  (
    S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL,
    (SELECT DD_TPO_ID
    FROM BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    WHERE dd_tpo_xml_jbpm = 'tramiteAdjudicacionV4'
    ),
    'P413_BPMTramiteSubsanacionEmbargo3',
    null,
    0,
    'Llamada al BPM de Trámite de Subsanación de Adjudicación',
    0,
    'DD',
    SYSDATE,
    0,
    1,
    'EXTTareaProcedimiento',
    3,
    39
  );

INSERT
INTO BANK01.TFI_TAREAS_FORM_ITEMS
  (
    TFI_ID,
    TAP_ID,
    TFI_ORDEN,
    TFI_TIPO,
    TFI_NOMBRE,
    TFI_LABEL,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_tfi_tareas_form_items.nextval,
    (SELECT tap_id
    FROM BANK01.tap_tarea_procedimiento
    WHERE tap_codigo = 'P413_BPMTramiteSubsanacionEmbargo3'
    ),
    0,
    'label',
    'titulo',
    '<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Subsanación de Embargo.</p></div>',
    0,
    'DD',
    sysdate,
    0
  );

INSERT
INTO BANK01.dd_ptp_plazos_tareas_plazas
  (
    DD_PTP_ID,
    DD_JUZ_ID,
    DD_PLA_ID,
    TAP_ID,
    DD_PTP_PLAZO_SCRIPT,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    USUARIOMODIFICAR,
    FECHAMODIFICAR,
    USUARIOBORRAR,
    FECHABORRAR,
    BORRADO
  )
  VALUES
  (
    s_dd_ptp_plazos_tareas_plazas.nextval,
    NULL,
    NULL,
    (SELECT tap_id
    FROM BANK01.TAP_TAREA_PROCEDIMIENTO tareas
    WHERE tap_codigo='P413_BPMTramiteSubsanacionEmbargo3'
    ),
    '300*24*60*60*1000L',
    '0',
    'DD',
    sysdate,
    NULL,
    NULL,
    NULL,
    NULL,
    '0'
  );


--17. *********************************************** Actualizo las tareas que apuntan al antiguo procedimiento de Adjudicación para que apunten al nuevo
update TAP_TAREA_PROCEDIMIENTO set DD_TPO_ID_BPM=(select dd_tpo_id from DD_TPO_TIPO_PROCEDIMIENTO where dd_tpo_codigo='P413') where DD_TPO_ID_BPM=(select dd_tpo_id from DD_TPO_TIPO_PROCEDIMIENTO where dd_tpo_codigo='P05');

--18. *********************************************** Elimino el antiguo procedimiento de adjudicación de la base de datos
delete from dd_ptp_plazos_tareas_plazas where TAP_ID in (SELECT tap_id FROM tap_tarea_procedimiento WHERE DD_TPO_ID=(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where dd_tpo_codigo='P05'));

delete from TFI_TAREAS_FORM_ITEMS where TAP_ID in (SELECT tap_id FROM tap_tarea_procedimiento WHERE DD_TPO_ID=(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where dd_tpo_codigo='P05'));

delete from TAP_TAREA_PROCEDIMIENTO where DD_TPO_ID=(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where dd_tpo_codigo='P05');

delete from DD_TPO_TIPO_PROCEDIMIENTO where dd_tpo_codigo='P05';
