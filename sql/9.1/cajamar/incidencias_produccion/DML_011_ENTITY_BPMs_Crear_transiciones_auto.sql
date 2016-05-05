--/*
--##########################################
--## AUTOR=OSCAR DORADO
--## FECHA_CREACION=20160503
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-2954
--## PRODUCTO=NO
--## Finalidad: DML
--##
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
	V_ESQUEMA VARCHAR2(25 CHAR):= 'CM01'; -- Configuracion Esquemas  
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'CMMASTER'; -- Configuracion Esquemas  
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script. 

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar 
BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO]');


DBMS_OUTPUT.PUT_LINE('[INSERT transicion activarProrroga...]');
V_TEXT1:= 'insert into '||V_ESQUEMA_M||'.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_) ' ||
	'select '||V_ESQUEMA_M||'.hibernate_sequence.nextval id_, ''activarProrroga'' name_, pd processdefinition_, nd from_, nd to_, (max_fromindex + 1) fromindex_ ' ||
	'from ( ' ||
	'select nd.id_ nd, nd.processdefinition_ pd, max(aux.fromindex_) max_fromindex ' ||
	'from '||V_ESQUEMA||'.tar_tareas_notificaciones tar ' ||
	'    join '||V_ESQUEMA||'.tex_tarea_externa tex on tar.tar_id = tex.tar_id ' ||
	'    join '||V_ESQUEMA||'.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id ' ||
	'    join '||V_ESQUEMA||'.prc_procedimientos prc on tar.prc_id = prc.prc_id ' ||
	'    join '||V_ESQUEMA_M||'.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_ ' ||
	'    join '||V_ESQUEMA_M||'.jbpm_token tk on pi.roottoken_ = tk.id_ ' ||
	'    join '||V_ESQUEMA_M||'.jbpm_node nd on tk.node_ = nd.id_  and nd.class_ <> ''F'' ' ||
	'    left join '||V_ESQUEMA_M||'.jbpm_transition aux on nd.id_ = aux.from_ ' ||
	'    left join '||V_ESQUEMA_M||'.jbpm_transition tr on nd.id_ = tr.from_ and tr.name_ = ''activarProrroga'' ' ||
	'where tar.borrado = 0 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) and tar.prc_id is not null ' ||
	'    and tap.tap_autoprorroga = 1 and tr.id_ is null ' ||
	'    and tar.usuariocrear like ''MIGRA%'' ' ||	
	'group by nd.id_,nd.processdefinition_)';
execute immediate V_TEXT1;

DBMS_OUTPUT.PUT_LINE('[INSERT transicion aplazarTareas...]');
V_TEXT1:= 'insert into '||V_ESQUEMA_M||'.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_) ' ||
	'select '||V_ESQUEMA_M||'.hibernate_sequence.nextval id_, ''aplazarTareas'' name_, pd processdefinition_, nd from_, nd to_, (max_fromindex + 1) fromindex_ ' ||
	'from ( ' ||
	'select nd.id_ nd, nd.processdefinition_ pd, max(aux.fromindex_) max_fromindex ' ||
	'from '||V_ESQUEMA||'.tar_tareas_notificaciones tar ' ||
	'    join '||V_ESQUEMA||'.tex_tarea_externa tex on tar.tar_id = tex.tar_id ' ||
	'    join '||V_ESQUEMA||'.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id ' ||
	'    join '||V_ESQUEMA||'.prc_procedimientos prc on tar.prc_id = prc.prc_id ' ||
	'    join '||V_ESQUEMA_M||'.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_ ' ||
	'    join '||V_ESQUEMA_M||'.jbpm_token tk on pi.roottoken_ = tk.id_ ' ||
	'    join '||V_ESQUEMA_M||'.jbpm_node nd on tk.node_ = nd.id_  and nd.class_ <> ''F'' ' ||
	'    left join '||V_ESQUEMA_M||'.jbpm_transition aux on nd.id_ = aux.from_ ' ||
	'    left join '||V_ESQUEMA_M||'.jbpm_transition tr on nd.id_ = tr.from_ and tr.name_ = ''aplazarTareas'' ' ||
	'where tar.borrado = 0 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) and tar.prc_id is not null ' ||
	'    and tap.tap_autoprorroga = 1 and tr.id_ is null ' ||
	'    and tar.usuariocrear like ''MIGRA%'' ' ||		
	'group by nd.id_,nd.processdefinition_)';
execute immediate V_TEXT1;

DBMS_OUTPUT.PUT_LINE('[INSERT transicion paralizarTareas...]');
V_TEXT1:= 'insert into '||V_ESQUEMA_M||'.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_) ' ||
	'select '||V_ESQUEMA_M||'.hibernate_sequence.nextval id_, ''paralizarTareas'' name_, pd processdefinition_, nd from_, nd to_, (max_fromindex + 1) fromindex_ ' ||
	'from ( ' ||
	'select nd.id_ nd, nd.processdefinition_ pd, max(aux.fromindex_) max_fromindex ' ||
	'from '||V_ESQUEMA||'.tar_tareas_notificaciones tar ' ||
	'    join '||V_ESQUEMA||'.tex_tarea_externa tex on tar.tar_id = tex.tar_id ' ||
	'    join '||V_ESQUEMA||'.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id ' ||
	'    join '||V_ESQUEMA||'.prc_procedimientos prc on tar.prc_id = prc.prc_id ' ||
	'    join '||V_ESQUEMA_M||'.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_ ' ||
	'    join '||V_ESQUEMA_M||'.jbpm_token tk on pi.roottoken_ = tk.id_ ' ||
	'    join '||V_ESQUEMA_M||'.jbpm_node nd on tk.node_ = nd.id_  and nd.class_ <> ''F'' '||
	'    left join '||V_ESQUEMA_M||'.jbpm_transition aux on nd.id_ = aux.from_ ' ||
	'    left join '||V_ESQUEMA_M||'.jbpm_transition tr on nd.id_ = tr.from_ and tr.name_ = ''paralizarTareas'' ' ||
	'where tar.borrado = 0 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) and tar.prc_id is not null ' ||
	'    and tap.tap_autoprorroga = 1 and tr.id_ is null ' ||
	'    and tar.usuariocrear like ''MIGRA%'' ' ||		
	'group by nd.id_,nd.processdefinition_)';
execute immediate V_TEXT1;

DBMS_OUTPUT.PUT_LINE('[INSERT transicion activarTareas...]');
V_TEXT1:= 'insert into '||V_ESQUEMA_M||'.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_) ' ||
	'select '||V_ESQUEMA_M||'.hibernate_sequence.nextval id_, ''activarTareas'' name_, pd processdefinition_, nd from_, nd to_, (max_fromindex + 1) fromindex_ ' ||
	'from ( ' ||
	'select nd.id_ nd, nd.processdefinition_ pd, max(aux.fromindex_) max_fromindex ' ||
	'from '||V_ESQUEMA||'.tar_tareas_notificaciones tar ' ||
	'    join '||V_ESQUEMA||'.tex_tarea_externa tex on tar.tar_id = tex.tar_id ' ||
	'    join '||V_ESQUEMA||'.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id ' ||
	'    join '||V_ESQUEMA||'.prc_procedimientos prc on tar.prc_id = prc.prc_id ' ||
	'    join '||V_ESQUEMA_M||'.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_ ' ||
	'    join '||V_ESQUEMA_M||'.jbpm_token tk on pi.roottoken_ = tk.id_ ' ||
	'    join '||V_ESQUEMA_M||'.jbpm_node nd on tk.node_ = nd.id_ and nd.class_ <> ''F'' ' ||
	'    left join '||V_ESQUEMA_M||'.jbpm_transition aux on nd.id_ = aux.from_ ' ||
	'    left join '||V_ESQUEMA_M||'.jbpm_transition tr on nd.id_ = tr.from_ and tr.name_ = ''activarTareas'' ' ||
	'where tar.borrado = 0 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) and tar.prc_id is not null ' ||
	'    and tap.tap_autoprorroga = 1 and tr.id_ is null ' ||
	'    and tar.usuariocrear like ''MIGRA%'' ' ||		
	'group by nd.id_,nd.processdefinition_)';
execute immediate V_TEXT1;

DBMS_OUTPUT.PUT_LINE('[INSERT transicion activarAlerta...]');
V_TEXT1:= 'insert into '||V_ESQUEMA_M||'.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_) ' ||
	'select '||V_ESQUEMA_M||'.hibernate_sequence.nextval id_, ''activarTareas'' name_, pd processdefinition_, nd from_, nd to_, (max_fromindex + 1) fromindex_ ' ||
	'from ( ' ||
	'select nd.id_ nd, nd.processdefinition_ pd, max(aux.fromindex_) max_fromindex ' ||
	'from '||V_ESQUEMA||'.tar_tareas_notificaciones tar ' ||
	'    join '||V_ESQUEMA||'.tex_tarea_externa tex on tar.tar_id = tex.tar_id ' ||
	'    join '||V_ESQUEMA||'.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id and DD_TPO_ID_BPM is null ' ||
	'    join '||V_ESQUEMA||'.prc_procedimientos prc on tar.prc_id = prc.prc_id ' ||
	'    join '||V_ESQUEMA_M||'.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_ ' ||
	'    join '||V_ESQUEMA_M||'.jbpm_token tk on pi.roottoken_ = tk.id_ ' ||
	'    join '||V_ESQUEMA_M||'.jbpm_node nd on tk.node_ = nd.id_ and nd.class_ <> ''F'' ' ||
	'    left join '||V_ESQUEMA_M||'.jbpm_transition aux on nd.id_ = aux.from_ ' ||
	'    left join '||V_ESQUEMA_M||'.jbpm_transition tr on nd.id_ = tr.from_ and tr.name_ = ''activarAlerta'' ' ||
	'where tar.borrado = 0 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) and tar.prc_id is not null ' ||
	'    and tap.tap_autoprorroga = 1 and tr.id_ is null ' ||
	'    and tar.usuariocrear like ''MIGRA%'' ' ||		
	'group by nd.id_,nd.processdefinition_)';
execute immediate V_TEXT1;

--EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA_M||'.JBPM_TRANSITION where id_ in (select tr.id_
--			from BANKMASTER.JBPM_TRANSITION tr 
--			 join BANKMASTER.JBPM_NODE nd on tr.from_ = nd.id_
--			where tr.from_ = tr.to_ and nd.class_ = ''F'')';
--			
COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN] INCIDENCIA');

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT

