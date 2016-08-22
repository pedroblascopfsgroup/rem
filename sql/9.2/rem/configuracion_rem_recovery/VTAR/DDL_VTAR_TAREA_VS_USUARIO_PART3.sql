
  CREATE OR REPLACE FORCE VIEW "REM01"."VTAR_TAREA_VS_USUARIO_PART3" ("TAR_ID", "USU_PENDIENTES", "USU_ALERTA", "USU_SUPERVISOR", "DD_TGE_ID_ALERTA", "DD_TGE_ID_PENDIENTE") AS 
  SELECT tac.tar_id, tac.usu_id, tac.sup_id, tac.sup_id, -1, -1
		FROM REM01.tac_tareas_activos tac
		JOIN REM01.tar_tareas_notificaciones tar on tar.TAR_ID = tac.TAR_ID
		WHERE (tar.tar_tarea_finalizada = 0)AND tar.borrado = 0
		;
 
