--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20190902
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7494
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ACT_PRO_PROPIETARIO los datos añadidos en T_ARRAY_DATA
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

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA(NULL, NULL, NULL, '2', 'Remaining', NULL, NULL, NULL, NULL, NULL, '16'),
        T_TIPO_DATA(NULL, NULL, NULL, '2', 'Arrow', NULL, NULL, NULL, NULL, NULL, '16')
    ); 


    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN   
        
        DBMS_OUTPUT.PUT_LINE('[INICIO] ');

         
    -- LOOP para insertar los valores en ACT_PRO_PROPIETARIO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN ACT_PRO_PROPIETARIO ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA(5))||'''';
        DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN                                

          DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE EL REGISTRO');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');     
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO (' ||
                      'PRO_ID, DD_LOC_ID, DD_PRV_ID, PRO_CODIGO_UVEM, DD_TPE_ID, PRO_NOMBRE, DD_TDI_ID, PRO_DOCIDENTIF
                      , PRO_DIR, PRO_TELF, PRO_PAGA_EJECUTANTE, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_CRA_ID) ' ||
                      'SELECT '|| V_ESQUEMA ||'.S_ACT_PRO_PROPIETARIO.NEXTVAL PRO_ID, '''||V_TMP_TIPO_DATA(1)||''', '''||V_TMP_TIPO_DATA(2)||''', '''||TRIM(V_TMP_TIPO_DATA(3))||''', (SELECT DD_TPE_ID FROM '||V_ESQUEMA_M||'.DD_TPE_TIPO_PERSONA WHERE DD_TPE_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||'''), '''||TRIM(V_TMP_TIPO_DATA(5))||''', '''||TRIM(V_TMP_TIPO_DATA(6))||''', '''||TRIM(V_TMP_TIPO_DATA(7))||''', '''||TRIM(V_TMP_TIPO_DATA(8))||''', '''||TRIM(V_TMP_TIPO_DATA(9))||''', '''||TRIM(V_TMP_TIPO_DATA(10))||''', 0, ''HREOS-7494'', SYSDATE, 0, (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(11))||''') FROM DUAL';
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO ACT_PRO_PROPIETARIO ACTUALIZADO CORRECTAMENTE ');
   

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



   
