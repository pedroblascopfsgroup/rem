/* Formatted on 2013/06/27 19:29 (Formatter Plus v4.8.8) */
SELECT tpo.dd_tpo_codigo, prc.*
  FROM prc_procedimientos prc INNER JOIN dd_tpo_tipo_procedimiento tpo
       ON prc.dd_tpo_id = tpo.dd_tpo_id
 WHERE prc.asu_id = 123230;


SELECT vba.prc_id
  FROM v_msv_busqueda_asuntos vba
 WHERE vba.asu_id = 123230 AND ROWNUM = 1;


SELECT RES.PRC_ID FROM 
(SELECT PRC.PRC_ID
  FROM prc_procedimientos prc INNER JOIN tar_tareas_notificaciones tar
       ON prc.prc_id = tar.prc_id
 WHERE prc.borrado = 0
   AND prc.asu_id = 123230
   AND (tar.tar_tarea_finalizada = 0 OR tar.tar_tarea_finalizada IS NULL)
   AND (TAR.DD_STA_ID IN (39,40))
   AND prc.dd_epr_id NOT IN (4,5)
ORDER BY TAR.FECHACREAR DESC) RES
WHERE ROWNUM=1;