-- Se crea una vista materializada con indices, con la información de uno de los joins de la vista principal 
-- de búsqueda


DROP MATERIALIZED VIEW UGAS001.V_TAREA_TIPOANOTACION;
CREATE MATERIALIZED VIEW UGAS001.V_TAREA_TIPOANOTACION 
TABLESPACE UGAS001
PCTUSED    0
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
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 2013/07/24 13:35 (Formatter Plus v4.8.8) */
SELECT   tar_id, MAX (flag) flag_envio_correo, MAX (tipo) tipo_anotacion
    FROM (SELECT DISTINCT ireg1.irg_valor AS tar_id, DECODE (ireg2.irg_clave_id, 31, ireg2.irg_valor) flag, DECODE (ireg2.irg_clave_id, 61, ireg2.irg_valor) tipo, ireg2.irg_valor AS tipo_anotacion,
                          ireg2.irg_clave_id AS clave
                     FROM mej_irg_info_registro ireg1 JOIN mej_reg_registro reg1 ON ireg1.reg_id = reg1.reg_id
                          JOIN mej_dd_trg_tipo_registro tipo1 ON reg1.dd_trg_id = tipo1.dd_trg_id
                          JOIN mej_reg_registro reg2 ON reg1.reg_id = reg2.reg_id
                          JOIN mej_irg_info_registro ireg2 ON reg2.reg_id = ireg2.reg_id
                          JOIN mej_dd_trg_tipo_registro tipo2 ON reg2.dd_trg_id = tipo2.dd_trg_id
                    WHERE (tipo1.dd_trg_id = 6 AND tipo2.dd_trg_id = 6 AND ireg1.irg_clave_id = 37) OR (tipo1.dd_trg_id = 8 AND tipo2.dd_trg_id = 8 AND ireg1.irg_clave_id = 34))
   WHERE (clave = 61 AND REGEXP_INSTR (tipo_anotacion, '[0-9]') = 0) OR clave = 31
GROUP BY tar_id;

COMMENT ON MATERIALIZED VIEW UGAS001.V_TAREA_TIPOANOTACION IS 'snapshot table for snapshot UGAS001.V45';

CREATE UNIQUE INDEX UGAS001.IDX_TAREA_TIPOANOTACION_1 ON UGAS001.V_TAREA_TIPOANOTACION
(TAR_ID)
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

CREATE INDEX UGAS001.IDX_TAREA_TIPOANOTACION_2 ON UGAS001.V_TAREA_TIPOANOTACION
(TIPO_ANOTACION)
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

CREATE INDEX UGAS001.IDX_TAREA_TIPOANOTACION_3 ON UGAS001.V_TAREA_TIPOANOTACION
(FLAG_ENVIO_CORREO)
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
