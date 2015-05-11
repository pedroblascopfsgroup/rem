DROP MATERIALIZED VIEW UN001.V_CVE_CLIENTES_VENCIDOS_USU;
CREATE MATERIALIZED VIEW UN001.V_CVE_CLIENTES_VENCIDOS_USU 
TABLESPACE UN001
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
USING INDEX
            TABLESPACE UN001
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
REFRESH COMPLETE
START WITH TO_DATE('24-ago-2012 07:00:00','dd-mon-yyyy hh24:mi:ss')
NEXT trunc(sysdate+1)+7/24            
WITH PRIMARY KEY
AS 
/* Formatted on 2012/08/23 10:08 (Formatter Plus v4.8.8) */
SELECT p.per_id, est.pef_id_gestor, zon.zon_cod, dd.dd_tit_codigo,
       pef.pef_es_carterizado
  FROM cnt_contratos c,
       cpe_contratos_personas cp,
       dd_tin_tipo_intervencion tin,
       cli_clientes cli,
       ccl_contratos_cliente ccl,
       ofi_oficinas o,
       zon_zonificacion zon,
       arq_arquetipos a,
       iti_itinerarios i,
       unmaster.dd_tit_tipo_itinerarios dd,
       per_personas p,
       unmaster.dd_tpe_tipo_persona tpe,
       est_estados est,
       pef_perfiles pef
 WHERE cp.borrado = 0
   AND cp.cnt_id = c.cnt_id
   AND c.borrado = 0
   AND cp.dd_tin_id = tin.dd_tin_id
   AND tin.dd_tin_titular = 1
   AND cli.cli_id = ccl.cli_id
   AND ccl.cnt_id = cp.cnt_id
   AND cli.per_id = cp.per_id
   AND ccl.ccl_pase = 1
   AND cp.cpe_orden = 1
   AND cli.ofi_id = o.ofi_id
   AND zon.ofi_id = o.ofi_id
   AND cli.borrado = 0
   AND cli.arq_id = a.arq_id
   AND a.iti_id = i.iti_id
   AND i.dd_tit_id = dd.dd_tit_id
   AND cli.per_id = p.per_id
   AND tpe.dd_tpe_id = p.dd_tpe_id
   AND est.dd_est_id = cli.dd_est_id
   AND a.iti_id = est.iti_id
   AND cli.arq_id = a.arq_id
   AND p.borrado = 0
   AND est.pef_id_gestor = pef.pef_id
   AND cli.dd_est_id IN (SELECT dd_est_id
                           FROM unmaster.dd_est_estados_itinerarios
                          WHERE dd_est_codigo IN ('GV'));

COMMENT ON MATERIALIZED VIEW UN001.V_CVE_CLIENTES_VENCIDOS_USU IS 'snapshot table for snapshot UN001.V_CVE_CLIENTES_VENCIDOS_USU';

CREATE UNIQUE INDEX UN001.I_V_CVE_CLIENTES_VENCIDOS_U_PK ON UN001.V_CVE_CLIENTES_VENCIDOS_USU
(PER_ID)
LOGGING
TABLESPACE UN001
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

CREATE INDEX UN001.I_V_CVE_CLIENTES_VENCIDOS_U_2 ON UN001.V_CVE_CLIENTES_VENCIDOS_USU
(PEF_ID_GESTOR, DD_TIT_CODIGO)
LOGGING
TABLESPACE UN001
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
