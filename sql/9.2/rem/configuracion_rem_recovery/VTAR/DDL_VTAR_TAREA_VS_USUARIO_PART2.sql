
  CREATE OR REPLACE FORCE VIEW "REM01"."VTAR_TAREA_VS_USUARIO_PART2" ("TAR_ID", "USU_PENDIENTES", "USU_ALERTA", "USU_SUPERVISOR", "DD_TGE_ID_ALERTA", "DD_TGE_ID_PENDIENTE") AS 
  SELECT tar.tar_id, etn.tar_id_dest usu_pendientes, usu.usu_id, -1, -1, -1
		FROM REM01.tar_tareas_notificaciones tar
		JOIN REM01.etn_extareas_notificaciones etn on tar.TAR_ID = etn.TAR_ID
		LEFT JOIN REMMASTER.usu_usuarios usu on usu.usu_username = tar.tar_emisor
		WHERE tar.dd_sta_id IN (700,701) AND tar.borrado = 0
		;
 
