--MODIFICACIÓN DEL NOMBRE DEL PROCEDIMIENTO P27
ALTER TABLE DD_TPO_TIPO_PROCEDIMIENTO
MODIFY(DD_TPO_DESCRIPCION VARCHAR2(100 CHAR));

update dd_tpo_tipo_procedimiento
set dd_tpo_descripcion = 'Trámite de solicitud de actuaciones de reintegración contra terceros o pronunciamiento'
where dd_tpo_codigo = 'P27';

update dd_tpo_tipo_procedimiento
set dd_tpo_descripcion_larga = 'Trámite de solicitud de actuaciones de reintegración contra terceros o pronunciamiento'
where dd_tpo_codigo = 'P27';

update tfi_tareas_form_items
set tfi_label = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Consignar fecha de presentaci&'||'oacute;n en el Juzgado del escrito de declaraci&'||'oacute;n de no afecci&'||'oacute;n o del requerimiento dirigido a la Administraci&'||'oacute;n Concursal para solicitud de actuaciones de reintegraci&'||'oacute;n contra terceros as&'||'iacute; como el nombre de la persona o entidad implicada.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P27_presentarSolicitud') and tfi_orden = 0;

commit;


--trámite demanda incidental
--SE HA MODIFICADO EL INSERT DIRECTAMENTE EN EL FICHERO 25-tramiteDamandaIncidental.sql
--PONGO EL UPDATE AQUI DE TODAS FORMAS

UPDATE TAP_TAREA_PROCEDIMIENTO 
SET TAP_DESCRIPCION = 'Interposición de la demanda'
WHERE TAP_CODIGO = 'P25_interposicionDemanda';

COMMIT;


--trámite de presentación propuesta convenio

--SE HA MODIFICADO EL INSERT DIRECTAMENTE EN EL FICHERO UNNIM/35-tramitePresentacionPropuestaConvenio.sql
--PONGO EL UPDATE AQUI DE TODAS FORMAS 
update tfi_tareas_form_items
set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&'||'eacute;s de esta pantalla deber&'||'aacute; indicar si desea, como supervisor, registrar la propuesta de convenio en la herramienta, en caso de que indique "NO" será el gestor asignado al procedimiento el que la registre.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será &'||'quot;Registrar convenio propio&'||'quot; y dependiendo de su dictamen, el responsable de realizar la tarea ser&'||'aacute; el supervisor o el gestor.</p></div>'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P35_determinarConfeccionDeConvenio') and tfi_tipo = 'label';

update tfi_tareas_form_items
set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Consignar fecha en la que se dicta la admisi&'||'oacute;n o no de la propuesta del convenio propio. En caso de que no haya admisi&'||'oacute;n deber&'||'aacute; indicar si es subsanable o no.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se iniciar&'||'aacute;, en caso de que haya admisi&'||'oacute;n &'||'quot;Registrar informe de la administraci&'||'oacute;n concursal&'||'quot;, en caso de que no se haya producido la admisi&'||'oacute;n pero sea subsanable &'||'quot;Registrar presentaci&'||'oacute;n de subsanaci&'||'oacute;n&'||'quot; y en caso de que no sea subsanable se iniciar&'||'aacute;n una tarea en la que propondr&'||'aacute;, seg&'||'uacute;n su criterio, la siguiente actuaci&'||'oacute;n al responsable de la entidad.</p></div>'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P35_registrarAdmision') and tfi_tipo = 'label';

update tfi_tareas_form_items
set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Consignar fecha en la que se nos notifica la resoluci&'||'oacute;n sobre la subsanaci&'||'oacute;n presentada as&'||'iacute; como el resultado de la misma</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla, en caso de que la resoluci&'||'oacute;n nos haya sido favorable se lanzar&'||'aacute; la tarea &'||'quot;Registrar informe administraci&'||'oacute;n concursal&'||'quot; y en caso de que nos haya sido desfavorable se iniciar&'||'aacute; una tarea en la que propondr&'||'aacute;, seg&'||'uacute;n su criterio, la siguiente actuaci&'||'oacute;n al responsable de la entidad.</p></div>'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P35_registrarResultado') and tfi_tipo = 'label';

commit;

--procedimiento de solicitud concursal
CREATE TABLE DD_SIN_SINOALLANAMIENTO
(
  DD_SIN_ID                 NUMBER(16)          NOT NULL,
  DD_SIN_CODIGO             VARCHAR2(50 CHAR)   NOT NULL,
  DD_SIN_DESCRIPCION        VARCHAR2(50 CHAR),
  DD_SIN_DESCRIPCION_LARGA  VARCHAR2(250 CHAR),
  DD_SIN_PATRON             VARCHAR2(250 CHAR),
  VERSION                   INTEGER             DEFAULT 0                     NOT NULL,
  USUARIOCREAR              VARCHAR2(10 CHAR)   NOT NULL,
  FECHACREAR                TIMESTAMP(6)        NOT NULL,
  USUARIOMODIFICAR          VARCHAR2(10 CHAR),
  FECHAMODIFICAR            TIMESTAMP(6),
  USUARIOBORRAR             VARCHAR2(10 CHAR),
  FECHABORRAR               TIMESTAMP(6),
  BORRADO                   NUMBER(1)           DEFAULT 0                     NOT NULL
)
TABLESPACE UGAS001
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE UNIQUE INDEX PK_DD_SIN_SINOALLANAMIENTO ON DD_SIN_SINOALLANAMIENTO
(DD_SIN_ID)
LOGGING
TABLESPACE UGAS001
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX UK_DD_SIN_SINOALLANAMIENTO ON DD_SIN_SINOALLANAMIENTO
(DD_SIN_CODIGO)
LOGGING
TABLESPACE UGAS001
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


ALTER TABLE DD_SIN_SINOALLANAMIENTO ADD (
  CONSTRAINT PK_DD_SIN_SINOALLANAMIENTO
 PRIMARY KEY
 (DD_SIN_ID)
    USING INDEX 
    TABLESPACE UGAS001
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
               ));

ALTER TABLE DD_SIN_SINOALLANAMIENTO ADD (
  CONSTRAINT UK_DD_SIN_SINOALLANAMIENTO
 UNIQUE (DD_SIN_CODIGO)
    USING INDEX 
    TABLESPACE UGAS001
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
               ));

SET DEFINE OFF;
Insert into DD_SIN_SINOALLANAMIENTO
   (DD_SIN_ID, DD_SIN_CODIGO, DD_SIN_DESCRIPCION, DD_SIN_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (1, '01', 'Sí', 'Sí', 0, 'DD', SYSDATE, 0);
Insert into DD_SIN_SINOALLANAMIENTO
   (DD_SIN_ID, DD_SIN_CODIGO, DD_SIN_DESCRIPCION, DD_SIN_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (2, '02', 'No', 'No', 0, 'DD', SYSDATE, 0);
Insert into DD_SIN_SINOALLANAMIENTO
   (DD_SIN_ID, DD_SIN_CODIGO, DD_SIN_DESCRIPCION, DD_SIN_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (3, '03', 'Allanamiento', 'Allanamiento', 0, 'DD', SYSDATE, 0);   
COMMIT;

UPDATE tap_tarea_procedimiento
SET TAP_SCRIPT_DECISION = 'valores[''P22_registrarOposicion''][''comboOposicion''] == DDSiNo.SI ? ''SI'' : (valores[''P22_registrarOposicion''][''comboOposicion''] == DDSiNo.NO ? ''NO'':''ALLANAMIENTO'')'
WHERE TAP_CODIGO = 'P22_registrarOposicion';

update tfi_tareas_form_items
set TFI_BUSINESS_OPERATION = 'DDSiNoAllanamiento'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P22_registrarOposicion') and tfi_tipo = 'combo';

commit;

-- TRÁMITE FASE COMÚN ORDINARIO

UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Consignar fecha de publicaci&'||'oacute;n en el BOE y fecha del auto declarando concurso. Ind&'||'iacute;quese la plaza, n&'||'uacute;mero de  juzgado y el n&'||'uacute;mero de procedimiento en juzgado, estos tres valores podr&'||'iacute;an venir rellenados si el procedimiento es derivado de otro donde ya se hayan introducido.</p><p style="margin-bottom: 10px">Tambien debe introducir el n&'||'uacute;mero de registro en el Bolet&'||'iacute;n ofical del estado, deber&'||'aacute;n consignar los datos de contacto de los administradores concursales designados.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Registrar insinuaci&'||'oacute;n de cr&'||'eacute;dito por parte del supervisor&'||'quot;.</p></div>'
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE') AND TFI_TIPO = 'label';

UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Aya discrepancia o no en los cr&'||'eacute;ditos insinuados, deber&'||'aacute;n cumplimentar los valores definitivos para la posterior presentaci&'||'oacute;n ante la administraci&'||'oacute;n concursal, por tanto, antes de rellenar esta pantalla deber&'||'aacute; ir a la pestaña &'||'quot;Fase com&'||'uacute;n&'||'quot; de la ficha del asunto correspondiente y proceder a la insinuaci&'||'oacute;n de los cr&'||'eacute;ditos para lo que deber&'||'aacute; introducir valores en los campos definitivos.</p><p style="margin-bottom: 10px">En la presente pantalla debe indicar el n&'||'uacute;mero de cr&'||'eacute;ditos insinuados con valores definitivos.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Presentar escrito de insinuaci&'||'oacute;n de cr&'||'eacute;dito&'||'quot;.</p></div>'
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarInsinuacionCreditosDef') AND TFI_TIPO = 'label';

UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debe indicar la fecha de presentaci&'||'oacute;n o env&'||'iacute;o por correo electr&'||'oacute;nico de la propuesta de insinuaci&'||'oacute;n de cr&'||'eacute;ditos a la administraci&'||'oacute;n concursal, al pulsar Aceptar el sistema comprobar&'||'aacute; que todos los cr&'||'eacute;ditos insinuados en la pestaña Fase Com&'||'uacute;n disponen de valores definitivos y que se encuentran en estado &'||'quot;2. insinuado&'||'quot;.<p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; , si hemos comunicado nuestros cr&'||'eacute;ditos  a la Administraci&'||'oacute;n concursal mediante correo electr&'||'oacute;nico , &'||'quot;Registrar comunicaci&'||'oacute;n proyecto inventario &'||'quot;.</p><p style="margin-bottom: 10px">Se deber&'||'aacute; consignar la fecha con la que se nos comunica mediante correo electr&'||'oacute;nico por la Administraci&'||'oacute;n Concursal el proyecto de inventario</p>
<p style="margin-bottom: 10px">Igualmente, dberemos informar si es favorable o desfavorable a los intereses de la Entidad el proyecto remitido por la Administraci&'||'oacute;n Concursal. En el caso de que sea favorable, se deber&'||'aacute; esperar a la siguente tarea, sobre el informe presentado por la Administraci&'||'aacute;n Concursal ante el juez</p>
<p style="margin-bottom: 10px">En el caso de que sea desfavorable, deber&'||'aacute; informar al supervisor mediante comunicado o notificaci&'||'oacute;n para recibir instrucciones. En ese caso, deber&'||'aacute; presentar escrito solicitando la rectificaci&'||'oacute;n de cualquier error o simplemente los datos comunicados</p></div>'
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarEscritoInsinuacionCreditos') AND TFI_TIPO = 'label';



Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE'), 17, 'text', 'procurador', 'Procurador', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE'), 21, 'date', 'fechaAceptacion', 'Fecha de aceptación del cargo de la administración concursal',  'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',0, 'DD', SYSDATE, 0);


Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE'), 18, 'text', 'admEmail', 'Adm.1 email', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE'), 19, 'text', 'admEmail2', 'Adm.2 email', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE'), 20, 'text', 'admEmail3', 'Adm.3 email', 0, 'DD', SYSDATE, 0);

update tfi_tareas_form_items 
set tfi_nombre = 'admNombre2'
where tfi_nombre = 'admNombre' and tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE') and tfi_orden = 10;

update tfi_tareas_form_items 
set tfi_nombre = 'admDireccion2'
where tfi_nombre = 'admDireccion' and tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE') and tfi_orden = 11;

update tfi_tareas_form_items 
set tfi_nombre = 'admTelefono2'
where tfi_nombre = 'admTelefono' and tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE') and tfi_orden = 12;

update tfi_tareas_form_items 
set tfi_nombre = 'admEmail2'
where tfi_nombre = 'admEmail' and tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE') and tfi_orden = 19;

update tfi_tareas_form_items 
set tfi_nombre = 'admNombre3'
where tfi_nombre = 'admNombre' and tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE') and tfi_orden = 13;

update tfi_tareas_form_items 
set tfi_nombre = 'admDireccion3'
where tfi_nombre = 'admDireccion' and tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE') and tfi_orden = 14;

update tfi_tareas_form_items 
set tfi_nombre = 'admTelefono3'
where tfi_nombre = 'admTelefono' and tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE') and tfi_orden = 15;

update tfi_tareas_form_items 
set tfi_nombre = 'admEmail3'
where tfi_nombre = 'admEmail' and tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE') and tfi_orden = 20;

	--MODIFIAMOS LA TAREA ANTERIOR PARA INCLUIR LA DECISIÓN, Q ANTES NO HABÍA
	

update tfi_tareas_form_items 
set TFI_ORDEN = 4
where  tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarEscritoInsinuacionCreditos') and tfi_orden = 2;
update tfi_tareas_form_items 
set TFI_ORDEN = 3
where  tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarEscritoInsinuacionCreditos') and tfi_orden = 1;

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarEscritoInsinuacionCreditos'), 1, 'date', 'fechaComunicacion', 'Fecha de comunicación del proyecto', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarEscritoInsinuacionCreditos'), 2, 'combo', 'comFavorable', 'Favorable', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);

update TAP_TAREA_PROCEDIMIENTO
set tap_script_decision = 'valores[''P24_presentarEscritoInsinuacionCreditos''][''comFavorable''] == DDSiNo.SI ? ''SI'' : ''NO'' '
where tap_codigo = 'P24_presentarEscritoInsinuacionCreditos';
commit;
	--NUEVA TAREA PRESENTAR SOLICITUD RECTIFICACION O COMPLEMENTO DE DATOS
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_VALIDACION_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO,DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P24'), 'P24_presentarSolicitudRectificacion', 0, 'Presentar solicitud de rectificación o complemento de datos', 
null,
0, 'DD', SYSDATE, 0,'EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarSolicitudRectificacion'), 'damePlazo(valores[''P24_presentarEscritoInsinuacionCreditos''][''fecha'']) + 7*24*60*60*1000L', 0, 'DD', SYSDATE, 0);


Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarSolicitudRectificacion'), 0, 'label', 'titulo' 
, '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez recibidas las instrucciones del supervisor, en esta pantalla se deber&'||'aacute; consignar la fecha del env&'||'iacute;o por correo electr&'||'oacute;nico del escrito solicitando la rectificaci&'||'oacute;n de errores o el complemento de datos en el proyecto de inventario y de la lista de acreedores notificadas por la Administraci&'||'oacute;n Concursal</p></div>'
, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarSolicitudRectificacion'), 1, 'date', 'fecha', 'Fecha presentación', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarSolicitudRectificacion'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);
commit;		


--TRAMITE SEGUIMIENTO CONVENIO
update tfi_tareas_form_items 
set tfi_label = 'Espera (Meses)'
where  tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P64_registrarConvenio') and tfi_orden = 4;

update tfi_tareas_form_items 
set tfi_label = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&'||'aacute; consignar la fecha por la que se incia el seguimiento de convenio, la cuantía, quita y espera por la que se realiza el seguimiento así como la periodicidad por la cual se realiza el seguimiento.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Registrar cumplimiento&'||'quot;.</p></div>'
where  tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P64_registrarConvenio') and tfi_orden = 0;

update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&'||'aacute; consignar la fecha por la que se incia el seguimiento de convenio, la cuant&'||'iacute;a, quita y espera por la que se realiza el seguimiento, as&'||'iacute; como la periodicida por la cual se realiza el seguimiento.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Registrar cumplimiento de convenio&'||'quot;.</p></div>'
where TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P64_registrarConvenio')
and TFI_TIPO = 'label';

update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&'||'aacute; consignar la fecha en la que se produce la revisi&'||'oacute;n del convenio, consignar si se ha cumplido o no dicho convenio y por &'||'uacute;ltimo, indicar si se da por finalizado el seguimiento del convenio o no.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez finalice esta tarea, en caso de que se haya producido un incumplimiento de convenio se iniciar&'||'aacute; una tarea por la cual deber&'||'aacute; proponer la siguiente actuaci&'||'oacute;n a realizar al supervisor, en caso de indicar que finaliza el seguimiento se lanzar&'||'aacute; una tarea al supervisor para que valide dicha finalizaci&'||'oacute;n, y en caso de seguir con el seguimiento de convenio, se volver&'||'aacute; a lanzar esta misma tarea con fecha de vencimiento de a 3 meses vista.</p></div>'
where TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P64_registrarCumplimiento')
and TFI_TIPO = 'label';

update TAP_TAREA_PROCEDIMIENTO set TAP_DESCRIPCION = 'Validar fin de seguimiento de convenio', TAP_SUPERVISOR = 1
where TAP_CODIGO = 'P64_validarFinSeguimiento';

update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&'||'eacute;s de esta pantalla, debe validar la finalizaci&'||'oacute;n de siguimiento de convenio propuesta por el letrado.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla, en caso de aprovar la finalizaci&'||'oacute;n del seguimiento de convenio, se inciar&'||'aacute; una tarea en la que el letrado deber&'||'aacute; proponer la actuaci&'||'oacute;n a seguir, en caso contrario se volver&'||'aacute; a lanzar la tarea &'||'quot;Registrar cumplimiento de convenio&'||'quot; al letrado correspondiente.</p></div>'
where TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P64_validarFinSeguimiento')
and TFI_TIPO = 'label';

update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = 'Validar fin de seguimiento'
where TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P64_validarFinSeguimiento')
and TFI_NOMBRE = 'comboValidar';


update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se deber&'||'aacute; de consignar la fecha de notificaci&'||'oacute;n de la Resoluci&'||'oacute;n que hubiere reca&'||'iacute;do.</p><p style="margin-bottom: 10px">Se indicar&'||'aacute; si el resultado de dicha resoluci&'||'oacute;n ha sido favorable para los intereses de la entidad o no.</p><p style="margin-bottom: 10px">En el caso que la Resoluci&'||'oacute;n reca&'||'iacute;da provoque o tenga efectos sobre la Entidad, se habr&'||'aacute; de comunicar de inmediato dicha situaci&'||'oacute;n al Supervisor y esperar instrucciones del mismo para continuar el proceso.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla, se abrir&'||'aacute; una tarea en la cual le propondr&'||'aacute; seg&'||'uacute;n su criterio, la siguiente actuaci&'||'oacute;n al responsable de la entidad.</p></div>'
where TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P28_registrarResolucion')
and TFI_TIPO = 'label';

commit;

--TRÁMITE CALIFICACIÓN
update tfi_tareas_form_items 
set tfi_label = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta tarea consignar la fecha de apertura de la fase de calificaci&'||'oacute;n as&'||'iacute; como la fecha publicaci&'||'oacute;n de la misma.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Personaci&'||'oacute;n fase de calificaci&'||'oacute;n&'||'quot;</p></div>'
where  tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P34_aperturaLiquidacion') and tfi_orden = 0;


update DD_PTP_PLAZOS_TAREAS_PLAZAS
set  DD_PTP_PLAZO_SCRIPT = 'valores[''P34_registrarOposicion''] == null ?  5*24*60*60*1000L :  (damePlazo(valores[''P34_registrarOposicion''][''fecha'']) + 2*24*60*60*1000L )'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P34_registrarResolucion');

commit;

--TRÁMITE FASE CONVENIO

update tfi_tareas_form_items 
set TFI_ORDEN = 3
where  tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P29_dictarInstrucciones') and tfi_orden = 2;

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P29_dictarInstrucciones'), 2, 'textarea', 'instrucciones', 'Instrucciones a seguir por el gestor', 0, 'DD', SYSDATE, 0);


update tfi_tareas_form_items 
set TFI_ORDEN = 6
where  tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P29_lecturaAceptacionInstrucciones') and tfi_orden = 5;


update tfi_tareas_form_items 
set TFI_ORDEN = 5
where  tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P29_lecturaAceptacionInstrucciones') and tfi_orden = 4;

update tfi_tareas_form_items 
set TFI_ORDEN = 4
where  tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P29_lecturaAceptacionInstrucciones') and tfi_orden = 3;


Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P29_lecturaAceptacionInstrucciones'), 3, 'textarea', 'instruccionesSup', 'Instrucciones supervisor', 'valores[''P29_dictarInstrucciones''][''instrucciones'']', 0, 'DD', SYSDATE, 0);

UPDATE TAP_TAREA_PROCEDIMIENTO
SET TAP_SCRIPT_VALIDACION_JBPM = 'checkPosturaEnConveniosDeTercerosOConcursado() ?  null  : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.convenioSinPostura''', 
TAP_SCRIPT_DECISION = 'valores[''P29_lecturaAceptacionInstrucciones''][''comboAceptacion''] == DDSiNo.SI ? ''SI'' : ''NO'' '
WHERE TAP_CODIGO = 'P29_lecturaAceptacionInstrucciones';

UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&'||'eacute;s de esta pantalla debemos indicar tanto si se ha admitido el resultado de la junta de acreedores como si hay oposici&'||'oacute;n.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute;:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">Si se presenta oposici&'||'oacute;n: &'||'quot;Registrar resoluci&'||'oacute;n oposici&'||'oacute;n&'||'quot;</li><li style="margin-bottom: 10px; margin-left: 35px;">Si no se admite el resultado: &'||'quot;Registrar resultado subsanaci&'||'oacute;n&'||'quot;</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de que se admita y no haya oposici&'||'oacute;n se termina el tr&'||'aacute;mite en curso por lo que se le abrir&'||'aacute; una tarea en la que propondr&'||'aacute;, seg&'||'uacute;n su criterio, la siguiente actuaci&'||'oacute;n al responsable de la entidad.</li></ul></div>'
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P29_RegistrarOposicionAdmon') AND TFI_ORDEN = 0;

COMMIT;

--TRÁMITE DE CONCLUSIÓN
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, DD_FAP_ID)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P62'), 'P62_registrarResolucionConcursal', 0, 'Registrar resolución concursal',
0, 'DD', SYSDATE, 0, 'EXTTareaProcedimiento', (select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='09'));

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P62_registrarResolucionConcursal'), 'damePlazo(valores[''P62_registrarInformeAdmConcursal''][''fecha'']) + 30*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P62_registrarResolucionConcursal'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se deber&'||'aacute; de consignar la fecha de notificaci&'||'oacute;n de la Resoluci&'||'oacute;n que hubiere reca&'||'iacute;do como consecuencia de la comparecencia celebrada.</p><p style="margin-bottom: 10px">Se indicar&'||'aacute; si el resultado de dicha resoluci&'||'oacute;n ha sido favorable para los intereses de la entidad o no. Para el supuesto de que la resoluci&'||'oacute;n no fuere favorable para la entidad, deber&'||'aacute; comunicar dicha circunstancia al responsable interno de la misma a traves del bot&'||'oacute;n &'||'quot;Comunicaci&'||'oacute;n&'||'quot;.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Registrar conclusi&'||'oacute;n del concurso&'||'quot;</p></div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P62_registrarResolucionConcursal'), 1, 'date', 'fecha', 'Fecha resolución', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P62_registrarResolucionConcursal'), 2, 'combo', 'resultado', 'Resultado', 'DDFavorable', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P62_registrarResolucionConcursal'), 3, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

update tfi_tareas_form_items 
set TFI_ORDEN = 6
where  tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P62_registrarOposicion') and tfi_orden = 5;


update tfi_tareas_form_items 
set TFI_ORDEN = 5
where  tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P62_registrarOposicion') and tfi_orden = 4;

update tfi_tareas_form_items 
set TFI_ORDEN = 4
where  tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P62_registrarOposicion') and tfi_orden = 3;

update tfi_tareas_form_items 
set TFI_ORDEN = 3
where  tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P62_registrarOposicion') and tfi_orden = 2;

update tfi_tareas_form_items 
set TFI_ORDEN = 2
where  tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P62_registrarOposicion') and tfi_orden = 1;

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P62_registrarOposicion'), 1, 'text', 'restultadoResolucionConcursal', 'Resultado resolución concursal', 0, 'DD', SYSDATE, 0);

update  TAP_TAREA_PROCEDIMIENTO
set tap_view = 'plugin/procedimientos/tramiteConclusionConcurso/registrarOposicion'
where tap_codigo = 'P62_registrarOposicion'

COMMIT;
--TRAMITE FASE COMÚN ABREVIADO

UPDATE TAP_TAREA_PROCEDIMIENTO
SET TAP_DESCRIPCION = 'Registrar resolución finalización fase común'
WHERE TAP_CODIGO = 'P23_registrarFinFaseComun';

UPDATE TAP_TAREA_PROCEDIMIENTO
SET TAP_DESCRIPCION = 'Registrar resolución finalización fase común'
WHERE TAP_CODIGO = 'P24_registrarFinFaseComun';

update dd_ptp_plazos_tareas_plazas
set dd_ptp_plazo_script =  'damePlazo(valores[''P23_informeAdministracionConcursal''][''fecha'']) + 2*24*60*60*1000L'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_revisarResultadoInfAdmon');

update tfi_tareas_form_items
set tfi_label = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debe indicar si se presentan alegaciones contra el reconocimiento que consta en el informe de la Administraci&'||'oacute;n Concursal, al pulsar Aceptar el sistema comprobar&'||'aacute; que el estado de los cr&'||'eacute;ditos insinuados en la pestaña Fase Com&'||'uacute;n es, en caso de presentar alegaciones &'||'quot;4. Pendiente de demanda incidental&'||'quot; o en caso contrario &'||'quot;5. Definitivo&'||'quot;. Para ello debe abrir el asunto correspondiente, ir a la pestaña &'||'quot;Fase Com&'||'uacute;n&'||'quot; y abrir la ficha de cada uno de los cr&'||'eacute;ditos insinuados y cambiar su estado.<p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se le abrir&'||'aacute; una tarea en la que propondr&'||'aacute;, seg&'||'uacute;n su criterio, la siguiente actuaci&'||'oacute;n al gestor interno de la entidad.</p></div>'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_revisarResultadoInfAdmon') and tfi_orden = 0;

commit;

--TRÁMITE REGISTRAR RESOLUCIÓN DE INTERÉS

UPDATE DD_TPO_TIPO_PROCEDIMIENTO
SET DD_TAC_ID = (SELECT DD_TAC_ID FROM DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO = 'CO')
WHERE DD_TPO_CODIGO = 'P28'; 

UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se deber&'||'aacute; de consignar la fecha de notificaci&'||'oacute;n de la Resoluci&'||'oacute;n que hubiere reca&'||'iacute;do.</p><p style="margin-bottom: 10px">Se indicar&'||'aacute; si el resultado de dicha resoluci&'||'oacute;n ha sido favorable para los intereses de la entidad o no.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute;, la siguiente tarea le propondr&'||'aacute;, seg&'||'uacute;n su criterio, que indique la siguiente actuaci&'||'oacute;n al responsable de la entidad.</p></div>'
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P28_registrarResolucion') AND TFI_ORDEN = 0;

commit;
--NUEVO TRÁMITE REAPERTURA DE CONCURSO
SET DEFINE OFF;
Insert into DD_TPO_TIPO_PROCEDIMIENTO
   (DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TAC_ID)
 Values
   (S_DD_TPO_TIPO_PROCEDIMIENTO.NEXTVAL, 'P94', 'P. reapertura de concurso', 'P. reapertura de concurso', 'tramiteReaperturaConcurso', 0, 'DD', sysdate, 0, (select dd_tac_id from dd_tac_tipo_actuacion where dd_tac_codigo = 'CO'));
COMMIT;

-- *************************************************************************** --
-- **                   BPM Procedimiento solicitud concursal               ** --
-- *************************************************************************** --

-- Pantalla 1
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SCRIPT_VALIDACION, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P94'), 'P94_SolicitudConcursal'
, '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>¡Atenci&'||'oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null'
, 0, 'Presentar solicitud reapertura concurso', 0, 'DD', SYSDATE, 0);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_SolicitudConcursal'), '15*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_SolicitudConcursal'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Consignar fecha de presentaci&'||'oacute;n de la solicitud concursal. Ind&'||'iacute;quese la plaza del juzgado y procurador que representa a la entidad.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Confirmar admisi&'||'oacute;n&'||'quot;.</p></div>'
, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_SolicitudConcursal'), 1, 'date', 'fecha', 'Fecha de presentación', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_SolicitudConcursal'), 2, 'combo', 'plazaJuzgado', 'Plaza del juzgado', 'TipoPlaza', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'damePlaza()', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_SolicitudConcursal'), 3, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- Pantalla 2
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_VIEW, TAP_SCRIPT_DECISION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P94'), 'P94_ConfirmarAdmision', 0, 'Confirmar admisión',
'plugin/procedimientos/tramiteReaperturaConcurso/confirmarAdmision', '', 0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_ConfirmarAdmision'), 'damePlazo(valores[''P94_SolicitudConcursal''][''fecha'']) + 30*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_ConfirmarAdmision'), 0, 'label', 'titulo',  
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Ind&'||'iacute;quese la fecha en la que se nos notifica la admisi&'||'oacute;n de la solicitud concursal, el juzgado en el que ha reca&'||'iacute;do y el n&'||'uacute;mero de procedimiento.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Confirmar notificaci&'||'oacute;n demandado&'||'quot;.</p></div>'
, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_ConfirmarAdmision'), 1, 'date', 'fecha', 'Fecha', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_ConfirmarAdmision'), 2, 'combo', 'nPlaza', 'Plaza', 'TipoPlaza', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_ConfirmarAdmision'), 3, 'combo', 'numJuzgado', 'Nº Juzgado', 'TipoJuzgado', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'dameNumJuzgado()', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_ConfirmarAdmision'), 4, 'textproc', 'procedimiento', 'Nº Procedimiento', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'dameNumAuto()', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_ConfirmarAdmision'), 5, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- Pantalla 3
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P94'), 'P94_ConfirmarNotificacionDemandado', 0, 'Presentar solicitud reapertura de concurso', 0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_ConfirmarNotificacionDemandado'), 'damePlazo(valores[''P94_ConfirmarAdmision''][''fecha'']) + 30*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_ConfirmarNotificacionDemandado'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debe indicar la fecha de la notificaci&'||'oacute;n al concursado.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Registrar oposici&'||'oacute;n&'||'quot;</div>'
, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_ConfirmarNotificacionDemandado'), 1, 'date', 'fecha', 'Fecha', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_ConfirmarNotificacionDemandado'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- Pantalla 4

Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_DECISION, TAP_SCRIPT_VALIDACION_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P94'), 'P94_registrarOposicion', 0, 'Registrar oposición',
'valores[''P94_registrarOposicion''][''comboOposicion''] == DDSiNo.SI ? ''SI'' : (valores[''P94_registrarOposicion''][''comboOposicion''] == DDSiNo.NO ? ''NO'':''ALLANAMIENTO'')', 
'( (valores[''P94_registrarOposicion''][''comboOposicion''] == DDSiNo.SI) &&'||' ((valores[''P94_registrarOposicion''][''fechaOposicion''] == '''') || (valores[''P94_registrarOposicion''][''fechaVista''] == '''')) ) ? ''tareaExterna.error.faltaAlgunaFecha'':null', 0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea');


Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_registrarOposicion'), 'damePlazo(valores[''P94_ConfirmarNotificacionDemandado''][''fecha'']) + 5*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_registrarOposicion'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez notificado al demandado, en esta pantalla ha de indicar si el mismo se ha opuesto o no a la solicitud.</p><p style="margin-bottom: 10px">En el supuesto de que exista oposici&'||'oacute;n, deber&'||'aacute; consignar tanto la fecha de notificaci&'||'oacute;n como la fecha de celebraci&'||'oacute;n de la vista.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute;:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">Si no hay oposici&'||'oacute;n: &'||'quot;Auto declarando concurso&'||'quot;.</li><li style="margin-bottom: 10px; margin-left: 35px;">Si hay oposici&'||'oacute;n: &'||'quot;Registrar vista&'||'quot;.</li></ul></div>'
, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_registrarOposicion'), 1, 'combo', 'comboOposicion', 'Existe oposición', 'DDSiNoAllanamiento', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_registrarOposicion'), 2, 'date', 'fechaOposicion', 'Fecha oposición', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_registrarOposicion'), 3, 'date', 'fechaVista', 'Fecha vista', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_registrarOposicion'), 4, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- Pantalla 5 
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P94'), 'P94_RegistrarVista', 0, 'Registrar vista', 0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_RegistrarVista'), 'damePlazo(valores[''P94_registrarOposicion''][''fechaVista'']) + 2*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_RegistrarVista'), 0, 'label', 'titulo',
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debemos de consignar la fecha de celebraci&'||'oacute;n de la vista. En el caso de que se aplace la vista deber&'||'aacute; solicitar la consiguiente pr&'||'oacute;rroga al supervisor, para de este modo aplazar la fecha de fin de esta tarea.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Registrar resoluci&'||'oacute;n&'||'quot;.</p></div>'
, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_RegistrarVista'), 1, 'date', 'fecha', 'Fecha', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_RegistrarVista'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- Pantalla 6 
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P94'), 'P94_RegistrarResolucion', 0, 'Registrar resolución', 0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_RegistrarResolucion'), 'damePlazo(valores[''P94_RegistrarVista''][''fecha'']) + 15*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_RegistrarResolucion'), 0, 'label', 'titulo',
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se deber&'||'aacute; de consignar la fecha de notificaci&'||'oacute;n de la Resoluci&'||'oacute;n que hubiere reca&'||'iacute;do como consecuencia de la vista celebrada.</p><p style="margin-bottom: 10px">Se indicar&'||'aacute; si el resultado de dicha resoluci&'||'oacute;n ha sido favorable para los intereses de la entidad o no.</p><p style="margin-bottom: 10px">Para el supuesto de que la resoluci&'||'oacute;n no fuere favorable para la entidad, deber&'||'aacute; comunicar dicha circunstancia al responsable interno de la misma a traves del bot&'||'oacute;n &'||'quot;Comunicaci&'||'oacute;n&'||'quot;. Una vez reciba la aceptación del supervisor deber&'||'aacute; gestionar el recurso por medio de la pestaña &'||'quot;Recursos&'||'quot;.</p><p style="margin-bottom: 10px">Para el supuesto de anuncio del recurso por la parte contraria se deber&'||'aacute; gestionar directamente a trav&'||'eacute;s de la pestaña &'||'quot;Recursos&'||'quot;.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Resoluci&'||'oacute;n firme&'||'quot;.</p></div>'
, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_RegistrarResolucion'), 1, 'date', 'fecha', 'Fecha', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_RegistrarResolucion'), 2, 'combo', 'comboResultado', 'Resultado', 'DDFavorable', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_RegistrarResolucion'), 3, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- Pantalla 7
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_DECISION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P94'), 'P94_ResolucionFirme', 0, 'Resolución firme',
'valores[''P94_RegistrarResolucion''][''comboResultado''] == DDFavorable.FAVORABLE ? ''Favorable'' : ''Desfavorable''', 0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_ResolucionFirme'), 'damePlazo(valores[''P94_RegistrarResolucion''][''fecha'']) + 5*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_ResolucionFirme'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se deber&'||'aacute; consignar la fecha en la que la Resoluci&'||'oacute;n adquiere firmeza.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute;:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">Si la sentencia nos ha sido Favorable: &'||'quot;Auto declarando concurso&'||'quot;.</li><li style="margin-bottom: 10px; margin-left: 35px;">Si la sentencia nos ha sido Desfavorable: Se le abrir&'||'aacute; una tarea en la que propondr&'||'aacute;, seg&'||'uacute;n su criterio, la siguiente actuaci&'||'oacute;n al responsable de la entidad.</li></ul></div>'
, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_ResolucionFirme'), 1, 'date', 'fechaResolucion', 'Fecha firmeza', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_ResolucionFirme'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- Pantalla 8 
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_DECISION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P94'), 'P94_AutoDeclarandoConcurso', 0, 'Auto declarando reapertura de concurso'
,'valores[''P94_AutoDeclarandoConcurso''][''comboEligeTramite''] == DDAccionAuto.ORDINARIO ? ''NO'' : ''SI'''
, 0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_AutoDeclarandoConcurso'), 'valores[''P94_registrarOposicion''][''comboOposicion''] == DDSiNo.SI ? damePlazo(valores[''P94_ResolucionFirme''][''fechaResolucion'']) + 5*24*60*60*1000L : damePlazo(valores[''P94_ConfirmarNotificacionDemandado''][''fecha'']) + 15*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_AutoDeclarandoConcurso'), 0, 'label', 'titulo',
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se deber&'||'aacute; consignar la fecha del auto declarando concurso as&'||'iacute; como el tr&'||'aacute;mite que se quiere iniciar a continuaci&'||'oacute;n, bien sea un Fase com&'||'uacute;n ordinario o Abreviado..</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se iniciar&'||'aacute; el tr&'||'aacute;mite que haya elegido.</p></div>'
, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_AutoDeclarandoConcurso'), 1, 'date', 'fecha', 'Fecha', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_AutoDeclarandoConcurso'), 2, 'combo', 'comboEligeTramite', 'Trámite a iniciar', 'DDAccionAuto', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_AutoDeclarandoConcurso'), 3, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

--Pantalla 9
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, DD_TPO_ID_BPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P94'), 'P94_BPMtramiteFaseComunOrdinario',(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P24'), 0, 'Ejecución del Trámite fase común ordinario', 0, 'DD', SYSDATE, 0);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_BPMtramiteFaseComunOrdinario'), '300*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_BPMtramiteFaseComunOrdinario'), 0, 'label', 'titulo', 'Ejecución del Trámite fase común ordinario', 0, 'DD', SYSDATE, 0);

--Pantalla 10
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, DD_TPO_ID_BPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P94'), 'P94_BPMtramiteFaseComunAbreviado',(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P56'), 0, 'Ejecución del Trámite fase común abreviado', 0, 'DD', SYSDATE, 0);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_BPMtramiteFaseComunAbreviado'), '300*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P94_BPMtramiteFaseComunAbreviado'), 0, 'label', 'titulo', 'Ejecución del Trámite fase común abreviado', 0, 'DD', SYSDATE, 0);

commit;
update  TAP_TAREA_PROCEDIMIENTO
set dtype = 'EXTTareaProcedimiento'
where tap_codigo like 'P94%';
commit;

--NUEVOS TIPOS DE CRÉDITO !!ATENCIÓN ESTO HAY QUE LANZARLO EN EL MASTER
--SET DEFINE OFF;
Insert into UGASMASTER.DD_STD_CREDITO
   (STD_CRE_ID, STD_CRE_CODIGO, STD_CRE_DESCRIP, STD_CRE_DESCRIP_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (UGASMASTER.s_dd_std_credito.nextval, '7', '7. Crédito reaperturado', 'Crédito reaperturado', 1, 'xema', sysdate, 0);

Insert into UGASMASTER.DD_STD_CREDITO
   (STD_CRE_ID, STD_CRE_CODIGO, STD_CRE_DESCRIP, STD_CRE_DESCRIP_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (UGASMASTER.s_dd_std_credito.nextval, '8', '8. Crédito cancelado', 'Crédito cancelado', 1, 'xema', sysdate, 0);
   
COMMIT;


--TRÁMITE DEMANDADO EN INCIDENTE
UPDATE DD_PTP_PLAZOS_TAREAS_PLAZAS
SET DD_PTP_PLAZO_SCRIPT = 'valores[''P26_dictarInstrucciones''][''comboInstrucciones''] == DDInstrucciones.OPOSICION ? damePlazo(valores[''P26_registrarResolucionOposicion''][''fecha'']) + 20*24*60*60*1000L : damePlazo(valores[''P26_registrarResolucionAllanamiento''][''fecha'']) + 20*24*60*60*1000L '
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P26_resolucionFirme');

COMMIT;
