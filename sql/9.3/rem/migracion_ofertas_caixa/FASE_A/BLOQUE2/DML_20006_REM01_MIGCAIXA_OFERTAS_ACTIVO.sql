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
	MAX_NUM_OFR NUMBER(10,0) := 0;
	V_NUM_TABLAS NUMBER(10,0) := 0;
	V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01'; --REM01
	V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER'; --REMMASTER
	V_USUARIO VARCHAR2(50 CHAR) := 'MIG_CAIXA';
	V_TABLA VARCHAR2(40 CHAR) := 'MIG2_OFA_OFERTAS_ACTIVO_CAIXA';
	V_SENTENCIA VARCHAR2(32000 CHAR);
	V_REG_MIG NUMBER(10,0) := 0;
	V_REG_INSERTADOS NUMBER(10,0) := 0;
	V_DUPLICADOS NUMBER(10,0) := 0;
	V_REJECTS NUMBER(10,0) := 0;
	V_COD NUMBER(10,0) := 0;
	V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';
	V_OFR_ID NUMBER(16,0);    -- Varaible que almacenara las OFR_ID de aquellas ofertas aceptadas
	V_TABLE_ECO NUMBER(16,0); -- Variable que almacenara los Expedientes Comerciales creados
	V_TABLE_DD_EOF NUMBER(16,0); -- Variable que almacenara los ESTADOS_OFERTAS modificados
	V_TABLE_ECO_MER NUMBER(16,0); -- Variable que almacenara los Expedientes Comerciales mergeados
	V_NUM_TABLAS_2 NUMBER(16);
	V_MSQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

BEGIN

	--Inicio del proceso de volcado sobre OFR_OFERTAS

	V_SENTENCIA := 'INSERT INTO '||V_ESQUEMA||'.MIG2_OFA_OFERTAS_ACTIVO_CAIXA (ACT_ID,
		OFR_ID,
		ACT_OFR_IMPORTE,
		VERSION,
		OFR_ACT_PORCEN_PARTICIPACION) SELECT ACO.ACT_ID, MIG.COD_OFERTA_CAIXA, ACO.ACT_OFR_IMPORTE, ACO.VERSION, ACO.OFR_ACT_PORCEN_PARTICIPACION 
		FROM '||V_ESQUEMA||'.ACT_OFR ACO 
		JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ACO.OFR_ID 
		JOIN '||V_ESQUEMA||'.MIG2_OFR_MAPEO_NUM_OFERTAS MIG ON MIG.COD_OFERTA_CAIXA = OFR.OFR_NUM_OFERTA';

	EXECUTE IMMEDIATE V_SENTENCIA;
  

	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');

	COMMIT; 

	V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'','''||V_TABLA||''',''1''); END;';
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
