insert into prc_per (prc_id, per_id, version)
with prc_sin_per as (
select prc.prc_id, asu_id
from prc_procedimientos prc
  left join prc_per on prc.prc_id = prc_per.prc_id
where prc_per.per_id is null
)
select distinct prc.prc_id, cpe.per_id, 0
from prc_sin_per prc
  join prc_cex on prc.prc_id = prc_cex.prc_id
  join cex_contratos_expediente cex on prc_cex.cex_id = cex.cex_id
  join cpe_contratos_personas cpe on cex.cnt_id = cpe.cnt_id
  ;
commit;
