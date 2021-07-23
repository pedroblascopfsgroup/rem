--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210708
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10085
--## PRODUCTO=NO
--##
--## Finalidad: 
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
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-10085'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
	V_TIPO_GESTOR VARCHAR2(30 CHAR) := 'HAYASBOINM';
	V_USERNAME VARCHAR2(30 CHAR) := 'grusbackoffice';
	V_NOMBRE_USUARIO VARCHAR2(60 CHAR) := 'Grupo Supervisores Backoffice Inmobiliario';

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('1','1'),
		T_TIPO_DATA('1','2'),
		T_TIPO_DATA('1','3'),
		T_TIPO_DATA('1','4'),
		T_TIPO_DATA('1','5'),
		T_TIPO_DATA('1','6'),
		T_TIPO_DATA('1','7'),
		T_TIPO_DATA('1','8'),
		T_TIPO_DATA('1','9'),
		T_TIPO_DATA('1','10'),
		T_TIPO_DATA('1','11'),
		T_TIPO_DATA('1','12'),
		T_TIPO_DATA('1','13'),
		T_TIPO_DATA('1','14'),
		T_TIPO_DATA('1','15'),
		T_TIPO_DATA('1','16'),
		T_TIPO_DATA('1','17'),
		T_TIPO_DATA('1','18'),
		T_TIPO_DATA('1','19'),
		T_TIPO_DATA('1','20'),
		T_TIPO_DATA('1','21'),
		T_TIPO_DATA('1','22'),
		T_TIPO_DATA('1','23'),
		T_TIPO_DATA('1','24'),
		T_TIPO_DATA('1','25'),
		T_TIPO_DATA('1','26'),
		T_TIPO_DATA('1','27'),
		T_TIPO_DATA('1','28'),
		T_TIPO_DATA('1','29'),
		T_TIPO_DATA('1','30'),
		T_TIPO_DATA('1','31'),
		T_TIPO_DATA('1','32'),
		T_TIPO_DATA('1','33'),
		T_TIPO_DATA('1','34'),
		T_TIPO_DATA('1','35'),
		T_TIPO_DATA('1','36'),
		T_TIPO_DATA('1','37'),
		T_TIPO_DATA('1','38'),
		T_TIPO_DATA('1','39'),
		T_TIPO_DATA('1','40'),
		T_TIPO_DATA('1','41'),
		T_TIPO_DATA('1','42'),
		T_TIPO_DATA('1','43'),
		T_TIPO_DATA('1','44'),
		T_TIPO_DATA('1','45'),
		T_TIPO_DATA('1','46'),
		T_TIPO_DATA('1','47'),
		T_TIPO_DATA('1','48'),
		T_TIPO_DATA('1','49'),
		T_TIPO_DATA('1','50'),
		T_TIPO_DATA('1','51'),
		T_TIPO_DATA('1','52'),
		T_TIPO_DATA('2','1'),
		T_TIPO_DATA('2','2'),
		T_TIPO_DATA('2','3'),
		T_TIPO_DATA('2','4'),
		T_TIPO_DATA('2','5'),
		T_TIPO_DATA('2','6'),
		T_TIPO_DATA('2','7'),
		T_TIPO_DATA('2','8'),
		T_TIPO_DATA('2','9'),
		T_TIPO_DATA('2','10'),
		T_TIPO_DATA('2','11'),
		T_TIPO_DATA('2','12'),
		T_TIPO_DATA('2','13'),
		T_TIPO_DATA('2','14'),
		T_TIPO_DATA('2','15'),
		T_TIPO_DATA('2','16'),
		T_TIPO_DATA('2','17'),
		T_TIPO_DATA('2','18'),
		T_TIPO_DATA('2','19'),
		T_TIPO_DATA('2','20'),
		T_TIPO_DATA('2','21'),
		T_TIPO_DATA('2','22'),
		T_TIPO_DATA('2','23'),
		T_TIPO_DATA('2','24'),
		T_TIPO_DATA('2','25'),
		T_TIPO_DATA('2','26'),
		T_TIPO_DATA('2','27'),
		T_TIPO_DATA('2','28'),
		T_TIPO_DATA('2','29'),
		T_TIPO_DATA('2','30'),
		T_TIPO_DATA('2','31'),
		T_TIPO_DATA('2','32'),
		T_TIPO_DATA('2','33'),
		T_TIPO_DATA('2','34'),
		T_TIPO_DATA('2','35'),
		T_TIPO_DATA('2','36'),
		T_TIPO_DATA('2','37'),
		T_TIPO_DATA('2','38'),
		T_TIPO_DATA('2','39'),
		T_TIPO_DATA('2','40'),
		T_TIPO_DATA('2','41'),
		T_TIPO_DATA('2','42'),
		T_TIPO_DATA('2','43'),
		T_TIPO_DATA('2','44'),
		T_TIPO_DATA('2','45'),
		T_TIPO_DATA('2','46'),
		T_TIPO_DATA('2','47'),
		T_TIPO_DATA('2','48'),
		T_TIPO_DATA('2','49'),
		T_TIPO_DATA('2','50'),
		T_TIPO_DATA('2','51'),
		T_TIPO_DATA('2','52'),
		T_TIPO_DATA('3','1'),
		T_TIPO_DATA('3','2'),
		T_TIPO_DATA('3','3'),
		T_TIPO_DATA('3','4'),
		T_TIPO_DATA('3','5'),
		T_TIPO_DATA('3','6'),
		T_TIPO_DATA('3','7'),
		T_TIPO_DATA('3','8'),
		T_TIPO_DATA('3','9'),
		T_TIPO_DATA('3','10'),
		T_TIPO_DATA('3','11'),
		T_TIPO_DATA('3','12'),
		T_TIPO_DATA('3','13'),
		T_TIPO_DATA('3','14'),
		T_TIPO_DATA('3','15'),
		T_TIPO_DATA('3','16'),
		T_TIPO_DATA('3','17'),
		T_TIPO_DATA('3','18'),
		T_TIPO_DATA('3','19'),
		T_TIPO_DATA('3','20'),
		T_TIPO_DATA('3','21'),
		T_TIPO_DATA('3','22'),
		T_TIPO_DATA('3','23'),
		T_TIPO_DATA('3','24'),
		T_TIPO_DATA('3','25'),
		T_TIPO_DATA('3','26'),
		T_TIPO_DATA('3','27'),
		T_TIPO_DATA('3','28'),
		T_TIPO_DATA('3','29'),
		T_TIPO_DATA('3','30'),
		T_TIPO_DATA('3','31'),
		T_TIPO_DATA('3','32'),
		T_TIPO_DATA('3','33'),
		T_TIPO_DATA('3','34'),
		T_TIPO_DATA('3','35'),
		T_TIPO_DATA('3','36'),
		T_TIPO_DATA('3','37'),
		T_TIPO_DATA('3','38'),
		T_TIPO_DATA('3','39'),
		T_TIPO_DATA('3','40'),
		T_TIPO_DATA('3','41'),
		T_TIPO_DATA('3','42'),
		T_TIPO_DATA('3','43'),
		T_TIPO_DATA('3','44'),
		T_TIPO_DATA('3','45'),
		T_TIPO_DATA('3','46'),
		T_TIPO_DATA('3','47'),
		T_TIPO_DATA('3','48'),
		T_TIPO_DATA('3','49'),
		T_TIPO_DATA('3','50'),
		T_TIPO_DATA('3','51'),
		T_TIPO_DATA('3','52'),
		T_TIPO_DATA('8','1'),
		T_TIPO_DATA('8','2'),
		T_TIPO_DATA('8','3'),
		T_TIPO_DATA('8','4'),
		T_TIPO_DATA('8','5'),
		T_TIPO_DATA('8','6'),
		T_TIPO_DATA('8','7'),
		T_TIPO_DATA('8','8'),
		T_TIPO_DATA('8','9'),
		T_TIPO_DATA('8','10'),
		T_TIPO_DATA('8','11'),
		T_TIPO_DATA('8','12'),
		T_TIPO_DATA('8','13'),
		T_TIPO_DATA('8','14'),
		T_TIPO_DATA('8','15'),
		T_TIPO_DATA('8','16'),
		T_TIPO_DATA('8','17'),
		T_TIPO_DATA('8','18'),
		T_TIPO_DATA('8','19'),
		T_TIPO_DATA('8','20'),
		T_TIPO_DATA('8','21'),
		T_TIPO_DATA('8','22'),
		T_TIPO_DATA('8','23'),
		T_TIPO_DATA('8','24'),
		T_TIPO_DATA('8','25'),
		T_TIPO_DATA('8','26'),
		T_TIPO_DATA('8','27'),
		T_TIPO_DATA('8','28'),
		T_TIPO_DATA('8','29'),
		T_TIPO_DATA('8','30'),
		T_TIPO_DATA('8','31'),
		T_TIPO_DATA('8','32'),
		T_TIPO_DATA('8','33'),
		T_TIPO_DATA('8','34'),
		T_TIPO_DATA('8','35'),
		T_TIPO_DATA('8','36'),
		T_TIPO_DATA('8','37'),
		T_TIPO_DATA('8','38'),
		T_TIPO_DATA('8','39'),
		T_TIPO_DATA('8','40'),
		T_TIPO_DATA('8','41'),
		T_TIPO_DATA('8','42'),
		T_TIPO_DATA('8','43'),
		T_TIPO_DATA('8','44'),
		T_TIPO_DATA('8','45'),
		T_TIPO_DATA('8','46'),
		T_TIPO_DATA('8','47'),
		T_TIPO_DATA('8','48'),
		T_TIPO_DATA('8','49'),
		T_TIPO_DATA('8','50'),
		T_TIPO_DATA('8','51'),
		T_TIPO_DATA('8','52'),
		T_TIPO_DATA('16','1'),
		T_TIPO_DATA('16','2'),
		T_TIPO_DATA('16','3'),
		T_TIPO_DATA('16','4'),
		T_TIPO_DATA('16','5'),
		T_TIPO_DATA('16','6'),
		T_TIPO_DATA('16','7'),
		T_TIPO_DATA('16','8'),
		T_TIPO_DATA('16','9'),
		T_TIPO_DATA('16','10'),
		T_TIPO_DATA('16','11'),
		T_TIPO_DATA('16','12'),
		T_TIPO_DATA('16','13'),
		T_TIPO_DATA('16','14'),
		T_TIPO_DATA('16','15'),
		T_TIPO_DATA('16','16'),
		T_TIPO_DATA('16','17'),
		T_TIPO_DATA('16','18'),
		T_TIPO_DATA('16','19'),
		T_TIPO_DATA('16','20'),
		T_TIPO_DATA('16','21'),
		T_TIPO_DATA('16','22'),
		T_TIPO_DATA('16','23'),
		T_TIPO_DATA('16','24'),
		T_TIPO_DATA('16','25'),
		T_TIPO_DATA('16','26'),
		T_TIPO_DATA('16','27'),
		T_TIPO_DATA('16','28'),
		T_TIPO_DATA('16','29'),
		T_TIPO_DATA('16','30'),
		T_TIPO_DATA('16','31'),
		T_TIPO_DATA('16','32'),
		T_TIPO_DATA('16','33'),
		T_TIPO_DATA('16','34'),
		T_TIPO_DATA('16','35'),
		T_TIPO_DATA('16','36'),
		T_TIPO_DATA('16','37'),
		T_TIPO_DATA('16','38'),
		T_TIPO_DATA('16','39'),
		T_TIPO_DATA('16','40'),
		T_TIPO_DATA('16','41'),
		T_TIPO_DATA('16','42'),
		T_TIPO_DATA('16','43'),
		T_TIPO_DATA('16','44'),
		T_TIPO_DATA('16','45'),
		T_TIPO_DATA('16','46'),
		T_TIPO_DATA('16','47'),
		T_TIPO_DATA('16','48'),
		T_TIPO_DATA('16','49'),
		T_TIPO_DATA('16','50'),
		T_TIPO_DATA('16','51'),
		T_TIPO_DATA('16','52')

		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP
	V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		V_MSQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES WHERE TIPO_GESTOR = '''||V_TIPO_GESTOR||''' AND COD_CARTERA = '||V_TMP_TIPO_DATA(1)||' AND USERNAME = '''||V_USERNAME||''' AND COD_PROVINCIA = '||V_TMP_TIPO_DATA(2)||' AND COD_TIPO_COMERZIALZACION = 1';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

		IF V_COUNT = 0 THEN

			V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES (ID, TIPO_GESTOR, COD_CARTERA, COD_TIPO_COMERZIALZACION, COD_PROVINCIA, USERNAME,
						NOMBRE_USUARIO, USUARIOCREAR, FECHACREAR) VALUES (
							'||V_ESQUEMA||'.S_ACT_GES_DIST_GESTORES.NEXTVAL,
							'''||V_TIPO_GESTOR||''',
							'||V_TMP_TIPO_DATA(1)||',
							1,
							'||V_TMP_TIPO_DATA(2)||',
							'''||V_USERNAME||''',
							'''||V_NOMBRE_USUARIO||''',
							'''||V_USU||''',
							SYSDATE
						)';
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO]: CONFIGURACIÓN INSERTADA PARA CARTERA CON CÓDIGO '''||V_TMP_TIPO_DATA(1)||''' Y PROVINCIA '''||V_TMP_TIPO_DATA(2)||'''');

		ELSE

			DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE LA CONFIGURACIÓN DEL GESTOR');

		END IF;

	END LOOP;

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