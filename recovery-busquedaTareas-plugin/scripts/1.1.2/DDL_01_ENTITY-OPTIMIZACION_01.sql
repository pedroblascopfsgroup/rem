-- Se a?ade una columna a MEJ_IRG_INFO_REGISTRO para poner ids a las distintas claves

ALTER TABLE MEJ_IRG_INFO_REGISTRO ADD IRG_CLAVE_ID      NUMBER(16);

-- Se crea un indice para esa columna

CREATE INDEX IDX_MEJ_IRG_CLAVE_ID ON MEJ_IRG_INFO_REGISTRO (IRG_CLAVE_ID);


-- Se rellena la columna
/*
UPDATE +BYPASS_UJVC 
(                          
SELECT mej.irg_clave_id viejo, ID nuevo
  FROM mej_irg_info_registro mej
       JOIN
       (SELECT ROWNUM ID, irg_clave irg_clave_valor
          FROM (SELECT DISTINCT irg_clave, irg_clave_id
                           FROM mej_irg_info_registro
                       ORDER BY irg_clave ASC)) cc ON mej.irg_clave = cc.irg_clave_valor
 WHERE mej.irg_clave_id IS NULL        
) set viejo=nuevo;

*/

--REMPLAZADA LA CONSULTA ANTERIOR "+BYPASS_UJVC" POR MERGE
MERGE INTO mej_irg_info_registro t1
   USING (SELECT mej.irg_id, mej.irg_clave_id viejo, ID nuevo
  FROM mej_irg_info_registro mej
       JOIN
       (SELECT ROWNUM ID, irg_clave irg_clave_valor
          FROM (SELECT DISTINCT irg_clave, irg_clave_id
                           FROM mej_irg_info_registro
                       ORDER BY irg_clave ASC)) cc ON mej.irg_clave = cc.irg_clave_valor
 WHERE mej.irg_clave_id IS NULL        
) q
   ON (t1.irg_id = q.irg_id)
   WHEN MATCHED THEN
      UPDATE
         SET t1.irg_clave_id = q.nuevo; 