--/*
--###########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20161111
--## ARTEFACTO=ONLINE
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1147
--## PRODUCTO=NO
--## 
--## Finalidad: Creacion de GRUPOS, PERFILES PARA GESTORES FASE2
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


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
  
  -- DESPACHOS EXTERNOS
  TYPE T_TIPO_DES IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DES IS TABLE OF T_TIPO_DES;
  V_TIPO_DES T_ARRAY_DES := T_ARRAY_DES(
  --			DES_DESPACHO	TDE_TIPO_DESPACHO
      T_TIPO_DES('REMGPREC',	'GPREC'		),
      T_TIPO_DES('REMGMARK',	'GMARK'		),
      T_TIPO_DES('REMGPUBL',	'GPUBL'		),
      T_TIPO_DES('REMGCOM',		'GCOM'		),
      T_TIPO_DES('REMGFORM',	'GFORM'		),
      
      T_TIPO_DES('REMSUPPREC',	'SPREC'		),
      T_TIPO_DES('REMSUPMARK',	'SMARK'		),
      T_TIPO_DES('REMSUPPUBL',	'SPUBL'		),
      T_TIPO_DES('REMSUPCOM',	'SCOM'		),
      T_TIPO_DES('REMSUPFORM',	'SFORM'		)
  ); 
  V_TMP_TIPO_DES T_TIPO_DES;

  -- PERFILES
  TYPE T_TIPO_PEF IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_PEF IS TABLE OF T_TIPO_PEF;
  V_TIPO_PEF T_ARRAY_PEF := T_ARRAY_PEF(
		--		CODIGO	  		DESCRIPCION	 					DESCRIPCION_LARGA   
	T_TIPO_PEF('HAYAGESTPREC', 	'Gestor de precios', 			'Gestor de precios'				),
	T_TIPO_PEF('HAYAGESTMARK', 	'Gestor de marketing', 			'Gestor de marketing'			),
	T_TIPO_PEF('HAYAGESTPUBL', 	'Gestor de publicaciones', 		'Gestor de publicaciones'		),
	T_TIPO_PEF('HAYAGESTCOM',	'Gestor comercial', 			'Gestor comercial'				),
	T_TIPO_PEF('HAYAGESTFORM',	'Gestor formalización', 		'Gestor formalización'			),
	
	T_TIPO_PEF('HAYASUPPREC', 	'Supervisor de precios', 		'Supervisor de precios'			),
	T_TIPO_PEF('HAYASUPMARK', 	'Supervisor de marketing', 		'Supervisor de marketing'		),
	T_TIPO_PEF('HAYASUPPUBL', 	'Supervisor de publicaciones', 	'Supervisor de publicaciones'	),
	T_TIPO_PEF('HAYASUPCOM',	'Supervisor comercial', 		'Supervisor comercial'			),
	T_TIPO_PEF('HAYASUPFORM',	'Supervisor formalización', 	'Supervisor formalización'		)
  ); 
  V_TMP_TIPO_PEF T_TIPO_PEF;
  
  -- USUARIOS GRUPO
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
  V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		--	ENTIDAD	  USER_NAME	 PASS   	NOMBRE_USU						APELL1	APELL2	EMAIL      			GRP	 PEF_COD			DESPACHO_EXTERNO
	T_TIPO_DATA('1', 'GESTPREC', '1234', 	'Gestor de precios', 			'', 	'', 	'email@email.es' , 	'1', 'HAYAGESTPREC', 	'REMGPREC'),
	T_TIPO_DATA('1', 'GESTMARK', '1234', 	'Gestor de marketing', 			'', 	'', 	'email@email.es' , 	'1', 'HAYAGESTMARK', 	'REMGMARK'),
	T_TIPO_DATA('1', 'GESTPUBL', '1234', 	'Gestor de publicaciones', 		'', 	'', 	'email@email.es' , 	'1', 'HAYAGESTPUBL', 	'REMGPUBL'),
	T_TIPO_DATA('1', 'GESTCOM',	 '1234', 	'Gestor comercial', 			'', 	'', 	'email@email.es' , 	'1', 'HAYAGESTCOM', 	'REMGCOM'),
	T_TIPO_DATA('1', 'GESTFORM', '1234', 	'Gestor formalización', 		'', 	'', 	'email@email.es' , 	'1', 'HAYAGESTFORM', 	'REMGFORM'),
	
	T_TIPO_DATA('1', 'SUPPREC', '1234', 	'Supervisor de precios', 		'', 	'', 	'email@email.es' , 	'1', 'HAYASUPPREC', 	'REMSUPPREC'),
	T_TIPO_DATA('1', 'SUPMARK', '1234', 	'Supervisor de marketing', 		'', 	'', 	'email@email.es' , 	'1', 'HAYASUPMARK', 	'REMSUPMARK'),
	T_TIPO_DATA('1', 'SUPPUBL', '1234', 	'Supervisor de publicaciones', 	'', 	'', 	'email@email.es' , 	'1', 'HAYASUPPUBL', 	'REMSUPPUBL'),
	T_TIPO_DATA('1', 'SUPCOM',	'1234', 	'Supervisor comercial', 		'', 	'', 	'email@email.es' , 	'1', 'HAYASUPCOM', 		'REMSUPCOM'),
	T_TIPO_DATA('1', 'SUPFORM',	'1234', 	'Supervisor formalización', 	'', 	'', 	'email@email.es' , 	'1', 'HAYASUPFORM', 	'REMSUPFORM')
  ); 
  V_TMP_TIPO_DATA T_TIPO_DATA;
  
BEGIN	

 DBMS_OUTPUT.PUT_LINE('[INICIO] ');

 	 -- LOOP para insertar los valores en DES_DESPACHO_EXTERNO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DES_DESPACHO_EXTERNO] ');
     FOR I IN V_TIPO_DES.FIRST .. V_TIPO_DES.LAST
      LOOP
            V_TMP_TIPO_DES := V_TIPO_DES(I);
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = (SELECT DES_DESPACHO FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = '''||TRIM(V_TMP_TIPO_DES(1))||''')';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
			-- Si existe la FUNCION
			IF V_NUM_TABLAS > 0 THEN	  
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO...no se modifica nada.');
				
			ELSE
			
				  DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DES(1)) ||'''');   
		          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DES_DESPACHO_EXTERNO.NEXTVAL FROM DUAL';
		          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
		          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DES_DESPACHO_EXTERNO (' ||
		                      'DES_ID, DES_DESPACHO, USUARIOCREAR, FECHACREAR, BORRADO, ZON_ID, DD_TDE_ID) ' ||
		                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DES(1)||''',''REM_F2'',SYSDATE,0, ' ||
		                      '(SELECT ZON_ID FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE ZON_DESCRIPCION = ''REM''), '||
							  '(SELECT DD_TDE_ID FROM '||V_ESQUEMA_M||'.DD_TDE_TIPO_DESPACHO WHERE DD_TDE_CODIGO = '''||V_TMP_TIPO_DES(2)||''') '||
		                      'FROM DUAL';
		          EXECUTE IMMEDIATE V_MSQL;
		          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
				
		    END IF;	
      END LOOP;
  --  COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DES_DESPACHO_EXTERNO ACTUALIZADO CORRECTAMENTE ');
 
 
  -- --------------------------------------------------------------------------------------------------------------------------------------------------------
 
	-- LOOP para insertar los valores en PEF_PERFILES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN PEF_PERFILES] ');
    FOR I IN V_TIPO_PEF.FIRST .. V_TIPO_PEF.LAST
      LOOP
      
        V_TMP_TIPO_PEF := V_TIPO_PEF(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||TRIM(V_TMP_TIPO_PEF(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
       IF V_NUM_TABLAS > 0 THEN			       
         DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.PEF_PERFILES...no se modifica nada.');
         
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_PEF(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_PEF_PERFILES.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.PEF_PERFILES (' ||
                      'PEF_ID, PEF_CODIGO, PEF_DESCRIPCION, PEF_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_PEF(1)||''','''||TRIM(V_TMP_TIPO_PEF(2))||''','''||TRIM(V_TMP_TIPO_PEF(3))||''',''REM_F2'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
 --   COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: PEF_PERFILES ACTUALIZADO CORRECTAMENTE ');
 
 
 -- --------------------------------------------------------------------------------------------------------------------------------------------------------
 
   -- LOOP para insertar los valores en USU_USUARIOS, ZON_PEF_USU Y USD_USUARIOS_DESPACHOS -----------------------------------------------------------------
   FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
     LOOP
    
       V_TMP_TIPO_DATA := V_TIPO_DATA(I);
       
       -------------------------------------------------
       --Comprobamos el dato a insertar en usu_usuario--
       -------------------------------------------------
       
       DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN USU_USUARIOS ');
       
       V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
       EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
       
       --Si existe no se modifica
       IF V_NUM_TABLAS > 0 THEN				         
			
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.USU_USUARIOS...no se modifica nada.');
			
       ELSE
     
        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' EN USU_USUARIOS');   
        
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
                      '|| TRIM(V_TMP_TIPO_DATA(1)) ||',
                      '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''',
                      '''|| TRIM(V_TMP_TIPO_DATA(3)) ||''',
                      '''|| TRIM(V_TMP_TIPO_DATA(4)) ||''',
                      '''|| TRIM(V_TMP_TIPO_DATA(5)) ||''',
                      '''|| TRIM(V_TMP_TIPO_DATA(6)) ||''',
                      '''|| TRIM(V_TMP_TIPO_DATA(7)) ||''',
                      '|| TRIM(V_TMP_TIPO_DATA(8)) ||',
                      SYSDATE,
                      ''REM_F2'',
                      SYSDATE,
                      0 
                      FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
        
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' INSERTADO CORRECTAMENTE EN USU_USUARIOS');
      
       END IF;
       
       -------------------------------------------------
       --Comprobamos el dato a insertar en zon_pef_usu--
       -------------------------------------------------
        
       DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN ZON_PEF_USU '); 
        
       V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ZON_PEF_USU WHERE PEF_ID = 
						(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(9))||''') 
							AND USU_ID = 
								(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||''')';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
		-- Si existe no se modifica
		IF V_NUM_TABLAS > 0 THEN	  
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.ZON_PEF_USU...no se modifica nada.');
			
		ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' EN ZON_PEF_USU');
		
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ZON_PEF_USU' ||
					' (ZPU_ID, ZON_ID, PEF_ID, USU_ID, USUARIOCREAR, FECHACREAR, BORRADO)' || 
					' SELECT '||V_ESQUEMA||'.S_ZON_PEF_USU.NEXTVAL,' ||
					' (SELECT ZON_ID FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE ZON_DESCRIPCION = ''REM''),' ||
					' (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(9))||'''),' ||
					' (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||'''),' ||
					' ''REM_F2'',
					SYSDATE,
					0 
					FROM DUAL';
		   	
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' INSERTADO CORRECTAMENTE EN ZON_PEF_USU');
			
		END IF;
		
	   ------------------------------------------------------------
       --Comprobamos el dato a insertar en usd_usuarios_despachos--
       ------------------------------------------------------------
       
       DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN USD_USUARIOS_DESPACHOS ');
       
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS 
			WHERE DES_ID = 
				(SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO 
				WHERE DES_DESPACHO = '''||TRIM(V_TMP_TIPO_DATA(10))||''') 
				AND USU_ID = 
					(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS 
					WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||''')';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
		-- Si existe no se modifica
		IF V_NUM_TABLAS > 0 THEN	  
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS...no se modifica nada.');
			
		ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' EN USD_USUARIOS_DESPACHOS');
		
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS' ||
					' (USD_ID, DES_ID, USU_ID, USD_GESTOR_DEFECTO, USD_SUPERVISOR, USUARIOCREAR, FECHACREAR, BORRADO)' || 
					' SELECT '||V_ESQUEMA||'.S_USD_USUARIOS_DESPACHOS.NEXTVAL,' ||
					' (SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = '''||TRIM(V_TMP_TIPO_DATA(10))||'''),' ||							
					' (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||'''),' ||
					' 1,1,''REM_F2'',SYSDATE,0 FROM DUAL';
		  	
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' INSERTADO CORRECTAMENTE EN USD_USUARIOS_DESPACHOS');
			
		END IF;	
		
		
	   ---------------------------------------------------------
       --Comprobamos el dato a insertar en gru_grupos_usuarios--
       ---------------------------------------------------------
       
       DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN GRU_GRUPOS_USUARIOS ');	
	   
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.GRU_GRUPOS_USUARIOS
			WHERE USU_ID_USUARIO = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||''')
			AND USU_ID_GRUPO = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||''')';
		
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		-- Si existe no se modifica
		IF V_NUM_TABLAS > 0 THEN	  
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.GRU_GRUPOS_USUARIOS...no se modifica nada.');
		ELSE
		
			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' EN GRU_GRUPOS_USUARIOS');
			
			V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.GRU_GRUPOS_USUARIOS
				(GRU_ID, USU_ID_GRUPO, USU_ID_USUARIO, USUARIOCREAR, FECHACREAR, BORRADO) 
				SELECT '||V_ESQUEMA_M||'.S_GRU_GRUPOS_USUARIOS.NEXTVAL,
				(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||'''),
				(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||'''),
				''REM_F2'',SYSDATE,	0 FROM DUAL';
				
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' INSERTADO CORRECTAMENTE EN GRU_GRUPOS_USUARIOS');
			
		END IF;

	   DBMS_OUTPUT.PUT_LINE('');
       
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
