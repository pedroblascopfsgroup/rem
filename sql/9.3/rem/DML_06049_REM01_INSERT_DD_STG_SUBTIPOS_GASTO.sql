--/*
--##########################################
--## AUTOR= Juan José Sanjuan
--## FECHA_CREACION=20211203
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16512
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_STG_SUBTIPOS_GASTO los subtipos de Vigilancia y seguridad
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
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_STG_SUBTIPOS_GASTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      -- 					TIPO TRABAJO(DD_TGA_CODIGO),   		SUBTIPO(DD_STG_CODIGO),  			DESCRIPCION,  			                    DESCRIPCION LARGA
		T_TIPO_DATA(			'16',								'116',							'Alarmas Instalación',			            'Alarmas Instalación'),
		T_TIPO_DATA(			'16',								'117',							'Alarmas Mantenimiento',			        'Alarmas Mantenimiento'),
		T_TIPO_DATA(			'16',								'118',							'Vigilancia',	                            'Vigilancia'),
		T_TIPO_DATA(			'16',								'119',							'Colocación puerta antiocupa',              'Colocación puerta antiocupa'),
		T_TIPO_DATA(			'16',								'120',							'Acudas',			                        'Acudas'),
		T_TIPO_DATA(			'16',								'121',							'CRA',			                            'CRA'),
		T_TIPO_DATA(			'16',								'122',							'Alquiler PAO',			                    'Alquiler PAO'),
        T_TIPO_DATA(			'16',								'123',							'Alquiler alarmas',		                    'Alquiler alarmas')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    --Comprobamos que la tabla existe---
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS > 0 THEN

        -- LOOP para insertar los valores en DD_STG_SUBTIPOS_GASTO -----------------------------------------------------------------
        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_STG_SUBTIPOS_GASTO] ');
        FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
        
            V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
            --Comprobamos el dato a insertar
            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
            --Si existe lo modificamos
            IF V_NUM_TABLAS > 0 THEN				
            
            DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
            V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_STG_SUBTIPOS_GASTO '||
                        'SET DD_STG_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(3))||''''|| 
                        ', DD_STG_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(4))||''''||
                        ', USUARIOMODIFICAR = ''HREOS-10656'' , FECHAMODIFICAR = SYSDATE '||
                        'WHERE DD_STG_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
            
        --Si no existe, lo insertamos   
        ELSE
        
            DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');   
            V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_STG_SUBTIPOS_GASTO.NEXTVAL FROM DUAL';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
            V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_STG_SUBTIPOS_GASTO (' ||
                        'DD_STG_ID, DD_TGA_ID, DD_STG_CODIGO, DD_STG_DESCRIPCION, DD_STG_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES' ||
                        '('|| V_ID || ',
                        (SELECT DD_TGA_ID FROM '||V_ESQUEMA ||'.DD_TGA_TIPOS_GASTO WHERE DD_TGA_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''),
                        '''||TRIM(V_TMP_TIPO_DATA(2))||''',
                        '''||TRIM(V_TMP_TIPO_DATA(3))||''',
                        '''||TRIM(V_TMP_TIPO_DATA(4))||''',
                        0, ''HREOS-10656'',SYSDATE,0 )';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
            
        END IF;
        END LOOP;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_STG_SUBTIPOS_GASTO ACTUALIZADO CORRECTAMENTE ');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_STG_SUBTIPOS_GASTO NO EXISTE ');
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
