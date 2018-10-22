--/*
--##########################################
--## AUTOR=Alejandro Valverde Herrera
--## FECHA_CREACION=20180806
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4390
--## PRODUCTO=NO
--##
--## Finalidad: Script que borra e inserta en USD_USUARIOS_DESPACHOS los datos añadidos en T_ARRAY_FUNCION.
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
    V_SQL_2 VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    V_NUM_TABLAS_2 NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
    --		USU_USERNAME			DES_DESPACHO
      T_FUNCION('sflores',			'REMACT'),
      T_FUNCION('prodriguezdelema',		'REMACT'),
      T_FUNCION('mgomezp',			'REMACT'),
      T_FUNCION('aalvear',			'REMACT'),
      T_FUNCION('jcordoba',			'REMSUPACT'),
      T_FUNCION('jcordoba',			'REMACT'),
      T_FUNCION('bcarrascosa',			'REMACT'),
      T_FUNCION('jpalazon',			'REMACT'),
      T_FUNCION('rcanales',			'REMACT'),
      T_FUNCION('mgodoy',			'REMACT'),
      T_FUNCION('mescribano',			'REMACT'),
      T_FUNCION('csalvador',			'REMACT'),
      T_FUNCION('gmoreno',			'REMACT'),
      T_FUNCION('jmateo',			'REMACT'),
      T_FUNCION('jsanmartint',			'REMACT'),
      T_FUNCION('jfernandez',			'REMACT'),
      T_FUNCION('jfernandez',			'REMSUPACT')
    ); 
    V_TMP_FUNCION T_FUNCION;

    TYPE T_FUNCION_2 IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION_2 IS TABLE OF T_FUNCION_2;
    V_FUNCION_2 T_ARRAY_FUNCION_2 := T_ARRAY_FUNCION_2(
    --		USU_USERNAME			DES_DESPACHO
      T_FUNCION_2('sflores',			'gestsue'),
      T_FUNCION_2('prodriguezdelema',		'gestsue'),
      T_FUNCION_2('mgomezp',			'gestsue'),
      T_FUNCION_2('aalvear',			'gestsue'),
      T_FUNCION_2('jcordoba',			'gestsue'),
      T_FUNCION_2('jcordoba',			'supsue'),
      T_FUNCION_2('bcarrascosa',			'gestedi'),
      T_FUNCION_2('jpalazon',			'gestedi'),
      T_FUNCION_2('rcanales',			'gestedi'),
      T_FUNCION_2('mgodoy',			'gestedi'),
      T_FUNCION_2('mescribano',			'gestedi'),
      T_FUNCION_2('csalvador',			'gestedi'),
      T_FUNCION_2('gmoreno',			'gestedi'),
      T_FUNCION_2('jmateo',			'gestedi'),
      T_FUNCION_2('jsanmartint',			'gestedi'),
      T_FUNCION_2('jfernandez',			'gestedi'),
      T_FUNCION_2('jfernandez',			'supedi')  
    ); 
    V_TMP_FUNCION_2 T_FUNCION_2;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    -- LOOP para borrar o insertar los valores en USD_USUARIOS_DESPACHOS -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: BORRADO EN USD_USUARIOS_DESPACHOS] ');
     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS 
			WHERE DES_ID = 
				(SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO 
				WHERE DES_DESPACHO = '''||TRIM(V_TMP_FUNCION(2))||''') 
				AND USU_ID = 
					(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS 
					WHERE USU_USERNAME = '''||TRIM(V_TMP_FUNCION(1))||''')';

			

			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
			-- Si existe la FUNCION
			IF V_NUM_TABLAS > 0 THEN
				
				V_MSQL := 'UPDATE '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS' || 
							' SET USUARIOBORRAR=''HREOS-4390'', FECHABORRAR=SYSDATE, BORRADO=1' || 
							' WHERE USU_ID=(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME='''||TRIM(V_TMP_FUNCION(1))||''')' || 
							' AND DES_ID=(SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO='''||TRIM(V_TMP_FUNCION(2))||''')';
				
				EXECUTE IMMEDIATE V_MSQL;
					  
				DBMS_OUTPUT.PUT_LINE('[INFO] Borrado de despacho '''||TRIM(V_TMP_FUNCION(2))||''' para el usuario '''||TRIM(V_TMP_FUNCION(1))||''' en '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS... realizado correctamente.');
				
			ELSE

				DBMS_OUTPUT.PUT_LINE('[INFO] El despacho '''||TRIM(V_TMP_FUNCION(2))||''' con usuario '''||TRIM(V_TMP_FUNCION(1))||''' en '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS... no existe.');

			END IF;
      END LOOP;
				
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADO EN USD_USUARIOS_DESPACHOS] ');
     FOR I IN V_FUNCION_2.FIRST .. V_FUNCION_2.LAST
      LOOP

	V_TMP_FUNCION_2 := V_FUNCION_2(I);
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS  
			WHERE DES_ID = 
				(SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO 
				WHERE DES_DESPACHO = '''||TRIM(V_TMP_FUNCION_2(2))||''') 
				AND USU_ID = 
					(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS 
					WHERE USU_USERNAME = '''||TRIM(V_TMP_FUNCION_2(1))||''')';

			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

			V_SQL_2 := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_FUNCION_2(1))||'''';
			
			EXECUTE IMMEDIATE V_SQL_2 INTO V_NUM_TABLAS_2;
			
			-- Si existe la FUNCION
			IF V_NUM_TABLAS > 0 THEN
					  
				DBMS_OUTPUT.PUT_LINE('[INFO] El despacho '''||TRIM(V_TMP_FUNCION_2(2))||''' con usuario '''||TRIM(V_TMP_FUNCION_2(1))||''' en '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS... ya existe.');

			ELSIF V_NUM_TABLAS_2 < 1 THEN
				
				DBMS_OUTPUT.PUT_LINE('[INFO] El usuario '''||TRIM(V_TMP_FUNCION_2(1))||''' no existe.');

				
			ELSE
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS' ||
							' (USD_ID, USU_ID, DES_ID, USD_GESTOR_DEFECTO, USD_SUPERVISOR, USUARIOCREAR, FECHACREAR, BORRADO)' || 
							' SELECT '||V_ESQUEMA||'.S_USD_USUARIOS_DESPACHOS.NEXTVAL,' ||
							' (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_FUNCION_2(1))||'''),' ||
							' (SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = '''||TRIM(V_TMP_FUNCION_2(2))||'''),' ||
							' 1,1,''HREOS-4390'',SYSDATE,0 FROM DUAL';

				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Inserción de despacho '''||TRIM(V_TMP_FUNCION_2(2))||''' para el usuario '''||TRIM(V_TMP_FUNCION_2(1))||''' en '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS... realizado correctamente.');

		    END IF;	
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: USD_USUARIOS_DESPACHOS ACTUALIZADO CORRECTAMENTE ');
   

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
   
