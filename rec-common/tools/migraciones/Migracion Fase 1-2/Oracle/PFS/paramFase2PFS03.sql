--PFS03
col junk new_value v_date
select to_char(sysdate,'YYYY-MM-DD') junk
from dual;

col junk new_value v_time
select to_char(sysdate,'HH24MISS') junk
from dual;

col junk new_value v_entorno
select global_name junk from global_name ;

@configuracionPFS.sql

spool 08Interna3094&v_entorno&v_date&v_time..log
prompt 08Interna3094
connect &user3Usuario/&user3Password;
@08Interna3094.sql;
prompt 08Interna3094 FIN
spool off;

spool 09Externa3094&v_entorno&v_date&v_time..log
prompt 09Externa3094
connect &user3Usuario/&user3Password;
@Insertar_parametrizacion_completa.sql; 
prompt 09Externa3094 FIN
spool off;

