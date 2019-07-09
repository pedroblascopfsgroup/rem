--/*
--##########################################
--## AUTOR=Guillermo Llidó
--## FECHA_CREACION=20190626
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3352
--## PRODUCTO=NO
--##
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-3352'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
        
BEGIN	
	
		DBMS_OUTPUT.PUT_LINE('[INICIO] BORRAR GASTOS GARSA');
	
		V_MSQL := 'UPDATE  '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR
						SET
							 BORRADO = 1
							,USUARIOBORRAR = '''||V_USR||'''
							,FECHABORRAR = SYSDATE
					WHERE
							GPV_NUM_GASTO_HAYA IN (
								select Gpv.Gpv_Num_Gasto_Haya from '||V_ESQUEMA||'.gpv_gastos_proveedor gpv
								inner join '||V_ESQUEMA||'.dd_ega_estados_gasto ega on gpv.dd_ega_id = ega.dd_ega_id
								where ega.dd_ega_codigo in (''12'',''01'') and gpv.gpv_num_gasto_haya in (
									10287793,
									10287792,
									10287791,
									10287790,
									10287787,
									10287488,
									10288320,
									10288319,
									10288318,
									10287394,
									10287393,
									10287685,
									10287684,
									10287683,
									10287682,
									10287680,
									10287333,
									10287332,
									10287331,
									10287330,
									10287328,
									10287327,
									10287326,
									10287325,
									10287324,
									10287323,
									10288117,
									10288114,
									10288113,
									10288112,
									10288111,
									10288110,
									10288124,
									10288123,
									10288122,
									10288121,
									10288120,
									10288119,
									10287734,
									10287733,
									10287732,
									10287731,
									10287730,
									10287727,
									10287726,
									10287725,
									10287724,
									10287723,
									10287722,
									10288103,
									10288102,
									10288101,
									10288100,
									10288099,
									10288225,
									10288224,
									10287455,
									10287454,
									10287452,
									10287529,
									10287527,
									10287450,
									10287449,
									10287447,
									10288109,
									10288108,
									10288106,
									10288105,
									10288041,
									10288037,
									10288036,
									10288161,
									10288160,
									10288159,
									10288158,
									10288157,
									10288156,
									10288155,
									10288154,
									10288153,
									10288152,
									10287811,
									10287809,
									10287807,
									10287804,
									10287802,
									10287799,
									10287797,
									10287795,
									10288304,
									10288302,
									10288301,
									10288300,
									10288299,
									10288297,
									10288296,
									10288295,
									10288294,
									10288293,
									10288290,
									10288288,
									10287699,
									10287696,
									10287693,
									10287692,
									10287690,
									10288195,
									10288194,
									10288193,
									10288192,
									10287678,
									10287677,
									10287446,
									10287445,
									10287440,
									10287439,
									10287990,
									10287989,
									10287988,
									10287986,
									10287985,
									10287984,
									10287982,
									10287980,
									10287979,
									10287978,
									10287401,
									10287400,
									10287398,
									10287397,
									10287396,
									10287748,
									10287747,
									10287746,
									10287745,
									10287742,
									10287741,
									10287740,
									10287736,
									10288035,
									10288034,
									10288033,
									10288030,
									10288028,
									10288027,
									10288026,
									10288024,
									10288022,
									10288021,
									10288020,
									10288019,
									10288018,
									10287508,
									10287507,
									10287506,
									10287505,
									10287504,
									10287503,
									10287502,
									10287501,
									10287500,
									10287499,
									10287495,
									10287494,
									10287492,
									10287491,
									10287489,
									10288097,
									10288095,
									10288094,
									10288092,
									10288090,
									10288088,
									10288087,
									10288086,
									10288083,
									10288076,
									10288075,
									10288072,
									10288070,
									10288068,
									10288067,
									10288066,
									10288065,
									10288062,
									10288061,
									10288059,
									10288058,
									10288057,
									10288056,
									10287655,
									10287654,
									10287653,
									10287652,
									10287650,
									10287647,
									10287646,
									10287645,
									10287644,
									10287643,
									10287641,
									10287640,
									10287639,
									10287638,
									10287637,
									10287635,
									10287634,
									10287633,
									10287632,
									10287631,
									10287627,
									10287626,
									10287625,
									10287624,
									10287623,
									10287622,
									10287620,
									10287619,
									10287618,
									10287615,
									10287614,
									10287611,
									10287610,
									10287609,
									10287608,
									10287606,
									10287966,
									10287965,
									10287960,
									10287959,
									10287958,
									10287957,
									10287956,
									10287953,
									10287952,
									10287951,
									10287946,
									10287945,
									10287944,
									10287942,
									10287941,
									10287939,
									10287937,
									10287936,
									10287935,
									10287934,
									10287933,
									10287931,
									10287930,
									10287928,
									10287927,
									10287925,
									10287923,
									10287920,
									10287919,
									10287918,
									10287915,
									10287914,
									10287911,
									10287910,
									10287909,
									10287908,
									10287903,
									10287902,
									10287899,
									10287897,
									10287870,
									10287868,
									10287867,
									10287866,
									10287864,
									10287862,
									10287861,
									10287860,
									10287859,
									10287856,
									10287855,
									10287851,
									10287849,
									10287848,
									10287847,
									10287846,
									10287845,
									10288204,
									10288203,
									10288202,
									10288199,
									10288198,
									10288197,
									10288196,
									10287589,
									10287583,
									10287582,
									10287581,
									10287579,
									10287578,
									10287576,
									10287574,
									10287573,
									10287569,
									10287565,
									10287563,
									10287562,
									10287561,
									10287392,
									10287388,
									10287387,
									10287386,
									10287383,
									10287381,
									10288285,
									10288284,
									10288281,
									10288279,
									10288277,
									10288276,
									10288274,
									10288273,
									10288272,
									10288271,
									10288270,
									10288269,
									10288268,
									10288267,
									10288265,
									10288264,
									10288263,
									10288262,
									10288260,
									10288258,
									10288255,
									10288254,
									10288253,
									10288251,
									10288250,
									10288249,
									10288248,
									10288247,
									10288246,
									10288245,
									10288243,
									10288242,
									10288239,
									10288238,
									10288231,
									10288228,
									10287890,
									10287889,
									10287886,
									10287883,
									10287882,
									10287879,
									10287877,
									10287875,
									10287874,
									10287873,
									10287872,
									10287871,
									10287721,
									10287720,
									10287717,
									10287716,
									10287715,
									10287713,
									10287712,
									10287708,
									10287706,
									10287705,
									10287701,
									10287700,
									10288013,
									10288012,
									10288011,
									10288007,
									10288005,
									10288004,
									10288003,
									10288002,
									10288001,
									10288000,
									10287998,
									10287996,
									10287995,
									10287994,
									10287993,
									10287992,
									10287991,
									10288191,
									10288189,
									10288188,
									10288185,
									10288183,
									10287305,
									10287304,
									10287303,
									10287302,
									10287301,
									10287602,
									10287601,
									10287600,
									10287599,
									10287598,
									10287597,
									10287596,
									10287430,
									10287427,
									10287426,
									10287424,
									10287423,
									10287786,
									10287785,
									10287781,
									10287780,
									10288143,
									10288142,
									10288141,
									10288140,
									10287826,
									10287825,
									10287824,
									10287822,
									10287820,
									10288055,
									10288054,
									10288053,
									10288052,
									10288051,
									10288050,
									10288049,
									10288048,
									10288046,
									10288044,
									10288043,
									10288042,
									10287688,
									10287687,
									10287686,
									10287364,
									10287361,
									10287358,
									10287357,
									10288223,
									10288222,
									10287347,
									10287485,
									10287483,
									10288126,
									10288125,
									10287895,
									10288180,
									10288179,
									10288176,
									10288175,
									10288174,
									10288172,
									10288171,
									10288169,
									10288168,
									10288166,
									10288165,
									10288164,
									10288163,
									10288162,
									10287778,
									10287777,
									10287776,
									10287775,
									10287774,
									10287773,
									10287771,
									10287769,
									10287674,
									10288218,
									10287531,
									10287457,
									10287818,
									10287816,
									10287814,
									10287813,
									10287463,
									10287462,
									10287461,
									10287459,
									10287560,
									10287559,
									10287557,
									10287556,
									10287555,
									10287554,
									10287553,
									10287552,
									10287551,
									10287550,
									10287549,
									10287548,
									10287465,
									10287464,
									10287436,
									10287434,
									10287433,
									10287789,
									10287788,
									10288339,
									10288338,
									10288337,
									10288336,
									10288335,
									10288334,
									10288333,
									10287681,
									10287329,
									10288116,
									10288115,
									10288118,
									10287729,
									10287728,
									10288104,
									10288227,
									10288226,
									10287453,
									10287528,
									10287451,
									10287448,
									10288040,
									10288039,
									10287810,
									10287808,
									10287806,
									10287805,
									10287803,
									10287801,
									10287800,
									10287798,
									10287796,
									10288303,
									10288298,
									10288292,
									10288291,
									10288289,
									10288287,
									10287698,
									10287697,
									10287695,
									10287694,
									10287691,
									10287679,
									10287444,
									10287443,
									10287442,
									10287441,
									10287438,
									10287437,
									10287987,
									10287983,
									10287981,
									10287977,
									10287976,
									10287975,
									10287399,
									10287395,
									10287744,
									10287743,
									10287739,
									10287738,
									10287737,
									10287735,
									10288032,
									10288031,
									10288029,
									10288025,
									10288023,
									10287498,
									10287497,
									10287496,
									10287493,
									10287490,
									10288098,
									10288096,
									10288093,
									10288091,
									10288089,
									10288085,
									10288084,
									10288082,
									10288081,
									10288080,
									10288079,
									10288078,
									10288077,
									10288074,
									10288073,
									10288071,
									10288069,
									10288064,
									10288063,
									10288060,
									10287657,
									10287656,
									10287651,
									10287649,
									10287648,
									10287642,
									10287636,
									10287630,
									10287629,
									10287628,
									10287621,
									10287617,
									10287616,
									10287613,
									10287612,
									10287607,
									10287964,
									10287963,
									10287962,
									10287961,
									10287955,
									10287954,
									10287950,
									10287949,
									10287948,
									10287947,
									10287943,
									10287940,
									10287938,
									10287932,
									10287929,
									10287926,
									10287924,
									10287922,
									10287921,
									10287917,
									10287916,
									10287913,
									10287912,
									10287907,
									10287906,
									10287905,
									10287904,
									10287901,
									10287900,
									10287898,
									10287869,
									10287865,
									10287863,
									10287858,
									10287857,
									10287854,
									10287853,
									10287852,
									10287850,
									10288207,
									10288206,
									10288205,
									10288201,
									10288200,
									10287591,
									10287590,
									10287588,
									10287587,
									10287586,
									10287585,
									10287584,
									10287580,
									10287577,
									10287575,
									10287572,
									10287571,
									10287570,
									10287568,
									10287567,
									10287566,
									10287564,
									10287391,
									10287390,
									10287389,
									10287385,
									10287384,
									10287382,
									10288286,
									10288283,
									10288282,
									10288280,
									10288278,
									10288275,
									10288266,
									10288261,
									10288259,
									10288257,
									10288256,
									10288252,
									10288244,
									10288241,
									10288240,
									10288237,
									10288236,
									10288235,
									10288234,
									10288233,
									10288232,
									10288230,
									10288229,
									10287888,
									10287887,
									10287885,
									10287884,
									10287881,
									10287880,
									10287878,
									10287876,
									10287719,
									10287718,
									10287714,
									10287711,
									10287710,
									10287709,
									10287707,
									10287704,
									10287703,
									10287702,
									10288017,
									10288016,
									10288015,
									10288014,
									10288010,
									10288009,
									10288008,
									10288006,
									10287999,
									10287997,
									10288190,
									10288187,
									10288186,
									10288184,
									10287306,
									10287300,
									10287605,
									10287604,
									10287603,
									10287595,
									10288221,
									10287431,
									10287429,
									10287428,
									10287425,
									10287422,
									10287421,
									10287784,
									10287783,
									10287782,
									10288145,
									10288144,
									10287823,
									10287821,
									10288047,
									10288045,
									10287689,
									10287363,
									10287362,
									10287360,
									10287359,
									10287356,
									10287355,
									10287348,
									10287346,
									10287345,
									10287344,
									10287343,
									10287342,
									10287487,
									10287486,
									10287484,
									10288127,
									10287896,
									10288182,
									10288181,
									10288178,
									10288177,
									10288173,
									10288170,
									10288167,
									10287779,
									10287772,
									10287770,
									10287843,
									10287842,
									10287420,
									10287419,
									10287418,
									10287417,
									10287676,
									10287675,
									10287673,
									10287672,
									10287671,
									10287670,
									10287669,
									10287668,
									10287667,
									10287666,
									10287665,
									10287664,
									10287663,
									10287662,
									10287661,
									10287660,
									10287659,
									10287658,
									10288220,
									10288219,
									10288217,
									10288216,
									10288215,
									10288214,
									10288213,
									10288212,
									10288211,
									10288210,
									10288209,
									10288208,
									10287841,
									10287840,
									10287839,
									10287838,
									10287837,
									10287836,
									10287835,
									10287834,
									10287833,
									10287832,
									10287831,
									10287830,
									10287829,
									10287828,
									10287827,
									10287526,
									10287525,
									10287523,
									10287522,
									10287521,
									10287520,
									10287519,
									10287518,
									10287517,
									10287516,
									10287515,
									10287514,
									10287513,
									10287512,
									10287511,
									10287510,
									10287509,
									10287341,
									10287340,
									10287339,
									10287338,
									10287337,
									10287335,
									10287334,
									10287974,
									10287973,
									10287972,
									10287971,
									10287970,
									10287969,
									10287968,
									10287967,
									10288151,
									10288150,
									10288149,
									10288148,
									10288147,
									10288146,
									10287768,
									10287767,
									10287766,
									10287763,
									10287762,
									10287761,
									10287760,
									10287354,
									10287353,
									10287352,
									10287351,
									10287350,
									10287349,
									10287894,
									10287893,
									10287892,
									10287891,
									10287416,
									10287415,
									10287414,
									10287413,
									10287412,
									10287411,
									10287410,
									10287409,
									10287408,
									10287407,
									10287406,
									10287405,
									10287404,
									10287403,
									10287402,
									10287547,
									10287546,
									10287545,
									10287544,
									10287543,
									10287542,
									10287541,
									10287540,
									10287539,
									10287538,
									10287537,
									10287536,
									10287535,
									10287534,
									10287533,
									10287532,
									10288135,
									10288134,
									10288133,
									10288132,
									10288131,
									10288130,
									10288129,
									10288128,
									10287482,
									10287481,
									10287480,
									10287479,
									10287478,
									10287477,
									10287476,
									10287475,
									10287474,
									10287473,
									10287472,
									10287471,
									10287470,
									10288139,
									10288138,
									10288137,
									10288136,
									10287469,
									10287468,
									10287467,
									10287794,
									10287812,
									10287530,
									10287458,
									10287819,
									10287815,
									10287558,
									10287435,
									10287432
									)       
							)';
					
		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado : '||SQL%ROWCOUNT||' registros');
		
	COMMIT;
	
 
EXCEPTION
     WHEN OTHERS THEN
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
