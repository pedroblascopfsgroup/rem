--/*
--##########################################
--## AUTOR=GMN
--## FECHA_CREACION=20180425
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=swat-2.0.16-180319-rem
--## INCIDENCIA_LINK=REMVIP-596
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_SEG_SUBTIPO_ERROR_GASTO los tipos de error definidos en gestorias 
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Gustavo Mora: quitamos letra a códigos subtipo gasto
--##        0.3 Diego Crespo: Añadimos códigos nuevos al subtipo '04' 
--##        0.4 Joaquin Arnal: Actualizamos codigos del tipo 03
--##        0.5 Gustavo Mora: Añadimos códigos nuevos al subtipo '03' 
--##        0.6 Daniel Albert: Añadimos error 405
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
    V_NUM_TIPO   NUMBER(16); -- Vble. para validar la existencia de la tabla de tipos.    
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_TEG_ID NUMBER(16);
    V_TEXT_TABLA VARCHAR2(40 CHAR) := 'DD_SEG_SUBTIPO_ERROR_GASTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TRES_LETRAS_TABLA VARCHAR2(10 CHAR) := 'SEG'; -- Vble. auxiliar para almacenar el sufijo de los campos de la tabla de ref.
    V_TEXT_TABLA_AUX VARCHAR2(40 CHAR) := 'DD_TEG_TIPO_ERROR_GASTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TRES_LETRAS_TABLA_AUX VARCHAR2(10 CHAR) := 'TEG'; -- Vble. auxiliar para almacenar el sufijo de los campos de la tabla de ref. aux
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(250);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
          T_TIPO_DATA('04' , '85' , '85 - Gasto NO autorizado  (EL GASTO CORRESPONDE AL CLIENTE)' , 'Gasto NO autorizado  (EL GASTO CORRESPONDE AL CLIENTE)' )
  , T_TIPO_DATA('04' , '86' , '86 - Gasto NO autorizado (GASTO PLUSVALIA, NO CORRESPONDE)' , 'Gasto NO autorizado (GASTO PLUSVALIA, NO CORRESPONDE)' )
  , T_TIPO_DATA('04' , '87' , '87 - Gasto NO autorizado (GASTO CORRESPONDE AL CLIENTE -VENTA EXTERNA)' , 'Gasto NO autorizado (GASTO CORRESPONDE AL CLIENTE -VENTA EXTERNA)' )
  , T_TIPO_DATA('04' , '88' , '88 - Gasto NO autorizado (GASTO PLUSVALIA, NO CORRESPONDE - VENTA EXTERNA)' , 'Gasto NO autorizado (GASTO PLUSVALIA, NO CORRESPONDE - VENTA EXTERNA)' )
  , T_TIPO_DATA('04' , '99' , '99 - Gasto descartado por duplicidad' , 'Gasto descartado por duplicidad' )
  , T_TIPO_DATA('04' , '400' , '400 - Error en líneas de factura' , 'Error en líneas de factura' ) 
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
                V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_'||V_TRES_LETRAS_TABLA||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''' ||
                        ' AND DD_'||V_TRES_LETRAS_TABLA_AUX||'_ID  = (SELECT DD_'||V_TRES_LETRAS_TABLA_AUX||'_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX||' WHERE DD_'||V_TRES_LETRAS_TABLA_AUX||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''')';

                EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
                --Si existe lo modificamos
                IF V_NUM_TABLAS > 0 THEN                                
                        DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');

                        V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                                        'SET DD_'||V_TRES_LETRAS_TABLA||'_DESCRIPCION = SUBSTR('''||TRIM(V_TMP_TIPO_DATA(3))||''',1, 20)'|| 
                                        ', DD_'||V_TRES_LETRAS_TABLA||'_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(4))||''''||
                                        ', USUARIOMODIFICAR = ''REMVIP-596'' , FECHAMODIFICAR = SYSDATE '||
                                        ', USUARIOBORRAR = null , FECHABORRAR = null, BORRADO = 0 '||
                                        'WHERE DD_'||V_TRES_LETRAS_TABLA||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''''||
                                        ' AND DD_'||V_TRES_LETRAS_TABLA_AUX||'_ID  = (SELECT DD_'||V_TRES_LETRAS_TABLA_AUX||'_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX||' WHERE DD_'||V_TRES_LETRAS_TABLA_AUX||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''')';
         
                        EXECUTE IMMEDIATE V_MSQL;

                        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE. [DD_'||V_TRES_LETRAS_TABLA_AUX||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''', DD_'||V_TRES_LETRAS_TABLA||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''']');

                --Si no existe, lo insertamos   
                ELSE
                        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');   

                        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
                        EXECUTE IMMEDIATE V_MSQL INTO V_ID;
        
                        V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
                        'DD_'||V_TRES_LETRAS_TABLA||'_ID, DD_'||V_TRES_LETRAS_TABLA_AUX||'_ID, DD_'||V_TRES_LETRAS_TABLA||'_CODIGO, DD_'||V_TRES_LETRAS_TABLA||'_DESCRIPCION, DD_'||V_TRES_LETRAS_TABLA||'_DESCRIPCION_LARGA,' ||
                        'VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                        'SELECT ' || V_ID || ','||
                        '(SELECT DD_'||V_TRES_LETRAS_TABLA_AUX||'_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX||' WHERE DD_'||V_TRES_LETRAS_TABLA_AUX||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''')'||                         

                                ','''||TRIM(V_TMP_TIPO_DATA(2))||''',SUBSTR('''||TRIM(V_TMP_TIPO_DATA(3))||''', 1, 20) ,'''||TRIM(V_TMP_TIPO_DATA(4))||''',' ||
                                '0, ''REMVIP-596'',SYSDATE,0 FROM DUAL';
                        EXECUTE IMMEDIATE V_MSQL;
                        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE. [DD_'||V_TRES_LETRAS_TABLA_AUX||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''', DD_'||V_TRES_LETRAS_TABLA||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''']');

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

EXIT;

