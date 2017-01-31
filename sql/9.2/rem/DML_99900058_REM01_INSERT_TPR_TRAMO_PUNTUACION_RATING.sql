--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20170124
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1333
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en TPR_TRAMO_PUNTUACION_RATING los datos añadidos en T_ARRAY_DATA
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
                  --DD_RTG_CODIGO   -- VALOR DESDE         -- VALOR HASTA
        T_TIPO_DATA('01',           '1101'	               	,'1200'		),
        T_TIPO_DATA('02',           '1001'                 	,'1100'     ),
        T_TIPO_DATA('03',           '901'                 	,'1000'     ),
        T_TIPO_DATA('04',           '801'                 	,'900'      ),
        T_TIPO_DATA('05',           '701'                 	,'800'      ),
        T_TIPO_DATA('06',           '601'                 	,'700'      ),
        T_TIPO_DATA('07',           '501'                 	,'600'      ),
        T_TIPO_DATA('08',           '401'                 	,'500'      ),
        T_TIPO_DATA('09',           '301'                 	,'400'      ),
        T_TIPO_DATA('10',           '0'                 	,'300'      )
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_SDE_SUBTIPO_DOC_EXP -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN TPR_TRAMO_PUNTUACION_RATING ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TPR_TRAMO_PUNTUACION_RATING TPR INNER JOIN DD_RTG_RATING_ACTIVO RTG ON TPR.DD_RTG_ID = RTG.DD_RTG_ID ' ||
        ' WHERE DD_RTG_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.TPR_TRAMO_PUNTUACION_RATING '||
                    'SET TPR_VALOR_DESDE =  '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
          			', TPR_VALOR_HASTA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''|| 
					', USUARIOMODIFICAR = ''DML_F2'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_RTG_ID = (SELECT DD_RTG_ID FROM '||V_ESQUEMA||'.DD_RTG_RATING_ACTIVO WHERE DD_RTG_CODIGO = '''||V_TMP_TIPO_DATA(1)||''') ';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_TPR_TRAMO_PUNTUACION_RATING.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.TPR_TRAMO_PUNTUACION_RATING (' ||
                      'TPR_ID, DD_RTG_ID, TPR_VALOR_DESDE, TPR_VALOR_HASTA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID ||
                       ', (SELECT DD_RTG_ID FROM '||V_ESQUEMA||'.DD_RTG_RATING_ACTIVO WHERE DD_RTG_CODIGO = '''||V_TMP_TIPO_DATA(1)||''') '||
                       ','''||V_TMP_TIPO_DATA(2)||''' '||
                       ','''||TRIM(V_TMP_TIPO_DATA(3))||''' '||
                       ', 0, ''DML_F2'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA TPR_TRAMO_PUNTUACION_RATING ACTUALIZADO CORRECTAMENTE ');
   

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



   
