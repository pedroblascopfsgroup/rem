--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20160215
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-2102
--## PRODUCTO=NO
--## 
--## Finalidad: Asignacion estados de la subasta en funcion del TAP y FECHA_FIN_TAREA
--## INSTRUCCIONES:  
--## VERSIONES:
--##         0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET TIMING ON;
DECLARE

        TABLE_COUNT  NUMBER(3);
        EXISTE       NUMBER;
        V_SQL        VARCHAR2(12000 CHAR);
        
        V_ESQUEMA    VARCHAR2(25 CHAR):= 'CM01';
        V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'CMMASTER';
        USUARIO      VARCHAR2(50 CHAR):= 'MIGRACM01';
        
        ERR_NUM      NUMBER(25);
        ERR_MSG      VARCHAR2(1024 CHAR);
                    
        V_NUMBER     NUMBER;
        V_COUNT      NUMBER;    
  
        
BEGIN


    -- cambiar el estado de la subasta según hito actual del trámite de subasta
    EXECUTE IMMEDIATE('UPDATE '||V_ESQUEMA||'.sub_subasta sub set sub.DD_ESU_ID = (select dd_esu_id from '||V_ESQUEMA||'.DD_ESU_ESTADO_SUBASTA esu where esu.dd_esu_descripcion = ''CELEBRADA'')
        where sub.sub_id in (
            select distinct subb.sub_id
    from  '||V_ESQUEMA||'.tar_tareas_notificaciones tar 
        , '||V_ESQUEMA||'.prc_procedimientos prc 
        , (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_DESCRIPCION = ''T. de subasta - HCJ'') TPO
        , '||V_ESQUEMA||'.tex_tarea_externa tex
        , '||V_ESQUEMA||'.tap_tarea_procedimiento tap
        , '||V_ESQUEMA||'.sub_subasta subb                         
                where 
                    tar.prc_id = prc.prc_id
                AND prc.dd_tpo_id = tpo.dd_tpo_id
                AND prc.usuariocrear = '''||USUARIO||'''             
                AND tap.TAP_CODIGO in ( ''H002_CelebracionSubasta'' )
                AND tex.tar_id = tar.tar_id
                AND tex.TAP_ID = tap.tap_id
                AND subb.prc_id = prc.prc_id        
                AND tar.TAR_FECHA_FIN is NOT null
        )');

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MM:SS')||'  SUB_SUBASTA estado CELEBRADA actualizada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;

    EXECUTE IMMEDIATE('UPDATE '||V_ESQUEMA||'.sub_subasta sub set sub.DD_ESU_ID = (select dd_esu_id from '||V_ESQUEMA||'.DD_ESU_ESTADO_SUBASTA esu where esu.dd_esu_codigo = ''PAC'')
        where sub.sub_id in (
                    select  distinct subb.sub_id
    from  '||V_ESQUEMA||'.tar_tareas_notificaciones tar 
        , '||V_ESQUEMA||'.prc_procedimientos prc 
        , (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_DESCRIPCION = ''T. de subasta - HCJ'') TPO
        , '||V_ESQUEMA||'.tex_tarea_externa tex
        , '||V_ESQUEMA||'.tap_tarea_procedimiento tap
        , '||V_ESQUEMA||'.sub_subasta subb                         
                where 
                    tar.prc_id = prc.prc_id
                AND prc.dd_tpo_id = tpo.dd_tpo_id
                AND prc.usuariocrear = '''||USUARIO||'''             
                AND tap.TAP_CODIGO in (''H002_LecturaConfirmacionInstrucciones'',''H002_ObtenerValidacionComite'',''H002_DictarInstruccionesSubasta'')
                AND tex.tar_id = tar.tar_id
                AND tex.TAP_ID = tap.tap_id
                AND subb.prc_id = prc.prc_id        
                AND tar.TAR_FECHA_FIN is null
        )');


    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MM:SS')||'  SUB_SUBASTA estado PAC actualizada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;

    EXECUTE IMMEDIATE('UPDATE sub_subasta sub set sub.DD_ESU_ID = (select dd_esu_id from '||V_ESQUEMA||'.DD_ESU_ESTADO_SUBASTA esu where esu.dd_esu_codigo = ''PCO'')
        where sub.sub_id in (
                    select distinct subb.sub_id
    from  '||V_ESQUEMA||'.tar_tareas_notificaciones tar 
        , '||V_ESQUEMA||'.prc_procedimientos prc 
        , (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_DESCRIPCION = ''T. de subasta - HCJ'') TPO
        , '||V_ESQUEMA||'.tex_tarea_externa tex
        , '||V_ESQUEMA||'.tap_tarea_procedimiento tap
        , '||V_ESQUEMA||'.sub_subasta subb                         
                where 
                    tar.prc_id = prc.prc_id
                AND prc.dd_tpo_id = tpo.dd_tpo_id
                AND prc.usuariocrear = '''||USUARIO||'''             
                AND tap.TAP_CODIGO in (''H002_ValidarInformeDeSubasta'')
                AND tex.tar_id = tar.tar_id
                AND tex.TAP_ID = tap.tap_id
                AND subb.prc_id = prc.prc_id        
                AND tar.TAR_FECHA_FIN is null
        )');

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MM:SS')||'  SUB_SUBASTA estado PCO actualizada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;

    EXECUTE IMMEDIATE('UPDATE '||V_ESQUEMA||'.sub_subasta sub set sub.DD_ESU_ID = (select dd_esu_id from '||V_ESQUEMA||'.DD_ESU_ESTADO_SUBASTA esu where esu.dd_esu_codigo = ''PPR'')
          where sub.sub_id in (
                    select distinct subb.sub_id
    from  '||V_ESQUEMA||'.tar_tareas_notificaciones tar 
        , '||V_ESQUEMA||'.prc_procedimientos prc 
        , (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_DESCRIPCION = ''T. de subasta - HCJ'') TPO
        , '||V_ESQUEMA||'.tex_tarea_externa tex
        , '||V_ESQUEMA||'.tap_tarea_procedimiento tap
        , '||V_ESQUEMA||'.sub_subasta subb                         
                where 
                    tar.prc_id = prc.prc_id
                AND prc.dd_tpo_id = tpo.dd_tpo_id
                AND prc.usuariocrear = '''||USUARIO||'''             
                AND tap.TAP_CODIGO in (''H002_PrepararInformeSubasta'')
                AND tex.tar_id = tar.tar_id
                AND tex.TAP_ID = tap.tap_id
                AND subb.prc_id = prc.prc_id        
                AND tar.TAR_FECHA_FIN is null          
        )');

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MM:SS')||'  SUB_SUBASTA estado PPR actualizada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;

    EXECUTE IMMEDIATE('UPDATE '||V_ESQUEMA||'.sub_subasta sub set sub.DD_ESU_ID = (select dd_esu_id from DD_ESU_ESTADO_SUBASTA esu where esu.dd_esu_codigo = ''PCE'')
        where sub.sub_id in (
              select distinct subb.sub_id
    from  '||V_ESQUEMA||'.tar_tareas_notificaciones tar 
        , '||V_ESQUEMA||'.prc_procedimientos prc 
        , (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_DESCRIPCION = ''T. de subasta - HCJ'') TPO
        , '||V_ESQUEMA||'.tex_tarea_externa tex
        , '||V_ESQUEMA||'.tap_tarea_procedimiento tap
        , '||V_ESQUEMA||'.sub_subasta subb                         
                where 
                    tar.prc_id = prc.prc_id
                AND prc.dd_tpo_id = tpo.dd_tpo_id
                AND prc.usuariocrear = '''||USUARIO||'''             
                AND tap.TAP_CODIGO in (''H002_CelebracionSubasta'')
                AND tex.tar_id = tar.tar_id
                AND tex.TAP_ID = tap.tap_id
                AND subb.prc_id = prc.prc_id        
                AND tar.TAR_FECHA_FIN is null          
        )');

        -- 4227 filas actualizadas
        
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MM:SS')||'  SUB_SUBASTA estado PCE actualizada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;

    EXECUTE IMMEDIATE('UPDATE sub_subasta sub set sub.DD_ESU_ID = (select dd_esu_id from DD_ESU_ESTADO_SUBASTA esu where esu.dd_esu_codigo = ''PIN'')
        where sub.sub_id in (
                      select distinct subb.sub_id
    from  '||V_ESQUEMA||'.tar_tareas_notificaciones tar 
        , '||V_ESQUEMA||'.prc_procedimientos prc 
        , (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_DESCRIPCION = ''T. de subasta - HCJ'') TPO
        , '||V_ESQUEMA||'.tex_tarea_externa tex
        , '||V_ESQUEMA||'.tap_tarea_procedimiento tap
        , '||V_ESQUEMA||'.sub_subasta subb                         
                where 
                    tar.prc_id = prc.prc_id
                AND prc.dd_tpo_id = tpo.dd_tpo_id
                AND prc.usuariocrear = '''||USUARIO||'''             
                AND tap.TAP_CODIGO in (''H002_SolicitudSubasta'',''H002_SenyalamientoSubasta'',''H002_RevisarDocumentacion'')
                AND tex.tar_id = tar.tar_id
                AND tex.TAP_ID = tap.tap_id
                AND subb.prc_id = prc.prc_id        
                AND tar.TAR_FECHA_FIN is null          
        )');

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MM:SS')||'  SUB_SUBASTA estado PIN actualizada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;

    EXECUTE IMMEDIATE('UPDATE sub_subasta sub set sub.DD_ESU_ID = (select dd_esu_id from DD_ESU_ESTADO_SUBASTA esu where esu.dd_esu_codigo = ''SUS'')
        where sub.sub_id in (
                    select distinct subb.sub_id
    from  '||V_ESQUEMA||'.tar_tareas_notificaciones tar 
        , '||V_ESQUEMA||'.prc_procedimientos prc 
        , (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_DESCRIPCION = ''T. de subasta - HCJ'') TPO
        , '||V_ESQUEMA||'.tex_tarea_externa tex
        , '||V_ESQUEMA||'.tap_tarea_procedimiento tap
        , '||V_ESQUEMA||'.sub_subasta subb                         
                where 
                    tar.prc_id = prc.prc_id
                AND prc.dd_tpo_id = tpo.dd_tpo_id
                AND prc.usuariocrear = '''||USUARIO||'''             
                AND tap.TAP_CODIGO in (''H002_DictarInstruccionesDeneSuspension'')
                AND tex.tar_id = tar.tar_id
                AND tex.TAP_ID = tap.tap_id
                AND subb.prc_id = prc.prc_id        
                AND tar.TAR_FECHA_FIN is null                  
        )');

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  SUB_SUBASTA estado SUS actualizada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;


DBMS_OUTPUT.PUT_LINE( 'FIN DEL PROCESO');

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

