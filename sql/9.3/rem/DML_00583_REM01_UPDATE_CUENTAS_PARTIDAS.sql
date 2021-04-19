--/*
--######################################### 
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210416
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9456
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES: Modificar cuentas y partidas
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
	V_USU VARCHAR2(30 CHAR) := 'REMVIP-9456';
    V_TEXT_TABLA_PTDAS VARCHAR2(30 CHAR) := 'ACT_CONFIG_PTDAS_PREP'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA_CTAS VARCHAR2(30 CHAR) := 'ACT_CONFIG_CTAS_CONTABLES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

	V_NUM_TABLAS NUMBER(16);
    V_TGA_COD VARCHAR2(30 CHAR) := '11';
    V_STG_COD VARCHAR2(30 CHAR) := '52';

    V_CRA_ID NUMBER(16) := 0;
    V_TGA_ID NUMBER(16) := 0;
    V_STG_ID NUMBER(16) := 0;

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                -- CRA_COD  CTAS    SUBCTAS 
		T_TIPO_DATA('-',    '6310',  '0000007'), --NO LBK
		T_TIPO_DATA('08',  '6874',  '0000003') --LBK
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN

    V_MSQL := 'SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO WHERE DD_TGA_CODIGO = '''||V_TGA_COD||''' AND BORRADO = 0';
    EXECUTE IMMEDIATE V_MSQL INTO V_TGA_ID;
    V_MSQL := 'SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = '''||V_STG_COD||''' AND BORRADO = 0';
    EXECUTE IMMEDIATE V_MSQL INTO V_STG_ID;

    IF V_TGA_ID != 0 OR V_STG_ID != 0 THEN

        /*MODIFICACION CUENTAS*/

        V_MSQL := 'SELECT COUNT(*) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA_CTAS||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS = 1 THEN

        -- LOOP para insertar los valores --
            DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN '||V_TEXT_TABLA_CTAS);
            FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
            LOOP
            V_TMP_TIPO_DATA := V_TIPO_DATA(I);

            V_CRA_ID:= 0;

            IF V_TMP_TIPO_DATA(1) != '-' THEN
                V_MSQL := 'SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' AND BORRADO = 0';
                EXECUTE IMMEDIATE V_MSQL INTO V_CRA_ID;
            END IF;
            

            IF V_CRA_ID != 0 THEN

                V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_CTAS||' WHERE DD_CRA_ID = '||V_CRA_ID||' 
                            AND DD_TGA_ID = '||V_TGA_ID||' AND DD_STG_ID = '||V_STG_ID||' AND BORRADO = 0';
                EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
                
                IF V_NUM_TABLAS != 0 THEN

                    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA_CTAS||' SET CCC_CUENTA_CONTABLE = '''||V_TMP_TIPO_DATA(2)||''',
                                CCC_SUBCUENTA_CONTABLE = '''||V_TMP_TIPO_DATA(3)||''',
                                USUARIOMODIFICAR = '''||V_USU||''', FECHAMODIFICAR = SYSDATE
                                WHERE DD_CRA_ID = '||V_CRA_ID||' AND DD_TGA_ID = '||V_TGA_ID||' AND DD_STG_ID = '||V_STG_ID||' AND BORRADO = 0';
                    EXECUTE IMMEDIATE V_MSQL;

                    DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICADOS '||SQL%ROWCOUNT||' REGISTROS DE LBK EN '||V_TEXT_TABLA_CTAS);

                ELSE

                    DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE REGISTRO CON DD_CRA_ID = '||V_CRA_ID||',
                                    DD_TGA_ID = '||V_TGA_ID||' Y DD_STG_ID = '||V_STG_ID||'');

                END IF;

            ELSIF V_CRA_ID = 0 THEN

                V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_CTAS||' WHERE DD_CRA_ID != (
                            SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''08'' AND BORRADO = 0) 
                            AND DD_TGA_ID = '||V_TGA_ID||' AND DD_STG_ID = '||V_STG_ID||' AND BORRADO = 0';
                EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
                
                IF V_NUM_TABLAS != 0 THEN

                    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA_CTAS||' SET CCC_CUENTA_CONTABLE = '''||V_TMP_TIPO_DATA(2)||''',
                                CCC_SUBCUENTA_CONTABLE = '''||V_TMP_TIPO_DATA(3)||''',
                                USUARIOMODIFICAR = '''||V_USU||''', FECHAMODIFICAR = SYSDATE
                                WHERE DD_CRA_ID != (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''08'' AND BORRADO = 0) 
                                AND DD_TGA_ID = '||V_TGA_ID||' AND DD_STG_ID = '||V_STG_ID||' AND BORRADO = 0';
                    EXECUTE IMMEDIATE V_MSQL;

                    DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICADOS '||SQL%ROWCOUNT||' REGISTROS DE LBK EN '||V_TEXT_TABLA_CTAS);

                ELSE

                    DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE REGISTRO CON DD_CRA_CODIGO != ''08'',
                                    DD_TGA_ID = '||V_TGA_ID||' Y DD_STG_ID = '||V_STG_ID||'');

                END IF;

            END IF;

            END LOOP;
        
            DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA_CTAS||' ACTUALIZADA CORRECTAMENTE '); 
            DBMS_OUTPUT.PUT_LINE('[INFO]: COMMIT');
            COMMIT;

        ELSE

            DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA_CTAS||' NO EXISTE');

        END IF;

        /*MODIFICACION PARTIDAS*/

        V_MSQL := 'SELECT COUNT(*) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA_PTDAS||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS = 1 THEN

            DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN '||V_TEXT_TABLA_PTDAS);

            V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_PTDAS||' WHERE DD_TGA_ID = '||V_TGA_ID||' 
                            AND DD_STG_ID = '||V_STG_ID||' AND BORRADO = 0';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
                
            IF V_NUM_TABLAS != 0 THEN

                V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA_PTDAS||' SET CPP_PARTIDA_PRESUPUESTARIA = ''010'',
                            CPP_APARTADO = ''20'', CPP_CAPITULO = ''05'',
                            USUARIOMODIFICAR = '''||V_USU||''', FECHAMODIFICAR = SYSDATE
                            WHERE DD_TGA_ID = '||V_TGA_ID||' AND DD_STG_ID = '||V_STG_ID||' AND BORRADO = 0';
                EXECUTE IMMEDIATE V_MSQL;

                DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICADOS '||SQL%ROWCOUNT||' REGISTROS EN '||V_TEXT_TABLA_PTDAS);

            ELSE

                DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE REGISTRO CON DD_TGA_ID = '||V_TGA_ID||' Y DD_STG_ID = '||V_STG_ID||'');

            END IF;
        
            DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA_PTDAS||' ACTUALIZADA CORRECTAMENTE ');
            DBMS_OUTPUT.PUT_LINE('[INFO]: COMMIT');
            COMMIT;

        ELSE

            DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA_PTDAS||' NO EXISTE');

        END IF;

    ELSE

    DBMS_OUTPUT.PUT_LINE('[FIN]: HAY UN ERROR CON EL TIPO O SUBTIPO DE GASTO');

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