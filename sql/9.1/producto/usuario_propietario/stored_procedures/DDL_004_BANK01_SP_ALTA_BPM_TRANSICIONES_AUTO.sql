--/*
--##########################################
--## AUTOR=Rubén Rovira
--## FECHA_CREACION=20151027
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.2
--## INCIDENCIA_LINK=BKREC-58
--## PRODUCTO=NO
--## 
--## Finalidad: 
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

create or replace PROCEDURE ALTA_BPM_TRANSICIONES_AUTO AUTHID CURRENT_USER AS

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] TRANSICIONES AUTOMATICAS');

	DBMS_OUTPUT.PUT_LINE('[INSERT transicion activarProrroga...]');
	V_TEXT1:= 'insert into #ESQUEMA_MASTER#.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_) ' ||
		'select #ESQUEMA_MASTER#.hibernate_sequence.nextval id_, ''activarProrroga'' name_, pd processdefinition_, nd from_, nd to_, (max_fromindex + 1) fromindex_ ' ||
		'from ( ' ||
		'select nd.id_ nd, nd.processdefinition_ pd, max(aux.fromindex_) max_fromindex ' ||
		'from #ESQUEMA#.tar_tareas_notificaciones tar ' ||
		'    join #ESQUEMA#.tex_tarea_externa tex on tar.tar_id = tex.tar_id ' ||
		'    join #ESQUEMA#.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id ' ||
		'    join #ESQUEMA#.prc_procedimientos prc on tar.prc_id = prc.prc_id ' ||
		'    join #ESQUEMA_MASTER#.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_ ' ||
		'    join #ESQUEMA_MASTER#.jbpm_token tk on pi.roottoken_ = tk.id_ ' ||
		'    join #ESQUEMA_MASTER#.jbpm_node nd on tk.node_ = nd.id_ ' ||
		'    left join #ESQUEMA_MASTER#.jbpm_transition aux on nd.id_ = aux.from_ ' ||
		'    left join #ESQUEMA_MASTER#.jbpm_transition tr on nd.id_ = tr.from_ and tr.name_ = ''activarProrroga'' ' ||
		'where tar.borrado = 0 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) and tar.prc_id is not null ' ||
		'    and tap.tap_autoprorroga = 1 and tr.id_ is null ' ||
		'group by nd.id_,nd.processdefinition_)';
	execute immediate V_TEXT1;

	DBMS_OUTPUT.PUT_LINE('[INSERT transicion aplazarTareas...]');
	V_TEXT1:= 'insert into #ESQUEMA_MASTER#.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_) ' ||
		'select #ESQUEMA_MASTER#.hibernate_sequence.nextval id_, ''aplazarTareas'' name_, pd processdefinition_, nd from_, nd to_, (max_fromindex + 1) fromindex_ ' ||
		'from ( ' ||
		'select nd.id_ nd, nd.processdefinition_ pd, max(aux.fromindex_) max_fromindex ' ||
		'from #ESQUEMA#.tar_tareas_notificaciones tar ' ||
		'    join #ESQUEMA#.tex_tarea_externa tex on tar.tar_id = tex.tar_id ' ||
		'    join #ESQUEMA#.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id ' ||
		'    join #ESQUEMA#.prc_procedimientos prc on tar.prc_id = prc.prc_id ' ||
		'    join #ESQUEMA_MASTER#.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_ ' ||
		'    join #ESQUEMA_MASTER#.jbpm_token tk on pi.roottoken_ = tk.id_ ' ||
		'    join #ESQUEMA_MASTER#.jbpm_node nd on tk.node_ = nd.id_ ' ||
		'    left join #ESQUEMA_MASTER#.jbpm_transition aux on nd.id_ = aux.from_ ' ||
		'    left join #ESQUEMA_MASTER#.jbpm_transition tr on nd.id_ = tr.from_ and tr.name_ = ''aplazarTareas'' ' ||
		'where tar.borrado = 0 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) and tar.prc_id is not null ' ||
		'    and tap.tap_autoprorroga = 1 and tr.id_ is null ' ||
		'group by nd.id_,nd.processdefinition_)';
	execute immediate V_TEXT1;

	DBMS_OUTPUT.PUT_LINE('[INSERT transicion paralizarTareas...]');
	V_TEXT1:= 'insert into #ESQUEMA_MASTER#.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_) ' ||
		'select #ESQUEMA_MASTER#.hibernate_sequence.nextval id_, ''paralizarTareas'' name_, pd processdefinition_, nd from_, nd to_, (max_fromindex + 1) fromindex_ ' ||
		'from ( ' ||
		'select nd.id_ nd, nd.processdefinition_ pd, max(aux.fromindex_) max_fromindex ' ||
		'from #ESQUEMA#.tar_tareas_notificaciones tar ' ||
		'    join #ESQUEMA#.tex_tarea_externa tex on tar.tar_id = tex.tar_id ' ||
		'    join #ESQUEMA#.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id ' ||
		'    join #ESQUEMA#.prc_procedimientos prc on tar.prc_id = prc.prc_id ' ||
		'    join #ESQUEMA_MASTER#.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_ ' ||
		'    join #ESQUEMA_MASTER#.jbpm_token tk on pi.roottoken_ = tk.id_ ' ||
		'    join #ESQUEMA_MASTER#.jbpm_node nd on tk.node_ = nd.id_ ' ||
		'    left join #ESQUEMA_MASTER#.jbpm_transition aux on nd.id_ = aux.from_ ' ||
		'    left join #ESQUEMA_MASTER#.jbpm_transition tr on nd.id_ = tr.from_ and tr.name_ = ''paralizarTareas'' ' ||
		'where tar.borrado = 0 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) and tar.prc_id is not null ' ||
		'    and tap.tap_autoprorroga = 1 and tr.id_ is null ' ||
		'group by nd.id_,nd.processdefinition_)';
	execute immediate V_TEXT1;

	DBMS_OUTPUT.PUT_LINE('[INSERT transicion activarTareas...]');
	V_TEXT1:= 'insert into #ESQUEMA_MASTER#.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_) ' ||
		'select #ESQUEMA_MASTER#.hibernate_sequence.nextval id_, ''activarTareas'' name_, pd processdefinition_, nd from_, nd to_, (max_fromindex + 1) fromindex_ ' ||
		'from ( ' ||
		'select nd.id_ nd, nd.processdefinition_ pd, max(aux.fromindex_) max_fromindex ' ||
		'from #ESQUEMA#.tar_tareas_notificaciones tar ' ||
		'    join #ESQUEMA#.tex_tarea_externa tex on tar.tar_id = tex.tar_id ' ||
		'    join #ESQUEMA#.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id ' ||
		'    join #ESQUEMA#.prc_procedimientos prc on tar.prc_id = prc.prc_id ' ||
		'    join #ESQUEMA_MASTER#.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_ ' ||
		'    join #ESQUEMA_MASTER#.jbpm_token tk on pi.roottoken_ = tk.id_ ' ||
		'    join #ESQUEMA_MASTER#.jbpm_node nd on tk.node_ = nd.id_ ' ||
		'    left join #ESQUEMA_MASTER#.jbpm_transition aux on nd.id_ = aux.from_ ' ||
		'    left join #ESQUEMA_MASTER#.jbpm_transition tr on nd.id_ = tr.from_ and tr.name_ = ''activarTareas'' ' ||
		'where tar.borrado = 0 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) and tar.prc_id is not null ' ||
		'    and tap.tap_autoprorroga = 1 and tr.id_ is null ' ||
		'group by nd.id_,nd.processdefinition_)';
	execute immediate V_TEXT1;

COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN] TRANSICIONES AUTOMATICAS');

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;
END ALTA_BPM_TRANSICIONES_AUTO;
/

EXIT;
