--/*
--##########################################
--## AUTOR=Mariam Lliso
--## FECHA_CREACION=20190325
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=v2.9.0-rem
--## INCIDENCIA_LINK=HREOS-5925
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_ETF_ENTIDAD_FINANCIERA los datos añadidos en T_ARRAY_DATA
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
	
    V_TXT VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16); 

    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        ------------COD---DESCRIPCIÓN-----DESCRIPCIÓN LARGA
        T_TIPO_DATA('01', 'Bankia',       'Bankia'),
        T_TIPO_DATA('02', 'Cajamar',      'Cajamar'),
        T_TIPO_DATA('03', 'Liberbank',    'Liberbank'),
        T_TIPO_DATA('04', 'Santander',    'Santander'),
        T_TIPO_DATA('05', 'BBVA',         'BBVA'),
        T_TIPO_DATA('06', 'ING',          'ING'),
        T_TIPO_DATA('07', 'Otra entidad', 'Otra entidad')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_ETF_ENTIDAD_FINANCIERA -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION DE DATOS EN DD_ETF_ENTIDAD_FINANCIERA] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ETF_ENTIDAD_FINANCIERA WHERE DD_ETF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');

       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_ETF_ENTIDAD_FINANCIERA '                 ||
                    'SET DD_ETF_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''         ||
                    ',  DD_ETF_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''    ||
                    ',  USUARIOMODIFICAR = ''HREOS-5925'' , FECHAMODIFICAR = SYSDATE '    ||
                    '   WHERE DD_ETF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');

          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_ETF_ENTIDAD_FINANCIERA.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;

          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_ETF_ENTIDAD_FINANCIERA ('  ||
                      'DD_ETF_ID, DD_ETF_CODIGO, DD_ETF_DESCRIPCION, DD_ETF_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) '  ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''', 0, ''HREOS-5925'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_ETF_ENTIDAD_FINANCIERA ACTUALIZADO CORRECTAMENTE ');
   

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