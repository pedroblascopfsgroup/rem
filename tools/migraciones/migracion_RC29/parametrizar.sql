prompt ******** ES NECESARIO COMPLETAR ESTE SCRIPT ********
quit;


col junk new_value v_date
select to_char(sysdate,'YYYY-MM-DD') junk
from dual;

col junk new_value v_time
select to_char(sysdate,'HH24MISS') junk
from dual;

col junk new_value v_entorno
select global_name junk from global_name ;

spool parametrizacionPFS&v_entorno&v_date&v_time..log

prompt **** PARAMETRIZANDO DICCIOARIOS DE DATOS **** 
connect pfsmaster/admin;
@;

prompt **** PARAMETRIZANDO EXTERNA PARA PFS01 **** 
connect pfs01/admin;
@;

prompt **** PARAMETRIZANDO EXTERNA PARA PFS02 **** 
connect pfs02/admin;
@;

prompt **** PARAMETRIZANDO EXTERNA PARA PFS03 **** 
connect pfs03/admin;
@;

spool off;
commit;
quit;


