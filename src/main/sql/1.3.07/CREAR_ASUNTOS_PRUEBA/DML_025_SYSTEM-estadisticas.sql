/* ANALIZAR TABLAS */
ANALYZE TABLE HAYAMASTER.USU_USUARIOS COMPUTE STATISTICS; -- ESTO DEBE HACERSE DESDE EL MASTER

ANALYZE TABLE HAYA01.PRC_PROCEDIMIENTOS COMPUTE STATISTICS;
ANALYZE TABLE HAYA01.ASU_ASUNTOS COMPUTE STATISTICS;
ANALYZE TABLE HAYA01.GAA_GESTOR_ADICIONAL_ASUNTO COMPUTE STATISTICS;
ANALYZE TABLE HAYA01.USD_USUARIOS_DESPACHOS COMPUTE STATISTICS;
ANALYZE TABLE HAYA01.TAR_TAREAS_NOTIFICACIONES COMPUTE STATISTICS;
ANALYZE TABLE HAYA01.TEX_TAREA_EXTERNA COMPUTE STATISTICS;

commit;