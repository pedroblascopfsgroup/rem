--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG2_ACT_PRP' -> 'ACT_PRP'
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
V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01'; --REM01
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER'; --REMMASTER
V_TABLA VARCHAR2(40 CHAR) := 'ACT_PRP';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_ACT_PRP';
V_SENTENCIA VARCHAR2(2000 CHAR);

BEGIN 
 
  --Inicio del proceso de volcado sobre RES_RESERVAS
  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
 
        EXECUTE IMMEDIATE ('
        INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
        ACT_ID,
        PRP_ID,
        ACT_PRP_PRECIO_PROPUESTO,
        ACT_PRP_PRECIO_SANCIONADO,
        ACT_PRP_MOTIVO_DESCARTE,
        VERSION
        )
        SELECT 
        ACT.ACT_ID                                                                                                                      ACT_ID,
        PRP.PRP_ID                                                                                                                      PRP_ID,
        MIG.ACT_PRP_PRECIO_PROPUESTO                                                                            ACT_PRP_PRECIO_PROPUESTO,
        MIG.ACT_PRP_PRECIO_SANCIONADO                                                                           ACT_PRP_PRECIO_SANCIONADO,
        MIG.ACT_PRP_MOTIVO_DESCARTE                                                                                     ACT_PRP_MOTIVO_DESCARTE,
        ''0''                                                                           VERSION
        FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG              
        INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
                ON ACT.ACT_NUM_ACTIVO = MIG.ACT_PRP_ACT_NUMERO_ACTIVO
        INNER JOIN '||V_ESQUEMA||'.PRP_PROPUESTAS_PRECIOS PRP
                ON PRP.PRP_NUM_PROPUESTA = MIG.ACT_PRP_NUM_PROPUESTA
        WHERE MIG.VALIDACION = 0
        ')
        ;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA||''',''10''); END;';
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
