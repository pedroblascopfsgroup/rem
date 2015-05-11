DROP MATERIALIZED VIEW V_PC_ZONAS_JUDICIAL;

CREATE MATERIALIZED VIEW V_PC_ZONAS_JUDICIAL 
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
REFRESH FORCE
START WITH TO_DATE('12-may-2012 10:10:18','dd-mon-yyyy hh24:mi:ss')
NEXT SYSDATE + 13    
WITH PRIMARY KEY
AS 
/* Formatted on 2012/04/30 08:21 (Formatter Plus v4.8.8) */
SELECT clientes.oficodigo AS oficodigo, clientes.zon_cod AS cod, clientes.zon_id AS ID, clientes.zon_descripcion AS nivel, clientes.cuenta AS clientes, contratos.cuenta AS contratostotal,
       contratosi.cuenta AS contratosirregulares, saldos.sumsaldovencido AS saldovencido, saldos.sumsaldonovencido AS saldonovencido, saldoda.suma AS saldonovencidodanyado, tareaspendientesmes,
       tareaspendientessemana, tareaspendientesvencidas, tareaspendienteshoy
  FROM (SELECT   zon_id, SUM (DECODE (ph, '', 0, 1)) tareaspendienteshoy, SUM (DECODE (ps, '', 0, 1)) tareaspendientessemana, SUM (DECODE (pm, '', 0, 1)) tareaspendientesmes,
                 SUM (DECODE (tv, '', 0, 1)) tareaspendientesvencidas
            FROM (SELECT zon_id, CASE
                            WHEN TRUNC (fecha) = TRUNC (SYSDATE)
                               THEN 'PH'
                         END ph, CASE
                            WHEN TRUNC (fecha) <= TRUNC (SYSDATE + 7) AND TRUNC (fecha) >= TRUNC (SYSDATE)
                               THEN 'PS'
                         END ps, CASE
                            WHEN TRUNC (fecha) <= TRUNC (SYSDATE + 30) AND TRUNC (fecha) >= TRUNC (SYSDATE)
                               THEN 'PM'
                         END pm, CASE
                            WHEN TRUNC (fecha) < TRUNC (SYSDATE)
                               THEN 'TV'
                         END tv
                    FROM (SELECT zon_ofi.zon_id, tar.tar_id, TRUNC (tar.tar_fecha_venc) fecha
                            FROM tar_tareas_notificaciones tar,
                                 cli_clientes cli,
                                 unmaster.dd_est_estados_itinerarios est_iti_cli,
                                 est_estados est,
                                 unmaster.dd_est_estados_itinerarios est_iti_tar,
                                 arq_arquetipos arq,
                                 ofi_oficinas ofi,
                                 zon_zonificacion zon_ofi
                           WHERE tar.cli_id = cli.cli_id(+)
                             AND cli.dd_est_id = est_iti_cli.dd_est_id(+)
                             AND est_iti_cli.dd_est_id = est.dd_est_id(+)
                             AND tar.dd_est_id = est_iti_tar.dd_est_id
                             AND cli.arq_id = arq.arq_id
                             AND cli.ofi_id = ofi.ofi_id
                             AND ofi.ofi_id = zon_ofi.ofi_id
                             AND tar.borrado = 0
                             AND est_iti_cli.dd_est_codigo = est_iti_tar.dd_est_codigo
                             AND arq.iti_id = est.iti_id
                             AND (tar.tar_tarea_finalizada IS NULL OR tar.tar_tarea_finalizada = 0)
                             AND tar.dd_ein_id = 1
                             AND (tar.tar_tarea_finalizada IS NULL OR tar.tar_tarea_finalizada = 0)
                             AND tar.borrado = 0
                          UNION ALL
                          SELECT zon_exp.zon_id, tar_exp.tar_id, TRUNC (tar_exp.tar_fecha_venc) fecha
                            FROM tar_tareas_notificaciones tar_exp,
                                 exp_expedientes exp,
                                 unmaster.dd_est_estados_itinerarios est_iti_exp,
                                 est_estados est_exp,
                                 unmaster.dd_est_estados_itinerarios est_iti_tar_exp,
                                 arq_arquetipos arq_exp,
                                 unmaster.dd_ein_entidad_informacion ent,
                                 unmaster.dd_sta_subtipo_tarea_base sub_tipo,
                                 ofi_oficinas ofi_exp,
                                 zon_zonificacion zon_exp
                           WHERE tar_exp.exp_id = exp.exp_id(+)
                             AND exp.dd_est_id = est_iti_exp.dd_est_id(+)
                             AND est_iti_exp.dd_est_id = est_exp.dd_est_id(+)
                             AND tar_exp.dd_est_id = est_iti_tar_exp.dd_est_id
                             AND exp.arq_id = arq_exp.arq_id
                             AND tar_exp.dd_ein_id = ent.dd_ein_id
                             AND tar_exp.dd_sta_id = sub_tipo.dd_sta_id
                             AND exp.ofi_id = ofi_exp.ofi_id
                             AND ofi_exp.ofi_id = zon_exp.ofi_id
                             AND tar_exp.borrado = 0
                             AND est_iti_exp.dd_est_codigo = est_iti_tar_exp.dd_est_codigo
                             AND arq_exp.iti_id = est_exp.iti_id
                             AND (tar_exp.tar_tarea_finalizada IS NULL OR tar_exp.tar_tarea_finalizada = 0)
                             AND ent.dd_ein_codigo = 2
                             AND sub_tipo.dd_sta_codigo <> 4
                             AND (tar_exp.tar_tarea_finalizada IS NULL OR tar_exp.tar_tarea_finalizada = 0)
                             AND tar_exp.borrado = 0))
        GROUP BY zon_id) tareas,
       (SELECT   o.ofi_codigo AS oficodigo, z.zon_cod, z.zon_id, z.zon_descripcion, COUNT (c.cli_id) AS cuenta
            FROM zon_zonificacion z, ofi_oficinas o, cli_clientes c
           WHERE z.ofi_id = o.ofi_id AND o.ofi_id = c.ofi_id
        GROUP BY o.ofi_codigo, z.zon_cod, z.zon_id, z.zon_descripcion) clientes,
       (
       SELECT   z.zon_id, z.zon_cod, COUNT (c.cnt_id) AS cuenta
            FROM cnt_contratos c, zon_zonificacion z
           WHERE c.ofi_id = z.ofi_id AND c.borrado = 0
        GROUP BY z.zon_id, z.zon_cod       
        ) contratos,
       (     
       SELECT   z.zon_id, z.zon_cod, COUNT (c.cnt_id) AS cuenta
            FROM cnt_contratos c, mov_movimientos m, zon_zonificacion z
           WHERE c.cnt_id = m.cnt_id AND c.cnt_fecha_extraccion = m.mov_fecha_extraccion AND m.mov_pos_viva_vencida <> 0 AND c.zon_id = z.zon_id AND c.borrado = 0 AND m.borrado = 0
        GROUP BY z.zon_id, z.zon_cod        
        ) contratosi,
       (SELECT   z.zon_id, z.zon_cod, SUM (m.mov_pos_viva_vencida) AS sumsaldovencido, SUM (m.mov_pos_viva_no_vencida) AS sumsaldonovencido
            FROM cnt_contratos c, zon_zonificacion z, mov_movimientos m
           WHERE c.ofi_id = z.ofi_id AND m.cnt_id = c.cnt_id AND m.mov_fecha_extraccion = c.cnt_fecha_extraccion AND c.borrado = 0 AND m.borrado = 0
        GROUP BY z.zon_id, z.zon_cod) saldos,
       (SELECT   sub2.ID AS zonid, sub2.cod AS cod, SUM (sub2.snv) AS suma
            FROM (SELECT   sub.ID AS ID, sub.cod AS cod, sub.cntid AS cntid, sub.snv AS snv, sub.sv AS sv, sub.perid AS perid, SUM (sub.mpvv) AS svc
                      FROM (SELECT z.zon_id AS ID, z.zon_cod AS cod, cnt.cnt_id AS cntid, mov.mov_pos_viva_no_vencida snv, mov.mov_pos_viva_vencida sv, per.per_id AS perid,
                                   mov2.mov_pos_viva_vencida AS mpvv, RANK () OVER (PARTITION BY cnt.cnt_id ORDER BY cpe.cpe_id) AS ranking
                              FROM cnt_contratos cnt JOIN zon_zonificacion z ON cnt.ofi_id = z.ofi_id
                                   JOIN mov_movimientos mov ON cnt.cnt_id = mov.cnt_id AND cnt.cnt_fecha_extraccion = mov.mov_fecha_extraccion
                                   JOIN cpe_contratos_personas cpe ON cnt.cnt_id = cpe.cnt_id AND (cpe.dd_tin_id = 208 OR cpe.dd_tin_id = 210)
                                   JOIN per_personas per ON cpe.per_id = per.per_id
                                   JOIN cpe_contratos_personas cpe2 ON per.per_id = cpe2.per_id
                                   JOIN cnt_contratos cnt2 ON cpe2.cnt_id = cnt2.cnt_id AND cnt2.borrado = 0
                                   LEFT JOIN mov_movimientos mov2 ON cnt2.cnt_id = mov2.cnt_id AND cnt2.cnt_fecha_extraccion = mov2.mov_fecha_extraccion AND mov2.mov_pos_viva_vencida != 0
                             WHERE cnt.borrado = 0 AND mov.mov_pos_viva_vencida = 0) sub
                     WHERE sub.ranking = 1
                  GROUP BY ID, cod, cntid, snv, sv, perid) sub2
           WHERE svc != 0
        GROUP BY sub2.ID, sub2.cod) saldoda
 WHERE clientes.zon_id = contratos.zon_id(+) AND clientes.zon_id = contratosi.zon_id(+) AND clientes.zon_id = saldos.zon_id(+) AND clientes.zon_id = saldoda.zonid(+) AND clientes.zon_id = tareas.zon_id(+);

COMMENT ON MATERIALIZED VIEW V_PC_ZONAS_JUDICIAL IS 'snapshot table for snapshot V_PC_ZONAS_JUDICIAL';
