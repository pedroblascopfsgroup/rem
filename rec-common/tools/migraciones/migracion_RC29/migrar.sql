col junk new_value v_date
select to_char(sysdate,'YYYY-MM-DD') junk
from dual;

col junk new_value v_time
select to_char(sysdate,'HH24MISS') junk
from dual;

col junk new_value v_entorno
select global_name junk from global_name ;

spool migracion&v_entorno&v_date&v_time..log

prompt **** Migrando pfsmaster **** 
connect pfsmaster/admin;
@cambiosPFSMASTER.sql;

prompt **** Migrando pfs01 **** 
connect pfs01/admin;
@cambiosPFS01.sql;

prompt **** Migrando pfs02 **** 
connect pfs02/admin;
@cambiosPFS02.sql;

prompt **** Migrando pfs03 **** 
connect pfs03/admin;
@cambiosPFS03.sql;

spool off;
commit;
quit;


