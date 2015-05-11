-- Se añade una columna a MEJ_IRG_INFO_REGISTRO para poner ids a las distintas claves

ALTER TABLE MEJ_IRG_INFO_REGISTRO ADD IRG_CLAVE_ID      NUMBER(16);

-- Se crea un indice para esa columna

CREATE INDEX UGAS001.IDX_MEJ_IRG_CLAVE_ID ON UGAS001.MEJ_IRG_INFO_REGISTRO
(IRG_CLAVE_ID)
LOGGING
TABLESPACE UGAS001
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


-- Se rellena la columna

UPDATE /*+BYPASS_UJVC*/ 
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