--Asignamos el codigo de gestion del asunto en funcion de marcas HAYA.

MERGE INTO HAYA02.asu_asuntos asu  USING
(
   select asuf.asu_id
        , (SELECT ges.DD_GES_ID FROM HAYA02.DD_GES_GESTION_ASUNTO ges
                            WHERE ges.DD_GES_CODIGO = case when b.dd_ges_codigo = 'HAYA' 
                                                        and r.dd_cre_codigo  in ('EX','CN','IM','AR','MA','SC') then 'HAYA' 
                                                      else 'CAJAMAR' end ) as DD_GES_ID
   from 
   (select asu.asu_id, asu.dd_tas_id, asu.DD_GES_ID, trim(substr(asu.asu_nombre,1,INSTR(asu.asu_nombre,'|', 1) -1)) as numero_contrato 
       from HAYA02.asu_asuntos asu ) asuf
     , HAYA02.cnt_contratos cnt
     , HAYA02.dd_ges_gestion_especial b
     , HAYA02.dd_cre_condiciones_remun_ext r
   where asuf.numero_contrato = lpad(cnt.cnt_contrato,16,'0')
       and cnt.dd_ges_id = b.dd_ges_id 
       and cnt.dd_cre_id = r.dd_cre_id
) AUX
ON (asu.ASU_ID = AUX.ASU_ID AND asu.usuariocrear in ('MIGRAHAYA02', 'MIGRAHAYA02PCO'))        
WHEN MATCHED THEN 
UPDATE SET asu.DD_GES_ID = AUX.DD_GES_ID;

COMMIT;

EXIT;
/