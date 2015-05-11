/*
 * Trámite de Análisis de contratos
 * 
 * Pruebas:
 * 	- Roles implicados: SUPERVISOR, GESTOR
 * 
 */
SET SERVEROUTPUT ON; 
SET DEFINE OFF

DECLARE
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
	V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
	V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
	VAR_CODIGO_PROCEDIMIENTO VARCHAR2(10 CHAR) := 'P405';
	VAR_CODIGO_BPM VARCHAR2(10 CHAR);
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
	(S_DD_TPO_TIPO_PROCEDIMIENTO.NEXTVAL, VAR_CODIGO_PROCEDIMIENTO, 'T. Inicio de Expediente Judicial', 'T. Inicio de Expediente Judicial','tramiteInicioExpJudicialV4', 0, 'dd', sysdate, 0, (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='CO'));


	
-- P405_LecturaInstruccionesEntidad.
VAR_CODIGO_TAREA := 'P405_LecturaInstruccionesEntidad';
VAR_PLAZO_TAREA := '1*24*60*60*1000L';
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_SCRIPT_DECISION, TAP_SCRIPT_VALIDACION)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO),
   VAR_CODIGO_TAREA,
   NULL, -- VIEW
   0, -- SUPERVISOR
   'Lectura instrucciones de entidad', 0, 'DD', sysdate, 0, 
   'EXTTareaProcedimiento',
   NULL,	-- DECISION
   NULL -- VALIDACION
   ); 
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que la entidad ha decidido ejecutar los contratos marcados en el campo “Contratos” de esta pantalla, antes de dar por completada esta tarea deberá iniciar la preparación del expediente para su reclamación conforme al protocolo establecido por la entidad.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta tarea se lanzará la tarea "Registrar marca de prelitigio"</p></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo=VAR_CODIGO_TAREA);

Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),1,'date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),2,'text','contrato','Contrato','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','dameContratoAsignadoABPM()',null,'0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 3, 'label', 'instrucLabel',  '<div align="justify" style="font-size: 8pt; font-family: Arial; margin: 10px 0 10px;"><p>Instrucciones de la entidad:</p></div>' , 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),4,'htmllabel','instrucciones','Instrucciones',null,null,'dameInstruccionesInicioExpedienteJudicial()',null,'0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),5,'textarea','observaciones','Observaciones',null,null,null,null,'0','DD',sysdate,null,null,null,null,'0');


-- P405_RegistrarMarcaPrelitigio.
VAR_CODIGO_TAREA := 'P405_RegistrarMarcaPrelitigio';
VAR_PLAZO_TAREA := '1*24*60*60*1000L';
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_SCRIPT_DECISION, TAP_SCRIPT_VALIDACION)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO),
   VAR_CODIGO_TAREA,
   NULL, -- VIEW
   0, -- SUPERVISOR
   'Registrar marca de prelitigio', 0, 'DD', sysdate, 0, 
   'EXTTareaProcedimiento',
   NULL,	-- DECISION
   NULL -- VALIDACION
   ); 
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Antes de dar por completada esta tarea deberá iniciar la preparación del expediente para su reclamación conforme al protocolo establecido por la entidad. En el campo Fecha deberá consignar la fecha en que haya iniciado dicha preparación.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta tarea se dará por concluido este trámite y el sistema quedará a la espera de recibir el nuevo preligió creado.</p></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo=VAR_CODIGO_TAREA);

Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),1,'date','fecha','Fecha marcado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),5,'textarea','observaciones','Observaciones',null,null,null,null,'0','DD',sysdate,null,null,null,null,'0');

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