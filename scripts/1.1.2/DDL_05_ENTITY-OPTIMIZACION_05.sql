-- Se indican los tipos de registros de las tablas materializadas creadas en la optimizaci�n

ALTER MATERIALIZED VIEW V_TAREA_TIPOANOTACION  REFRESH START WITH SYSDATE NEXT sysdate+1 COMPLETE;

ALTER MATERIALIZED VIEW V_TAREA_USUPENDIENTE  REFRESH START WITH SYSDATE NEXT sysdate+1 COMPLETE;