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
      --ACTUALIZACION MIG2_GEO_GESTORES_OFERTAS--
      -------------------------------------------------
      
      V_SQL := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''GEE_GESTOR_ENTIDAD'',''10''); END;';
      EXECUTE IMMEDIATE V_SQL;

      V_SQL := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''GCO_GESTOR_ADD_ECO'',''10''); END;';
      EXECUTE IMMEDIATE V_SQL;

      V_SQL := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''GEH_GESTOR_ENTIDAD_HIST'',''10''); END;';
      EXECUTE IMMEDIATE V_SQL;

      V_SQL := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''GCH_GESTOR_ECO_HISTORICO'',''10''); END;';
      EXECUTE IMMEDIATE V_SQL; 
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] ACTUALIZACION MIG2_GEO_GESTORES_OFERTAS');
      
       V_SQL := '
          MERGE INTO '||V_ESQUEMA||'.MIG2_GEO_GESTORES_OFERTAS GEO
          USING
          (
            SELECT 
              GEO.GEO_COD_OFERTA
              , USU.USU_USERNAME
              , TGE.DD_TGE_CODIGO
            FROM '||V_ESQUEMA||'.MIG2_GEO_GESTORES_OFERTAS GEO
            INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_NUM_OFERTA = GEO.GEO_COD_OFERTA
            INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID
            INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_USERNAME = GEO.GEO_GESTOR_ACTIVO
            INNER JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = GEO.GEO_TIPO_GESTOR AND TGE.BORRADO = 0
            WHERE GEO.VALIDACION = 0 AND GEO.GEE_ID IS NULL AND NOT EXISTS (
              SELECT 1           
              FROM '||V_ESQUEMA||'.MIG2_GEO_GESTORES_OFERTAS GEO2
              INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR2 ON OFR2.OFR_NUM_OFERTA = GEO2.GEO_COD_OFERTA
              INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO2 ON ECO2.OFR_ID = OFR2.OFR_ID
              INNER JOIN '||V_ESQUEMA||'.GCO_GESTOR_ADD_ECO GCO2 ON GCO2.ECO_ID = ECO2.ECO_ID
              LEFT JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE2 ON GEE2.GEE_ID = GCO2.GEE_ID AND GEE2.BORRADO = 0
              LEFT JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE2 ON GEE2.DD_TGE_ID = TGE2.DD_TGE_ID AND TGE2.BORRADO = 0
              WHERE OFR2.OFR_NUM_OFERTA = OFR.OFR_NUM_OFERTA AND TGE2.DD_TGE_CODIGO = TGE.DD_TGE_CODIGO   
            )
          ) SQLI ON (GEO.GEO_COD_OFERTA = SQLI.GEO_COD_OFERTA AND GEO.GEO_GESTOR_ACTIVO = SQLI.USU_USERNAME AND GEO.GEO_TIPO_GESTOR = SQLI.DD_TGE_CODIGO)
          WHEN MATCHED THEN UPDATE SET
            GEO.GEE_ID = '||V_ESQUEMA||'.S_GEE_GESTOR_ENTIDAD.NEXTVAL
            , GEO.GEH_ID = '||V_ESQUEMA||'.S_GEH_GESTOR_ENTIDAD_HIST.NEXTVAL
      '
      ;
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.MIG2_GEO_GESTORES_OFERTAS actualizadas. '||SQL%ROWCOUNT||' Filas.');
      
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
            GEO.GEE_ID
            , USU.USU_ID
            , TGE.DD_TGE_ID
            , 0
            , '''||USUARIO_MIGRACION||'''
            , SYSDATE
            , 0
          FROM '||V_ESQUEMA||'.MIG2_GEO_GESTORES_OFERTAS GEO
          INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_NUM_OFERTA = GEO.GEO_COD_OFERTA
          INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID 
          INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_USERNAME = GEO.GEO_GESTOR_ACTIVO
          INNER JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = GEO.GEO_TIPO_GESTOR AND TGE.BORRADO = 0
          WHERE GEO.VALIDACION = 0 AND GEO.GEE_ID IS NOT NULL AND NOT EXISTS (
            SELECT 1
            FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
            WHERE GEE.GEE_ID = GEO.GEE_ID
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
          SELECT DISTINCT GCO.ECO_ID, GEE.GEE_ID, GEE.USU_ID AS USU_ID_OLD, USU.USU_ID AS USU_ID_NEW, GEE.DD_TGE_ID, ROW_NUMBER() OVER(PARTITION BY GEE.GEE_ID ORDER BY USU.USU_ID) RN
          FROM '||V_ESQUEMA||'.MIG2_GEO_GESTORES_OFERTAS GEO
          INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_NUM_OFERTA = GEO.GEO_COD_OFERTA
          INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID
          INNER JOIN '||V_ESQUEMA||'.GCO_GESTOR_ADD_ECO GCO ON GCO.ECO_ID = ECO.ECO_ID
          INNER JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GCO.GEE_ID
          INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_USERNAME = GEO.GEO_GESTOR_ACTIVO
          INNER JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON GEE.DD_TGE_ID = TGE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = GEO.GEO_TIPO_GESTOR AND TGE.BORRADO = 0
          WHERE GEE.USU_ID <> USU.USU_ID
        ) SQLI ON (SQLI.GEE_ID = GEE.GEE_ID AND SQLI.RN = 1)
        WHEN MATCHED THEN UPDATE SET 
          GEE.USU_ID = SQLI.USU_ID_NEW
          , USUARIOMODIFICAR = '''||USUARIO_MIGRACION||'''
          , FECHAMODIFICAR =  SYSDATE
      '
      ;
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD actualizada. '||SQL%ROWCOUNT||' Filas.'); 

      -------------------------------------------------
      --INSERCION EN GCO_GESTOR_ADD_ECO--
      -------------------------------------------------
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] INSERCION EN GCO_GESTOR_ADD_ECO ');
      
       V_SQL := '
        INSERT INTO '||V_ESQUEMA||'.GCO_GESTOR_ADD_ECO (
          GEE_ID,
          ECO_ID
        )
        SELECT DISTINCT
          GEO.GEE_ID
          , ECO.ECO_ID
        FROM '||V_ESQUEMA||'.MIG2_GEO_GESTORES_OFERTAS GEO
        INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_NUM_OFERTA = GEO.GEO_COD_OFERTA
        INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID
        WHERE GEO.VALIDACION = 0 AND GEO.GEE_ID IS NOT NULL AND NOT EXISTS (
          SELECT 1
          FROM '||V_ESQUEMA||'.GCO_GESTOR_ADD_ECO GCO
          WHERE GCO.GEE_ID = GEO.GEE_ID
        )
      '
      ;
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.GCO_GESTOR_ADD_ECO cargada. '||SQL%ROWCOUNT||' Filas.'); 

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
            GEO.GEH_ID
            , USU.USU_ID
            , TGE.DD_TGE_ID
            , SYSDATE
            , NULL
            , 1
            , '''||USUARIO_MIGRACION||'''
            , SYSDATE
            , 0
          FROM '||V_ESQUEMA||'.MIG2_GEO_GESTORES_OFERTAS GEO
          INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_NUM_OFERTA = GEO.GEO_COD_OFERTA
          INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID
          INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_USERNAME = GEO.GEO_GESTOR_ACTIVO
          INNER JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = GEO.GEO_TIPO_GESTOR AND TGE.BORRADO = 0
          WHERE GEO.VALIDACION = 0 AND GEO.GEH_ID IS NOT NULL AND NOT EXISTS (
            SELECT 1
            FROM '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH
            WHERE GEH.GEH_ID = GEO.GEH_ID
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
          SELECT DISTINCT GCH.ECO_ID, GEH.GEH_ID, GEH.USU_ID AS USU_ID_OLD, USU.USU_ID AS USU_ID_NEW, GEH.DD_TGE_ID, ROW_NUMBER() OVER(PARTITION BY GEH.GEH_ID ORDER BY USU.USU_ID) RN
          FROM '||V_ESQUEMA||'.MIG2_GEO_GESTORES_OFERTAS GEO
          INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_NUM_OFERTA = GEO.GEO_COD_OFERTA
          INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID
          INNER JOIN '||V_ESQUEMA||'.GCH_GESTOR_ECO_HISTORICO GCH ON GCH.ECO_ID = ECO.ECO_ID
          INNER JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH ON GEH.GEH_ID = GCH.GEH_ID
          INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_USERNAME = GEO.GEO_GESTOR_ACTIVO
          INNER JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON GEH.DD_TGE_ID = TGE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = GEO.GEO_TIPO_GESTOR AND TGE.BORRADO = 0
          WHERE GEH.USU_ID <> USU.USU_ID
        ) SQLI ON (SQLI.GEH_ID = GEH.GEH_ID AND SQLI.RN = 1)
        WHEN MATCHED THEN UPDATE SET 
          GEH.USU_ID = SQLI.USU_ID_NEW
          , USUARIOMODIFICAR = '''||USUARIO_MIGRACION||'''
          , FECHAMODIFICAR =  SYSDATE
      '
      ;
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST actualizada. '||SQL%ROWCOUNT||' Filas.');

      -------------------------------------------------
      --INSERCION EN GCH_GESTOR_ECO_HISTORICO--
      -------------------------------------------------
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] INSERCION EN GCH_GESTOR_ECO_HISTORICO ');
      
       V_SQL := '
        INSERT INTO '||V_ESQUEMA||'.GCH_GESTOR_ECO_HISTORICO (
          GEH_ID,
          ECO_ID
        )
        SELECT DISTINCT
          GEO.GEH_ID
          , ECO.ECO_ID
        FROM '||V_ESQUEMA||'.MIG2_GEO_GESTORES_OFERTAS GEO
        INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_NUM_OFERTA = GEO.GEO_COD_OFERTA
        INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID
        WHERE GEO.VALIDACION = 0 AND GEO.GEH_ID IS NOT NULL AND NOT EXISTS (
          SELECT 1
          FROM '||V_ESQUEMA||'.GCH_GESTOR_ECO_HISTORICO GCH
          WHERE GCH.GEH_ID = GEO.GEH_ID
        )
      '
      ;
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.GCH_GESTOR_ECO_HISTORICO cargada. '||SQL%ROWCOUNT||' Filas.');

      COMMIT; 
      
      V_SQL := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''GEE_GESTOR_ENTIDAD'',''10''); END;';
      EXECUTE IMMEDIATE V_SQL;

      V_SQL := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''GCO_GESTOR_ADD_ECO'',''10''); END;';
      EXECUTE IMMEDIATE V_SQL;

      V_SQL := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''GEH_GESTOR_ENTIDAD_HIST'',''10''); END;';
      EXECUTE IMMEDIATE V_SQL;

      V_SQL := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''GCH_GESTOR_ECO_HISTORICO'',''10''); END;';
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