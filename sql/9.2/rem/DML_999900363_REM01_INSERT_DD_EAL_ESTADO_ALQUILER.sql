--/*
--##########################################
--## AUTOR=rasul Akhmeddibirov
--## FECHA_CREACION=20181005
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4473
--## PRODUCTO=NO
--## Finalidad: Script que añade datos en la tabla DD_EAL_ESTADO_ALQUILER
--##
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_EAL_ESTADO_ALQUILER'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        --          DD_EAL_CODIGO                               DD_EAL_DESCRIPCION                                  DD_EAL_DESCRIPCION_LARGA
        T_TIPO_DATA('01'	                                    ,'Libre'		                                    ,'Libre'),
        T_TIPO_DATA('02'	                                    ,'Alquilado'		                                ,'Alquilado'),
        T_TIPO_DATA('03'	                                    ,'Con demandas'		                                ,'Con demandas') 
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_MOR_MOTIVO_RECHAZO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_EAL_ESTADO_ALQUILER] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        DBMS_OUTPUT.PUT_LINE('******** DD_EAL_ESTADO_ALQUILER ********'); 
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ... Comprobaciones previas DD_EAL_ESTADO_ALQUILER');

        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_EAL_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
            DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');

       	    V_MSQL :=   'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||''                                           ||
                        'SET DD_EAL_DESCRIPCION         = '''           || TRIM(V_TMP_TIPO_DATA(2)) || ''''     || 
                        ', DD_EAL_DESCRIPCION_LARGA     = '''           || TRIM(V_TMP_TIPO_DATA(3)) || ''''     ||
                        ', USUARIOMODIFICAR             = ''HREOS-4473'''                                       || 
                        ', FECHAMODIFICAR               = SYSDATE '                                             ||
                        'WHERE DD_EAL_CODIGO            = '''           || TRIM(V_TMP_TIPO_DATA(1)) || '''';

            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
            --Si no existe, lo insertamos   
        ELSE
       
            DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');

            V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID;

            V_MSQL :=   'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' ('||
                            'DD_EAL_ID '                                    ||
                            ', DD_EAL_CODIGO '                              ||
                            ', DD_EAL_DESCRIPCION '                         ||
                            ', DD_EAL_DESCRIPCION_LARGA '                   ||
                            ', VERSION '                                    ||
                            ', USUARIOCREAR '                               ||
                            ', FECHACREAR '                                 ||
                            ', BORRADO) '                                   ||
                        'SELECT '|| V_ID || '                               
                            ,'''||TRIM(V_TMP_TIPO_DATA(1))||'''
                            ,'''||TRIM(V_TMP_TIPO_DATA(2))||'''
                            ,'''||TRIM(V_TMP_TIPO_DATA(3))||'''
                            , 0
                            , ''HREOS-4473''
                            , SYSDATE
                            , 0 
                        FROM DUAL';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_EAL_ESTADO_ALQUILER ACTUALIZADO CORRECTAMENTE ');
   

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



   
