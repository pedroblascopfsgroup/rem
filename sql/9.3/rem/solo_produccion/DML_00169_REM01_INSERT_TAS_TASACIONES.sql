--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200225
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6494
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

    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-6494';    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    			-- NUM_ACT	NºFINCA 	FECHA_TAS	IMPORTE_TAS	TASADORA,  FECHA_CADUCIDAD
			T_TIPO_DATA('7068408','','14/11/2018','136507,08','', '',''),
			T_TIPO_DATA('7072619','','05/04/2018','89339,40','', '',''),	
			T_TIPO_DATA('7293175','','10/10/2019','120830','', '',''),
			T_TIPO_DATA('7072631','','31/10/2019','223814','', '',''),
			T_TIPO_DATA('6881535','','05/09/2018','94523,90','', '','')
			
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
							 NULL,
							 NULL,
							 SYSDATE,
							 '''||V_USUARIO||''',
							 0,
							 0,
							 TO_DATE('''||TRIM(V_TMP_TIPO_DATA(3))||''', ''DD/MM/YYYY''),
							 TO_NUMBER('''|| REPLACE( TRIM(V_TMP_TIPO_DATA(4)), ',', '.' )  ||''',''99999999.99''),
							 TO_DATE('''||TRIM(V_TMP_TIPO_DATA(7))||''', ''DD/MM/YYYY'')
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
