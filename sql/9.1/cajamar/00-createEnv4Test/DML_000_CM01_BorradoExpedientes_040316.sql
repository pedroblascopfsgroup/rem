--BORRAR EXPEDIENTES---
UPDATE CM01.EXP_EXPEDIENTES SET USUARIOBORRAR = 'REC-BATCH' WHERE USUARIOBORRAR = 'PARABORRAR';

UPDATE CM01.EXP_EXPEDIENTES SET USUARIOBORRAR = 'PARABORRAR' WHERE (USUARIOCREAR = 'REC-BATCH' or USUARIOCREAR LIKE 'val.%') AND EXP_ID NOT IN (
SELECT EXP.EXP_ID
FROM CM01.EXP_EXPEDIENTES EXP
INNER JOIN CM01.ASU_ASUNTOS ASU
ON EXP.EXP_ID = ASU.EXP_ID
INNER JOIN CM01.PRC_PROCEDIMIENTOS PRC
ON ASU.ASU_ID = PRC.ASU_ID
INNER JOIN CM01.PCO_PRC_PROCEDIMIENTOS P
ON PRC.PRC_ID           = P.PRC_ID);
commit;

delete from CM01.epr_estados_procesos where exp_id in (select exp_id from CM01.exp_expedientes WHERE USUARIOBORRAR = 'PARABORRAR');
commit;
delete from CM01.PRC_CEX WHERE CEX_ID IN (SELECT CEX_ID FROM CM01.CEX_CONTRATOS_EXPEDIENTE CEX INNER JOIN CM01.EXP_EXPEDIENTES EXP ON EXP.EXP_ID = CEX.EXP_ID AND EXP.USUARIOBORRAR = 'PARABORRAR');
commit;
delete from CM01.CEX_CONTRATOS_EXPEDIENTE where exp_id in (select exp_id from CM01.exp_expedientes WHERE USUARIOBORRAR = 'PARABORRAR');
commit;
delete from CM01.PEX_PERSONAS_EXPEDIENTE where exp_id in (select exp_id from CM01.exp_expedientes WHERE USUARIOBORRAR = 'PARABORRAR');
commit;
delete from CM01.HAC_HISTORICO_ACCESOS where exp_id  in (select exp_id from CM01.exp_expedientes WHERE USUARIOBORRAR = 'PARABORRAR');
commit;
delete from CM01.tar_tareas_notificaciones where exp_id  in (select exp_id from CM01.exp_expedientes WHERE USUARIOBORRAR = 'PARABORRAR');
commit;
DELETE FROM CM01.PRC_PER WHERE PRC_ID IN (SELECT PRC_ID FROM CM01.PRC_PROCEDIMIENTOS WHERE ASU_ID IN (SELECT ASU_ID FROM CM01.ASU_ASUNTOS WHERE EXP_ID IN (SELECT EXP_ID FROM CM01.EXP_EXPEDIENTES WHERE USUARIOBORRAR = 'PARABORRAR')));
commit;
DELETE FROM CM01.HAC_HISTORICO_ACCESOS WHERE PRC_ID IN (SELECT PRC_ID FROM CM01.PRC_PROCEDIMIENTOS WHERE ASU_ID IN (SELECT ASU_ID FROM CM01.ASU_ASUNTOS WHERE EXP_ID IN (SELECT EXP_ID FROM CM01.EXP_EXPEDIENTES WHERE USUARIOBORRAR = 'PARABORRAR')));
commit;
DELETE FROM CM01.TEX_TAREA_EXTERNA WHERE TAR_ID IN (SELECT TAR_ID FROM CM01.TAR_TAREAS_NOTIFICACIONES WHERE PRC_ID IN (SELECT PRC_ID FROM CM01.PRC_PROCEDIMIENTOS WHERE ASU_ID IN (SELECT ASU_ID FROM CM01.ASU_ASUNTOS WHERE EXP_ID IN (SELECT EXP_ID FROM CM01.EXP_EXPEDIENTES WHERE USUARIOBORRAR = 'PARABORRAR'))));
commit;
DELETE FROM CM01.TAR_TAREAS_NOTIFICACIONES WHERE PRC_ID IN (SELECT PRC_ID FROM CM01.PRC_PROCEDIMIENTOS WHERE ASU_ID IN (SELECT ASU_ID FROM CM01.ASU_ASUNTOS WHERE EXP_ID IN (SELECT EXP_ID FROM CM01.EXP_EXPEDIENTES WHERE USUARIOBORRAR = 'PARABORRAR')));
commit;
DELETE FROM CM01.DPR_DECISIONES_PROCEDIMIENTOS WHERE PRC_ID IN (SELECT PRC_ID FROM CM01.PRC_PROCEDIMIENTOS WHERE ASU_ID IN (SELECT ASU_ID FROM CM01.ASU_ASUNTOS WHERE EXP_ID IN (SELECT EXP_ID FROM CM01.EXP_EXPEDIENTES WHERE USUARIOBORRAR = 'PARABORRAR')));
commit;
DELETE FROM CM01.SUB_SUBASTA WHERE PRC_ID IN (SELECT PRC_ID FROM CM01.PRC_PROCEDIMIENTOS WHERE ASU_ID IN (SELECT ASU_ID FROM CM01.ASU_ASUNTOS WHERE EXP_ID IN (SELECT EXP_ID FROM CM01.EXP_EXPEDIENTES WHERE USUARIOBORRAR = 'PARABORRAR')));
commit;
DELETE FROM CM01.PRB_PRC_BIE WHERE PRC_ID IN (SELECT PRC_ID FROM CM01.PRC_PROCEDIMIENTOS WHERE ASU_ID IN (SELECT ASU_ID FROM CM01.ASU_ASUNTOS WHERE EXP_ID IN (SELECT EXP_ID FROM CM01.EXP_EXPEDIENTES WHERE USUARIOBORRAR = 'PARABORRAR')));
COMMIT;
DELETE FROM CM01.PRC_PROCEDIMIENTOS WHERE ASU_ID IN (SELECT ASU_ID FROM CM01.ASU_ASUNTOS WHERE EXP_ID IN (SELECT EXP_ID FROM CM01.EXP_EXPEDIENTES WHERE USUARIOBORRAR = 'PARABORRAR'));
commit;
DELETE FROM CM01.HAC_HISTORICO_ACCESOS WHERE ASU_ID IN (SELECT ASU_ID FROM CM01.ASU_ASUNTOS WHERE EXP_ID IN (SELECT EXP_ID FROM CM01.EXP_EXPEDIENTES WHERE USUARIOBORRAR = 'PARABORRAR'));
commit;
DELETE FROM CM01.AFA_FICHA_ACEPTACION WHERE ASU_ID IN (SELECT ASU_ID FROM CM01.ASU_ASUNTOS WHERE EXP_ID IN (SELECT EXP_ID FROM CM01.EXP_EXPEDIENTES WHERE USUARIOBORRAR = 'PARABORRAR'));
commit;
DELETE FROM CM01.ASU_ASUNTOS ASU WHERE ASU.EXP_ID IN (SELECT EXP_ID FROM CM01.EXP_EXPEDIENTES WHERE USUARIOBORRAR = 'PARABORRAR');
commit;
DELETE FROM CM01.PEM_PROP_EXP_MANUAL WHERE EXP_ID IN (SELECT EXP_ID FROM CM01.EXP_EXPEDIENTES WHERE USUARIOBORRAR = 'PARABORRAR');
commit;
DELETE FROM CM01.TAR_TAREAS_NOTIFICACIONES WHERE OBJ_ID IN (SELECT OBJ_ID FROM CM01.OBJ_OBJETIVO WHERE POL_ID IN (SELECT POL_ID FROM CM01.CMP_CICLO_MARCADO_POLITICA WHERE EXP_ID IN (SELECT EXP_ID FROM CM01.EXP_EXPEDIENTES WHERE USUARIOBORRAR = 'PARABORRAR')));
COMMIT;
DELETE FROM CM01.OBJ_OBJETIVO WHERE POL_ID IN (SELECT POL_ID FROM CM01.CMP_CICLO_MARCADO_POLITICA WHERE EXP_ID IN (SELECT EXP_ID FROM CM01.EXP_EXPEDIENTES WHERE USUARIOBORRAR = 'PARABORRAR'));
commit;
DELETE FROM CM01.POL_POLITICA WHERE CMP_ID IN (SELECT CMP_ID FROM CM01.CMP_CICLO_MARCADO_POLITICA WHERE EXP_ID IN (SELECT EXP_ID FROM CM01.EXP_EXPEDIENTES WHERE USUARIOBORRAR = 'PARABORRAR'));
commit;
DELETE FROM CM01.APO_ANALISIS_PERSONA_OPERAC WHERE APP_ID IN (SELECT APP_ID FROM CM01.APP_ANALISIS_PERSONA_POLITICA WHERE CMP_ID IN (SELECT CMP_ID FROM CM01.CMP_CICLO_MARCADO_POLITICA WHERE EXP_ID IN (SELECT EXP_ID FROM CM01.EXP_EXPEDIENTES WHERE USUARIOBORRAR = 'PARABORRAR')));
commit;
DELETE FROM CM01.APP_TIG; 
commit;
DELETE FROM CM01.APA_ANALISIS_PARCELA_PERSONA; 
commit;
DELETE FROM CM01.APP_ANALISIS_PERSONA_POLITICA WHERE CMP_ID IN (SELECT CMP_ID FROM CM01.CMP_CICLO_MARCADO_POLITICA WHERE EXP_ID IN (SELECT EXP_ID FROM CM01.EXP_EXPEDIENTES WHERE USUARIOBORRAR = 'PARABORRAR'));
commit;
DELETE FROM CM01.CMP_CICLO_MARCADO_POLITICA WHERE EXP_ID IN (SELECT EXP_ID FROM CM01.EXP_EXPEDIENTES WHERE USUARIOBORRAR = 'PARABORRAR');
commit;
DELETE FROM CM01.TEA_CNT WHERE TEA_ID IN (SELECT TEA_ID FROM CM01.TEA_TERMINOS_ACUERDO WHERE ACU_ID IN (SELECT ACU_ID FROM CM01.ACU_ACUERDO_PROCEDIMIENTOS WHERE EXP_ID IN (SELECT EXP_ID FROM CM01.EXP_EXPEDIENTES WHERE USUARIOBORRAR = 'PARABORRAR')));
commit;
DELETE FROM CM01.BIE_TEA WHERE TEA_ID IN (SELECT TEA_ID FROM CM01.TEA_TERMINOS_ACUERDO WHERE ACU_ID IN (SELECT ACU_ID FROM CM01.ACU_ACUERDO_PROCEDIMIENTOS WHERE EXP_ID IN (SELECT EXP_ID FROM CM01.EXP_EXPEDIENTES WHERE USUARIOBORRAR = 'PARABORRAR')));
commit;
DELETE FROM CM01.ACU_OPERACIONES_TERMINOS WHERE TEA_ID IN (SELECT TEA_ID FROM CM01.TEA_TERMINOS_ACUERDO WHERE ACU_ID IN (SELECT ACU_ID FROM CM01.ACU_ACUERDO_PROCEDIMIENTOS WHERE EXP_ID IN (SELECT EXP_ID FROM CM01.EXP_EXPEDIENTES WHERE USUARIOBORRAR = 'PARABORRAR')));
commit;
DELETE FROM CM01.TEA_TERMINOS_ACUERDO WHERE ACU_ID IN (SELECT ACU_ID FROM CM01.ACU_ACUERDO_PROCEDIMIENTOS WHERE EXP_ID IN (SELECT EXP_ID FROM CM01.EXP_EXPEDIENTES WHERE USUARIOBORRAR = 'PARABORRAR'));
commit;
DELETE FROM CM01.ACU_ACUERDO_PROCEDIMIENTOS WHERE EXP_ID IN (SELECT EXP_ID FROM CM01.EXP_EXPEDIENTES WHERE USUARIOBORRAR = 'PARABORRAR');
commit;
DELETE FROM CM01.AEE_ACTUACION_EXPLORAR_EXP WHERE EXP_ID IN (SELECT EXP_ID FROM CM01.EXP_EXPEDIENTES WHERE USUARIOBORRAR = 'PARABORRAR');
commit;
DELETE FROM CM01.ARE_ACT_REALIZADAS_EXP WHERE EXP_ID IN (SELECT EXP_ID FROM CM01.EXP_EXPEDIENTES WHERE USUARIOBORRAR = 'PARABORRAR');
commit;
DELETE FROM CM01.SCX_SOL_CANCELAC_EXP WHERE EXP_ID IN (SELECT EXP_ID FROM CM01.EXP_EXPEDIENTES WHERE USUARIOBORRAR = 'PARABORRAR');
commit;
DELETE FROM CM01.CEE_PER_EXP_EXCLUIDOS WHERE SEE_ID IN (SELECT SEE_ID FROM CM01.SEE_SOL_EXCL_EXP_CLIENTE WHERE EXP_ID IN (SELECT EXP_ID FROM CM01.EXP_EXPEDIENTES WHERE USUARIOBORRAR = 'PARABORRAR'));
commit;
DELETE FROM CM01.SEE_SOL_EXCL_EXP_CLIENTE WHERE EXP_ID IN (SELECT EXP_ID FROM CM01.EXP_EXPEDIENTES WHERE USUARIOBORRAR = 'PARABORRAR');
commit;
DELETE FROM CM01.ADE_ADJUNTOS_EXPEDIENTES WHERE EXP_ID IN (SELECT EXP_ID FROM CM01.EXP_EXPEDIENTES WHERE USUARIOBORRAR = 'PARABORRAR');
commit;
delete cmmaster.jbpm_job where transitionname_ = 'GenerarNotificacion' and trunc(locktime_) = trunc(sysdate);
commit;
DELETE FROM CM01.REC_RECUPERACIONES WHERE EXP_ID IN (SELECT EXP_ID FROM CM01.EXP_EXPEDIENTES WHERE USUARIOBORRAR = 'PARABORRAR');
commit;
DELETE FROM CM01.EXP_EXPEDIENTES WHERE USUARIOBORRAR = 'PARABORRAR';
commit;

--BORRAR CLIENTES--
UPDATE CM01.CLI_CLIENTES SET USUARIOBORRAR = 'PARABORRAR' WHERE USUARIOCREAR = 'BATCH' or USUARIOCREAR LIKE 'val.%';
commit;

DELETE FROM CM01.CCL_CONTRATOS_CLIENTE WHERE CLI_ID IN (SELECT CLI_ID FROM CM01.CLI_CLIENTES WHERE USUARIOBORRAR = 'PARABORRAR');
commit;
DELETE FROM CM01.TAR_TAREAS_NOTIFICACIONES WHERE CLI_ID IN (SELECT CLI_ID FROM CM01.CLI_CLIENTES WHERE USUARIOBORRAR = 'PARABORRAR');
commit;
DELETE FROM CM01.REC_RECUPERACIONES WHERE CLI_ID IN (SELECT CLI_ID FROM CM01.CLI_CLIENTES WHERE USUARIOBORRAR = 'PARABORRAR');
commit;
DELETE FROM CM01.CLI_CLIENTES WHERE USUARIOBORRAR = 'PARABORRAR';
commit;

TRUNCATE TABLE CM01.ARR_ARQ_RECUPERACION_PERSONA;
TRUNCATE TABLE CM01.H_ARR_ARQ_RECUPERACION_PERSONA;

--delete from CM01.ARR_ARQ_RECUPERACION_PERSONA;
--commit;
--delete from CM01.H_ARR_ARQ_RECUPERACION_PERSONA;
--commit;


/*
BEGIN
 
--tu carga de datos masiva aquí...
utiles.analiza_esquema('CM01');
--utiles.analiza_esquema('CMMASTER');
 
END;*/
