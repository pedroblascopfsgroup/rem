set wrap off
set colsep ";"
set heading on
set pagesize 0 embedded on
set trimspool off
set linesize 2000

col KPI_INDICADOR format a150
col CONCEPTO format a75

SET TERMOUT OFF
spool INFORMES/KPIS/OUTPUT/REPORT-informe_KPIS.csv

SELECT
  KPI_INDICADOR KPI_INDICADOR
  , NVL(CONCEPTO,'NULO') CONCEPTO
  , CANTIDAD CANTIDAD
FROM REM01.MIG2_INFORME_KPIS
ORDER BY KPI_ID
;

spool off
