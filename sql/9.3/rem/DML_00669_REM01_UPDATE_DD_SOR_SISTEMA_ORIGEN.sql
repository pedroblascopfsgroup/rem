--/*
--##########################################
--## AUTOR=Alejandro Valverde
--## FECHA_CREACION=20210908
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14860
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade los datos del array en DD_SOR_SISTEMA_ORIGEN
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
    V_NUM_TABLAS2 NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_ID NUMBER(16);
    V_TABLA_DD VARCHAR2(2400 CHAR) := 'DD_SOR_SISTEMA_ORIGEN'; -- Vble. auxiliar para almacenar el nombre de la tabla diccionario.
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
	T_TIPO_DATA('03','REM','REM'),
	T_TIPO_DATA('04','WCOM','WEBCOM'),
	T_TIPO_DATA('05','HAYA HOME','HAYA HOME')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
   
BEGIN	
	
    -- LOOP para insertar los valores en DD_SOR_SISTEMA_ORIGEN
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA_DD||'] ');
	    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	      LOOP
	      
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);
	    
		--Comprobamos el dato a insertar
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_DD||' WHERE DD_SOR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		--Si existe lo notificamos
		IF V_NUM_TABLAS > 0 THEN				
		  
		  	DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO CON CODIGO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' EN LA TABLA '||V_TABLA_DD||' YA EXISTE');
		  
	       --Si no existe, lo insertamos   
	       ELSE
	       
		  DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
		  V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TABLA_DD||'.NEXTVAL FROM DUAL';
		  EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
		  V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TABLA_DD||' (' ||
		              'DD_SOR_ID, DD_SOR_CODIGO, DD_SOR_DESCRIPCION, DD_SOR_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
		              'SELECT '|| V_ID || ', '''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''', 0, ''HREOS-14860'',SYSDATE,0 FROM DUAL';
		  EXECUTE IMMEDIATE V_MSQL;
		  DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS INSERTADO CORRECTAMENTE EN LA TABLA '||V_TABLA_DD||'');
		
	       END IF;
	      END LOOP;
	DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_SOR_SISTEMA_ORIGEN_CARGA ACTUALIZADO CORRECTAMENTE ');

  COMMIT;
   

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line(V_MSQL);
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
