DELETE FROM tgp_tipo_gestor_propiedad
      WHERE dd_tge_id = (SELECT dd_tge_id
                           FROM bankmaster.dd_tge_tipo_gestor
                          WHERE dd_tge_codigo = 'GEXT')
        AND tgp_valor = (SELECT dd_tde_codigo
                           FROM bankmaster.dd_tde_tipo_despacho
                          WHERE dd_tde_codigo = '1');
                          
                          
DELETE FROM tgp_tipo_gestor_propiedad
      WHERE dd_tge_id = (SELECT dd_tge_id
                           FROM bankmaster.dd_tge_tipo_gestor
                          WHERE dd_tge_codigo = 'GAGER')
        AND tgp_valor = (SELECT dd_tde_codigo
                           FROM bankmaster.dd_tde_tipo_despacho
                          WHERE dd_tde_codigo = 'AGER');
                          
                          
DELETE FROM tgp_tipo_gestor_propiedad
      WHERE dd_tge_id = (SELECT dd_tge_id
                           FROM bankmaster.dd_tge_tipo_gestor
                          WHERE dd_tge_codigo = 'SAGER')
        AND tgp_valor = (SELECT dd_tde_codigo
                           FROM bankmaster.dd_tde_tipo_despacho
                          WHERE dd_tde_codigo = 'AGER');
                          
                          
DELETE FROM tgp_tipo_gestor_propiedad
      WHERE dd_tge_id = (SELECT dd_tge_id
                           FROM bankmaster.dd_tge_tipo_gestor
                          WHERE dd_tge_codigo = 'SUP')
        AND tgp_valor = (SELECT dd_tde_codigo
                           FROM bankmaster.dd_tde_tipo_despacho
                          WHERE dd_tde_codigo = '1');
                          
                          
DELETE FROM tgp_tipo_gestor_propiedad
      WHERE dd_tge_id = (SELECT dd_tge_id
                           FROM bankmaster.dd_tge_tipo_gestor
                          WHERE dd_tge_codigo = 'PROC')
        AND tgp_valor = (SELECT dd_tde_codigo
                           FROM bankmaster.dd_tde_tipo_despacho
                          WHERE dd_tde_codigo = '2');
                          
                          
DELETE FROM tgp_tipo_gestor_propiedad
      WHERE dd_tge_id = (SELECT dd_tge_id
                           FROM bankmaster.dd_tge_tipo_gestor
                          WHERE dd_tge_codigo = 'GECEXP')
        AND tgp_valor = (SELECT dd_tde_codigo
                           FROM bankmaster.dd_tde_tipo_despacho
                          WHERE dd_tde_codigo = '3');

                          
DELETE FROM tgp_tipo_gestor_propiedad
      WHERE dd_tge_id = (SELECT dd_tge_id
                           FROM bankmaster.dd_tge_tipo_gestor
                          WHERE dd_tge_codigo = 'SUPCEXP')
        AND tgp_valor = (SELECT dd_tde_codigo
                           FROM bankmaster.dd_tde_tipo_despacho
                          WHERE dd_tde_codigo = '3');                          

commit;