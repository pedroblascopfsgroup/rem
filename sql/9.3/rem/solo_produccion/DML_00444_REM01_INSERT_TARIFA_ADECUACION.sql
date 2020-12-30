--/*
--##########################################
--## AUTOR=Juan Bautista Alfosno
--## FECHA_CREACION=20200903
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7193
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade una nueva tarifa en DD_TTF_TIPO_TAREA y en ACT_CFT_CONFIG_TARIFA los datos añadidos en T_ARRAY_DATA.
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ',.';
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_SEQUENCE NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia actual.
  	V_NUM_MAXID NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia máxima utilizada en los registros.
    V_ID NUMBER(16); --Vble. auxiliar para almacenar el id a insertar

    V_TEXT_TABLA_TARIFA VARCHAR2(100 CHAR) := 'DD_TTF_TIPO_TARIFA'; --Vble. auxiliar para almacenar la tabla en la cual se inserta la tarea
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'ACT_CFT_CONFIG_TARIFA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-7193'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

    V_CODIGO_TARIFA VARCHAR2(100 CHAR) := 'AP-DIV-ADEC1'; --Vble. auxiliar para almacenar el codigo de la tarifa a insertar
    V_DESCRIPCION_TARIFA VARCHAR2(100 CHAR) :='Adecuacion de vivienda'; --Vble. auxiliar para almacenar la descripcion de la tarifa a insertar

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(4000 char);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (
    --	TIPO_TRABAJO_CODIGO	TIPO_SUBTRABAJO_CODIGO	CARTERA_CODIGO	SUBCARTERA_CODIGO	PRECIO_UNITARIO	  UNIDAD_MEDIDA
T_TIPO_DATA('03',  '39',  '07',  '138', '0'  ,'€/ud'),
T_TIPO_DATA('03',  '39',  '07',  '151', '0'  ,'€/ud'),
T_TIPO_DATA('03',  '39',  '07',  '152', '0'  ,'€/ud')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    V_SQL:='SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_TARIFA||' WHERE DD_TTF_CODIGO = '''||V_CODIGO_TARIFA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

   
    IF V_NUM_TABLAS < 1 THEN

        -- SI NO EXISTE LA TARIFA LA INSERTAMOS
        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCCION TARIFA '''||V_CODIGO_TARIFA||''' - '''||V_DESCRIPCION_TARIFA||''' EN '||V_TEXT_TABLA_TARIFA);

        V_SQL:='SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA_TARIFA||'.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_SQL INTO V_ID;

        V_SQL:='INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA_TARIFA||' (DD_TTF_ID, DD_TTF_CODIGO, DD_TTF_DESCRIPCION, DD_TTF_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) VALUES
        ('||V_ID||','''||V_CODIGO_TARIFA||''','''||V_DESCRIPCION_TARIFA||''','''||V_DESCRIPCION_TARIFA||''','''||V_USUARIO||''',SYSDATE)';
        
        EXECUTE IMMEDIATE V_SQL;

        --Comprobamos que la tarifa se a insertado correctamente

        V_SQL:='SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_TARIFA||' WHERE DD_TTF_CODIGO = '''||V_CODIGO_TARIFA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN

        --SI LA TARIFA SE HA CREADO

            -- LOOP para insertar los valores --
            DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
            FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
            LOOP

                V_TMP_TIPO_DATA := V_TIPO_DATA(I);

                -- Comprobar el dato a insertar.
                V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_TTF_ID = (SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_TARIFA||' WHERE DD_TTF_CODIGO = '''||V_CODIGO_TARIFA||''') '||
                'AND DD_TTR_ID = (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''') '||
                'AND DD_STR_ID = (SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''') '||
                'AND DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''') '||
                'AND DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||''')';
                EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

                IF V_NUM_TABLAS < 1 THEN

                    -- Comprobar secuencias de la tabla.
                    V_SQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
                    EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
                
                    V_SQL := 'SELECT NVL(MAX(CFT_ID), 0) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||'';
                    EXECUTE IMMEDIATE V_SQL INTO V_NUM_MAXID;
                    
                    WHILE V_NUM_SEQUENCE <= V_NUM_MAXID LOOP
                        V_SQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
                        EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
                    END LOOP;

                    -- Si no existe se inserta.
                    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''||V_CODIGO_TARIFA||''' EN '''||V_TEXT_TABLA||'''');

                    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (' ||
                            'CFT_ID, DD_TTF_ID, DD_TTR_ID, DD_STR_ID, DD_CRA_ID, DD_SCR_ID, CFT_PRECIO_UNITARIO, CFT_UNIDAD_MEDIDA, USUARIOCREAR, FECHACREAR) VALUES ( ' ||
                            ''|| V_NUM_SEQUENCE || ', (SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_TARIFA||' WHERE DD_TTF_CODIGO = '''||V_CODIGO_TARIFA||'''), '||
                            '(SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''), '||
                            '(SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''), '||
                            '(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''), '||
                            '(SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||'''), '||
                            ''''||TRIM(V_TMP_TIPO_DATA(5))||''', '''||TRIM(V_TMP_TIPO_DATA(6))||''', '''|| V_USUARIO ||''', SYSDATE)';
                    EXECUTE IMMEDIATE V_MSQL;

                ELSE
                    DBMS_OUTPUT.PUT_LINE('[INFO]: LA TARIFA CON CODIGO '''|| V_CODIGO_TARIFA ||''' YA EXISTE EN LA TABLA '''||V_TEXT_TABLA||'''');
                END IF;

            END LOOP;
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO]: NO SE CONTINUA LA TARIFA CON CODIGO '''||V_CODIGO_TARIFA||''' NO EXISTE');
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO]: LA TARIFA CON CODIGO '''||V_CODIGO_TARIFA||''' YA EXISTE');
    END IF;

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]: Tabla '||V_TEXT_TABLA||' Y '||V_TEXT_TABLA_TARIFA||' actualizada correctamente.');


EXCEPTION
		WHEN OTHERS THEN
			ERR_NUM := SQLCODE;
			ERR_MSG := SQLERRM;

			DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
			DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
			DBMS_OUTPUT.put_line(ERR_MSG);

			ROLLBACK;
			RAISE;          

END;
/
EXIT