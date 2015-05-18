

--CONSULTA 2 : Consultar nodo al que apunta el expediente

select exp.exp_id, exp.EXP_PROCESS_BPM, node.name_, token.id_ token_id, token.end_
from exp_expedientes exp inner join
     BANKMASTER.JBPM_PROCESSINSTANCE processinstance on processinstance.id_ = exp.EXP_PROCESS_BPM inner join 
     BANKMASTER.jbpm_token token on token.PROCESSINSTANCE_ = processinstance.id_ inner join
     BANKMASTER.JBPM_NODE node on node.id_ = token.NODE_
where exp.exp_id  in (select exp_id from TMP_EXPID_TAPID_RECOBRO)
and node.name_ like '%nodoEspera%';








-- CONSULTAS ORIGINALES

--CONSULTA 1
--Comprobamos que para el contrato actual tiene como dias vencimiento los dñias que hemos indicado
select prc.prc_id, prc.prc_process_bpm, cnt.cnt_id, cnt.CNT_FECHA_VENC, trunc(cnt.CNT_FECHA_VENC) - trunc(sysdate) dias_hasta_vencimiento
from prc_procedimientos prc inner join
     prc_cex pcex on pcex.prc_id = prc.prc_id inner join
     cex_contratos_expediente cex on cex.cex_id = pcex.cex_id inner join
     cnt_contratos cnt on cnt.cnt_id = cex.cnt_id 
where prc.prc_id in (select * from tmp_prc_para_demo_90);

-- actualizar fecha de vencimiento del contrato 
--Con este update seteamos los días de vencimiento. De acuerdo al groovy, los valores son los siguientes:
-- x y 91 dias --> no pasa nada
-- 90 y 61 dias --> se lanza mas2, se cancela tareas pendientes y avanzaTareaExterna
-- 60 y 31 dias --> se lanza mas3, se cancela tareas pendientes y avanzaTareaExterna
-- 30 y 0 dias --> se lanza nodoVencido, se cancela tareas pendiente y avanzaTareaExterna
update cnt_contratos cnt set cnt.CNT_FECHA_VENC = sysdate + 90
where cnt.cnt_id in (
select cnt.cnt_id
from prc_procedimientos prc inner join
     prc_cex pcex on pcex.prc_id = prc.prc_id inner join
     cex_contratos_expediente cex on cex.cex_id = pcex.cex_id inner join
     cnt_contratos cnt on cnt.cnt_id = cex.cnt_id 
where prc.prc_id  in (select * from tmp_prc_para_demo_90);

commit;

--CONSULTA 2
-- consultar nodo al que apunta el procedimiento
select prc.prc_id, prc.PRC_PROCESS_BPM, node.name_, token.id_ token_id, token.end_
from prc_procedimientos prc inner join
     BANKMASTER.JBPM_PROCESSINSTANCE processinstance on processinstance.id_ = prc.PRC_PROCESS_BPM inner join 
     BANKMASTER.jbpm_token token on token.PROCESSINSTANCE_ = processinstance.id_ inner join
     BANKMASTER.JBPM_NODE node on node.id_ = token.NODE_
where prc.prc_id  in (select * from tmp_prc_para_demo_90)
and node.name_ like '%nodoEspera%';


-- insertar transición
--Con este script forzamos al batch a trabajar.
--Hay que poner el TOKEN_ID de la CONSULTA 2
insert into BANKMASTER.jbpm_job (ID_, CLASS_, VERSION_, DUEDATE_, TASKINSTANCE_, ISSUSPENDED_, ISEXCLUSIVE_,
    LOCKOWNER_, LOCKTIME_, EXCEPTION_, RETRIES_, NAME_, REPEAT_, TRANSITIONNAME_, ACTION_, GRAPHELEMENTTYPE_, GRAPHELEMENT_, NODE_, PROCESSINSTANCE_, TOKEN_) 
select BANKMASTER.hibernate_sequence.nextval, 'T', 0, sysdate - 2, null, 0, 1, null, null, null, 1, 
 'TIMER_MANUAL_GI', null, 'avanzaBPM', null, null, null, null, tmp.pid, tmp.tid
from (
    select processinstance.id_ pid, token.id_ tid
    from prc_procedimientos prc inner join
         BANKMASTER.JBPM_PROCESSINSTANCE processinstance on processinstance.id_ = prc.PRC_PROCESS_BPM inner join 
         BANKMASTER.jbpm_token token on token.PROCESSINSTANCE_ = processinstance.id_ 
    where token.id_ in (select token.id_
from prc_procedimientos prc inner join
     BANKMASTER.JBPM_PROCESSINSTANCE processinstance on processinstance.id_ = prc.PRC_PROCESS_BPM inner join 
     BANKMASTER.jbpm_token token on token.PROCESSINSTANCE_ = processinstance.id_ inner join
     BANKMASTER.JBPM_NODE node on node.id_ = token.NODE_
where prc.prc_id  in (select * from tmp_prc_para_demo_90)
and node.name_ like '%nodoEspera%')            
) tmp;

commit;

--Si somos rapidos, podemos llegar a ver el job antes de ser ejecutado por el batch
select *
from BANKMASTER.jbpm_job
where NAME_ = 'TIMER_MANUAL_GI';

--Eliminamos todo rastro de jobs (no es necesario en caso de ir bien)
--delete from  BANKMASTER.jbpm_job where NAME_ = 'TIMER_MANUAL_GI';

commit;




/*******************************************************/
/******HASTA AQUI TODO LO IMPORTANTE *******************/
/*******************************************************/
select prc.prc_id, prc.PRC_PROCESS_BPM, node.name_, token.id_ token_id, token.end_
from prc_procedimientos prc inner join
     BANKMASTER.JBPM_PROCESSINSTANCE processinstance on processinstance.id_ = prc.PRC_PROCESS_BPM inner join 
     BANKMASTER.jbpm_token token on token.PROCESSINSTANCE_ = processinstance.id_ inner join
     BANKMASTER.JBPM_NODE node on node.id_ = token.NODE_ inner join
     
where prc.prc_id = 10000000592317



select tk.*, nd.*
from prc_procedimientos prc inner join
     BANKMASTER.jbpm_processinstance pi on pi.id_ = prc.PRC_PROCESS_BPM inner join
     BANKMASTER.jbpm_token tk on tk.PROCESSINSTANCE_ = pi.id_ inner join
     BANKMASTER.jbpm_node nd on nd.ID_ = tk.NODE_
where   prc.asu_id = 10000000363107

-- procedimientos de gestion interna 

select prcc.prc_id, usu.usu_username
from asu_asuntos asu left join
     prc_procedimientos prcc on prcc.asu_id = asu.asu_id /*and prcc.DD_TPO_ID not in (341, 641, 642, 643, 40)*/left join
     dd_tpo_tipo_procedimiento tpo on tpo.dd_tpo_id = prcc.dd_tpo_id left join
     GAA_GESTOR_ADICIONAL_ASUNTO gaa_d on gaa_d.asu_id = asu.asu_id and gaa_d.DD_TGE_ID = 2 left join
     usd_usuarios_despachos usd_d on usd_d.USD_ID = gaa_d.USD_ID left join
     des_despacho_externo des on des.des_id = usd_d.des_id left join
     GAA_GESTOR_ADICIONAL_ASUNTO gaa_s on gaa_s.asu_id = asu.asu_id and gaa_s.DD_TGE_ID = 3 left join
     usd_usuarios_despachos usd_s on usd_s.USD_ID = gaa_s.USD_ID left join
     BANKMASTER.usu_usuarios usu on usu.usu_id = usd_s.usu_id left join 
     prc_cex pcex on pcex.prc_id = prcc.prc_id 
where asu.DD_TAS_ID = 3
and prc_process_bpm is not null


select distinct prc.prc_id, prc.PRC_PROCESS_BPM, node.name_
from prc_procedimientos prc inner join
     BANKMASTER.JBPM_PROCESSINSTANCE processinstance on processinstance.id_ = prc.PRC_PROCESS_BPM inner join 
     BANKMASTER.jbpm_token token on token.PROCESSINSTANCE_ = processinstance.id_ inner join
     BANKMASTER.JBPM_NODE node on node.id_ = token.NODE_
where node.name_ = 'P199_nodoEspera1wait'