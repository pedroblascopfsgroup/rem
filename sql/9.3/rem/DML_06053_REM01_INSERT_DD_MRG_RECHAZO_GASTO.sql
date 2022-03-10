--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20211213
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16648
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica en DD_MRG_MOTIVO_RECHAZO_GASTO los datos añadidos de T_ARRAY_DATA
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

    V_USUARIO VARCHAR2(100 CHAR):='HREOS-16648';
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_MRG_MOTIVO_RECHAZO_GASTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TRES_LETRAS_TABLA VARCHAR2(2400 CHAR) := 'MRG'; -- Vble. auxiliar para almacenar el sufijo de los campos de la tabla de ref.
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(5012);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('F61' ,'El NIF Titular carta pago no coincide con ninguno dado de alta en REM' , '1', 'WHERE AUX.NIF_TITULAR_CARTA IS NOT NULL AND NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO WHERE PRO.BORRADO = 0 AND PRO.PRO_DOCIDENTIF = AUX.NIF_TITULAR_CARTA)' )
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
			
		  	DBMS_OUTPUT.PUT_LINE('[INFO]: El registro ya existe');
          	--Si no existe, lo insertamos   

       		ELSE
       			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          		V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          		EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          		V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
                      		'DD_'||V_TRES_LETRAS_TABLA||'_ID, DD_'||V_TRES_LETRAS_TABLA||'_CODIGO, DD_'||V_TRES_LETRAS_TABLA||'_DESCRIPCION,'||
				'DD_'||V_TRES_LETRAS_TABLA||'_DESCRIPCION_LARGA, PROCESO_VALIDAR, QUERY_ITER,' ||
				' VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      		'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||SUBSTR(TRIM(V_TMP_TIPO_DATA(2)),0,100)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','||
				''''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''','||
                      		'0, '''||V_USUARIO||''',SYSDATE,0 FROM DUAL';
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