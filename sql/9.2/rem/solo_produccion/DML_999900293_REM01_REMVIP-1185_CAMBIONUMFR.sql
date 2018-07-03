--/*
--##########################################
--## AUTOR=Sergio Ortuño
--## FECHA_CREACION=20180703
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1185
--## PRODUCTO=NO
--##
--## Finalidad: Cambio de número de finca registral
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    --V_COUNT NUMBER(16); -- Vble. para contar.
    --V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-1185';
	V_COUNT NUMBER;
	V_CONTADOR NUMBER := 0;
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
	--
    	--T_TIPO_DATA('DEL',' HRNIVDOS-6732', '4B2E8766639C697EE055000000000001', 267717, 0,NULL),
	--T_TIPO_DATA('INS',' HRNIVDOS-6732', '48BF117E11EA8282E055000000000001', 267717, 0,303578)
	
		T_TIPO_DATA(202754,35018,7489159),
		T_TIPO_DATA(202755,35014,7489159),
		T_TIPO_DATA(202756,34928,7489159),
		T_TIPO_DATA(202759,35030,7489159),
		T_TIPO_DATA(202765,35068,7489159),
		T_TIPO_DATA(202767,34960,7489159),
		T_TIPO_DATA(202770,3484050,7489159),
		T_TIPO_DATA(202774,3484066,7489159),
		T_TIPO_DATA(202776,3484075,7489159),
		T_TIPO_DATA(202777,3484079,7489159),
		T_TIPO_DATA(202778,3484080,7489159),
		T_TIPO_DATA(202782,3484021,7489159),
		T_TIPO_DATA(202783,3484016,7489159),
		T_TIPO_DATA(202790,34840103,7489159),
		T_TIPO_DATA(203088,35012,7489159),
		T_TIPO_DATA(203089,34930,7489159),
		T_TIPO_DATA(203092,35024,7489159),
		T_TIPO_DATA(203095,35054,7489159),
		T_TIPO_DATA(203098,34952,7489159),
		T_TIPO_DATA(203155,35004,7489159),
		T_TIPO_DATA(203170,34978,7489159),
		T_TIPO_DATA(203171,3484052,7489159),
		T_TIPO_DATA(203172,3484046,7489159),
		T_TIPO_DATA(203173,3484056,7489159),
		T_TIPO_DATA(203174,3484070,7489159),
		T_TIPO_DATA(203326,34918,7489159),
		T_TIPO_DATA(203329,35000,7489159),
		T_TIPO_DATA(203333,34840121,7489159),
		T_TIPO_DATA(203343,34840138,7489159),
		T_TIPO_DATA(203344,34840143,7489159),
		T_TIPO_DATA(203347,34840106,7489159),
		T_TIPO_DATA(203469,34980,7489159),
		T_TIPO_DATA(203470,34966,7489159),
		T_TIPO_DATA(203471,34860,7489159),
		T_TIPO_DATA(203472,34912,7489159),
		T_TIPO_DATA(203473,34914,7489159),
		T_TIPO_DATA(203475,34990,7489159),
		T_TIPO_DATA(203476,34986,7489159),
		T_TIPO_DATA(203477,34992,7489159),
		T_TIPO_DATA(203478,34984,7489159),
		T_TIPO_DATA(203479,34994,7489159),
		T_TIPO_DATA(203480,34870,7489159),
		T_TIPO_DATA(203481,34840149,7489159),
		T_TIPO_DATA(203482,34840123,7489159),
		T_TIPO_DATA(203483,34840117,7489159),
		T_TIPO_DATA(203484,34840120,7489159),
		T_TIPO_DATA(203485,34840116,7489159),
		T_TIPO_DATA(203486,34840118,7489159),
		T_TIPO_DATA(203487,3484039,7489159),
		T_TIPO_DATA(203488,3484041,7489159),
		T_TIPO_DATA(203489,34840126,7489159),
		T_TIPO_DATA(203490,34840131,7489159),
		T_TIPO_DATA(203491,34840128,7489159),
		T_TIPO_DATA(203492,34840148,7489159),
		T_TIPO_DATA(203493,3484026,7489159),
		T_TIPO_DATA(203494,3484032,7489159),
		T_TIPO_DATA(203495,3484024,7489159),
		T_TIPO_DATA(203496,3484025,7489159),
		T_TIPO_DATA(203853,34840113,7489159),
		T_TIPO_DATA(203854,34840109,7489159),
		T_TIPO_DATA(203910,34974,7489159),
		T_TIPO_DATA(203911,34968,7489159),
		T_TIPO_DATA(203912,34976,7489159),
		T_TIPO_DATA(203913,34916,7489159),
		T_TIPO_DATA(203914,34858,7489159),
		T_TIPO_DATA(203915,34998,7489159),
		T_TIPO_DATA(203916,34988,7489159),
		T_TIPO_DATA(203917,34862,7489159),
		T_TIPO_DATA(203918,34840150,7489159),
		T_TIPO_DATA(203919,34840151,7489159),
		T_TIPO_DATA(203920,34840115,7489159),
		T_TIPO_DATA(203921,34840122,7489159),
		T_TIPO_DATA(203922,3484038,7489159),
		T_TIPO_DATA(203923,3484034,7489159),
		T_TIPO_DATA(203924,34840133,7489159),
		T_TIPO_DATA(203925,34840134,7489159),
		T_TIPO_DATA(203928,35010,7489159),
		T_TIPO_DATA(203929,35016,7489159),
		T_TIPO_DATA(203930,34924,7489159),
		T_TIPO_DATA(203931,34922,7489159),
		T_TIPO_DATA(204049,34840111,7489159),
		T_TIPO_DATA(204199,35002,7489159),
		T_TIPO_DATA(204214,34972,7489159),
		T_TIPO_DATA(204215,34964,7489159),
		T_TIPO_DATA(204216,34866,7489159),
		T_TIPO_DATA(204217,34898,7489159),
		T_TIPO_DATA(204218,34908,7489159),
		T_TIPO_DATA(204220,34910,7489159),
		T_TIPO_DATA(204221,34906,7489159),
		T_TIPO_DATA(204224,3484043,7489159),
		T_TIPO_DATA(204225,3484040,7489159),
		T_TIPO_DATA(204226,3484037,7489159),
		T_TIPO_DATA(204227,34840125,7489159),
		T_TIPO_DATA(204228,3484031,7489159),
		T_TIPO_DATA(204229,3484029,7489159),
		T_TIPO_DATA(204230,3484030,7489159),
		T_TIPO_DATA(204231,34840110,7489159),
		T_TIPO_DATA(204232,34840108,7489159),
		T_TIPO_DATA(204295,35038,7489159),
		T_TIPO_DATA(204296,35032,7489159),
		T_TIPO_DATA(204297,35034,7489159),
		T_TIPO_DATA(204298,35036,7489159),
		T_TIPO_DATA(204300,34880,7489159),
		T_TIPO_DATA(204301,34888,7489159),
		T_TIPO_DATA(204302,35058,7489159),
		T_TIPO_DATA(204303,35050,7489159),
		T_TIPO_DATA(204304,35046,7489159),
		T_TIPO_DATA(204305,35048,7489159),
		T_TIPO_DATA(204306,35066,7489159),
		T_TIPO_DATA(204307,34872,7489159),
		T_TIPO_DATA(204308,3484048,7489159),
		T_TIPO_DATA(204309,3484045,7489159),
		T_TIPO_DATA(204310,3484062,7489159),
		T_TIPO_DATA(204311,3484059,7489159),
		T_TIPO_DATA(204312,3484073,7489159),
		T_TIPO_DATA(204313,3484074,7489159),
		T_TIPO_DATA(204314,3484065,7489159),
		T_TIPO_DATA(204315,348401,7489159),
		T_TIPO_DATA(204316,348409,7489159),
		T_TIPO_DATA(204317,348405,7489159),
		T_TIPO_DATA(204319,348404,7489159),
		T_TIPO_DATA(204320,3484082,7489159),
		T_TIPO_DATA(204321,3484020,7489159),
		T_TIPO_DATA(204322,3484015,7489159),
		T_TIPO_DATA(204323,3484093,7489159),
		T_TIPO_DATA(204324,3484022,7489159),
		T_TIPO_DATA(204409,3484067,7489159),
		T_TIPO_DATA(204410,3484060,7489159),
		T_TIPO_DATA(204411,3484057,7489159),
		T_TIPO_DATA(204412,3484061,7489159),
		T_TIPO_DATA(204413,3484064,7489159),
		T_TIPO_DATA(204414,3484069,7489159),
		T_TIPO_DATA(204415,34840132,7489159),
		T_TIPO_DATA(204416,34840135,7489159),
		T_TIPO_DATA(204417,34840137,7489159),
		T_TIPO_DATA(204418,34840136,7489159),
		T_TIPO_DATA(204419,34840142,7489159),
		T_TIPO_DATA(204420,3484044,7489159),
		T_TIPO_DATA(204421,3484023,7489159),
		T_TIPO_DATA(204422,34840114,7489159),
		T_TIPO_DATA(204423,34840107,7489159),
		T_TIPO_DATA(204424,34840112,7489159),
		T_TIPO_DATA(204508,34890,7489159),
		T_TIPO_DATA(204509,35060,7489159),
		T_TIPO_DATA(204510,35052,7489159),
		T_TIPO_DATA(204511,35044,7489159),
		T_TIPO_DATA(204512,34948,7489159),
		T_TIPO_DATA(204513,34944,7489159),
		T_TIPO_DATA(204514,34946,7489159),
		T_TIPO_DATA(204515,34874,7489159),
		T_TIPO_DATA(204516,3484053,7489159),
		T_TIPO_DATA(204517,3484049,7489159),
		T_TIPO_DATA(204518,3484047,7489159),
		T_TIPO_DATA(204519,3484058,7489159),
		T_TIPO_DATA(204520,3484055,7489159),
		T_TIPO_DATA(204521,3484068,7489159),
		T_TIPO_DATA(204522,3484071,7489159),
		T_TIPO_DATA(204523,348403,7489159),
		T_TIPO_DATA(204524,348408,7489159),
		T_TIPO_DATA(204525,3484083,7489159),
		T_TIPO_DATA(204526,3484077,7489159),
		T_TIPO_DATA(204527,3484078,7489159),
		T_TIPO_DATA(204528,3484013,7489159),
		T_TIPO_DATA(204529,3484012,7489159),
		T_TIPO_DATA(204530,3484090,7489159),
		T_TIPO_DATA(204531,3484091,7489159),
		T_TIPO_DATA(204532,3484088,7489159),
		T_TIPO_DATA(204533,3484096,7489159),
		T_TIPO_DATA(204534,34840101,7489159),
		T_TIPO_DATA(204535,34840102,7489159),
		T_TIPO_DATA(204541,348407,7489159),
		T_TIPO_DATA(204542,3484010,7489159),
		T_TIPO_DATA(204543,3484084,7489159),
		T_TIPO_DATA(204544,3484017,7489159),
		T_TIPO_DATA(204545,3484094,7489159),
		T_TIPO_DATA(204546,3484087,7489159),
		T_TIPO_DATA(204547,3484097,7489159),
		T_TIPO_DATA(204548,3484092,7489159),
		T_TIPO_DATA(933862,3484027,7489159),
		T_TIPO_DATA(934014,3484035,7489159),
		T_TIPO_DATA(935845,3484036,7489159),
		T_TIPO_DATA(937921,34894,7489159)

    );
    
    V_TMP_TIPO_DATA T_TIPO_DATA;
 
 BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	--LOOP del ARRAY
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
      V_TMP_TIPO_DATA := V_TIPO_DATA(I);
      
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES DATOS WHERE DATOS.BIE_ID = (
		SELECT BIE.BIE_ID
		FROM '||V_ESQUEMA||'.BIE_BIEN BIE
		JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON BIE.BIE_ID = ACT.BIE_ID AND ACT.ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'
		JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID
		JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.AGR_NUM_AGRUP_REM = '||V_TMP_TIPO_DATA(3)||'
      )';
      
      EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
      
      IF V_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('Se procede a setear el número de finca registral '||V_TMP_TIPO_DATA(2)||' al activo '||V_TMP_TIPO_DATA(1)||' de la agrupación '||V_TMP_TIPO_DATA(3)||'.');
		
		V_SQL := 'UPDATE '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES DATOS SET DATOS.BIE_DREG_NUM_FINCA = '''||V_TMP_TIPO_DATA(2)||''',DATOS.USUARIOMODIFICAR = '''||V_USUARIO||''', DATOS.FECHAMODIFICAR = SYSDATE
					WHERE DATOS.BIE_ID = (
						SELECT BIE.BIE_ID
						FROM '||V_ESQUEMA||'.BIE_BIEN BIE
						JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON BIE.BIE_ID = ACT.BIE_ID AND ACT.ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'
						JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID
						JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.AGR_NUM_AGRUP_REM = '||V_TMP_TIPO_DATA(3)||'
					)';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros en la BIE_DATOS_REGISTRALES');
		V_CONTADOR := V_CONTADOR +1;
      ELSE
      
		DBMS_OUTPUT.PUT_LINE('No existe el activo '||V_TMP_TIPO_DATA(1)||' en la agrupación '||V_TMP_TIPO_DATA(3)||'.');
		
      END IF;

     END LOOP;
    DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado '||V_CONTADOR||' registros en la BIE_DATOS_REGISTRALES');
	

	
 COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
