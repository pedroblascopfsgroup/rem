--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20220203
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11088
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica en ACT_P20_PRORRATA_DIARIO20 los datos añadidos en T_ARRAY_DATA
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
    V_ITEM VARCHAR2(25 CHAR):= 'REMVIP-11088';

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_P20_PRORRATA_DIARIO20'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    -- PARTIDA_PRESUPUESTARIA   DD_TGA_CODIGO  DD_TIM_CODIGO   DD_SCR_CODIGO
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('B84921758',58),
        T_TIPO_DATA('A93139053',6)
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	

    -- LOOP para insertar los valores -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICACION '||V_TEXT_TABLA||' ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

          DBMS_OUTPUT.PUT_LINE('[INFO]: FUSIONAMOS EL REGISTRO '''||TRIM(V_TMP_TIPO_DATA(1))||'''');
          V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' T1
            USING (
              SELECT P20.P20_ID
                , PRO.PRO_ID
              FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' P20 
              JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_DOCIDENTIF = '''||V_TMP_TIPO_DATA(1)||'''
                AND PRO.PRO_ID = P20.PRO_ID
                AND PRO.BORRADO = 0
              WHERE P20.BORRADO = 0
                AND P20.P20_PRORRATA <> '||V_TMP_TIPO_DATA(2)||'
            ) T2
            ON (T1.P20_ID = T2.P20_ID)
            WHEN MATCHED THEN
              UPDATE SET T1.P20_PRORRATA = '||V_TMP_TIPO_DATA(2)||'
                , T1.P20_GASTO = 100 - '||V_TMP_TIPO_DATA(2)||'
                , T1.USUARIOMODIFICAR = '''||V_ITEM||'''
                , T1.FECHAMODIFICAR = SYSDATE
            WHEN NOT MATCHED THEN
              INSERT (
                T1.P20_ID
                , T1.PRO_ID
                , T1.P20_PRORRATA
                , T1.P20_GASTO
                , T1.USUARIOCREAR
                , T1.FECHACREAR
              )
              VALUES (
                '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL
                , T2.PRO_ID
                , '||V_TMP_TIPO_DATA(2)||'
                , 100 - '||V_TMP_TIPO_DATA(2)||'
                , '''||V_ITEM||'''
                , SYSDATE
              )';

          EXECUTE IMMEDIATE V_MSQL;

          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO FUSIONADO CORRECTAMENTE');

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