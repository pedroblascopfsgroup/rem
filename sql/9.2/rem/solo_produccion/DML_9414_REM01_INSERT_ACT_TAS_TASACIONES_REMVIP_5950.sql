--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20191209
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5950
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
    V_TABLA_3 VARCHAR2(25 CHAR):= 'BIE_DATOS_REGISTRALES';
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

    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-5950';    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    			-- NUM_ACT	NºFINCA 	FECHA_TAS	IMPORTE_TAS		TASADORA
                      T_TIPO_DATA('6946819','','12/12/2011','265859,23','Arco Valoraciones', '03'),
                      T_TIPO_DATA('6946782','','16/05/2012','11000','Valmesa', '03'),
                      T_TIPO_DATA('6946910','','07/11/2017','218745,35','Arco Valoraciones', '03'),
                      T_TIPO_DATA('6946997','','16/04/2010','10000','Valmesa', '03'),
                      T_TIPO_DATA('6947000','','09/04/2015','11151,8','Valmesa', '03'),
                      T_TIPO_DATA('6946761','','16/05/2014','271006,53','Valmesa', '03'),
                      T_TIPO_DATA('6946765','','02/11/2011','91326,41','Valmesa', '03'),
                      T_TIPO_DATA('6946768','','16/11/2017','200008,66','Valmesa', '03'),
                      T_TIPO_DATA('6946776','','03/04/2014','320000','Tinsa', '03'),
                      T_TIPO_DATA('6946777','','29/01/2013','81907,93','Valmesa', '03'),
                      T_TIPO_DATA('6946779','','02/02/2015','90024,54','Sociedad de Tasacion', '03'),
                      T_TIPO_DATA('6946780','','12/02/2013','83718,63','Valmesa', '03'),
                      T_TIPO_DATA('6946781','','16/05/2012','128716,81','Valmesa', '03'),
                      T_TIPO_DATA('6946783','','22/09/2009','130647,07','Valmesa', '03'),
                      T_TIPO_DATA('6946785','','24/11/2015','743414,78','Valmesa', '03'),
                      T_TIPO_DATA('6946791','','21/10/2014','115614,3','Tinsa', '03'),
                      T_TIPO_DATA('6946793','','02/09/2016','109097,64','Euroval', '03'),
                      T_TIPO_DATA('6946794','','02/09/2016','95832,84','Euroval', '03'),
                      T_TIPO_DATA('6946796','','02/09/2016','116067,93','Euroval', '03'),
                      T_TIPO_DATA('6946797','','02/09/2016','113774,1','Euroval', '03'),
                      T_TIPO_DATA('6946798','','11/05/2011','92072,06','Sociedad de Tasacion', '03'),
                      T_TIPO_DATA('6946799','','29/12/2011','133955','Murciana de Tasaciones', '03'),
                      T_TIPO_DATA('6946800','','13/11/2014','120943,35','Valmesa', '03'),
                      T_TIPO_DATA('6946801','','22/11/2012','160128','Tinsa', '03'),
                      T_TIPO_DATA('6946802','','08/10/2012','144507,05','Valmesa', '03'),
                      T_TIPO_DATA('6946804','','05/05/2014','90329,49','Valmesa', '03'),
                      T_TIPO_DATA('6946807','','17/01/2011','228417,42','Cohispania', '03'),
                      T_TIPO_DATA('6946814','','30/07/2007','372500','Alia Tasaciones', '03'),
                      T_TIPO_DATA('6946815','','06/11/2017','186634,74','Arco Valoraciones', '03'),
                      T_TIPO_DATA('6946816','','18/01/2013','291519,12','Sociedad de Tasacion', '03'),
                      T_TIPO_DATA('6946817','','05/09/2013','117665,47','Sociedad de Tasacion', '03'),
                      T_TIPO_DATA('6946820','','31/12/2013','96000','Tinsa', '03'),
                      T_TIPO_DATA('6946830','','17/09/2013','81323,3','Valmesa', '03'),
                      T_TIPO_DATA('6946831','','13/10/2011','234673,65','Murciana de Tasaciones', '03'),
                      T_TIPO_DATA('6946832','','17/11/2011','270132,62','Valmesa', '03'),
                      T_TIPO_DATA('6946851','','23/10/2012','129676,14','Valmesa', '03'),
                      T_TIPO_DATA('6946853','','15/05/2014','72038,82','Valmesa', '03'),
                      T_TIPO_DATA('6946876','','21/01/2014','160268,5','Tinsa', '03'),
                      T_TIPO_DATA('6946877','','04/03/2011','238805,92','Valmesa', '03'),
                      T_TIPO_DATA('6946878','','17/11/2017','131083,79','Arco Valoraciones', '03'),
                      T_TIPO_DATA('6946880','','31/12/2014','95221,17','Sociedad de Tasacion', '03'),
                      T_TIPO_DATA('6946883','','08/10/2014','116859,68','Sociedad de Tasacion', '03'),
                      T_TIPO_DATA('6946884','','21/12/2012','85956','Tinsa', '03'),
                      T_TIPO_DATA('6946885','','13/04/2011','97948,06','Cohispania', '03'),
                      T_TIPO_DATA('6946886','','18/12/2013','81612,32','Valmesa', '03'),
                      T_TIPO_DATA('6946888','','22/10/2014','209454,39','Sociedad de Tasacion', '03'),
                      T_TIPO_DATA('6946890','','30/10/2014','86700','Tinsa', '03'),
                      T_TIPO_DATA('6946891','','07/05/2014','83072,5','Tinsa', '03'),
                      T_TIPO_DATA('6946892','','01/04/2009','94809,4','Valmesa', '03'),
                      T_TIPO_DATA('6946893','','03/01/2008','151104,23','Cohispania', '03'),
                      T_TIPO_DATA('6946896','','29/09/2011','107893,5','Tinsa', '03'),
                      T_TIPO_DATA('6946900','','07/07/2010','125473,45','Valmesa', '03'),
                      T_TIPO_DATA('6946904','','09/04/2015','82561,2','Valmesa', '03'),
                      T_TIPO_DATA('6946906','','03/04/2013','146173,26','Valmesa', '03'),
                      T_TIPO_DATA('6946912','','16/11/2015','244226,65','Valmesa', '03'),
                      T_TIPO_DATA('6946914','','29/05/2012','114275,15','Cohispania', '03'),
                      T_TIPO_DATA('6946916','','02/01/2014','332342,4','Tinsa', '03'),
                      T_TIPO_DATA('6946917','','19/10/2011','196084,51','Sociedad de Tasacion', '03'),
                      T_TIPO_DATA('6946921','','09/01/2009','120224,63','Socieda de Tasaciones Inmobiliarias', '03'),
                      T_TIPO_DATA('6946922','','09/01/2009','112893,25','Socieda de Tasaciones Inmobiliarias', '03'),
                      T_TIPO_DATA('6946927','','29/06/2011','158485,45','Cohispania', '03'),
                      T_TIPO_DATA('6946932','','19/12/2017','124957,78','Arco Valoraciones', '03'),
                      T_TIPO_DATA('6946967','','26/09/2011','114400','Risc Valor', '03'),
                      T_TIPO_DATA('6946969','','25/02/2014','101223,71','Valmesa', '03'),
                      T_TIPO_DATA('6946970','','25/02/2014','97888,68','Valmesa', '03'),
                      T_TIPO_DATA('6946971','','03/04/2013','100450','Tinsa', '03'),
                      T_TIPO_DATA('6946975','','04/11/2010','155587','Socieda de Tasaciones Inmobiliarias', '03'),
                      T_TIPO_DATA('6946976','','04/11/2010','170193','Socieda de Tasaciones Inmobiliarias', '03'),
                      T_TIPO_DATA('6946977','','04/11/2010','152746','Socieda de Tasaciones Inmobiliarias', '03'),
                      T_TIPO_DATA('6946978','','04/11/2010','152746','Socieda de Tasaciones Inmobiliarias', '03'),
                      T_TIPO_DATA('6946979','','04/11/2010','139710','Socieda de Tasaciones Inmobiliarias', '03'),
                      T_TIPO_DATA('6946980','','04/11/2010','147900','Socieda de Tasaciones Inmobiliarias', '03'),
                      T_TIPO_DATA('6946981','','04/11/2010','149015','Socieda de Tasaciones Inmobiliarias', '03'),
                      T_TIPO_DATA('6946982','','04/11/2010','140471','Socieda de Tasaciones Inmobiliarias', '03'),
                      T_TIPO_DATA('6946984','','26/08/2010','80346,42','Valmesa', '03'),
                      T_TIPO_DATA('6946987','','29/10/2009','109875,52','Valmesa', '03'),
                      T_TIPO_DATA('6946988','','29/10/2009','80174,46','Valmesa', '03'),
                      T_TIPO_DATA('6946991','','26/04/2011','185769,06','Cohispania', '03'),
                      T_TIPO_DATA('6946993','','08/05/2014','103767,22','Valmesa', '03'),
                      T_TIPO_DATA('6946995','','24/10/2016','135824','Tinsa', '03'),
                      T_TIPO_DATA('6946996','','24/10/2016','136752','Tinsa', '03'),
                      T_TIPO_DATA('6947001','','17/03/2000','164196,5','Valmesa', '03'),
                      T_TIPO_DATA('6947005','','03/03/2011','106521,5','Cohispania', '03'),
                      T_TIPO_DATA('6946787','','29/08/2012','206505','Sociedad de Tasacion', '03'),
                      T_TIPO_DATA('6946803','','24/04/2012','115730,44','Cohispania', '03'),
                      T_TIPO_DATA('6946809','','27/10/2015','120837,78','Valmesa', '03'),
                      T_TIPO_DATA('6946823','','22/08/2012','208087,5','Tinsa', '03'),
                      T_TIPO_DATA('6946824','','19/12/2011','96976','Cohispania', '03'),
                      T_TIPO_DATA('6946872','','27/11/2012','104245,4','Valmesa', '03'),
                      T_TIPO_DATA('6946875','','11/08/2015','120303,47','Valmesa', '03'),
                      T_TIPO_DATA('6946889','','31/10/2014','105691,4','Valmesa', '03'),
                      T_TIPO_DATA('6946895','','07/12/2009','136889,4','Cohispania', '03'),
                      T_TIPO_DATA('6946897','','20/01/2015','106547,12','Valmesa', '03'),
                      T_TIPO_DATA('6946898','','12/03/2015','147465,04','Valmesa', '03'),
                      T_TIPO_DATA('6946901','','22/04/2013','111006','Tinsa', '03'),
                      T_TIPO_DATA('6946902','','22/04/2013','98077','Tinsa', '03'),
                      T_TIPO_DATA('6946905','','25/10/2011','77255,93','Cohispania', '03'),
                      T_TIPO_DATA('6946928','','21/05/2015','130872,38','Valmesa', '03'),
                      T_TIPO_DATA('6946933','','22/09/2017','90356,7','Krata', '03'),
                      T_TIPO_DATA('6946986','','22/07/2015','155667,49','Valmesa', '03'),
                      T_TIPO_DATA('6946788','','18/01/2016','12000','Sociedad de Tasacion', '03'),
                      T_TIPO_DATA('6946789','','18/01/2016','1500','Sociedad de Tasacion', '03'),
                      T_TIPO_DATA('6946811','','17/11/2017','273568,78','Arco Valoraciones', '03'),
                      T_TIPO_DATA('6946818','','12/01/2012','73082','Valencia Terra, VT, Sociedad de Tasaciones Inmobiliarias', '03'),
                      T_TIPO_DATA('6946864','','16/05/2011','315308,47','Tinsa', '03'),
                      T_TIPO_DATA('6946899','','17/11/2017','315162,01','Arco Valoraciones', '03'),
                      T_TIPO_DATA('6946918','','17/11/2017','284431,19','Arco Valoraciones', '03'),
                      T_TIPO_DATA('6946934','','19/01/2010','141995,81','Valmesa', '03'),
                      T_TIPO_DATA('6946989','','29/10/2019','93754,61','Valmesa', '03'),
                      T_TIPO_DATA('6966445','','11/10/2007','143300','Valmesa', '03'),
                      T_TIPO_DATA('6966446','','31/07/2017','81872,47','Euroval', '03'),
                      T_TIPO_DATA('6966447','','16/11/2011','56204,55','Tinsa', '03'),
                      T_TIPO_DATA('6966450','','06/02/2008','170000','Valmesa', '03'),
                      T_TIPO_DATA('6966451','','14/05/2009','111540,24','Valmesa', '03'),
                      T_TIPO_DATA('6966452','','19/05/2011','108056,86','Cohispania', '03'),
                      T_TIPO_DATA('6966453','','28/02/2011','90720','Cohispania', '03'),
                      T_TIPO_DATA('6966457','','28/04/2011','166546,01','Valmesa', '03'),
                      T_TIPO_DATA('6966458','','17/11/2017','115651,79','Arco Valoraciones', '03'),
                      T_TIPO_DATA('6966459','','17/11/2017','122586,7','Arco Valoraciones', '03'),
                      T_TIPO_DATA('6966473','','11/03/2011','99762,36','Murciana de Tasaciones', '03'),
                      T_TIPO_DATA('6966476','','21/03/2017','152452','Krata', '03'),
                      T_TIPO_DATA('6966482','','23/09/2015','86079,3','Valmesa', '03'),
                      T_TIPO_DATA('6966483','','29/10/2015','138091','Valmesa', '03'),
                      T_TIPO_DATA('6966484','','15/10/2013','316847,31','Socieda de Tasacion', '03'),
                      T_TIPO_DATA('6966486','','18/01/2016','97285,04','Socieda de Tasacion', '03'),
                      T_TIPO_DATA('6946827','','02/11/2017','113776,73','Valmesa', '03'),
                      T_TIPO_DATA('6946806','','14/12/2005','110398','Socieda de Tasacion', '03'),
                      T_TIPO_DATA('7071707','','16/08/2018','46661,06','Arco Valoraciones', '03'),
                      T_TIPO_DATA('7071705','','21/08/2018','161830,67','Arco Valoraciones', '03'),
                      T_TIPO_DATA('7071709','','15/10/2018','127657,76','Arco Valoraciones', '03'),
                      T_TIPO_DATA('7071706','','26/09/2018','62234,26','Arco Valoraciones', '03'),
                      T_TIPO_DATA('7071703','','09/01/2014','109450,41','Valmesa', '03'),
                      T_TIPO_DATA('6946805','','09/11/2011','400514','Socieda de Tasacion', '03'),
                      T_TIPO_DATA('6966461','','16/02/2012','179969,31','Cohispania', '03'),
                      T_TIPO_DATA('6946894','','07/10/2009','90301,82','Cohispania', '03'),
                      T_TIPO_DATA('6946990','','17/11/2017','209428,49','Arco Valoraciones', '03'),
                      T_TIPO_DATA('6946869','','11/10/2011','24172,53','Valmesa', '03'),
                      T_TIPO_DATA('6946919','','14/10/2015','162137,23','Valmesa', '03'),
                      T_TIPO_DATA('6946857','','05/09/2017','163535,05','Krata', '03'),
                      T_TIPO_DATA('6946778','','17/10/2011','693603,1','Socieda de Tasacion', '03'),
                      T_TIPO_DATA('6946770','','15/05/2014','117469,31','Valmesa', '03'),
                      T_TIPO_DATA('6946772','','23/12/2015','99505,18','Valmesa', '03'),
                      T_TIPO_DATA('6946773','','23/12/2015','93560,95','Valmesa', '03'),
                      T_TIPO_DATA('6946774','','23/12/2015','93521,73','Valmesa', '03'),
                      T_TIPO_DATA('6946775','','23/12/2015','99505,18','Valmesa', '03'),
                      T_TIPO_DATA('6946792','','22/05/2012','263131,15','Cohispania', '03'),
                      T_TIPO_DATA('6946826','','20/09/2013','106104,53','Tinsa', '03'),
                      T_TIPO_DATA('6946881','','11/11/2013','149333,25','Tinsa', '03'),
                      T_TIPO_DATA('6946923','','10/07/2014','28423,67','Tinsa', '03'),
                      T_TIPO_DATA('6946926','','10/07/2014','101711,17','Tinsa', '03'),
                      T_TIPO_DATA('6946965','','28/08/2015','82537,5','Tinsa', '03'),
                      T_TIPO_DATA('6946974','','18/10/2015','201514,25','Tinsa', '03'),
                      T_TIPO_DATA('6946994','','30/05/2012','188955,04','Valmesa', '03'),
                      T_TIPO_DATA('6946998','','17/03/2017','76030,73','Krata', '03'),
                      T_TIPO_DATA('6966449','','22/12/2019','112482,14','Valmesa', '03'),
                      T_TIPO_DATA('6966454','','22/05/2012','96671,29','Cohispania', '03'),
                      T_TIPO_DATA('6966488','','22/08/2015','242821,24','Socieda de Tasacion', '03'),
                      T_TIPO_DATA('7071708','','02/08/2018','189752,08','Arco Valoraciones', '03')


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
							 (SELECT DD_TTS_ID FROM '||V_ESQUEMA||'.DD_TTS_TIPO_TASACION WHERE DD_TTS_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(6))||'''),
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
