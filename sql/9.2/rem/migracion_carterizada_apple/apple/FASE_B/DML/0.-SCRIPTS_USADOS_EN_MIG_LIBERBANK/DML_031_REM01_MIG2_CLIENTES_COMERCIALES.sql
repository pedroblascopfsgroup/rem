--/*
--#########################################
--## AUTOR=Gustavo Mora
--## FECHA_CREACION=20180817
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1550
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
V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
V_TABLA VARCHAR2(40 CHAR) := 'CLC_CLIENTE_COMERCIAL';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_CLC_CLIENTE_COMERCIAL';
V_SENTENCIA VARCHAR2(32000 CHAR);

BEGIN
      
      --Inicio del proceso de volcado sobre CLC_CLIENTE_COMERCIAL
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      V_SENTENCIA := '
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
          ,CLC_WEBCOM_ID_OLD
          ,CLC_COD_CLIENTE_PRINEX
        )
        SELECT 
          '||V_ESQUEMA||'.S_CLC_CLIENTE_COMERCIAL.NEXTVAL     																		AS CLC_ID,
          NVL(AUX.CLC_REM_ID,'||V_ESQUEMA||'.S_CLC_REM_ID.NEXTVAL)                													AS CLC_REM_ID,
          AUX.CLC_WEBCOM_ID, AUX.CLC_NUM_CLIENTE_HAYA, AUX.CLC_NUM_CLIENTE_UVEM, AUX.CLC_RAZON_SOCIAL, 
          AUX.CLC_NOMBRE, AUX.CLC_APELLIDOS, AUX.CLC_FECHA_ALTA, AUX.USU_ID, AUX.DD_TDI_ID, AUX.CLC_DOCUMENTO, 
          AUX.DD_TDI_ID_REPRESENTANTE, AUX.CLC_DOCUMENTO_REPRESENTANTE, AUX.CLC_TELEFONO1, AUX.CLC_TELEFONO2, 
          AUX.CLC_EMAIL, AUX.DD_TVI_ID, AUX.CLC_DIRECCION, AUX.CLC_NUMEROCALLE, AUX.CLC_ESCALERA, AUX.CLC_PLANTA, 
          AUX.CLC_PUERTA, AUX.CLC_CODIGO_POSTAL, AUX.DD_PRV_ID, AUX.DD_LOC_ID, AUX.DD_UPO_ID, AUX.CLC_OBSERVACIONES, 
          AUX.VERSION, AUX.USUARIOCREAR, AUX.FECHACREAR, AUX.BORRADO, AUX.CLC_WEBCOM_ID_OLD, AUX.CLC_COD_CLIENTE_PRINEX
        FROM (      
          SELECT DISTINCT      
          MIG2.CLC_REM_ID                                     AS CLC_REM_ID,
          null						                          AS CLC_WEBCOM_ID,      
          MIG2.CLC_COD_CLIENTE_HAYA                           AS CLC_NUM_CLIENTE_HAYA,
          MIG2.CLC_COD_CLIENTE_UVEM                           AS CLC_NUM_CLIENTE_UVEM,
          MIG2.CLC_RAZON_SOCIAL                               AS CLC_RAZON_SOCIAL,
          MIG2.CLC_NOMBRE                                     AS CLC_NOMBRE,
          MIG2.CLC_APELLIDOS                                  AS CLC_APELLIDOS,
          MIG2.CLC_FECHA_ALTA                                 AS CLC_FECHA_ALTA,
          USU.USU_ID                                          AS USU_ID,
          TDI.DD_TDI_ID                                       AS DD_TDI_ID,
          MIG2.CLC_DOCUMENTO                                  AS CLC_DOCUMENTO,
          TDI2.DD_TDI_ID                                      AS DD_TDI_ID_REPRESENTANTE,
          MIG2.CLC_DOCUMENTO_RTE                              AS CLC_DOCUMENTO_REPRESENTANTE,
          MIG2.CLC_TELEFONO1                                  AS CLC_TELEFONO1,
          MIG2.CLC_TELEFONO2                                  AS CLC_TELEFONO2,
          MIG2.CLC_EMAIL                                      AS CLC_EMAIL,
          TVI.DD_TVI_ID                                       AS DD_TVI_ID,
          MIG2.CLC_CLC_DIRECCION                              AS CLC_DIRECCION,
          MIG2.CLC_NUMEROCALLE                                AS CLC_NUMEROCALLE,
          MIG2.CLC_ESCALERA                                   AS CLC_ESCALERA,
          MIG2.CLC_PLANTA                                     AS CLC_PLANTA,
          MIG2.CLC_PUERTA                                     AS CLC_PUERTA,
          MIG2.CLC_CODIGO_POSTAL                              AS CLC_CODIGO_POSTAL,
          PRV.DD_PRV_ID                                       AS DD_PRV_ID,  
          LOC.DD_LOC_ID                                       AS DD_LOC_ID,
          UPO.DD_UPO_ID                                       AS DD_UPO_ID,
          MIG2.CLC_OBSERVACIONES                              AS CLC_OBSERVACIONES,
          0                                                   AS VERSION,
          '''||V_USUARIO||'''                                 AS USUARIOCREAR,
          SYSDATE                                             AS FECHACREAR,
          0                                                   AS BORRADO,
          MIG2.CLC_COD_CLIENTE_WEBCOM                         AS CLC_WEBCOM_ID_OLD,
          MIG2.CLC_COD_CLIENTE_WEBCOM                         AS CLC_COD_CLIENTE_PRINEX
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2
          LEFT JOIN '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU ON USU.USU_USERNAME = MIG2.CLC_COD_USUARIO_LDAP_ACCION AND USU.BORRADO = 0
          LEFT JOIN '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID TDI ON TDI.DD_TDI_CODIGO = MIG2.CLC_COD_TIPO_DOCUMENTO AND TDI.BORRADO = 0
          LEFT JOIN '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID TDI2 ON TDI2.DD_TDI_CODIGO = MIG2.CLC_COD_TIPO_DOC_RTE AND TDI2.BORRADO = 0
          LEFT JOIN '||V_ESQUEMA_MASTER||'.DD_TVI_TIPO_VIA TVI ON TVI.DD_TVI_CODIGO = MIG2.CLC_COD_TIPO_VIA AND TVI.BORRADO = 0
          LEFT JOIN '||V_ESQUEMA_MASTER||'.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_CODIGO = MIG2.CLC_COD_PROVINCIA AND PRV.BORRADO = 0
          LEFT JOIN '||V_ESQUEMA_MASTER||'.DD_LOC_LOCALIDAD LOC ON LOC.DD_LOC_CODIGO = MIG2.CLC_COD_LOCALIDAD AND LOC.BORRADO = 0
          LEFT JOIN '||V_ESQUEMA_MASTER||'.DD_UPO_UNID_POBLACIONAL UPO ON UPO.DD_UPO_CODIGO = TRIM(LEADING 0 FROM MIG2.CLC_COD_UNIDADPOBLACIONAL) AND UPO.BORRADO = 0
          WHERE MIG2.VALIDACION = 0 AND MIG2.CLC_REM_ID IS NULL) AUX';
      EXECUTE IMMEDIATE V_SENTENCIA;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');

      /*EXECUTE IMMEDIATE 'MERGE INTO REM01.CLC_CLIENTE_COMERCIAL T1
        USING REM01.MIG2_CLC_CLIENTE_COMERCIAL T2
        ON (T2.CLC_COD_CLIENTE_WEBCOM = T1.CLC_WEBCOM_ID_OLD)
        WHEN MATCHED THEN UPDATE SET
            T1.CLC_NOMBRE = T2.CLC_NOMBRE, T1.CLC_APELLIDOS = T2.CLC_APELLIDOS
        WHERE T1.CLC_NOMBRE <> T2.CLC_NOMBRE OR T1.CLC_APELLIDOS <> T2.CLC_APELLIDOS';

      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL actualizada (CLC_NOMBRE, CLC_APELLIDOS). '||SQL%ROWCOUNT||' Filas.');*/

      COMMIT;

      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'','''||V_TABLA||''',''10''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');

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
