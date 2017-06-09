--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_VIS_VISITAS -> VIS_VISITAS
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
TABLE_COUNT_2 NUMBER(10,0) := 0;
V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
V_TABLA VARCHAR2(40 CHAR) := 'VIS_VISITAS';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_VIS_VISITAS';
V_SENTENCIA VARCHAR2(32000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_DUPLICADOS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

BEGIN

      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      V_SENTENCIA := '
        INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
                VIS_ID,
                VIS_WEBCOM_ID,
                VIS_NUM_VISITA,
                ACT_ID,
                CLC_ID,
                DD_EVI_ID,
                DD_SVI_ID,
                VIS_FECHA_VISITA,
                VIS_FECHA_SOLICTUD,
                PVE_ID_PRESCRIPTOR,
                PVE_ID_API_CUSTODIO,
                PVE_ID_API_RESPONSABLE,
                PVE_ID_FDV,
                VIS_OBSERVACIONES,
                VIS_FECHA_CONCERTACION,
                VERSION,
                USUARIOCREAR,
                FECHACREAR,
                BORRADO,
                VIS_PROCEDENCIA
                )
                WITH INSERTAR AS (
                SELECT DISTINCT 
                CLC.CLC_ID,
                ACT.ACT_ID,
                MIG.VIS_COD_VISITA_WEBCOM,
                MIG.VIS_COD_ESTADO_VISITA,
                MIG.VIS_COD_SUBESTADO_VISISTA,
                MIG.VIS_COD_PROCEDENCIA,
                MIG.VIS_COD_SUBPROCEDENCIA,
                MIG.VIS_FECHA_SOLCITUD,
                MIG.VIS_FECHA_CONCERTACION,
                MIG.VIS_FECHA_REAL_VISITA,
                MIG.VIS_COD_PRESCRIPTOR_UVEM,
                MIG.VIS_IND_VISITA_PRESCRIPTOR,
                MIG.VIS_COD_API_RESPONSABLE_UVEM,
                MIG.VIS_IND_VISITA_API_RESPONSABLE,
                MIG.VIS_COD_API_CUSTODIO_UVEM,
                MIG.VIS_IND_VISITA_API_CUSTODIO,
                MIG.VIS_COD_FVD_UVEM,
                MIG.VIS_IND_VISITA_FVD,
                MIG.VIS_OBSERVACIONES
                FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
                INNER JOIN '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL CLC
                  ON CLC.CLC_WEBCOM_ID = MIG.VIS_COD_CLIENTE_WEBCOM
                INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
                  ON ACT.ACT_NUM_ACTIVO = MIG.VIS_ACT_NUMERO_ACTIVO
				WHERE MIG.VALIDACION = 0
          ),
      DUPLICADOS AS (
          SELECT DISTINCT VIS_COD_VISITA_WEBCOM
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' WMIG2
		  WHERE WMIG2.VALIDACION = 0
          GROUP BY VIS_COD_VISITA_WEBCOM 
          HAVING COUNT(1) > 1
          )
                SELECT
                '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL                                         					   VIS_ID, 
                VIS.VIS_COD_VISITA_WEBCOM                                                                              VIS_WEBCOM_ID,
                '||V_ESQUEMA||'.S_VIS_NUM_VISITA.NEXTVAL                                                			   VIS_NUM_VISITA,
                VIS.ACT_ID                                                                                             ACT_ID,
                VIS.CLC_ID                                                                                             CLC_ID,
                (SELECT DD_EVI_ID 
                FROM '||V_ESQUEMA||'.DD_EVI_ESTADOS_VISITA
                WHERE DD_EVI_CODIGO =  VIS.VIS_COD_ESTADO_VISITA)                               						DD_EVI_ID,
                (SELECT DD_SVI_ID 
                FROM '||V_ESQUEMA||'.DD_SVI_SUBESTADOS_VISITA
                WHERE DD_SVI_CODIGO =  VIS.VIS_COD_SUBESTADO_VISISTA)                   								DD_SVI_ID,
                VIS.VIS_FECHA_REAL_VISITA                                                                               VIS_FECHA_VISITA,
                VIS.VIS_FECHA_SOLCITUD                                                                                  VIS_FECHA_SOLCITUD,
                (SELECT PVE_ID 
          FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
          INNER JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON TPR.DD_TPR_ID = PVE.DD_TPR_ID
          WHERE TPR.DD_TPR_CODIGO IN (''04'',''18'',''23'',''28'',''29'',''30'',''31'')
          AND PVE_COD_UVEM = VIS.VIS_COD_PRESCRIPTOR_UVEM
          AND ROWNUM = 1
    ) PVE_ID_PRESCRIPTOR,
                (SELECT PVE_ID 
          FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
          INNER JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON TPR.DD_TPR_ID = PVE.DD_TPR_ID
          WHERE TPR.DD_TPR_CODIGO IN (''04'',''18'',''23'',''28'',''29'',''30'',''31'')
          AND PVE_COD_UVEM = VIS.VIS_COD_API_CUSTODIO_UVEM
          AND ROWNUM = 1
    )   PVE_ID_API_CUSTODIO,
                (SELECT PVE_ID 
          FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
          INNER JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON TPR.DD_TPR_ID = PVE.DD_TPR_ID
          WHERE TPR.DD_TPR_CODIGO IN (''04'',''18'',''23'',''28'',''29'',''30'',''31'')
          AND PVE_COD_UVEM = VIS.VIS_COD_API_RESPONSABLE_UVEM
          AND ROWNUM = 1
    )                   PVE_ID_API_RESPONSABLE,
                (SELECT PVE_ID 
          FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
          INNER JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON TPR.DD_TPR_ID = PVE.DD_TPR_ID
          WHERE TPR.DD_TPR_CODIGO IN (''04'',''18'',''23'',''28'',''29'',''30'',''31'')
          AND PVE_COD_UVEM = VIS.VIS_COD_FVD_UVEM
          AND ROWNUM = 1
    )                                           PVE_ID_FDV,
                VIS.VIS_OBSERVACIONES                                                                                   VIS_OBSERVACIONES,
                VIS.VIS_FECHA_CONCERTACION                                                                              VIS_FECHA_CONCERTACION,
                0                                                                                                       VERSION,
                '||V_USUARIO||'                                                                					USUARIOCREAR,
                SYSDATE                                                                         						FECHACREAR,
                0                                                                               						BORRADO,
                REPLACE(VIS.VIS_COD_PROCEDENCIA, ''.'')																	VIS_PROCEDENCIA
                FROM INSERTAR VIS
                WHERE NOT EXISTS (
            SELECT 1
            FROM DUPLICADOS DUP
            WHERE DUP.VIS_COD_VISITA_WEBCOM = VIS.VIS_COD_VISITA_WEBCOM)
                '
                ;
      EXECUTE IMMEDIATE V_SENTENCIA     ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      V_REG_INSERTADOS := SQL%ROWCOUNT;
      
      COMMIT;
      
      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
      
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