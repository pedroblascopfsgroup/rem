SET ECHO ON
WHENEVER SQLERROR EXIT ROLLBACK;

delete from pco_bur_envio where pco_bur_burofax_id in 
    (select pco_bur_burofax_id from PCO_BUR_BUROFAX where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA'));
delete from PCO_BUR_BUROFAX where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA');

delete from pco_bur_envio where pco_bur_burofax_id in 
    (select pco_bur_burofax_id from PCO_BUR_BUROFAX where pco_prc_id in 
    (select pco_prc_id from pco_prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA')));
delete from PCO_BUR_BUROFAX 
  where pco_prc_id in (select pco_prc_id from pco_prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA'));

delete from PCO_LIQ_LIQUIDACIONES where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA');
DELETE FROM pco_doc_solicitudes WHERE PCO_DOC_PDD_ID IN (SELECT pco_doc_pdd_id FROM PCO_DOC_DOCUMENTOS where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA'));
delete from PCO_DOC_DOCUMENTOS d where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA') ;

DELETE FROM pco_doc_solicitudes WHERE PCO_DOC_PDD_ID IN (SELECT pco_doc_pdd_id FROM PCO_DOC_DOCUMENTOS where 
  pco_prc_id in (select pco_prc_id from pco_prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA')));
delete from pco_doc_documentos d where  pco_prc_id in (select pco_prc_id from pco_prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA'));
delete from PCO_PRC_HEP_HISTOR_EST_PREP where pco_prc_id in (select pco_prc_id from pco_prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA'));
delete from pco_prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA');

delete from GAA_GESTOR_ADICIONAL_ASUNTO where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA');
delete from PRC_CEX where prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA'))
    or prc_id in (select prc_id from prc_procedimientos where prc_prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA')));
delete from PRC_PER  where prc_id in
    (select prc_id from prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA'))    
    or prc_id in (select prc_id from prc_procedimientos where prc_prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA')));

delete from tev_tarea_externa_valor where tex_id in
  (select tex_id from tex_tarea_externa where tar_id in 
    (select tar_id from tar_tareas_notificaciones where prc_id in 
      (select prc_id from prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA'))));
delete from TER_TAREA_EXTERNA_RECUPERACION  where tex_id in
  (select tex_id from tex_tarea_externa where tar_id in 
    (select tar_id from tar_tareas_notificaciones where prc_id in 
      (select prc_id from prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA'))));
delete from tex_tarea_externa where tar_id in 
    (select tar_id from tar_tareas_notificaciones where prc_id in 
      (select prc_id from prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA')));
delete from tar_tareas_notificaciones where prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA'));

delete from PRD_PROCEDIMIENTOS_DERIVADOS where dpr_id in
  (select dpr_id from DPR_DECISIONES_PROCEDIMIENTOS where prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA')));
    
delete from DPR_DECISIONES_PROCEDIMIENTOS where prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA'));

delete from HAC_HISTORICO_ACCESOS where prc_id in
    (select prc_prc_id from prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA'));

delete from HAC_HISTORICO_ACCESOS where prc_id in
    (select prc_id from prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA'));

delete from HAC_HISTORICO_ACCESOS where prc_id in
    (select prc_id from PRC_PROCEDIMIENTOS where prc_prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA')));

delete from tev_tarea_externa_valor where tex_id in
  (select tex_id from tex_tarea_externa where tar_id in 
    (select tar_id from tar_tareas_notificaciones where prc_id in 
    (select prc_id from prc_procedimientos where prc_prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA')))));
delete from TER_TAREA_EXTERNA_RECUPERACION  where tex_id in
  (select tex_id from tex_tarea_externa where tar_id in 
    (select tar_id from tar_tareas_notificaciones where prc_id in 
    (select prc_id from prc_procedimientos where prc_prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA')))));
delete from tex_tarea_externa where tar_id in 
    (select tar_id from tar_tareas_notificaciones where prc_id in 
    (select prc_id from prc_procedimientos where prc_prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA'))));
      
delete from tar_tareas_notificaciones where prc_id in 
    (select prc_id from prc_procedimientos where prc_prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA')));

DELETE FROM PRD_PROCEDIMIENTOS_DERIVADOS WHERE DPR_ID IN
  (SELECT DPR_ID FROM DPR_DECISIONES_PROCEDIMIENTOS where PRC_ID in 
    (select prc_id from PRC_PROCEDIMIENTOS where prc_prc_id in 
      (select prc_id from prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA'))));

delete from DPR_DECISIONES_PROCEDIMIENTOS where PRC_ID in 
  (select prc_id from PRC_PROCEDIMIENTOS where prc_prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA')));

DELETE FROM HAC_HISTORICO_ACCESOS WHERE PRC_ID IN 
  (SELECT PRC_ID from PRC_PROCEDIMIENTOS WHERE PRC_PRC_ID IN
    (SELECT PRC_ID from PRC_PROCEDIMIENTOS where prc_prc_id in 
      (select prc_id from prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA'))));
    
DELETE FROM PRD_PROCEDIMIENTOS_DERIVADOS WHERE 
usuariocrear IN ('A118468', 'PREDOC');
--DPR_ID IN
--  (SELECT DPR_ID FROM DPR_DECISIONES_PROCEDIMIENTOS where PRC_ID in 
--     (SELECT PRC_ID from PRC_PROCEDIMIENTOS where prc_prc_id in 
--       (select prc_id from prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA'))));

delete from DPR_DECISIONES_PROCEDIMIENTOS where 
usuariocrear IN ('A118468', 'PREDOC');
--  (SELECT DPR_ID FROM DPR_DECISIONES_PROCEDIMIENTOS where PRC_ID in 
--     (SELECT PRC_ID from PRC_PROCEDIMIENTOS where prc_prc_id in 
--       (select prc_id from prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA'))));

DELETE FROM PRC_CEX WHERE PRC_ID IN
  (SELECT PRC_ID FROM PRC_PROCEDIMIENTOS where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA') or usuariocrear IN ('A118468', 'PREDOC') or 
  PRC_PRC_ID IN 
  (SELECT PRC_ID from PRC_PROCEDIMIENTOS where prc_prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA'))));

DELETE FROM PRC_PER WHERE PRC_ID IN 
  (SELECT PRC_ID FROM PRC_PROCEDIMIENTOS where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA') or usuariocrear IN ('A118468', 'PREDOC') or 
  PRC_PRC_ID IN 
  (SELECT PRC_ID from PRC_PROCEDIMIENTOS where prc_prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA'))));

DELETE FROM SUB_SUBASTA WHERE PRC_ID IN 
  (SELECT PRC_ID FROM PRC_PROCEDIMIENTOS where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA') or usuariocrear IN ('A118468', 'PREDOC') or 
  PRC_PRC_ID IN 
  (SELECT PRC_ID from PRC_PROCEDIMIENTOS where prc_prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA'))));

DELETE FROM TER_TAREA_EXTERNA_RECUPERACION WHERE TEX_ID IN
  (SELECT TEX_ID FROM TEX_TAREA_EXTERNA WHERE TAR_ID IN 
  (SELECT TAR_ID FROM TAR_TAREAS_NOTIFICACIONES WHERE PRC_ID IN 
  (SELECT PRC_ID FROM PRC_PROCEDIMIENTOS where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA') or usuariocrear IN ('A118468', 'PREDOC') or 
  PRC_PRC_ID IN 
  (SELECT PRC_ID from PRC_PROCEDIMIENTOS where prc_prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA'))))));

DELETE FROM TEV_TAREA_EXTERNA_VALOR WHERE TEX_ID IN (SELECT TEX_ID FROM TEX_TAREA_EXTERNA WHERE TAR_ID IN 
  (SELECT TAR_ID FROM TAR_TAREAS_NOTIFICACIONES WHERE PRC_ID IN 
  (SELECT PRC_ID FROM PRC_PROCEDIMIENTOS where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA') or usuariocrear IN ('A118468', 'PREDOC') or 
  PRC_PRC_ID IN 
  (SELECT PRC_ID from PRC_PROCEDIMIENTOS where prc_prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA'))))));
    
DELETE FROM TEX_TAREA_EXTERNA WHERE TAR_ID IN 
  (SELECT TAR_ID FROM TAR_TAREAS_NOTIFICACIONES WHERE PRC_ID IN 
  (SELECT PRC_ID FROM PRC_PROCEDIMIENTOS where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA') or usuariocrear IN ('A118468', 'PREDOC') or 
  PRC_PRC_ID IN 
  (SELECT PRC_ID from PRC_PROCEDIMIENTOS where prc_prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA')))));
    
DELETE FROM TAR_TAREAS_NOTIFICACIONES WHERE PRC_ID IN 
  (SELECT PRC_ID FROM PRC_PROCEDIMIENTOS where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA') or usuariocrear IN ('A118468', 'PREDOC') or 
  PRC_PRC_ID IN 
  (SELECT PRC_ID from PRC_PROCEDIMIENTOS where prc_prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA'))));

DELETE FROM hac_historico_accesos WHERE PRC_ID IN 
  (SELECT PRC_ID FROM PRC_PROCEDIMIENTOS WHERE PRC_PRC_ID IN 
  (SELECT PRC_ID FROM PRC_PROCEDIMIENTOS WHERE usuariocrear IN ('A118468', 'PREDOC', 'CARGA_PCO')))
  OR PRC_ID IN 
  (SELECT PRC_ID FROM PRC_PROCEDIMIENTOS WHERE usuariocrear IN ('A118468', 'PREDOC', 'CARGA_PCO'));
    
DELETE FROM PRC_PROCEDIMIENTOS WHERE PRC_PRC_ID IN 
  (SELECT PRC_ID FROM PRC_PROCEDIMIENTOS WHERE usuariocrear IN ('A118468', 'PREDOC', 'CARGA_PCO', 'LET_PCO'));
  
DELETE FROM PRB_PRC_BIE WHERE PRC_ID IN 
(SELECT prc_id FROM PRC_PROCEDIMIENTOS WHERE usuariocrear IN ('A118468', 'PREDOC', 'CARGA_PCO'));

DELETE FROM PRC_PROCEDIMIENTOS WHERE usuariocrear IN ('A118468', 'PREDOC', 'CARGA_PCO');
    
DELETE FROM PRC_PROCEDIMIENTOS WHERE PRC_PRC_ID IN 
  (SELECT PRC_ID from PRC_PROCEDIMIENTOS where prc_prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA')));
    
delete from PRC_PROCEDIMIENTOS where prc_prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA'));

delete from PRC_PROCEDIMIENTOS where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA');

delete from hac_historico_accesos WHERE ASU_ID IN 
  (SELECT ASU_ID FROM ASU_ASUNTOS WHERE usuariocrear IN ('CARGA_PCO', 'AUTOMATICA'));

delete from TEA_CNT where TEA_ID in 
  (select tea_id from TEA_TERMINOS_ACUERDO where ACU_ID in 
  (select acu_id from ACU_ACUERDO_PROCEDIMIENTOS where ASU_ID in 
  (select asu_id from ASU_ASUNTOS where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA'))));

delete from BIE_TEA where TEA_ID in 
  (select tea_id from TEA_TERMINOS_ACUERDO where ACU_ID in 
  (select acu_id from ACU_ACUERDO_PROCEDIMIENTOS where ASU_ID in 
  (select asu_id from ASU_ASUNTOS where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA'))));

WHENEVER SQLERROR CONTINUE;

delete from ACU_OPERACIONES_TERMINOS where tea_id in 
  (select tea_id from TEA_TERMINOS_ACUERDO where ACU_ID in 
  (select acu_id from ACU_ACUERDO_PROCEDIMIENTOS where ASU_ID in 
  (select asu_id from ASU_ASUNTOS where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA'))));

WHENEVER SQLERROR EXIT ROLLBACK;

delete from TEA_TERMINOS_ACUERDO where ACU_ID in 
  (select acu_id from ACU_ACUERDO_PROCEDIMIENTOS where ASU_ID in 
  (select asu_id from ASU_ASUNTOS where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA')));

delete from TEA_TERMINOS_ACUERDO where ACU_ID in 
  (select acu_id from ACU_ACUERDO_PROCEDIMIENTOS where ASU_ID in 
  (select asu_id from ASU_ASUNTOS where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA')));
  
delete from ACU_ACUERDO_PROCEDIMIENTOS where ASU_ID in 
  (select asu_id from ASU_ASUNTOS where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA'));
  
delete from TAR_TAREAS_NOTIFICACIONES where ASU_ID in 
  (select asu_id from ASU_ASUNTOS where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA'));
  
delete from ASU_ASUNTOS where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA');
delete from PEX_PERSONAS_EXPEDIENTE where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA');
delete from CEX_CONTRATOS_EXPEDIENTE where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA');
delete from EXP_EXPEDIENTES where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA');
delete from CCL_CONTRATOS_CLIENTE where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA');
delete from CLI_CLIENTES where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA');

delete from gaa_gestor_adicional_asunto where asu_id in 
  (SELECT ASU_ID FROM ASU_ASUNTOS WHERE usuariocrear IN ('CARGA_PCO', 'AUTOMATICA'));

delete from GAH_GESTOR_ADICIONAL_HISTORICO where GAH_ASU_ID in 
  (SELECT ASU_ID FROM ASU_ASUNTOS WHERE usuariocrear IN ('CARGA_PCO', 'AUTOMATICA'));

delete from gaa_gestor_adicional_asunto where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA');
delete from GAH_GESTOR_ADICIONAL_HISTORICO where usuariocrear IN ('CARGA_PCO', 'AUTOMATICA');

COMMIT;
