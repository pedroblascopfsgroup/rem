--/*
--##########################################
--## AUTOR=Sonia Garcia
--## FECHA_CREACION=20190315
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5823
--## PRODUCTO=NO
--## Finalidad: Insertar usernames de GTOPOSTV con 07 y GTOPLUS con 06 en DD_GRF_GESTORIA_RECEP_FICH.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE


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

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_GRF_GESTORIA_RECEP_FICH'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TRES_LETRAS_TABLA VARCHAR2(2400 CHAR) := 'GRF'; -- Vble. auxiliar para almacenar el sufijo de los campos de la tabla de ref.
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(

------------DD_GRF_CODIGO----USERNAME_GTOPOSTV-----USERNAME_GTOPLUS

	T_TIPO_DATA('4',	'pinos07',	'pinos06'),  
	T_TIPO_DATA('3',	'uniges07',	'uniges06'),    
	T_TIPO_DATA('2',	'montalvo07',	'montalvo06'),
	T_TIPO_DATA('1',	'gl07',		'gl06'),
	T_TIPO_DATA('5',	'garsa07',	'garsa06'),
	T_TIPO_DATA('6',	'ogf07',	'ogf06'),
	T_TIPO_DATA('8',	'diagonal07',	'diagonal06'),
	T_TIPO_DATA('9',	'cenahi07' ,	'cenahi06'),
	T_TIPO_DATA('10',	'tinsacer07' ,	'tinsacer06'),
	T_TIPO_DATA('7',	'tecnotra07' ,	'tecnotra06'),
	T_TIPO_DATA('11',	'maretra07' ,	'maretra06'),
	T_TIPO_DATA('12',	'qipert07' ,	'qipert06'),
	T_TIPO_DATA('13',	'mediterraneo07','mediterraneo06'),
	T_TIPO_DATA('14',	'gestinova07' ,	'gestinova06'),
	T_TIPO_DATA('15',	'emais07',	'emais06'),
	T_TIPO_DATA('16',	'f&g07',	'f&g06' )
		

); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
	-- LOOP para insertar los valores en la tabla indicada
    	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA||'] ');
    	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      	LOOP
             	V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
	        --Comprobamos el dato a insertar
        	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_'||V_TRES_LETRAS_TABLA||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
	        --Si existe lo modificamos
        	IF V_NUM_TABLAS > 0 THEN				
			DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
	       	  	V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
		        		'SET USERNAME_GTOPOSTV = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''''||
					', USERNAME_GTOPLUS = '''|| TRIM(V_TMP_TIPO_DATA(3)) ||''''||
					', USUARIOMODIFICAR = ''HREOS-5823'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_'||V_TRES_LETRAS_TABLA||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
		  	EXECUTE IMMEDIATE V_MSQL;
		  	DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          	--Si no existe, lo insertamos   
       		ELSE
       			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          		V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          		EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          		V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
                      		'DD_'||V_TRES_LETRAS_TABLA||'_ID, DD_'||V_TRES_LETRAS_TABLA||'_CODIGO, USERNAME_GTOPOSTV, USERNAME_GTOPLUS, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      		'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''', 0, ''HREOS-5823'',SYSDATE,0 FROM DUAL';
			DBMS_OUTPUT.PUT_LINE(V_MSQL);
          		EXECUTE IMMEDIATE V_MSQL;
          		DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        	END IF;
      	END LOOP;
    	
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');
   
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

