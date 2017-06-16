--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20170612
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG2_OFA_OFERTAS_ACTIVO' -> 'ACT_OFR'
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
V_TABLA VARCHAR2(40 CHAR) := 'ACT_OFR';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_OFA_OFERTAS_ACTIVO';
V_SENTENCIA VARCHAR2(2000 CHAR);


BEGIN
  
  --Inicio del proceso de volcado sobre ACT_OFR
  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
 
        EXECUTE IMMEDIATE '
        INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
        ACT_ID,
        OFR_ID,
        ACT_OFR_IMPORTE,
        VERSION,
        OFR_ACT_PORCEN_PARTICIPACION
        )
        WITH INSERTAR AS (
      SELECT DISTINCT ACT.ACT_ID, OFR.OFR_ID, MIG.OFA_IMPORTE_PARTICIPACION, MIG.OFA_PORCENTAJE_PARTICIPACION
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
      INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR
        ON OFR.OFR_NUM_OFERTA = MIG.OFA_COD_OFERTA
      INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
        ON ACT.ACT_NUM_ACTIVO = MIG.OFA_ACT_NUMERO_ACTIVO
      WHERE MIG.VALIDACION = 0
      )
        SELECT 
        ACT_OFR.ACT_ID                                          ACT_ID,
        ACT_OFR.OFR_ID                                          OFR_ID,
        ACT_OFR.OFA_IMPORTE_PARTICIPACION       CT_OFR_IMPORTE,
        0                                                                       VERSION,
        OFA_PORCENTAJE_PARTICIPACION            OFR_ACT_PORCEN_PARTICIPACION
        FROM INSERTAR ACT_OFR';
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
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
