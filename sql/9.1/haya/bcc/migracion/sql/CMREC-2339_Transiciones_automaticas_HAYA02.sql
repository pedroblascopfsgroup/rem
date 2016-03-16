--select *
--from asu_asuntos
--where asu_nombre = ' |  ';


insert into HAYAMASTER.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_) 
	select HAYAMASTER.hibernate_sequence.nextval id_, 'activarProrroga' name_, pd processdefinition_, nd from_, nd to_, (max_fromindex + 1) fromindex_ 
	from ( 
	select nd.id_ nd, nd.processdefinition_ pd, max(aux.fromindex_) max_fromindex 
	from HAYA02.tar_tareas_notificaciones tar 
	    join HAYA02.tex_tarea_externa tex on tar.tar_id = tex.tar_id 
	    join HAYA02.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id 
	    join HAYA02.prc_procedimientos prc on tar.prc_id = prc.prc_id 
	    join HAYAMASTER.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_ 
	    join HAYAMASTER.jbpm_token tk on pi.roottoken_ = tk.id_ 
	    join HAYAMASTER.jbpm_node nd on tk.node_ = nd.id_  and nd.class_ <> 'F' 
	    left join HAYAMASTER.jbpm_transition aux on nd.id_ = aux.from_ 
	    left join HAYAMASTER.jbpm_transition tr on nd.id_ = tr.from_ and tr.name_ = 'activarProrroga' 
	where tar.borrado = 0 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) and tar.prc_id is not null 
	    and tap.tap_autoprorroga = 1 and tr.id_ is null 
	group by nd.id_,nd.processdefinition_);



insert into HAYAMASTER.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_) 
	select HAYAMASTER.hibernate_sequence.nextval id_, 'aplazarTareas' name_, pd processdefinition_, nd from_, nd to_, (max_fromindex + 1) fromindex_ 
	from ( 
	select nd.id_ nd, nd.processdefinition_ pd, max(aux.fromindex_) max_fromindex 
	from HAYA02.tar_tareas_notificaciones tar 
	    join HAYA02.tex_tarea_externa tex on tar.tar_id = tex.tar_id 
	    join HAYA02.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id 
	    join HAYA02.prc_procedimientos prc on tar.prc_id = prc.prc_id 
	    join HAYAMASTER.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_ 
	    join HAYAMASTER.jbpm_token tk on pi.roottoken_ = tk.id_ 
	    join HAYAMASTER.jbpm_node nd on tk.node_ = nd.id_  and nd.class_ <> 'F' 
	    left join HAYAMASTER.jbpm_transition aux on nd.id_ = aux.from_ 
	    left join HAYAMASTER.jbpm_transition tr on nd.id_ = tr.from_ and tr.name_ = 'aplazarTareas' 
	where tar.borrado = 0 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) and tar.prc_id is not null 
	    and tap.tap_autoprorroga = 1 and tr.id_ is null 
	group by nd.id_,nd.processdefinition_);

insert into HAYAMASTER.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_) 
	select HAYAMASTER.hibernate_sequence.nextval id_, 'paralizarTareas' name_, pd processdefinition_, nd from_, nd to_, (max_fromindex + 1) fromindex_ 
	from ( 
	select nd.id_ nd, nd.processdefinition_ pd, max(aux.fromindex_) max_fromindex 
	from HAYA02.tar_tareas_notificaciones tar 
	    join HAYA02.tex_tarea_externa tex on tar.tar_id = tex.tar_id 
	    join HAYA02.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id 
	    join HAYA02.prc_procedimientos prc on tar.prc_id = prc.prc_id 
	    join HAYAMASTER.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_ 
	    join HAYAMASTER.jbpm_token tk on pi.roottoken_ = tk.id_ 
	    join HAYAMASTER.jbpm_node nd on tk.node_ = nd.id_  and nd.class_ <> 'F' 
	    left join HAYAMASTER.jbpm_transition aux on nd.id_ = aux.from_ 
	    left join HAYAMASTER.jbpm_transition tr on nd.id_ = tr.from_ and tr.name_ = 'paralizarTareas' 
	where tar.borrado = 0 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) and tar.prc_id is not null 
	    and tap.tap_autoprorroga = 1 and tr.id_ is null 
	group by nd.id_,nd.processdefinition_);



insert into HAYAMASTER.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_) 
	select HAYAMASTER.hibernate_sequence.nextval id_, 'activarTareas' name_, pd processdefinition_, nd from_, nd to_, (max_fromindex + 1) fromindex_ 
	from ( 
	select nd.id_ nd, nd.processdefinition_ pd, max(aux.fromindex_) max_fromindex 
	from HAYA02.tar_tareas_notificaciones tar 
	    join HAYA02.tex_tarea_externa tex on tar.tar_id = tex.tar_id 
	    join HAYA02.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id 
	    join HAYA02.prc_procedimientos prc on tar.prc_id = prc.prc_id 
	    join HAYAMASTER.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_ 
	    join HAYAMASTER.jbpm_token tk on pi.roottoken_ = tk.id_ 
	    join HAYAMASTER.jbpm_node nd on tk.node_ = nd.id_ and nd.class_ <> 'F' 
	    left join HAYAMASTER.jbpm_transition aux on nd.id_ = aux.from_ 
	    left join HAYAMASTER.jbpm_transition tr on nd.id_ = tr.from_ and tr.name_ = 'activarTareas' 
	where tar.borrado = 0 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) and tar.prc_id is not null 
	    and tap.tap_autoprorroga = 1 and tr.id_ is null 
	group by nd.id_,nd.processdefinition_);


insert into HAYAMASTER.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_) 
	select HAYAMASTER.hibernate_sequence.nextval id_, 'activarTareas' name_, pd processdefinition_, nd from_, nd to_, (max_fromindex + 1) fromindex_ 
	from ( 
	select nd.id_ nd, nd.processdefinition_ pd, max(aux.fromindex_) max_fromindex 
	from HAYA02.tar_tareas_notificaciones tar 
	    join HAYA02.tex_tarea_externa tex on tar.tar_id = tex.tar_id 
	    join HAYA02.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id and DD_TPO_ID_BPM is null 
	    join HAYA02.prc_procedimientos prc on tar.prc_id = prc.prc_id 
	    join HAYAMASTER.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_ 
	    join HAYAMASTER.jbpm_token tk on pi.roottoken_ = tk.id_ 
	    join HAYAMASTER.jbpm_node nd on tk.node_ = nd.id_ and nd.class_ <> 'F' 
	    left join HAYAMASTER.jbpm_transition aux on nd.id_ = aux.from_ 
	    left join HAYAMASTER.jbpm_transition tr on nd.id_ = tr.from_ and tr.name_ = 'activarAlerta' 
	where tar.borrado = 0 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) and tar.prc_id is not null 
	    and tap.tap_autoprorroga = 1 and tr.id_ is null 
	group by nd.id_,nd.processdefinition_);
  
  
  
  
  
  DELETE FROM HAYAMASTER.JBPM_TRANSITION where id_ in (select tr.id_
			from HAYAMASTER.JBPM_TRANSITION tr 
			 join HAYAMASTER.JBPM_NODE nd on tr.from_ = nd.id_
			where tr.from_ = tr.to_ and nd.class_ = 'F');
      
      
commit;      
      

EXIT;
/