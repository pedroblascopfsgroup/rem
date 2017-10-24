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
V_SENTENCIA VARCHAR2(1600 CHAR);

BEGIN
  
  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE INSERCION SOBRE LA TABLA '||V_ESQUEMA||'.ACT_ABA_ACTIVO_BANCARIO PARA AAFF.');
  
  EXECUTE IMMEDIATE ('
	INSERT /*+APPEND */ INTO '||V_ESQUEMA||'.ACT_ABA_ACTIVO_BANCARIO (
		ABA_ID,
		ACT_ID,
		DD_CLA_ID,
	  ABA_NEXPRIESGO,
		VERSION,
		USUARIOCREAR,
		FECHACREAR,
		BORRADO
	)
	SELECT 
		'||V_ESQUEMA||'.S_ACT_ABA_ACTIVO_BANCARIO.NEXTVAL   ABA_ID,
		ACT.ACT_ID                                         	ACT_ID,
	  (SELECT DD_CLA_ID
	    FROM '||V_ESQUEMA||'.DD_CLA_CLASE_ACTIVO
	    WHERE DD_CLA_CODIGO = ''01'')                      	DD_CLA_ID,
	  (SELECT PDV_ACREEDOR_NUM_EXP 
	    FROM '||V_ESQUEMA||'.ACT_PDV_PLAN_DIN_VENTAS PDV
	    WHERE PDV.ACT_ID = ACT.ACT_ID
	    AND PDV_ACREEDOR_NUM_EXP IS NOT NULL
	    AND PDV.BORRADO = 0
	    AND ROWNUM = 1)                                  	PDV_ACREEDOR_NUM_EXP,
	  ''0''                                                	VERSION,
	  '''||V_USUARIO||'''                                	USUARIOCREAR,
	  SYSDATE                                            	FECHACREAR,
	  0                                                  	BORRADO
	FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
	  INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.BORRADO = 0
	  INNER JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = ACT.DD_SCR_ID AND SCR.BORRADO = 0
	WHERE ACT.BORRADO = 0 AND SCR.DD_SCR_CODIGO = DECODE(CRA.DD_CRA_CODIGO, ''01'', ''01'',     ''02'', ''03'',     ''03'', ''05'',     ''04'', ''20'',     ''05'', ''12'')
	  AND NOT EXISTS (
	    SELECT 1
	    FROM '||V_ESQUEMA||'.ACT_ABA_ACTIVO_BANCARIO ABA
	    WHERE ABA.ACT_ID = ACT.ACT_ID AND ABA.BORRADO = 0
	)
   '
   )
   ;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_ABA_ACTIVO_BANCARIO cargada. '||SQL%ROWCOUNT||' Filas.');

  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE INSERCION SOBRE LA TABLA '||V_ESQUEMA||'.ACT_ABA_ACTIVO_BANCARIO PARA AAII.');
  
  EXECUTE IMMEDIATE ('
	INSERT /*+APPEND */ INTO '||V_ESQUEMA||'.ACT_ABA_ACTIVO_BANCARIO (
		ABA_ID,
		ACT_ID,
		DD_CLA_ID,
	  	DD_SCA_ID,
	 	ABA_NEXPRIESGO,
		VERSION,
		USUARIOCREAR,
		FECHACREAR,
		BORRADO
	)
	SELECT 
		'||V_ESQUEMA||'.S_ACT_ABA_ACTIVO_BANCARIO.NEXTVAL            ABA_ID,
		ACT.ACT_ID                                         ACT_ID,
		(SELECT DD_CLA_ID
	    FROM '||V_ESQUEMA||'.DD_CLA_CLASE_ACTIVO
	    WHERE DD_CLA_CODIGO = ''02'')                      DD_CLA_ID,
		(SELECT DD_SCA_ID
	    FROM '||V_ESQUEMA||'.DD_SCA_SUBCLASE_ACTIVO
	    WHERE DD_SCA_CODIGO = ''02'')                      DD_SCA_ID,
	  (SELECT PDV_ACREEDOR_NUM_EXP 
	    FROM '||V_ESQUEMA||'.ACT_PDV_PLAN_DIN_VENTAS PDV
	    WHERE PDV.ACT_ID = ACT.ACT_ID
	    AND PDV_ACREEDOR_NUM_EXP IS NOT NULL
	    AND PDV.BORRADO = 0
	    AND ROWNUM = 1)                                    PDV_ACREEDOR_NUM_EXP,
		''0''                                              VERSION,
		'''||V_USUARIO||'''                                USUARIOCREAR,
		SYSDATE                                            FECHACREAR,
		0                                                  BORRADO
	FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
	  INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.BORRADO = 0
	  INNER JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = ACT.DD_SCR_ID AND SCR.BORRADO = 0
	WHERE ACT.BORRADO = 0 AND SCR.DD_SCR_CODIGO <> DECODE(CRA.DD_CRA_CODIGO, ''01'', ''01'',     ''02'', ''03'',     ''03'', ''05'',     ''04'', ''20'',     ''05'', ''12'')
	  AND NOT EXISTS (
	    SELECT 1
	    FROM '||V_ESQUEMA||'.ACT_ABA_ACTIVO_BANCARIO ABA
	    WHERE ABA.ACT_ID = ACT.ACT_ID AND ABA.BORRADO = 0
	)
   '
   )
   ;
  /*= DECODE(CRA.DD_CRA_CODIGO, ''01'', ''02'',    ''02'', ''04'',     ''03'', ''06'',    ''03'', ''07'', ''03'', ''08'',''03'', ''09'',''03'', ''14'',''03'', ''15'',''03'', ''19'',''04'', ''10'',     ''07'', ''17'',''08'', ''18'',''06'', ''16'')*/
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_ABA_ACTIVO_BANCARIO cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;

  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''ACT_ABA_ACTIVO_BANCARIO'',''1''); END;';
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
