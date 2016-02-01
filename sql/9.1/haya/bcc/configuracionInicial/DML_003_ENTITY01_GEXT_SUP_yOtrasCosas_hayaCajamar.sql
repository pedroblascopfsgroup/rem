-- actualizar GAA y GAH, en la sigueinte migraci�n si se ejecuta la nueva versi�n de la carterizaci�n estops updates no ser�an necesarios.

update des_despacho_externo set dd_tde_id = (select dd_tde_id from hayamaster.dd_tde_tipo_despacho where dd_tde_codigo = 'D-SUCONGE'), usuariomodificar = 'SAG', fechamodificar = sysdate
where des_despacho = 'Despacho Supervisor contencioso gesti�n';

update  haya02.GAA_GESTOR_ADICIONAL_ASUNTO set dd_tge_id = (select dd_tge_id from hayamaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GEXT'), usuariomodificar = 'SAG', fechamodificar = sysdate
where dd_tge_id = (select dd_tge_id from hayamaster.dd_tge_tipo_gestor where dd_tge_codigo = 'CJ-LETR') ;

update  haya02.GAH_GESTOR_ADICIONAL_HISTORICO set GAH_TIPO_GESTOR_ID = (select dd_tge_id from hayamaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GEXT'), usuariomodificar = 'SAG', fechamodificar = sysdate
where GAH_TIPO_GESTOR_ID = (select dd_tge_id from hayamaster.dd_tge_tipo_gestor where dd_tge_codigo = 'CJ-LETR');

update  haya02.GAA_GESTOR_ADICIONAL_ASUNTO set dd_tge_id = (select dd_tge_id from hayamaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUP'), usuariomodificar = 'SAG', fechamodificar = sysdate
where dd_tge_id = (select dd_tge_id from hayamaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUCONGE');

update  haya02.GAH_GESTOR_ADICIONAL_HISTORICO set GAH_TIPO_GESTOR_ID = (select dd_tge_id from hayamaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUP'), usuariomodificar = 'SAG', fechamodificar = sysdate
where GAH_TIPO_GESTOR_ID = (select dd_tge_id from hayamaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUCONGE');