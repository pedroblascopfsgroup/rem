set heading on
set pagesize 50000
set feedback off
set linesize 250
col OWNER format a15
col TABLE_NAME format a50
col COLUMN_NAME format a50
col DATA_TYPE format a30
col NULLABLE format a5
SELECT atc.OWNER, atc.TABLE_NAME, atc.COLUMN_NAME,
DECODE(atc.DATA_TYPE, 'NUMBER', 'NUMBER('||atc.DATA_PRECISION||','||atc.DATA_SCALE||')','VARCHAR2','VARCHAR2('||atc.CHAR_LENGTH||' '||DECODE(atc.CHAR_USED,'C','CHAR','B','BYTE',atc.CHAR_USED)||')', atc.DATA_TYPE) AS DATA_TYPE,
DECODE(atc.NULLABLE, 'Y', 'Yes', 'N', 'No', ATC.NULLABLE) AS NULLABLE
FROM all_tab_columns atc
WHERE (atc.OWNER='SUT')
ORDER BY atc.TABLE_NAME, atc.COLUMN_NAME;
