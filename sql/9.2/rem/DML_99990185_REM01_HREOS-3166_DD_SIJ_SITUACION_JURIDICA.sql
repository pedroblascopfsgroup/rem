--/*
--##########################################
--## AUTOR=Gustavo Mora
--## FECHA_CREACION=20171113
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3166
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_SIJ_SITUACION_JURIDICA  los datos añadidos en T_ARRAY_DATA
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
	
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('0'	        ,'DESCONOCIDO'                                 , 'DESCONOCIDO'                                 ),
        T_TIPO_DATA('3'	        ,'ACTA'                                        , 'ACTA'                                        ),
        T_TIPO_DATA('4'	        ,'SE DESCONOCE. SIN AUTO-TITULO'               , 'SE DESCONOCE. SIN AUTO-TITULO'               ),
        T_TIPO_DATA('5'	        ,'AUTO/TITULO PTE.INCRIPCION'                  , 'AUTO/TITULO PTE.INCRIPCION'                  ),
        T_TIPO_DATA('6'	        ,'FIRME, NO NECESARIA POSESION-LANZAMIENTO'    , 'FIRME, NO NECESARIA POSESION-LANZAMIENTO'    ),
        T_TIPO_DATA('7'	        ,'FIRME PTE. POSESION'                         , 'FIRME PTE. POSESION'                         ),
        T_TIPO_DATA('8'	        ,'FIRME SEÑALADA POSESION'                     , 'FIRME SEÑALADA POSESION'                     ),
        T_TIPO_DATA('9'	        ,'FIRME CON POSESION NO NECESARIO LANZAMIENTO' , 'FIRME CON POSESION NO NECESARIO LANZAMIENTO' ),
        T_TIPO_DATA('10'	,'FIRME CON POSESION PTE. LANZAMIENTO'         , 'FIRME CON POSESION PTE. LANZAMIENTO'         ),
        T_TIPO_DATA('11'	,'FIRME CON POSESION SEÑALADO LANZAMIENTO'     , 'FIRME CON POSESION SEÑALADO LANZAMIENTO'     ),
        T_TIPO_DATA('12'	,'FIRME CON POSESION Y LANZAMIENTO'            , 'FIRME CON POSESION Y LANZAMIENTO'            ),
        T_TIPO_DATA('13'	,'FIRME Y ARRENDAMIENTO'                       , 'FIRME Y ARRENDAMIENTO'                       ),
        T_TIPO_DATA('15'	,'FIRME SIN POSIBILIDAD DE POSESION'           , 'FIRME SIN POSIBILIDAD DE POSESION'           ),
        T_TIPO_DATA('16'	,'AUTO DE ADJUDICACION PENDIENTE DE DILIGENCIA', 'AUTO DE ADJUDICACION PENDIENTE DE DILIGENCIA')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_SIJ_SITUACION_JURIDICA -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_SIJ_SITUACION_JURIDICA] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_SIJ_SITUACION_JURIDICA WHERE DD_SIJ_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_SIJ_SITUACION_JURIDICA '||
                    'SET DD_SIJ_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
					', DD_SIJ_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', USUARIOMODIFICAR = ''HREOS-3166'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_SIJ_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_SIJ_SITUACION_JURIDICA.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_SIJ_SITUACION_JURIDICA (' ||
                      'DD_SIJ_ID, DD_SIJ_CODIGO, DD_SIJ_DESCRIPCION, DD_SIJ_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''', 0, ''HREOS-3166'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_SIJ_SITUACION_JURIDICA ACTUALIZADO CORRECTAMENTE ');
   

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




   
