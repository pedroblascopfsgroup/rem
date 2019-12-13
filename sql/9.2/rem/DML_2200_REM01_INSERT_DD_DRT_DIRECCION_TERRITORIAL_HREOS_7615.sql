--/*
--##########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20190925
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7615
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_DRT_DIRECCION_TERRITORIAL los datos añadidos en T_ARRAY_DATA
--## INSTRUCCIONES: Lanzar, con cuidado de que no se rompa.
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

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('01', 'Norte', 'Norte'),
		T_TIPO_DATA('02', 'Sur', 'Sur'),
		T_TIPO_DATA('03', 'Cataluña', 'Cataluña'),
		T_TIPO_DATA('04', 'Noroeste', 'Noroeste'),
		T_TIPO_DATA('05', 'Sureste', 'Sureste'),
		T_TIPO_DATA('06', 'Canarias', 'Canarias'),
		T_TIPO_DATA('07', 'Centro', 'Centro')
    ); 


    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN   
        
        DBMS_OUTPUT.PUT_LINE('[INICIO] ');

         
    -- LOOP para insertar los valores en DD_DRT_DIRECCION_TERRITORIAL -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_DRT_DIRECCION_TERRITORIAL ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_DRT_DIRECCION_TERRITORIAL WHERE DD_DRT_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN                                
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
          V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_DRT_DIRECCION_TERRITORIAL '||
                    'SET DD_DRT_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
                            , DD_DRT_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||'''
                            , USUARIOMODIFICAR = ''HREOS-7615'' , FECHAMODIFICAR = SYSDATE 
                            WHERE DD_DRT_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');     
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_DRT_DIRECCION_TERRITORIAL (' ||
                      'DD_DRT_ID, DD_DRT_CODIGO, DD_DRT_DESCRIPCION, DD_DRT_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ESQUEMA ||'.S_DD_DRT_DIRECCION_TERRITORIAL.NEXTVAL DD_DRT_ID, '''||V_TMP_TIPO_DATA(1)||''', '''||TRIM(V_TMP_TIPO_DATA(2))||''', '''||TRIM(V_TMP_TIPO_DATA(3))||''', 0, ''HREOS-7615'', SYSDATE, 0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_DRT_DIRECCION_TERRITORIAL ACTUALIZADO CORRECTAMENTE ');
   

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



   

