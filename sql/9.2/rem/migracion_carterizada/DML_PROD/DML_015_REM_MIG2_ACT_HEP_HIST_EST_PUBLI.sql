--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_ACT_HEP_HIST_EST_PUBLI -> ACT_HEP_HIST_EST_PUBLICACION
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
V_TABLA VARCHAR2(40 CHAR) := 'ACT_HEP_HIST_EST_PUBLICACION';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_ACT_HEP_HIST_EST_PUBLI';
V_SENTENCIA VARCHAR2(32000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

BEGIN

      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      V_SENTENCIA := '
          INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' HEP (
              HEP_ID
              ,ACT_ID
              ,HEP_FECHA_DESDE
              ,HEP_FECHA_HASTA
              ,DD_POR_ID
              ,DD_TPU_ID
              ,DD_EPU_ID
              ,HEP_MOTIVO
              ,VERSION
              ,USUARIOCREAR
              ,FECHACREAR
              ,BORRADO
          )
          SELECT
            '||V_ESQUEMA||'.S_ACT_HEP_HIST_EST_PUBLICACION.NEXTVAL      AS HEP_ID,
            ACT.ACT_ID                                                  AS ACT_ID,
            NVL(MIG2.HEP_FECHA_DESDE, NVL(MIG2.HEP_FECHA_HASTA, SYSDATE))  AS HEP_FECHA_DESDE,
            MIG2.HEP_FECHA_HASTA                                        AS HEP_FECHA_HASTA,
            POR.DD_POR_ID                                               AS DD_POR_ID,
            TPU.DD_TPU_ID                                               AS DD_TPU_ID,
            EPU.DD_EPU_ID                                               AS DD_EPU_ID,
            MIG2.HEP_MOTIVO                                             AS HEP_MOTIVO,
            0                                                           AS VERSION,
            '||V_USUARIO||'                                     AS USUARIOCREAR,
            SYSDATE                                                     AS FECHACREAR,
            0                                                           AS BORRADO
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2
          INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = MIG2.HEP_ACT_NUMERO_ACTIVO AND ACT.BORRADO = 0
          LEFT JOIN '||V_ESQUEMA||'.DD_POR_PORTAL POR ON POR.DD_POR_CODIGO = LPAD(MIG2.HEP_COD_PORTAL,2,0) AND POR.BORRADO = 0
          LEFT JOIN '||V_ESQUEMA||'.DD_TPU_TIPO_PUBLICACION TPU ON TPU.DD_TPU_CODIGO = LPAD(MIG2.HEP_COD_TIPO_PUBLICACION,2,0) AND TPU.BORRADO = 0
          LEFT JOIN '||V_ESQUEMA||'.DD_EPU_ESTADO_PUBLICACION EPU ON EPU.DD_EPU_CODIGO = LPAD(MIG2.HEP_COD_ESTADO_PUBLI,2,0) AND EPU.BORRADO = 0
		  WHERER MIG2.VALIDACION = 0
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA;
      
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