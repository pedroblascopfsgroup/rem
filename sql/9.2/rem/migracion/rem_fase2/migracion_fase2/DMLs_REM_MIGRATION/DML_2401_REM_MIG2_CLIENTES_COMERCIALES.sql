--/*
--#########################################
--## AUTOR=MANUEL RODRIGUEZ
--## FECHA_CREACION=20160928
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_CLC_CLIENTE_COMERCIAL -> CLC_CLIENTE_COMERCIAL
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

TABLE_COUNT NUMBER(10,0) := 0;
V_ESQUEMA VARCHAR2(10 CHAR) := '#ESQUEMA#';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
V_TABLA VARCHAR2(40 CHAR) := 'CLC_CLIENTE_COMERCIAL';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_CLC_CLIENTE_COMERCIAL';
V_SENTENCIA VARCHAR2(32000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

BEGIN
      
      --COMPROBACIONES PREVIAS - USUARIOS
      DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO USUARIOS...');
      
      V_SENTENCIA := '
      SELECT COUNT(DISTINCT CLC_COD_USUARIO_LDAP_ACCION) 
      FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
      WHERE NOT EXISTS (
        SELECT 1 FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = MIG2.CLC_COD_USUARIO_LDAP_ACCION
      )
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT;
      
      IF TABLE_COUNT = 0 THEN
      
          DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS USUARIOS EXISTEN EN REMMASTER.USU_USUARIOS');
      
      ELSE
      
          DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT||' USUARIOS INEXISTENTES EN USU_USUARIO. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_USU_NOT_EXISTS.');
          
          --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
          
          EXECUTE IMMEDIATE '
          DELETE FROM '||V_ESQUEMA||'.MIG2_USU_NOT_EXISTS
          WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
          '
          ;
          
          COMMIT;
          
          EXECUTE IMMEDIATE '
          INSERT INTO '||V_ESQUEMA||'.MIG2_USU_NOT_EXISTS (
            TABLA_MIG,
            USU_USERNAME,            
            FECHA_COMPROBACION
          )
          WITH USERNAME_NOT_EXISTS AS (
            SELECT DISTINCT MIG2.CLC_COD_USUARIO_LDAP_ACCION 
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
            WHERE NOT EXISTS (
              SELECT 1 
              FROM '||V_ESQUEMA_MASTER||'.USU_USUARIO USU
              WHERE MIG2.CLC_COD_USUARIO_LDAP_ACCION = USU.USU_USERNAME
            )
          )
          SELECT DISTINCT
          '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
          MIG2.CLC_COD_USUARIO_LDAP_ACCION    						      OFA_COD_OFERTA,          
          SYSDATE                                                                 FECHA_COMPROBACION
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2  
          INNER JOIN USERNAME_NOT_EXISTS ON USERNAME_NOT_EXISTS.USU_USERNAME = MIG2.CLC_COD_USUARIO_LDAP_ACCION
          '
          ;
          
          COMMIT;      
      
      END IF;
      
      --Inicio del proceso de volcado sobre CLC_CLIENTE_COMERCIAL
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      EXECUTE IMMEDIATE '
        INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
          CLC_ID
          ,CLC_REM_ID
          ,CLC_WEBCOM_ID
          ,CLC_NUM_CLIENTE_HAYA
          ,CLC_NUM_CLIENTE_UVEM
          ,CLC_RAZON_SOCIAL
          ,CLC_NOMBRE
          ,CLC_APELLIDOS
          ,CLC_FECHA_ALTA
          ,USU_ID
          ,DD_TDI_ID
          ,CLC_DOCUMENTO
          ,DD_TDI_ID_REPRESENTANTE
          ,CLC_DOCUMENTO_REPRESENTANTE
          ,CLC_TELEFONO1
          ,CLC_TELEFONO2
          ,CLC_EMAIL
          ,DD_TVI_ID
          ,CLC_DIRECCION
          ,CLC_NUMEROCALLE
          ,CLC_ESCALERA
          ,CLC_PLANTA
          ,CLC_PUERTA
          ,CLC_CODIGO_POSTAL
          ,DD_PRV_ID
          ,DD_LOC_ID
          ,DD_UPO_ID
          ,CLC_OBSERVACIONES
          ,VERSION
          ,USUARIOCREAR
          ,FECHACREAR
          ,BORRADO
        )
        WITH CLIENTE_WEBCOM AS (
          SELECT DISTINCT CLC_COD_CLIENTE_WEBCOM
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' WMIG2
          WHERE NOT EXISTS (
            SELECT 1
            FROM '||V_ESQUEMA||'.'||V_TABLA||' CLC
            WHERE CLC.CLC_WEBCOM_ID = WMIG2.CLC_COD_CLIENTE_WEBCOM
          )  
        )
        SELECT 
          '||V_ESQUEMA||'.S_CLC_CLIENTE_COMERCIAL.NEXTVAL                                         AS CLC_ID,
          '||V_ESQUEMA||'.S_CLC_REM_ID.NEXTVAL                                          AS CLC_REM_ID,
          AUX.*
        FROM (      
          SELECT DISTINCT      
          MIG2.CLC_COD_CLIENTE_WEBCOM                                                       AS CLC_WEBCOM_ID,      
          MIG2.CLC_COD_CLIENTE_HAYA                                                            AS CLC_NUM_CLIENTE_HAYA,
          MIG2.CLC_COD_CLIENTE_UVEM                                                           AS CLC_NUM_CLIENTE_UVEM,
          MIG2.CLC_RAZON_SOCIAL                                                                  AS CLC_RAZON_SOCIAL,
          MIG2.CLC_NOMBRE                                                                            AS CLC_NOMBRE,
          MIG2.CLC_APELLIDOS                                                                         AS CLC_APELLIDOS,
          MIG2.CLC_FECHA_ALTA                                                                      AS CLC_FECHA_ALTA,
          (SELECT USU.USU_ID
          FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU
          WHERE USU.USU_USERNAME = MIG2.CLC_COD_USUARIO_LDAP_ACCION
          AND USU.BORRADO = 0)                                                                      AS USU_ID,
          (SELECT DD.DD_TDI_ID 
            FROM '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID DD 
            WHERE DD.DD_TDI_CODIGO = MIG2.CLC_COD_TIPO_DOCUMENTO
            AND DD.BORRADO = 0)                                                                       AS DD_TDI_ID,
          MIG2.CLC_DOCUMENTO                                                                           AS CLC_DOCUMENTO,
          (SELECT DD.DD_TDI_ID 
            FROM '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID DD 
            WHERE DD.DD_TDI_CODIGO = MIG2.CLC_COD_TIPO_DOC_RTE
            AND BORRADO = 0)                                                                        AS DD_TDI_ID_REPRESENTANTE,
          MIG2.CLC_DOCUMENTO_RTE                                                               AS CLC_DOCUMENTO_REPRESENTANTE,
          MIG2.CLC_TELEFONO1                                                                        AS CLC_TELEFONO1,
          MIG2.CLC_TELEFONO2                                                                        AS CLC_TELEFONO2,
          MIG2.CLC_EMAIL                                                                                AS CLC_EMAIL,
          (SELECT DD.DD_TVI_ID
            FROM '||V_ESQUEMA_MASTER||'.DD_TVI_TIPO_VIA DD
            WHERE DD.DD_TVI_CODIGO = MIG2.CLC_COD_TIPO_VIA
            AND DD.BORRADO = 0)                                                                   AS DD_TVI_ID,
          MIG2.CLC_CLC_DIRECCION                                                                  AS CLC_DIRECCION,
          MIG2.CLC_NUMEROCALLE                                                                  AS CLC_NUMEROCALLE,
          MIG2.CLC_ESCALERA                                                                         AS CLC_ESCALERA,
          MIG2.CLC_PLANTA                                                                             AS CLC_PLANTA,
          MIG2.CLC_PUERTA                                                                            AS CLC_PUERTA,
          MIG2.CLC_CODIGO_POSTAL                                                               AS CLC_CODIGO_POSTAL,
          (SELECT DD.DD_PRV_ID
            FROM '||V_ESQUEMA_MASTER||'.DD_PRV_PROVINCIA DD
            WHERE DD.DD_PRV_CODIGO = MIG2.CLC_COD_PROVINCIA
            AND DD.BORRADO = 0)                                                                   AS DD_PRV_ID,  
          (SELECT DD.DD_LOC_ID
            FROM '||V_ESQUEMA_MASTER||'.DD_LOC_LOCALIDAD DD
            WHERE DD.DD_LOC_CODIGO = MIG2.CLC_COD_LOCALIDAD
            AND DD.BORRADO = 0)                                                                   AS DD_LOC_ID,
          (SELECT DD.DD_UPO_ID
            FROM '||V_ESQUEMA_MASTER||'.DD_UPO_UNID_POBLACIONAL DD
            WHERE DD.DD_UPO_CODIGO = MIG2.CLC_COD_UNIDADPOBLACIONAL
            AND DD.BORRADO = 0)                                                                        AS DD_UPO_ID,
          MIG2.CLC_OBSERVACIONES                                                                      AS CLC_OBSERVACIONES,
          0                                                                                                           AS VERSION,
          ''MIG2''                                                                                                    AS USUARIOCREAR,
          SYSDATE                                                                                               AS FECHACREAR,
          0                                                                                                           AS BORRADO
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2
          INNER JOIN CLIENTE_WEBCOM CW ON CW.CLC_COD_CLIENTE_WEBCOM = MIG2.CLC_COD_CLIENTE_WEBCOM
        ) AUX
      '
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      COMMIT;
      
      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
      
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
      
      -- INFORMAMOS A LA TABLA INFO
      
      -- Registros MIG
      V_SENTENCIA := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'';  
      EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_MIG;
      
      -- Registros insertados en REM
      V_SENTENCIA := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USUARIOCREAR = ''MIG2''';  
      EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_INSERTADOS;
      
      -- Total registros rechazados
      V_REJECTS := V_REG_MIG - V_REG_INSERTADOS;	
      
      /*  
      -- Diccionarios rechazados
      V_SENTENCIA := '
      SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_COD_NOT_EXISTS 
      WHERE DICCIONARIO IN (''DD_TPR_TIPO_PROVEEDOR'',''DD_TDI_TIPO_DOCUMENTO_ID'',''DD_ZNG_ZONA_GEOGRAFICA'',''DD_PRV_PROVINCIA'',''DD_LOC_LOCALIDAD'')
      AND FICHERO_ORIGEN = ''PROVEEDORES.dat''
      AND CAMPO_ORIGEN IN (''TIPO_PROVEEDOR'',''TIPO_DOCUMENTO'',''ZONA_GEOGRAFICA'',''PVE_PROVINCIA'',''PVE_LOCALIDAD'')
      '
      ;
      
      EXECUTE IMMEDIATE V_SENTENCIA INTO V_COD;
      */
      
      -- Observaciones
      IF V_REJECTS != 0 THEN
        V_OBSERVACIONES := 'Se han rechazado '||V_REJECTS||' CLIENTES_COMERCIALES, comprobar la MIG2_USU_NOT_EXISTS.';
      END IF;
      
      EXECUTE IMMEDIATE '
      INSERT INTO '||V_ESQUEMA||'.MIG_INFO_TABLE (
        TABLA_MIG,
        TABLA_REM,
        REGISTROS_TABLA_MIG,
        REGISTROS_INSERTADOS,
        REGISTROS_RECHAZADOS,
        DD_COD_INEXISTENTES,
        FECHA,
        OBSERVACIONES
      )
      SELECT
      '''||V_TABLA_MIG||''',
      '''||V_TABLA||''',
      '||V_REG_MIG||',
      '||V_REG_INSERTADOS||',
      '||V_REJECTS||',
      '||V_COD||',
      SYSDATE,
      '''||V_OBSERVACIONES||'''
      FROM DUAL
      '
      ;
      
      COMMIT;  

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
