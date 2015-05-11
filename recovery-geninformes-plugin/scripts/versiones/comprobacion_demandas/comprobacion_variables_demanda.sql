select distinct inf.DD_INFORME_CODIGO, vbl.VBL_CODIGO 
from dd_informes inf 
inner join ipa_informe_parrafos ipa on ipa.DD_INFORME_ID=inf.DD_INFORME_ID
inner join prf_parrafos prf on prf.PRF_PARRAFO_ID=ipa.PRF_PARRAFO_ID 
inner join pvb_parrafos_variables pvb on pvb.PRF_PARRAFO_ID=ipa.PRF_PARRAFO_ID
inner join vbl_variables vbl on vbl.VBL_ID=pvb.VBL_ID
where inf.dd_informe_codigo='DEMANDA_MONITORIO_SPROC'
order by vbl_codigo;