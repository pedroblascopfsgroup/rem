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

TABLE_COUNT NUMBER(10,0) := 0;
V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; /* Configuracion Esquema*/
V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; /* Configuracion Esquema Master*/
V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
V_TABLA VARCHAR2(40 CHAR) := 'ACT_PDV_PLAN_DIN_VENTAS';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_APL_PLANDINVENTAS';
V_SENTENCIA VARCHAR2(1600 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_DUPL NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

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
	WITH ACT_NUM_ACTIVO AS (
    SELECT ACT_NUMERO_ACTIVO,PDV_ACREEDOR_NOMBRE,
    PDV_ACREEDOR_CODIGO,
    PDV_ACREEDOR_NIF,
    PDV_ACREEDOR_DIR,
    PDV_IMPORTE_DEUDA,
    PDV_ACREEDOR_NUM_EXP,
    PDV_TIPO_PRODUCTO_ACTIVO
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
    LEFT JOIN '||V_ESQUEMA||'.ACT_NOT_EXISTS NOTT
      ON NOTT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO AND nott.tabla_mig = '''||V_TABLA_MIG||''' 
    WHERE NOTT.ACT_NUM_ACTIVO IS NULL
	AND MIG.VALIDACION = 0
	)
	SELECT 
	S_ACT_PDV_PLAN_DIN_VENTAS.NEXTVAL   				PDV_ID,
	ACT.ACT_ID                                  ACT_ID,
	MIG.PDV_ACREEDOR_NOMBRE                             PDV_ACREEDOR_NOMBRE,
	MIG.PDV_ACREEDOR_CODIGO                             PDV_ACREEDOR_CODIGO,
	MIG.PDV_ACREEDOR_NIF                                PDV_ACREEDOR_NIF,
	MIG.PDV_ACREEDOR_DIR                                PDV_ACREEDOR_DIR,
	MIG.PDV_IMPORTE_DEUDA                               PDV_IMPORTE_DEUDA,
	MIG.PDV_ACREEDOR_NUM_EXP							PDV_ACREEDOR_NUM_EXP,					
	MIG.PDV_TIPO_PRODUCTO_ACTIVO						TIPO_PRODUCTO_ACTIVO,
	''0''                                               VERSION,
	'||V_USUARIO||'                                   USUARIOCREAR,
	SYSDATE                                             FECHACREAR,
	NULL                                                USUARIOMODIFICAR,
	NULL                                                FECHAMODIFICAR,
	NULL                                                USUARIOBORRAR,
	NULL                                                FECHABORRAR,
	0                                                   BORRADO
	FROM ACT_NUM_ACTIVO MIG
  INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
    ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
  ')
	;  
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
  
  
  -- INSERTAMOS TODOS LOS ACTIVOS DE PDV_PLAN_DIN_VENTAS EN ABA_ACTIVO_BANCARIO
  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE INSERCION SOBRE LA TABLA '||V_ESQUEMA||'.ACT_ABA_ACTIVO_BANCARIO.');
  
  EXECUTE IMMEDIATE ('
  INSERT INTO '||V_ESQUEMA||'.ACT_ABA_ACTIVO_BANCARIO ABA (
	ABA_ID,
	ACT_ID,
	DD_CLA_ID,
	DD_TIP_ID,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	BORRADO,
	ABA_TIPO_PRODUCTO
	)
	SELECT 
	'||V_ESQUEMA||'.S_ACT_ABA_ACTIVO_BANCARIO.NEXTVAL               ABA_ID,
	PDV.ACT_ID                                      ACT_ID,
	CLA.DD_CLA_ID                                   DD_CLA_ID,
	TIP.DD_TIP_ID                                   DD_TIP_ID,
	''0''                                             VERSION,
	'||V_USUARIO||'                                 USUARIOCREAR,
	SYSDATE                                         FECHACREAR,
	0                                               BORRADO,
	TIP.DD_TIP_DESCRIPCION_LARGA                    ABA_TIPO_PRODUCTO
	FROM '||V_ESQUEMA||'.ACT_PDV_PLAN_DIN_VENTAS PDV
	INNER JOIN '||V_ESQUEMA||'.DD_CLA_CLASE_ACTIVO CLA
	  ON CLA.DD_CLA_CODIGO = ''01''
	LEFT JOIN '||V_ESQUEMA||'.DD_TIP_TIPO_PRODUCTO TIP
	  ON TIP.DD_TIP_CODIGO = PDV.TIPO_PRODUCTO_ACTIVO
	WHERE PDV.ACT_ID NOT IN (
	  SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ABA_ACTIVO_BANCARIO ABA1
	  WHERE PDV.ACT_ID = ABA1.ACT_ID)
   ')
	;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_ABA_ACTIVO_BANCARIO cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.ACT_ABA_ACTIVO_BANCARIO COMPUTE STATISTICS');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACT_ABA_ACTIVO_BANCARIO ANALIZADA.');
  
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