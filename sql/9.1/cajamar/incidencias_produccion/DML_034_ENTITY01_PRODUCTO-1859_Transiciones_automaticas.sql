--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20160602
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
SET SERVEROUTPUT ON;

DECLARE

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.


BEGIN



/**************** TRANSICIONES AUTOMATICAS *******************/

insert into #ESQUEMA_MASTER#.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_) 
     select #ESQUEMA_MASTER#.hibernate_sequence.nextval id_, 'activarProrroga' name_, pd processdefinition_, nd from_, nd to_, (max_fromindex + 1) fromindex_ 
     from ( 
     select nd.id_ nd, nd.processdefinition_ pd, max(aux.fromindex_) max_fromindex 
     from #ESQUEMA#.tar_tareas_notificaciones tar 
         join #ESQUEMA#.tex_tarea_externa tex on tar.tar_id = tex.tar_id 
         join #ESQUEMA#.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id 
         join #ESQUEMA#.prc_procedimientos prc on tar.prc_id = prc.prc_id 
         join #ESQUEMA_MASTER#.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_ 
         join #ESQUEMA_MASTER#.jbpm_token tk on pi.roottoken_ = tk.id_ 
         join #ESQUEMA_MASTER#.jbpm_node nd on tk.node_ = nd.id_  and nd.class_ <> 'F' 
         left join #ESQUEMA_MASTER#.jbpm_transition aux on nd.id_ = aux.from_ 
         left join #ESQUEMA_MASTER#.jbpm_transition tr on nd.id_ = tr.from_ and tr.name_ = 'activarProrroga' 
     where tar.borrado = 0 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) and tar.prc_id is not null   
         and tr.id_ is null 
     group by nd.id_,nd.processdefinition_);

     DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);  


insert into #ESQUEMA_MASTER#.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_) 
     select #ESQUEMA_MASTER#.hibernate_sequence.nextval id_, 'aplazarTareas' name_, pd processdefinition_, nd from_, nd to_, (max_fromindex + 1) fromindex_ 
     from ( 
     select nd.id_ nd, nd.processdefinition_ pd, max(aux.fromindex_) max_fromindex 
     from #ESQUEMA#.tar_tareas_notificaciones tar 
         join #ESQUEMA#.tex_tarea_externa tex on tar.tar_id = tex.tar_id 
         join #ESQUEMA#.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id 
         join #ESQUEMA#.prc_procedimientos prc on tar.prc_id = prc.prc_id 
         join #ESQUEMA_MASTER#.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_ 
         join #ESQUEMA_MASTER#.jbpm_token tk on pi.roottoken_ = tk.id_ 
         join #ESQUEMA_MASTER#.jbpm_node nd on tk.node_ = nd.id_  and nd.class_ <> 'F' 
         left join #ESQUEMA_MASTER#.jbpm_transition aux on nd.id_ = aux.from_ 
         left join #ESQUEMA_MASTER#.jbpm_transition tr on nd.id_ = tr.from_ and tr.name_ = 'aplazarTareas' 
     where tar.borrado = 0 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) and tar.prc_id is not null 
         and tr.id_ is null 
     group by nd.id_,nd.processdefinition_);
     
     DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);  
     

insert into #ESQUEMA_MASTER#.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_) 
      select #ESQUEMA_MASTER#.hibernate_sequence.nextval id_, 'paralizarTareas' name_, pd processdefinition_, nd from_, nd to_, (max_fromindex + 1) fromindex_ 
      from ( 
      select nd.id_ nd, nd.processdefinition_ pd, max(aux.fromindex_) max_fromindex 
      from #ESQUEMA#.tar_tareas_notificaciones tar 
          join #ESQUEMA#.tex_tarea_externa tex on tar.tar_id = tex.tar_id 
          join #ESQUEMA#.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id 
          join #ESQUEMA#.prc_procedimientos prc on tar.prc_id = prc.prc_id 
          join #ESQUEMA_MASTER#.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_ 
          join #ESQUEMA_MASTER#.jbpm_token tk on pi.roottoken_ = tk.id_ 
          join #ESQUEMA_MASTER#.jbpm_node nd on tk.node_ = nd.id_  and nd.class_ <> 'F' 
          left join #ESQUEMA_MASTER#.jbpm_transition aux on nd.id_ = aux.from_ 
          left join #ESQUEMA_MASTER#.jbpm_transition tr on nd.id_ = tr.from_ and tr.name_ = 'paralizarTareas' 
      where tar.borrado = 0 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) and tar.prc_id is not null 
          and tr.id_ is null 
      group by nd.id_,nd.processdefinition_);

     DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);  
 

insert into #ESQUEMA_MASTER#.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_) 
      select #ESQUEMA_MASTER#.hibernate_sequence.nextval id_, 'activarTareas' name_, pd processdefinition_, nd from_, nd to_, (max_fromindex + 1) fromindex_ 
      from ( 
      select nd.id_ nd, nd.processdefinition_ pd, max(aux.fromindex_) max_fromindex 
      from #ESQUEMA#.tar_tareas_notificaciones tar 
          join #ESQUEMA#.tex_tarea_externa tex on tar.tar_id = tex.tar_id 
          join #ESQUEMA#.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id 
          join #ESQUEMA#.prc_procedimientos prc on tar.prc_id = prc.prc_id 
          join #ESQUEMA_MASTER#.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_ 
          join #ESQUEMA_MASTER#.jbpm_token tk on pi.roottoken_ = tk.id_ 
          join #ESQUEMA_MASTER#.jbpm_node nd on tk.node_ = nd.id_ and nd.class_ <> 'F' 
          left join #ESQUEMA_MASTER#.jbpm_transition aux on nd.id_ = aux.from_ 
          left join #ESQUEMA_MASTER#.jbpm_transition tr on nd.id_ = tr.from_ and tr.name_ = 'activarTareas' 
      where tar.borrado = 0 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) and tar.prc_id is not null 
          and tr.id_ is null 
      group by nd.id_,nd.processdefinition_);

      DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);  
      

insert into #ESQUEMA_MASTER#.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_) 
       select #ESQUEMA_MASTER#.hibernate_sequence.nextval id_, 'activarAlerta' name_, pd processdefinition_, nd from_, nd to_, (max_fromindex + 1) fromindex_ 
       from ( 
       select nd.id_ nd, nd.processdefinition_ pd, max(aux.fromindex_) max_fromindex 
       from #ESQUEMA#.tar_tareas_notificaciones tar 
           join #ESQUEMA#.tex_tarea_externa tex on tar.tar_id = tex.tar_id 
           join #ESQUEMA#.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id and DD_TPO_ID_BPM is null 
           join #ESQUEMA#.prc_procedimientos prc on tar.prc_id = prc.prc_id 
           join #ESQUEMA_MASTER#.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_ 
           join #ESQUEMA_MASTER#.jbpm_token tk on pi.roottoken_ = tk.id_ 
           join #ESQUEMA_MASTER#.jbpm_node nd on tk.node_ = nd.id_ and nd.class_ <> 'F' 
           left join #ESQUEMA_MASTER#.jbpm_transition aux on nd.id_ = aux.from_ 
           left join #ESQUEMA_MASTER#.jbpm_transition tr on nd.id_ = tr.from_ and tr.name_ = 'activarAlerta' 
       where tar.borrado = 0 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) and tar.prc_id is not null 
           and tr.id_ is null 
       group by nd.id_,nd.processdefinition_);
  
  
   DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);  
   
   
     
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
