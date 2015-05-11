-- actualziación en todas las entidades.
-- dependencia con al versión a fecha 24032011 del plugin BPMs

update PFS01.TAP_TAREA_PROCEDIMIENTO set TAP_SCRIPT_VALIDACION_JBPM = '((valores[''P02_ConfirmarOposicionCuantia''][''comboResultado''] == DDSiNo.SI) &&'||' (valores[''P02_ConfirmarOposicionCuantia''][''fechaOposicion''] == ''''))?''El campo Fecha de oposici&'||'oacute;n es obligatorio'':(((valores[''P02_ConfirmarOposicionCuantia''][''comboResultado''] == DDSiNo.SI) &&'||' (valores[''P02_ConfirmarOposicionCuantia''][''fechaJuicio''] == '''')  &&'||' (damePrincipal()<6000))?''El campo Fecha de juicio es obligatorio'':null)'
WHERE TAP_CODIGO = 'P02_ConfirmarOposicionCuantia';
update PFS02.TAP_TAREA_PROCEDIMIENTO set TAP_SCRIPT_VALIDACION_JBPM = '((valores[''P02_ConfirmarOposicionCuantia''][''comboResultado''] == DDSiNo.SI) &&'||' (valores[''P02_ConfirmarOposicionCuantia''][''fechaOposicion''] == ''''))?''El campo Fecha de oposici&'||'oacute;n es obligatorio'':(((valores[''P02_ConfirmarOposicionCuantia''][''comboResultado''] == DDSiNo.SI) &&'||' (valores[''P02_ConfirmarOposicionCuantia''][''fechaJuicio''] == '''')  &&'||' (damePrincipal()<6000))?''El campo Fecha de juicio es obligatorio'':null)'
WHERE TAP_CODIGO = 'P02_ConfirmarOposicionCuantia';
update SOR01.TAP_TAREA_PROCEDIMIENTO set TAP_SCRIPT_VALIDACION_JBPM = '((valores[''P02_ConfirmarOposicionCuantia''][''comboResultado''] == DDSiNo.SI) &&'||' (valores[''P02_ConfirmarOposicionCuantia''][''fechaOposicion''] == ''''))?''El campo Fecha de oposici&'||'oacute;n es obligatorio'':(((valores[''P02_ConfirmarOposicionCuantia''][''comboResultado''] == DDSiNo.SI) &&'||' (valores[''P02_ConfirmarOposicionCuantia''][''fechaJuicio''] == '''')  &&'||' (damePrincipal()<6000))?''El campo Fecha de juicio es obligatorio'':null)'
WHERE TAP_CODIGO = 'P02_ConfirmarOposicionCuantia';
update SCF01.TAP_TAREA_PROCEDIMIENTO set TAP_SCRIPT_VALIDACION_JBPM = '((valores[''P02_ConfirmarOposicionCuantia''][''comboResultado''] == DDSiNo.SI) &&'||' (valores[''P02_ConfirmarOposicionCuantia''][''fechaOposicion''] == ''''))?''El campo Fecha de oposici&'||'oacute;n es obligatorio'':(((valores[''P02_ConfirmarOposicionCuantia''][''comboResultado''] == DDSiNo.SI) &&'||' (valores[''P02_ConfirmarOposicionCuantia''][''fechaJuicio''] == '''')  &&'||' (damePrincipal()<6000))?''El campo Fecha de juicio es obligatorio'':null)'
WHERE TAP_CODIGO = 'P02_ConfirmarOposicionCuantia';

-- nuevo procedimiento para almacenar los procedimientos concursales, solo para PFS02
Insert into PFS02.DD_TAC_TIPO_ACTUACION(DD_TAC_ID, DD_TAC_CODIGO, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TAC_TIPO_ACTUACION.nextval, '05', 'Concursal Bloqueado', 'Concursal Bloqueado', 0, 'DD', SYSDATE, 0);

Insert into PFS02.DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P95', 'Procedimiento concursal bloqueado', 'Procedimiento concursal bloqueado', '', 'procedimientoConcursalBloqueado', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='05'), 0, 'DD', SYSDATE, 0);
