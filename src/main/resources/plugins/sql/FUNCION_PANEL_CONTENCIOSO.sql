



DROP MATERIALIZED VIEW UNMASTER.V_PC_ZONAS_JUDICIAL;

CREATE MATERIALIZED VIEW UNMASTER.V_PC_ZONAS_JUDICIAL 
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
BUILD DEFERRED
REFRESH FORCE
START WITH TO_DATE('29-abr-2012 10:10:14','dd-mon-yyyy hh24:mi:ss')
NEXT SYSDATE + 13  
WITH PRIMARY KEY
AS 
SELECT clientes.oficodigo AS oficodigo, clientes.zon_cod AS cod,
       clientes.zon_id AS ID, clientes.zon_descripcion AS nivel,
       clientes.cuenta AS clientes, contratos.cuenta AS contratostotal,
       contratosi.cuenta AS contratosirregulares,
       saldos.sumsaldovencido AS saldovencido,
       saldos.sumsaldonovencido AS saldonovencido,
       saldoda.suma AS saldonovencidodanyado
  FROM (SELECT   o.ofi_codigo AS oficodigo, z.zon_cod, z.zon_id,
                 z.zon_descripcion, COUNT (c.cli_id) AS cuenta
            FROM zon_zonificacion z, ofi_oficinas o, cli_clientes c
           WHERE z.ofi_id = o.ofi_id AND o.ofi_id = c.ofi_id
        GROUP BY o.ofi_codigo, z.zon_cod, z.zon_id, z.zon_descripcion) clientes,
       (SELECT   z.zon_id, z.zon_cod, COUNT (c.cnt_id) AS cuenta
            FROM cnt_contratos c, zon_zonificacion z
           WHERE c.ofi_id = z.ofi_id AND c.borrado = 0
        GROUP BY z.zon_id, z.zon_cod) contratos,
       (SELECT   z.zon_id, z.zon_cod, COUNT (c.cnt_id) AS cuenta
            FROM cnt_contratos c, mov_movimientos m, zon_zonificacion z
           WHERE c.cnt_id = m.cnt_id
             AND c.cnt_fecha_extraccion = m.mov_fecha_extraccion
             AND m.mov_pos_viva_vencida <> 0
             AND c.zon_id = z.zon_id
             AND c.borrado = 0
             AND m.borrado = 0
        GROUP BY z.zon_id, z.zon_cod) contratosi,
       (SELECT   z.zon_id, z.zon_cod,
                 SUM (m.mov_pos_viva_vencida) AS sumsaldovencido,
                 SUM (m.mov_pos_viva_no_vencida) AS sumsaldonovencido
            FROM cnt_contratos c, zon_zonificacion z, mov_movimientos m
           WHERE c.ofi_id = z.ofi_id
             AND m.cnt_id = c.cnt_id
             AND m.mov_fecha_extraccion = c.cnt_fecha_extraccion
             AND c.borrado = 0
             AND m.borrado = 0
        GROUP BY z.zon_id, z.zon_cod) saldos,
       (SELECT   sub2.ID AS zonid, sub2.cod AS cod, SUM (sub2.snv) AS suma
            FROM (SELECT   sub.ID AS ID, sub.cod AS cod, sub.cntid AS cntid,
                           sub.snv AS snv, sub.sv AS sv, sub.perid AS perid,
                           SUM (sub.mpvv) AS svc
                      FROM (SELECT z.zon_id AS ID, z.zon_cod AS cod,
                                   cnt.cnt_id AS cntid,
                                   mov.mov_pos_viva_no_vencida snv,
                                   mov.mov_pos_viva_vencida sv,
                                   per.per_id AS perid,
                                   mov2.mov_pos_viva_vencida AS mpvv,
                                   RANK () OVER (PARTITION BY cnt.cnt_id ORDER BY cpe.cpe_id)
                                                                   AS ranking
                              FROM cnt_contratos cnt JOIN zon_zonificacion z
                                   ON cnt.ofi_id = z.ofi_id
                                   JOIN mov_movimientos mov
                                   ON cnt.cnt_id = mov.cnt_id
                                 AND cnt.cnt_fecha_extraccion =
                                                      mov.mov_fecha_extraccion
                                   JOIN cpe_contratos_personas cpe
                                   ON cnt.cnt_id = cpe.cnt_id
                                 AND (   cpe.dd_tin_id = 208
                                      OR cpe.dd_tin_id = 210
                                     )
                                   JOIN per_personas per
                                   ON cpe.per_id = per.per_id
                                   JOIN cpe_contratos_personas cpe2
                                   ON per.per_id = cpe2.per_id
                                   JOIN cnt_contratos cnt2
                                   ON cpe2.cnt_id = cnt2.cnt_id
                                 AND cnt2.borrado = 0
                                   LEFT JOIN mov_movimientos mov2
                                   ON cnt2.cnt_id = mov2.cnt_id
                                 AND cnt2.cnt_fecha_extraccion =
                                                     mov2.mov_fecha_extraccion
                                 AND mov2.mov_pos_viva_vencida != 0
                             WHERE cnt.borrado = 0
                               AND mov.mov_pos_viva_vencida = 0) sub
                     WHERE sub.ranking = 1
                  GROUP BY ID, cod, cntid, snv, sv, perid) sub2
           WHERE svc != 0
        GROUP BY sub2.ID, sub2.cod) saldoda
 WHERE clientes.zon_id = contratos.zon_id
   AND clientes.zon_id = contratosi.zon_id
   AND clientes.zon_id = saldos.zon_id
   AND clientes.zon_id = saldoda.zonid;

COMMENT ON MATERIALIZED VIEW UNMASTER.V_PC_ZONAS_JUDICIAL IS 'snapshot table for snapshot UN001.V_PC_ZONAS_JUDICIAL';
