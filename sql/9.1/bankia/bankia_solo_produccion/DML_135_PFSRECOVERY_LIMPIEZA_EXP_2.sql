drop table EXP_DUP_BKREC_1831 purge;

create table EXP_DUP_BKREC_1831 as 
select distinct exp.exp_id
from bank01.exp_expedientes exp
left join BANK01.CRE_CICLO_RECOBRO_EXP cre on exp.exp_id = cre.exp_id
where exp.dd_tpx_id = 2   --> expedientes de recobro
  and exp.borrado   = 0   --> no borrados
  and exp.dd_eex_id = 6   --> expediente cancelado
  and cre.exp_id is null; --> expedientes sin ciclo de recobro de expediente

create index EXP_DUP_BKREC_1831_IDX on EXP_DUP_BKREC_1831 (exp_id);

merge into BANK01.EXP_EXPEDIENTES EXP
using ( select exp_id from EXP_DUP_BKREC_1831 ) BORRAR
on ( BORRAR.exp_id = EXP.exp_id )
when matched then
update set EXP.borrado = 1, EXP.fechaborrar = sysdate, EXP.usuarioborrar = 'BKREC-1831'
where EXP.borrado = 0;

merge into BANK01.PEX_PERSONAS_EXPEDIENTE EXP
using ( select exp_id from EXP_DUP_BKREC_1831 ) BORRAR
on ( BORRAR.exp_id = EXP.exp_id )
when matched then
update set EXP.borrado = 1, EXP.fechaborrar = sysdate, EXP.usuarioborrar = 'BKREC-1831'
where EXP.borrado = 0;

merge into BANK01.CEX_CONTRATOS_EXPEDIENTE EXP
using ( select exp_id from EXP_DUP_BKREC_1831 ) BORRAR
on ( BORRAR.exp_id = EXP.exp_id )
when matched then
update set EXP.borrado = 1, EXP.fechaborrar = sysdate, EXP.usuarioborrar = 'BKREC-1831'
where EXP.borrado = 0;

merge into BANK01.CRE_CICLO_RECOBRO_EXP EXP
using ( select exp_id from EXP_DUP_BKREC_1831 ) BORRAR
on ( BORRAR.exp_id = EXP.exp_id )
when matched then
update set EXP.borrado = 1, EXP.fechaborrar = sysdate, EXP.usuarioborrar = 'BKREC-1831'
where EXP.borrado = 0;

commit;
