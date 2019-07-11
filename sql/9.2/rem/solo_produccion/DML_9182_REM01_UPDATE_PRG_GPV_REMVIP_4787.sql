--/*
--#########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20190712
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4787
--## PRODUCTO=NO
--## 
--## Finalidad: ACTUALIZAR PROVISIONES Y GASTOS
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
V_SQL VARCHAR2(32000 CHAR);
TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master

BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_SQL := 'UPDATE '||V_ESQUEMA||'.PRG_PROVISION_GASTOS SET BORRADO = 1, 
		USUARIOBORRAR = ''REMVIP-4787'',
		FECHABORRAR = SYSDATE 
		WHERE PRG_NUM_PROVISION IN (
		21300017863,
		20700017864,
		20700017865,
		20700017866,
		20700017867,
		20600017868,
		20600017869,
		21700017811,
		21700017812,
		21700017813,
		21300017814,
		21700017815,
		21700017816,
		21700017817,
		21700017818,
		21700017819,
		21700017820,
		21700017821,
		21700017822,
		21700017823,
		20700017824,
		20700017825,
		20700017826,
		20700017827,
		21700017719,
		20600017720,
		21700017721,
		21700017722,
		20600017723,
		21700017724,
		21700017725,
		21700017726,
		21700017727,
		21700017728,
		21700017729,
		21700017730,
		20600017731,
		21700017732,
		21700017733,
		21700017734,
		21700017735,
		20600017736,
		21700017737,
		20600017738,
		21700017739,
		21300017740,
		20700017741,
		20700017742,
		20600017743,
		20600017744,
		20600017745,
		21300017746,
		20600017747,
		20600017828,
		20600017829,
		20700017830,
		20700017831,
		20600017832,
		21700017833,
		21300017834,
		21300017835,
		21700017836,
		21700017837,
		21700017838,
		21700017839,
		21700017840,
		21700017841,
		20600017842,
		21700017843,
		21700017844,
		20600017845,
		20600017846,
		20600017847,
		20600017848,
		20600017849,
		20600017850,
		21700017851,
		21700017852,
		21700017853,
		21700017854,
		21700017855,
		21700017856,
		21700017857,
		21700017858,
		21700017859,
		21700017860,
		21700017861,
		21700017862,
		21700017748,
		21700017749,
		21700017750,
		20700017751,
		20700017752,
		20600017753,
		20600017754,
		20600017755,
		20700017756,
		21700017757,
		21700017758,
		21700017759,
		20600017760,
		21700017761,
		21700017762,
		21700017763,
		21700017764,
		21700017765,
		21700017766,
		21700017767,
		21700017768,
		21700017769,
		20600017770,
		20600017771,
		20600017772,
		20600017773,
		20600017774,
		21700017775,
		21700017776,
		21700017777,
		20600017778,
		21700017779,
		20600017780,
		20700017781,
		20700017782,
		20600017783,
		20600017784,
		20600017785,
		21700017786,
		21700017787,
		21700017788,
		21700017789,
		21300017790,
		21700017791,
		21700017792,
		21700017793,
		20600017794,
		21700017795,
		21700017796,
		21700017797,
		21700017798,
		21700017799,
		21700017800,
		21700017801,
		20600017802,
		20600017803,
		20600017804,
		20700017805,
		21700017806,
		21700017807,
		20600017808,
		21700017809,
		21700017810,
		21700017718
		)'
			;

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' PROVISIONES ACTUALIZADAS.');  

	V_SQL := 'UPDATE '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR SET PRG_ID = NULL, 
		USUARIOMODIFICAR = ''REMVIP-4787'',
		FECHAMODIFICAR = SYSDATE 
		WHERE GPV_NUM_GASTO_HAYA IN (
10563291,
10563295,
10563301,
10563303,
10563304,
10563305,
10563306,
10563308,
10563309,
10563311,
10563314,
10563315,
10563319,
10563320,
10563312,
10563323,
10563321,
10563327,
10563330,
10563331,
10564027,
10563527,
10564127,
10578310,
10563727,
10578327,
10578331,
10578335,
10563827,
10563927,
10563293,
10563329,
10576064,
10606381,
10606378,
10606380,
10606382,
10606383,
10606385,
10606393,
10606400,
10606407,
10606409,
10609125,
10610740,
10610741,
10610748,
10611878,
10611921,
10611932,
10611937,
10611938,
10611943,
10611944,
10611948,
10611949,
10611953,
10611956,
10611957,
10611959,
10611965,
10611922,
10611939,
10611693,
10606379,
10614397,
10614460,
10619366,
10619368,
10614542,
10614585,
10614490,
10615768,
10615773,
10615790,
10626289,
10626298,
10626300,
10626301,
10609187,
10608842,
10608893,
10609149,
10601021,
10602494,
10587572,
10608824,
10608953,
10609111,
10609127,
10587587,
10587588,
10587589,
10587604,
10587607,
10601145,
10602616,
10605060,
10602103,
10602104,
10602105,
10602106,
10602108,
10602109,
10602110,
10602111,
10602112,
10602113,
10602114,
10608815,
10608816,
10608817,
10608818,
10608819,
10608820,
10608821,
10608822,
10608823,
10608825,
10608826,
10608827,
10608831,
10608834,
10608840,
10608845,
10608848,
10608849,
10608888,
10608890,
10608891,
10608892,
10608894,
10608895,
10608896,
10602220,
10602221,
10602222,
10602223,
10602224,
10602225,
10602226,
10602236,
10602246,
10602247,
10602434,
10602227,
10602385,
10608913,
10608922,
10608924,
10608931,
10608944,
10602249,
10602250,
10602251,
10602252,
10602253,
10602254,
10602420,
10602386,
10602115,
10602421,
10609112,
10602352,
10602374,
10609113,
10609114,
10609115,
10609117,
10609118,
10609119,
10609120,
10609121,
10609122,
10609123,
10609126,
10609128,
10609129,
10609130,
10609131,
10609133,
10609145,
10609146,
10609147,
10609148,
10609150,
10602377,
10602378,
10602379,
10602380,
10602381,
10602382,
10602383,
10602384,
10602387,
10609185,
10609186,
10609188,
10609189,
10609190,
10609191,
10609192,
10609193,
10602422,
10602423,
10602424,
10602425,
10602426,
10602427,
10602428,
10602429,
10602430,
10602431,
10602432,
10602433,
10602435,
10602436,
10602437,
10602438,
10602439,
10602440,
10602441,
10602442,
10602444,
10602445,
10602446,
10602447,
10602448,
10631408,
10630617,
10662664,
10664182,
10662529,
10662812,
10663881,
10664668,
10639160,
10639162,
10639165,
10639220,
10639235,
10639237,
10639239,
10663873,
10639250,
10639251,
10608897,
10649587,
10649592,
10649593,
10649595,
10655564,
10655569,
10649559,
10649561,
10649563,
10649564,
10649565,
10649566,
10649582,
10649585,
10685921,
10685922,
10685923,
10685924,
10685925,
10685927,
10685928,
10685929,
10685930,
10685931,
10685882,
10685892,
10686497,
10686433,
10686435,
10686437,
10686438,
10686440,
10686495,
10686496,
10686500,
10674154,
10674285,
10674286,
10674028,
10674031,
10673346,
10674094,
10681777,
10681778,
10681779,
10688560,
10664667,
10688555,
10688556,
10688557,
10688558,
10688559,
10688562)'
			;

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' GASTOS ACTUALIZADAS.');

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
		DBMS_OUTPUT.PUT_LINE(V_SQL);
        ROLLBACK;
        RAISE;
END;

/

EXIT

