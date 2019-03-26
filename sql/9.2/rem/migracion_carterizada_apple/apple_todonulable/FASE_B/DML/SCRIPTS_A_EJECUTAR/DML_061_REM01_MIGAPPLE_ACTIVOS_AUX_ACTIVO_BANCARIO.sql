--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20171025
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: A
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
V_SENTENCIA VARCHAR2(1600 CHAR);

BEGIN
  
  
  DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza la migración de ACTIVOS BANCARIO');

  -------------------------------------------------
  --INSERCION EN ACT_ABA_ACTIVO_BANCARIO--
  -------------------------------------------------
  DBMS_OUTPUT.PUT_LINE('  [INFO] INSERCION EN ACT_ABA_ACTIVO_BANCARIO');
  DBMS_OUTPUT.PUT_LINE('	[INFO] Para activos de Apple serán todos: CLASE (inmoviliario), SUBCLASE (REO)');
  
  
  EXECUTE IMMEDIATE ('
	INSERT /*+APPEND */ INTO '||V_ESQUEMA||'.ACT_ABA_ACTIVO_BANCARIO (
		ABA_ID,
		ACT_ID,
		DD_CLA_ID,
		DD_SCA_ID,
		ABA_NEXPRIESGO,
		USUARIOCREAR,
		FECHACREAR
	)
	WITH PDV AS (
	    SELECT PDV.ACT_ID,PDV.PDV_ACREEDOR_NUM_EXP,ROW_NUMBER() OVER(PARTITION BY PDV.ACT_ID ORDER BY PDV.PDV_ID) RN
	    FROM '||V_ESQUEMA||'.ACT_PDV_PLAN_DIN_VENTAS PDV
	    WHERE PDV.PDV_ACREEDOR_NUM_EXP IS NOT NULL AND PDV.BORRADO = 0
	)
	SELECT 
		'||V_ESQUEMA||'.S_ACT_ABA_ACTIVO_BANCARIO.NEXTVAL, 
		ACT.ACT_ID, 
		CLA.DD_CLA_ID, 
		SCA.DD_SCA_ID,
		PDV.PDV_ACREEDOR_NUM_EXP, 
		'''||V_USUARIO||''', 
		SYSDATE
	FROM '||V_ESQUEMA||'.ACT_ACTIVO 					ACT
	LEFT JOIN '||V_ESQUEMA||'.ACT_ABA_ACTIVO_BANCARIO   ABA ON ABA.ACT_ID = ACT.ACT_ID AND ABA.BORRADO = 0
	JOIN '||V_ESQUEMA||'.DD_CLA_CLASE_ACTIVO            CLA ON CLA.DD_CLA_CODIGO = ''02''
	JOIN '||V_ESQUEMA||'.DD_SCA_SUBCLASE_ACTIVO 		SCA ON SCA.DD_SCA_CODIGO = ''02''
	JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA 			    CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.BORRADO = 0
	JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA 				SCR ON SCR.DD_SCR_ID = ACT.DD_SCR_ID AND SCR.BORRADO = 0
	LEFT JOIN 												PDV ON PDV.ACT_ID = ACT.ACT_ID AND PDV.RN = 1
	WHERE ACT.USUARIOCREAR = ''MIG_APPLE'' AND ABA.ABA_ID IS NULL');
  
  DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_ABA_ACTIVO_BANCARIO cargada. '||SQL%ROWCOUNT||' Filas.');


  COMMIT;

  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'',''ACT_ABA_ACTIVO_BANCARIO'',''1''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;
  
  DBMS_OUTPUT.PUT_LINE('[FIN] Acaba la migración de ACTIVOS BANCARIO');
  
  
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
