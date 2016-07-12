
  CREATE OR REPLACE FORCE VIEW "REM01"."VTAR_TAREA_VS_TGE" ("DD_TGE_ID_PENDIENTE", "DD_TGE_ID_ALERTA", "DD_TGE_ID_SUPERVISOR", "ASU_ID", "TAR_ID", "DD_STA_ID", "TAR_ID_DEST") AS 
  SELECT CASE
             WHEN (sta.dd_sta_id = 700 OR sta.dd_sta_id = 701)
                THEN -1
             WHEN NVL (tap.dd_tge_id, 0) != 0
                THEN tap.dd_tge_id
             WHEN sta.dd_tge_id IS NULL
                THEN CASE sta.dd_sta_gestor
                       WHEN 0
                          THEN 3
                       ELSE 2
                    END
             ELSE sta.dd_tge_id
          END dd_tge_id_pendiente,
          CASE
             WHEN (tar.tar_alerta IS NOT NULL AND tar.tar_alerta = 1)
                THEN NVL (tap.dd_tsup_id, 3)
             ELSE -1
          END dd_tge_id_alerta, NVL (tap.dd_tsup_id, 3) dd_tge_id_supervisor, tar.asu_id, tar.tar_id, tar.dd_sta_id, etn.tar_id_dest
     FROM REM01.tar_tareas_notificaciones tar
          JOIN ETN_EXTAREAS_NOTIFICACIONES etn ON etn.tar_id = tar.tar_id
          JOIN REMMASTER.dd_sta_subtipo_tarea_base sta ON tar.dd_sta_id = sta.dd_sta_id
          JOIN REMMASTER.dd_ein_entidad_informacion ein ON tar.dd_ein_id = ein.dd_ein_id
          LEFT JOIN REM01.tex_tarea_externa tex ON tar.tar_id = tex.tar_id
          LEFT JOIN REM01.tap_tarea_procedimiento tap ON tex.tap_id = tap.tap_id
    WHERE (tar.tar_tarea_finalizada IS NULL OR tar.tar_tarea_finalizada = 0) AND ein.dd_ein_codigo IN (3, 5, 2, 9, 10) AND tar.borrado = 0;
 
