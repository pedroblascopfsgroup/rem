/* Formatted on 2013/04/29 17:14 (Formatter Plus v4.8.8) */
DROP MATERIALIZED VIEW v_msv_busqueda_asuntos;

/*Nueva vista que incluye el tipo de juicio*/
CREATE MATERIALIZED VIEW v_msv_busqueda_asuntos
BUILD IMMEDIATE
REFRESH COMPLETE NEXT SYSDATE+(24*60)
WITH PRIMARY KEY
--ENABLE QUERY REWRITE
AS
(SELECT DISTINCT ROWNUM id_, asu.asu_id "ASU_ID", prc.prc_id "PRC_ID", asu.asu_nombre "ASU_NOMBRE", pla.dd_pla_descripcion "PLAZA",
juz.dd_juz_descripcion "JUZGADO" , prc.prc_cod_proc_en_juzgado "AUTO", tpo.dd_tpo_descripcion "TIPO_PRC", prc.prc_saldo_recuperacion "PRINCIPAL", tar.TAR_ID "TAR_ID"
FROM asu_asuntos asu
INNER JOIN prc_procedimientos prc ON asu.asu_id=prc.asu_id
LEFT JOIN dd_juz_juzgados_plaza juz ON prc.dd_juz_id=juz.dd_juz_id
LEFT JOIN dd_pla_plazas pla ON pla.dd_pla_id = juz.dd_pla_id
INNER JOIN dd_tj_tipo_juicio tj ON prc.dd_tpo_id = tj.dd_tpo_id
INNER JOIN dd_tpo_tipo_procedimiento tpo ON prc.dd_tpo_id = tpo.dd_tpo_id
INNER JOIN tar_tareas_notificaciones tar ON prc.prc_id = tar.prc_id
WHERE asu.borrado=0
AND asu.dd_eas_id = (SELECT dd_epr_id FROM linmaster.dd_epr_estado_procedimiento WHERE dd_epr_codigo = '03')
AND prc.borrado=0
AND prc.dd_epr_id NOT IN ((SELECT dd_epr_id FROM linmaster.dd_epr_estado_procedimiento WHERE dd_epr_codigo = '04'),(SELECT dd_epr_id FROM linmaster.dd_epr_estado_procedimiento WHERE dd_epr_codigo = '05'))
AND (juz.borrado=0 OR juz.borrado IS NULL)
AND (pla.borrado=0 OR PLA.BORRADO IS NULL)
AND (tar.tar_tarea_finalizada = 0 OR tar.tar_tarea_finalizada IS NULL));


--DROP MATERIALIZED VIEW V_MSV_BUSQUEDA_ASUNTOS;
--
--/*Nueva vista que incluye el tipo de juicio*/
--CREATE MATERIALIZED VIEW V_MSV_BUSQUEDA_ASUNTOS
--BUILD IMMEDIATE
--REFRESH COMPLETE NEXT SYSDATE+(24*60)
--WITH PRIMARY KEY
----ENABLE QUERY REWRITE
--AS
--(SELECT ASU.ASU_ID "ASU_ID", MAX(PRC.PRC_ID) "ID_PROC", PRC2.PRC_SALDO_ORIGINAL_VENCIDO "PRINCIPAL", ASU.ASU_NOMBRE "ASU_NOMBRE", PLA.DD_PLA_DESCRIPCION "PLAZA", 
--JUZ.DD_JUZ_DESCRIPCION "JUZGADO" , PRC.PRC_COD_PROC_EN_JUZGADO "AUTO"
--FROM ASU_ASUNTOS ASU
--inner join PRC_PROCEDIMIENTOS PRC ON ASU.ASU_ID=PRC.ASU_ID
--inner join DD_JUZ_JUZGADOS_PLAZA JUZ ON PRC.DD_JUZ_ID=JUZ.DD_JUZ_ID 
--inner join DD_PLA_PLAZAS PLA ON PLA.DD_PLA_ID = JUZ.DD_PLA_ID
--INNER JOIN DD_TJ_TIPO_JUICIO TJ ON PRC.DD_TPO_ID = TJ.DD_TPO_ID
--INNER JOIN PRC_PROCEDIMIENTOS PRC2 ON PRC.PRC_ID = PRC2.PRC_ID
--WHERE ASU.BORRADO=0 
--AND ASU.DD_EAS_ID = (SELECT DD_EPR_ID FROM LINMASTER.DD_EPR_ESTADO_PROCEDIMIENTO WHERE DD_EPR_CODIGO = '03')
--AND PRC.BORRADO=0 
--AND (PRC.DD_EPR_ID = (SELECT DD_EPR_ID FROM LINMASTER.DD_EPR_ESTADO_PROCEDIMIENTO WHERE DD_EPR_CODIGO = '03') 
--OR PRC.DD_EPR_ID = (SELECT DD_EPR_ID FROM LINMASTER.DD_EPR_ESTADO_PROCEDIMIENTO WHERE DD_EPR_CODIGO = '06'))
--AND JUZ.BORRADO=0
--AND PLA.BORRADO=0
--GROUP BY ASU.ASU_ID, ASU.ASU_NOMBRE, PLA.DD_PLA_DESCRIPCION, 
--JUZ.DD_JUZ_DESCRIPCION, PRC.PRC_COD_PROC_EN_JUZGADO,
--PRC2.PRC_SALDO_ORIGINAL_VENCIDO);