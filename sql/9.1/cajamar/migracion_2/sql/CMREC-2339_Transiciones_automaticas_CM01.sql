insert into CMMASTER.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_) 
	select CMMASTER.hibernate_sequence.nextval id_, 'activarProrroga' name_, pd processdefinition_, nd from_, nd to_, (max_fromindex + 1) fromindex_ 
	from ( 
	select nd.id_ nd, nd.processdefinition_ pd, max(aux.fromindex_) max_fromindex 
	from CM01.tar_tareas_notificaciones tar 
	    join CM01.tex_tarea_externa tex on tar.tar_id = tex.tar_id 
	    join CM01.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id 
	    join CM01.prc_procedimientos prc on tar.prc_id = prc.prc_id 
	    join CMMASTER.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_ 
	    join CMMASTER.jbpm_token tk on pi.roottoken_ = tk.id_ 
	    join CMMASTER.jbpm_node nd on tk.node_ = nd.id_  and nd.class_ <> 'F' 
	    left join CMMASTER.jbpm_transition aux on nd.id_ = aux.from_ 
	    left join CMMASTER.jbpm_transition tr on nd.id_ = tr.from_ and tr.name_ = 'activarProrroga' 
	where tar.borrado = 0 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) and tar.prc_id is not null 
	    and tap.tap_autoprorroga = 1 and tr.id_ is null 
	group by nd.id_,nd.processdefinition_);



insert into CMMASTER.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_) 
	select CMMASTER.hibernate_sequence.nextval id_, 'aplazarTareas' name_, pd processdefinition_, nd from_, nd to_, (max_fromindex + 1) fromindex_ 
	from ( 
	select nd.id_ nd, nd.processdefinition_ pd, max(aux.fromindex_) max_fromindex 
	from CM01.tar_tareas_notificaciones tar 
	    join CM01.tex_tarea_externa tex on tar.tar_id = tex.tar_id 
	    join CM01.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id 
	    join CM01.prc_procedimientos prc on tar.prc_id = prc.prc_id 
	    join CMMASTER.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_ 
	    join CMMASTER.jbpm_token tk on pi.roottoken_ = tk.id_ 
	    join CMMASTER.jbpm_node nd on tk.node_ = nd.id_  and nd.class_ <> 'F' 
	    left join CMMASTER.jbpm_transition aux on nd.id_ = aux.from_ 
	    left join CMMASTER.jbpm_transition tr on nd.id_ = tr.from_ and tr.name_ = 'aplazarTareas' 
	where tar.borrado = 0 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) and tar.prc_id is not null 
	    and tap.tap_autoprorroga = 1 and tr.id_ is null 
	group by nd.id_,nd.processdefinition_);

insert into CMMASTER.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_) 
	select CMMASTER.hibernate_sequence.nextval id_, 'paralizarTareas' name_, pd processdefinition_, nd from_, nd to_, (max_fromindex + 1) fromindex_ 
	from ( 
	select nd.id_ nd, nd.processdefinition_ pd, max(aux.fromindex_) max_fromindex 
	from CM01.tar_tareas_notificaciones tar 
	    join CM01.tex_tarea_externa tex on tar.tar_id = tex.tar_id 
	    join CM01.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id 
	    join CM01.prc_procedimientos prc on tar.prc_id = prc.prc_id 
	    join CMMASTER.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_ 
	    join CMMASTER.jbpm_token tk on pi.roottoken_ = tk.id_ 
	    join CMMASTER.jbpm_node nd on tk.node_ = nd.id_  and nd.class_ <> 'F' 
	    left join CMMASTER.jbpm_transition aux on nd.id_ = aux.from_ 
	    left join CMMASTER.jbpm_transition tr on nd.id_ = tr.from_ and tr.name_ = 'paralizarTareas' 
	where tar.borrado = 0 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) and tar.prc_id is not null 
	    and tap.tap_autoprorroga = 1 and tr.id_ is null 
	group by nd.id_,nd.processdefinition_);



insert into CMMASTER.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_) 
	select CMMASTER.hibernate_sequence.nextval id_, 'activarTareas' name_, pd processdefinition_, nd from_, nd to_, (max_fromindex + 1) fromindex_ 
	from ( 
	select nd.id_ nd, nd.processdefinition_ pd, max(aux.fromindex_) max_fromindex 
	from CM01.tar_tareas_notificaciones tar 
	    join CM01.tex_tarea_externa tex on tar.tar_id = tex.tar_id 
	    join CM01.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id 
	    join CM01.prc_procedimientos prc on tar.prc_id = prc.prc_id 
	    join CMMASTER.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_ 
	    join CMMASTER.jbpm_token tk on pi.roottoken_ = tk.id_ 
	    join CMMASTER.jbpm_node nd on tk.node_ = nd.id_ and nd.class_ <> 'F' 
	    left join CMMASTER.jbpm_transition aux on nd.id_ = aux.from_ 
	    left join CMMASTER.jbpm_transition tr on nd.id_ = tr.from_ and tr.name_ = 'activarTareas' 
	where tar.borrado = 0 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) and tar.prc_id is not null 
	    and tap.tap_autoprorroga = 1 and tr.id_ is null 
	group by nd.id_,nd.processdefinition_);


insert into CMMASTER.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_) 
	select CMMASTER.hibernate_sequence.nextval id_, 'activarTareas' name_, pd processdefinition_, nd from_, nd to_, (max_fromindex + 1) fromindex_ 
	from ( 
	select nd.id_ nd, nd.processdefinition_ pd, max(aux.fromindex_) max_fromindex 
	from CM01.tar_tareas_notificaciones tar 
	    join CM01.tex_tarea_externa tex on tar.tar_id = tex.tar_id 
	    join CM01.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id and DD_TPO_ID_BPM is null 
	    join CM01.prc_procedimientos prc on tar.prc_id = prc.prc_id 
	    join CMMASTER.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_ 
	    join CMMASTER.jbpm_token tk on pi.roottoken_ = tk.id_ 
	    join CMMASTER.jbpm_node nd on tk.node_ = nd.id_ and nd.class_ <> 'F' 
	    left join CMMASTER.jbpm_transition aux on nd.id_ = aux.from_ 
	    left join CMMASTER.jbpm_transition tr on nd.id_ = tr.from_ and tr.name_ = 'activarAlerta' 
	where tar.borrado = 0 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) and tar.prc_id is not null 
	    and tap.tap_autoprorroga = 1 and tr.id_ is null 
	group by nd.id_,nd.processdefinition_);
  
  
  
  
  
  DELETE FROM CMMASTER.JBPM_TRANSITION where id_ in (select tr.id_
			from CMMASTER.JBPM_TRANSITION tr 
			 join CMMASTER.JBPM_NODE nd on tr.from_ = nd.id_
			where tr.from_ = tr.to_ and nd.class_ = 'F');
      
      
COMMIT;      