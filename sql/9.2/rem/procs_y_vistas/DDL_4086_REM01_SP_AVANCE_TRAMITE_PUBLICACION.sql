--/*
--######################################### 
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20190201
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3003
--## PRODUCTO=NO
--## Finalidad:
--##      
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

create or replace PROCEDURE       #ESQUEMA#.AVANCE_TRAMITE_PUBLICACION (USUARIO VARCHAR2
		, LIST_TRA_ID VARCHAR2
		, TRAM_DESTINO IN #ESQUEMA#.TAP_TAREA_PROCEDIMIENTO.TAP_CODIGO%TYPE
		, PL_OUTPUT OUT VARCHAR2) AUTHID CURRENT_USER AS

	/**
	USUARIO es únicamente para auditoría, es obligatorio.
	LIST_TRA_ID es la lista de trámites de publicvación, separados por comas, que queramos reposicionar. Es obligatorio.
	TRAM_DESTINO es el trámite al que se quiere avanzar cada expediente comercial. Es obligatorio.
	**/
    V_ESQUEMA VARCHAR2(25 CHAR) := '#ESQUEMA#';			-- 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#';	-- 'REMMASTER'; -- Configuracion Esquema Master
    V_USUARIO VARCHAR2(50 CHAR);
    ERR_NUM NUMBER;-- Numero de errores
    ERR_MSG VARCHAR2(2048);-- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);
    COD_ITEM VARCHAR2(50 CHAR);
    PL_OUTPUT2 VARCHAR2(32000 CHAR);
    V_TABLA_REP VARCHAR2(30 CHAR) := 'OFERTAS_REPOSICIONAR';
    V_TABLA VARCHAR2(40 CHAR) := 'MIG2_TRAMITES_OFERTAS_REP'; -- Vble. Tabla pivote
    V_TRA_ID NUMBER(16); -- Vble. para almacenar el TRA_ID
    S_TBJ NUMBER(16) := 0; -- Vble. para almacenar la secuencia generada para el TBJ_ID
    S_NUM NUMBER(16) := 0; -- Vble. para almacenar la secuencia generada para el TBJ_NUM_TRABAJO
    S_TRA NUMBER(16) := 0; -- Vble. para almacenar la secuencia generada para el TRA_ID
    S_TAR NUMBER(16) := 0; -- Vble. para almacenar la secuencia generada para el TAR_ID
    S_TEX NUMBER(16) := 0; -- Vble. para almacenar la secuencia generada para el TEX_ID
    CURSOR CURSOR_TRAMITES IS
    SELECT DISTINCT TRA_ID FROM #ESQUEMA#.MIG2_TRAMITES_OFERTAS_REP TRA;
    V_TABLA_TBJ 	VARCHAR2(30 CHAR) := 'ACT_TBJ_TRABAJO';
    V_TABLA_ACT_TBJ VARCHAR2(30 CHAR) := 'ACT_TBJ';
    V_TABLA_ECO 	VARCHAR2(30 CHAR) := 'ECO_EXPEDIENTE_COMERCIAL';
    V_TABLA_TRA 	VARCHAR2(30 CHAR) := 'ACT_TRA_TRAMITE';
    V_TABLA_TAR 	VARCHAR2(30 CHAR) := 'TAR_TAREAS_NOTIFICACIONES';
    V_TABLA_ETN 	VARCHAR2(30 CHAR) := 'ETN_EXTAREAS_NOTIFICACIONES';
    V_TABLA_TEX 	VARCHAR2(30 CHAR) := 'TEX_TAREA_EXTERNA';
    V_TABLA_TAC 	VARCHAR2(30 CHAR) := 'TAC_TAREAS_ACTIVOS';
    V_UPDATE 		NUMBER(16);
    V_COUNT			NUMBER(16);
    V_TAREAS_TRAMITE_PUBLICACION VARCHAR(32000 CHAR);

BEGIN

    PL_OUTPUT := '[INICIO] Inicio del proceso de reposicionamiento de trámites de publicación.';
    PL_OUTPUT := PL_OUTPUT ||chr(10) || '';

    V_USUARIO := USUARIO;
    COD_ITEM := V_USUARIO;
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.OFERTAS_REPOSICIONAR ';
    --DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.OFERTAS_REPOSICIONAR (OFR_ID, ECO_ID, TBJ_ID, TAR_ID, TEX_ID, TRA_ID, DD_TOF_CODIGO, ACT_ID)
                SELECT TRA.TRA_ID, NULL, TBJ.TBJ_ID, TAR.TAR_ID, TEX.TEX_ID, TRA.TRA_ID, NULL, ACT.ACT_ID
                FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA 
                LEFT JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ ON TRA.TBJ_ID = TBJ.TBJ_ID
                LEFT JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON TRA.ACT_ID = ACT.ACT_ID
                LEFT JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID
                LEFT JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
                LEFT JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAR.TAR_ID
                LEFT JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID
                WHERE TRA.TRA_ID IN ('||LIST_TRA_ID||')';

    --DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    --DBMS_OUTPUT.PUT_LINE(V_MSQL);

    V_MSQL := 'SELECT COUNT(DISTINCT TRA_ID) FROM '||V_ESQUEMA||'.OFERTAS_REPOSICIONAR';
    --DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
    PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] '|| V_COUNT ||' trámites a reposicionar.';

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES T1
                USING '||V_ESQUEMA||'.OFERTAS_REPOSICIONAR T2
                ON (T1.TAR_ID = T2.TAR_ID)
                WHEN MATCHED THEN UPDATE SET
                    T1.TAR_FECHA_FIN = SYSDATE, T1.TAR_TAREA_FINALIZADA = 1, T1.BORRADO = 1
                    , T1.USUARIOBORRAR = '''||V_USUARIO||''', T1.FECHABORRAR = SYSDATE
                WHERE T1.TAR_FECHA_FIN IS NULL';
    --DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] '|| SQL%ROWCOUNT||' tareas antiguas finalizadas.';

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TEX_TAREA_EXTERNA T1
                USING '||V_ESQUEMA||'.OFERTAS_REPOSICIONAR T2
                ON (T1.TEX_ID = T2.TEX_ID)
                WHEN MATCHED THEN UPDATE SET
                    T1.BORRADO = 1, T1.USUARIOBORRAR = '''||V_USUARIO||''', T1.FECHABORRAR = SYSDATE
                WHERE T1.BORRADO = 0';
    --DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] '|| SQL%ROWCOUNT||' tareas antiguas finalizadas.';

    PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] APROVISIONANDO LA TABLA AUXILIAR '||V_TABLA||'...';
      V_MSQL := 'DELETE FROM  '||V_ESQUEMA||'.MIG2_TRAMITES_OFERTAS_REP';
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;
      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.MIG2_TRAMITES_OFERTAS_REP (OFR_ID, ACT_ID, TPO_ID, TAP_ID, USU_ID, SUP_ID, TBJ_ID, TBJ_NUM_TRABAJO, TRA_ID)
                    SELECT DISTINCT TRA.TRA_ID, TRA.ACT_ID,NULL AS TPO_ID, (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = '''||TRAM_DESTINO||''') , NULL AS USU_ID, NULL AS SUP_ID, NULL AS TBJ_ID, NULL AS TBJ_NUM_TRABAJO, TRA.TRA_ID
                    FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA
                    LEFT JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS tac on tac.tra_id = tra.tra_id
                    LEFT JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEx on tac.tar_id = tex.tar_id
                    LEFT JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO tap on tap.tap_id = tex.tap_id
                    WHERE TAP.BORRADO = 0 AND TRA.TRA_ID IN ('||LIST_TRA_ID||')';
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.';

      V_UPDATE := 0;

      V_TAREAS_TRAMITE_PUBLICACION :='SELECT TAP.TAP_CODIGO FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO like ''T011%''';

      /* Metemos al gestor de publicaciones en la nueva tarea */
      V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.MIG2_TRAMITES_OFERTAS_REP T1
                    USING (
                        SELECT DISTINCT TRA.TRA_ID, GEE.USU_ID
                        FROM '||V_ESQUEMA||'.MIG2_TRAMITES_OFERTAS_REP MIG
                        LEFT JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = MIG.TAP_ID AND TAP.TAP_CODIGO IN ('||V_TAREAS_TRAMITE_PUBLICACION||')
                        LEFT JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TRA.TRA_ID = MIG.TRA_ID
                        LEFT JOIN '||V_ESQUEMA||'.ACT_TBJ atb on TRA.TBJ_ID = ATB.TBJ_ID
                        LEFT JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC on (TRA.ACT_ID = GAC.ACT_ID)OR(ATB.ACT_ID = GAC.ACT_ID)
                        LEFT JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID AND GEE.BORRADO = 0
                        INNER JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''GPUBL'') T2
                    ON (T1.TRA_ID = T2.TRA_ID)
                    WHEN MATCHED THEN UPDATE SET
                        T1.USU_ID = T2.USU_ID';
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;
      V_UPDATE := SQL%ROWCOUNT;

      V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.MIG2_TRAMITES_OFERTAS_REP T1
        USING (SELECT GEE.USU_ID, GAC.ACT_ID, ROW_NUMBER() OVER(PARTITION BY GAC.ACT_ID ORDER BY GEE.USU_ID DESC) RN
          FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
          JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.GEE_ID = GEE.GEE_ID
          JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''GPUBL''
          WHERE GEE.BORRADO = 0 ) T2
        ON (T1.ACT_ID = T2.ACT_ID AND T2.RN = 1)
        WHEN MATCHED THEN UPDATE SET
          T1.USU_ID = T2.USU_ID
        WHERE T1.USU_ID IS NULL AND T1.TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO IN ('||V_TAREAS_TRAMITE_PUBLICACION||'))';
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;

      V_UPDATE := V_UPDATE + SQL%ROWCOUNT;
      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizado (Gestor publicación). '||V_UPDATE||' Filas.';

      V_UPDATE := 0;
      V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.MIG2_TRAMITES_OFERTAS_REP T1
        USING (
            SELECT DISTINCT TRA.TRA_ID, GEE.USU_ID, TGE.DD_TGE_CODIGO
                        FROM '||V_ESQUEMA||'.MIG2_TRAMITES_OFERTAS_REP MIG
                        LEFT JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = MIG.TAP_ID AND TAP.TAP_CODIGO IN ('||V_TAREAS_TRAMITE_PUBLICACION||')
                        LEFT JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TRA.TRA_ID = MIG.TRA_ID
                        LEFT JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO gac on TRA.ACT_ID = GAC.ACT_ID
                        INNER JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = gac.GEE_ID AND GEE.BORRADO = 0
                        INNER JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''SPUBL'')T2
        ON (T1.TRA_ID = T2.TRA_ID)
        WHEN MATCHED THEN UPDATE SET
            T1.SUP_ID = T2.USU_ID';
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;
      V_UPDATE := SQL%ROWCOUNT;

      V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.MIG2_TRAMITES_OFERTAS_REP T1
        USING (SELECT GEE.USU_ID, GAC.ACT_ID, ROW_NUMBER() OVER(PARTITION BY GAC.ACT_ID ORDER BY GEE.USU_ID DESC) RN
          FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
          JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.GEE_ID = GEE.GEE_ID
          JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''SPUBL'') T2
        ON (T1.ACT_ID = T2.ACT_ID AND T2.RN = 1)
        WHEN MATCHED THEN UPDATE SET
          T1.SUP_ID = T2.USU_ID
        WHERE T1.SUP_ID IS NULL AND T1.TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO IN ('||V_TAREAS_TRAMITE_PUBLICACION||'))';
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;
      V_UPDATE := V_UPDATE + SQL%ROWCOUNT;
      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizado (Supervisor publicación). '||V_UPDATE||' Filas.';

      ---------------------------------------------------------------------------------------------------------------
      -- UPDATE MIG2_TRAMITES_OFERTAS_REP (TBJ_ID, TRA_ID, TAR_ID, TEX_ID) --
      ---------------------------------------------------------------------------------------------------------------

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] GENERANDO TBJ_ID, TRA_ID, TAR_ID, TEX_ID...';

      OPEN CURSOR_TRAMITES;

      LOOP
            FETCH CURSOR_TRAMITES INTO V_TRA_ID;
            EXIT WHEN CURSOR_TRAMITES%NOTFOUND;

                  V_MSQL := 'SELECT '||V_ESQUEMA||'.S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL FROM DUAL';
                  --DBMS_OUTPUT.PUT_LINE(V_MSQL);
                  EXECUTE IMMEDIATE V_MSQL INTO S_TAR;
                  V_MSQL := 'SELECT '||V_ESQUEMA||'.S_TEX_TAREA_EXTERNA.NEXTVAL FROM DUAL';
                  --DBMS_OUTPUT.PUT_LINE(V_MSQL);
                  EXECUTE IMMEDIATE V_MSQL INTO S_TEX;

                  V_MSQL := '
                        UPDATE '||V_ESQUEMA||'.MIG2_TRAMITES_OFERTAS_REP TRA
                        SET TRA.TAR_ID = '||S_TAR||'
                              , TRA.TEX_ID = '||S_TEX||'
                        WHERE OFR_ID = '||V_TRA_ID||'
                  '
                  ;
                  --DBMS_OUTPUT.PUT_LINE(V_MSQL);
                  EXECUTE IMMEDIATE V_MSQL;

      END LOOP;

      CLOSE CURSOR_TRAMITES;

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizada.';

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] COMIENZA EL VOLCADO A LAS TABLAS DEFINITIVAS';

      ---------------------------------------------------------------------------------------------------------------
      -- INSERT ACT_TRA_TRAMITE --
      ---------------------------------------------------------------------------------------------------------------

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] ACTUALIZANDO TRAMITES...';

      V_MSQL := '
            MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_TRA||' T1
            USING (
                  SELECT DISTINCT TRA_ID
                  FROM '||V_ESQUEMA||'.'||V_TABLA||'
            ) T2
            ON (T1.TRA_ID = T2.TRA_ID)
            WHEN MATCHED THEN UPDATE SET
                T1.TRA_PROCESS_BPM = NULL
      '
      ;
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_TRA||' actualizada. '||SQL%ROWCOUNT||' Filas.';

      ---------------------------------------------------------------------------------------------------------------
      -- INSERT TAR_TAREAS_NOTIFICACIONES --
      ---------------------------------------------------------------------------------------------------------------

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] CREANDO TAREAS NOTIFICACIONES...';

      V_MSQL := '
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
                  MIG2.TAR_ID                                                      AS TAR_ID
                  , (SELECT EIN.DD_EIN_ID
                          FROM '||V_ESQUEMA_M||'.DD_EIN_ENTIDAD_INFORMACION EIN
                          WHERE EIN.DD_EIN_CODIGO = ''61''
                          AND BORRADO = 0
                  )                                                                AS DD_EIN_ID
                  , STA.DD_STA_ID                                                  AS DD_STA_ID
                  , 1                                                              AS TAR_CODIGO
                  , TAP.TAP_DESCRIPCION                                            AS TAR_TAREA
                  , TAP.TAP_DESCRIPCION                                            AS TAR_DESCRIPCION
                  , SYSDATE                                                        AS TAR_FECHA_INI
                  , 0                                                              AS TAR_EN_ESPERA
                  , 0                                                              AS TAR_ALERTA
                  , 0                                                              AS TAR_TAREA_FINALIZADA
                  , 0                                                              AS VERSION
                  , '''||V_USUARIO||'''                                            AS USUARIOCREAR
                  , SYSDATE                                                        AS FECHACREAR
                  , 0                                                              AS BORRADO
                  , (SELECT SYSDATE + 3 FROM DUAL)                                 AS TAR_FECHA_VENC
                  , ''EXTTareaNotificacion''                                       AS DTYPE
                  , 0                                                              AS NFA_TAR_REVISADA
            FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
                  INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = MIG2.TAP_ID
                  INNER JOIN '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE STA ON STA.DD_STA_ID = TAP.DD_STA_ID
      '
      ;
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_TAR||' cargada. '||SQL%ROWCOUNT||' Filas.';

      ---------------------------------------------------------------------------------------------------------------
      -- INSERT ETN_EXTAREAS_NOTIFICACIONES --
      ---------------------------------------------------------------------------------------------------------------

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] CREANDO TAREAS EXTERNAS NOTIFICACIONES...';

      V_MSQL := '
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
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_ETN||' cargada. '||SQL%ROWCOUNT||' Filas.';

      ---------------------------------------------------------------------------------------------------------------
      -- INSERT TEX_TAREA_EXTERNA --
      ---------------------------------------------------------------------------------------------------------------

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] CREANDO TAREAS EXTERNAS...';

      V_MSQL := '
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
                  MIG2.TEX_ID            AS TEX_ID
                  , MIG2.TAR_ID          AS TAR_ID
                  , MIG2.TAP_ID          AS TAP_ID
                  , NULL                 AS TEX_TOKEN_ID_BPM
                  , 0                    AS TEX_DETENIDA
                  , 0                    AS VERSION
                  , '''||V_USUARIO||'''  AS USUARIOCREAR
                  , SYSDATE              AS FECHACREAR
                  , 0                    AS BORRADO
                  , 0                    AS TEX_NUM_AUTOP
                  , ''EXTTareaExterna''  AS DTYPE
            FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
                  INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = MIG2.TAP_ID
      '
      ;
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_TEX||' cargada. '||SQL%ROWCOUNT||' Filas.';

      ---------------------------------------------------------------------------------------------------------------
      -- INSERT TAC_TAREAS_ACTIVOS --
      ---------------------------------------------------------------------------------------------------------------

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] CREANDO RELACION TAREAS ACTIVOS...';

      V_MSQL := '
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
                  , 0                   AS VERSION
                  , '''||V_USUARIO||''' AS USUARIOCREAR
                  , SYSDATE             AS FECHACREAR
                  ,0                    AS BORRADO
            FROM UNICO_ACTIVO UA
            WHERE UA.ORDEN = 1
      '
      ;
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_TAC||' cargada. '||SQL%ROWCOUNT||' Filas.';

    PL_OUTPUT := PL_OUTPUT ||chr(10) || '';
    PL_OUTPUT := PL_OUTPUT ||chr(10) || '[FIN] Reposicionamiento de trámites de publicación.';

    #ESQUEMA#.ALTA_BPM_INSTANCES(V_USUARIO,PL_OUTPUT2);

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
      PL_OUTPUT := PL_OUTPUT ||chr(10) || '[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE);
      PL_OUTPUT := PL_OUTPUT ||chr(10) || '-----------------------------------------------------------';
      PL_OUTPUT := PL_OUTPUT ||chr(10) || SQLERRM;
      PL_OUTPUT := PL_OUTPUT ||chr(10) || V_MSQL;
      DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
      ROLLBACK;
      RAISE;
END;
