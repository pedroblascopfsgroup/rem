WHENEVER SQLERROR EXIT ROLLBACK;
SET ECHO ON

--INSERTA REGISTRO PCO_PRECONTENCIOSO CON VALORES INICIALES, E HISTÓRICO EN ESTADO INICIAL

INSERT INTO PCO_PRC_PROCEDIMIENTOS
	(PCO_PRC_ID, PRC_ID, PCO_PRC_TIPO_PRC_PROP, PCO_PRC_TIPO_PRC_INICIADO, PCO_PRC_PRETURNADO, 
		PCO_PRC_NUM_EXP_EXT, PCO_PRC_NOM_EXP_JUD, PCO_PRC_CNT_PRINCIPAL, PCO_PRC_NUM_EXP_INT, DD_PCO_PTP_ID, 
		USUARIOCREAR, FECHACREAR)
SELECT S_PCO_PRC_PROCEDIMIENTOS.NEXTVAL, PRC.PRC_ID, (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = 'P420'), null, 1, 
		lin.n_caso, prc.prc_cod_proc_en_juzgado, null, null, TPR.DD_PCO_PTP_ID,
		'CARGA_PCO', SYSDATE
	FROM PRC_PROCEDIMIENTOS prc 
  inner join asu_asuntos asu on asu.asu_id=prc.asu_id
  inner join lin_asuntos_para_crear lin on lin.asu_id=asu.asu_id
  inner join bankmaster.dd_tas_tipos_asunto tas on tas.dd_tas_id=asu.dd_tas_id
  LEFT JOIN DD_PCO_PRC_TIPO_PREPARACION TPR ON TPR.DD_PCO_PTP_CODIGO='SE'
  inner join dd_tpo_tipo_procedimiento tpo on prc.dd_tpo_id= tpo.dd_tpo_id
  where tas.dd_tas_codigo='01'
  and prc.prc_id not in (select pco.prc_id from pco_prc_procedimientos pco)
  and tpo.dd_tpo_codigo='PCO';
  
INSERT INTO PCO_PRC_HEP_HISTOR_EST_PREP
	(PCO_PRC_HEP_ID, PCO_PRC_ID, DD_PCO_PEP_ID, PCO_PRC_HEP_FECHA_INCIO, USUARIOCREAR, FECHACREAR)
SELECT S_PCO_PRC_HEP_HIST_EST_PREP.NEXTVAL, PCO.PCO_PRC_ID, PEP.DD_PCO_PEP_ID, SYSDATE,
		'CARGA_PCO', SYSDATE
	FROM PRC_PROCEDIMIENTOS prc 
  inner join pco_prc_procedimientos pco on pco.prc_id=prc.prc_id
  inner join asu_asuntos asu on asu.asu_id=prc.asu_id
  inner join bankmaster.dd_tas_tipos_asunto tas on tas.dd_tas_id=asu.dd_tas_id
  INNER JOIN DD_PCO_PRC_ESTADO_PREPARACION PEP ON PEP.DD_PCO_PEP_CODIGO = 'PT'
  where tas.dd_tas_codigo='01' and 
    NOT EXISTS (SELECT 1 FROM PCO_PRC_HEP_HISTOR_EST_PREP HIST WHERE HIST.pco_prc_id= pco.pco_prc_id);
    
commit;
