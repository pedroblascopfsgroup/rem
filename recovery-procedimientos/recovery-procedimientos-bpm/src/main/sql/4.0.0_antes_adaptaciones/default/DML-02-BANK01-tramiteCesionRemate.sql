--1. en caso de haber dado de alta el antiguo trámite de cesión de remate lo eliminaremos de la base de datos para crear el nuevo
--1.1 Eliminar plazos de tareas
DELETE
FROM BANK01.dd_ptp_plazos_tareas_plazas
WHERE tap_id IN
  (SELECT t.tap_id
  FROM BANK01.dd_tpo_tipo_procedimiento p
  INNER JOIN BANK01.TAP_TAREA_PROCEDIMIENTO t
  ON t.dd_tpo_id       =p.dd_tpo_id
  WHERE p.dd_tpo_codigo='P65'
  );
--1.2 Eliminar items de tareas
DELETE
FROM BANK01.TFI_TAREAS_FORM_ITEMS
WHERE tap_id IN
  (SELECT t.tap_id
  FROM BANK01.dd_tpo_tipo_procedimiento p
  INNER JOIN BANK01.TAP_TAREA_PROCEDIMIENTO t
  ON t.dd_tpo_id       =p.dd_tpo_id
  WHERE p.dd_tpo_codigo='P65'
  );
--1.3 Eliminar tareas
DELETE
FROM BANK01.TAP_TAREA_PROCEDIMIENTO
WHERE tap_id IN
  (SELECT t.tap_id
  FROM BANK01.dd_tpo_tipo_procedimiento p
  INNER JOIN BANK01.TAP_TAREA_PROCEDIMIENTO t
  ON t.dd_tpo_id       =p.dd_tpo_id
  WHERE p.dd_tpo_codigo='P65'
  );


--2. Daremos de alta el nuevo trámite

--2.1 Procedimiento
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
    'P410',
    'T. de cesión de remate',
    'T. de cesión de remate',
    'tramiteCesionRemateV4',
    0,
    'DD',
    SYSDATE,
    0,
    (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AP'),
    1,
    'MEJTipoProcedimiento'
  );

--2.2 Tareas del procedimiento y sus Tareas_Form_Items

--******************************** Tarea P410_AperturaPlazo ****************************
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
    WHERE dd_tpo_xml_jbpm = 'tramiteCesionRemateV4'
    ),
    'P410_AperturaPlazo',
    '( valores[''P410_AperturaPlazo''][''comboFinaliza''] == DDSiNo.SI ? ''SI'':''NO'')',
    0,
    'Apertura plazo cesión de remate',
    0,
    'DD',
    SYSDATE,
    0,
    1,
    'EXTTareaProcedimiento',
    3,
    39
  );

--Items tarea P410_AperturaPlazo
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
    WHERE tap_codigo = 'P410_AperturaPlazo'
    ),
    0,
    'label',
    'titulo',
    '<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En caso de que la entidad haya dado instrucciones específicas para la cesión de remate, éstas aparecerán precargadas en el campo instrucciones. De manera inmediata a la celebración de la subasta, deberán realizarse las gestiones necesarias con el Juzgado para que se abra el plazo de cesión de remate. En el caso de no realizarse las mismas, deberá comunicar a su gestor el motivo por el que no se considera necesario.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla y en el caso de haber realizado las gestiones necesarias para la cesión de remate se lanzará la tarea "Registrar comparecencia", en caso contrario se in se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</p></div>',
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
    WHERE tap_codigo = 'P410_AperturaPlazo'
    ),
    1,
    'combo',
    'comboFinaliza',
    'Realizadas gestiones',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null '
    ||'&'
    ||'&'
    ||' valor != '''' ? true : false',
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
    WHERE tap_codigo = 'P410_AperturaPlazo'
    ),
    2,
    'date',
    'fecha',
    'Fecha',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null '
    ||'&'
    ||'&'
    ||' valor != '''' ? true : false',
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
    WHERE tap_codigo = 'P410_AperturaPlazo'
    ),
    3,
    'textarea',
    'instrucciones',
    'Instrucciones',
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
    WHERE tap_codigo = 'P410_AperturaPlazo'
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

--Plazos tarea P410_AperturaPlazo
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
    WHERE tap_codigo='P410_AperturaPlazo'
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

--******************************** Tarea P410_ResenyarFechaComparecencia  ****************************
INSERT
INTO BANK01.TAP_TAREA_PROCEDIMIENTO
  (
    TAP_ID,
    DD_TPO_ID,
    TAP_CODIGO,
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
    TAP_ALERT_VUELTA_ATRAS
  )
  VALUES
  (
    S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL,
    (SELECT DD_TPO_ID
    FROM BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    WHERE dd_tpo_xml_jbpm = 'tramiteCesionRemateV4'
    ),
    'P410_ResenyarFechaComparecencia',
    0,
    'Reseñar fecha de comparecencia',
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

--Items tarea P410_ResenyarFechaComparecencia
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
    WHERE tap_codigo = 'P410_ResenyarFechaComparecencia'
    ),
    0,
    'label',
    'titulo',
    '<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En esta pantalla, deberá consignar la fecha que ha señalado el juzgado para la realización de la comparecencia en la que se formalizará la cesión de remate.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzará la tarea "Registrar realización cesión de remate".</p></div>',
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
    WHERE tap_codigo = 'P410_ResenyarFechaComparecencia'
    ),
    1,
    'date',
    'fecha',
    'Fecha',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null '
    ||'&'
    ||'&'
    ||' valor != '''' ? true : false',
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
    WHERE tap_codigo = 'P410_ResenyarFechaComparecencia'
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

--Plazos tarea P410_ResenyarFechaComparecencia
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
    WHERE tap_codigo='P410_ResenyarFechaComparecencia'
    ),
    'damePlazo(valores[''P410_AperturaPlazo''][''fecha'']) + 20*24*60*60*1000L ',
    '0',
    'DD',
    sysdate,
    NULL,
    NULL,
    NULL,
    NULL,
    '0'
  );

--******************************** Tarea P410_RealizacionCesionRemate  ****************************
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
    TAP_ALERT_VUELTA_ATRAS
  )
  VALUES
  (
    S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL,
    (SELECT DD_TPO_ID
    FROM BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    WHERE dd_tpo_xml_jbpm = 'tramiteCesionRemateV4'
    ),
    'P410_RealizacionCesionRemate',
    '( valores[''P410_RealizacionCesionRemate''][''comboTitularizado''] == DDSiNo.SI ? ''SI'':''NO'')',
    0,
    'Realización de la cesión de remate',
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

--Items tarea P410_RealizacionCesionRemate
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
    WHERE tap_codigo = 'P410_RealizacionCesionRemate'
    ),
    0,
    'label',
    'titulo',
    '<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En esta pantalla, se deberá poner la fecha en la que se formaliza la comparecencia para la cesión del remate. En el caso de no celebración de la comparecencia, se habrá de solicitar autoprórroga.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En caso de corresponder los bienes a un fondo titularizado deberá de consignar dicha circunstancia.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene ésta tarea, en caso de haber indicado que los bienes pertenecen a un fondo titularizado se iniciará el trámite de posesión, en caso contrario se lanzará una tarea por la cual propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</p></div>',
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
    WHERE tap_codigo = 'P410_RealizacionCesionRemate'
    ),
    1,
    'date',
    'fecha',
    'Fecha',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null '
    ||'&'
    ||'&'
    ||' valor != '''' ? true : false',
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
    WHERE tap_codigo = 'P410_RealizacionCesionRemate'
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
    WHERE tap_codigo = 'P410_RealizacionCesionRemate'
    ),
    3,
    'combo',
    'comboTitularizado',
    'Titularizado',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null '
    ||'&'
    ||'&'
    ||' valor != '''' ? true : false',
    'DDSiNo',
    0,
    'DD',
    sysdate,
    0
  );

--Plazos tarea P410_RealizacionCesionRemate
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
    WHERE tap_codigo='P410_RealizacionCesionRemate'
    ),
    'damePlazo(valores[''P410_ResenyarFechaComparecencia''][''fecha'']) + 5*24*60*60*1000L ',
    '0',
    'DD',
    sysdate,
    NULL,
    NULL,
    NULL,
    NULL,
    '0'
  );

--******************************** Tarea Decision1  ****************************
INSERT
INTO BANK01.TAP_TAREA_PROCEDIMIENTO
  (
    TAP_ID,
    DD_TPO_ID,
    TAP_CODIGO,
    DD_TPO_ID_BPM,
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
    WHERE dd_tpo_xml_jbpm = 'tramiteCesionRemateV4'
    ),
    'Decision1',
    441,
    0,
    'Toma decisión cesión de remate',
    0,
    'DD',
    SYSDATE,
    0,
    1,
    'EXTTareaProcedimiento',
    3,
    39
  );

--Items tarea Decision1
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
    (SELECT tap_id FROM BANK01.tap_tarea_procedimiento WHERE tap_codigo = 'Decision1'
    ),
    0,
    'label',
    'titulo',
    '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Debe acceder a la pestaña "Decisiones" y derivar en la actuación que corresponda</p></div>',
    0,
    'DD',
    sysdate,
    0
  );

--******************************** Tarea P410_BPMTramiteAdjudicacion  ****************************
INSERT
INTO BANK01.TAP_TAREA_PROCEDIMIENTO
  (
    TAP_ID,
    DD_TPO_ID,
    TAP_CODIGO,
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
    DD_TPO_ID_BPM
  )
  VALUES
  (
    S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL,
    (SELECT DD_TPO_ID
    FROM BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    WHERE dd_tpo_xml_jbpm = 'tramiteCesionRemateV4'
    ),
    'P410_BPMTramiteAdjudicacion',
    0,
    'Trámite de Adjudicación',
    0,
    'DD',
    SYSDATE,
    0,
    1,
    'EXTTareaProcedimiento',
    3,
    39,
    (select dd_tpo_id from BANK01.dd_tpo_tipo_procedimiento where dd_tpo_codigo='P05')
  );

--Items tarea P410_BPMTramiteAdjudicacion
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
    WHERE tap_codigo = 'P410_BPMTramiteAdjudicacion'
    ),
    0,
    'label',
    'titulo',
    '<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Adjudicación.</p></div>',
    0,
    'DD',
    sysdate,
    0
  );

--Plazos tarea P410_BPMTramiteAdjudicacion
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
    WHERE tap_codigo='P410_BPMTramiteAdjudicacion'
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


--3. Elimino el tr�mite que se hab�a dado de alta en la base de datos por error
UPDATE BANK01.TAP_TAREA_PROCEDIMIENTO
SET DD_TPO_ID_BPM=
  (SELECT dd_tpo_id FROM BANK01.DD_TPO_TIPO_PROCEDIMIENTO WHERE dd_tpo_codigo='P410'
  )
WHERE DD_TPO_ID_BPM IN
  (SELECT dd_tpo_tipo_procedimiento.dd_tpo_id
  FROM BANK01.dd_tpo_tipo_procedimiento
  WHERE dd_tpo_codigo='P65'
  );
DELETE FROM BANK01.dd_tpo_tipo_procedimiento WHERE dd_tpo_codigo='P65';
