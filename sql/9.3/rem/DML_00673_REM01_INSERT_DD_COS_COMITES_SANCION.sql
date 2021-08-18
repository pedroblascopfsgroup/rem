--/*
--##########################################
--## AUTOR=Alejandro Valverde
--## FECHA_CREACION=20210817
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14914
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_COS_COMITES_SANCION los datos añadidos en T_ARRAY_DATA
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
    V_TABLA_DD_COS VARCHAR2(25 CHAR):= 'DD_COS_COMITES_SANCION';
    V_TABLA_DD_CRA VARCHAR2(25 CHAR):= 'DD_CRA_CARTERA';
    V_TABLA_DD_SCR VARCHAR2(25 CHAR):= 'DD_SCR_SUBCARTERA';
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-14914';
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    -- DD_COS_CODIGO  DD_COS_DESCRIPCION  DD_COS_DESCRIPCION_LARGA  DD_CRA_CODIGO   DD_SCR_CODIGO
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('49', 'HRE',  'HRE',  '17', '69'),
        T_TIPO_DATA('50', 'BFA', 'BFA', '17', '69')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_SCR_SUBCARTERA -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '|| V_TABLA_DD_COS ||' ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'|| V_TABLA_DD_COS ||' WHERE DD_COS_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'|| V_TABLA_DD_COS ||' '||
                    'SET DD_COS_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
					', DD_COS_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', USUARIOMODIFICAR = '''||TRIM(V_ITEM)||''' , FECHAMODIFICAR = SYSDATE '||
					', DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.'|| V_TABLA_DD_CRA ||' WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||''') '||
         			', DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.'|| V_TABLA_DD_SCR ||' WHERE DD_SCR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(5))||''') '||
					'WHERE DD_COS_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'|| V_TABLA_DD_COS ||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'|| V_TABLA_DD_COS ||' (' ||
                      'DD_COS_ID, DD_COS_CODIGO, DD_COS_DESCRIPCION, DD_COS_DESCRIPCION_LARGA, DD_CRA_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_SCR_ID) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','||
                      '(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.'|| V_TABLA_DD_CRA ||' WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||'''), 0, '''||TRIM(V_ITEM)||''',SYSDATE,0, (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.'|| V_TABLA_DD_SCR ||' WHERE DD_SCR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(5))||''') FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '|| V_TABLA_DD_COS ||' MODIFICADO CORRECTAMENTE ');
   

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
