--/*
--#########################################
--## AUTOR=MANUEL RODRIGUEZ
--## FECHA_CREACION=20160928
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2204
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración de Usuarios.
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

  V_ESQUEMA VARCHAR2(30 CHAR):= 'REM01'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(30 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  USUARIO_MIGRACION VARCHAR2(50 CHAR):= '#USUARIO_MIGRACION#';

BEGIN
      
      DBMS_OUTPUT.PUT_LINE('[INICIO]');

      -------------------------------------------------
      --ACTUALIZACION MIG2_GEA_GESTORES_ACTIVOS--
      -------------------------------------------------
      
      V_SQL := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''MIG2_GEA_GESTORES_ACTIVOS'',''10''); END;';
      EXECUTE IMMEDIATE V_SQL;

      V_SQL := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''GEE_GESTOR_ENTIDAD'',''10''); END;';
      EXECUTE IMMEDIATE V_SQL;

      V_SQL := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''GAC_GESTOR_ADD_ACTIVO'',''10''); END;';
      EXECUTE IMMEDIATE V_SQL;

      V_SQL := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''GEH_GESTOR_ENTIDAD_HIST'',''10''); END;';
      EXECUTE IMMEDIATE V_SQL;

      V_SQL := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''GAH_GESTOR_ACTIVO_HISTORICO'',''10''); END;';
      EXECUTE IMMEDIATE V_SQL;

      DBMS_OUTPUT.PUT_LINE('  [INFO] ACTUALIZACION MIG2_GEA_GESTORES_ACTIVOS');
      
       V_SQL := '
          MERGE INTO '||V_ESQUEMA||'.MIG2_GEA_GESTORES_ACTIVOS GEA
          USING
          (
            SELECT 
              GEA.GEA_NUMERO_ACTIVO||USU.USU_USERNAME||TGE.DD_TGE_CODIGO AS CODIGO
              , GEA.GEA_NUMERO_ACTIVO
              , USU.USU_USERNAME
              , TGE.DD_TGE_CODIGO
            FROM '||V_ESQUEMA||'.MIG2_GEA_GESTORES_ACTIVOS GEA
            INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = GEA.GEA_NUMERO_ACTIVO 
            INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_USERNAME = GEA.GEA_GESTOR_ACTIVO
            INNER JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = GEA.GEA_TIPO_GESTOR AND TGE.BORRADO = 0
            WHERE GEA.VALIDACION = 0 AND GEA.GEE_ID IS NULL AND NOT EXISTS (
              SELECT 1           
              FROM '||V_ESQUEMA||'.MIG2_GEA_GESTORES_ACTIVOS GEA2
              INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT2 ON ACT2.ACT_NUM_ACTIVO = GEA2.GEA_NUMERO_ACTIVO
              INNER JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC2 ON GAC2.ACT_ID = ACT2.ACT_ID
              LEFT JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE2 ON GEE2.GEE_ID = GAC2.GEE_ID AND GEE2.BORRADO = 0
              LEFT JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE2 ON GEE2.DD_TGE_ID = TGE2.DD_TGE_ID AND TGE2.BORRADO = 0
              WHERE ACT2.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO AND TGE2.DD_TGE_CODIGO = TGE.DD_TGE_CODIGO   
            )
          ) SQLI ON (GEA.GEA_NUMERO_ACTIVO||GEA.GEA_GESTOR_ACTIVO||GEA.GEA_TIPO_GESTOR = SQLI.CODIGO)
          WHEN MATCHED THEN UPDATE SET
            GEA.GEE_ID = '||V_ESQUEMA||'.S_GEE_GESTOR_ENTIDAD.NEXTVAL
            , GEA.GEH_ID = '||V_ESQUEMA||'.S_GEH_GESTOR_ENTIDAD_HIST.NEXTVAL
      '
      ;
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.MIG2_GEA_GESTORES_ACTIVOS actualizadas. '||SQL%ROWCOUNT||' Filas.');     
      
      -------------------------------------------------
      --INSERCION EN GEE_GESTOR_ENTIDAD--
      -------------------------------------------------
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] INSERCION EN GEE_GESTOR_ENTIDAD ');
      
       V_SQL := '
          INSERT INTO '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD (
            GEE_ID
            , USU_ID
            , DD_TGE_ID
            , VERSION
            , USUARIOCREAR
            , FECHACREAR
            , BORRADO
          )
          SELECT
            GEA.GEE_ID
            , USU.USU_ID
            , TGE.DD_TGE_ID
            , 0
            , '''||USUARIO_MIGRACION||'''
            , SYSDATE
            , 0
          FROM '||V_ESQUEMA||'.MIG2_GEA_GESTORES_ACTIVOS GEA
          INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = GEA.GEA_NUMERO_ACTIVO 
          INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_USERNAME = GEA.GEA_GESTOR_ACTIVO
          INNER JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = GEA.GEA_TIPO_GESTOR AND TGE.BORRADO = 0
          WHERE GEA.VALIDACION = 0 AND GEA.GEE_ID IS NOT NULL AND NOT EXISTS (
            SELECT 1
            FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
            WHERE GEE.GEE_ID = GEA.GEE_ID
          )
      '
      ;
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD cargada. '||SQL%ROWCOUNT||' Filas.');     

      -------------------------------------------------
      --ACTUALIZACION EN GEE_GESTOR_ENTIDAD--
      -------------------------------------------------
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] ACTUALIZACION EN GEE_GESTOR_ENTIDAD ');
      
       V_SQL := '
        MERGE INTO '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
        USING 
        (
          SELECT DISTINCT GAC.ACT_ID, GEE.GEE_ID, GEE.USU_ID AS USU_ID_OLD, USU.USU_ID AS USU_ID_NEW, GEE.DD_TGE_ID, ROWNUM
          FROM '||V_ESQUEMA||'.MIG2_GEA_GESTORES_ACTIVOS GEA
          INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = GEA.GEA_NUMERO_ACTIVO
          INNER JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.ACT_ID = ACT.ACT_ID
          INNER JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID
          INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_USERNAME = GEA.GEA_GESTOR_ACTIVO
          INNER JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON GEE.DD_TGE_ID = TGE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = GEA.GEA_TIPO_GESTOR AND TGE.BORRADO = 0
          WHERE GEE.USU_ID <> USU.USU_ID
        ) SQLI ON (SQLI.GEE_ID = GEE.GEE_ID)
        WHEN MATCHED THEN UPDATE SET 
          GEE.USU_ID = SQLI.USU_ID_NEW
          , USUARIOMODIFICAR = '''||USUARIO_MIGRACION||'''
          , FECHAMODIFICAR =  SYSDATE
      '
      ;
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD actualizada. '||SQL%ROWCOUNT||' Filas.'); 

      -------------------------------------------------
      --INSERCION EN GAC_GESTOR_ADD_ACTIVO--
      -------------------------------------------------
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] INSERCION EN GAC_GESTOR_ADD_ACTIVO ');
      
       V_SQL := '
        INSERT INTO '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO (
          GEE_ID,
          ACT_ID
        )
        SELECT DISTINCT
          GEA.GEE_ID
          , ACT.ACT_ID
        FROM '||V_ESQUEMA||'.MIG2_GEA_GESTORES_ACTIVOS GEA
        INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = GEA.GEA_NUMERO_ACTIVO
        WHERE GEA.VALIDACION = 0 AND GEA.GEE_ID IS NOT NULL AND NOT EXISTS (
          SELECT 1
          FROM '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC
          WHERE GAC.GEE_ID = GEA.GEE_ID
        )
      '
      ;
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO cargada. '||SQL%ROWCOUNT||' Filas.'); 

      -------------------------------------------------
      --INSERCION EN GEH_GESTOR_ENTIDAD_HIST--
      -------------------------------------------------
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] INSERCION EN GEH_GESTOR_ENTIDAD_HIST ');
      
       V_SQL := '
          INSERT INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST (
            GEH_ID
            , USU_ID
            , DD_TGE_ID
            , GEH_FECHA_DESDE
            , GEH_FECHA_HASTA
            , VERSION
            , USUARIOCREAR
            , FECHACREAR
            , BORRADO
          )
          SELECT
            GEA.GEH_ID
            , USU.USU_ID
            , TGE.DD_TGE_ID
            , SYSDATE
            , NULL
            , 1
            , '''||USUARIO_MIGRACION||'''
            , SYSDATE
            , 0
          FROM '||V_ESQUEMA||'.MIG2_GEA_GESTORES_ACTIVOS GEA
          INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = GEA.GEA_NUMERO_ACTIVO 
          INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_USERNAME = GEA.GEA_GESTOR_ACTIVO
          INNER JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = GEA.GEA_TIPO_GESTOR AND TGE.BORRADO = 0
          WHERE GEA.VALIDACION = 0 AND GEA.GEH_ID IS NOT NULL AND NOT EXISTS (
            SELECT 1
            FROM '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH
            WHERE GEH.GEH_ID = GEA.GEH_ID
          )
      '
      ;
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST cargada. '||SQL%ROWCOUNT||' Filas.'); 

      -------------------------------------------------
      --ACTUALIZACION EN GEH_GESTOR_ENTIDAD_HIST--
      -------------------------------------------------
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] ACTUALIZACION EN GEH_GESTOR_ENTIDAD_HIST ');
      
       V_SQL := '
        MERGE INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH
        USING 
        (
          SELECT DISTINCT GAH.ACT_ID, GEH.GEH_ID, GEH.USU_ID AS USU_ID_OLD, USU.USU_ID AS USU_ID_NEW, GEH.DD_TGE_ID, ROWNUM
          FROM '||V_ESQUEMA||'.MIG2_GEA_GESTORES_ACTIVOS GEA
          INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = GEA.GEA_NUMERO_ACTIVO
          INNER JOIN '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH ON GAH.ACT_ID = ACT.ACT_ID
          INNER JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH ON GEH.GEH_ID = GAH.GEH_ID
          INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_USERNAME = GEA.GEA_GESTOR_ACTIVO
          INNER JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON GEH.DD_TGE_ID = TGE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = GEA.GEA_TIPO_GESTOR AND TGE.BORRADO = 0
          WHERE GEH.USU_ID <> USU.USU_ID
        ) SQLI ON (SQLI.GEH_ID = GEH.GEH_ID)
        WHEN MATCHED THEN UPDATE SET 
          GEH.USU_ID = SQLI.USU_ID_NEW
          , USUARIOMODIFICAR = '''||USUARIO_MIGRACION||'''
          , FECHAMODIFICAR =  SYSDATE
      '
      ;
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST actualizada. '||SQL%ROWCOUNT||' Filas.');

      -------------------------------------------------
      --INSERCION EN GAH_GESTOR_ACTIVO_HISTORICO--
      -------------------------------------------------
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] INSERCION EN GAH_GESTOR_ACTIVO_HISTORICO ');
      
       V_SQL := '
        INSERT INTO '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO (
          GEH_ID,
          ACT_ID
        )
        SELECT DISTINCT
          GEA.GEH_ID
          , ACT.ACT_ID
        FROM '||V_ESQUEMA||'.MIG2_GEA_GESTORES_ACTIVOS GEA
        INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = GEA.GEA_NUMERO_ACTIVO
        WHERE GEA.VALIDACION = 0 AND GEA.GEH_ID IS NOT NULL AND NOT EXISTS (
          SELECT 1
          FROM '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH
          WHERE GAH.GEH_ID = GEA.GEH_ID
        )
      '
      ;
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO cargada. '||SQL%ROWCOUNT||' Filas.');
      
      COMMIT;  

      V_SQL := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''GEE_GESTOR_ENTIDAD'',''10''); END;';
      EXECUTE IMMEDIATE V_SQL;

      V_SQL := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''GAC_GESTOR_ADD_ACTIVO'',''10''); END;';
      EXECUTE IMMEDIATE V_SQL;

      V_SQL := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''GEH_GESTOR_ENTIDAD_HIST'',''10''); END;';
      EXECUTE IMMEDIATE V_SQL;

      V_SQL := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''GAH_GESTOR_ACTIVO_HISTORICO'',''10''); END;';
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('[FIN]');
      
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
