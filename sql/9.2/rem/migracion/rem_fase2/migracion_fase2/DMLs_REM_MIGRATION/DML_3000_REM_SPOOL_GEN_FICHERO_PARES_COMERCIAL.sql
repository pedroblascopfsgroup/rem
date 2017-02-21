SET TERMOUT OFF HEADING OFF FEEDBACK OFF ECHO OFF PAGESIZE 0 LINESIZE 200
SPOOL ../../output_uvem/PARES_OFERTAS_UVEM_REM.txt
  select '     OFERTA_UVEM	      OFERTA_REM'
  from dual
  union ALL
  select lpad(ofr_num_oferta,16,0) ||'	'||  lpad(ofr_num_oferta,16,0) 
  from ofr_ofertas;

SPOOL OFF;
set echo on heading on feedback on termout on;

EXIT;
