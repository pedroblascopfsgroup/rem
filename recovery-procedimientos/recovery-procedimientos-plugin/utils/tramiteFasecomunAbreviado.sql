--PREPARATIVOS
SET DEFINE OFF;
Insert into UGASMASTER.DD_TGE_TIPO_GESTOR
   (DD_TGE_ID, DD_TGE_CODIGO, DD_TGE_DESCRIPCION, DD_TGE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (5, 'GADM', 'Gestor administrativo', 'Gestor administrativo del asunto', 0, 'xema',SYSDATE, 0);
COMMIT;

SET DEFINE OFF;
Insert into UGASMASTER.DD_STA_SUBTIPO_TAREA_BASE
   (DD_STA_ID, DD_TAR_ID, DD_STA_CODIGO, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE,DD_TGE_ID)
 Values
   (S_DD_STA_SUBTIPO_TAREA_BASE.NEXTVAL, 1, 'TCGA', 'Tareas concursal gestor Administrativo', 'Tareas concursal gestor Administrativo', 0, 'xema', SYSDATE, 0, 'EXTSubtipoTarea',(SELECT DD_TGE_ID FROM DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = 'GADM' ));
COMMIT;

ALTER TABLE UGAS001.TAP_TAREA_PROCEDIMIENTO
 ADD (DD_STA_ID  NUMBER(16));

ALTER TABLE UGAS001.TAP_TAREA_PROCEDIMIENTO
 ADD CONSTRAINT TAP_TAREA_PROC_SUBTIPO_TAR 
 FOREIGN KEY (DD_STA_ID) 
 REFERENCES UGASMASTER.DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID);



--FASE COMÚN ABREVIADO

--TAREA 1
UPDATE TAP_TAREA_PROCEDIMIENTO
SET DD_STA_ID = (SELECT DD_STA_ID  FROM UGASMASTER.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = 'TCGA')
WHERE TAP_CODIGO = 'P23_registrarPublicacionBOE';


UPDATE TAP_TAREA_PROCEDIMIENTO
SET TAP_VIEW = 'plugin/procedimientos/tramiteFaseComunOrdinario/regPublicacionBOE'
WHERE TAP_CODIGO = 'P23_registrarPublicacionBOE';


Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_registrarPublicacionBOE'), 10, 'text', 'admNombre2', 'Adm.2 Nombre', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_registrarPublicacionBOE'), 11, 'text', 'admDireccion2', 'Adm.2 dirección', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_registrarPublicacionBOE'), 12, 'text', 'admTelefono2', 'Adm.2 teléfono', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_registrarPublicacionBOE'), 13, 'text', 'admNombre3', 'Adm.3 Nombre', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_registrarPublicacionBOE'), 14, 'text', 'admDireccion3', 'Adm.3 dirección', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_registrarPublicacionBOE'), 15, 'text', 'admTelefono3', 'Adm.3 teléfono', 0, 'DD', SYSDATE, 0);


update TFI_TAREAS_FORM_ITEMS
set tfi_orden = 16
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_registrarPublicacionBOE') and tfi_nombre ='observaciones';

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_registrarPublicacionBOE'), 17, 'text', 'procurador', 'Procurador', 0, 'DD', SYSDATE, 0);


Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_registrarPublicacionBOE'), 18, 'text', 'admEmail', 'Adm. email', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_registrarPublicacionBOE'), 19, 'text', 'admEmail2', 'Adm.2 email', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_registrarPublicacionBOE'), 20, 'text', 'admEmail3', 'Adm.3 email', 0, 'DD', SYSDATE, 0);


Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_registrarPublicacionBOE'), 21, 'date', 'fechaAceptacion', 'Fecha de aceptación del cargo de la administración concursal', 0, 'DD', SYSDATE, 0);

--TAREA 2

UPDATE TAP_TAREA_PROCEDIMIENTO
SET DD_STA_ID = (SELECT DD_STA_ID  FROM UGASMASTER.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = 'TCGA')
WHERE TAP_CODIGO = 'P23_regInsinuacionCreditosSup';

UPDATE TAP_TAREA_PROCEDIMIENTO
SET TAP_DESCRIPCION = 'Registrar insinuación de créditos inicial'
WHERE TAP_CODIGO = 'P23_regInsinuacionCreditosSup';

UPDATE TAP_TAREA_PROCEDIMIENTO
SET TAP_SCRIPT_DECISION = NULL, TAP_SUPERVISOR = 0
WHERE TAP_CODIGO = 'P23_regInsinuacionCreditosSup';


delete from tfi_tareas_form_items
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_regInsinuacionCreditosSup') and tfi_nombre = 'comProcede';

update TFI_TAREAS_FORM_ITEMS
set tfi_orden = 3
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_regInsinuacionCreditosSup') and tfi_nombre ='observaciones';

--TAREA 3 (NUEVA TAREA)

Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_SCRIPT_VALIDACION_JBPM)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P56'), 'P23_asignarGestorLetradoSup', 1, 'Asignar Gestor Letrado y Supervisor (por Supervisor)', 0, 'DD', SYSDATE, 0,'EXTTareaProcedimiento','tieneGestorYSupervisor() ? ''null'' : ''tareaExterna.procedimiento.tramiteFaseComun.sinGestorNiSupervisor'' ');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_asignarGestorLetradoSup'), '20*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_asignarGestorLetradoSup'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;">
<p style="margin-bottom: 10px">Se debe asignar mediante la opci&'||'oacute;n en el asunto de &'||'quot;cambio de gestor/supervisor&'||'quot;, el gestor letraedo interno o externo al que se encomienda el concurso, y el supervisor que queda asignado para llevar dicha funci&'||'oacute;n</p>
<p style="margin-bottom: 10px">Para dar por completada esta tarea, una vez realizada dicha asignaci&'||'oacute;n, simplemente deber&'||'aacute; pulsar el bot&'||'oacute;n guardar. En el caso en el que se considere necesario, se debe incluir un comentario en el campo observaciones. La tarea no se dar&'||'aacute; por realizada si no se realiza previamente la asignaci&'||'oacute;n mencionada</p></div>', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_asignarGestorLetradoSup'), 1, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- TAREA 4

UPDATE TAP_TAREA_PROCEDIMIENTO
SET TAP_DESCRIPCION = 'Registrar insinuación de créditos gestor Letrado'
WHERE TAP_CODIGO = 'P23_registrarInsinuacionCreditosDef';


--TAREA 5

update TFI_TAREAS_FORM_ITEMS
set TFI_VALIDACION = NULL, TFI_VALOR_INICIAL = 'dameTotalCreditosContraLaMasa()'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_presentarEscritoInsinuacionCreditos') and tfi_nombre ='tCredMasa';

update TFI_TAREAS_FORM_ITEMS
set TFI_VALIDACION = NULL, TFI_VALOR_INICIAL = 'dameTotalCreditosConPrivilegioEspecial()'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_presentarEscritoInsinuacionCreditos') and tfi_nombre ='tCredPrivEsp';

update TFI_TAREAS_FORM_ITEMS
set TFI_VALIDACION = NULL, TFI_VALOR_INICIAL = 'dameTotalCreditosConPrivilegioGeneral()'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_presentarEscritoInsinuacionCreditos') and tfi_nombre ='tCredPrivGen';

update TFI_TAREAS_FORM_ITEMS
set TFI_VALIDACION = NULL, TFI_VALOR_INICIAL = 'dameTotalCreditosOrdinarios()'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_presentarEscritoInsinuacionCreditos') and tfi_nombre ='tCredOrd';

update TFI_TAREAS_FORM_ITEMS
set TFI_VALIDACION = NULL, TFI_VALOR_INICIAL = 'dameTotalCreditosSubordinados()'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_presentarEscritoInsinuacionCreditos') and tfi_nombre ='tCredSub';

update TFI_TAREAS_FORM_ITEMS
set TFI_VALIDACION = NULL, TFI_VALOR_INICIAL = 'dameTotalCreditosContingentes()'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_presentarEscritoInsinuacionCreditos') and tfi_nombre ='tCredContigentes';

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TFI_VALOR_INICIAL)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_presentarEscritoInsinuacionCreditos'), 8, 'currency', 'totalCred', 'Total créditos insinuados', 0, 'DD', SYSDATE, 0,'dameTotalCreditos()');

update TFI_TAREAS_FORM_ITEMS
set tfi_orden = 9
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_presentarEscritoInsinuacionCreditos') and tfi_nombre ='observaciones';


-- TAREA 8
update TFI_TAREAS_FORM_ITEMS
set tfi_label = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;">
<p style="margin-bottom: 10px">En esta pantalla debe indicar si se presentan alegaciones a nuestra propuesta de insinuaci&'||'oacute;n de cr&'||'eacute;ditos, al pulsar Aceptar el sistema comprobar&'||'aacute; que el estado de los cr&'||'eacute;ditos insinuados en la pesta&'||'nacute;a Fase Com&'||'uacute;n es, en caso de presentar alegaciones &'||'quot;4. Pendiente de demanda incidental&'||'quot; o en caso contrario &'||'quot;6. Reconocido&'||'quot;. Para ello debe abrir el asunto correspondiente, ir a la pesta&'||'nacute;a &'||'quot;Fase Com&'||'uacute;n&'||'quot; y abrir la ficha de cada uno de los cr&'||'eacute;ditos insinuados y cambiar su estado</p>
<p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p>
<p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea en caso de no presentar alegaciones ser&'||'aacute; &'||'quot;Registrar resoluci&'||'oacute;n de finalizaci&'||'oacute;n fase com&'||'uacute;n&'||'quot; y en caso de haberse presentado se iniciar&'||'aacute; el tr&'||'aacute;mite de demanda incidental</p></div>'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_revisarResultadoInfAdmon') and tfi_nombre ='titulo';



COMMIT;


--NUEVA TAREA
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_DECISION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_VIEW, DTYPE, DD_FAP_ID)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P56'), 'P23_registrarAceptacion', 0, 'Registrar aceptación de asunto',
'((valores[''P23_registrarAceptacion''][''comboAceptación''] == DDSiNo.SI) &&'||' (valores[''P23_registrarAceptacion''][''comboConflicto''] == DDSiNo.NO)) ?  ''SI'' : ''NO''', 0, 'DD', SYSDATE, 0, 
'plugin/procedimientos/aceptacionYdecision/aceptacion', 'EXTTareaProcedimiento', (select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='09'));

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_registrarAceptacion'), '2*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_registrarAceptacion'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&'||'eacute;s de esta pantalla deberá indicar si acepta el Asunto asignado por la entidad o no.</p><p style="margin-bottom: 10px">En el campo &'||'quot;Conflicto de intereses&'||'quot; deber&'||'aacute; consignar la existencia de conflicto o no, que le impida aceptar la direcci&'||'oacute;n de la acci&'||'oacute;n a instar, en caso de que haya conflicto de intereses no se le permitir&'||'aacute; la aceptaci&'||'oacute;n del Asunto.</p><p style="margin-bottom: 10px">En el campo &'||'quot;Aceptaci&'||'oacute;n del asunto &'||'quot; deber&'||'aacute; indicar si acepta o no el asunto, si ha marcado con anterioridad que existe conflicto de intereses, deber&'||'aacute; marcar, en todo caso, la no aceptaci&'||'oacute;n del asunto.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Registrar insinuaci&'||'oacute;n de cr&'||'eacute;ditos gestor letrado&'||'quot; en caso de que haya aceptado el asunto, en caso de no haber aceptado el asunto se creará una tarea al supervisor para que tenga en cuenta su respuesta a la vez que reasigna el asunto a otro letrado.</p></div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_registrarAceptacion'), 1, 'currency', 'principal', 'Principal','procedimientoManager.getProcedimiento(idProcedimiento).getSaldoRecuperacion()', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_registrarAceptacion'), 2, 'combo', 'comboConflicto', 'Conflicto de intereses', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_registrarAceptacion'), 3, 'combo', 'comboAceptación', 'Aceptación del asunto', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_registrarAceptacion'), 4, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);
commit;