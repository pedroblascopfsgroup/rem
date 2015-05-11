
	SET DEFINE OFF;
	SET SERVEROUTPUT ON; 

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     

    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas

    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   

    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.

    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
	BEGIN
	
--1. Trámite
INSERT
INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
  (
    DD_TPO_ID,
    DD_TPO_CODIGO,
    DD_TPO_DESCRIPCION,
    DD_TPO_DESCRIPCION_LARGA,
    DD_TPO_HTML,
    DD_TPO_XML_JBPM,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    USUARIOMODIFICAR,
    FECHAMODIFICAR,
    USUARIOBORRAR,
    FECHABORRAR,
    BORRADO,
    DD_TAC_ID,
    DD_TPO_SALDO_MIN,
    DD_TPO_SALDO_MAX,
    FLAG_PRORROGA,
    DTYPE,
    FLAG_DERIVABLE,
    FLAG_UNICO_BIEN
  )
  VALUES
  (
    BANK01.S_DD_TPO_TIPO_PROCEDIMIENTO.nextval,
    'P408',
    'T. fase convenio',
    'T. fase convenio',
    NULL,
    'tramiteFaseConvenioV4',
    '0',
    'DD',
    sysdate,
    NULL,
    NULL,
    NULL,
    NULL,
    '0',
    '3',
    NULL,
    NULL,
    '1',
    'MEJTipoProcedimiento',
    '1',
    '0'
  );
--2. Tareas
--2.1 P408_autoApertura
INSERT
INTO BANK01.TAP_TAREA_PROCEDIMIENTO
  (
    TAP_ID,
    DD_TPO_ID,
    TAP_CODIGO,
    TAP_VIEW,
    TAP_SCRIPT_VALIDACION_JBPM,
    TAP_SCRIPT_DECISION,
    DD_TPO_ID_BPM,
    TAP_SUPERVISOR,
    TAP_DESCRIPCION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO,
    TAP_ALERT_VUELTA_ATRAS,
    DD_FAP_ID,
    TAP_AUTOPRORROGA,
    DTYPE,
    TAP_MAX_AUTOP,
    DD_STA_ID
  )
  VALUES
  (
    BANK01.S_TAP_TAREA_PROCEDIMIENTO.nextval,
    (SELECT dd_tpo_id FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE dd_tpo_codigo='P408'
    ),
    'P408_autoApertura',
    NULL,
    NULL,
    NULL,
    NULL,
    0,
    'Auto apertura',
    0,
    'DD',
    sysdate,
    0,
    NULL,
    1,1,
    'EXTTareaProcedimiento',
    3,39
  );
INSERT
INTO BANK01.dd_ptp_plazos_tareas_plazas
  (
    DD_PTP_ID,
    TAP_ID,
    DD_PTP_PLAZO_SCRIPT,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_dd_ptp_plazos_tareas_plazas.nextval,
    (SELECT tap_id
    FROM TAP_TAREA_PROCEDIMIENTO
    WHERE tap_codigo='P408_autoApertura'
    ),
    '3*24*60*60*1000L',
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_autoApertura'
    ),
    0,
    'label',
    'titulo',
    '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Consignar fecha en la que se nos notifica auto por el que se inicia la fase de convenio, así como la fecha en la que se celebrará la junta de acreedores.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.
Una vez rellene esta pantalla se iniciarán dos tareas, "Decidir sobre fase de convenios", (tarea que deberá ser completada por el Supervisor asignado a la actuación), y otra, correspondiente al gestor, denominada "Realizar valoración del concurso".</p></div>',
    NULL,
    NULL,
    NULL,
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_autoApertura'
    ),
    1,
    'date',
    'fechaFase',
    'Fecha auto fase convenio',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null && valor != '''' ? true : false',
    NULL,
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_autoApertura'
    ),
    2,
    'date',
    'fechaJunta',
    'Fecha junta de acreedores',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null && valor != '''' ? true : false',
    NULL,
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_autoApertura'
    ),
    3,
    'textarea',
    'observaciones',
    'Observaciones',
    NULL,
    NULL,
    NULL,
    0,
    'DD',
    sysdate,
    0
  );
--2.2 P408_decidirSobreFaseComun
INSERT
INTO BANK01.TAP_TAREA_PROCEDIMIENTO
  (
    TAP_ID,
    DD_TPO_ID,
    TAP_CODIGO,
    TAP_VIEW,
    TAP_SCRIPT_VALIDACION_JBPM,
    TAP_SCRIPT_DECISION,
    DD_TPO_ID_BPM,
    TAP_SUPERVISOR,
    TAP_DESCRIPCION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO,
    TAP_ALERT_VUELTA_ATRAS,
    DD_FAP_ID,
    TAP_AUTOPRORROGA,
    DTYPE,
    TAP_MAX_AUTOP,
    DD_STA_ID
  )
  VALUES
  (
    BANK01.S_TAP_TAREA_PROCEDIMIENTO.nextval,
    (SELECT dd_tpo_id FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE dd_tpo_codigo='P408'
    ),
    'P408_decidirSobreFaseComun',
    NULL,
    NULL,
    'valores[''P408_decidirSobreFaseComun''][''comboPropio''] == DDSiNo.NO ? (valores[''P408_decidirSobreFaseComun''][''comboSeguimiento''] == DDSiNo.NO ? ''terminar'' : ''soloSeguimiento'') : (valores[''P408_decidirSobreFaseComun''][''comboSeguimiento''] == DDSiNo.NO ? ''soloPropia'' : ''propiaSeguimiento'')',
    NULL,
    1,
    'Decidir sobre fase convenio',
    0,
    'DD',
    sysdate,
    0,
    NULL,
    1,1,
    'EXTTareaProcedimiento',
    3,40
  );
INSERT
INTO BANK01.dd_ptp_plazos_tareas_plazas
  (
    DD_PTP_ID,
    TAP_ID,
    DD_PTP_PLAZO_SCRIPT,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_dd_ptp_plazos_tareas_plazas.nextval,
    (SELECT tap_id
    FROM TAP_TAREA_PROCEDIMIENTO
    WHERE tap_codigo='P408_decidirSobreFaseComun'
    ),
    'damePlazo(valores[''P408_autoApertura''][''fechaFase'']) + 5*24*60*60*1000L',
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_decidirSobreFaseComun'
    ),
    0,
    'label',
    'titulo',
    '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el primer campo indíquese si se quiere que el gestor registre una propuesta de convenio de la propia entidad, en el segundo campo indíquese si se quiere realizar un seguimiento de los convenios propuestos por terceros que puedan surgir durante la fase convenio. Si ya hubiere Convenio propio de la entidad registrado, o adhesión a otro convenio propio o presentado por otros, no se deberán registrar más convenio.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px"><p>En caso de que no quiera registrar un convenio propio en estos momentos, puede hacerlo cuando quiera hasta la fecha hábil por medio del "Trámite de presentación propuesta de convenio" que le guiará para dar de alta el convenio propio en la pestaña "Convenios" de la ficha del asunto correspondiente.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez rellene esta pantalla se iniciará una tarea por cada una de las decisiones tomadas, en el caso de querer registrar un convenio propio se iniciará un "Trámite presentación de propuesta de convenio propia" o en el caso de querer hacer un seguimiento sobre otras propuestas se creará la tarea "Actualizar propuesta de convenio".</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En caso de no querer registrar ningún convenio propio o de terceros, no se lanzará ninguna otra tarea respecto al seguimiento de los convenios.</p></div>'
    ,
    NULL,
    NULL,
    NULL,
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_decidirSobreFaseComun'
    ),
    1,
    'combo',
    'comboPropio',
    'Registrar convenio propio',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null && valor != '''' ? true : false',
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
    TFI_BUSINESS_OPERATION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_decidirSobreFaseComun'
    ),
    2,
    'combo',
    'comboSeguimiento',
    'Seguimiento de otros convenios',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null && valor != '''' ? true : false',
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
    TFI_BUSINESS_OPERATION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_decidirSobreFaseComun'
    ),
    3,
    'textarea',
    'observaciones',
    'Observaciones',
    NULL,
    NULL,
    NULL,
    0,
    'DD',
    sysdate,
    0
  );
--2.3 P408_actPropuestaConvenio
INSERT
INTO BANK01.TAP_TAREA_PROCEDIMIENTO
  (
    TAP_ID,
    DD_TPO_ID,
    TAP_CODIGO,
    TAP_VIEW,
    TAP_SCRIPT_VALIDACION_JBPM,
    TAP_SCRIPT_DECISION,
    DD_TPO_ID_BPM,
    TAP_SUPERVISOR,
    TAP_DESCRIPCION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO,
    TAP_ALERT_VUELTA_ATRAS,
    DD_FAP_ID,
    TAP_AUTOPRORROGA,
    DTYPE,
    TAP_MAX_AUTOP,
    DD_STA_ID
  )
  VALUES
  (
    BANK01.S_TAP_TAREA_PROCEDIMIENTO.nextval,
    (SELECT dd_tpo_id FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE dd_tpo_codigo='P408'
    ),
    'P408_actPropuestaConvenio',
    NULL,
    NULL,
    'valores[''P408_actPropuestaConvenio''][''combo''] == DDSiNo.NO ? ''NO'' : ''SI'' ',
    NULL,
    0,
    'Actualizar propuestas de convenio',
    0,
    'DD',
    sysdate,
    0,
    NULL,
    1,1,
    'EXTTareaProcedimiento',
    3,39
  );
INSERT
INTO BANK01.dd_ptp_plazos_tareas_plazas
  (
    DD_PTP_ID,
    TAP_ID,
    DD_PTP_PLAZO_SCRIPT,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_dd_ptp_plazos_tareas_plazas.nextval,
    (SELECT tap_id
    FROM TAP_TAREA_PROCEDIMIENTO
    WHERE tap_codigo='P408_actPropuestaConvenio'
    ),
    '5*24*60*60*1000L',
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_actPropuestaConvenio'
    ),
    0,
    'label',
    'titulo',
    '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">El seguimiento de un convenio de terceros se mantendrá mientras se introduzca un "No" en el campo "Terminar seguimiento".</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para registrar los convenio propuestos por terceros deberá abrir la ficha del asunto correspondiente y en la pestaña "Convenios" darlos de alta.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez rellene esta pantalla se iniciará, en el caso de introducir un "No" esta misma tarea, en el caso de Introducir un "Si" se iniciará la tarea "Aceptar fin de seguimiento" a realizar por el supervisor asignado a la actuación.</p></div>'
    ,
    NULL,
    NULL,
    NULL,
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_actPropuestaConvenio'
    ),
    1,
    'combo',
    'combo',
    'Terminar seguimiento',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null && valor != '''' ? true : false',
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
    TFI_BUSINESS_OPERATION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_actPropuestaConvenio'
    ),
    2,
    'textarea',
    'observaciones',
    'Observaciones',
    NULL,
    NULL,
    NULL,
    0,
    'DD',
    sysdate,
    0
  );
--2.4 P408_aceptarFinSeguimiento
INSERT
INTO BANK01.TAP_TAREA_PROCEDIMIENTO
  (
    TAP_ID,
    DD_TPO_ID,
    TAP_CODIGO,
    TAP_VIEW,
    TAP_SCRIPT_VALIDACION_JBPM,
    TAP_SCRIPT_DECISION,
    DD_TPO_ID_BPM,
    TAP_SUPERVISOR,
    TAP_DESCRIPCION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO,
    TAP_ALERT_VUELTA_ATRAS,
    DD_FAP_ID,
    TAP_AUTOPRORROGA,
    DTYPE,
    TAP_MAX_AUTOP,
    DD_STA_ID
  )
  VALUES
  (
    BANK01.S_TAP_TAREA_PROCEDIMIENTO.nextval,
    (SELECT dd_tpo_id FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE dd_tpo_codigo='P408'
    ),
    'P408_aceptarFinSeguimiento',
    NULL,
    NULL,
    'valores[''P408_aceptarFinSeguimiento''][''combo''] == DDSiNo.NO ? ''NO'' : ''SI'' ',
    NULL,
    1,
    'Aceptar fin de seguimiento',
    0,
    'DD',
    sysdate,
    0,
    NULL,
    1,1,
    'EXTTareaProcedimiento',
    3,40
  );
INSERT
INTO BANK01.dd_ptp_plazos_tareas_plazas
  (
    DD_PTP_ID,
    TAP_ID,
    DD_PTP_PLAZO_SCRIPT,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_dd_ptp_plazos_tareas_plazas.nextval,
    (SELECT tap_id
    FROM TAP_TAREA_PROCEDIMIENTO
    WHERE tap_codigo='P408_aceptarFinSeguimiento'
    ),
    '5*24*60*60*1000L',
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_aceptarFinSeguimiento'
    ),
    0,
    'label',
    'titulo',
    '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Indíquese si acepta el fin de seguimiento de otros convenios propuestos por terceros.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez rellene esta pantalla se dará por concluido el seguimiento de propuestas de convenio de terceros.</p></div>',
    NULL,
    NULL,
    NULL,
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_aceptarFinSeguimiento'
    ),
    1,
    'combo',
    'combo',
    'Fin de seguimiento',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null && valor != '''' ? true : false',
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
    TFI_BUSINESS_OPERATION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_aceptarFinSeguimiento'
    ),
    2,
    'textarea',
    'observaciones',
    'Observaciones',
    NULL,
    NULL,
    NULL,
    0,
    'DD',
    sysdate,
    0
  );
--2.5 P408_BPMtramitePresentacionPropConvenio
INSERT
INTO BANK01.TAP_TAREA_PROCEDIMIENTO
  (
    TAP_ID,
    DD_TPO_ID,
    TAP_CODIGO,
    TAP_VIEW,
    TAP_SCRIPT_VALIDACION_JBPM,
    TAP_SCRIPT_DECISION,
    DD_TPO_ID_BPM,
    TAP_SUPERVISOR,
    TAP_DESCRIPCION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO,
    TAP_ALERT_VUELTA_ATRAS,
    DD_FAP_ID,
    TAP_AUTOPRORROGA,
    DTYPE,
    TAP_MAX_AUTOP,
    DD_STA_ID
  )
  VALUES
  (
    BANK01.S_TAP_TAREA_PROCEDIMIENTO.nextval,
    (SELECT dd_tpo_id FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE dd_tpo_codigo='P408'
    ),
    'P408_BPMtramitePresentacionPropConvenio',
    NULL,
    NULL,
    NULL,
    152,0,
    'Se inicia Trámite de presentación propuesta de convenio',
    0,
    'DD',
    sysdate,
    0,
    NULL,
    NULL,
    1,
    'EXTTareaProcedimiento',
    3,39
  );
INSERT
INTO BANK01.dd_ptp_plazos_tareas_plazas
  (
    DD_PTP_ID,
    TAP_ID,
    DD_PTP_PLAZO_SCRIPT,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_dd_ptp_plazos_tareas_plazas.nextval,
    (SELECT tap_id
    FROM TAP_TAREA_PROCEDIMIENTO
    WHERE tap_codigo='P408_BPMtramitePresentacionPropConvenio'
    ),
    '300*24*60*60*1000L',
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_BPMtramitePresentacionPropConvenio'
    ),
    0,
    'label',
    'titulo',
    'Se inicia Trámite de presentación propuesta de convenio',
    NULL,
    NULL,
    NULL,
    0,
    'DD',
    sysdate,
    0
  );
--2.7 P408_lecturaAceptacionInstrucciones
INSERT
INTO BANK01.TAP_TAREA_PROCEDIMIENTO
  (
    TAP_ID,
    DD_TPO_ID,
    TAP_CODIGO,
    TAP_VIEW,
    TAP_SCRIPT_VALIDACION_JBPM,
    TAP_SCRIPT_DECISION,
    DD_TPO_ID_BPM,
    TAP_SUPERVISOR,
    TAP_DESCRIPCION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO,
    TAP_ALERT_VUELTA_ATRAS,
    DD_FAP_ID,
    TAP_AUTOPRORROGA,
    DTYPE,
    TAP_MAX_AUTOP,
    DD_STA_ID
  )
  VALUES
  (
    BANK01.S_TAP_TAREA_PROCEDIMIENTO.nextval,
    (SELECT dd_tpo_id FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE dd_tpo_codigo='P408'
    ),
    'P408_lecturaAceptacionInstrucciones',
    'plugin/procedimientos/tramiteFaseConvenio/lecturaYaceptacionV4',
    ' checkPosturaEnConveniosDeTercerosOConcursado() ?  null  : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.convenioSinPostura''',
    'valores[''P408_lecturaAceptacionInstrucciones''][''comboAceptacion''] == DDSiNo.SI ? ''SI'' : ''NO'' ',
    NULL,
    0,
    'Aceptación de instrucciones',
    0,
    'DD',
    sysdate,
    0,
    'tareaExterna.cancelarTarea',
    1,1,
    'EXTTareaProcedimiento',
    3,39
  );
INSERT
INTO BANK01.dd_ptp_plazos_tareas_plazas
  (
    DD_PTP_ID,
    TAP_ID,
    DD_PTP_PLAZO_SCRIPT,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_dd_ptp_plazos_tareas_plazas.nextval,
    (SELECT tap_id
    FROM TAP_TAREA_PROCEDIMIENTO
    WHERE tap_codigo='P408_lecturaAceptacionInstrucciones'
    ),
    'damePlazo(valores[''P408_autoApertura''][''fechaJunta'']) - 5*24*60*60*1000L',
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_lecturaAceptacionInstrucciones'
    ),
    0,
    'label',
    'titulo',
    '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta pantalla el gestor atiende las instrucciones propuestas por el comité para la junta de acreedores.</p><p>Para el caso que se entienda que en las instrucciones dadas por el comité existe algún error, no deberá aceptar las mismas, explicando el motivo en el campo "Observaciones" o enviando un comunicado al supervisor. En este caso, deberá esperar a recibir, por parte del supervisor, las instrucciones que procedan.</p><p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p>Una vez rellene esta pantalla se iniciará la tarea "Registrar resultado junta de acreedores".</p></div>',
    NULL,
    NULL,
    NULL,
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_lecturaAceptacionInstrucciones'
    ),
    1,
    'date',
    'fechaJunta',
    'Fecha junta de acreedores',
    NULL,
    NULL,
    NULL,
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
    BORRADO,
    TFI_VALOR_INICIAL
  )
  VALUES
  (
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_lecturaAceptacionInstrucciones'
    ),
    2,
    'htmleditor',
    'propuestaInstrucciones',
    'Instrucciones entidad',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null && valor != '''' ? true : false',
    NULL,
    0,
    'DD',
    sysdate,
    0,
    'valores[''P408_registrarResultado''] == null ? '''' : (valores[''P408_registrarResultado''][''propuestaInstrucciones''])'
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_lecturaAceptacionInstrucciones'
    ),
    3,
    'combo',
    'comboAceptacion',
    'Leído y aceptado',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null && valor != '''' ? true : false',
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
    TFI_BUSINESS_OPERATION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_lecturaAceptacionInstrucciones'
    ),
    4,
    'textarea',
    'observaciones',
    'Observaciones',
    NULL,
    NULL,
    NULL,
    0,
    'DD',
    sysdate,
    0
  );
UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_VALOR_INICIAL='valores[''P408_autoApertura''] == null ? '''' : ( valores[''P408_autoApertura''][''fechaJunta''] )'
WHERE tap_id         =
  (SELECT tap_id
  FROM TAP_TAREA_PROCEDIMIENTO
  WHERE tap_codigo='P408_lecturaAceptacionInstrucciones'
  )
AND tfi_nombre='fechaJunta';
--2.8 P408_registrarResultado (junta acreedores)
INSERT
INTO BANK01.TAP_TAREA_PROCEDIMIENTO
  (
    TAP_ID,
    DD_TPO_ID,
    TAP_CODIGO,
    TAP_VIEW,
    TAP_SCRIPT_VALIDACION_JBPM,
    TAP_SCRIPT_DECISION,
    DD_TPO_ID_BPM,
    TAP_SUPERVISOR,
    TAP_DESCRIPCION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO,
    TAP_ALERT_VUELTA_ATRAS,
    DD_FAP_ID,
    TAP_AUTOPRORROGA,
    DTYPE,
    TAP_MAX_AUTOP,
    DD_STA_ID
  )
  VALUES
  (
    BANK01.S_TAP_TAREA_PROCEDIMIENTO.nextval,
    (SELECT dd_tpo_id FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE dd_tpo_codigo='P408'
    ),
    'P408_registrarResultado',
    'plugin/procedimientos/tramiteFaseConvenio/registrarResultadoConvenioV4',
    ' existeNumeroAuto() ? ( checkPosturaEnConveniosDeTercerosOConcursado() ? ((valores[''P408_registrarResultado''][''algunConvenio''] == DDSiNo.SI) ? ( unConvenioAprovadoEnJunta() ? null : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.noHayConvenioAprovado'' ) : (todosLosConveniosNoAdmitidos() ? null : ''tareaExterna.procedimiento.tramiteFaseConvenio.todosLosConvenioDebenEstarNoAdmitidos'')) : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.convenioSinPostura'' ) : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.noExisteNumeroAuto'' ',
    'valores[''P408_registrarResultado''][''comboAlgunConvenio''] == DDSiNo.SI ? ''SI'' : ''NO''',
    NULL,
    0,
    'Registrar resultado junta acreedores',
    0,
    'DD',
    sysdate,
    0,
    'tareaExterna.cancelarTarea',
    1,1,
    'EXTTareaProcedimiento',
    3,39
  );
INSERT
INTO BANK01.dd_ptp_plazos_tareas_plazas
  (
    DD_PTP_ID,
    TAP_ID,
    DD_PTP_PLAZO_SCRIPT,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_dd_ptp_plazos_tareas_plazas.nextval,
    (SELECT tap_id
    FROM TAP_TAREA_PROCEDIMIENTO
    WHERE tap_codigo='P408_registrarResultado'
    ),
    'damePlazo(valores[''P408_autoApertura''][''fechaJunta'']) + 2*24*60*60*1000L',
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_registrarResultado'
    ),
    0,
    'label',
    'titulo',
    '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Habiéndose celebrado la junta de acreedores, registrar el resultado de la misma. Se ha de consignar la fecha de celebración y observaciones al supervisor si da lugar a ello e indicar si se ha aprobado alguno de los convenios presentados.</p><br><p>Para dar por terminada esta tarea deberá abrir la pestaña "Convenios" de la ficha del asunto correspondiente y actualizar el estado de los convenios con el correspondiente ya sea "Aprobado en junta" o "No admitido a trámite".</p><br><p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><br><p>Una vez rellene esta pantalla la siguiente tarea será "Registrar oposición y admisión judicial".</p><br><p>En el campo "Situación concursal" deberá indicar la situación en la que queda el concurso una vez completada esta tarea.</p></div>',
    NULL,
    NULL,
    NULL,
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_registrarResultado'
    ),
    1,
    'date',
    'fechaJunta',
    'Fecha junta de acreedores',
    NULL,
    NULL,
    NULL,
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_registrarResultado'
    ),
    2,
    'combo',
    'comboAlgunConvenio',
    'Aprobación de algún convenio',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null && valor != '''' ? true : false',
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
    TFI_BUSINESS_OPERATION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_registrarResultado'
    ),
    3,
    'textarea',
    'observaciones',
    'Observaciones',
    NULL,
    NULL,
    NULL,
    0,
    'DD',
    sysdate,
    0
  );
UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_VALOR_INICIAL='valores[''P408_autoApertura''] == null ? '''' : ( valores[''P408_autoApertura''][''fechaJunta''] )'
WHERE tap_id         =
  (SELECT tap_id
  FROM TAP_TAREA_PROCEDIMIENTO
  WHERE tap_codigo='P408_registrarResultado'
  )
AND tfi_nombre='fechaJunta';
--2.9 P408_RegistrarOposicionAdmon
INSERT
INTO BANK01.TAP_TAREA_PROCEDIMIENTO
  (
    TAP_ID,
    DD_TPO_ID,
    TAP_CODIGO,
    TAP_VIEW,
    TAP_SCRIPT_VALIDACION_JBPM,
    TAP_SCRIPT_DECISION,
    DD_TPO_ID_BPM,
    TAP_SUPERVISOR,
    TAP_DESCRIPCION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO,
    TAP_ALERT_VUELTA_ATRAS,
    DD_FAP_ID,
    TAP_AUTOPRORROGA,
    DTYPE,
    TAP_MAX_AUTOP,
    DD_STA_ID
  )
  VALUES
  (
    BANK01.S_TAP_TAREA_PROCEDIMIENTO.nextval,
    (SELECT dd_tpo_id FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE dd_tpo_codigo='P408'
    ),
    'P408_RegistrarOposicionAdmon',
    NULL,
    '(((valores[''P408_RegistrarOposicionAdmon''][''comboOposicion'']==DDSiNo.SI)&&(valores[''P408_RegistrarOposicionAdmon''][''fechaOposicion''] == ''''))||((valores[''P408_RegistrarOposicionAdmon''][''comboAdmision'']==DDSiNo.SI) && (valores[''P408_RegistrarOposicionAdmon''][''fechaAdmision'']=='''')) )?''tareaExterna.error.faltaAlgunaFecha'':((valores[''P408_RegistrarOposicionAdmon''][''comboAdmision'']==DDSiNo.NO) && (valores[''P408_RegistrarOposicionAdmon''][''comboOposicion''] == DDSiNo.SI) ? ''tareaExterna.error.combinacionIncoherente'' : (((valores[''P408_RegistrarOposicionAdmon''][''comboAdmision''] == DDSiNo.SI) && (NoExisteConvenioAdmitidoTrasAprovacion()))? ''tareaExterna.procedimiento.tramiteFaseComun.faltaConvAdmitidoTA'':(((valores[''P408_RegistrarOposicionAdmon''][''comboAdmision''] == DDSiNo.NO)&&(valores[''P408_RegistrarOposicionAdmon''][''comboOposicion''] == DDSiNo.NO)&&(NoExisteConvenioNoAdmitidoTrasAprovacion()))?''tareaExterna.procedimiento.tramiteFaseComun.faltaConvenioNoAdmitidoTrasAprovacion'': null)))'
    ,
    'valores[''P408_RegistrarOposicionAdmon''][''comboAdmision''] == DDSiNo.NO ? ''NOADMISION'' : valores[''P408_RegistrarOposicionAdmon''][''comboOposicion''] == DDSiNo.SI ? ''SIOPOSICION'' : ''ADMSIOPONO''',
    NULL,
    0,
    'Registrar oposición y admisión judicial',
    0,
    'DD',
    sysdate,
    0,
    'tareaExterna.cancelarTarea',
    1,1,
    'EXTTareaProcedimiento',
    3,39
  );
INSERT
INTO BANK01.dd_ptp_plazos_tareas_plazas
  (
    DD_PTP_ID,
    TAP_ID,
    DD_PTP_PLAZO_SCRIPT,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_dd_ptp_plazos_tareas_plazas.nextval,
    (SELECT tap_id
    FROM TAP_TAREA_PROCEDIMIENTO
    WHERE tap_codigo='P408_RegistrarOposicionAdmon'
    ),
    'damePlazo(valores[''P408_autoApertura''][''fechaJunta'']) + 10*24*60*60*1000L',
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_RegistrarOposicionAdmon'
    ),
    0,
    'label',
    'titulo',
    '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta pantalla debemos indicar tanto si se ha admitido el resultado de la junta de acreedores como si hay oposición.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será:</p><p>- Si se presenta oposición: "Registrar resolución oposición"</p><p>- Si no se admite el resultado: "Registrar resultado subsanación"</p><p>- En caso de que se admita y no haya oposición se termina el trámite en curso por lo que se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</p></div>'
    ,
    NULL,
    NULL,
    NULL,
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_RegistrarOposicionAdmon'
    ),
    1,
    'combo',
    'comboAdmision',
    'Admisión',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null && valor != '''' ? true : false',
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
    TFI_BUSINESS_OPERATION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_RegistrarOposicionAdmon'
    ),
    2,
    'date',
    'fechaAdmision',
    'Fecha admisión',
    NULL,
    NULL,
    NULL,
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_RegistrarOposicionAdmon'
    ),
    3,
    'combo',
    'comboOposicion',
    'Oposición',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null && valor != '''' ? true : false',
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
    TFI_BUSINESS_OPERATION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_RegistrarOposicionAdmon'
    ),
    4,
    'date',
    'fechaOposicion',
    'Fecha oposicion',
    NULL,
    NULL,
    NULL,
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_RegistrarOposicionAdmon'
    ),
    5,
    'textarea',
    'observaciones',
    'Observaciones',
    NULL,
    NULL,
    NULL,
    0,
    'DD',
    sysdate,
    0
  );
--2.10 P408_registrarResolucionOposicion
INSERT
INTO BANK01.TAP_TAREA_PROCEDIMIENTO
  (
    TAP_ID,
    DD_TPO_ID,
    TAP_CODIGO,
    TAP_VIEW,
    TAP_SCRIPT_VALIDACION_JBPM,
    TAP_SCRIPT_DECISION,
    DD_TPO_ID_BPM,
    TAP_SUPERVISOR,
    TAP_DESCRIPCION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO,
    TAP_ALERT_VUELTA_ATRAS,
    DD_FAP_ID,
    TAP_AUTOPRORROGA,
    DTYPE,
    TAP_MAX_AUTOP,
    DD_STA_ID
  )
  VALUES
  (
    BANK01.S_TAP_TAREA_PROCEDIMIENTO.nextval,
    (SELECT dd_tpo_id FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE dd_tpo_codigo='P408'
    ),
    'P408_registrarResolucionOposicion',
    NULL,
    'todosLosConvenioEnEstadoFinal() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.noTodosLosConvneiosEstanEnEstadoFinal'' ',
    NULL,
    NULL,
    0,
    'Registrar resolución oposición',
    0,
    'DD',
    sysdate,
    0,
    'tareaExterna.cancelarTarea',
    1,1,
    'EXTTareaProcedimiento',
    3,39
  );
INSERT
INTO BANK01.dd_ptp_plazos_tareas_plazas
  (
    DD_PTP_ID,
    TAP_ID,
    DD_PTP_PLAZO_SCRIPT,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_dd_ptp_plazos_tareas_plazas.nextval,
    (SELECT tap_id
    FROM TAP_TAREA_PROCEDIMIENTO
    WHERE tap_codigo='P408_registrarResolucionOposicion'
    ),
    'damePlazo(valores[''P408_autoApertura''][''fechaJunta'']) + 10*24*60*60*1000L',
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_registrarResolucionOposicion'
    ),
    0,
    'label',
    'titulo',
    '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Consignar la fecha de notificación de la Resolución que hubiere recaído.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se indicará si el resultado de dicha resolución ha sido favorable o no.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para el supuesto de que la resolución no fuere favorable para la entidad, deberá comunicar dicha circunstancia al responsable interno de la misma a través del botón "Comunicación". Una vez reciba la aceptación del supervisor deberá gestionar el recurso por medio de la pestaña "Recursos".</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para el supuesto de anuncio del recurso por la parte contraria se deberá gestionar directamente a través de la pestaña "Recursos".</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deberá abrir la pestaña "Convenios" de la ficha del asunto correspondiente y registrar el estado que corresponda, ya sea "Aprobación judicial" o "No aprobado".</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez rellene esta pantalla se termina el trámite en curso por lo que se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</p></div>'
    ,
    NULL,
    NULL,
    NULL,
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_registrarResolucionOposicion'
    ),
    1,
    'date',
    'fecha',
    'Fecha',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null && valor != '''' ? true : false',
    NULL,
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_registrarResolucionOposicion'
    ),
    2,
    'combo',
    'comboResultado',
    'Resultado',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null && valor != '''' ? true : false',
    'DDFavorable',
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_registrarResolucionOposicion'
    ),
    3,
    'textarea',
    'observaciones',
    'Observaciones',
    NULL,
    NULL,
    NULL,
    0,
    'DD',
    sysdate,
    0
  );
--2.11 P408_registrarResultadoSubsana
INSERT
INTO BANK01.TAP_TAREA_PROCEDIMIENTO
  (
    TAP_ID,
    DD_TPO_ID,
    TAP_CODIGO,
    TAP_VIEW,
    TAP_SCRIPT_VALIDACION_JBPM,
    TAP_SCRIPT_DECISION,
    DD_TPO_ID_BPM,
    TAP_SUPERVISOR,
    TAP_DESCRIPCION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO,
    TAP_ALERT_VUELTA_ATRAS,
    DD_FAP_ID,
    TAP_AUTOPRORROGA,
    DTYPE,
    TAP_MAX_AUTOP,
    DD_STA_ID
  )
  VALUES
  (
    BANK01.S_TAP_TAREA_PROCEDIMIENTO.nextval,
    (SELECT dd_tpo_id FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE dd_tpo_codigo='P408'
    ),
    'P408_registrarResultadoSubsana',
    NULL,
    'todosLosConvenioEnEstadoFinal() ? null :''tareaExterna.procedimiento.tramiteFaseComun.noTodosLosConvneiosEstanEnEstadoFinal''',
    'valores[''P408_registrarResultadoSubsana''][''comboSubsana''] == DDSiNo.SI ? ''SI'' : ''NO''',
    NULL,
    0,
    'Registrar resultado subsanación',
    0,
    'DD',
    sysdate,
    0,
    'tareaExterna.cancelarTarea',
    1,1,
    'EXTTareaProcedimiento',
    3,39
  );
INSERT
INTO BANK01.dd_ptp_plazos_tareas_plazas
  (
    DD_PTP_ID,
    TAP_ID,
    DD_PTP_PLAZO_SCRIPT,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_dd_ptp_plazos_tareas_plazas.nextval,
    (SELECT tap_id
    FROM TAP_TAREA_PROCEDIMIENTO
    WHERE tap_codigo='P408_registrarResultadoSubsana'
    ),
    'damePlazo(valores[''P408_autoApertura''][''fechaJunta'']) + 30*24*60*60*1000L',
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_registrarResultadoSubsana'
    ),
    0,
    'label',
    'titulo',
    '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Consignar la fecha de notificación de la Resolución que hubiere recaído y el resultado de la subsanación si este es positivo o negativo.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será:</p><p>- Si se ha subsanado, una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</p><p>- Si no se ha subsanado se iniciará un trámite de liquidación.</p></div>',
    NULL,
    NULL,
    NULL,
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_registrarResultadoSubsana'
    ),
    1,
    'date',
    'fecha',
    'Fecha',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null && valor != '''' ? true : false',
    NULL,
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_registrarResultadoSubsana'
    ),
    2,
    'combo',
    'comboSubsana',
    'Subsanado',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null && valor != '''' ? true : false',
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
    TFI_BUSINESS_OPERATION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_registrarResultadoSubsana'
    ),
    3,
    'textarea',
    'observaciones',
    'Observaciones',
    NULL,
    NULL,
    NULL,
    0,
    'DD',
    sysdate,
    0
  );
--2.12 P408_BPMTramiteFaseLiquidacion
INSERT
INTO BANK01.TAP_TAREA_PROCEDIMIENTO
  (
    TAP_ID,
    DD_TPO_ID,
    TAP_CODIGO,
    TAP_VIEW,
    TAP_SCRIPT_VALIDACION_JBPM,
    TAP_SCRIPT_DECISION,
    DD_TPO_ID_BPM,
    TAP_SUPERVISOR,
    TAP_DESCRIPCION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO,
    TAP_ALERT_VUELTA_ATRAS,
    DD_FAP_ID,
    TAP_AUTOPRORROGA,
    DTYPE,
    TAP_MAX_AUTOP,
    DD_STA_ID
  )
  VALUES
  (
    BANK01.S_TAP_TAREA_PROCEDIMIENTO.nextval,
    (SELECT dd_tpo_id FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE dd_tpo_codigo='P408'
    ),
    'P408_BPMTramiteFaseLiquidacion',
    NULL,
    NULL,
    NULL,
    150,0,
    'Se inicia Trámite fase de liquidación',
    0,
    'DD',
    sysdate,
    0,
    NULL,
    1,1,
    'EXTTareaProcedimiento',
    3,39
  );
INSERT
INTO BANK01.dd_ptp_plazos_tareas_plazas
  (
    DD_PTP_ID,
    TAP_ID,
    DD_PTP_PLAZO_SCRIPT,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_dd_ptp_plazos_tareas_plazas.nextval,
    (SELECT tap_id
    FROM TAP_TAREA_PROCEDIMIENTO
    WHERE tap_codigo='P408_BPMTramiteFaseLiquidacion'
    ),
    '300*24*60*60*1000L',
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_BPMTramiteFaseLiquidacion'
    ),
    0,
    'label',
    'titulo',
    'Se inicia Trámite fase de liquidación',
    NULL,
    NULL,
    NULL,
    0,
    'DD',
    sysdate,
    0
  );
--2.13 P408_elevarAcomitePropuesta
INSERT
INTO BANK01.TAP_TAREA_PROCEDIMIENTO
  (
    TAP_ID,
    DD_TPO_ID,
    TAP_CODIGO,
    TAP_VIEW,
    TAP_SCRIPT_VALIDACION_JBPM,
    TAP_SCRIPT_DECISION,
    DD_TPO_ID_BPM,
    TAP_SUPERVISOR,
    TAP_DESCRIPCION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO,
    TAP_ALERT_VUELTA_ATRAS,
    DD_FAP_ID,
    TAP_AUTOPRORROGA,
    DTYPE,
    TAP_MAX_AUTOP,
    DD_STA_ID
  )
  VALUES
  (
    BANK01.S_TAP_TAREA_PROCEDIMIENTO.nextval,
    (SELECT dd_tpo_id FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE dd_tpo_codigo='P408'
    ),
    'P408_elevarAcomitePropuesta',
    NULL,
    NULL,
    NULL,
    NULL,
    1,
    'Elevar a comité la propuesta de instrucciones',
    0,
    'DD',
    sysdate,
    0,
    'tareaExterna.cancelarTarea',
    NULL,
    1,
    'EXTTareaProcedimiento',
    3,40
  );
INSERT
INTO BANK01.dd_ptp_plazos_tareas_plazas
  (
    DD_PTP_ID,
    TAP_ID,
    DD_PTP_PLAZO_SCRIPT,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_dd_ptp_plazos_tareas_plazas.nextval,
    (SELECT tap_id
    FROM TAP_TAREA_PROCEDIMIENTO
    WHERE tap_codigo='P408_elevarAcomitePropuesta'
    ),
    'damePlazo(valores[''P408_autoApertura''][''fechaJunta'']) - 25*24*60*60*1000L',
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_elevarAcomitePropuesta'
    ),
    0,
    'label',
    'titulo',
    '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deberá revisar el informe de valoración del concurso presentado por el letrado, para ello deberá abrir la tarea ya completada por el letrado "Realizar valoración del concurso" donde el letrado a introducido dicho informe. Una vez revisado el informe deberá de cumplimentar el campo propuesta de instrucciones, donde propondrá según su criterio las instrucciones para el concurso al comité correspondiente.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el campo Fecha indicar la fecha en que da por concluido su informe y procede a terminar la tarea.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Al dar por terminada esta tarea se creará la tarea "Registrar resultado comité" a completar por el comité correspondiente.</p></div>'
    ,
    NULL,
    NULL,
    NULL,
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_elevarAcomitePropuesta'
    ),
    1,
    'date',
    'fechaElevacion',
    'Fecha elevación a comité',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null && valor != '''' ? true : false',
    NULL,
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_elevarAcomitePropuesta'
    ),
    2,
    'htmleditor',
    'propuestaInstrucciones',
    'Propuesta de instrucciones',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null && valor != '''' ? true : false',
    NULL,
    0,
    'DD',
    sysdate,
    0
  );
--2.14 P408_registrarResultadoComite
INSERT
INTO BANK01.TAP_TAREA_PROCEDIMIENTO
  (
    TAP_ID,
    DD_TPO_ID,
    TAP_CODIGO,
    TAP_VIEW,
    TAP_SCRIPT_VALIDACION_JBPM,
    TAP_SCRIPT_DECISION,
    DD_TPO_ID_BPM,
    TAP_SUPERVISOR,
    TAP_DESCRIPCION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO,
    TAP_ALERT_VUELTA_ATRAS,
    DD_FAP_ID,
    TAP_AUTOPRORROGA,
    DTYPE,
    TAP_MAX_AUTOP,
    DD_STA_ID
  )
  VALUES
  (
    BANK01.S_TAP_TAREA_PROCEDIMIENTO.nextval,
    (SELECT dd_tpo_id FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE dd_tpo_codigo='P408'
    ),
    'P408_registrarResultadoComite',
    NULL,
    NULL,
    '(valores[''P408_registrarResultadoComite''][''comboResultado''] == ''CONCEDIDO'' ? ''Concedido'':(valores[''P408_registrarResultadoComite''][''comboResultado''] == ''CONCONMOD'' ? ''ConcedidoConModificaciones'' :(valores[''P408_registrarResultadoComite''][''comboResultado''] == ''MODIFICAR'' ? ''Modificar'':''Denegado'')))',
    null,
    1,
    'Registrar el resultado del comité',
    0,
    'DD',
    sysdate,
    0,
    'tareaExterna.cancelarTarea',
    NULL,
    1,
    'EXTTareaProcedimiento',
    3,40
  );
INSERT
INTO BANK01.dd_ptp_plazos_tareas_plazas
  (
    DD_PTP_ID,
    TAP_ID,
    DD_PTP_PLAZO_SCRIPT,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_dd_ptp_plazos_tareas_plazas.nextval,
    (SELECT tap_id
    FROM TAP_TAREA_PROCEDIMIENTO
    WHERE tap_codigo='P408_registrarResultadoComite'
    ),
    'damePlazo(valores[''P408_autoApertura''][''fechaJunta'']) - 10*24*60*60*1000L',
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_registrarResultadoComite'
    ),
    0,
    'label',
    'titulo',
    '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez celebrado el Comité deberá consignar la fecha en que haya resuelto sobre la propuesta y el resultado de la misma. En el campo "Instrucciones propuestas" podrá modificar si así fuera necesario, las instrucciones propuestas por el supervisor de manera que estas lleguen al letrado.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez cumplimentada esta tarea y dependiendo del resultado del comité, la siguiente tarea será:</p><p>- Concedido, en cuyo caso la siguiente tarea será "Lectura y aceptación de instrucciones" a completar por el letrado concursal.</p><p>- Concedido con modificaciones, el convenio ha sido modificado por el comité y por tanto la siguiente tarea será "Lectura y aceptación de instrucciones" a completar por el letrado concursal.</p><p>- Modificar, el convenio requiere de algunas modificaciones las cuales deben ser realizadas por el supervisor, en este caso la siguiente tarea volvería a ser "Elevar a comité propuesta de instrucciones" a realizar por el supervisor del concurso.</p><p>- Denegada, en cuyo caso se abrirá una tarea en la que el letrado concursal deberá proponer, según su criterio, la siguiente actuación al responsable de la entidad.</p></div>'
    ,
    NULL,
    NULL,
    NULL,
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_registrarResultadoComite'
    ),
    1,
    'date',
    'fechaAprobacion',
    'Fecha de obtención de aprobación',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null && valor != '''' ? true : false',
    NULL,
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
    BORRADO,
    TFI_VALOR_INICIAL
  )
  VALUES
  (
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_registrarResultadoComite'
    ),
    2,
    'htmleditor',
    'propuestaInstrucciones',
    'Instrucciones propuestas',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null && valor != '''' ? true : false',
    NULL,
    0,
    'DD',
    sysdate,
    0,
    'valores[''P408_elevarAcomitePropuesta''] == null ? '''' : (valores[''P408_elevarAcomitePropuesta''][''propuestaInstrucciones''])'
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
    WHERE tap_codigo = 'P408_registrarResultadoComite'
    ),
    3,
    'combo',
    'comboResultado',
    'Resultado',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null '
    ||'&'
    ||'&'
    ||' valor != '''' ? true : false',
    'DDResultadoComiteConcursal',
    0,
    'DD',
    sysdate,
    0
  );
--2.15 P408_realizarValoracionConcurso
INSERT
INTO BANK01.TAP_TAREA_PROCEDIMIENTO
  (
    TAP_ID,
    DD_TPO_ID,
    TAP_CODIGO,
    TAP_VIEW,
    TAP_SCRIPT_VALIDACION_JBPM,
    TAP_SCRIPT_DECISION,
    DD_TPO_ID_BPM,
    TAP_SUPERVISOR,
    TAP_DESCRIPCION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO,
    DD_FAP_ID,
    TAP_AUTOPRORROGA,
    DTYPE,
    TAP_MAX_AUTOP,
    DD_STA_ID
  )
  VALUES
  (
    BANK01.S_TAP_TAREA_PROCEDIMIENTO.nextval,
    (SELECT dd_tpo_id FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE dd_tpo_codigo='P408'
    ),
    'P408_realizarValoracionConcurso',
    NULL,
    NULL,
    NULL,
    NULL,
    0,
    'Realizar la valoración del concurso',
    0,
    'DD',
    sysdate,
    0,
    NULL,
    1,
    'EXTTareaProcedimiento',
    3,39
  );
INSERT
INTO BANK01.dd_ptp_plazos_tareas_plazas
  (
    DD_PTP_ID,
    TAP_ID,
    DD_PTP_PLAZO_SCRIPT,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    s_dd_ptp_plazos_tareas_plazas.nextval,
    (SELECT tap_id
    FROM TAP_TAREA_PROCEDIMIENTO
    WHERE tap_codigo='P408_realizarValoracionConcurso'
    ),
    'damePlazo(valores[''P408_autoApertura''][''fechaJunta'']) - 30*24*60*60*1000L',
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_realizarValoracionConcurso'
    ),
    0,
    'label',
    'titulo',
    '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deberá indicar si se ha presentado algún convenio o no, en caso de contestar afirmativamente deberá abrir la pestaña "Convenios" de la ficha del asunto correspondiente y comprobar que al menos un convenio haya quedado registrado, en caso de no estarlo ya deberá proceder a su registro debiendo indicar si es de tipo Ordinario o Anticipado, el estado en el que se encuentra y la postura de la Entidad, así como el contenido del mismo respecto de cada tipología de créditos. Si el convenio tiene varias alternativas de adhesión deberán registrarse todas ellas.</p><br><p>En el campo Informe deberá introducir el informe que quiere remitir a su supervisor en la entidad. No olvide indicar, en caso de adherirnos a un convenio, si la propuesta de adhesión se refiere exclusivamente a los créditos ordinarios o por el contrario incluye también los privilegiados, así como cualquier otro comentario considerado como relevante.</p><br><p>En el campo Fecha indicar la fecha en que da por concluido su informe y procede a terminar la tarea.</p><br><p>Una vez complete esta tarea la siguiente tarea será "Elevar a comité propuesta de instrucciones" a realizar por el supervisor del concurso.</p></div>'
    ,
    NULL,
    NULL,
    NULL,
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_realizarValoracionConcurso'
    ),
    1,
    'date',
    'fechaConclusionInforme',
    'Fecha',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null && valor != '''' ? true : false',
    NULL,
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
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_realizarValoracionConcurso'
    ),
    2,
    'combo',
    'comboConvenioPresentado',
    'Se ha presentado algún convenio',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null && valor != '''' ? true : false',
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
    TFI_BUSINESS_OPERATION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_realizarValoracionConcurso'
    ),
    3,
    'htmleditor',
    'informe',
    'Informe',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null && valor != '''' ? true : false',
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
    TFI_BUSINESS_OPERATION,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    S_TFI_TAREAS_FORM_ITEMS.nextval,
    (SELECT t.tap_id
    FROM TAP_TAREA_PROCEDIMIENTO t
    WHERE t.tap_codigo='P408_realizarValoracionConcurso'
    ),
    4,
    'textarea',
    'observaciones',
    'Observaciones',
    NULL,
    NULL,
    NULL,
    0,
    'DD',
    sysdate,
    0
  );
--3. Elimino el trámite antiguo P29
DELETE
FROM dd_ptp_plazos_tareas_plazas
WHERE TAP_ID IN
  (SELECT tap_id
  FROM tap_tarea_procedimiento
  WHERE DD_TPO_ID=
    (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE dd_tpo_codigo='P29'
    )
  );
DELETE
FROM TFI_TAREAS_FORM_ITEMS
WHERE TAP_ID IN
  (SELECT tap_id
  FROM tap_tarea_procedimiento
  WHERE DD_TPO_ID=
    (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE dd_tpo_codigo='P29'
    )
  );
DELETE
FROM TAP_TAREA_PROCEDIMIENTO
WHERE DD_TPO_ID=
  (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE dd_tpo_codigo='P29'
  );
UPDATE TAP_TAREA_PROCEDIMIENTO
SET dd_tpo_id_bpm=
  (SELECT dd_tpo_id FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE dd_tpo_codigo='P408'
  )
WHERE dd_tpo_id_bpm=
  (SELECT dd_tpo_id FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE dd_tpo_codigo='P29'
  );
DELETE FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE dd_tpo_codigo='P29';

  
  
  COMMIT;
  
  
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