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
	V_TABLA VARCHAR2(40 CHAR) := 'MIG2_OFR_MAPEO_NUM_OFERTAS';
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

V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.MIG2_OFR_MAPEO_NUM_OFERTAS';

EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS_2;

IF V_NUM_TABLAS_2 = 1 THEN

V_SENTENCIA := 'TRUNCATE TABLE '||V_ESQUEMA||'.MIG2_OFR_MAPEO_NUM_OFERTAS';

	EXECUTE IMMEDIATE V_SENTENCIA;

ELSE
	DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.MIG2_OFR_MAPEO_NUM_OFERTAS');

	
	V_SENTENCIA := 'INSERT INTO '||V_ESQUEMA||'.MIG2_OFR_MAPEO_NUM_OFERTAS(COD_OFERTA_BANKIA, COD_OFERTA_CAIXA, OFR_ID, ECO_ID)(SELECT 9 + OFR_NUM_OFERTA, OFR_NUM_OFERTA, '||V_ESQUEMA||'.S_OFR_OFERTAS.NEXTVAL, '||V_ESQUEMA||'.S_ECO_EXPEDIENTE_COMERCIAL.NEXTVAL FROM (SELECT DISTINCT OFR.OFR_NUM_OFERTA  FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
                    INNER JOIN '||V_ESQUEMA||'.ACT_OFR ACO ON ACO.OFR_ID = OFR.OFR_ID
                    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ACO.ACT_ID
                    INNER JOIN  '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO  ON ECO.OFR_ID = OFR.OFR_ID
                    INNER JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
                    INNER JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_ID = OFR.DD_EOF_ID
		     INNER JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE ATR ON  ATR.TBJ_ID=ECO.TBJ_ID
                    INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
					INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON ATR.TRA_ID = TAC.TRA_ID AND ATR.TBJ_ID=ECO.TBJ_ID
					INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID AND TAR.TAR_TAREA_FINALIZADA = 0
                    WHERE CRA.DD_CRA_CODIGO = ''03'' AND EOF.DD_EOF_CODIGO IN (''01'') AND  eec.dd_eec_codigo NOT IN (02, 08, 15, 12, 32, 35, 37, 41)               
UNION ALL
SELECT DISTINCT OFR.OFR_NUM_OFERTA FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
                    INNER JOIN '||V_ESQUEMA||'.ACT_OFR ACO ON ACO.OFR_ID = OFR.OFR_ID
                    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ACO.ACT_ID
                    INNER JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_ID = OFR.DD_EOF_ID
                    INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
                    WHERE CRA.DD_CRA_CODIGO = ''03'' AND EOF.DD_EOF_CODIGO IN (''04''))) ';
                   
        	EXECUTE IMMEDIATE V_SENTENCIA;

	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.MIG2_OFR_MAPEO_NUM_OFERTAS cargada. '||SQL%ROWCOUNT||' Filas.');
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
