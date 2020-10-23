--/*
--##########################################
--## AUTOR= Lara Pablo
--## FECHA_CREACION=20200705
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-10457
--## PRODUCTO=NO
--## 
--## Finalidad: Añade en DD_TST_TIPO_SOLICITUD_TRIB los datos añadidos en T_ARRAY_DATA
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el '||V_CHARS||'ipt.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el '||V_CHARS||'ipt.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-10457';
    V_TABLA VARCHAR2(30 CHAR) := 'DD_TST_TIPO_SOLICITUD_TRIB';  -- Tabla a modificar
    V_CHARS VARCHAR2(3 CHAR) := 'TST';
	V_COUNT NUMBER(16); 
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
	T_TIPO_DATA('07' ,'Ingresos indebidos',' Ingresos indebidos')

		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	
	IF V_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO]: La tabla existe');
	    -- LOOP para insertar los valores en '''||V_TABLA||''' -----------------------------------------------------------------
	    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '''||V_TABLA||'''] ');
	    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	      LOOP
	      
	        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
	    
	        --Comprobamos el dato a insertar
	        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_'||V_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';

	        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	        
	        
		
	        --Si existe lo modificamos
	        IF V_NUM_TABLAS > 0 THEN				
	        	  
	        
	        
	          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
	       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TABLA||' '||
	                    'SET DD_'||V_CHARS||'_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
						', DD_'||V_CHARS||'_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
						', USUARIOMODIFICAR = '''||V_USUARIO||''' , FECHAMODIFICAR = SYSDATE '||
						'WHERE DD_'||V_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
	          EXECUTE IMMEDIATE V_MSQL;
	          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
	          
	       --Si no existe, lo insertamos   
	       ELSE
	       
	          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
	          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TABLA||'.NEXTVAL FROM DUAL';
	          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
	          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TABLA||' (' ||
	                      'DD_'||V_CHARS||'_ID, DD_'||V_CHARS||'_CODIGO, DD_'||V_CHARS||'_DESCRIPCION, DD_'||V_CHARS||'_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
	                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','||
	                      ' 0, '''||V_USUARIO||''',SYSDATE,0 FROM DUAL';
	          EXECUTE IMMEDIATE V_MSQL;
	          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
	        
	       END IF;
	      END LOOP;
	END IF;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '''||V_TABLA||''' ACTUALIZADO CORRECTAMENTE ');
   

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
