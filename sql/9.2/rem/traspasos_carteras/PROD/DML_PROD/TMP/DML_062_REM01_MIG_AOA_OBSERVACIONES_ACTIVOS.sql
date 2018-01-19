--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20170612
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_AOA_OBSERVACIONES_ACTIVOS' -> 'ACT_AOB_ACTIVO_OBS'
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
V_USUARIO VARCHAR2(50 CHAR) := 'TRASPASO_TANGO';
V_TABLA VARCHAR2(40 CHAR) := 'ACT_AOB_ACTIVO_OBS';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_AOA_OBSERVACIONES_ACTIVOS';
V_SENTENCIA VARCHAR2(2000 CHAR);

BEGIN
  
  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
 
  EXECUTE IMMEDIATE ('
  INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
    AOB_ID,
    ACT_ID,
    USU_ID,
    AOB_OBSERVACION,
    AOB_FECHA,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO,
    DD_TOB_ID
  )
  SELECT
    '||V_ESQUEMA||'.S_ACT_AOB_ACTIVO_OBS.NEXTVAL        AOB_ID,
    ACT.ACT_ID                                          ACT_ID,
    USU.USU_ID                                          USU_ID,
    MIG.AOB_OBSERVACION                       AOB_OBSERVACION,
    MIG.AOB_FECHA                         AOB_FECHA,
    ''0''                             VERSION,
    '''||V_USUARIO||'''                   USUARIOCREAR,
    SYSDATE                             FECHACREAR,
    0                               BORRADO,
    TOB.DD_TOB_ID                  DD_TOB_ID
  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
  INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
  INNER JOIN '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU ON USU.USU_USERNAME = MIG.USERNAME
  LEFT JOIN '||V_ESQUEMA||'.DD_TOB_TIPO_OBSERVACION TOB ON TOB.DD_TOB_CODIGO = MIG.AOB_TIPO_OBSERVACION
  WHERE MIG.VALIDACION = 0
  '
  )
  ;

  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA||''',''10''); END;';
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