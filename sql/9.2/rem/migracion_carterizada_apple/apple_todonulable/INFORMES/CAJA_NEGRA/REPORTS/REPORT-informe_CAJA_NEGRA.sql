set wrap off
set colsep ";"
set heading on
set pagesize 0 embedded on
set trimspool off
set linesize 2000

col CAJA_NEGRA_INDICADOR format a150
col CONCEPTO format a75

SET TERMOUT OFF
spool INFORMES/CAJA_NEGRA/OUTPUT/REPORT-informe_CAJA_NEGRA.csv

SELECT
    CAJA_NEGRA_INDICADOR CAJA_NEGRA_INDICADOR
  , NVL(REPLACE(CONCEPTO,'null','NULO'),'NULO') CONCEPTO
  , CANTIDAD             CANTIDAD
FROM REM01.MIG_INFORME_CAJA_NEGRA
ORDER BY CAJA_NEGRA_ID
;

spool off
