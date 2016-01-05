update pef_perfiles set borrado = 1, usuarioborrar = 'SAG', fechaborrar = sysdate
where pef_id not in (
select distinct pef.pef_id
from pef_perfiles pef inner join 
     zon_pef_usu zp on zp.pef_id = pef.pef_id);
     
--------------------

update ITI_ITINERARIOS set ITI_NOMBRE = 'Migración', borrado = 0, usuarioborrar = null, fechaborrar = null
where iti_id = (
  select distinct max(iti_id)
  from exp_expedientes exp inner join 
       arq_arquetipos arq on arq.arq_id = exp.arq_id); 
       
insert into est_estados (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,ITI_ID,DD_EST_ID,usuariocrear,fechacrear)
values(
s_est_estados.nextval, 
(select pef_id from pef_perfiles where pef_codigo = 'HAYAGEST'),
(select pef_id from pef_perfiles where pef_codigo = 'HAYAGEST'),
(select iti_id from ITI_ITINERARIOS where ITI_NOMBRE = 'Migración'),
(SELECT DD_EST_ID FROM HAYAMASTER.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = 'DC'),
'sag', SYSDATE);
       
UPDATE EXP_EXPEDIENTES EXP SET EXP.EXP_descriPCION = (
  SELECT MAX(CNT_CONTRATO)
  FROM CEX_CONTRATOS_EXPEDIENTE CEX INNER JOIN 
       CNT_CONTRATOS CNT ON CNT.CNT_ID = CEX.CNT_ID INNER JOIN 
       PEX_PERSONAS_EXPEDIENTE PEX ON PEX.EXP_ID = CEX.EXP_ID INNER JOIN
       PER_PERSONAS PER ON PER.PER_ID = PEX.PER_ID
  WHERE CEX.EXP_ID = EXP.EXP_ID AND CEX.CEX_PASE = 1) ||' | ' ||
  (SELECT MIN(PER.PER_NOM50)
  FROM PEX_PERSONAS_EXPEDIENTE PEX INNER JOIN
       PER_PERSONAS PER ON PER.PER_ID = PEX.PER_ID
  WHERE PEX.EXP_ID = EXP.EXP_ID )
;

--DELETE FROM BIE_BIEN_ENTIDAD  WHERE BIE_ID = 100365725 ;

INSERT INTO BIE_BIEN_ENTIDAD (BIE_ID, BIE_LOC_ID, BIE_DREG_ID, BIE_ADI_ID, BIE_VAL_ID, USUARIOCREAR, FECHACREAR)
SELECT BIE.BIE_ID, 1, 1, 1, 1, 'SAG', SYSDATE
FROM BIE_BIEN BIE LEFT JOIN 
     BIE_BIEN_ENTIDAD BIEE ON BIEE.BIE_ID = BIE.BIE_ID
WHERE BIEE.BIE_ID IS NULL 
;

commit;