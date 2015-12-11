--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20151203
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=XXXXXX
--## PRODUCTO=NO
--## 
--## Finalidad: Carga de claves y SYSGUID en la tbla TMP_GUID_HRE para hacer traspaso de SYSGUID a HRE
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
        
        V_ESQUEMA    VARCHAR2(25 CHAR):= 'HAYA02';
        V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER';
        USUARIO      VARCHAR2(50 CHAR):= 'MIGRAHAYA02';
        
        ERR_NUM      NUMBER(25);
        ERR_MSG      VARCHAR2(1024 CHAR);
                    
        V_NUMBER     NUMBER;
        V_COUNT      NUMBER;    
  
        
BEGIN

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Inicio carga');   

    HAYA02.UTILES.ANALIZA_TABLA('HAYA02','TMP_GUID_HRE');   
    DBMS_OUTPUT.PUT_LINE(V_ESQUEMA||'.UTILES.ANALIZA_TABLA( '''||V_ESQUEMA||''',''TMP_GUID_HRE'' )');    

   --quitamos duplicado por bienes repetidos

    EXECUTE IMMEDIATE('TRUNCATE TABLE '||V_ESQUEMA||'.TMP_GUID_HRE_2'); 
   
    V_SQL:= 'INSERT INTO '||V_ESQUEMA||'.TMP_GUID_HRE_2
             (  GUID_SYSGUID
              , GUID_ASU_ID_EXTERNO
              , GUID_DES
              , GUID_DD_TPO_CODIGO
              , GUID_BIE_CODIGO_INTERNO
              , GUID_CNT_CONTRATO
              , GUID_TAP_CODIGO 
              )
           SELECT DISTINCT GUID_SYSGUID
              , GUID_ASU_ID_EXTERNO
              , GUID_DES
              , GUID_DD_TPO_CODIGO
              , GUID_BIE_CODIGO_INTERNO
              , GUID_CNT_CONTRATO
              , GUID_TAP_CODIGO 
            FROM '||V_ESQUEMA||'.TMP_GUID_HRE';

    EXECUTE IMMEDIATE V_SQL;

    COMMIT;


    HAYA02.UTILES.ANALIZA_TABLA('HAYA02','TMP_GUID_HRE_2');   
    DBMS_OUTPUT.PUT_LINE(V_ESQUEMA||'.UTILES.ANALIZA_TABLA( '''||V_ESQUEMA||''',''TMP_GUID_HRE_2'' )');    
   
--select count(*), GUID_DES
--from TMP_GUID_HRE
--GROUP BY GUID_DES
--order by GUID_DES;

     EXECUTE IMMEDIATE('TRUNCATE TABLE '||V_ESQUEMA||'.TMP_GUID_ASU_ASUNTOS_HRE'); 
    
     V_SQL:= null;

     V_SQL:= 'insert into '||V_ESQUEMA||'.TMP_GUID_ASU_ASUNTOS_HRE (SYS_GUID, ASU_ID)
                           SELECT tmp.GUID_SYSGUID, hre.ASU_ID  
                                   FROM '||V_ESQUEMA||'.TMP_GUID_HRE_2 tmp
                                      , '||V_ESQUEMA||'.ASU_ASUNTOS hre
                                   WHERE tmp.GUID_ASU_ID_EXTERNO = hre.ASU_ID_EXTERNO
                                     AND tmp.GUID_DES = ''ASU_ASUNTOS''
                                     AND hre.USUARIOCREAR = ''MIGRAHAYA02''';
  
     EXECUTE IMMEDIATE V_SQL;
     COMMIT;
     HAYA02.UTILES.ANALIZA_TABLA('HAYA02','TMP_GUID_ASU_ASUNTOS_HRE');   

     V_SQL:= 'UPDATE (SELECT asuhre.SYS_GUID AS old_SYS_GUID,
                           tmp.SYS_GUID    AS new_SYS_GUID
                      FROM '||V_ESQUEMA||'.ASU_ASUNTOS asuhre
                      INNER JOIN '||V_ESQUEMA||'.TMP_GUID_ASU_ASUNTOS_HRE tmp 
                              ON asuhre.ASU_ID = tmp.ASU_ID 
                      WHERE asuhre.USUARIOCREAR = ''MIGRAHAYA02''
                     )
                SET old_SYS_GUID = new_SYS_GUID';    
     
     
--      V_SQL:= 'UPDATE '||V_ESQUEMA||'.ASU_ASUNTOS hre
--               SET hre.SYS_GUID = (SELECT tmp.GUID_SYSGUID
--                                   FROM '||V_ESQUEMA||'.TMP_GUID_HRE tmp
--                                   WHERE tmp.GUID_ASU_ID_EXTERNO = hre.ASU_ID_EXTERNO
--                                     AND tmp.GUID_DES = ''ASU_ASUNTOS''
--                                     AND hre.USUARIOCREAR = ''MIGRAHAYA02''      )';

     EXECUTE IMMEDIATE V_SQL;
  
     DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Registros de ASU_ASUNTOS actualizados. '||SQL%ROWCOUNT||' Filas.');
     COMMIT;   
  

  EXECUTE IMMEDIATE('TRUNCATE TABLE '||V_ESQUEMA||'.TMP_HAYA_PRC_SYSGUID');

  V_SQL:= null;  
  
-- TABLA INTERMEDIA CON CODIGO_BIEN
 V_SQL:= 'INSERT INTO '||V_ESQUEMA||'.TMP_HAYA_PRC_SYSGUID (PRC_ID, ASU_ID, ASU_ID_EXTERNO, DD_TPO_CODIGO, BIE_CODIGO_INTERNO)
          SELECT DISTINCT PRC.PRC_ID, ASU.ASU_ID, ASU.ASU_ID_EXTERNO, TPO.DD_TPO_CODIGO, XX.BIE_CODIGO_INTERNO
          FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
             INNER JOIN '||V_ESQUEMA||'.ASU_ASUNTOS ASU ON PRC.ASU_ID = ASU.ASU_ID 
             INNER JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON PRC.DD_TPO_ID = TPO.DD_TPO_ID
           LEFT OUTER JOIN 
           ( SELECT TT.* FROM (
             SELECT PRB.PRC_ID, BB.BIE_CODIGO_INTERNO, RANK ()  OVER (PARTITION BY PRB.PRC_ID ORDER BY BB.BIE_CODIGO_INTERNO) AS RANKING
             FROM '||V_ESQUEMA||'.PRB_PRC_BIE PRB 
               INNER JOIN '||V_ESQUEMA||'.BIE_BIEN BB ON BB.BIE_ID = PRB.BIE_ID
               )TT WHERE TT.RANKING = 1
            ) XX ON XX.PRC_ID = PRC.PRC_ID  
         WHERE PRC.USUARIOCREAR = ''MIGRAHAYA02''
           AND ASU.USUARIOCREAR = ''MIGRAHAYA02''';

--  V_SQL:= 'INSERT INTO TMP_GUID_PRB_PRC_BIE_CODIGO 
--     (  PRB_ID , PRC_ID , BIE_ID , USUARIOCREAR , BIE_CODIGO_INTERNO
--     )
--     SELECT  PRB_ID , PRC_ID, BIE_ID, USUARIOCREAR , BIE_CODIGO_INTERNO
--     from (
--            SELECT prb.PRB_ID
--                 , prb.PRC_ID
--                 , prb.BIE_ID
--                 , prb.USUARIOCREAR
--                 , bie.BIE_CODIGO_INTERNO
--                 , RANK() OVER (PARTITION BY prb.PRC_ID ORDER BY bie.BIE_CODIGO_INTERNO) AS RANKING     
--            FROM
--                 '||V_ESQUEMA||'.PRB_PRC_BIE prb
--               ,  ||V_ESQUEMA||'.BIE_BIEN  bie
--            WHERE 
--                   prb.BIE_ID = bie.BIE_ID               
--               AND prb.USUARIOCREAR = ''MIGRAHAYA02'' ) WHERE RANKING = 1'  ;
--
--
   EXECUTE IMMEDIATE V_SQL;
  
   COMMIT;


   HAYA02.UTILES.ANALIZA_TABLA('HAYA02','TMP_HAYA_PRC_SYSGUID');   
   DBMS_OUTPUT.PUT_LINE(V_ESQUEMA||'.UTILES.ANALIZA_TABLA( '''||V_ESQUEMA||''',''TMP_HAYA_PRC_SYSGUID'' )');   

   
-- PRC_PROCEDIMIENTOS
  
  EXECUTE IMMEDIATE('TRUNCATE TABLE '||V_ESQUEMA||'.TMP_GUID_PRC_PROCS_HRE'); 

  V_SQL:= null;

  
     V_SQL:= 'INSERT INTO '||V_ESQUEMA||'.TMP_GUID_PRC_PROCS_HRE (SYS_GUID, PRC_ID)
                           SELECT tmp.GUID_SYSGUID, prchre.PRC_ID  
                          FROM '||V_ESQUEMA||'.TMP_GUID_HRE_2 tmp
                             , '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS prchre                             
                             , '||V_ESQUEMA||'.TMP_HAYA_PRC_SYSGUID haya
                         WHERE  prchre.PRC_ID             = haya.PRC_ID      
                           AND NVL(tmp.GUID_BIE_CODIGO_INTERNO,''-123'') = NVL(haya.BIE_CODIGO_INTERNO,''-123'')
                           AND tmp.GUID_ASU_ID_EXTERNO    = haya.ASU_ID_EXTERNO 
                           AND tmp.GUID_DD_TPO_CODIGO     = haya.DD_TPO_CODIGO
                           AND tmp.GUID_DES               = ''PRC_PROCEDIMIENTOS''
                           AND prchre.USUARIOCREAR = ''MIGRAHAYA02''';

     EXECUTE IMMEDIATE V_SQL;
     COMMIT;
     HAYA02.UTILES.ANALIZA_TABLA('HAYA02','TMP_GUID_PRC_PROCS_HRE');   
  
   
     V_SQL:= 'UPDATE (SELECT prchre.SYS_GUID AS old_SYS_GUID,
                           tmp.SYS_GUID    AS new_SYS_GUID
                      FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS prchre
                      INNER JOIN '||V_ESQUEMA||'.TMP_GUID_PRC_PROCS_HRE tmp 
                              ON prchre.PRC_ID = tmp.PRC_ID 
                      WHERE prchre.USUARIOCREAR = ''MIGRAHAYA02''
                     )
                SET old_SYS_GUID = new_SYS_GUID';    
     

     EXECUTE IMMEDIATE V_SQL; 
     
  
--  V_SQL:= 'UPDATE '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS prchre
--              SET prchre.SYS_GUID = ( 
--                          SELECT tmp.GUID_SYSGUID
--                          FROM '||V_ESQUEMA||'.TMP_GUID_HRE_2 tmp
--                             , '||V_ESQUEMA||'.ASU_ASUNTOS asuhre
--                             , '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO dd
----                             , '||V_ESQUEMA||'.TMP_GUID_PRB_PRC_BIE_CODIGO prb
--                         WHERE prchre.ASU_ID              = asuhre.ASU_ID
--                           AND prchre.DD_TPO_ID           = dd.DD_TPO_ID 
----                           AND prchre.PRC_ID              = prb.PRC_ID (+)
----                           AND NVL(tmp.GUID_BIE_CODIGO_INTERNO,0) = NVL(prb.BIE_CODIGO_INTERNO,0)
--                           AND tmp.GUID_ASU_ID_EXTERNO    = asuhre.ASU_ID_EXTERNO 
--                           AND tmp.GUID_DD_TPO_CODIGO     = dd.DD_TPO_CODIGO
--                           AND tmp.GUID_DES               = ''PRC_PROCEDIMIENTOS''
--                           AND prchre.USUARIOCREAR = ''MIGRAHAYA02''                           
--                           )';


  
   DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Registros de PRC_PROCEDIMIENTOS actualizados. '||SQL%ROWCOUNT||' Filas.');
   COMMIT;   
  
--PRB_PRC_BIE


--   V_SQL:= 'UPDATE '||V_ESQUEMA||'.PRB_PRC_BIE prbhre
--              SET prbhre.SYS_GUID = (                            
--                     SELECT tmp.GUID_SYSGUID
--                          FROM '||V_ESQUEMA||'.TMP_GUID_HRE_2 tmp
--                             , '||V_ESQUEMA||'.ASU_ASUNTOS asuhre
--                             , '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO dd
--                             , '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS prchre
--                             , '||V_ESQUEMA||'.BIE_BIEN           biehre
----                             , (SELECT BIE_ID, BIE_CODIGO_INTERNO, RANK() OVER (PARTITION BY BIE_CODIGO_INTERNO ORDER BY BIE_ID) AS RANKING FROM HAYA02.BIE_BIEN ) biehre
--                         WHERE prchre.ASU_ID              = asuhre.ASU_ID
--                           AND prchre.DD_TPO_ID           = dd.DD_TPO_ID 
--                           AND tmp.GUID_ASU_ID_EXTERNO    = asuhre.ASU_ID_EXTERNO 
--                           AND tmp.GUID_DD_TPO_CODIGO     = dd.DD_TPO_CODIGO
--                           AND tmp.GUID_DES               = ''PRB_PRC_BIE''
--                           AND tmp.GUID_BIE_CODIGO_INTERNO = biehre.BIE_CODIGO_INTERNO
--                           AND biehre.BIE_ID               = prbhre.BIE_ID
--                           AND prchre.PRC_ID               = prbhre.PRC_ID 
--                           AND prbhre.usuariocrear = ''MIGRAHAYA02''
--                           )';
--
-- con inserts y update

   EXECUTE IMMEDIATE('TRUNCATE TABLE '||V_ESQUEMA||'.TMP_GUID_PRB_HRE'); 

-- versión sin tener en cuenta duplicados
--   V_SQL:= 'insert into '||V_ESQUEMA||'.TMP_GUID_PRB_HRE (SYS_GUID, prb_id)               
--                 select tmp.SYS_GUID, prbhre.prb_id
--                          FROM (select * from (select GUID_SYSGUID as sys_guid
--                                           , GUID_ASU_ID_EXTERNO
--                                           , GUID_DD_TPO_CODIGO
--                                           , GUID_BIE_CODIGO_INTERNO
--                                           , GUID_DES
--                                              ,rank() over (partition by   GUID_ASU_ID_EXTERNO
--                                                                         , GUID_DD_TPO_CODIGO
--                                                                          , GUID_BIE_CODIGO_INTERNO
--                                                             order by GUID_SYSGUID) as ranking
--                                      from '||V_ESQUEMA||'.TMP_GUID_HRE_2 ) where ranking = 1) tmp
--                             , '||V_ESQUEMA||'.ASU_ASUNTOS asuhre
--                             , '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO dd
--                             , '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS prchre
----                           , '||V_ESQUEMA||'.BIE_BIEN           biehre
--                             , '||V_ESQUEMA||'.PRB_PRC_BIE prbhre
--                            , (SELECT BIE_ID, BIE_CODIGO_INTERNO, RANK() OVER (PARTITION BY BIE_CODIGO_INTERNO ORDER BY BIE_ID) AS RANKING2 FROM '||V_ESQUEMA||'.BIE_BIEN ) biehre
--                         WHERE prchre.ASU_ID              = asuhre.ASU_ID
--                           AND prchre.DD_TPO_ID           = dd.DD_TPO_ID 
--                           AND tmp.GUID_ASU_ID_EXTERNO    = asuhre.ASU_ID_EXTERNO 
--                           AND tmp.GUID_DD_TPO_CODIGO     = dd.DD_TPO_CODIGO
--                           AND tmp.GUID_DES               = ''PRB_PRC_BIE''
--                           AND tmp.GUID_BIE_CODIGO_INTERNO = biehre.BIE_CODIGO_INTERNO
--                           AND biehre.BIE_ID               = prbhre.BIE_ID
--                           AND prchre.PRC_ID               = prbhre.PRC_ID 
--                           AND prbhre.usuariocrear = ''MIGRAHAYA02''
--                           and biehre.ranking2 = 1 '
--                           ;

   V_SQL:= 'insert into '||V_ESQUEMA||'.TMP_GUID_PRB_HRE (SYS_GUID, prb_id)                              
            SELECT DISTINCT tmp.GUID_SYSGUID as SYS_GUID, haya2.prb_id
            FROM 
               (
                  select * from 
                   ( 
                      select GUID_SYSGUID 
                           , GUID_ASU_ID_EXTERNO
                           , GUID_DD_TPO_CODIGO
                           , GUID_BIE_CODIGO_INTERNO
                           , GUID_DES
                           , RANK() over (partition by GUID_ASU_ID_EXTERNO
                                                     , GUID_DD_TPO_CODIGO
                                                     , GUID_BIE_CODIGO_INTERNO
                                          order by GUID_SYSGUID) as ranking
                        from '||V_ESQUEMA||'.TMP_GUID_HRE_2 
                        where guid_des = ''PRB_PRC_BIE''
                    ) 
               ) tmp
            ,  ( select haya.prc_id
                       , haya.asu_id
                       , haya.asu_id_externo
                       , haya.dd_tpo_codigo
                       , biehre.bie_codigo_interno
                       , prbhre.prb_id      
                       , biehre.bie_id
                       , rank() over (partition by   haya.ASU_ID_EXTERNO
                                                   , haya.DD_TPO_CODIGO
                                                   , biehre.BIE_CODIGO_INTERNO
                                       order by prbhre.PRB_ID) as ranking2             
                     from          '||V_ESQUEMA||'.TMP_HAYA_PRC_SYSGUID haya
                                 , '||V_ESQUEMA||'.BIE_BIEN        biehre
                                 , '||V_ESQUEMA||'.PRB_PRC_BIE     prbhre
                    where biehre.BIE_ID       = prbhre.BIE_ID
                      and haya.PRC_ID         = prbhre.PRC_ID 
                      and prbhre.usuariocrear = ''MIGRAHAYA02'' 
                      ) haya2
                     WHERE tmp.GUID_ASU_ID_EXTERNO     = haya2.ASU_ID_EXTERNO 
                       AND tmp.GUID_DD_TPO_CODIGO      = haya2.DD_TPO_CODIGO
                       AND tmp.GUID_BIE_CODIGO_INTERNO = haya2.BIE_CODIGO_INTERNO
                       AND tmp.ranking                = haya2.ranking2';
                       
                           
   EXECUTE IMMEDIATE V_SQL;                           
   COMMIT;
    
   HAYA02.UTILES.ANALIZA_TABLA('HAYA02','TMP_GUID_PRB_HRE');   
   DBMS_OUTPUT.PUT_LINE(V_ESQUEMA||'.UTILES.ANALIZA_TABLA( '''||V_ESQUEMA||''',''TMP_GUID_PRB_HRE'' )');   


   V_SQL:= 'UPDATE (SELECT prbhre.SYS_GUID AS old_SYS_GUID,
                         tmp.SYS_GUID    AS new_SYS_GUID
                  FROM '||V_ESQUEMA||'.PRB_PRC_BIE prbhre
                  INNER JOIN '||V_ESQUEMA||'.TMP_GUID_PRB_HRE tmp 
                          ON prbhre.PRB_ID = tmp.PRB_ID 
                  WHERE prbhre.USUARIOCREAR = ''MIGRAHAYA02''
                 )
            SET old_SYS_GUID = new_SYS_GUID';   

                           
   EXECUTE IMMEDIATE V_SQL;
   DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Registros de PRB_PRC_BIE Actualizados. '||SQL%ROWCOUNT||' Filas.');
   COMMIT;   

  
-- TAR_TAREAS

--  V_SQL:= 'UPDATE '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES tarhre
--           SET tarhre.SYS_GUID = (         
--                         SELECT tmp.GUID_SYSGUID
--                          FROM '||V_ESQUEMA||'.TMP_GUID_HRE_2 tmp
--                             , '||V_ESQUEMA||'.ASU_ASUNTOS asuhre
--                             , '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS prchre                             
--                             , '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO dd                             
----                             , '||V_ESQUEMA||'.TMP_GUID_PRB_PRC_BIE_CODIGO prb
--                             , '||V_ESQUEMA||'.TEX_TAREA_EXTERNA tex
--                             , '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO tap                                                        
--                         WHERE prchre.ASU_ID     = asuhre.ASU_ID
--                           AND prchre.DD_TPO_ID  = dd.DD_TPO_ID 
--  --                         AND prchre.PRC_ID     = prb.PRC_ID (+)
--                           AND tarhre.ASU_ID     = prchre.ASU_ID  
--                           AND tarhre.PRC_ID     = prchre.PRC_ID  
--                           AND tarhre.TAR_ID     = tex.TAR_ID
--                           AND tex.TAP_ID        = tap.TAP_ID
--                           AND tmp.GUID_ASU_ID_EXTERNO = asuhre.ASU_ID_EXTERNO 
--                           AND tmp.GUID_DD_TPO_CODIGO  = dd.DD_TPO_CODIGO
--                           AND tmp.GUID_TAP_CODIGO     = tap.TAP_CODIGO
--    --                       AND NVL(tmp.GUID_BIE_CODIGO_INTERNO,0) = NVL(prb.BIE_CODIGO_INTERNO,0)                                                      
--                           AND tmp.GUID_DES            = ''TAR_TAREAS_NOTIFICACIONES''
--                           )';       
   
   
    EXECUTE IMMEDIATE('TRUNCATE TABLE '||V_ESQUEMA||'.TMP_GUID_TAR_TAREAS_HRE'); 
      
   
     V_SQL:= 'insert into '||V_ESQUEMA||'.TMP_GUID_TAR_TAREAS_HRE (SYS_GUID, TAR_ID)
                         SELECT bcc.GUID_SYSGUID, tarhre.TAR_ID
                          FROM '||V_ESQUEMA||'.TMP_GUID_HRE_2 bcc                            
                             , '||V_ESQUEMA||'.TMP_HAYA_PRC_SYSGUID haya
                             , '||V_ESQUEMA||'.TEX_TAREA_EXTERNA tex
                             , '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO tap  
                             , '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES tarhre
                         WHERE NVL(bcc.GUID_BIE_CODIGO_INTERNO,''-123'') = NVL(haya.BIE_CODIGO_INTERNO,''-123'')                           
                           AND tarhre.PRC_ID     = haya.PRC_ID  
                           AND tarhre.TAR_ID     = tex.TAR_ID
                           AND tex.TAP_ID        = tap.TAP_ID
                           AND bcc.GUID_ASU_ID_EXTERNO = haya.ASU_ID_EXTERNO 
                           AND bcc.GUID_DD_TPO_CODIGO  = haya.DD_TPO_CODIGO
                           AND bcc.GUID_TAP_CODIGO     = tap.TAP_CODIGO
                           AND bcc.GUID_DES            = ''TAR_TAREAS_NOTIFICACIONES''
                           AND tarhre.USUARIOCREAR = ''MIGRAHAYA02'''
                           ;   
                                        
   
   
   EXECUTE IMMEDIATE V_SQL;
   COMMIT;
   
   HAYA02.UTILES.ANALIZA_TABLA('HAYA02','TMP_GUID_TAR_TAREAS_HRE');      
   
   V_SQL:= 'UPDATE (SELECT tarhre.SYS_GUID AS old_SYS_GUID,
                           tmp.SYS_GUID    AS new_SYS_GUID
                    FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES tarhre
                    INNER JOIN '||V_ESQUEMA||'.TMP_GUID_TAR_TAREAS_HRE tmp 
                            ON tarhre.TAR_ID = tmp.TAR_ID 
                    WHERE tarhre.USUARIOCREAR = ''MIGRAHAYA02''
                   )
              SET old_SYS_GUID = new_SYS_GUID';

   EXECUTE IMMEDIATE V_SQL;              
   DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Registros de TAR_TAREAS_NOTIFICACIONES actualizados. '||SQL%ROWCOUNT||' Filas.');
   COMMIT;


-- CEX_CONTRATOS_EXPEDIENTES

     EXECUTE IMMEDIATE('TRUNCATE TABLE '||V_ESQUEMA||'.TMP_GUID_CEX_HRE'); 
    
     V_SQL:= null;

     V_SQL:= 'insert into '||V_ESQUEMA||'.TMP_GUID_CEX_HRE (SYS_GUID, CEX_ID)
                                SELECT tmp.GUID_SYSGUID AS SYS_GUID, cexhre.CEX_ID  
                                    FROM '||V_ESQUEMA||'.TMP_GUID_HRE_2 tmp
                                      , '||V_ESQUEMA||'.ASU_ASUNTOS asu
                                      , '||V_ESQUEMA||'.CNT_CONTRATOS cnt
                                      , '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE cexhre
                                  WHERE tmp.GUID_ASU_ID_EXTERNO = asu.ASU_ID_EXTERNO
                                    AND tmp.guid_cnt_contrato = cnt.cnt_contrato
                                    AND cexhre.CNT_ID = cnt.CNT_ID
                                    AND asu.EXP_ID    = cexhre.EXP_ID
                                    AND tmp.GUID_DES  = ''CEX_CONTRATOS_EXPEDIENTE''
                                    AND cexhre.USUARIOCREAR = ''MIGRAHAYA02''';                   
  
     EXECUTE IMMEDIATE V_SQL;
     COMMIT;
     HAYA02.UTILES.ANALIZA_TABLA('HAYA02','TMP_GUID_CEX_HRE');   

     V_SQL:= 'UPDATE (SELECT cexhre.SYS_GUID AS old_SYS_GUID,
                             tmp.SYS_GUID    AS new_SYS_GUID
                      FROM '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE cexhre
                      INNER JOIN '||V_ESQUEMA||'.TMP_GUID_CEX_HRE tmp 
                            ON cexhre.CEX_ID = tmp.CEX_ID 
                      WHERE cexhre.USUARIOCREAR = ''MIGRAHAYA02''
                   )
              SET old_SYS_GUID = new_SYS_GUID';     

--  V_SQL:= 'UPDATE '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE cexhre
--               SET cexhre.SYS_GUID = (SELECT tmp.GUID_SYSGUID
--                                   FROM '||V_ESQUEMA||'.TMP_GUID_HRE_2 tmp
--                                      , '||V_ESQUEMA||'.ASU_ASUNTOS asu
--                                      , '||V_ESQUEMA||'.CNT_CONTRATOS cnt
--                                  WHERE tmp.GUID_ASU_ID_EXTERNO = asu.ASU_ID_EXTERNO
--                                    AND tmp.guid_cnt_contrato = cnt.cnt_contrato
--                                    AND cexhre.CNT_ID = cnt.CNT_ID
--                                    AND asu.EXP_ID    = cexhre.EXP_ID
--                                    AND tmp.GUID_DES  = ''CEX_CONTRATOS_EXPEDIENTE''
--                                    AND cexhre.USUARIOCREAR = ''MIGRAHAYA02''
--                                    )';                   
    
   EXECUTE IMMEDIATE V_SQL;
  
   DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Registros de CEX_CONTRATOS_EXPEDIENTE actualizados. '||SQL%ROWCOUNT||' Filas.');
   COMMIT;   
   

   -- SUB_SUBASTAS

     EXECUTE IMMEDIATE('TRUNCATE TABLE '||V_ESQUEMA||'.TMP_GUID_SUB_HRE'); 
    
     V_SQL:= null;   
     
     V_SQL:= 'insert into '||V_ESQUEMA||'.TMP_GUID_SUB_HRE (SYS_GUID, SUB_ID)
                        SELECT tmp.GUID_SYSGUID AS SYS_GUID, subhre.SUB_ID       
                          FROM '||V_ESQUEMA||'.TMP_GUID_HRE_2 tmp
                             , '||V_ESQUEMA||'.TMP_HAYA_PRC_SYSGUID haya                        
                             , '||V_ESQUEMA||'.SUB_SUBASTA subhre
                         WHERE 
                               subhre.ASU_ID     = haya.ASU_ID  
                           AND subhre.PRC_ID     = haya.PRC_ID  
                           AND NVL(tmp.GUID_BIE_CODIGO_INTERNO,''-123'') = NVL(haya.BIE_CODIGO_INTERNO,''-123'')                                   
                           AND tmp.GUID_ASU_ID_EXTERNO = haya.ASU_ID_EXTERNO 
                           AND tmp.GUID_DD_TPO_CODIGO  = haya.DD_TPO_CODIGO
                           AND tmp.GUID_DES            = ''SUB_SUBASTA''
                           AND subhre.USUARIOCREAR = ''MIGRAHAYA02''';    
                                
     EXECUTE IMMEDIATE V_SQL;
     COMMIT;
     HAYA02.UTILES.ANALIZA_TABLA('HAYA02','TMP_GUID_SUB_HRE');   

     V_SQL:= 'UPDATE (SELECT subhre.SYS_GUID AS old_SYS_GUID,
                             tmp.SYS_GUID    AS new_SYS_GUID
                      FROM '||V_ESQUEMA||'.SUB_SUBASTA subhre
                      INNER JOIN '||V_ESQUEMA||'.TMP_GUID_SUB_HRE tmp 
                            ON subhre.SUB_ID = tmp.SUB_ID 
                      WHERE subhre.USUARIOCREAR = ''MIGRAHAYA02''
                   )
              SET old_SYS_GUID = new_SYS_GUID';        
      
--  V_SQL:= 'UPDATE '||V_ESQUEMA||'.SUB_SUBASTA subhre
--           SET subhre.SYS_GUID = (         
--                         SELECT tmp.GUID_SYSGUID
--                          FROM '||V_ESQUEMA||'.TMP_GUID_HRE_2 tmp
--                             , '||V_ESQUEMA||'.ASU_ASUNTOS asuhre
--                             , '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS prchre                             
--                             , '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO dd                             
----                             , '||V_ESQUEMA||'.TMP_GUID_PRB_PRC_BIE_CODIGO prb
--                         WHERE prchre.ASU_ID     = asuhre.ASU_ID
--                           AND prchre.DD_TPO_ID  = dd.DD_TPO_ID 
----                           AND prchre.PRC_ID     = prb.PRC_ID (+)
--                           AND subhre.ASU_ID     = prchre.ASU_ID  
--                           AND subhre.PRC_ID     = prchre.PRC_ID  
--                           AND tmp.GUID_ASU_ID_EXTERNO = asuhre.ASU_ID_EXTERNO 
--                           AND tmp.GUID_DD_TPO_CODIGO  = dd.DD_TPO_CODIGO
-- --                          AND NVL(tmp.GUID_BIE_CODIGO_INTERNO,0) = NVL(prb.BIE_CODIGO_INTERNO,0)
--                           AND tmp.GUID_DES            = ''SUB_SUBASTA''
--                           AND subhre.USUARIOCREAR = ''MIGRAHAYA02''                             
--                         )';    

   EXECUTE IMMEDIATE V_SQL;
  
   DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Registros de SUB_SUBASTA actualizados. '||SQL%ROWCOUNT||' Filas.');
   COMMIT;   


-- LOS_LOTE_SUBASTA

     EXECUTE IMMEDIATE('TRUNCATE TABLE '||V_ESQUEMA||'.TMP_GUID_LOS_HRE'); 
    
     V_SQL:= null;   
     
     V_SQL:= 'insert into '||V_ESQUEMA||'.TMP_GUID_LOS_HRE (SYS_GUID, LOS_ID)
                        SELECT tmp.GUID_SYSGUID AS SYS_GUID, loshre.LOS_ID       
                         FROM '||V_ESQUEMA||'.TMP_GUID_HRE_2 tmp
                             , '||V_ESQUEMA||'.ASU_ASUNTOS asuhre
                             , '||V_ESQUEMA||'.SUB_SUBASTA subhre
                             , '||V_ESQUEMA||'.LOS_LOTE_SUBASTA loshre                             
                         WHERE asuhre.ASU_ID     = subhre.ASU_ID
                           AND loshre.SUB_ID     = subhre.SUB_ID
                           AND tmp.GUID_ASU_ID_EXTERNO = asuhre.ASU_ID_EXTERNO 
                           AND tmp.GUID_DES            = ''LOS_LOTE_SUBASTA''
                           AND loshre.USUARIOCREAR = ''MIGRAHAYA02''';         


     EXECUTE IMMEDIATE V_SQL;
     COMMIT;
     HAYA02.UTILES.ANALIZA_TABLA('HAYA02','TMP_GUID_LOS_HRE');   

     V_SQL:= 'UPDATE (SELECT loshre.SYS_GUID AS old_SYS_GUID,
                             tmp.SYS_GUID    AS new_SYS_GUID
                      FROM '||V_ESQUEMA||'.LOS_LOTE_SUBASTA loshre
                      INNER JOIN '||V_ESQUEMA||'.TMP_GUID_LOS_HRE tmp 
                            ON loshre.LOS_ID = tmp.LOS_ID 
                      WHERE loshre.USUARIOCREAR = ''MIGRAHAYA02''
                   )
              SET old_SYS_GUID = new_SYS_GUID';        
                         
                        
--  V_SQL:= 'UPDATE '||V_ESQUEMA||'.LOS_LOTE_SUBASTA loshre
--           SET loshre.SYS_GUID = (         
--                         SELECT tmp.GUID_SYSGUID
--                          FROM '||V_ESQUEMA||'.TMP_GUID_HRE_2 tmp
--                             , '||V_ESQUEMA||'.ASU_ASUNTOS asuhre
--                             , '||V_ESQUEMA||'.SUB_SUBASTA subhre
--                         WHERE asuhre.ASU_ID     = subhre.ASU_ID
--                           AND loshre.SUB_ID     = subhre.SUB_ID
--                           AND tmp.GUID_ASU_ID_EXTERNO = asuhre.ASU_ID_EXTERNO 
--                           AND tmp.GUID_DES            = ''LOS_LOTE_SUBASTA''
--                           AND loshre.USUARIOCREAR = ''MIGRAHAYA02''                             
--                         )';         


   EXECUTE IMMEDIATE V_SQL;
  
   DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Registros de LOS_LOTE_SUBASTA Actualizados. '||SQL%ROWCOUNT||' Filas.');
   COMMIT;   

  

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













