

SET TERMOUT OFF HEADING OFF FEEDBACK OFF ECHO OFF PAGESIZE 0 LINESIZE 200

SPOOL INFORMES/PARES/OUTPUT/PARES_OFERTAS_UVEM_REM.txt
  select '     OFERTA_UVEM	      OFERTA_REM'
  from dual
  union ALL
   select lpad(ofr_num_oferta,16,0) ||' '||  lpad(ofr_num_oferta,16,0) 
  from REM01.ofr_ofertas ofr
  inner join ECO_EXPEDIENTE_COMERCIAL eco  on ofr.ofr_id = eco.ofr_id
  inner join DD_EOF_ESTADOS_OFERTA eof    on eof.dd_eof_id = ofr.dd_eof_id
  inner join DD_EEC_EST_EXP_COMERCIAL eec on eco.dd_eec_id = eec.dd_eec_id
  WHERE ofr.USUARIOCREAR = 'MIG_BANKIA'
    and eof.dd_eof_codigo <> '04'  
    and eec.dd_eec_codigo <> '01'--64394
    and ofr_num_oferta not in ( select distinct ofr_num_oferta
  from REM01.ofr_ofertas ofr
  inner join ECO_EXPEDIENTE_COMERCIAL eco  on ofr.ofr_id = eco.ofr_id
  inner join DD_EOF_ESTADOS_OFERTA eof    on eof.dd_eof_id = ofr.dd_eof_id
  inner join DD_EEC_EST_EXP_COMERCIAL eec on eco.dd_eec_id = eec.dd_eec_id
  inner join ACT_OFR AFR ON AFR.OFR_ID=OFR.OFR_ID
  inner join ACT_PAC_PERIMETRO_ACTIVO pac on pac.act_id=afr.act_id
  inner join DD_COS_COMITES_SANCION cos on cos.dd_cos_id =eco.dd_cos_id
  WHERE ofr.USUARIOCREAR = 'MIG_BANKIA'
    and eof.dd_eof_codigo = '01'  
    and eec.dd_eec_codigo = '10'
    and cos.dd_cos_codigo='3'
    and pac.pac_check_formalizar=1);

  
  
SPOOL OFF;
set echo on heading on feedback on termout on;


EXIT;
/
