col junk new_value v_date
select to_char(sysdate,'YYYY-MM-DD') junk
from dual;

col junk new_value v_time
select to_char(sysdate,'HH24MISS') junk
from dual;

col junk new_value v_entorno
select global_name junk from global_name ;

@configuracionPFS.sql
-- MASTER actualización usuarios de las entidades  
spool 01master3177&v_entorno&v_date&v_time..log
prompt 01master3177
connect &userMasterusuario/&userMasterPassword;
@01master3177.sql;
prompt 01master3177 FIN
spool off;

--PFS01
spool 04Interna3177&v_entorno&v_date&v_time..log
prompt 04Interna3177
connect &user1Usuario/&user1Password;
@04Interna3177.sql;
prompt 04Interna3177 FIN
spool off;

spool 05Externa3177&v_entorno&v_date&v_time..log
prompt 05Externa3177
connect &user1Usuario/&user1Password;
@Insertar_parametrizacion_pfs01.sql; 
prompt 05Externa3177 FIN
spool off;

