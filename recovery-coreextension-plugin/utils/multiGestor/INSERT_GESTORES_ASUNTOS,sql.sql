insert into gaa_gestor_adicional_asunto (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
select s_gaa_gestor_adicional_asunto.nextVal, asu_id, gas_id, (select dd_tge_id from unmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GEXT'), 0, 'BAR', sysdate, 0
from asu_asuntos where gas_id is not null;

insert into gaa_gestor_adicional_asunto (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
select s_gaa_gestor_adicional_asunto.nextVal, asu_id, sup_id, (select dd_tge_id from unmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUP'), 0, 'BAR', sysdate, 0
from asu_asuntos where sup_id is not null;

insert into gaa_gestor_adicional_asunto (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
select s_gaa_gestor_adicional_asunto.nextVal, asu_id, USD_ID, (select dd_tge_id from unmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'PROC'), 0, 'BAR', sysdate, 0
from asu_asuntos where usd_id is not null;