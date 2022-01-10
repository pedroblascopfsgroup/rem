--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20211229
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10988
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_TBK_TIPO_BULK_AN los datos añadidos en T_ARRAY_DATA
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
    V_ID NUMBER(16);
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_TBK_TIPO_BULK_AN'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_CHARS VARCHAR2(2400 CHAR) := 'TBK'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.
    V_INCIDENCIA VARCHAR2(25 CHAR) := 'REMVIP-10988';
    V_ID_MODIFICAR NUMBER(16); --Vble para extraer el ID del registro a modificar, si procede.

    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('JRD', 'Jaguar - Aprobadas en Delegación', 'Jaguar - Aprobadas en Delegación'),
        T_TIPO_DATA('JRC', 'Jaguar - Aprobadas por Cerberus', 'Jaguar - Aprobadas por Cerberus')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_TBK_TIPO_BULK_AN -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_TBK_TIPO_BULK_AN ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        
        --Comprobamos el dato a insertar
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_TBK_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        

        --Si existe modificamos los valores
        IF V_NUM_TABLAS > 0 THEN
        V_MSQL := 'SELECT DD_TBK_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_TBK_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
		    EXECUTE IMMEDIATE V_MSQL INTO V_ID_MODIFICAR;
			V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
            'SET DD_TBK_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''''||
		    ', DD_'||V_TEXT_CHARS||'_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
            ', DD_'||V_TEXT_CHARS||'_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
            ', USUARIOMODIFICAR = '''||V_INCIDENCIA||''' , FECHAMODIFICAR = SYSDATE '||
            'WHERE DD_'||V_TEXT_CHARS||'_ID = '''||V_ID_MODIFICAR||'''';
          EXECUTE IMMEDIATE V_MSQL;
        
        --Si no existe insertamos los registros
        ELSE
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');           
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (' ||
                      'DD_TBK_CODIGO, DD_TBK_DESCRIPCION, DD_TBK_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'VALUES ('''||TRIM(V_TMP_TIPO_DATA(1))||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','||
                      '0, '''||V_INCIDENCIA||''', SYSDATE, 0)';
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS INSERTADOS CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_TBK_TIPO_BULK_AN MODIFICADO CORRECTAMENTE ');
   

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
