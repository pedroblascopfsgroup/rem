--/*
--#########################################
--## AUTOR=Gustavo Mora
--## FECHA_CREACION=20180817
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-1550
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

V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
V_TABLA VARCHAR2(40 CHAR) := 'VIS_VISITAS';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_VIS_VISITAS';
V_SENTENCIA VARCHAR2(32000 CHAR);

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
					MIG.VIS_OBSERVACIONES,
					row_number() over(partition by MIG.VIS_COD_VISITA_WEBCOM order by clc.clc_id asc) rn
					FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
					INNER JOIN '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL CLC
					  ON CLC.CLC_REM_ID = MIG.CLC_REM_ID OR (MIG.CLC_REM_ID IS NULL AND CLC.CLC_COD_CLIENTE_PRINEX = MIG.VIS_COD_CLIENTE_WEBCOM AND CLC.USUARIOCREAR = '''||V_USUARIO||''')
					INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
					  ON ACT.ACT_NUM_ACTIVO = MIG.VIS_ACT_NUMERO_ACTIVO
					  left join rem01.VIS_VISITAS vis on vis.VIS_WEBCOM_ID = mig.VIS_COD_VISITA_WEBCOM
					  left join (SELECT VIS_COD_VISITA_WEBCOM FROM rem01.MIG2_VIS_VISITAS group by VIS_COD_VISITA_WEBCOM having count(1) > 1) aux on aux.VIS_COD_VISITA_WEBCOM = mig.VIS_COD_VISITA_WEBCOM
			WHERE MIG.VALIDACION = 0 and vis.vis_id is null and aux.VIS_COD_VISITA_WEBCOM is null
			  )
                SELECT
                '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL                                                      VIS_ID, 
                VIS.VIS_COD_VISITA_WEBCOM                                                                              VIS_WEBCOM_ID,
                '||V_ESQUEMA||'.S_VIS_NUM_VISITA.NEXTVAL                                                         VIS_NUM_VISITA,
                VIS.ACT_ID                                                                                             ACT_ID,
                VIS.CLC_ID                                                                                             CLC_ID,
                (SELECT DD_EVI_ID 
                FROM '||V_ESQUEMA||'.DD_EVI_ESTADOS_VISITA
                WHERE DD_EVI_CODIGO =  VIS.VIS_COD_ESTADO_VISITA)                                           DD_EVI_ID,
                (SELECT DD_SVI_ID 
                FROM '||V_ESQUEMA||'.DD_SVI_SUBESTADOS_VISITA
                WHERE DD_SVI_CODIGO =  VIS.VIS_COD_SUBESTADO_VISISTA)                                   DD_SVI_ID,
                VIS.VIS_FECHA_REAL_VISITA                                                                               VIS_FECHA_VISITA,
                VIS.VIS_FECHA_SOLCITUD                                                                                  VIS_FECHA_SOLCITUD,
                (SELECT PVE_ID 
          FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
          INNER JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON TPR.DD_TPR_ID = PVE.DD_TPR_ID
          WHERE TPR.DD_TPR_CODIGO IN (''04'',''18'',''23'',''28'',''29'',''30'',''31'',''38'')
          AND PVE_COD_REM = VIS.VIS_COD_PRESCRIPTOR_UVEM AND PVE.PVE_FECHA_BAJA IS NULL
          AND ROWNUM = 1
    ) PVE_ID_PRESCRIPTOR,
                (SELECT PVE_ID 
          FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
          INNER JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON TPR.DD_TPR_ID = PVE.DD_TPR_ID
          WHERE TPR.DD_TPR_CODIGO IN (''04'',''18'',''23'',''28'',''29'',''30'',''31'',''38'')
          AND PVE_COD_REM = VIS.VIS_COD_API_CUSTODIO_UVEM AND PVE.PVE_FECHA_BAJA IS NULL
          AND ROWNUM = 1
    )   PVE_ID_API_CUSTODIO,
                (SELECT PVE_ID 
          FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
          INNER JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON TPR.DD_TPR_ID = PVE.DD_TPR_ID
          WHERE TPR.DD_TPR_CODIGO IN (''04'',''18'',''23'',''28'',''29'',''30'',''31'',''38'')
          AND PVE_COD_REM = VIS.VIS_COD_API_RESPONSABLE_UVEM AND PVE.PVE_FECHA_BAJA IS NULL
          AND ROWNUM = 1
    )                   PVE_ID_API_RESPONSABLE,
                (SELECT PVE_ID 
          FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
          INNER JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON TPR.DD_TPR_ID = PVE.DD_TPR_ID
          WHERE TPR.DD_TPR_CODIGO IN (''04'',''18'',''23'',''28'',''29'',''30'',''31'',''38'')
          AND PVE_COD_REM = VIS.VIS_COD_FVD_UVEM AND PVE.PVE_FECHA_BAJA IS NULL
          AND ROWNUM = 1
    )                                           PVE_ID_FDV,
                VIS.VIS_OBSERVACIONES                                                                                   VIS_OBSERVACIONES,
                VIS.VIS_FECHA_CONCERTACION                                                                              VIS_FECHA_CONCERTACION,
                0                                                                                                       VERSION,
                '''||V_USUARIO||'''                                                                         USUARIOCREAR,
                SYSDATE                                                                                     FECHACREAR,
                0                                                                                           BORRADO,
                REPLACE(VIS.VIS_COD_PROCEDENCIA, ''.'')                                 VIS_PROCEDENCIA
                FROM INSERTAR VIS
                where vis.rn = 1';
      EXECUTE IMMEDIATE V_SENTENCIA;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      COMMIT;

      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA||''',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');

EXECUTE IMMEDIATE 'MERGE INTO REM01.VIS_VISITAS T1
USING (SELECT T1.VIS_ID, T1.PVE_ID_API_RESPONSABLE PVE_ID
    FROM VIS_VISITAS T1
    JOIN MIG2_VIS_VISITAS T2 ON T1.VIS_WEBCOM_ID = T2.VIS_COD_VISITA_WEBCOM AND T2.VALIDACION = 0 AND T2.VIS_IND_VISITA_API_RESPONSABLE = 1
    WHERE T1.BORRADO = 0 AND T1.PVE_ID_PVE_VISITA IS NULL AND T1.PVE_ID_API_RESPONSABLE IS NOT NULL) T2
ON (T1.VIS_ID = T2.VIS_ID)
WHEN MATCHED THEN UPDATE SET
    T1.PVE_ID_PVE_VISITA = T2.PVE_ID';

DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizada (PVE_ID_PVE_VISITA con PVE_ID_API_RESPONSABLE). '||SQL%ROWCOUNT||' Filas.');

EXECUTE IMMEDIATE 'MERGE INTO REM01.VIS_VISITAS T1
USING (SELECT T1.VIS_ID, T1.PVE_ID_FDV PVE_ID
    FROM VIS_VISITAS T1
    JOIN MIG2_VIS_VISITAS T2 ON T1.VIS_WEBCOM_ID = T2.VIS_COD_VISITA_WEBCOM AND T2.VALIDACION = 0 AND T2.VIS_IND_VISITA_FVD = 1
    WHERE T1.BORRADO = 0 AND T1.PVE_ID_PVE_VISITA IS NULL AND T1.PVE_ID_FDV IS NOT NULL) T2
ON (T1.VIS_ID = T2.VIS_ID)
WHEN MATCHED THEN UPDATE SET
    T1.PVE_ID_PVE_VISITA = T2.PVE_ID';

DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizada (PVE_ID_PVE_VISITA con PVE_ID_FDV). '||SQL%ROWCOUNT||' Filas.');

EXECUTE IMMEDIATE 'MERGE INTO REM01.VIS_VISITAS T1
USING (SELECT T1.VIS_ID, T1.PVE_ID_PRESCRIPTOR PVE_ID
    FROM VIS_VISITAS T1
    JOIN MIG2_VIS_VISITAS T2 ON T1.VIS_WEBCOM_ID = T2.VIS_COD_VISITA_WEBCOM AND T2.VALIDACION = 0 AND T2.VIS_IND_VISITA_PRESCRIPTOR = 1
    JOIN ACT_PVE_PROVEEDOR T3 ON T3.PVE_ID = T1.PVE_ID_PRESCRIPTOR
    JOIN DD_TPR_TIPO_PROVEEDOR T4 ON T4.DD_TPR_ID = T3.DD_TPR_ID AND T4.DD_TPR_CODIGO NOT IN (''23'',''30'',''31'')
    WHERE T1.BORRADO = 0 AND T1.PVE_ID_PVE_VISITA IS NULL AND T1.PVE_ID_PRESCRIPTOR IS NOT NULL) T2
ON (T1.VIS_ID = T2.VIS_ID)
WHEN MATCHED THEN UPDATE SET
    T1.PVE_ID_PVE_VISITA = T2.PVE_ID';

DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizada (PVE_ID_PVE_VISITA con PVE_ID_PRESCRIPTOR). '||SQL%ROWCOUNT||' Filas.');

EXECUTE IMMEDIATE 'MERGE INTO REM01.VIS_VISITAS T1
USING (SELECT T1.VIS_ID, T1.PVE_ID_API_CUSTODIO PVE_ID
    FROM VIS_VISITAS T1
    JOIN MIG2_VIS_VISITAS T2 ON T1.VIS_WEBCOM_ID = T2.VIS_COD_VISITA_WEBCOM AND T2.VALIDACION = 0 AND T2.VIS_IND_VISITA_API_CUSTODIO = 1
    WHERE T1.BORRADO = 0 AND T1.PVE_ID_PVE_VISITA IS NULL AND T1.PVE_ID_API_CUSTODIO IS NOT NULL) T2
ON (T1.VIS_ID = T2.VIS_ID)
WHEN MATCHED THEN UPDATE SET
    T1.PVE_ID_PVE_VISITA = T2.PVE_ID';

DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizada (PVE_ID_PVE_VISITA con PVE_ID_API_CUSTODIO). '||SQL%ROWCOUNT||' Filas.');

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
