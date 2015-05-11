
/*
 *
 * Reasignación
 * CAMBIAR EL GESTOR EN LA GAAA
 *
 */
 
 update /*+BYPASS_UJVC*/ (
 select gaa.gaa_id, gaa.asu_id, gaa.dd_tge_id, gaa.usd_id viejo , cma.usd_id_nuevo nuevo
 from gaa_gestor_adicional_asunto gaa
    join cma_cambios_masivos_asuntos cma on gaa.asu_id = cma.asu_id and gaa.dd_tge_id = cma.cod_tipo_gestor and gaa.usd_id = cma.usd_id_original
 where cma.borrado = 0 and cma.reasignado = 0    
 ) set viejo = nuevo;    
    
    
/*
 *
 * Reasignación
 * DEJAR TRAZA DEL CAMBIO
 *
 */ 
 
 --
 -- Escribir cabecera de la traza 
 --
 
 create table tmp_insert_mej_reg_registro as
 select case tge.dd_tge_codigo
        when 'SUP' then 'CAMBIO_SJUD'
        when 'GEXT' then 'CAMBIO_GJUD'
        when 'PROC' then 'CAMBIO_PROC'
        when 'SUPCEXP' then 'CAMBIO_SCEX'
        when 'GECEXP' then 'CAMBIO_GCEX'
     end cod_tipo_registro
     , 3 trg_ein_codigo
     , cma.asu_id trg_ein_id
     , cma.sol_id usu_id
     , cma.cma_id 
 from cma_cambios_masivos_asuntos cma
    join unmaster.dd_tge_tipo_gestor tge on cma.cod_tipo_gestor = tge.dd_tge_id
 where cma.reasignado = 0 and cma.borrdado = 0;
    
insert into mej_reg_registro (cma_id, reg_id, dd_trg_id, trg_ein_codigo, trg_ein_id, usu_id, version, usuariocrear, fechacrear, borrado)
select tmp.cma_id, s_mej_reg_registro.nextval, trg.dd_trg_id, tmp.trg_ein_codigo, tmp.trg_ein_id, tmp.usu_id, 0, 'AUTO', sysdate, 0
from tmp_insert_mej_reg_registro tmp
   join mej_dd_trg_tipo_registro trg on tmp.cod_tipo_registro = trg.dd_trg_codigo;
   
drop table tmp_insert_mej_reg_registro;


--
 -- Escribir detalle de la traza 
 --

insert into mej_irg_info_registro (irg_id, reg_id, irg_clave, irg_valor, version, usuariocrear,fechacrear, borrado)
select s_mej_irg_info_registro.nextval irg_id
    , reg.reg_id
    , 'idUserOld' irg_clave
    , usd_old.usu_id
    ,0, 'AUTO', sysdate, 0
from mej_reg_registro reg
    join cma_cambios_masivos_asuntos cma on reg.cma_id = cma.cma_id
    join usd_usuarios_despachos usd_old on cma.usd_id_original = usd_old.usd_id
where cma.reasignado = 0 and cma.borrado = 0;

insert into mej_irg_info_registro (irg_id, reg_id, irg_clave, irg_valor, version, usuariocrear,fechacrear, borrado)
select s_mej_irg_info_registro.nextval irg_id
    , reg.reg_id
    , 'userOld' irg_clave
    , trim(usu.usu_nombre||' '||usu.usu_apellido1||' '||usu.usu_apellido2)
    ,0, 'AUTO', sysdate, 0
from mej_reg_registro reg
    join cma_cambios_masivos_asuntos cma on reg.cma_id = cma.cma_id
    join usd_usuarios_despachos usd on cma.usd_id_original = usd.usd_id
    join unmaster.usu_usuarios usu on usd.usu_id = usu.usu_id
where cma.reasignado = 0 and cma.borrado = 0;


insert into mej_irg_info_registro (irg_id, reg_id, irg_clave, irg_valor, version, usuariocrear,fechacrear, borrado)
select s_mej_irg_info_registro.nextval irg_id
    , reg.reg_id
    , 'idUserNew' irg_clave
    , usd.usu_id   
    ,0, 'AUTO', sysdate, 0
from mej_reg_registro reg
    join cma_cambios_masivos_asuntos cma on reg.cma_id = cma.cma_id
    join usd_usuarios_despachos usd on cma.usd_id_nuevo = usd.usd_id
where cma.reasignado = 0 and cma.borrado = 0;

insert into mej_irg_info_registro (irg_id, reg_id, irg_clave, irg_valor, version, usuariocrear,fechacrear, borrado)
select s_mej_irg_info_registro.nextval irg_id
    , reg.reg_id
    , 'userNew' irg_clave
    , trim(usu.usu_nombre||' '||usu.usu_apellido1||' '||usu.usu_apellido2)
    ,0, 'AUTO', sysdate, 0
from mej_reg_registro reg
    join cma_cambios_masivos_asuntos cma on reg.cma_id = cma.cma_id
    join usd_usuarios_despachos usd on cma.usd_id_nuevo = usd.usd_id
    join unmaster.usu_usuarios usu on usd.usu_id = usu.usu_id
where cma.reasignado = 0 and cma.borrado = 0;

insert into mej_irg_info_registro (irg_id, reg_id, irg_clave, irg_valor, version, usuariocrear,fechacrear, borrado)
select s_mej_irg_info_registro.nextval irg_id
    , reg.reg_id
    , 'userNew' irg_clave
    , trim(usu.usu_nombre||' '||usu.usu_apellido1||' '||usu.usu_apellido2)
    ,0, 'AUTO', sysdate, 0
from mej_reg_registro reg
    join cma_cambios_masivos_asuntos cma on reg.cma_id = cma.cma_id
    join usd_usuarios_despachos usd on cma.usd_id_nuevo = usd.usd_id
    join unmaster.usu_usuarios usu on usd.usu_id = usu.usu_id
where cma.reasignado = 0 and cma.borrado = 0;


insert into mej_irg_info_registro (irg_id, reg_id, irg_clave, irg_valor, version, usuariocrear,fechacrear, borrado)
select s_mej_irg_info_registro.nextval irg_id
    , reg.reg_id
    , 'dateBegin' irg_clave
    , to_char(cma.fecha_inicio, 'dd/mm/rrrr')
    ,0, 'AUTO', sysdate, 0
from mej_reg_registro reg
    join cma_cambios_masivos_asuntos cma on reg.cma_id = cma.cma_id
where cma.reasignado = 0 and cma.borrado = 0;


insert into mej_irg_info_registro (irg_id, reg_id, irg_clave, irg_valor, version, usuariocrear,fechacrear, borrado)
select s_mej_irg_info_registro.nextval irg_id
    , reg.reg_id
    , 'dateEnd' irg_clave
    , to_char(cma.fecha_fin, 'dd/mm/rrrr')
    ,0, 'AUTO', sysdate, 0
from mej_reg_registro reg
    join cma_cambios_masivos_asuntos cma on reg.cma_id = cma.cma_id
where cma.reasignado = 0 and cma.borrado = 0;
 