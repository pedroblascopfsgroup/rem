--/*
--##########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20160907
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=HREOS-758
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en '||V_TEXT_TABLA||' los datos añadidos en T_ARRAY_DATA
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
	  
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'CCP_CARTERA_CONDIC_PRECIOS';
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('03', '01', '01', '',    '',         ''),
        T_TIPO_DATA('03', '01', '02', '',    '',         ''),
        T_TIPO_DATA('03', '01', '08', '100', '10000000', ''),
        T_TIPO_DATA('03', '01', '09', '',    '3',        ''),
        T_TIPO_DATA('03', '01', '12', '',    '',         ''),
        T_TIPO_DATA('03', '01', '13', '',    '',         ''),
        T_TIPO_DATA('03', '01', '14', '',    '',         ''),
        T_TIPO_DATA('03', '01', '15', '',    '',         ''),
        T_TIPO_DATA('03', '01', '17', '',    '2015',     ''),
        T_TIPO_DATA('03', '01', '18', '',    '',         ''),
        T_TIPO_DATA('02', '01', '01', '',    '',         ''),
        T_TIPO_DATA('02', '01', '12', '',    '',         ''),
        T_TIPO_DATA('02', '01', '13', '',    '',         ''),
        T_TIPO_DATA('02', '01', '16', '',    '',         ''),
        T_TIPO_DATA('01', '01', '12', '',    '',         ''),
        T_TIPO_DATA('01', '01', '13', '',    '',         ''),
        T_TIPO_DATA('01', '01', '16', '',    '',         ''),        
        T_TIPO_DATA('03', '02', '31', '',    '',         ''),
        T_TIPO_DATA('03', '02', '32', '',    '',         ''),  
        T_TIPO_DATA('03', '02', '33', '',    '',         ''),    
        T_TIPO_DATA('03', '02', '34', '',    '',         ''),    
        T_TIPO_DATA('03', '02', '40', '',    '',         '40'),        
        T_TIPO_DATA('02', '02', '31', '',    '',         ''),
        T_TIPO_DATA('02', '02', '39', '',    '',         '30'),
        T_TIPO_DATA('02', '02', '40', '',    '',         '150'),        
        T_TIPO_DATA('01', '02', '31', '',    '',         ''),
        T_TIPO_DATA('01', '02', '37', '',    '',         ''),
        T_TIPO_DATA('01', '02', '35', '',    '',         ''),
        T_TIPO_DATA('01', '02', '40', '',    '',         '30')           
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en CCP_CARTERA_CONDIC_PRECIOS -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
        WHERE DD_CRA_ID =(SELECT DD_CRA_ID FROM '|| V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO  = '''||TRIM(V_TMP_TIPO_DATA(1))||''') 
        AND DD_TPP_ID = (SELECT DD_TPP_ID FROM '|| V_ESQUEMA ||'.DD_TPP_TIPO_PROP_PRECIO WHERE DD_TPP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''')
        AND DD_CIP_ID = (SELECT DD_CIP_ID FROM '|| V_ESQUEMA ||'.DD_CIP_CONDIC_IND_PRECIOS WHERE DD_CIP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO CON CARTERA = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' CODIGO TPP = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' Y CODIGO CIP = '''|| TRIM(V_TMP_TIPO_DATA(3)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                    'SET CCP_MAYOR_QUE = '''||TRIM(V_TMP_TIPO_DATA(4))||''''|| 
					', CCP_MENOR_QUE = '''||TRIM(V_TMP_TIPO_DATA(5))||''''||
					', CCP_IGUAL_A = '''||TRIM(V_TMP_TIPO_DATA(6))||''''||
					', USUARIOMODIFICAR = ''HREOS-758'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_CRA_ID =(SELECT DD_CRA_ID FROM '|| V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO  = '''||TRIM(V_TMP_TIPO_DATA(1))||''') 
					AND DD_TPP_ID = (SELECT DD_TPP_ID FROM '|| V_ESQUEMA ||'.DD_TPP_TIPO_PROP_PRECIO WHERE DD_TPP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''')
					AND DD_CIP_ID = (SELECT DD_CIP_ID FROM '|| V_ESQUEMA ||'.DD_CIP_CONDIC_IND_PRECIOS WHERE DD_CIP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''')';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO CON CARTERA = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' CODIGO TPP = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' Y CODIGO CIP = '''|| TRIM(V_TMP_TIPO_DATA(3)) ||'''');
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
                      'CCP_ID, DD_CRA_ID , DD_TPP_ID, DD_CIP_ID, CCP_MAYOR_QUE, CCP_MENOR_QUE, CCP_IGUAL_A, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ',
                      (SELECT DD_CRA_ID FROM '|| V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO  = '''||TRIM(V_TMP_TIPO_DATA(1))||'''), 
					  (SELECT DD_TPP_ID FROM '|| V_ESQUEMA ||'.DD_TPP_TIPO_PROP_PRECIO WHERE DD_TPP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''),
					  (SELECT DD_CIP_ID FROM '|| V_ESQUEMA ||'.DD_CIP_CONDIC_IND_PRECIOS WHERE DD_CIP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''),
					  '''||TRIM(V_TMP_TIPO_DATA(4))||''',
					  '''||TRIM(V_TMP_TIPO_DATA(5))||''',
					  '''||TRIM(V_TMP_TIPO_DATA(6))||''',
					   0, ''HREOS-758'',SYSDATE,0 
					   FROM DUAL';
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
