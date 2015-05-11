
-- etj
--update /*+BYPASS_UJVC*/(
--    select prc.PRC_PROCESS_BPM,ins.PROCESSDEFINITION_ viejo, defin.NAME_,defin.VERSION_, ultima.ulti_version , ultim_proces.ID_ nuevo
--    --prc.prc_id, prc.PRC_PROCESS_BPM, defin.NAME_,defin.VERSION_, ultima.ulti_version 
--from prc_procedimientos prc
--join linmaster.jbpm_processinstance ins on ins.ID_=prc.PRC_PROCESS_BPM
--join linmaster.jbpm_processdefinition defin on defin.ID_=ins.PROCESSDEFINITION_
--join dd_tpo_tipo_procedimiento tpo on tpo.DD_TPO_ID=prc.DD_TPO_ID
--join (select max(version_) ulti_version, name_ from linmaster.jbpm_processdefinition group by name_) ultima on ultima.NAME_=tpo.DD_TPO_XML_JBPM
--join linmaster.jbpm_processdefinition ultim_proces on ultim_proces.VERSION_=ultima.ulti_version and ultim_proces.NAME_=ultima.NAME_
--where tpo.DD_TPO_CODIGO='P72' and defin.VERSION_!=ultima.ulti_version
--) SET viejo=nuevo;

MERGE INTO linmaster.jbpm_processinstance ins
USING (select prc.PRC_PROCESS_BPM, ultim_proces.ID_
        from
        prc_procedimientos prc
        join linmaster.jbpm_processinstance ins on ins.ID_=prc.PRC_PROCESS_BPM
        join linmaster.jbpm_processdefinition defin on defin.ID_=ins.PROCESSDEFINITION_
        join dd_tpo_tipo_procedimiento tpo on tpo.DD_TPO_ID=prc.DD_TPO_ID
        join (select max(version_) ulti_version, name_ from linmaster.jbpm_processdefinition group by name_) ultima on ultima.NAME_=tpo.DD_TPO_XML_JBPM
        join linmaster.jbpm_processdefinition ultim_proces on ultim_proces.VERSION_=ultima.ulti_version and ultim_proces.NAME_=ultima.NAME_
        where tpo.DD_TPO_CODIGO='P72' and defin.VERSION_!=ultima.ulti_version) nuevo
ON (ins.ID_=nuevo.PRC_PROCESS_BPM )
when matched then update
set ins.PROCESSDEFINITION_=nuevo.ID_;

--update /*+BYPASS_UJVC*/(
--select prc.PRC_PROCESS_BPM, ins.ROOTTOKEN_, node.NAME_, defin.VERSION_, defin.NAME_, token.NODE_ antiguo, ultima.ulti_version, ultimo_nodo.ID_ nuevo
--from prc_procedimientos prc
--join linmaster.jbpm_processinstance ins on ins.ID_=prc.PRC_PROCESS_BPM
--join linmaster.jbpm_token token on token.ID_=ins.ROOTTOKEN_
--join linmaster.jbpm_node node on node.ID_=token.NODE_
--join linmaster.jbpm_processdefinition defin on defin.ID_=node.PROCESSDEFINITION_
--join dd_tpo_tipo_procedimiento tpo on tpo.DD_TPO_ID=prc.DD_TPO_ID
--join (select max(version_) ulti_version, name_ from linmaster.jbpm_processdefinition group by name_) ultima on ultima.NAME_=tpo.DD_TPO_XML_JBPM
--join linmaster.jbpm_processdefinition ultim_proces on ultim_proces.VERSION_=ultima.ulti_version and ultim_proces.NAME_=ultima.NAME_
--join linmaster.jbpm_node ultimo_nodo on ultimo_nodo.PROCESSDEFINITION_=ultim_proces.ID_ and ultimo_nodo.NAME_=node.NAME_
--where tpo.DD_TPO_CODIGO='P72' and defin.VERSION_!=ultima.ulti_version
--) SET antiguo=nuevo;

MERGE INTO linmaster.jbpm_token tk
USING (
        select token.ID_ "token", ultimo_nodo.ID_ "nodo"
        from
            prc_procedimientos prc
            join linmaster.jbpm_processinstance ins on ins.ID_=prc.PRC_PROCESS_BPM
            join linmaster.jbpm_token token on token.ID_=ins.ROOTTOKEN_
            join linmaster.jbpm_node node on node.ID_=token.NODE_
            join linmaster.jbpm_processdefinition defin on defin.ID_=node.PROCESSDEFINITION_
            join dd_tpo_tipo_procedimiento tpo on tpo.DD_TPO_ID=prc.DD_TPO_ID
            join (select max(version_) ulti_version, name_ from linmaster.jbpm_processdefinition group by name_) ultima on ultima.NAME_=tpo.DD_TPO_XML_JBPM
            join linmaster.jbpm_processdefinition ultim_proces on ultim_proces.VERSION_=ultima.ulti_version and ultim_proces.NAME_=ultima.NAME_
            join linmaster.jbpm_node ultimo_nodo on ultimo_nodo.PROCESSDEFINITION_=ultim_proces.ID_ and ultimo_nodo.NAME_=node.NAME_
            where tpo.DD_TPO_CODIGO='P72' and defin.VERSION_!=ultima.ulti_version
      ) nuevo
ON (tk.ID_=nuevo."token" )
when matched then update
set tk.NODE_=nuevo."nodo";


--update /*+BYPASS_UJVC*/(
--select prc.PRC_PROCESS_BPM, ins.ROOTTOKEN_, node.NAME_, defin.VERSION_, defin.NAME_, token.NODE_ antiguo, ultima.ulti_version, ultimo_nodo.ID_ nuevo,
--    token.PARENT_
--from prc_procedimientos prc
--join linmaster.jbpm_processinstance ins on ins.ID_=prc.PRC_PROCESS_BPM
--join linmaster.jbpm_token token on token.PARENT_ =ins.ROOTTOKEN_
--join linmaster.jbpm_node node on node.ID_=token.NODE_
--join linmaster.jbpm_processdefinition defin on defin.ID_=node.PROCESSDEFINITION_
--join dd_tpo_tipo_procedimiento tpo on tpo.DD_TPO_ID=prc.DD_TPO_ID
--join (select max(version_) ulti_version, name_ from linmaster.jbpm_processdefinition group by name_) ultima on ultima.NAME_=tpo.DD_TPO_XML_JBPM
--join linmaster.jbpm_processdefinition ultim_proces on ultim_proces.VERSION_=ultima.ulti_version and ultim_proces.NAME_=ultima.NAME_
--join linmaster.jbpm_node ultimo_nodo on ultimo_nodo.PROCESSDEFINITION_=ultim_proces.ID_ and ultimo_nodo.NAME_=node.NAME_
--where tpo.DD_TPO_CODIGO='P72' and defin.VERSION_!=ultima.ulti_version
--) SET antiguo=nuevo;

MERGE INTO linmaster.jbpm_token tk
USING (
        select token.ID_ "token", ultimo_nodo.ID_ "nodo"
        from
            prc_procedimientos prc
            join linmaster.jbpm_processinstance ins on ins.ID_=prc.PRC_PROCESS_BPM
            join linmaster.jbpm_token token on token.PARENT_ =ins.ROOTTOKEN_
            join linmaster.jbpm_node node on node.ID_=token.NODE_
            join linmaster.jbpm_processdefinition defin on defin.ID_=node.PROCESSDEFINITION_
            join dd_tpo_tipo_procedimiento tpo on tpo.DD_TPO_ID=prc.DD_TPO_ID
            join (select max(version_) ulti_version, name_ from linmaster.jbpm_processdefinition group by name_) ultima on ultima.NAME_=tpo.DD_TPO_XML_JBPM
            join linmaster.jbpm_processdefinition ultim_proces on ultim_proces.VERSION_=ultima.ulti_version and ultim_proces.NAME_=ultima.NAME_
            join linmaster.jbpm_node ultimo_nodo on ultimo_nodo.PROCESSDEFINITION_=ultim_proces.ID_ and ultimo_nodo.NAME_=node.NAME_
            where tpo.DD_TPO_CODIGO='P72' and defin.VERSION_!=ultima.ulti_version
      ) nuevo
ON (tk.ID_=nuevo."token" )
when matched then update
set tk.NODE_=nuevo."nodo";


--update /*+BYPASS_UJVC*/(
--select prc.PRC_PROCESS_BPM, ins.ROOTTOKEN_, node.NAME_, defin.VERSION_, defin.NAME_, token.NODE_ antiguo, ultima.ulti_version, ultimo_nodo.ID_ nuevo,
--    token.PARENT_
--from prc_procedimientos prc
--join linmaster.jbpm_processinstance ins on ins.ID_=prc.PRC_PROCESS_BPM
--join linmaster.jbpm_token token_abuelo on token_abuelo.PARENT_ =ins.ROOTTOKEN_
--join linmaster.jbpm_token token on token.PARENT_ =token_abuelo.id_
--join linmaster.jbpm_node node on node.ID_=token.NODE_
--join linmaster.jbpm_processdefinition defin on defin.ID_=node.PROCESSDEFINITION_
--join dd_tpo_tipo_procedimiento tpo on tpo.DD_TPO_ID=prc.DD_TPO_ID
--join (select max(version_) ulti_version, name_ from linmaster.jbpm_processdefinition group by name_) ultima on ultima.NAME_=tpo.DD_TPO_XML_JBPM
--join linmaster.jbpm_processdefinition ultim_proces on ultim_proces.VERSION_=ultima.ulti_version and ultim_proces.NAME_=ultima.NAME_
--join linmaster.jbpm_node ultimo_nodo on ultimo_nodo.PROCESSDEFINITION_=ultim_proces.ID_ and ultimo_nodo.NAME_=node.NAME_
--where tpo.DD_TPO_CODIGO='P72' and defin.VERSION_!=ultima.ulti_version
--) SET antiguo=nuevo;

MERGE INTO linmaster.jbpm_token tk
USING (
        select token.ID_ "token", ultimo_nodo.ID_ "nodo"
        from
            prc_procedimientos prc
            join linmaster.jbpm_processinstance ins on ins.ID_=prc.PRC_PROCESS_BPM
            join linmaster.jbpm_token token_abuelo on token_abuelo.PARENT_ =ins.ROOTTOKEN_
            join linmaster.jbpm_token token on token.PARENT_ =token_abuelo.id_
            join linmaster.jbpm_node node on node.ID_=token.NODE_
            join linmaster.jbpm_processdefinition defin on defin.ID_=node.PROCESSDEFINITION_
            join dd_tpo_tipo_procedimiento tpo on tpo.DD_TPO_ID=prc.DD_TPO_ID
            join (select max(version_) ulti_version, name_ from linmaster.jbpm_processdefinition group by name_) ultima on ultima.NAME_=tpo.DD_TPO_XML_JBPM
            join linmaster.jbpm_processdefinition ultim_proces on ultim_proces.VERSION_=ultima.ulti_version and ultim_proces.NAME_=ultima.NAME_
            join linmaster.jbpm_node ultimo_nodo on ultimo_nodo.PROCESSDEFINITION_=ultim_proces.ID_ and ultimo_nodo.NAME_=node.NAME_
            where tpo.DD_TPO_CODIGO='P72' and defin.VERSION_!=ultima.ulti_version
      ) nuevo
ON (tk.ID_=nuevo."token" )
when matched then update
set tk.NODE_=nuevo."nodo";

commit;