--/*
--##########################################
--## AUTOR=Jose Villel
--## FECHA_CREACION=20161110
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en CCC_CONFIG_CTAS_CONTABLES los datos añadidos en T_ARRAY_DATA
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
    V_TABLA VARCHAR2(50 CHAR) := 'CCC_CONFIG_CTAS_CONTABLES';

    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('01','03','9645','14056'),
		T_TIPO_DATA('02','03','9645','14056'),
		T_TIPO_DATA('01','02','6310000000','6310000000'),
		T_TIPO_DATA('02','02','6310000000','6310000000')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
    -- Mientras sea una tabla de configuración de la que extraemos información y no haya ninguna FK apuntando a su id, 
    -- podemos borrar la tabla completa y volver a generar la configuración.
    V_MSQL := 'TRUNCATE TABLE '|| V_ESQUEMA ||'.'|| V_TABLA; 
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO]: TABLA TRUNCADA');
	 
    -- LOOP para insertar los valores en CCC_CONFIG_CTAS_CONTABLES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN CCC_CONFIG_CTAS_CONTABLES] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
       
        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS REGISTRO: ' || I );   
        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_CCC_CONFIG_CTAS_CONTABLES.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.CCC_CONFIG_CTAS_CONTABLES (' ||
                    'CCC_ID, DD_STG_ID, DD_CRA_ID, CCC_CUENTA_ANYO_CURSO, CCC_CUENTA_ANYOS_ANTERIORES, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES' ||
                      '('|| V_ID || ',
					  (SELECT DD_STG_ID FROM '||V_ESQUEMA ||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''),
					  (SELECT DD_CRA_ID FROM '||V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''),
                      '''||TRIM(V_TMP_TIPO_DATA(3))||''',
                      '''||TRIM(V_TMP_TIPO_DATA(4))||''',
                       0, ''DML'',SYSDATE,0 )';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');

      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA CCC_CONFIG_CTAS_CONTABLES ACTUALIZADA CORRECTAMENTE ');
   

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



   