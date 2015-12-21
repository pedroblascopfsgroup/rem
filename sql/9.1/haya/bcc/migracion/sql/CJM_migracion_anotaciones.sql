/*********** SCRIPT *****************/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET TIMING ON;
DECLARE

 table_count       number(3);
 v_count           number(16);
 
 v_sql             varchar2(4000);
 err_num           number(25);
 err_msg           varchar2(1024 char);
 
 v_esquema         varchar2(25 char):= 'HAYA02';
 v_esquema_master  varchar2(25 char):= 'HAYAMASTER';
 usuario           varchar2(50 char):= 'MIGRAHAYA02';
 
 v_dd_ein_id       number(16);
 v_dd_sta_id       number(16);
 v_dd_trg_id       number(16);
 v_usu_id          number(16);
 v_sysdate         number;

 
BEGIN

 ---------------------------------
 -- Migración de notificaciones --
 ---------------------------------

dbms_output.put_line('[INI] - '||to_char(sysdate,'HH24:MI:SS')||' Inicio del proceso de migración de anotaciones.');

    --** Asignamos valores de diccionario
    v_sql:= 'select dd_ein_id from '||v_esquema_master||'.dd_ein_entidad_informacion where dd_ein_codigo = ''9'''; --persona
    execute immediate v_sql into v_dd_ein_id;
    
    v_sql:= 'select dd_sta_id from '||v_esquema_master||'.dd_sta_subtipo_tarea_base where dd_sta_codigo = ''701'''; --anotacion
    execute immediate v_sql into v_dd_sta_id; 
    
    v_sql:= 'select dd_trg_id from '||v_esquema||'.mej_dd_trg_tipo_registro where dd_trg_codigo = ''ANO_NOTIFICACION'''; --probar si no 'ANO_COMENTARIO'
    execute immediate v_sql into v_dd_trg_id;
    
    v_sql:= 'select max(usu_id) from '||v_esquema_master||'.usu_usuarios'; -- Falta crear usuario de migración
    execute immediate v_sql into v_usu_id;
    
    v_sql:= 'select (sysdate - to_date(''01/01/1970 00:00:00'', ''mm-dd-yyyy hh24:mi:ss'')) * 24 * 60 * 60 * 1000 from dual';
    execute immediate v_sql into v_sysdate;


    --** Borramos antes de crear
    v_count := 0;
    v_sql:= 'select count(*) from all_tables where table_name = ''MIG_TMP_TAR_TAREAS_NOTIF'' and owner = '''||v_esquema||'''';
    execute immediate v_sql into v_count;
    if (v_count>0) then execute immediate('drop table '||v_esquema||'.MIG_TMP_TAR_TAREAS_NOTIF'); end if;


    --** Creamos temporal para no mezclarlas en tar_tareas_notificaciones
    v_sql := 'Create table '||v_esquema||'.mig_tmp_tar_tareas_notif
              as
              Select '||v_esquema||'.s_mej_reg_registro.nextval          as reg_id
                   , '||v_esquema||'.s_tar_tareas_notificaciones.nextval as tar_id
                   , '||v_dd_trg_id||'        as dd_trg_id
                   , '||v_dd_ein_id||'        as dd_ein_id
                   , '||v_dd_sta_id||'        as dd_sta_id
                   , ''3''                    as tar_codigo
                   , ''Anotacion''            as tar_tarea
                   , mig.texto_anotacion      as tar_descripcion
                   , mig.fecha_anotacion      as tar_fecha_ini
                   , ''0''                    as tar_en_espera
                   , ''0''                    as tar_alerta
                   , '''||usuario||'''        as tar_emisor
                   , ''EXTTareaNotificacion'' as dType
                   , ''U''                    as tar_tipo_destinatario
                   , per.per_id               as per_id
                From '||v_esquema||'.mig_anotaciones mig
                   , '||v_esquema||'.per_personas    per
               Where mig.codigo_entidad = per.per_cod_entidad
                 And mig.codigo_entidad||mig.codigo_persona = per.per_cod_cliente_entidad
              ';
    execute immediate v_sql;
    v_count := sql%rowcount;

    dbms_output.put_line('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||v_esquema||'.MIG_TMP_TAR_TAREAS_NOTIF Creada. Filas: '||v_count);
    dbms_stats.gather_table_stats (ownname => v_esquema, tabname => 'MIG_TMP_TAR_TAREAS_NOTIF', estimate_percent => 20);
    dbms_output.put_line('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||v_esquema||'.MIG_TMP_TAR_TAREAS_NOTIF Estadísticas actualizadas');



    --** Insertamos en TAR_TAREAS_NOTIFICACIONES las nuevas tareas generadas.
    v_sql := 'Insert into '||v_esquema||'.TAR_TAREAS_NOTIFICACIONES
               ( TAR_ID, DD_EIN_ID, DD_STA_ID, TAR_CODIGO, TAR_TAREA, TAR_DESCRIPCION, TAR_FECHA_INI, TAR_EN_ESPERA,TAR_ALERTA,TAR_EMISOR
               , VERSION, USUARIOCREAR, FECHACREAR, BORRADO,DTYPE, TAR_TIPO_DESTINATARIO, PER_ID )
              Select tar_id, dd_ein_id, dd_sta_id, tar_codigo, tar_tarea, tar_descripcion, tar_fecha_ini, tar_en_espera,tar_alerta,tar_emisor
                   , ''0'' as version, '''||usuario||''' as usuariocrear, sysdate as fechacrear, ''0'' as borrado, dType, tar_tipo_destinatario, per_id
                From '||v_esquema||'.mig_tmp_tar_tareas_notif
             ';
    execute immediate v_sql;
    v_count := sql%rowcount;

    dbms_output.put_line('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||v_esquema||'.TAR_TAREAS_NOTIFICACIONES Cargada. Filas: '||v_count);
    dbms_stats.gather_table_stats (ownname => v_esquema, tabname => 'TAR_TAREAS_NOTIFICACIONES', estimate_percent => 20);
    dbms_output.put_line('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||v_esquema||'.MIG_TMP_TAR_TAREAS_NOTIF Estadisticas actualizadas'); 
    commit;



    --** Insertamos en MEJ_REG_REGISTRO un registro por tarea.
    v_sql := 'Insert into '||v_esquema||'.MEJ_REG_REGISTRO 
                (REG_ID, DD_TRG_ID, TRG_EIN_CODIGO, TRG_EIN_ID, USU_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
              Select reg_id
                   , dd_trg_id
                   , ''9'' as dd_trg_ein_codigo
                   , per_id
                   , '||v_usu_id||' as usu_id --- ???
                   , ''0'' as version
                   , '''||usuario||''' as usuariocrear
                   , sysdate as fechacrear
                   , ''0'' as borrado
                From '||v_esquema||'.mig_tmp_tar_tareas_notif'; 
    execute immediate v_sql;
    v_count := sql%rowcount;

    dbms_output.put_line('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||v_esquema||'.MEJ_REG_REGISTRO Cargada. Filas: '||v_count);
    dbms_stats.gather_table_stats (ownname => v_esquema, tabname => 'MEJ_REG_REGISTRO', estimate_percent => 20);
    dbms_output.put_line('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||v_esquema||'.MEJ_REG_REGISTRO Estadisticas actualizadas'); 
    commit;



    --** Insertamos en MEJ_IRG_INFO_REGISTRO la info de los registros generados, por producto cartesiano.
    v_sql := 'Insert into MEJ_IRG_INFO_REGISTRO (IRG_ID,REG_ID,IRG_CLAVE,IRG_VALOR,IRG_VALOR_CLOB,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)
              With tmp_irg_claves as
                (
                select cast(''TIPO_ANO_NOTIF''     as varchar2(20 char)) as irg_clave from dual 
                union
                select cast(''FECHA_CREAR_NOTIF''  as varchar2(20 char)) as irg_clave from dual 
                union
                select cast(''ID_NOTIF''           as varchar2(20 char)) as irg_clave from dual 
                union
                select cast(''DESCRIPCION_NOTIF''  as varchar2(20 char)) as irg_clave from dual 
                union
                select cast(''ASUNTO_NOTIF''       as varchar2(20 char)) as irg_clave from dual 
                union
                select cast(''DESTINATARIO_NOTIF'' as varchar2(20 char)) as irg_clave from dual 
                union
                select cast(''EMISOR_NOTIF''       as varchar2(20 char)) as irg_clave from dual
                )
              Select '||v_esquema||'.s_mej_irg_info_registro.nextval as irg_id
                   , tmp.reg_id
                   , sub.irg_clave
                   , decode(sub.irg_clave
                           ,''TIPO_ANO_NOTIF'', ''R''
                           ,''FECHA_CREAR_NOTIF'', '||v_sysdate||'
                           ,''ID_NOTIF'', tmp.tar_id
                           ,''DESCRIPCION_NOTIF'', substr(tmp.tar_descripcion,1,255)
                           ,''ASUNTO_NOTIF'', ''Anotacion migrada''
                           ,''DESTINATARIO_NOTIF'', null
                           ,''EMISOR_NOTIF'', '||v_usu_id||'
                           ) as irg_valor
                   , tmp.tar_descripcion as irg_valor_clob
                   , ''0'' as version
                   , '''||usuario||''' as usuariocrear
                   , sysdate as fechacrear
                   ,''0'' as borrado
                From '||v_esquema||'.mig_tmp_tar_tareas_notif tmp, tmp_irg_claves sub';
    execute immediate v_sql;
    v_count := sql%rowcount;
    
    dbms_output.put_line('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||v_esquema||'.MEJ_IRG_INFO_REGISTRO Cargada. Filas :'||v_count);
    dbms_stats.gather_table_stats (ownname => v_esquema, tabname => 'MEJ_IRG_INFO_REGISTRO', estimate_percent => 20);
    dbms_output.put_line('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||v_esquema||'.MEJ_IRG_INFO_REGISTRO Estadisticas actualizadas'); 
    commit;
    
    --** Borramos temporal
    execute immediate('drop table '||v_esquema||'.MIG_TMP_TAR_TAREAS_NOTIF');
    dbms_output.put_line('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||v_esquema||'.MIG_TMP_TAR_TAREAS_NOTIF eliminada');

dbms_output.put_line('[FIN] - '||to_char(sysdate,'HH24:MI:SS')||' Fin del proceso de migración de anotaciones.');

EXCEPTION
    WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
      DBMS_OUTPUT.put_line(V_SQL);
      DBMS_OUTPUT.put_line('-----------------------------------------------------------');
      DBMS_OUTPUT.put_line(ERR_MSG);
      ROLLBACK;
      RAISE;

END;
/

EXIT;
