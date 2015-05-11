Insert into BANKMASTER.DD_TDE_TIPO_DESPACHO 
(DD_TDE_ID,DD_TDE_CODIGO,DD_TDE_DESCRIPCION,DD_TDE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values 
(S_DD_TDE_TIPO_DESPACHO.nextval,'GPA','Gestoría para adjudicación','Gestoría para adjudicación','0','DD',sysdate,null,null,null,null,'0');


Insert into BANKMASTER.DD_TDE_TIPO_DESPACHO 
(DD_TDE_ID,DD_TDE_CODIGO,DD_TDE_DESCRIPCION,DD_TDE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values 
(S_DD_TDE_TIPO_DESPACHO.nextval,'GPS','Gestoría para saneamiento','Gestoría para saneamiento','0','DD',sysdate,null,null,null,null,'0');









Insert into BANKMASTER.DD_TGE_TIPO_GESTOR (DD_TGE_ID,DD_TGE_CODIGO,DD_TGE_DESCRIPCION,DD_TGE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DD_TGE_EDITABLE_WEB) values (BANKMASTER.S_DD_TGE_TIPO_GESTOR.nextval,'GGADJ','Gestor gestoría adjudicación','Gestor gestoría adjudicación','0','DD',sysdate,null,null,null,null,'0','1');

Insert into BANKMASTER.DD_TGE_TIPO_GESTOR (DD_TGE_ID,DD_TGE_CODIGO,DD_TGE_DESCRIPCION,DD_TGE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DD_TGE_EDITABLE_WEB) values (BANKMASTER.S_DD_TGE_TIPO_GESTOR.nextval,'GGSAN','Gestor gestoría saneamiento','Gestor gestoría saneamiento','0','DD',sysdate,null,null,null,null,'0','1');

Insert into BANKMASTER.DD_TGE_TIPO_GESTOR (DD_TGE_ID,DD_TGE_CODIGO,DD_TGE_DESCRIPCION,DD_TGE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DD_TGE_EDITABLE_WEB) values (BANKMASTER.S_DD_TGE_TIPO_GESTOR.nextval,'SGADJ','Supervisor gestoría adjudicación','Supervisor gestoría adjudicación','0','DD',sysdate,null,null,null,null,'0','1');

Insert into BANKMASTER.DD_TGE_TIPO_GESTOR (DD_TGE_ID,DD_TGE_CODIGO,DD_TGE_DESCRIPCION,DD_TGE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DD_TGE_EDITABLE_WEB) values (BANKMASTER.S_DD_TGE_TIPO_GESTOR.nextval,'SGSAN','Supervisor gestoría saneamiento','Supervisor gestoría saneamiento','0','DD',sysdate,null,null,null,null,'0','1');





insert into BANKMASTER.dd_sta_subtipo_tarea_base (
dd_sta_id,
dd_tar_id,
dd_sta_codigo,
dd_sta_descripcion,
dd_sta_descripcion_larga,
version,
usuariocrear,
fechacrear,
borrado,
dd_tge_id,
dtype
) values (
BANKMASTER.s_dd_sta_subtipo_tarea_base.nextval,
1,
'100',
'Tarea externa',
'Tarea externa (Gestor gestoria adjudicacion)',
0,
'DD',
sysdate,
0,
(select dd_tge_id from BANKMASTER.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO='GGADJ'),
'EXTSubtipoTarea'
);

insert into BANKMASTER.dd_sta_subtipo_tarea_base (
dd_sta_id,
dd_tar_id,
dd_sta_codigo,
dd_sta_descripcion,
dd_sta_descripcion_larga,
version,
usuariocrear,
fechacrear,
borrado,
dd_tge_id,
dtype
) values (
BANKMASTER.s_dd_sta_subtipo_tarea_base.nextval,
1,
'101',
'Tarea externa',
'Tarea externa (Gestor gestoria saneamiento)',
0,
'DD',
sysdate,
0,
(select dd_tge_id from BANKMASTER.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO='GGSAN'),
'EXTSubtipoTarea'
);

insert into BANKMASTER.dd_sta_subtipo_tarea_base (
dd_sta_id,
dd_tar_id,
dd_sta_codigo,
dd_sta_descripcion,
dd_sta_descripcion_larga,
version,
usuariocrear,
fechacrear,
borrado,
dd_tge_id,
dtype
) values (
BANKMASTER.s_dd_sta_subtipo_tarea_base.nextval,
1,
'102',
'Tarea externa',
'Tarea externa (Supervisor gestoria adjudicacion)',
0,
'DD',
sysdate,
0,
(select dd_tge_id from BANKMASTER.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO='SGADJ'),
'EXTSubtipoTarea'
);

insert into BANKMASTER.dd_sta_subtipo_tarea_base (
dd_sta_id,
dd_tar_id,
dd_sta_codigo,
dd_sta_descripcion,
dd_sta_descripcion_larga,
version,
usuariocrear,
fechacrear,
borrado,
dd_tge_id,
dtype
) values (
BANKMASTER.s_dd_sta_subtipo_tarea_base.nextval,
1,
'103',
'Tarea externa',
'Tarea externa (Supervisor gestoria saneamiento)',
0,
'DD',
sysdate,
0,
(select dd_tge_id from BANKMASTER.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO='SGSAN'),
'EXTSubtipoTarea'
);

update BANKMASTER.dd_sta_subtipo_tarea_base set dd_sta_id=103, dd_sta_codigo=103 where dd_sta_descripcion_larga='Tarea externa (Supervisor gestoria saneamiento)';
update BANKMASTER.dd_sta_subtipo_tarea_base set dd_sta_id=102, dd_sta_codigo=102 where dd_sta_descripcion_larga='Tarea externa (Supervisor gestoria adjudicacion)';
update BANKMASTER.dd_sta_subtipo_tarea_base set dd_sta_id=101, dd_sta_codigo=101 where dd_sta_descripcion_larga='Tarea externa (Gestor gestoria saneamiento)';
update BANKMASTER.dd_sta_subtipo_tarea_base set dd_sta_id=100, dd_sta_codigo=100 where dd_sta_descripcion_larga='Tarea externa (Gestor gestoria adjudicacion)';
