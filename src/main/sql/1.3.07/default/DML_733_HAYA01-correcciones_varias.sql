/*
--######################################################################
--## Author: Roberto
--## Finalidad: Correciones de instrucciones de BPM - http://link.pfsgroup.es/jira/browse/HR-574
--## INSTRUCCIONES: Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--######################################################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
  V_MSQL           VARCHAR2(32000 CHAR);             -- Sentencia a ejecutar
  V_ESQUEMA        VARCHAR2(25 CHAR):= 'HAYA01';     -- Configuracion Esquemas
  V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquemas
  V_SQL            VARCHAR2(4000 CHAR);              -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS     NUMBER(16);                       -- Vble. para validar la existencia de una tabla.
  ERR_NUM          NUMBER(25);                       -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG          VARCHAR2(1024 CHAR);              -- Vble. auxiliar para registrar errores en el script.
  VAR_TABLENAME    VARCHAR2(50 CHAR);                -- Nombre de la tabla a crear
  VAR_SEQUENCENAME VARCHAR2(50 CHAR);                -- Nombre de la tabla a crear
BEGIN
  UPDATE tfi_tareas_form_items
  SET tfi_label=
    '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Antes de dar por completada esta tarea deberá de haber un bien vinculado al procedimiento, esto podrá comprobarlo a través de la pestaña Bienes del procedimiento, en caso de no haberlo, a través de esa misma pestaña dispone de la opción de Agregar por la cual se le permite vincular un bien al procedimiento.</p><p style="margin-bottom: 10px">A través de esta tarea deberá de informar si hay una posible posesión o no, en caso de que proceda, la fecha de solicitud de la posesión, si el bien se encuentra ocupado o no, si se ha producido una petición de moratoria y en cualquier caso se deberá informar la condición del bien respecto a si es vivienda habitual o no.</p><p style="margin-bottom: 10px">En caso de que no haya ningún bien vinculado al procedimiento, deberá vincularlo a través de la pestaña Bienes del procedimiento.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla y dependiendo de la información registrada se lanzará:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">En caso de haber solicitud de moratoria de posesión se iniciará el trámite para tal efecto.</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de encontrarse el bien con ocupantes, se lanzará el trámite de ocupantes.</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de encontrarse el bien sin ocupantes, se lanzará la tarea "Registrar señalamiento de posesión"</li><li style="margin-bottom: 10px; margin-left: 35px;">En el caso de que el bien no esté en ninguna de las situaciones expuestas y no haya una posible posesión, se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</li></ul></div>'
  WHERE tfi_nombre='titulo'
  AND tap_id      =
    (SELECT tap_id
    FROM tap_tarea_procedimiento
    WHERE tap_codigo='H015_RegistrarSolicitudPosesion'
    );
  UPDATE tfi_tareas_form_items
  SET tfi_label   ='<div align="justify" style="margin-bottom: 30px;"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Para dar por completada esta tarea deberá de informar la fecha de señalamiento para la posesión. </span></font></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">Una vez completada esta tarea se lanzará la tarea Registrar posesión y decisión sobre lanzamiento.</span></p></div>'
  WHERE tfi_nombre='titulo'
  AND tap_id      =
    (SELECT tap_id
    FROM tap_tarea_procedimiento
    WHERE tap_codigo='H015_RegistrarSenyalamientoPosesion'
    );
  UPDATE tfi_tareas_form_items
  SET tfi_label=
    '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deberá informar en primer lugar si el bien se encuentra ocupado, y en caso negativo indicar la fecha de realización de la posesión, necesario fuerza pública y si el lanzamiento es necesario o no.</p><p style="margin-bottom: 10px">En caso de haberse producido la posesión deberá de adjuntar al procedimiento el documento "Diligencia judicial de la posesión"</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez completada esta tarea se lanzará:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">En caso de haber marcado el bien como ocupado, se lanzará el trámite de ocupantes.</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de Lanzamiento necesario se lanzará la tarea "Registrar señalamiento del lanzamiento".</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de no ser necesario el lanzamiento se lanzará la tarea "Registrar decisión sobre llaves".</li></ul></div>'
  WHERE tfi_nombre='titulo'
  AND tap_id      =
    (SELECT tap_id
    FROM tap_tarea_procedimiento
    WHERE tap_codigo='H015_RegistrarPosesionYLanzamiento'
    );
  UPDATE tfi_tareas_form_items
  SET tfi_label   ='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deberá de infomar la fecha de señalamiento para el lanzamiento.</p><p style="margin-bottom: 10px">En el campo observaciones infomar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzará la tarea "Registrar lanzamiento efectivo".</p></div>'
  WHERE tfi_nombre='titulo'
  AND tap_id      =
    (SELECT tap_id
    FROM tap_tarea_procedimiento
    WHERE tap_codigo='H015_RegistrarSenyalamientoLanzamiento'
    );
  UPDATE tfi_tareas_form_items
  SET tfi_label   ='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deberá de informar la fecha de lanzamiento efectivo así como dejar indicado si ha sido necesario el uso de la fuerza pública o no.</p><p style="margin-bottom: 10px">En caso de haberse producido el lanzamiento deberá de adjuntar al procedimiento el documento "Diligencia judicial del lanzamiento"</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzará la tarea "Registrar decisión sobre llaves".</p></div>'
  WHERE tfi_nombre='titulo'
  AND tap_id      =
    (SELECT tap_id
    FROM tap_tarea_procedimiento
    WHERE tap_codigo='H015_RegistrarLanzamientoEfectuado'
    );
  UPDATE tfi_tareas_form_items
  SET tfi_label   ='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deberá dejar constancia de si es necesario realizar una gestión de las llaves por cambio de cerradura, o no.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla y en el caso de ser necesaria una gestión de las llaves se iniciará el trámite para la gestión de llaves, en caso contrario se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad. </p></div>'
  WHERE tfi_nombre='titulo'
  AND tap_id      =
    (SELECT tap_id
    FROM tap_tarea_procedimiento
    WHERE tap_codigo='H015_RegistrarDecisionLlaves'
    );
  UPDATE tfi_tareas_form_items
  SET tfi_label=
    '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta pantalla deberá de informar la fecha en la que se notifica por el Juzgado el Decreto de Adjudicación, la entidad adjudicataria de los bienes afectos.</p><p style="margin-bottom: 10px">Deberá revisar que el Decreto es conforme a la subasta celebrada y contiene lo preceptuado para su correcta inscripción en el Registro de la Propiedad, para ello deberá revisar:</p><p style="margin-bottom: 10px; margin-left: 40px;"></p><ul><li><span style="font-size: 8pt;">Datos procesales básicos: (Nº autos, tipo de procedimiento, cantidad reclamada)</span></li><li><span style="font-size: 8pt;">Datos de la Entidad demandante (nombre CIF, domicilio) y de los adjudicatarios</span></li><li><span style="font-size: 8pt;">Datos  de los demandados y titulares registrales.</span></li><li><span style="font-size: 8pt;">Importe de adjudicación.</span></li><li><span style="font-size: 8pt;">Orden de cancelación de la nota marginal y cancelación de la carga objeto de ejecución así como cargas   posteriores)</span></li><li><span style="font-size: 8pt;">Descripción  y datos registrales completos de la finca adjudicada.</span></li><li><span style="font-size: 8pt;">Declaración en el auto de la firmeza de la resolución</span></li></ul><p></p><p style="margin-bottom: 10px">Una vez analizados los puntos descritos, en el campo Requiere subsanación deberá indicar el resultado de dicho análisis.</p><p style="margin-bottom: 10px">Una vez emitido el Auto Decreto de Adjudicación y si la operación está sujeta a IVA o IGIC (recogido en la ficha del bien), se lanzará la tarea "Declarar IVA e IGIC". En caso de que no estuviese informado, deberá enviar notificación al Área Fiscal para le informe del tipo de tributación y completar este dato en la ficha del Bien.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzará, en caso de requerir subsanación, el Trámite de subsanación de adjudicación, en caso contrario se lanzará la tarea "Notificación decreto adjudicación al contrario".</p></div>'
  WHERE tfi_nombre='titulo'
  AND tap_id      =
    (SELECT tap_id
    FROM tap_tarea_procedimiento
    WHERE tap_codigo='H005_notificacionDecretoAdjudicacionAEntidad'
    );
  UPDATE tfi_tareas_form_items
  SET tfi_label   ='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que la entidad ya ha tomado una postura frente al acuerdo propuesto, a través de esta pantalla deberá indicar la conformidad con dicha postura. En el campo Fecha deberá consignar la fecha en que de por aceptadas las instrucciones dictadas por la entidad.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será, en caso de no haber acuerdo se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad. En caso de sí haber habido acuerdo, sea favorable o no se creará la tarea "Registrar resolución homologación judicial".</p></div>'
  WHERE tfi_nombre='titulo'
  AND tap_id      =
    (SELECT tap_id
    FROM tap_tarea_procedimiento
    WHERE tap_codigo='H027_LecturaAceptacionInstrucciones'
    );
    
update tap_tarea_procedimiento
  set tap_descripcion='Lectura y aceptación de instrucciones'
  where tap_codigo='H027_LecturaAceptacionInstrucciones';
    
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
EXIT;