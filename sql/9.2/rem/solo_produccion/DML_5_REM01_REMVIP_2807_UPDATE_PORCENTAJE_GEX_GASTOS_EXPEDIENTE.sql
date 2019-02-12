--/*
--#########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20181212
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-2807
--## PRODUCTO=NO
--## 
--## Finalidad: Actualiza importes erroneos de la tabla GEX_GASTOS_EXPEDIENTE
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; --'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; --'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_KOUNT NUMBER(16); -- Vble. para kontar.
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-2807';

BEGIN


	 V_SQL := ' MERGE INTO '||V_ESQUEMA||'.GEX_GASTOS_EXPEDIENTE T1
				USING (
   					    SELECT DISTINCT ECO.ECO_NUM_EXPEDIENTE, GEX.GEX_ID, GEX.GEX_IMPORTE_CALCULO, GEX.GEX_IMPORTE_FINAL, GEX.ACT_ID, 
					    ROUND(AFR.ACT_OFR_IMPORTE*(GEX.GEX_IMPORTE_CALCULO/100),2) AS CALCULO 
					    FROM '||V_ESQUEMA||'.GEX_GASTOS_EXPEDIENTE GEX
					    JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.ECO_ID = GEX.ECO_ID 
					    JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID 
					    JOIN '||V_ESQUEMA||'.ACT_OFR AFR ON AFR.ACT_ID = GEX.ACT_ID AND  AFR.OFR_ID = ECO.OFR_ID 
					    WHERE GEX.DD_TCC_ID = 1 
				        AND ECO.ECO_NUM_EXPEDIENTE IN (129370,
									129168,
									126291,
									122992,
									123127,
									126562,
									123125,
									123402,
									126086,
									123857,
									124464,
									123433,
									113160,
									115149,
									113709,
									111776,
									110456,
									125283,
									113855,
									106995,
									110878,
									112027,
									111959,
									110149,
									109686,
									110306,
									108924,
									113125,
									104065,
									124571,
									110741,
									104633,
									124309,
									124316,
									107832,
									107377,
									124558,
									112850,
									108804,
									110656,
									108002,
									107365,
									104413,
									109078,
									105232,
									105891,
									124226,
									123498,
									106398,
									104019,
									98276,
									99666,
									101379,
									96487,
									104783,
									101250,
									96712,
									102828,
									102980,
									92193,
									102342,
									101600,
									104504,
									102263,
									91113,
									104005,
									94344,
									95833,
									102169,
									93926,
									124237,
									124222,
									123993,
									123542,
									123527,
									123543,
									92954,
									96300,
									92538,
									122264,
									90576,
									91752,
									122089,
									122230,
									86535,
									87122,
									121352,
									80406,
									19587,
									121836,
									17168,
									19411,
									17072,
									75381,
									128535,
									128716,
									128950,
									129141,
									124632,
									122856,
									122272,
									123002,
									125097,
									125241,
									121500,
									122849,
									124329,
									125600,
									123378,
									123239,
									123242,
									121523,
									123963,
									123276,
									121519,
									123277,
									123274,
									123241,
									124091,
									117500,
									123403,
									123638,
									123463,
									124621,
									124334,
									124584,
									125490,
									125487,
									125486,
									92552,
									123199,
									123734,
									123735,
									123732,
									123726,
									123783,
									123730,
									100507,
									100036,
									100032,
									100499,
									100211,
									100287,
									100552,
									100591,
									100611,
									100632,
									100672,
									100703,
									100938,
									100758,
									100798,
									100845,
									100904,
									100946,
									100941,
									100987,
									101060,
									101178,
									101259,
									101395,
									101459,
									123991,
									92693,
									19929,
									99371,
									121729,
									5325,
									128095,
									129469,
									124740,
									134876,
									121166,
									133702,
									124624,
									126443,
									133645,
									126416,
									123087,
									125053,
									121117,
									125468,
									123246,
									125145,
									129683,
									129669,
									123019,
									121511,
									131094,
									129238,
									127515,
									123850,
									126717,
									128326,
									116190,
									125567,
									124167,
									121466,
									122841,
									124945,
									125659,
									105003,
									113623,
									111079,
									99768,
									96390,
									94170,
									86593,
									42738,
									130942)
				        ) T2 
						ON (T1.GEX_ID = T2.GEX_ID) 
						WHEN MATCHED THEN UPDATE SET 
							T1.GEX_IMPORTE_FINAL = T2.CALCULO, 
							T1.USUARIOMODIFICAR = ''REMVIP-2807'', 
							T1.FECHAMODIFICAR = SYSDATE'; 


	EXECUTE IMMEDIATE V_SQL;
		
	COMMIT;

      DBMS_OUTPUT.put_line('[INFO] Se han actualizado '||SQL%ROWCOUNT||' registro en la tabla GEX_GASTOS_EXPEDIENTE');

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
