--PFS02
col junk new_value v_date
select to_char(sysdate,'YYYY-MM-DD') junk
from dual;

col junk new_value v_time
select to_char(sysdate,'HH24MISS') junk
from dual;

col junk new_value v_entorno
select global_name junk from global_name ;

@configuracionPFS.sql

spool 06Interna3062&v_entorno&v_date&v_time..log
prompt 06Interna3062
connect &user2Usuario/&user2Password;
@06Interna3062.sql;
prompt 06Interna3062 FIN
spool off;

spool 07Externa3062&v_entorno&v_date&v_time..log
prompt 07Externa3062
connect &user2Usuario/&user2Password;
@Insertar_parametrizacion_completa.sql; 
prompt 07Externa3062 FIN
spool off;


