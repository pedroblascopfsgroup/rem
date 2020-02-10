--/*
--##########################################
--## AUTOR=Joaquin Bahamonde
--## FECHA_CREACION=20200210
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9039
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_SCS_SEGMENTO_CRA_SCR los datos añadidos en T_ARRAY_DATA
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_SCS_SEGMENTO_CRA_SCR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_SCR VARCHAR2(2400 CHAR) := 'DD_SCR_SUBCARTERA';
    V_TEXT_CRA VARCHAR2(2400 CHAR) := 'DD_CRA_CARTERA';
    V_TEXT_TS VARCHAR2(2400 CHAR) := 'DD_TS_TIPO_SEGMENTO';
    V_INCIDENCIA VARCHAR2(25 CHAR) := 'HREOS-9320';
    V_ID_CRA NUMBER(16); --Vble para extraer el ID del registro de la cartera.
    V_ID_SCR NUMBER(16); --Vble para extraer el ID del registro de la subcartera.
    V_ID_TS NUMBER(16); --Vble para extraer el ID del registro del diccionario tipo segmento.
    

    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('01', '07', '150'),
        T_TIPO_DATA('02', '07', '150'),
        T_TIPO_DATA('03', '07', '150'),
        T_TIPO_DATA('04', '07', '150'),
        T_TIPO_DATA('05', '07', '150'),
        T_TIPO_DATA('06', '07', '150'),
        T_TIPO_DATA('07', '07', '150')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_SCS_SEGMENTO_CRA_SCR -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_SCS_SEGMENTO_CRA_SCR ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        -- Comprobamos si existe la tabla   
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS = 1 THEN 

            V_MSQL := 'SELECT DD_TS_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TS||' WHERE DD_TS_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID_TS;

            V_MSQL := 'SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.'||V_TEXT_CRA||' WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID_CRA;

            V_MSQL := 'SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.'||V_TEXT_SCR||' WHERE DD_SCR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID_SCR;
            
       
            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_TS_ID = (SELECT DD_TS_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TS||' 
            WHERE DD_TS_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''')';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

          --Si existe modificamos los valores
            IF V_NUM_TABLAS > 0 THEN
                V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                'SET DD_TS_ID = '''||V_ID_TS||''''||
                ', DD_CRA_ID = '''||V_ID_CRA||''''|| 
                ', DD_SCR_ID = '''||V_ID_SCR||''''||
                ', USUARIOMODIFICAR = '''||V_INCIDENCIA||''' , FECHAMODIFICAR = SYSDATE '||
                'WHERE DD_TS_ID = (SELECT DD_TS_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TS||' 
                                    WHERE DD_TS_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''')';
                EXECUTE IMMEDIATE V_MSQL;
                --Si no existe insertamos los registros
            ELSE
                DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS LOS REGISTROS');   
                              
                V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (DD_TS_ID, DD_CRA_ID, DD_SCR_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
                            VALUES ('''||V_ID_TS||''','''||V_ID_CRA||''','''||V_ID_SCR||''', 0, '''||V_INCIDENCIA||''', SYSDATE, 0)';
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS INSERTADO CORRECTAMENTE');
            
            END IF;
        ELSE
          DBMS_OUTPUT.PUT_LINE('LA TABLA DD_SCS_SEGMENTO_CRA_SCR NO EXISTE');
        END IF;
      END LOOP;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_SCS_SEGMENTO_CRA_SCR MODIFICADO CORRECTAMENTE ');
   

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.PUT_LINE(V_MSQL);

          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
