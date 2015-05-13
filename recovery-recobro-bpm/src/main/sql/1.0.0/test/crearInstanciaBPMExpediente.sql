-- GENERAMOS UNA INSTANCIA DEL PROCEDIMIENTO DE RECOBRO A LOS NUEVOS EXPEDIENTES Y A TODOS LOS EXPEDIENTES REAQUETIPADOS  

-- CREAMOS LA TABLA TMP_PRCID_TAPID_RECOBRO EN CASO DE QUE NO EXISTA

declare
nCount NUMBER;
v_sql LONG;
begin
SELECT count(*) into nCount FROM all_tables where table_name = 'TMP_EXPID_TAPID_RECOBRO';
IF(nCount = 0)
THEN
v_sql:='create table TMP_EXPID_TAPID_RECOBRO (EXP_ID NUMBER(16,0), TAP_ID NUMBER(16,0), FECHA_PROCESO NUMBER(8,0))';
execute immediate v_sql;
END IF;
end;			

/

-- BORRAMOS SU CONTENIDO

delete from TMP_EXPID_TAPID_RECOBRO;

-- CARGAMOS LA TABLA TMP_EXPID_TAPID_RECOBRO CON LOS NUEVOS EXPEDIENTES MÁS TODOS LOS EXPEDIENTES REAQUETIPADOS (EXTINCIÓN Y MARCADO)

INSERT INTO BANK01.TMP_EXPID_TAPID_RECOBRO (EXP_ID, TAP_ID, FECHA_PROCESO)
(SELECT SAL.EXP_ID, 
		(SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO = 'P100_nodoInicioPorSQL') AS TAP_ID,
		 to_number(to_char(trunc(sysdate),'YYYYMMDD')) AS FECHA_PROCESO
FROM BATCH_DATOS_SALIDA SAL)
UNION
(SELECT EXT.EXP_ID, 
		(SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO = 'P100_nodoInicioPorSQL') AS TAP_ID,
		 to_number(to_char(trunc(sysdate),'YYYYMMDD')) AS FECHA_PROCESO
FROM TMP_REC_EXP_EXTINCION_RA EXT)
UNION
(SELECT MAR.EXP_ID, 
		(SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO = 'P100_nodoInicioPorSQL') AS TAP_ID,
		 to_number(to_char(trunc(sysdate),'YYYYMMDD')) AS FECHA_PROCESO
FROM TMP_REC_EXP_MARCADO_RA MAR);

-- BORRAMOS LA TABLA TMP_BANKIARECOBRO_BPM_INPUT

drop table tmp_bankiarecobro_bpm_input;

-- CREAMOS LA TABLA TMP_BANKIARECOBRO_BPM_INPUT

create table tmp_bankiarecobro_bpm_input as (SELECT EXP_ID, TAP_ID from TMP_EXPID_TAPID_RECOBRO);

-- AÑADIMOS LA COLUMNA REFERENCIA A LA TABLA TMP_BANKIARECOBRO_BPM_INPUT

alter table tmp_bankiarecobro_bpm_input add t_referencia number(16);

-- AÑADIMOS LA COLUMNA REFERENCIA A LA TABLA JBPM_TOKEN

alter table bankmaster.jbpm_token add t_referencia number(16);

-- AÑADIMOS LA COLUMNA REFERENCIA A LA TABLA JBPM_PROCESSINSTANCE

alter table bankmaster.jbpm_processinstance add t_referencia number(16);

-- ACTUALIZAMOS EL VALOR DE LA COLUMNA REFERENCIA DE LA TABLA TMP_BANKIARECOBRO_BPM_INPUT

update tmp_bankiarecobro_bpm_input set t_referencia = rownum;

-- INSERTAMOS LAS NUEVAS INSTANCIAS EN LA TABLA JBPM_PROCESSINSTANCE

Insert into BANKMASTER.JBPM_PROCESSINSTANCE
   (ID_, VERSION_, START_, END_, ISSUSPENDED_, PROCESSDEFINITION_,t_referencia)   
select BANKMASTER.HIBERNATE_SEQUENCE.nextval
,1 VERSION_
, SYSDATE START_
,NULL END_
, 0 issuspended_
, maxpd.id_ PROCESSDEFINITION_
, tmp.t_referencia
from tmp_bankiarecobro_bpm_input tmp
    join tap_tarea_procedimiento tap on tmp.tap_id = tap.tap_id    
    join dd_tpo_tipo_procedimiento tpo on tap.dd_tpo_id = tpo.dd_tpo_id
    join (select name_, max(id_) id_ from bankmaster.jbpm_processdefinition group by name_) maxpd on tpo.dd_tpo_xml_jbpm = maxpd.name_;

-- ACTUALIZAMOS LOS IDS DE LOS BPM DE LOS EXPEDIENTES NUEVOS MÄS LOS QUE HAYAN ENTRADO EN REARQUETIPACION    

MERGE INTO EXP_EXPEDIENTES EXP
USING 
	(SELECT TMP.EXP_ID, PI.id_
  	FROM TMP_BANKIARECOBRO_BPM_INPUT TMP
  	JOIN BANKMASTER.JBPM_PROCESSINSTANCE PI on TMP.T_REFERENCIA = PI.T_REFERENCIA
  	) OBJ ON (OBJ.EXP_ID = EXP.EXP_ID)
WHEN MATCHED THEN UPDATE 
    SET EXP.EXP_PROCESS_BPM = OBJ.id_,
    	USUARIOMODIFICAR = 'BATCH-REC',
		FECHAMODIFICAR = SYSDATE;  
    
-- INSERTAMOS LAS NUEVAS TOKENS    
		
Insert into bankmaster.JBPM_TOKEN
   (ID_, VERSION_, START_, END_, NODEENTER_, ISSUSPENDED_, NODE_, PROCESSINSTANCE_, t_referencia)   
select bankmaster.hibernate_sequence.nextval
, 1 VERSION_
, SYSDATE START_
, null end_
, sysdate nodeenter_
, 0 issuspended_
, node.id_ node_
, pi.id_ processinstance_
, tmp.t_referencia
from tmp_bankiarecobro_bpm_input tmp
    join tap_tarea_procedimiento tap on tmp.tap_id = tap.tap_id    
    join dd_tpo_tipo_procedimiento tpo on (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P100') = tpo.dd_tpo_id
    join (select name_, max(id_) id_ from bankmaster.jbpm_processdefinition group by name_) maxpd on tpo.dd_tpo_xml_jbpm = maxpd.name_
    join bankmaster.jbpm_node node on maxpd.id_ = node.processdefinition_ and tap.tap_codigo = node.name_
    join bankmaster.jbpm_processinstance pi on tmp.t_referencia = pi.t_referencia;

-- ACTUALIZAMOS LOS TOKENS DE LAS NUEVAS INSTANCIAS DE LOS PROCEDIMIENTOS DE RECOBRO    

    MERGE INTO BANKMASTER.JBPM_PROCESSINSTANCE PI
USING 
	(SELECT TK.id_, TK.T_REFERENCIA
  	FROM BANKMASTER.JBPM_TOKEN TK
  	) OBJ ON (OBJ.T_REFERENCIA = PI.T_REFERENCIA)
WHEN MATCHED THEN UPDATE 
    SET PI.roottoken_ = OBJ.id_;  

-- INSERTAMOS LAS INSTANCIAS DE LOS MODULOS    
    
Insert into BANKMASTER.JBPM_MODULEINSTANCE
   (ID_, CLASS_, VERSION_, PROCESSINSTANCE_, NAME_)
select BANKMASTER.hibernate_sequence.nextval
, 'C' class_
, 0 version_
, exp.exp_process_bpm processinstance_
, 'org.jbpm.context.exe.ContextInstance' name_
from exp_expedientes exp
    join tmp_bankiarecobro_bpm_input ug on ug.exp_id=exp.exp_id
    join BANKMASTER.jbpm_processinstance pi on exp.exp_process_bpm = pi.id_
    join BANKMASTER.jbpm_token tk on pi.roottoken_ = tk.id_
    join BANKMASTER.jbpm_node nd on tk.node_ = nd.id_
where not exists (
    select * from BANKMASTER.JBPM_MODULEINSTANCE where processinstance_ = exp.exp_process_bpm
);    
    
-- INSERTAMOS LOS MAPAS DE VARIABLES    

Insert into bankmaster.JBPM_TOKENVARIABLEMAP 
   (ID_, VERSION_, TOKEN_, CONTEXTINSTANCE_)
select bankmaster.hibernate_sequence.nextval
, 0 version_
, pi.roottoken_
, mi.id_  contextinstance_
from exp_expedientes exp
    join tmp_bankiarecobro_bpm_input ug on ug.exp_id=exp.exp_id
    join bankmaster.jbpm_processinstance pi on exp.exp_process_bpm = pi.id_
    join bankmaster.JBPM_MODULEINSTANCE mi on pi.id_ = mi.processinstance_
    join bankmaster.jbpm_token tk on pi.roottoken_ = tk.id_
    join bankmaster.jbpm_node nd on tk.node_ = nd.id_
where not exists (select * from bankmaster.JBPM_TOKENVARIABLEMAP where token_ = pi.roottoken_);

-- INSERTAMOS LAS INSTANCIAS DE LAS VARIABLES DE TIPO DB_ID

Insert into bankmaster.JBPM_VARIABLEINSTANCE
   (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)
select bankmaster.hibernate_sequence.nextval
,'L' class_
, 0 version_ 
, 'DB_ID' name_
, pi.roottoken_ tokem_
, vm.id_ tokenvariablemap_
, pi.id_ processinstance_
, 1 longvlaue_
from exp_expedientes exp
    join tmp_bankiarecobro_bpm_input ug on ug.exp_id=exp.exp_id
    join bankmaster.jbpm_processinstance pi on exp.exp_process_bpm = pi.id_
    join bankmaster.JBPM_TOKENVARIABLEMAP vm on pi.roottoken_ = vm.token_
    join bankmaster.jbpm_token tk on pi.roottoken_ = tk.id_
    join bankmaster.jbpm_node nd on tk.node_ = nd.id_
where not exists (select * from bankmaster.JBPM_VARIABLEINSTANCE where processinstance_ = pi.id_ and name_ = 'DB_ID');
   
-- INSERTAMOS LAS INSTANCIAS DE LAS VARIABLES DE TIPO procedimientoTareaExterna

Insert into bankmaster.JBPM_VARIABLEINSTANCE
   (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)
select bankmaster.hibernate_sequence.nextval
,'L' class_
, 0 version_ 
, 'idExpediente' name_
, pi.roottoken_ tokem_
, vm.id_ tokenvariablemap_
, pi.id_ processinstance_
, exp.exp_id longvlaue_
from exp_expedientes exp
    join tmp_bankiarecobro_bpm_input ug on ug.exp_id=exp.exp_id
    join bankmaster.jbpm_processinstance pi on exp.exp_process_bpm = pi.id_
    join bankmaster.JBPM_TOKENVARIABLEMAP vm on pi.roottoken_ = vm.token_
    join bankmaster.jbpm_token tk on pi.roottoken_ = tk.id_
    join bankmaster.jbpm_node nd on tk.node_ = nd.id_
where not exists (select * from bankmaster.JBPM_VARIABLEINSTANCE where processinstance_ = pi.id_ and name_ = 'procedimientoTareaExterna');
    
-- INSERTAMOS LAS INSTANCIAS DE LAS VARIABLES DE TIPO bpmParalizado

Insert into bankmaster.JBPM_VARIABLEINSTANCE
   (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)
select bankmaster.hibernate_sequence.nextval
,'L' class_
, 0 version_ 
, 'bpmParalizado' name_
, pi.roottoken_ tokem_
, vm.id_ tokenvariablemap_
, pi.id_ processinstance_
, 0 longvlaue_
from exp_expedientes exp
    join tmp_bankiarecobro_bpm_input ug on ug.exp_id=exp.exp_id
    join bankmaster.jbpm_processinstance pi on exp.exp_process_bpm = pi.id_
    join bankmaster.JBPM_TOKENVARIABLEMAP vm on pi.roottoken_ = vm.token_
    join bankmaster.jbpm_token tk on pi.roottoken_ = tk.id_
    join bankmaster.jbpm_node nd on tk.node_ = nd.id_
where not exists (select * from bankmaster.JBPM_VARIABLEINSTANCE where processinstance_ = pi.id_ and name_ = 'bpmParalizado');

-- INSERTAMOS LAS INSTANCIAS DE LAS VARIABLES DE TIPO id

Insert into bankmaster.JBPM_VARIABLEINSTANCE
   (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)
select bankmaster.hibernate_sequence.nextval
,'L' class_
, 0 version_ 
, 'id'||nd.name_ name_
, pi.roottoken_ tokem_
, vm.id_ tokenvariablemap_
, pi.id_ processinstance_
, null --tex.tex_id longvlaue_
from exp_expedientes exp
    join tmp_bankiarecobro_bpm_input ug on ug.exp_id=exp.exp_id
    join bankmaster.jbpm_processinstance pi on exp.exp_process_bpm = pi.id_
    join bankmaster.jbpm_token tk on pi.roottoken_ = tk.id_
    join bankmaster.jbpm_node nd on tk.node_ = nd.id_
    join bankmaster.JBPM_TOKENVARIABLEMAP vm on pi.roottoken_ = vm.token_
where not exists (select * from bankmaster.JBPM_VARIABLEINSTANCE where processinstance_ = pi.id_ and name_ = 'id'||nd.name_);

-- ACTUALIZAMOS LOS TOKENS

update bankmaster.jbpm_token set nextlogindex_ = 0 where nextlogindex_ is null;
update bankmaster.jbpm_token set isabletoreactivateparent_ = 0 where isabletoreactivateparent_ is null;
update bankmaster.jbpm_token set isterminationimplicit_ = 0 where isterminationimplicit_ is null;

-- INSERTAR TIMERS CADUCADOS

insert into bankmaster.jbpm_job (ID_, CLASS_, VERSION_, DUEDATE_, TASKINSTANCE_, ISSUSPENDED_, ISEXCLUSIVE_,
    LOCKOWNER_, LOCKTIME_, EXCEPTION_, RETRIES_, NAME_, REPEAT_, TRANSITIONNAME_, ACTION_, GRAPHELEMENTTYPE_, GRAPHELEMENT_, NODE_, PROCESSINSTANCE_, TOKEN_) 
    select bankmaster.hibernate_sequence.nextval, 'T', 0, sysdate - 2, null, 0, 1, null, null, null, 1,'TIMER_INI_REC', null, 'avanzaBPM', null, null, null, null, tmp.*
    from (
        select pi_id, token
        from (select processinstance.id_ pi_id, token.id_ token
                from exp_expedientes exp
    				INNER JOIN tmp_bankiarecobro_bpm_input ug on ug.exp_id=exp.exp_id
                    INNER JOIN bankmaster.JBPM_PROCESSINSTANCE processinstance on processinstance.id_ = exp.EXP_PROCESS_BPM 
                    INNER JOIN bankmaster.JBPM_TOKEN token on token.PROCESSINSTANCE_ = processinstance.id_ )     
    ) tmp;

-- BORRAMOS LAS COLUMNAS DE APOYO QUE HEMOS CREADO

alter table tmp_bankiarecobro_bpm_input drop column  t_referencia;
alter table bankmaster.jbpm_token drop column  t_referencia;
alter table bankmaster.jbpm_processinstance drop column  t_referencia;   
    
    

