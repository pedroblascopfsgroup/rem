--/*
--##########################################
--## AUTOR=JTD
--## FECHA_CREACION=20160527
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-3388
--## PRODUCTO=NO
--## 
--## Finalidad: Borra TEX de tareas_notificaciones de decision
--##            Borra Gestores duplicados de la GAA y GAH
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
        
        V_ESQUEMA    VARCHAR2(25 CHAR):= 'HAYA02';
        V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER';
        USUARIO      VARCHAR2(50 CHAR):= 'MIGRA2HAYA02';
        
        ERR_NUM      NUMBER(25);
        ERR_MSG      VARCHAR2(1024 CHAR);
                    
        V_NUMBER     NUMBER;
        V_COUNT      NUMBER;    
  
        
BEGIN    
    ------------------
    --    TEX
    ------------------

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' EMPIEZA BORRADO DE TEX DE DECISION');
    
    V_SQL:='delete from '||V_ESQUEMA||'.tex_tarea_externa where tar_id in (select tar_id from '||V_ESQUEMA||
           '.tar_tareas_notificaciones where tar_descripcion = ''Tarea toma de decisión'' AND usuariocrear = ''MIGRA2HAYA02'')';
    EXECUTE IMMEDIATE V_SQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  BORRADOS DE TEX DE DECISION. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;

    ------------------
    --    GAA y GAH
    ------------------

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' EMPIEZA BORRADO GAA DUPLIS');
    V_SQL:='DELETE FROM '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO WHERE gaa_id IN (
                SELECT gaa_id FROM (
                SELECT distinct gaa_id, asu.asu_id, usd.usd_id, des_codigo
                  FROM '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa
                  JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE ON GAA.DD_TGE_ID = TGE.DD_TGE_ID
                  JOIN '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS USD ON GAA.USD_ID = USD.USD_ID 
                  JOIN '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO DES ON USD.DES_ID = DES.DES_ID 
                  JOIN '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU ON USD.USU_ID = USU.USU_ID
                  JOIN '||V_ESQUEMA||'.ASU_ASUNTOS ASU ON ASU.ASU_ID = GAA.ASU_ID
                  JOIN '||V_ESQUEMA||'.mig_procedimientos_cabecera migp on to_char(migp.cd_procedimiento) = asu.asu_id_externo  
                 WHERE TGE.DD_TGE_CODIGO IN (''GEXT'')
                   AND asu.usuariocrear = ''MIGRA2HAYA02''
                   AND des.des_codigo <> migp.CD_DESPACHO  
                   AND gaa.ASU_ID in
                    (SELECT ASU_ID FROM (
                    SELECT DISTINCT GAA.ASU_ID, Count(USD.USD_ID)  
                        FROM '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO GAA
                          JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE ON GAA.DD_TGE_ID = TGE.DD_TGE_ID
                          JOIN '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS USD ON GAA.USD_ID = USD.USD_ID
                          JOIN '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO DES ON USD.DES_ID = DES.DES_ID
                          JOIN '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU ON USD.USU_ID = USU.USU_ID
                          JOIN '||V_ESQUEMA||'.ASU_ASUNTOS ASU ON ASU.ASU_ID = GAA.ASU_ID
                        WHERE TGE.DD_TGE_CODIGO IN (''GEXT'')
                        AND asu.usuariocrear = ''MIGRA2HAYA02''
                        GROUP BY GAA.ASU_ID
                        HAVING Count(USD.USD_ID) > 1))))';
    EXECUTE IMMEDIATE V_SQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  BORRADOS DE GAA DUPLIS. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' EMPIEZA BORRADO GAH DUPLIS');
    V_SQL:='DELETE FROM '||V_ESQUEMA||'.gah_gestor_adicional_historico WHERE gah_id IN ( 
            SELECT gah_id FROM (
            SELECT distinct gah_id, asu.asu_id, usd.usd_id, des_codigo
             FROM '||V_ESQUEMA||'.gah_gestor_adicional_historico gah
             JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE ON gah.gah_tipo_gestor_id = TGE.DD_TGE_ID
             JOIN '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS USD ON gah.gah_gestor_id = USD.USD_ID 
             JOIN '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO DES ON USD.DES_ID = DES.DES_ID 
             JOIN '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU ON USD.USU_ID = USU.USU_ID
             JOIN '||V_ESQUEMA||'.ASU_ASUNTOS ASU ON ASU.ASU_ID = gah.gah_asu_id
             JOIN '||V_ESQUEMA||'.mig_procedimientos_cabecera migp on to_char(migp.cd_procedimiento) = asu.asu_id_externo  
            WHERE TGE.DD_TGE_CODIGO IN (''GEXT'')
              AND asu.usuariocrear = ''MIGRA2HAYA02''
              AND gah_fecha_hasta IS null
              AND des.des_codigo <> migp.CD_DESPACHO  
              AND gah.gah_asu_id in
                (SELECT ASU_ID FROM (
                SELECT DISTINCT GAh.gah_asu_id asu_id, Count(USD.USD_ID)  
                    FROM '||V_ESQUEMA||'.gah_gestor_adicional_historico gah
                      JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE ON gah.gah_tipo_gestor_id = TGE.DD_TGE_ID
                      JOIN '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS USD ON gah.gah_gestor_id = USD.USD_ID
                      JOIN '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO DES ON USD.DES_ID = DES.DES_ID
                      JOIN '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU ON USD.USU_ID = USU.USU_ID
                      JOIN '||V_ESQUEMA||'.ASU_ASUNTOS ASU ON ASU.ASU_ID = gah.gah_asu_id
                    WHERE TGE.DD_TGE_CODIGO IN (''GEXT'')
                    AND asu.usuariocrear = ''MIGRA2HAYA02''
                    AND gah_fecha_hasta IS null
                    GROUP BY gah.gah_asu_id
                    HAVING Count(USD.USD_ID) > 1))))';
    
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  BORRADOS DE GAH DUPLIS. '||SQL%ROWCOUNT||' Filas.');
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
