--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210316
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9222
--## PRODUCTO=NO
--##
--## Finalidad: Script inserta config gestores activos
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'ACT_GES_DIST_GESTORES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-9222'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
	V_REGISTROS NUMBER(16) := 0; -- TOTAL: 102 (GESTOR Y SUPERVISOR) * 5 (SUBCARTERAS) = 510

	TYPE T_TIPO_DATA_SCR IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA_SCR IS TABLE OF T_TIPO_DATA_SCR;
    V_TIPO_DATA_SCR T_ARRAY_DATA_SCR := T_ARRAY_DATA_SCR(
		T_TIPO_DATA_SCR('137'),
		T_TIPO_DATA_SCR('135'),
		T_TIPO_DATA_SCR('39'),
		T_TIPO_DATA_SCR('38'),
		T_TIPO_DATA_SCR('37')); 
    V_TMP_TIPO_DATA_SCR T_TIPO_DATA_SCR;

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('HAYAGBOINM','7','30','lcarrillo','Lorena Carrillo Martinez'),
		T_TIPO_DATA('HAYAGBOINM','7','12','lcarrillo','Lorena Carrillo Martinez'),
		T_TIPO_DATA('HAYAGBOINM','7','46','lcarrillo','Lorena Carrillo Martinez'),
		T_TIPO_DATA('HAYAGBOINM','7','3','lcarrillo','Lorena Carrillo Martinez'),
		T_TIPO_DATA('HAYAGBOINM','7','7','elopezg','Lorena Carrillo Martinez'),
		T_TIPO_DATA('HAYAGBOINM','7','43','lcarrillo','Lorena Carrillo Martinez'),
		T_TIPO_DATA('HAYAGBOINM','7','8','msanzi','Maria Sanz Infantes'),
		T_TIPO_DATA('HAYAGBOINM','7','25','msanzi','Maria Sanz Infantes'),
		T_TIPO_DATA('HAYAGBOINM','7','17','msanzi','Maria Sanz Infantes'),
		T_TIPO_DATA('HAYAGBOINM','7','21','msanzi','Maria Sanz Infantes'),
		T_TIPO_DATA('HAYAGBOINM','7','41','msanzi','Maria Sanz Infantes'),
		T_TIPO_DATA('HAYAGBOINM','7','14','msanzi','Maria Sanz Infantes'),
		T_TIPO_DATA('HAYAGBOINM','7','23','msanzi','Maria Sanz Infantes'),
		T_TIPO_DATA('HAYAGBOINM','7','4','msanzi','Maria Sanz Infantes'),
		T_TIPO_DATA('HAYAGBOINM','7','18','msanzi','Maria Sanz Infantes'),
		T_TIPO_DATA('HAYAGBOINM','7','29','msanzi','Maria Sanz Infantes'),
		T_TIPO_DATA('HAYAGBOINM','7','11','msanzi','Maria Sanz Infantes'),
		T_TIPO_DATA('HAYAGBOINM','7','38','msanzi','Maria Sanz Infantes'),
		T_TIPO_DATA('HAYAGBOINM','7','35','msanzi','Maria Sanz Infantes'),
		T_TIPO_DATA('HAYAGBOINM','7','28','lrisco','LAURA RISCO CABALLERO  '),
		T_TIPO_DATA('HAYAGBOINM','7','15','lrisco','LAURA RISCO CABALLERO  '),
		T_TIPO_DATA('HAYAGBOINM','7','27','lrisco','LAURA RISCO CABALLERO  '),
		T_TIPO_DATA('HAYAGBOINM','7','32','lrisco','LAURA RISCO CABALLERO  '),
		T_TIPO_DATA('HAYAGBOINM','7','36','lrisco','LAURA RISCO CABALLERO  '),
		T_TIPO_DATA('HAYAGBOINM','7','33','lrisco','LAURA RISCO CABALLERO  '),
		T_TIPO_DATA('HAYAGBOINM','7','39','lrisco','LAURA RISCO CABALLERO  '),
		T_TIPO_DATA('HAYAGBOINM','7','1','lrisco','LAURA RISCO CABALLERO  '),
		T_TIPO_DATA('HAYAGBOINM','7','20','lrisco','LAURA RISCO CABALLERO  '),
		T_TIPO_DATA('HAYAGBOINM','7','48','lrisco','LAURA RISCO CABALLERO  '),
		T_TIPO_DATA('HAYAGBOINM','7','31','lrisco','LAURA RISCO CABALLERO  '),
		T_TIPO_DATA('HAYAGBOINM','7','22','lrisco','LAURA RISCO CABALLERO  '),
		T_TIPO_DATA('HAYAGBOINM','7','50','lrisco','LAURA RISCO CABALLERO  '),
		T_TIPO_DATA('HAYAGBOINM','7','44','lrisco','LAURA RISCO CABALLERO  '),
		T_TIPO_DATA('HAYAGBOINM','7','26','lrisco','LAURA RISCO CABALLERO  '),
		T_TIPO_DATA('HAYAGBOINM','7','45','lrisco','LAURA RISCO CABALLERO  '),
		T_TIPO_DATA('HAYAGBOINM','7','13','lrisco','LAURA RISCO CABALLERO  '),
		T_TIPO_DATA('HAYAGBOINM','7','16','lrisco','LAURA RISCO CABALLERO  '),
		T_TIPO_DATA('HAYAGBOINM','7','19','lrisco','LAURA RISCO CABALLERO  '),
		T_TIPO_DATA('HAYAGBOINM','7','2','lrisco','LAURA RISCO CABALLERO  '),
		T_TIPO_DATA('HAYAGBOINM','7','42','lrisco','LAURA RISCO CABALLERO  '),
		T_TIPO_DATA('HAYAGBOINM','7','9','lrisco','LAURA RISCO CABALLERO  '),
		T_TIPO_DATA('HAYAGBOINM','7','47','lrisco','LAURA RISCO CABALLERO  '),
		T_TIPO_DATA('HAYAGBOINM','7','49','lrisco','LAURA RISCO CABALLERO  '),
		T_TIPO_DATA('HAYAGBOINM','7','34','lrisco','LAURA RISCO CABALLERO  '),
		T_TIPO_DATA('HAYAGBOINM','7','24','jguarch','Jose Maria Guarch Herrero'),
		T_TIPO_DATA('HAYAGBOINM','7','40','lrisco','LAURA RISCO CABALLERO  '),
		T_TIPO_DATA('HAYAGBOINM','7','5','lrisco','LAURA RISCO CABALLERO  '),
		T_TIPO_DATA('HAYAGBOINM','7','37','lrisco','LAURA RISCO CABALLERO  '),
		T_TIPO_DATA('HAYAGBOINM','7','10','lrisco','LAURA RISCO CABALLERO  '),
		T_TIPO_DATA('HAYAGBOINM','7','6','lrisco','LAURA RISCO CABALLERO  '),
		T_TIPO_DATA('HAYASBOINM','7','1','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','2','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','3','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','4','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','5','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','6','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','7','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','8','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','9','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','10','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','11','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','12','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','13','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','14','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','15','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','16','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','17','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','18','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','19','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','20','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','21','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','22','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','23','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','24','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','25','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','26','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','27','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','28','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','29','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','30','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','31','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','32','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','33','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','34','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','35','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','36','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','37','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','38','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','39','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','40','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','41','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','42','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','43','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','44','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','45','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','46','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','47','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','48','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','49','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','50','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','51','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  '),
		T_TIPO_DATA('HAYASBOINM','7','52','grusbackoffman','Grupo Supervisor Backoffice Inmobiliario Manzana  ')); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	FOR I IN V_TIPO_DATA_SCR.FIRST .. V_TIPO_DATA_SCR.LAST
    LOOP
        V_TMP_TIPO_DATA_SCR := V_TIPO_DATA_SCR(I);
	
		FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
		LOOP
			V_TMP_TIPO_DATA := V_TIPO_DATA(I);

			DBMS_OUTPUT.PUT_LINE('[INFO]: INFORMAR MEDIADOR EN '||V_TEXT_TABLA);

			V_MSQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TIPO_GESTOR = '''||V_TMP_TIPO_DATA(1)||''' AND COD_CARTERA = '''||V_TMP_TIPO_DATA(2)||'''
						AND COD_PROVINCIA = '''||V_TMP_TIPO_DATA(3)||''' AND USERNAME = '''||V_TMP_TIPO_DATA(4)||''' AND COD_SUBCARTERA = '''||V_TMP_TIPO_DATA_SCR(1)||'''
						AND BORRADO = 0';
			EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

			IF V_COUNT = 0 THEN

				V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (ID,TIPO_GESTOR,COD_CARTERA,COD_PROVINCIA,USERNAME,NOMBRE_USUARIO,USUARIOCREAR,FECHACREAR,COD_SUBCARTERA) VALUES (
							'||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL, '''||V_TMP_TIPO_DATA(1)||''','''||V_TMP_TIPO_DATA(2)||''','''||V_TMP_TIPO_DATA(3)||''','''||V_TMP_TIPO_DATA(4)||''',
							'''||V_TMP_TIPO_DATA(5)||''','''||V_USU||''',SYSDATE,'''||V_TMP_TIPO_DATA_SCR(1)||''')';
				EXECUTE IMMEDIATE V_MSQL;
				
				DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS REGISTRO PARA GESTOR '||V_TMP_TIPO_DATA(1)||' EN SUBCARTERA CODIGO '''||V_TMP_TIPO_DATA_SCR(1)||'''');

				V_REGISTROS := V_REGISTROS + 1;

			ELSE

				DBMS_OUTPUT.PUT_LINE('[INFO]: CONFIGURACION DE GESTOR '||V_TMP_TIPO_DATA(1)||', PARA CODIGO DE CARTERA '||V_TMP_TIPO_DATA(2)||', PROVINCIA CODIGO '||V_TMP_TIPO_DATA(3)||'
										Y CODIGO DE SUBCARTERA '||V_TMP_TIPO_DATA_SCR(1)||' YA EXISTE');

			END IF;
		
		END LOOP;

	END LOOP;

	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADOS '||V_REGISTROS||' REGISTROS');

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');


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