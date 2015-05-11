/*
 * Limipamos las talas OJO, comentar si no se quiere
 */
delete from cdc_ciclo_deuda_cex;
delete from cdp_ciclo_deuda_pex;
delete from  cde_ciclo_deuda_exp;
delete from cex_contratos_expediente_rec;
delete from  pex_personas_expediente_rec;
delete from  exp_expedientes_rec;

delete from tmp_rec_exp_rearquetipado;

commit;

/*
 * Creamos un expediente de recobro
 */
-- Seleccionamos el expediente
update exp_expedientes set dd_eex_id = 2 where exp_id in (
select min(exp_id) from exp_expedientes where borrado = 0);

commit;

insert into exp_expedientes_rec
select min(exp_id) from exp_expedientes;

commit;

-- Insertamos info de recobro al expediente (de los expedientes seleccionados)
insert into cex_contratos_expediente_rec
select cex_id
from cex_contratos_expediente
where exp_id in (select exp_id from exp_expedientes_rec);

commit;

insert into pex_personas_expediente_rec
select pex_id
from pex_personas_expediente
where exp_id in (select exp_id from exp_expedientes_rec);

commit;

insert into cde_ciclo_deuda_exp
select s_cde_ciclo_deuda_exp.nextval
  , rec.exp_id
  , sysdate - (30 * dbms_random.value(1,3)) cde_fecha_alta
  , null cde_fecha_baja
  , 2 rcf_esq_id
  , 2 rcf_esc_id
  , 2 rcf_sca_id
  , 2 rcf_sua_id
  , 2 rcf_age_id
  , 1 cde_pos_viva_no_vencida
  , 1 cde_pos_viva_vencida
  , 1 cde_int_ordin_deven
  , 1 cde_int_morat_deven
  , 1 cde_comisiones
  , 1 cde_gastos
  , 1 cde_impuestos
  ,0,'UNITTEST', SYSDATE, NULL, NULL, NULL, NULL, 0
from exp_expedientes_rec rec;

commit;

insert into cdc_ciclo_deuda_cex
select s_cdc_ciclo_deuda_cex.nextval 
  , rec.cex_id
  , cde.cde_id
  , null dd_mob_id
  ,to_number(to_char(TRUNC(cde.cde_fecha_alta), 'yyyyMMdd') || cex.cnt_id)  id_envio
  , null exc_id
  , cde.cde_fecha_alta cdc_fecha_alta
  , null cdc_fecha_baja
  , 1 cdc_pos_viva_no_vencida
  , 1 cdc_pos_viva_vencida
  , 1 cdc_int_ordin_deven
  , 1 cdc_int_morat_deven
  , 1 cdc_comisiones
  , 1 cdc_gastos
  , 1 cdc_impuestos
  ,0,'UNITTEST', SYSDATE, NULL, NULL, NULL, NULL, 0
from cex_contratos_expediente_rec rec
  join cex_contratos_expediente cex on rec.cex_id = cex.cex_id
  join cde_ciclo_deuda_exp cde on cex.exp_id = cde.exp_id;
  
commit;

insert into cdp_ciclo_deuda_pex
select s_cdp_ciclo_deuda_pex.nextval 
  , rec.pex_id
  , cde.cde_id
  , null dd_mob_id
  , null exc_id
  , cde.cde_fecha_alta cdp_fecha_alta
  , null cdp_fecha_baja
  , 1 cdp_riesgo_directo
  , 1 cdp_riesgo_indirecto
  ,0,'UNITTEST', SYSDATE, NULL, NULL, NULL, NULL, 0
from pex_personas_expediente_rec rec
  join pex_personas_expediente pex on rec.pex_id = pex.pex_id
  join cde_ciclo_deuda_exp cde on pex.exp_id = cde.exp_id;
  
commit;


/*
 * Marcamos los expedientes seleccionados como pendientes de rearquetipar
 */
 insert into tmp_rec_exp_rearquetipado
 select rec.exp_id
  , 3 rcf_age_id
  , 5 rcf_sca_id
  , esc.rcf_car_id
  , 3 arq_id_new
 from exp_expedientes_rec rec
  join cde_ciclo_deuda_exp cde on rec.exp_id = cde.exp_id
  join rcf_esc_esquema_carteras esc on cde.rcf_esc_id = esc.rcf_esc_id;
  
commit;