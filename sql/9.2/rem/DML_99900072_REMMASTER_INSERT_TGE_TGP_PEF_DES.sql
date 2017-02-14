--/*
--##########################################
--## AUTOR=DANIEL GUTIÉRREZ
--## FECHA_CREACION=20170209
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1489
--## PRODUCTO=NO
--##
--## Finalidad: Crea tipos de gestor, tgp, des y pef
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

    ------------------------------------------------------------------------------------------------------------------------
    -- GESTORES/SUPERVISORES. Este array sirve para: DD_TGE_TIPO_GESTOR, DD_TDE_TIPO_DESPACHO y TGP_TIPO_GESTOR_PROPIEDAD
    ------------------------------------------------------------------------------------------------------------------------ 
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    --				CODIGO		DESCRIPCION									DESCRIPCION_LARGA
    	T_TIPO_DATA('GIAADMT'	,'Gestoría de administración'				,'Gestoría de administración'		)
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    ------------------------------------------------------------------------------------------------------------------------ 
    
     -- DESPACHOS EXTERNOS
	TYPE T_TIPO_DES IS TABLE OF VARCHAR2(150);
	TYPE T_ARRAY_DES IS TABLE OF T_TIPO_DES;
	V_TIPO_DES T_ARRAY_DES := T_ARRAY_DES(
	--				DES_DESPACHO	TDE_TIPO_DESPACHO
	    T_TIPO_DES('REMGIAADMT',	'GIAADMT'		)
	); 
	V_TMP_TIPO_DES T_TIPO_DES;
	
	-- PERFILES
	TYPE T_TIPO_PEF IS TABLE OF VARCHAR2(150);
	TYPE T_ARRAY_PEF IS TABLE OF T_TIPO_PEF;
	V_TIPO_PEF T_ARRAY_PEF := T_ARRAY_PEF(
	--				CODIGO	  			DESCRIPCION	 						DESCRIPCION_LARGA   
		T_TIPO_PEF('HAYAGESTADMT', 		'Gestoría de administración',		'Gestoría de administración'		)
	); 
	V_TMP_TIPO_PEF T_TIPO_PEF;
	  
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_TGE_TIPO_GESTOR -----------------------------------------------------------------

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    	------------------------------------------------------------------------------------------------------------------------
    	--											DD_TGE_TIPO_GESTOR
    	------------------------------------------------------------------------------------------------------------------------
    	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERT/UPDATE EN DD_TGE_TIPO_GESTOR');
    	
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA_M ||'.DD_TGE_TIPO_GESTOR '||
                    'SET DD_TGE_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
					', DD_TGE_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', USUARIOMODIFICAR = ''REM_F2'' , FECHAMODIFICAR = SYSDATE '||
					', BORRADO = 0 '||
					'WHERE DD_TGE_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA_M ||'.S_DD_TGE_TIPO_GESTOR.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.DD_TGE_TIPO_GESTOR (' ||
                      'DD_TGE_ID, DD_TGE_CODIGO, DD_TGE_DESCRIPCION, DD_TGE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''' ,'''||V_TMP_TIPO_DATA(2)||''','''||TRIM(V_TMP_TIPO_DATA(3))||''', 0, ''REM_F2'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
       
       
       	------------------------------------------------------------------------------------------------------------------------
    	--											DD_TDE_TIPO_DESPACHO
    	------------------------------------------------------------------------------------------------------------------------
       DBMS_OUTPUT.PUT_LINE('[INFO]: INSERT/UPDATE EN DD_TDE_TIPO_DESPACHO');
       
       	 --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_TDE_TIPO_DESPACHO WHERE DD_TDE_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA_M ||'.DD_TDE_TIPO_DESPACHO '||
                    'SET DD_TDE_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
					', DD_TDE_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', USUARIOMODIFICAR = ''REM_F2'' , FECHAMODIFICAR = SYSDATE '||
					', BORRADO = 0 '||
					'WHERE DD_TDE_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA_M ||'.S_DD_TDE_TIPO_DESPACHO.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.DD_TDE_TIPO_DESPACHO (' ||
                      'DD_TDE_ID, DD_TDE_CODIGO, DD_TDE_DESCRIPCION, DD_TDE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''' ,'''||V_TMP_TIPO_DATA(2)||''','''||TRIM(V_TMP_TIPO_DATA(3))||''', 0, ''REM_F2'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
       
       	------------------------------------------------------------------------------------------------------------------------
    	--											TGP_TIPO_GESTOR_PROPIEDAD
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
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.TGP_TIPO_GESTOR_PROPIEDAD '||
                    'SET DD_TGE_ID = '|| V_TIPO_ID ||' '|| 
					', USUARIOMODIFICAR = ''REM_F2'' , FECHAMODIFICAR = SYSDATE '||
					', BORRADO = 0 '||
					'WHERE TGP_VALOR = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_TGP_TIPO_GESTOR_PROPIEDAD.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.TGP_TIPO_GESTOR_PROPIEDAD (' ||
                      'TGP_ID, TGP_VALOR, TGP_CLAVE, DD_TGE_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''' ,''DES_VALIDOS'','|| V_TIPO_ID ||', 0, ''REM_F2'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
       
    END LOOP;

  	------------------------------------------------------------------------------------------------------------------------
	--										 		DES_DESPACHO_EXTERNO
	------------------------------------------------------------------------------------------------------------------------
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
 
 
	------------------------------------------------------------------------------------------------------------------------
	--												PEF_PERFILES
	------------------------------------------------------------------------------------------------------------------------
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
    DBMS_OUTPUT.PUT_LINE('[FIN]: PEF_PERFILES ACTUALIZADO CORRECTAMENTE ');
 

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



   