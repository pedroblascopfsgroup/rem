col junk new_value v_date
select to_char(sysdate,'YYYY-MM-DD') junk
from dual;

col junk new_value v_time
select to_char(sysdate,'HH24MISS') junk
from dual;

col junk new_value v_entorno
select global_name junk from global_name ;

spool migracion&v_entorno&v_date&v_time..log

@configuracion.sql
/***********************************************************************
******************* DEHABILITO CONSTRAINTS *****************************
************************************************************************/
prompt Deshabilitando constraints de &userMasterSchema
connect &userMasterusuario/&userMasterPassword;
@deshabilitar.Constraints.sql;
prompt Constraints de &userMasterSchema deshabilitadas

prompt Deshabilitando constraints de &user1Schema
connect &user1Usuario/&user1Password;
@deshabilitar.Constraints.sql;
prompt Constraints de &user1Schema deshabilitadas


/***********************************************************************
***************** FIN DEHABILITO CONSTRAINTS ***************************
************************************************************************/

-- Migrando el master
prompt Conectando al Master......
connect &userMasterusuario/&userMasterPassword;
prompt Conectado
prompt Se invoca al script 01.crear.tablas.master.sql
@Master/01.crear.tablas.master.sql
prompt Script Finalizado

prompt Se invoca al script 011.modificar.tablas.master.sql
@Master/011.modificar.tablas.master.sql
prompt Script Finalizado


prompt Se invoca al script 02.crear.secuencias.master.sql
@Master/02.crear.secuencias.master.sql
prompt Script Finalizado
prompt Se invoca al script 03.crear.constraints.master.sql
@Master/03.crear.constraints.master.sql
prompt Script Finalizado
prompt Se invoca al script 04.grants.master.sql
@Master/04.grants.master.sql
prompt Script Finalizado
prompt Se invoca al script 04.masterDataLoad.sql
@Master/05.masterDataLoad.sql
prompt Script Finalizado


-- Migrando PFS01
prompt Conectando a PFS01
connect &user1Usuario/&user1Password;
prompt Conectado
prompt Se invoca al script migrar.entidad.sql
@migrar.entidad.sql &user1InitialId;
prompt Script Finalizado

-- Migrando el master
prompt Conectando al Master......
connect &userMasterusuario/&userMasterPassword;
prompt Conectado
prompt Se invoca al script borrar.master.sql
@Master/borrar.master.sql;
prompt Script Finalizado

/***********************************************************************
******************* HABILITO CONSTRAINTS *****************************
************************************************************************/
prompt Habilitando constraints de &userMasterSchema
connect &userMasterusuario/&userMasterPassword;
@habilitar.Constraints.sql;
prompt Constraints de &userMasterSchema Habilitadas

prompt Habilitando constraints de &user1Schema
connect &user1Usuario/&user1Password;
@habilitar.Constraints.sql;
prompt Constraints de &user1Schema Habilitadas


/***********************************************************************
***************** FIN HABILITO CONSTRAINTS ***************************
************************************************************************/

spool off;

/***********************************************************************
***************** PERMISOS AL MASTER ***************************
************************************************************************/
prompt Grant de las entidades al master
connect &userMasterusuario/&userMasterPassword;
@masterGrantsScript-Oracle9iDialect.sql;
prompt Fin Grant de las entidades al master

/***********************************************************************
***************** Actualizar Tareas Exp Cancelados ***************************
************************************************************************/
prompt Actualizar Tareas Exp Cancelados
connect &user1Usuario/&user1Password;
@borrarTareasExpCancelado.sql;
prompt Fin Actualizar Tareas Exp Cancelados

/***********************************************************************
***************** Actualizar Tareas Exp Cancelados ***************************
************************************************************************/
prompt Actualizar Tareas Asuntos
connect &user1Usuario/&user1Password;
@borrarTareasAsuntos.sql;
prompt Fin Actualizar Tareas Asuntos

/***********************************************************************
***************** CU-20 ***************************
************************************************************************/
col junk new_value v_date
select to_char(sysdate,'YYYY-MM-DD') junk
from dual;

col junk new_value v_time
select to_char(sysdate,'HH24MISS') junk
from dual;

col junk new_value v_entorno
select global_name junk from global_name ;



spool cu20&v_entorno&v_date&v_time..log

prompt CU-20
connect &user1Usuario/&user1Password;
update pfs01.prc_procedimientos set cex_id = 1,usuarioborrar = 'MIGFASE1-2',fechaborrar = sysdate where cex_id is null and prc_id in(1,1801,1301,1302,1802,1201);


@MigracionCUF3_WEB-20.sql;
prompt Fin CU-20

spool off;
/***********************************************************************
***************** Nombre Expedientes ***************************
************************************************************************/
prompt Nombres Expedientes
connect &user1Usuario/&user1Password;
@creaNombresExpedientes.sql;
prompt Fin Nombres Expedientes

/***********************************************************************
***************** Borrado de clientes duplicados ***********************
************************************************************************/
col junk new_value v_date
select to_char(sysdate,'YYYY-MM-DD') junk
from dual;

col junk new_value v_time
select to_char(sysdate,'HH24MISS') junk
from dual;

col junk new_value v_entorno
select global_name junk from global_name ;


spool borrarClientes&v_entorno&v_date&v_time..log

prompt borrarClientes
connect &user1Usuario/&user1Password;
@borrarClientes.sql;
prompt fin borrarClientes

spool off;


