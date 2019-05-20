--/*
--#########################################
--## AUTOR=Migracion Apple
--## FECHA_CREACION=20181217
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=
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

	  DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza la migración de USUARIOS');

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
          , ZON.ZON_ID                       		   AS ZON_ID
          , PEF.PEF_ID                       		   AS PEF_ID
          , USU.USU_ID                       		   AS USU_ID
          , '''|| USUARIO_MIGRACION ||'''    		   AS USUARIOCREAR
          , SYSDATE                          		   AS FECHACREAR
          , 0                                		   AS BORRADO
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
      ';
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
            '||V_ESQUEMA||'.S_USD_USUARIOS_DESPACHOS.NEXTVAL        AS USD_ID
          , DES.DES_ID                                  		    AS DES_ID                       
          , USU.USU_ID                                  			AS USU_ID
          , 1                                           			AS USD_GESTOR_DEFECTO
          , 1                                           			AS USD_SUPERVISOR
          , '''|| USUARIO_MIGRACION ||'''               			AS USUARIOCREAR
          , SYSDATE                                     			AS FECHACREAR
          , 0                                           			AS BORRADO
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
      ';
      EXECUTE IMMEDIATE V_SQL;
      DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS cargada. '||SQL%ROWCOUNT||' Filas.');


	  COMMIT;   
	  
	  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'',''ZON_PEF_USU'',''10''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;

      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'',''USD_USUARIOS_DESPACHOS'',''10''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
	    
      DBMS_OUTPUT.PUT_LINE('[FIN] Acaba la migración de USUARIOS');
      
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
