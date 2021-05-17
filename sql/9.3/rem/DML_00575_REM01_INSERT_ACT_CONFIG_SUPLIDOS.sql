--/*
--######################################### 
--## AUTOR=Ivan Repiso
--## FECHA_CREACION=20210408
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7986
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Insertar config suplidos
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejECVtar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USU VARCHAR2(30 CHAR) := 'REMVIP-7986';
    V_TEXT_TABLA VARCHAR2(30 CHAR) := 'ACT_CONFIG_SUPLIDOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

	V_NUM_TABLAS NUMBER(16);

    V_CRA_ID NUMBER(16);
    V_SCR_ID NUMBER(16);
    V_TGA_ID NUMBER(16);
    V_STG_ID NUMBER(16);

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('07','151','02','16'),
		T_TIPO_DATA('07','152','02','16'),
		T_TIPO_DATA('07','151','02','18'),
		T_TIPO_DATA('07','152','02','18')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN

    V_MSQL := 'SELECT COUNT(*) FROM ALL_TABLES WHERE TABLE_NAME = ''ACT_CONFIG_SUPLIDOS''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 1 THEN

	 -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        V_CRA_ID:= 0;
        V_SCR_ID:= 0;
        V_TGA_ID:= 0;
        V_STG_ID:= 0;

        V_MSQL := 'SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL INTO V_CRA_ID;
        V_MSQL := 'SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||V_TMP_TIPO_DATA(2)||''' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL INTO V_SCR_ID;
        V_MSQL := 'SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO WHERE DD_TGA_CODIGO = '''||V_TMP_TIPO_DATA(3)||''' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL INTO V_TGA_ID;
        V_MSQL := 'SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = '''||V_TMP_TIPO_DATA(4)||''' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL INTO V_STG_ID;

        IF V_CRA_ID != 0 AND V_SCR_ID != 0 AND V_TGA_ID != 0 AND V_STG_ID != 0 THEN

            V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_CRA_ID = '||V_CRA_ID||' 
                        AND DD_SCR_ID = '||V_SCR_ID||' AND DD_TGA_ID = '||V_TGA_ID||' 
                        AND DD_STG_ID = '||V_STG_ID||' AND BORRADO = 0';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
            
            IF V_NUM_TABLAS = 0 THEN

                V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (SUP_ID,DD_CRA_ID,DD_SCR_ID,DD_TGA_ID,DD_STG_ID,USUARIOCREAR,FECHACREAR) VALUES (
                                '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,'||V_CRA_ID||','||V_SCR_ID||','||V_TGA_ID||',
                                '||V_STG_ID||', '''||V_USU||''',SYSDATE)';
                EXECUTE IMMEDIATE V_MSQL;

                DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADO REGISTRO CON DD_CRA_ID = '||V_CRA_ID||',DD_SCR_ID = '||V_SCR_ID||',
                                DD_TGA_ID = '||V_TGA_ID||' Y DD_STG_ID = '||V_STG_ID||'');

            ELSE

                DBMS_OUTPUT.PUT_LINE('[INFO]: EXISTE REGISTRO CON DD_CRA_ID = '||V_CRA_ID||',DD_SCR_ID = '||V_SCR_ID||',
                                DD_TGA_ID = '||V_TGA_ID||' Y DD_STG_ID = '||V_STG_ID||'');

            END IF;

        END IF;

	END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');

    ELSE

    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' NO EXISTE');

    END IF;

EXCEPTION
     WHEN OTHERS THEN 
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejECVción:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT;