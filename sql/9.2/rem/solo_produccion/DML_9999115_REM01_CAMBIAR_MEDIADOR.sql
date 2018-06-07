--/*
--#########################################
--## AUTOR=SIMEON SHOPOV
--## FECHA_CREACION=20180604
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-957
--## PRODUCTO=NO
--## 
--## Finalidad: 
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
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= 'ACT_ICO_INFO_COMERCIAL';
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-957';

	ACT_NUM_ACTIVO NUMBER(16);
	PVE_COD_REM VARCHAR2(55 CHAR);
	ICM_ID NUMBER(16);

    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		  T_JBV(5933693,2153)
		, T_JBV(6965922,1799)
		, T_JBV(5926639,672)
		, T_JBV(5925994,5071)
		, T_JBV(5926749,4396)
		, T_JBV(5965509,2149)
		, T_JBV(6965869,2996)
		, T_JBV(6966780,9990148)
		, T_JBV(5958283,2583)
		, T_JBV(6956356,12608)
		, T_JBV(6956363,12608)
		, T_JBV(6965741,2091)
		, T_JBV(6966779,2091)
		, T_JBV(6965773,2260)
		, T_JBV(5953429,3260)
		, T_JBV(5959188,3260)
		, T_JBV(5955955,3277)
		, T_JBV(6966793,3277)
		, T_JBV(5964835,12608)
		, T_JBV(6966835,4564)
		, T_JBV(5930917,120)
		, T_JBV(5954043,120)
		, T_JBV(5949610,2105)
		, T_JBV(6966842,1116)
		, T_JBV(6965755,13059)
		, T_JBV(6965894,1798)
		, T_JBV(5947111,2996)
		, T_JBV(5952660,1116)
		, T_JBV(5927449,3260)
		, T_JBV(5926952,120)
		, T_JBV(5926259,2119)
		, T_JBV(5951675,2119)
		, T_JBV(6965756,96)
		, T_JBV(6965876,96)
		, T_JBV(6965924,96)
		, T_JBV(6966765,96)
		, T_JBV(6966908,96)
		, T_JBV(6966921,96)
		, T_JBV(5927388,4446)
		, T_JBV(6966851,12608)
		, T_JBV(5933024,2127)
		, T_JBV(5967335,2299)
		, T_JBV(6966878,3260)
		, T_JBV(5971539,963)
		, T_JBV(6966863,1073)
		, T_JBV(6965734,9990167)
		, T_JBV(6966872,3386)
		, T_JBV(6965738,3219)
		, T_JBV(5942217,2164)
		, T_JBV(6966781,2164)
		, T_JBV(6965746,6602)
		, T_JBV(5936822,12608)
		, T_JBV(5931356,2303)
		, T_JBV(5959068,2303)
		, T_JBV(5952749,1798)
		, T_JBV(5926244,3219)
		, T_JBV(6965919,4434)
		, T_JBV(5968776,2137)
		, T_JBV(5963878,2140)
		, T_JBV(5969373,2140)
		, T_JBV(6967314,2140)
		, T_JBV(6965912,662)
		, T_JBV(6966862,4436)
		, T_JBV(5925462,9990172)
		, T_JBV(5925577,3260)
		, T_JBV(5930025,3260)
		, T_JBV(5954890,3260)
		, T_JBV(6344596,3260)
		, T_JBV(6966844,3260)
		, T_JBV(6966869,3260)
		, T_JBV(6966876,3260)
		, T_JBV(6966923,3260)
		, T_JBV(6967316,3260)
		, T_JBV(6967333,3260)
		, T_JBV(5943186,2137)
		, T_JBV(6960016,142)
		, T_JBV(6960027,142)
		, T_JBV(6965898,13048)
		, T_JBV(5928325,2164)
		, T_JBV(5948619,2164)
		, T_JBV(5956795,2164)
		, T_JBV(5967829,2164)
		, T_JBV(6965936,2164)
		, T_JBV(6965789,9990158)
		, T_JBV(6966962,91)
		, T_JBV(6966981,91)
		, T_JBV(6966983,91)
		, T_JBV(6966988,91)
		, T_JBV(5963309,2166)
		, T_JBV(6966927,4434)
		, T_JBV(5931393,2153)
		, T_JBV(5935656,2153)
		, T_JBV(5940681,2153)
		, T_JBV(6966771,142)
		, T_JBV(5930753,2705)
		, T_JBV(5938175,2705)
		, T_JBV(6965904,4447)
		, T_JBV(5959515,2153)
		, T_JBV(5936696,2321)
		, T_JBV(6966859,2119)
		, T_JBV(5962090,4564)
		, T_JBV(5930121,4767)
		, T_JBV(5960905,4767)
		, T_JBV(5961579,4767)
		, T_JBV(5963424,6421)
		, T_JBV(5926623,2152)
		, T_JBV(5934476,2152)
		, T_JBV(5935035,2152)
		, T_JBV(5935635,2152)
		, T_JBV(5938792,2152)
		, T_JBV(5939859,2152)
		, T_JBV(5941301,2152)
		, T_JBV(5942336,2152)
		, T_JBV(5944235,2152)
		, T_JBV(5945312,2152)
		, T_JBV(5946384,2152)
		, T_JBV(5949336,2152)
		, T_JBV(5952781,2152)
		, T_JBV(5959073,2152)
		, T_JBV(5961708,2152)
		, T_JBV(5961740,2152)
		, T_JBV(5966641,2152)
		, T_JBV(5946930,2127)
		, T_JBV(5953954,2127)
		, T_JBV(6965926,1798)
		, T_JBV(6966825,2143)
		, T_JBV(6063196,2982)
		, T_JBV(5939102,11503)
		, T_JBV(5966233,11503)
		, T_JBV(5941766,1145)
		, T_JBV(6965889,662)
		, T_JBV(6965905,662)
		, T_JBV(6965909,662)
		, T_JBV(6965920,662)
		, T_JBV(6966778,662)
		, T_JBV(6966785,662)
		, T_JBV(6966909,662)
		, T_JBV(6966929,662)
		, T_JBV(6965906,94)
		, T_JBV(6966773,3251)
		, T_JBV(5935050,2705)
		, T_JBV(5966764,2705)
		, T_JBV(5943428,3256)
		, T_JBV(5941394,1115)
		, T_JBV(6967328,1115)
		, T_JBV(5969638,662)
		, T_JBV(6044582,134)
		, T_JBV(6764616,4443)
		, T_JBV(5963151,4384)
		, T_JBV(6966836,4401)	
	); 
V_TMP_JBV T_JBV;
BEGIN


 
 FOR I IN V_JBV.FIRST .. V_JBV.LAST
 LOOP
 
 V_TMP_JBV := V_JBV(I);
 			  ACT_NUM_ACTIVO := TRIM(V_TMP_JBV(1));
			  PVE_COD_REM 	 := TRIM(V_TMP_JBV(2));
					
			V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_ICM_INF_COMER_HIST_MEDI
						SET 
							  ICM_FECHA_HASTA = SYSDATE
							, USUARIOMODIFICAR = '''||V_USUARIO||'''
							, FECHAMODIFICAR = SYSDATE
							WHERE
							ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO||')
							AND ICM_FECHA_HASTA IS NULL
							';
							
			EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_ICM_INF_COMER_HIST_MEDI (
								  ICM_ID
								, ACT_ID
								, ICO_MEDIADOR_ID
								, ICM_FECHA_DESDE
								, USUARIOCREAR
								, FECHACREAR
								) VALUES (
								  '||V_ESQUEMA||'.S_ACT_ICM_INF_COMER_HIST_MEDI.NEXTVAL
								, (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO||')
								, (SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = '||PVE_COD_REM||')
								, SYSDATE
								, '''||V_USUARIO||'''
								, SYSDATE
								)';
					
			EXECUTE IMMEDIATE V_SQL;


		V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' ICO SET
				  ICO_MEDIADOR_ID = (SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = '||PVE_COD_REM||')
				, USUARIOMODIFICAR = '''||V_USUARIO||'''
				, FECHAMODIFICAR = SYSDATE
				WHERE ICO.ACT_ID IN (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE ACT.ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO||')
					';
           
				EXECUTE IMMEDIATE V_SQL;
				
				IF SQL%ROWCOUNT > 0 THEN
					DBMS_OUTPUT.PUT_LINE('Se ha puesto el mediador PVE_COD_REM = '||PVE_COD_REM||' al activo '||ACT_NUM_ACTIVO);
					V_COUNT_UPDATE := V_COUNT_UPDATE + 1;
				END IF;
 END LOOP;			    
    
	COMMIT;

    DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado en total '||V_COUNT_UPDATE||' mediadores');

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
