--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210929
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10516
--## PRODUCTO=NO
--##
--## Finalidad: Se añaden datos a la tabla ACT_TIT_TITULO y ACT_AHT_HIST_TRAM_TITULO
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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_USUARIO VARCHAR2(150 CHAR):='REMVIP-10516';

    V_COUNT NUMBER(16):=0;
    V_COUNT_TOTAL NUMBER(16):=0;
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(1500);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
        --ACT_NUM_ACTIVO    FECHA PRES.REGISTRO     FECHA INSCRIPCION
T_FUNCION('6854175','17/09/2021','23/09/2021'),
T_FUNCION('6854655','17/09/2021','23/09/2021'),
T_FUNCION('6854656','17/09/2021','23/09/2021'),
T_FUNCION('6854657','17/09/2021','23/09/2021'),
T_FUNCION('6854658','17/09/2021','23/09/2021'),
T_FUNCION('6854659','17/09/2021','23/09/2021'),
T_FUNCION('6854693','17/09/2021','23/09/2021'),
T_FUNCION('6854728','17/09/2021','23/09/2021'),
T_FUNCION('6854729','17/09/2021','23/09/2021'),
T_FUNCION('6854760','17/09/2021','23/09/2021'),
T_FUNCION('6854761','17/09/2021','23/09/2021'),
T_FUNCION('6854762','17/09/2021','23/09/2021'),
T_FUNCION('6854763','17/09/2021','23/09/2021'),
T_FUNCION('6854764','17/09/2021','23/09/2021'),
T_FUNCION('6854799','17/09/2021','23/09/2021'),
T_FUNCION('6854800','17/09/2021','23/09/2021'),
T_FUNCION('6854801','17/09/2021','23/09/2021'),
T_FUNCION('6854802','17/09/2021','23/09/2021'),
T_FUNCION('6854803','17/09/2021','23/09/2021'),
T_FUNCION('6854804','17/09/2021','23/09/2021'),
T_FUNCION('6854805','17/09/2021','23/09/2021'),
T_FUNCION('6854806','17/09/2021','23/09/2021'),
T_FUNCION('6854897','17/09/2021','23/09/2021'),
T_FUNCION('6854898','17/09/2021','23/09/2021'),
T_FUNCION('6854899','17/09/2021','23/09/2021'),
T_FUNCION('6854900','17/09/2021','23/09/2021'),
T_FUNCION('6854901','17/09/2021','23/09/2021'),
T_FUNCION('6854902','17/09/2021','23/09/2021'),
T_FUNCION('6854903','17/09/2021','23/09/2021'),
T_FUNCION('6854904','17/09/2021','23/09/2021'),
T_FUNCION('6854928','17/09/2021','23/09/2021'),
T_FUNCION('6854929','17/09/2021','23/09/2021'),
T_FUNCION('6854930','17/09/2021','23/09/2021'),
T_FUNCION('6854931','17/09/2021','23/09/2021'),
T_FUNCION('6854932','17/09/2021','23/09/2021'),
T_FUNCION('6855277','17/09/2021','23/09/2021'),
T_FUNCION('6855376','17/09/2021','23/09/2021'),
T_FUNCION('6855377','17/09/2021','23/09/2021'),
T_FUNCION('6855378','17/09/2021','23/09/2021'),
T_FUNCION('6855379','17/09/2021','23/09/2021'),
T_FUNCION('6855380','17/09/2021','23/09/2021'),
T_FUNCION('6855381','17/09/2021','23/09/2021'),
T_FUNCION('6855570','17/09/2021','23/09/2021'),
T_FUNCION('6855571','17/09/2021','23/09/2021'),
T_FUNCION('6855572','17/09/2021','23/09/2021'),
T_FUNCION('6855573','17/09/2021','23/09/2021'),
T_FUNCION('6855574','17/09/2021','23/09/2021'),
T_FUNCION('6855684','17/09/2021','23/09/2021'),
T_FUNCION('6855685','17/09/2021','23/09/2021'),
T_FUNCION('6855686','17/09/2021','23/09/2021'),
T_FUNCION('6856675','17/09/2021','23/09/2021'),
T_FUNCION('6856676','17/09/2021','23/09/2021'),
T_FUNCION('6856677','17/09/2021','23/09/2021'),
T_FUNCION('6856678','17/09/2021','23/09/2021'),
T_FUNCION('6856679','17/09/2021','23/09/2021'),
T_FUNCION('6856680','17/09/2021','23/09/2021'),
T_FUNCION('6856681','17/09/2021','23/09/2021'),
T_FUNCION('6881361','17/09/2021','27/09/2021'),
T_FUNCION('6882143','17/09/2021','27/09/2021'),
T_FUNCION('6882270','17/09/2021','27/09/2021'),
T_FUNCION('6882271','17/09/2021','27/09/2021'),
T_FUNCION('6882272','17/09/2021','27/09/2021'),
T_FUNCION('6882306','17/09/2021','27/09/2021'),
T_FUNCION('6882790','17/09/2021','27/09/2021'),
T_FUNCION('6882791','17/09/2021','27/09/2021'),
T_FUNCION('6882976','17/09/2021','27/09/2021'),
T_FUNCION('6882977','17/09/2021','27/09/2021'),
T_FUNCION('6883028','17/09/2021','27/09/2021'),
T_FUNCION('6883029','17/09/2021','27/09/2021'),
T_FUNCION('6883401','17/09/2021','27/09/2021'),
T_FUNCION('6883536','17/09/2021','27/09/2021'),
T_FUNCION('6883537','17/09/2021','27/09/2021'),
T_FUNCION('6883553','17/09/2021','27/09/2021'),
T_FUNCION('6883606','17/09/2021','27/09/2021'),
T_FUNCION('6883937','17/09/2021','27/09/2021'),
T_FUNCION('6884532','17/09/2021','27/09/2021'),
T_FUNCION('6884533','17/09/2021','27/09/2021'),
T_FUNCION('6884534','17/09/2021','27/09/2021'),
T_FUNCION('6884535','17/09/2021','27/09/2021'),
T_FUNCION('6884981','17/09/2021','27/09/2021')

    );          
    V_TMP_FUNCION T_FUNCION;
                
BEGIN	        
	            
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	            
    -- LOOP para insertar los valores en MGD_MAPEO_GESTOR_DOC -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN ACT_DIS_DISTRIBUCION] ');

      V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.ACT_AHT_HIST_TRAM_TITULO AUX USING (
                            SELECT DISTINCT TIT.TIT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                                JOIN '||V_ESQUEMA||'.ACT_TIT_TITULO TIT ON TIT.ACT_ID=ACT.ACT_ID
                                JOIN '||V_ESQUEMA||'.act_aht_hist_tram_titulo AHT ON AHT.TIT_ID=TIT.TIT_ID
                                WHERE ACT.ACT_NUM_ACTIVO IN (
                                6854175,
                                6854655,
                                6854656,
                                6854657,
                                6854658,
                                6854659,
                                6854693,
                                6854728,
                                6854729,
                                6854760,
                                6854761,
                                6854762,
                                6854763,
                                6854764,
                                6854799,
                                6854800,
                                6854801,
                                6854802,
                                6854803,
                                6854804,
                                6854805,
                                6854806,
                                6854897,
                                6854898,
                                6854899,
                                6854900,
                                6854901,
                                6854902,
                                6854903,
                                6854904,
                                6854928,
                                6854929,
                                6854930,
                                6854931,
                                6854932,
                                6855277,
                                6855376,
                                6855377,
                                6855378,
                                6855379,
                                6855380,
                                6855381,
                                6855570,
                                6855571,
                                6855572,
                                6855573,
                                6855574,
                                6855684,
                                6855685,
                                6855686,
                                6856675,
                                6856676,
                                6856677,
                                6856678,
                                6856679,
                                6856680,
                                6856681,
                                6881361,
                                6882143,
                                6882270,
                                6882271,
                                6882272,
                                6882306,
                                6882790,
                                6882791,
                                6882976,
                                6882977,
                                6883028,
                                6883029,
                                6883401,
                                6883536,
                                6883537,
                                6883553,
                                6883606,
                                6883937,
                                6884532,
                                6884533,
                                6884534,
                                6884535,
                                6884981


                                )
                    ) participadaBBVA
                ON (aux.TIT_ID = participadaBBVA.TIT_ID)
                WHEN MATCHED THEN UPDATE SET 
                BORRADO = 1,
                USUARIOBORRAR = '''||V_USUARIO||''',
                FECHABORRAR = SYSDATE
                ';
	
	            EXECUTE IMMEDIATE V_MSQL;

                DBMS_OUTPUT.PUT_LINE('[INFO] BORRADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN ACT_AHT_HIST_TRAM_TITULO ');


     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);

            V_COUNT_TOTAL:=V_COUNT_TOTAL+1;

            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT  WHERE ACT.ACT_NUM_ACTIVO = '''||(V_TMP_FUNCION(1))||''' AND ACT.BORRADO = 0';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;			

			
			-- Si existe el activo
			IF V_NUM_TABLAS = 1 THEN	  
				DBMS_OUTPUT.PUT_LINE('[INFO] Existe el activo se procede a insertar en historico');

                V_SQL := 'SELECT TIT.TIT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
                        JOIN '||V_ESQUEMA||'.ACT_TIT_TITULO TIT ON TIT.ACT_ID=ACT.ACT_ID AND TIT.BORRADO = 0                
                        WHERE ACT.ACT_NUM_ACTIVO = '''||(V_TMP_FUNCION(1))||''' AND ACT.BORRADO = 0';
			    EXECUTE IMMEDIATE V_SQL INTO V_ID;
      

                    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_AHT_HIST_TRAM_TITULO (
                                AHT_ID, TIT_ID, AHT_FECHA_PRES_REGISTRO, AHT_FECHA_INSCRIPCION, DD_ESP_ID, USUARIOCREAR, FECHACREAR
                                ) VALUES (
                                '||V_ESQUEMA||'.S_ACT_AHT_HIST_TRAM_TITULO.NEXTVAL,
                                '||V_ID||',
                                TO_DATE('''||(V_TMP_FUNCION(2))||''',''DD/MM/YYYY''),
                                TO_DATE('''||(V_TMP_FUNCION(3))||''',''DD/MM/YYYY''),
                                (SELECT DD_ESP_ID FROM '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION WHERE DD_ESP_CODIGO = ''03'' AND BORRADO = 0),
                                '''||V_USUARIO||''',
                                SYSDATE)';
                    EXECUTE IMMEDIATE V_MSQL;    

                    V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ACT_TIT_TITULO SET
                        TIT_FECHA_INSC_REG = TO_DATE('''||(V_TMP_FUNCION(3))||''',''DD/MM/YYYY''),
                        DD_ETI_ID = (SELECT DD_ETI_ID FROM '||V_ESQUEMA||'.DD_ETI_ESTADO_TITULO WHERE BORRADO = 0 AND DD_ETI_CODIGO=''02''),
                        USUARIOMODIFICAR = '''||V_USUARIO||''',
                        FECHAMODIFICAR = SYSDATE
                        WHERE TIT_ID = '||V_ID||'';
                    EXECUTE IMMEDIATE V_MSQL;    

                    DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.ACT_AHT_HIST_TRAM_TITULO insertados correctamente. '''||V_TMP_FUNCION(1)||''' - '''||V_TMP_FUNCION(2)||''' - '''||V_TMP_FUNCION(3)||''' ');
                    V_COUNT:=V_COUNT+1;        
			ELSE
                DBMS_OUTPUT.PUT_LINE('[INFO] No existe el activo indicado: '''||(V_TMP_FUNCION(1))||'''');
		    END IF;	
      END LOOP;
      DBMS_OUTPUT.PUT_LINE('[FIN]: MODIFICADOS CORRECTAMENTE '||V_COUNT||' DE '||V_COUNT_TOTAL||' ');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: Historico presentaciones ACTUALIZADO CORRECTAMENTE ');

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