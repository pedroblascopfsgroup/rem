--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20160601
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-1849
--## PRODUCTO=NO
--## 
--## Finalidad: Corrige BPMs
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 20151126 GMN Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
set timing ON
set linesize 2000
SET VERIFY OFF
set feedback on

DECLARE

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.


BEGIN



/**************** TRANSICIONES AUTOMATICAS *******************/

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
	where tar.borrado = 1 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) and tar.prc_id is not null 
	    --and tap.tap_autoprorroga = 1 
	    and tr.id_ is null 
       AND PRC.PRC_ID in 
                                          (select distinct prc.prc_ID
                                           from CM01.MIG_EXPEDIENTES_CABECERA mig
                                             inner join CM01.asu_asuntos asu  on mig.cd_expediente = asu.asu_id_externo
                                             inner join CM01.prc_procedimientos prc on asu.asu_id = prc.asu_id 
                                             inner join CM01.pco_prc_procedimientos pco on prc.prc_id = pco.prc_id
                                             inner join CM01.PCO_PRC_HEP_HISTOR_EST_PREP hep on pco.pco_prc_id = hep.pco_prc_id
                                             inner join CM01.tar_tareas_notificaciones tar on prc.prc_id = tar.prc_id 
                                             inner join CM01.tex_tarea_externa tex on tar.tar_id = tex.tar_id 
                                           where  prc.usuariocrear = 'MIGRACM01PCO'
                                             and hep.DD_PCO_PEP_ID = (SELECT DD_PCO_PEP_ID FROM CM01.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = 'PA')
                                             and hep.PCO_PRC_HEP_FECHA_FIN is null
                                            )
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
	where tar.borrado = 1 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) and tar.prc_id is not null 
	    --and tap.tap_autoprorroga = 1 
	    and tr.id_ is null 
 AND PRC.PRC_ID in 
                                          (select distinct prc.prc_ID
                                           from CM01.MIG_EXPEDIENTES_CABECERA mig
                                             inner join CM01.asu_asuntos asu  on mig.cd_expediente = asu.asu_id_externo
                                             inner join CM01.prc_procedimientos prc on asu.asu_id = prc.asu_id 
                                             inner join CM01.pco_prc_procedimientos pco on prc.prc_id = pco.prc_id
                                             inner join CM01.PCO_PRC_HEP_HISTOR_EST_PREP hep on pco.pco_prc_id = hep.pco_prc_id
                                             inner join CM01.tar_tareas_notificaciones tar on prc.prc_id = tar.prc_id 
                                             inner join CM01.tex_tarea_externa tex on tar.tar_id = tex.tar_id 
                                           where  prc.usuariocrear = 'MIGRACM01PCO'
                                             and hep.DD_PCO_PEP_ID = (SELECT DD_PCO_PEP_ID FROM CM01.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = 'PA')
                                             and hep.PCO_PRC_HEP_FECHA_FIN is null
                                            )      
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
	where tar.borrado = 1 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) and tar.prc_id is not null 
	    --and tap.tap_autoprorroga = 1 
	    and tr.id_ is null 
 AND PRC.PRC_ID in 
                                          (select distinct prc.prc_ID
                                           from CM01.MIG_EXPEDIENTES_CABECERA mig
                                             inner join CM01.asu_asuntos asu  on mig.cd_expediente = asu.asu_id_externo
                                             inner join CM01.prc_procedimientos prc on asu.asu_id = prc.asu_id 
                                             inner join CM01.pco_prc_procedimientos pco on prc.prc_id = pco.prc_id
                                             inner join CM01.PCO_PRC_HEP_HISTOR_EST_PREP hep on pco.pco_prc_id = hep.pco_prc_id
                                             inner join CM01.tar_tareas_notificaciones tar on prc.prc_id = tar.prc_id 
                                             inner join CM01.tex_tarea_externa tex on tar.tar_id = tex.tar_id 
                                           where  prc.usuariocrear = 'MIGRACM01PCO'
                                             and hep.DD_PCO_PEP_ID = (SELECT DD_PCO_PEP_ID FROM CM01.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = 'PA')
                                             and hep.PCO_PRC_HEP_FECHA_FIN is null
                                            )      
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
	where tar.borrado = 1 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) and tar.prc_id is not null 
	    --and tap.tap_autoprorroga = 1 
	    and tr.id_ is null 
       AND PRC.PRC_ID in 
                                          (select distinct prc.prc_ID
                                           from CM01.MIG_EXPEDIENTES_CABECERA mig
                                             inner join CM01.asu_asuntos asu  on mig.cd_expediente = asu.asu_id_externo
                                             inner join CM01.prc_procedimientos prc on asu.asu_id = prc.asu_id 
                                             inner join CM01.pco_prc_procedimientos pco on prc.prc_id = pco.prc_id
                                             inner join CM01.PCO_PRC_HEP_HISTOR_EST_PREP hep on pco.pco_prc_id = hep.pco_prc_id
                                             inner join CM01.tar_tareas_notificaciones tar on prc.prc_id = tar.prc_id 
                                             inner join CM01.tex_tarea_externa tex on tar.tar_id = tex.tar_id 
                                           where  prc.usuariocrear = 'MIGRACM01PCO'
                                             and hep.DD_PCO_PEP_ID = (SELECT DD_PCO_PEP_ID FROM CM01.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = 'PA')
                                             and hep.PCO_PRC_HEP_FECHA_FIN is null
                                            )
	group by nd.id_,nd.processdefinition_);


insert into CMMASTER.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_) 
	select CMMASTER.hibernate_sequence.nextval id_, 'activarAlerta' name_, pd processdefinition_, nd from_, nd to_, (max_fromindex + 1) fromindex_ 
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
	where tar.borrado = 1 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) and tar.prc_id is not null 
	    --and tap.tap_autoprorroga = 1 
	    and tr.id_ is null 
       AND PRC.PRC_ID in 
                                          (select distinct prc.prc_ID
                                           from CM01.MIG_EXPEDIENTES_CABECERA mig
                                             inner join CM01.asu_asuntos asu  on mig.cd_expediente = asu.asu_id_externo
                                             inner join CM01.prc_procedimientos prc on asu.asu_id = prc.asu_id 
                                             inner join CM01.pco_prc_procedimientos pco on prc.prc_id = pco.prc_id
                                             inner join CM01.PCO_PRC_HEP_HISTOR_EST_PREP hep on pco.pco_prc_id = hep.pco_prc_id
                                             inner join CM01.tar_tareas_notificaciones tar on prc.prc_id = tar.prc_id 
                                             inner join CM01.tex_tarea_externa tex on tar.tar_id = tex.tar_id 
                                           where  prc.usuariocrear = 'MIGRACM01PCO'
                                             and hep.DD_PCO_PEP_ID = (SELECT DD_PCO_PEP_ID FROM CM01.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = 'PA')
                                             and hep.PCO_PRC_HEP_FECHA_FIN is null
                                            )
	group by nd.id_,nd.processdefinition_);
  
  
  
     
COMMIT;      

                             
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(V_SQL);
          ROLLBACK;
          RAISE;   
END;
/

EXIT;
