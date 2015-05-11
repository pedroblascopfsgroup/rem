--TAREA 1
UPDATE TAP_TAREA_PROCEDIMIENTO
SET DD_STA_ID = (SELECT DD_STA_ID  FROM UGASMASTER.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = 'TCGA')
WHERE TAP_CODIGO = 'P24_registrarPublicacionBOE';


--TAREA 2

UPDATE TAP_TAREA_PROCEDIMIENTO
SET DD_STA_ID = (SELECT DD_STA_ID  FROM UGASMASTER.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = 'TCGA')
WHERE TAP_CODIGO = 'P24_regInsinuacionCreditosSup';

UPDATE TAP_TAREA_PROCEDIMIENTO
SET TAP_DESCRIPCION = 'Registrar insinuación de créditos inicial'
WHERE TAP_CODIGO = 'P24_regInsinuacionCreditosSup';

UPDATE TAP_TAREA_PROCEDIMIENTO
SET TAP_SCRIPT_DECISION = NULL, TAP_SUPERVISOR = 0
WHERE TAP_CODIGO = 'P24_regInsinuacionCreditosSup';


delete from tfi_tareas_form_items
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_regInsinuacionCreditosSup') and tfi_nombre = 'comProcede';

update TFI_TAREAS_FORM_ITEMS
set tfi_orden = 3
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_regInsinuacionCreditosSup') and tfi_nombre ='observaciones';

--TAREA 3 (NUEVA TAREA)

Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_SCRIPT_VALIDACION_JBPM)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P24'), 'P24_asignarGestorLetradoSup', 1, 'Asignar Gestor Letrado y Supervisor (por Supervisor)', 0, 'DD', SYSDATE, 0,'EXTTareaProcedimiento','tieneGestorYSupervisor() ? ''null'' : ''tareaExterna.procedimiento.tramiteFaseComun.sinGestorNiSupervisor'' ');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_asignarGestorLetradoSup'), '20*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_asignarGestorLetradoSup'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;">
<p style="margin-bottom: 10px">Se debe asignar mediante la opci&'||'oacute;n en el asunto de &'||'quot;cambio de gestor/supervisor&'||'quot;, el gestor letraedo interno o externo al que se encomienda el concurso, y el supervisor que queda asignado para llevar dicha funci&'||'oacute;n</p>
<p style="margin-bottom: 10px">Para dar por completada esta tarea, una vez realizada dicha asignaci&'||'oacute;n, simplemente deber&'||'aacute; pulsar el bot&'||'oacute;n guardar. En el caso en el que se considere necesario, se debe incluir un comentario en el campo observaciones. La tarea no se dar&'||'aacute; por realizada si no se realiza previamente la asignaci&'||'oacute;n mencionada</p></div>', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_asignarGestorLetradoSup'), 1, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- TAREA 4

UPDATE TAP_TAREA_PROCEDIMIENTO
SET TAP_DESCRIPCION = 'Registrar insinuación de créditos gestor Letrado'
WHERE TAP_CODIGO = 'P24_registrarInsinuacionCreditosDef';

UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;">
<p style="margin-bottom: 10px">Antes de rellenar esta pantalla deber&'||'aacute; ir a la pesta&'||'nacute;a &'||'quot;Fase Com&'||'uacute;n&'||'quot; de la ficha del asunto correspondiente y proceder a la insinuaci&'||'oacute;n de los cr&'||'eacute;ditos para lo que deber&'||'aacute; introducir valores en los campos gestor.</p>
<p style="margin-bottom: 10px">En la presente pantalla debe indicar el n&'||'uacute;mero de cr&'||'eacute;ditos insinuados.</p>
<p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interese quede reflejado en este punto del procedimiento</p>
<p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Presentar escrito de insinuaci&'||'oacute;n de cr&'||'eacute;ditos&'||'quot;.</p></div>'
WHERE TAP_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarInsinuacionCreditosDef') and tfi_nombre = 'titulo';

--tarea 5

UPDATE TAP_TAREA_PROCEDIMIENTO
SET TAP_view = 'plugin/procedimientos/tramiteFaseComunAbreviado/presentarEscritoInsinuacionCreditos'
WHERE TAP_CODIGO = 'P24_presentarEscritoInsinuacionCreditos';

update TFI_TAREAS_FORM_ITEMS
set tfi_label = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debe indicar la fecha de presentaci&'||'oacute;n o env&'||'iacute;o por correo electr&'||'oacute;nico de la propuesta de insinuaci&'||'oacute;n de cr&'||'eacute;ditos a la administraci&'||'oacute;n concursal, al pulsar Aceptar el sistema comprobar&'||'aacute; que todos los cr&'||'eacute;ditos insinuados en la pestaña Fase Com&'||'uacute;n disponen de valores definitivos y que se encuentran en estado &'||'quot;2. insinuado&'||'quot;.<p style="margin-bottom: 10px">En esta tarea, aparecer&'||'aacute;n acumulados los importes de los cr&'||'eacute;ditos insinuados.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; , si hemos comunicado nuestros cr&'||'eacute;ditos  a la Administraci&'||'oacute;n concursal mediante correo electr&'||'oacute;nico , &'||'quot;Registrar comunicaci&'||'oacute;n proyecto inventario &'||'quot;.</p>
</div>'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarEscritoInsinuacionCreditos') and tfi_nombre ='titulo';



delete from tfi_tareas_form_items
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarEscritoInsinuacionCreditos') and tfi_nombre = 'fechaComunicacion';

delete from tfi_tareas_form_items
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarEscritoInsinuacionCreditos') and tfi_nombre = 'comFavorable';


update TFI_TAREAS_FORM_ITEMS
set tfi_orden = 1
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarEscritoInsinuacionCreditos') and tfi_nombre ='fecha';
update TFI_TAREAS_FORM_ITEMS
set tfi_orden = 9
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarEscritoInsinuacionCreditos') and tfi_nombre ='observaciones';

insert into UGAS001.TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_TFI_TAREAS_FORM_ITEMS.nextval,(select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarEscritoInsinuacionCreditos'), 2, 'currency', 'tCredMasa', 'Total créditos contra la masa', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'dameTotalCreditosContraLaMasa()', 0, 'DD', TO_TIMESTAMP('24/05/2012 10:44:47.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'), 0);
Insert into UGAS001.TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarEscritoInsinuacionCreditos'), 3, 'currency', 'tCredPrivEsp', 'Total créditos con privilegio especial', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'dameTotalCreditosConPrivilegioEspecial()', 0, 'DD', TO_TIMESTAMP('24/05/2012 10:44:47.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'), 0);
Insert into UGAS001.TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarEscritoInsinuacionCreditos'), 4, 'currency', 'tCredPrivGen', 'Total créditos con privilegio general', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'dameTotalCreditosConPrivilegioGeneral()', 0, 'DD', TO_TIMESTAMP('24/05/2012 10:44:47.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'), 0);
Insert into UGAS001.TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarEscritoInsinuacionCreditos'), 5, 'currency', 'tCredOrd', 'Total créditos ordinarios', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'dameTotalCreditosOrdinarios()', 0, 'DD', TO_TIMESTAMP('24/05/2012 10:44:47.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'), 0);
Insert into UGAS001.TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarEscritoInsinuacionCreditos'), 6, 'currency', 'tCredSub', 'Total créditos subordinados', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'dameTotalCreditosSubordinados()', 0, 'DD', TO_TIMESTAMP('24/05/2012 10:44:47.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'), 0);
Insert into UGAS001.TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarEscritoInsinuacionCreditos'), 7, 'currency', 'tCredContigentes', 'Total créditos contigentes', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'dameTotalCreditosContingentes()', 0, 'DD', TO_TIMESTAMP('24/05/2012 10:44:47.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'), 0);
Insert into UGAS001.TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarEscritoInsinuacionCreditos'), 8, 'currency', 'totalCred', 'Total créditos insinuados', 'dameTotalCreditos()', 0, 'DD', TO_TIMESTAMP('30/05/2012 18:08:18.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'), 0);

 --tarea 6
 Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_DECISION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO,DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P24'), 'P24_regComProyectoInventario', 0, 'Registrar comunicación proyecto inventario', 
'valores[''P24_regComProyectoInventario''][''comFavorable''] == DDSiNo.SI ? ''SI'' : ''NO'' ',
0, 'DD', SYSDATE, 0,'EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_regComProyectoInventario'), 'damePlazo(valores[''P24_registrarPublicacionBOE''][''fecha'']) + 15*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_regComProyectoInventario'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se deber&'||'aacute; consignar la fecha con la que se nos comunica mediante correo electr&'||'oacute;nico por la Administraci&'||'oacute;n Concursal el proyecto de inventario</p>
<p style="margin-bottom: 10px">Igualmente, dberemos informar si es favorable o desfavorable a los intereses de la Entidad el proyecto remitido por la Administraci&'||'oacute;n Concursal. En el caso de que sea favorable, se deber&'||'aacute; esperar a la siguente tarea, sobre el informe presentado por la Administraci&'||'aacute;n Concursal ante el juez</p>
<p style="margin-bottom: 10px">En el caso de que sea desfavorable, deber&'||'aacute; informar al supervisor mediante comunicado o notificaci&'||'oacute;n para recibir instrucciones. En ese caso, deber&'||'aacute; presentar escrito solicitando la rectificaci&'||'oacute;n de cualquier error o simplemente los datos comunicados</p></div>'
, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_regComProyectoInventario'), 1, 'date', 'fechaComunicacion', 'Fecha de comunicación del proyecto', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_regComProyectoInventario'), 2, 'combo', 'comFavorable', 'Favorable', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);

--TAREA 8
update TFI_TAREAS_FORM_ITEMS
set tfi_label = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;">
<p style="margin-bottom: 10px">En esta pantalla debe indicar si se presentan alegaciones a nuestra propuesta de insinuaci&'||'oacute;n de cr&'||'eacute;ditos, al pulsar Aceptar el sistema comprobar&'||'aacute; que el estado de los cr&'||'eacute;ditos insinuados en la pesta&'||'nacute;a Fase Com&'||'uacute;n es, en caso de presentar alegaciones &'||'quot;4. Pendiente de demanda incidental&'||'quot; o en caso contrario &'||'quot;6. Reconocido&'||'quot;. Para ello debe abrir el asunto correspondiente, ir a la pesta&'||'nacute;a &'||'quot;Fase Com&'||'uacute;n&'||'quot; y abrir la ficha de cada uno de los cr&'||'eacute;ditos insinuados y cambiar su estado</p>
<p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p>
<p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea en caso de no presentar alegaciones ser&'||'aacute; &'||'quot;Registrar resoluci&'||'oacute;n de finalizaci&'||'oacute;n fase com&'||'uacute;n&'||'quot; y en caso de haberse presentado se iniciar&'||'aacute; el tr&'||'aacute;mite de demanda incidental</p></div>'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_revisarResultadoInfAdmon') and tfi_nombre ='titulo';


--NUEVA TAREA
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_DECISION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_VIEW, DTYPE, DD_FAP_ID)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P24'), 'P24_registrarAceptacion', 0, 'Registrar aceptación de asunto',
'((valores[''P24_registrarAceptacion''][''comboAceptación''] == DDSiNo.SI) &&'||' (valores[''P24_registrarAceptacion''][''comboConflicto''] == DDSiNo.NO)) ?  ''SI'' : ''NO''', 0, 'DD', SYSDATE, 0, 
'plugin/procedimientos/aceptacionYdecision/aceptacion', 'EXTTareaProcedimiento', (select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='09'));

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarAceptacion'), '2*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarAceptacion'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&'||'eacute;s de esta pantalla deberá indicar si acepta el Asunto asignado por la entidad o no.</p><p style="margin-bottom: 10px">En el campo &'||'quot;Conflicto de intereses&'||'quot; deber&'||'aacute; consignar la existencia de conflicto o no, que le impida aceptar la direcci&'||'oacute;n de la acci&'||'oacute;n a instar, en caso de que haya conflicto de intereses no se le permitir&'||'aacute; la aceptaci&'||'oacute;n del Asunto.</p><p style="margin-bottom: 10px">En el campo &'||'quot;Aceptaci&'||'oacute;n del asunto &'||'quot; deber&'||'aacute; indicar si acepta o no el asunto, si ha marcado con anterioridad que existe conflicto de intereses, deber&'||'aacute; marcar, en todo caso, la no aceptaci&'||'oacute;n del asunto.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Registrar insinuaci&'||'oacute;n de cr&'||'eacute;ditos gestor letrado&'||'quot; en caso de que haya aceptado el asunto, en caso de no haber aceptado el asunto se creará una tarea al supervisor para que tenga en cuenta su respuesta a la vez que reasigna el asunto a otro letrado.</p></div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarAceptacion'), 1, 'currency', 'principal', 'Principal','procedimientoManager.getProcedimiento(idProcedimiento).getSaldoRecuperacion()', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarAceptacion'), 2, 'combo', 'comboConflicto', 'Conflicto de intereses', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarAceptacion'), 3, 'combo', 'comboAceptación', 'Aceptación del asunto', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarAceptacion'), 4, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);
commit;