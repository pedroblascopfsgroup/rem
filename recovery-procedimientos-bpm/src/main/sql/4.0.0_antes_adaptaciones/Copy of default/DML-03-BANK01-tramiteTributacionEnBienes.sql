
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
	
	
	--Nuevo Trámite de Tributación en Bienes
--1. Nuevo Procedimiento
Insert into BANK01.DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TAC_ID,DTYPE) Values(S_DD_TPO_TIPO_PROCEDIMIENTO.NEXTVAL, 'P411', 'Trámite tributación en bienes', 'Trámite tributación en bienes','tramiteTributacionEnBienesV4', 0, 'DD', sysdate, 0, (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AP'),'MEJTipoProcedimiento');

--2. Tareas

--2.1 P411_ConsultarTributacionDeBienes
INSERT INTO BANK01.tap_tarea_procedimiento
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
     VALUES (
S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL,
    (SELECT DD_TPO_ID
    FROM BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    WHERE dd_tpo_xml_jbpm = 'tramiteTributacionEnBienesV4'
    ),
    'P411_ConsultarTributacionDeBienes',
    0,
    'Consultar la tributación de los bienes',
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

--2.1.1 Plazos
INSERT INTO BANK01.dd_ptp_plazos_tareas_plazas
            (dd_ptp_id, tap_id, dd_ptp_plazo_script, VERSION, usuariocrear, fechacrear, borrado
            )
     VALUES (s_dd_ptp_plazos_tareas_plazas.NEXTVAL, (SELECT tap_id
                                                       FROM BANK01.tap_tarea_procedimiento
                                                      WHERE tap_codigo = 'P411_ConsultarTributacionDeBienes'), '5*24*60*60*1000L', 0, 'DD', SYSDATE, 0
            );

--2.1.2 Ítems
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
    WHERE tap_codigo = 'P411_ConsultarTributacionDeBienes'
    ),
    0,
    'label',
    'titulo',
    '<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por completada esta tarea deberá remitir consulta de tributación para los bienes afectos a la subasta, estos bienes los podrá identificar a través de la pestaña Subastas del asunto correspondiente.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se considerará bien afecto a esta tarea aquellos bienes que pertenezcan a persona jurídica o en cualquier caso aquellos bienes de tipo Suelo, Promociones o Bajos.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Recuerde que para poder tramitar la consulta, deberá enviar al destinatario de la consulta tanto la propuesta de subasta como la tasación de todos los inmuebles afectos a la subasta, esta documentación la puede encontrar en la pestaña Adjuntos del asunto correspondiente.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo “Gestoría” deberá informar de la Gestoría a la cual realiza la consulta de tributación.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzará la tarea “Registrar resolución consulta”.</p></div>',
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
    WHERE tap_codigo = 'P411_ConsultarTributacionDeBienes'
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
    WHERE tap_codigo = 'P411_ConsultarTributacionDeBienes'
    ),
    2,
    'combo',
    'comboGestorias',
    'Gestorías',
    'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
    'valor != null '||'&'||'&'||' valor != '''' ? true : false',
    'DDGestoria',
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
    WHERE tap_codigo = 'P411_ConsultarTributacionDeBienes'
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

--2.2 P411_RegistrarResolucionConsulta
--2.2.1 Tarea
INSERT INTO BANK01.tap_tarea_procedimiento
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
    TAP_ALERT_VUELTA_ATRAS,
    TAP_SCRIPT_VALIDACION
            )
     VALUES (
S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL,
    (SELECT DD_TPO_ID
    FROM BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    WHERE dd_tpo_xml_jbpm = 'tramiteTributacionEnBienesV4'
    ),
    'P411_RegistrarResolucionConsulta',
    0,
    'Registrar la Resolución de la Consulta',
    0,
    'DD',
    SYSDATE,
    0,
    1,
    'EXTTareaProcedimiento',
    3,
    100,
    'tareaExterna.cancelarTarea',
    'comprobarExisteDocumentoRCT() ? null : ''Es necesario adjuntar el documento respuesta a la consulta de tributación'''
            );
--2.2.2 Plazo
INSERT INTO BANK01.dd_ptp_plazos_tareas_plazas
            (dd_ptp_id, tap_id, dd_ptp_plazo_script, VERSION, usuariocrear, fechacrear, borrado
            )
     VALUES (s_dd_ptp_plazos_tareas_plazas.NEXTVAL, (SELECT tap_id
                                                       FROM BANK01.tap_tarea_procedimiento
                                                      WHERE tap_codigo = 'P411_RegistrarResolucionConsulta'), 'damePlazo(valores[''P411_ConsultarTributacionDeBienes''][''fecha'']) + 10*24*60*60*1000L', 0, 'DD', SYSDATE, 0
            );

--2.2.3 Ítems
INSERT INTO BANK01.tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, VERSION, usuariocrear, fechacrear, borrado
            )
     VALUES (s_tfi_tareas_form_items.NEXTVAL, (SELECT tap_id
                                                 FROM BANK01.tap_tarea_procedimiento
                                                WHERE tap_codigo = 'P411_RegistrarResolucionConsulta'), 0, 'label', 'titulo', '<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por completada esta tarea deberá por un lado adjuntar al procedimiento el documento con la respuesta íntegra a la consulta de tributación realizada, y por otro, para cada uno de los bienes consultados deberá de añadir la respuesta en el campo “Respuesta a la consulta de tributación” de la ficha de cada uno de los bienes. De esta forma los usuarios intervinientes en el proceso de liquidación de impuestos podrán tener acceso a esta información en el momento una vez se obtenga la documentación (testimonio del decreto de adjudicación) en su caso.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo Fecha deberá consignar la fecha en que haya obtenido respuesta a la consulta de tributación planteada.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzará la tarea “Registrar resolución consulta”.</p></div>', 0, 'DD', SYSDATE, 0
            );             

INSERT INTO BANK01.tfi_tareas_form_items
(tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, VERSION, usuariocrear, fechacrear, borrado
)
VALUES (s_tfi_tareas_form_items.NEXTVAL, (SELECT tap_id
                                 FROM BANK01.tap_tarea_procedimiento
                                WHERE tap_codigo = 'P411_RegistrarResolucionConsulta'), 1, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0
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
    WHERE tap_codigo = 'P411_RegistrarResolucionConsulta'
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
    WHERE dd_tpo_xml_jbpm = 'tramiteTributacionEnBienesV4'
    ),
    'P411_Decision1',
    441,
    0,
    'Toma decisión Tributación en Bienes',
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
    (
	SELECT tap_id 
	FROM BANK01.tap_tarea_procedimiento t
	WHERE t.tap_codigo = 'P411_Decision1'
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