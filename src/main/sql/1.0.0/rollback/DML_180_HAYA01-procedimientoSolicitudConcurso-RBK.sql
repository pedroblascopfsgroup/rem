/*
* SCRIPT PARA BORRADO DE DATOS BPM: Trámite de Homologación de Acuerdo
* BPM: H021 tramiteHomologacionAcuerdo
* FECHA: 20141031
* PARTES: 1/1
*/

SET DEFINE OFF;

/*
select * from TFI_TAREAS_FORM_ITEMS where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO like 'H021_%');
select * from DD_PTP_PLAZOS_TAREAS_PLAZAS WHERE tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO like 'H021_%');
select * from TAP_TAREA_PROCEDIMIENTO WHERE tap_codigo IN (select TAP_CODIGO from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO like 'H021_%');
select * from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'H021';
*/


--BORRADO DEL PROCEDIMIENTO H021
--ROLLBACK dd_tpo_tipo_procedimiento

delete from tfi_TareaS_form_items where tap_id IN (select tap_id from tap_tarea_procedimiento where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'H021'));

delete from dd_ptp_plazos_tareas_plazas where tap_id IN (select tap_id from tap_tarea_procedimiento where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'H021'));

delete from ter_Tarea_externa_recuperacion ter where ter.TEX_ID in (select tex_id from TEX_TAREA_EXTERNA where tap_id IN (select tap_id from tap_tarea_procedimiento where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'H021'))); 

DELETE FROM TEV_TAREA_EXTERNA_VALOR WHERE TEX_ID IN (SELECT TEX_ID FROM TEX_TAREA_EXTERNA where tap_id IN (select tap_id from tap_tarea_procedimiento where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'H021')));

DELETE FROM TEX_TAREA_EXTERNA where tap_id IN (select tap_id from tap_tarea_procedimiento where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'H021'));

DELETE from tap_tarea_procedimiento where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'H021');

delete from tar_tareas_notificaciones where prc_id in (select prc_id from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'H021'));

delete from prc_cex where prc_id in (select prc_id from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'H021'));

delete from hac_historico_accesos where prc_id in (select prc_id from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'H021'));

delete from prc_per where prc_id in (select prc_id from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'H021'));

delete from prd_procedimientos_derivados where prc_id in (select prc_id from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'H021'));

DELETE FROM LOB_LOTE_BIEN WHERE LOS_ID IN (SELECT LOS_ID FROM LOS_LOTE_SUBASTA WHERE SUB_ID IN (SELECT SUB_ID FROM SUB_SUBASTA WHERE PRC_ID IN (SELECT PRC_ID  from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'H021'))));

DELETE FROM LOS_LOTE_SUBASTA WHERE SUB_ID IN (SELECT SUB_ID FROM SUB_SUBASTA WHERE PRC_ID IN (SELECT PRC_ID  from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'H021')));

DELETE FROM SUB_SUBASTA WHERE PRC_ID IN (SELECT PRC_ID  from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'H021'));

delete from PRD_PROCEDIMIENTOS_DERIVADOS dpr WHERE PRC_ID IN (SELECT PRC_ID  from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'H021'));

delete from dpr_decisiones_procedimientos dpr WHERE PRC_ID IN (SELECT PRC_ID  from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'H021')); 

DELETE FROM PRB_PRC_BIE WHERE PRC_ID IN (SELECT PRC_ID  from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'H021'));

DELETE FROM TEV_TAREA_EXTERNA_VALOR TEV  WHERE TEX_ID IN (SELECT TEX_ID FROM TEX_TAREA_EXTERNA TEX WHERE TAR_ID IN (SELECT TAR_ID  FROM TAR_TAREAS_NOTIFICACIONES TAR WHERE PRC_ID IN (select prc_id from prc_procedimientos where prc_prc_id in (
	select prc_id from prc_procedimientos where dd_tpo_id =  (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'H021')
))));

DELETE FROM TER_tAREA_EXTERNA_RECUPERACION TER WHERE TEX_ID IN (SELECT TEX_ID FROM TEX_TAREA_EXTERNA TEX WHERE TAR_ID IN (SELECT TAR_ID  FROM TAR_TAREAS_NOTIFICACIONES TAR WHERE PRC_ID IN (select prc_id from prc_procedimientos where prc_prc_id in (
	select prc_id from prc_procedimientos where dd_tpo_id =  (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'H021')
))));

DELETE FROM TEX_TAREA_EXTERNA TEX WHERE TAR_ID IN (SELECT TAR_ID  FROM TAR_TAREAS_NOTIFICACIONES TAR WHERE PRC_ID IN (select prc_id from prc_procedimientos where prc_prc_id in (
	select prc_id from prc_procedimientos where dd_tpo_id =  (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'H021')
)));

DELETE FROM TAR_TAREAS_NOTIFICACIONES TAR WHERE PRC_ID IN (select prc_id from prc_procedimientos where prc_prc_id in (
	select prc_id from prc_procedimientos where dd_tpo_id =  (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'H021')
));

delete from prc_cex where prc_id in (select prc_id from prc_procedimientos where prc_prc_id in (
	select prc_id from prc_procedimientos where dd_tpo_id =  (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'H021')
));

delete from hac_historico_accesos where prc_id in (select prc_id from prc_procedimientos where prc_prc_id in (
	select prc_id from prc_procedimientos where dd_tpo_id =  (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'H021')
));

delete from prc_per where prc_id in (select prc_id from prc_procedimientos where prc_prc_id in (
	select prc_id from prc_procedimientos where dd_tpo_id =  (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'H021')
));

 delete from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'H021');

delete from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'H021';



