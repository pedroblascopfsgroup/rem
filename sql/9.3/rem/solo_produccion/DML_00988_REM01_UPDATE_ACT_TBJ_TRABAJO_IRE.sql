--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210803
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10272
--## PRODUCTO=NO
--##
--## Finalidad: Script informa area peticionaria RAM trabajos
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
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'ACT_TBJ_TRABAJO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-10272'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		-- 		TBJ_NUM_TRABAJO  DD_IRE_CODIGO
		T_TIPO_DATA('916964378333','01'),
        T_TIPO_DATA('916964378866','01'),
        T_TIPO_DATA('916964378867','01'),
        T_TIPO_DATA('916964378870','01'),
        T_TIPO_DATA('916964378870','01'),
        T_TIPO_DATA('916964378305','01'),
        T_TIPO_DATA('916964378311','01'),
        T_TIPO_DATA('916964378316','01'),
        T_TIPO_DATA('916964378320','01'),
        T_TIPO_DATA('916964378324','01'),
        T_TIPO_DATA('916964378338','01'),
        T_TIPO_DATA('916964378812','01'),
        T_TIPO_DATA('916964378818','01'),
        T_TIPO_DATA('916964378822','01'),
        T_TIPO_DATA('916964378826','01'),
        T_TIPO_DATA('916964378839','01'),
        T_TIPO_DATA('916964378871','01'),
        T_TIPO_DATA('916964379105','01'),
        T_TIPO_DATA('916964378865','01'),
        T_TIPO_DATA('916964378830','01'),
        T_TIPO_DATA('916964378842','01'),
        T_TIPO_DATA('916964378864','01'),
        T_TIPO_DATA('916964379100','01'),
        T_TIPO_DATA('916964378310','01'),
        T_TIPO_DATA('916964378327','01'),
        T_TIPO_DATA('916964378332','01'),
        T_TIPO_DATA('916964378314','01')

	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR DD_IRE_ID EN '||V_TEXT_TABLA);

		V_MSQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TBJ_NUM_TRABAJO = '||V_TMP_TIPO_DATA(1)||' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

		IF V_COUNT = 1 THEN

			V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET
						DD_IRE_ID = (SELECT DD_IRE_ID FROM '||V_ESQUEMA||'.DD_IRE_IDENTIFICADOR_REAM WHERE DD_IRE_CODIGO = '||V_TMP_TIPO_DATA(2)||' ) ,
						USUARIOMODIFICAR = '''||V_USU||''',
						FECHAMODIFICAR = SYSDATE
						WHERE TBJ_NUM_TRABAJO = '||V_TMP_TIPO_DATA(1)||' AND BORRADO = 0';
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS DD_IRE_ID = '||V_TMP_TIPO_DATA(2)||' EN TRABAJO '||V_TMP_TIPO_DATA(1)||'');

		ELSE

			DBMS_OUTPUT.PUT_LINE('[INFO]: TRABAJO '||V_TMP_TIPO_DATA(1)||' NO EXISTE O ESTA BORRADO');

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