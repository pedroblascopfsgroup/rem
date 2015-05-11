/* Se borra la tabla en DML_02_entity_GESTOR
 * 
 delete from gae_gestor_add_expediente gae where gae.gee_id in (select gee.gee_id from gee_gestor_entidad gee inner join
bankmaster.dd_tge_tipo_gestor tge on tge.dd_tge_id = gee.dd_tge_id
where TGE.DD_TGE_CODIGO = 'SAGER');

delete from gee_gestor_entidad gee 
where gee.dd_tge_id in (select tge.dd_tge_id from bankmaster.dd_tge_tipo_gestor tge 
	where TGE.DD_TGE_CODIGO = 'SAGER' or TGE.DD_TGE_CODIGO = 'GAGER');
*/
DELETE FROM bankmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GAGER';

DELETE FROM bankmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SAGER';