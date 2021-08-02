--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210702
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
		T_TIPO_DATA('2'),
		T_TIPO_DATA('3')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP
	V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		V_MSQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES WHERE TIPO_GESTOR = '''||V_TIPO_GESTOR||''' AND COD_CARTERA = '||V_TMP_TIPO_DATA(1)||' AND USERNAME = '''||V_USERNAME||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

		IF V_COUNT = 0 THEN

			V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES SET
					USERNAME = '''||V_USERNAME||''',
					NOMBRE_USUARIO = '''||V_NOMBRE_USUARIO||''',
					USUARIOMODIFICAR = '''||V_USU||''',
					FECHAMODIFICAR = SYSDATE
					WHERE TIPO_GESTOR = '''||V_TIPO_GESTOR||''' AND COD_CARTERA = '||V_TMP_TIPO_DATA(1)||'';
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO]: CONFIGURACIÓN ACTUALIZADA PARA CARTERA CON CÓDIGO '''||V_TMP_TIPO_DATA(1)||'''');

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