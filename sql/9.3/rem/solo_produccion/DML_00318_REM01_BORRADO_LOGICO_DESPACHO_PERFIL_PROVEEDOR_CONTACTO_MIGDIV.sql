--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200528
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7289
--## PRODUCTO=NO
--##
--## Finalidad: Script para borrado logico de perfil y despacho de usuario MIGDIV
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

   	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR BORRADO A 1 EN USD_USUARIOS_DESPACHOS] ');
			
		V_SQL := 'SELECT COUNT (1) FROM '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS usd
			  WHERE USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''MIGDIV'')';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		-- Si existe 
		IF V_NUM_TABLAS > 0 THEN	  
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS SET BORRADO = 1, USUARIOBORRAR = ''REMVIP-7289'', FECHABORRAR = SYSDATE 
     				     WHERE USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''MIGDIV'')';
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO] BORRADO CORRECTO DE LA RELACION DESPACHO-USUARIO MIGDIV.');
			
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] EL URUAIO NO TIENE RELACION CON NINGUN DESPACHO');
			
	   	END IF;	


	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR BORRADO A 1 EN ZON_PEF_USU] ');
			
		V_SQL := 'SELECT COUNT (1) FROM '||V_ESQUEMA||'.ZON_PEF_USU 
			  WHERE USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''MIGDIV'')';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		-- Si existe 
		IF V_NUM_TABLAS > 0 THEN	  
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ZON_PEF_USU SET BORRADO = 1, USUARIOBORRAR = ''REMVIP-7289'', FECHABORRAR = SYSDATE 
             			     WHERE USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''MIGDIV'')';
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO] BORRADO CORRECTO DE LA RELACION PERFIL-USUARIO MIGDIV.');
			
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] EL URUAIO NO TIENE RELACION CON NINGUN PERFIL');
			
	   	END IF;	


	DBMS_OUTPUT.PUT_LINE('[INFO]: BORRADO LOGICO DE PROVEEDORES CONTACTO QUE TIENEN MAS DE UNO Y UNO DE ELLOS ES MIGDIV');

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO T1 USING (
   		 SELECT PVC.PVC_ID FROM '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO PVC
   		 INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON PVC.USU_ID = USU.USU_ID
   		 INNER JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = PVC.PVE_ID 
   		 WHERE PVE.PVE_COD_REM IN 
	(110115587,
	10006181,
	10006050,
	10006210,
	10007379,
	10004802,
	10006227,
	10005038,
	10361,
	10009508,
	10008501,
	6318,
	10005967,
	11377,
	3254,
	2393,
	11693,
	608,
	3118,
	3821,
	3595,
	10009606,
	10006907,
	12272,
	4433,
	2154,
	2658,
	1193,
	10634,
	10817,
	2391,
	10006616,
	10006233,
	10005462,
	5456,
	10008207,
	918,
	945,
	10004908,
	10006203,
	2933,
	10368,
	266,
	1959,
	10765,
	10006580,
	10825,
	10862,
	1326,
	11124,
	2039,
	10004583,
	10008146,
	10004409,
	10006307,
	24268,
	11308,
	11420,
	890,
	4067,
	10008777,
	10006033,
	10005684,
	10006406,
	10010260,
	10004984,
	3047,
	10004958,
	5681,
	10008273,
	10010460,
	5776,
	10006657,
	10006972,
	10005029,
	10007146,
	13071,
	13072,
	10007126,
	10007452,
	10006068,
	10008508,
	10005736,
	10010192,
	10008333,
	10004363,
	10009390,
	10006360,
	10007849,
	1345,
	10009386,
	6791,
	10009354,
	10006444,
	5132,
	10008183,
	10005975,
	10004641,
	10004789,
	9917,
	10006078,
	10007453,
	10006117,
	10007545,
	10006127,
	10005630,
	9991209,
	6085,
	10427,
	10698,
	10699,
	10779,
	10007052,
	10007382,
	6283,
	10009689,
	10010442,
	868,
	3247,
	1770,
	1774,
	11505,
	11508,
	10005177,
	11623,
	11733,
	127,
	12154,
	12360,
	10009427,
	10004468,
	10004264,
	9994197,
	9990151,
	10007290,
	5231,
	10011264,
	10006188,
	10006321,
	10004250,
	12534,
	139,
	1351,
	412,
	3812,
	10005912,
	1028,
	13104,
	10010261,
	10006089,
	10009002,
	10006541,
	10007459,
	10008551,
	10004964,
	10006255,
	6389,
	10007430,
	10007471,
	10006435,
	10004939,
	10006911,
	6792,
	9990172,
	10007136,
	13059,
	10008319,
	10008323,
	10010881,
	6273,
	10007505,
	6338,
	6405,
	10006934,
	6428,
	10009387,
	10004295,
	1239,
	1802,
	1558,
	10008546,
	9990166,
	10006910,
	10007872,
	10009529,
	10005189,
	7168,
	24187,
	10006935,
	10009670,
	10006820,
	10006717,
	10006478,
	10004883,
	10007128,
	10006586,
	2339,
	10008805,
	10005996,
	10008289,
	10007707,
	2886,
	1075,
	10479,
	2423,
	10677,
	5970,
	10006996,
	10006171,
	6183,
	2076,
	10520,
	954,
	10989,
	4517,
	10006836,
	10009776,
	10006043,
	6521,
	10005857,
	10653,
	2271,
	11076,
	3574,
	11488,
	10009655,
	10009747,
	11663,
	1386,
	10009286,
	3369,
	4298,
	2298,
	2144,
	11762,
	11894,
	2145,
	2540,
	10009593,
	4436,
	12624,
	12695,
	12985,
	10008859,
	10007120,
	10006051,
	10007068,
	10006638,
	10006141,
	12733,
	12745,
	809,
	10006936,
	10005250,
	10008308,
	10009558,
	10005706,
	6089,
	10007863,
	10006841,
	9990133,
	10006536,
	10007051,
	10005650,
	10009476,
	10009913,
	10007407,
	10006582,
	10005780,
	10004952,
	10007408,
	10006237,
	10006241,
	9991249,
	10007862,
	10009536,
	10009391,
	7005,
	10009143,
	3344,
	10261,
	427,
	3717,
	10748,
	2112,
	105,
	1093,
	11443,
	2437,
	1785,
	4293,
	11646,
	11708,
	10009565,
	3379,
	10008011,
	10007069,
	1793,
	2152,
	4759,
	10005212,
	110064911,
	10010183,
	12669,
	4730,
	10006336,
	10007864,
	10006284,
	10008863,
	3134,
	4696,
	3107,
	1488,
	10005949,
	10006664,
	1500,
	10008419,
	10008844,
	10005162,
	10004862,
	10006559,
	10008802,
	10004912,
	10008562,
	10006216,
	10006145,
	3587,
	10010805,
	10004965,
	6535,
	10004618,
	10007821,
	10007896,
	10011334,
	9990163,
	6949,
	10008398,
	10004777,
	10300,
	9990009,
	10402,
	10448,
	377,
	10659,
	10009284,
	10005047,
	2272,
	10939,
	10983,
	11161,
	11195,
	3366,
	11360,
	2614,
	11441,
	11517,
	11673,
	121,
	1111,
	10008996,
	2539,
	10009808,
	3655,
	4617,
	4392,
	3565,
	10010910,
	10010472,
	10008148,
	10967,
	9991331,
	116,
	10009871,
	11559,
	3256,
	1106,
	10008414,
	126,
	10006279,
	10028024,
	10028059,
	10033454,
	10009798,
	10007364,
	10032487,
	10026247,
	10013388,
	10030796,
	110076930,
	110161850)
	AND  USU.USU_USERNAME = ''MIGDIV''
	) T2
		ON (T1.PVC_ID = T2.PVC_ID)
		WHEN MATCHED THEN UPDATE SET
		T1.BORRADO = 1,
		T1.USUARIOBORRAR = ''REMVIP-7289_1'',
		T1.FECHABORRAR = SYSDATE 
		';
	EXECUTE IMMEDIATE V_MSQL;

	 DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros con usuarioborrar REMVIP-7289_1. Deberian ser 390.'); 


	DBMS_OUTPUT.PUT_LINE('[INFO]: BORRADO LOGICO DE PROVEEDORES CONTACTO QUE TIENEN COMO USUARIO MIGDIV, OBVIANDO LOS ANTERIORES');

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO T1 USING (
   		 SELECT PVC.PVC_ID FROM '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO PVC
   		 INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON PVC.USU_ID = USU.USU_ID
   		 INNER JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = PVC.PVE_ID 
   		 WHERE USU.USU_USERNAME = ''MIGDIV'' AND PVC.BORRADO = 0
	) T2
		ON (T1.PVC_ID = T2.PVC_ID)
		WHEN MATCHED THEN UPDATE SET
		T1.BORRADO = 1,
		T1.USUARIOBORRAR = ''REMVIP-7289_2'',
		T1.FECHABORRAR = SYSDATE 
		';
	EXECUTE IMMEDIATE V_MSQL;

	 DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros con usuarioborrar REMVIP-7289_2. Deberian ser 15696.'); 

	
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: ACTUALIZADO CORRECTAMENTE ');
   

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
