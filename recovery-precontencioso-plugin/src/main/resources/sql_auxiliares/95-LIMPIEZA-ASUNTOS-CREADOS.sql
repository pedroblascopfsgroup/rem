SET ECHO ON
WHENEVER SQLERROR EXIT ROLLBACK;

delete from pco_bur_envio where pco_bur_burofax_id in 
    (select pco_bur_burofax_id from PCO_BUR_BUROFAX where usuariocrear='CARGA_PCO');
delete from PCO_BUR_BUROFAX where usuariocrear='CARGA_PCO';

delete from pco_bur_envio where pco_bur_burofax_id in 
    (select pco_bur_burofax_id from PCO_BUR_BUROFAX where pco_prc_id in 
    (select pco_prc_id from pco_prc_procedimientos where usuariocrear='CARGA_PCO'));
delete from PCO_BUR_BUROFAX 
  where pco_prc_id in (select pco_prc_id from pco_prc_procedimientos where usuariocrear='CARGA_PCO');

delete from PCO_LIQ_LIQUIDACIONES where usuariocrear='CARGA_PCO';
DELETE FROM pco_doc_solicitudes WHERE PCO_DOC_PDD_ID IN (SELECT pco_doc_pdd_id FROM PCO_DOC_DOCUMENTOS where usuariocrear='CARGA_PCO');
delete from PCO_DOC_DOCUMENTOS d where usuariocrear='CARGA_PCO' ;

DELETE FROM pco_doc_solicitudes WHERE PCO_DOC_PDD_ID IN (SELECT pco_doc_pdd_id FROM PCO_DOC_DOCUMENTOS where 
  pco_prc_id in (select pco_prc_id from pco_prc_procedimientos where usuariocrear='CARGA_PCO'));
delete from pco_doc_documentos d where  pco_prc_id in (select pco_prc_id from pco_prc_procedimientos where usuariocrear='CARGA_PCO');
delete from PCO_PRC_HEP_HISTOR_EST_PREP where pco_prc_id in (select pco_prc_id from pco_prc_procedimientos where usuariocrear='CARGA_PCO');
delete from pco_prc_procedimientos where usuariocrear='CARGA_PCO';

delete from GAA_GESTOR_ADICIONAL_ASUNTO where usuariocrear='CARGA_PCO';
delete from PRC_CEX where prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear='CARGA_PCO')
    or prc_id in (select prc_id from prc_procedimientos where prc_prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear='CARGA_PCO'));
delete from PRC_PER  where prc_id in
    (select prc_id from prc_procedimientos where usuariocrear='CARGA_PCO')    
    or prc_id in (select prc_id from prc_procedimientos where prc_prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear='CARGA_PCO'));

delete from tev_tarea_externa_valor where tex_id in
  (select tex_id from tex_tarea_externa where tar_id in 
    (select tar_id from tar_tareas_notificaciones where prc_id in 
      (select prc_id from prc_procedimientos where usuariocrear='CARGA_PCO')));
delete from TER_TAREA_EXTERNA_RECUPERACION  where tex_id in
  (select tex_id from tex_tarea_externa where tar_id in 
    (select tar_id from tar_tareas_notificaciones where prc_id in 
      (select prc_id from prc_procedimientos where usuariocrear='CARGA_PCO')));
delete from tex_tarea_externa where tar_id in 
    (select tar_id from tar_tareas_notificaciones where prc_id in 
      (select prc_id from prc_procedimientos where usuariocrear='CARGA_PCO'));
delete from tar_tareas_notificaciones where prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear='CARGA_PCO');

delete from PRD_PROCEDIMIENTOS_DERIVADOS where dpr_id in
  (select dpr_id from DPR_DECISIONES_PROCEDIMIENTOS where prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear='CARGA_PCO'));
    
delete from DPR_DECISIONES_PROCEDIMIENTOS where prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear='CARGA_PCO');

delete from HAC_HISTORICO_ACCESOS where prc_id in
    (select prc_prc_id from prc_procedimientos where usuariocrear='CARGA_PCO');

delete from HAC_HISTORICO_ACCESOS where prc_id in
    (select prc_id from prc_procedimientos where usuariocrear='CARGA_PCO');

delete from HAC_HISTORICO_ACCESOS where prc_id in
    (select prc_id from PRC_PROCEDIMIENTOS where prc_prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear='CARGA_PCO'));

delete from tev_tarea_externa_valor where tex_id in
  (select tex_id from tex_tarea_externa where tar_id in 
    (select tar_id from tar_tareas_notificaciones where prc_id in 
    (select prc_id from prc_procedimientos where prc_prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear='CARGA_PCO'))));
delete from TER_TAREA_EXTERNA_RECUPERACION  where tex_id in
  (select tex_id from tex_tarea_externa where tar_id in 
    (select tar_id from tar_tareas_notificaciones where prc_id in 
    (select prc_id from prc_procedimientos where prc_prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear='CARGA_PCO'))));
delete from tex_tarea_externa where tar_id in 
    (select tar_id from tar_tareas_notificaciones where prc_id in 
    (select prc_id from prc_procedimientos where prc_prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear='CARGA_PCO')));
      
delete from tar_tareas_notificaciones where prc_id in 
    (select prc_id from prc_procedimientos where prc_prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear='CARGA_PCO'));

DELETE FROM PRD_PROCEDIMIENTOS_DERIVADOS WHERE DPR_ID IN
  (SELECT DPR_ID FROM DPR_DECISIONES_PROCEDIMIENTOS where PRC_ID in 
    (select prc_id from PRC_PROCEDIMIENTOS where prc_prc_id in 
      (select prc_id from prc_procedimientos where usuariocrear='CARGA_PCO')));

delete from DPR_DECISIONES_PROCEDIMIENTOS where PRC_ID in 
  (select prc_id from PRC_PROCEDIMIENTOS where prc_prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear='CARGA_PCO'));

DELETE FROM HAC_HISTORICO_ACCESOS WHERE PRC_ID IN 
  (SELECT PRC_ID from PRC_PROCEDIMIENTOS WHERE PRC_PRC_ID IN
    (SELECT PRC_ID from PRC_PROCEDIMIENTOS where prc_prc_id in 
      (select prc_id from prc_procedimientos where usuariocrear='CARGA_PCO')));
    
DELETE FROM PRD_PROCEDIMIENTOS_DERIVADOS WHERE 
usuariocrear IN ('A118468', 'PREDOC');
--DPR_ID IN
--  (SELECT DPR_ID FROM DPR_DECISIONES_PROCEDIMIENTOS where PRC_ID in 
--     (SELECT PRC_ID from PRC_PROCEDIMIENTOS where prc_prc_id in 
--       (select prc_id from prc_procedimientos where usuariocrear='CARGA_PCO')));

delete from DPR_DECISIONES_PROCEDIMIENTOS where 
usuariocrear IN ('A118468', 'PREDOC');
--  (SELECT DPR_ID FROM DPR_DECISIONES_PROCEDIMIENTOS where PRC_ID in 
--     (SELECT PRC_ID from PRC_PROCEDIMIENTOS where prc_prc_id in 
--       (select prc_id from prc_procedimientos where usuariocrear='CARGA_PCO')));

DELETE FROM PRC_CEX WHERE PRC_ID IN
  (SELECT PRC_ID FROM PRC_PROCEDIMIENTOS where usuariocrear='CARGA_PCO' or usuariocrear IN ('A118468', 'PREDOC') or 
  PRC_PRC_ID IN 
  (SELECT PRC_ID from PRC_PROCEDIMIENTOS where prc_prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear='CARGA_PCO')));

DELETE FROM PRC_PER WHERE PRC_ID IN 
  (SELECT PRC_ID FROM PRC_PROCEDIMIENTOS where usuariocrear='CARGA_PCO' or usuariocrear IN ('A118468', 'PREDOC') or 
  PRC_PRC_ID IN 
  (SELECT PRC_ID from PRC_PROCEDIMIENTOS where prc_prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear='CARGA_PCO')));

DELETE FROM SUB_SUBASTA WHERE PRC_ID IN 
  (SELECT PRC_ID FROM PRC_PROCEDIMIENTOS where usuariocrear='CARGA_PCO' or usuariocrear IN ('A118468', 'PREDOC') or 
  PRC_PRC_ID IN 
  (SELECT PRC_ID from PRC_PROCEDIMIENTOS where prc_prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear='CARGA_PCO')));

DELETE FROM TER_TAREA_EXTERNA_RECUPERACION WHERE TEX_ID IN
  (SELECT TEX_ID FROM TEX_TAREA_EXTERNA WHERE TAR_ID IN 
  (SELECT TAR_ID FROM TAR_TAREAS_NOTIFICACIONES WHERE PRC_ID IN 
  (SELECT PRC_ID FROM PRC_PROCEDIMIENTOS where usuariocrear='CARGA_PCO' or usuariocrear IN ('A118468', 'PREDOC') or 
  PRC_PRC_ID IN 
  (SELECT PRC_ID from PRC_PROCEDIMIENTOS where prc_prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear='CARGA_PCO')))));

DELETE FROM TEV_TAREA_EXTERNA_VALOR WHERE TEX_ID IN (SELECT TEX_ID FROM TEX_TAREA_EXTERNA WHERE TAR_ID IN 
  (SELECT TAR_ID FROM TAR_TAREAS_NOTIFICACIONES WHERE PRC_ID IN 
  (SELECT PRC_ID FROM PRC_PROCEDIMIENTOS where usuariocrear='CARGA_PCO' or usuariocrear IN ('A118468', 'PREDOC') or 
  PRC_PRC_ID IN 
  (SELECT PRC_ID from PRC_PROCEDIMIENTOS where prc_prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear='CARGA_PCO')))));
    
DELETE FROM TEX_TAREA_EXTERNA WHERE TAR_ID IN 
  (SELECT TAR_ID FROM TAR_TAREAS_NOTIFICACIONES WHERE PRC_ID IN 
  (SELECT PRC_ID FROM PRC_PROCEDIMIENTOS where usuariocrear='CARGA_PCO' or usuariocrear IN ('A118468', 'PREDOC') or 
  PRC_PRC_ID IN 
  (SELECT PRC_ID from PRC_PROCEDIMIENTOS where prc_prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear='CARGA_PCO'))));
    
DELETE FROM TAR_TAREAS_NOTIFICACIONES WHERE PRC_ID IN 
  (SELECT PRC_ID FROM PRC_PROCEDIMIENTOS where usuariocrear='CARGA_PCO' or usuariocrear IN ('A118468', 'PREDOC') or 
  PRC_PRC_ID IN 
  (SELECT PRC_ID from PRC_PROCEDIMIENTOS where prc_prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear='CARGA_PCO')));

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
    (select prc_id from prc_procedimientos where usuariocrear='CARGA_PCO'));
    
delete from PRC_PROCEDIMIENTOS where prc_prc_id in 
    (select prc_id from prc_procedimientos where usuariocrear='CARGA_PCO');

delete from PRC_PROCEDIMIENTOS where usuariocrear='CARGA_PCO';

delete from hac_historico_accesos WHERE ASU_ID IN 
  (SELECT ASU_ID FROM ASU_ASUNTOS WHERE usuariocrear='CARGA_PCO');

delete from TEA_CNT where TEA_ID in 
  (select tea_id from TEA_TERMINOS_ACUERDO where ACU_ID in 
  (select acu_id from ACU_ACUERDO_PROCEDIMIENTOS where ASU_ID in 
  (select asu_id from ASU_ASUNTOS where usuariocrear='CARGA_PCO')));

delete from BIE_TEA where TEA_ID in 
  (select tea_id from TEA_TERMINOS_ACUERDO where ACU_ID in 
  (select acu_id from ACU_ACUERDO_PROCEDIMIENTOS where ASU_ID in 
  (select asu_id from ASU_ASUNTOS where usuariocrear='CARGA_PCO')));

WHENEVER SQLERROR CONTINUE;

delete from ACU_OPERACIONES_TERMINOS where tea_id in 
  (select tea_id from TEA_TERMINOS_ACUERDO where ACU_ID in 
  (select acu_id from ACU_ACUERDO_PROCEDIMIENTOS where ASU_ID in 
  (select asu_id from ASU_ASUNTOS where usuariocrear='CARGA_PCO')));

WHENEVER SQLERROR EXIT ROLLBACK;

delete from TEA_TERMINOS_ACUERDO where ACU_ID in 
  (select acu_id from ACU_ACUERDO_PROCEDIMIENTOS where ASU_ID in 
  (select asu_id from ASU_ASUNTOS where usuariocrear='CARGA_PCO'));

delete from TEA_TERMINOS_ACUERDO where ACU_ID in 
  (select acu_id from ACU_ACUERDO_PROCEDIMIENTOS where ASU_ID in 
  (select asu_id from ASU_ASUNTOS where usuariocrear='CARGA_PCO'));
  
delete from ACU_ACUERDO_PROCEDIMIENTOS where ASU_ID in 
  (select asu_id from ASU_ASUNTOS where usuariocrear='CARGA_PCO');
  
delete from TAR_TAREAS_NOTIFICACIONES where ASU_ID in 
  (select asu_id from ASU_ASUNTOS where usuariocrear='CARGA_PCO');
  
delete from ASU_ASUNTOS where usuariocrear='CARGA_PCO';
delete from PEX_PERSONAS_EXPEDIENTE where usuariocrear='CARGA_PCO';
delete from CEX_CONTRATOS_EXPEDIENTE where usuariocrear='CARGA_PCO';
delete from EXP_EXPEDIENTES where usuariocrear='CARGA_PCO';
delete from CCL_CONTRATOS_CLIENTE where usuariocrear='CARGA_PCO';
delete from CLI_CLIENTES where usuariocrear='CARGA_PCO';

delete from gaa_gestor_adicional_asunto where asu_id in 
  (SELECT ASU_ID FROM ASU_ASUNTOS WHERE usuariocrear='CARGA_PCO');

delete from GAH_GESTOR_ADICIONAL_HISTORICO where GAH_ASU_ID in 
  (SELECT ASU_ID FROM ASU_ASUNTOS WHERE usuariocrear='CARGA_PCO');

delete from gaa_gestor_adicional_asunto where usuariocrear='CARGA_PCO';
delete from GAH_GESTOR_ADICIONAL_HISTORICO where usuariocrear='CARGA_PCO';

COMMIT;
