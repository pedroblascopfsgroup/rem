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

TABLE_COUNT_1 NUMBER(10,0) := 0;
TABLE_COUNT_2 NUMBER(10,0) := 0;
V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01'; --REM01
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER'; --REMMASTER
V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
V_TABLA VARCHAR2(40 CHAR) := 'ACT_HVA_HIST_VALORACIONES';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_ACT_HVA_HIST_VALORACIONES';
V_SENTENCIA VARCHAR2(32000 CHAR);

BEGIN

      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      V_SENTENCIA := '
          INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' HVA (
              HVA_ID
              ,ACT_ID
              ,DD_TPC_ID
              ,HVA_IMPORTE
              ,HVA_FECHA_INICIO
              ,HVA_FECHA_FIN
              ,HVA_FECHA_APROBACION
              ,HVA_FECHA_CARGA
              ,USU_ID
              ,HVA_OBSERVACIONES
              ,VERSION
              ,USUARIOCREAR
              ,FECHACREAR
              ,BORRADO
          )
          SELECT
            '||V_ESQUEMA||'.S_ACT_HVA_HIST_VALORACIONES.NEXTVAL                             AS HVA_ID,
            AUX.*
          FROM (
              SELECT DISTINCT
                  ACT.ACT_ID                                                                                AS ACT_ID,
                  TPC.DD_TPC_ID                                                                           AS DD_TPC_ID,
                  MIG2.HVA_IMPORTE                                                                    AS HVA_IMPORTE,
                  MIG2.HVA_FECHA_INICIO                                                             AS HVA_FECHA_INICIO,
                  MIG2.HVA_FECHA_FIN                                                                  AS HVA_FECHA_FIN,
                  MIG2.HVA_FECHA_APROBACION                                                   AS HVA_FECHA_APROBACION,
                  MIG2.HVA_FECHA_CARGA                                                            AS HVA_FECHA_CARGA,
                  USU.USU_ID                                                                                  AS USU_ID,
                  MIG2.HVA_OBSERVACIONES                                                          AS HVA_OBSERVACIONES,
                  0                                                                                               AS VERSION,
                  '''||V_USUARIO||'''                                                        AS USUARIOCREAR,
                  SYSDATE                                                                                   AS FECHACREAR,
                  0                                                                                               AS BORRADO
              FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2
              INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = MIG2.HVA_ACT_NUMERO_ACTIVO AND ACT.BORRADO = 0
              INNER JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_CODIGO = MIG2.HVA_COD_TIPO_PRECIO AND TPC.BORRADO = 0
              LEFT JOIN '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU ON USU.USU_USERNAME = MIG2.HVA_COD_USUARIO AND USU.BORRADO = 0
			  WHERE MIG2.VALIDACION = 0
          ) AUX       
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      COMMIT;
      
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA||''',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
 
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
