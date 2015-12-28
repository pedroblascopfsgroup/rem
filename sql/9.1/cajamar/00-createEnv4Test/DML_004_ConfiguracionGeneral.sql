insert into cm01.pps_parcela_persona_sgto pps (PPS_ID,DD_PAR_ID,DD_SCL_ID,DD_TPE_ID,USUARIOCREAR,FECHACREAR) 
select rownum, dd_par_id, dd_scl_id, dd_tpe_id, 'SAG', SYSDATE + 1
from (
  select par.dd_par_id, scl.dd_scl_id, dd_tpe_id --dd_par_id
  from cm01.dd_par_parcelas par, cm01.dd_scl_segto_cli scl, cmmaster.dd_tpe_tipo_persona
);


update cm01.DD_PCO_DOC_SOLICIT_TIPOACTOR ser set borrado = 1, fechaborrar = sysdate, usuarioborrar = 'SAG' where DD_PCO_DSA_CODIGO = 'CM_GE_PCO';


delete from cm01.fun_pef where fun_id = (select fun_id from cmmaster.fun_funciones where fun_descripcion = 'ROLE_VER_POLITICAS');



--EXPEDIENTES PRECONTENCIOSO--
UPDATE CM01.exp_expedientes SET ARQ_ID = (SELECT ARQ_ID FROM CM01.ARQ_ARQUETIPOS ARQ INNER JOIN CM01.ITI_ITINERARIOS ITI ON ARQ.ITI_ID = ITI.ITI_ID WHERE ARQ.BORRADO = '0' AND ITI.BORRADO = 0 AND ITI.DD_TIT_ID = 
(SELECT DD_TIT_ID FROM CMMASTER.DD_TIT_TIPO_ITINERARIOS WHERE DD_TIT_CODIGO = 'REC') AND ROWNUM=1)
, USUARIOMODIFICAR = 'ARQ_SIN_GEST', FECHAMODIFICAR = SYSDATE where  arq_id in (Select arq_id from CM01.arq_arquetipos where borrado = 1) and borrado = 0;
UPDATE CM01.EXP_EXPEDIENTES SET DD_TPX_ID = (SELECT DD_TPX_ID FROM CM01.DD_TPX_TIPO_EXPEDIENTE WHERE DD_TPX_CODIGO = 'RECU'), USUARIOMODIFICAR = 'ARQ_SIN_GEST', FECHAMODIFICAR = SYSDATE WHERE DD_TPX_ID IS NULL;
UPDATE CM01.EXP_EXPEDIENTES SET EXP_DESCRIPCION = 'PRECONTENCIOSO', USUARIOMODIFICAR = 'SIN_DESCRIPCION', FECHAMODIFICAR = SYSDATE WHERE EXP_DESCRIPCION IS NULL;
