drop table EXP_DUP_BKREC_1373 purge;

create table EXP_DUP_BKREC_1373 as 
select DISTINCT exp_id
from BANK01.CRE_CICLO_RECOBRO_EXP
where CRE_POS_VIVA_NO_VENCIDA = 0
AND CRE_POS_VIVA_VENCIDA = 0
AND CRE_INT_MORAT_DEVEN = 0
AND CRE_INT_ORDIN_DEVEN = 0
AND CRE_COMISIONES = 0
AND CRE_GASTOS = 0
AND CRE_IMPUESTOS = 0
AND (to_date(trunc(CRE_FECHA_BAJA), 'dd/mm/yyyy') - to_date(trunc(CRE_FECHA_ALTA), 'dd/mm/yyyy'))<2
and (cre_id not in (SELECT cre_id FROM BANK01.CRC_CICLO_RECOBRO_CNT)
or cre_id not in (SELECT cre_id FROM BANK01.CRP_CICLO_RECOBRO_PER));

create index EXP_DUP_BKREC_1373_IDX on EXP_DUP_BKREC_1373 (exp_id);

merge into BANK01.EXP_EXPEDIENTES EXP
using ( select exp_id from EXP_DUP_BKREC_1373 ) BORRAR
on ( BORRAR.exp_id = EXP.exp_id )
when matched then
update set EXP.borrado = 1, EXP.fechaborrar = sysdate, EXP.usuarioborrar = 'BKREC-1373'
where EXP.borrado = 0;

merge into BANK01.PEX_PERSONAS_EXPEDIENTE EXP
using ( select exp_id from EXP_DUP_BKREC_1373 ) BORRAR
on ( BORRAR.exp_id = EXP.exp_id )
when matched then
update set EXP.borrado = 1, EXP.fechaborrar = sysdate, EXP.usuarioborrar = 'BKREC-1373'
where EXP.borrado = 0;

merge into BANK01.CEX_CONTRATOS_EXPEDIENTE EXP
using ( select exp_id from EXP_DUP_BKREC_1373 ) BORRAR
on ( BORRAR.exp_id = EXP.exp_id )
when matched then
update set EXP.borrado = 1, EXP.fechaborrar = sysdate, EXP.usuarioborrar = 'BKREC-1373'
where EXP.borrado = 0;

merge into BANK01.CRE_CICLO_RECOBRO_EXP EXP
using ( select exp_id from EXP_DUP_BKREC_1373 ) BORRAR
on ( BORRAR.exp_id = EXP.exp_id )
when matched then
update set EXP.borrado = 1, EXP.fechaborrar = sysdate, EXP.usuarioborrar = 'BKREC-1373'
where EXP.borrado = 0;

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

update BANK01.EXP_EXPEDIENTES set borrado = 0 where usuarioborrar = 'BKREC-1831' and borrado = 1;
update BANK01.PEX_PERSONAS_EXPEDIENTE set borrado = 0 where usuarioborrar = 'BKREC-1831' and borrado = 1;
update BANK01.CEX_CONTRATOS_EXPEDIENTE set borrado = 0 where usuarioborrar = 'BKREC-1831' and borrado = 1;
update BANK01.CRE_CICLO_RECOBRO_EXP set borrado = 0 where usuarioborrar = 'BKREC-1831' and borrado = 1;
commit;

update BANK01.EXP_EXPEDIENTES 
set DD_TPX_ID = (SELECT DD_TPX_ID FROM BANK01.DD_TPX_TIPO_EXPEDIENTE WHERE DD_TPX_CODIGO = 'RECU'), USUARIOMODIFICAR = 'BKREC-1831', FECHAMODIFICAR = SYSDATE 
where USUARIOCREAR = 'CONVIVE_F2';

update BANK01.EXP_EXPEDIENTES set dd_eex_id = 4 where usuariomodificar = 'BKREC-1831' and to_char(fechamodificar,'DD/MM/RRRR') = '10/02/2016' and DD_EEX_ID = 6;

commit;
