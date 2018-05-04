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
  USUARIO_MIGRACION VARCHAR2(30 CHAR):= '#USUARIO_MIGRACION#';

BEGIN
      
      DBMS_OUTPUT.PUT_LINE('[INICIO]');

       -------------------------------------------------
       --INSERCION EN USU_USUARIOS--
       -------------------------------------------------
       
      DBMS_OUTPUT.PUT_LINE('  [INFO] INSERCION EN USU_USUARIOS');
        
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
          '|| V_ESQUEMA_M ||'.S_USU_USUARIOS.NEXTVAL
          , SQLI.ENTIDAD_ID
          , SQLI.USU_USERNAME
          , SQLI.USU_PASSWORD
          , SQLI.USU_NOMBRE
          , SQLI.USU_APELLIDO1
          , SQLI.USU_APELLIDO2
          , SQLI.USU_EMAIL
          , SQLI.USU_GRUPO
          , SQLI.USU_FECHA_VIGENCIA_PASS
          , SQLI.USUARIOCREAR
          , SQLI.FECHACREAR
          , SQLI.BORRADO
        FROM (
          SELECT DISTINCT
            '|| ENTIDAD ||'                   AS ENTIDAD_ID
            , MIG2.USU_USERNAME
            , NULL                            AS USU_PASSWORD
            , MIG2.USU_NOMBRE
            , MIG2.USU_APELLIDO1
            , MIG2.USU_APELLIDO2
            , MIG2.USU_EMAIL
            , ''0''                           AS USU_GRUPO
            , SYSDATE+730                     AS USU_FECHA_VIGENCIA_PASS
            , '''|| USUARIO_MIGRACION ||'''   AS USUARIOCREAR
            , SYSDATE                         AS FECHACREAR
            , 0                               AS BORRADO
            , ROW_NUMBER () OVER (PARTITION BY MIG2.USU_USERNAME ORDER BY MIG2.USU_USERNAME DESC) RANK
          FROM '||V_ESQUEMA||'.MIG2_USU_USUARIOS MIG2
          WHERE MIG2.VALIDACION = 0 AND NOT EXISTS (
            SELECT 1
            FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU
            WHERE USU.USU_USERNAME = MIG2.USU_USERNAME 
          )
        ) SQLI
        WHERE SQLI.RANK = 1
      '
      ;
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA_M||'.USU_USUARIOS cargada. '||SQL%ROWCOUNT||' Filas.');
      
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
      
      -- BAJA USUARIOS
/*      DBMS_OUTPUT.PUT_LINE('  [INFO] DANDO DE BAJA USUARIOS...');
      
      EXECUTE IMMEDIATE 'MERGE INTO REMMASTER.usu_usuarios USU_OLD
        USING (
        select usu.usu_id
        from REMMASTER.usu_usuarios usu
        left join REM01.MIG2_USU_USUARIOS mig2 on usu.usu_username = mig2.usu_username
        where mig2.usu_username is null
        and usu.borrado = 0
        ) USU_NEW
        ON (USU_OLD.USU_ID = USU_NEW.USU_ID)
        WHEN MATCHED THEN UPDATE 
        SET  USU_OLD.USU_FECHA_VIGENCIA_PASS = sysdate-1
           , USU_OLD.fechamodificar = sysdate
           , USU_OLD.USUARIOMODIFICAR = '''|| USUARIO_MIGRACION ||'''';

      DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA_M||'.USU_USUARIOS borrado. '||SQL%ROWCOUNT||' Filas.');

      -- BAJA GRUPOS USUARIOS
      DBMS_OUTPUT.PUT_LINE('  [INFO] DANDO DE BAJA GRUPOS...');
      
      EXECUTE IMMEDIATE 'MERGE INTO REMMASTER.GRU_GRUPOS_USUARIOS GRU_OLD
        USING (
          SELECT GRU.GRU_ID
          FROM REMMASTER.GRU_GRUPOS_USUARIOS GRU
          INNER JOIN REMMASTER.USU_USUARIOS USU1 ON USU1.USU_ID = GRU.USU_ID_GRUPO
          left join REM01.MIG2_USU_USUARIOS mig2 on USU1.usu_username = mig2.usu_username
          WHERE USU1.USU_USERNAME = MIG2.USU_USERNAME AND GRU.BORRADO = 0
        ) GRU_NEW
        ON (GRU_OLD.GRU_ID = GRU_NEW.GRU_ID)
        WHEN MATCHED THEN UPDATE 
        SET  GRU_OLD.borrado = 1
           , GRU_OLD.fechamodificar = sysdate
           , GRU_OLD.USUARIOMODIFICAR = '''|| USUARIO_MIGRACION ||''' ';

      DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA_M||'.GRU_GRUPOS_USUARIOS borrado. '||SQL%ROWCOUNT||' Filas.');
       */

      COMMIT;  
      
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