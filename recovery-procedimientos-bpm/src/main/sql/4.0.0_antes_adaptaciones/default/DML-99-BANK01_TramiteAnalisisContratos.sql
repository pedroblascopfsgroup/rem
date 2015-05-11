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
	
	VAR_CODIGO_PROCEDIMIENTO VARCHAR2(10 CHAR) := 'P402';
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
	(S_DD_TPO_TIPO_PROCEDIMIENTO.NEXTVAL, VAR_CODIGO_PROCEDIMIENTO, 'T. Análisis de Contratos', 'T. Análisis de Contratos','tramiteAnalisisContratosV4', 0, 'dd', sysdate, 0, (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='CO'));


	
-- P402_AnalisisOperacionesConcurso.
VAR_CODIGO_TAREA := 'P402_AnalisisOperacionesConcurso';
VAR_PLAZO_TAREA := 'valoresBPMPadre[P412_RegistrarPublicacionBOE]!=null && valoresBPMPadre[P412_RegistrarPublicacionBOE][fecha] != null && valoresBPMPadre[P412_RegistrarPublicacionBOE][fecha]!='''' ? damePlazo(valoresBPMPadre[P412_RegistrarPublicacionBOE][fecha]) + 20*24*60*60*1000L : 20*24*60*60*1000L';
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_SCRIPT_DECISION, TAP_SCRIPT_VALIDACION)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO),
   VAR_CODIGO_TAREA,
   NULL, -- VIEW
   0, -- SUPERVISOR
   'Análisis de las operaciones del concurso', 0, 'DD', sysdate, 0, 
   'EXTTareaProcedimiento',
   NULL,	-- DECISION
   'analisisDeGarantiasCompletado() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; acceder a la pesta&ntilde;a &quot;An&aacute;lisis de contratos&quot; del asunto correspondiente y determinar para cada operaci&oacute;n del concurso su tipo de garant&iacute;a, ya sea &quot;Garant&iacute;as adicionales o personales&quot; de tipo fiadores, librado, descuento, de tipo Prendas, Pignoraci&oacute;n, IPF, Otros o &quot;Garant&iacute;as reales&quot;. Recuerde que en la pesta&ntilde;a Adjuntos de la ficha del procedimiento correspondiente, deber&iacute;a disponer de toda la documentaci&oacute;n necesaria para el an&aacute;lisis de las operaciones, en caso de no disponer de dicha informaci&oacute;n deber&aacute; remitir una notificaci&oacute;n a su supervisor indicando dicha circunstancia.</p></div>'''
   ); 
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interese quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será , dependiendo de la información introducida:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">En caso de haber encontrado alguna garantía adicionales / personales de tipo "Prendas / pignoración / IPF / Otros" en los contratos del concurso, se lanzará la tarea "Estudiar inicio de posibles ejecuciones".</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de haber encontrado alguna garantía adicionales / personales de tipo "Fiadores / Librado / descuento" en los contratos del concurso, se lanzará la tarea "Solicitar solvencias patrimoniales".</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de haber encontrado alguna garantía hipotecaria en los contratos del concurso, se iniciará la tarea "Solicitar la no afección de los bienes".</li></ul></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo=VAR_CODIGO_TAREA);

Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),1,'date','fecha','Fecha fin de análisis','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),2,'textarea','observaciones','Observaciones',null,null,null,null,'0','DD',sysdate,null,null,null,null,'0');


-------------------------------------------------------------------------------------
--------------------------------- A ------------------------------------------------
-------------------------------------------------------------------------------------

-- P402_EstudiarInicioPosEjec.
VAR_CODIGO_TAREA := 'P402_EstudiarInicioPosEjec';
VAR_PLAZO_TAREA := 'damePlazo(valores[''P402_AnalisisOperacionesConcurso''][''fecha'']) + 5*24*60*60*1000L';
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_SCRIPT_DECISION, TAP_SCRIPT_VALIDACION)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO),
   VAR_CODIGO_TAREA,
   NULL, -- VIEW
   0, -- SUPERVISOR
   'Estudiar inicio posibles ejecuciones', 0, 'DD', sysdate, 0, 
   'EXTTareaProcedimiento',
   NULL,	-- DECISION
   'comprobarPropuestaEjecuciones() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; acceder a la pesta&ntilde;a &quot;An&aacute;lisis de contratos&quot; y estudiar las garant&iacute;as de cada uno de los contratos marcados con &quot;Garant&iacute;as adicionales o personales (Prendas, Pignoraci&oacute;n, IPF, otros)&quot;, en base a esto proponer a la entidad a trav&eacute;s de esa misma pantalla de an&aacute;lisis la conveniencia o no de iniciar una ejecuci&oacute;n de garant&iacute;a adicional para cada uno de los contratos.</p></div>'''
   ); 
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el campo Fecha deberá indicar la fecha en que da por finalizado el estudio de las operaciones con Garantías adicionales, personales o reales.</p><p style="margin-bottom: 10px">En el campo observaciones realizar un breve informe que avale la recomendación indicada en la pestaña "Análisis de contratos".</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será "Revisar propuesta letrado" que deberá ser realizar por el supervisor del concurso</p></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo=VAR_CODIGO_TAREA);

Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),1,'date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),2,'textarea','observaciones','Observaciones',null,null,null,null,'0','DD',sysdate,null,null,null,null,'0');


-- P402_RevisarPropuestaLetrado.
VAR_CODIGO_TAREA := 'P402_RevisarPropuestaLetrado';
VAR_PLAZO_TAREA := 'damePlazo(valores[''P402_EstudiarInicioPosEjec''][''fecha'']) + 5*24*60*60*1000L';
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SUPERVISOR, DD_STA_ID, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_SCRIPT_DECISION, TAP_ALERT_VUELTA_ATRAS, TAP_SCRIPT_VALIDACION)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO),
   VAR_CODIGO_TAREA,
   NULL, -- VIEW
   1, -- SUPERVISOR
   (SELECT DD_STA_ID FROM BANKMASTER.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO='40'),
   'Revisar propuesta letrado', 0, 'DD', sysdate, 0, 
   'EXTTareaProcedimiento',
   'existenGarantiasConDiscrepancia() ? ''discrepancias'' : ''ok''',	-- DECISION parecido a FComún cuentaPropuestaEjecucionSup() <> cuentaPropuestaEjecucionLetrado()
   'tareaExterna.cancelarTarea',
   'comprobarInicioEjecuciones() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; acceder a la pesta&ntilde;a &quot;An&aacute;lisis de contratos&quot; del asunto correspondiente y revisar para los contratos con garant&iacute;a de tipo &quot;Garant&iacute;as adicionales o personales (Prendas, Pignoraci&oacute;n, IPF, otros)&quot; la propuesta introducida por el letrado en la columna &quot;Propuesta ejecuci&oacute;n&quot;. Una vez revisado deber&aacute; consignar, seg&uacute;n su criterio, la columna &quot;Iniciar ejecuci&oacute;n&quot;.</p></div>''' -- VALIDACION
   ); 
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Ante cualquier discrepancia con las propuestas realizadas por el letrado y antes de su decisión definitiva, en caso de duda deberá solventar con el letrado dichas discrepancia. Las instrucciones que se marquen en la columna "Iniciar ejecución" serán definitivas, no modificables y provocarán el inicio de la preparación del expediente judicial por parte de la EDP.</p><p style="margin-bottom: 10px">En el campo Fecha deberá consignar la fecha en que da por finalizada la revisión de las propuestas del letrado.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento. Tenga en cuenta que, en caso de que se deba iniciarse alguna ejecución,  estas observaciones serán trasladadas a la empresa de preparación de expediente judicial para su conocimiento.</p><p style="margin-bottom: 10px">Una vez completada esta tarea se lanzaran tantos trámites de inicio de expediente judicial como ejecuciones haya indicado que se deben iniciar. En caso de haber discrepancia entre la propuesta dada por el letrado y la decisión tomada por la entidad, se lanzará la tarea "Comunicado decisión entidad" a realizar por el letrado.</p></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo=VAR_CODIGO_TAREA);

Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),1,'date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),2,'textarea','observaciones','Observaciones',null,null,null,null,'0','DD',sysdate,null,null,null,null,'0');


--------------------------
---- BPM TRAMITE Inicio Expediente Judicial A
--------------------------
VAR_CODIGO_TAREA := 'P402_BPMInicioEJ_A';
VAR_PLAZO_TAREA := VAR_PLAZO_BPM_DERIVADO;
VAR_CODIGO_BPM := 'P405';
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, 
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_PROCEDIMIENTO),
	VAR_CODIGO_TAREA, 0,
	'Tramite Inicio Expediente Judicial A P405',
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_BPM), 0, 'dd', sysdate, 0, 'EXTTareaProcedimiento');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval,
	(select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  
	'Se inicia el trámite Inicio Expediente Judicial A P405' , 0, 'DD', SYSDATE, 0);
   
	
-- P402_ComunicadoDecisionEntidadA
VAR_CODIGO_TAREA := 'P402_ComunicadoDecisionEntidadA';
VAR_PLAZO_TAREA := 'damePlazo(valores[''P402_RevisarPropuestaLetrado''][''fecha'']) + 1*24*60*60*1000L';
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SUPERVISOR, DD_STA_ID, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_SCRIPT_DECISION)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO),
   VAR_CODIGO_TAREA,
   NULL, -- VIEW
   0, -- SUPERVISOR
   NULL, -- STA_ID
   'Comunicado Decisión Entidad', 0, 'DD', sysdate, 0, 
   'EXTTareaProcedimiento',
   NULL -- DECISION
   ); 
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que ha habido discrepancia entre la propuesta cursada por letrado y la realizada por la entidad, a través de esta tarea se pone en conocimiento dicha circunstancia. Para consultar el resultado final del análisis de las operaciones deberá acceder a la pestaña "Análisis de operaciones" de la ficha del asunto correspondiente.</p><p style="margin-bottom: 10px">En el campo Fecha deberá consignar la fecha en que da por finalizada la lectura de las instrucciones dadas por la entidad.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta tarea se dará por concluido el análisis de los contratos de garantías reales o personales de tipo Prendas, Pignoración, IPF, otros.</p></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo=VAR_CODIGO_TAREA);

Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),1,'date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),2,'textarea','observaciones','Observaciones',null,null,null,null,'0','DD',sysdate,null,null,null,null,'0');



-------------------------------------------------------------------------------------
--------------------------------- B ------------------------------------------------
-------------------------------------------------------------------------------------


-- P402_SolSolvenciaPatrimonial.
VAR_CODIGO_TAREA := 'P402_SolSolvenciaPatrimonial';
VAR_PLAZO_TAREA := 'damePlazo(valores[''P402_AnalisisOperacionesConcurso''][''fecha'']) + 5*24*60*60*1000L';
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SUPERVISOR, DD_STA_ID, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_SCRIPT_VALIDACION, TAP_SCRIPT_DECISION)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO),
   VAR_CODIGO_TAREA,
   NULL, -- VIEW
   1, -- SUPERVISOR
   (SELECT DD_STA_ID FROM BANKMASTER.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO='40'),
   'Solicitar solvencia patrimonial', 0, 'DD', sysdate, 0, 
   'EXTTareaProcedimiento',
   'garantiasTienenSolicitudSolvencia() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea antes deber&aacute; considerar para cada uno de los bienes marcados por el letrado con garant&iacute;as de tipo &quot;Garant&iacute;as adicionales o personales (Fiadores, Librado, Descuento)&quot; en la pesta&ntilde;a &quot;An&aacute;lisis de contratos&quot; de la ficha del asunto correspondiente, si es necesario o no Solicitar solvencias, en los casos en que marque que s&iacute; es necesario deber&aacute; introducir la fecha de solicitud de la misma.</p></div>''',	-- VALIDACION
   'existeGarantiaConSolicitudSolvenciaSI() ? ''Si'' : ''No''' -- DECISION
   ); 
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el campo Fecha deberá consignar la fecha en que da por finalizada la solicitud de solvencias.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla y en caso de haber solicitado alguna solvencia,  la siguiente tarea será "Registrar resultado solvencia" que deberá ser realizada por el supervisor del concurso. En caso contrario se dará por finalizada la revisión de contratos con garantías adicionales o personales de tipo Fiadores, Librado o Descuento.</p></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo=VAR_CODIGO_TAREA);

Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),1,'date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),2,'textarea','observaciones','Observaciones',null,null,null,null,'0','DD',sysdate,null,null,null,null,'0');


-- P402_RegistrarResultadoSolvencias.
VAR_CODIGO_TAREA := 'P402_RegistrarResultadoSolvencias';
VAR_PLAZO_TAREA := 'damePlazo(valores[''P402_SolSolvenciaPatrimonial''][''fecha'']) + 30*24*60*60*1000L';
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SUPERVISOR, DD_STA_ID, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_ALERT_VUELTA_ATRAS, TAP_SCRIPT_VALIDACION, TAP_SCRIPT_DECISION)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO),
   VAR_CODIGO_TAREA,
   NULL, -- VIEW
   1, -- SUPERVISOR
   (SELECT DD_STA_ID FROM BANKMASTER.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO='40'),
   'Registrar resultado de solvencia', 0, 'DD', sysdate, 0, 
   'EXTTareaProcedimiento',
   'tareaExterna.cancelarTarea',
   'garantiasTienenResultadoSolvencia() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea antes deber&aacute; acceder a la pesta&ntilde;a &quot;An&aacute;lisis de contratos&quot; de la ficha del asunto correspondiente y registrar para cada uno de los contratos sobre los que se haya solicitado solvencia, la fecha de recepci&oacute;n de la misma, el resultado ya sea Positivo o Negativo y la decisi&oacute;n de la entidad respecto a si hay que iniciar o continuar ejecuci&oacute;n de las garant&iacute;as. Tenga en cuenta que esta tarea no la podr&aacute; dar por terminada hasta que no haya recibido el resultado de todas las solvencias solicitadas.</p></div>''', -- TAP_SCRIPT_VALIDACION
   'existeSolvenciaNegOPosNoIniciarEjecucion() ? ''negOposIniEjec'' : ''posInicEjec''' 	-- DECISION
   ); 
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el campo Fecha deberá consignar la fecha en que da por terminada la revisión de solvencias y la decisión de actuación sobre los contratos.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea, dependiendo de los valores introducidos, podrá ser:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">"Dictar instrucciones" Una tarea de este tipo por cada ejecución que se vaya a iniciar y a completar por el supervisor.</li><li style="margin-bottom: 10px; margin-left: 35px;">"Comunicado decisión entidad "Tarea a realizar por el letrado y lanzada en caso de que haya solvencias negativas que informar al letrado o solvencias positivas con decisión de no ejecutar o continuar por parte de la entidad.</li></ul></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo=VAR_CODIGO_TAREA);

Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),1,'date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),2,'textarea','observaciones','Observaciones',null,null,null,null,'0','DD',sysdate,null,null,null,null,'0');


-- P402_ComunicadoDecisionEntidadB
VAR_CODIGO_TAREA := 'P402_ComunicadoDecisionEntidadB';
VAR_PLAZO_TAREA := 'damePlazo(valores[''P402_RegistrarResultadoSolvencias''][''fecha'']) + 1*24*60*60*1000L';
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SUPERVISOR, DD_STA_ID, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_ALERT_VUELTA_ATRAS, TAP_SCRIPT_VALIDACION, TAP_SCRIPT_DECISION)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO),
   VAR_CODIGO_TAREA,
   NULL, -- VIEW
   0, -- SUPERVISOR
   NULL,
   'Comunicado Decisión Entidad', 0, 'DD', sysdate, 0, 
   'EXTTareaProcedimiento',
   NULL, -- CANCELAR
   NULL, -- TAP_SCRIPT_VALIDACION
   NULL 	-- DECISION
   ); 
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta tarea se le informa de la decisión tomada por la entidad respecto a los contratos marcados por el letrado con garantías de tipo "Garantías adicionales o personales (Fiadores, Librado, Descuento)", para su consulta deberá acceder a la pestaña "Análisis de contratos" de la ficha del asunto correspondiente. Una vez revisado consigne la fecha en que ha terminado la revisión.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta tarea se dará por concluido el análisis de los contratos de garantías reales o personales de tipo Fiadores, Librado o Descuento.</p></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo=VAR_CODIGO_TAREA);

Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),1,'date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),2,'textarea','observaciones','Observaciones',null,null,null,null,'0','DD',sysdate,null,null,null,null,'0');


-- P402_DictarInstrucciones.
VAR_CODIGO_TAREA := 'P402_DictarInstrucciones';
VAR_PLAZO_TAREA := 'damePlazo(valores[''P402_RegistrarResultadoSolvencias''][''fecha'']) + 1*24*60*60*1000L';
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SUPERVISOR, DD_STA_ID, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_SCRIPT_VALIDACION, TAP_SCRIPT_VALIDACION_JBPM, TAP_SCRIPT_DECISION)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO),
   VAR_CODIGO_TAREA,
   'plugin/procedimientos/analisisContratos/dictarInstruccionesV4', -- VIEW
   1, -- SUPERVISOR
   (SELECT DD_STA_ID FROM BANKMASTER.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO='40'),
   'Dictar instrucciones', 0, 'DD', sysdate, 0, 
   'EXTTareaProcedimiento',
   NULL, -- TAP_SCRIPT_VALIDACION
   'existenInstruccionesEnTarea() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px">Debe indicar las instrucciones para la empresa de preparaci&oacute;n del expediente</p></div>''', -- NO FUNCIONA POR EL TEMA de evaluarScript _1, _2, ...
   NULL 	-- DECISION
   ); 
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta pantalla deberá indicar a la Agencia de preparación de expediente, las instrucciones a seguir para la creación y preparación del nuevo expediente de prelitigio. Tenga en cuenta que las instrucciones que registre en el campo Instrucciones serán recibidas por la empresa de preparación de expediente.</p><p style="margin-bottom: 10px">La operación asociada al nuevo expediente será la que aparece en el campo Contrato.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta tarea se iniciar el trámite de inicio expediente judicial.</p></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo=VAR_CODIGO_TAREA);

Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),1,'date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),2,'text','contrato','Contrato','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',null,'dameContratoAsignadoATarea()',null,'0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 3, 'label', 'instrucLabel',  '<div align="justify" style="font-size: 8pt; font-family: Arial; margin: 10px 0 10px;"><p>A continuación escriba las instrucciones para la empresa de preparación del expediente:</p></div>' , 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),4,'htmleditor','instrucciones','Instrucciones','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',null,null,null,'0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),5,'textarea','observaciones','Observaciones',null,null,null,null,'0','DD',sysdate,null,null,null,null,'0');


--------------------------
---- BPM TRAMITE Inicio Expediente Judicial B
--------------------------
VAR_CODIGO_TAREA := 'P402_BPMInicioEJ_B';
VAR_PLAZO_TAREA := VAR_PLAZO_BPM_DERIVADO;
VAR_CODIGO_BPM := 'P405';
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, 
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_PROCEDIMIENTO),
	VAR_CODIGO_TAREA, 0,
	'Tramite Inicio Expediente Judicial B P405',
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_BPM), 0, 'dd', sysdate, 0, 'EXTTareaProcedimiento');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval,
	(select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  
	'Se inicia el trámite Inicio Expediente Judicial B P405' , 0, 'DD', SYSDATE, 0);
   


-------------------------------------------------------------------------------------
--------------------------------- C ------------------------------------------------
-------------------------------------------------------------------------------------


-- P420_SolicitarNoAfeccionBienes.
VAR_CODIGO_TAREA := 'P420_SolicitarNoAfeccionBienes';
VAR_PLAZO_TAREA := 'damePlazo(valores[''P402_AnalisisOperacionesConcurso''][''fecha'']) + 5*24*60*60*1000L';
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SUPERVISOR, DD_STA_ID, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_SCRIPT_DECISION, TAP_SCRIPT_VALIDACION)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO),
   VAR_CODIGO_TAREA,
   NULL, -- VIEW
   0, -- SUPERVISOR
   NULL, --(SELECT DD_STA_ID FROM BANKMASTER.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO='40'),
   'Solicitar la no afección de los bienes', 0, 'DD', sysdate, 0, 
   'EXTTareaProcedimiento',
   'existeBienConSolicitudNoAfeccionSI() ? ''Si'' : ''No''', -- DECISION
   'bienesTienenSolicitudNoAfeccion() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea antes deber&aacute; considerar para cada uno de los contratos marcados por el letrado con garant&iacute;as de tipo Hipotecaria en la pesta&ntilde;a &quot;An&aacute;lisis de contratos&quot; de la ficha del asunto correspondiente, si es necesario o no solicitar la no afecci&oacute;n para cada uno delos bienes relacionados con los contratos. En los casos que considere que s&iacute; es necesario, deber&aacute; indicar dicha circunstancia en cada bien as&iacute; como la fecha de solicitud de la misma.</p></div>''' -- VALIDACION
   ); 
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el campo fecha deberá indicar la fecha en que de por terminada la solicitud de no afección de los bienes.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla y en caso de haber solicitado alguna desafección de bienes,  la siguiente tarea será "Registrar resultado resoluciones no afección" que deberá ser realizada por el supervisor del concurso, en caso contrario será por finalizada la revisión de contratos con garantías Hipotecarias"</p></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo=VAR_CODIGO_TAREA);

Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),1,'date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),2,'textarea','observaciones','Observaciones',null,null,null,null,'0','DD',sysdate,null,null,null,null,'0');


-- P402_RegResolucionesNoAfeccion.
VAR_CODIGO_TAREA := 'P402_RegResolucionesNoAfeccion';
VAR_PLAZO_TAREA := 'damePlazo(valores[''P420_SolicitarNoAfeccionBienes''][''fecha'']) + 30*24*60*60*1000L';
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SUPERVISOR, DD_STA_ID, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_ALERT_VUELTA_ATRAS, TAP_SCRIPT_DECISION, TAP_SCRIPT_VALIDACION)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO),
   VAR_CODIGO_TAREA,
   NULL, -- VIEW
   0, -- SUPERVISOR
   NULL, --(SELECT DD_STA_ID FROM BANKMASTER.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO='40'),
   'Registrar resoluciones no afección', 0, 'DD', sysdate, 0, 
   'EXTTareaProcedimiento',
   'tareaExterna.cancelarTarea',
   'existeBienResolucionNoAfeccionFavorable() ? ''Si'' : ''No''', -- DECISION
   'bienesTienenResolucionNoAfeccion() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea antes deber&aacute; acceder a la pesta&ntilde;a &quot;An&aacute;lisis de contratos&quot; de la ficha del asunto correspondiente y registrar para cada uno de los bienes sobre los que se haya solicitado la no afecci&oacute;n tanto la fecha de resoluci&oacute;n como el resultado de dicha resoluci&oacute;n ya sea Favorable o Desfavorable para los intereses de la entidad.</p></div>''' -- VALIDACION
   ); 
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el campo Fecha deberá consignar la fecha en que se haya terminado de cargar el resultado sobre la solicitud de no afección de los bienes.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea, dependiendo de los valores introducidos, podrá ser:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">En caso de que haya uno o mas contratos con garantías hipotecarias donde alguno de los bienes ha quedado no afecto se iniciará la tarea "Decidir sobre ejecuciones"</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de no haber ningún contrato con garantía hipotecaria donde alguno de los bienes haya quedado no afecto, la actuación se quedará a la espera de que pase un año, momento en el cual el sistema lanzará una tarea automáticamente para revisar la situación del concurso.</li></ul></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo=VAR_CODIGO_TAREA);

Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),1,'date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),2,'textarea','observaciones','Observaciones',null,null,null,null,'0','DD',sysdate,null,null,null,null,'0');


-- P402_DecidirSobreEjecuciones.
VAR_CODIGO_TAREA := 'P402_DecidirSobreEjecuciones';
VAR_PLAZO_TAREA := 'damePlazo(valores[''P402_RegResolucionesNoAfeccion''][''fecha'']) + 1*24*60*60*1000L';
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SUPERVISOR, DD_STA_ID, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_ALERT_VUELTA_ATRAS, TAP_SCRIPT_DECISION, TAP_SCRIPT_VALIDACION)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO),
   VAR_CODIGO_TAREA,
   NULL, -- VIEW
   1, -- SUPERVISOR
   (SELECT DD_STA_ID FROM BANKMASTER.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO='40'),
   'Decidir sobre ejecuciones', 0, 'DD', sysdate, 0, 
   'EXTTareaProcedimiento',
   'tareaExterna.cancelarTarea',
   'existeEjecucionParalizadaConAfeccionFavorable() ? ''Si'' : ''No''', -- DECISION
   'garantiasTienenEsNecesarioEjecutar() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea antes deber&aacute; acceder a la pesta&ntilde;a &quot;An&aacute;lisis de contratos&quot; de la ficha del asunto correspondiente y registrar para cada uno de los contratos en los que se haya registrado resoluci&oacute;n favorable respecto a la no afecci&oacute;n en alguno de sus bienes relacionados, si es necesario iniciar ejecuci&oacute;n o no.</p></div>''' -- VALIDACION
   ); 
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el campo Fecha deberá consignar la fecha en que se haya terminado de decidir sobre cada uno de los contratos afectos a este punto.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento. En caso de haberse indicado el inicio de alguna ejecución, el valor introducido aquí será puesto en conocimiento de la empresa de preparación del expediente judicial.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea, dependiendo de los valores introducidos, podrá ser:</p><p style="margin-bottom: 10px"><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">Para cada uno de los contratos en los que haya decidido iniciar ejecución se iniciará el trámite de preparación de expediente judicial.</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de haber alguna ejecución paralizada para alguno de los contratos donde se haya obtenido una resolución favorable a la no afección de alguno de sus bienes, se lanzará la tarea "Comunicado decisión entidad" al letrado.</li></ul></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo=VAR_CODIGO_TAREA);

Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),1,'date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),2,'textarea','observaciones','Observaciones',null,null,null,null,'0','DD',sysdate,null,null,null,null,'0');


--------------------------
---- BPM TRAMITE Inicio Expediente Judicial C1
--------------------------
VAR_CODIGO_TAREA := 'P402_BPMInicioEJ_C1';
VAR_PLAZO_TAREA := VAR_PLAZO_BPM_DERIVADO;
VAR_CODIGO_BPM := 'P405';
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, 
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_PROCEDIMIENTO),
	VAR_CODIGO_TAREA, 0,
	'Tramite Inicio Expediente Judicial C1 P405',
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_BPM), 0, 'dd', sysdate, 0, 'EXTTareaProcedimiento');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval,
	(select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  
	'Se inicia el trámite Inicio Expediente Judicial C1 P405' , 0, 'DD', SYSDATE, 0);

	

-- P402_ComunicadoDecisionEntidadC1
VAR_CODIGO_TAREA := 'P402_ComunicadoDecisionEntidadC1';
VAR_PLAZO_TAREA := 'damePlazo(valores[''P402_DecidirSobreEjecuciones''][''fecha'']) + 1*24*60*60*1000L';
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SUPERVISOR, DD_STA_ID, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_ALERT_VUELTA_ATRAS, TAP_SCRIPT_VALIDACION, TAP_SCRIPT_DECISION)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO),
   VAR_CODIGO_TAREA,
   NULL, -- VIEW
   0, -- SUPERVISOR
   NULL,
   'Comunicado Decisión Entidad', 0, 'DD', sysdate, 0, 
   'EXTTareaProcedimiento',
   NULL, -- CANCELAR
   NULL, -- TAP_SCRIPT_VALIDACION
   NULL 	-- DECISION
   ); 
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta tarea se le informa de la decisión tomada por la entidad respecto a los contratos marcados por el letrado con garantías hipotecarias, donde alguno de los bienes a resultado no afecto y haya una ejecución paralizada. Para su consulta deberá acceder a la pestaña "Análisis de contratos" de la ficha del asunto correspondiente. Una vez revisado consigne la fecha en que ha terminado la revisión.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta tarea se dará por concluido el análisis de los contratos de garantías hipotecarias.</p></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo=VAR_CODIGO_TAREA);

Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),1,'date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),2,'textarea','observaciones','Observaciones',null,null,null,null,'0','DD',sysdate,null,null,null,null,'0');
	

--------------------------
---- P402_EsperaFDeclaracionConcurso. TAREA DE ESPERA.  
--------------------------
VAR_CODIGO_TAREA := 'P402_EsperaFDeclaracionConcurso';
VAR_PLAZO_TAREA := VAR_PLAZO_BPM_DERIVADO;
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, 
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_PROCEDIMIENTO),
	VAR_CODIGO_TAREA, 0,
	'Espera F. auto delcara. concurso - 1 año',
	NULL, 0, 'dd', sysdate, 0, 'EXTTareaProcedimiento');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval,
	(select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  
	'Espera F. auto delcara. concurso - 1 año' , 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),2,'textarea','observaciones','Observaciones',null,null,null,null,'0','DD',sysdate,null,null,null,null,'0');

	


-- P402_RevisarSituacionConcurso.
VAR_CODIGO_TAREA := 'P402_RevisarSituacionConcurso';
VAR_PLAZO_TAREA := '1*24*60*60*1000L';
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SUPERVISOR, DD_STA_ID, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_ALERT_VUELTA_ATRAS, TAP_SCRIPT_DECISION, TAP_SCRIPT_VALIDACION)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO),
   VAR_CODIGO_TAREA,
   NULL, -- VIEW
   0, -- SUPERVISOR
   NULL,
   'Revisar Situación del concurso', 0, 'DD', sysdate, 0, 
   'EXTTareaProcedimiento',
   NULL, -- Vuelta atrás
   'valores[''P402_RevisarSituacionConcurso''][''comboLiquidacion''] == DDSiNo.SI ? ''Si'' : ''No''', -- DECISION
   NULL -- VALIDACION
   ); 
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Habiendo transcurrido un año desde la fecha del auto declarando concurso, y siendo que alguno de los contratos del concurso dispone de garantías reales, a través de esta pantalla deberá indicar la situación en que se encuentra el concurso, ya sea que se ha iniciado la fase de convenio o liquidación o no se haya iniciado ninguna de dichas fases.</p><p style="margin-bottom: 10px">En el campo Fecha deberá indicar la fecha en que revisa el concurso.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">En caso de no haberse iniciado la fase convenio o de liquidación "Revisar inicio o continuación de ejecuciones hipotecarias" a realizar por el supervisor del concurso.</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso contrario se dar por finalizado el análisis de las operaciones con garantía hipotecaria.</li></ul></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo=VAR_CODIGO_TAREA);

Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),1,'date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),2,'combo','comboLiquidacion','Liquidación o convenio','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),3,'textarea','observaciones','Observaciones',null,null,null,null,'0','DD',sysdate,null,null,null,null,'0');


-- P402_RevisarIniContEjec.
VAR_CODIGO_TAREA := 'P402_RevisarIniContEjec';
VAR_PLAZO_TAREA := 'damePlazo(valores[''P402_RevisarSituacionConcurso''][''fecha'']) + 1*24*60*60*1000L';
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SUPERVISOR, DD_STA_ID, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_ALERT_VUELTA_ATRAS, TAP_SCRIPT_DECISION, TAP_SCRIPT_VALIDACION)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO),
   VAR_CODIGO_TAREA,
   NULL, -- VIEW
   1, -- SUPERVISOR
   (SELECT DD_STA_ID FROM BANKMASTER.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO='40'),
   'Revisar inicio o continuacion de ejecuciones', 0, 'DD', sysdate, 0, 
   'EXTTareaProcedimiento',
   'tareaExterna.cancelarTarea',
   'existeContratosConDecisionRevSIEjecIniciada() ? ''SIyEjecIniciada'' : (existeContratosConDecisionRevSIEjecNoIniciada() ? ''SIyNoEjecIniciada'' : ''No'')', -- DECISION
   'garantiasTienenDecisionRevision() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea antes deber&aacute; acceder a la pesta&ntilde;a &quot;An&aacute;lisis de contratos&quot; de la ficha del asunto correspondiente y registrar en el campo &quot;Decisi&oacute;n Rev.&quot; para cada uno de los contratos con garant&iacute;a hipotecaria y pendientes de revisi&oacute;n la decisi&oacute;n en cuanto a si es necesario iniciar ejecuci&oacute;n o no.</p></div>''' -- VALIDACION
   ); 
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el campo Fecha deberá consignar la fecha en que se haya terminado de decidir sobre cada uno de los contratos afectos a este punto.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento. En caso de haberse indicado el inicio de alguna ejecución, el valor introducido aquí será puesto en conocimiento de la empresa de preparación del expediente judicial.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea, dependiendo de los valores introducidos, podrá ser:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">Para cada uno de los contratos en los que haya decidido iniciar ejecución se iniciará el trámite de preparación de expediente judicial.</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de haber alguna ejecución paralizada para alguno de los contratos donde se haya obtenido una resolución favorable a la no afección de alguno de sus bienes, se lanzará la tarea "Comunicado decisión entidad" al letrado.</li></ul></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo=VAR_CODIGO_TAREA);

Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),1,'date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),2,'textarea','observaciones','Observaciones',null,null,null,null,'0','DD',sysdate,null,null,null,null,'0');


--------------------------
---- BPM TRAMITE Inicio Expediente Judicial C2
--------------------------
VAR_CODIGO_TAREA := 'P402_BPMInicioEJ_C2';
VAR_PLAZO_TAREA := VAR_PLAZO_BPM_DERIVADO;
VAR_CODIGO_BPM := 'P405';
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, 
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_PROCEDIMIENTO),
	VAR_CODIGO_TAREA, 0,
	'Tramite Inicio Expediente Judicial C2 P405',
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_BPM), 0, 'dd', sysdate, 0, 'EXTTareaProcedimiento');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval,
	(select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  
	'Se inicia el trámite Inicio Expediente Judicial C2 P405' , 0, 'DD', SYSDATE, 0);


	
-- P402_ComunicadoDecisionEntidadC2
VAR_CODIGO_TAREA := 'P402_ComunicadoDecisionEntidadC2';
VAR_PLAZO_TAREA := 'damePlazo(valores[''P402_RevisarIniContEjec''][''fecha'']) + 1*24*60*60*1000L';
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SUPERVISOR, DD_STA_ID, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_ALERT_VUELTA_ATRAS, TAP_SCRIPT_VALIDACION, TAP_SCRIPT_DECISION)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO),
   VAR_CODIGO_TAREA,
   NULL, -- VIEW
   0, -- SUPERVISOR
   NULL,
   'Comunicado Decisión Entidad', 0, 'DD', sysdate, 0, 
   'EXTTareaProcedimiento',
   NULL, -- CANCELAR
   NULL, -- TAP_SCRIPT_VALIDACION
   NULL 	-- DECISION
   ); 
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta tarea se le informa de la decisión tomada por la entidad respecto a los contratos marcados por el letrado con garantías hipotecarias y que estaban a la espera de decisión por parte de la entidad. Para su consulta deberá acceder a la pestaña "Análisis de contratos" de la ficha del asunto correspondiente. Una vez revisado consigne la fecha en que ha terminado la revisión.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta tarea se dará por concluido el análisis de los contratos de garantías hipotecarias.</p></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo=VAR_CODIGO_TAREA);

Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),1,'date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),2,'textarea','observaciones','Observaciones',null,null,null,null,'0','DD',sysdate,null,null,null,null,'0');
	
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