--/*
--##########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20190903
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7468
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_FSP_FASE_PUBLICACION los datos añadidos en T_ARRAY_DATA
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
        T_TIPO_DATA('01', 'No aplica', 'No aplica'),
	T_TIPO_DATA('02', 'Fase 0', 'Fase 0'),
	T_TIPO_DATA('03', 'Fase I', 'Fase I'),
	T_TIPO_DATA('04', 'Fase II', 'Fase II'),
	T_TIPO_DATA('05', 'Fase III', 'Fase III'),
	T_TIPO_DATA('06', 'Clasificado', 'Clasificado'),
	T_TIPO_DATA('07', 'Devuelto', 'Devuelto'),
	T_TIPO_DATA('08', 'Fase IV', 'Fase IV'),
	T_TIPO_DATA('09', 'Fase V', 'Fase V'),
	T_TIPO_DATA('10', 'Fase VI', 'Fase VI')
    ); 


    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN   
        
        DBMS_OUTPUT.PUT_LINE('[INICIO] ');

         
    -- LOOP para insertar los valores en DD_FSP_FASE_PUBLICACION -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_FSP_FASE_PUBLICACION ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_FSP_FASE_PUBLICACION WHERE DD_FSP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN                                
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
          V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_FSP_FASE_PUBLICACION '||
                    'SET DD_FSP_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
                            , DD_FSP_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||'''
                            , USUARIOMODIFICAR = ''HREOS-7468'' , FECHAMODIFICAR = SYSDATE 
                            WHERE DD_FSP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');     
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_FSP_FASE_PUBLICACION (' ||
                      'DD_FSP_ID, DD_FSP_CODIGO, DD_FSP_DESCRIPCION, DD_FSP_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ESQUEMA ||'.S_DD_FSP_FASE_PUBLICACION.NEXTVAL DD_FSP_ID, '''||V_TMP_TIPO_DATA(1)||''', '''||TRIM(V_TMP_TIPO_DATA(2))||''', '''||TRIM(V_TMP_TIPO_DATA(3))||''', 0, ''HREOS-7468'', SYSDATE, 0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_FSP_CARTERA ACTUALIZADO CORRECTAMENTE ');
   

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



   

