--/*
--##########################################
--## AUTOR=Pedro Blasco
--## FECHA_CREACION=20220506
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17708
--## PRODUCTO=NO
--## Finalidad:  Script que añade en ESP_SAC_CONFIG los datos añadidos en T_ARRAY_DATA (mapeos de tipo y subtipo de activo con tipo de especialidad)
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial: Pedro Blasco
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(4000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TICKET VARCHAR2(20 CHAR):='HREOS-17708';
    V_NUM_FILAS NUMBER(5);

    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ESP_SAC_CONFIG'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(

    T_TIPO_DATA('01','01','03','0'),
    T_TIPO_DATA('01','02','03','0'),
    T_TIPO_DATA('01','03','03','0'),
    T_TIPO_DATA('01','04','03','0'),
    T_TIPO_DATA('01','05','01','1'),
    T_TIPO_DATA('01','06','01','1'),
    T_TIPO_DATA('01','09','01','1'),
    T_TIPO_DATA('01','10','01','1'),
    T_TIPO_DATA('01','17','04','0'),
    T_TIPO_DATA('01','18','04','0'),
    T_TIPO_DATA('01','26','09','0'),
    T_TIPO_DATA('01','27','03','0'),
    T_TIPO_DATA('01','42','03','0'),
    T_TIPO_DATA('02','01','03','0'),
    T_TIPO_DATA('02','04','03','0'),
    T_TIPO_DATA('02','05','01','1'),
    T_TIPO_DATA('02','06','01','1'),
    T_TIPO_DATA('02','07','01','1'),
    T_TIPO_DATA('02','08','01','1'),
    T_TIPO_DATA('02','09','01','1'),
    T_TIPO_DATA('02','10','01','1'),
    T_TIPO_DATA('02','11','01','1'),
    T_TIPO_DATA('02','12','01','1'),
    T_TIPO_DATA('02','13','05','0'),
    T_TIPO_DATA('02','14','07','0'),
    T_TIPO_DATA('02','16','05','0'),
    T_TIPO_DATA('02','19','08','1'),
    T_TIPO_DATA('02','20','05','0'),
    T_TIPO_DATA('02','22','05','0'),
    T_TIPO_DATA('02','24','08','1'),
    T_TIPO_DATA('02','25','09','1'),
    T_TIPO_DATA('02','26','09','0'),
    T_TIPO_DATA('02','43','01','1'),
    T_TIPO_DATA('03','03','03','0'),
    T_TIPO_DATA('03','06','01','1'),
    T_TIPO_DATA('03','09','01','1'),
    T_TIPO_DATA('03','13','05','0'),
    T_TIPO_DATA('03','14','07','0'),
    T_TIPO_DATA('03','15','05','0'),
    T_TIPO_DATA('03','16','05','0'),
    T_TIPO_DATA('03','17','04','0'),
    T_TIPO_DATA('03','20','05','0'),
    T_TIPO_DATA('03','21','07','0'),
    T_TIPO_DATA('03','22','05','0'),
    T_TIPO_DATA('03','24','08','1'),
    T_TIPO_DATA('03','25','09','1'),
    T_TIPO_DATA('03','26','09','0'),
    T_TIPO_DATA('03','28','09','0'),
    T_TIPO_DATA('03','29','04','0'),
    T_TIPO_DATA('04','09','01','1'),
    T_TIPO_DATA('04','13','05','0'),
    T_TIPO_DATA('04','15','04','0'),
    T_TIPO_DATA('04','17','04','0'),
    T_TIPO_DATA('04','18','04','0'),
    T_TIPO_DATA('04','20','05','0'),
    T_TIPO_DATA('04','26','09','0'),
    T_TIPO_DATA('04','37','04','0'),
    T_TIPO_DATA('05','04','03','0'),
    T_TIPO_DATA('05','06','01','1'),
    T_TIPO_DATA('05','09','01','1'),
    T_TIPO_DATA('05','13','05','0'),
    T_TIPO_DATA('05','16','05','0'),
    T_TIPO_DATA('05','18','04','0'),
    T_TIPO_DATA('05','19','08','1'),
    T_TIPO_DATA('05','20','05','0'),
    T_TIPO_DATA('05','21','07','0'),
    T_TIPO_DATA('05','22','05','0'),
    T_TIPO_DATA('05','24','08','1'),
    T_TIPO_DATA('05','25','09','1'),
    T_TIPO_DATA('05','26','09','0'),
    T_TIPO_DATA('05','43','01','1'),
    T_TIPO_DATA('06','05','01','1'),
    T_TIPO_DATA('06','06','01','1'),
    T_TIPO_DATA('06','09','01','1'),
    T_TIPO_DATA('06','23','01','1'),
    T_TIPO_DATA('06','24','08','1'),
    T_TIPO_DATA('06','25','09','1'),
    T_TIPO_DATA('07','01','03','0'),
    T_TIPO_DATA('07','04','03','0'),
    T_TIPO_DATA('07','06','01','1'),
    T_TIPO_DATA('07','08','01','1'),
    T_TIPO_DATA('07','09','01','1'),
    T_TIPO_DATA('07','13','05','0'),
    T_TIPO_DATA('07','14','07','0'),
    T_TIPO_DATA('07','15','04','0'),
    T_TIPO_DATA('07','16','05','0'),
    T_TIPO_DATA('07','17','04','0'),
    T_TIPO_DATA('07','18','04','0'),
    T_TIPO_DATA('07','19','08','1'),
    T_TIPO_DATA('07','22','05','0'),
    T_TIPO_DATA('07','24','08','1'),
    T_TIPO_DATA('07','25','09','1'),
    T_TIPO_DATA('07','26','09','0'),
    T_TIPO_DATA('07','35','09','0'),
    T_TIPO_DATA('07','36','09','0'),
    T_TIPO_DATA('07','38','04','0'),
    T_TIPO_DATA('07','40','09','0'),
    T_TIPO_DATA('07','41','09','0'),
    T_TIPO_DATA('08','30','09','0'),
    T_TIPO_DATA('08','31','09','0'),
    T_TIPO_DATA('08','32','09','0'),
    T_TIPO_DATA('08','34','09','0'),
    T_TIPO_DATA('08','39','09','0'),
    T_TIPO_DATA('09','33','09','0')


    ); 

    V_TMP_TIPO_DATA T_TIPO_DATA;

    V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
    V_DD_TPA_ID NUMBER(16); -- Vble. para almacenar el id del tipo de activo
    V_DD_SAC_ID NUMBER(16); -- Vble. para almacenar el id del subtipo de activo
    V_DD_ESP_ID NUMBER(16); -- Vble. para almacenar el id de la especialidad

	V_SQL_DD_TPA VARCHAR2(4000 CHAR) := 'SELECT DD_TPA_ID FROM DD_TPA_TIPO_ACTIVO WHERE DD_TPA_CODIGO=:1';
	V_SQL_DD_SAC VARCHAR2(4000 CHAR) := 'SELECT DD_SAC_ID FROM DD_SAC_SUBTIPO_ACTIVO WHERE DD_SAC_CODIGO=:1';
	V_SQL_DD_ESP VARCHAR2(4000 CHAR) := 'SELECT DD_ESP_ID FROM DD_ESP_ESPECIALIDAD WHERE DD_ESP_CODIGO=:1';
	V_SQL_ID VARCHAR2(4000 CHAR) := 'SELECT ' || V_ESQUEMA || '.S_' || V_TEXT_TABLA || '.NEXTVAL FROM DUAL';

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	-- LOOP para insertar los valores --
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        -- Obtener IDs implicados
        EXECUTE IMMEDIATE V_SQL_DD_TPA INTO V_DD_TPA_ID USING V_TMP_TIPO_DATA(1);
        EXECUTE IMMEDIATE V_SQL_DD_SAC INTO V_DD_SAC_ID USING V_TMP_TIPO_DATA(2);
        EXECUTE IMMEDIATE V_SQL_DD_ESP INTO V_DD_ESP_ID USING V_TMP_TIPO_DATA(3);
        --Comprobar el dato a insertar.
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.' || V_TEXT_TABLA || ' WHERE DD_TPA_ID=:1 AND DD_SAC_ID=:2';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_FILAS USING V_DD_TPA_ID, V_DD_SAC_ID;
		IF V_NUM_FILAS > 0 THEN				
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||
				' SET DD_ESP_ID=:1, VERSION=VERSION+1, USUARIOMODIFICAR=:2, FECHAMODIFICAR=SYSDATE, EAC_APLICA_OBRA_NUEVA=:3' ||
				' WHERE DD_TPA_ID=:4 AND DD_SAC_ID=:5';
			EXECUTE IMMEDIATE V_MSQL USING V_DD_ESP_ID, V_TICKET, V_TMP_TIPO_DATA(4), V_DD_TPA_ID, V_DD_SAC_ID;
			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ' || V_TMP_TIPO_DATA(1) || ',' || V_TMP_TIPO_DATA(2) ||' YA EXISTENTE: ACTUALIZADO ' || V_TMP_TIPO_DATA(3) || ',' || V_TMP_TIPO_DATA(4));
		ELSE
			EXECUTE IMMEDIATE V_SQL_ID INTO V_ID;

			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||
				' (EAC_ID, DD_TPA_ID, DD_SAC_ID, DD_ESP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, EAC_APLICA_OBRA_NUEVA) ' ||
				' VALUES (:1, :2, :3, :4, 0, :5, SYSDATE, 0, :6)';
			EXECUTE IMMEDIATE V_MSQL USING V_ID, V_DD_TPA_ID, V_DD_SAC_ID, V_DD_ESP_ID, V_TICKET, V_TMP_TIPO_DATA(4);
			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ' || V_TMP_TIPO_DATA(1) || ',' || V_TMP_TIPO_DATA(2) ||' INSERTADO CORRECTAMENTE ' || V_TMP_TIPO_DATA(3) || ',' || V_TMP_TIPO_DATA(4));
		END IF;
	END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');

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
   