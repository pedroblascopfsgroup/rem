-- Expedientes
truncate table tmp_tgexp_exp;

insert into tmp_tgexp_exp
select exp_id, cnt_id
from TMP_BK_BATCH_DATOS_SALIDA_2
where cex_pase = 1 and pex_pase = 1
  and exp_id = 4539104;

-- Obligados
truncate table tmp_tgexp_obl;

insert into tmp_tgexp_obl
select r.exp_id, r.per_id, r.cnt_per_arrastre
from TMP_BK_BATCH_DATOS_SALIDA_2 r
  join tmp_tgexp_exp e on r.cnt_id = e.cnt_id and r.cnt_id = e.cnt_id;
  
truncate table tmp_tgexp_obl_real;

insert into tmp_tgexp_obl_real
select distinct exp.exp_id, cpe.per_id
from CPE_CONTRATOS_PERSONAS cpe
  join tmp_tgexp_exp exp on  cpe.cnt_id = exp.cnt_id
  join dd_tin_tipo_intervencion tin on cpe.dd_tin_id = tin.DD_TIN_ID
where (tin.dd_tin_titular = 1 or tin.dd_tin_avalista = 1)  and cpe.borrado = 0;

commit;


-- Contratos arrastrados en 1 generacion
truncate table tmp_tgexp_gen1_cnt;

insert into tmp_tgexp_gen1_cnt
select e.exp_id, o.per_id, r.cnt_id
from tmp_tgexp_exp e
  join tmp_tgexp_obl o on e.exp_id = o.exp_id
  left join TMP_BK_BATCH_DATOS_SALIDA_2 r on o.exp_id = r.exp_id and o.per_id = r.per_id
;


truncate table tmp_tgexp_gen1_cnt_real;

insert into tmp_tgexp_gen1_cnt_real
with cnt_exp as (
  select distinct cnt_id, exp_id from TMP_BK_BATCH_DATOS_SALIDA_2
), cpe_exp as (
  select distinct cpe.cnt_id, cpe.per_id, exp.exp_id
  from cpe_contratos_personas cpe
    join dd_tin_tipo_intervencion tin on cpe.dd_tin_id = tin.DD_TIN_ID
    left join cnt_exp exp  on cpe.cnt_id = exp.cnt_id
  where (tin.dd_tin_titular = 1 or tin.dd_tin_avalista = 1)  and cpe.borrado = 0
    and tin.dd_tin_exp_recobro_sn = 1
)
select e.exp_id, o.per_id, cpe.cnt_id, cpe.exp_id en_exp
from tmp_tgexp_exp e
  join tmp_tgexp_obl o on e.exp_id = o.exp_id
  left join cpe_exp cpe on o.per_id = cpe.per_id
where o.cnt_per_arrastre = 1
;

commit;


-- Comprobamos si no coinciden los obligados
with obl as (
  select * from tmp_tgexp_obl
), obl_real as (
  select * from tmp_tgexp_obl_real
), total as (
  select o.exp_id, count(o.per_id) n_obl, count(r.per_id) n_obl_real
  from tmp_tgexp_obl o
    left join tmp_tgexp_obl_real r on o.exp_id = r.exp_id
  group by o.exp_id
)
select exp_id as NO_COINCIDEN_OBL
from total
where n_obl <> n_obl_real;



-- Comprobamos si no los contratos de arrastre en 1g
with cnt as (
  select * from tmp_tgexp_gen1_cnt
), cnt_real as (
  select c.* from tmp_tgexp_gen1_cnt_real c
), total as (
  select exp_id, per_id, count(cnt_id) n_cnt
  from tmp_tgexp_gen1_cnt 
  group by exp_id, per_id
), total_real as (
  select exp_id, per_id, count(cnt_id) n_cnt_real
  from tmp_tgexp_gen1_cnt_real
  group by exp_id, per_id
)
select c.exp_id, c.per_id, c.n_cnt, r.n_cnt_real
from total c
  left join total_real r on c.exp_id = r.exp_id and c.per_id = r.per_id
;

