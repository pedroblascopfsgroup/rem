CREATE OR REPLACE FUNCTION obtenerProc(ASU_ID IN NUMBER) RETURN NUMBER IS
  PRC_ID NUMBER(16);
BEGIN 
   EXECUTE IMMEDIATE 
    'SELECT RES.PRC_ID FROM ' ||
    '(SELECT PRC.PRC_ID ' ||
    'FROM prc_procedimientos prc INNER JOIN tar_tareas_notificaciones tar ' ||
    '   ON prc.prc_id = tar.prc_id ' ||
    'WHERE prc.borrado = 0 ' ||
    'AND prc.asu_id = ' || ASU_ID || ' ' || 
    'AND (tar.tar_tarea_finalizada = 0 OR tar.tar_tarea_finalizada IS NULL) ' ||
    'AND (TAR.DD_STA_ID IN (39,40)) ' ||
    'AND prc.dd_epr_id NOT IN (4,5) ' ||
    'ORDER BY TAR.FECHACREAR DESC) RES ' ||
    'WHERE ROWNUM=1'
   INTO PRC_ID;
   RETURN PRC_ID;
END;
/ 