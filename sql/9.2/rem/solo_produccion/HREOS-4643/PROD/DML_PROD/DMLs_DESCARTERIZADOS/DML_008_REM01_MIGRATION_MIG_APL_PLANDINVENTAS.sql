--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_APL_PLANDINVENTAS' -> 'ACT_PDV_PLAN_DIN_VENTAS'
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

V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01'; --REM01
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER'; --REMMASTER
V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
V_TABLA VARCHAR2(40 CHAR) := 'ACT_PDV_PLAN_DIN_VENTAS';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_APL_PLANDINVENTAS';
V_SENTENCIA VARCHAR2(1600 CHAR);

BEGIN
	
    DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');

	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
	PDV_ID,
	ACT_ID,	
	PDV_ACREEDOR_NOMBRE,
	PDV_ACREEDOR_CODIGO,
	PDV_ACREEDOR_NIF,
	PDV_ACREEDOR_DIR,
	PDV_IMPORTE_DEUDA,
	PDV_ACREEDOR_NUM_EXP,
	TIPO_PRODUCTO_ACTIVO,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	USUARIOMODIFICAR,
	FECHAMODIFICAR,
	USUARIOBORRAR,
	FECHABORRAR,
	BORRADO
	)
	SELECT 
	'||V_ESQUEMA||'.S_ACT_PDV_PLAN_DIN_VENTAS.NEXTVAL   				PDV_ID,
	ACT.ACT_ID                                  ACT_ID,
	MIG.PDV_ACREEDOR_NOMBRE                             PDV_ACREEDOR_NOMBRE,
	MIG.PDV_ACREEDOR_CODIGO                             PDV_ACREEDOR_CODIGO,
	MIG.PDV_ACREEDOR_NIF                                PDV_ACREEDOR_NIF,
	MIG.PDV_ACREEDOR_DIR                                PDV_ACREEDOR_DIR,
	MIG.PDV_IMPORTE_DEUDA                               PDV_IMPORTE_DEUDA,
	MIG.PDV_ACREEDOR_NUM_EXP							PDV_ACREEDOR_NUM_EXP,					
	MIG.PDV_TIPO_PRODUCTO_ACTIVO						TIPO_PRODUCTO_ACTIVO,
	''0''                                               VERSION,
	'''||V_USUARIO||'''                                   USUARIOCREAR,
	SYSDATE                                             FECHACREAR,
	NULL                                                USUARIOMODIFICAR,
	NULL                                                FECHAMODIFICAR,
	NULL                                                USUARIOBORRAR,
	NULL                                                FECHABORRAR,
	0                                                   BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
	INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
    ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	WHERE MIG.VALIDACION = 0
  ')
	;  
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
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
