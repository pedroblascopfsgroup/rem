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
--## 		0.2 Correcciones
--## 		0.3 HREOS-10749 Se añade comprobación de registros en MIG
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


	DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
	
	EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.MIG2_OBF_OBSERVACIONES_OFERTAS_CAIXA OEX (
		OFR_NUM_OFERTA,
		DD_TTX_ID,
		TXO_TEXTO
	)
		SELECT
		MIG.COD_OFERTA_CAIXA,
		TXO.DD_TTX_ID,
		TXO.TXO_TEXTO 								
		FROM '||V_ESQUEMA||'.TXO_TEXTOS_OFERTA TXO
		INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = TXO.OFR_ID
		INNER JOIN '||V_ESQUEMA||'.MIG2_OFR_MAPEO_NUM_OFERTAS MIG ON MIG.COD_OFERTA_CAIXA = OFR.OFR_NUM_OFERTA
	';

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
