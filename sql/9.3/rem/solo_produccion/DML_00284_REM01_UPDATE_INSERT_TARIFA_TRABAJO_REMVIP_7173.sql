--/*
--######################################### 
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20200427
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-7173
--## PRODUCTO=NO
--## 
--## Finalidad: Cambio tipo trabajo de acompañamiento y fotografia en config tarifa
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

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- #ESQUEMA# Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	PL_OUTPUT VARCHAR2(32000 CHAR);

	V_TABLA VARCHAR2(40 CHAR) := 'ACT_TCT_TRABAJO_CFGTARIFA';
	V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_ATR_TRABAJO_TARIFAS';
	V_CRA_COD VARCHAR2(20 CHAR) := '07'; 	-- Código de cartera CERBERUS (Comentado para divarian)
	V_SRC_COD VARCHAR2(20 CHAR) := '150'; 	-- Código de subcartera DIVARIAN (Comentado para divarian)
	V_SENTENCIA VARCHAR2(2000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-7173';

	V_COUNT NUMBER(25);
	
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] Se van a actualizar ACT_CFT_CONFIG_TARIFA Los subtipos de trabajo ACOMPAÑAMIENTO y FOTOGRAFIA al tipo de trabajo Actuacion Tecnica.');

	execute immediate 'UPDATE '||V_ESQUEMA||'.ACT_CFT_CONFIG_TARIFA SET
						DD_TTR_ID = (SELECT DD_TTR_ID FROM DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = ''03''),
						usuariomodificar = ''REMVIP-7173'',
						fechamodificar = sysdate
						where dd_str_id in ((select dd_str_id from dd_str_subtipo_trabajo where dd_str_codigo = ''ACO''),(select dd_str_id from dd_str_subtipo_trabajo where dd_str_codigo = ''FOT''))';

	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ACT_CFT_CONFIG_TARIFA. Deberian ser 42.');  

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');

	EXECUTE IMMEDIATE ('INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
		TCT_ID,
		TBJ_ID,
		CFT_ID,
		TCT_MEDICION,
		TCT_PRECIO_UNITARIO,
		VERSION,
		USUARIOCREAR,
		FECHACREAR,
		BORRADO
	)
	SELECT
		'||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL			AS TCT_ID,
		SQLI.*
	FROM (
		SELECT DISTINCT
			TBJ.TBJ_ID 									AS TBJ_ID,
			CFT.CFT_ID 									AS CFT_ID,
			MIG.TCT_MEDICION 							AS TCT_MEDICION,
			CFT.CFT_PRECIO_UNITARIO 					AS TCT_PRECIO_UNITARIO,
			0											AS VERSION,
			'''||V_USUARIO||'''							AS USUARIOCREAR,
			SYSDATE										AS FECHACREAR,
			0 											AS BORRADO
		FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' 			MIG
		JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO 			TBJ ON TBJ.TBJ_NUM_TRABAJO = MIG.TBJ_NUM_TRABAJO
		JOIN '||V_ESQUEMA||'.ACT_TBJ 				ACTTBJ ON ACTTBJ.TBJ_ID = TBJ.TBJ_ID
		JOIN '||V_ESQUEMA||'.ACT_ACTIVO 				ACT ON ACT.ACT_ID = ACTTBJ.ACT_ID
		JOIN '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA 		TTF ON TTF.DD_TTF_CODIGO = MIG.TIPO_TARIFA
		JOIN '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO 		TTR ON TTR.DD_TTR_ID = TBJ.DD_TTR_ID
		JOIN '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO 	STR ON STR.DD_STR_ID = TBJ.DD_STR_ID
		JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA 			CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND 
			CRA.BORRADO = 0 
		JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA 			SCR ON SCR.DD_SCR_ID = ACT.DD_SCR_ID AND 
			SCR.BORRADO = 0 
		JOIN '||V_ESQUEMA||'.ACT_CFT_CONFIG_TARIFA 		CFT ON CFT.DD_TTF_ID = TTF.DD_TTF_ID AND 
			CFT.DD_TTR_ID = TTR.DD_TTR_ID AND 
			CFT.DD_STR_ID = STR.DD_STR_ID AND 
			CFT.DD_CRA_ID = CRA.DD_CRA_ID AND 
			CFT.DD_SCR_ID = SCR.DD_SCR_ID AND 
			CFT.BORRADO = 0
		WHERE MIG.VALIDACION IN (0) AND NOT EXISTS (
			SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA||' AUX
			WHERE AUX.TBJ_ID = TBJ.TBJ_ID AND AUX.CFT_ID = CFT.CFT_ID
			AND AUX.BORRADO = 0
		)
	) SQLI'
	);

	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas. Deberian ser 48.826');

	COMMIT;

	V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'','''||V_TABLA||''',''1''); END;';
	EXECUTE IMMEDIATE V_SENTENCIA;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;    
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);    
    ROLLBACK;
    RAISE;        

END;
/
EXIT;
