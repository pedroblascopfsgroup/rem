--/*
--##########################################
--## AUTOR=Jonathan Ovalle
--## FECHA_CREACION=20200717
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10602
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ACT_STI_SGT_IMP los datos añadidos en T_ARRAY_DATA
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
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-10602';

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_STI_SGT_IMP'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    -- PARTIDA_PRESUPUESTARIA   DD_TGA_CODIGO  DD_TIM_CODIGO   DD_SCR_CODIGO
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('28',  '72','01','01,02,03,04,06,07,08,09,10,11,12,13,14,15,16,17','21'),
        T_TIPO_DATA('29',  '73','01','01,02,03,04,06,07,08,09,10,11,12,13,14,15,16,17','21'),
        T_TIPO_DATA('30',  '74','01','01,02,03,04,06,07,08,09,10,11,12,13,14,15,16,17','21'),
        T_TIPO_DATA('31',  '75','01','01,02,03,04,06,07,08,09,10,11,12,13,14,15,16,17','21'),
        T_TIPO_DATA('32',  '76','01','01,02,03,04,06,07,08,09,10,11,12,13,14,15,16,17','21'),
        T_TIPO_DATA('121', '80','01','01,02,03,04,06,07,08,09,10,11,12,13,14,15,16,17','21'),
        T_TIPO_DATA('122', '79','01','01,02,03,04,06,07,08,09,10,11,12,13,14,15,16,17','21'),
        T_TIPO_DATA('123', '79','01','01,02,03,04,06,07,08,09,10,11,12,13,14,15,16,17','21'),
        T_TIPO_DATA('124', '79','01','01,02,03,04,06,07,08,09,10,11,12,13,14,15,16,17','21'),
        T_TIPO_DATA('125', '79','01','01,02,03,04,06,07,08,09,10,11,12,13,14,15,16,17','21'),
        T_TIPO_DATA('126', '79','01','01,02,03,04,06,07,08,09,10,11,12,13,14,15,16,17','21'),
        T_TIPO_DATA('127', '79','01','01,02,03,04,06,07,08,09,10,11,12,13,14,15,16,17','21'),

        T_TIPO_DATA('28','72','03','05','7'),
        T_TIPO_DATA('29','73','03','05','7'),
        T_TIPO_DATA('30','74','03','05','7'),
        T_TIPO_DATA('31','75','03','05','7'),
        T_TIPO_DATA('32','76','03','05','7'),
        T_TIPO_DATA('121','80','03','05','7'),
        T_TIPO_DATA('122','79','03','05','7'),
        T_TIPO_DATA('123','79','03','05','7'),
        T_TIPO_DATA('124','79','03','05','7'),
        T_TIPO_DATA('125','79','03','05','7'),
        T_TIPO_DATA('126','79','03','05','7'),
        T_TIPO_DATA('127','79','03','05','7'),

        T_TIPO_DATA('28','72','04','18','8'),
        T_TIPO_DATA('29','73','04','18','8'),
        T_TIPO_DATA('30','74','04','18','8'),
        T_TIPO_DATA('31','75','04','18','8'),
        T_TIPO_DATA('32','76','04','18','8'),
        T_TIPO_DATA('121','80','04','18','8'),
        T_TIPO_DATA('122','79','04','18','8'),
        T_TIPO_DATA('123','79','04','18','8'),
        T_TIPO_DATA('124','79','04','18','8'),
        T_TIPO_DATA('125','79','04','18','8'),
        T_TIPO_DATA('126','79','04','18','8'),
        T_TIPO_DATA('127','79','04','18','8'),

        T_TIPO_DATA('28','72','04','19','8'),
        T_TIPO_DATA('29','73','04','19','8'),
        T_TIPO_DATA('30','74','04','19','8'),
        T_TIPO_DATA('31','75','04','19','8'),
        T_TIPO_DATA('32','76','04','19','8'),
        T_TIPO_DATA('121','80','04','19','8'),
        T_TIPO_DATA('122','79','04','19','8'),
        T_TIPO_DATA('123','79','04','19','8'),
        T_TIPO_DATA('124','79','04','19','8'),
        T_TIPO_DATA('125','79','04','19','8'),
        T_TIPO_DATA('126','79','04','19','8'),
        T_TIPO_DATA('127','79','04','19','8')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	

    -- LOOP para insertar los valores -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA||' ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
       
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE
        SGT_ID = (SELECT SGT_ID FROM '||V_ESQUEMA||'.ACT_SGT_SUBTIPO_GPV_TBJ WHERE DD_STG_ID = (SELECT DD_STG_ID FROM DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO ='''||V_TMP_TIPO_DATA(2)||''') and DD_STR_ID = (SELECT DD_STR_ID FROM DD_STR_SUBTIPO_TRABAJO where DD_STR_CODIGO ='''||V_TMP_TIPO_DATA(1)||''' ))
        AND DD_TIT_ID = (SELECT DD_TIT_ID FROM '||V_ESQUEMA||'.DD_TIT_TIPOS_IMPUESTO WHERE DD_TIT_CODIGO = '''||V_TMP_TIPO_DATA(3)||''')
        AND DD_CCA_ID = (SELECT DD_CCA_ID FROM '||V_ESQUEMA_M||'.DD_CCA_COMUNIDAD WHERE DD_CCA_CODIGO IN ('''||V_TMP_TIPO_DATA(4)||'''))
        AND STI_TIPO_IMPOSITIVO = '''||V_TMP_TIPO_DATA(5)||'''';
         DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: La '''||TRIM(V_TMP_TIPO_DATA(1))||''' ya existe');
        ELSE
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (
                      STI_ID,SGT_ID, DD_TIT_ID,DD_CCA_ID,STI_TIPO_IMPOSITIVO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) SELECT
                       '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL
                       ,(SELECT SGT_ID FROM '||V_ESQUEMA||'.ACT_SGT_SUBTIPO_GPV_TBJ WHERE DD_STG_ID = (SELECT DD_STG_ID FROM DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO ='''||V_TMP_TIPO_DATA(2)||''') and DD_STR_ID = (SELECT DD_STR_ID FROM DD_STR_SUBTIPO_TRABAJO where DD_STR_CODIGO ='''||V_TMP_TIPO_DATA(1)||''' ))
                       ,(SELECT DD_TIT_ID FROM '||V_ESQUEMA||'.DD_TIT_TIPOS_IMPUESTO WHERE DD_TIT_CODIGO = '''||V_TMP_TIPO_DATA(3)||''')
                       ,DD_CCA_ID 
                       ,'''||V_TMP_TIPO_DATA(5)||''',0,'''||V_ITEM||''',SYSDATE,0
                       FROM '||V_ESQUEMA_M||'.DD_CCA_COMUNIDAD WHERE DD_CCA_CODIGO IN ('||V_TMP_TIPO_DATA(4)||')';
                        DBMS_OUTPUT.PUT_LINE(V_MSQL);
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
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
