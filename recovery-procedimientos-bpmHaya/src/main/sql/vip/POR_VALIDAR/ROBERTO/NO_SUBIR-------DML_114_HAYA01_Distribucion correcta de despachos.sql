---------------------------------------------------------
-- DISTRIBUCION CORRECTA DE DESPACHOS
---------------------------------------------------------

update USD_USUARIOS_DESPACHOS
set des_id = (select des_id from USD_USUARIOS_DESPACHOS where usu_id = (select usu_id from HAYAMASTER.USU_USUARIOS where BORRADO = 0 and HAYAMASTER.USU_USUARIOS.USU_USERNAME = 'D_UCL_H'))
where usu_id in (select usu_id from HAYAMASTER.USU_USUARIOS where HAYAMASTER.USU_USUARIOS.USU_USERNAME in ('D_UCL_V','D_UCL_H'));

update USD_USUARIOS_DESPACHOS
set des_id = (select des_id from USD_USUARIOS_DESPACHOS where usu_id = (select usu_id from HAYAMASTER.USU_USUARIOS where BORRADO = 0 and HAYAMASTER.USU_USUARIOS.USU_USERNAME = 'S_UCL_H'))
where usu_id in (select usu_id from HAYAMASTER.USU_USUARIOS where HAYAMASTER.USU_USUARIOS.USU_USERNAME in ('S_UCL_V','S_UCL_H'));

update USD_USUARIOS_DESPACHOS
set des_id = (select des_id from USD_USUARIOS_DESPACHOS where usu_id = (select usu_id from HAYAMASTER.USU_USUARIOS where BORRADO = 0 and HAYAMASTER.USU_USUARIOS.USU_USERNAME = 'G_UCL_H'))
where usu_id in (select usu_id from HAYAMASTER.USU_USUARIOS where HAYAMASTER.USU_USUARIOS.USU_USERNAME in ('G_UCL_V','G_UCL_H'));

update USD_USUARIOS_DESPACHOS
set des_id = (select des_id from USD_USUARIOS_DESPACHOS where usu_id = (select usu_id from HAYAMASTER.USU_USUARIOS where BORRADO = 0 and HAYAMASTER.USU_USUARIOS.USU_USERNAME = 'G_SUB_H'))
where usu_id in (select usu_id from HAYAMASTER.USU_USUARIOS where HAYAMASTER.USU_USUARIOS.USU_USERNAME in ('G_SUB_V','G_SUB_H'));

update USD_USUARIOS_DESPACHOS
set des_id = (select des_id from USD_USUARIOS_DESPACHOS where usu_id = (select usu_id from HAYAMASTER.USU_USUARIOS where BORRADO = 0 and HAYAMASTER.USU_USUARIOS.USU_USERNAME = 'S_SUB_H'))
where usu_id in (select usu_id from HAYAMASTER.USU_USUARIOS where HAYAMASTER.USU_USUARIOS.USU_USERNAME in('S_SUB_V','S_SUB_H'));

update USD_USUARIOS_DESPACHOS
set des_id = (select des_id from USD_USUARIOS_DESPACHOS where usu_id = (select usu_id from HAYAMASTER.USU_USUARIOS where BORRADO = 0 and HAYAMASTER.USU_USUARIOS.USU_USERNAME = 'G_DEUDA_H'))
where usu_id in (select usu_id from HAYAMASTER.USU_USUARIOS where HAYAMASTER.USU_USUARIOS.USU_USERNAME in('G_DEUDA_V','G_DEUDA_H'));

update USD_USUARIOS_DESPACHOS
set des_id = (select des_id from USD_USUARIOS_DESPACHOS where usu_id = (select usu_id from HAYAMASTER.USU_USUARIOS where BORRADO = 0 and HAYAMASTER.USU_USUARIOS.USU_USERNAME = 'S_DEUDA_H'))
where usu_id in (select usu_id from HAYAMASTER.USU_USUARIOS where HAYAMASTER.USU_USUARIOS.USU_USERNAME in('S_DEUDA_V','S_DEUDA_H'));

update USD_USUARIOS_DESPACHOS
set des_id = (select des_id from USD_USUARIOS_DESPACHOS where usu_id = (select usu_id from HAYAMASTER.USU_USUARIOS where BORRADO = 0 and HAYAMASTER.USU_USUARIOS.USU_USERNAME = 'G_SOP_H'))
where usu_id in (select usu_id from HAYAMASTER.USU_USUARIOS where HAYAMASTER.USU_USUARIOS.USU_USERNAME in('G_SOP_V','G_SOP_H'));

update USD_USUARIOS_DESPACHOS
set des_id = (select des_id from USD_USUARIOS_DESPACHOS where usu_id = (select usu_id from HAYAMASTER.USU_USUARIOS where BORRADO = 0 and HAYAMASTER.USU_USUARIOS.USU_USERNAME = 'S_SOP_H'))
where usu_id in (select usu_id from HAYAMASTER.USU_USUARIOS where HAYAMASTER.USU_USUARIOS.USU_USERNAME in('S_SOP_V','S_SOP_H'));

update USD_USUARIOS_DESPACHOS
set des_id = (select des_id from USD_USUARIOS_DESPACHOS where usu_id = (select usu_id from HAYAMASTER.USU_USUARIOS where BORRADO = 0 and HAYAMASTER.USU_USUARIOS.USU_USERNAME = 'G_CONT_H'))
where usu_id in (select usu_id from HAYAMASTER.USU_USUARIOS where HAYAMASTER.USU_USUARIOS.USU_USERNAME in('G_CONT_V','G_CONT_H'));

update USD_USUARIOS_DESPACHOS
set des_id = (select des_id from USD_USUARIOS_DESPACHOS where usu_id = (select usu_id from HAYAMASTER.USU_USUARIOS where BORRADO = 0 and HAYAMASTER.USU_USUARIOS.USU_USERNAME = 'S_CONT_H'))
where usu_id in (select usu_id from HAYAMASTER.USU_USUARIOS where HAYAMASTER.USU_USUARIOS.USU_USERNAME in('S_CONT_V','S_CONT_H'));

update USD_USUARIOS_DESPACHOS
set des_id = (select des_id from USD_USUARIOS_DESPACHOS where usu_id = (select usu_id from HAYAMASTER.USU_USUARIOS where BORRADO = 0 and HAYAMASTER.USU_USUARIOS.USU_USERNAME = 'G_FISC_H'))
where usu_id in (select usu_id from HAYAMASTER.USU_USUARIOS where HAYAMASTER.USU_USUARIOS.USU_USERNAME in('G_FISC_V','G_FISC_H'));

update USD_USUARIOS_DESPACHOS
set des_id = (select des_id from USD_USUARIOS_DESPACHOS where usu_id = (select usu_id from HAYAMASTER.USU_USUARIOS where BORRADO = 0 and HAYAMASTER.USU_USUARIOS.USU_USERNAME = 'S_FISC_H'))
where usu_id in (select usu_id from HAYAMASTER.USU_USUARIOS where HAYAMASTER.USU_USUARIOS.USU_USERNAME in('S_FISC_V','S_FISC_H'));

update USD_USUARIOS_DESPACHOS
set des_id = (select des_id from USD_USUARIOS_DESPACHOS where usu_id = (select usu_id from HAYAMASTER.USU_USUARIOS where BORRADO = 0 and HAYAMASTER.USU_USUARIOS.USU_USERNAME = 'G_ADM_H'))
where usu_id in (select usu_id from HAYAMASTER.USU_USUARIOS where HAYAMASTER.USU_USUARIOS.USU_USERNAME in('G_ADM_V','G_ADM_H'));

update USD_USUARIOS_DESPACHOS
set des_id = (select des_id from USD_USUARIOS_DESPACHOS where usu_id = (select usu_id from HAYAMASTER.USU_USUARIOS where BORRADO = 0 and HAYAMASTER.USU_USUARIOS.USU_USERNAME = 'S_ADM_H'))     
where usu_id in (select usu_id from HAYAMASTER.USU_USUARIOS where HAYAMASTER.USU_USUARIOS.USU_USERNAME in('S_ADM_V','S_ADM_H'));

update USD_USUARIOS_DESPACHOS
set des_id = (select des_id from USD_USUARIOS_DESPACHOS where usu_id = (select usu_id from HAYAMASTER.USU_USUARIOS where BORRADO = 0 and HAYAMASTER.USU_USUARIOS.USU_USERNAME = 'LETRADO_H'))
where usu_id in (select usu_id from HAYAMASTER.USU_USUARIOS where HAYAMASTER.USU_USUARIOS.USU_USERNAME in('LETRADO_V','LETRADO_H'));

update USD_USUARIOS_DESPACHOS
set des_id = (select des_id from USD_USUARIOS_DESPACHOS where usu_id = (select usu_id from HAYAMASTER.USU_USUARIOS where BORRADO = 0 and HAYAMASTER.USU_USUARIOS.USU_USERNAME = 'GESTORIA_H'))
where usu_id in (select usu_id from HAYAMASTER.USU_USUARIOS where HAYAMASTER.USU_USUARIOS.USU_USERNAME in('GESTORIA_V','GESTORIA_H'));

update USD_USUARIOS_DESPACHOS
set des_id = (select des_id from USD_USUARIOS_DESPACHOS where usu_id = (select usu_id from HAYAMASTER.USU_USUARIOS where BORRADO = 0 and HAYAMASTER.USU_USUARIOS.USU_USERNAME = 'G_SAN_H'))
where usu_id in (select usu_id from HAYAMASTER.USU_USUARIOS where HAYAMASTER.USU_USUARIOS.USU_USERNAME in('G_SAN_V','G_SAN_H'));

update USD_USUARIOS_DESPACHOS
set des_id = (select des_id from USD_USUARIOS_DESPACHOS where usu_id = (select usu_id from HAYAMASTER.USU_USUARIOS where BORRADO = 0 and HAYAMASTER.USU_USUARIOS.USU_USERNAME = 'G_ADJ_H'))
where usu_id in (select usu_id from HAYAMASTER.USU_USUARIOS where HAYAMASTER.USU_USUARIOS.USU_USERNAME in('G_ADJ_V','G_ADJ_H'));

COMMIT;


---------------------------------------------------------
-- BORRADO DE TABLAS TIPOS DE GESTOR DE LOS ASUNTOS
-- Antes de caracterizar, es necesario lanzar este borrado
---------------------------------------------------------

truncate table gaa_gestor_adicional_asunto;
truncate table gah_gestor_adicional_historico;

COMMIT;








