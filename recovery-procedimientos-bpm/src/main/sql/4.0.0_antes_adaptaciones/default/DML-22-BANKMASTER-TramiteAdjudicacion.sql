Insert into BANKMASTER.DD_TDE_TIPO_DESPACHO 
(DD_TDE_ID,DD_TDE_CODIGO,DD_TDE_DESCRIPCION,DD_TDE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values 
(S_DD_TDE_TIPO_DESPACHO.nextval,'GLL','Gestoría para llaves','Gestoría para llaves','0','DD',sysdate,null,null,null,null,'0');


Insert into BANKMASTER.DD_TDE_TIPO_DESPACHO 
(DD_TDE_ID,DD_TDE_CODIGO,DD_TDE_DESCRIPCION,DD_TDE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values 
(S_DD_TDE_TIPO_DESPACHO.nextval,'GDLL','Gestoría depositaria de llaves','Gestoría depositaria de llaves','0','DD',sysdate,null,null,null,null,'0');









Insert into BANKMASTER.DD_TGE_TIPO_GESTOR (DD_TGE_ID,DD_TGE_CODIGO,DD_TGE_DESCRIPCION,DD_TGE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DD_TGE_EDITABLE_WEB) values (BANKMASTER.S_DD_TGE_TIPO_GESTOR.nextval,'GGLL','Gestor gestoría llaves','Gestor gestoría llaves','0','DD',sysdate,null,null,null,null,'0','1');

Insert into BANKMASTER.DD_TGE_TIPO_GESTOR (DD_TGE_ID,DD_TGE_CODIGO,DD_TGE_DESCRIPCION,DD_TGE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DD_TGE_EDITABLE_WEB) values (BANKMASTER.S_DD_TGE_TIPO_GESTOR.nextval,'GGDLL','Gestor gestoría depositaria llaves','Gestor gestoría depositaria llaves','0','DD',sysdate,null,null,null,null,'0','1');


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
104,
1,
'104',
'Tarea externa',
'Tarea externa (Gestor gestoria llaves)',
0,
'DD',
sysdate,
0,
(select dd_tge_id from BANKMASTER.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO='GGLL'),
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
105,
1,
'105',
'Tarea externa',
'Tarea externa (Gestor gestoria depositaria llaves)',
0,
'DD',
sysdate,
0,
(select dd_tge_id from BANKMASTER.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO='GGDLL'),
'EXTSubtipoTarea'
);