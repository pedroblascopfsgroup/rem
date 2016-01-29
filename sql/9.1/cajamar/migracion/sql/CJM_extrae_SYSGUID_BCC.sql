--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20151203
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=XXXXXX
--## PRODUCTO=NO
--## 
--## Finalidad: Carga de claves y SYSGUID en la tbla TMP_GUID_BCC para hacer traspaso de SYSGUID a HRE
--## INSTRUCCIONES:  
--## VERSIONES:
--##        20151203 GMN  0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET TIMING ON;
DECLARE

        TABLE_COUNT  NUMBER(3);
        EXISTE       NUMBER;
        V_SQL        VARCHAR2(10000 CHAR);
        
        V_ESQUEMA    VARCHAR2(25 CHAR):= 'CM01';
        V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'CMMASTER';
        USUARIO      VARCHAR2(50 CHAR):= 'MIGRACM01';
        
        ERR_NUM      NUMBER(25);
        ERR_MSG      VARCHAR2(1024 CHAR);
                    
        V_NUMBER     NUMBER;
        V_COUNT      NUMBER;    
  
        
BEGIN

  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Inicio carga');   

  EXECUTE IMMEDIATE('TRUNCATE TABLE '||V_ESQUEMA||'.TMP_GUID_BCC');

--select count(*), GUID_DES
--from TMP_GUID_BCC
--GROUP BY GUID_DES
--order by GUID_DES;
  V_SQL:= null;

  V_SQL:= 'INSERT INTO TMP_GUID_BCC
        (   GUID_ID
          , GUID_SYSGUID
          , GUID_ASU_ID_EXTERNO
          , GUID_DES
          , GUID_DD_TPO_CODIGO
          , GUID_BIE_CODIGO_INTERNO
          , GUID_CNT_CONTRATO
          , GUID_TAP_CODIGO
        )
        SELECT asu.ASU_ID         AS GUID_ID
             , asu.SYS_GUID       AS GUID_SYSGUID
             , asu.ASU_ID_EXTERNO AS GUID_ASU_ID_EXTERNO --CD_PROCEDIMIENTO
             , ''ASU_ASUNTOS''    AS GUID_DES
             , null               AS GUID_DD_TPO_CODIGO  
             , null               AS GUID_BIE_CODIGO_INTERNO
             , null               AS GUID_CNT_CONTRATO
             , null               AS GUID_TAP_CODIGO
        FROM '||V_ESQUEMA||'.ASU_ASUNTOS ASU
        WHERE ASU.DD_TAS_ID = 1
          AND asu.USUARIOCREAR = ''MIGRACM01''';

   EXECUTE IMMEDIATE V_SQL;
  
   DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Registros de ASU_ASUNTOS insertados. '||SQL%ROWCOUNT||' Filas.');
   COMMIT;   
  

  EXECUTE IMMEDIATE('TRUNCATE TABLE '||V_ESQUEMA||'.TMP_GUID_PRB_PRC_BIE_CODIGO');

  V_SQL:= null;
  
-- TABLA INTERMEDIA TMP_GUID_PRB_PRC_BIE_CODIGO CON CODIGO_BIEN
  V_SQL:= 'INSERT INTO TMP_GUID_PRB_PRC_BIE_CODIGO 
     (  PRB_ID , PRC_ID , BIE_ID , USUARIOCREAR , BIE_CODIGO_INTERNO
     )
     SELECT  PRB_ID , PRC_ID, BIE_ID, USUARIOCREAR , BIE_CODIGO_INTERNO
     from (
            SELECT prb.PRB_ID
                 , prb.PRC_ID
                 , prb.BIE_ID
                 , prb.USUARIOCREAR
                 , bie.BIE_CODIGO_INTERNO
                 , RANK() OVER (PARTITION BY prb.PRC_ID ORDER BY bie.BIE_ID) AS RANKING     
            FROM
                 '||V_ESQUEMA||'.PRB_PRC_BIE prb
               , '||V_ESQUEMA||'.BIE_BIEN bie
            WHERE 
                   prb.BIE_ID = bie.BIE_ID               
               AND prb.USUARIOCREAR = ''MIGRACM01'' ) WHERE RANKING = 1'  ;


   EXECUTE IMMEDIATE V_SQL;
  
   COMMIT;


   CM01.UTILES.ANALIZA_TABLA('CM01','TMP_GUID_PRB_PRC_BIE_CODIGO');   
   DBMS_OUTPUT.PUT_LINE(V_ESQUEMA||'.UTILES.ANALIZA_TABLA( '''||V_ESQUEMA||''',''TMP_GUID_PRB_PRC_BIE_CODIGO'' )');   

-- PRC_PROCEDIMIENTOS
  
  V_SQL:= null;

  V_SQL:= 'INSERT INTO TMP_GUID_BCC
       (   GUID_ID
         , GUID_SYSGUID
         , GUID_ASU_ID_EXTERNO
         , GUID_DES
         , GUID_DD_TPO_CODIGO
         , GUID_BIE_CODIGO_INTERNO
         , GUID_CNT_CONTRATO
         , GUID_TAP_CODIGO
       )
       SELECT prc.PRC_ID             AS GUID_ID
            , prc.SYS_GUID           AS GUID_SYSGUID
            , asu.ASU_ID_EXTERNO     AS GUID_ASU_ID_EXTERNO
            , ''PRC_PROCEDIMIENTOS''   AS GUID_DES     
            , dd.DD_TPO_CODIGO       AS GUID_DD_TPO_CODIGO     
            , tmp.BIE_CODIGO_INTERNO AS GUID_BIE_CODIGO_INTERNO
            , null                   AS GUID_CNT_CONTRATO
            , null                   AS GUID_TAP_CODIGO     
       FROM '||V_ESQUEMA||'.ASU_ASUNTOS asu
          , '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS prc
          , '||V_ESQUEMA||'.TMP_GUID_PRB_PRC_BIE_CODIGO tmp
          , '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO dd
       WHERE prc.ASU_ID    = asu.ASU_ID 
         AND prc.DD_TPO_ID = dd.DD_TPO_ID  
         AND prc.PRC_ID    = tmp.PRC_ID (+)
         AND asu.DD_TAS_ID = 1
         AND asu.USUARIOCREAR = ''MIGRACM01''';

   EXECUTE IMMEDIATE V_SQL;
  
   DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Registros de PRC_PROCEDIMIENTOS insertados. '||SQL%ROWCOUNT||' Filas.');
   COMMIT;   
  
--PRB_PRC_BIE

  V_SQL:= 'INSERT INTO TMP_GUID_BCC
         (   GUID_ID
           , GUID_SYSGUID
           , GUID_ASU_ID_EXTERNO
           , GUID_DES
           , GUID_DD_TPO_CODIGO
           , GUID_BIE_CODIGO_INTERNO
           , GUID_CNT_CONTRATO
           , GUID_TAP_CODIGO
         )
         SELECT prb.PRB_ID             AS GUID_ID
              , prb.SYS_GUID            AS GUID_SYSGUID
              , asu.ASU_ID_EXTERNO     AS GUID_ASU_ID_EXTERNO     
              , ''PRB_PRC_BIE''          AS GUID_DES          
              , dd.DD_TPO_CODIGO       AS GUID_DD_TPO_CODIGO     
              , bie.BIE_CODIGO_INTERNO AS GUID_BIE_CODIGO_INTERNO
              , null                   AS GUID_CNT_CONTRATO
              , null                   AS GUID_TAP_CODIGO          
         FROM '||V_ESQUEMA||'.PRB_PRC_BIE prb
            , '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS prc
            , '||V_ESQUEMA||'.ASU_ASUNTOS asu
         --   , (SELECT BIE_ID, BIE_CODIGO_INTERNO, RANK() OVER (PARTITION BY BIE_CODIGO_INTERNO ORDER BY BIE_ID) AS RANKING FROM '||V_ESQUEMA||'.BIE_BIEN ) bie
            , '||V_ESQUEMA||'.BIE_BIEN bie
            , '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO dd   
         WHERE prb.PRC_ID    = prc.PRC_ID
           AND prb.BIE_ID    = bie.BIE_ID
           AND asu.ASU_ID    = prc.ASU_ID
           AND prc.DD_TPO_ID = dd.DD_TPO_ID    
           AND asu.DD_TAS_ID = 1
           AND asu.USUARIOCREAR = ''MIGRACM01''';  

   EXECUTE IMMEDIATE V_SQL;
  
   DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Registros de PRB_PRC_BIE insertados. '||SQL%ROWCOUNT||' Filas.');
   COMMIT;   


-- CEX_CONTRATOS_EXPEDIENTES

  V_SQL:= 'INSERT INTO TMP_GUID_BCC
        (   GUID_ID
          , GUID_SYSGUID
          , GUID_ASU_ID_EXTERNO
          , GUID_DES
          , GUID_DD_TPO_CODIGO
          , GUID_BIE_CODIGO_INTERNO
          , GUID_CNT_CONTRATO
          , GUID_TAP_CODIGO
        )
        SELECT cex.CEX_ID                 AS GUID_ID
             , cex.SYS_GUID               AS GUID_SYSGUID
             , asu.ASU_ID_EXTERNO         AS GUID_ASU_ID_EXTERNO --CD_PROCEDIMIENTO
             , ''CEX_CONTRATOS_EXPEDIENTE'' AS GUID_DES    
             , null                       AS GUID_DD_TPO_CODIGO     
             , null                       AS GUID_BIE_CODIGO_INTERNO
             , cnt.CNT_CONTRATO           AS GUID_CNT_CONTRATO
             , null                       AS GUID_TAP_CODIGO          
          FROM '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE cex
             , '||V_ESQUEMA||'.ASU_ASUNTOS asu
             , '||V_ESQUEMA||'.CNT_CONTRATOS cnt
          WHERE cex.CNT_ID = cnt.CNT_ID
            AND asu.EXP_ID = cex.EXP_ID
            AND asu.DD_TAS_ID = 1
            AND asu.USUARIOCREAR = ''MIGRACM01''';    
    
   EXECUTE IMMEDIATE V_SQL;
  
   DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Registros de CEX_CONTRATOS_EXPEDIENTE insertados. '||SQL%ROWCOUNT||' Filas.');
   COMMIT;   
    
-- TAR_TAREAS

  V_SQL:= 'INSERT INTO TMP_GUID_BCC
         (   GUID_ID
           , GUID_SYSGUID
           , GUID_ASU_ID_EXTERNO
           , GUID_DES
           , GUID_DD_TPO_CODIGO
           , GUID_BIE_CODIGO_INTERNO
           , GUID_CNT_CONTRATO
           , GUID_TAP_CODIGO
         )
         SELECT
                tar.TAR_ID                  AS GUID_ID
              , tar.SYS_GUID                AS GUID_SYSGUID
              , asu.ASU_ID_EXTERNO          AS GUID_ASU_ID_EXTERNO --CD_PROCEDIMIENTO
              , ''TAR_TAREAS_NOTIFICACIONES'' AS GUID_DES  
              , dd.DD_TPO_CODIGO            AS DD_TPO_CODIGO     
              , tmp.BIE_CODIGO_INTERNO      AS GUID_BIE_CODIGO_INTERNO
              , null                        AS GUID_CNT_CONTRATO     
              , tap.TAP_CODIGO              AS GUID_TAP_CODIGO
           FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES tar
              , '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS prc
              , '||V_ESQUEMA||'.ASU_ASUNTOS asu
              , '||V_ESQUEMA||'.TMP_GUID_PRB_PRC_BIE_CODIGO tmp     
              , '||V_ESQUEMA||'.TEX_TAREA_EXTERNA tex
              , '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO tap
              , '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO dd    
           WHERE tar.PRC_ID    = prc.PRC_ID
             AND prc.ASU_ID    = asu.ASU_ID
             AND prc.PRC_ID    = tmp.PRC_ID (+)    
             AND prc.DD_TPO_ID = dd.DD_TPO_ID        
             AND tar.TAR_ID    = tex.TAR_ID
             AND tex.TAP_ID    = tap.TAP_ID
             AND asu.DD_TAS_ID = 1
             AND asu.USUARIOCREAR = ''MIGRACM01''';    
   
   EXECUTE IMMEDIATE V_SQL;

   DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Registros de TAR_TAREAS_NOTIFICACIONES insertados. '||SQL%ROWCOUNT||' Filas.');
   COMMIT;   

-- SUB_SUBASTAS
  V_SQL:= 'INSERT INTO TMP_GUID_BCC
         (   GUID_ID
           , GUID_SYSGUID
           , GUID_ASU_ID_EXTERNO
           , GUID_DES
           , GUID_DD_TPO_CODIGO
           , GUID_BIE_CODIGO_INTERNO
           , GUID_CNT_CONTRATO
           , GUID_TAP_CODIGO
         )
         SELECT 
                sub.SUB_ID             AS GUID_ID
              , sub.SYS_GUID           AS GUID_SYSGUID
              , asu.ASU_ID_EXTERNO     AS GUID_ASU_ID_EXTERNO --CD_PROCEDIMIENTO  
              , ''SUB_SUBASTA''        AS GUID_DES           
              , dd.DD_TPO_CODIGO       AS GUID_DD_TPO_CODIGO       
              , tmp.BIE_CODIGO_INTERNO AS GUID_BIE_CODIGO_INTERNO
              , null                   AS GUID_CNT_CONTRATO
              , null                   AS GUID_TAP_CODIGO          
           FROM '||V_ESQUEMA||'.SUB_SUBASTA sub
              , '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS prc
              , '||V_ESQUEMA||'.ASU_ASUNTOS asu
              , '||V_ESQUEMA||'.TMP_GUID_PRB_PRC_BIE_CODIGO tmp              
              , '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO dd         
           WHERE sub.PRC_ID = prc.PRC_ID
             AND sub.ASU_ID = asu.ASU_ID
             AND prc.PRC_ID    = tmp.PRC_ID (+)        
             AND prc.DD_TPO_ID = dd.DD_TPO_ID           
             AND asu.DD_TAS_ID = 1
             AND asu.USUARIOCREAR = ''MIGRACM01''';    

   EXECUTE IMMEDIATE V_SQL;
  
   DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Registros de SUB_SUBASTA insertados. '||SQL%ROWCOUNT||' Filas.');
   COMMIT;   


-- LOS_LOTE_SUBASTA

  V_SQL:= 'INSERT INTO TMP_GUID_BCC
          (   GUID_ID
            , GUID_SYSGUID
            , GUID_ASU_ID_EXTERNO
            , GUID_DES
            , GUID_DD_TPO_CODIGO
            , GUID_BIE_CODIGO_INTERNO
            , GUID_CNT_CONTRATO
            , GUID_TAP_CODIGO
          )
          SELECT los.LOS_ID           AS SYS_GUID
               , los.SYS_GUID         AS GUID_SYSGUID
               , asu.ASU_ID_EXTERNO   AS GUID_ASU_ID_EXTERNO --CD_PROCEDIMIENTO
               , ''LOS_LOTE_SUBASTA'' AS GUID_DES        
               , null                 AS GUID_DD_TPO_CODIGO       
               , null                 AS GUID_BIE_CODIGO_INTERNO
               , null                 AS GUID_CNT_CONTRATO
               , null                 AS GUID_TAP_CODIGO          
            FROM '||V_ESQUEMA||'.LOS_LOTE_SUBASTA los
               , '||V_ESQUEMA||'.SUB_SUBASTA sub
               , '||V_ESQUEMA||'.ASU_ASUNTOS asu
            WHERE los.SUB_ID = sub.SUB_ID
              AND sub.ASU_ID = asu.ASU_ID
              AND asu.DD_TAS_ID = 1
              AND asu.USUARIOCREAR = ''MIGRACM01''';        


   EXECUTE IMMEDIATE V_SQL;
  
   DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Registros de LOS_LOTE_SUBASTA insertados. '||SQL%ROWCOUNT||' Filas.');
   COMMIT;   

   
   CM01.UTILES.ANALIZA_TABLA('CM01','TMP_GUID_BCC');   
   DBMS_OUTPUT.PUT_LINE(V_ESQUEMA||'.UTILES.ANALIZA_TABLA( '''||V_ESQUEMA||''',''TMP_GUID_BCC'' )');

   DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Fin carga');      
   
--/***************************************
--*     FIN EXTRAE SYSGUID               *
--***************************************/

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













