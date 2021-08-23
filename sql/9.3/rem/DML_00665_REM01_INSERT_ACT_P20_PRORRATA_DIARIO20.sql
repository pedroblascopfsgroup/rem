--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210817
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10340
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ACT_P20_PRORRATA_DIARIO20 los datos añadidos en T_ARRAY_DATA
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
    V_ITEM VARCHAR2(25 CHAR):= 'REMVIP-10340';

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_P20_PRORRATA_DIARIO20'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    -- PRO_DOCIDENTIF   P20_PRORRATA
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('A93139053',93)
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	

    -- LOOP para insertar los valores -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA||' ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        V_MSQL :='SELECT COUNT(1)
              FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' P20 
              JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_DOCIDENTIF = '''||V_TMP_TIPO_DATA(1)||'''
                AND PRO.PRO_ID = P20.PRO_ID
                AND PRO.BORRADO = 0
              WHERE P20.BORRADO = 0
                AND P20.P20_PRORRATA = 100-'||V_TMP_TIPO_DATA(2)||'';

        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS>0 THEN
            DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE UN REGISTRO '''||V_TMP_TIPO_DATA(1)||''' - '''||V_TMP_TIPO_DATA(2)||''' ');

        ELSE
            V_MSQL :='INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
                P20_ID
                , PRO_ID
                , P20_PRORRATA
                , P20_GASTO
                , USUARIOCREAR
                , FECHACREAR
              )
              VALUES (
                '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL
                , (SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_DOCIDENTIF= '''||V_TMP_TIPO_DATA(1)||''' AND BORRADO = 0)
                , 100 - '||V_TMP_TIPO_DATA(2)||'
                , '||V_TMP_TIPO_DATA(2)||'
                , '''||V_ITEM||'''
                , SYSDATE
              )';

              EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''||V_TMP_TIPO_DATA(1)||''' - '''||V_TMP_TIPO_DATA(2)||''' INSERTADO CORRECTAMENTE');
        END IF;


        

      END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: Tabla '||V_TEXT_TABLA||' MODIFICADA CORRECTAMENTE ');

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
