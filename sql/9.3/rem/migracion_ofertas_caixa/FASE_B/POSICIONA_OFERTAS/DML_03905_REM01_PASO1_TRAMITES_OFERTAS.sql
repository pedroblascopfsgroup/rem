--/*
--#########################################
--## AUTOR=KEVIN HONORATO
--## FECHA_CREACION=20200730
--## ARTEFACTO=migracion
--## VERSION_ARTEFACTO=0.3
--## INCIDENCIA_LINK=HREOS-10749
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración Fase 2, para la generacion de tramites.
--##                    
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

      V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
      V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
      V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
      V_TABLA VARCHAR2(40 CHAR) := 'MIG2_CAIXA_POSICIONAMIENTO_OFERTA'; -- Vble. Tabla pivote
      V_SENTENCIA VARCHAR2(2600 CHAR);
      V_UPDATE NUMBER(16);
      V_NUM_TABLAS NUMBER(16);
      V_MSQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
      -- Vbls. para el cursor
      V_OFR_ID NUMBER(16) := 0; -- Vble. para almacenar el OFR_ID
      S_TBJ NUMBER(16) := 0; -- Vble. para almacenar la secuencia generada para el TBJ_ID
      S_NUM NUMBER(16) := 0; -- Vble. para almacenar la secuencia generada para el TBJ_NUM_TRABAJO
      S_TRA NUMBER(16) := 0; -- Vble. para almacenar la secuencia generada para el TRA_ID
      S_TAR NUMBER(16) := 0; -- Vble. para almacenar la secuencia generada para el TAR_ID
      S_TEX NUMBER(16) := 0; -- Vble. para almacenar la secuencia generada para el TEX_ID
      
      -- Cursor que almacena las secuencias
      CURSOR CURSOR_OFERTAS IS
      SELECT DISTINCT NUM_OFERTA  FROM REM01.MIG2_CAIXA_POSICIONAMIENTO_OFERTA TRA
      ;

      -- Tablas de volcado
      V_TABLA_TBJ VARCHAR2(30 CHAR) := 'ACT_TBJ_TRABAJO';
      V_TABLA_ACT_TBJ VARCHAR2(30 CHAR) := 'ACT_TBJ';
      V_TABLA_ECO VARCHAR2(30 CHAR) := 'ECO_EXPEDIENTE_COMERCIAL';
      V_TABLA_TRA VARCHAR2(30 CHAR) := 'ACT_TRA_TRAMITE';
      V_TABLA_TAR VARCHAR2(30 CHAR) := 'TAR_TAREAS_NOTIFICACIONES';
      V_TABLA_ETN VARCHAR2(30 CHAR) := 'ETN_EXTAREAS_NOTIFICACIONES';
      V_TABLA_TEX VARCHAR2(30 CHAR) := 'TEX_TAREA_EXTERNA';
      V_TABLA_TAC VARCHAR2(30 CHAR) := 'TAC_TAREAS_ACTIVOS';
      
BEGIN

      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------------') ;
      DBMS_OUTPUT.PUT_LINE('PROCESO DE GENERACION DE TRAMITES PARA LAS OFERTAS MIGRADAS EN FASE 2....') ;
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------------') ;

      ---------------------------------------------------------------------------------------------------------------
      -- UPDATE MIG2_CAIXA_POSICIONAMIENTO_OFERTA (TBJ_ID, TRA_ID, TAR_ID, TEX_ID) --
      ---------------------------------------------------------------------------------------------------------------
      
      DBMS_OUTPUT.PUT_LINE('[INFO] GENERANDO TBJ_ID, TRA_ID, TAR_ID, TEX_ID...');
      
      OPEN CURSOR_OFERTAS;
      
      LOOP
            FETCH CURSOR_OFERTAS INTO V_OFR_ID;
            EXIT WHEN CURSOR_OFERTAS%NOTFOUND;
            
                  EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA||'.S_ACT_TRA_TRAMITE.NEXTVAL FROM DUAL' INTO S_TRA;
                  EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA||'.S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL FROM DUAL' INTO S_TAR;
                  EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA||'.S_TEX_TAREA_EXTERNA.NEXTVAL FROM DUAL' INTO S_TEX;
                  
                  EXECUTE IMMEDIATE '
                        UPDATE '||V_ESQUEMA||'.MIG2_CAIXA_POSICIONAMIENTO_OFERTA TRA
                        SET  TRA.TRA_ID = '||S_TRA||'
                              , TRA.TAR_ID = '||S_TAR||'
                              , TRA.TEX_ID = '||S_TEX||'
                        WHERE NUM_OFERTA = '||V_OFR_ID||'
                  '
                  ;
                  
      END LOOP;
      
      CLOSE CURSOR_OFERTAS; 
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizada.');

      ---------------------------------------------------------------------------------------------------------------
      -- INSERT ACT_TRA_TRAMITE --
      ---------------------------------------------------------------------------------------------------------------
  
      DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO TRAMITES...');
      
      EXECUTE IMMEDIATE '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TRA||'
            (
                  TRA_ID
                  ,TBJ_ID
                  ,DD_TPO_ID
                  ,DD_EPR_ID
                  ,TRA_DECIDIDO
                  ,TRA_PROCESS_BPM
                  ,TRA_PARALIZADO
                  ,TRA_FECHA_INICIO
                  ,VERSION
                  ,USUARIOCREAR
                  ,FECHACREAR
                  ,BORRADO
                  ,DD_TAC_ID
            )
            SELECT DISTINCT
                  MIG2.TRA_ID                                                                         AS TRA_ID
                  , MIG2.TBJ_ID                                                                        AS TBJ_ID
                  , TPO.DD_TPO_ID                                                                       AS DD_TPO_ID
                  , (SELECT DD_EPR_ID 
                        FROM '||V_ESQUEMA_MASTER||'.DD_EPR_ESTADO_PROCEDIMIENTO 
                        WHERE DD_EPR_CODIGO = ''10''
                        AND BORRADO = 0
                  )                                                                                           AS DD_EPR_ID
                  , 0                                                                                        AS TRA_DECIDIDO
                  , NULL                                                                                  AS TRA_PROCESS_BPM
                  , 0                                                                                        AS TRA_PARALIZADO
                  , SYSDATE                                                                           AS TRA_FECHA_INICIO
                  , 1                                                                                        AS VERSION
                  , '''||V_USUARIO||'''                                                            AS USUARIOCREAR
                  , SYSDATE                                                                           AS FECHACREAR         
                  , 0                                                                                        AS BORRADO
                  , (SELECT DD_TAC_ID 
                          FROM '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION  
                          WHERE DD_TAC_CODIGO = ''GES''
                          AND BORRADO = 0
                  )                                                                                           AS DD_TAC_ID
            FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
            JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_CODIGO = MIG2.TPO_ID
      '
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_TRA||' cargada. '||SQL%ROWCOUNT||' Filas.');
   
      ---------------------------------------------------------------------------------------------------------------
      -- INSERT TAR_TAREAS_NOTIFICACIONES --
      ---------------------------------------------------------------------------------------------------------------
  
      DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO TAREAS NOTIFICACIONES...');
      
      EXECUTE IMMEDIATE '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TAR||'
            (
                  TAR_ID
                  , DD_EIN_ID
                  , DD_STA_ID
                  , TAR_CODIGO
                  , TAR_TAREA
                  , TAR_DESCRIPCION
                  , TAR_FECHA_INI
                  , TAR_EN_ESPERA
                  , TAR_ALERTA
                  , TAR_TAREA_FINALIZADA
                  , VERSION
                  , USUARIOCREAR
                  , FECHACREAR
                  , BORRADO
                  , TAR_FECHA_VENC
                  , DTYPE
                  , NFA_TAR_REVISADA
            )
            SELECT DISTINCT
                  MIG2.TAR_ID                                                                               AS TAR_ID
                  , (SELECT EIN.DD_EIN_ID 
                          FROM '||V_ESQUEMA_MASTER||'.DD_EIN_ENTIDAD_INFORMACION EIN 
                          WHERE EIN.DD_EIN_CODIGO = ''61''
                          AND BORRADO = 0
                  )                                                                                                 AS DD_EIN_ID
                  , STA.DD_STA_ID                                                                         AS DD_STA_ID
                  , 1                                                                                              AS TAR_CODIGO
                  , TAP.TAP_DESCRIPCION                                                               AS TAR_TAREA
                  , TAP.TAP_DESCRIPCION                                                               AS TAR_DESCRIPCION
                  , SYSDATE                                                                                 AS TAR_FECHA_INI
                  , 0                                                                                             AS TAR_EN_ESPERA
                  , 0                                                                                              AS TAR_ALERTA
                  , 0                                                                                             AS TAR_TAREA_FINALIZADA
                  , 0                                                                                             AS VERSION
                  , '''||V_USUARIO||'''                                                                       AS USUARIOCREAR
                  , SYSDATE                                                                                 AS FECHACREAR
                  , 0                                                                                             AS BORRADO
                  , (SELECT SYSDATE + 3 FROM DUAL)                                          AS TAR_FECHA_VENC
                  , ''EXTTareaNotificacion''                                                               AS DTYPE
                  , 0                                                                                             AS NFA_TAR_REVISADA
            FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
                  INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_CODIGO = MIG2.TAREA_NUEVA_TRAMITE
                  INNER JOIN '||V_ESQUEMA_MASTER||'.DD_STA_SUBTIPO_TAREA_BASE STA ON STA.DD_STA_ID = TAP.DD_STA_ID
      '
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_TAR||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
      ---------------------------------------------------------------------------------------------------------------
      -- INSERT ETN_EXTAREAS_NOTIFICACIONES --
      ---------------------------------------------------------------------------------------------------------------
    
      DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO TAREAS EXTERNAS NOTIFICACIONES...');
      
      EXECUTE IMMEDIATE '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_ETN||'
            (
                  TAR_ID
                  ,TAR_FECHA_VENC_REAL
            )
            SELECT DISTINCT
                  MIG2.TAR_ID
                  ,(SELECT SYSDATE + 3 FROM DUAL) AS TAR_FECHA_VENC_REAL
            FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
      '
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_ETN||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
      ---------------------------------------------------------------------------------------------------------------
      -- INSERT TEX_TAREA_EXTERNA --
      ---------------------------------------------------------------------------------------------------------------
    
      DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO TAREAS EXTERNAS...');
      
      EXECUTE IMMEDIATE '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TEX||'
            (
                  TEX_ID
                  , TAR_ID
                  , TAP_ID
                  , TEX_TOKEN_ID_BPM
                  , TEX_DETENIDA
                  , VERSION
                  , USUARIOCREAR
                  , FECHACREAR
                  , BORRADO
                  , TEX_NUM_AUTOP
                  , DTYPE
            )
            SELECT DISTINCT
                  MIG2.TEX_ID             AS TEX_ID
                  , MIG2.TAR_ID          AS TAR_ID
                  , MIG2.TAP_ID           AS TAP_ID
                  , NULL                     AS TEX_TOKEN_ID_BPM
                  , 0                           AS TEX_DETENIDA
                  , 0                           AS VERSION
                  , '''||V_USUARIO||'''     AS USUARIOCREAR
                  , SYSDATE               AS FECHACREAR
                  , 0                              AS BORRADO
                  , 0                             AS TEX_NUM_AUTOP
                  , ''EXTTareaExterna''     AS DTYPE
            FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
                  INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = MIG2.TAP_ID
      '
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_TEX||' cargada. '||SQL%ROWCOUNT||' Filas.');
   
      ---------------------------------------------------------------------------------------------------------------
      -- INSERT TAC_TAREAS_ACTIVOS --
      ---------------------------------------------------------------------------------------------------------------
    
      DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO RELACION TAREAS ACTIVOS...');
      
      EXECUTE IMMEDIATE '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TAC||'
            (
                  TAR_ID
                  , TRA_ID
                  , ACT_ID
                  , USU_ID
                  , SUP_ID
                  , VERSION
                  , USUARIOCREAR
                  , FECHACREAR
                  , BORRADO
            )
            WITH UNICO_ACTIVO AS (
                  SELECT DISTINCT
                        MIG2.TAR_ID          
                        , MIG2.TRA_ID       
                        , MIG2.ACT_ID       
                        , MIG2.USU_ID        
                        , MIG2.SUP_ID        
                        , ROW_NUMBER () OVER (PARTITION BY MIG2.TAR_ID ORDER BY MIG2.ACT_ID DESC) AS ORDEN
                  FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
            )
            SELECT
                  UA.TAR_ID             AS TAR_ID
                  , UA.TRA_ID           AS TRA_ID
                  , UA.ACT_ID           AS ACT_ID
                  , UA.USU_ID           AS USU_ID
                  , UA.SUP_ID           AS SUP_ID
                  , 0                       AS VERSION
                  , '''||V_USUARIO||''' AS USUARIOCREAR
                  , SYSDATE           AS FECHACREAR
                  ,0                        AS BORRADO
            FROM UNICO_ACTIVO UA
            WHERE UA.ORDEN = 1
      '
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_TAC||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
     COMMIT;

      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''ACT_TBJ_TRABAJO'',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;

      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''ACT_TBJ'',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;

      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''ACT_TRA_TRAMITE'',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;

      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''TAR_TAREAS_NOTIFICACIONES'',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;

      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''ETN_EXTAREAS_NOTIFICACIONES'',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;

      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''TEX_TAREA_EXTERNA'',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;

      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''TAC_TAREAS_ACTIVOS'',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
 
EXCEPTION
      WHEN OTHERS THEN
            DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
            DBMS_OUTPUT.put_line('-----------------------------------------------------------');
            DBMS_OUTPUT.put_line(SQLERRM);
            ROLLBACK;
            RAISE;
END;

/

EXIT;
