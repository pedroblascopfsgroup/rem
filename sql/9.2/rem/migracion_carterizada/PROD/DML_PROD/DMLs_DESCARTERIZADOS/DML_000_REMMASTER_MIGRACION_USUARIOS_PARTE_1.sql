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
          , SQLI.*
        FROM (
          SELECT DISTINCT
            '|| ENTIDAD ||'
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
        ) SQLI
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
