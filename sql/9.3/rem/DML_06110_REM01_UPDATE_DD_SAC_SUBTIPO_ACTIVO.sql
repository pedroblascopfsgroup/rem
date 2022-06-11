--/*
--##########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20210606
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11506
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_SAC_SUBTIPO_ACTIVO nuevos registros
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
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_SAC_SUBTIPO_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      -- 					TIPO ACTIVO(DD_TPA_CODIGO),   		SUBTIPO(DD_SAC_CODIGO),  			DESCRIPCION,  			         DESCRIPCION LARGA          DD_SAC_EN_BBVA
		T_TIPO_DATA(			'07',								'40',							'Apartamento Turístico',		'Apartamento Turístico',            1)
       
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    --Comprobamos que la tabla existe---
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS > 0 THEN

        -- LOOP para insertar los valores en DD_SAC_SUBTIPO_ACTIVO -----------------------------------------------------------------
        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_SAC_SUBTIPO_ACTIVO] ');
        FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
        
            V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
            --Comprobamos el dato a insertar
            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO WHERE DD_SAC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
            --Si existe lo modificamos
            IF V_NUM_TABLAS > 0 THEN				
            
            DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
            V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_SAC_SUBTIPO_ACTIVO '||
                        'SET DD_SAC_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(3))||''''|| 
                        ', DD_SAC_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(4))||''''||
                        ', DD_SAC_EN_BBVA = '''||TRIM(V_TMP_TIPO_DATA(5))||''''||
                        ', USUARIOMODIFICAR = ''REMVIP-11506'' , FECHAMODIFICAR = SYSDATE '||
                        'WHERE DD_SAC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
            
        --Si no existe, lo insertamos   
        ELSE
        
            DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');   
            V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_SAC_SUBTIPO_ACTIVO.NEXTVAL FROM DUAL';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
            V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_SAC_SUBTIPO_ACTIVO (' ||
                        'DD_SAC_ID, DD_TPA_ID, DD_SAC_CODIGO, DD_SAC_DESCRIPCION, DD_SAC_DESCRIPCION_LARGA, DD_SAC_EN_BBVA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES' ||
                        '('|| V_ID || ',
                        (SELECT DD_TPA_ID FROM '||V_ESQUEMA ||'.DD_TPA_TIPO_ACTIVO WHERE DD_TPA_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''),
                        '''||TRIM(V_TMP_TIPO_DATA(2))||''',
                        '''||TRIM(V_TMP_TIPO_DATA(3))||''',
                        '''||TRIM(V_TMP_TIPO_DATA(4))||''',
                        '''||TRIM(V_TMP_TIPO_DATA(5))||''',
                        0, ''HREOS-12185'',SYSDATE,0 )';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
            
        END IF;
        END LOOP;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_SAC_SUBTIPO_ACTIVO ACTUALIZADO CORRECTAMENTE ');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_SAC_SUBTIPO_ACTIVO NO EXISTE ');
    END IF;

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
