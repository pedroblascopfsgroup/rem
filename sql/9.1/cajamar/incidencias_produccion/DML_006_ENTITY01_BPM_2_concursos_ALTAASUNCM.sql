--/*
--##########################################
--## AUTOR=Lorenzo Lerate 
--## FECHA_CREACION=20160505
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-3043
--## PRODUCTO=NO
--## Finalidad: Arreglar BMP de Litigios tratados mal en  APR_ALTA_ASUNTOS_CM 
--##           
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL         VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA      VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M    VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL          VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_COLUMN   NUMBER(16); -- Vble. para validar la existencia de una columna. 
    V_NUM_TABLAS   NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_VIEW     NUMBER(16); -- Vble. para validar la existencia de una vista.
    ERR_NUM        NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG        VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1        VARCHAR2(2400 CHAR); -- Vble. auxiliar

BEGIN


DBMS_OUTPUT.put_line('[INFO] STEP: 1');

EXECUTE IMMEDIATE('delete from CM01.tmp_ugaspfs_bpm_input_con1');


DBMS_OUTPUT.put_line('[INFO] STEP: 2');

EXECUTE IMMEDIATE('INSERT INTO CM01.TMP_UGASPFS_BPM_INPUT_CON1(PRC_ID,TAP_ID) select distinct PRC.prc_id,
(select tap_id from CM01.tap_tarea_procedimiento where tap_codigo = ''PCO_RevisarExpedientePreparar'') tap_id 
from CM01.PRC_PROCEDIMIENTOS PRC
INNER JOIN CM01.ASU_ASUNTOS ASU ON (ASU.ASU_ID = PRC.ASU_ID AND ASU.DD_TAS_ID = 2)
WHERE (PRC.PRC_PROCESS_BPM IS NULL AND PRC.USUARIOCREAR = ''ALTAASUNCM'')
');


DBMS_OUTPUT.put_line('[INFO] STEP: 3');

EXECUTE IMMEDIATE('update CM01.TMP_UGASPFS_BPM_INPUT_CON1 set t_referencia = prc_id');


DBMS_OUTPUT.put_line('[INFO] STEP: 4');


DBMS_OUTPUT.put_line('[INFO] STEP: 5');

DBMS_OUTPUT.put_line('[INFO] STEP: 6');

EXECUTE IMMEDIATE('INSERT INTO CMMASTER.jbpm_processinstance(id_ , version_ , start_ , end_ , issuspended_ , processdefinition_ ,t_referencia)
SELECT CMMASTER.hibernate_sequence.NEXTVAL id_, 1 version_, SYSDATE start_,
          NULL end_, 0 issuspended_, maxpd.id_ processdefinition_,
          tmp.t_referencia
     FROM CM01.tmp_ugaspfs_bpm_input_con1 tmp
          JOIN CM01.tap_tarea_procedimiento tap ON tmp.tap_id = tap.tap_id
          JOIN CM01.dd_tpo_tipo_procedimiento tpo ON tap.dd_tpo_id = tpo.dd_tpo_id
          JOIN CM01.tar_tareas_notificaciones tar
          ON tmp.t_referencia = tar.t_referencia
          JOIN
          (SELECT   name_, MAX (id_) id_
               FROM CMMASTER.jbpm_processdefinition
           GROUP BY name_) maxpd ON tpo.dd_tpo_xml_jbpm = maxpd.name_');

DBMS_OUTPUT.put_line('[INFO] STEP: 7');

EXECUTE IMMEDIATE('MERGE INTO CM01.prc_procedimientos t1 USING (SELECT prc.prc_id, prc.prc_process_bpm viejo, pi.id_ nuevo
FROM CM01.prc_procedimientos prc
JOIN CM01.tmp_ugaspfs_bpm_input_con1 tmp ON prc.prc_id = tmp.prc_id
JOIN CMMASTER.jbpm_processinstance pi ON tmp.t_referencia = pi.t_referencia ) q
ON (t1.prc_id = q.prc_id)
WHEN MATCHED THEN
UPDATE SET t1.prc_process_bpm = q.nuevo');


DBMS_OUTPUT.put_line('[INFO] STEP: 8');

EXECUTE IMMEDIATE('MERGE INTO CM01.prc_procedimientos t1 USING (SELECT prc.prc_id, prc.dd_tpo_id viejo, tap.dd_tpo_id nuevo
FROM CM01.prc_procedimientos prc
JOIN CM01.tmp_ugaspfs_bpm_input_con1 tmp ON prc.prc_id = tmp.prc_id
JOIN CM01.tap_tarea_procedimiento tap ON tmp.tap_id = tap.tap_id ) q
ON (t1.prc_id = q.prc_id)
WHEN MATCHED THEN
UPDATE
SET t1.dd_tpo_id = q.nuevo');


DBMS_OUTPUT.put_line('[INFO] STEP: 9');

EXECUTE IMMEDIATE('INSERT INTO CMMASTER.jbpm_token (id_, version_, start_,
end_, nodeenter_, issuspended_, node_, processinstance_, t_referencia)
SELECT CMMASTER.hibernate_sequence.NEXTVAL id_, 1 version_, SYSDATE start_,
NULL end_, SYSDATE nodeenter_, 0 issuspended_, node.id_ node_,
pi.id_ processinstance_, tmp.t_referencia
FROM CM01.tmp_ugaspfs_bpm_input_con1 tmp JOIN CM01.tar_tareas_notificaciones tar
ON tmp.t_referencia = tar.t_referencia
JOIN CM01.tap_tarea_procedimiento tap ON tmp.tap_id = tap.tap_id
JOIN CM01.prc_procedimientos prc ON tmp.prc_id = prc.prc_id
JOIN CM01.dd_tpo_tipo_procedimiento tpo ON prc.dd_tpo_id = tpo.dd_tpo_id
JOIN
(SELECT   name_, MAX (id_) id_
FROM CMMASTER.jbpm_processdefinition
GROUP BY name_) maxpd ON tpo.dd_tpo_xml_jbpm = maxpd.name_
JOIN CMMASTER.jbpm_node node ON maxpd.id_ = node.processdefinition_ AND tap.tap_codigo = node.name_
JOIN CMMASTER.jbpm_processinstance pi ON tmp.t_referencia = pi.t_referencia');


DBMS_OUTPUT.put_line('[INFO] STEP: 10');

EXECUTE IMMEDIATE('MERGE INTO CMMASTER.jbpm_processinstance t1 USING (SELECT pi.ID_, pi.roottoken_ viejo, tk.id_ nuevo
FROM CMMASTER.jbpm_processinstance pi 
JOIN CMMASTER.jbpm_token tk ON pi.t_referencia = tk.t_referencia
) q
ON (t1.ID_ = q.ID_)
WHEN MATCHED THEN
UPDATE
SET t1.roottoken_ = q.nuevo');


DBMS_OUTPUT.put_line('[INFO] STEP: 11');

EXECUTE IMMEDIATE('merge into CM01.tex_tarea_externa t1 using (SELECT tex.tex_id, tex.tex_token_id_bpm viejo, tk.id_ nuevo
FROM CM01.tex_tarea_externa tex 
JOIN CMMASTER.jbpm_token tk ON tex.t_referencia = tk.t_referencia) q
on (t1.tex_id = q.tex_id)
when matched then
update
set t1.tex_token_id_bpm = q.nuevo');


DBMS_OUTPUT.put_line('[INFO] STEP: 12');



EXECUTE IMMEDIATE('INSERT INTO CMMASTER.jbpm_moduleinstance
(ID_, class_, version_,processinstance_,name_)
SELECT CMMASTER.hibernate_sequence.NEXTVAL, ''C'' class_, 0 version_,
prc.prc_process_bpm processinstance_,
''org.jbpm.context.exe.ContextInstance'' name_
FROM CM01.prc_procedimientos prc 
JOIN CMMASTER.jbpm_processinstance pi ON prc.prc_process_bpm = pi.id_
JOIN CMMASTER.jbpm_token tk ON pi.roottoken_ = tk.id_
JOIN CMMASTER.jbpm_node nd ON tk.node_ = nd.id_
JOIN CM01.tex_tarea_externa tex ON tk.id_ = tex.tex_token_id_bpm AND tex.borrado = 0
JOIN CM01.tmp_ugaspfs_bpm_input_con1 ug ON ug.prc_id = prc.prc_id
WHERE NOT EXISTS (SELECT *
FROM CMMASTER.jbpm_moduleinstance
WHERE processinstance_ = prc.prc_process_bpm)');


DBMS_OUTPUT.put_line('[INFO] STEP: 13');

EXECUTE IMMEDIATE('INSERT INTO CMMASTER.jbpm_tokenvariablemap SELECT CMMASTER.hibernate_sequence.NEXTVAL, 0 version_, pi.roottoken_,
mi.id_ contextinstance_
FROM CM01.prc_procedimientos prc 
JOIN CMMASTER.jbpm_processinstance pi ON prc.prc_process_bpm = pi.id_
JOIN CMMASTER.jbpm_moduleinstance mi ON pi.id_ = mi.processinstance_
JOIN CMMASTER.jbpm_token tk ON pi.roottoken_ = tk.id_
JOIN CMMASTER.jbpm_node nd ON tk.node_ = nd.id_
JOIN CM01.tex_tarea_externa tex ON tk.id_ = tex.tex_token_id_bpm AND tex.borrado = 0
WHERE NOT EXISTS (SELECT *
FROM CMMASTER.jbpm_tokenvariablemap
WHERE token_ = pi.roottoken_)');


DBMS_OUTPUT.put_line('[INFO] STEP: 14');

EXECUTE IMMEDIATE('INSERT INTO CMMASTER.jbpm_variableinstance
(id_, class_, version_, name_, token_, tokenvariablemap_, processinstance_, longvalue_)
SELECT CMMASTER.hibernate_sequence.NEXTVAL id_, ''L'' class_, 0 version_,
''DB_ID'' name_, pi.roottoken_ token_, vm.id_ tokenvariablemap_,
pi.id_ processinstance_, 1 longvalue_
FROM CM01.prc_procedimientos prc 
JOIN CMMASTER.jbpm_processinstance pi ON prc.prc_process_bpm = pi.id_
JOIN CMMASTER.jbpm_tokenvariablemap vm ON pi.roottoken_ = vm.token_
JOIN CMMASTER.jbpm_token tk ON pi.roottoken_ = tk.id_
JOIN CMMASTER.jbpm_node nd ON tk.node_ = nd.id_
JOIN CM01.tex_tarea_externa tex ON tk.id_ = tex.tex_token_id_bpm AND tex.borrado = 0
WHERE NOT EXISTS (SELECT *
FROM CMMASTER.jbpm_variableinstance
WHERE processinstance_ = pi.id_ AND name_ = ''DB_ID'')');


DBMS_OUTPUT.put_line('[INFO] STEP: 15');

EXECUTE IMMEDIATE('INSERT INTO CMMASTER.jbpm_variableinstance 
(id_, class_, version_, name_, token_, tokenvariablemap_, processinstance_, longvalue_)
SELECT CMMASTER.hibernate_sequence.NEXTVAL id_, ''L'' class_, 0 version_,
''procedimientoTareaExterna'' name_, pi.roottoken_ token_,
vm.id_ tokenvariablemap_, pi.id_ processinstance_,
prc.prc_id longvalue_
FROM CM01.prc_procedimientos prc 
JOIN CMMASTER.jbpm_processinstance pi ON prc.prc_process_bpm = pi.id_
JOIN CMMASTER.jbpm_tokenvariablemap vm ON pi.roottoken_ = vm.token_
JOIN CMMASTER.jbpm_token tk ON pi.roottoken_ = tk.id_
JOIN CMMASTER.jbpm_node nd ON tk.node_ = nd.id_
JOIN CM01.tex_tarea_externa tex
ON tk.id_ = tex.tex_token_id_bpm AND tex.borrado = 0
WHERE NOT EXISTS (
SELECT *
FROM CMMASTER.jbpm_variableinstance
WHERE processinstance_ = pi.id_
AND name_ = ''procedimientoTareaExterna'')');


DBMS_OUTPUT.put_line('[INFO] STEP: 16');

EXECUTE IMMEDIATE('INSERT INTO CMMASTER.jbpm_variableinstance
(id_, class_, version_, name_, token_, tokenvariablemap_, processinstance_, longvalue_)
SELECT CMMASTER.hibernate_sequence.NEXTVAL id_, ''L'' class_, 0 version_,
''bpmParalizado'' name_, pi.roottoken_ token_,
vm.id_ tokenvariablemap_, pi.id_ processinstance_, 0 longvalue_
FROM CM01.prc_procedimientos prc 
JOIN CMMASTER.jbpm_processinstance pi ON prc.prc_process_bpm = pi.id_
JOIN CMMASTER.jbpm_tokenvariablemap vm ON pi.roottoken_ = vm.token_
JOIN CMMASTER.jbpm_token tk ON pi.roottoken_ = tk.id_
JOIN CMMASTER.jbpm_node nd ON tk.node_ = nd.id_
JOIN CM01.tex_tarea_externa tex ON tk.id_ = tex.tex_token_id_bpm AND tex.borrado = 0
WHERE NOT EXISTS (
SELECT *
FROM CMMASTER.jbpm_variableinstance
WHERE processinstance_ = pi.id_
AND name_ = ''bpmParalizado'')');


DBMS_OUTPUT.put_line('[INFO] STEP: 17');

EXECUTE IMMEDIATE('INSERT INTO CMMASTER.jbpm_variableinstance
(id_, class_, version_, name_, token_, tokenvariablemap_, processinstance_, longvalue_)
SELECT CMMASTER.hibernate_sequence.NEXTVAL id_, ''L'' class_, 0 version_,
''id'' || nd.name_ name_, pi.roottoken_ token_,
vm.id_ tokenvariablemap_, pi.id_ processinstance_,
tex.tex_id longvalue_
FROM CM01.prc_procedimientos prc 
JOIN CM01.tmp_ugaspfs_bpm_input_con1 tmp ON prc.prc_id = tmp.prc_id
JOIN CMMASTER.jbpm_processinstance pi ON prc.prc_process_bpm = pi.id_
JOIN CMMASTER.jbpm_token tk ON pi.roottoken_ = tk.id_
JOIN CMMASTER.jbpm_node nd ON tk.node_ = nd.id_
JOIN CMMASTER.jbpm_tokenvariablemap vm ON pi.roottoken_ = vm.token_
JOIN CM01.tex_tarea_externa tex ON tk.id_ = tex.tex_token_id_bpm AND tex.borrado = 0
WHERE NOT EXISTS (
SELECT *
FROM CMMASTER.jbpm_variableinstance
WHERE processinstance_ = pi.id_
AND name_ = ''id'' || nd.name_)
AND tex.usuariocrear = ''ALTAASUNCM''');


DBMS_OUTPUT.put_line('[INFO] STEP: 18');

EXECUTE IMMEDIATE('UPDATE CMMASTER.jbpm_token SET nextlogindex_ = 0 WHERE nextlogindex_ IS NULL');


DBMS_OUTPUT.put_line('[INFO] STEP: 19');

EXECUTE IMMEDIATE('UPDATE CMMASTER.jbpm_token SET isabletoreactivateparent_ = 0 WHERE isabletoreactivateparent_ IS NULL');


DBMS_OUTPUT.put_line('[INFO] STEP: 20');

EXECUTE IMMEDIATE('UPDATE CMMASTER.jbpm_token SET isterminationimplicit_ = 0 WHERE isterminationimplicit_ IS NULL');


DBMS_OUTPUT.put_line('[INFO] STEP: 21');

EXECUTE IMMEDIATE('INSERT INTO CMMASTER.JBPM_transition
(id_, name_,processdefinition_, from_, to_,fromindex_)
SELECT CMMASTER.hibernate_sequence.NEXTVAL id_, ''activarProrroga'' name_,
pd processdefinition_, nd from_, nd to_,
(max_fromindex + 1) fromindex_
FROM (SELECT   nd.id_ nd, nd.processdefinition_ pd,
MAX (aux.fromindex_) max_fromindex
FROM CM01.tar_tareas_notificaciones tar JOIN CM01.tex_tarea_externa tex
ON tar.tar_id = tex.tar_id
JOIN CM01.tap_tarea_procedimiento tap ON tex.tap_id = tap.tap_id
JOIN CM01.prc_procedimientos prc ON tar.prc_id = prc.prc_id
JOIN CMMASTER.jbpm_processinstance pi ON prc.prc_process_bpm = pi.id_
JOIN CMMASTER.jbpm_token tk ON pi.roottoken_ = tk.id_
JOIN CMMASTER.jbpm_node nd ON tk.node_ = nd.id_
JOIN CM01.tmp_ugaspfs_bpm_input_con1 ug ON prc.prc_id = ug.prc_id
LEFT JOIN CMMASTER.jbpm_transition aux ON nd.id_ = aux.from_
LEFT JOIN CMMASTER.jbpm_transition tr ON nd.id_ = tr.from_ AND tr.name_ = ''activarProrroga''
WHERE tar.borrado = 0
AND (   tar.tar_tarea_finalizada IS NULL
OR tar.tar_tarea_finalizada = 0
)
AND tar.prc_id IS NOT NULL
AND tap.tap_autoprorroga = 1
AND tr.id_ IS NULL
GROUP BY nd.id_, nd.processdefinition_)');


DBMS_OUTPUT.put_line('[INFO] STEP: 22');

EXECUTE IMMEDIATE('UPDATE CM01.tar_tareas_notificaciones SET tar_fecha_venc = SYSDATE + (DBMS_RANDOM.VALUE (1, 5)) WHERE fechacrear > SYSDATE - 0.1 AND tar_fecha_venc IS NULL
AND prc_id IS NOT NULL AND tar_tarea_finalizada IS NULL AND tar_tar_id IS NULL');


DBMS_OUTPUT.put_line('[INFO] STEP: 23');

EXECUTE IMMEDIATE('UPDATE CM01.tar_tareas_notificaciones SET tar_fecha_venc_real = tar_fecha_venc WHERE tar_fecha_venc IS NOT NULL AND tar_fecha_venc_real IS NULL');

DBMS_OUTPUT.put_line('[INFO] FIN');

COMMIT;

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
EXIT;

