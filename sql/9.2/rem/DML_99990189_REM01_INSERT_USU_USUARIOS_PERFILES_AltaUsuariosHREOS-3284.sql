--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20171122
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3284
--## PRODUCTO=NO
--##
--## Finalidad: Script que da de alta usuarios
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

  ENTIDAD NUMBER(1):= '1';
  
  V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-3284';
  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
  V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		--	  USER_NAME	   	NOMBRE_USU		APELL1			APELL2			EMAIL      			PASS	grupo	PEF_COD		USU GRUPO	DESPACHO_EXTERNO	
		
	  T_TIPO_DATA('jcasabosca', 'Judit', 'Casabosca', 'Casals', 'jcasabosca@externos.haya.es', '', '0','HAYAGESTCOM', '', ''),
	  T_TIPO_DATA('X8488826D', 'Krasimira', 'Terzieva', '', 'kterzieva@gesvalt.es', '', '0','HAYAPROV', '', ''),
	  T_TIPO_DATA('05202942C', 'Jesús', 'Fernández', 'Diaz', 'jfernandez@gesvaltservices.es', '', '0', 'HAYAPROV', '', ''),
	  T_TIPO_DATA('43751940Y', 'Inmaculada', 'Cano', 'Sánchez', 'bankia@gesvalt.es', '', '0', 'HAYAPROV', '', ''),
	  T_TIPO_DATA('80063260F', 'Belen', 'Salguero', 'Monago', 'bankia@gesvalt.es', '', '0', 'HAYAPROV', '', '')

  ); 
  V_TMP_TIPO_DATA T_TIPO_DATA;
  
BEGIN	

 DBMS_OUTPUT.PUT_LINE('[INICIO] ');


 
   -- LOOP para insertar los valores en USU_USUARIOS, ZON_PEF_USU Y USD_USUARIOS_DESPACHOS -----------------------------------------------------------------
   FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
     LOOP
    
       V_TMP_TIPO_DATA := V_TIPO_DATA(I);
       
       -------------------------------------------------
       --Comprobamos el dato a insertar en usu_usuario--
       -------------------------------------------------
       
       DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN USU_USUARIOS DE '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       
       V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
       EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
       
       --Si existe no se modifica
       IF V_NUM_TABLAS > 0 THEN				         
			
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.USU_USUARIOS... se modifican sus campos');
		
		V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS SET USU_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA(2))||''', USU_APELLIDO1 = '''||TRIM(V_TMP_TIPO_DATA(3))||''', 
					USU_APELLIDO2 = '''||TRIM(V_TMP_TIPO_DATA(4))||''', USU_MAIL = '''||TRIM(V_TMP_TIPO_DATA(5))||''', 
					USU_PASSWORD = '''||TRIM(V_TMP_TIPO_DATA(6))||''', USU_GRUPO = '||TRIM(V_TMP_TIPO_DATA(7))||', USUARIOMODIFICAR = '''||V_USUARIO||''', FECHAMODIFICAR = SYSDATE
					WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
		EXECUTE IMMEDIATE V_MSQL;	
       ELSE
     
        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' EN USU_USUARIOS');   
        
        V_MSQL := 'SELECT '|| V_ESQUEMA_M ||'.S_USU_USUARIOS.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
        
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.USU_USUARIOS (' ||
                      'USU_ID,
                       ENTIDAD_ID,
                       USU_USERNAME,
                       USU_PASSWORD,
                       USU_NOMBRE,
                       USU_APELLIDO1,
                       USU_APELLIDO2,
                       USU_MAIL,
                       USU_GRUPO,
                       USU_FECHA_VIGENCIA_PASS,
                       USUARIOCREAR,
                       FECHACREAR,
                       BORRADO) ' ||
                      'SELECT '|| V_ID || ',
                      '|| ENTIDAD ||',
                      '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''',
                      '''|| TRIM(V_TMP_TIPO_DATA(6)) ||''',
                      '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''',
                      '''|| TRIM(V_TMP_TIPO_DATA(3)) ||''',
                      '''|| TRIM(V_TMP_TIPO_DATA(4)) ||''',
                      '''|| TRIM(V_TMP_TIPO_DATA(5)) ||''',
                      '||TRIM(V_TMP_TIPO_DATA(7))||',
                      SYSDATE+730,
                      '''||V_USUARIO||''',
                      SYSDATE,
                      0 
                      FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
        
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' INSERTADO CORRECTAMENTE EN USU_USUARIOS');
      
       END IF;
       
       -------------------------------------------------
       --Comprobamos el dato a insertar en zon_pef_usu--
       -------------------------------------------------
        
       DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN ZON_PEF_USU '); 
        
       V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ZON_PEF_USU WHERE PEF_ID = 
						(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(8))||''') 
							AND USU_ID = 
								(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(1))||''')';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
		-- Si existe no se modifica
		IF V_NUM_TABLAS > 0 THEN	  
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.ZON_PEF_USU...no se modifica nada.');
			
		ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' EN ZON_PEF_USU');
		
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ZON_PEF_USU' ||
					' (ZPU_ID, ZON_ID, PEF_ID, USU_ID, USUARIOCREAR, FECHACREAR, BORRADO)' || 
					' SELECT '||V_ESQUEMA||'.S_ZON_PEF_USU.NEXTVAL,' ||
					' (SELECT ZON_ID FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE ZON_DESCRIPCION = ''REM''),' ||
					' (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(8))||'''),' ||
					' (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(1))||'''),' ||
					' '''||V_USUARIO||''',
					SYSDATE,
					0 
					FROM DUAL';
		   	
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' INSERTADO CORRECTAMENTE EN ZON_PEF_USU');
			
		END IF;
		
	   ------------------------------------------------------------
       --Comprobamos el dato a insertar en usd_usuarios_despachos--
       ------------------------------------------------------------
       IF V_TMP_TIPO_DATA(10) IS NULL THEN
       		DBMS_OUTPUT.PUT_LINE('[INFO]: NO INSERTA EN USUARIOS_DESPACHOS');
       ELSE
       
	       DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN USD_USUARIOS_DESPACHOS ');
	       
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS 
				WHERE DES_ID = 
					(SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO 
					WHERE DES_DESPACHO = '''||TRIM(V_TMP_TIPO_DATA(10))||''') 
					AND USU_ID = 
						(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS 
						WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(1))||''')';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
				
			-- Si existe no se modifica
			IF V_NUM_TABLAS > 0 THEN	  
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS...no se modifica nada.');
				
			ELSE
			
			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' EN USD_USUARIOS_DESPACHOS');
			
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS' ||
						' (USD_ID, DES_ID, USU_ID, USD_GESTOR_DEFECTO, USD_SUPERVISOR, USUARIOCREAR, FECHACREAR, BORRADO)' || 
						' SELECT '||V_ESQUEMA||'.S_USD_USUARIOS_DESPACHOS.NEXTVAL,' ||
						' (SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = '''||TRIM(V_TMP_TIPO_DATA(10))||'''),' ||							
						' (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(1))||'''),' ||
						' 1,1,'''||V_USUARIO||''',SYSDATE,0 FROM DUAL';
			  	
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' INSERTADO CORRECTAMENTE EN USD_USUARIOS_DESPACHOS');
				
			END IF;	
		END IF;
		
	   ---------------------------------------------------------
       --Comprobamos el dato a insertar en gru_grupos_usuarios--
       ---------------------------------------------------------
       
		IF V_TMP_TIPO_DATA(9) IS NULL THEN
			DBMS_OUTPUT.PUT_LINE('[INFO]: NO INSERTA EN GRUPOS ');
		ELSE
			-- Comprobamos que exista el usuario de grupo
			V_SQL := '
			SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(9))||''' AND USU.USU_GRUPO = 1'
			;
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
			IF V_NUM_TABLAS > 0 THEN
		
		       	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN GRU_GRUPOS_USUARIOS ');	
			   
				V_SQL := '
				SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.GRU_GRUPOS_USUARIOS
				WHERE USU_ID_USUARIO = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(1))||''')
				AND USU_ID_GRUPO = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(9))||''')
				'
				;
				
				EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
				
				-- Si existe no se modifica
				IF V_NUM_TABLAS > 0 THEN	  
					DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.GRU_GRUPOS_USUARIOS...no se modifica nada.');
					
				ELSE
				
				DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' EN GRU_GRUPOS_USUARIOS');
				
				V_MSQL := '
				INSERT INTO '||V_ESQUEMA_M||'.GRU_GRUPOS_USUARIOS
					(GRU_ID, USU_ID_GRUPO, USU_ID_USUARIO, USUARIOCREAR, FECHACREAR, BORRADO) 
					SELECT '||V_ESQUEMA_M||'.S_GRU_GRUPOS_USUARIOS.NEXTVAL,
					(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(9))||'''),
					(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(1))||'''),
					'''||V_USUARIO||''',
					SYSDATE,
					0 
					FROM DUAL
				'
				;
					
				EXECUTE IMMEDIATE V_MSQL;
				
				DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' INSERTADO CORRECTAMENTE EN GRU_GRUPOS_USUARIOS.. en GRUPO: '|| TRIM(V_TMP_TIPO_DATA(9)));
					
				END IF;
			ELSE
				DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL USUARIO DE GRUPO: '|| TRIM(V_TMP_TIPO_DATA(9)));
			END IF;
		END IF;
		
    END LOOP;
    
   COMMIT;
   
   DBMS_OUTPUT.PUT_LINE('[FIN]: PROCESO ACTUALIZADO CORRECTAMENTE ');
 

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