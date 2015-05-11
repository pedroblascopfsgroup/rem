/*
 * Trámite de Fase común Abreviado.
 * 
 * Pruebas:
 * 	- Roles implicados: SUPERVISOR, GESTOR, EDP
 * 	- Se necesita lanzar el script DML-04-BANK01-CrearUsuarioEDP.sql que crea el usuario GESTOREDP (EDP).
 * 
 */
SET SERVEROUTPUT ON; 

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     

    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas

    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   

    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.

    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

  	

  VAR_CODIGO_PROCEDIMIENTO VARCHAR2(10 CHAR) := 'P412';
  VAR_CODIGO_TAREA VARCHAR2(50 CHAR) := NULL;
  VAR_PLAZO_BPM_DERIVADO VARCHAR2(20 CHAR) := '300*24*60*60*1000L';
  VAR_PLAZO_TAREA VARCHAR2(1000 CHAR) := NULL;

BEGIN

dbms_output.put_line(VAR_CODIGO_PROCEDIMIENTO || ' - ROLLBACK DATOS y TABLAS...');

-- ROLLBACK COMPLETO
DELETE FROM tfi_tareas_form_items
      WHERE tap_id IN (SELECT tap_id
                         FROM tap_tarea_procedimiento
                        WHERE dd_tpo_id = (SELECT dd_tpo_id
                                             FROM dd_tpo_tipo_procedimiento
                                            WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO));


DELETE FROM dd_ptp_plazos_tareas_plazas
      WHERE tap_id IN (SELECT tap_id
                         FROM tap_tarea_procedimiento
                        WHERE dd_tpo_id = (SELECT dd_tpo_id
                                             FROM dd_tpo_tipo_procedimiento
                                            WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO));

DELETE FROM ter_tarea_externa_recuperacion ter
      WHERE ter.tex_id IN (SELECT tex_id
                             FROM tex_tarea_externa
                            WHERE tap_id IN (SELECT tap_id
                                               FROM tap_tarea_procedimiento
                                              WHERE dd_tpo_id = (SELECT dd_tpo_id
                                                                   FROM dd_tpo_tipo_procedimiento
                                                                  WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO)));

DELETE FROM TEV_TAREA_EXTERNA_VALOR TTV
      WHERE TTV.TEX_ID IN (SELECT tex_id
                             FROM tex_tarea_externa
                            WHERE tap_id IN (SELECT tap_id
                                               FROM tap_tarea_procedimiento
                                              WHERE dd_tpo_id = (SELECT dd_tpo_id
                                                                   FROM dd_tpo_tipo_procedimiento
                                                                  WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO)));

DELETE FROM tex_tarea_externa
      WHERE tap_id IN (SELECT tap_id
                         FROM tap_tarea_procedimiento
                        WHERE dd_tpo_id = (SELECT dd_tpo_id
                                             FROM dd_tpo_tipo_procedimiento
                                            WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO));

DELETE FROM tap_tarea_procedimiento
      WHERE dd_tpo_id = (SELECT dd_tpo_id
                           FROM dd_tpo_tipo_procedimiento
                          WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO);

DELETE FROM tar_tareas_notificaciones
      WHERE prc_id IN (SELECT prc_id
                         FROM prc_procedimientos
                        WHERE dd_tpo_id = (SELECT dd_tpo_id
                                             FROM dd_tpo_tipo_procedimiento
                                            WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO)
                                            );

DELETE FROM CRE_PRC_CEX WHERE CRE_PRC_CEX_PRCID IN (SELECT prc_id
                         FROM prc_procedimientos
                        WHERE dd_tpo_id = (SELECT dd_tpo_id
                                             FROM dd_tpo_tipo_procedimiento
                                            WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO));
                                           
DELETE FROM prc_cex
      WHERE prc_id IN (SELECT prc_id
                         FROM prc_procedimientos
                        WHERE dd_tpo_id = (SELECT dd_tpo_id
                                             FROM dd_tpo_tipo_procedimiento
                                            WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO));

DELETE FROM hac_historico_accesos
      WHERE prc_id IN (SELECT prc_id
                         FROM prc_procedimientos
                        WHERE dd_tpo_id = (SELECT dd_tpo_id
                                             FROM dd_tpo_tipo_procedimiento
                                            WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO));

DELETE FROM prc_per
      WHERE prc_id IN (SELECT prc_id
                         FROM prc_procedimientos
                        WHERE dd_tpo_id = (SELECT dd_tpo_id
                                             FROM dd_tpo_tipo_procedimiento
                                            WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO));


-- Elimina los procedimientos derivados
DELETE FROM prd_procedimientos_derivados WHERE dpr_id IN (
  SELECT DPR_ID FROM DPR_DECISIONES_PROCEDIMIENTOS WHERE PRC_ID  IN (SELECT prc_id
                         FROM prc_procedimientos
                        WHERE dd_tpo_id = (SELECT dd_tpo_id
                                             FROM dd_tpo_tipo_procedimiento
                                            WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO))

);

DELETE FROM prd_procedimientos_derivados WHERE prc_id IN (SELECT prc_id
                         FROM prc_procedimientos
                        WHERE dd_tpo_id = (SELECT dd_tpo_id
                                             FROM dd_tpo_tipo_procedimiento
                                            WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO));
                        

/*
SELECT DPR_ID FROM
DPR_DECISIONES_PROCEDIMIENTOS WHERE PRC_ID  IN (SELECT prc_id
                         FROM prc_procedimientos
                        WHERE dd_tpo_id = (SELECT dd_tpo_id
                                             FROM dd_tpo_tipo_procedimiento
                                            WHERE dd_tpo_codigo = 'P413'));                                    
*/                                            
DELETE FROM DPR_DECISIONES_PROCEDIMIENTOS WHERE PRC_ID  IN (SELECT prc_id
                         FROM prc_procedimientos
                        WHERE dd_tpo_id = (SELECT dd_tpo_id
                                             FROM dd_tpo_tipo_procedimiento
                                            WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO));

DELETE FROM PRB_PRC_BIE WHERE PRC_ID IN (SELECT prc_id
                         FROM prc_procedimientos
                        WHERE dd_tpo_id = (SELECT dd_tpo_id
                                             FROM dd_tpo_tipo_procedimiento
                                            WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO));

-- PARA LIMPIAR DEPENDENCIAS
UPDATE prc_procedimientos SET PRC_PRC_ID=NULL 
  WHERE PRC_PRC_ID IN (SELECT prc_id
                         FROM prc_procedimientos
                        WHERE dd_tpo_id = (SELECT dd_tpo_id
                                             FROM dd_tpo_tipo_procedimiento
                                            WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO));

DELETE FROM prc_procedimientos WHERE dd_tpo_id = (SELECT dd_tpo_id
                           FROM dd_tpo_tipo_procedimiento
                          WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO);

                          -- PARA LIMPIAR DEPENDENCIAS
UPDATE TAP_TAREA_PROCEDIMIENTO SET DD_TPO_ID_BPM=NULL WHERE DD_TPO_ID_BPM IN (
	SELECT DD_TPO_ID FROM dd_tpo_tipo_procedimiento
	      WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO
);

DELETE FROM dd_tpo_tipo_procedimiento
      WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO;

----

dbms_output.put_line(VAR_CODIGO_PROCEDIMIENTO || ' - CREANDO TRAMITE FASE COMUN ABREVIADO...');

-- CREA EL PROCEDIMIENTO P420
Insert into DD_TPO_TIPO_PROCEDIMIENTO
	(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TAC_ID) 
Values
	(S_DD_TPO_TIPO_PROCEDIMIENTO.NEXTVAL, VAR_CODIGO_PROCEDIMIENTO, 'T. fase común abreviado', 'T. fase común abreviado','tramiteFaseComunAbreviadoV4', 0, 'dd', sysdate, 0, (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='CO'));

	
-- P412_RegistrarPublicacionBOE.
VAR_CODIGO_TAREA := 'P412_RegistrarPublicacionBOE';
VAR_PLAZO_TAREA := '3*24*60*60*1000L';
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, DD_STA_ID)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO),
   VAR_CODIGO_TAREA,
   'plugin/procedimientos/tramiteFaseComunAbreviado/regPublicacionBOE',
   0, 
   'Registrar publicación en el BOE', 0, 'DD', sysdate, 0, 
   'EXTTareaProcedimiento',
   (SELECT DD_STA_ID FROM BANKMASTER.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO='600'));
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta pantalla deberá de revisar los datos que aparecen rellenados respecto al nuevo concurso y consignar aquellos datos que aparecen vacíos. Opcionalmente puede consignar los datos de contacto de los administradores concursales designados.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será "Registrar insinuación de créditos"</p></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo=VAR_CODIGO_TAREA);

Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	1, 'date', 'fecha', 'Fecha de publicación', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	2, 'date', 'fechaAuto', 'Fecha auto declarando concurso', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_VALOR_INICIAL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	3, 'combo', 'plazaJuzgado', 'Plaza del juzgado', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 'damePlaza()', 'TipoPlaza', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_VALOR_INICIAL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	4, 'combo', 'nJuzgado', 'Nº de juzgado', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 'dameNumJuzgado()', 'TipoJuzgado', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	5, 'textproc', 'nAuto', 'Nº Auto', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 'dameNumAuto()', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	6, 'date', 'fechaAceptacion', 'Fecha aceptación del cargo de la Adm. Concursal', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	7, 'text', 'admNombre', 'Adm. Nombre', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	8, 'text', 'admDireccion', 'Adm. dirección', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	9, 'text', 'admTelefono', 'Adm. teléfono', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	10, 'text', 'admEmail', 'Adm. email', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	11, 'text', 'admNombre2', 'Adm.2 Nombre', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	12, 'text', 'admDireccion2', 'Adm.2 dirección', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	13, 'text', 'admTelefono2', 'Adm.2 teléfono', 0, 'DD',sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	14, 'text', 'admEmail2', 'Adm.2 email', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	15, 'text', 'admNombre3', 'Auxiliar delegado Nombre', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	16, 'text', 'admDireccion3', 'Auxiliar delegado Dirección', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	17, 'text', 'admTelefono3', 'Auxiliar delegado Teléfono', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	18, 'text', 'admEmail3', 'Auxiliar delegado Email', 0, 'DD',sysdate, 0);
/*Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	19, 'text', 'procurador', 'Procurador', 0, 'DD', sysdate, 0);*/
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	19, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);


--------------------------
---- BPM TRAMITE DE ACEPTACION POR PARTE DEL GESTOR
--------------------------
VAR_CODIGO_TAREA := 'P412_BPMTramiteAceptacionV4';
VAR_PLAZO_TAREA := VAR_PLAZO_BPM_DERIVADO;
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, 
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_PROCEDIMIENTO),
	VAR_CODIGO_TAREA, 0,
	'Tramite de Aceptación',
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P404'), 0, 'dd', sysdate, 0, 'EXTTareaProcedimiento');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval,
	(select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  
	'Trámite de Aceptación por parte del gestor' , 0, 'DD', SYSDATE, 0);
   
   
-- P412_RegistrarInsinuacionCreditos.
VAR_CODIGO_TAREA := 'P412_RegistrarInsinuacionCreditos';
VAR_PLAZO_TAREA := 'damePlazo(valores[''P412_RegistrarPublicacionBOE''][''fecha'']) + 5*24*60*60*1000L';
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SCRIPT_VALIDACION_JBPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO), 
   VAR_CODIGO_TAREA,
   'valores[''P412_RegistrarInsinuacionCreditos''][''numCreditos''] == null || valores[''P412_RegistrarInsinuacionCreditos''][''numCreditos''] == '''' || valores[''P412_RegistrarInsinuacionCreditos''][''numCreditos''] == ''0'' ? ''tareaExterna.procedimiento.tramiteFaseComun.numCreditos'': (cuentaCreditosInsinuadosExt()!=valores[''P412_RegistrarInsinuacionCreditos''][''numCreditos''] ? ''tareaExterna.procedimiento.tramiteFaseComun.numCreditosInsinuados'' : null)', 
   0, 
   'Registrar insinuación de créditos', 0, 'DD', sysdate, 0,
   'EXTTareaProcedimiento');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Antes de poder completar esta tarea deberá acceder a la pestaña "Fase común" de la ficha del asunto correspondiente y proceder a la insinuación de los créditos, para ello dispone del botón “Agregar calificación”, a través del cual podrá tanto proponer una calificación inicial de los contratos asociados al concurso para posterior revisión por parte de la entidad,  como establecer la calificación definitiva de los contratos asociados al concurso a expensas de que la entidad lo revise.</p><p style="margin-bottom: 10px">En la presente pantalla debe indicar el número de créditos insinuados.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será "Revisar insinuación de créditos" a realizar por el supervisor del asunto concursal.</p></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo=VAR_CODIGO_TAREA);

Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TFI_ERROR_VALIDACION, TFI_VALIDACION)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	1, 'currency', 'numCreditos', 'Nº de créditos insinuados', 0, 'DD', sysdate, 0, 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);

-- P412_RevisarInsinuacionCreditos.
VAR_CODIGO_TAREA := 'P412_RevisarInsinuacionCreditos';
VAR_PLAZO_TAREA := 'damePlazo(valores[''P412_RegistrarPublicacionBOE''][''fecha'']) + 22*24*60*60*1000L';
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SCRIPT_VALIDACION_JBPM, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_ALERT_VUELTA_ATRAS, TAP_SUPERVISOR, DD_STA_ID)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO), 
   VAR_CODIGO_TAREA,
   'valores[''P412_RevisarInsinuacionCreditos''][''numCreditos''] == null || valores[''P412_RevisarInsinuacionCreditos''][''numCreditos''] == '''' || valores[''P412_RevisarInsinuacionCreditos''][''numCreditos''] == ''0'' ? (cuentaCreditosInsinuadosSup() != ''0'' ? ''tareaExterna.procedimiento.tramiteFaseComun.numCreditos'' : null) : (cuentaCreditosInsinuadosSup()!=valores[''P412_RevisarInsinuacionCreditos''][''numCreditos''] ? ''tareaExterna.procedimiento.tramiteFaseComun.numCreditosInsinuados'' : null)', 
   'Revisar insinuación de créditos', 0, 'DD', sysdate, 0, 
   'EXTTareaProcedimiento',
   'tareaExterna.cancelarTarea',
   1, (SELECT DD_STA_ID FROM BANKMASTER.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO='40'));
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Antes de rellenar esta pantalla deberá revisar las insinuaciones realizadas por el letrado, para el supuesto que quiera rectificar alguna de ellas deberá acceder a la pestaña "Fase común" de la ficha del asunto correspondiente y a través del botón "Revisar calificación" proponer los valores que estime en los campos de calificación revisada.</p><p style="margin-bottom: 10px">En la presente pantalla y para el caso del supuesto anterior debe indicar el número de créditos rectificados.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será "Presentar escrito de insinuación de créditos" a realizar por el letrado concursa</p></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo=VAR_CODIGO_TAREA);

Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	1, 'currency', 'numCreditos', 'Nº de créditos rectificados', NULL, NULL, 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);


-- P412_PresentarEscritoInsinuacion
VAR_CODIGO_TAREA := 'P412_PresentarEscritoInsinuacion';
VAR_PLAZO_TAREA := 'damePlazo(valores[''P412_RegistrarPublicacionBOE''][''fecha'']) + 30*24*60*60*1000L';
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SCRIPT_VALIDACION_JBPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_ALERT_VUELTA_ATRAS)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO),
   VAR_CODIGO_TAREA,
   'plugin/procedimientos/tramiteFaseComunAbreviado/presentarEscritoInsinuacionCreditos',
   'creditosDefinitivosDefinidosEInsinuados() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.creditosNoInsinuados''', 0,
   'Presentar escrito de insinuación', 0, 'DD', sysdate, 0, 'EXTTareaProcedimiento', 
   'tareaExterna.cancelarTarea');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Antes de poder completar esta tarea, deberá asegurarse que todas las insinuaciones de crédito a presentar a la administración concursal, se encuentran en la pestaña Fase común del asunto correspondiente con valores definitivos y en estado "2. Insinuado".</p><p style="margin-bottom: 10px">En esta pantalla debe indicar la fecha de presentación o envío por correo electrónico de la propuesta de insinuación de créditos a la administración concursal.</p><p style="margin-bottom: 10px">En esta tarea, aparecerán acumulados los importes de los créditos insinuados.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será, si hemos comunicado nuestros créditos a la Administración concursal mediante correo electrónico, "Revisar proyecto de inventario".</p></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo=VAR_CODIGO_TAREA);

Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	1, 'date', 'fecha', 'Fecha presentación', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	2, 'currency', 'tCredMasa', 'Total créditos contra la masa', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'dameTotalCreditosContraLaMasa()', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	3, 'currency', 'tCredPrivEsp', 'Total créditos con privilegio especial', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'dameTotalCreditosConPrivilegioEspecial()', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	4, 'currency', 'tCredPrivGen', 'Total créditos con privilegio general', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'dameTotalCreditosConPrivilegioGeneral()', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	5, 'currency', 'tCredOrd', 'Total créditos ordinarios', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'dameTotalCreditosOrdinarios()', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	6, 'currency', 'tCredSub', 'Total créditos subordinados', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'dameTotalCreditosSubordinados()', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	7, 'currency', 'tCredContigentes', 'Total créditos contigentes', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'dameTotalCreditosContingentes()', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	8, 'currency', 'totalCred', 'Total créditos insinuados', 'dameTotalCreditos()', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	9, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);
	
-- P412_RegistrarProyectoInventario
VAR_CODIGO_TAREA := 'P412_RegistrarProyectoInventario';
VAR_PLAZO_TAREA := 'damePlazo(valores[''P412_RegistrarPublicacionBOE''][''fecha'']) + 15*24*60*60*1000L';
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SCRIPT_DECISION, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_ALERT_VUELTA_ATRAS)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO),
	VAR_CODIGO_TAREA,
	'valores[''P412_RegistrarProyectoInventario''][''comFavorable''] == DDSiNo.SI ? ''favorable'' : ''desfavorable''', 0,
	'Registrar proyecto de inventario', 0, 'DD', sysdate, 0, 
	'EXTTareaProcedimiento',
	'tareaExterna.cancelarTarea');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se deberá consignar la fecha con la que se nos comunica mediante correo electrónico por la Administración Concursal el proyecto de inventario.</p><p style="margin-bottom: 10px">Igualmente, deberemos informar si es favorable o desfavorable a los intereses de la Entidad el proyecto remitido por la Administración Concursal. En el caso de que sea favorable, se deberá esperar a la siguiente tarea sobre el informe presentado por la Administración Concursal ante el juez.</p><p style="margin-bottom: 10px">En el caso de que sea desfavorable, deberá comprobar si el error ha sido cometido por la Entidad a la hora de elaborar la insinuación de créditos. Si la insinuación ha sido correcta deberá ponerse en contacto con la Administración Concursal para su aclaración. Con independencia de que se aclarada o no la discrepancia con la Administración Concursal, se deberá remitir igualmente correo electrónico a la Administración Concursal solicitando su subsanación para su constancia por escrito, haciendo mención en su caso de la aclaración efectuada previamente.</p><p style="margin-bottom: 10px">En aquellos casos en los que la discrepancia sea relevante deberá informar al supervisor mediante comunicado o notificación para anticipar la posibilidad de que sea  necesario interponer un incidente de impugnación una vez presentado el informe en el Juzgado. En todo caso, tanto si el proyecto es favorable como desfavorable, deberemos modificar el estado de todos los créditos al estado "3. Pendiente revisión IAC" para completar esta tarea.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será, en caso de ser favorable "Registrar informe de la administración concursal" y en caso contrario "Presentar rectificación".</p></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo=VAR_CODIGO_TAREA);

Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TFI_ERROR_VALIDACION, TFI_VALIDACION)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	1, 'date', 'fechaComunicacion', 'Fecha de comunicación del proyecto', 0, 'DD', TO_TIMESTAMP('24/05/2012 10:44:47.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'), 0, 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	2, 'combo', 'comFavorable', 'Favorable', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 'DDSiNo', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	3, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);

-- P412_PresentarRectificacion
VAR_CODIGO_TAREA := 'P412_PresentarRectificacion';
VAR_PLAZO_TAREA := 'damePlazo(valores[''P412_PresentarEscritoInsinuacion''][''fecha'']) + 7*24*60*60*1000L';
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_ALERT_VUELTA_ATRAS)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO), 
   VAR_CODIGO_TAREA, 0, 
   'Presentar rectificación', 0, 'DD', sysdate, 0, 
   'EXTTareaProcedimiento',
   'tareaExterna.cancelarTarea');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se deberá consignar la fecha del envío por correo electrónico del escrito solicitando la rectificación de errores o el complemento de datos en el proyecto de inventario y de la lista de acreedores notificados por la Administración Concursal.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.
Una vez rellene esta pantalla la siguiente tarea será "Registrar informe de la administración concursal".</p></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo=VAR_CODIGO_TAREA);

Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	1, 'date', 'fecha', 'Fecha presentación', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);


-- 	P412_RegistrarInformeAdmonConcursal
VAR_CODIGO_TAREA := 'P412_RegistrarInformeAdmonConcursal';
VAR_PLAZO_TAREA := 'damePlazo(valores[''P412_RegistrarPublicacionBOE''][''fechaAuto'']) + 45*24*60*60*1000L';
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SCRIPT_VALIDACION_JBPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO),
   VAR_CODIGO_TAREA,
   'creditosDefinitivosPendientes() ? ''tareaExterna.procedimiento.tramiteFaseComun.creditosDefinitivosPendientes'': null', 0, 
   'Registrar informe de la administración concursal', 0, 'DD', sysdate, 0, 
   'EXTTareaProcedimiento');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debe indicar la fecha de recepción del informe de administración concursal en respuesta a nuestra presentación de insinuación de créditos, al pulsar Aceptar el sistema comprobará que los créditos insinuados en la pestaña "Fase Común" disponen de cuantías finales y que se encuentran en estado "3 Pendiente Revisión IAC". Para ello debe abrir el asunto correspondiente, ir a la pestaña Fase Común y abrir la ficha de cada uno de los créditos insinuados y cambiar su estado.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será "Revisar informe de la administración concursal".</p></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo=VAR_CODIGO_TAREA);

Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	1, 'date', 'fecha', 'Fecha', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);

-- P412_RevisarResultadoInfAdmon
VAR_CODIGO_TAREA := 'P412_RevisarResultadoInfAdmon';
VAR_PLAZO_TAREA := 'damePlazo(valores[''P412_RegistrarInformeAdmonConcursal''][''fecha'']) + 2*24*60*60*1000L';
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SCRIPT_VALIDACION_JBPM, TAP_SCRIPT_DECISION, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS, DTYPE)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO), 
   VAR_CODIGO_TAREA, 
   'valores[''P412_RevisarResultadoInfAdmon''][''comAlegaciones''] == DDSiNo.SI ? ( creditosDespuesDeIACConDemanda() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.creditosDespuesDeIACDemandaMalDefinidos'' ) : ( creditosDespuesDeIACSinDemanda() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.creditosDespuesDeIACMalDefinidos'')',
   'valores[''P412_RevisarResultadoInfAdmon''][''comAlegaciones''] == DDSiNo.SI ? ''SI'' : ''NO''', 0, 
   'Revisar informe de la administración concursal', 0, 'DD', sysdate, 0, 'tareaExterna.cancelarTarea', 
   'EXTTareaProcedimiento');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
   
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debe indicar si se presentan alegaciones al informe de la Administración Concursal, al pulsar Aceptar el sistema comprobará que el estado de los créditos insinuados en la pestaña Fase Común es, en caso de presentar alegaciones "4. Pendiente de demanda incidental" o en caso contrario "6. Reconocido". Para ello debe abrir el asunto correspondiente, ir a la pestaña "Fase Común" y abrir la ficha de cada uno de los créditos insinuados y cambiar su estado.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px"></p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea en caso de no presentar alegaciones será "Registrar resolución de finalización fase común" y en caso de haberse presentado se lanzará la tarea "Validar alegaciones" al supervisor del concurso.</p></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo=VAR_CODIGO_TAREA);

Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	1, 'combo', 'comAlegaciones', 'Presentar alegaciones', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 'DDSiNo', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);


-- P412_RegistrarResolucionFaseComun
VAR_CODIGO_TAREA := 'P412_RegistrarResolucionFaseComun';
VAR_PLAZO_TAREA := '180*24*60*60*1000L';
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SCRIPT_DECISION, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO),
	VAR_CODIGO_TAREA,
	'valores[''P412_RegistrarResolucionFaseComun''][''comboLiquidacion''] == DDSiNo.SI ? ''faseLiquidacion'' : ''faseConvenio''', 0, 
	'Registrar resolución de fase común', 0, 'DD', sysdate, 0,
	'EXTTareaProcedimiento');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Esta tarea deberá completarla en el momento que tenga constancia del fin de la fase común e inicio de la siguiente fase. En el campo "Situación concursal" deberá indicar la situación en la que queda el concurso una vez completada esta tarea.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se iniciará la Fase de liquidación en caso de que lo haya indicado así, en caso contrario se iniciará la Fase de convenio.</p></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo=VAR_CODIGO_TAREA);


Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	1, 'date', 'fecha', 'Fecha', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	2, 'combo', 'comboLiquidacion', 'Fase de liquidación', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 'DDSiNo', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	3, 'combo', 'SituacionConcursal', 'Situación concursal', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 'DDSituacConcursal', 0, 'Oscar_com', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	4, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);


-- P412_ValidarAlegaciones
VAR_CODIGO_TAREA := 'P412_ValidarAlegaciones';
VAR_PLAZO_TAREA := 'damePlazo(valores[''P412_RegistrarInformeAdmonConcursal''][''fecha'']) + 5*24*60*60*1000L';
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_ALERT_VUELTA_ATRAS, TAP_SCRIPT_DECISION, TAP_SUPERVISOR, DD_STA_ID)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO),
   VAR_CODIGO_TAREA, 
   'Validar alegaciones', 0, 'DD', sysdate, 0,
   'EXTTareaProcedimiento',
   'tareaExterna.cancelarTarea',
   'valores[''P412_ValidarAlegaciones''][''PresentaAlegacionesCombo''] == DDSiNo.SI ? ''OK'' : ''KO''',
   1, (SELECT DD_STA_ID FROM BANKMASTER.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO='40'));
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta pantalla deberá revisar si procede presentar alegaciones según informa el letrado del concurso.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea, en caso de haber acordado junto al letrado la presentación de alegaciones, se iniciará el trámite de demanda incidental, en caso contrario se iniciará la tarea "Registrar resolución de fase".</p></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo=VAR_CODIGO_TAREA);

Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TFI_ERROR_VALIDACION, TFI_VALIDACION)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	1, 'date', 'fecha', 'Fecha', 0, 'DD', SYSDATE, 0, 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TFI_VALOR_INICIAL)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	2, 'combo', 'PresentaAlegaciones', 'Presenta alegaciones', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 'DDSiNo', 0, 'DD', sysdate, 0, 'valores[''P412_RevisarResultadoInfAdmon''][''comAlegaciones'']');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TFI_VALOR_INICIAL)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	3, 'textarea', 'ObservacionesLetrado', 'Observaciones letrado', null, 0, 'DD', sysdate, 0, 'valores[''P412_RevisarResultadoInfAdmon''][''observaciones'']');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	4, 'combo', 'PresentaAlegacionesCombo', 'Presentar alegaciones', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 'DDSiNo', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	5, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);

--------------------------
---- P412_BPMTramiteDemandaIncidental- BPM TRAMITE DE DEMANDA INCIDENTAL
--------------------------   
VAR_CODIGO_TAREA := 'P412_BPMTramiteDemandaIncidental';
VAR_PLAZO_TAREA := VAR_PLAZO_BPM_DERIVADO;
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, 
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_PROCEDIMIENTO),
	VAR_CODIGO_TAREA, 0,
	'Tramite de Demanda Incidental',
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P25'), 0, 'dd', sysdate, 0, 'EXTTareaProcedimiento');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval,
	(select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  
	'Se inicia Trámite demanda incidental' , 0, 'DD', SYSDATE, 0);

	
-- P412_ActualizarEstadoCreditos
VAR_CODIGO_TAREA := 'P412_ActualizarEstadoCreditos';
VAR_PLAZO_TAREA := '1*24*60*60*1000L';
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SCRIPT_VALIDACION_JBPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE)
 Values
   (s_tap_tarea_procedimiento.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_PROCEDIMIENTO),
   VAR_CODIGO_TAREA,
   'creditosDespuesDeIACSinDemanda() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.creditosDespuesDeIACMalDefinidos''', 0, 
   'Actualizar estado de los créditos insinuados', 0, 'DD', sysdate, 0, 
   'EXTTareaProcedimiento');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
   
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para completar esta tarea deberá actualizar el estado de los créditos insinuados en la pestaña "Fase común" de la ficha del Asunto correspondiente a valor "6. Reconocido".</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será "Registrar resolución finalización fase común".</p></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo=VAR_CODIGO_TAREA);

Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),
	1, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);

-- P412_BPMTramiteFaseConvenio
VAR_CODIGO_TAREA := 'P412_BPMTramiteFaseConvenioV4';
VAR_PLAZO_TAREA := VAR_PLAZO_BPM_DERIVADO;
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, 
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_PROCEDIMIENTO),
	VAR_CODIGO_TAREA, 0,
	'Se inicia la Fase de convenio',
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P408'), 0, 'dd', sysdate, 0, 'EXTTareaProcedimiento');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval,
	(select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  
	'Se inicia la Fase de convenio' , 0, 'DD', SYSDATE, 0);
   
-- P412_BPMTramiteFaseLiquidacion
VAR_CODIGO_TAREA := 'P412_BPMTramiteFaseLiquidacion';
VAR_PLAZO_TAREA := VAR_PLAZO_BPM_DERIVADO;
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, 
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_PROCEDIMIENTO),
	VAR_CODIGO_TAREA, 0,
	'Se inicia la Fase de liquidación',
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P31'), 0, 'dd', sysdate, 0, 'EXTTareaProcedimiento');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval,
	(select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  
	'Se inicia la Fase de liquidación' , 0, 'DD', SYSDATE, 0);


dbms_output.put_line(VAR_CODIGO_PROCEDIMIENTO || ' - FIN');

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