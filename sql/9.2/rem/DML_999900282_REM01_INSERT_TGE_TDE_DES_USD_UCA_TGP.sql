--/*
--##########################################
--## AUTOR=Pau Serrano
--## FECHA_CREACION=2018032
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.18
--## INCIDENCIA_LINK=HREOS-4102
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_TGE; DD_TDE y DES_DESPACHO
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
    V_TIPO_ID NUMBER(16); --Vle para el id DD_TGE_TIPO_GESTOR 

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            -- DD_TGE/TDE_CODIGO  DD_TGE/TDE_DESCRIPCION          DD_TGE/TDE_DESCRIPCION_LARGA     DES_DESPACHO    USU_USERNAME  DD_CRA_CODIGO
      T_TIPO_DATA('GLIBRES'     ,'Gestor Liberbank Residencial'  ,'Gestor Liberbank Residencial'  ,'REMLIBRES'    ,'grulibres'    ,'08'),
      T_TIPO_DATA('GLIBSINTER'  ,'Gestor Singular/Terciario'     ,'Gestor Singular/Terciario'     ,'REMLIBSINTER' ,'grulibsinter' ,'08'),
      T_TIPO_DATA('GLIBINVINM'  ,'Gestor Inversión Inmobiliaria' ,'Gestor Inversión Inmobiliaria' ,'REMLIBINVINM' ,'grulibinvinm' ,'08'),
      T_TIPO_DATA('GCOIN'       ,'Gestor Comité de Inversiones Inmobiliarias','Gestor Comité de Inversiones Inmobiliarias','REMLIBCOINV','grucoinv','08'),
      T_TIPO_DATA('GCOINM'      ,'Gestor Comité Inmobiliario'    ,'Gestor Comité Inmobiliario'    ,'REMLIBCOINM'  ,'grucoinm'     ,'08'),
      T_TIPO_DATA('GCODI'       ,'Gestor Comité de Dirección'    ,'Gestor Comité de Dirección'    ,'REMLIBCODI'   ,'grucodi'      ,'08')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
   
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] Insertar/actualizar las tablas TGE, TDE, DES, USD, UCA  y TGP.');

	 
    -- LOOP para insertar los valores en -----------------------------------------------------------------

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

      V_TMP_TIPO_DATA := V_TIPO_DATA(I);
      DBMS_OUTPUT.PUT_LINE('[INFO]: ****** INSERT/UPDATE regitro: '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
    	------------------------------------------------------------------------------------------------------------------------
    	--											DD_TGE_TIPO_GESTOR
    	------------------------------------------------------------------------------------------------------------------------
    	DBMS_OUTPUT.PUT_LINE('[INFO]: *** INSERT/UPDATE EN DD_TGE_TIPO_GESTOR');
    	
      --Comprobamos el dato a insertar
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      
      --Si existe lo modificamos
      IF V_NUM_TABLAS > 0 THEN				
        
        DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
        V_MSQL := '
          UPDATE '|| V_ESQUEMA_M ||'.DD_TGE_TIPO_GESTOR 
          SET 
            DD_TGE_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''',
            DD_TGE_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''',
			    USUARIOMODIFICAR = ''HREOS-4102'',
            FECHAMODIFICAR = SYSDATE,
            BORRADO = 0 
			    WHERE DD_TGE_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
        
      --Si no existe, lo insertamos   
      ELSE
              DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
        V_MSQL := 'SELECT '|| V_ESQUEMA_M ||'.S_DD_TGE_TIPO_GESTOR.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
        
        V_MSQL := '
          INSERT INTO '|| V_ESQUEMA_M ||'.DD_TGE_TIPO_GESTOR 
            (DD_TGE_ID, DD_TGE_CODIGO, DD_TGE_DESCRIPCION, DD_TGE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
          SELECT 
            '|| V_ID || ',
            '''||V_TMP_TIPO_DATA(1)||''',
            '''||V_TMP_TIPO_DATA(2)||''',
            '''||TRIM(V_TMP_TIPO_DATA(3))||''',
            0,
            ''HREOS-4102'',
            SYSDATE,
            0
          FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
      
      END IF;
            
      ------------------------------------------------------------------------------------------------------------------------
    	--											DD_TDE_TIPO_DESPACHO
    	------------------------------------------------------------------------------------------------------------------------
      DBMS_OUTPUT.PUT_LINE('[INFO]: *** INSERT/UPDATE EN DD_TDE_TIPO_DESPACHO');
       
      --Comprobamos el dato a insertar
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_TDE_TIPO_DESPACHO WHERE DD_TDE_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
      --Si existe lo modificamos
      IF V_NUM_TABLAS > 0 THEN				
          
        DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
        V_MSQL := '
          UPDATE '|| V_ESQUEMA_M ||'.DD_TDE_TIPO_DESPACHO 
          SET 
            DD_TDE_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''',
            DD_TDE_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''',
					  USUARIOMODIFICAR = ''HREOS-4102'',
            FECHAMODIFICAR = SYSDATE, 
					  BORRADO = 0 
					WHERE DD_TDE_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
      ELSE
       
        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
        V_MSQL := 'SELECT '|| V_ESQUEMA_M ||'.S_DD_TDE_TIPO_DESPACHO.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
      
        V_MSQL := '
          INSERT INTO '|| V_ESQUEMA_M ||'.DD_TDE_TIPO_DESPACHO 
            (DD_TDE_ID, DD_TDE_CODIGO, DD_TDE_DESCRIPCION, DD_TDE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
          SELECT 
            '|| V_ID || ',
            '''||V_TMP_TIPO_DATA(1)||''',
            '''||V_TMP_TIPO_DATA(2)||''',
            '''||TRIM(V_TMP_TIPO_DATA(3))||''',
            0,
            ''HREOS-4102'',
            SYSDATE,
            0
          FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
      END IF;
       
      ------------------------------------------------------------------------------------------------------------------------
    	--											DES_DESPACHO_EXTERNO
    	------------------------------------------------------------------------------------------------------------------------
      DBMS_OUTPUT.PUT_LINE('[INFO]: *** INSERT EN DES_DESPACHO_EXTERNO');
        
		  V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DD_TDE_ID = (SELECT DD_TDE_ID FROM '||V_ESQUEMA_M||'.DD_TDE_TIPO_DESPACHO WHERE DD_TDE_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''')';
		  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		  -- Si existe 
		  IF V_NUM_TABLAS > 0 THEN	  
			  
        DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el DESPACHO para el DD_TDE_CODIGO '||TRIM(V_TMP_TIPO_DATA(1))||' en la tabla.');
		
      ELSE
		
			  DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(4)) ||'''');   
	      V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DES_DESPACHO_EXTERNO.NEXTVAL FROM DUAL';
	      EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
	      
        V_MSQL := '
          INSERT INTO '|| V_ESQUEMA ||'.DES_DESPACHO_EXTERNO 
            (DES_ID, DES_DESPACHO, USUARIOCREAR, FECHACREAR, BORRADO, ZON_ID, DD_TDE_ID)
	        SELECT 
            '|| V_ID || ',
            '''||V_TMP_TIPO_DATA(4)||''',
            ''HREOS-4102'',
            SYSDATE,
            0,
            (SELECT ZON_ID FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE ZON_DESCRIPCION = ''REM''),
						(SELECT DD_TDE_ID FROM '||V_ESQUEMA_M||'.DD_TDE_TIPO_DESPACHO WHERE DD_TDE_CODIGO = '''||V_TMP_TIPO_DATA(1)||''')
	        FROM DUAL';
	      EXECUTE IMMEDIATE V_MSQL;
	      DBMS_OUTPUT.PUT_LINE('[INFO]: Registro INSERTADO en DES para el DD_TDE_CODIGO: '||TRIM(V_TMP_TIPO_DATA(1))||'.');
			
	    END IF;

      ------------------------------------------------------------------------------------------------------------------------
      --                      USD_USUARIOS_DESPACHO
      ------------------------------------------------------------------------------------------------------------------------
      DBMS_OUTPUT.PUT_LINE('[INFO]: *** INSERT EN USD_USUARIOS_DESPACHOS');

      V_SQL := '
        SELECT COUNT(1) FROM '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS 
        WHERE 
          DES_ID = (SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = '''||V_TMP_TIPO_DATA(4)||''') 
          AND USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_TIPO_DATA(5)||''')
      ';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      
      IF V_NUM_TABLAS > 0 THEN    
    
        DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe la reLacion con un despacho del USU_USERNAME '||TRIM(V_TMP_TIPO_DATA(5))||' en la tabla.');
      
      ELSE
        V_MSQL := '
          INSERT INTO '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS 
            (USD_ID, DES_ID, USU_ID, USD_GESTOR_DEFECTO, USD_SUPERVISOR, USUARIOCREAR, FECHACREAR, BORRADO)
          SELECT 
            '||V_ESQUEMA||'.S_USD_USUARIOS_DESPACHOS.NEXTVAL,
            (SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = '''||V_TMP_TIPO_DATA(4)||'''),              
            (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_TIPO_DATA(5)||'''),
            1,
            1,
            ''HREOS-4102'',
            SYSDATE,
            0
          FROM DUAL
        ';    
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Registro INSERTADO en USD para el USU_USERNAME: '||TRIM(V_TMP_TIPO_DATA(5))||'.');
      
      END IF;

      ------------------------------------------------------------------------------------------------------------------------
      --                      UCA_USUARIO_CARTERA
      ------------------------------------------------------------------------------------------------------------------------
      DBMS_OUTPUT.PUT_LINE('[INFO]: *** INSERT/UPDATE EN UCA_USUARIO_CARTERA');

      V_SQL := '
        SELECT COUNT(1) FROM '||V_ESQUEMA||'.UCA_USUARIO_CARTERA 
        WHERE 
          USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(5))||''')';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      
      IF V_NUM_TABLAS > 0 THEN    
        
        V_MSQL := '
          UPDATE '||V_ESQUEMA||'.UCA_USUARIO_CARTERA
          SET 
            DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(6))||''')
          WHERE USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(5))||''')';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: Registro MODIFICADO en UCA para el USU_USERNAME: '||TRIM(V_TMP_TIPO_DATA(5))||'.');
        
      ELSE
        V_MSQL := '
          INSERT INTO '||V_ESQUEMA||'.UCA_USUARIO_CARTERA
            (UCA_ID, USU_ID, DD_CRA_ID)
          SELECT '||V_ESQUEMA||'.S_UCA_USUARIO_CARTERA.NEXTVAL, 
            (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(5))||'''),
            (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(6))||''')
          FROM DUAL
        ';
          
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Registro INSERTADO en UCA para el USU_USERNAME: '||TRIM(V_TMP_TIPO_DATA(6))||'.');
        
      END IF;

      ------------------------------------------------------------------------------------------------------------------------
      --                      TGP_TIPO_GESTOR_PROPIEDAD
      ------------------------------------------------------------------------------------------------------------------------
       DBMS_OUTPUT.PUT_LINE('[INFO]: INSERT/UPDATE EN TGP_TIPO_GESTOR_PROPIEDAD');
       
         --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TGP_TIPO_GESTOR_PROPIEDAD WHERE TGP_VALOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        -- Recuperamos el id del Tipo DE GESTOR
        V_SQL := 'SELECT DD_TGE_ID FROM '|| V_ESQUEMA_M ||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' ';
        EXECUTE IMMEDIATE V_SQL INTO V_TIPO_ID;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN        
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
          V_MSQL := '
            UPDATE '|| V_ESQUEMA ||'.TGP_TIPO_GESTOR_PROPIEDAD 
            SET 
              DD_TGE_ID = '|| V_TIPO_ID ||',
              USUARIOMODIFICAR = ''HREOS-4102'',
              FECHAMODIFICAR = SYSDATE,
              BORRADO = 0 
            WHERE TGP_VALOR = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_TGP_TIPO_GESTOR_PROPIEDAD.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID; 
        
        V_MSQL := '
          INSERT INTO '|| V_ESQUEMA ||'.TGP_TIPO_GESTOR_PROPIEDAD 
            (TGP_ID, TGP_VALOR, TGP_CLAVE, DD_TGE_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
          SELECT 
            '|| V_ID || ',
            '''||V_TMP_TIPO_DATA(1)||''',
            ''DES_VALIDOS'',
            '|| V_TIPO_ID ||',
            0,
            ''HREOS-4102'',
            SYSDATE,
            0
          FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF; 

    END LOOP;
  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('[FIN]: Tablas TGE, TDE, DES, USD, UCA  y TGP actualizadas correctamente.');
   

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



   
