
insert into TGP_TIPO_GESTOR_PROPIEDAD (tgp_id, dd_tge_id, tgp_clave, tgp_valor, usuariocrear, fechacrear)
values (S_TGP_TIPO_GESTOR_PROPIEDAD.nextval, 
    (select dd_tge_id from bankmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GEXT'),
    'DES_VALIDOS',
    (select dd_tde_codigo from bankmaster.dd_tde_tipo_despacho where dd_tde_codigo = '1'),
    'SAG', sysdate);

insert into TGP_TIPO_GESTOR_PROPIEDAD (tgp_id, dd_tge_id, tgp_clave, tgp_valor, usuariocrear, fechacrear)
values (S_TGP_TIPO_GESTOR_PROPIEDAD.nextval, 
    (select dd_tge_id from bankmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GAGER'),
    'DES_VALIDOS',
    (select dd_tde_codigo from bankmaster.dd_tde_tipo_despacho where dd_tde_codigo = 'AGER'),
    'SAG', sysdate);

insert into TGP_TIPO_GESTOR_PROPIEDAD (tgp_id, dd_tge_id, tgp_clave, tgp_valor, usuariocrear, fechacrear)
values (S_TGP_TIPO_GESTOR_PROPIEDAD.nextval, 
    (select dd_tge_id from bankmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SAGER'),
    'DES_VALIDOS',
    (select dd_tde_codigo from bankmaster.dd_tde_tipo_despacho where dd_tde_codigo = 'AGER'),
    'SAG', sysdate);
        
insert into TGP_TIPO_GESTOR_PROPIEDAD (tgp_id, dd_tge_id, tgp_clave, tgp_valor, usuariocrear, fechacrear)
values (S_TGP_TIPO_GESTOR_PROPIEDAD.nextval, 
    (select dd_tge_id from bankmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUP'),
    'DES_VALIDOS',
    (select dd_tde_codigo from bankmaster.dd_tde_tipo_despacho where dd_tde_codigo = '1'),
    'SAG', sysdate);

insert into TGP_TIPO_GESTOR_PROPIEDAD (tgp_id, dd_tge_id, tgp_clave, tgp_valor, usuariocrear, fechacrear)
values (S_TGP_TIPO_GESTOR_PROPIEDAD.nextval, 
    (select dd_tge_id from bankmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'PROC'),
    'DES_VALIDOS',
    (select dd_tde_codigo from bankmaster.dd_tde_tipo_despacho where dd_tde_codigo = '2'),
    'SAG', sysdate);    

insert into TGP_TIPO_GESTOR_PROPIEDAD (tgp_id, dd_tge_id, tgp_clave, tgp_valor, usuariocrear, fechacrear)
values (S_TGP_TIPO_GESTOR_PROPIEDAD.nextval, 
    (select dd_tge_id from bankmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GECEXP'),
    'DES_VALIDOS',
    (select dd_tde_codigo from bankmaster.dd_tde_tipo_despacho where dd_tde_codigo = '3'),
    'SAG', sysdate);    
          
insert into TGP_TIPO_GESTOR_PROPIEDAD (tgp_id, dd_tge_id, tgp_clave, tgp_valor, usuariocrear, fechacrear)
values (S_TGP_TIPO_GESTOR_PROPIEDAD.nextval, 
    (select dd_tge_id from bankmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUPCEXP'),
    'DES_VALIDOS',
    (select dd_tde_codigo from bankmaster.dd_tde_tipo_despacho where dd_tde_codigo = '3'),
    'SAG', sysdate);    

commit;