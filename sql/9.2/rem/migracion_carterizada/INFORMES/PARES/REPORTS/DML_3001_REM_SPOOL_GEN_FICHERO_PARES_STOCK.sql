
SET TERMOUT OFF HEADING OFF FEEDBACK OFF ECHO OFF PAGESIZE 0 LINESIZE 200

SPOOL INFORMES/PARES/OUTPUT/PARES_ACTIVOS_UVEM_REM.txt
  select '     ACTIVO_UVEM	      ACTIVO_REM'
  from dual
  union ALL
  select lpad(act_num_activo_uvem,16,0) ||'	'||  lpad(act_num_activo,16,0) 
  from REM01.act_activo act
  inner join REM01.dd_cra_cartera cra on act.dd_cra_id = cra.dd_cra_id 
  where cra.dd_cra_codigo ='03'
  ;
  
  
  
SPOOL OFF;
set echo on heading on feedback on termout on;


EXIT;
/
