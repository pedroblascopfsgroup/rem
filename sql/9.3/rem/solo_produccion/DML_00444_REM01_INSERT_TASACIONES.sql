--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200902
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8010
--## PRODUCTO=NO
--## 
--## Finalidad: Script que añade en ACT_TAS_TASACION los datos añadidos en T_ARRAY_DATA
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
    	V_TABLA_1 VARCHAR2(25 CHAR):= 'BIE_VALORACIONES';
    	V_TABLA_2 VARCHAR2(25 CHAR):= 'ACT_TAS_TASACION';
    	V_COUNT NUMBER(16); -- Vble. para contar.
    	V_KOUNT NUMBER(16); -- Vble. para kontar.
    	V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

	ACT_NUM_ACTIVO NUMBER(16);
	ACT_ID NUMBER(16);
	NUM_SECUENCIA_VAL NUMBER(16);
	NUM_SECUENCIA_TAS NUMBER(16);
	BIE_ID NUMBER(16);

    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8010';    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    			-- NUM_ACT	TIPO_TASACION 	FECHA_TAS	IMPORTE_TAS	TASADORA,  FECHA_CADUCIDAD
T_TIPO_DATA('6044013','3','31/07/2020','54829,73','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044016','3','31/07/2020','119908,04','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044026','3','31/07/2020','255875,56','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044032','3','31/08/2020','125404,54','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044033','3','31/08/2020','8596,39','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044034','3','31/08/2020','169212,64','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044036','3','31/08/2020','88848,69','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044045','3','31/08/2020','71562,85','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044055','3','31/07/2020','45542,54','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044071','3','31/07/2020','154130,38','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044082','3','31/07/2020','113875,81','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044083','3','31/08/2020','140481,76','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044088','3','31/07/2020','263287,68','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044089','3','31/07/2020','121646,84','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044092','3','31/07/2020','56084,66','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044098','3','31/08/2020','19883,19','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044101','3','31/08/2020','108900,08','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044102','3','31/08/2020','65539,24','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044112','3','31/08/2020','75207,56','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044114','3','31/07/2020','210267,02','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044121','3','31/08/2020','8650,99','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044166','3','31/08/2020','113136,12','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044167','3','31/08/2020','76628,25','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044170','3','31/07/2020','91642,95','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044172','3','31/07/2020','3388,22','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044205','3','31/08/2020','8516,88','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044208','3','31/08/2020','182467,06','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044220','3','31/08/2020','166590,66','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044221','3','31/08/2020','111681,5','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044226','3','31/08/2020','68680,12','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044230','3','31/07/2020','118629,75','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044233','3','31/07/2020','34644,36','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044234','3','31/08/2020','149349,51','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044259','3','31/07/2020','84334,01','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044261','3','31/07/2020','72551,59','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044265','3','31/08/2020','147430,51','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044266','3','31/08/2020','132507,51','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044271','3','31/08/2020','113633,2','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044277','3','31/08/2020','63956,22','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044278','3','31/08/2020','125587,38','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044293','3','31/08/2020','74101,56','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044298','3','31/08/2020','273116,69','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044299','3','31/08/2020','121416,09','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044306','3','31/08/2020','260356,25','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044308','3','31/08/2020','175514,49','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044321','3','31/07/2020','104202,34','Arco valoraciones S.A', ''),
T_TIPO_DATA('6044325','3','31/07/2020','48251,09','Arco valoraciones S.A', ''),
T_TIPO_DATA('6084929','3','31/07/2020','53089,71','Arco valoraciones S.A', ''),
T_TIPO_DATA('6084930','3','31/07/2020','43470,47','Arco valoraciones S.A', ''),
T_TIPO_DATA('6084935','3','31/07/2020','88798,73','Arco valoraciones S.A', ''),
T_TIPO_DATA('6084941','3','31/08/2020','294094,86','Arco valoraciones S.A', ''),
T_TIPO_DATA('6084942','3','31/08/2020','291443,1','Arco valoraciones S.A', ''),
T_TIPO_DATA('6084947','3','31/07/2020','237137','Arco valoraciones S.A', ''),
T_TIPO_DATA('6084948','3','31/08/2020','124631,6','Arco valoraciones S.A', ''),
T_TIPO_DATA('6084959','3','31/08/2020','124590,55','Arco valoraciones S.A', ''),
T_TIPO_DATA('6084964','3','31/08/2020','132387,85','Arco valoraciones S.A', ''),
T_TIPO_DATA('6084965','3','31/08/2020','1183,49','Arco valoraciones S.A', ''),
T_TIPO_DATA('6084966','3','31/08/2020','9711,36','Arco valoraciones S.A', ''),
T_TIPO_DATA('6084972','3','31/08/2020','110205,35','Arco valoraciones S.A', ''),
T_TIPO_DATA('6084991','3','31/07/2020','93023,18','Arco valoraciones S.A', ''),
T_TIPO_DATA('6084999','3','31/08/2020','163710,37','Arco valoraciones S.A', ''),
T_TIPO_DATA('6085003','3','31/08/2020','289073,63','Arco valoraciones S.A', ''),
T_TIPO_DATA('6085006','3','31/08/2020','44704,04','Arco valoraciones S.A', ''),
T_TIPO_DATA('6127802','3','31/08/2020','110872,61','Arco valoraciones S.A', ''),
T_TIPO_DATA('6128432','3','31/08/2020','85734,41','Arco valoraciones S.A', ''),
T_TIPO_DATA('6525061','3','31/07/2020','56244,49','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762166','3','31/07/2020','107529,02','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762167','3','31/08/2020','459513,5','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762169','3','31/08/2020','5449,74','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762175','3','31/08/2020','5520','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762178','3','31/08/2020','26646,93','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762179','3','31/08/2020','5684,96','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762180','3','31/08/2020','33347,07','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762182','3','31/08/2020','5620,58','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762183','3','31/08/2020','34770,76','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762184','3','31/08/2020','5684,96','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762185','3','31/08/2020','30799,36','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762186','3','31/08/2020','25952,64','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762187','3','31/08/2020','5684,96','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762188','3','31/07/2020','444221,61','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762189','3','31/08/2020','30565,79','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762190','3','31/07/2020','28009,54','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762192','3','31/08/2020','30565,79','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762193','3','31/07/2020','155399,35','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762196','3','31/08/2020','72787,18','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762199','3','31/08/2020','58660,02','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762200','3','31/07/2020','94389,1','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762204','3','31/08/2020','72053,22','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762209','3','31/07/2020','84681,01','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762210','3','31/07/2020','51656,64','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762211','3','31/07/2020','2555,28','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762212','3','31/07/2020','81203,63','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762214','3','31/07/2020','6247,69','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762216','3','31/08/2020','40045,01','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762217','3','31/08/2020','5517,99','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762219','3','31/08/2020','28924,28','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762220','3','31/08/2020','131770,4','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762222','3','31/08/2020','5562,25','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762229','3','31/07/2020','71038,9','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762232','3','31/08/2020','102673,56','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762234','3','31/08/2020','110508,71','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762247','3','31/07/2020','120660,34','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762249','3','31/08/2020','67975,83','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762267','3','31/07/2020','113476,98','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762268','3','31/08/2020','20016,34','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762269','3','31/08/2020','4970,82','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762270','3','31/08/2020','29144,88','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762271','3','31/08/2020','108589,22','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762272','3','31/08/2020','235518,1','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762274','3','31/07/2020','136631,99','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762277','3','31/07/2020','110380,08','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762281','3','31/08/2020','160462,44','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762295','3','31/08/2020','139106,86','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762303','3','31/08/2020','5517,99','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762308','3','31/08/2020','34951,79','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762309','3','31/08/2020','5684,96','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762310','3','31/07/2020','189728,72','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762311','3','31/08/2020','5385,22','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762312','3','31/08/2020','29897,19','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762313','3','31/07/2020','182480,37','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762314','3','31/07/2020','9989,58','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762315','3','31/08/2020','5385,22','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762316','3','31/08/2020','40343,47','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762319','3','31/07/2020','16275,59','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762320','3','31/08/2020','128277,54','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762335','3','31/07/2020','95488,23','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762339','3','31/08/2020','172332,46','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762342','3','31/08/2020','134536,9','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762344','3','31/08/2020','97412,56','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762345','3','31/07/2020','180443,98','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762349','3','31/08/2020','66261,17','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762355','3','31/08/2020','5562,25','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762356','3','31/08/2020','26848,06','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762357','3','31/08/2020','5562,25','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762358','3','31/08/2020','30799,36','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762359','3','31/08/2020','29358,99','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762361','3','31/08/2020','5684,96','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762365','3','31/07/2020','265173,6','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762370','3','31/08/2020','40648,41','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762373','3','31/08/2020','5602,48','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762376','3','31/08/2020','101110,88','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762377','3','31/08/2020','60381,96','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762380','3','31/08/2020','34867,45','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762383','3','31/08/2020','5471,72','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762389','3','31/08/2020','430101,43','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762392','3','31/08/2020','5598,46','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762393','3','31/08/2020','80124,88','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762396','3','31/08/2020','105870,68','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762399','3','31/08/2020','83955,96','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762400','3','31/08/2020','83955,96','Arco valoraciones S.A', ''),
T_TIPO_DATA('6762401','3','31/08/2020','53019,35','Arco valoraciones S.A', ''),
T_TIPO_DATA('6767799','3','31/08/2020','178564,21','Arco valoraciones S.A', ''),
T_TIPO_DATA('6767808','3','31/08/2020','70768,86','Arco valoraciones S.A', ''),
T_TIPO_DATA('6767940','3','31/07/2020','126284,08','Arco valoraciones S.A', ''),
T_TIPO_DATA('6775896','3','31/08/2020','47357,83','Arco valoraciones S.A', ''),
T_TIPO_DATA('6775901','3','31/08/2020','5620,58','Arco valoraciones S.A', ''),
T_TIPO_DATA('6775906','3','31/08/2020','69459,73','Arco valoraciones S.A', ''),
T_TIPO_DATA('6775911','3','31/08/2020','5620,58','Arco valoraciones S.A', ''),
T_TIPO_DATA('6775915','3','31/08/2020','5648,75','Arco valoraciones S.A', ''),
T_TIPO_DATA('6775916','3','31/08/2020','5620,58','Arco valoraciones S.A', ''),
T_TIPO_DATA('6775918','3','31/08/2020','31881,02','Arco valoraciones S.A', ''),
T_TIPO_DATA('6775922','3','31/08/2020','5620,58','Arco valoraciones S.A', ''),
T_TIPO_DATA('6782713','3','31/08/2020','53576','Arco valoraciones S.A', ''),
T_TIPO_DATA('6800129','3','31/08/2020','56700,15','Arco valoraciones S.A', ''),
T_TIPO_DATA('6803449','3','31/08/2020','30799,36','Arco valoraciones S.A', ''),
T_TIPO_DATA('6803464','3','31/08/2020','5188,08','Arco valoraciones S.A', ''),
T_TIPO_DATA('6826980','3','31/08/2020','40343,47','Arco valoraciones S.A', ''),
T_TIPO_DATA('6826983','3','31/08/2020','5648,75','Arco valoraciones S.A', ''),
T_TIPO_DATA('6840015','3','31/08/2020','5648,75','Arco valoraciones S.A', ''),
T_TIPO_DATA('6840016','3','31/08/2020','5620,58','Arco valoraciones S.A', ''),
T_TIPO_DATA('6840018','3','31/08/2020','34657,85','Arco valoraciones S.A', ''),
T_TIPO_DATA('6840019','3','31/08/2020','35133,46','Arco valoraciones S.A', ''),
T_TIPO_DATA('6840020','3','31/08/2020','5620,58','Arco valoraciones S.A', ''),
T_TIPO_DATA('6840022','3','31/08/2020','56963,5','Arco valoraciones S.A', ''),
T_TIPO_DATA('6841482','3','31/08/2020','207508,81','Arco valoraciones S.A', ''),
T_TIPO_DATA('6950339','3','31/08/2020','39903,93','Arco valoraciones S.A', ''),
T_TIPO_DATA('6950340','3','31/08/2020','7389,32','Arco valoraciones S.A', ''),
T_TIPO_DATA('6950341','3','31/08/2020','31719,5','Arco valoraciones S.A', ''),
T_TIPO_DATA('6950344','3','31/08/2020','110672,07','Arco valoraciones S.A', ''),
T_TIPO_DATA('6950345','3','31/07/2020','93385,95','Arco valoraciones S.A', ''),
T_TIPO_DATA('6950346','3','31/07/2020','5107,01','Arco valoraciones S.A', ''),
T_TIPO_DATA('6950349','3','31/08/2020','61848,14','Arco valoraciones S.A', ''),
T_TIPO_DATA('6962194','3','31/08/2020','30672,7','Arco valoraciones S.A', ''),
T_TIPO_DATA('6962195','3','31/08/2020','5385,22','Arco valoraciones S.A', ''),
T_TIPO_DATA('6967731','3','31/07/2020','175159,31','Arco valoraciones S.A', ''),
T_TIPO_DATA('6979120','3','31/07/2020','108320,11','Arco valoraciones S.A', ''),
T_TIPO_DATA('7007131','3','31/07/2020','193091,18','Arco valoraciones S.A', ''),
T_TIPO_DATA('7007133','3','31/08/2020','34757,15','Arco valoraciones S.A', ''),
T_TIPO_DATA('7007134','3','31/08/2020','5648,75','Arco valoraciones S.A', ''),
T_TIPO_DATA('7015170','3','31/08/2020','197312,76','Arco valoraciones S.A', ''),
T_TIPO_DATA('7074954','3','31/07/2020','92168,99','Arco valoraciones S.A', ''),
T_TIPO_DATA('7075194','3','31/07/2020','126168,8','Arco valoraciones S.A', ''),
T_TIPO_DATA('7075195','3','31/07/2020','126168,8','Arco valoraciones S.A', ''),
T_TIPO_DATA('7101843','3','31/07/2020','101925,42','Arco valoraciones S.A', ''),
T_TIPO_DATA('7225642','3','31/08/2020','146233,65','Arco valoraciones S.A', ''),
T_TIPO_DATA('7225643','3','31/08/2020','49869,01','Arco valoraciones S.A', ''),
T_TIPO_DATA('7226179','3','31/07/2020','69500,29','Arco valoraciones S.A', ''),
T_TIPO_DATA('7226967','3','31/07/2020','71423,17','Arco valoraciones S.A', ''),
T_TIPO_DATA('7292507','3','31/08/2020','294032,84','Arco valoraciones S.A', ''),
T_TIPO_DATA('7292508','3','31/07/2020','31449,65','Arco valoraciones S.A', ''),
T_TIPO_DATA('7300443','3','31/08/2020','99943,89','Arco valoraciones S.A', ''),
T_TIPO_DATA('7300445','3','31/08/2020','6884,39','Arco valoraciones S.A', ''),
T_TIPO_DATA('7300818','3','31/08/2020','130904,53','Arco valoraciones S.A', ''),
T_TIPO_DATA('7300821','3','31/07/2020','122262,53','Arco valoraciones S.A', ''),
T_TIPO_DATA('7330043','3','31/07/2020','8873,33','Arco valoraciones S.A', '')

		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');


    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    	ACT_NUM_ACTIVO := TRIM(V_TMP_TIPO_DATA(1));
       	EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO INTO V_KOUNT;
  			  
		IF V_KOUNT > 0 THEN 
	  			  
			EXECUTE IMMEDIATE 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO INTO ACT_ID;
			
			EXECUTE IMMEDIATE 'SELECT BIE_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO INTO BIE_ID;
			
			EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA||'.S_BIE_VALORACIONES.NEXTVAL FROM DUAL' INTO NUM_SECUENCIA_VAL;
			
			EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA||'.S_ACT_TAS_TASACION.NEXTVAL FROM DUAL' INTO NUM_SECUENCIA_TAS;
	
			V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_1||' (BIE_ID, BIE_VAL_ID, BIE_FECHA_VALOR_TASACION, FECHACREAR, 
			USUARIOCREAR, VERSION, BORRADO)
					  SELECT '''||BIE_ID||''', 
							 '''||NUM_SECUENCIA_VAL||''',
							 TO_DATE('''||TRIM(V_TMP_TIPO_DATA(3))||''', ''DD/MM/YYYY''),
							 SYSDATE,
							 '''||V_USUARIO||''',
							 0,
							 0
					  FROM DUAL';

			EXECUTE IMMEDIATE V_SQL;
			
			DBMS_OUTPUT.PUT_LINE('INSERTADO EL ACTIVO '||ACT_NUM_ACTIVO||' EN '||V_TABLA_1);
			
			V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_2||' (ACT_ID, BIE_VAL_ID, TAS_ID, DD_TTS_ID, TAS_NOMBRE_TASADOR, FECHACREAR, 
			USUARIOCREAR, VERSION, BORRADO, TAS_FECHA_INI_TASACION, TAS_IMPORTE_TAS_FIN, TAS_FECHA_CADUCIDAD)
					  SELECT '''||ACT_ID||''',
							 '''||NUM_SECUENCIA_VAL||''',
							 '''||NUM_SECUENCIA_TAS||''',
							 '''||TRIM(V_TMP_TIPO_DATA(2))||''',
							 '''||TRIM(V_TMP_TIPO_DATA(5))||''',
							 SYSDATE,
							 '''||V_USUARIO||''',
							 0,
							 0,
							 TO_DATE('''||TRIM(V_TMP_TIPO_DATA(3))||''', ''DD/MM/YYYY''),
							 TO_NUMBER('''|| REPLACE( TRIM(V_TMP_TIPO_DATA(4)), ',', '.' )  ||''',''99999999.99''),
							 TO_DATE('''||TRIM(V_TMP_TIPO_DATA(6))||''', ''DD/MM/YYYY'')
					  FROM DUAL';
			EXECUTE IMMEDIATE V_SQL;
			
			DBMS_OUTPUT.PUT_LINE('INSERTADO EL ACTIVO '||ACT_NUM_ACTIVO||' EN '||V_TABLA_2);
			
			V_COUNT_UPDATE := V_COUNT_UPDATE + 1;
				
		ELSE
			
			DBMS_OUTPUT.PUT_LINE('[INFO] El activo '||ACT_NUM_ACTIVO||' no existe!');
			
		END IF;
		
      END LOOP;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado en total '||V_COUNT_UPDATE||' registros en la tabla '||V_TABLA_1);
    DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado en total '||V_COUNT_UPDATE||' registros en la tabla '||V_TABLA_2);
   

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
