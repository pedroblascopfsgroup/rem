--/*
--#########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20181217
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-2843
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; --'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; --'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= 'ACT_OFR';
    --V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-2843';
    ACT_NUM_OFERTA NUMBER(16);
    ACT_NUM_ACTIVO NUMBER(16);
    ACT_NUM_IMPORTE NUMBER(16);
	
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(		
		    	T_JBV(90134450,6856735,3883.73),
			T_JBV(90134450,6855717,3883.73),
			T_JBV(90134450,6855646,3883.73),
			T_JBV(90134450,6855647,3883.73),
			T_JBV(90134450,6856053,3883.73),
			T_JBV(90134450,6856736,3883.73),
			T_JBV(90134450,6855648,3883.73),
			T_JBV(90134450,6855953,3883.73),
			T_JBV(90134450,6856737,3883.73),
			T_JBV(90134450,6857911,3883.73),
			T_JBV(90134450,6856738,3883.73),
			T_JBV(90134450,6855718,3883.73),
			T_JBV(90134450,6855954,3883.73),
			T_JBV(90134450,6856739,3883.73),
			T_JBV(90134450,6855874,3883.73),
			T_JBV(90134450,6857912,3883.73),
			T_JBV(90134450,6855719,3883.73),
			T_JBV(90134450,6855875,3883.73),
			T_JBV(90134450,6856529,3883.73),
			T_JBV(90134450,6856616,3883.73),
			T_JBV(90134450,6857913,3883.73),
			T_JBV(90134450,6857263,3883.73),
			T_JBV(90134450,6855876,3883.73),
			T_JBV(90134450,6856530,3883.73),
			T_JBV(90134450,6856740,3883.73),
			T_JBV(90134450,6856741,3883.73),
			T_JBV(90134450,6857054,3883.73),
			T_JBV(90134450,6857914,3883.73),
			T_JBV(90134450,6855955,3883.73),
			T_JBV(90134450,6855720,3883.73),
			T_JBV(90134450,6855721,3883.73),
			T_JBV(90134450,6856742,3883.73),
			T_JBV(90134450,6857915,3883.73),
			T_JBV(90134450,6855956,3883.73),
			T_JBV(90134450,6857916,3883.73),
			T_JBV(90134450,6857264,3883.73),
			T_JBV(90134450,6854409,926.59),
			T_JBV(90134450,6854630,934.58),
			T_JBV(90134450,6854598,1083.15),
			T_JBV(90134450,6856998,1016.05),
			T_JBV(90134450,6854410,1022.44),
			T_JBV(90134450,6854737,960.14),
			T_JBV(90134450,6855040,1123.09),
			T_JBV(90134450,6855474,1062.38),
			T_JBV(90134450,6855475,845.11),
			T_JBV(90134450,6855041,832.33),
			T_JBV(90134450,6854599,861.09),
			T_JBV(90134450,6854738,837.12),
			T_JBV(90134450,6855545,808.37),
			T_JBV(90134450,6855042,809.97),
			T_JBV(90134450,6854631,889.85),
			T_JBV(90134450,6854632,712.51),
			T_JBV(90134450,6854633,664.59),
			T_JBV(90134450,6854702,662.15),
			T_JBV(90134450,6854634,624.65),
			T_JBV(90134450,6854411,1083.15),
			T_JBV(90134450,6854739,674.17),
			T_JBV(90134450,6854600,651.81),
			T_JBV(90134450,6854740,541.57),
			T_JBV(90134450,6854703,551.16),
			T_JBV(90134450,6854704,1084.75),
			T_JBV(90134450,6854635,487.81),
			T_JBV(90134450,6855546,445.28),
			T_JBV(90134450,6854636,805.99),
			T_JBV(90134450,6856986,37674.17),
			T_JBV(90134450,6854401,30390.95),
			T_JBV(90134450,685,19337.60),
			T_JBV(90134450,6855467,19337.60),
			T_JBV(90134450,6855468,24956.66),
			T_JBV(90134450,6855033,24744.23),
			T_JBV(90134450,6854402,19337.60),
			T_JBV(90134450,6854700,19337.60),
			T_JBV(90134450,6854622,19556.02),
			T_JBV(90134450,6855469,19556.02),
			T_JBV(90134450,6854623,19337.60),
			T_JBV(90134450,6855470,24756.20),
			T_JBV(90134450,6856991,24935.72),
			T_JBV(90134450,6854403,19337.60),
			T_JBV(90134450,6854404,19337.60),
			T_JBV(90134450,6854592,19337.60),
			T_JBV(90134450,6855471,19556.02),
			T_JBV(90134450,6854624,19556.02),
			T_JBV(90134450,6854405,18598.56),
			T_JBV(90134450,6854732,19337.60),
			T_JBV(90134450,6854746,32426.43),
			T_JBV(90134450,6857005,32426.43),
			T_JBV(90134450,6857336,32429.36),
			T_JBV(90134450,6854644,32767.93),
			T_JBV(90134450,6855055,28532.10),
			T_JBV(90134450,6854747,28532.10),
			T_JBV(90134450,6854606,28418.01),
			T_JBV(90134450,6854645,30673.93),
			T_JBV(90134450,6857337,30202.88),
			T_JBV(90134450,6857338,28016.88),
			T_JBV(90134450,6856531,3883.73),
			T_JBV(90134450,6855957,3883.73),
			T_JBV(90134450,6856798,3883.73),
			T_JBV(90134450,6855877,3883.73),
			T_JBV(90134450,6857917,3883.73),
			T_JBV(90134450,6856799,3883.73),
			T_JBV(90134450,6855878,3883.73),
			T_JBV(90134450,6858714,3883.73),
			T_JBV(90134450,6855958,3883.73),
			T_JBV(90134450,6856800,3883.73),
			T_JBV(90134450,6856743,3883.73),
			T_JBV(90134450,6856532,3883.73),
			T_JBV(90134450,6857055,3883.73),
			T_JBV(90134450,6856744,3883.73),
			T_JBV(90134450,6857265,3883.73),
			T_JBV(90134450,6855959,3883.73),
			T_JBV(90134450,6855960,3883.73),
			T_JBV(90134450,6857056,3883.73),
			T_JBV(90134450,6856533,3883.73),
			T_JBV(90134450,6857057,3883.73),
			T_JBV(90134450,6855879,3883.73),
			T_JBV(90134450,6857058,3883.73),
			T_JBV(90134450,6857266,3883.73),
			T_JBV(90134450,6857267,3883.73),
			T_JBV(90134450,6856745,3883.73),
			T_JBV(90134450,6856746,3883.73),
			T_JBV(90134450,6857059,3883.73),
			T_JBV(90134450,6855961,3883.73),
			T_JBV(90134450,6856747,3883.73),
			T_JBV(90134450,6858715,3883.73),
			T_JBV(90134450,6855962,3883.73),
			T_JBV(90134450,6857268,3883.73),
			T_JBV(90134450,6856534,3883.73),
			T_JBV(90134450,6856535,3883.73),
			T_JBV(90134450,6857060,3883.73),
			T_JBV(90134450,6857061,3883.73),
			T_JBV(90134450,6856748,3883.73),
			T_JBV(90134450,6857269,3883.73),
			T_JBV(90134450,6855880,3883.73),
			T_JBV(90134450,6857270,3883.73),
			T_JBV(90134450,6856536,3883.73),
			T_JBV(90134450,6855963,3883.73),
			T_JBV(90134450,6858716,3883.73),
			T_JBV(90134450,6858717,3883.73),
			T_JBV(90134450,6856749,3883.73),
			T_JBV(90134450,6856999,1051.20),
			T_JBV(90134450,6854741,613.47),
			T_JBV(90134450,6854637,597.49),
			T_JBV(90134450,6855547,573.53),
			T_JBV(90134450,6855043,549.56),
			T_JBV(90134450,6854705,686.96),
			T_JBV(90134450,6854706,615.06),
			T_JBV(90134450,6855044,595.89),
			T_JBV(90134450,6854638,594.29),
			T_JBV(90134450,6857000,672.58),
			T_JBV(90134450,6857001,688.55),
			T_JBV(90134450,6854742,693.35),
			T_JBV(90134450,6854601,754.05),
			T_JBV(90134450,6855548,723.70),
			T_JBV(90134450,6855549,718.90),
			T_JBV(90134450,6854639,714.11),
			T_JBV(90134450,6854707,707.72),
			T_JBV(90134450,6855550,704.53),
			T_JBV(90134450,6854640,699.74),
			T_JBV(90134450,6855045,702.93),
			T_JBV(90134450,6854602,699.74),
			T_JBV(90134450,6854412,581.51),
			T_JBV(90134450,6855551,581.51),
			T_JBV(90134450,6854743,573.53),
			T_JBV(90134450,6854708,573.53),
			T_JBV(90134450,6855046,650.21),
			T_JBV(90134450,6854641,650.21),
			T_JBV(90134450,6854709,650.21),
			T_JBV(90134450,6855552,672.58),
			T_JBV(90134450,6855047,596.24),
			T_JBV(90134450,6854603,762.04),
			T_JBV(90134450,6854413,920.20),
			T_JBV(90134450,6854642,586.31),
			T_JBV(90134450,6854744,557.55),
			T_JBV(90134450,6855048,557.55),
			T_JBV(90134450,6855049,1048.00),
			T_JBV(90134450,6854591,51510.74),
			T_JBV(90134450,6856990,242771.48),
			T_JBV(90134450,6855034,22329.64),
			T_JBV(90134450,6854701,27924.77),
			T_JBV(90134450,6854625,28771.52),
			T_JBV(90134450,6856992,22443.34),
			T_JBV(90134450,6854626,22536.10),
			T_JBV(90134450,6855472,22625.86),
			T_JBV(90134450,6854406,22990.89),
			T_JBV(90134450,6854733,22416.41),
			T_JBV(90134450,6855035,21943.67),
			T_JBV(90134450,6854593,15717.22),
			T_JBV(90134450,6854734,22329.64),
			T_JBV(90134450,6854594,28373.58),
			T_JBV(90134450,6856993,28834.35),
			T_JBV(90134450,6854627,23083.64),
			T_JBV(90134450,6856994,22990.89),
			T_JBV(90134450,6854407,22901.12),
			T_JBV(90134450,6855473,23083.64),
			T_JBV(90134450,6855036,22383.50),
			T_JBV(90134450,6854408,21964.62),
			T_JBV(90134450,6856995,22329.64),
			T_JBV(90134450,6854543,33485.56),
			T_JBV(90134450,6855056,31937.32),
			T_JBV(90134450,6855057,33901.42),
			T_JBV(90134450,6855556,36032.22),
			T_JBV(90134450,6855557,34968.65),
			T_JBV(90134450,6854607,33242.67),
			T_JBV(90134450,6854712,33485.56),
			T_JBV(90134450,6854748,34703.69),
			T_JBV(90134450,6857339,34501.28),
			T_JBV(90134450,6854608,36230.94),
			T_JBV(90134450,6854646,35034.90),
			T_JBV(90134450,6854609,33010.82),
			T_JBV(90134650,6858718,3883.73),
			T_JBV(90134650,6855881,3883.73),
			T_JBV(90134650,6855882,3883.73),
			T_JBV(90134650,6857062,3883.73),
			T_JBV(90134650,6856537,3883.73),
			T_JBV(90134650,6857271,3883.73),
			T_JBV(90134650,6857272,3883.73),
			T_JBV(90134650,6855964,3883.73),
			T_JBV(90134650,6855965,3883.73),
			T_JBV(90134650,6855966,3883.73),
			T_JBV(90134650,6854297,3883.73),
			T_JBV(90134650,6854326,3883.73),
			T_JBV(90134650,6854382,3883.73),
			T_JBV(90134650,6854400,3883.73),
			T_JBV(90134650,6854431,3883.73),
			T_JBV(90134650,6854698,3883.73),
			T_JBV(90134650,6856985,3883.73),
			T_JBV(90134650,6854383,3883.73),
			T_JBV(90134650,6855050,795.59),
			T_JBV(90134650,6854710,782.81),
			T_JBV(90134650,6855051,782.81),
			T_JBV(90134650,6857002,861.09),
			T_JBV(90134650,6854541,821.15),
			T_JBV(90134650,6854745,1508.10),
			T_JBV(90134650,6855052,752.45),
			T_JBV(90134650,6855553,782.81),
			T_JBV(90134650,6855053,832.33),
			T_JBV(90134650,6857003,931.38),
			T_JBV(90134650,6854542,1028.83),
			T_JBV(90134650,6854643,1127.88),
			T_JBV(90134650,6854604,718.90),
			T_JBV(90134650,6855554,765.23),
			T_JBV(90134650,6855555,1303.61),
			T_JBV(90134650,6854711,966.53),
			T_JBV(90134650,6854605,940.97),
			T_JBV(90134650,6855054,923.40),
			T_JBV(90134650,6857004,3067.33),
			T_JBV(90134389,6855037,23089.63),
			T_JBV(90134389,6854595,30099.99),
			T_JBV(90134389,6854596,30244.18),
			T_JBV(90134389,6854628,22913.09),
			T_JBV(90134389,6855038,22913.09),
			T_JBV(90134389,6855039,22554.05),
			T_JBV(90134389,6854735,22981.91),
			T_JBV(90134389,6856996,23194.35),
			T_JBV(90134389,6854597,30515.88),
			T_JBV(90134650,6854713,33349.39),
			T_JBV(90134389,6854736,23224.27),
			T_JBV(90134389,6856997,22990.89),
			T_JBV(90134389,6854629,23041.75),
			T_JBV(90134650,6854714,34803.05),
			T_JBV(90134650,6854544,34519.68),
			T_JBV(90134650,6854545,34206.87),
			T_JBV(90134650,6857340,33963.98),
			T_JBV(90134650,6854610,30876.34),
			T_JBV(90134650,6854749,34479.20),
			T_JBV(90134650,6854715,34619.04),
			T_JBV(90134450,6856987,47624.15),
			T_JBV(90134450,6856988,201595.48),
			T_JBV(90134450,6854327,35091.61),
			T_JBV(90134450,6854699,32491.19),
			T_JBV(90134450,6854432,43377.73),
			T_JBV(90134450,6856989,28502.52),
			T_JBV(90134450,6854621,32539.68),
			T_JBV(90134450,6854328,38470.37),
			T_JBV(90134450,6854329,38064.61),
			T_JBV(90134389,6854298,44541.41),
			T_JBV(90134389,6854299,22081.86)

	); 
V_TMP_JBV T_JBV;
BEGIN


 FOR I IN V_JBV.FIRST .. V_JBV.LAST
 LOOP
 
 V_TMP_JBV := V_JBV(I);

    ACT_NUM_OFERTA	      := V_TMP_JBV(1);
    ACT_NUM_ACTIVO	      := V_TMP_JBV(2);
    ACT_NUM_IMPORTE           := V_TMP_JBV(3);

			
		V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
				   ACT_OFR_IMPORTE = '||ACT_NUM_IMPORTE||'
				   WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO||')
				   AND OFR_ID = (SELECT OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA = '||ACT_NUM_OFERTA||')
					';
           
				EXECUTE IMMEDIATE V_SQL;
				
				IF SQL%ROWCOUNT > 0 THEN
					V_COUNT_UPDATE := V_COUNT_UPDATE + 1;
				END IF;
 END LOOP;			    
    
	COMMIT;

    DBMS_OUTPUT.PUT_LINE('[INFO] Se han updateado en total '||V_COUNT_UPDATE||' fechas');

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
