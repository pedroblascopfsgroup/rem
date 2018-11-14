--/*
--##########################################
--## AUTOR=DANIEL ALGABA
--## FECHA_CREACION=20180425
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3890
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en TMP_MAPEO_PUB_VENTA los datos añadidos en T_ARRAY_DATA
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
        T_TIPO_DATA('01', '03', 1, 0, 0, 0, '01', NULL, NULL),
        T_TIPO_DATA('02', '03', 1, 0, 0, 0, '02', NULL, NULL),
        T_TIPO_DATA('03', '04', 1, 1, 0, 0, NULL, '12', 'Migración'),
        T_TIPO_DATA('04', '03', 1, 0, 1, 0, NULL, NULL, NULL),
        T_TIPO_DATA('05', '04', 1, 1, 0, 0, NULL, NULL, NULL),
        T_TIPO_DATA('06', '04', 1, 1, 0, 0, NULL, '12', 'Migración'),
        T_TIPO_DATA('07', '03', 1, 0, 1, 0, '02', NULL, NULL)
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en TMP_MAPEO_PUB_VENTA -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN TMP_MAPEO_PUB_VENTA');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TMP_MAPEO_PUB_VENTA WHERE DD_EPU_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
          V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.TMP_MAPEO_PUB_VENTA '||
                    'SET DD_EPV_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''''||
                    ', APU_CHECK_PUBLICAR_V = '''||TRIM(V_TMP_TIPO_DATA(3))||''''|| 
                    ', APU_CHECK_OCULTAR_V = '''||TRIM(V_TMP_TIPO_DATA(4))||''''||
                    ', APU_CHECK_OCULT_PRECIO_V = '''||TRIM(V_TMP_TIPO_DATA(5))||''''||
                    ', APU_CHECK_PUB_SIN_PRECIO_V = '''||TRIM(V_TMP_TIPO_DATA(6))||''''||
                    ', DD_TPU_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(7))||''''||
                    ', DD_MTO_V_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(8))||''''||
                    ', MTO_OCULTACION = '''||TRIM(V_TMP_TIPO_DATA(9))||''''||
                    ' WHERE DD_EPU_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO  '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.TMP_MAPEO_PUB_VENTA (DD_EPU_CODIGO, DD_EPV_CODIGO, APU_CHECK_PUBLICAR_V, APU_CHECK_OCULTAR_V, APU_CHECK_OCULT_PRECIO_V, APU_CHECK_PUB_SIN_PRECIO_V, DD_TPU_CODIGO, DD_MTO_V_CODIGO, MTO_OCULTACION)'|| 
          'VALUES ('''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''','''||TRIM(V_TMP_TIPO_DATA(5))||''','''||TRIM(V_TMP_TIPO_DATA(6))||''','''||TRIM(V_TMP_TIPO_DATA(7))||''','''||TRIM(V_TMP_TIPO_DATA(8))||''','''||TRIM(V_TMP_TIPO_DATA(9))||''')';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO TMP_MAPEO_PUB_VENTA ACTUALIZADO CORRECTAMENTE ');
   

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
