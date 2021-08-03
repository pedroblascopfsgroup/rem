--/*
--#########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20210727
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.11
--## INCIDENCIA_LINK=HREOS-14680
--## PRODUCTO=NO
--## 
--## Finalidad: 
--## 
--## INSTRUCCIONES:  
--## VERSIONES:
--## 		0.1 Versión inicial
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
	V_USUARIO VARCHAR2(50 CHAR) := 'MIG_CAIXA';
	V_TABLA VARCHAR2(40 CHAR) := 'TXO_TEXTOS_OFERTA';
	V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_OBF_OBSERVACIONES_OFERTAS_CAIXA';
	V_SENTENCIA VARCHAR2(32000 CHAR);
	V_NUM_TABLAS NUMBER(16);
	V_MSQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

BEGIN
	--Inicio del proceso de volcado sobre TXO_TEXTOS_OFERTA
V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'';

EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN
DBMS_OUTPUT.PUT_LINE('La tabla/s de migración implicada está vacía. No se realiza ninguna acción');

ELSE


	DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
	
	EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' OEX (
		TXO_ID,
		OFR_ID,
		DD_TTX_ID,
		TXO_TEXTO,
		VERSION,
		USUARIOCREAR,
		FECHACREAR,
		BORRADO
	)
	SELECT
		'||V_ESQUEMA||'.S_TXO_TEXTOS_OFERTA.NEXTVAL 		AS TXO_ID,
		OFR.OFR_ID 											AS OFR_ID,
		TTX.DD_TTX_ID 										AS DD_TTX_ID,
		MIG2.OBF_OBSERVACION 								AS TXO_TEXTO,
		0 													AS VERSION,
		'''||V_USUARIO||''' 								AS USUARIOCREAR,
		MIG2.OBF_FECHA 										AS FECHACREAR,
		0 													AS BORRADO
		FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2
		INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS 					OFR ON OFR.OFR_NUM_OFERTA = MIG2.OBF_COD_OFERTA AND OFR.BORRADO = 0
		INNER JOIN '||V_ESQUEMA||'.DD_TTX_TIPOS_TEXTO_OFERTA 	TTX ON DD_TTX_CODIGO = MIG2.OBF_COD_TIPO_OBS
		WHERE MIG2.VALIDACION = 0 AND
		NOT EXISTS (
			SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA||' AUX
			WHERE AUX.OFR_ID = OFR.OFR_ID AND
			AUX.DD_TTX_ID = TTX.DD_TTX_ID
		)
	';

	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');

	COMMIT;

	V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA||''',''10''); END;';
	EXECUTE IMMEDIATE V_SENTENCIA;
END IF;
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
