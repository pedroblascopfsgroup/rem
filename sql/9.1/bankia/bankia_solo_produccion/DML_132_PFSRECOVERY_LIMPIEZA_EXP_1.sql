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

commit;
