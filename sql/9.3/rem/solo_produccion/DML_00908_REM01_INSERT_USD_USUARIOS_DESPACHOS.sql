--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210611
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9923
--## PRODUCTO=NO
--##
--## Finalidad: Script añade usuario despacho
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
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-9923'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
	V_USU_ID NUMBER(16);
	V_TDE_ID NUMBER(16);

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
			T_TIPO_DATA('jsanchezv', 'SCOM'),
			T_TIPO_DATA('jsanchezv', 'GPM')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP
	V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		V_MSQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_TIPO_DATA(1)||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

		IF V_COUNT = 1 THEN

			V_MSQL:= 'SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_TIPO_DATA(1)||'''';
			EXECUTE IMMEDIATE V_MSQL INTO V_USU_ID;

			V_MSQL:= 'SELECT DD_TDE_ID FROM '||V_ESQUEMA_M||'.DD_TDE_TIPO_DESPACHO WHERE DD_TDE_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''';
			EXECUTE IMMEDIATE V_MSQL INTO V_TDE_ID;

			V_MSQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS WHERE USU_ID = '||V_USU_ID||' 
			AND DES_ID = (SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DD_TDE_ID = '||V_TDE_ID||')';
			EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

			IF V_COUNT = 0 THEN

				V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS (USD_ID, USU_ID, DES_ID, USD_GESTOR_DEFECTO, USD_SUPERVISOR, USUARIOCREAR, FECHACREAR) VALUES (
					'||V_ESQUEMA||'.S_USD_USUARIOS_DESPACHOS.NEXTVAL,
					'||V_USU_ID||',
					(SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DD_TDE_ID = '||V_TDE_ID||'),
					1,
					1,
					'''||V_USU||''',
					SYSDATE
				)';
				EXECUTE IMMEDIATE V_MSQL;

				DBMS_OUTPUT.PUT_LINE('[INFO]: USUARIO DESPACHO INSERTADO PARA : '''||V_TMP_TIPO_DATA(1)||''' EN TIPO '''||V_TMP_TIPO_DATA(1)||'''');

			ELSE

				DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE USUARIO DESPACHO PARA '''||V_TMP_TIPO_DATA(1)||''' Y TIPO '''||V_TMP_TIPO_DATA(2)||'''');

			END IF;

		ELSE

			DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL USUARIO '''||V_TMP_TIPO_DATA(1)||'''');

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