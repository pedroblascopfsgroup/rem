--/*
--#########################################
--## AUTOR=MANUEL RODRIGUEZ
--## FECHA_CREACION=20160928
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-855
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
  V_SENTENCIA VARCHAR2(1024 CHAR);
  V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
  V_ENTIDAD_ID NUMBER(16);
  V_ID NUMBER(16);

  ENTIDAD NUMBER(1):= '1';
  USUARIO_MIGRACION VARCHAR2(30 CHAR):= 'SAREB';

BEGIN
      
      DBMS_OUTPUT.PUT_LINE('[INICIO]');

       -------------------------------------------------
       --INSERCION EN USU_USUARIOS--
       -------------------------------------------------
       
      DBMS_OUTPUT.PUT_LINE('  [INFO] INSERCION EN USU_USUARIOS');

      V_SQL := 'SELECT '|| V_ESQUEMA_M ||'.S_USU_USUARIOS.NEXTVAL FROM DUAL';
      EXECUTE IMMEDIATE V_SQL INTO V_ID;
        
      V_SQL := '
        INSERT INTO '||V_ESQUEMA_M||'.USU_USUARIOS (
          USU_ID,
          ENTIDAD_ID,
          USU_USERNAME,
          USU_PASSWORD,
          USU_NOMBRE,
          USU_APELLIDO1,
          USU_APELLIDO2,
          USU_MAIL,
          USU_GRUPO,
          USU_FECHA_VIGENCIA_PASS,
          USUARIOCREAR,
          FECHACREAR,
          BORRADO
        )
        SELECT 
          '|| V_ID || '
          , '|| ENTIDAD ||'
          , MIG2.USU_USERNAME
          , NULL
          , MIG2.USU_NOMBRE
          , MIG2.USU_APELLIDO1
          , MIG2.USU_APELLIDO2
          , MIG2.USU_EMAIL
          , ''0''
          , SYSDATE+730
          , '''|| USUARIO_MIGRACION ||'''
          , SYSDATE
          , 0 
        FROM '||V_ESQUEMA||'.MIG2_USU_USUARIOS MIG2
        WHERE MIG2.VALIDACION = 0 AND NOT EXISTS (
          SELECT 1
          FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU
          WHERE USU.USU_USERNAME = MIG2.USU_USERNAME 
        )
      '
      ;
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA_M||'.USU_USUARIOS cargada. '||SQL%ROWCOUNT||' Filas.');
      
      -------------------------------------------------
      --INSERCION EN ZON_PEF_USU--
      -------------------------------------------------
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] INSERCION EN ZON_PEF_USU '); 
      
      V_SQL := '
        INSERT INTO '||V_ESQUEMA||'.ZON_PEF_USU (
          ZPU_ID
          , ZON_ID
          , PEF_ID
          , USU_ID
          , USUARIOCREAR
          , FECHACREAR
          , BORRADO
        )
        SELECT 
          '||V_ESQUEMA||'.S_ZON_PEF_USU.NEXTVAL        AS ZPU_ID
          , ZON.ZON_ID                       AS ZON_ID
          , PEF.PEF_ID                       AS PEF_ID
          , USU.USU_ID                       AS USU_ID
          , '''|| USUARIO_MIGRACION ||'''    AS USUARIOCREAR
          , SYSDATE                          AS FECHACREAR
          , 0                                AS BORRADO
        FROM '||V_ESQUEMA||'.MIG2_USU_USUARIOS MIG2
        INNER JOIN '||V_ESQUEMA||'.PEF_PERFILES PEF ON PEF.PEF_CODIGO = MIG2.USU_CODIGO_PERFIL AND PEF.BORRADO = 0
        INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_USERNAME = MIG2.USU_USERNAME
        INNER JOIN '||V_ESQUEMA||'.ZON_ZONIFICACION ZON ON ZON.ZON_DESCRIPCION = ''REM'' AND ZON.BORRADO = 0
        WHERE MIG2.VALIDACION = 0 AND NOT EXISTS (
          SELECT 1 
          FROM '||V_ESQUEMA||'.ZON_PEF_USU ZPU
          INNER JOIN '||V_ESQUEMA||'.PEF_PERFILES PEF ON ZPU.PEF_ID = PEF.PEF_ID
          INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON ZPU.USU_ID = USU.USU_ID
          WHERE PEF.PEF_CODIGO = MIG2.USU_CODIGO_PERFIL AND USU.USU_USERNAME = MIG2.USU_USERNAME AND ZPU.BORRADO = 0
        )     
      '
      ;
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ZON_PEF_USU cargada. '||SQL%ROWCOUNT||' Filas.');

      -------------------------------------------------
      --INSERCION EN USD_USUARIOS_DESPACHOS--
      -------------------------------------------------
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] INSERCION EN USD_USUARIOS_DESPACHOS ');
      
       V_SQL := '
        INSERT INTO '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS (
          USD_ID
          , DES_ID
          , USU_ID
          , USD_GESTOR_DEFECTO
          , USD_SUPERVISOR
          , USUARIOCREAR
          , FECHACREAR
          , BORRADO
        ) 
        SELECT 
          REM01.S_USD_USUARIOS_DESPACHOS.NEXTVAL        AS USD_ID
          , DES.DES_ID                                  AS DES_ID                       
          , USU.USU_ID                                  AS USU_ID
          , 1                                           AS USD_GESTOR_DEFECTO
          , 1                                           AS USD_SUPERVISOR
          , '''|| USUARIO_MIGRACION ||'''               AS USUARIOCREAR
          , SYSDATE                                     AS FECHACREAR
          , 0                                           AS BORRADO
        FROM '||V_ESQUEMA||'.MIG2_USU_USUARIOS MIG2
        INNER JOIN '||V_ESQUEMA||'.MIG2_DESPACHOS_PERFILES DEP ON DEP.CODIGO_PERFIL = MIG2.USU_CODIGO_PERFIL
        INNER JOIN '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO DES ON DES.DES_DESPACHO = DEP.CODIGO_DESPACHO AND DES.BORRADO = 0
        INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_USERNAME = MIG2.USU_USERNAME
        WHERE MIG2.VALIDACION = 0 AND NOT EXISTS (
          SELECT 1
          FROM '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS USD
          INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS AUX ON AUX.USU_ID = USD.USU_ID
          INNER JOIN '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO DES ON DES.DES_ID = USD.DES_ID
          WHERE AUX.USU_USERNAME = MIG2.USU_USERNAME AND DES.DES_DESPACHO = DEP.CODIGO_DESPACHO AND USD.BORRADO = 0
        ) 
      '
      ;
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS cargada. '||SQL%ROWCOUNT||' Filas.');     
      
       -------------------------------------------------
      --INSERCION EN GRU_GRUPOS_USUARIOS--
      -------------------------------------------------
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] INSERCION EN GRU_GRUPOS_USUARIOS ');
      
       V_SQL := '
          INSERT INTO '||V_ESQUEMA_M||'.GRU_GRUPOS_USUARIOS (
            GRU_ID
            , USU_ID_GRUPO
            , USU_ID_USUARIO
            , USUARIOCREAR
            , FECHACREAR
            , BORRADO
          )
          SELECT 
            '||V_ESQUEMA_M||'.S_GRU_GRUPOS_USUARIOS.NEXTVAL    AS GRU_ID
            , USU_GRUPO.USU_ID                                 AS USU_ID_GRUPO
            , USU_PERT.USU_ID                                  AS USU_ID_USUARIO
            , '''|| USUARIO_MIGRACION ||'''                    AS USUARIOCREAR
            , SYSDATE                                          AS FECHACREAR
            , 0                                                AS BORRADO
          FROM '||V_ESQUEMA||'.MIG2_GRU_GRUPOS_USUARIOS MIG2
          INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU_GRUPO ON USU_GRUPO.USU_USERNAME = MIG2.GRU_USERNAME_PRINCIPAL
          INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU_PERT ON USU_PERT.USU_USERNAME = MIG2.GRU_USERNAME
          WHERE MIG2.VALIDACION = 0 AND NOT EXISTS (
            SELECT 1
            FROM '||V_ESQUEMA_M||'.GRU_GRUPOS_USUARIOS GRU
            INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU1 ON USU1.USU_ID = GRU.USU_ID_GRUPO
            INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU2 ON USU2.USU_ID = GRU.USU_ID_USUARIO
            WHERE USU1.USU_USERNAME = MIG2.GRU_USERNAME_PRINCIPAL AND USU2.USU_USERNAME = MIG2.GRU_USERNAME AND GRU.BORRADO = 0
          )   
      '
      ;
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA_M||'.GRU_GRUPOS_USUARIOS cargada. '||SQL%ROWCOUNT||' Filas.');     
      
      COMMIT;  

      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''USU_USUARIOS'',''10''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;

      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''ZON_PEF_USU'',''10''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;

      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''USD_USUARIOS_DESPACHOS'',''10''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;

      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''GRU_GRUPOS_USUARIOS'',''10''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      
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
