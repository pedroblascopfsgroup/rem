--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210913
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10436
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

    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-10436';    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    			-- NUM_ACT	TIPO_TASACION 	FECHA_TAS	IMPORTE_TAS	TASADORA
	T_TIPO_DATA('6044011','3','10/08/2021','51744,9','Arco valoraciones S.A'),
	T_TIPO_DATA('6044013','3','10/08/2021','51718,92','Arco valoraciones S.A'),
	T_TIPO_DATA('6044020','3','10/08/2021','106097,29','Arco valoraciones S.A'),
	T_TIPO_DATA('6044026','3','10/08/2021','258079,25','Arco valoraciones S.A'),
	T_TIPO_DATA('6044045','3','10/08/2021','71552,12','Arco valoraciones S.A'),
	T_TIPO_DATA('6044082','3','10/08/2021','113855,59','Arco valoraciones S.A'),
	T_TIPO_DATA('6044089','3','10/08/2021','119475,24','Arco valoraciones S.A'),
	T_TIPO_DATA('6044104','3','10/08/2021','74270,46','Arco valoraciones S.A'),
	T_TIPO_DATA('6044105','3','10/08/2021','74580,87','Arco valoraciones S.A'),
	T_TIPO_DATA('6044112','3','10/08/2021','76118,66','Arco valoraciones S.A'),
	T_TIPO_DATA('6044166','3','10/08/2021','113956,44','Arco valoraciones S.A'),
	T_TIPO_DATA('6044167','3','10/08/2021','75076,51','Arco valoraciones S.A'),
	T_TIPO_DATA('6044170','3','10/08/2021','94211,45','Arco valoraciones S.A'),
	T_TIPO_DATA('6044172','3','10/08/2021','3177,91','Arco valoraciones S.A'),
	T_TIPO_DATA('6044190','3','10/08/2021','71993,28','Arco valoraciones S.A'),
	T_TIPO_DATA('6044191','3','10/08/2021','73660,09','Arco valoraciones S.A'),
	T_TIPO_DATA('6044226','3','10/08/2021','65536,13','Arco valoraciones S.A'),
	T_TIPO_DATA('6044259','3','10/08/2021','86880,74','Arco valoraciones S.A'),
	T_TIPO_DATA('6044281','3','10/08/2021','71993,28','Arco valoraciones S.A'),
	T_TIPO_DATA('6044293','3','10/08/2021','74243,62','Arco valoraciones S.A'),
	T_TIPO_DATA('6044298','3','10/08/2021','276945,9','Arco valoraciones S.A'),
	T_TIPO_DATA('6084947','3','10/08/2021','240869,54','Arco valoraciones S.A'),
	T_TIPO_DATA('6084959','3','10/08/2021','126830,57','Arco valoraciones S.A'),
	T_TIPO_DATA('6084991','3','10/08/2021','91266,25','Arco valoraciones S.A'),
	T_TIPO_DATA('6084994','3','10/08/2021','49625,22','Arco valoraciones S.A'),
	T_TIPO_DATA('6762166','3','10/08/2021','115967,83','Arco valoraciones S.A'),
	T_TIPO_DATA('6762190','3','10/08/2021','28068,62','Arco valoraciones S.A'),
	T_TIPO_DATA('6762193','3','10/08/2021','159539,14','Arco valoraciones S.A'),
	T_TIPO_DATA('6762199','3','10/08/2021','58984,1','Arco valoraciones S.A'),
	T_TIPO_DATA('6762209','3','10/08/2021','82662,41','Arco valoraciones S.A'),
	T_TIPO_DATA('6762233','3','10/08/2021','6630,72','Arco valoraciones S.A'),
	T_TIPO_DATA('6762247','3','10/08/2021','124773,8','Arco valoraciones S.A'),
	T_TIPO_DATA('6762249','3','10/08/2021','68317,77','Arco valoraciones S.A'),
	T_TIPO_DATA('6762267','3','10/08/2021','113416,08','Arco valoraciones S.A'),
	T_TIPO_DATA('6762272','3','10/08/2021','211885,2','Arco valoraciones S.A'),
	T_TIPO_DATA('6762274','3','10/08/2021','137306,9','Arco valoraciones S.A'),
	T_TIPO_DATA('6762295','3','10/08/2021','141675,69','Arco valoraciones S.A'),
	T_TIPO_DATA('6762319','3','10/08/2021','16475,1','Arco valoraciones S.A'),
	T_TIPO_DATA('6762348','3','10/08/2021','55958,76','Arco valoraciones S.A'),
	T_TIPO_DATA('6762349','3','10/08/2021','72241,91','Arco valoraciones S.A'),
	T_TIPO_DATA('6762382','3','10/08/2021','63137,59','Arco valoraciones S.A'),
	T_TIPO_DATA('6762393','3','10/08/2021','80612,36','Arco valoraciones S.A'),
	T_TIPO_DATA('6762396','3','10/08/2021','109758,72','Arco valoraciones S.A'),
	T_TIPO_DATA('6767799','3','10/08/2021','174523,18','Arco valoraciones S.A'),
	T_TIPO_DATA('6814469','3','10/08/2021','211608,21','Arco valoraciones S.A'),
	T_TIPO_DATA('6979120','3','10/08/2021','112260,17','Arco valoraciones S.A'),
	T_TIPO_DATA('7007134','3','10/08/2021','6066,93','Arco valoraciones S.A'),
	T_TIPO_DATA('7029113','3','10/08/2021','298151,16','Arco valoraciones S.A'),
	T_TIPO_DATA('7075194','3','10/08/2021','124977,91','Arco valoraciones S.A'),
	T_TIPO_DATA('7075195','3','10/08/2021','124977,91','Arco valoraciones S.A'),
	T_TIPO_DATA('7225642','3','10/08/2021','147212,16','Arco valoraciones S.A'),
	T_TIPO_DATA('7225643','3','10/08/2021','49100,79','Arco valoraciones S.A'),
	T_TIPO_DATA('7226179','3','10/08/2021','69678,95','Arco valoraciones S.A'),
	T_TIPO_DATA('6044016','3','13/08/2021','118450,9','Arco valoraciones S.A'),
	T_TIPO_DATA('6044034','3','13/08/2021','176408,91','Arco valoraciones S.A'),
	T_TIPO_DATA('6044036','3','13/08/2021','89478,42','Arco valoraciones S.A'),
	T_TIPO_DATA('6044037','3','13/08/2021','31836,1','Arco valoraciones S.A'),
	T_TIPO_DATA('6044083','3','13/08/2021','140959,12','Arco valoraciones S.A'),
	T_TIPO_DATA('6044088','3','13/08/2021','250318,76','Arco valoraciones S.A'),
	T_TIPO_DATA('6044098','3','13/08/2021','20791,16','Arco valoraciones S.A'),
	T_TIPO_DATA('6044114','3','13/08/2021','235808,04','Arco valoraciones S.A'),
	T_TIPO_DATA('6044116','3','13/08/2021','150555,6','Arco valoraciones S.A'),
	T_TIPO_DATA('6044180','3','13/08/2021','118604,95','Arco valoraciones S.A'),
	T_TIPO_DATA('6044220','3','13/08/2021','164403,72','Arco valoraciones S.A'),
	T_TIPO_DATA('6044278','3','13/08/2021','132767,23','Arco valoraciones S.A'),
	T_TIPO_DATA('6044318','3','13/08/2021','70923,83','Arco valoraciones S.A'),
	T_TIPO_DATA('6084935','3','13/08/2021','88798,73','Arco valoraciones S.A'),
	T_TIPO_DATA('6084942','3','13/08/2021','350969,74','Arco valoraciones S.A'),
	T_TIPO_DATA('6084948','3','13/08/2021','124635,02','Arco valoraciones S.A'),
	T_TIPO_DATA('6084964','3','13/08/2021','138687,46','Arco valoraciones S.A'),
	T_TIPO_DATA('6084965','3','13/08/2021','1211,5','Arco valoraciones S.A'),
	T_TIPO_DATA('6084966','3','13/08/2021','10116,41','Arco valoraciones S.A'),
	T_TIPO_DATA('6762200','3','13/08/2021','95871,87','Arco valoraciones S.A'),
	T_TIPO_DATA('6762210','3','13/08/2021','52552,26','Arco valoraciones S.A'),
	T_TIPO_DATA('6762232','3','13/08/2021','102746,78','Arco valoraciones S.A'),
	T_TIPO_DATA('6762234','3','13/08/2021','110465,79','Arco valoraciones S.A'),
	T_TIPO_DATA('6762310','3','13/08/2021','191838,04','Arco valoraciones S.A'),
	T_TIPO_DATA('6762313','3','13/08/2021','199628,57','Arco valoraciones S.A'),
	T_TIPO_DATA('6762314','3','13/08/2021','11213,23','Arco valoraciones S.A'),
	T_TIPO_DATA('6762339','3','13/08/2021','172823,66','Arco valoraciones S.A'),
	T_TIPO_DATA('6762376','3','13/08/2021','106886,36','Arco valoraciones S.A'),
	T_TIPO_DATA('6767808','3','13/08/2021','84129,06','Arco valoraciones S.A'),
	T_TIPO_DATA('6841482','3','13/08/2021','218170,48','Arco valoraciones S.A'),
	T_TIPO_DATA('6950344','3','13/08/2021','118078,12','Arco valoraciones S.A'),
	T_TIPO_DATA('7007131','3','13/08/2021','195512,02','Arco valoraciones S.A'),
	T_TIPO_DATA('7015170','3','13/08/2021','203296,19','Arco valoraciones S.A'),
	T_TIPO_DATA('7300821','3','13/08/2021','128209,63','Arco valoraciones S.A'),
	T_TIPO_DATA('7460220','3','13/08/2021','118002,48','Arco valoraciones S.A'),
	T_TIPO_DATA('6762203','3','20/08/2021','28586,42','Arco valoraciones S.A'),
	T_TIPO_DATA('6762296','3','20/08/2021','87077,2','Arco valoraciones S.A'),
	T_TIPO_DATA('6762302','3','20/08/2021','87035,86','Arco valoraciones S.A'),
	T_TIPO_DATA('6762377','3','20/08/2021','60747,43','Arco valoraciones S.A'),
	T_TIPO_DATA('6831681','3','20/08/2021','7233,77','Arco valoraciones S.A'),
	T_TIPO_DATA('6831689','3','20/08/2021','85997,52','Arco valoraciones S.A'),
	T_TIPO_DATA('6950343','3','20/08/2021','56827,72','Arco valoraciones S.A'),
	T_TIPO_DATA('7465843','3','20/08/2021','53790,25','Arco valoraciones S.A'),
	T_TIPO_DATA('7300987','3','07/09/2021','264170,27','Arco valoraciones S.A'),
	T_TIPO_DATA('7460965','3','07/09/2021','6041,48','Arco valoraciones S.A'),
	T_TIPO_DATA('6762241','3','07/09/2021','286232,96','Arco valoraciones S.A'),
	T_TIPO_DATA('6044032','3','07/09/2021','144886,82','Arco valoraciones S.A'),
	T_TIPO_DATA('6044103','3','07/09/2021','95271,39','Arco valoraciones S.A'),
	T_TIPO_DATA('6044121','3','07/09/2021','8896,04','Arco valoraciones S.A'),
	T_TIPO_DATA('6044187','3','07/09/2021','61403,7','Arco valoraciones S.A'),
	T_TIPO_DATA('6044188','3','07/09/2021','227534,31','Arco valoraciones S.A'),
	T_TIPO_DATA('6044189','3','07/09/2021','13904,04','Arco valoraciones S.A'),
	T_TIPO_DATA('6044221','3','07/09/2021','113727,26','Arco valoraciones S.A'),
	T_TIPO_DATA('6044261','3','07/09/2021','72714,51','Arco valoraciones S.A'),
	T_TIPO_DATA('6044265','3','07/09/2021','149229,76','Arco valoraciones S.A'),
	T_TIPO_DATA('6762175','3','07/09/2021','5789,65','Arco valoraciones S.A'),
	T_TIPO_DATA('6762179','3','07/09/2021','5962,67','Arco valoraciones S.A'),
	T_TIPO_DATA('6762182','3','07/09/2021','5895,15','Arco valoraciones S.A'),
	T_TIPO_DATA('6762184','3','07/09/2021','5962,67','Arco valoraciones S.A'),
	T_TIPO_DATA('6762198','3','07/09/2021','77276,54','Arco valoraciones S.A'),
	T_TIPO_DATA('6762211','3','07/09/2021','2742,48','Arco valoraciones S.A'),
	T_TIPO_DATA('6762212','3','07/09/2021','82734,75','Arco valoraciones S.A'),
	T_TIPO_DATA('6762214','3','07/09/2021','6354,93','Arco valoraciones S.A'),
	T_TIPO_DATA('6762223','3','07/09/2021','98997,8','Arco valoraciones S.A'),
	T_TIPO_DATA('6762227','3','07/09/2021','13985,87','Arco valoraciones S.A'),
	T_TIPO_DATA('6762239','3','07/09/2021','40157,56','Arco valoraciones S.A'),
	T_TIPO_DATA('6762260','3','07/09/2021','58669,52','Arco valoraciones S.A'),
	T_TIPO_DATA('6762268','3','07/09/2021','20724,77','Arco valoraciones S.A'),
	T_TIPO_DATA('6762271','3','07/09/2021','109031,64','Arco valoraciones S.A'),
	T_TIPO_DATA('6762277','3','07/09/2021','106231,53','Arco valoraciones S.A'),
	T_TIPO_DATA('6762279','3','07/09/2021','118647,27','Arco valoraciones S.A'),
	T_TIPO_DATA('6762299','3','07/09/2021','166161,11','Arco valoraciones S.A'),
	T_TIPO_DATA('6762303','3','07/09/2021','5787,54','Arco valoraciones S.A'),
	T_TIPO_DATA('6762315','3','07/09/2021','5648,29','Arco valoraciones S.A'),
	T_TIPO_DATA('6762317','3','07/09/2021','181118,38','Arco valoraciones S.A'),
	T_TIPO_DATA('6762318','3','07/09/2021','193283,41','Arco valoraciones S.A'),
	T_TIPO_DATA('6762326','3','07/09/2021','42617,55','Arco valoraciones S.A'),
	T_TIPO_DATA('6762360','3','07/09/2021','99189,73','Arco valoraciones S.A'),
	T_TIPO_DATA('6762387','3','07/09/2021','99165,75','Arco valoraciones S.A'),
	T_TIPO_DATA('6762389','3','07/09/2021','429265,63','Arco valoraciones S.A'),
	T_TIPO_DATA('6762399','3','07/09/2021','84762,67','Arco valoraciones S.A'),
	T_TIPO_DATA('6762400','3','07/09/2021','84969,15','Arco valoraciones S.A'),
	T_TIPO_DATA('6776330','3','07/09/2021','101361,48','Arco valoraciones S.A'),
	T_TIPO_DATA('6950339','3','07/09/2021','41453,16','Arco valoraciones S.A'),
	T_TIPO_DATA('6950345','3','07/09/2021','85101,5','Arco valoraciones S.A'),
	T_TIPO_DATA('6950346','3','07/09/2021','8345,15','Arco valoraciones S.A'),
	T_TIPO_DATA('6962196','3','07/09/2021','49230,78','Arco valoraciones S.A'),
	T_TIPO_DATA('7300443','3','07/09/2021','95345,15','Arco valoraciones S.A'),
	T_TIPO_DATA('7300444','3','07/09/2021','48708,61','Arco valoraciones S.A'),
	T_TIPO_DATA('7434832','3','07/09/2021','98696,25','Arco valoraciones S.A')
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
			USUARIOCREAR, VERSION, BORRADO, TAS_FECHA_INI_TASACION, TAS_IMPORTE_TAS_FIN)
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
							 TO_NUMBER('''|| REPLACE( TRIM(V_TMP_TIPO_DATA(4)), ',', '.' )  ||''',''99999999.99'')
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