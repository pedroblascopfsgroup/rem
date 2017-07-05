set colsep ";"
set heading on
set pagesize 0 embedded on
set trimspool off
set linesize 2000

SET TERMOUT OFF
spool INFORMES/CONTRASTE/OUTPUT/REPORT-informe_contraste.csv

SELECT
  INTERFAZ
  , REGISTROS_ENTRADA					 		           AS "REGISTROS DE ENTRADA"
  , REGISTROS_RECHAZADOS						         AS "RECHAZADOS"
  , REGISTROS_INVALIDOS							         AS "ERRORES (ERROR > 1)"
  , REGISTROS_MIGRADOS							         AS "MIGRADOS "
FROM REM01.MIG2_INFORME_CONTRASTE
WHERE REGISTROS_RECHAZADOS IS NOT NULL
ORDER BY INTERFAZ
;


spool off
